-- crmdm.fms_t4_cust_risk_assess_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t4_cust_risk_assess_info;

CREATE TABLE crmdm.fms_t4_cust_risk_assess_info (
	host_cust_no varchar(32) NULL, -- 主机客户号
	cust_no varchar(20) NULL, -- 客户号
	cust_type varchar(8) NULL, -- 客户类型
	cust_risk_level bpchar(1) NULL, -- 风险承受等级
	assess_date bpchar(8) NULL, -- 评估日期
	trans_serno varchar(32) NULL, -- 风险评估交易流水号
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	id_type varchar(8) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	invalid_date bpchar(8) NULL, -- 失效日期
	publish_code varchar(8) NULL, -- 管理人代码
	print_no varchar(8) NULL, -- 打印次数
	counter_assed bpchar(1) NULL, -- 是否已在柜台做过风险评估
	inputuser varchar(20) NULL, -- 录入柜员
	cust_name varchar(128) NULL, -- 客户名称
	sub_branch_code varchar(20) NULL, -- 网点代码
	risk_channeled varchar(32) NULL, -- 已评估渠道
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.fms_t4_cust_risk_assess_info IS '客户风险承受能力评估信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.host_cust_no IS '主机客户号';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_risk_level IS '风险承受等级';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.assess_date IS '评估日期';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.trans_serno IS '风险评估交易流水号';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.invalid_date IS '失效日期';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.publish_code IS '管理人代码';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.print_no IS '打印次数';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.counter_assed IS '是否已在柜台做过风险评估';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.sub_branch_code IS '网点代码';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.risk_channeled IS '已评估渠道';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.ryzd IS '冗余字段';
