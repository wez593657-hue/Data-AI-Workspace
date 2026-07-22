/*
 * 上游信贷系统
 * 表名: crmdm.cms_acct_payment_schedule
 * 来源: TB.ddl
 */

-- crmdm.cms_acct_payment_schedule 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_payment_schedule;

CREATE TABLE crmdm.cms_acct_payment_schedule (
    serialno varchar(40) NOT NULL,
    parentserialno varchar(40) NULL,
    objecttype varchar(40) NULL,
    objectno varchar(40) NULL,
    relativeobjecttype varchar(40) NULL,
    relativeobjectno varchar(40) NULL,
    periodno int4 NULL,
    paydate varchar(10) NULL,
    pstype varchar(10) NULL,
    payitemcode varchar(10) NULL,
    intedate varchar(10) NULL,
    holidayintedate varchar(10) NULL,
    graceintedate varchar(10) NULL,
    settledate varchar(10) NULL,
    autopayflag varchar(10) NULL,
    currency varchar(10) NULL,
    fixpayprincipalamt numeric(24,
    2) NULL,
    fixpayinstalmentamt numeric(24,
    2) NULL,
    payprincipalamt numeric(24,
    2) DEFAULT 0.00 NULL,
    actualpayprincipalamt numeric(24,
    2) DEFAULT 0.00 NULL,
    waiveprincipalamt numeric(24,
    2) DEFAULT 0.00 NULL,
    principalbalance numeric(24,
    2) DEFAULT 0.00 NULL,
    payinterestamt numeric(24,
    2) DEFAULT 0.00 NULL,
    actualpayinterestamt numeric(24,
    2) DEFAULT 0.00 NULL,
    waiveinterestamt numeric(24,
    2) DEFAULT 0.00 NULL,
    payprincipalpenaltyamt numeric(24,
    2) DEFAULT 0.00 NULL,
    actualpayprincipalpenaltyamt numeric(24,
    2) DEFAULT 0.00 NULL,
    waiveprincipalpenaltyamt numeric(24,
    2) DEFAULT 0.00 NULL,
    payinterestpenaltyamt numeric(24,
    2) DEFAULT 0.00 NULL,
    actualpayinterestpenaltyamt numeric(24,
    2) DEFAULT 0.00 NULL,
    waiveinterestpenaltyamt numeric(24,
    2) DEFAULT 0.00 NULL,
    status varchar(10) NULL,
    finishdate varchar(10) NULL,
    remark varchar(400) NULL,
    direction varchar(10) NULL,
    payfeeamt numeric(24,
    2) DEFAULT 0.00 NULL,
    actualpayfeeamt numeric(24,
    2) DEFAULT 0.00 NULL,
    waivefeeamt numeric(24,
    2) DEFAULT 0.00 NULL,
    fixpayinterestflag varchar(10) NULL,
    fixpayprincipaldate varchar(10) NULL,
    paygraceinteamt numeric(24,
    2) DEFAULT 0.00 NULL,
    actualpaygraceinteamt numeric(24,
    2) DEFAULT 0.00 NULL,
    waivegraceinteamt numeric(24,
    2) DEFAULT 0.00 NULL,
    oldpstype varchar(2) NULL
);