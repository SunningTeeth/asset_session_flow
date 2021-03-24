package com.lanysec.services;

import com.lanysec.entity.FlowParserEntity;
import com.lanysec.utils.DbConnectUtil;
import com.lanysec.utils.SystemUtil;
import com.lanysec.utils.UUIDUtil;
import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.functions.sink.RichSinkFunction;
import org.apache.flink.streaming.api.functions.sink.SinkFunction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;

/**
 * @author daijb
 * @date 2021/3/10 11:14
 */
public class TestSink extends RichSinkFunction<FlowParserEntity> implements SinkFunction<FlowParserEntity> {

    private static final Logger logger = LoggerFactory.getLogger(TestSink.class);

    private Connection connection;

    private PreparedStatement ps;

    private BasicDataSource dataSource;

    @Override
    public void open(Configuration parameters) throws Exception {
        super.open(parameters);
        String sql = "INSERT INTO `model_result_asset_session_flow` (`id`, `modeling_params_id`, `src_id`, `src_ip`, `protocol`, `flow`, `up_down`, `in_out`, `time`)" +
                " values (?,?,?,?,?,?,?,?,?) ";
        //"ON DUPLICATE KEY UPDATE `dst_ip_segment`=?";
        dataSource = new BasicDataSource();
        connection = getConnection(dataSource);
        ps = connection.prepareStatement(sql);
    }

    @Override
    public void invoke(FlowParserEntity value, Context context) throws Exception {
        logger.info("----------------invoke sink");
        String modelId = "daijb_test";
        // 下行流量
        {
            ps.setString(1, "msf_" + UUIDUtil.genId());
            ps.setString(2, modelId);
            ps.setString(3, value.getSrcIp());
            ps.setString(4, value.getSrcIp());
            ps.setString(5, value.getProtocol());
            ps.setString(6, "[]");
            //0 下行流量 in ;1 上行流量 out'
            ps.setInt(7, 0);
            ps.setInt(8, 1);
            ps.setString(9, LocalDateTime.now().toString());
            ps.executeUpdate();

        }
    }

    private static Connection getConnection(BasicDataSource dataSource) {
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        //注意，替换成自己本地的 mysql 数据库地址和用户名、密码
        String addr = SystemUtil.getHostIp();
        String username = SystemUtil.getMysqlUser();
        String password = SystemUtil.getMysqlPassword();
        String url = "jdbc:mysql://" + addr + ":3306/csp?useEncoding=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC";
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        //设置连接池的一些参数
        dataSource.setInitialSize(10);
        dataSource.setMaxTotal(50);
        dataSource.setMinIdle(2);

        Connection con = null;
        try {
            con = dataSource.getConnection();
            System.out.println("创建连接池：" + con);
        } catch (Exception e) {
            System.out.println("-----------mysql get connection has exception , msg = " + e.getMessage());
        }
        return con;
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
}
