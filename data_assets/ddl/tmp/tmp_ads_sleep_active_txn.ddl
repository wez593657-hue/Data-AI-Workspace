-- TMP_ADS_SLEEP_ACTIVE_TXN
-- 睡眠户唤醒-主动动账客户预聚合表
-- 版本: v2.13.0
-- 用途: 预聚合近365天有主动动账(JIOYCFFS='0')的客户，供[A][B]步骤NOT EXISTS使用，
--      消除DWD_TX_ASET重复扫描（O-01优化）。
-- 数据来源: DWD_TX_ASET
CREATE TABLE TMP_ADS_SLEEP_ACTIVE_TXN (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),   -- 法人行号
    CUST_ID             VARCHAR2(12)   -- 客户号
);
