package com.lanysec.services;

import com.alibaba.fastjson.JSON;
import com.lanysec.config.JavaKafkaConfigurer;
import com.lanysec.config.ModelParamsConfigurer;
import com.lanysec.entity.FlowEntity;
import com.lanysec.entity.FlowParserEntity;
import com.lanysec.entity.FlowStaticEntity;
import com.lanysec.utils.ConversionUtil;
import com.lanysec.utils.DbConnectUtil;
import com.lanysec.utils.StringUtil;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
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
import org.apache.flink.util.OutputTag;
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
 * 参数设置参考如下:
 * --mysql.servers 192.168.3.101
 * --bootstrap.servers 192.168.3.101:6667
 * --topic csp_flow //消费
 * --check.topic csp_event // 建模结果发送的topic
 * --group.id test
 * --interval 1m
 */
public class AssetSessionVisitFlow implements AssetSessionVisitConstants {

    private static final Logger logger = LoggerFactory.getLogger(AssetSessionVisitFlow.class);

    public static void main(String[] args) {
        AssetSessionVisitFlow assetSessionVisitFlow = new AssetSessionVisitFlow();
        // 启动任务
        assetSessionVisitFlow.run(args);
    }

    public void run(String[] args) {
        logger.info("flink streaming is starting....");
        StringBuilder text = new StringBuilder(128);
        for (String s : args) {
            text.append(s).append("\t");
        }
        logger.info("all params : " + text.toString());
        Properties properties = JavaKafkaConfigurer.getKafkaProperties(args);
        System.setProperty("mysql.servers", properties.getProperty("mysql.servers"));
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
        logger.info("load kafka properties : " + properties.toString());
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, properties.getProperty("bootstrap.servers"));
        //可根据实际拉取数据等设置此值，默认30s
        props.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, 30000);
        //每次poll的最大数量
        //注意该值不要改得太大，如果poll太多数据，而不能在下次poll之前消费完，则会触发一次负载均衡，产生卡顿
        props.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 30);
        //当前消费实例所属的消费组
        //属于同一个组的消费实例，会负载消费消息
        props.put(ConsumerConfig.GROUP_ID_CONFIG, properties.getProperty("group.id"));

        int intervalOriginal = ConversionUtil.str2Minutes(ConversionUtil.toString(properties.get("interval")));

        // 添加kafka source
        // 过滤kafka无匹配资产的数据
        DataStream<String> kafkaSource = streamExecutionEnvironment.addSource(new FlinkKafkaConsumer010<>(properties.getProperty("topic"), new SimpleStringSchema(), props));

        DataStream<String> kafkaSourceFilter = kafkaSource.filter((FilterFunction<String>) value -> {
            JSONObject line = (JSONObject) JSONValue.parse(value);
            if (!StringUtil.isEmpty(ConversionUtil.toString(line.get("SrcID")))) {
                return true;
            }
            if (StringUtil.isEmpty(ConversionUtil.toString(line.get("DstID")))) {
                return false;
            }
            return false;
        });

        // 添加需要匹配的字段
        DataStream<String> matchAssetSourceStream = kafkaSourceFilter.map(new AssetMapSourceFunction())
                .filter((FilterFunction<String>) value -> !StringUtil.isEmpty(value));

        //建模系列操作

        //定义一个tag,来收集
        OutputTag<FlowEntity> outputTag = new OutputTag<>("side-output", TypeInformation.of(FlowEntity.class));
        //建模entity
        DataStream<FlowEntity> kafkaProcessStream = matchAssetSourceStream.process(new ParserKafkaProcessFunction());
        // 分流
        SingleOutputStreamOperator<FlowEntity> flowProcessSplitStream = kafkaProcessStream.process(new ProcessFunction<FlowEntity, FlowEntity>() {
            @Override
            public void processElement(FlowEntity value, Context ctx, Collector<FlowEntity> out) throws Exception {
                //这句代码的含义是把数据发送到常规的流中，也就是mainDataStream中去，发送的数据是全量的数据
                //如果不需要全量的数据，可以不进行发送，那么mainDataStream中也就没有数据
                //上行流量
                out.collect(value);
                //输出到旁路流 下行流量
                ctx.output(outputTag, value);
            }
        });

        // TODO 添加水位线 必须加否则无法group by
        //下行流量
        SingleOutputStreamOperator<FlowEntity> inFlowProcessStream = flowProcessSplitStream.assignTimestampsAndWatermarks(new BrowseBoundedOutOfOrderTimestampExtractor(Time.seconds(5)));

        // 上行流量
        SingleOutputStreamOperator<FlowEntity> outFlowProcessStream = flowProcessSplitStream.getSideOutput(outputTag).assignTimestampsAndWatermarks(new BrowseBoundedOutOfOrderTimestampExtractor(Time.seconds(5)));

        // 注册kafka关联表
        streamTableEnvironment.createTemporaryView("kafka_asset_in_flow", inFlowProcessStream, "srcId,srcIp,srcPort,areaId,l4p,inFlow,rowtime.rowtime");
        streamTableEnvironment.createTemporaryView("kafka_asset_out_flow", outFlowProcessStream, "srcId,srcIp,srcPort,areaId,l4p,outFlow,rowtime.rowtime");

        //4、注册UDF
        //日期转换函数: 将Flink Window Start/End Timestamp转换为指定时区时间(默认转换为北京时间)
        streamTableEnvironment.registerFunction("UDFTimestampConverter", new UDFTimestampConverter());

        // 运行sql
        String intervalTime1 = "'" + intervalOriginal + "' MINUTE";
        // 第一个算子计算样本总量(求样本均值)
        String inFlowSql = "select srcIp,srcId,areaId,l4p as protocol,sum(inFlow) as flowSize,count(1) as totalCount," +
                "UDFTimestampConverter(TUMBLE_END(rowtime, INTERVAL " + intervalTime1 + " ),'YYYY-MM-dd','+08:00') as cntDate " +
                "from kafka_asset_in_flow " +
                "group by areaId,srcId,srcIp,l4p,TUMBLE(rowtime, INTERVAL " + intervalTime1 + ")";

        String outFlowSql = "select srcIp,srcId,areaId,l4p as protocol,sum(outFlow) as flowSize,count(1) as totalCount," +
                "UDFTimestampConverter(TUMBLE_END(rowtime, INTERVAL " + intervalTime1 + " ),'YYYY-MM-dd','+08:00') as cntDate " +
                "from kafka_asset_out_flow " +
                "group by areaId,srcId,srcIp,l4p,TUMBLE(rowtime, INTERVAL " + intervalTime1 + ")";

        // 获取结果
        Table inFlowTable = streamTableEnvironment.sqlQuery(inFlowSql);
        Table outFlowTable = streamTableEnvironment.sqlQuery(outFlowSql);

        DataStream<FlowParserEntity> inFlowSinkEntityDataStream = streamTableEnvironment.toAppendStream(inFlowTable, FlowParserEntity.class);
        DataStream<FlowParserEntity> outFlowSinkEntityDataStream = streamTableEnvironment.toAppendStream(outFlowTable, FlowParserEntity.class);


        // 注册kafka关联表
        streamTableEnvironment.createTemporaryView("calculate_in_flow", inFlowSinkEntityDataStream, "srcId,srcIp,protocol,areaId,flowSize,totalCount,rowtime.rowtime");
        streamTableEnvironment.createTemporaryView("calculate_out_flow", outFlowSinkEntityDataStream, "srcId,srcIp,protocol,areaId,flowSize,totalCount,rowtime.rowtime");

        // 第二个算子计算样本方差
        String intervalTime2 = "'" + intervalOriginal * 5 + "' MINUTE";
        String inFlowCalculate = "select srcId,srcIp,areaId,protocol," +
                "UDFTimestampConverter(TUMBLE_END(rowtime, INTERVAL " + intervalTime2 + "),'YYYY-MM-dd','+08:00') as cDate," +
                "((sum(flowSize)/sum(totalCount))+1.96*STDDEV_POP(flowSize)/SQRT(sum(totalCount))) as maxFlowSize," +
                "((sum(flowSize)/sum(totalCount))-1.96*STDDEV_POP(flowSize)/SQRT(sum(totalCount))) as minFlowSize " +
                " from calculate_in_flow " +
                " group by srcId,srcIp,areaId,protocol,TUMBLE(rowtime, INTERVAL " + intervalTime2 + ")";

        String outFlowCalculate = "select srcId,srcIp,areaId,protocol," +
                "UDFTimestampConverter(TUMBLE_END(rowtime, INTERVAL " + intervalTime2 + "),'YYYY-MM-dd','+08:00') as cDate," +
                "((sum(flowSize)/sum(totalCount))+1.96*STDDEV_POP(flowSize)/SQRT(sum(totalCount))) as maxFlowSize," +
                "((sum(flowSize)/sum(totalCount))-1.96*STDDEV_POP(flowSize)/SQRT(sum(totalCount))) as minFlowSize " +
                " from calculate_in_flow " +
                " group by srcId,srcIp,areaId,protocol,TUMBLE(rowtime, INTERVAL " + intervalTime2 + ")";

        Table inFlowCalculateTable = streamTableEnvironment.sqlQuery(inFlowCalculate);
        Table outFlowCalculateTable = streamTableEnvironment.sqlQuery(outFlowCalculate);

        DataStream<JSONObject> inFlowStaticStream = streamTableEnvironment.toAppendStream(inFlowCalculateTable, FlowStaticEntity.class)
                .map((MapFunction<FlowStaticEntity, JSONObject>) value -> {
                    JSONObject json = value.toJSONObject();
                    //0 下行流量 in ;1 上行流量 out'
                    json.put("flowType", 0);
                    return json;
                });

        DataStream<JSONObject> outFlowStaticStream = streamTableEnvironment.toAppendStream(outFlowCalculateTable, FlowStaticEntity.class)
                .map((MapFunction<FlowStaticEntity, JSONObject>) value -> {
                    JSONObject json = value.toJSONObject();
                    //0 下行流量 in ;1 上行流量 out'
                    json.put("flowType", 1);
                    return json;
                });

        // sink
        inFlowStaticStream.addSink(new SessionFlowSink());
        outFlowStaticStream.addSink(new SessionFlowSink());


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

