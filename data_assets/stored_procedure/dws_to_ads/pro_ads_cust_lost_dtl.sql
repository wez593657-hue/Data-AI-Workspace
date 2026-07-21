CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_LOST_DTL(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：客户流失清单处理
  -- 处理周期: 日
  -- 过程描述: 按轻度、重度流失规则，计算接触、挽回和挽回金融资产
  -- 来源表: DWS_CUST_ASSE_LIAB, DWD_CUST_INDV_INFO, DWS_CUST_LVL_INFO, ADS_MKT_REC_INFO
  -- 目标表: ADS_CUST_LOST_DTL
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.1.0
  -- 关联需求: REQ-CUST-001
  -- 变更记录:
  --   v2.1.0: 1.已挽回金融资产口径确认：T-1日金融资产余额达标的客户，从月初~T-1日金融资产新增总金额，单个客户的挽回金融资产为当前T-1日客户金融资产减去上月末时点的金融资产余额
  --           2.明细表新增RESCUED_FINA_ASSET字段，存储单个客户的挽回金融资产金额
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '客户流失清单处理';
  V_PRC_NAME             VARCHAR(64)  := 'PRO_ADS_CUST_LOST_DTL';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查
  ------------------------------------------------------------------
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  ------------------------------------------------------------------
  -- 2. TMP1：清理当前数据日明细和物理临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_LOST_DTL D
   WHERE D.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_LOST_DTL D
   WHERE TO_DATE(D.DATA_DATE, 'YYYYMMDD') < ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY'), -36);

  TRUNC_TMP('TMP_ADS_LOST_BASE');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日明细和物理临时表';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 3. TMP2：生成轻度和重度流失客户基础数据
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_LOST_BASE (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      LVL_CHURN,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      RESCUE_STATE,
      CUR_AUM_BAL,
      LAST_MONTH_END_AUM_BAL,
      POST_ID,
      ORG_ID
  )
  SELECT c.PERSN_LEGAL_BK_CODE,
         c.CUST_ID,
         c.CUST_NAME,
         cur_l.CUST_LVL,
         CASE
           WHEN p.AUM_BAL >= CASE
                               WHEN p.LVL IN ('04', '05', '06') THEN 50000
                               WHEN p.LVL = '07' THEN 300000
                               WHEN p.LVL = '08' THEN 500000
                               WHEN p.LVL = '09' THEN 1000000
                               WHEN p.LVL = '10' THEN 3000000
                             END
                AND NVL(e.AUM_BAL, 0) < CASE
                                           WHEN p.LVL IN ('04', '05', '06') THEN 50000
                                           WHEN p.LVL = '07' THEN 300000
                                           WHEN p.LVL = '08' THEN 500000
                                           WHEN p.LVL = '09' THEN 1000000
                                           WHEN p.LVL = '10' THEN 3000000
                                         END
           THEN '1'
           WHEN pp.AUM_BAL >= CASE
                               WHEN pp.LVL IN ('04', '05', '06') THEN 50000
                               WHEN pp.LVL = '07' THEN 300000
                               WHEN pp.LVL = '08' THEN 500000
                               WHEN pp.LVL = '09' THEN 1000000
                               WHEN pp.LVL = '10' THEN 3000000
                             END
                AND NVL(p.AUM_BAL, 0) < CASE
                                           WHEN pp.LVL IN ('04', '05', '06') THEN 50000
                                           WHEN pp.LVL = '07' THEN 300000
                                           WHEN pp.LVL = '08' THEN 500000
                                           WHEN pp.LVL = '09' THEN 1000000
                                           WHEN pp.LVL = '10' THEN 3000000
                                         END
                AND NVL(e.AUM_BAL, 0) < CASE
                                           WHEN pp.LVL IN ('04', '05', '06') THEN 50000
                                           WHEN pp.LVL = '07' THEN 300000
                                           WHEN pp.LVL = '08' THEN 500000
                                           WHEN pp.LVL = '09' THEN 1000000
                                           WHEN pp.LVL = '10' THEN 3000000
                                         END
           THEN '2'
         END,
         NVL(b.DEPO_CURNT_DEPO_BAL, 0),
         NVL(b.FIXD_DEPO_BAL, 0),
         NVL(b.FIN_BAL, 0),
         CASE
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO r
              WHERE r.CUST_ID = c.CUST_ID
                AND r.MKT_TYP IN ('1', '2', '3', '4')
                AND r.MKT_TIME IS NOT NULL
                AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'MM')
                        AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
           ) THEN '1'
           ELSE '0'
         END,
         CASE
           WHEN NVL(q.AUM_BAL, 0) >= CASE
                                        WHEN COALESCE(p.LVL, pp.LVL) IN ('04', '05', '06') THEN 50000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '07' THEN 300000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '08' THEN 500000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '09' THEN 1000000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '10' THEN 3000000
                                      END
           THEN '1'
           ELSE '0'
         END,
         NVL(q.AUM_BAL, 0),
         NVL(e.AUM_BAL, 0),
         c.HOST_CUST_MNGR_POST_ID,
         c.ORG_LEAD
    FROM (
          SELECT a.CUST_ID,
                 a.AUM_BAL,
                 l.CUST_LVL LVL
            FROM DWS_CUST_ASSE_LIAB a
            JOIN DWS_CUST_LVL_INFO l
              ON l.CUST_ID = a.CUST_ID
             AND l.DATA_DT = a.DATA_DATE
           WHERE a.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD')
             AND a.BAL_TYPE = '2'
         ) p
    FULL JOIN (
          SELECT a.CUST_ID,
                 a.AUM_BAL,
                 l.CUST_LVL LVL
            FROM DWS_CUST_ASSE_LIAB a
            JOIN DWS_CUST_LVL_INFO l
              ON l.CUST_ID = a.CUST_ID
             AND l.DATA_DT = a.DATA_DATE
           WHERE a.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -2)), 'YYYYMMDD')
             AND a.BAL_TYPE = '2'
         ) pp
      ON pp.CUST_ID = p.CUST_ID
    JOIN DWD_CUST_INDV_INFO c
      ON c.CUST_ID = COALESCE(p.CUST_ID, pp.CUST_ID)
    LEFT JOIN DWS_CUST_LVL_INFO cur_l
      ON cur_l.CUST_ID = c.CUST_ID
     AND cur_l.DATA_DT = V_SYSDAT
    LEFT JOIN DWS_CUST_ASSE_LIAB e
      ON e.CUST_ID = c.CUST_ID
     AND e.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD')
     AND e.BAL_TYPE = '1'
    LEFT JOIN DWS_CUST_ASSE_LIAB q
      ON q.CUST_ID = c.CUST_ID
     AND q.DATA_DATE = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - 1, 'YYYYMMDD')
     AND q.BAL_TYPE = '1'
    LEFT JOIN DWS_CUST_ASSE_LIAB b
      ON b.CUST_ID = c.CUST_ID
     AND b.DATA_DATE = V_SYSDAT
     AND b.BAL_TYPE = '1';

  DELETE FROM TMP_ADS_LOST_BASE
   WHERE LVL_CHURN IS NULL;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成轻度和重度流失客户基础数据';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 4. 目标表写入：生成月、季、年三个统计周期明细
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_LOST_DTL (
      PERSN_LEGAL_BK_CODE,
      DATA_DATE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      LVL_CHURN,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      RESCUE_STATE,
      RESCUED_FINA_ASSET,
      POST_ID,
      ORG_ID,
      STATIS_CYCLE
  )
  SELECT x.PERSN_LEGAL_BK_CODE,
         V_SYSDAT,
         x.CUST_ID,
         x.CUST_NAME,
         x.CUST_LVL,
         x.LVL_CHURN,
         x.DEPO_CURNT_DEPO_BAL,
         x.FIXD_DEPO_BAL,
         x.FIN_AMT,
         x.CNTCT_STATE,
         x.RESCUE_STATE,
         CASE WHEN x.RESCUE_STATE = '1' THEN GREATEST(NVL(x.CUR_AUM_BAL, 0) - NVL(x.LAST_MONTH_END_AUM_BAL, 0), 0) ELSE 0 END,
         x.POST_ID,
         x.ORG_ID,
         c.STATIS_CYCLE
    FROM TMP_ADS_LOST_BASE x
   CROSS JOIN (
         SELECT 'M' AS STATIS_CYCLE FROM DUAL
         UNION ALL
         SELECT 'Q' AS STATIS_CYCLE FROM DUAL
         UNION ALL
         SELECT 'N' AS STATIS_CYCLE FROM DUAL
   ) c;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入客户流失清单';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 5. 历史客群持续经营：累计更新上一月、上一季、上一年状态
  ------------------------------------------------------------------
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  UPDATE ADS_CUST_LOST_DTL D
     SET D.CNTCT_STATE = CASE
                           WHEN D.CNTCT_STATE = '1'
                             OR EXISTS (
                               SELECT 1
                                 FROM ADS_MKT_REC_INFO R
                                WHERE R.CUST_ID = D.CUST_ID
                                  AND R.MKT_TYP IN ('1', '2', '3', '4')
                                  AND R.MKT_TIME IS NOT NULL
                                  AND TO_DATE(REPLACE(SUBSTR(R.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                                      BETWEEN TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'MM')
                                          AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
                             ) THEN '1'
                           ELSE '0'
                         END,
         D.RESCUE_STATE = CASE
                            WHEN D.RESCUE_STATE = '1'
                              OR EXISTS (
                                SELECT 1
                                  FROM DWS_CUST_ASSE_LIAB A
                                 WHERE A.CUST_ID = D.CUST_ID
                                   AND A.DATA_DATE = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - 1, 'YYYYMMDD')
                                   AND A.BAL_TYPE = '1'
                                   AND (
                                       (D.CUST_LVL IN ('04', '05', '06') AND NVL(A.AUM_BAL, 0) >= 50000)
                                       OR (D.CUST_LVL = '07' AND NVL(A.AUM_BAL, 0) >= 300000)
                                       OR (D.CUST_LVL = '08' AND NVL(A.AUM_BAL, 0) >= 500000)
                                       OR (D.CUST_LVL = '09' AND NVL(A.AUM_BAL, 0) >= 1000000)
                                       OR (D.CUST_LVL = '10' AND NVL(A.AUM_BAL, 0) >= 3000000)
                                       )
                              ) THEN '1'
                            ELSE '0'
                          END
   WHERE (D.STATIS_CYCLE = 'M' AND D.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'Q' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'N' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD'));

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第4段完成：累计更新上一月、上一季、上一年流失客群经营状态';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );

EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;

    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;

    SYS_PRC_STEP_LOGS(
        V_SYSDAT,
        V_PRC_NAME,
        V_PRC_DESC,
        V_NO_ID,
        V_BGN_DATE,
        V_END_DATE,
        V_DURA_DATE,
        V_LOG_MSG,
        V_LOG_FLG,
        V_LOG_BUTTON
    );

    RAISE;
END;
/