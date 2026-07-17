/*
 * 上游信贷系统
 * 表名: crmdm.cms_customer_info
 * 来源: TB.ddl
 */

-- crmdm.cms_customer_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_info;

CREATE TABLE crmdm.cms_customer_info (
	customerid varchar(40) NOT NULL,
	customername varchar(80) NULL,
	customertype varchar(20) NULL,
	certtype varchar(20) NULL,
	certid varchar(40) NULL,
	customerpassword varchar(20) NULL,
	inputorgid varchar(32) NULL,
	inputuserid varchar(32) NULL,
	inputdate varchar(10) NULL,
	remark varchar(250) NULL,
	mfcustomerid varchar(40) NULL,
	status varchar(20) NULL,
	belonggroupid varchar(40) NULL,
	channel varchar(18) NULL,
	loancardno varchar(32) NULL,
	customerscale varchar(20) NULL,
	nationcode varchar(40) NULL,
	forbidstatus varchar(12) NULL,
	counterpartytype varchar(10) NULL,
	taxpayertype varchar(10) NULL,
	mystocker varchar(10) NULL,
	oldmfcustomerid varchar(40) NULL,
	isrelacustomer varchar(10) NULL,
	custriskleve varchar(10) NULL,
	checkbasedate varchar(10) NULL,
	creditsum numeric(24, 4) NULL,
	classifyresult varchar(200) NULL,
	linetype varchar(32) NULL,
	titularsum2 numeric(24, 4) NULL,
	titularsum1 numeric(24, 4) NULL,
	nominalcreditsum numeric(24, 4) NULL,
	nominalcreditbalance numeric(24, 4) NULL,
	exposurecreditsum numeric(24, 4) NULL,
	exposurecreditbalance numeric(24, 4) NULL,
	smesystemflag varchar(4) NULL,
	finalsmeflag varchar(4) NULL,
	checkbaseriskdate varchar(20) NULL,
	onemtotenmflag varchar(10) NULL,
	onemtotenmtime varchar(40) NULL,
	morethantenmflag varchar(10) NULL,
	morethantenmtime varchar(40) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_cms_customer_info PRIMARY KEY (customerid)
);

