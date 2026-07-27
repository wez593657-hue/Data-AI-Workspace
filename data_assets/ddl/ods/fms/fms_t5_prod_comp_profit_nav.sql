-- crmdm.fms_t5_prod_comp_profit_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_comp_profit_nav;

CREATE TABLE crmdm.fms_t5_prod_comp_profit_nav (
	prod_code varchar(32) NOT NULL, -- 产品代码
	benchmarks numeric(7, 4) NULL, -- 业绩比较基准
	float_manage_rate numeric(7, 4) NULL, -- 浮动管理费率
	windup_type bpchar(1) NULL, -- 清盘方式;（0-净值清盘;1-总金额清盘）
	windup_amt numeric(16, 2) NULL, -- 清盘总金额
	div_delivery_days numeric NULL, -- 分红交收天数
	div_chg_flag bpchar(1) NULL, -- 分红方式是否可修改;（0-否1-是）
	def_div_method bpchar(1) DEFAULT '1'::bpchar NULL, -- 默认分红方式;（0-红利再投1-现金分红）
	pay_nav_day numeric NULL, -- 兑付净值取值日
	min_benchmarks numeric(7, 4) NULL, -- 最小业绩比较基准
	max_benchmarks numeric(7, 4) NULL, -- 最大业绩比较基准
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_comp_profit_nav PRIMARY KEY (prod_code)
);
COMMENT ON TABLE crmdm.fms_t5_prod_comp_profit_nav IS '产品净值组件信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.benchmarks IS '业绩比较基准';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.float_manage_rate IS '浮动管理费率';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.windup_type IS '清盘方式;（0-净值清盘;1-总金额清盘）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.windup_amt IS '清盘总金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.div_delivery_days IS '分红交收天数';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.div_chg_flag IS '分红方式是否可修改;（0-否1-是）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.def_div_method IS '默认分红方式;（0-红利再投1-现金分红）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.pay_nav_day IS '兑付净值取值日';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.min_benchmarks IS '最小业绩比较基准';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.max_benchmarks IS '最大业绩比较基准';
