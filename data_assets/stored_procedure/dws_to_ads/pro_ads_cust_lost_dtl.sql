CREATE OR REPLACE PROCEDURE pro_ads_cust_lost_dtl(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：客户流失清单
  --
  -- 业务规则：
  -- 轻度流失：上月金融资产月日均达标，上月末金融资产余额不达标
  -- 重度流失：上上月金融资产月日均达标（上月金融资产月日均不达标），上月末金融资产余额不达标
  --
  -- 等级体系说明：
  -- 客户AUM等级（CUST_LVL）：存储在DWS_CUST_LVL_INFO表中，基于AUM余额计算得出
  -- 客户等级编码：按AUM余额区间划分的规则
  -- 等级阈值映射（客户等级编码 -> AUM阈值）：
  --   03-优质：50000
  --   04-财富1：300000
  --   05-财富2：500000
  --   07-贵宾：1000000
  --   09-私行：3000000
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
  V_PRC_DESC             VARCHAR(100) := '客户流失清单';
  V_PRC_NAME             VARCHAR(32)  := 'pro_ads_cust_lost_dtl';
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
  DELETE FROM ads_cust_lost_dtl 
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

  -- 3.1 TMP1: 临时表段 - 流失客户数据（基于AUM余额达标情况判断）
  V_NO_ID := 'TMP1';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_lost_cust;
  CREATE TEMP TABLE tmp_lost_cust AS
  SELECT 
      curr.cust_id,                              -- 客户编号
      curr.aum_bal,                              -- 当前AUM余额
      curr.depo_curnt_depo_bal,                  -- 当前活期存款余额
      curr.fixd_depo_bal,                        -- 当前定期存款余额
      curr.fin_bal,                              -- 当前金融资产余额
      curr.cust_lvl,                             -- 当前客户等级（从DWS_CUST_LVL_INFO获取）
      prev.cust_lvl AS prev_lvl,                 -- 上月客户等级
      prev.aum_bal AS prev_aum_bal,              -- 上月月日均AUM
      prev_bal.aum_bal AS prev_end_bal,          -- 上月末余额
      prev_prev.aum_bal AS prev_prev_aum_bal,    -- 上上月月日均AUM
      prev_prev.cust_lvl AS prev_prev_lvl,       -- 上上月客户等级
      CASE 
          WHEN prev.cust_lvl IN ('03','04','05','07','09') 
               AND prev.aum_bal >= CASE prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END 
               AND COALESCE(prev_end_bal, 0) < CASE prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END THEN '01' -- 轻度流失
          WHEN prev_prev.cust_lvl IN ('03','04','05','07','09') 
               AND prev_prev.aum_bal >= CASE prev_prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END 
               AND COALESCE(prev.aum_bal, 0) < CASE prev_prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END 
               AND COALESCE(prev_end_bal, 0) < CASE prev_prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END THEN '02' -- 重度流失
          ELSE NULL
      END AS lvl_churn                          -- 流失等级：01轻度流失，02重度流失
  FROM (
      SELECT 
          a.cust_id,
          a.aum_bal,
          a.depo_curnt_depo_bal,
          a.fixd_depo_bal,
          a.fin_bal,
          COALESCE(l.cust_lvl, '00') AS cust_lvl
      FROM dws_cust_asse_liab a                -- DWS层客户资产负债表(当前月)
      LEFT JOIN dws_cust_lvl_info l            -- DWS层客户等级信息表(当前月)
          ON a.cust_id = l.cust_id 
          AND a.data_date = l.data_dt
      WHERE a.data_date = V_SYSDAT             -- 当前数据日期
        AND a.bal_type = '2'                   -- 余额类型：2表示月日均
  ) curr
  LEFT JOIN (
      SELECT 
          a.cust_id,
          a.aum_bal,
          COALESCE(l.cust_lvl, '00') AS cust_lvl
      FROM dws_cust_asse_liab a                -- DWS层客户资产负债表(上月月日均)
      LEFT JOIN dws_cust_lvl_info l            -- DWS层客户等级信息表(上月)
          ON a.cust_id = l.cust_id 
          AND a.data_date = l.data_dt
      WHERE a.data_date = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - INTERVAL '1 month', 'YYYYMMDD')
        AND a.bal_type = '2'
  ) prev ON curr.cust_id = prev.cust_id
  LEFT JOIN (
      SELECT 
          a.cust_id,
          a.aum_bal
      FROM dws_cust_asse_liab a                -- DWS层客户资产负债表(上月末)
      WHERE a.data_date = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - INTERVAL '1 month', 'YYYYMMDD')
        AND a.bal_type = '1'                   -- 余额类型：1表示时点余额
  ) prev_bal ON curr.cust_id = prev_bal.cust_id
  LEFT JOIN (
      SELECT 
          a.cust_id,
          a.aum_bal,
          COALESCE(l.cust_lvl, '00') AS cust_lvl
      FROM dws_cust_asse_liab a                -- DWS层客户资产负债表(上上月月日均)
      LEFT JOIN dws_cust_lvl_info l            -- DWS层客户等级信息表(上上月)
          ON a.cust_id = l.cust_id 
          AND a.data_date = l.data_dt
      WHERE a.data_date = TO_CHAR(TO_DATE(V_SYSDAT, 'YYYYMMDD') - INTERVAL '2 month', 'YYYYMMDD')
        AND a.bal_type = '2'
  ) prev_prev ON curr.cust_id = prev_prev.cust_id
  WHERE (
          -- 轻度流失：上月月日均达标，上月末余额不达标
          (prev.cust_lvl IN ('03','04','05','07','09') 
           AND prev.aum_bal >= CASE prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END
           AND COALESCE(prev_end_bal, 0) < CASE prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END)
          OR
          -- 重度流失：上上月月日均达标，上月月日均不达标，上月末余额不达标
          (prev_prev.cust_lvl IN ('03','04','05','07','09') 
           AND prev_prev.aum_bal >= CASE prev_prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END
           AND COALESCE(prev.aum_bal, 0) < CASE prev_prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END
           AND COALESCE(prev_end_bal, 0) < CASE prev_prev.cust_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END)
        );

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 临时表处理完成，流失客户数: ' || (SELECT COUNT(*) FROM tmp_lost_cust WHERE lvl_churn IS NOT NULL);
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

  -- 3.4 TMP4: 临时表段 - 挽回客户判断（T-1日金融资产余额达标）
  V_NO_ID := 'TMP4';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_rescued_cust;
  CREATE TEMP TABLE tmp_rescued_cust AS
  SELECT 
      t.cust_id,
      '1' AS rescue_state
  FROM tmp_lost_cust t
  WHERE t.aum_bal >= CASE WHEN t.lvl_churn = '01' THEN 
                         CASE t.prev_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END
                       ELSE
                         CASE t.prev_prev_lvl WHEN '03' THEN 50000 WHEN '04' THEN 300000 WHEN '05' THEN 500000 WHEN '07' THEN 1000000 WHEN '09' THEN 3000000 END
                       END;

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP4 临时表处理完成，已挽回客户数: ' || (SELECT COUNT(*) FROM tmp_rescued_cust);
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

  -- 3.5 目标表写入 - 客户流失清单
  V_NO_ID := '2';
  V_BGN_DATE := NOW();

  INSERT INTO ads_cust_lost_dtl (
      data_date,           -- 数据日期
      cust_id,             -- 客户编号
      cust_name,           -- 客户名称
      cust_lvl,            -- 客户等级
      lvl_churn,           -- 流失等级：01轻度流失，02重度流失
      depo_curnt_depo_bal, -- 活期余额
      fixd_depo_bal,       -- 定期余额
      fin_amt,             -- 理财余额
      cntct_state,         -- 接触状态：0未接触/1已接触
      rescue_state,        -- 挽回状态：0未挽回/1已挽回
      post_id,             -- 管户经理
      org_id               -- 归属机构
  )
  SELECT 
      V_SYSDAT AS data_date,
      t.cust_id,
      COALESCE(i.cust_name, '') AS cust_name,
      t.cust_lvl,
      t.lvl_churn,
      t.depo_curnt_depo_bal,
      t.fixd_depo_bal,
      t.fin_bal AS fin_amt,
      COALESCE(c.cntct_state, '0') AS cntct_state,
      COALESCE(r.rescue_state, '0') AS rescue_state,
      COALESCE(i.post_id, '') AS post_id,
      COALESCE(i.org_id, '') AS org_id
  FROM tmp_lost_cust t                        -- 临时表：流失客户
  LEFT JOIN tmp_cust_contact c                -- 临时表：已接触客户
      ON t.cust_id = c.cust_id
  LEFT JOIN tmp_cust_info i                   -- 临时表：客户基本信息
      ON t.cust_id = i.cust_id
  LEFT JOIN tmp_rescued_cust r                -- 临时表：已挽回客户
      ON t.cust_id = r.cust_id
  WHERE t.lvl_churn IS NOT NULL;              -- 只保留有流失等级的客户

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