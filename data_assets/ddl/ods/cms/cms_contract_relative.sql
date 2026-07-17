/*
 * 上游信贷系统
 * 表名: crmdm.cms_contract_relative
 * 来源: TB.ddl
 */

-- crmdm.cms_contract_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_contract_relative;

CREATE TABLE crmdm.cms_contract_relative (
	serialno varchar(40) NOT NULL,
	objecttype varchar(18) NOT NULL,
	objectno varchar(40) NOT NULL,
	relativesum numeric(24, 6) NULL,
	relationstatus varchar(3) NULL,
	addtype varchar(30) NULL
);

