CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_NEW_CUST_DTL(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：新客经营明细处理
  -- 处理周期: 日
  -- 过程描述: 以客户基本信息OPEN_DATE确定180天内新客，按0~30、30~100、100~180、全部四类统计
  -- 来源表: DWD_CUST_INDV_INFO, DWS_CUST_LVL_INFO, DWS_CUST_ASSE_LIAB, DWD_CUST_INDV_KYC, ADS_MKT_REC_INFO
  -- 目标表: ADS_CUST_NEW_CUST_DTL
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.1.0
  -- 关联需求: REQ-CUST-007
  -- 变更记录:
  --   v2.1.0: 1.新客定义改为使用DWD_CUST_INDV_INFO的OPEN_DATE字段
  --           2.新客周期边界值改为左闭右开（0~30、30~100、100~180）
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '新客经营明细处理';
  V_PRC_NAME             VARCHAR(64)  := 'PRO_ADS_CUST_NEW_CUST_DTL';
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

  DELETE FROM ADS_CUST_NEW_CUST_DTL D
   WHERE D.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_NEW_CUST_DTL D
   WHERE TO_DATE(D.DATA_DATE, 'YYYYMMDD') < ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY'), -36);

  TRUNC_TMP('TMP_ADS_NEW_CUST_BASE');
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
  -- 3. TMP2：生成180天内新客基础数据
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_NEW_CUST_BASE (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      NEW_CUST_CYCLE,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      KYC_STATE,
      POST_ID,
      ORG_ID
  )
  SELECT c.PERSN_LEGAL_BK_CODE,
         c.CUST_ID,
         c.CUST_NAME,
         l.CUST_LVL,
         CASE
        WHEN TO_DATE(V_SYSDAT, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') < 30 THEN '1'
        WHEN TO_DATE(V_SYSDAT, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') < 100 THEN '2'
        WHEN TO_DATE(V_SYSDAT, 'YYYYMMDD') - TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') <= 180 THEN '3'
      END,
         NVL(a.DEPO_CURNT_DEPO_BAL, 0),
         NVL(a.FIXD_DEPO_BAL, 0),
         NVL(a.FIN_BAL, 0),
         CASE
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO r
              WHERE r.CUST_ID = c.CUST_ID
                AND r.MKT_PERSN = c.HOST_CUST_MNGR_POST_ID
                AND r.MKT_TYP IN ('1', '2', '3', '4')
                AND r.MKT_TIME IS NOT NULL
                AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'MM')
                        AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
           ) THEN '1'
           ELSE '0'
         END,
         CASE
           WHEN (CASE WHEN k.BK_OUTER_DEPO IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_FIN IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_FUND IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_INSUR IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_GOLD IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.STK_INVEST IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.ESTT_INF IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.PROP_OWNER_CERT_NO IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.HOUSE_AREA IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.IS_HOUSE_MORTGAGED IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.RES_ADDRS IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.SHOP_INVEST IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.VIKL_INF IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.VEHICLE_PLATE_NO IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.USAGE_NATURE IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.IS_CAR_LOAN IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.IS_CAR_MORTGAGED IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.MTH_INCOM IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.YR_INCOM IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_LOAN_BAL IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.BK_OUTER_CRDT_LMT IS NOT NULL THEN 1 ELSE 0 END
                + CASE WHEN k.AVAIL_LMT IS NOT NULL THEN 1 ELSE 0 END) >= 18
           THEN '1'
           ELSE '0'
         END,
         c.HOST_CUST_MNGR_POST_ID,
         c.ORG_LEAD
    FROM DWD_CUST_INDV_INFO c
    LEFT JOIN DWS_CUST_LVL_INFO l
      ON l.CUST_ID = c.CUST_ID
     AND l.DATA_DT = V_SYSDAT
    LEFT JOIN DWS_CUST_ASSE_LIAB a
      ON a.CUST_ID = c.CUST_ID
     AND a.DATA_DATE = V_SYSDAT
     AND a.BAL_TYPE = '1'
    LEFT JOIN DWD_CUST_INDV_KYC k
      ON k.CUST_ID = c.CUST_ID
   WHERE c.OPEN_DATE IS NOT NULL
     AND TO_DATE(REPLACE(SUBSTR(c.OPEN_DATE, 1, 10), '-', ''), 'YYYYMMDD') BETWEEN TO_DATE(V_SYSDAT, 'YYYYMMDD') - 180 AND TO_DATE(V_SYSDAT, 'YYYYMMDD');

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成180天内新客基础数据';
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

  INSERT INTO ADS_CUST_NEW_CUST_DTL (
      PERSN_LEGAL_BK_CODE,
      DATA_DATE,
      CUST_ID,
      CUST_NAME,
      CUST_LVL,
      NEW_CUST_CYCLE,
      DEPO_CURNT_DEPO_BAL,
      FIXD_DEPO_BAL,
      FIN_AMT,
      CNTCT_STATE,
      KYC_STATE,
      POST_ID,
      ORG_ID,
      STATIS_CYCLE
  )
  SELECT b.PERSN_LEGAL_BK_CODE,
         V_SYSDAT,
         b.CUST_ID,
         b.CUST_NAME,
         b.CUST_LVL,
         b.NEW_CUST_CYCLE,
         b.DEPO_CURNT_DEPO_BAL,
         b.FIXD_DEPO_BAL,
         b.FIN_AMT,
         b.CNTCT_STATE,
         b.KYC_STATE,
         b.POST_ID,
         b.ORG_ID,
         p.STATIS_CYCLE
    FROM TMP_ADS_NEW_CUST_BASE b
   CROSS JOIN (
         SELECT 'M' AS STATIS_CYCLE FROM DUAL
         UNION ALL
         SELECT 'Q' AS STATIS_CYCLE FROM DUAL
         UNION ALL
         SELECT 'N' AS STATIS_CYCLE FROM DUAL
   ) p;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入新客经营明细';
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

  UPDATE ADS_CUST_NEW_CUST_DTL D
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
                             ) THEN '1'
                           ELSE '0'
                         END,
         D.KYC_STATE = CASE
                        WHEN D.KYC_STATE = '1'
                          OR EXISTS (
                            SELECT 1
                              FROM DWD_CUST_INDV_KYC K
                             WHERE K.CUST_ID = D.CUST_ID
                               AND (CASE WHEN K.BK_OUTER_DEPO IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.BK_OUTER_FIN IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.BK_OUTER_FUND IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.BK_OUTER_INSUR IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.BK_OUTER_GOLD IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.STK_INVEST IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.ESTT_INF IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.PROP_OWNER_CERT_NO IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.HOUSE_AREA IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.IS_HOUSE_MORTGAGED IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.RES_ADDRS IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.SHOP_INVEST IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.VIKL_INF IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.VEHICLE_PLATE_NO IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.USAGE_NATURE IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.IS_CAR_LOAN IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.IS_CAR_MORTGAGED IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.MTH_INCOM IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.YR_INCOM IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.BK_OUTER_LOAN_BAL IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.BK_OUTER_CRDT_LMT IS NOT NULL THEN 1 ELSE 0 END
                                    + CASE WHEN K.AVAIL_LMT IS NOT NULL THEN 1 ELSE 0 END) >= 18)
                          THEN '1'
                        ELSE '0'
                      END
   WHERE (D.STATIS_CYCLE = 'M' AND D.DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'YYYYMMDD'), -1)), 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'Q' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'Q') - 1, 'YYYYMMDD'))
      OR (D.STATIS_CYCLE = 'N' AND D.DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'YYYYMMDD'), 'YYYY') - 1, 'YYYYMMDD'));

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第4段完成：累计更新上一月、上一季、上一年新客经营状态';
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