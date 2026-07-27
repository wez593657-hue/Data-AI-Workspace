-- crmdm.fms_t5_cust_vol 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_cust_vol;

CREATE TABLE crmdm.fms_t5_cust_vol (
	cust_no varchar(20) NOT NULL, -- 客户号
	fnc_trans_acct_no varchar(17) NOT NULL, -- 理财交易账号
	prod_code varchar(32) NOT NULL, -- 产品代码
	distributor_code varchar(14) DEFAULT '0 '::varchar NOT NULL, -- 销售商代码（本行销售填0）
	self_fnc_acct_no bpchar(12) NULL, -- 自有理财业务账号;老理财系统保留
	total_vol numeric(16, 2) NOT NULL, -- 总份额
	buy_amt numeric(16, 2) NOT NULL, -- 购买金额
	trans_frozen_vol numeric(16, 2) NULL, -- 赎回冻结
	abnm_frozen_vol numeric(16, 2) NULL, -- 异常冻结份额
	redeem_amt numeric(16, 2) NOT NULL, -- 累计赎回金额
	unconvert_income numeric(20, 6) NULL, -- 未结转收益
	convert_income numeric(20, 6) NOT NULL, -- 已结转收益;累计值
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	cust_manager varchar(20) NULL, -- 客户经理代码
	fm_manager varchar(20) NULL, -- 理财经理代码
	last_vol_change_date bpchar(8) NOT NULL, -- 份额最后变动日
	elisor_frozen_vol numeric(16, 2) NULL, -- 司法冻结份额
	frozen_vol numeric(16, 2) NULL, -- 质押冻结份额
	acc_income numeric(16, 2) NULL, -- 累计收益
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_cust_vol PRIMARY KEY (cust_no, fnc_trans_acct_no, prod_code, distributor_code)
);
CREATE INDEX fms_t5_cust_vol_idx01 ON crmdm.fms_t5_cust_vol USING btree (fnc_trans_acct_no, prod_code);
COMMENT ON TABLE crmdm.fms_t5_cust_vol IS '客户份额汇总表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_cust_vol.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.distributor_code IS '销售商代码（本行销售填0）';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.self_fnc_acct_no IS '自有理财业务账号;老理财系统保留';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.total_vol IS '总份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.buy_amt IS '购买金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.trans_frozen_vol IS '赎回冻结';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.abnm_frozen_vol IS '异常冻结份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.redeem_amt IS '累计赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.unconvert_income IS '未结转收益';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.convert_income IS '已结转收益;累计值';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.fm_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.last_vol_change_date IS '份额最后变动日';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.elisor_frozen_vol IS '司法冻结份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.frozen_vol IS '质押冻结份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.acc_income IS '累计收益';
