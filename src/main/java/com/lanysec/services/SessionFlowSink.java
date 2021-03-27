package com.lanysec.services;

import com.lanysec.config.ModelParamsConfigurer;
import com.lanysec.utils.*;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.functions.sink.RichSinkFunction;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * @author daijb
 * @date 2021/3/8 22:41
 * DROP TABLE IF EXISTS `model_result_asset_session_flow`;
 * CREATE TABLE `model_result_asset_session_flow`
 * (
 * `id`                 varchar(32)  NOT NULL COMMENT 'ID',
 * `modeling_params_id` varchar(64)  NOT NULL COMMENT '模型参数ID。根据模型参数ID可以知道建模的类型及子类型',
 * `src_id`             varchar(100) NOT NULL COMMENT '源资产ID',
 * `src_ip`             text COMMENT '资产源IP',
 * `protocol`           varchar(255) NOT NULL COMMENT '通信协议',
 * `flow`               text COMMENT '流量大小置信区间统计。json格式，key 从1开始到 （模型结果时长/频率）例，一周每天的访问模型 结果为[  {"name": "1",\r\n  "value": "0-9"},\r\n  {"name": "2",\r\n  "value": "1-56"},\r\n  {"name": "3",\r\n  "value": "2-3"},\r\n  {"name": "4",\r\n  "value": "4-9"},\r\n  {"name": "5",\r\n  "value": "76-908"}\r\n]。value用英文"-"连接最低和最高值。\r\n最低和最高，用样本数量，求出样本方差。根据用户输入的置信度，根据标准正态分布表求出置信区间。',
 * `up_down`            int(11)  DEFAULT NULL COMMENT '上下行区分。0 下行流量 in ;1 上行流量 out',
 * `in_out`             int(11)  DEFAULT NULL COMMENT '内外网区分。目的IP在内网网段（10.0.0.0-10.255.255.255；172.16.0.0-172.31.255.255；192.168.0.0-192.168.255.255）0 。其他外网 1',
 * `time`               datetime DEFAULT NULL COMMENT '数据插入时间',
 * PRIMARY KEY (`src_id`, `protocol`, `modeling_params_id`)
 * ) ENGINE = InnoDB
 * DEFAULT CHARSET = utf8;
 */
public class SessionFlowSink extends RichSinkFunction<JSONObject> {

    private static final Logger logger = LoggerFactory.getLogger(SessionFlowSink.class);

    private PreparedStatement ps;

    private Connection connection;

    private volatile ServiceState state = ServiceState.Starting;

    private volatile boolean isFirst = true;

    private final AtomicInteger batchSize = new AtomicInteger();

    private final int MAX_BATCH_SIZE = 200;

    /**
     * 记录历史数据天数
     */
    private volatile int historyDataDays = 1;

    /**
     * 程序最多执行时间
     */
    private volatile Date futureDate;

    private final Lock modelTaskStatusLock = new ReentrantLock();

    private volatile Map<String, Object> modelingParams = ModelParamsConfigurer.getModelingParams();

    @Override
    public void open(Configuration parameters) throws Exception {
        super.open(parameters);
        String sql = "INSERT INTO `model_result_asset_session_flow` (`id`, `modeling_params_id`, `src_id`, `src_ip`, `protocol`, `flow`, `up_down`, `in_out`, `time`)" +
                " values (?,?,?,?,?,?,?,?,?) " +
                "ON DUPLICATE KEY UPDATE `flow`=?";
        connection = DbConnectUtil.getConnection();
        ps = connection.prepareStatement(sql);
    }

    @Override
    public void invoke(JSONObject value, Context context) throws Exception {
        logger.info("--冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭冲鸭");
        checkModelInfo();
        checkState();
        if (state != ServiceState.Ready) {
            logger.warn("build modeling is stopped...");
            return;
        }
        // 判断是否超出存储数据天数
        if (!isFirst && !canSink()) {
            logger.warn("more than save data days");
            return;
        }

        String modelId = ConversionUtil.toString(ModelParamsConfigurer.getModelingParams().get("modelId"));
        String srcId = ConversionUtil.toString(value.get("srcId"));
        String protocol = ConversionUtil.toString(value.get("protocol"));
        String srcIp = ConversionUtil.toString(value.get("srcIp"));
        List<Map<String, Object>> lastBuildModelResult = ModelParamsConfigurer.getLastBuildModelResult();
        String key = ConversionUtil.toString(calculateSegmentCurrKey());
        JSONArray segment = null;
        for (Map<String, Object> item : lastBuildModelResult) {
            String srcId0 = ConversionUtil.toString(item.get("srcId"));
            String protocol0 = ConversionUtil.toString(item.get("protocol"));
            if (StringUtil.equals(srcId, srcId0) && StringUtil.equals(protocol, protocol0)) {
                Object segmentObj = item.get("segmentArr");
                if (segmentObj != null && !StringUtil.isEmpty(segmentObj.toString())) {
                    segment = (JSONArray) JSONValue.parse(segmentObj.toString());
                    break;
                }
            }
        }
        JSONObject json = new JSONObject();
        double minFlowSize = ConversionUtil.toDouble(value.get("minFlowSize"));
        if (minFlowSize < 0) {
            minFlowSize = 0;
        } else {
            minFlowSize = ConversionUtil.toDouble((minFlowSize / 1024));
        }
        String calculateValue = minFlowSize + "-" + ConversionUtil.toDouble((ConversionUtil.toDouble(value.get("maxFlowSize")) / 1024));
        json.put("name", key);
        json.put("value", calculateValue);
        if (segment != null) {
            for (Object o : segment) {
                JSONObject obj = (JSONObject) o;
                String name = ConversionUtil.toString(obj.get("name"));
                if (StringUtil.equals(name, key)) {
                    obj.put("value", calculateValue);
                    break;
                }
            }
        } else {
            segment = new JSONArray();
            segment.add(json);
        }
        ps.setString(1, "msf_" + UUIDUtil.genId());
        ps.setString(2, modelId);
        ps.setString(3, srcId);
        ps.setString(4, srcIp);
        ps.setString(5, protocol);
        ps.setString(6, segment.toJSONString());
        //0 下行流量 in ;1 上行流量 out'
        ps.setInt(7, ConversionUtil.toInt(value.get("flowType")));
        ps.setInt(8, SystemUtil.isInternalIp(srcIp));
        ps.setString(9, LocalDateTime.now().toString());
        ps.setString(10, segment.toJSONString());
        ps.addBatch();
        batchSize.incrementAndGet();
        if (batchSize.get() > MAX_BATCH_SIZE) {
            ps.executeBatch();
            batchSize.set(0);
        }

        if (isFirst) {
            isFirst = false;
            //updateModelTaskStatus(AssetBehaviorConstants.ModelStatus.SUCCESS);
            //记录运行天数
            //updateModelHistoryDataDays();

            Calendar calendar = Calendar.getInstance();
            calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) + this.historyDataDays);
            this.futureDate = calendar.getTime();
        }

    }

    @Override
    public void close() throws Exception {
        super.close();
        if (connection != null) {
            connection.close();
        }
        if (ps != null) {
            ps.close();
        }
    }

    /**
     * 建模结果周期：1 代表一天。
     * 2 代表一周。3 代表一季度。
     * 4 代表一年。如果总长度填写 1 ，建模的时间单位可以是 ss mm hh 。周的建模时间单位只能是 dd 。其他的只能为月
     * 计算模型的key
     * <pre>
     *   1. 建模周期为天 ：
     *       SegmentKey : 每次从当前日期开始计算,以小时为key
     *   2. 建模周期为周：建模时间单位只能是天）
     *       SegmentKey : 每次从当前日期开始计算,以当前周几为key
     *   3. 建模周期为季度：（建模时间单位只能是月）
     *      SegmentKey : 每次从当前日期开始计算,以当前月份开始递增
     *   4. 建模周期为年：（建模时间单位只能是月）
     *      SegmentKey : 每次从当前日期开始计算,以当前月份开始递增
     *
     * </pre>
     */
    private Object calculateSegmentCurrKey() throws Exception {
        // 建模周期
        int cycle = ConversionUtil.toInteger(ModelParamsConfigurer.getModelingParams().get(AssetSessionVisitConstants.MODEL_RESULT_SPAN));
        LocalDateTime now = LocalDateTime.now();
        Object segmentKey = null;
        switch (cycle) {
            // 暂时默认为小时
            case 1: {
                segmentKey = now.getHour();
                break;
            }
            //周,频率只能是 dd
            case 2: {
                segmentKey = now.getDayOfWeek().getValue();
                break;
            }
            //季度,频率只能是月
            case 3:
            case 4: {
                // 年,频率只能是月
                segmentKey = now.getMonth().getValue();
                break;
            }
            default: {
                throw new Exception("modeling span is not support.");
            }
        }
        return segmentKey;
    }

    /**
     * 更新建模状态
     *
     * @param modelStatus 状态枚举
     */
    private void updateModelTaskStatus(AssetSessionVisitConstants.ModelStatus modelStatus) {
        while (!modelTaskStatusLock.tryLock()) {
        }
        try {
            String updateSql = "UPDATE `modeling_params` SET `model_task_status`=?, `modify_time`=? WHERE (`id`='" + modelingParams.get(AssetSessionVisitConstants.MODEL_ID) + "');";
            PreparedStatement ps = connection.prepareStatement(updateSql);
            ps.setString(1, modelStatus.toString().toLowerCase());
            ps.setString(2, LocalDateTime.now().toString());
            ps.execute();
            logger.info("update model task status : " + modelStatus.name());
        } catch (Throwable t) {
        } finally {
            modelTaskStatusLock.unlock();
        }
    }

    /**
     * 更新模型建模数据存储历史天数
     */
    private void updateModelHistoryDataDays() {
        String sql = "INSERT INTO `config` (`keyword`, `vals`, `opts`, `types`, `name`, `notes`, `gid`, `sys`, `sort`) VALUES " +
                "('ASSET_BEHAVIOR_CONNECTION', ?, '', 'int', '资产行为连接关系记录存储数据天数', '', '0', '1', '50') " +
                "ON DUPLICATE KEY UPDATE `vals`=?";

        int day = this.historyDataDays;
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, day + "");
            preparedStatement.setString(2, day + "");
            if (preparedStatement.execute()) {
                logger.info("update model history data days : " + day);
            }
        } catch (Throwable throwable) {
            logger.error("update model history data days : " + day + " failed.", throwable);
        }

    }

    /**
     * 检查模型各种信息
     */
    private void checkModelInfo() {
        Map<String, Object> newModelingParams = ModelParamsConfigurer.getModelingParams();
        if (newModelingParams.isEmpty()) {
            state = ServiceState.Stopped;
            return;
        }

        //建模维度变化
        boolean modelParamsChange = modelParamsChange(newModelingParams);
        if (modelParamsChange) {
            // 说明此时出现：同一个模型 多个不同的维度(设计要求，同一个模型只能有一个维度生效)
            state = ServiceState.Stopped;
            updateModelTaskStatus(AssetSessionVisitConstants.ModelStatus.STOP);
            //更新建模参数
            ModelParamsConfigurer.reloadModelingParams();
            this.modelingParams = ModelParamsConfigurer.getModelingParams();
            return;
        }

        boolean updateChange = modelUpdateChange(newModelingParams);
        if (updateChange) {
            // 更新方式发生变化
            // 模型的更新方式:
            // 0(false)清除历史数据更新
            // 1(true)累计迭代历史数据更新。
            // 模型结果的唯一性:模型分类 & 模型子类 & 频率 & 频数
            // 更改 历史数据和置信度 更新。
            boolean modelUpdate = ConversionUtil.toBoolean(newModelingParams.get(AssetSessionVisitConstants.MODEL_UPDATE));
            if (!modelUpdate) {
                // 清除历史数据更新
                if (connection == null) {
                    connection = DbConnectUtil.getConnection();
                }
                String deleteSql = "DELETE FROM model_result_asset_behavior_relation WHERE modeling_params_id ='"
                        + newModelingParams.get(AssetSessionVisitConstants.MODEL_ID).toString() + "';";
                try {
                    boolean result = connection.createStatement().execute(deleteSql);
                } catch (SQLException sqlException) {
                    updateModelTaskStatus(AssetSessionVisitConstants.ModelStatus.FAILED);
                    logger.error("exec clear history data failed.", sqlException);
                }
            }
        }

        // 建模数据存储历史天数
        boolean modelHistoryDataDaysChange = checkModelHistoryDataDays(newModelingParams);
        if (modelHistoryDataDaysChange) {
            updateModelHistoryDataDays();
        }
        this.modelingParams = newModelingParams;
    }

    /**
     * 检查模型开关
     */
    private void checkState() {
        if (this.modelingParams.isEmpty()) {
            this.modelingParams = ModelParamsConfigurer.getModelingParams();
            state = ServiceState.Stopped;
            // 更新状态
            updateModelTaskStatus(AssetSessionVisitConstants.ModelStatus.FAILED);
            return;
        }
        if (ConversionUtil.toBoolean(this.modelingParams.get(AssetSessionVisitConstants.MODEL_SWITCH))) {
            state = ServiceState.Ready;
        } else {
            state = ServiceState.Stopped;
            // 更新状态
            updateModelTaskStatus(AssetSessionVisitConstants.ModelStatus.FAILED);
        }
    }

    /**
     * 更新方式是否发生变化
     */
    private boolean modelUpdateChange(Map<String, Object> newModelingParams) {

        // 更新方式
        Integer newModelUpdate = ConversionUtil.toInteger(newModelingParams.get(AssetSessionVisitConstants.MODEL_UPDATE));
        Integer oldModelUpdate = ConversionUtil.toInteger(modelingParams.get(AssetSessionVisitConstants.MODEL_UPDATE));
        if (newModelUpdate != null && !newModelUpdate.equals(oldModelUpdate)) {
            return true;
        }
        return false;
    }

    /**
     * 定期检查建模维度是否发生变化
     * 当前维度的定义： 建模周期 & 模型建模的频率 & 建模频率时间单位对应的数值
     */
    private boolean modelParamsChange(Map<String, Object> newModelingParams) {

        Map<String, Object> modelingParams = this.modelingParams;
        // 建模周期 model_result_span
        boolean modelResultSpanFlag = false;
        Integer newModelResultSpan = ConversionUtil.toInteger(newModelingParams.get(AssetSessionVisitConstants.MODEL_RESULT_SPAN));
        Integer oldModelResultSpan = ConversionUtil.toInteger(modelingParams.get(AssetSessionVisitConstants.MODEL_RESULT_SPAN));
        if (newModelResultSpan != null && !newModelResultSpan.equals(oldModelResultSpan)) {
            modelResultSpanFlag = true;
        }

        // 模型建模的频率 model_rate_timeunit
        boolean modelRateTimeUnitFlag = false;
        String newModelRateTimeUnit = ConversionUtil.toString(newModelingParams.get(AssetSessionVisitConstants.MODEL_RATE_TIME_UNIT));
        String oldModelRateTimeUnit = ConversionUtil.toString(modelingParams.get(AssetSessionVisitConstants.MODEL_RATE_TIME_UNIT));
        if (StringUtil.equals(newModelRateTimeUnit, oldModelRateTimeUnit)) {
            modelRateTimeUnitFlag = true;
        }

        // 建模频率时间单位对应的数值 model_rate_timeunit_num
        boolean modelRateTimeUnitNumFlag = false;
        Integer newModelRateTimeUnitNum = ConversionUtil.toInteger(newModelingParams.get(AssetSessionVisitConstants.MODEL_RATE_TIME_UNIT_NUM));
        Integer oldModelRateTimeUnitNum = ConversionUtil.toInteger(modelingParams.get(AssetSessionVisitConstants.MODEL_RATE_TIME_UNIT_NUM));
        if (newModelRateTimeUnitNum != null && !newModelRateTimeUnitNum.equals(oldModelRateTimeUnitNum)) {
            modelRateTimeUnitNumFlag = true;
        }

        if (modelResultSpanFlag && modelRateTimeUnitFlag && modelRateTimeUnitNumFlag) {
            return true;
        }

        return false;
    }

    /**
     * 检查模型所需历史天数
     *
     * @param newModelingParams 模型参数
     * @return true : 历史天数发送改变
     */
    private boolean checkModelHistoryDataDays(Map<String, Object> newModelingParams) {

        // 所需历史天数 model_history_data_span
        Integer newModelHistoryData = ConversionUtil.toInteger(newModelingParams.get(AssetSessionVisitConstants.MODEL_HISTORY_DATA_SPAN));
        Integer oldModelHistoryData = ConversionUtil.toInteger(modelingParams.get(AssetSessionVisitConstants.MODEL_HISTORY_DATA_SPAN));
        if (newModelHistoryData != null && !newModelHistoryData.equals(oldModelHistoryData)) {
            this.historyDataDays = ConversionUtil.toInteger(newModelingParams.get(AssetSessionVisitConstants.MODEL_HISTORY_DATA_SPAN));
            return true;
        }
        return false;
    }

    /**
     * 判断time是否在now的n天之内
     * n :正数表示在条件时间n天之后，负数表示在条件时间n天之前
     */
    private boolean canSink() {
        Date cTime = new Date(), fTime = this.futureDate;
        int n = -this.historyDataDays;
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(cTime);
        calendar.add(Calendar.DAY_OF_MONTH, n);
        //得到n天前的时间
        Date before7days = calendar.getTime();
        if (before7days.getTime() <= fTime.getTime()) {
            return true;
        } else {
            return false;
        }
    }
}

