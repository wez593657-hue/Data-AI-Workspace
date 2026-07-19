CREATE OR REPLACE PROCEDURE pro_ads_cust_potn_upgrade_cust_dtl(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：潜力提升客户明细
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
  V_PRC_DESC             VARCHAR(100) := '潜力提升客户明细';
  V_PRC_NAME             VARCHAR(32)  := 'pro_ads_cust_potn_upgrade_cust_dtl';
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
  DELETE FROM ads_cust_potn_upgrade_cust_dtl 
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

  -- 3.1 TMP1: 临时表段 - 潜力提升客户数据
  V_NO_ID := 'TMP1';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_potn_upgrade_cust;
  CREATE TEMP TABLE tmp_potn_upgrade_cust AS
  SELECT 
      a.cust_id,                              -- 客户编号
      a.aum_bal,                              -- AUM余额（月日均）
      a.depo_curnt_depo_bal,                  -- 活期存款余额
      a.fixd_depo_bal,                        -- 定期存款余额
      a.fin_bal,                              -- 金融资产余额
      COALESCE(l.cust_lvl, '00') AS cust_lvl, -- 客户等级（从客户等级信息表获取）
      CASE 
          WHEN a.aum_bal >= 45000 AND a.aum_bal < 50000 THEN '3'   -- 临界优质（客户等级编码：1字符）
          WHEN a.aum_bal >= 270000 AND a.aum_bal < 300000 THEN '6' -- 临界财富1（客户等级编码：1字符）
          WHEN a.aum_bal >= 450000 AND a.aum_bal < 500000 THEN '7' -- 临界财富2（客户等级编码：1字符）
          WHEN a.aum_bal >= 900000 AND a.aum_bal < 1000000 THEN '8' -- 临界贵宾（客户等级编码：1字符）
          WHEN a.aum_bal >= 2700000 AND a.aum_bal < 3000000 THEN '9' -- 临界私行（客户等级编码：1字符）
          ELSE NULL
      END AS lvl_crit                         -- 临界等级（客户等级编码：1字符）
  FROM dws_cust_asse_liab a                  -- DWS层客户资产负债表
  LEFT JOIN dws_cust_lvl_info l              -- DWS层客户等级信息表
      ON a.cust_id = l.cust_id 
      AND a.data_date = l.data_dt
  WHERE a.data_date = V_SYSDAT               -- 数据日期
    AND a.bal_type = '2';                    -- 余额类型：2表示月日均

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 临时表处理完成，临界客户数: ' || (SELECT COUNT(*) FROM tmp_potn_upgrade_cust WHERE lvl_crit IS NOT NULL);
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

  -- 3.2 TMP2: 临时表段 - 已接触客户数据
  V_NO_ID := 'TMP2';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_cust_contact;
  CREATE TEMP TABLE tmp_cust_contact AS
  SELECT 
      m.cust_id,                              -- 客户编号
      '1' AS cntct_state                      -- 接触状态：1表示已接触
  FROM ads_mkt_rec_info m                    -- ADS层营销记录表
  WHERE TO_CHAR(TO_DATE(m.mkt_time, 'YYYY-MM-DD HH24:MI:SS'), 'YYYYMMDD') <= V_SYSDAT
    AND m.mkt_time >= TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - INTERVAL '1 month', 'YYYY-MM-DD HH24:MI:SS')
    AND m.mkt_typ IN ('1', '2', '3', '4')    -- 营销类型：1面访/2电话/3短信/4企微
  GROUP BY m.cust_id;

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 临时表处理完成，已接触客户数: ' || (SELECT COUNT(*) FROM tmp_cust_contact);
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

  -- 3.3 TMP3: 临时表段 - 客户基本信息
  V_NO_ID := 'TMP3';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_cust_info;
  CREATE TEMP TABLE tmp_cust_info AS
  SELECT 
      c.cust_id,                              -- 客户编号
      c.cust_name,                            -- 客户名称
      c.host_cust_mngr_post_id AS post_id,    -- 主办客户经理职位编号
      c.org_lead AS org_id                    -- 归属机构
  FROM dwd_cust_indv_info c                  -- DWD层客户基本信息表
  WHERE c.data_date = V_SYSDAT;              -- 数据日期

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP3 临时表处理完成，客户信息数: ' || (SELECT COUNT(*) FROM tmp_cust_info);
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

  -- 3.4 目标表写入 - 潜力提升客户明细
  V_NO_ID := '2';
  V_BGN_DATE := NOW();

  INSERT INTO ads_cust_potn_upgrade_cust_dtl (
      data_date,           -- 数据日期
      cust_id,             -- 客户编号
      cust_name,           -- 客户名称
      cust_lvl,            -- 客户等级
      lvl_crit,            -- 临界等级
      depo_curnt_depo_bal, -- 活期存款余额
      fixd_depo_bal,       -- 定期存款余额
      fin_amt,             -- 金融资产余额
      cntct_state,         -- 接触状态
      qual_state,          -- 达标状态
      post_id,             -- 主办客户经理职位编号
      org_id               -- 归属机构
  )
  SELECT 
      V_SYSDAT AS data_date,
      t.cust_id,
      COALESCE(i.cust_name, '') AS cust_name,
      t.cust_lvl,
      t.lvl_crit,
      t.depo_curnt_depo_bal,
      t.fixd_depo_bal,
      t.fin_bal AS fin_amt,
      COALESCE(c.cntct_state, '0') AS cntct_state,  -- 接触状态：0未接触/1已接触
      CASE 
          WHEN t.lvl_crit = '3' AND t.aum_bal >= 50000 THEN '1'
          WHEN t.lvl_crit = '6' AND t.aum_bal >= 300000 THEN '1'
          WHEN t.lvl_crit = '7' AND t.aum_bal >= 500000 THEN '1'
          WHEN t.lvl_crit = '8' AND t.aum_bal >= 1000000 THEN '1'
          WHEN t.lvl_crit = '9' AND t.aum_bal >= 3000000 THEN '1'
          ELSE '0'
      END AS qual_state,                            -- 达标状态：0未达标/1已达标
      COALESCE(i.post_id, '') AS post_id,
      COALESCE(i.org_id, '') AS org_id
  FROM tmp_potn_upgrade_cust t                    -- 临时表：潜力提升客户
  LEFT JOIN tmp_cust_contact c                    -- 临时表：已接触客户
      ON t.cust_id = c.cust_id
  LEFT JOIN tmp_cust_info i                       -- 临时表：客户基本信息
      ON t.cust_id = i.cust_id
  WHERE t.lvl_crit IS NOT NULL;                   -- 只保留有临界等级的客户

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := '第2个业务处理段完成，插入记录数: ' || SQL%ROWCOUNT;
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