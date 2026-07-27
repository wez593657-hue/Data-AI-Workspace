-- crmdm.fms_td_cust_vol 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_vol;

CREATE TABLE crmdm.fms_td_cust_vol (
	fnc_trans_acct_no varchar(24) NULL, -- 理财交易账号
	ta_acct_no varchar(32) NULL, -- TA账号
	tano varchar(16) NULL, -- TA代码
	prod_code varchar(32) NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	cust_no varchar(32) NULL, -- 客户号
	total_amt numeric(32, 2) NULL, -- 总金额
	total_vol numeric(32, 2) NULL, -- 总份额
	trans_frozen_vol numeric(32, 2) NULL, -- 交易冻结份额
	elisor_frozen_vol numeric(32, 2) NULL, -- 司法冻结份额
	abn_frozen_vol numeric(32, 2) NULL, -- 质押冻结份额
	ta_frozen_vol numeric(32, 2) NULL, -- TA冻结份额
	undistribute_monetary_income numeric(32, 2) NULL, -- 货币式理财未付收益金额
	hold_cost numeric(32, 2) NULL, -- 持仓成本
	upd_date varchar(8) NULL, -- 更新日期
	upd_time varchar(6) NULL, -- 更新时间
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	attorn_out_vol numeric(32, 2) NULL, -- 转让转出份额
	attorn_into_vol numeric(32, 2) NULL, -- 转让转入份额
	attorn_into_frozen_vol numeric(32, 2) NULL, -- 转如冻结份额
	trans_redem_vol numeric(32, 2) NULL, -- 实时赎回待TA确认份额
	total_buy_amt numeric(32, 2) NULL, -- 累计购买金额（确认金额）
	total_buy_vol numeric(32, 2) NULL, -- 累计购买份额（确认份额）
	total_redeem_amt numeric(32, 2) NULL, -- 累计赎回金额（确认金额）
	total_redeem_vol numeric(32, 2) NULL, -- 累计赎回份额（确认份额）
	total_income_amt numeric(32, 2) NULL, -- 累计收益金额（即143总确认金额，不区分分红方式）
	total_income_cash numeric(32, 2) NULL, -- 累积现金分红总金额
	total_income_reinvestment numeric(32, 2) NULL, -- 累积红利再投总份额
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_cust_vol IS '理财客户份额表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_cust_vol.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.ta_acct_no IS 'TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_amt IS '总金额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_vol IS '总份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.trans_frozen_vol IS '交易冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.elisor_frozen_vol IS '司法冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.abn_frozen_vol IS '质押冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.ta_frozen_vol IS 'TA冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.undistribute_monetary_income IS '货币式理财未付收益金额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.hold_cost IS '持仓成本';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.attorn_out_vol IS '转让转出份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.attorn_into_vol IS '转让转入份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.attorn_into_frozen_vol IS '转如冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.trans_redem_vol IS '实时赎回待TA确认份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_buy_amt IS '累计购买金额（确认金额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_buy_vol IS '累计购买份额（确认份额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_redeem_amt IS '累计赎回金额（确认金额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_redeem_vol IS '累计赎回份额（确认份额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_income_amt IS '累计收益金额（即143总确认金额，不区分分红方式）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_income_cash IS '累积现金分红总金额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_income_reinvestment IS '累积红利再投总份额';
