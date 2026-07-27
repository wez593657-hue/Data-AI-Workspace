-- crmdm.mbk_mkp_rebat_recode 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_rebat_recode;

CREATE TABLE crmdm.mbk_mkp_rebat_recode (
	acti_no varchar(32) NOT NULL, -- 折扣活动编号
	cust_no varchar(32) NULL, -- 客户号
	user_time varchar(32) NULL, -- 使用时间
	sence_code varchar(16) NULL, -- 使用场景码
	rebat_value numeric(22, 2) NULL, -- 折扣金额
	status bpchar(1) NULL, -- 记录状态(0-未使用  1-已使用  2-已对账  3-已失效)
	recode_no varchar(32) NOT NULL, -- 记录编号
	trans_amt numeric(22, 2) NULL, -- 交易金额
	payed_value numeric(22, 2) NULL, -- 客户实际支付金额
	refund_remark varchar(3000) NULL, -- 退款备注
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_rebat_recode PRIMARY KEY (recode_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.acti_no IS '折扣活动编号';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.user_time IS '使用时间';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.sence_code IS '使用场景码';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.rebat_value IS '折扣金额';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.status IS '记录状态(0-未使用  1-已使用  2-已对账  3-已失效)';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.recode_no IS '记录编号';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.trans_amt IS '交易金额';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.payed_value IS '客户实际支付金额';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.refund_remark IS '退款备注';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.ryzd IS '冗余字段';
