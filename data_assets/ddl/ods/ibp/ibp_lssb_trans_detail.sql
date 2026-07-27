-- crmdm.ibp_lssb_trans_detail 定义

-- Drop table

-- DROP TABLE crmdm.ibp_lssb_trans_detail;

CREATE TABLE crmdm.ibp_lssb_trans_detail (
	plat_serial varchar(20) NOT NULL, -- 平台流水号
	tran_code varchar(8) NULL, -- 交易码
	batch_no varchar(18) NULL, -- 批次号
	id varchar(32) NULL, -- 社保流水号
	batch_message varchar(128) NULL, -- 批次描述
	"type" varchar(3) NULL, -- 险种
	branch_code varchar(8) NULL, -- 经办机构编码
	soc_no varchar(20) NULL, -- 个人编码/单位编码
	idno varchar(20) NOT NULL, -- 身份证号
	"name" varchar(100) NULL, -- 姓名/单位名称
	billno varchar(32) NOT NULL, -- 社保单据号
	bank_code varchar(8) NULL, -- 交易银行
	pboc_code varchar(16) NULL, -- 人行网点编号
	pboc_name varchar(128) NULL, -- 人行网点名称
	acct_name varchar(100) NULL, -- 户名
	acct_no varchar(32) NULL, -- 银行账号
	socs_branch_code varchar(8) NULL, -- 社保经办银行
	socs_acct_name varchar(100) NULL, -- 社保经办户名
	socs_acct_no varchar(32) NULL, -- 社保经办银行账号
	date_no varchar(10) NULL, -- 期号
	tran_amt numeric(12, 2) NULL, -- 交易金额
	remark varchar(100) NULL, -- 摘要说明
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	rst_memo varchar(500) NULL, -- 交易结果描述
	status varchar(1) NULL, -- 交易状态0:未处理 1:处理中 2:处理成功 3:处理失败败 4:处理超时
	tran_channel varchar(32) NULL, -- 交易渠道号
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.plat_serial IS '平台流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.tran_code IS '交易码';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.id IS '社保流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.batch_message IS '批次描述';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail."type" IS '险种';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.branch_code IS '经办机构编码';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.soc_no IS '个人编码/单位编码';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.idno IS '身份证号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail."name" IS '姓名/单位名称';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.billno IS '社保单据号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.bank_code IS '交易银行';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.pboc_code IS '人行网点编号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.pboc_name IS '人行网点名称';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.acct_name IS '户名';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.socs_branch_code IS '社保经办银行';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.socs_acct_name IS '社保经办户名';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.socs_acct_no IS '社保经办银行账号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.date_no IS '期号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.tran_amt IS '交易金额';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.remark IS '摘要说明';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.status IS '交易状态0:未处理 1:处理中 2:处理成功 3:处理失败败 4:处理超时';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.tran_channel IS '交易渠道号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.ryzd IS '冗余字段';
