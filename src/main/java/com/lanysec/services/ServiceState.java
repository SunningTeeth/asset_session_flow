package com.lanysec.services;

/**
 * @author daijb
 * @date 2021/3/8 22:42
 */
public enum ServiceState {

    /**
     * 启动中, 不可工作
     */
    Starting,
    /**
     * 启动完毕, 正常工作
     */
    Ready,
    /**
     * 已关闭
     */
    Stopped
}
