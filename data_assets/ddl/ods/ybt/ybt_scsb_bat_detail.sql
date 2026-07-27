-- crmdm.ybt_scsb_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ybt_scsb_bat_detail;

CREATE TABLE crmdm.ybt_scsb_bat_detail (
	bat_no varchar(18) NOT NULL, -- 社保代发批次号
	det_no varchar(10) NOT NULL, -- 序号
	sb_no varchar(20) NOT NULL, -- 个人编号
	"name" varchar(400) NULL, -- 银行户名
	acct varchar(30) NOT NULL, -- 银行账号
	id_no varchar(18) NULL, -- 证件号码
	id_type varchar(2) NULL, -- 证件类型
	amt numeric(17, 2) NOT NULL, -- 拨付金额
	memo varchar(200) NULL, -- 备注
	bank_no varchar(20) NULL, -- 银行联行号
	sb_serial varchar(20) NULL, -- 业务财务流水号
	payee_type varchar(2) NOT NULL, -- 支付对象类型 1:单位 2:个人
	is_other_bank varchar(2) NOT NULL, -- 支付类型 1:本行 2:他行
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	pay_send_serial varchar(32) NULL, -- 支付系统渠道流水号
	pay_ref_serial varchar(32) NULL, -- 支付系统结果账参考流水号
	rst_memo varchar(512) NULL, -- 交易结果描述
	status varchar(1) NOT NULL, -- 交易状态
	re_status varchar(1) NOT NULL, -- 回盘状态
	remark varchar(128) NULL, -- 摘要
	addtional varchar(128) NULL, -- 附言
	tran_channel varchar(10) NULL, -- 交易渠道
	back_status varchar(1) NULL, -- 是否退汇处理  1.有做退汇处理
	bank_name varchar(400) NULL, -- 姓名
	ignore_limit varchar(1) NULL, -- 是否忽略最高限额  1 是   0 否
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_scsb_bat_detail PRIMARY KEY (bat_no, det_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.bat_no IS '社保代发批次号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.det_no IS '序号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.sb_no IS '个人编号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail."name" IS '银行户名';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.acct IS '银行账号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.id_no IS '证件号码';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.amt IS '拨付金额';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.memo IS '备注';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.bank_no IS '银行联行号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.sb_serial IS '业务财务流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.payee_type IS '支付对象类型 1:单位 2:个人';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.is_other_bank IS '支付类型 1:本行 2:他行';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.pay_send_serial IS '支付系统渠道流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.pay_ref_serial IS '支付系统结果账参考流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.status IS '交易状态';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.re_status IS '回盘状态';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.remark IS '摘要';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.addtional IS '附言';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.tran_channel IS '交易渠道';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.back_status IS '是否退汇处理  1.有做退汇处理';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.bank_name IS '姓名';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.ignore_limit IS '是否忽略最高限额  1 是   0 否';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.ryzd IS '冗余字段';
