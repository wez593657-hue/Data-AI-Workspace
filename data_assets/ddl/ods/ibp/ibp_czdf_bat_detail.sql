-- crmdm.ibp_czdf_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ibp_czdf_bat_detail;

CREATE TABLE crmdm.ibp_czdf_bat_detail (
	batch_no varchar(30) NOT NULL, -- 批次号
	serial_id varchar(12) NOT NULL, -- 流水号
	bank_name varchar(400) NULL, -- 开户行名称
	payee_id varchar(32) NULL, -- 收款人身份证件号码
	payee_name varchar(128) NULL, -- 收款人名称
	coll_account varchar(20) NULL, -- 收款账号
	amt numeric(20, 2) NOT NULL, -- 金额
	remark varchar(240) NULL, -- 附言
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	status varchar(1) NOT NULL, -- "处理状态：0:未处理 1:处理中 2:处理成功 3:处理失败 4:处理超时"
	rst_memo varchar(400) NULL, -- 交易结果描述
	tran_channel varchar(32) NULL, -- 交易渠道号
	bank_acct_no varchar(80) NULL, -- 开户行号
	third_batch varchar(30) NULL, -- 第三方批次号
	is_other_bank varchar(1) NULL, -- 是否跨行：1 否     2 是
	tel varchar(50) NULL, -- 联系电话
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_czdf_bat_detail PRIMARY KEY (serial_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.serial_id IS '流水号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.bank_name IS '开户行名称';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.payee_id IS '收款人身份证件号码';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.payee_name IS '收款人名称';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.coll_account IS '收款账号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.amt IS '金额';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.remark IS '附言';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.status IS '"处理状态：0:未处理 1:处理中 2:处理成功 3:处理失败 4:处理超时"';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.tran_channel IS '交易渠道号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.bank_acct_no IS '开户行号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.third_batch IS '第三方批次号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.is_other_bank IS '是否跨行：1 否     2 是';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.tel IS '联系电话';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.ryzd IS '冗余字段';
