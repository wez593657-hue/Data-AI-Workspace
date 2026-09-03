/*
 * 统计指标计算临时表
 * 表名: crmdm.TMP_STAT_INDX_LOAN_BASE
 * 用途: 0066 不良率构成指标基数临时表 - 贷款基数(正常/关注账户余额) + 五级分类快照
 * 说明: 来源表改为 DWS_CUST_CLASSFIVE(客户五级分类全历史)；
 *       路径08(营销活动): 活动开始前一天(V_NEXT_DAY)一次性冻结，取正常(1)/关注(2)客户余额做基数；
 *       路径09(目标任务): 基准日固定 = 任务开始前一天(term_begin_date - 1)；任务期内每日 DELETE + 重算；
 *       09每日重算取数分流：基准日=跑批日从主表取，否则从HIS表取；
 *       ACCT_ID 为 NULL（DWS_CUST_CLASSFIVE 无账户维度；仅保留兼容列）
 */

-- crmdm.TMP_STAT_INDX_LOAN_BASE 定义

CREATE TABLE IF NOT EXISTS crmdm.TMP_STAT_INDX_LOAN_BASE (
    PATH_CODE            VARCHAR(2)   NOT NULL,  -- 路径码: 08=营销活动 09=目标任务
    STATIS_DIM           VARCHAR(64)  NOT NULL,  -- 活动ID/任务ID
    DATA_BLNG            VARCHAR(64)  NOT NULL,  -- 归属: ORG_机构 / MGR_客户经理
    PERSN_LEGAL_BK_CODE  VARCHAR(4)   NOT NULL,  -- 法人行
    CUST_ID              VARCHAR(20)  NOT NULL,  -- 客户号
    ACCT_ID              VARCHAR(40)  NULL,       -- 贷款账号(已废弃，恒为NULL，保留兼容)
    LOAN_BAL             NUMBER(20,2) NULL,      -- 期初贷款余额(DWS_CUST_CLASSFIVE.LOAN_BAL)
    CATE_5LVL            VARCHAR(2)   NULL,      -- 贷款五级分类: 1正常/2关注/3次级/4可疑/5损失
    BASE_DATE            VARCHAR(8)   NULL       -- 基准建立日期(跑批日)
);

COMMENT ON TABLE  TMP_STAT_INDX_LOAN_BASE IS '0066不良率基数临时表-贷款余额五级分类快照(08活动冻结/09任务日重算); 来源DWS_CUST_CLASSFIVE';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PATH_CODE           IS '路径码: 08=营销活动(一次性冻结) 09=目标任务(每日重算)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.STATIS_DIM          IS '活动ID/任务ID';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.DATA_BLNG           IS '归属: ORG_机构 / MGR_客户经理';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PERSN_LEGAL_BK_CODE IS '法人行';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CUST_ID             IS '客户号';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.ACCT_ID             IS '贷款账号(已废弃，恒为NULL，保留兼容)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.LOAN_BAL            IS '贷款期末余额 来源DWS_CUST_CLASSFIVE.LOAN_BAL';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CATE_5LVL           IS '贷款五级分类: 1正常 2关注 3次级 4可疑 5损失';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.BASE_DATE           IS '基数基准日(YYYYMMDD): 08=活动开始前1天; 09=任务开始前1天';