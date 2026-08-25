-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_009
-- 功能说明: 指标数据统计——步骤9（手机银行/一码付交易金额与笔数指标汇总）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（结果行数/标志）
-- 需求版本: v5.1 (2026-08-25)
-- 变更记录:
--   v5.0 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_009，段首自清（并行跑批隔离）
--   v5.1 0078/0079支付退款区分：金额净额化(01退款取负)，笔数含退款单；ORDER_TYPE IN('00','01')
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_009
(
    V_SYSDAT  IN VARCHAR2,
    OUTCDE OUT INTEGER
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤99处理完成 9';   -- 过程描述（写入步骤日志；文本中'步骤99'与过程号009不一致【待确认】）
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_009';
    V_LOG_MSG    VARCHAR2(4000);
    V_LOG_FLG    INTEGER;
    V_LOG_BUTTON INTEGER := 1;
    V_NO_ID      VARCHAR2(10);
    V_BGN_DATE   DATE;
    V_END_DATE   DATE;
    V_DURA_DATE  INTEGER;
BEGIN
    -------------------------------------------------------------------------
    -- 运行变量初始化与入参校验
    -------------------------------------------------------------------------
    V_NO_ID := '0';                 -- 业务流水号（固定 '0'）【待确认：取值与用途】
    V_BGN_DATE := SYSDATE;          -- 过程起始时间
    IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
    END IF;
    V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');    -- 跑批业务日期转 DATE

    -------------------------------------------------------------------------
    -- 段首自清：清空本过程专属汇总临时表，防止重跑/并行跑批残留
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_AGGR_009;

    -------------------------------------------------------------------------
    -- 0074/0075：手机银行交易金额/笔数 (合并 A/B 路径)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_009
    (
        PATH_CODE,
        DATA_DATE,
        DATA_BLNG,
        STATIS_DIM,
        STATIS_CALIB,
        INDX_CODE,
        CURNT_VAL,
        TERM_LAST_VAL,
        PERSN_LEGAL_BK_CODE
    )
    WITH SCOPE_ALL AS
    (
        -- 统一获取 A/B 路径的目标客户范围
        SELECT 'A'           AS PATH_CODE,   -- 路径标识：A=营销活动
               '营销活动'      AS STATIS_CALIB,
               S.STATIS_DIM,
               S.DATA_BLNG,
               S.TERM_BEGIN_DATE,
               TI.CUST_ID,                 -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE
          FROM TMP_STAT_INDX_SCOPE S
         INNER JOIN DWD_MKT_TSK_INFO TI
                 ON TI.MKT_ACT_ID = S.STATIS_DIM
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                AND TI.DATA_DATE = V_SYSDAT
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)
                     OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))
         WHERE S.PATH_CODE = 'A'
           AND S.INDX_CODE IN ('INDX_0074', 'INDX_0075')
        UNION ALL
        SELECT 'B'           AS PATH_CODE,   -- 路径标识：B=目标任务
               '目标任务'      AS STATIS_CALIB,
               S.STATIS_DIM,
               S.DATA_BLNG,
               S.TERM_BEGIN_DATE,
               LV.CUST_ID,                 -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE
          FROM TMP_STAT_INDX_SCOPE S
         INNER JOIN DWS_CUST_LVL_INFO LV
                 ON S.BLNG_TYPE = 'O'
                AND LV.ORG_ID = S.BLNG_ID
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                AND LV.DATA_DATE = V_SYSDAT
         WHERE S.PATH_CODE = 'B'
           AND S.INDX_CODE IN ('INDX_0074', 'INDX_0075')
        UNION ALL
        SELECT 'B'           AS PATH_CODE,
               '目标任务'      AS STATIS_CALIB,
               S.STATIS_DIM,
               S.DATA_BLNG,
               S.TERM_BEGIN_DATE,
               CM.CUST_ID,                 -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE
          FROM TMP_STAT_INDX_SCOPE S
         INNER JOIN DWD_CUST_MAN CM
                 ON S.BLNG_TYPE = 'M'
                AND CM.MNGR_POST_ID = S.BLNG_ID
                AND CM.MNG_TYP = '1'
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
         WHERE S.PATH_CODE = 'B'
           AND S.INDX_CODE IN ('INDX_0074', 'INDX_0075')
    ),
    SCOPE_DISTINCT AS
    (
        -- 按维度去重后的目标客户范围
        SELECT DISTINCT PATH_CODE,
                        STATIS_CALIB,
                        STATIS_DIM,
                        DATA_BLNG,
                        TERM_BEGIN_DATE,
                        CUST_ID,
                        PERSN_LEGAL_BK_CODE
          FROM SCOPE_ALL
    ),
    MBK_BASE AS
    (
        -- 预关联客户基础信息，避免后续 10 个交易表重复 JOIN
        SELECT SC.PATH_CODE,
               SC.STATIS_CALIB,
               SC.STATIS_DIM,
               SC.DATA_BLNG,
               SC.PERSN_LEGAL_BK_CODE,
               SC.TERM_BEGIN_DATE,
               MI.CUST_NO
          FROM SCOPE_DISTINCT SC
         INNER JOIN MBK_CUST_INFO MI
                 ON MI.CUST_CORE_NO = SC.CUST_ID
                AND MI.INCORP_NO = SC.PERSN_LEGAL_BK_CODE
         INNER JOIN DWD_CUST_INDV_INFO CI
                 ON CI.CUST_ID = SC.CUST_ID
                AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE
    ),
    MBK_TRANS_ALL AS
    (
        -- 商圈
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               Y.AMT     AS TRAN_AMT,     -- 商圈交易金额
               1         AS TRAN_NUM      -- 商圈交易笔数（固定 1）
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_ACCT CA ON CA.CUST_NO = B.CUST_NO
         INNER JOIN IBP_IB_LIST_PLAT Y
                 ON Y.ACCT_NO = CA.ACCT
                AND Y.ITEM_ID = '100015'
                AND Y.CHANNEL_ID = '3031'
                AND Y.PLAT_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND CASE SUBSTR(Y.BRANCH_CODE, 1, 2)   -- 机构前两位折算核算机构
                        WHEN '12' THEN '1200'
                        WHEN '15' THEN '1500'
                        WHEN '18' THEN '1800'
                        ELSE '9999'
                    END = B.PERSN_LEGAL_BK_CODE
        UNION ALL
        -- 酷屏
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               Y.AMT,
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_ACCT CA ON CA.CUST_NO = B.CUST_NO
         INNER JOIN IBP_IB_LIST_PLAT Y
                 ON Y.ACCT_NO = CA.ACCT
                AND Y.ITEM_ID = '100012'
                AND Y.CHANNEL_ID = '3031'
                AND Y.SETTLE_CD_FLAG = 'D'
                AND Y.PLAT_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND CASE SUBSTR(Y.BRANCH_CODE, 1, 2)
                        WHEN '12' THEN '1200'
                        WHEN '15' THEN '1500'
                        WHEN '18' THEN '1800'
                        ELSE '9999'
                    END = B.PERSN_LEGAL_BK_CODE
        UNION ALL
        -- 转账
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               T.TRAN_AMT,
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_LOG_TRAN T
                 ON T.CUST_NO = B.CUST_NO
                AND T.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND T.TRAN_STATUS = '1'
                AND NVL(T.TRAN_AMT, 0) <> 0     -- 排除交易金额为空的记录
        UNION ALL
        -- 理财
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               F.TRAN_AMT,
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_LOG_FINANCE F
                 ON F.CUST_NO = B.CUST_NO
                AND F.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND F.TRAN_STATUS = '1'
                AND NVL(F.TRAN_AMT, 0) <> 0
        UNION ALL
        -- 生活缴费
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               CAST(NULLIF(F.TRAN_AMT, '') AS DECIMAL(31, 2)),    -- 缴费金额（空串转 NULL 再转 DECIMAL）
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_LOG_FEE F
                 ON F.CUST_NO = B.CUST_NO
                AND F.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND F.TRAN_STATUS = '1'
                AND NVL(CAST(NULLIF(F.TRAN_AMT, '') AS DECIMAL(31, 2)), 0) <> 0
                AND CASE SUBSTR(F.DEPT_ID, 1, 2)
                        WHEN '12' THEN '1200'
                        WHEN '15' THEN '1500'
                        WHEN '18' THEN '1800'
                        ELSE '9999'
                    END = B.PERSN_LEGAL_BK_CODE
        UNION ALL
        -- 无卡预约取款
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               CAST(NULLIF(O.TRAN_AMT, '') AS DECIMAL(31, 2)),
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_LOG_OPER O
                 ON O.CUST_NO = B.CUST_NO
                AND O.TRAN_CODE = 'atm/noCardPredMoney'
                AND O.TRAN_STATUS = '1'
                AND O.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
        UNION ALL
        -- 扫码取款
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               CAST(NULLIF(P.SENCE_VALUE, '') AS DECIMAL(31, 2)),
               1
          FROM MBK_BASE B
         INNER JOIN MBK_MKP_PROCESS_INFO P
                 ON P.CUST_NO = B.CUST_NO
                AND P.TRANS_SN NOT LIKE 'AP%'
                AND LENGTH(P.TRANS_SN) > 18
                AND P.SENCE_TIME BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
        UNION ALL
        -- 存款/乐惠存
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               B2.TRAN_AMT,
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_LOG_BASE_FINANCE B2
                 ON B2.CUST_NO = B.CUST_NO
                AND B2.TRAN_STATUS = '1'
                AND B2.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND NVL(B2.TRAN_AMT, 0) <> 0
        UNION ALL
        -- 贷款
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               CAST(NULLIF(L.BUSINESSSUM, '') AS DECIMAL(31, 2)),
               1
          FROM MBK_BASE B
         INNER JOIN MBK_CUST_LOG_LOAN L
                 ON L.CUST_NO = B.CUST_NO
                AND L.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND NVL(CAST(NULLIF(L.BUSINESSSUM, '') AS DECIMAL(31, 2)), 0) <> 0
        UNION ALL
        -- 移动支付
        SELECT B.PATH_CODE,
               B.STATIS_CALIB,
               B.STATIS_DIM,
               B.DATA_BLNG,
               B.PERSN_LEGAL_BK_CODE,
               CAST(NULLIF(Q.TXN_AMT, '') AS DECIMAL(31, 2)),
               1
          FROM MBK_BASE B
         INNER JOIN MBK_QR_C2B_QUERYTRANS Q
                 ON Q.CUST_NO = B.CUST_NO
                AND Q.STATUS = '1'
                AND Q.ORDERTIME BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT
                AND NVL(CAST(NULLIF(Q.TXN_AMT, '') AS DECIMAL(31, 2)), 0) <> 0
    )
    SELECT PATH_CODE,
           V_SYSDAT,          -- 数据日期（跑批业务日期）
           DATA_BLNG,
           STATIS_DIM,
           STATIS_CALIB,
           'INDX_0074',       -- 金额指标
           SUM(TRAN_AMT),     -- 交易金额合计
           0,
           PERSN_LEGAL_BK_CODE
      FROM MBK_TRANS_ALL
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE
    UNION ALL
    SELECT PATH_CODE,
           V_SYSDAT,
           DATA_BLNG,
           STATIS_DIM,
           STATIS_CALIB,
           'INDX_0075',       -- 笔数指标
           SUM(TRAN_NUM),     -- 交易笔数合计
           0,
           PERSN_LEGAL_BK_CODE
      FROM MBK_TRANS_ALL
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- 0078/0079：一码付交易金额/笔数 (合并 A/B 路径)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_009
    (
        PATH_CODE,
        DATA_DATE,
        DATA_BLNG,
        STATIS_DIM,
        STATIS_CALIB,
        INDX_CODE,
        CURNT_VAL,
        TERM_LAST_VAL,
        PERSN_LEGAL_BK_CODE
    )
    WITH SCOPE_ALL AS
    (
        -- 统一获取 A/B 路径的目标客户范围
        SELECT 'A'           AS PATH_CODE,   -- 路径标识：A=营销活动
               '营销活动'      AS STATIS_CALIB,
               S.STATIS_DIM,
               S.DATA_BLNG,
               S.TERM_BEGIN_DATE,
               TI.CUST_ID,
               S.PERSN_LEGAL_BK_CODE
          FROM TMP_STAT_INDX_SCOPE S
         INNER JOIN DWD_MKT_TSK_INFO TI
                 ON TI.MKT_ACT_ID = S.STATIS_DIM
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                AND TI.DATA_DATE = V_SYSDAT
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)
                     OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))
         WHERE S.PATH_CODE = 'A'
           AND S.INDX_CODE IN ('INDX_0078', 'INDX_0079')
        UNION ALL
        SELECT 'B'           AS PATH_CODE,
               '目标任务'      AS STATIS_CALIB,
               S.STATIS_DIM,
               S.DATA_BLNG,
               S.TERM_BEGIN_DATE,
               LV.CUST_ID,
               S.PERSN_LEGAL_BK_CODE
          FROM TMP_STAT_INDX_SCOPE S
         INNER JOIN DWS_CUST_LVL_INFO LV
                 ON S.BLNG_TYPE = 'O'
                AND LV.ORG_ID = S.BLNG_ID
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
                AND LV.DATA_DATE = V_SYSDAT
         WHERE S.PATH_CODE = 'B'
           AND S.INDX_CODE IN ('INDX_0078', 'INDX_0079')
        UNION ALL
        SELECT 'B'           AS PATH_CODE,
               '目标任务'      AS STATIS_CALIB,
               S.STATIS_DIM,
               S.DATA_BLNG,
               S.TERM_BEGIN_DATE,
               CM.CUST_ID,
               S.PERSN_LEGAL_BK_CODE
          FROM TMP_STAT_INDX_SCOPE S
         INNER JOIN DWD_CUST_MAN CM
                 ON S.BLNG_TYPE = 'M'
                AND CM.MNGR_POST_ID = S.BLNG_ID
                AND CM.MNG_TYP = '1'
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
         WHERE S.PATH_CODE = 'B'
           AND S.INDX_CODE IN ('INDX_0078', 'INDX_0079')
    ),
    ACQ_TRANS AS
    (
        -- 一码付收单交易（00 支付 / 01 退款）
        SELECT SC.PATH_CODE,
               SC.STATIS_CALIB,
               SC.STATIS_DIM,
               SC.DATA_BLNG,
               SC.PERSN_LEGAL_BK_CODE,
               CASE WHEN O.ORDER_TYPE = '01' THEN -O.ORDER_AMT ELSE O.ORDER_AMT END AS TRAN_AMT,   -- 01退款取负，00支付为正（金额净额化）
               1                                                                        AS TRAN_NUM
          FROM (SELECT DISTINCT PATH_CODE,
                                STATIS_CALIB,
                                STATIS_DIM,
                                DATA_BLNG,
                                TERM_BEGIN_DATE,
                                CUST_ID,
                                PERSN_LEGAL_BK_CODE
                  FROM SCOPE_ALL) SC
         INNER JOIN DWD_CUST_INDV_INFO CI
                 ON CI.CUST_ID = SC.CUST_ID
                AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE
         INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA
                 ON SA.CUST_NO = SC.CUST_ID
                AND SA.STATUS <> '9'
         INNER JOIN UEPP_PAY_MCT_INFO M
                 ON M.MCT_ID = SA.MCT_ID
                AND M.MCT_TYPE IN ('personage', 'smallBusinesses')
                AND M.STATUS <> '9'
         INNER JOIN UEPP_PAY_ORDER_INFO O
                 ON O.MCT_ID = SA.MCT_ID
                AND O.STATUS = '02'
                AND O.ORDER_TYPE IN ('00', '01')      -- 00支付 01退款（值域仅此两值）
                AND O.PAY_TIME BETWEEN SC.TERM_BEGIN_DATE AND V_SYSDAT
    )
    SELECT PATH_CODE,
           V_SYSDAT,
           DATA_BLNG,
           STATIS_DIM,
           STATIS_CALIB,
           'INDX_0078',      -- 金额指标
           SUM(TRAN_AMT),    -- 一码付交易金额净额合计（退款为负）
           0,
           PERSN_LEGAL_BK_CODE
      FROM ACQ_TRANS
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE
    UNION ALL
    SELECT PATH_CODE,
           V_SYSDAT,
           DATA_BLNG,
           STATIS_DIM,
           STATIS_CALIB,
           'INDX_0079',      -- 笔数指标
           SUM(TRAN_NUM),    -- 一码付交易笔数合计（含退款单）
           0,
           PERSN_LEGAL_BK_CODE
      FROM ACQ_TRANS
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- 返回本次写入行数并提交
    -------------------------------------------------------------------------
    OUTCDE := SQL%ROWCOUNT;     -- 取最后一条 DML（0078/0079 写入）的影响行数
    COMMIT;

    -------------------------------------------------------------------------
    -- 记录本步骤执行日志
    -------------------------------------------------------------------------
    V_END_DATE := SYSDATE;      -- 过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);    -- 运行耗时（秒）
    V_LOG_MSG := '步骤9处理完成，行数=' || NVL(OUTCDE, 0);
    V_LOG_FLG := 0;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        OUTCDE := -1;                       -- 异常以 -1 标识失败
        V_END_DATE := SYSDATE;
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);      -- 异常信息截断记录
        V_LOG_FLG := -1;
        SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
        RAISE;
END PRC_ADS_STAT_INDX_PLAN_009;