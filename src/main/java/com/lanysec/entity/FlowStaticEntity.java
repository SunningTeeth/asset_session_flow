
package com.lanysec.entity;

/**
 * @author daijb
 * @date 2021/3/25 11:29
 */
public class FlowStaticEntity {

    public FlowStaticEntity() {
    }

    private String srcId;
    private String srcIp;
    private Integer areaId;
    private String protocol;
    private String cDate;
    private Long totalCnt;
    private Long sumCount;
    private Long avgFlowSize;
    private Long standPop;
    private Double minFlowSize;
    private Double maxFlowSize;

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

    public Integer getAreaId() {
        return areaId;
    }

    public void setAreaId(Integer areaId) {
        this.areaId = areaId;
    }

    public String getProtocol() {
        return protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }

    public String getcDate() {
        return cDate;
    }

    public void setcDate(String cDate) {
        this.cDate = cDate;
    }

    public Long getTotalCnt() {
        return totalCnt;
    }

    public void setTotalCnt(Long totalCnt) {
        this.totalCnt = totalCnt;
    }

    public Long getSumCount() {
        return sumCount;
    }

    public void setSumCount(Long sumCount) {
        this.sumCount = sumCount;
    }

    public Long getAvgFlowSize() {
        return avgFlowSize;
    }

    public void setAvgFlowSize(Long avgFlowSize) {
        this.avgFlowSize = avgFlowSize;
    }

    public Long getStandPop() {
        return standPop;
    }

    public void setStandPop(Long standPop) {
        this.standPop = standPop;
    }

    public Double getMinFlowSize() {
        return minFlowSize;
    }

    public void setMinFlowSize(Double minFlowSize) {
        this.minFlowSize = minFlowSize;
    }

    public Double getMaxFlowSize() {
        return maxFlowSize;
    }

    public void setMaxFlowSize(Double maxFlowSize) {
        this.maxFlowSize = maxFlowSize;
    }

    @Override
    public String toString() {
        return "FlowStaticEntity{" +
                "srcId='" + srcId + '\'' +
                ", srcIp='" + srcIp + '\'' +
                ", areaId=" + areaId +
                ", protocol='" + protocol + '\'' +
                ", cDate='" + cDate + '\'' +
                ", totalCnt=" + totalCnt +
                ", sumCount=" + sumCount +
                ", avgFlowSize=" + avgFlowSize +
                ", standPop=" + standPop +
                ", minFlowSize=" + minFlowSize +
                ", maxFlowSize=" + maxFlowSize +
                '}';
    }
}
