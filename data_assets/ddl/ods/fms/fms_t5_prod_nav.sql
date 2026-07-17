/*
 * 上游理财系统
 * 表名: crmdm.fms_t5_prod_nav
 * 来源: TB.ddl
 */

-- crmdm.fms_t5_prod_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_nav;

CREATE TABLE crmdm.fms_t5_prod_nav (
	prod_code varchar(32) NOT NULL,
	nav_date bpchar(8) NOT NULL,
	nav numeric(12, 6) NOT NULL,
	total_nav numeric(12, 6) NULL,
	seven_days_income numeric(7, 4) NULL,
	ten_thousand_income_amt numeric(7, 4) NULL,
	expire_cash_amt numeric(16, 2) NULL,
	remark varchar(255) NULL,
	crt_date bpchar(8) NULL,
	crt_time bpchar(6) NULL,
	upd_date bpchar(8) NULL,
	upd_time bpchar(6) NULL,
	income_status bpchar(1) NULL,
	total_income_amt numeric(16, 4) NULL,
	ryzd varchar(1) NULL
);

