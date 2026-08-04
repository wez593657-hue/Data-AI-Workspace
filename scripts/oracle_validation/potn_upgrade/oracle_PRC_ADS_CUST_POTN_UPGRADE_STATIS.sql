CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_POTN_UPGRADE_STAT(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：潜力提升统计处理
  -- 处理周期: 日
  -- 过程描述: 按机构向上汇总和客户经理维度生成潜力提升统计
  -- 来源表: ADS_CUST_POTN_UPGRADE_CUST_DTL, DWS_CUST_ASSE_LIAB, DWD_SYS_ORG
  -- 目标表: ADS_CUST_POTN_UPGRADE_STATIS
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v3.1.1
  -- 变更记录:
  --   v2.2.0 2026-07-27 计算单位调整为客户号+归属机构(ORG_ID)
  --   v2.3.0 2026-07-27 相对日期统一使用sys_fun_deal_date
  --   v2.4.0 2026-07-27 补充三键关联及各业务处理段说明
  --   v2.4.1 2026-07-28 DWS_CUST_ASSE_LIAB关联移除ORG_ID条件
  --   v3.0.0 2026-07-28 同步DTL：月/季/年切片接触状态按不同时间窗口独立计算
  --   v3.1.0 2026-07-30 去掉季/年统计周期切片，仅保留月度（对应v2.0.3需求变更）
  --   v3.1.1 2026-07-30 补充所有变量、字段、表别名、逻辑参数的注释
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '潜力提升统计处理';                     -- 过程描述
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_POTN_UPGRADE_STAT';  -- 过程名称
  V_LOG_MSG              VARCHAR(4000);                                        -- 日志消息文本
  V_LOG_FLG              INTEGER;                                              -- 日志标志（0=成功）
  V_LOG_BUTTON           INTEGER := 1;                                         -- 日志记录开关（1=启用）
  V_NO_ID                VARCHAR(10);                                          -- 当前步骤序号
  V_BGN_DATE             DATE;                                                 -- 步骤开始时间
  V_END_DATE             DATE;                                                 -- 步骤结束时间
  V_DURA_DATE            INTEGER;                                              -- 步骤耗时（秒）
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                          -- 三年历史清理边界（YYYYMMDD）

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查
  ------------------------------------------------------------------
  -- 1. 校验跑批日期并初始化三年历史清理边界。
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);

  ------------------------------------------------------------------
  -- 2. TMP1：清理当前数据日统计结果、三年前历史数据和物理临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  -- 2. 清理本跑批日统计结果和超过三年保留期限的历史数据，保证过程可重跑。
  DELETE FROM ADS_CUST_POTN_UPGRADE_STATIS T
   WHERE T.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_POTN_UPGRADE_STATIS T
   WHERE T.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_POTN_STAT_SRC');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和物理临时表';
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

  -- 3. 将明细按机构层级和客户经理展开为统计对象，并关联当前月日均资产计算达标状态。
  INSERT INTO TMP_ADS_POTN_STAT_SRC (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      DATA_DATE,                                                -- 数据日期（YYYYMMDD）
      STATIS_CYCLE,                                             -- 统计周期（M=月度）
      STATIS_OBJ,                                               -- 统计对象（机构ID或客户经理岗位ID）
      LVL_CRIT,                                                 -- 临界等级（03/04/05/06/07）
      MTH_AVG_QUAL_STATE,                                       -- 月日均达标状态（1=达标，0=未达标）
      PNT_QUAL_STATE,                                           -- T-1时点达标状态（1=达标，0=未达标）
      CNTCT_STATE                                               -- 月接触状态（1=有接触，0=无接触）
  )
  -- 机构分支：将客户所属叶子机构向上展开至各级祖先机构，形成机构统计口径。
  SELECT D.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         D.DATA_DATE,                                           -- 数据日期
         D.STATIS_CYCLE,                                        -- 统计周期
         O.ANCESTOR_ORG_ID,                                     -- 祖先机构ID（作为统计对象）
         D.LVL_CRIT,                                            -- 临界等级
         CASE                                                   -- 按跑批日月日均AUM判断是否达到临界等级阈值
           WHEN (D.LVL_CRIT = '03' AND NVL(M.AUM_BAL, 0) >= 50000)      -- 临界优质：月日均AUM≥5万
             OR (D.LVL_CRIT = '04' AND NVL(M.AUM_BAL, 0) >= 300000)     -- 临界财富1：月日均AUM≥30万
             OR (D.LVL_CRIT = '05' AND NVL(M.AUM_BAL, 0) >= 500000)     -- 临界财富2：月日均AUM≥50万
             OR (D.LVL_CRIT = '06' AND NVL(M.AUM_BAL, 0) >= 1000000)    -- 临界贵宾：月日均AUM≥100万
             OR (D.LVL_CRIT = '07' AND NVL(M.AUM_BAL, 0) >= 3000000)    -- 临界私行：月日均AUM≥300万
           THEN '1'                                             -- 达标
           ELSE '0'                                             -- 未达标
         END,
         D.QUAL_STATE,                                          -- T-1时点达标状态（直接取自明细表）
         D.CNTCT_STATE                                          -- 月接触状态（直接取自明细表）
    FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D                       -- D：潜力提升客户明细
    JOIN (
          SELECT DISTINCT
                 CONNECT_BY_ROOT X.ORG_ID AS LEAF_ORG_ID,       -- 叶子机构ID（起点）
                 X.ORG_ID AS ANCESTOR_ORG_ID                    -- 祖先机构ID（向上展开的所有祖先）
            FROM DWD_SYS_ORG X                                  -- X：机构树表
           START WITH X.ORG_ID IN (
                 SELECT DISTINCT ORG_ID
                   FROM ADS_CUST_POTN_UPGRADE_CUST_DTL
                  WHERE ORG_ID IS NOT NULL                      -- 以潜力提升明细中出现的机构为起点
                )
         CONNECT BY NOCYCLE PRIOR X.SUP_ORG_ID = X.ORG_ID       -- 沿上级机构向上递归
    ) O                                                        -- O：机构层级展开结果
      ON O.LEAF_ORG_ID = D.ORG_ID                               -- 明细的叶子机构匹配展开起点的叶子机构
    LEFT JOIN DWS_CUST_ASSE_LIAB M                              -- M：当月月日均AUM（DATA_DATE=V_SYSDAT, BAL_TYPE='2'）
     ON M.CUST_ID = D.CUST_ID
     AND M.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE         -- 双键关联：客户号+法人行号
     AND M.DATA_DATE = V_SYSDAT                                 -- 取跑批日数据
     AND M.BAL_TYPE = '2'                                       -- 月日均余额类型
   WHERE D.DATA_DATE = V_SYSDAT                                 -- 仅统计当天跑批产生的明细

  UNION ALL

  -- 客户经理分支：按管户经理岗位ID直接分组统计。
  SELECT D.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         D.DATA_DATE,                                           -- 数据日期
         D.STATIS_CYCLE,                                        -- 统计周期
         D.POST_ID,                                             -- 管户经理岗位ID（作为统计对象）
         D.LVL_CRIT,                                            -- 临界等级
         CASE                                                   -- 按跑批日月日均AUM判断是否达到临界等级阈值
           WHEN (D.LVL_CRIT = '03' AND NVL(M.AUM_BAL, 0) >= 50000)      -- 临界优质：月日均AUM≥5万
             OR (D.LVL_CRIT = '04' AND NVL(M.AUM_BAL, 0) >= 300000)     -- 临界财富1：月日均AUM≥30万
             OR (D.LVL_CRIT = '05' AND NVL(M.AUM_BAL, 0) >= 500000)     -- 临界财富2：月日均AUM≥50万
             OR (D.LVL_CRIT = '06' AND NVL(M.AUM_BAL, 0) >= 1000000)    -- 临界贵宾：月日均AUM≥100万
             OR (D.LVL_CRIT = '07' AND NVL(M.AUM_BAL, 0) >= 3000000)    -- 临界私行：月日均AUM≥300万
           THEN '1'                                             -- 达标
           ELSE '0'                                             -- 未达标
         END,
         D.QUAL_STATE,                                          -- T-1时点达标状态
         D.CNTCT_STATE                                          -- 月接触状态
    FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D                       -- D：潜力提升客户明细
    LEFT JOIN DWS_CUST_ASSE_LIAB M                              -- M：当月月日均AUM
     ON M.CUST_ID = D.CUST_ID
     AND M.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE
     AND M.DATA_DATE = V_SYSDAT
     AND M.BAL_TYPE = '2'
   WHERE D.POST_ID IS NOT NULL                                  -- 仅统计有管户经理的客户
     AND D.DATA_DATE = V_SYSDAT;

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
  -- 4. 目标表写入：按统计对象和月度周期汇总
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  -- 4. 按统计对象、法人行、统计周期和临界等级汇总客户数、达标人数、接触人数及比例。
  INSERT INTO ADS_CUST_POTN_UPGRADE_STATIS (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      DATA_DATE,                                                -- 数据日期（YYYYMMDD）
      STATIS_OBJ,                                               -- 统计对象（机构ID或管户经理岗位ID）
      STATIS_CYCLE,                                             -- 统计周期（M=月度）
      LVL_CRIT,                                                 -- 临界等级（03/04/05/06/07）
      TTL_CUST_CNT,                                             -- 总客户数
      MTH_AVG_QUAL_CNT,                                         -- 月日均达标客户数
      MTH_AVG_QUAL_RATE,                                        -- 月日均达标率（%，保留2位小数）
      PNT_QUAL_CNT,                                             -- T-1时点达标客户数
      PNT_QUAL_RATE,                                            -- T-1时点达标率（%，保留2位小数）
      CNTCT_CUST_CNT,                                           -- 接触客户数
      CNTCT_RATE                                                -- 接触率（%，保留2位小数）
  )
  SELECT S.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         S.DATA_DATE,                                           -- 数据日期
         S.STATIS_OBJ,                                           -- 统计对象
         S.STATIS_CYCLE,                                        -- 统计周期
         S.LVL_CRIT,                                            -- 临界等级
         COUNT(*),                                              -- 总客户数：每个展开记录算1个统计单位
         SUM(CASE WHEN S.MTH_AVG_QUAL_STATE = '1' THEN 1 ELSE 0 END),  -- 月日均达标客户数
         CASE WHEN COUNT(*) = 0 THEN 0                          -- 月日均达标率=达标数/总数×100
              ELSE ROUND(SUM(CASE WHEN S.MTH_AVG_QUAL_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
         END,
         SUM(CASE WHEN S.PNT_QUAL_STATE = '1' THEN 1 ELSE 0 END),      -- T-1时点达标客户数
         CASE WHEN COUNT(*) = 0 THEN 0                          -- T-1时点达标率=达标数/总数×100
              ELSE ROUND(SUM(CASE WHEN S.PNT_QUAL_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
         END,
         SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END),         -- 接触客户数
         CASE WHEN COUNT(*) = 0 THEN 0                          -- 接触率=接触数/总数×100
              ELSE ROUND(SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
         END
    FROM TMP_ADS_POTN_STAT_SRC S                                 -- S：统计源数据（已按机构/客户经理展开）
   GROUP BY S.PERSN_LEGAL_BK_CODE,                               -- 按法人行号
            S.DATA_DATE,                                         -- 按数据日期
            S.STATIS_OBJ,                                         -- 按统计对象
            S.STATIS_CYCLE,                                      -- 按统计周期
            S.LVL_CRIT;                                          -- 按临界等级

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：按统计对象和月度周期汇总写入统计';
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
