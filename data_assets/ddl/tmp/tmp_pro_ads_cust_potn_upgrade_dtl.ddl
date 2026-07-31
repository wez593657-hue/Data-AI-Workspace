-- ============================================================
-- 潜力提升客户明细表存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL
-- 需求版本: v3.1.1
-- ============================================================

-- 2.1 临界客户基础中间表
CREATE TABLE IF NOT EXISTS TMP_ADS_POTN_BASE (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    CUST_ID               VARCHAR2(20),      -- 客户编号
    CUST_NAME             VARCHAR2(100),     -- 客户名称
    CUST_LVL              VARCHAR2(2),       -- 客户等级
    LVL_CRIT              VARCHAR2(2),       -- 临界等级
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),      -- 活期余额
    FIXD_DEPO_BAL         NUMBER(20,2),      -- 定期余额
    FIN_AMT               NUMBER(20,2),      -- 理财余额
    CURR_MTH_AVG_AUM      NUMBER(20,2),      -- 当前月日均AUM
    PNT_AUM_BAL           NUMBER(20,2),      -- T-1日时点AUM
    CNTCT_STATE_M         VARCHAR2(1),       -- 月接触状态(当月初~跑批日)
    POST_ID               VARCHAR2(20),      -- 管户经理
    ORG_ID                VARCHAR2(7)        -- 归属机构
);
