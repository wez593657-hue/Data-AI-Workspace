-- TMP_ADS_SLEEP_WAKE_PROD
-- 睡眠户唤醒-当月产品新增客户预聚合表
-- 版本: v2.12.0
-- 用途: 预聚合当月有新增产品(定期/理财/保险)的客户，供[A0]步骤IS_WAKE判断使用
-- 数据来源: DWD_ACCT_DEPO(定期起息日), DWD_ACCT_FIN(理财办理日), DWD_ACCT_INSUR(保险最近交易日)
CREATE TABLE TMP_ADS_SLEEP_WAKE_PROD (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),   -- 法人行号
    CUST_ID             VARCHAR2(20)   -- 客户号
);
