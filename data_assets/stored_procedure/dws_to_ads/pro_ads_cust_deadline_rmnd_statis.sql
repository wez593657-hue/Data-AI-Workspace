CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_DEADLINE_RMND_STATIS(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: 到期承接统计表处理
  -- 存储过程编号: PRO_ADS_CUST_DEADLINE_RMND_STATIS
  -- 处理周期: 日
  -- 过程描述: 按机构向上汇总和客户经理维度生成到期承接统计
  -- 来源表: ADS_CUST_DEADLINE_RMND_DTL, DWS_CUST_ASSE_LIAB, DWD_SYS_ORG
  -- 目标表: ADS_CUST_DEADLINE_RMND_STATIS
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.2.0
  -- 关联需求: REQ-CUST-002
  -- 变更记录:
  --   v2.1.0: 1.理财转存款转化率和存款转理财转化率指标已实现
  --           2.统计维度0-全部、1-存款、2-理财已实现
  --           3.客户承接率长期化产品剔除保险（待实现，已做注释）
  --           4.定期存款承接率需确认通知存款过滤（待实现，已做注释）
  --           5.DATA_DATE语义变更：统一使用周期结束日期（M-月末，Q-季末，N-年末），清理逻辑同步更新
  --   v2.2.0: 1.客户数统计改为按客户+机构维度去重：COUNT(DISTINCT CUST_ID || '_' || ORG_ID)
  --           2.承接状态统计同步改为按客户+机构维度去重
  ------------------------------------------------------------------
  V_PRC_DESC VARCHAR(100) := '到期承接统计表处理';
  V_PRC_NAME VARCHAR(64) := 'PRO_ADS_CUST_DEADLINE_RMND_STATIS';
  V_LOG_MSG VARCHAR(4000);
  V_LOG_FLG INTEGER;
  V_LOG_BUTTON INTEGER := 1;
  V_NO_ID VARCHAR(10);
  V_BGN_DATE DATE;
  V_END_DATE DATE;
  V_DURA_DATE INTEGER;

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  --***************************************
  -- 2.0 -- 第1段处理开始：清理当前快照和中间表
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_DEADLINE_RMND_STATIS
   WHERE (STATIS_CYCLE = 'M' AND DATA_DATE = TO_CHAR(LAST_DAY(TO_DATE(V_SYSDAT, 'yyyymmdd')), 'yyyymmdd'))
      OR (STATIS_CYCLE = 'Q' AND DATA_DATE = TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q'), 3) - 1, 'yyyymmdd'))
      OR (STATIS_CYCLE = 'N' AND DATA_DATE = TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), 12) - 1, 'yyyymmdd'))
      OR (STATIS_CYCLE = 'M' AND DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -1)), 'yyyymmdd'))
      OR (STATIS_CYCLE = 'Q' AND DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q') - 1, 'yyyymmdd'))
      OR (STATIS_CYCLE = 'N' AND DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY') - 1, 'yyyymmdd'));
  TRUNC_TMP('TMP_CDR_STAT_BASE');
  TRUNC_TMP('TMP_CDR_STAT_SRC');
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第1段业务逻辑处理完成：清理当前快照和中间表';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.1 -- 第2段处理开始：生成统计基础明细中间表
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_STAT_BASE (
      PERSN_LEGAL_BK_CODE, DATA_DATE, STAT_PERD, STATIS_TYP, CUST_ID, ORG_ID, POST_ID,
      EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE_30D, CUST_TAKE_FLG,
      FIXED_MATURE_TRAN_FIN_AMT, FIXED_FIN_MATURE_TRAN_INSUR_AMT, FIN_MATURE_TRAN_FIXED_AMT,
      FRST_MATURE_PK_BF_DAY_AUM_BAL, CURR_AUM_BAL
  )
  SELECT d.PERSN_LEGAL_BK_CODE,
         d.DATA_DATE,
         d.STAT_PERD,
         d.STATIS_TYP,
         d.CUST_ID,
         d.ORG_ID,
         d.POST_ID,
         NVL(d.EXPR_AMT, 0),
         NVL(d.MATURE_TTL_AMT, 0),
         NVL(d.TAKE_RATE, 0),
         d.UNDTAKE_STATE,
         NVL(d.FIXED_MATURE_TRAN_FIN_AMT, 0),
         NVL(d.FIXED_FIN_MATURE_TRAN_INSUR_AMT, 0),
         NVL(d.FIN_MATURE_TRAN_FIXED_AMT, 0),
         NVL(d.FRST_MATURE_PK_BF_DAY_AUM_BAL, 0),
         NVL(a.CURR_AUM_BAL, 0)
    FROM ADS_CUST_DEADLINE_RMND_DTL d
    LEFT JOIN (
        SELECT x.CUST_ID, SUM(NVL(x.AUM_BAL, 0)) AS CURR_AUM_BAL
          FROM DWS_CUST_ASSE_LIAB x
         WHERE x.DATA_DATE = V_SYSDAT
           AND x.BAL_TYPE = '1'
         GROUP BY x.CUST_ID
    ) a
      ON a.CUST_ID = d.CUST_ID
   WHERE (d.STAT_PERD = 'M' AND d.DATA_DATE IN (TO_CHAR(LAST_DAY(TO_DATE(V_SYSDAT, 'yyyymmdd')), 'yyyymmdd'), TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -1)), 'yyyymmdd')))
      OR (d.STAT_PERD = 'Q' AND d.DATA_DATE IN (TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q'), 3) - 1, 'yyyymmdd'), TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q') - 1, 'yyyymmdd')))
      OR (d.STAT_PERD = 'N' AND d.DATA_DATE IN (TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), 12) - 1, 'yyyymmdd'), TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY') - 1, 'yyyymmdd')));
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第2段业务逻辑处理完成：生成统计基础明细中间表';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.2 -- 第3段处理开始：展开机构和客户经理统计对象
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_STAT_SRC (
      PERSN_LEGAL_BK_CODE, STATIS_OBJ, DATA_DATE, STAT_PERD, STATIS_TYP, CUST_ID, ORG_ID, POST_ID,
      EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE_30D, CUST_TAKE_FLG,
      FIXED_MATURE_TRAN_FIN_AMT, FIXED_FIN_MATURE_TRAN_INSUR_AMT, FIN_MATURE_TRAN_FIXED_AMT,
      FRST_MATURE_PK_BF_DAY_AUM_BAL, CURR_AUM_BAL
  )
  SELECT b.PERSN_LEGAL_BK_CODE,
         o.ANCESTOR_ORG_ID,
         b.DATA_DATE, b.STAT_PERD, b.STATIS_TYP, b.CUST_ID, b.ORG_ID, b.POST_ID,
         b.EXPR_AMT, b.MATURE_TTL_AMT, b.TAKE_RATE_30D, b.CUST_TAKE_FLG,
         b.FIXED_MATURE_TRAN_FIN_AMT, b.FIXED_FIN_MATURE_TRAN_INSUR_AMT, b.FIN_MATURE_TRAN_FIXED_AMT,
         b.FRST_MATURE_PK_BF_DAY_AUM_BAL, b.CURR_AUM_BAL
    FROM TMP_CDR_STAT_BASE b
    JOIN (
        SELECT DISTINCT CONNECT_BY_ROOT o.ORG_ID AS LEAF_ORG_ID,
                        o.ORG_ID AS ANCESTOR_ORG_ID
          FROM DWD_SYS_ORG o
         START WITH o.ORG_ID IN (
             SELECT DISTINCT z.ORG_ID
               FROM TMP_CDR_STAT_BASE z
              WHERE z.ORG_ID IS NOT NULL
         )
       CONNECT BY NOCYCLE PRIOR o.SUP_ORG_ID = o.ORG_ID
    ) o
      ON o.LEAF_ORG_ID = b.ORG_ID
  UNION ALL
  SELECT b.PERSN_LEGAL_BK_CODE,
         b.POST_ID,
         b.DATA_DATE, b.STAT_PERD, b.STATIS_TYP, b.CUST_ID, b.ORG_ID, b.POST_ID,
         b.EXPR_AMT, b.MATURE_TTL_AMT, b.TAKE_RATE_30D, b.CUST_TAKE_FLG,
         b.FIXED_MATURE_TRAN_FIN_AMT, b.FIXED_FIN_MATURE_TRAN_INSUR_AMT, b.FIN_MATURE_TRAN_FIXED_AMT,
         b.FRST_MATURE_PK_BF_DAY_AUM_BAL, b.CURR_AUM_BAL
    FROM TMP_CDR_STAT_BASE b
   WHERE b.POST_ID IS NOT NULL;
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第3段业务逻辑处理完成：展开机构和客户经理统计对象';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.3 -- 第4段处理开始：写入到期承接统计表并清理历史
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_DEADLINE_RMND_STATIS (
      PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
      EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
      CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
      DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
  )
  SELECT s.PERSN_LEGAL_BK_CODE,
         s.DATA_DATE,
         s.STATIS_OBJ,
         s.STAT_PERD,
         s.STATIS_TYP,
         COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || '_' || s.ORG_ID END),
         COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || '_' || s.ORG_ID END),
         SUM(s.EXPR_AMT),
         SUM(s.MATURE_TTL_AMT),
         CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || '_' || s.ORG_ID END) = 0 THEN 0
              ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || '_' || s.ORG_ID END)
                         / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || '_' || s.ORG_ID END) * 100, 2)
         END,
         CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
              ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
         END,
         CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
              ELSE ROUND(SUM(ROUND(s.EXPR_AMT * s.TAKE_RATE_30D / 100, 2)) / SUM(s.EXPR_AMT) * 100, 2)
         END,
         CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
              ELSE ROUND(SUM(s.FIXED_MATURE_TRAN_FIN_AMT) / SUM(s.EXPR_AMT) * 100, 2)
         END,
         CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
              ELSE ROUND(SUM(s.FIXED_FIN_MATURE_TRAN_INSUR_AMT) / SUM(s.EXPR_AMT) * 100, 2)
         END,
         CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
              ELSE ROUND(SUM(s.FIN_MATURE_TRAN_FIXED_AMT) / SUM(s.EXPR_AMT) * 100, 2)
         END
    FROM TMP_CDR_STAT_SRC s
   GROUP BY s.PERSN_LEGAL_BK_CODE, s.STATIS_OBJ, s.STAT_PERD, s.STATIS_TYP;

  DELETE FROM ADS_CUST_DEADLINE_RMND_STATIS t
   WHERE t.DATA_DATE NOT IN (
          TO_CHAR(LAST_DAY(TO_DATE(V_SYSDAT, 'yyyymmdd')), 'yyyymmdd'),
          TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q'), 3) - 1, 'yyyymmdd'),
          TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), 12) - 1, 'yyyymmdd'),
          TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -1)), 'yyyymmdd'),
          TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q') - 1, 'yyyymmdd'),
          TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY') - 1, 'yyyymmdd')
        )
     AND (
          t.DATA_DATE < TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), -36), 'yyyymmdd')
          OR (t.STATIS_CYCLE = 'M' AND t.DATA_DATE <> TO_CHAR(LAST_DAY(TO_DATE(t.DATA_DATE, 'yyyymmdd')), 'yyyymmdd'))
          OR (t.STATIS_CYCLE = 'Q' AND t.DATA_DATE <> TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(t.DATA_DATE, 'yyyymmdd'), 'Q'), 3) - 1, 'yyyymmdd'))
          OR (t.STATIS_CYCLE = 'N' AND t.DATA_DATE <> TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(t.DATA_DATE, 'yyyymmdd'), 'YYYY'), 12) - 1, 'yyyymmdd'))
     );
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第4段业务逻辑处理完成：写入到期承接统计表并清理历史';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NULL THEN NULL ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60) END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END;
/
