-- ============================================================
-- 保险账户处理存储过程临时表建表语句
-- 存储过程名称: PRC_DWD_ACCT_INSUR
-- 需求版本: v3.2.0
-- 设计：两层架构（明细层→聚合层），3张临时表
--       01: TMP_DWD_ACCT_INSUR_DETAIL 明细层（PLAT_POLICY_SERIAL+INSURANCE_CODE+TRAN_TYPE粒度）
--       02: TMP_DWD_ACCT_INSUR_FEE_AGGR 预聚合（每保单交易日期聚合）
--       03: TMP_DWD_ACCT_INSUR_SNAP 聚合层快照（四键主键粒度）
-- ============================================================

-- 01: 明细层临时表
--     以 PLAT_POLICY_SERIAL + INSURANCE_CODE + TRAN_TYPE 为粒度，
--     存储每一条缴费成功(ORD_TRAN_STATUS='2')的交易记录，
--     供聚合层按四键主键聚合
CREATE TABLE IF NOT EXISTS TMP_DWD_ACCT_INSUR_DETAIL (
    plat_policy_serial           VARCHAR2(200) NOT NULL,    -- 保单平台流水号
    insurance_code               VARCHAR2(50)  NULL,        -- 险种代码
    tran_type                    VARCHAR2(2)   NULL,        -- 交易类型(0新单/1续期/2撤单/3退保/4退保/5满期/6理赔/7保全/8终止撤销/9复效)
    ord_amt                      NUMBER(22)    NULL,        -- 交易金额(保费)
    ord_tran_status              VARCHAR2(2)   NULL,        -- 交易状态(固定为'2'=缴费成功)
    ord_create_date              VARCHAR2(8)   NULL,        -- 订单创建日期(YYYYMMDD)
    cust_id                      VARCHAR2(20)  NULL,        -- 客户编号
    cust_typ                     VARCHAR2(4)   NULL,        -- 客户类型
    acct_id                      VARCHAR2(40)  NULL,        -- 账户
    prdkt_id                     VARCHAR2(40)  NULL,        -- 产品ID
    prdkt_name                   VARCHAR2(100) NULL,        -- 产品名称
    prdkt_cate_big               VARCHAR2(64)  NULL,        -- 产品大类
    insur_bid_form_no            VARCHAR2(40)  NULL,        -- 投保单号
    cont_status                  VARCHAR2(2)   NULL,        -- 保单状态(0未生效/1正常/2失效)
    accept_date_parsed           DATE          NULL,        -- 投保日期(DATE型)
    bgn_insur_date               VARCHAR2(10)  NULL,        -- 起保日期(YYYY-MM-DD)
    valid_per_unit               VARCHAR2(2)   NULL,        -- 保险期间类型(-1永久/0保至年龄/12年/1月/2日)
    valid_per_num                NUMBER(22)    NULL,        -- 保险期间值
    pay_per_unit                 VARCHAR2(2)   NULL,        -- 缴费期间类型(-1无期限/0保至年龄/12年/1月/2日)
    pay_per_num                  NUMBER(22)    NULL,        -- 缴费期间值
    pay_type                     VARCHAR2(2)   NULL,        -- 缴费方式(0趸缴/1期缴)
    tx_org                       VARCHAR2(7)   NULL,        -- 交易机构
    tx_chnl                      VARCHAR2(10)  NULL,        -- 交易渠道
    mkt_org                      VARCHAR2(7)   NULL,        -- 归属机构
    persn_legal_bk_code          VARCHAR2(4)   NULL,        -- 法人行号
    cert_id                      VARCHAR2(18)  NULL,        -- 证件号码(供身份证推算日期)
    vali_date                    VARCHAR2(8)   NULL,        -- 起保日期(源YYYYMMDD格式)
    PRIMARY KEY (plat_policy_serial, insurance_code, tran_type, ord_create_date)
);

-- 02: 预聚合临时表
--     从明细层一次扫描聚合每保单的交易日期：
--     last_success_tx_date:    最近缴费成功日期(ORD_TRAN_STATUS='2')
--     actl_term_date_parsed:   最近终止交易日期(TRAN_TYPE IN 2/3/4/5/6/8)
--     last_renewal_date_parsed: 最近续期日期(TRAN_TYPE='1')
CREATE TABLE IF NOT EXISTS TMP_DWD_ACCT_INSUR_FEE_AGGR (
    plat_policy_serial           VARCHAR2(200) NOT NULL,    -- 保单平台流水号
    last_success_tx_date         DATE          NULL,        -- 最近缴费成功日期
    actl_term_date_parsed        DATE          NULL,        -- 最近终止交易日期
    last_renewal_date_parsed     DATE          NULL,        -- 最近续期日期(供60天宽限期判定)
    PRIMARY KEY (plat_policy_serial)
);

-- 03: 聚合层快照表
--     按四键主键(CUST_ID+ACCT_ID+PRDKT_ID+INSUR_BID_FORM_NO)聚合，
--     结构与 DWD_ACCT_INSUR 一致，一次计算后直接 INSERT 到目标表
CREATE TABLE IF NOT EXISTS TMP_DWD_ACCT_INSUR_SNAP (
    cust_id                      VARCHAR2(20)   NOT NULL,  -- 客户编号
    cust_typ                     VARCHAR2(4)    NULL,      -- 客户类型
    acct_id                      VARCHAR2(40)   NOT NULL,  -- 账户
    prdkt_id                     VARCHAR2(40)   NOT NULL,  -- 产品ID
    prdkt_name                   VARCHAR2(100)  NULL,      -- 产品名称
    prdkt_cate_big               VARCHAR2(64)   NULL,      -- 产品大类
    insur_bid_form_no            VARCHAR2(40)   NOT NULL,  -- 投保单号
    tx_date                      VARCHAR2(8)    NULL,      -- 交易日期(YYYYMMDD)
    last_tx_date                 VARCHAR2(8)    NULL,      -- 最近交易日期(YYYYMMDD)
    tx_org                       VARCHAR2(7)    NULL,      -- 交易机构
    tx_chnl                      VARCHAR2(10)   NULL,      -- 交易渠道
    mkt_org                      VARCHAR2(7)    NULL,      -- 归属机构
    bgn_insur_date               VARCHAR2(10)   NULL,      -- 起保日期(YYYY-MM-DD)
    cancl_insur_date             VARCHAR2(10)   NULL,      -- 保险期间结束日期(推算值,仅参考)
    actl_term_date               VARCHAR2(8)    NULL,      -- 实际终止日期(YYYYMMDD)
    pay_upto_date                VARCHAR2(8)    NULL,      -- 缴费截止日期(YYYYMMDD)
    insur_period_typ             VARCHAR2(2)    NULL,      -- 保险期间类型(-1永久/0保至年龄/12年/1月/2日)
    insur_period                 VARCHAR2(6)    NULL,      -- 保险期间值
    pay_period_typ               VARCHAR2(2)    NULL,      -- 缴费期间类型(-1无期限/0保至年龄/12年/1月/2日)
    pay_period                   VARCHAR2(6)    NULL,      -- 缴费期间值
    pay_patrn                    VARCHAR2(2)    NULL,      -- 缴费方式(0趸缴/1期缴)
    new_insur_amt                NUMBER(20,2)   NULL,      -- 首期保费(新单保费)
    insur_amt                    NUMBER(20,2)   NULL,      -- 当前保险金额(终止/缴费期满/宽限期过=0)
    policy_state                 VARCHAR2(8)    NOT NULL,  -- 保单状态(0未生效/1正常/2失效)
    tx_typ                       VARCHAR2(1)    NULL,      -- 交易类型(统一置空)
    persn_legal_bk_code          VARCHAR2(4)    NULL,      -- 法人行号
    PRIMARY KEY (cust_id, acct_id, prdkt_id, insur_bid_form_no)
);