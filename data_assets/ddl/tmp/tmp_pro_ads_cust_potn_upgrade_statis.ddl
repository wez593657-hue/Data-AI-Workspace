-- ============================================================
-- 潜力提升统计表存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_POTN_UPGRADE_STATIS
-- 需求版本: v3.2.0
-- ============================================================

-- 2.1 月日均达标状态预计算中间表（两个UNION ALL分支共用）
CREATE TABLE IF NOT EXISTS TMP_ADS_POTN_MTH_AVG (
    CUST_ID               VARCHAR2(20),      -- 客户编号
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    MTH_AVG_QUAL_STATE    VARCHAR2(1)        -- 月日均达标状态（1=达标，0=未达标）
);

-- 2.2 统计对象展开中间表
CREATE TABLE IF NOT EXISTS TMP_ADS_POTN_STAT_SRC (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    DATA_DATE             VARCHAR2(8),       -- 数据日期
    STATIS_CYCLE          VARCHAR2(2),       -- 统计周期
    STATIS_OBJ            VARCHAR2(20),      -- 统计对象
    LVL_CRIT              VARCHAR2(2),       -- 临界等级
    MTH_AVG_QUAL_STATE    VARCHAR2(1),       -- 月均达标状态
    PNT_QUAL_STATE        VARCHAR2(1),       -- 时点达标状态
    CNTCT_STATE           VARCHAR2(1)        -- 接触状态
);
