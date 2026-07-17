/*
 * 上游信贷系统
 * 表名: crmdm.cms_funds_data
 * 来源: TB.ddl
 */

-- crmdm.cms_funds_data 定义

-- Drop table

-- DROP TABLE crmdm.cms_funds_data;

CREATE TABLE crmdm.cms_funds_data (
	serialno varchar(32) NOT NULL,
	xingming varchar(120) NULL,
	zjlx varchar(2) NULL,
	zjhm varchar(18) NULL,
	dwmc varchar(255) NULL,
	dwzh varchar(100) NULL,
	khrq varchar(30) NULL,
	grzhzt varchar(2) NULL,
	grjcjs numeric(18, 2) NULL,
	grjcbl numeric(4, 2) NULL,
	yje numeric(18, 2) NULL,
	jzny varchar(10) NULL,
	grzhye numeric(18, 2) NULL,
	fwzj numeric(18, 2) NULL,
	htdkje numeric(18, 2) NULL,
	dkqs int4 NULL,
	zxll numeric(8, 7) NULL,
	yhke numeric(18, 2) NULL,
	yqzt varchar(6) NULL,
	dkye numeric(18, 2) NULL,
	inputdate varchar(10) NULL
);

