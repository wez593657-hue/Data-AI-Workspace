-- ============================================================
-- 客户流失统计表临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_LOST_STATIS
-- 需求版本: v2.4.1
-- 变更记录:
--   v2.3.0 2026-07-28 年码值N→Y统一
--   v2.4.1 2026-07-30 去掉季/年切片，统计周期统一为月度
-- ============================================================

-- 2.1 统计对象展开中间表
CREATE TABLE IF NOT EXISTS TMP_ADS_LOST_STAT_SRC (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    DATA_DATE             VARCHAR2(8),       -- 数据日期
    STATIS_CYCLE          VARCHAR2(2),       -- 统计周期
    STATIS_OBJ            VARCHAR2(20),      -- 统计对象
    LVL_CHURN             VARCHAR2(2),       -- 流失等级
    CNTCT_STATE           VARCHAR2(1),       -- 接触状态
    RESCUE_STATE          VARCHAR2(1),       -- 挽回状态
    RESCUED_FINA_ASSET    NUMBER(20,2)       -- 已挽回金融资产
);
