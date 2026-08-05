/*
 * DWD层表
 * 表名: crmdm.dwd_acct_insur_his
 * 来源: TB.ddl
 * 变更记录:
 *   v1.1.0 2026-08-03 新增 new_insur_amt/renew_insur_amt，与 DWD_ACCT_INSUR 当前表同步
 *   v2.0.0 2026-08-03 DWS 不再依赖本表(仅归档)；同步 last_tx_date/actl_term_date，移除 renew_insur_amt
 *   v2.4.0 2026-08-05 F-06 列类型对齐当前表(tx_date VARCHAR2(10)→VARCHAR2(8), tx_typ VARCHAR2(6)→VARCHAR2(1))
 *                     F-07 新增四键主键(cust_id, acct_id, prdkt_id, insur_bid_form_no)防重复归档
 *                     F-08 补充表注释
 */

-- crmdm.dwd_acct_insur_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_insur_his;

CREATE TABLE crmdm.dwd_acct_insur_his (
    data_date            varchar(10) NULL,      -- 数据日期(归档批次)
    cust_id              varchar(20) NULL,      -- 客户编号
    cust_typ             varchar(4)  NULL,      -- 客户类型
    acct_id              varchar(40) NULL,      -- 账户
    prdkt_id             varchar(40) NULL,      -- 产品ID
    prdkt_name           varchar(100) NULL,     -- 产品名称
    prdkt_cate_big       varchar(64) NULL,      -- 产品大类
    insur_bid_form_no    varchar(40) NULL,      -- 投保单号
    tx_date              varchar(8)  NULL,      -- 首次交易日期(YYYYMMDD, v2.4.0 F-06: 对齐当前表VARCHAR2(8))
    tx_org               varchar(7)  NULL,      -- 交易机构
    tx_chnl              varchar(10) NULL,      -- 交易渠道
    mkt_org              varchar(7)  NULL,      -- 归属机构
    bgn_insur_date       varchar(10) NULL,      -- 起保日期
    cancl_insur_date     varchar(10) NULL,      -- 保险期间结束日期(推算,仅参考)
    pay_upto_date        varchar(8)  NULL,      -- 缴费截止日期(YYYYMMDD, v2.4.0 F-06: 对齐当前表VARCHAR2(8))
    insur_period_typ     varchar(2)  NULL,      -- 保险期间类型
    insur_period         varchar(6)  NULL,      -- 保险期间值
    pay_period_typ       varchar(2)  NULL,      -- 缴费期间类型
    pay_period           varchar(6)  NULL,      -- 缴费期间值
    pay_patrn            varchar(2)  NULL,      -- 缴费方式(0趸缴/1期缴)
    insur_amt            numeric(20, 2) NULL,   -- 当前保险金额(v2.4.0 F-06: 修正格式)
    last_tx_date         varchar(8)  NULL,      -- 最近交易日期(YYYYMMDD)
    actl_term_date       varchar(8)  NULL,      -- 实际终止日期(YYYYMMDD)
    new_insur_amt        numeric(20, 2) NULL,   -- 首期保费(新单保费)
    policy_state         varchar(8)  NULL,      -- 保单状态: 0未生效/1正常/2失效
    tx_typ               varchar(1)  NULL,      -- 交易类型(v2.4.0 F-06: 对齐当前表VARCHAR2(1))
    persn_legal_bk_code  varchar(4)  NULL,      -- 法人行号
    CONSTRAINT PK_DWD_ACCT_INSUR_HIS PRIMARY KEY (data_date, cust_id, acct_id, prdkt_id, insur_bid_form_no) -- v2.4.0 F-07
);

COMMENT ON TABLE  DWD_ACCT_INSUR_HIS IS '保险账户信息历史归档表(保单级主档，按data_date+四键主键去重)'; -- v2.4.0 F-08
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.data_date IS '归档批次日期(YYYYMMDD)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.cust_id IS '客户编号';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.cust_typ IS '客户类型';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.acct_id IS '账户';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.prdkt_id IS '产品ID';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.prdkt_name IS '产品名称';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.insur_bid_form_no IS '投保单号';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.tx_date IS '首次交易日期(YYYYMMDD)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.tx_org IS '交易机构';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.tx_chnl IS '交易渠道';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.mkt_org IS '归属机构';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.bgn_insur_date IS '起保日期(YYYY-MM-DD)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.cancl_insur_date IS '保险期间结束日期(推算值,仅参考)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.pay_upto_date IS '缴费截止日期(YYYYMMDD)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.insur_period_typ IS '保险期间类型';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.insur_period IS '保险期间值';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.pay_period_typ IS '缴费期间类型';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.pay_period IS '缴费期间值';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.pay_patrn IS '缴费方式(0趸缴/1期缴)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.insur_amt IS '当前保险金额';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.last_tx_date IS '最近交易日期(YYYYMMDD)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.actl_term_date IS '实际终止日期(YYYYMMDD)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.new_insur_amt IS '首期保费(新单保费)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.policy_state IS '保单状态: 0未生效/1正常/2失效';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.tx_typ IS '交易类型(统一置空)';
COMMENT ON COLUMN DWD_ACCT_INSUR_HIS.persn_legal_bk_code IS '法人行号';
