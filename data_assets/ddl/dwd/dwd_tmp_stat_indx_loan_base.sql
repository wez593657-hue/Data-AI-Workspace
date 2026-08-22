/*
 * 统计中间临时表
 * 表名: crmdm.TMP_STAT_INDX_LOAN_BASE
 * 用途: 0066 个贷新形成不良贷款率 - 期初基准(正常/关注账户快照)
 * 说明: DWD_ACCT_LOAN 无历史快照; 活动首次跑批用当日正常(1)/关注(2)账户建立基准;
 *       活动结束后保留不清理; 后续跑批沿用首次基准(期初口径冻结)
 */

-- crmdm.TMP_STAT_INDX_LOAN_BASE 定义

CREATE TABLE IF NOT EXISTS crmdm.TMP_STAT_INDX_LOAN_BASE (
    PATH_CODE            VARCHAR(1)   NOT NULL,  -- 路径: A=营销活动 B=目标任务
    STATIS_DIM           VARCHAR(64)  NOT NULL,  -- 活动ID/任务ID
    DATA_BLNG            VARCHAR(64)  NOT NULL,  -- 归属: ORG_机构 / MGR_客户经理
    PERSN_LEGAL_BK_CODE  VARCHAR(4)   NOT NULL,  -- 法人行
    CUST_ID              VARCHAR(20)  NOT NULL,  -- 客户号
    ACCT_ID              VARCHAR(40)  NOT NULL,  -- 贷款账户
    LOAN_BAL             NUMBER(20,2) NULL,      -- 期初贷款余额(DWD_ACCT_LOAN.BAL)
    CATE_5LVL            VARCHAR(2)   NULL,      -- 期初五级分类(1正常/2关注)
    BASE_DATE            VARCHAR(8)   NULL       -- 基准建立日期(跑批日)
);

COMMENT ON TABLE  TMP_STAT_INDX_LOAN_BASE IS '个贷新形成不良贷款率-期初基准(正常/关注账户快照)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PATH_CODE           IS '路径: A=营销活动 B=目标任务';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.STATIS_DIM          IS '活动ID/任务ID';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.DATA_BLNG           IS '归属: ORG_机构 / MGR_客户经理';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.PERSN_LEGAL_BK_CODE IS '法人行';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CUST_ID             IS '客户号';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.ACCT_ID             IS '贷款账户';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.LOAN_BAL            IS '期初贷款余额(DWD_ACCT_LOAN.BAL)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.CATE_5LVL           IS '期初五级分类(1正常/2关注)';
COMMENT ON COLUMN TMP_STAT_INDX_LOAN_BASE.BASE_DATE           IS '基准建立日期(跑批日)';