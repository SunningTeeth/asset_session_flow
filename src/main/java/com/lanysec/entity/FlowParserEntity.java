package com.lanysec.entity;

/**
 * @author daijb
 * @date 2021/3/8 17:51
 */
public class FlowParserEntity {

    private String srcId;
    private String srcIp;
    private String protocol;
    private Integer areaId;
    private String cntDate;
    private long inFlow;
    private long outFlow;
    private long totalCount;

    public FlowParserEntity() {
    }

    public String getSrcIp() {
        return srcIp;
    }

    public void setSrcIp(String srcIp) {
        this.srcIp = srcIp;
    }

    public String getProtocol() {
        return protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }

    public Integer getAreaId() {
        return areaId;
    }

    public void setAreaId(Integer areaId) {
        this.areaId = areaId;
    }

    public String getCntDate() {
        return cntDate;
    }

    public void setCntDate(String cntDate) {
        this.cntDate = cntDate;
    }

    public long getInFlow() {
        return inFlow;
    }

    public void setInFlow(long inFlow) {
        this.inFlow = inFlow;
    }

    public long getOutFlow() {
        return outFlow;
    }

    public void setOutFlow(long outFlow) {
        this.outFlow = outFlow;
    }

    public long getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(long totalCount) {
        this.totalCount = totalCount;
    }

    public String getSrcId() {
        return srcId;
    }

    public void setSrcId(String srcId) {
        this.srcId = srcId;
    }

    @Override
    public String toString() {
        return "FlowParserEntity{" +
                "srcId='" + srcId + '\'' +
                ", srcIp='" + srcIp + '\'' +
                ", protocol='" + protocol + '\'' +
                ", areaId=" + areaId +
                ", cntDate='" + cntDate + '\'' +
                ", inFlow=" + inFlow +
                ", outFlow=" + outFlow +
                ", totalCount=" + totalCount +
                '}';
    }
}
