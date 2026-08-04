-- TMP_ADS_SLEEP_ORG_HIER
-- 睡眠户唤醒-机构层级预物化表
-- 版本: v2.13.0
-- 用途: 预物化CONNECT BY机构递归结果，供STATIS步骤TMP2使用，
--      避免在INSERT子查询中重复执行递归（O-04优化）。
-- 数据来源: DWD_SYS_ORG, ADS_CUST_SLEEP_WAKE_DTL
CREATE TABLE TMP_ADS_SLEEP_ORG_HIER (
    LEAF_ORG_ID    VARCHAR2(7),   -- 叶子机构
    ANCESTOR_ORG_ID VARCHAR2(7)   -- 祖先机构(含自身)
);
