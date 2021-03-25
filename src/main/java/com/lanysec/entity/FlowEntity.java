package com.lanysec.entity;

/**
 * @author daijb
 * @date 2021/3/8 16:58
 */
public class FlowEntity {

    /**
     * 关注l4p
     */
    private String l4p;
    private String srcIp;
    private String srcId;
    private int srcPort;
    private long outFlow;
    private long inFlow;
    private long rTime;
    private Integer areaId;

    public FlowEntity() {
    }

    public String getL4p() {
        return l4p;
    }

    public void setL4p(String l4p) {
        this.l4p = l4p;
    }

    public String getSrcIp() {
        return srcIp;
    }

    public void setSrcIp(String srcIp) {
        this.srcIp = srcIp;
    }

    public String getSrcId() {
        return srcId;
    }

    public void setSrcId(String srcId) {
        this.srcId = srcId;
    }

    public int getSrcPort() {
        return srcPort;
    }

    public void setSrcPort(int srcPort) {
        this.srcPort = srcPort;
    }

    public long getOutFlow() {
        return outFlow;
    }

    public void setOutFlow(long outFlow) {
        this.outFlow = outFlow;
    }

    public long getInFlow() {
        return inFlow;
    }

    public void setInFlow(long inFlow) {
        this.inFlow = inFlow;
    }

    public long getrTime() {
        return rTime;
    }

    public void setrTime(long rTime) {
        this.rTime = rTime;
    }

    public Integer getAreaId() {
        return areaId;
    }

    public void setAreaId(Integer areaId) {
        this.areaId = areaId;
    }

    @Override
    public String toString() {
        return "FlowEntity{" +
                "l4p='" + l4p + '\'' +
                ", srcIp='" + srcIp + '\'' +
                ", srcId='" + srcId + '\'' +
                ", srcPort=" + srcPort +
                ", outFlow=" + outFlow +
                ", inFlow=" + inFlow +
                ", rTime=" + rTime +
                ", areaId=" + areaId +
                '}';
    }
}
