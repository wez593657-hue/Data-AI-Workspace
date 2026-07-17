/*
 * 上游理财系统
 * 表名: crmdm.fms_td_prod_nav
 * 来源: TB.ddl
 */

-- crmdm.fms_td_prod_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_nav;

CREATE TABLE crmdm.fms_td_prod_nav (
	tano varchar(16) NOT NULL,
	prod_code varchar(32) NOT NULL,
	share_class bpchar(1) NULL,
	net_value_type varchar(1) NOT NULL,
	nav_date varchar(8) NOT NULL,
	nav numeric(16, 8) NULL,
	total_nav numeric(16, 8) NULL,
	ten_thousand_income_amt numeric(16, 8) NULL,
	seven_days_income_rate numeric(17, 8) NULL,
	import_date varchar(8) NULL,
	legal_code varchar(32) NULL,
	dayclientratio numeric(16, 8) NULL,
	monthclientratio numeric(16, 8) NULL,
	quarterclientratio numeric(16, 8) NULL,
	semiannualclientratio numeric(16, 8) NULL,
	yearclientratio numeric(16, 8) NULL,
	cycleclientratio numeric(16, 8) NULL,
	twoyearclientratio numeric(16, 8) NULL,
	threeyearclientratio numeric(16, 8) NULL,
	tonowclientratio numeric(16, 8) NULL,
	remark varchar(200) NULL,
	adjustednav numeric(16, 2) NULL,
	ryzd varchar(1) NULL
);

