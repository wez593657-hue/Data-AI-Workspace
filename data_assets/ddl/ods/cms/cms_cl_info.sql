/*
 * 上游信贷系统
 * 表名: crmdm.cms_cl_info
 * 来源: TB.ddl
 */

-- crmdm.cms_cl_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_cl_info;

CREATE TABLE crmdm.cms_cl_info (
	lineid varchar(32) NULL,
	cltypeid varchar(32) NULL,
	cltypename varchar(80) NULL,
	applyserialno varchar(32) NULL,
	approveserialno varchar(32) NULL,
	bcserialno varchar(32) NULL,
	linecontractno varchar(32) NULL,
	customerid varchar(32) NULL,
	customername varchar(80) NULL,
	linesum1 numeric(24, 6) NULL,
	linesum2 numeric(24, 6) NULL,
	linesum3 numeric(24, 6) NULL,
	currency varchar(18) NULL,
	lineeffdate varchar(10) NULL,
	lineeffflag varchar(1) NULL,
	putoutdeadline varchar(10) NULL,
	maturitydeadline varchar(10) NULL,
	rotative varchar(18) NULL,
	approvalpolicy varchar(18) NULL,
	freezeflag varchar(1) NULL,
	recentcheck varchar(32) NULL,
	recentcheckstatus varchar(1) NULL,
	checkresult varchar(1) NULL,
	overflowtype varchar(200) NULL,
	inputuser varchar(32) NULL,
	inputorg varchar(32) NULL,
	inputtime varchar(20) NULL,
	updatetime varchar(20) NULL,
	begindate varchar(10) NULL,
	enddate varchar(10) NULL,
	parentlineid varchar(32) NULL,
	useorgid varchar(32) NULL,
	useorgname varchar(80) NULL,
	bailratio numeric(10, 6) NULL,
	businesstype varchar(32) NULL,
	usedsum numeric(24, 6) NULL,
	usablesum numeric(24, 6) NULL,
	calculatetime varchar(20) NULL
);

