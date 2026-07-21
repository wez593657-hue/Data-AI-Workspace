CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_POTN_UPGRADE_CUST_DTL(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：潜力提升客户明细处理
  -- 处理周期: 日
  -- 过程描述: 按临界等级、月日均资产和T-1时点资产计算达标、接触及统计指标
  -- 来源表: DWS_CUST_ASSE_LIAB, DWD_CUST_INDV_INFO, DWS_CUST_LVL_INFO, ADS_MKT_REC_INFO
  -- 目标表: ADS_CUST_POTN_UPGRADE_CUST_DTL
  -- 适配数据库: Kingbase Oracle 兼容模式
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '潜力提升客户明细处理';
  V_PRC_NAME             VARCHAR(64)  := 'PRO_ADS_CUST_POTN_UPGRADE_CUST_DTL';
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

  DELETE FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D
   WHERE D.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D
   WHERE D.DATA_DATE < TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY'), -36), 'YYYYMMDD');

  TRUNC_TMP('TMP_ADS_POTN_BASE');
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
  -- 3. TMP2：生成临界客户及月均、时点、接触基础数据
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_POTN_BASE (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      LVL_CRIT,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CURR_MTH_AVG_AUM,
      PNT_AUM_BAL,
      CNTCT_STATE,
      POST_ID,
      ORG_ID
  )
  SELECT c.PERSN_LEGAL_BK_CODE,
         c.CUST_ID,
         c.CUST_NAME,
         l.CUST_LVL,
         CASE
           WHEN p.AUM_BAL >= 45000 AND p.AUM_BAL < 50000 THEN '03'
           WHEN p.AUM_BAL >= 270000 AND p.AUM_BAL < 300000 THEN '04'
           WHEN p.AUM_BAL >= 450000 AND p.AUM_BAL < 500000 THEN '05'
           WHEN p.AUM_BAL >= 900000 AND p.AUM_BAL < 1000000 THEN '06'
           WHEN p.AUM_BAL >= 2700000 AND p.AUM_BAL < 3000000 THEN '07'
         END,
         NVL(b.DEPO_CURNT_DEPO_BAL, 0),
         NVL(b.FIXD_DEPO_BAL, 0),
         NVL(b.FIN_BAL, 0),
         NVL(m.AUM_BAL, 0),
         NVL(q.AUM_BAL, 0),
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
         c.HOST_CUST_MNGR_POST_ID,
         c.ORG_LEAD
    FROM DWS_CUST_ASSE_LIAB p
    JOIN DWD_CUST_INDV_INFO c
      ON c.CUST_ID = p.CUST_ID
    LEFT JOIN DWS_CUST_LVL_INFO l
      ON l.CUST_ID = p.CUST_ID
     AND l.DATA_DT = V_SYSDAT
    LEFT JOIN DWS_CUST_ASSE_LIAB m
      ON m.CUST_ID = p.CUST_ID
     AND m.DATA_DATE = V_SYSDAT
     AND m.BAL_TYPE = '2'
    LEFT JOIN DWS_CUST_ASSE_LIAB b
      ON b.CUST_ID = p.CUST_ID
     AND b.DATA_DATE = V_SYSDAT
     AND b.BAL_TYPE = '1'
    LEFT JOIN DWS_CUST_ASSE_LIAB q
      ON q.CUST_ID = p.CUST_ID
     AND q.DATA_DATE = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - 1, 'YYYYMMDD')
     AND q.BAL_TYPE = '1'
   WHERE p.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD')
     AND p.BAL_TYPE = '2'
     AND p.AUM_BAL >= 45000
     AND p.AUM_BAL < 3000000;

  DELETE FROM TMP_ADS_POTN_BASE
   WHERE LVL_CRIT IS NULL;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成临界客户及月均、时点、接触基础数据';
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

  INSERT INTO ADS_CUST_POTN_UPGRADE_CUST_DTL (
      PERSN_LEGAL_BK_CODE,
      DATA_DATE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      LVL_CRIT,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      QUAL_STATE,
      POST_ID,
      ORG_ID,
      STATIS_CYCLE
  )
  SELECT x.PERSN_LEGAL_BK_CODE,
         V_SYSDAT,
         x.CUST_ID,
         x.CUST_NAME,
         x.CUST_LVL,
         x.LVL_CRIT,
         x.DEPO_CURNT_DEPO_BAL,
         x.FIXD_DEPO_BAL,
         x.FIN_AMT,
         x.CNTCT_STATE,
         CASE
           WHEN (x.LVL_CRIT = '03' AND x.PNT_AUM_BAL >= 50000)
             OR (x.LVL_CRIT = '04' AND x.PNT_AUM_BAL >= 300000)
             OR (x.LVL_CRIT = '05' AND x.PNT_AUM_BAL >= 500000)
             OR (x.LVL_CRIT = '06' AND x.PNT_AUM_BAL >= 1000000)
             OR (x.LVL_CRIT = '07' AND x.PNT_AUM_BAL >= 3000000)
           THEN '1'
           ELSE '0'
         END,
         x.POST_ID,
         x.ORG_ID,
         c.STATIS_CYCLE
    FROM TMP_ADS_POTN_BASE x
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
  V_LOG_MSG := '第3段完成：写入潜力提升客户明细';
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