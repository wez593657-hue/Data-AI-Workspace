-- ============================================================
-- 到期承接明细表存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_DEADLINE_RMND_DTL
-- 需求版本: v2.7.0
-- ============================================================

-- 2.1 统计周期中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_PERIOD;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_PERIOD (
    STAT_PERD VARCHAR2(1),   -- 统计周期：M-月,Q-季,Y-年
    BGN_DT    DATE,          -- 统计周期开始日期
    END_DT    DATE           -- 统计周期结束日期
);

-- 2.2 到期产品源中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_MATURE_SRC;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_MATURE_SRC (
    CUST_ID              VARCHAR2(64),  -- 客户编号
    STATIS_TYP           VARCHAR2(1),   -- 承接类型：0-全部,1-存款,2-理财
    ACCT_ID              VARCHAR2(64),  -- 账户
    PRDKT_ID             VARCHAR2(64),  -- 产品编号
    PRDKT_NAME           VARCHAR2(200), -- 产品名称
    EXPR_AMT             NUMBER(20,2),  -- 到期金额
    EXPR_DT              DATE,          -- 到期日期
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    ORG_ID               VARCHAR2(64)   -- 归属机构
);

-- 2.3 到期窗口中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_DUE_WIN;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_DUE_WIN (
    STAT_PERD            VARCHAR2(1),   -- 统计周期：M-月,Q-季,Y-年
    BGN_DT               DATE,          -- 统计周期开始日期
    END_DT               DATE,          -- 统计周期结束日期
    CUST_ID              VARCHAR2(64),  -- 客户编号
    STATIS_TYP           VARCHAR2(1),   -- 承接类型：0-全部,1-存款,2-理财
    FIRST_EXPR_DT        DATE,          -- 本期第一笔到期日期
    LAST_EXPR_DT         DATE,          -- 本期最后一笔到期日期
    EXPR_AMT             NUMBER(20,2),  -- 已到期金额
    MATURE_TTL_AMT       NUMBER(20,2),  -- 总到期金额
    TAKE_END_DT_30D      DATE,          -- 30天承接窗口结束日期
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    ORG_ID               VARCHAR2(64)   -- 归属机构
);

-- 2.4 购买产品源中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_PURCHASE_SRC;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_PURCHASE_SRC (
    CUST_ID              VARCHAR2(64),  -- 客户编号
    PRDKT_TYP            VARCHAR2(10),  -- 购买产品类型：DEPO-存款,FIN-理财,INSUR-保险
    BUY_AMT              NUMBER(20,2),  -- 购买金额
    BUY_DT               DATE,          -- 购买日期
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    ORG_ID               VARCHAR2(64)   -- 归属机构
);

-- 2.5 承接金额中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_TAKE_AMT;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_TAKE_AMT (
    STAT_PERD            VARCHAR2(1),   -- 统计周期：M-月,Q-季,Y-年
    CUST_ID              VARCHAR2(64),  -- 客户编号
    STATIS_TYP           VARCHAR2(1),   -- 承接类型：0-全部,1-存款,2-理财
    TAKE_AMT_30D         NUMBER(20,2),  -- 30天长期化产品承接金额
    BUY_DEPO_AMT_30D     NUMBER(20,2),  -- 30天购买定期存款金额
    BUY_FIN_AMT_30D      NUMBER(20,2),  -- 30天购买理财金额
    BUY_INSUR_AMT_30D    NUMBER(20,2),  -- 30天购买保险金额
    FIRST_BUY_DT_30D     DATE,          -- 30天窗口内首次购买日期
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    ORG_ID               VARCHAR2(64)   -- 归属机构
);

-- 2.5.1 跨类型转化金额中间表(优化:预聚合替代关联子查询)
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_CROSS_CONV;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_CROSS_CONV (
    STAT_PERD                   VARCHAR2(1),   -- 统计周期：M-月,Q-季,Y-年
    CUST_ID                     VARCHAR2(64),  -- 客户编号
    PERSN_LEGAL_BK_CODE         VARCHAR2(32),  -- 法人行号
    ORG_ID                      VARCHAR2(64),  -- 归属机构
    FIN_MATURE_TRAN_FIXED_AMT   NUMBER(20,2),  -- 理财到期转定期金额(STATIS_TYP=2的BUY_DEPO_30D)
    FIXED_MATURE_TRAN_FIN_AMT   NUMBER(20,2)   -- 定期到期转理财金额(STATIS_TYP=1的BUY_FIN_30D)
);

-- 2.6 客户基础及余额中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_CUST_BASE;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_CUST_BASE (
    CUST_ID              VARCHAR2(64),  -- 客户编号
    CUST_NAME            VARCHAR2(200), -- 客户名称
    CUST_LVL             VARCHAR2(20),  -- 客户等级
    POST_ID              VARCHAR2(64),  -- 管户经理
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    DEPO_CURNT_DEPO_BAL  NUMBER(20,2),  -- 活期余额
    FIXD_DEPO_BAL        NUMBER(20,2),  -- 定期余额
    FIN_AMT              NUMBER(20,2),  -- 理财余额
    AUM_BAL              NUMBER(20,2)   -- 当前AUM余额
);

-- 2.7 AUM中间表
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_AUM_BAL;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_AUM_BAL (
    STAT_PERD            VARCHAR2(1),   -- 统计周期：M-月,Q-季,Y-年
    CUST_ID              VARCHAR2(64),  -- 客户编号
    STATIS_TYP           VARCHAR2(1),   -- 承接类型：0-全部,1-存款,2-理财
    AUM_TYP              VARCHAR2(10),  -- AUM类型：PREV-第一笔到期前一日,CURR-当前日
    DATA_DATE            VARCHAR2(8),   -- AUM数据日期
    AUM_BAL              NUMBER(20,2),  -- AUM余额
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    ORG_ID               VARCHAR2(64)   -- 归属机构
);

-- 2.8 本期隔离存储表（v3.0.0：两期计算完全分离，本期结果仅写入本表）
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_CURR_STAGE;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_CURR_STAGE (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),   -- 法人行号
    DATA_DATE             VARCHAR2(8),   -- 数据日期=跑批日期V_SYSDAT
    CUST_ID               VARCHAR2(20),  -- 客户编号
    CUST_NAME             VARCHAR2(100), -- 客户名称
    CUST_LVL              VARCHAR2(2),   -- 客户等级
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),  -- 活期余额
    FIXD_DEPO_BAL         NUMBER(20,2),  -- 定期余额
    FIN_AMT               NUMBER(20,2),  -- 理财余额
    STAT_PERD             VARCHAR2(2),   -- 统计周期：M-月,Q-季,Y-年
    STATIS_TYP            VARCHAR2(2),   -- 承接类型：0-全部,1-存款,2-理财
    EXPR_AMT              NUMBER(20,2),  -- 到期金额
    MATURE_TTL_AMT        NUMBER(20,2),  -- 到期总金额
    TAKE_RATE             NUMBER(10,2),  -- 30天客户承接金额占比
    FIX_DEPO_MATURE_AMT   NUMBER(20,2),  -- 定期存款到期金额
    FIX_DEPO_MATURE_TTL_AMT NUMBER(20,2),-- 定期存款到期总金额
    FIX_DEPO_TAKE_RATE    NUMBER(10,2),  -- 定期存款30天承接率
    CNTCT_STATE           VARCHAR2(1),   -- 接触状态
    UNDTAKE_STATE         VARCHAR2(1),   -- 承接状态
    FIXED_FIN_MATURE_TRAN_INSUR_AMT NUMBER(20,2), -- 到期转保险金额
    FIN_MATURE_TRAN_FIXED_AMT NUMBER(20,2), -- 理财到期转定期金额
    FIXED_MATURE_TRAN_FIN_AMT NUMBER(20,2), -- 定期到期转理财金额
    FRST_MATURE_PK_BF_DAY_AUM_BAL NUMBER(20,2), -- 本期第一笔到期产品前一日AUM余额
    LAST_END_DATE         VARCHAR2(8),   -- 本期最后一笔到期产品日期
    POST_ID               VARCHAR2(20),  -- 管户经理
    ORG_ID                VARCHAR2(7)    -- 归属机构
);

-- 2.9 上期隔离存储表（v3.0.0：上期结果仅写入本表，目标表仅定点更新7字段）
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_PREV_STAGE;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_PREV_STAGE (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),   -- 法人行号
    DATA_DATE             VARCHAR2(8),   -- 数据日期=上期期末日期
    CUST_ID               VARCHAR2(20),  -- 客户编号
    CUST_NAME             VARCHAR2(100), -- 客户名称
    CUST_LVL              VARCHAR2(2),   -- 客户等级
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),  -- 活期余额
    FIXD_DEPO_BAL         NUMBER(20,2),  -- 定期余额
    FIN_AMT               NUMBER(20,2),  -- 理财余额
    STAT_PERD             VARCHAR2(2),   -- 统计周期：M-月,Q-季,Y-年
    STATIS_TYP            VARCHAR2(2),   -- 承接类型：0-全部,1-存款,2-理财
    EXPR_AMT              NUMBER(20,2),  -- 到期金额
    MATURE_TTL_AMT        NUMBER(20,2),  -- 到期总金额
    TAKE_RATE             NUMBER(10,2),  -- 30天客户承接金额占比
    FIX_DEPO_MATURE_AMT   NUMBER(20,2),  -- 定期存款到期金额
    FIX_DEPO_MATURE_TTL_AMT NUMBER(20,2),-- 定期存款到期总金额
    FIX_DEPO_TAKE_RATE    NUMBER(10,2),  -- 定期存款30天承接率
    CNTCT_STATE           VARCHAR2(1),   -- 接触状态
    UNDTAKE_STATE         VARCHAR2(1),   -- 承接状态
    FIXED_FIN_MATURE_TRAN_INSUR_AMT NUMBER(20,2), -- 到期转保险金额
    FIN_MATURE_TRAN_FIXED_AMT NUMBER(20,2), -- 理财到期转定期金额
    FIXED_MATURE_TRAN_FIN_AMT NUMBER(20,2), -- 定期到期转理财金额
    FRST_MATURE_PK_BF_DAY_AUM_BAL NUMBER(20,2), -- 本期第一笔到期产品前一日AUM余额
    LAST_END_DATE         VARCHAR2(8),   -- 本期最后一笔到期产品日期
    POST_ID               VARCHAR2(20),  -- 管户经理
    ORG_ID                VARCHAR2(7)    -- 归属机构
);

-- 2.10 上期冻结快照表（v3.0.0：验证段比对18基础字段是否被修改）
DROP TABLE IF NOT EXISTS TMP_CDR_DTL_FREEZE_LOG;
CREATE TABLE IF NOT EXISTS TMP_CDR_DTL_FREEZE_LOG (
    BATCH_DATE            VARCHAR2(8),   -- 跑批日期
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),   -- 法人行号
    DATA_DATE             VARCHAR2(8),   -- 数据日期
    CUST_ID               VARCHAR2(20),  -- 客户编号
    CUST_NAME             VARCHAR2(100), -- 客户名称
    CUST_LVL              VARCHAR2(2),   -- 客户等级
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),  -- 活期余额
    FIXD_DEPO_BAL         NUMBER(20,2),  -- 定期余额
    FIN_AMT               NUMBER(20,2),  -- 理财余额
    STAT_PERD             VARCHAR2(2),   -- 统计周期
    STATIS_TYP            VARCHAR2(2),   -- 承接类型
    EXPR_AMT              NUMBER(20,2),  -- 到期金额
    MATURE_TTL_AMT        NUMBER(20,2),  -- 到期总金额
    TAKE_RATE             NUMBER(10,2),  -- 承接率
    FIX_DEPO_MATURE_AMT   NUMBER(20,2),  -- 定期存款到期金额
    FIX_DEPO_MATURE_TTL_AMT NUMBER(20,2),-- 定期存款到期总金额
    FIX_DEPO_TAKE_RATE    NUMBER(10,2),  -- 定期存款承接率
    CNTCT_STATE           VARCHAR2(1),   -- 接触状态
    UNDTAKE_STATE         VARCHAR2(1),   -- 承接状态
    FIXED_FIN_MATURE_TRAN_INSUR_AMT NUMBER(20,2), -- 到期转保险金额
    FIN_MATURE_TRAN_FIXED_AMT NUMBER(20,2), -- 理财到期转定期金额
    FIXED_MATURE_TRAN_FIN_AMT NUMBER(20,2), -- 定期到期转理财金额
    FRST_MATURE_PK_BF_DAY_AUM_BAL NUMBER(20,2), -- 第一笔到期前一日AUM
    LAST_END_DATE         VARCHAR2(8),   -- 最后一笔到期产品日期
    POST_ID               VARCHAR2(20),  -- 管户经理
    ORG_ID                VARCHAR2(7)    -- 归属机构
);

-- 2.11 两期验证结果日志表（v3.0.0：DTL/STATIS 共用，FAIL即中止批次）
DROP TABLE IF NOT EXISTS TMP_CDR_VALIDATE_RESULT;
CREATE TABLE IF NOT EXISTS TMP_CDR_VALIDATE_RESULT (
    BATCH_DATE    VARCHAR2(8),   -- 跑批日期
    PERIOD_TYP    VARCHAR2(1),   -- 期别：C-本期,P-上期
    VALIDATE_ITEM VARCHAR2(100), -- 校验项
    RESULT        VARCHAR2(5),   -- PASS/FAIL
    DETAIL        VARCHAR2(500), -- 校验说明
    CHECK_TIME    DATE           -- 校验时间
);
