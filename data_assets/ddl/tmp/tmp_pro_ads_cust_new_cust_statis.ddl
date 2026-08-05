-- ============================================================
-- 新客经营统计存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_NEW_CUST_STATIS
-- 需求版本: v2.4.1
-- 临时表: TMP_ADS_NEW_CUST_AUM(T-1日AUM预查询中间表,F-04),
--         TMP_ADS_NEW_CUST_STAT_SRC(物理临时表，存储展开后的统计源数据)
-- 用途: 存储机构向上汇总与客户经理两个维度展开后的统计源数据，
--       供新客数、接触率、KYC完成率、金融资产区间分布统计使用
-- ============================================================

CREATE TABLE IF NOT EXISTS TMP_ADS_NEW_CUST_STAT_SRC (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    DATA_DATE             VARCHAR2(8),       -- 数据日期(YYYYMMDD)
    STATIS_CYCLE          VARCHAR2(2),       -- 统计周期(M=月度)
    STATIS_OBJ            VARCHAR2(20),      -- 统计对象(机构编号或客户经理岗位编号)
    NEW_CUST_CYCLE        VARCHAR2(1),       -- 新客周期(1=0~30天,2=30~100天,3=100~180天)
    CNTCT_STATE           VARCHAR2(1),       -- 接触状态(1=已接触,0=未接触)
    KYC_STATE             VARCHAR2(1),       -- KYC完成状态(1=完整,0=不完整)
    PNT_AUM_BAL           NUMBER(20,2)       -- T-1日AUM余额
);

COMMENT ON TABLE TMP_ADS_NEW_CUST_STAT_SRC IS '新客经营统计源数据临时表';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR2(4)，取明细法人行号。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.DATA_DATE IS '数据日期：VARCHAR2(8)，格式YYYYMMDD。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.STATIS_CYCLE IS '统计周期：VARCHAR2(2)，仅M=月度。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.STATIS_OBJ IS '统计对象：VARCHAR2(20)，机构维度为祖先机构编号，经理维度为客户经理岗位编号。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.NEW_CUST_CYCLE IS '新客周期：VARCHAR2(1)，1=0~30天，2=30~100天，3=100~180天。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.CNTCT_STATE IS '接触状态：VARCHAR2(1)，1=已接触，0=未接触。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.KYC_STATE IS 'KYC完成状态：VARCHAR2(1)，1=完整，0=不完整。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_STAT_SRC.PNT_AUM_BAL IS 'T-1日AUM余额：NUMBER(20,2)，金额元，缺失按0处理，用于资产区间分段。';

-- ============================================================
-- T-1日AUM预查询中间表（两个UNION ALL分支共用，F-04）
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_NEW_CUST_AUM (
    CUST_ID               VARCHAR2(20),      -- 客户编号
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    ORG_ID                VARCHAR2(7),       -- 归属机构
    AUM_BAL               NUMBER(20,2)       -- T-1日AUM余额
);

COMMENT ON TABLE TMP_ADS_NEW_CUST_AUM IS 'T-1日AUM预查询中间表（F-04：两个UNION ALL分支共用，消除DWS重复JOIN）';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_AUM.CUST_ID IS '客户编号：VARCHAR2(20)。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_AUM.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR2(4)，取明细法人行号。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_AUM.ORG_ID IS '归属机构：VARCHAR2(7)，取明细归属机构。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_AUM.AUM_BAL IS 'T-1日AUM余额：NUMBER(20,2)，金额元，缺失按0处理，用于资产区间分段。';
