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
