/*
 * 上游信贷系统
 * 表名: crmdm.cms_acct_rpt_segment
 * 来源: TB.ddl
 */

-- crmdm.cms_acct_rpt_segment 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_rpt_segment;

CREATE TABLE crmdm.cms_acct_rpt_segment (
    serialno varchar(40) NOT NULL,
    objectno varchar(40) NULL,
    objecttype varchar(40) NULL,
    pstype varchar(10) NULL,
    termid varchar(10) NULL,
    segno numeric NULL,
    segname varchar(120) NULL,
    termruleid varchar(10) NULL,
    segtermid varchar(10) NULL,
    segfromdate varchar(10) NULL,
    segtodate varchar(10) NULL,
    segfromstage numeric NULL,
    segtostage numeric NULL,
    segstages numeric NULL,
    status varchar(10) NULL,
    segtermflag varchar(10) NULL,
    segtermunit varchar(10) NULL,
    segterm numeric NULL,
    firstduedate varchar(10) NULL,
    defaultdueday varchar(2) NULL,
    lastduedate varchar(10) NULL,
    nextduedate varchar(10) NULL,
    totalperiod numeric NULL,
    currentperiod numeric NULL,
    gaincyc numeric NULL,
    gainamount numeric(24,
    2) NULL,
    payfrequencytype varchar(10) NULL,
    payfrequencyunit varchar(10) NULL,
    payfrequency varchar(10) NULL,
    segrptamountflag varchar(20) NULL,
    segrptamount numeric(24,
    2) NULL,
    segrptpercent numeric(5,
    2) NULL,
    seginstalmentamt numeric(24,
    2) NULL,
    segrptbalance numeric(24,
    2) NULL,
    firstinstalmentflag varchar(10) NULL,
    finalinstalmentflag varchar(10) NULL,
    gracedays numeric NULL,
    autopayflag varchar(10) NULL,
    remark varchar(200) NULL,
    psrestructureflag varchar(10) NULL,
    postponerule varchar(200) NULL,
    transserialno varchar(40) NULL,
    gracedaysaccrualflag varchar(2) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_cms_acct_rpt_segment PRIMARY KEY (serialno)
);