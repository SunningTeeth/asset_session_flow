package com.lanysec.services;

import com.alibaba.fastjson.JSON;
import com.lanysec.config.JavaKafkaConfigurer;
import com.lanysec.config.ModelParamsConfigurer;
import com.lanysec.entity.FlowEntity;
import com.lanysec.entity.FlowParserEntity;
import com.lanysec.utils.ConversionUtil;
import com.lanysec.utils.DbConnectUtil;
import com.lanysec.utils.StringUtil;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.streaming.api.functions.timestamps.BoundedOutOfOrdernessTimestampExtractor;
import org.apache.flink.streaming.api.TimeCharacteristic;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.ProcessFunction;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer010;
import org.apache.flink.table.api.EnvironmentSettings;
import org.apache.flink.table.api.Table;
import org.apache.flink.table.api.java.StreamTableEnvironment;
import org.apache.flink.table.functions.ScalarFunction;
import org.apache.flink.util.Collector;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

/**
 * @author daijb
 * @date 2021/3/8 16:27
 * 资产会话访问流量模型
 */
public class AssetSessionVisitFlow implements AssetBehaviorConstants {

    private static final Logger logger = LoggerFactory.getLogger(AssetSessionVisitFlow.class);

    public static void main(String[] args) {
        AssetSessionVisitFlow assetSessionVisitFlow = new AssetSessionVisitFlow();
        // 启动任务
        assetSessionVisitFlow.run(args);
    }

    public void run(String[] args) {
        logger.info("flink streaming is starting....");

        // 启动定时任务
        startFunc();

        // 更新状态
        //TODO 临时注释
        updateModelTaskStatus(ModelStatus.RUNNING);

        StreamExecutionEnvironment streamExecutionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment();

        streamExecutionEnvironment.setStreamTimeCharacteristic(TimeCharacteristic.EventTime);

        EnvironmentSettings fsSettings = EnvironmentSettings.newInstance().useOldPlanner().inStreamingMode().build();
        //创建 TableEnvironment
        StreamTableEnvironment streamTableEnvironment = StreamTableEnvironment.create(streamExecutionEnvironment, fsSettings);

        //加载kafka配置信息
        Properties kafkaProperties = JavaKafkaConfigurer.getKafkaProperties(args);
        logger.info("load kafka properties : " + kafkaProperties.toString());
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaProperties.getProperty("bootstrap.servers"));
        //可根据实际拉取数据等设置此值，默认30s
        props.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, 30000);
        //每次poll的最大数量
        //注意该值不要改得太大，如果poll太多数据，而不能在下次poll之前消费完，则会触发一次负载均衡，产生卡顿
        props.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 30);
        //当前消费实例所属的消费组
        //属于同一个组的消费实例，会负载消费消息
        props.put(ConsumerConfig.GROUP_ID_CONFIG, kafkaProperties.getProperty("group.id"));

        // 添加kafka source
        // 过滤kafka无匹配资产的数据
        DataStream<String> kafkaSource = streamExecutionEnvironment.addSource(new FlinkKafkaConsumer010<>(kafkaProperties.getProperty("topic"), new SimpleStringSchema(), props));

        DataStream<String> kafkaSourceFilter = kafkaSource.filter((FilterFunction<String>) value -> {
            JSONObject line = (JSONObject) JSONValue.parse(value);
            return !StringUtil.isEmpty(ConversionUtil.toString(line.get("SrcID")));
        });

        // 添加需要匹配的字段
        DataStream<String> matchAssetSourceStream = kafkaSourceFilter.map(new AssetMapSourceFunction())
                .filter((FilterFunction<String>) value -> !StringUtil.isEmpty(value));

        //建模系列操作
        {
            //建模entity
            DataStream<FlowEntity> kafkaProcessStream = matchAssetSourceStream.process(new ParserKafkaProcessFunction())
                    // TODO 添加水位线 必须加否则无法group by
                    .assignTimestampsAndWatermarks(new BrowseBoundedOutOfOrderTimestampExtractor(Time.seconds(5)));

            // 注册kafka关联表
            streamTableEnvironment.createTemporaryView("kafka_asset_flow_source", kafkaProcessStream, "srcId,srcIp,srcPort,areaId,l4p,outFlow,inFlow,rowtime.rowtime");

            //4、注册UDF
            //日期转换函数: 将Flink Window Start/End Timestamp转换为指定时区时间(默认转换为北京时间)
            streamTableEnvironment.registerFunction("UDFTimestampConverter", new UDFTimestampConverter());

            // 运行sql
            //String intervalTime = "'1' DAY";
            String intervalTime = "'1' MINUTE";
            String sql = "select srcIp,srcId,areaId,l4p as protocol,outFlow,inFlow,count(1) as totalCount," +
                    "UDFTimestampConverter(TUMBLE_END(rowtime, INTERVAL " + intervalTime + " ),'YYYY-MM-dd','+08:00') as cntDate " +
                    "from kafka_asset_flow_source " +
                    "group by areaId,srcId,srcIp,l4p,outFlow,inFlow,TUMBLE(rowtime, INTERVAL " + intervalTime + ")";

            // 获取结果
            Table assetSessionFlowTable = streamTableEnvironment.sqlQuery(sql);

            DataStream<FlowParserEntity> flowSinkEntityDataStream = streamTableEnvironment.toAppendStream(assetSessionFlowTable, FlowParserEntity.class);

             /*student.timeWindowAll(Time.minutes(1)).apply(new AllWindowFunction<Student, List<Student>, TimeWindow>() {
                @Override
                public void apply(TimeWindow window, Iterable<Student> values, Collector<List<Student>> out) throws Exception {
                    ArrayList<Student> students = Lists.newArrayList(values);
                    if (students.size() > 0) {
                        System.out.println("1 分钟内收集到 student 的数据条数是：" + students.size());
                        out.collect(students);
                    }
                }
            });*/

            // sink
            flowSinkEntityDataStream.addSink(new SessionFlowSink());
        }

        try {
            streamExecutionEnvironment.execute("kafka message streaming start ....");
        } catch (Exception e) {
            logger.error("flink streaming execute failed", e);
            // 更新状态
            updateModelTaskStatus(ModelStatus.STOP);
        }
    }

    /**
     * 更新建模状态
     *
     * @param modelStatus 状态枚举
     */
    private void updateModelTaskStatus(ModelStatus modelStatus) {
        Object modelId = ModelParamsConfigurer.getModelingParams().get(MODEL_ID);
        String updateSql = "UPDATE `modeling_params` SET `model_task_status`=?, `modify_time`=? " +
                " WHERE (`id`='" + modelId + "');";
        DbConnectUtil.execUpdateTask(updateSql, modelStatus.toString().toLowerCase(), LocalDateTime.now().toString());
        logger.info("[kafkaMessageStreaming] update model task status : " + modelStatus.name());
    }

    private void startFunc() {
        logger.info("starting build model params.....");
        new Timer("timer-model").schedule(new TimerTask() {
            @Override
            public void run() {
                try {
                    ModelParamsConfigurer.reloadModelingParams();
                    logger.info("reload model params configurer.");
                } catch (Throwable throwable) {
                    logger.error("timer schedule at fixed rate failed ", throwable);
                }
            }
        }, 1000 * 10, 1000 * 60 * 5);

        new Timer("timer-model").schedule(new TimerTask() {
            @Override
            public void run() {
                try {
                    ModelParamsConfigurer.queryLastBuildModelResult();
                    logger.info("reload build model result.");
                } catch (Throwable throwable) {
                    logger.error("timer schedule at fixed rate failed ", throwable);
                }
            }
        }, 1000 * 60 * 5, 1000 * 60 * 30);
    }

    /**
     * 解析kafka flow 建模数据
     */
    private static class ParserKafkaProcessFunction extends ProcessFunction<String, FlowEntity> {

        @Override
        public void processElement(String value, Context ctx, Collector<FlowEntity> out) throws Exception {
            FlowEntity flowEntity = JSON.parseObject(value, FlowEntity.class);
            //输出到主流
            out.collect(flowEntity);
        }
    }

    /**
     * 自定义UDF
     */
    public static class UDFTimestampConverter extends ScalarFunction {

        /**
         * 默认转换为北京时间
         *
         * @param timestamp Flink Timestamp 格式时间
         * @param format    目标格式,如"YYYY-MM-dd HH:mm:ss"
         * @return 目标时区的时间
         */
        public String eval(Timestamp timestamp, String format) {

            LocalDateTime noZoneDateTime = timestamp.toLocalDateTime();
            ZonedDateTime utcZoneDateTime = ZonedDateTime.of(noZoneDateTime, ZoneId.of("UTC"));

            ZonedDateTime targetZoneDateTime = utcZoneDateTime.withZoneSameInstant(ZoneId.of("+08:00"));

            return targetZoneDateTime.format(DateTimeFormatter.ofPattern(format));
        }

        /**
         * 转换为指定时区时间
         *
         * @param timestamp  Flink Timestamp 格式时间
         * @param format     目标格式,如"YYYY-MM-dd HH:mm:ss"
         * @param zoneOffset 目标时区偏移量
         * @return 目标时区的时间
         */
        public String eval(Timestamp timestamp, String format, String zoneOffset) {

            LocalDateTime noZoneDateTime = timestamp.toLocalDateTime();
            ZonedDateTime utcZoneDateTime = ZonedDateTime.of(noZoneDateTime, ZoneId.of("UTC"));

            ZonedDateTime targetZoneDateTime = utcZoneDateTime.withZoneSameInstant(ZoneId.of(zoneOffset));

            return targetZoneDateTime.format(DateTimeFormatter.ofPattern(format));
        }
    }

    /**
     * 提取时间戳生成水印
     */
    public static class BrowseBoundedOutOfOrderTimestampExtractor extends BoundedOutOfOrdernessTimestampExtractor<FlowEntity> {

        BrowseBoundedOutOfOrderTimestampExtractor(org.apache.flink.streaming.api.windowing.time.Time maxOutOfOrder) {
            super(maxOutOfOrder);
        }

        @Override
        public long extractTimestamp(FlowEntity element) {
            return element.getrTime();
        }
    }

}

