/*
 * 上游信贷系统
 * 表名: crmdm.cms_business_type
 * 来源: TB.ddl
 */

-- crmdm.cms_business_type 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_type;

CREATE TABLE crmdm.cms_business_type (
	typeno varchar(32) NOT NULL,
	sortno varchar(32) NULL,
	typename varchar(80) NULL,
	typesortno varchar(32) NULL,
	subtypecode varchar(32) NULL,
	isinuse varchar(18) NULL,
	basetypeno varchar(32) NULL,
	flowno varchar(80) NULL,
	loanpredetailno varchar(32) NULL,
	vouchtypes varchar(3000) NULL,
	guarantyrate numeric(24, 6) NULL,
	rateleft numeric(24, 6) NULL,
	rateright numeric(24, 6) NULL,
	sumlimit numeric(24, 6) NULL,
	afterloanday numeric NULL,
	indafterloan numeric(24, 6) NULL,
	belongorg varchar(32) NULL,
	approveopinion varchar(250) NULL,
	attribute1 varchar(200) NULL,
	attribute2 varchar(200) NULL,
	attribute3 varchar(200) NULL,
	attribute4 varchar(200) NULL,
	attribute5 varchar(200) NULL,
	attribute6 varchar(200) NULL,
	attribute7 varchar(200) NULL,
	attribute8 varchar(200) NULL,
	attribute9 varchar(200) NULL,
	attribute10 varchar(200) NULL,
	infoset varchar(200) NULL,
	displaytemplet varchar(32) NULL,
	applydetailno varchar(18) NULL,
	approvedetailno varchar(18) NULL,
	contractdetailno varchar(18) NULL,
	attribute11 varchar(80) NULL,
	attribute12 varchar(80) NULL,
	attribute13 varchar(80) NULL,
	attribute14 varchar(80) NULL,
	attribute15 varchar(80) NULL,
	attribute16 varchar(80) NULL,
	attribute17 varchar(80) NULL,
	attribute18 varchar(80) NULL,
	attribute19 varchar(80) NULL,
	attribute20 varchar(80) NULL,
	attribute21 varchar(80) NULL,
	attribute22 varchar(80) NULL,
	attribute23 varchar(80) NULL,
	attribute24 varchar(80) NULL,
	attribute25 varchar(80) NULL,
	offsheetflag varchar(6) NULL,
	configfile varchar(200) NULL,
	remark varchar(200) NULL,
	inputuser varchar(32) NULL,
	inputorg varchar(32) NULL,
	inputtime varchar(20) NULL,
	updateuser varchar(32) NULL,
	updatetime varchar(20) NULL,
	isliquidity varchar(4) NULL,
	isfixed varchar(4) NULL,
	isproject varchar(4) NULL,
	prdremark varchar(2000) NULL,
	linetype varchar(20) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_cms_business_type PRIMARY KEY (typeno)
);

