CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_SLEEP_WAKE_STATIS(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒统计
  -- 处理周期: 日
  -- 过程描述: 按机构向上汇总和客户经理维度生成睡眠户唤醒统计
  -- 来源表: ADS_CUST_SLEEP_WAKE_DTL, DWD_SYS_ORG
  -- 目标表: ADS_CUST_SLEEP_WAKE_STATIS
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.1.0
  -- 关联需求: REQ-CUST-008
  -- 变更记录:
  --   v2.1.0: 1.添加需求版本标注和变更记录
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '睡眠户唤醒统计表';
  V_PRC_NAME             VARCHAR(64)  := 'PRO_ADS_CUST_SLEEP_WAKE_STATIS';
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
  -- 2. TMP1：清理当前数据日统计结果、三年前历史数据和统计临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS S
   WHERE S.DATA_DATE = V_SYSDAT;
  DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS S
   WHERE (S.STATIS_CYCLE = 'M' AND S.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
      OR (S.STATIS_CYCLE = 'Q' AND S.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
      OR (S.STATIS_CYCLE = 'N' AND S.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD'));

  DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS S
   WHERE TO_DATE(S.DATA_DATE, 'YYYYMMDD') < ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY'), -36);

  TRUNC_TMP('TMP_ADS_SLEEP_STAT_SRC');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和统计临时表';
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
  -- 3. TMP2：展开机构和客户经理统计对象
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_SLEEP_STAT_SRC (
      PERSN_LEGAL_BK_CODE,
      DATA_DATE,
      STATIS_CYCLE,
      STATIS_OBJ,
      CNTCT_STATE,
      WAKE_STATE
  )
  SELECT D.PERSN_LEGAL_BK_CODE,
         D.DATA_DATE,
         D.STATIS_CYCLE,
         O.ANCESTOR_ORG_ID,
         D.CNTCT_STATE,
         D.WAKE_STATE
    FROM ADS_CUST_SLEEP_WAKE_DTL D
    JOIN (
          SELECT DISTINCT
                 CONNECT_BY_ROOT O.ORG_ID AS LEAF_ORG_ID,
                 O.ORG_ID AS ANCESTOR_ORG_ID
            FROM DWD_SYS_ORG O
           START WITH O.ORG_ID IN (
                 SELECT DISTINCT D1.ORG_ID
                   FROM ADS_CUST_SLEEP_WAKE_DTL D1
                   WHERE D1.DATA_DATE = V_SYSDAT
                      OR (D1.STATIS_CYCLE = 'M' AND D1.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
                      OR (D1.STATIS_CYCLE = 'Q' AND D1.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
                      OR (D1.STATIS_CYCLE = 'N' AND D1.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD'))
                    AND D1.ORG_ID IS NOT NULL
           )
         CONNECT BY NOCYCLE PRIOR O.SUP_ORG_ID = O.ORG_ID
    ) O
      ON O.LEAF_ORG_ID = D.ORG_ID
   WHERE D.DATA_DATE = V_SYSDAT
      OR (D.STATIS_CYCLE = 'M' AND D.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'Q' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'N' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD'))

  UNION ALL

  SELECT D.PERSN_LEGAL_BK_CODE,
         D.DATA_DATE,
         D.STATIS_CYCLE,
         D.POST_ID,
         D.CNTCT_STATE,
         D.WAKE_STATE
    FROM ADS_CUST_SLEEP_WAKE_DTL D
   WHERE (D.DATA_DATE = V_SYSDAT
      OR (D.STATIS_CYCLE = 'M' AND D.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'Q' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'N' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD')))
     AND D.POST_ID IS NOT NULL;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：展开机构和客户经理统计对象';
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
  -- 4. 目标表写入：按统计对象和月/季/年周期汇总
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_SLEEP_WAKE_STATIS (
      PERSN_LEGAL_BK_CODE,
      DATA_DATE,
      STATIS_OBJ,
      STATIS_CYCLE,
      CUST_CNT,
      CNTCT_CUST_CNT,
      CNTCT_RATE,
      WAKE_CUST_CNT,
      WAKE_RATE
  )
  SELECT S.PERSN_LEGAL_BK_CODE,
         S.DATA_DATE,
         S.STATIS_OBJ,
         S.STATIS_CYCLE,
         COUNT(*),
         SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END),
         CASE WHEN COUNT(*) = 0 THEN 0 ELSE ROUND(SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) END,
         SUM(CASE WHEN S.WAKE_STATE = '1' THEN 1 ELSE 0 END),
         CASE WHEN COUNT(*) = 0 THEN 0 ELSE ROUND(SUM(CASE WHEN S.WAKE_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) END
    FROM TMP_ADS_SLEEP_STAT_SRC S
   GROUP BY S.PERSN_LEGAL_BK_CODE,
            S.DATA_DATE,
            S.STATIS_OBJ,
            S.STATIS_CYCLE;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入睡眠户唤醒统计';
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