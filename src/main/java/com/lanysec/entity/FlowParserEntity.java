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
    private long flowSize;
    private long totalCount;

    public FlowParserEntity() {
    }

    public String getSrcId() {
        return srcId;
    }

    public void setSrcId(String srcId) {
        this.srcId = srcId;
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

    public long getFlowSize() {
        return flowSize;
    }

    public void setFlowSize(long flowSize) {
        this.flowSize = flowSize;
    }

    public long getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(long totalCount) {
        this.totalCount = totalCount;
    }

    @Override
    public String toString() {
        return "FlowParserEntity{" +
                "srcId='" + srcId + '\'' +
                ", srcIp='" + srcIp + '\'' +
                ", protocol='" + protocol + '\'' +
                ", areaId=" + areaId +
                ", cntDate='" + cntDate + '\'' +
                ", flowSize=" + flowSize +
                ", totalCount=" + totalCount +
                '}';
    }
}
