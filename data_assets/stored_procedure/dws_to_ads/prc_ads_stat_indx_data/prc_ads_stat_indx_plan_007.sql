-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_007
-- 功能说明: 指标数据统计——步骤7（按多路径计算多项新增类指标，汇总写入专属临时表）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（影响行数 / 错误标志）
-- 需求版本: v5.0 (2026-08-25)
-- 变更记录:
--   v5.0 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_007，段首自清（并行跑批隔离）
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_007
(
    V_SYSDAT  IN VARCHAR2,
    OUTCDE OUT INTEGER
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤77处理完成 7';          -- 步骤描述
    V_PRC_NAME VARCHAR2(32) := 'PRC_ADS_STAT_INDX_PLAN_007';          -- 过程名
    V_LOG_MSG VARCHAR2(4000);
    V_LOG_FLG INTEGER;
    V_LOG_BUTTON INTEGER := 1;
    V_NO_ID VARCHAR2(10);
    V_BGN_DATE DATE;
    V_END_DATE DATE;
    V_DURA_DATE INTEGER;
    V_180_DAY_BEGIN VARCHAR2(8);
BEGIN
    V_NO_ID := '0';
    V_BGN_DATE := SYSDATE;
    -- 参数校验：跑批日期必须为 8 位数字 YYYYMMDD
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');
    -- 计算往前回推 27 个自然日（约 180 天口径）的起始日期，用于新客判定
    V_180_DAY_BEGIN := SYS_FUN_DEAL_DATE(V_SYSDAT, 27);

    -------------------------------------------------------------------------
    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_AGGR_007;

    -------------------------------------------------------------------------
    -- INDX_0080 新客交叉销售 (合并 A/B)
    -- 说明: 营销活动(A)/目标任务(B)两路径取数并经客户维度去重后，
    --       统计开户时间在 180 天窗口内且持有两类及以上产品（手机银行/存款/理财/贷款）的交叉销售客户数
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007
        (PATH_CODE,
         DATA_DATE,
         DATA_BLNG,
         STATIS_DIM,
         STATIS_CALIB,
         INDX_CODE,
         CURNT_VAL,
         TERM_LAST_VAL,
         PERSN_LEGAL_BK_CODE)
        WITH SCOPE_ALL AS
         (SELECT 'A'       AS PATH_CODE,
                 '营销活动' AS STATIS_CALIB,
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
            AND S.INDX_CODE = 'INDX_0080'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0080'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0080'),
        CUST_FLAGS AS
         (SELECT SM.PATH_CODE,
                 SM.STATIS_CALIB,
                 SM.STATIS_DIM,
                 SM.DATA_BLNG,
                 SM.TERM_BEGIN_DATE,
                 SM.CUST_ID,
                 SM.PERSN_LEGAL_BK_CODE,
                 CI.OPEN_DATE,
                 MAX(CASE WHEN MI.CUST_NO IS NOT NULL THEN 1 ELSE 0 END) AS HAS_MBK,
                 MAX(CASE WHEN NVL(B.DEPO_CURNT_DEPO_BAL, 0) + NVL(B.FIXD_DEPO_BAL, 0) >= 100 THEN 1 ELSE 0 END) AS HAS_DEPO,
                 MAX(CASE WHEN NVL(B.FIN_BAL, 0) > 0 THEN 1 ELSE 0 END) AS HAS_FIN,
                 MAX(CASE WHEN NVL(B.LOAN_BAL, 0) > 0 THEN 1 ELSE 0 END) AS HAS_LOAN
           FROM (SELECT DISTINCT PATH_CODE,
                                  STATIS_CALIB,
                                  STATIS_DIM,
                                  DATA_BLNG,
                                  TERM_BEGIN_DATE,
                                  CUST_ID,
                                  PERSN_LEGAL_BK_CODE
                   FROM SCOPE_ALL) SM
       LEFT JOIN DWD_CUST_INDV_INFO CI
              ON CI.CUST_ID = SM.CUST_ID
             AND CI.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE
       LEFT JOIN MBK_CUST_INFO MI
              ON MI.CUST_CORE_NO = SM.CUST_ID
             AND MI.INCORP_NO = SM.PERSN_LEGAL_BK_CODE
             AND MI.CUST_STATUS = '1'
       LEFT JOIN DWS_CUST_ASSE_LIAB B
              ON B.CUST_ID = SM.CUST_ID
             AND B.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE
             AND B.DATA_DATE = V_SYSDAT
             AND B.BAL_TYPE = '1'
        GROUP BY SM.PATH_CODE,
                 SM.STATIS_CALIB,
                 SM.STATIS_DIM,
                 SM.DATA_BLNG,
                 SM.TERM_BEGIN_DATE,
                 SM.CUST_ID,
                 SM.PERSN_LEGAL_BK_CODE,
                 CI.OPEN_DATE)
        SELECT PATH_CODE,
               V_SYSDAT,
               DATA_BLNG,
               STATIS_DIM,
               STATIS_CALIB,
               'INDX_0080',
               COUNT(DISTINCT CASE
                    WHEN OPEN_DATE BETWEEN V_180_DAY_BEGIN AND V_SYSDAT
                     AND HAS_MBK + HAS_DEPO + HAS_FIN + HAS_LOAN >= 2 THEN
                        CUST_ID
                  END),
               0,
               PERSN_LEGAL_BK_CODE
          FROM CUST_FLAGS
        GROUP BY PATH_CODE,
                 DATA_BLNG,
                 STATIS_DIM,
                 STATIS_CALIB,
                 PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- INDX_0082 新增客户数 (合并 A/B)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007
        (PATH_CODE,
         DATA_DATE,
         DATA_BLNG,
         STATIS_DIM,
         STATIS_CALIB,
         INDX_CODE,
         CURNT_VAL,
         TERM_LAST_VAL,
         PERSN_LEGAL_BK_CODE)
        WITH SCOPE_ALL AS
         (SELECT 'A'       AS PATH_CODE,
                 '营销活动' AS STATIS_CALIB,
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
            AND S.INDX_CODE = 'INDX_0082'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0082'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0082')
        SELECT SM.PATH_CODE,
               V_SYSDAT,
               SM.DATA_BLNG,
               SM.STATIS_DIM,
               SM.STATIS_CALIB,
               'INDX_0082',
               COUNT(DISTINCT CASE
                    WHEN CI.OPEN_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT THEN
                        SM.CUST_ID
                  END),
               0,
               SM.PERSN_LEGAL_BK_CODE
          FROM (SELECT DISTINCT PATH_CODE,
                                 STATIS_CALIB,
                                 STATIS_DIM,
                                 DATA_BLNG,
                                 TERM_BEGIN_DATE,
                                 CUST_ID,
                                 PERSN_LEGAL_BK_CODE
                   FROM SCOPE_ALL) SM
       LEFT JOIN DWD_CUST_INDV_INFO CI
              ON CI.CUST_ID = SM.CUST_ID
             AND CI.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE
        GROUP BY SM.PATH_CODE,
                 SM.DATA_BLNG,
                 SM.STATIS_DIM,
                 SM.STATIS_CALIB,
                 SM.PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- INDX_0073 手机银行客户数新增 (合并 A/B)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007
        (PATH_CODE,
         DATA_DATE,
         DATA_BLNG,
         STATIS_DIM,
         STATIS_CALIB,
         INDX_CODE,
         CURNT_VAL,
         TERM_LAST_VAL,
         PERSN_LEGAL_BK_CODE)
        WITH SCOPE_ALL AS
         (SELECT 'A'       AS PATH_CODE,
                 '营销活动' AS STATIS_CALIB,
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
            AND S.INDX_CODE = 'INDX_0073'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0073'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0073')
        SELECT SM.PATH_CODE,
               V_SYSDAT,
               SM.DATA_BLNG,
               SM.STATIS_DIM,
               SM.STATIS_CALIB,
               'INDX_0073',
               COUNT(DISTINCT CASE
                    WHEN MI.CUST_OPEN_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT THEN
                        SM.CUST_ID
                  END),
               0,
               SM.PERSN_LEGAL_BK_CODE
          FROM (SELECT DISTINCT PATH_CODE,
                                 STATIS_CALIB,
                                 STATIS_DIM,
                                 DATA_BLNG,
                                 TERM_BEGIN_DATE,
                                 CUST_ID,
                                 PERSN_LEGAL_BK_CODE
                   FROM SCOPE_ALL) SM
       LEFT JOIN MBK_CUST_INFO MI
              ON MI.CUST_CORE_NO = SM.CUST_ID
             AND MI.INCORP_NO = SM.PERSN_LEGAL_BK_CODE
        GROUP BY SM.PATH_CODE,
                 SM.DATA_BLNG,
                 SM.STATIS_DIM,
                 SM.STATIS_CALIB,
                 SM.PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- INDX_0083 借记卡新开净增量（CBS发卡日期，合并 A/B）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007
        (PATH_CODE,
         DATA_DATE,
         DATA_BLNG,
         STATIS_DIM,
         STATIS_CALIB,
         INDX_CODE,
         CURNT_VAL,
         TERM_LAST_VAL,
         PERSN_LEGAL_BK_CODE)
        WITH SCOPE_ALL AS
         (SELECT 'A'       AS PATH_CODE,
                 '营销活动' AS STATIS_CALIB,
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
            AND S.INDX_CODE = 'INDX_0083'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0083'
         UNION ALL
         SELECT 'B',
                '目标任务',
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
            AND S.INDX_CODE = 'INDX_0083')
        SELECT SM.PATH_CODE,
               V_SYSDAT,
               SM.DATA_BLNG,
               SM.STATIS_DIM,
               SM.STATIS_CALIB,
               'INDX_0083',
               COUNT(DISTINCT C.KAHAOOOO),
               0,
               SM.PERSN_LEGAL_BK_CODE
          FROM (SELECT DISTINCT PATH_CODE,
                                 STATIS_CALIB,
                                 STATIS_DIM,
                                 DATA_BLNG,
                                 TERM_BEGIN_DATE,
                                 CUST_ID,
                                 PERSN_LEGAL_BK_CODE
                   FROM SCOPE_ALL) SM
        INNER JOIN CBS_KCDA_PZJCXX C
               ON C.KEHUHAOO = SM.CUST_ID
              AND CASE
                    WHEN C.FAKAJIGO LIKE '12%' THEN '1200'
                    WHEN C.FAKAJIGO LIKE '15%' THEN '1500'
                    WHEN C.FAKAJIGO LIKE '18%' THEN '1800'
                    ELSE '9999'
                  END = SM.PERSN_LEGAL_BK_CODE
              AND C.FAKARIQI BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT
              AND C.PZSYZTAI IN ('0','1','3','4','5','6','D','E','F','K','N','M','j','m','n','h','y')
        INNER JOIN CBS_KDPA_KEHUZH K
               ON K.KEHUZHAO = C.KAHAOOOO
              AND K.ZHHUFENL IN ('1','2') -- 一类户 二类户
        GROUP BY SM.PATH_CODE,
                 SM.DATA_BLNG,
                 SM.STATIS_DIM,
                 SM.STATIS_CALIB,
                 SM.PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- 汇总入库收尾：记录影响行数、提交事务、写跑批日志（成功路径）
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    V_LOG_MSG := '步骤7处理完成，行数=' || NVL(outcde, 0);
    V_LOG_FLG := 0;
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
EXCEPTION
    WHEN OTHERS THEN
        -- 异常处理：回滚事务并记录错误日志后重新抛出
        ROLLBACK;
        outcde := -1;
        V_END_DATE := SYSDATE;
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
        V_LOG_FLG := -1;
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
        RAISE;
END PRC_ADS_STAT_INDX_PLAN_007;