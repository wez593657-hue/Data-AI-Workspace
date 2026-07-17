/*
 * 上游信贷系统
 * 表名: crmdm.cms_acct_rate_segment
 * 来源: TB.ddl
 */

-- crmdm.cms_acct_rate_segment 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_rate_segment;

CREATE TABLE crmdm.cms_acct_rate_segment (
	serialno varchar(40) NOT NULL,
	objectno varchar(40) NULL,
	objecttype varchar(40) NULL,
	segno numeric NULL,
	segfromdate varchar(10) NULL,
	segtodate varchar(10) NULL,
	segfromstage numeric NULL,
	segtostage numeric NULL,
	segstages numeric NULL,
	termid varchar(20) NULL,
	ratetype varchar(20) NULL,
	rateunit varchar(10) NULL,
	baserategrade varchar(10) NULL,
	baseratetype varchar(10) NULL,
	baserate numeric(12, 8) NULL,
	ratefloattype varchar(10) NULL,
	ratefloat numeric(10, 6) NULL,
	businessrate numeric(12, 8) NULL,
	repricetype varchar(4) NULL,
	repricetermunit varchar(10) NULL,
	repriceterm numeric NULL,
	defaultrepricedate varchar(10) NULL,
	lastrepricedate varchar(10) NULL,
	nextrepricedate varchar(10) NULL,
	remark varchar(400) NULL,
	status varchar(10) NULL,
	segname varchar(120) NULL,
	segtermid varchar(20) NULL,
	yearbaseday numeric NULL,
	transserialno varchar(40) NULL,
	splitmethod varchar(10) NULL,
	accrueinteflag varchar(10) NULL,
	accruecompflag varchar(10) NULL,
	accruefineflag varchar(10) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_cms_acct_rate_segment PRIMARY KEY (serialno)
);

