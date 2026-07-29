-- ============================================================
-- 对私客户标签表存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CRM_R_CUST_LABLE
-- 需求版本: v1.3.0
-- 设计：各段独立建临时表，最终多表汇聚到目标表
-- ============================================================

-- 01: 基础客户列表
CREATE TABLE IF NOT EXISTS TMP_ADS_CRM_CUST_LABLE_01 (
    PERSN_LEGAL_BK_CODE               VARCHAR2(4),        -- 法人行号
    CUST_ID                           VARCHAR2(20)        -- 核心客户号
);

-- 02: 近1月交易（主动动账）
CREATE TABLE IF NOT EXISTS TMP_ADS_CRM_CUST_LABLE_02 (
    PERSN_LEGAL_BK_CODE               VARCHAR2(4),        -- 法人行号
    CUST_ID                           VARCHAR2(20),       -- 核心客户号
    NEAR_MTH_TX_CNT                   NUMBER(8),          -- 近1月累计交易笔数（主动动账）
    NEAR_MTH_TX_AMT                   NUMBER(20,2)        -- 近1月累计交易金额（主动动账）
);

-- 03: 近1月第三方支付（网联渠道）
CREATE TABLE IF NOT EXISTS TMP_ADS_CRM_CUST_LABLE_03 (
    PERSN_LEGAL_BK_CODE               VARCHAR2(4),        -- 法人行号
    CUST_ID                           VARCHAR2(20),       -- 核心客户号
    NEAR_MTH_THIRD_PAY_OUT_CNT        NUMBER(8),          -- 近1月第三方累计交易笔数（网联渠道）
    NEAR_MTH_THIRD_PAY_OUT_AMT        NUMBER(20,2)        -- 近1月第三方累计交易金额（网联渠道）
);

-- 04: 是否向他行同名户规律转出
CREATE TABLE IF NOT EXISTS TMP_ADS_CRM_CUST_LABLE_04 (
    PERSN_LEGAL_BK_CODE               VARCHAR2(4),        -- 法人行号
    CUST_ID                           VARCHAR2(20),       -- 核心客户号
    IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME CHAR(1)          -- 是否向他行同名户规律转出
);

-- 05: 当年校园缴费笔数
CREATE TABLE IF NOT EXISTS TMP_ADS_CRM_CUST_LABLE_05 (
    PERSN_LEGAL_BK_CODE               VARCHAR2(4),        -- 法人行号
    CUST_ID                           VARCHAR2(20),       -- 核心客户号
    YR_CAMPUS_PAY_CNT                 NUMBER(8)           -- 当年校园缴费笔数
);

-- 06: 当月水电气缴费
CREATE TABLE IF NOT EXISTS TMP_ADS_CRM_CUST_LABLE_06 (
    PERSN_LEGAL_BK_CODE               VARCHAR2(4),        -- 法人行号
    CUST_ID                           VARCHAR2(20),       -- 核心客户号
    MTH_UTIL_PAY_TRAN_AMT             NUMBER(20,2),       -- 当月水电气缴费交易金额
    MTH_UTIL_PAY_TRAN_CNT             NUMBER(8)           -- 当月水电气缴费交易笔数
);
