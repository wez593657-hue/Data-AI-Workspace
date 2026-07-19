CREATE OR REPLACE PROCEDURE pro_ads_cust_lost_statis(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：客户挽回统计
  --
  -- 生成规则：
  -- 1. 保留本过程的参数、异常处理框架和 SYS_PRC_STEP_LOGS 调用方式。
  -- 2. 业务逻辑按实际处理链拆分，不预设固定的业务段数量。
  -- 3. 每个物理临时表段按 TMP1、TMP2、TMP3... 顺序命名并独立处理。
  -- 4. 每个临时表段必须依次包含：设置步骤号、记录开始时间、处理数据、COMMIT、
  --    记录结束时间和耗时、调用 SYS_PRC_STEP_LOGS。
  -- 5. 临时表段之间的 COMMIT 和日志调用不可省略，不得合并为过程末尾一次提交。
  -- 6. 临时表段完成后，再按实际业务逻辑汇总写入目标表，并单独记录目标表步骤日志。
  -- 7. 字段、来源表、过滤条件无法确认时保留 NULL 或明确占位，不得猜测业务规则。
  -- 8. 字段、来源表、目标表都要带上注释并对齐。
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '客户挽回统计';
  V_PRC_NAME             VARCHAR(32)  := 'pro_ads_cust_lost_statis';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
BEGIN
  --***************************************
  --1.自定义参数区
  --***************************************
  IF V_SYSDAT IS NULL
     OR NOT V_SYSDAT ~ '^[0-9]{8}$'
  THEN
    RAISE EXCEPTION 'V_SYSDAT must be in YYYYMMDD format';
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  --***************************************
  -- 2. 目标表准备
  --***************************************
  
  -- 每日全量过程先清理目标表；该语义保持不变。
  DELETE FROM ads_cust_lost_statis 
  WHERE data_date = V_SYSDAT;

  COMMIT;

  V_NO_ID := '1';
  V_BGN_DATE := NOW();
  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := '清理目标表完成，删除数据日期: ' || V_SYSDAT;
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

  --***************************************
  -- 3. 业务处理段
  --***************************************

  -- 3.1 目标表写入 - 客户挽回统计
  V_NO_ID := '2';
  V_BGN_DATE := NOW();

  INSERT INTO ads_cust_lost_statis (
      data_date,           -- 数据日期
      statis_obj,          -- 统计对象：0全量
      statis_cycle,        -- 统计周期：01月度
      lvl_churn,           -- 流失等级
      cust_cnt,            -- 客户数
      cntct_cust_cnt,      -- 已接触客户
      cntct_rate,          -- 接触率(%)
      rescued_cust_cnt,    -- 已挽回客户
      rescue_rate,         -- 挽回率(%)
      rescued_fina_asset   -- 已挽回金融资产
  )
  SELECT 
      V_SYSDAT AS data_date,
      '0' AS statis_obj,                       -- 统计对象：0全量
      '01' AS statis_cycle,                    -- 统计周期：01月度
      d.lvl_churn,                             -- 流失等级
      COUNT(*) AS cust_cnt,                    -- 客户数
      SUM(CASE WHEN d.cntct_state = '1' THEN 1 ELSE 0 END) AS cntct_cust_cnt,  -- 已接触客户数
      ROUND(CASE WHEN COUNT(*) > 0 THEN SUM(CASE WHEN d.cntct_state = '1' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) ELSE 0 END * 100, 2) AS cntct_rate,  -- 接触率(%)
      SUM(CASE WHEN d.rescue_state = '1' THEN 1 ELSE 0 END) AS rescued_cust_cnt, -- 已挽回客户数
      ROUND(CASE WHEN COUNT(*) > 0 THEN SUM(CASE WHEN d.rescue_state = '1' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) ELSE 0 END * 100, 2) AS rescue_rate,  -- 挽回率(%)
      SUM(CASE WHEN d.rescue_state = '1' THEN d.pnt_aum_bal ELSE 0 END) AS rescued_fina_asset  -- 已挽回金融资产（T-1日时点AUM余额）
  FROM ads_cust_lost_dtl d                    -- ADS层客户流失清单表
  WHERE d.data_date = V_SYSDAT                -- 数据日期
  GROUP BY d.lvl_churn;                       -- 按流失等级分组统计

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := '第2个业务处理段完成，插入统计记录数: ' || SQL%ROWCOUNT;
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

  -- ***************************************  
  -- 4. 异常处理区（捕获错误码并记录详细日志）
  -- ***************************************  
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;

    V_END_DATE := NOW();
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER
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