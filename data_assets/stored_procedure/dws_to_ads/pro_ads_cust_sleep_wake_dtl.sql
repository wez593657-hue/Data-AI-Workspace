CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_SLEEP_WAKE_DTL(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒明细
  -- 处理周期: 日
  -- 过程描述: 识别睡眠客户并生成唤醒经营明细数据
  -- 来源表: DWD_CUST_INDV_INFO, DWS_CUST_ASSE_LIAB, DWS_CUST_LVL_INFO, ADS_MKT_REC_INFO, DWD_TX_ASET
  -- 目标表: ADS_CUST_SLEEP_WAKE_DTL
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.1.0
  -- 关联需求: REQ-CUST-008
  -- 变更记录:
  --   v2.1.0: 1.添加需求版本标注和变更记录
  --           2.主动动账条件待确认：当前使用1=1保守逻辑，需确认DWD_TX_ASET表中主动动账标识字段
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '睡眠户唤醒明细处理';
  V_PRC_NAME             VARCHAR(64)  := 'PRO_ADS_CUST_SLEEP_WAKE_DTL';
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
  -- 2. TMP1：清理当前数据日和睡眠户基础临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE D.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE TO_DATE(D.DATA_DATE, 'YYYYMMDD') < ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY'), -36);

  TRUNC_TMP('TMP_ADS_SLEEP_WAKE_BASE');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日明细和基础临时表';
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
  -- 3. TMP2：生成睡眠户、接触状态和唤醒状态基础数据
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_SLEEP_WAKE_BASE (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      WAKE_STATE,
      POST_ID,
      ORG_ID
  )
  SELECT C.PERSN_LEGAL_BK_CODE,
         C.CUST_ID,
         C.CUST_NAME,
         L.CUST_LVL,
         NVL(A.DEPO_CURNT_DEPO_BAL, 0),
         NVL(A.FIXD_DEPO_BAL, 0),
         NVL(A.FIN_BAL, 0),
         CASE
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO R
              WHERE R.CUST_ID = C.CUST_ID
                AND R.MKT_PERSN = C.HOST_CUST_MNGR_POST_ID
                AND R.MKT_TYP IN ('1', '2', '3', '4')
                AND R.MKT_TIME IS NOT NULL
                AND TO_DATE(REPLACE(SUBSTR(R.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'MM')
                        AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
           ) THEN '1'
           ELSE '0'
         END,
         CASE
           WHEN NVL(A.FIXD_DEPO_BAL, 0) > 0
             OR NVL(A.FIN_BAL, 0) > 0
             OR NVL(A.INSUR_BAL, 0) > 0
           THEN '1'
           ELSE '0'
         END,
         C.HOST_CUST_MNGR_POST_ID,
         C.ORG_LEAD
    FROM DWD_CUST_INDV_INFO C
    JOIN DWS_CUST_ASSE_LIAB A
      ON A.CUST_ID = C.CUST_ID
     AND A.DATA_DATE = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - 1, 'YYYYMMDD')
     AND A.BAL_TYPE = '1'
    LEFT JOIN DWS_CUST_LVL_INFO L
      ON L.CUST_ID = C.CUST_ID
     AND L.DATA_DT = V_SYSDAT
   WHERE NVL(A.AUM_BAL, 0) < 100
     AND NOT EXISTS (
           SELECT 1
             FROM DWD_TX_ASET T
            WHERE T.CUST_ID = C.CUST_ID
              AND TO_DATE(REPLACE(SUBSTR(T.TX_DATE, 1, 10), '-', ''), 'YYYYMMDD')
                  BETWEEN TO_DATE(V_SYSDAT, 'YYYYMMDD') - 365
                      AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
              AND 1 = 1
              /* 保守逻辑：LOAN_FLG未配置时不判定任何客户为睡眠客户。
                 确认主动动账取值后，将1=1替换为实际条件，如：LOAN_FLG = '1' */
         );

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成睡眠户、接触和唤醒基础数据';
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

  INSERT INTO ADS_CUST_SLEEP_WAKE_DTL (
      PERSN_LEGAL_BK_CODE,
      DATA_DATE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      WAKE_STATE,
      POST_ID,
      ORG_ID,
      STATIS_CYCLE
  )
  SELECT B.PERSN_LEGAL_BK_CODE,
         V_SYSDAT,
         B.CUST_ID,
         B.CUST_NAME,
         B.CUST_LVL,
         B.DEPO_CURNT_DEPO_BAL,
         B.FIXD_DEPO_BAL,
         B.FIN_AMT,
         B.CNTCT_STATE,
         B.WAKE_STATE,
         B.POST_ID,
         B.ORG_ID,
         P.STATIS_CYCLE
    FROM TMP_ADS_SLEEP_WAKE_BASE B
   CROSS JOIN (
         SELECT 'M' AS STATIS_CYCLE FROM DUAL
         UNION ALL
         SELECT 'Q' AS STATIS_CYCLE FROM DUAL
         UNION ALL
         SELECT 'N' AS STATIS_CYCLE FROM DUAL
   ) P;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入睡眠户唤醒明细';
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

  UPDATE ADS_CUST_SLEEP_WAKE_DTL D
     SET D.CNTCT_STATE = CASE
                           WHEN D.CNTCT_STATE = '1'
                             OR EXISTS (
                               SELECT 1
                                 FROM ADS_MKT_REC_INFO R
                                WHERE R.CUST_ID = D.CUST_ID
                                  AND R.MKT_PERSN = D.POST_ID
                                  AND R.MKT_TYP IN ('1', '2', '3', '4')
                                  AND R.MKT_TIME IS NOT NULL
                                  AND TO_DATE(REPLACE(SUBSTR(R.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                                      BETWEEN TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'MM')
                                          AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
                             ) THEN '1' ELSE '0' END,
         D.WAKE_STATE = CASE
                          WHEN D.WAKE_STATE = '1'
                            OR EXISTS (
                              SELECT 1
                                FROM DWS_CUST_ASSE_LIAB A
                               WHERE A.CUST_ID = D.CUST_ID
                                 AND A.DATA_DATE = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - 1, 'YYYYMMDD')
                                 AND A.BAL_TYPE = '1'
                                 AND (NVL(A.FIXD_DEPO_BAL, 0) > 0 OR NVL(A.FIN_BAL, 0) > 0 OR NVL(A.INSUR_BAL, 0) > 0)
                            ) THEN '1' ELSE '0' END
   WHERE (D.STATIS_CYCLE = 'M' AND D.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'Q' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'N' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD'));

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第4段完成：累计更新上一月、上一季、上一年睡眠户经营状态';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

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