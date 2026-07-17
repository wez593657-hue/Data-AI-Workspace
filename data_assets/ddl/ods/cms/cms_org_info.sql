/*
 * 上游信贷系统
 * 表名: crmdm.cms_org_info
 * 来源: TB.ddl
 */

-- crmdm.cms_org_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_org_info;

CREATE TABLE crmdm.cms_org_info (
	orgid varchar(32) NULL,
	sortno varchar(32) NULL,
	orgname varchar(80) NULL,
	orglevel varchar(32) NULL,
	orgproperty varchar(250) NULL,
	relativeorgid varchar(32) NULL,
	bankid varchar(32) NULL,
	banklicense varchar(32) NULL,
	businesslicense varchar(32) NULL,
	belongarea varchar(18) NULL,
	orgclass varchar(18) NULL,
	zipcode varchar(18) NULL,
	mainframeorgid varchar(32) NULL,
	mainframeexgid varchar(32) NULL,
	orgcode varchar(32) NULL,
	status varchar(80) NULL,
	orgoldname varchar(80) NULL,
	setupdate varchar(10) NULL,
	orgadd varchar(80) NULL,
	principal varchar(10) NULL,
	orgtel varchar(80) NULL,
	branchnum numeric(22) NULL,
	cmnum numeric(22) NULL,
	businesshours varchar(80) NULL,
	inputorg varchar(32) NULL,
	inputuser varchar(32) NULL,
	inputdate varchar(20) NULL,
	inputtime varchar(20) NULL,
	updateuser varchar(32) NULL,
	updatetime varchar(20) NULL,
	updatedate varchar(20) NULL,
	remark varchar(250) NULL,
	belongorgid varchar(32) NULL,
	hostno varchar(10) NULL,
	vitualserialno numeric(22) NULL,
	vitualid varchar(32) NULL,
	corporgid varchar(20) NULL,
	corporgname varchar(32) NULL,
	orgfax varchar(32) NULL,
	clearbankno varchar(32) NULL,
	accountingorgflag varchar(1) NULL,
	spesubbranchflag varchar(1) NULL,
	corporateorgname varchar(60) NULL,
	ryzd varchar(1) NULL
);

