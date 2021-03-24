package com.lanysec.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.apache.commons.dbcp2.BasicDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * @author daijb
 * @date 2021/3/8 16:25
 */
@SuppressWarnings("ALL")
public class DbConnectUtil {

    private static final Logger logger = LoggerFactory.getLogger(DbConnectUtil.class);
    private static BasicDataSource dataSource = new BasicDataSource();

    static {
        String addr = SystemUtil.getHostIp();
        String username = SystemUtil.getMysqlUser();
        String password = SystemUtil.getMysqlPassword();
        String url = "jdbc:mysql://" + addr + ":3306/csp?useEncoding=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC";
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        //初始化的连接数
        dataSource.setInitialSize(3);
        //最大连接数
        dataSource.setMaxTotal(5);
        //最大空闲数
        dataSource.setMaxIdle(2);
        //最小空闲数
        dataSource.setMinIdle(1);
    }

    public static Connection getConnection() {
        Connection con = null;
        try {
            con = dataSource.getConnection();
        } catch (Exception e) {
            logger.error("create mysql connect pool failed.",e);
        }
        return con;
    }

    /**
     * 执行一个任务
     *
     * @param sql    sql
     * @param params PrepareStatement 参数
     */
    public static void execUpdateTask(String sql, String... params) {
        Connection connection = getConnection();
        try {
            if (connection == null) {
                logger.error("mysql connection is null.");
                return;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            for (int i = 1; i <= params.length; i++) {
                ps.setString(i, params[i - 1]);
            }
            ps.execute();
        } catch (Throwable throwable) {
            logger.error("execute update task failed ", throwable);
        }

    }

    /**
     * 提交事物
     */
    public static void commit(Connection conn) {
        if (conn != null) {
            try {
                conn.commit();
            } catch (SQLException e) {
                logger.error("提交事物失败,Connection: " + conn, e);
                close(conn);
            }
        }
    }

    /**
     * 事物回滚
     *
     * @deprecated
     */
    public static void rollback(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                logger.error("事物回滚失败,Connection:" + conn, e);
                close(conn);
            }
        }
    }

    /**
     * 关闭连接
     */
    private static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                logger.error("关闭连接失败,Connection:" + conn);
            }
        }
    }
}
