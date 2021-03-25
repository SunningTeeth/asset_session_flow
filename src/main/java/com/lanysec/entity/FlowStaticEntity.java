
package com.lanysec.entity;

import org.json.simple.JSONObject;

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

    public JSONObject toJSONObject() {
        JSONObject json = new JSONObject();
        json.put("srcId", getSrcId());
        json.put("srcIp", getSrcIp());
        json.put("areaId", getAreaId());
        json.put("protocol", getProtocol());
        json.put("minFlowSize", getMinFlowSize());
        json.put("maxFlowSize", getMaxFlowSize());
        return json;
    }

    @Override
    public String toString() {
        return "FlowStaticEntity{" +
                "srcId='" + srcId + '\'' +
                ", srcIp='" + srcIp + '\'' +
                ", areaId=" + areaId +
                ", protocol='" + protocol + '\'' +
                ", cDate='" + cDate + '\'' +
                ", minFlowSize=" + minFlowSize +
                ", maxFlowSize=" + maxFlowSize +
                '}';
    }
}
