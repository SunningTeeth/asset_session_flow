/*
Navicat MySQL Data Transfer

Source Server         : 192.168.3.101
Source Server Version : 50720
Source Host           : 192.168.3.101:3306
Source Database       : csp

Target Server Type    : MYSQL
Target Server Version : 50720
File Encoding         : 65001

Date: 2021-03-24 10:37:52
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for modeling_params
-- ----------------------------
DROP TABLE IF EXISTS `modeling_params`;
CREATE TABLE `modeling_params` (
  `id` varchar(32) NOT NULL COMMENT '模型ID。',
  `model_type` int(11) NOT NULL COMMENT '模型分类：1 资产行为模型 ；2 扫描行为 ；3 Ddos ; 4 加密流量',
  `model_child_type` int(11) NOT NULL COMMENT '模型子类类型：无子类为 0 ；资产行为模型： 1 连接关系模型 ；2 连接频率模型 ； 3 连接流量模型 ； 4 会话信息模型 ； 5 应用分布模型',
  `model_rate_timeunit` varchar(10) DEFAULT NULL COMMENT '模型建模的频率的时间单位：秒-ss ；分钟-mm ；小时-hh ；天-dd ；月-MM ；年-yy ；周-ww ; 季度-qq',
  `model_rate_timeunit_num` int(11) DEFAULT NULL COMMENT '建模频率时间单位对应的数值。单位为 mm ；数值为 5；代表5分钟一次结果。结合上面参数使用。现在只支持 1mm 5mm 1hh 1dd',
  `model_result_span` int(11) DEFAULT NULL COMMENT '建模结果周期：1 代表一天。2 代表一周。3 代表一季度。 4 代表一年。如果总长度填写 1 ，建模的时间单位可以是 ss mm hh 。周的建模时间单位只能是 dd 。其他的只能为月',
  `model_result_template` longtext COMMENT '模型结果模板 json格式：如果建模总时间长度为1周{1:10;2:11;3:1;4:2;5:2;6:10;7:10}',
  `model_confidence_interval` float(10,2) DEFAULT NULL COMMENT '置信度。范围 0-1 。模型参数：样本总体方差 模型中计算求得。根据置信度，查询标准正态分布表。计算样本的置信区间\r\n不是所有模型都有置信区间。置信度选择直接影响模型结果',
  `model_history_data_span` int(11) DEFAULT NULL COMMENT '所需历史数据 最少为1天。只能是1的整数倍',
  `model_update` int(11) DEFAULT NULL COMMENT '模型的更新方式。0 清除历史数据更新 1 累计迭代历史数据更新。模型结果的唯一性：\r\n1.模型分类\r\n2.模型子类\r\n3.频率\r\n4.频数\r\n5.总时间长度\r\n更改上面的内容。新增。\r\n更改 历史数据和置信度 更新。',
  `model_switch` int(11) DEFAULT NULL COMMENT '0 关闭 1 打开。总开关。页面控制',
  `model_switch_2` int(11) DEFAULT NULL COMMENT '编辑控制。一种模型的多套参数同时只能有一个是开启状态。0 关闭 1 打开。',
  `model_alt_params` json DEFAULT NULL COMMENT '备用参数，json格式，用于扩展参数。\r\n{\r\n "further":"true",\r\n\r\n "joint":"false",\r\n\r\n "aggregation":"false",\r\n\r\n "model_entity_group":"grp_75Tb5HSk162ZpTWa5Vmki4,grp_75Tb5HSk164nSukfdYHRuY"\r\n\r\n}',
  `model_task_status` varchar(255) DEFAULT NULL COMMENT '建模的状态。参数选定：prepare ；提交Flink任务：running；建模成功：successs；建模失败：failed；意外终止：stop。',
  `modify_time` datetime DEFAULT NULL COMMENT '最后修改时间。首次编辑添加（首次即 没有模型类型和子类型）。一个模型同时只能存在一套建模参数。\r\n建模模型实时感知（一分钟一次）建模参数。并在确认和10分钟以后（当前时间减去最后修改时间）开始运行。',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of modeling_params
-- ----------------------------
INSERT INTO `modeling_params` VALUES ('msf_daijb', '1', '1', '1', '1', null, '1', null, '1', null, '1', '1', '{\"model_entity_group\": \"grp_75Tb5cvHjdmBtgntJxLQWX,grp_75Tb5cvHVFgCByYPVqqMVJ,grp_75Tb5ct4nNi8TGWBifmaCr,grp_75Tb5ct4nNi7xH7afTe8DV,grp_2NrXNtdVVrn7bhEpY4UVC\"}', 'running');
