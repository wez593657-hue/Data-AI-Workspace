CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL(
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
  -- 需求版本: v2.4.0
  -- 变更记录:
  --   v2.2.0 2026-07-27 计算单位调整为客户号+归属机构(ORG_ID)，关联DWS_CUST_ASSE_LIAB增加ORG_ID条件避免笛卡尔积
  --               输出ORG_ID/PERSN_LEGAL_BK_CODE改取DWS_CUST_ASSE_LIAB(p)字段，正确反映同客户多机构拆分
  --   v2.3.0 2026-07-27 相对日期统一使用sys_fun_deal_date：上日=1、上月末=2；后续日期按函数参数扩展
  --   v2.4.0 2026-07-27 补充客户、归属机构、法人行三键关联及各业务处理段说明
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '潜力提升客户明细处理';
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  V_PREV_DAY             VARCHAR2(8);
  V_PREV_MONTH_END       VARCHAR2(8);
  V_CURR_MONTH_BEGIN     VARCHAR2(8);
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查
  ------------------------------------------------------------------
  -- 1. 校验跑批日期并初始化本过程使用的相对业务日期参数。
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');
  V_PREV_DAY := sys_fun_deal_date(V_SYSDAT, 1);
  V_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 2);
  V_CURR_MONTH_BEGIN := sys_fun_deal_date(V_SYSDAT, 9);
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);

  ------------------------------------------------------------------
  -- 2. TMP1：清理当前数据日明细和物理临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  -- 2. 清理本跑批日已生成的明细和超过保留期限的历史数据，保证过程可重跑。
  DELETE FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D
   WHERE D.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D
   WHERE D.DATA_DATE < V_HISTORY_CUTOFF_DATE;

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

  -- 3. 基于上月末月日均资产筛选临界客户，并按客户、法人行、归属机构关联资产和接触记录。
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
  SELECT p.PERSN_LEGAL_BK_CODE,
         c.CUST_ID,
         c.CUST_NAME,
         l.CUST_LVL,
         -- 根据上月末月日均 AUM 确定客户所属的临界升级等级。
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
         -- 判断当月初至跑批日是否存在有效营销接触记录。
         CASE
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO r
              WHERE r.CUST_ID = c.CUST_ID
                AND r.MKT_TYP IN ('1', '2', '3', '4')
                AND r.MKT_TIME IS NOT NULL
                AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN TO_DATE(V_CURR_MONTH_BEGIN, 'YYYYMMDD')
                        AND TO_DATE(V_SYSDAT, 'YYYYMMDD')
           ) THEN '1'
           ELSE '0'
         END,
         c.HOST_CUST_MNGR_POST_ID,
         p.ORG_ID
    FROM DWS_CUST_ASSE_LIAB p
    JOIN DWD_CUST_INDV_INFO c
      ON c.CUST_ID = p.CUST_ID
    LEFT JOIN DWS_CUST_LVL_INFO l
      ON l.CUST_ID = p.CUST_ID
     AND l.DATA_DT = V_SYSDAT
    LEFT JOIN DWS_CUST_ASSE_LIAB m
     ON m.CUST_ID = p.CUST_ID
     AND m.ORG_ID = p.ORG_ID
     AND m.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND m.DATA_DATE = V_SYSDAT
     AND m.BAL_TYPE = '2'
    LEFT JOIN DWS_CUST_ASSE_LIAB b
     ON b.CUST_ID = p.CUST_ID
     AND b.ORG_ID = p.ORG_ID
     AND b.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND b.DATA_DATE = V_SYSDAT
     AND b.BAL_TYPE = '1'
    LEFT JOIN DWS_CUST_ASSE_LIAB q
     ON q.CUST_ID = p.CUST_ID
     AND q.ORG_ID = p.ORG_ID
     AND q.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND q.DATA_DATE = V_PREV_DAY
     AND q.BAL_TYPE = '1'
   WHERE p.DATA_DATE = V_PREV_MONTH_END
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

  -- 4. 将基础客户扩展为月、季、年统计周期明细，并计算上日时点资产达标标识。
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
         -- 按上日时点 AUM 与临界等级阈值判断客户是否已完成升级。
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
  -- 5. 发生异常时回滚本过程事务并记录失败日志。
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
