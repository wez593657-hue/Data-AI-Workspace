-- ============================================================
-- 客户流失清单临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_LOST_DTL
-- 需求版本: v2.3.0
-- ============================================================

-- 2.1 流失客户基础中间表
CREATE TABLE IF NOT EXISTS TMP_ADS_LOST_BASE (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    CUST_ID               VARCHAR2(20),      -- 客户编号
    CUST_NAME             VARCHAR2(100),     -- 客户名称
    CUST_LVL              VARCHAR2(2),       -- 客户等级
    LVL_CHURN             VARCHAR2(2),       -- 流失等级
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),      -- 活期余额
    FIXD_DEPO_BAL         NUMBER(20,2),      -- 定期余额
    FIN_AMT               NUMBER(20,2),      -- 理财余额
    CNTCT_STATE_M         VARCHAR2(1),       -- 月接触状态(当月初~跑批日)
    CNTCT_STATE_Q         VARCHAR2(1),       -- 季接触状态(当季初~跑批日)
    CNTCT_STATE_Y         VARCHAR2(1),       -- 年接触状态(当年初~跑批日)
    RESCUE_STATE          VARCHAR2(1),       -- 挽回状态
    CUR_AUM_BAL           NUMBER(20,2),      -- T-1日AUM余额
    LAST_MONTH_END_AUM_BAL NUMBER(20,2),     -- 上月末AUM余额
    POST_ID               VARCHAR2(20),      -- 管户经理
    ORG_ID                VARCHAR2(7)        -- 归属机构
);
