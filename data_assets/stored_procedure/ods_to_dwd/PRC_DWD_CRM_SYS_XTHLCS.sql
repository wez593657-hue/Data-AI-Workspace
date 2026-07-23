CREATE OR REPLACE PROCEDURE PRC_DWD_CRM_SYS_XTHLCS(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称: 货币汇率表
  -- 报表编号：PRC_DWD_CRM_SYS_XTHLCS
  -- 处理周期：日
  -- 过程描述：
  -- 来源表：CBS_KFXP_XTHLCS
  -- 目标表：DWD_CRM_SYS_XTHLCS
  -- author :
  -- date   ： 2020-06-11
  -- 适配数据库：人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '单位性质';
  V_PRC_NAME             VARCHAR(32)  := 'P_MTS_CUST_LABEL_AF03';
  V_SYSDAT2              VARCHAR(10);
  V_SQL                  VARCHAR(4000);
  V_LOG_MSG              VARCHAR(4000);
  V_START_DT             DATE;
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  P_INTERVAL_START_DATE  VARCHAR(8);
  P_INTERVAL_END_DATE    VARCHAR(8);
begin
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  -- 默认返回成功，异常时统一改为 -1
  --OUTCDE := 0;

  -- 记录跑批开始时间，用于统计整个过程耗时
  V_START_DT := SYSDATE;

  -- 将输入的批处理日期转换为标准格式，便于后续日志和区间处理
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');

  -- 预留时间区间参数，方便后续扩展按天/按月增量处理
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  -- 每次跑批前先清空目标表，保证结果为当日全量重算
  EXECUTE IMMEDIATE 'TRUNCATE TABLE CRM_SYS_XTHLCS';

  --***************************************
  -- 2.0 -- 第1段处理开始：记录步骤号和起始时间
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- 第1段业务逻辑：从客户基础信息表提取单位性质，写入目标标签表
  INSERT INTO DWD_CRM_SYS_XTHLCS
    SELECT P.HUOBDAIH,
           P.PJDANWEI,
           P.HUOBFHAO,
           P.ZHNGJJIA,
           P.ZHNGJJIA / P.PJDANWEI AS HL
      FROM (SELECT C.*,
                   ROW_NUMBER() OVER(PARTITION BY C.HUOBDAIH ORDER BY C.SHENXRIQ DESC, C.SHENXSHJ DESC) ROWNUM
              FROM CBS_KFXP_XTHLCS C) P
     WHERE ROWNUM_ = 1;
  -- 提交第1段结果，确保已完成数据不被后续异常影响
  COMMIT;

  -- 记录第1段结束时间和耗时
  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第1段业务逻辑处理完成';
  V_LOG_FLG := OUTCDE;

  -- 调用日志过程，记录第1段正常结束信息
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
    -- ***************************************  
    -- 3. 异常处理区（捕获错误码并记录详细日志）
    -- ***************************************  
EXCEPTION
  WHEN OTHERS THEN
    -- 异常时先回滚当前未提交数据，避免留下半成品
    OUTCDE := -1;
    ROLLBACK;

    -- 记录异常发生后的结束时间和耗时
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;

    -- 用 Oracle 标准错误信息写入日志，保留前 1000 个字符
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;

    -- 异常信息也走同一个日志过程，保证审计链路一致
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

    -- 继续抛出异常，交给上层调度器感知失败
    RAISE;
END;
