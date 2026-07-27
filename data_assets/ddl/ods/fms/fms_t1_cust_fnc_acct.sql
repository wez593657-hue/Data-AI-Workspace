-- crmdm.fms_t1_cust_fnc_acct 定义

-- Drop table

-- DROP TABLE crmdm.fms_t1_cust_fnc_acct;

CREATE TABLE crmdm.fms_t1_cust_fnc_acct (
	fnc_trans_acct_no varchar(17) NULL, -- 理财交易账号
	cust_no varchar(20) NULL, -- 客户号
	card_type varchar(8) NULL, -- 卡类型
	card_no varchar(32) NULL, -- 介质号
	acct_no varchar(32) NULL, -- 银行账号
	acct_nm varchar(128) NULL, -- 银行账号名称
	sub_acct_no varchar(32) NULL, -- 子银行账号
	trans_pwd varchar(64) NULL, -- 交易密码
	cur varchar(8) NULL, -- 币种
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型
	acct_status bpchar(1) NULL, -- 账户状态
	bank_code varchar(20) NULL, -- 银行代码-登记总行
	branch_code varchar(20) NULL, -- 分行代码-登记分行
	sub_branch_code varchar(20) NULL, -- 网点代码-登记网点
	inputuser varchar(20) NULL, -- 录入柜员
	iss_bank_code varchar(20) NULL, -- 发卡银行
	iss_branch_code varchar(20) NULL, -- 发卡分行
	iss_sub_branch_code varchar(20) NULL, -- 发卡网点
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	inv_date bpchar(8) NULL, -- 注销日期
	inv_time bpchar(6) NULL, -- 注销时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	tradingmethod varchar(3) NULL, -- 签约/登记渠道
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.fms_t1_cust_fnc_acct IS '客户理财交易账号表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.card_type IS '卡类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.card_no IS '介质号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.acct_nm IS '银行账号名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.sub_acct_no IS '子银行账号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.trans_pwd IS '交易密码';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cur IS '币种';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cust_card_type IS '客户卡类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.acct_status IS '账户状态';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.bank_code IS '银行代码-登记总行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.branch_code IS '分行代码-登记分行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.sub_branch_code IS '网点代码-登记网点';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.iss_bank_code IS '发卡银行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.iss_branch_code IS '发卡分行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.iss_sub_branch_code IS '发卡网点';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.inv_date IS '注销日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.inv_time IS '注销时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.tradingmethod IS '签约/登记渠道';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.ryzd IS '冗余字段';
