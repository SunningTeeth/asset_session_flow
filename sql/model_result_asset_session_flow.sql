/*
Navicat MySQL Data Transfer

Source Server         : 192.168.3.101
Source Server Version : 50720
Source Host           : 192.168.3.101:3306
Source Database       : csp

Target Server Type    : MYSQL
Target Server Version : 50720
File Encoding         : 65001

Date: 2021-03-27 13:10:29
*/

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for model_result_asset_session_flow
-- ----------------------------
DROP TABLE IF EXISTS `model_result_asset_session_flow`;
CREATE TABLE `model_result_asset_session_flow`
(
    `id`                 varchar(32)  NOT NULL COMMENT 'ID',
    `modeling_params_id` varchar(64)  NOT NULL COMMENT '模型参数ID。根据模型参数ID可以知道建模的类型及子类型',
    `src_id`             varchar(100) NOT NULL COMMENT '源资产ID',
    `src_ip`             text COMMENT '资产源IP',
    `protocol`           varchar(255) NOT NULL COMMENT '通信协议',
    `flow`               text COMMENT '流量大小置信区间统计。json格式，key 从1开始到 （模型结果时长/频率）例，一周每天的访问模型 结果为[  {"name": "1",\r\n  "value": "0-9"},\r\n  {"name": "2",\r\n  "value": "1-56"},\r\n  {"name": "3",\r\n  "value": "2-3"},\r\n  {"name": "4",\r\n  "value": "4-9"},\r\n  {"name": "5",\r\n  "value": "76-908"}\r\n]。value用英文"-"连接最低和最高值。\r\n最低和最高，用样本数量，求出样本方差。根据用户输入的置信度，根据标准正态分布表求出置信区间。',
    `up_down`            int(11)  DEFAULT NULL COMMENT '上下行区分。0 下行流量 in ;1 上行流量 out',
    `in_out`             int(11)  DEFAULT NULL COMMENT '内外网区分。目的IP在内网网段（10.0.0.0-10.255.255.255；172.16.0.0-172.31.255.255；192.168.0.0-192.168.255.255）0 。其他外网 1',
    `time`               datetime DEFAULT NULL COMMENT '数据插入时间',
    PRIMARY KEY (`src_id`, `protocol`, `modeling_params_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- ----------------------------
-- Records of model_result_asset_session_flow
-- ----------------------------
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWQi9PJRycf2APnBFQaH6', 'msf_daijb', 'ast_03ba65b39f98379bd717abb3394c9a00', '192.168.3.200', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tbMku6JHMrBCCpFxuh9Z2', 'msf_daijb', 'ast_05c1b1ccc9788c03d145c14545c718b5', '192.168.9.231', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-1.37\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWQhyius4PHqLW8LAHmyr', 'msf_daijb', 'ast_05c1b1ccc9788c03d145c14545c718b5', '192.168.9.231', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVfboPApmPNzq2EQVdZUc', 'msf_daijb', 'ast_09d5b0fc058a0a7f9cbab8b064da4965', '192.168.7.42', 'TCP',
        '[{\"name\":\"11\",\"value\":\"7.2-7.21\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tY9JFnD5ywjsocT1AN96g', 'msf_daijb', 'ast_09d5b0fc058a0a7f9cbab8b064da4965', '192.168.7.42', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWGmUfxVZvz24qp7yGtWk', 'msf_daijb', 'ast_0e5371a4377339158d799df22007bfe7', '192.168.122.220', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTgdbx4TWGJaumNupoGFS', 'msf_daijb', 'ast_0f553039be1efceec6212506c3851e19', '192.168.3.129', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUvVCtTNBK4CFpCs7BMEG', 'msf_daijb', 'ast_119b2a3a6371b403ad48a43629326333', '192.168.9.200', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-7.19\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsEWX3RAcrNvCG7rTBWxg8', 'msf_daijb', 'ast_119b2a3a6371b403ad48a43629326333', '192.168.9.200', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWALJqga6fiF8C5H8D3KN', 'msf_daijb', 'ast_11ae33c1d8bae431c4ced4c7998bd15a', '192.168.8.74', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.02\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8taNGdiMXp4GoRJBNVACeC', 'msf_daijb', 'ast_11ae33c1d8bae431c4ced4c7998bd15a', '192.168.8.74', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRQXRtjb4L1CZVw3BKug8p', 'msf_daijb', 'ast_11db99c1944b82f99b59ac9e79d9e63c', '192.168.9.89', 'TCP',
        '[{\"name\":\"10\",\"value\":\"4.26-4.26\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRSG6kVatVQCEg2odFhzRn', 'msf_daijb', 'ast_11db99c1944b82f99b59ac9e79d9e63c', '192.168.9.89', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsGV7qJH4BPZ85SMh1nghn', 'msf_daijb', 'ast_1e5c687da8f7ae63a45d72a4fff25cc9', '192.168.3.119', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-11.99\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsEG9CsYkyRyRDv9Z4KRiQ', 'msf_daijb', 'ast_1e5c687da8f7ae63a45d72a4fff25cc9', '192.168.3.119', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsEWWi6PV1vBpcLYm1HN5e', 'msf_daijb', 'ast_22cd8d05d95e6084427036c2ca03d8c1', '192.168.8.71', 'TCP',
        '[{\"name\":\"10\",\"value\":\"1.59-1.59\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsE1kxAxUoQcg7zK3DKu1a', 'msf_daijb', 'ast_22cd8d05d95e6084427036c2ca03d8c1', '192.168.8.71', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWXAjLtBFLXt87ZiLyD12', 'msf_daijb', 'ast_246289f025f6990457b5d296f2e6629e', '192.168.3.16', 'TCP',
        '[{\"name\":\"11\",\"value\":\"462.04-462.04\"}]', '0', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvW2Pe8Ldgz3F2e7Dr5MZ2', 'msf_daijb', 'ast_246289f025f6990457b5d296f2e6629e', '192.168.3.16', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZdA83qMgbdbG2ykeGPYU', 'msf_daijb', 'ast_25673b7b1504f64369d555808a4304cb', '192.168.9.22', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-115.44\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsAYcELeH3pjeGZr1BTx3a', 'msf_daijb', 'ast_25673b7b1504f64369d555808a4304cb', '192.168.9.22', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_2GmkPVhTFm3rXh9vdjQg4Y', 'msf_daijb', 'ast_2805ff087bd87dc9474c2a5dbc333abc', '192.168.7.159', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:35:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUg87pb4RuFkw7wGt1Qc8', 'msf_daijb', 'ast_2805ff087bd87dc9474c2a5dbc333abc', '192.168.7.159', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-185.05\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tURkHGyCYxJytvENkoseQ', 'msf_daijb', 'ast_2805ff087bd87dc9474c2a5dbc333abc', '192.168.7.159', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUBNcPjubEjPgcBKij8yv', 'msf_daijb', 'ast_28eb57b433f203b8a645fb49fd8a7d5f', '192.168.9.15', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVArsmgf92dnU8Fv9G5tk', 'msf_daijb', 'ast_297b661dcb1219074e27eb93f9c533a6', '192.168.3.149', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8QbqCX3sadHZbUEnofAFmA', 'msf_daijb', 'ast_2a30741c85e580c2fab7fc6e41becf7f', '192.168.9.158', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUBNhDwC3rQz6Z1FGHY8Y', 'msf_daijb', 'ast_2a9b3101956cce54604af4d2f2457e25', '192.168.9.43', 'TCP',
        '[{\"name\":\"10\",\"value\":\"6.42-6.42\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwY1RgQRaAuHuGSy3qnY', 'msf_daijb', 'ast_2a9b3101956cce54604af4d2f2457e25', '192.168.9.43', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tas1PfT8XBepxJW1kQsvp', 'msf_daijb', 'ast_2b04c8c65613373414860a0eff5a1d0d', '192.168.7.158', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-613.72\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWALoprGrMoobs2pPZSD6', 'msf_daijb', 'ast_2b04c8c65613373414860a0eff5a1d0d', '192.168.7.158', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZNnXzoMBVjbTfkd9k42c', 'msf_daijb', 'ast_30c1bbafd7840aeb0f0a033d3d5ec2a2', '192.168.3.34', 'TCP',
        '[{\"name\":\"10\",\"value\":\"1.88-2.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRTFbw1fm5xc9zwyNfPKyS', 'msf_daijb', 'ast_30e16209f8633da22575f4e8ec74d860', '192.168.7.191', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8taNGiYYpGfxPqF1J2ibnp', 'msf_daijb', 'ast_30e16209f8633da22575f4e8ec74d860', '192.168.7.191', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-608.22\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tb7PPsTZKMxnpPrkxjDBn', 'msf_daijb', 'ast_30e16209f8633da22575f4e8ec74d860', '192.168.7.191', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tbMkyvVZpTrncm5tTFYhe', 'msf_daijb', 'ast_312cd485d4a18a33ed55da2466624110', '192.168.9.46', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.4-0.48\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWALeAThw8ScmyNyJSdur', 'msf_daijb', 'ast_318d07d30eda56cff66cd76f07ec3187', '192.168.9.212', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.6-2.72\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVRETpife8XnGVV3dnRQc', 'msf_daijb', 'ast_35077babfc249ac71be15bf605618eb1', '192.168.7.225', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-115.38\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws8p1cxZvHoZE9gDe19zLG', 'msf_daijb', 'ast_35077babfc249ac71be15bf605618eb1', '192.168.7.225', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRMoeqoCgDrCiwp9nAcBKW', 'msf_daijb', 'ast_360f74bdf30ebee3eef1036df0c1ca40', '192.168.3.245', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtwAiLnEXwSUvBQwCCUY', 'msf_daijb', 'ast_3661e9423c5b1eb1c0a5933cdba1fb0c', '192.168.7.172', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-825.05\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZ8RCSMC4EtNu91GHtuxc', 'msf_daijb', 'ast_3661e9423c5b1eb1c0a5933cdba1fb0c', '192.168.7.172', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws9oVdqvpTkQqhMpTo1joE', 'msf_daijb', 'ast_36816d62aaf4ce558d4e9fcd1d685005', '192.168.9.151', 'TCP',
        '[{\"name\":\"11\",\"value\":\"1.95-1.95\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMujmZk2KAh4s5rJxybzi4', 'msf_daijb', 'ast_36816d62aaf4ce558d4e9fcd1d685005', '192.168.9.151', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTgdmcT2RVfmjf2kuv4Yg', 'msf_daijb', 'ast_4365e790773de6533114e4f123ac0a1f', '192.168.3.206', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.33-0.59\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8ta7tdWM71sxqZCpdGqsPE', 'msf_daijb', 'ast_4365e790773de6533114e4f123ac0a1f', '192.168.3.206', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8taNGDZP7WyrqMa3kmNCu6', 'msf_daijb', 'ast_437dbe387ac95302a29151184bc42fc5', '192.168.3.12', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNJQgYpxtyTTr7DRW83YC', 'msf_daijb', 'ast_43f756e705e29a4c1be0e66fc4457989', '192.168.3.91', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUvVHieedvjnfm2nejkNt', 'msf_daijb', 'ast_46cabf010e2a22524ae2cbbcb57b0714', '192.168.7.155', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-1849.37\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDX17RLC8HMwDhFPsp2nt', 'msf_daijb', 'ast_46cabf010e2a22524ae2cbbcb57b0714', '192.168.7.155', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsAJEJxq8iG7GpRKBWi1wE', 'msf_daijb', 'ast_470fd1d63c9660979bc084399e48eb37', '192.168.3.140', 'TCP',
        '[{\"name\":\"11\",\"value\":\"3.12-3.12\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsD2GX8dALPM6Waabhg9oW', 'msf_daijb', 'ast_4774f14e51c07c4fc017599db7f0f212', '192.168.3.208', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-1.39\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8QbaoGNwtwt1jQy3DHTwGt', 'msf_daijb', 'ast_47846f18ea0ee6b769262d2a764f61a5', '192.168.9.163', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXqmHqWLoiU1cbsw3VJ', 'msf_daijb', 'ast_47a73e56253b84b6a46dae5dfe49fcd3', '192.168.8.97', 'ICMP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVArdH6omBb1EHn9WatSt', 'msf_daijb', 'ast_47a73e56253b84b6a46dae5dfe49fcd3', '192.168.8.97', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.9-1.7\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tbc8QK91QLPbbEfArf5vG', 'msf_daijb', 'ast_47a73e56253b84b6a46dae5dfe49fcd3', '192.168.8.97', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Hr2HW3UbG7rohbsxEMQRYc', 'msf_daijb', 'ast_4bd1c528006c2be1939ba0648e8185df', '192.168.3.95', 'ICMP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:00:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWALZLGRUWm2N2Z3ktEmE', 'msf_daijb', 'ast_4bd1c528006c2be1939ba0648e8185df', '192.168.3.95', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-5496.68\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8ta7tszvxPj1co3JPuX4q6', 'msf_daijb', 'ast_4bd1c528006c2be1939ba0648e8185df', '192.168.3.95', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws8p2CmvuW7LP3J16p4nNc', 'msf_daijb', 'ast_4bd26da1792f1819bad6ee7ca87278ce', '192.168.122.112', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws9Z8P7fwo7FDYmu2Uizsr', 'msf_daijb', 'ast_4c6c0f16c13d8e7f308feb0ffeea7e4c', '192.168.7.116', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTSG1u2T1AQb7Q9nLGvja', 'msf_daijb', 'ast_4c6c0f16c13d8e7f308feb0ffeea7e4c', '192.168.7.116', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tURkXmZ3voMm8ki9PV56G', 'msf_daijb', 'ast_4c6c0f16c13d8e7f308feb0ffeea7e4c', '192.168.7.116', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUg82zPmyHaAXB7MLT1TW', 'msf_daijb', 'ast_4ca8c12b970a89557e2bd5a8b0ba3c98', '192.168.9.168', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.27-9.56\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tas1JqFr4ZyEYMg6CrUnC', 'msf_daijb', 'ast_4ca8c12b970a89557e2bd5a8b0ba3c98', '192.168.9.168', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Hr32eikApBKCLVidrLpcWU', 'msf_daijb', 'ast_4e23876e3567d3f50eb0ea62efb452e7', '192.168.9.82', 'TCP',
        '[{\"name\":\"11\",\"value\":\"6.42-6.42\"}]', '0', '0', '2021-03-27 11:00:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Hr3H2onNXS7BtmkpX6hLv4', 'msf_daijb', 'ast_4e23876e3567d3f50eb0ea62efb452e7', '192.168.9.82', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:00:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWQi4Z79WzyRkSxFhrB8U', 'msf_daijb', 'ast_5091c557bb073e8f79e4b1cd378bd428', '192.168.9.9', 'ICMP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvXWSLRFo3cg69x3z4bVKW', 'msf_daijb', 'ast_50f71291ed0d84d131b442e4f4f2a6e8', '192.168.9.205', 'TCP',
        '[{\"name\":\"10\",\"value\":\"1.7-1.7\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMvEYjnm9BfF6bGbP24FJg', 'msf_daijb', 'ast_50f71291ed0d84d131b442e4f4f2a6e8', '192.168.9.205', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tbMkpG6zuEVbnsS3N8kQQ', 'msf_daijb', 'ast_51b97cb2c1a93fb5451419d1bed10130', '192.168.3.68', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.67-0.67\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWuTKVNSypT1m8ESETFJp', 'msf_daijb', 'ast_5410aac1859de1d9c7f3e62d068ac2c1', '192.168.9.33', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-94.64\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_2GjmHJVfeSsFA99kWpx4Zn', 'msf_daijb', 'ast_5410aac1859de1d9c7f3e62d068ac2c1', '192.168.9.33', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:35:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tURkcbkLPR3MYhY4w3UEt', 'msf_daijb', 'ast_55b3e96e65dd69a11728e56bbd7388a7', '192.168.3.110', 'TCP',
        '[{\"name\":\"10\",\"value\":\"4.4-27.45\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtvkZNMwTXURC3oDQCjS', 'msf_daijb', 'ast_55b3e96e65dd69a11728e56bbd7388a7', '192.168.3.110', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tbc8EekSV72QmM1KmYHd2', 'msf_daijb', 'ast_5641a068ff6cb38f87a47baff3f26eb1', '192.168.7.27', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsAYbyr4Rfygs2jNEYnkbi', 'msf_daijb', 'ast_57b92a9cdb95d2da74d5e222796acc0f', '192.168.3.127', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tacdtScQUhSRZt6ooSwZa', 'msf_daijb', 'ast_5d69971a0f69483333800629d9c665a7', '192.168.9.177', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws9oVig86vN6S7JePLa8wr', 'msf_daijb', 'ast_5d69971a0f69483333800629d9c665a7', '192.168.9.177', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUBNwiX3RhTmLPV1txjaQ', 'msf_daijb', 'ast_5fda2ffd01d92f29ca844cd9eef3a885', '192.168.9.147', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUg7sL1D44CyhHTWFLDAG', 'msf_daijb', 'ast_5fda2ffd01d92f29ca844cd9eef3a885', '192.168.9.147', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Hr6kFH1SVqNndCiU6chFZz', 'msf_daijb', 'ast_61b1256bca7fcab05504ed660871caa8', '192.168.122.13', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:00:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsE1knWZutBFVJ6fC8D6iL', 'msf_daijb', 'ast_647e601442c54f841288d1b9b8bdb9a5', '192.168.3.141', 'TCP',
        '[{\"name\":\"10\",\"value\":\"6.52-6.52\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsD2GSJRssmfW6dkgA7ket', 'msf_daijb', 'ast_647e601442c54f841288d1b9b8bdb9a5', '192.168.3.141', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtvatyo2EAHbJPx8HQSC', 'msf_daijb', 'ast_67a0d18a4092638dccfa577320feb94d', '192.168.7.174', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-104.24\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVArYSuXJZuQpLxDy2VJG', 'msf_daijb', 'ast_67a0d18a4092638dccfa577320feb94d', '192.168.7.174', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtvqPZeQ5D4q8sikxbt4', 'msf_daijb', 'ast_67d5e2d04425b62dcb5bc178835cf7d4', '192.168.8.244', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-86.52\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTgdrSeJt7MN9brgTUThJ', 'msf_daijb', 'ast_67d5e2d04425b62dcb5bc178835cf7d4', '192.168.8.244', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_TUTYhjdue745jAFXJbeNUg', 'msf_daijb', 'ast_6842b889a0b49cabcf43765044a38530', '192.168.9.113', 'TCP',
        '[{\"name\":\"10\",\"value\":\"6.39-6.39\"}]', '0', '0', '2021-03-27 10:55:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_2GmzmqEEpPgtsD2b57xbuz', 'msf_daijb', 'ast_6842b889a0b49cabcf43765044a38530', '192.168.9.113', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:35:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXLn88kei9zLf4caeba', 'msf_daijb', 'ast_68cb1c714ec88413e062abee17a90d07', '192.168.3.92', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNYmrStZ6zwVakJwGrPJx', 'msf_daijb', 'ast_68cb1c714ec88413e062abee17a90d07', '192.168.3.92', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYPgFzDWn83qfhokNgUMe', 'msf_daijb', 'ast_69a51ec4b895d2d3e02e1d05b9f8f7c7', '192.168.7.129', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXeZAWLMSMdUcppfissDa', 'msf_daijb', 'ast_69a51ec4b895d2d3e02e1d05b9f8f7c7', '192.168.7.129', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-183.85\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZsXTcHWorUopZj7W7XcU', 'msf_daijb', 'ast_69a51ec4b895d2d3e02e1d05b9f8f7c7', '192.168.7.129', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRPHvXiU7ATL8UazZGGaGp', 'msf_daijb', 'ast_6a84f3436927a9240f141160517c70ff', '192.168.3.64', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws9Z8DTHNsst2itFBPcCac', 'msf_daijb', 'ast_6a84f3436927a9240f141160517c70ff', '192.168.3.64', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRPnJ3mxLrhdrjYcnn5UfA', 'msf_daijb', 'ast_6bd298c2394ea7be0db7c7ff078f07f8', '192.168.9.216', 'TCP',
        '[{\"name\":\"11\",\"value\":\"6.49-6.49\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNJQGPrYbu3VnP5onL3o6', 'msf_daijb', 'ast_6bd298c2394ea7be0db7c7ff078f07f8', '192.168.9.216', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Bth3fCXBov3cF1AVztvpzc', 'msf_daijb', 'ast_6f233f6c9dd58828361437b6c66d7f1e', '192.168.0.7', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:30:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_BtgZEWtJnnRMy4HUghtkxg', 'msf_daijb', 'ast_6f233f6c9dd58828361437b6c66d7f1e', '192.168.0.7', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:30:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsEkWomEH8Hxjtpbi7gjFN', 'msf_daijb', 'ast_6f6af28e94a7ec42fabc7cc931db8686', '192.168.9.161', 'TCP',
        '[{\"name\":\"11\",\"value\":\"6.42-6.42\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsMSUKziMJfUg4Cq7a4Gdv', 'msf_daijb', 'ast_6f6af28e94a7ec42fabc7cc931db8686', '192.168.9.161', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_BtgoFcXUzQBL1J7SiLzuur', 'msf_daijb', 'ast_71dce169bb9281fca54d52835c6c45d7', '192.168.9.85', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:30:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8ta7u8VWoma4Q2snAYCGGx', 'msf_daijb', 'ast_725dbbdf9ea65c24ec78f693cdb20d64', '192.168.7.163', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-8863.73\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWQhp4XJ99veWcUV5Aygc', 'msf_daijb', 'ast_725dbbdf9ea65c24ec78f693cdb20d64', '192.168.7.163', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_BtgoH2enpCdw6KBVQbVhSQ', 'msf_daijb', 'ast_74610982f20da87555861ccc2da4960c', '192.168.3.47', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:30:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tURkCSmv6LdPUyQTDFUVn', 'msf_daijb', 'ast_75b75b5e04111bbfe72797b4d57e24fa', '192.168.9.120', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.09-0.09\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVArxbswbeKNt55qgpV3N', 'msf_daijb', 'ast_77aed692ac257e3123eebdd1aff8d136', '192.168.8.171', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsAnypPgHYvde4w58fzHZS', 'msf_daijb', 'ast_77aed692ac257e3123eebdd1aff8d136', '192.168.8.171', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVfby3ZPgckBeutFakMmr', 'msf_daijb', 'ast_79e04b1a14ddfed5b8665154df88e8a3', '192.168.9.211', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-8.44\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUg7nVovbSXPHLdahmp1e', 'msf_daijb', 'ast_79e04b1a14ddfed5b8665154df88e8a3', '192.168.9.211', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_5M73zd3Pv78DeX8EZVHDxU', 'msf_daijb', 'ast_7bad8c1bb435fd17771b85e2501fb13c', '192.168.8.187', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:50:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWQhttiabmcEvZJQcjNqE', 'msf_daijb', 'ast_7bad8c1bb435fd17771b85e2501fb13c', '192.168.8.187', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-372.3\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTgdSHftb2wQ5sj4jgTxC', 'msf_daijb', 'ast_7bad8c1bb435fd17771b85e2501fb13c', '192.168.8.187', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVuy47RhS2Ycyc9qovJPz', 'msf_daijb', 'ast_7d2ff76c2c96880a3e67064d22fb78ce', '192.168.9.131', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-622.2\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZd9nj4Dr8uDcFg4U2nwz', 'msf_daijb', 'ast_7d2ff76c2c96880a3e67064d22fb78ce', '192.168.9.131', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsHyKmpniUJxq2g1vdK7yA', 'msf_daijb', 'ast_7e9c608ca7ae2affb9e2e3f9d584e836', '192.168.9.12', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYPg6Kpwrtgeqp9uHZg4Q', 'msf_daijb', 'ast_81a2c979e67c4a81e3d2547391e83e08', '192.168.7.184', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-335.11\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXRcKRDGPkQHUzA93kC', 'msf_daijb', 'ast_81a2c979e67c4a81e3d2547391e83e08', '192.168.7.184', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRTzjC9wVLxPhsicJQJjQk', 'msf_daijb', 'ast_837fea1c9f64633c6210990294d26eed', '192.168.7.63', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwX1TLzvBynLZMNSM416', 'msf_daijb', 'ast_837fea1c9f64633c6210990294d26eed', '192.168.7.63', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-346.73\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tURkSwMmUBgAiotDqvfwe', 'msf_daijb', 'ast_837fea1c9f64633c6210990294d26eed', '192.168.7.63', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYdgGps2Rt9AYF2mwXSNk', 'msf_daijb', 'ast_83c8284f1a32382fbfcbc67bfcf79b6d', '192.168.3.36', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.38-4.07\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUvV84G5ihNbqsNwZcx5e', 'msf_daijb', 'ast_83c8284f1a32382fbfcbc67bfcf79b6d', '192.168.3.36', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tY9JfwBWH29qsLactA8qn', 'msf_daijb', 'ast_8623fd4b8ea8f369edf9c3d22b20e227', '192.168.9.227', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-8.34\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXFwvrJ32ZaPq952FSx', 'msf_daijb', 'ast_8623fd4b8ea8f369edf9c3d22b20e227', '192.168.9.227', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDmPXnK3DY5s9WjkovMnx', 'msf_daijb', 'ast_8633968a2a2496369988aa374671a793', '192.168.9.222', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsBHhuhDcb8YvJNnPammf6', 'msf_daijb', 'ast_8898fc00e40eab50d4a5016279a831f3', '192.168.3.8', 'TCP',
        '[{\"name\":\"10\",\"value\":\"1.63-1.63\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtw13xDKJaFf2XZr5QBJ', 'msf_daijb', 'ast_8898fc00e40eab50d4a5016279a831f3', '192.168.3.8', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZdACt2e9DKBfyogBpnh6', 'msf_daijb', 'ast_89f22902ea7d3c0879078f9acdb74206', '192.168.3.21', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-150.54\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYPfqqF6V3dsbyg8etUcY', 'msf_daijb', 'ast_89f22902ea7d3c0879078f9acdb74206', '192.168.3.21', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8Qd4rnyottfUWfjFCwa4Xa', 'msf_daijb', 'ast_8aee343d85c9db21d03a584d436cc2a9', '192.168.9.223', 'TCP',
        '[{\"name\":\"11\",\"value\":\"6.36-6.36\"}]', '1', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNoA79UqH2JEgg9T7qv1n', 'msf_daijb', 'ast_8bd24a81ce2c1c93e1b7575caac9b784', '192.168.122.2', 'TCP',
        '[{\"name\":\"10\",\"value\":\"2.17-2.17\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsE1m7qM3idyrwsxtJShJp', 'msf_daijb', 'ast_8c5f4cba3c7202e6e38843599555ae7d', '192.168.0.9', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-15.62\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWXAZgVcL7AhJDusFrQhn', 'msf_daijb', 'ast_8c5f4cba3c7202e6e38843599555ae7d', '192.168.0.9', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtvvDkvrgtfF5heJX12g', 'msf_daijb', 'ast_8dbc512f5a4cb3ec161b7168a4ac2391', '192.168.8.134', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVuy8wcyteEDPYymMUhYc', 'msf_daijb', 'ast_8f9018eb841b52e6200be5b83330cb45', '192.168.9.2', 'TCP',
        '[{\"name\":\"11\",\"value\":\"1.45-1.45\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZ8RHGYUWrZyK5qBqTK7E', 'msf_daijb', 'ast_8f9018eb841b52e6200be5b83330cb45', '192.168.9.2', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUg7hfce8pqnsPofADQs2', 'msf_daijb', 'ast_918d60f34bb24b5d20530489f7339e26', '192.168.9.60', 'TCP',
        '[{\"name\":\"11\",\"value\":\"1.07-3.52\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tX9pKj3UGcZrfsg6v4nnL', 'msf_daijb', 'ast_927f74061d02f5924f5dad891508396f', '192.168.0.108', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.48\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws7pYGimHnnAMuZECZmS4G', 'msf_daijb', 'ast_927f74061d02f5924f5dad891508396f', '192.168.0.108', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_TUSZAJga77tEngp3dVtFvG', 'msf_daijb', 'ast_98e9010ce388eb3c38d78eace0f04457', '192.168.3.94', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-80876.32\"}]', '1', '0', '2021-03-27 10:55:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws8KH2frtVuYPSZYqq27Lt', 'msf_daijb', 'ast_98e9010ce388eb3c38d78eace0f04457', '192.168.3.94', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsAYc9WSzbD43rd25duYtx', 'msf_daijb', 'ast_9a3cec6d8a287228ee389d885c359d44', '192.168.3.201', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVRE3fkFM47pCmMRuzRfW', 'msf_daijb', 'ast_9a659aa9d74e7c609e91d93a4efbcb06', '192.168.3.4', 'TCP',
        '[{\"name\":\"10\",\"value\":\"35.19-41.87\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMvUwQeKqem1okvZWaqmkc', 'msf_daijb', 'ast_9b8006acab8f6b2bfa4beb48714bf037', '192.168.9.58', 'TCP',
        '[{\"name\":\"10\",\"value\":\"5.9-5.9\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMuVPp2bjkMogTbRzPxrtx', 'msf_daijb', 'ast_9b8006acab8f6b2bfa4beb48714bf037', '192.168.9.58', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXbGhz8VkwEB8qFFr3S', 'msf_daijb', 'ast_9bcf80f48b18680c7fdafc0f7d0efa59', '192.168.8.93', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.34\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwWvd9iTaJBvcXStnerU', 'msf_daijb', 'ast_9bcf80f48b18680c7fdafc0f7d0efa59', '192.168.8.93', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXtw5t9VmvFr4yMVPdoKv', 'msf_daijb', 'ast_9bfeb71d7f154f1fe020436a86bba497', '192.168.8.146', 'ICMP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZsXHwtwtd7czg5GQzjKE', 'msf_daijb', 'ast_9bfeb71d7f154f1fe020436a86bba497', '192.168.8.146', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-74.56\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVArnwVNgQxC4BRzbhgk8', 'msf_daijb', 'ast_9bfeb71d7f154f1fe020436a86bba497', '192.168.8.146', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8QbLQr1y3rdHoV9YrMMcGp', 'msf_daijb', 'ast_9c507b23f79fa77c104671e6b4da447f', '192.168.9.155', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwX6HYHNofNkWBHyuT9i', 'msf_daijb', 'ast_9ebd8052359821f4797f19b8baa1e7d3', '192.168.7.249', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-1.5\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDmNwxx41EJiFtxJ11Zkc', 'msf_daijb', 'ast_9ebd8052359821f4797f19b8baa1e7d3', '192.168.7.249', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws94PHqoDFX8pMzGh3Eizk', 'msf_daijb', 'ast_a15b24f617b7d0e71a6e22a92bcc28a6', '192.168.3.172', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWALPfsrZHPqY8uCfmSTz', 'msf_daijb', 'ast_a194bf6be591dd6d056fd81b22ec3545', '192.168.3.100', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.18-1.42\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRTFbmMHCAjEyB4KXaGXgC', 'msf_daijb', 'ast_a2128964f1cce94b3c31eae89b95f94e', '192.168.3.182', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-10.52\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_2GjmJdnnBniAekGyHXtSwi', 'msf_daijb', 'ast_a2128964f1cce94b3c31eae89b95f94e', '192.168.3.182', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:35:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRRWyjqu1cFTU36eU9TnSL', 'msf_daijb', 'ast_a94daa4062cb904a523b1b4617259c4e', '192.168.8.133', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-223.42\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRR2C9eBmJCsGTxESPDY6c', 'msf_daijb', 'ast_a94daa4062cb904a523b1b4617259c4e', '192.168.8.133', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8QbqDmWnqWWoVfRBepYEzU', 'msf_daijb', 'ast_a9b2320b2539ef4a667ba3e64f80a91f', '192.168.0.160', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTgdgnFjxszBKiCqNMfQ4', 'msf_daijb', 'ast_ae4bfa93c6e4bc46e970f84c32dfc6ff', '192.168.3.168', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-53.81\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTgdX7sB3eczVpYzHEs6p', 'msf_daijb', 'ast_ae4bfa93c6e4bc46e970f84c32dfc6ff', '192.168.3.168', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8Qc5eGedn59bFusL6McYi4', 'msf_daijb', 'ast_aebee5d8121d68b686fdfce8a45644fb', '192.168.9.73', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVAri7J6DoGbeEc549HbW', 'msf_daijb', 'ast_afb1d44ee125fc43b1d696d565b958aa', '192.168.7.25', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-1.78\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXkw6Z3j8844ngLNeLg', 'msf_daijb', 'ast_afb1d44ee125fc43b1d696d565b958aa', '192.168.7.25', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_BtgoGSqRpzL9wRZhwnauQ4', 'msf_daijb', 'ast_b13cde2e44c4c3f26f3680907d38cfea', '192.168.8.211', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:30:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws84umwc1qGNmHydQWjNRW', 'msf_daijb', 'ast_b13cde2e44c4c3f26f3680907d38cfea', '192.168.8.211', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-280.23\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws94PTWBnAkW1BsvY8MXHz', 'msf_daijb', 'ast_b13cde2e44c4c3f26f3680907d38cfea', '192.168.8.211', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWGo9HrAkEdtKkLarSsVA', 'msf_daijb', 'ast_b1ab4c3d359b2d0eb6c82c1923184722', '192.168.9.87', 'TCP',
        '[{\"name\":\"11\",\"value\":\"6.29-6.29\"}]', '0', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWXCeTMhoVEXcrZwrpPRJ', 'msf_daijb', 'ast_b1ab4c3d359b2d0eb6c82c1923184722', '192.168.9.87', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws94PdAaM5ysC1maPDUKbE', 'msf_daijb', 'ast_b50a17aaf89c5095c7a4dd5e59e6f778', '192.168.7.68', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXeZLAivMazfSiUWozfWp', 'msf_daijb', 'ast_b50a17aaf89c5095c7a4dd5e59e6f778', '192.168.7.68', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-135.36\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tZdA3De5Dywzr69q6hzPr', 'msf_daijb', 'ast_b50a17aaf89c5095c7a4dd5e59e6f778', '192.168.7.68', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMuzBQEJz4QPt2jr2AD7Eg', 'msf_daijb', 'ast_b527942c62084321341099b7301bab79', '192.168.9.159', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWf5Q7ZJeFpeJyhcZhKCU', 'msf_daijb', 'ast_b74517821bd209ea1903f287835c3e9f', '192.168.3.103', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-4.21\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_BtgZF1sUVY7TXXxSDyF9rQ', 'msf_daijb', 'ast_b74517821bd209ea1903f287835c3e9f', '192.168.3.103', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:30:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNYnSGFYKJieUN6Q5mBMJ', 'msf_daijb', 'ast_b93cbe2b3a9490fe73088a877e1c025b', '192.168.7.8', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSh9qZHQiAVkbvFrfciEL', 'msf_daijb', 'ast_b93cbe2b3a9490fe73088a877e1c025b', '192.168.7.8', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-77.25\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXvbV7xxVJsxSXRVSdv', 'msf_daijb', 'ast_b93cbe2b3a9490fe73088a877e1c025b', '192.168.7.8', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVfbU4PgvvedBEviKPxt8', 'msf_daijb', 'ast_b9aae38c7ba9a94ef26a789f8cc19a71', '192.168.9.100', 'TCP',
        '[{\"name\":\"10\",\"value\":\"8.77-10.11\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTw1cA4tJScYmrjf37bWQ', 'msf_daijb', 'ast_ba6322d22b14ce544cb68fce27706b63', '192.168.9.121', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUBNn48UWU6aWVqAoqwHA', 'msf_daijb', 'ast_ba6322d22b14ce544cb68fce27706b63', '192.168.9.121', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNYnwFRF4zpCx33wM7aF2', 'msf_daijb', 'ast_bb25209db54eb8a8a3190c3148faf957', '192.168.9.221', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tXeZQzvCpCgFrfJSMZ4fS', 'msf_daijb', 'ast_bbd86357071857a8c759b59d1390b310', '192.168.3.250', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMuVPZY1tNWkuDkxDmHfT6', 'msf_daijb', 'ast_bd074457aef10d66dda6fd536c00b4f1', '192.168.8.227', 'ICMP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTw12Lhu68qPtExCECoU4', 'msf_daijb', 'ast_bd074457aef10d66dda6fd536c00b4f1', '192.168.8.227', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-3.97\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws7pYMYxaFPqxKW487KqCt', 'msf_daijb', 'ast_bd074457aef10d66dda6fd536c00b4f1', '192.168.8.227', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_5M64mS4fXcgseThi4YrWwz', 'msf_daijb', 'ast_bdbd693e83cb3812fba1bbea5a1e0706', '192.168.9.80', 'TCP',
        '[{\"name\":\"10\",\"value\":\"3.83-3.83\"}]', '1', '0', '2021-03-27 10:50:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws84ucHDSv31aU5yZRca8G', 'msf_daijb', 'ast_bdbd693e83cb3812fba1bbea5a1e0706', '192.168.9.80', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVuyDmpGMFuooVogu36hE', 'msf_daijb', 'ast_bf6a3556070a2a4fd1387e568ec468f9', '192.168.3.98', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTSGGPcJP1TNMEdYxx8BS', 'msf_daijb', 'ast_bffe8fab9a913a8642f73ec4b654f007', '192.168.3.9', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.42-0.42\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvYW3BSZxr1WMZ9QWUFxyN', 'msf_daijb', 'ast_bffe8fab9a913a8642f73ec4b654f007', '192.168.3.9', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVfbtDN7E14bEy4L3BxdE', 'msf_daijb', 'ast_c0380136309f42bbd4cf0a3bfe5a176a', '192.168.3.50', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-1.07\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Hr2nGU3aY1HqbPnoLVq5oe', 'msf_daijb', 'ast_c2e2cd01bcd45f94da5cada897a17122', '192.168.9.79', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:00:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsE1mHVjcdsM3mmcjPZVc4', 'msf_daijb', 'ast_c49ee5a4d2fd16fe473c7c862433bb6f', '192.168.9.128', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMujmeaDbdJkTVo8tXAPrg', 'msf_daijb', 'ast_c98a3ee2a8b13d458c727c997406ca00', '192.168.9.42', 'TCP',
        '[{\"name\":\"10\",\"value\":\"6.55-6.55\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMwE4qSz8pzAYTarHQsyVA', 'msf_daijb', 'ast_c98a3ee2a8b13d458c727c997406ca00', '192.168.9.42', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8ta7u3fKXJxNocvxEzds8L', 'msf_daijb', 'ast_cab01f8d9876f44a7b0e340ac6e3420d', '192.168.3.20', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.57-2.26\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTSFw4qAYYizhTKrniXax', 'msf_daijb', 'ast_cab01f8d9876f44a7b0e340ac6e3420d', '192.168.3.20', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8taNGPDmgSDE2BThbrV1CL', 'msf_daijb', 'ast_cc3537da5fa9e83da62ce933e64992c6', '192.168.7.207', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-10.53\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDmNnJZV5zwXS1JSutmTN', 'msf_daijb', 'ast_cc3537da5fa9e83da62ce933e64992c6', '192.168.7.207', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRRWy5CLjwKzijY35nzbFN', 'msf_daijb', 'ast_cd4820a834efe371d20aa677fda7b925', '192.168.9.88', 'TCP',
        '[{\"name\":\"10\",\"value\":\"6.36-6.36\"}]', '1', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_MRNYn27H82EJgQdxnMyBcC', 'msf_daijb', 'ast_cd4820a834efe371d20aa677fda7b925', '192.168.9.88', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:25:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8QbqE6qZyLyXsKCVLzmqax', 'msf_daijb', 'ast_cf1447343b59243b2ccb6f6a9ffda9df', '192.168.9.235', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tURkN7AV1ZzaJs4JJNGo2', 'msf_daijb', 'ast_d33c24f0e9c10f0bae8d1adff29b7afa', '192.168.7.219', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-8930.97\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8taNGU3xxtpucbQXXQ3QLx', 'msf_daijb', 'ast_d33c24f0e9c10f0bae8d1adff29b7afa', '192.168.7.219', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDGdmrt312WifAW31xtit', 'msf_daijb', 'ast_e241d10b30ef32e558125b43c2299c17', '192.168.9.162', 'ICMP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvW2NyUnN24aVj5VqVcAN4', 'msf_daijb', 'ast_e241d10b30ef32e558125b43c2299c17', '192.168.9.162', 'TCP',
        '[{\"name\":\"11\",\"value\":\"6.42-6.42\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWuSuLQ2gk33hQ6pWfFZi', 'msf_daijb', 'ast_e4df9a4b99f1ded40e62b39f6b5a1244', '192.168.3.15', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-32.64\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws84uMndbYBxoEFVnnwNgQ', 'msf_daijb', 'ast_e5dcb9270a442f761f96a358188f30a1', '192.168.8.254', 'ICMP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwXg6uGb7SXe7xknpFC4', 'msf_daijb', 'ast_e6d915f4ee9084086bb4611f5a039213', '192.168.7.67', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-6.87\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWQiK3gztr2CzHS2LXNaL', 'msf_daijb', 'ast_e6d915f4ee9084086bb4611f5a039213', '192.168.7.67', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYdgXKSsojBwn5WYaCdpc', 'msf_daijb', 'ast_e762504f737ca3657ae4e60275e32f2f', '192.168.7.222', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-1.83\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTw1XKsbqpvxMuujVZCMn', 'msf_daijb', 'ast_e762504f737ca3657ae4e60275e32f2f', '192.168.7.222', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tbMkZmX9XPSpZ2xGjTYxY', 'msf_daijb', 'ast_ea4f7e9b6eb96f1e80f9764e06fbbbbd', '192.168.7.40', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-6.02\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDmP2o9LTqzJfqnDYZxuE', 'msf_daijb', 'ast_ea4f7e9b6eb96f1e80f9764e06fbbbbd', '192.168.7.40', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws8p237YLasyCDQMFiwz5N', 'msf_daijb', 'ast_eb329ca9d4b212823269f93473331189', '192.168.9.232', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_Ws9Jm3ZDnfrPzzF9fcsror', 'msf_daijb', 'ast_ee23d402bd1ec117a3c0a291e29be8d1', '192.168.9.44', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-4.47\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_QMuF1Pfctf75kXmwdTrXtt', 'msf_daijb', 'ast_ee23d402bd1ec117a3c0a291e29be8d1', '192.168.9.44', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:40:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsDX1CFXUau3Xde5KRNRwW', 'msf_daijb', 'ast_eeb610b0d926155910a68963c4ebd0de', '192.168.3.35', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8QbLRBLkBh62B8vrYXbCsJ', 'msf_daijb', 'ast_f16e8f39d85e8cfff08fae26122c4101', '192.168.9.148', 'TCP',
        '[{\"name\":\"11\",\"value\":\"4.27-4.34\"}]', '1', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8Qc5bgtbyr5Rs7ZiUVJB6p', 'msf_daijb', 'ast_f16e8f39d85e8cfff08fae26122c4101', '192.168.9.148', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 11:05:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tVRENzXPBWrBrYf86E2Fz', 'msf_daijb', 'ast_f2985f3da90686d46dfad51793f0ede4', '192.168.0.8', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-80.91\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_2GkG4osBcJJ9mJMLd3dukt', 'msf_daijb', 'ast_f2985f3da90686d46dfad51793f0ede4', '192.168.0.8', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:35:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTw1C16U1NCai8c3KKbmJ', 'msf_daijb', 'ast_f4629f7277dfba4a1139a62806625d6d', '192.168.7.253', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.11\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWma9gCRqySw1Gy9onKnY', 'msf_daijb', 'ast_f5455fe7913ee851bdbfa332fd42ffd3', '192.168.9.3', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.64-0.69\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsAYcKAqZWSREgWfvj2MCC', 'msf_daijb', 'ast_f5455fe7913ee851bdbfa332fd42ffd3', '192.168.9.3', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_TUTJKpG6VmVTMi6zUvtSNL', 'msf_daijb', 'ast_f567b9e1e9aa02d36334e490699a7ded', '192.168.3.85', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:55:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tSwWqnxRzxcbWfhXMEFhr', 'msf_daijb', 'ast_f657dcf7c520b3c56c4262ef5253b72d', '192.168.3.101', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-4.33\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tUvVNYqw6YRP5hriCJ9XW', 'msf_daijb', 'ast_f657dcf7c520b3c56c4262ef5253b72d', '192.168.3.101', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYt3cPKBZ8zP6mn8oNaSk', 'msf_daijb', 'ast_f9e2cbca9f59b0e24d3a5bce55fcb614', '192.168.8.59', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-211.09\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsCXXmBXZdFy4yaFxSRUWt', 'msf_daijb', 'ast_f9e2cbca9f59b0e24d3a5bce55fcb614', '192.168.8.59', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tTw17AuBYkWzJBn7mmCcg', 'msf_daijb', 'ast_fa4ee0e726e37f25fd949e9582fe3039', '192.168.9.167', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tYdgBzfjyGTa8JCrPy3E8', 'msf_daijb', 'ast_fa4ee0e726e37f25fd949e9582fe3039', '192.168.9.167', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tb7NttHrZfsELiuDhNpJ4', 'msf_daijb', 'ast_fad66ee08b7ca33e5ea722d1cc1f457d', '192.168.7.189', 'TCP',
        '[{\"name\":\"11\",\"value\":\"0.0-51.7\"}]', '0', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_8tWALizezPk8DBvCtr134U', 'msf_daijb', 'ast_fad66ee08b7ca33e5ea722d1cc1f457d', '192.168.7.189', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:15:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_WsMgqfZAWRvKtcjaURuQhv', 'msf_daijb', 'ast_fb5e57f6bc29a365616eeec46f69156e', '192.168.9.17', 'UDP',
        '[{\"name\":\"10\",\"value\":\"0.0-0.0\"}]', '1', '0', '2021-03-27 10:20:06');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvX1yKWvq4mKCebtpdvF8C', 'msf_daijb', 'ast_fcf1b84f5fea59e91ea8366a6389be2a', '192.168.8.141', 'TCP',
        '[{\"name\":\"10\",\"value\":\"0.0-13818.35\"}]', '1', '0', '2021-03-27 10:45:07');
INSERT INTO `model_result_asset_session_flow`
VALUES ('msf_EvWmapKkhWtugJqaYAFWyW', 'msf_daijb', 'ast_fcf1b84f5fea59e91ea8366a6389be2a', '192.168.8.141', 'UDP',
        '[{\"name\":\"11\",\"value\":\"0.0-0.0\"}]', '0', '0', '2021-03-27 10:45:07');
