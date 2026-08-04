CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_SLEEP_WAKE_STATIS(
    V_SYSDAT IN VARCHAR,        -- 系统跑批日期，格式YYYYMMDD
    OUTCDE   OUT INTEGER        -- 输出状态码: 0=成功，非0=失败
)
AS
  ------------------------------------------------------------------
  -- 存储过程：睡眠户唤醒统计
  -- 处理周期: 日
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.11.0
  -- 关联需求: REQ-CUST-008(睡眠户唤醒), REQ-CUST-020(精简重构)
  -- 变更记录:
  --   v2.1.0-v2.6.0: 见前续版本
  --   v2.8.0(2026-07-30): 移除睡眠类型分组及存量/新增拆分字段
  --   v2.10.0(2026-07-31): 月首先由明细过程完成上月末复核及当日合并；
  --                        统计仍只输出总数、接触和唤醒，不新增存量/新增字段；
  --                        历史日期清理改为YYYYMMDD字符串比较以保留索引可用性。
  --   v2.11.0(2026-08-04): F-06: 删除V_END_DATE无效初始化；
  --                        F-09: 移除上月末数据取数条件及清理逻辑，
  --                        统计仅基于DTL当日(V_DATA_DATE)数据，
  --                        消除上月末未复核数据的重复计算。
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
  V_NO_ID := 'TMP1';
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
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成: 清理统计表数据和临时表';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: TMP2 — 展开机构递归汇总和客户经理维度
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_SLEEP_STAT_SRC (
      PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_CYCLE, STATIS_OBJ,
      CNTCT_STATE, WAKE_STATE
  )
  -- 维度1: 机构递归向上汇总 (CONNECT BY)
  SELECT d.PERSN_LEGAL_BK_CODE,                                       -- 法人行号
         d.DATA_DATE,                                                  -- 数据日期
         d.STATIS_CYCLE,                                               -- 统计周期
         o.ANCESTOR_ORG_ID,                                            -- 统计对象=层级机构
         d.CNTCT_STATE,                                                -- 接触状态
         d.WAKE_STATE                                                  -- 唤醒状态
    FROM ADS_CUST_SLEEP_WAKE_DTL d                                     -- 明细表
    JOIN (-- 机构递归: 从明细中的叶子机构出发，向上找所有祖先机构
          SELECT DISTINCT
                 CONNECT_BY_ROOT o.ORG_ID AS LEAF_ORG_ID,             -- 叶子机构
                 o.ORG_ID AS ANCESTOR_ORG_ID                           -- 祖先机构(含自身)
            FROM DWD_SYS_ORG o                                         -- 系统机构表
           START WITH o.ORG_ID IN (
                 SELECT DISTINCT d1.ORG_ID
                   FROM ADS_CUST_SLEEP_WAKE_DTL d1
                  WHERE d1.DATA_DATE = V_DATA_DATE                     -- F-09: 仅取当日数据
                    AND d1.ORG_ID IS NOT NULL
           )
         CONNECT BY NOCYCLE PRIOR o.SUP_ORG_ID = o.ORG_ID             -- 沿上级机构递归
    ) o
      ON o.LEAF_ORG_ID = d.ORG_ID
   WHERE d.DATA_DATE = V_DATA_DATE                                     -- F-09: 仅取当日数据

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
  V_LOG_MSG := 'TMP2 完成: 机构递归+客户经理维度展开';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT,V_PRC_NAME,V_PRC_DESC,V_NO_ID,
      V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,V_LOG_FLG,V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤4: 目标表写入 — 按统计对象聚合
  ------------------------------------------------------------------
  V_NO_ID := '3';
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
  V_LOG_MSG := '第3段完成: 写入睡眠户唤醒统计(v2.11.0 F-06/F-09优化)';
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
