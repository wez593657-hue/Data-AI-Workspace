-- ============================================================
-- 到期承接统计表存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_DEADLINE_RMND_STATIS
-- 需求版本: v2.5.0
-- ============================================================

-- 2.1 统计基础明细中间表
CREATE TABLE IF NOT EXISTS TMP_CDR_STAT_BASE (
    PERSN_LEGAL_BK_CODE              VARCHAR2(32),   -- 法人行号
    DATA_DATE                        VARCHAR2(8),    -- 数据日期
    STAT_PERD                        VARCHAR2(1),    -- 统计周期：M-月,Q-季,Y-年
    STATIS_TYP                       VARCHAR2(1),    -- 承接类型：0-全部,1-存款,2-理财
    CUST_ID                          VARCHAR2(64),   -- 客户编号
    ORG_ID                           VARCHAR2(64),   -- 归属机构
    POST_ID                          VARCHAR2(64),   -- 管户经理
    EXPR_AMT                         NUMBER(20,2),   -- 已到期金额
    MATURE_TTL_AMT                   NUMBER(20,2),   -- 总到期金额
    TAKE_RATE_30D                    NUMBER(10,4),   -- 30天承接率
    CUST_TAKE_FLG                    VARCHAR2(1),    -- 客户承接状态
    FIXED_MATURE_TRAN_FIN_AMT        NUMBER(20,2),   -- 定期到期转理财金额
    FIXED_FIN_MATURE_TRAN_INSUR_AMT  NUMBER(20,2),   -- 定期理财到期转保险金额
    FIN_MATURE_TRAN_FIXED_AMT        NUMBER(20,2),   -- 理财到期转定期金额
    FRST_MATURE_PK_BF_DAY_AUM_BAL    NUMBER(20,2),   -- 第一笔到期前一日AUM
    CURR_AUM_BAL                     NUMBER(20,2),   -- 当前AUM余额
    FIX_DEPO_MATURE_AMT              NUMBER(20,2),   -- 定期存款已到期金额
    FIX_DEPO_MATURE_TTL_AMT          NUMBER(20,2),   -- 定期存款到期总金额
    FIX_DEPO_TAKE_RATE               NUMBER(10,4)    -- 定期存款30天承接率
);

-- 2.2 统计对象展开中间表
CREATE TABLE IF NOT EXISTS TMP_CDR_STAT_SRC (
    PERSN_LEGAL_BK_CODE              VARCHAR2(32),   -- 法人行号
    STATIS_OBJ                       VARCHAR2(64),   -- 统计对象
    DATA_DATE                        VARCHAR2(8),    -- 数据日期
    STAT_PERD                        VARCHAR2(1),    -- 统计周期：M-月,Q-季,Y-年
    STATIS_TYP                       VARCHAR2(1),    -- 承接类型：0-全部,1-存款,2-理财
    CUST_ID                          VARCHAR2(64),   -- 客户编号
    ORG_ID                           VARCHAR2(64),   -- 归属机构
    POST_ID                          VARCHAR2(64),   -- 管户经理
    EXPR_AMT                         NUMBER(20,2),   -- 已到期金额
    MATURE_TTL_AMT                   NUMBER(20,2),   -- 总到期金额
    TAKE_RATE_30D                    NUMBER(10,4),   -- 30天承接率
    CUST_TAKE_FLG                    VARCHAR2(1),    -- 客户承接状态
    FIXED_MATURE_TRAN_FIN_AMT        NUMBER(20,2),   -- 定期到期转理财金额
    FIXED_FIN_MATURE_TRAN_INSUR_AMT  NUMBER(20,2),   -- 定期理财到期转保险金额
    FIN_MATURE_TRAN_FIXED_AMT        NUMBER(20,2),   -- 理财到期转定期金额
    FRST_MATURE_PK_BF_DAY_AUM_BAL    NUMBER(20,2),   -- 第一笔到期前一日AUM
    CURR_AUM_BAL                     NUMBER(20,2),   -- 当前AUM余额
    FIX_DEPO_MATURE_AMT              NUMBER(20,2),   -- 定期存款已到期金额
    FIX_DEPO_MATURE_TTL_AMT          NUMBER(20,2),   -- 定期存款到期总金额
    FIX_DEPO_TAKE_RATE               NUMBER(10,4)    -- 定期存款30天承接率
);
