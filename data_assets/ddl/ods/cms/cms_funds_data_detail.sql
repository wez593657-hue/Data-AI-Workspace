/*
 * 上游信贷系统
 * 表名: crmdm.cms_funds_data_detail
 * 来源: TB.ddl
 */

-- crmdm.cms_funds_data_detail 定义

-- Drop table

-- DROP TABLE crmdm.cms_funds_data_detail;

CREATE TABLE crmdm.cms_funds_data_detail (
	serialno varchar(32) NOT NULL,
	relativeserialno varchar(32) NOT NULL,
	zhaiyao varchar(50) NULL,
	jkfse numeric(24, 6) NULL
);

