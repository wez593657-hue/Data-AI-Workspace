/*
 * 上游信贷系统
 * 表名: crmdm.cms_customer_relative
 * 来源: TB.ddl
 */

-- crmdm.cms_customer_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_relative;

CREATE TABLE crmdm.cms_customer_relative (
	customerid varchar(40) NULL,
	relativeid varchar(32) NULL,
	relationship varchar(18) NULL,
	customername varchar(80) NULL,
	certtype varchar(18) NULL,
	certid varchar(40) NULL,
	fictitiousperson varchar(80) NULL,
	currencytype varchar(18) NULL,
	investmentsum numeric(24, 6) NULL,
	oughtsum numeric(24, 6) NULL,
	investmentprop numeric(10, 6) NULL,
	investdate varchar(10) NULL,
	duty varchar(18) NULL,
	telephone varchar(32) NULL,
	inputorgid varchar(80) NULL,
	inputuserid varchar(80) NULL,
	inputdate varchar(10) NULL,
	updatedate varchar(10) NULL,
	remark varchar(200) NULL,
	sex varchar(18) NULL,
	birthday varchar(10) NULL,
	sino varchar(32) NULL,
	familyadd varchar(200) NULL,
	familyzip varchar(32) NULL,
	eduexperience varchar(18) NULL,
	investyield numeric(24, 6) NULL,
	holddate varchar(10) NULL,
	engageterm numeric(22) NULL,
	holdstock varchar(200) NULL,
	loancardno varchar(32) NULL,
	effstatus varchar(1) NULL,
	customertype varchar(10) NULL,
	describea varchar(350) NULL,
	actualcontroller varchar(10) NULL,
	ecifid varchar(20) NULL
);

