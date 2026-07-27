-- crmdm.uepp_pay_mct_settle_account 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_settle_account;

CREATE TABLE crmdm.uepp_pay_mct_settle_account (
	mct_id varchar(40) NOT NULL, -- 商户号
	acct_type varchar(2) NULL, -- 账户类型0：对公户1：对私户2：存折
	bank_account varchar(50) NULL, -- 结算账号
	bank_acct_name varchar(100) NULL, -- 开户户名
	provice varchar(10) NULL, -- 开户省分  非本行卡时填写
	city varchar(10) NULL, -- 开户城市 非本行卡时填写
	open_bankno varchar(20) NULL, -- 开户支行行号 非本行卡时填写
	open_bankname varchar(60) NULL, -- 开户支行名称 非本行卡时填写
	is_self varchar(1) NULL, -- 是否本行户0:本行账户1:非本行账户
	cert_phone varchar(11) NULL, -- 银行预留电话
	cert_type varchar(2) NULL, -- 开户证件类型01-身份证；02-港澳通行证；03-台湾通行证；04-护照；05-其他
	cert_no varchar(50) NULL, -- 证件号码
	status varchar(1) NULL, -- 状态 0-正常（可交易） 1-未生效 2-冻结 3-冻结(涉案账户) 9-作废
	remark varchar(100) NULL, -- 摘要
	channel varchar(40) NOT NULL, -- 支付通道（统一一个账户，默认all）
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	check_status varchar(2) NULL, -- 审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过
	check_task_id varchar(40) NULL, -- 当前审核任务ID
	is_default varchar(1) NULL, -- 类型：1-共用默认的清算账户 0-独有清算账号  （后台不需要给前台转码）
	cust_no varchar(32) NULL, -- 核心客户号
	cust_cn_name varchar(500) NULL, -- 客户中文名
	acc_bal varchar(40) NULL, -- 清算账号余额
	old_cust_no varchar(40) NULL, -- 原客户号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_settle_account PRIMARY KEY (mct_id, channel)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.mct_id IS '商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.acct_type IS '账户类型0：对公户1：对私户2：存折';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.bank_account IS '结算账号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.bank_acct_name IS '开户户名';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.provice IS '开户省分  非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.city IS '开户城市 非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.open_bankno IS '开户支行行号 非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.open_bankname IS '开户支行名称 非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.is_self IS '是否本行户0:本行账户1:非本行账户';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cert_phone IS '银行预留电话';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cert_type IS '开户证件类型01-身份证；02-港澳通行证；03-台湾通行证；04-护照；05-其他';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cert_no IS '证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.status IS '状态 0-正常（可交易） 1-未生效 2-冻结 3-冻结(涉案账户) 9-作废';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.remark IS '摘要';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.channel IS '支付通道（统一一个账户，默认all）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.check_status IS '审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.check_task_id IS '当前审核任务ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.is_default IS '类型：1-共用默认的清算账户 0-独有清算账号  （后台不需要给前台转码）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cust_no IS '核心客户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cust_cn_name IS '客户中文名';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.acc_bal IS '清算账号余额';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.old_cust_no IS '原客户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.ryzd IS '冗余字段';
