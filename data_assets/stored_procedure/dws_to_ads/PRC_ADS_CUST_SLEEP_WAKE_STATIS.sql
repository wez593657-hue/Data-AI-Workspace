CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_SLEEP_WAKE_STATIS(
    V_SYSDAT IN VARCHAR,        -- 系统跑批日期，格式YYYYMMDD
    OUTCDE   OUT INTEGER        -- 输出状态码: 0=成功，非0=失败
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒统计
  -- 处理周期: 日
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.16.2
  -- 关联需求: REQ-CUST-008(睡眠户唤醒), REQ-CUST-028(最新唤醒口径确认)
  -- 变更记录:
  --   v2.1.0-v2.8.0: 见前续版本
  --   v2.10.0(2026-07-31): 月首先由明细过程完成上月末复核及当日合并；
  --   v2.11.0(2026-08-04): F-06: 删除V_END_DATE无效初始化；
  --                        F-09: 移除上月末数据取数条件及清理逻辑。
  --   v2.12.0(2026-08-04): O-04: CONNECT BY机构递归预物化到
  --        TMP_ADS_SLEEP_ORG_HIER临时表，消除TMP2步骤INSERT子查询内
  --        的实时递归计算，提升大机构树场景下的执行效率。
  --   v2.12.1(2026-08-04): 模板规范化
  --        F-6: 步骤编号规范化: TMP1→'1'(清理), TMP2→'TMP1'(层级+维度展开),
  --              '3'→'2'(目标表写入)，同步日志消息
  --   v2.15.0(2026-08-05): 与明细过程同步采用本月新增持有产品唤醒口径；
  --          统计仅汇总当日月度明细，机构向上汇总和客户经理维度保持不变。
  --   v2.16.0(2026-08-17): 睡眠户清单来源切换至DWS_CUST_DORMANT_ACCOUT
  --          （明细过程v2.16.0）；本过程统计逻辑不变，仅版本同步。
  --          注: ORG_ID可能为空(不兜底)，机构维度不包含ORG为空的客户，
  --          建议在统计前输出ORG空值占比预警。
  --   v2.16.1(2026-08-17): 明细过程重构为先身份后属性（[D1]属性补全），
  --          本过程统计逻辑仍不变，仅版本同步。
  --   v2.16.2(2026-08-17): 明细过程改为属性计算式（[D1]/[D2]下线，属性与
  --          接触/唤醒状态在第4段直接计算），本过程统计逻辑仍不变，仅版本同步。
  ------------------------------------------------------------------
  -- === 输入参数 ===
  -- V_SYSDAT: 系统跑批日期 VARCHAR(8)，取值YYYYMMDD，非NULL且必须为有效日期格式；
  --           用于当前统计日数据聚合。
  -- OUTCDE:   输出状态码 INTEGER OUT，0=成功，-1=异常；异常时回滚并记录步骤日志。
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '睡眠户唤醒统计表';             -- 过程描述，固定值。
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_SLEEP_WAKE_STATIS'; -- 过程名，固定值。
  V_LOG_MSG              VARCHAR(4000);                                 -- 步骤/异常消息，最多4000字符。
  V_LOG_FLG              INTEGER;                                       -- 日志状态，0成功、-1异常。
  V_LOG_BUTTON           INTEGER := 1;                                  -- 日志按钮标识，固定为1。
  V_NO_ID                VARCHAR(10);                                   -- 步骤编号，TMP1/TMP2/3或异常步骤。
  V_BGN_DATE             DATE;                                          -- 步骤开始时间，仅用于耗时日志。
  V_END_DATE             DATE;                                          -- 步骤结束时间，仅用于耗时日志。
  V_DURA_DATE            INTEGER;                                       -- 步骤耗时，单位秒，非负整数。
  V_DATA_DATE            VARCHAR2(8);                                   -- 当前统计日期，YYYYMMDD，等于V_SYSDAT。
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                   -- 三年历史清理边界（参数19）

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 步骤1: 参数校验与日期初始化
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_DATA_DATE := V_SYSDAT;
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);         -- 三年历史清理边界（参数19）

  ------------------------------------------------------------------
  -- 步骤2: 清理当日统计、三年前历史、统计临时表
  -- F-09: 移除上月末统计清理(DTL月首已复核并写入当日，不再需要上月末数据)
  ------------------------------------------------------------------
  DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS s
   WHERE s.DATA_DATE = V_DATA_DATE;

  DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS s
   WHERE s.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_SLEEP_STAT_SRC');
  TRUNC_TMP('TMP_ADS_SLEEP_ORG_HIER');                               -- v2.12.0 O-04机构递归预物化
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '1 完成: 清理统计表数据和临时表';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: TMP1 — 预物化机构层级 + 展开统计维度
  --   [O-04] 预物化CONNECT BY机构递归 → TMP_ADS_SLEEP_ORG_HIER
  --   展开: 机构维度(JOIN预物化表) + 客户经理维度(UNION ALL)
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- ================================================================
  -- [O-04] 预物化机构层级: 从DTL叶子机构递归找所有祖先
  -- ================================================================
  INSERT INTO TMP_ADS_SLEEP_ORG_HIER (LEAF_ORG_ID, ANCESTOR_ORG_ID)
  SELECT DISTINCT
         CONNECT_BY_ROOT o.ORG_ID AS LEAF_ORG_ID,
         o.ORG_ID AS ANCESTOR_ORG_ID
    FROM DWD_SYS_ORG o
   START WITH o.ORG_ID IN (
         SELECT DISTINCT d1.ORG_ID
           FROM ADS_CUST_SLEEP_WAKE_DTL d1
          WHERE d1.DATA_DATE = V_DATA_DATE
            AND d1.ORG_ID IS NOT NULL
   )
 CONNECT BY NOCYCLE PRIOR o.SUP_ORG_ID = o.ORG_ID;
  COMMIT;

  INSERT INTO TMP_ADS_SLEEP_STAT_SRC (
      PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_CYCLE, STATIS_OBJ,
      CNTCT_STATE, WAKE_STATE
  )
  -- 维度1: 机构递归向上汇总 (JOIN预物化表)
  SELECT d.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         d.DATA_DATE,                                                  -- 数据日期
         d.STATIS_CYCLE,                                               -- 统计周期
         o.ANCESTOR_ORG_ID,                                            -- 统计对象=层级机构
         d.CNTCT_STATE,                                                -- 接触状态
         d.WAKE_STATE                                                  -- 唤醒状态
    FROM ADS_CUST_SLEEP_WAKE_DTL d                                     -- 明细表
    JOIN TMP_ADS_SLEEP_ORG_HIER o                                      -- v2.12.0 O-04: 预物化层级表
      ON o.LEAF_ORG_ID = d.ORG_ID
   WHERE d.DATA_DATE = V_DATA_DATE

  UNION ALL

  -- 维度2: 客户经理维度
  SELECT d.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         d.DATA_DATE,                                                  -- 数据日期
         d.STATIS_CYCLE,                                               -- 统计周期
         d.POST_ID,                                                    -- 统计对象=客户经理编号
         d.CNTCT_STATE,                                                -- 接触状态
         d.WAKE_STATE                                                  -- 唤醒状态
    FROM ADS_CUST_SLEEP_WAKE_DTL d                                     -- 明细表
   WHERE d.DATA_DATE = V_DATA_DATE                                     -- F-09: 仅取当日数据
     AND d.POST_ID IS NOT NULL;
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '1 完成: 机构递归+客户经理维度展开';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤4: 目标表写入 — 按统计对象聚合
  ------------------------------------------------------------------
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_SLEEP_WAKE_STATIS (
      PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE,
      CUST_CNT, CNTCT_CUST_CNT, CNTCT_RATE,
      WAKE_CUST_CNT, WAKE_RATE
  )
  SELECT s.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         s.DATA_DATE,                                                  -- 数据日期
         s.STATIS_OBJ,                                                 -- 统计对象
         s.STATIS_CYCLE,                                               -- 统计周期
         COUNT(*) AS CUST_CNT,                                         -- 睡眠客户总数
         SUM(CASE WHEN s.CNTCT_STATE='1' THEN 1 ELSE 0 END) AS CNTCT, -- 已接触数
         CASE WHEN COUNT(*)=0 THEN 0
              ELSE ROUND(SUM(CASE WHEN s.CNTCT_STATE='1' THEN 1 ELSE 0 END)/COUNT(*)*100,2)
         END AS CNTCT_RATE,                                            -- 接触率
         SUM(CASE WHEN s.WAKE_STATE='1' THEN 1 ELSE 0 END) AS WAKE,  -- 已唤醒数
         CASE WHEN COUNT(*)=0 THEN 0
              ELSE ROUND(SUM(CASE WHEN s.WAKE_STATE='1' THEN 1 ELSE 0 END)/COUNT(*)*100,2)
         END AS WAKE_RATE                                              -- 唤醒率
    FROM TMP_ADS_SLEEP_STAT_SRC s
   GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STATIS_CYCLE;
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第2段完成: 写入睡眠户唤醒统计(v2.16.2 来源DORMANT口径)';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NOT NULL AND V_END_DATE IS NOT NULL
                        THEN TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60) END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
        V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);
    RAISE;
END;
/
