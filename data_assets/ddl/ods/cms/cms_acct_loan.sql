/*
 * 上游信贷系统
 * 表名: crmdm.cms_acct_loan
 * 来源: TB.ddl
 */

-- crmdm.cms_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_loan;

CREATE TABLE crmdm.cms_acct_loan (
	serialno varchar(40) NOT NULL,
	accountno varchar(40) NULL,
	contractserialno varchar(40) NULL,
	customerid varchar(40) NULL,
	customername varchar(80) NULL,
	businesstype varchar(40) NULL,
	productid varchar(40) NULL,
	specificid varchar(40) NULL,
	versionid varchar(40) NULL,
	currency varchar(10) NULL,
	businesssum numeric(24, 2) NULL,
	putoutdate varchar(10) NULL,
	maturitydate varchar(10) NULL,
	originalmaturitydate varchar(10) NULL,
	operateorgid varchar(40) NULL,
	accountingorgid varchar(32) NULL,
	loanstatus varchar(10) NULL,
	finishdate varchar(10) NULL,
	businessdate varchar(10) NULL,
	lockflag varchar(10) NULL,
	overduedays numeric NULL,
	classifyresult varchar(10) NULL,
	putoutserialno varchar(40) NULL,
	approveserialno varchar(40) NULL,
	applyserialno varchar(40) NULL,
	businessstatus varchar(10) NULL,
	maxoverduedays numeric NULL,
	normalbalance numeric(24, 2) NULL,
	overduebalance numeric(24, 2) NULL,
	accruedinterest numeric(24, 2) NULL,
	overdueinterest numeric(24, 2) NULL,
	principalpenalty numeric(24, 2) NULL,
	interestpenalty numeric(24, 2) NULL,
	overduefee numeric(24, 2) NULL,
	impairmentflag varchar(10) NULL,
	graceinteestamt numeric(24, 2) NULL,
	loanratetermid varchar(20) NULL,
	gracedays numeric NULL,
	currentrpttermid varchar(32) NULL,
	batchno varchar(10) NULL,
	occurtype varchar(10) NULL,
	vouchtype varchar(18) NULL,
	businessloantype varchar(20) NULL,
	lastdaynormalbalance numeric(24, 2) NULL,
	lastdayoverduebalance numeric(24, 2) NULL,
	lastdayaccruedinterest numeric(24, 2) NULL,
	lastdayoverdueinterest numeric(24, 2) NULL,
	lastdayprincipalpenalty numeric(24, 2) NULL,
	lastdayinterestpenalty numeric(24, 2) NULL,
	lastdayoverduefee numeric(24, 2) NULL,
	dongjbho varchar(40) NULL,
	corpuspaymethod varchar(20) NULL,
	autopayflag varchar(20) NULL,
	nextduedate varchar(20) NULL,
	lcatimes numeric(22) NULL,
	guaranteeway varchar(18) NULL,
	basebusinesstype varchar(18) NULL,
	accountflag varchar(10) NULL,
	gjflag varchar(18) NULL,
	dutyfreecode varchar(2) NULL,
	batchflag varchar(10) NULL,
	yzflag varchar(2) NULL,
	iswriteoffaccrualflag varchar(2) NULL,
	loanwriteofftype varchar(10) NULL,
	xwmsswitchstatus varchar(10) NULL,
	intpaymode varchar(2) NULL,
	ryzd varchar(1) NULL,
	CONSTRAINT pk_cms_acct_loan PRIMARY KEY (serialno)
);

