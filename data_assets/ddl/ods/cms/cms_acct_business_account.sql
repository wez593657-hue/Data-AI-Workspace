/*
 * 上游信贷系统
 * 表名: crmdm.cms_acct_business_account
 * 来源: TB.ddl
 */

-- crmdm.cms_acct_business_account 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_business_account;

CREATE TABLE crmdm.cms_acct_business_account (
	serialno varchar(40) NOT NULL,
	objecttype varchar(40) NULL,
	objectno varchar(40) NULL,
	accountindicator varchar(10) NULL,
	priorityflag varchar(10) NULL,
	accountflag varchar(10) NULL,
	accounttype varchar(10) NULL,
	accountno varchar(40) NULL,
	accountcurrency varchar(10) NULL,
	accountname varchar(80) NULL,
	accountorgid varchar(32) NULL,
	status varchar(10) NULL,
	mfcustomerid varchar(32) NULL,
	suoshudx varchar(12) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_cms_acct_business_account PRIMARY KEY (serialno)
);

