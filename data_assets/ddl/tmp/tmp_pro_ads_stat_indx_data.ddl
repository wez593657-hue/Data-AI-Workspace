-- PRC_ADS_STAT_INDX_DATA 临时表：客户维度分层重构 v2.0
-- 非客户指标只在源关联内使用客户号并立即聚合；仅客户状态指标保留短生命周期客户行。

DROP TABLE IF EXISTS TMP_STAT_INDX_AGGR_A;
DROP TABLE IF EXISTS TMP_STAT_INDX_AGGR_B;
DROP TABLE IF EXISTS TMP_STAT_INDX_AGGR;

CREATE TABLE IF NOT EXISTS TMP_STAT_INDX_SCOPE (
    path_code VARCHAR(1) NOT NULL,
    statis_dim VARCHAR(100) NOT NULL,
    indx_code VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    blng_type VARCHAR(1) NOT NULL,
    blng_id VARCHAR(40) NOT NULL,
    term_begin_date VARCHAR(8) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    PRIMARY KEY (path_code, statis_dim, indx_code, data_blng, persn_legal_bk_code)
);

CREATE TABLE IF NOT EXISTS TMP_STAT_INDX_BAL_AGGR (
    path_code VARCHAR(1) NOT NULL,
    statis_dim VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    curnt_aum NUMBER(20,2) NULL,
    yr_begin_aum NUMBER(20,2) NULL,
    mth_end_aum NUMBER(20,2) NULL,
    qrt_end_aum NUMBER(20,2) NULL,
    curnt_yr_avg_aum NUMBER(20,2) NULL,
    prev_yr_avg_aum NUMBER(20,2) NULL,
    curnt_mth_avg_aum NUMBER(20,2) NULL,
    prev_mth_avg_aum NUMBER(20,2) NULL,
    PRIMARY KEY (path_code, statis_dim, data_blng, persn_legal_bk_code)
);

-- 仅用于0052~0054、0063的逐客户状态判定；不得用于金额或事件指标。
CREATE TABLE IF NOT EXISTS TMP_STAT_INDX_CUST_STATE (
    path_code VARCHAR(1) NOT NULL,
    statis_dim VARCHAR(100) NOT NULL,
    indx_code VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    cust_id VARCHAR(20) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    base_cust_lvl VARCHAR(2) NULL,
    curnt_cust_lvl VARCHAR(2) NULL,
    base_mth_avg_aum NUMBER(20,2) NULL,
    curnt_mth_avg_aum NUMBER(20,2) NULL,
    PRIMARY KEY (path_code, statis_dim, indx_code, data_blng, cust_id, persn_legal_bk_code)
);

CREATE TABLE IF NOT EXISTS TMP_STAT_INDX_AGGR (
    path_code VARCHAR(1) NOT NULL, -- 统计路径：A=营销活动，B=目标任务
    data_date VARCHAR(8) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    statis_dim VARCHAR(100) NOT NULL,
    statis_calib VARCHAR(100) NOT NULL,
    indx_code VARCHAR(100) NOT NULL,
    curnt_val NUMBER(20,2) NULL,
    term_last_val NUMBER(20,2) NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    PRIMARY KEY (path_code, data_date, data_blng, statis_dim, statis_calib, indx_code, persn_legal_bk_code)
);
/*
 * 0066 个贷新形成不良贷款率期初基准
 * 来源: prc_ads_stat_indx_plan_002.sql 3.4段
 * 说明: 活动开始前一天建立，活动结束后保留；不纳入上方临时表清空逻辑
 */
CREATE TABLE IF NOT EXISTS TMP_STAT_INDX_LOAN_BASE (
    path_code            VARCHAR(1)   NOT NULL,
    statis_dim           VARCHAR(64)  NOT NULL,
    data_blng            VARCHAR(64)  NOT NULL,
    persn_legal_bk_code  VARCHAR(4)   NOT NULL,
    cust_id              VARCHAR(20)  NOT NULL,
    acct_id              VARCHAR(40)  NOT NULL,
    loan_bal             NUMBER(20,2) NULL,
    cate_5lvl            VARCHAR(2)   NULL,
    base_date            VARCHAR(8)   NULL
);

COMMENT ON TABLE TMP_STAT_INDX_LOAN_BASE IS '个贷新形成不良贷款率-期初基准(正常/关注账户快照)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PATH_CODE IS '统计路径: A营销活动/B目标任务';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.STATIS_DIM IS '活动ID或任务ID';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.DATA_BLNG IS '数据归属: ORG_机构/MGR_客户经理';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PERSN_LEGAL_BK_CODE IS '法人行号';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CUST_ID IS '客户号';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.ACCT_ID IS '贷款账户';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.LOAN_BAL IS '期初贷款余额(DWD_ACCT_LOAN.BAL)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CATE_5LVL IS '期初五级分类(1正常/2关注)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.BASE_DATE IS '基准建立日期(跑批日)';