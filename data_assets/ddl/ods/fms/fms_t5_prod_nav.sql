-- crmdm.fms_t5_prod_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_nav;

CREATE TABLE crmdm.fms_t5_prod_nav (
	prod_code varchar(32) NOT NULL, -- 产品代码
	nav_date bpchar(8) NOT NULL, -- 净值日期
	nav numeric(12, 6) NOT NULL, -- 单位净值
	total_nav numeric(12, 6) NULL, -- 累计净值
	seven_days_income numeric(7, 4) NULL, -- 7日年化收益率
	ten_thousand_income_amt numeric(7, 4) NULL, -- 万份收益
	expire_cash_amt numeric(16, 2) NULL, -- 到期总金额
	remark varchar(255) NULL, -- 备注
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	income_status bpchar(1) NULL, -- 收益状态;（0未处理，1;处理中，2 已分配）
	total_income_amt numeric(16, 4) NULL, -- 收益总额
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_t5_prod_nav IS '产品净值信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_nav.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.nav IS '单位净值';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.total_nav IS '累计净值';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.seven_days_income IS '7日年化收益率';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.ten_thousand_income_amt IS '万份收益';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.expire_cash_amt IS '到期总金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.income_status IS '收益状态;（0未处理，1;处理中，2 已分配）';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.total_income_amt IS '收益总额';
