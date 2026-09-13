-- PRC_ADS_STAT_INDX_DATA 临时表：客户维度分层重构 v2.0
-- 非客户指标只在源关联内使用客户号并立即聚合；仅客户状态指标保留短生命周期客户行。

DROP TABLE IF EXISTS TMP_STAT_INDX_AGGR;

DROP TABLE TMP_STAT_INDX_SCOPE;
CREATE TABLE TMP_STAT_INDX_SCOPE (
    path_code VARCHAR(2) NOT NULL,
    statis_calib VARCHAR(100) NOT NULL,
    indx_code VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    blng_type VARCHAR(1) NOT NULL,
    blng_id VARCHAR(40) NOT NULL,
    term_begin_date VARCHAR(8) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    PRIMARY KEY (path_code, statis_calib, indx_code, data_blng, persn_legal_bk_code)
);

DROP TABLE TMP_STAT_INDX_BAL_AGGR;
CREATE TABLE TMP_STAT_INDX_BAL_AGGR (
    path_code VARCHAR(2) NOT NULL,
    statis_calib VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    curnt_aum NUMBER(20,2) NULL,
    yr_begin_aum NUMBER(20,2) NULL,
    mth_end_aum NUMBER(20,2) NULL,
    qrt_end_aum NUMBER(20,2) NULL,
    curnt_yr_avg_aum NUMBER(20,2) NULL,
    curnt_mth_avg_aum NUMBER(20,2) NULL,
    PRIMARY KEY (path_code, statis_calib, data_blng, persn_legal_bk_code)
);

-- 仅用于0052~0054、0063的逐客户状态判定；不得用于金额或事件指标。
DROP TABLE TMP_STAT_INDX_CUST_STATE;
CREATE TABLE TMP_STAT_INDX_CUST_STATE (
    path_code VARCHAR(2) NOT NULL,
    statis_calib VARCHAR(100) NOT NULL,
    indx_code VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    cust_id VARCHAR(20) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    base_cust_lvl VARCHAR(2) NULL,
    curnt_cust_lvl VARCHAR(2) NULL,
    base_mth_avg_aum NUMBER(20,2) NULL,
    curnt_mth_avg_aum NUMBER(20,2) NULL,
    PRIMARY KEY (path_code, statis_calib, indx_code, data_blng, cust_id, persn_legal_bk_code)
);

-- 指标汇总临时表按写入过程拆分（v3.0）：TMP_STAT_INDX_AGGR_003 ~ _009，
-- 各过程段首自清，防止并行跑批相互影响；plan_010 合并至 _010 后统一强校验+落库。
-- 旧 TMP_STAT_INDX_AGGR 已删除，不留兼容。
DROP TABLE TMP_STAT_INDX_AGGR_003;
CREATE TABLE TMP_STAT_INDX_AGGR_003 (
    path_code VARCHAR(2) NOT NULL, -- 统计路径：A=营销活动，B=目标任务
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
DROP TABLE TMP_STAT_INDX_AGGR_004;
CREATE TABLE TMP_STAT_INDX_AGGR_004 (
    path_code VARCHAR(2) NOT NULL,
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
DROP TABLE TMP_STAT_INDX_AGGR_005;
CREATE TABLE TMP_STAT_INDX_AGGR_005 (
    path_code VARCHAR(2) NOT NULL,
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
-- plan_006 指标 INDX_0061/0064/0067/0068/0070/0071/0072/0076/0077/0078/0079 汇总临时表
DROP TABLE TMP_STAT_INDX_AGGR_006;
CREATE TABLE TMP_STAT_INDX_AGGR_006 (
    path_code VARCHAR(2) NOT NULL,
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
DROP TABLE TMP_STAT_INDX_AGGR_007;
CREATE TABLE TMP_STAT_INDX_AGGR_007 (
    path_code VARCHAR(2) NOT NULL,
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
DROP TABLE TMP_STAT_INDX_AGGR_008;
CREATE TABLE TMP_STAT_INDX_AGGR_008 (
    path_code VARCHAR(2) NOT NULL,
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
DROP TABLE TMP_STAT_INDX_AGGR_009;
CREATE TABLE TMP_STAT_INDX_AGGR_009 (
    path_code VARCHAR(2) NOT NULL,
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
-- plan_010 合并表：接收 _003~_009 全部结果后统一强校验并落库 ADS_STAT_INDX_DATA
DROP TABLE TMP_STAT_INDX_AGGR_010;
CREATE TABLE TMP_STAT_INDX_AGGR_010 (
    path_code VARCHAR(2) NOT NULL,
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
DROP TABLE TMP_STAT_INDX_LOAN_BASE;
CREATE TABLE TMP_STAT_INDX_LOAN_BASE (
    path_code            VARCHAR(2)   NOT NULL,
    statis_calib         VARCHAR(64)  NOT NULL,
    data_blng            VARCHAR(64)  NOT NULL,
    persn_legal_bk_code  VARCHAR(4)   NOT NULL,
    cust_id              VARCHAR(20)  NOT NULL,
    acct_id              VARCHAR(40)  NOT NULL,
    loan_bal             NUMBER(20,2) NULL,
    class_five            VARCHAR(2)   NULL,
    base_date            VARCHAR(8)   NULL
);

COMMENT ON TABLE TMP_STAT_INDX_LOAN_BASE IS '个贷新形成不良贷款率-期初基准(正常/关注账户快照)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PATH_CODE IS '统计路径: A营销活动/B目标任务';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.STATIS_CALIB IS '统计口径: 活动ID或任务ID';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.DATA_BLNG IS '数据归属: 机构编码/客户经理编码';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PERSN_LEGAL_BK_CODE IS '法人行号';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CUST_ID IS '客户号';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.ACCT_ID IS '贷款账户';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.LOAN_BAL IS '期初贷款余额(DWD_ACCT_LOAN.BAL)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.class_five IS '期初五级分类(1正常/2关注)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.BASE_DATE IS '基准建立日期(跑批日)';
-- 客户范围物化表 (v5.2 性能优化, PRC_ADS_STAT_INDX_PLAN_006, 2026-09-11)
-- 客户范围三分支UNION(08=CRM.MKT_TSK_INFO / 09-O=DWS_CUST_LVL_INFO / 09-M=DWD_CUST_MAN)
-- 由plan_006第2段一次构建, 9个客户范围段(0064基数刷新 + 0065/0061/0067/0076/0077/0070/0071/0072
-- 八段AGGR)按INDX_CODE取用, 消除范围CTE x9次重复展开与DWS_CUST_LVL_INFO当日快照重复扫描;
-- 过程段首DELETE自清, 并行跑批安全; 0068商户范围(UEPP_PAY_MCT_INFO)不涉及客户范围, 不物化
DROP TABLE TMP_STAT_INDX_CUST_SC_006;
CREATE TABLE TMP_STAT_INDX_CUST_SC_006 (
    indx_code VARCHAR(100) NOT NULL,
    path_code VARCHAR(2) NOT NULL,
    statis_dim VARCHAR(100) NOT NULL,
    statis_calib VARCHAR(100) NOT NULL,
    data_blng VARCHAR(100) NOT NULL,
    term_begin_date VARCHAR(8) NOT NULL,
    cust_id VARCHAR(20) NOT NULL,
    persn_legal_bk_code VARCHAR(30) NOT NULL,
    PRIMARY KEY (indx_code, path_code, statis_dim, statis_calib, data_blng, term_begin_date, cust_id, persn_legal_bk_code)
);
COMMENT ON TABLE TMP_STAT_INDX_CUST_SC_006 IS 'plan_006客户范围物化表(过程段首自清, 并行安全, 0068商户范围不涉及)';
