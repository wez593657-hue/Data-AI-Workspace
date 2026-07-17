/*
 * 上游理财系统
 * 表名: crmdm.fms_t5_prod_comp_profit_nav
 * 来源: TB.ddl
 */

-- crmdm.fms_t5_prod_comp_profit_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_comp_profit_nav;

CREATE TABLE crmdm.fms_t5_prod_comp_profit_nav (
	prod_code varchar(32) NOT NULL,
	benchmarks numeric(7, 4) NULL,
	float_manage_rate numeric(7, 4) NULL,
	windup_type bpchar(1) NULL,
	windup_amt numeric(16, 2) NULL,
	div_delivery_days numeric NULL,
	div_chg_flag bpchar(1) NULL,
	def_div_method bpchar(1) DEFAULT '1'::bpchar NULL,
	pay_nav_day numeric NULL,
	min_benchmarks numeric(7, 4) NULL,
	max_benchmarks numeric(7, 4) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_comp_profit_nav PRIMARY KEY (prod_code)
);

