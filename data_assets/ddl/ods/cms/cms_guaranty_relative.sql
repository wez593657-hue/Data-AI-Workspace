/*
 * 上游信贷系统
 * 表名: crmdm.cms_guaranty_relative
 * 来源: TB.ddl
 */

-- crmdm.cms_guaranty_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_guaranty_relative;

CREATE TABLE crmdm.cms_guaranty_relative (
	objecttype varchar(30) NOT NULL,
	objectno varchar(40) NOT NULL,
	contractno varchar(40) NOT NULL,
	guarantyid varchar(40) NOT NULL,
	channel varchar(18) NULL,
	status varchar(18) NULL,
	othersrightid varchar(32) NULL,
	guarantysum varchar(32) NULL,
	payorder varchar(18) NULL,
	"type" varchar(18) NULL,
	relationstatus varchar(3) NULL,
	describea varchar(250) NULL
);

