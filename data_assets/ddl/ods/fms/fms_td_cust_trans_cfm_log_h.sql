-- crmdm.fms_td_cust_trans_cfm_log_h 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_trans_cfm_log_h;

CREATE TABLE crmdm.fms_td_cust_trans_cfm_log_h (
	back_date varchar(8) NULL, -- 备份历史表日期
	app_serno varchar(32) NULL, -- 交易申请流水号
	cfm_date varchar(8) NULL, -- 交易确认业务日期
	ccy varchar(3) NULL, -- 币种
	app_amt numeric(32, 2) NULL, -- 交易申请金额
	app_vol numeric(32, 2) NULL, -- 交易申请份额
	cfm_amt numeric(32, 2) NULL, -- 交易确认金额
	cfm_vol numeric(32, 2) NULL, -- 交易确认份额
	tano varchar(16) NULL, -- TA代码
	prod_code varchar(32) NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	lrdm_flag bpchar(1) NULL, -- 巨额赎回标识
	app_date varchar(8) NULL, -- 交易申请业务日期
	fnc_trans_acct_no varchar(24) NULL, -- 理财交易账号
	busi_code varchar(3) NULL, -- 业务代码
	ta_acct_no varchar(32) NULL, -- TA账号
	ta_cfm_serno varchar(32) NULL, -- TA确认流水
	busi_finish_flag bpchar(1) NULL, -- 业务过程完全结束标识
	cmms_disct numeric(8, 5) NULL, -- 销售佣金折扣率
	charge numeric(32, 2) NULL, -- 手续费
	agen_fee numeric(32, 2) NULL, -- 代理费
	nav numeric(16, 8) NULL, -- 净值
	ori_app_serno varchar(32) NULL, -- 交易申请流水号原
	ori_cfm_serno varchar(32) NULL, -- TA的原确认流水号
	fee_rate numeric(17, 2) NULL, -- 费率
	bcfee_amt numeric(32, 2) NULL, -- 交易后端收费总额
	distributor_code varchar(32) NULL, -- 销售人代码
	tag_distributor_code varchar(32) NULL, -- 销售人代码对方
	tag_trans_acct_no varchar(24) NULL, -- 对方理财交易账号
	def_div_method bpchar(1) NULL, -- 默认分红方式
	sbcp_intrst numeric(17, 2) NULL, -- 认购利息金额
	tax numeric(17, 2) NULL, -- 税金
	tagt_prod_code varchar(32) NULL, -- 对方产品代码
	tagt_share_class bpchar(1) NULL, -- 对方产品份额类别
	tagt_nav numeric(16, 8) NULL, -- 对方产品净值
	trans_status bpchar(1) NULL, -- 交易状态
	ta_flag bpchar(1) NULL, -- TA发起业务标识
	frozen_cause bpchar(1) NULL, -- 冻结原因
	frozen_ddl varchar(8) NULL, -- 冻结截止日期
	rdm_rsn varchar(32) NULL, -- 强行赎回原因
	rtn_code varchar(30) NULL, -- 返回码
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	cust_manager varchar(20) NULL, -- 客户经理代码
	windup_frozen_amt numeric(32, 2) NULL, -- 清盘冻结金额
	tag_ta_acct_no varchar(32) NULL, -- 对方理财账号（TA账号）
	rtn_desc varchar(256) NULL, -- 返回信息（成功或出错详细信息）
	ta_app_serno varchar(32) NULL, -- TA记录的申请流水号（确认流水中记录的申请流水号）
	originalcfmamount numeric(16, 2) NULL, -- 原确认本金
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_cust_trans_cfm_log_h IS '理财客户交易确认流水表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.back_date IS '备份历史表日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_serno IS '交易申请流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cfm_date IS '交易确认业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ccy IS '币种';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_amt IS '交易申请金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_vol IS '交易申请份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cfm_amt IS '交易确认金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cfm_vol IS '交易确认份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.lrdm_flag IS '巨额赎回标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_date IS '交易申请业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.busi_code IS '业务代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_acct_no IS 'TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_cfm_serno IS 'TA确认流水';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.busi_finish_flag IS '业务过程完全结束标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cmms_disct IS '销售佣金折扣率';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.charge IS '手续费';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.agen_fee IS '代理费';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ori_app_serno IS '交易申请流水号原';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ori_cfm_serno IS 'TA的原确认流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.fee_rate IS '费率';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.bcfee_amt IS '交易后端收费总额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.distributor_code IS '销售人代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tag_distributor_code IS '销售人代码对方';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tag_trans_acct_no IS '对方理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.def_div_method IS '默认分红方式';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.sbcp_intrst IS '认购利息金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tax IS '税金';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tagt_prod_code IS '对方产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tagt_share_class IS '对方产品份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tagt_nav IS '对方产品净值';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.trans_status IS '交易状态';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_flag IS 'TA发起业务标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.frozen_cause IS '冻结原因';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.frozen_ddl IS '冻结截止日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.rdm_rsn IS '强行赎回原因';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.rtn_code IS '返回码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.windup_frozen_amt IS '清盘冻结金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tag_ta_acct_no IS '对方理财账号（TA账号）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.rtn_desc IS '返回信息（成功或出错详细信息）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_app_serno IS 'TA记录的申请流水号（确认流水中记录的申请流水号）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.originalcfmamount IS '原确认本金';
