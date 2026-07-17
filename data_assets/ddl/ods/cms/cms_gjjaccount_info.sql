/*
 * 上游信贷系统
 * 表名: crmdm.cms_gjjaccount_info
 * 来源: TB.ddl
 */

-- crmdm.cms_gjjaccount_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_gjjaccount_info;

CREATE TABLE crmdm.cms_gjjaccount_info (
	relativeno varchar(40) NULL,
	certtype varchar(8) NULL,
	authpersonid varchar(18) NULL,
	etpscode varchar(32) NULL,
	etpsname varchar(128) NULL,
	depmonth varchar(12) NULL,
	depamt varchar(18) NULL,
	etpsdepamt varchar(18) NULL,
	indvdepamt varchar(18) NULL,
	etpsdeprat varchar(6) NULL,
	indvdeprat varchar(6) NULL,
	opendate varchar(12) NULL,
	lastyearbal varchar(18) NULL,
	thisyearbal varchar(18) NULL,
	acctflag varchar(8) NULL,
	ryzd varchar(1) NULL
);

