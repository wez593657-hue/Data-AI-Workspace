CREATE OR REPLACE PROCEDURE pro_ads_cust_prdkt_rcmd(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：客户产品推荐
  --
  -- 业务逻辑：基于产品推荐方案，对即将到期的客户理财产品进行承接推荐
  -- 推荐流程：全量在售产品池 -> 硬过滤 -> 候选产品池 -> 评分排序 -> 输出Top 3推荐结果
  --
  -- 评分模型（100分制）：
  --   收益吸引力得分（35分）+ 期限匹配度得分（30分）+ 风险舒适度得分（20分）+ 历史偏好得分（15分）
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '客户产品推荐';
  V_PRC_NAME             VARCHAR(32)  := 'pro_ads_cust_prdkt_rcmd';
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
  
  DELETE FROM ads_cust_prdkt_rcmd 
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

  -- 3.1 TMP1: 临时表段 - 获取在售产品池
  V_NO_ID := 'TMP1';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_prdkt_pool;
  CREATE TEMP TABLE tmp_prdkt_pool AS
  SELECT 
      p.prdkt_id,                              -- 产品编号
      p.prdkt_name,                            -- 产品名称
      p.prdkt_cate_big,                        -- 产品大类
      p.prdkt_state,                           -- 产品状态
      p.prdkt_rate,                            -- 产品预期收益率
      p.bgn_date,                              -- 开始日期
      p.end_date,                              -- 结束日期
      p.issu_org,                              -- 发行机构
      COALESCE(f.risk_lvl, 'R1') AS risk_lvl,  -- 产品风险等级
      COALESCE(f.expr_date, '') AS expr_date,  -- 到期日期
      CASE 
          WHEN f.expr_date IS NOT NULL AND f.expr_date != '' THEN 
              EXTRACT(DAY FROM (TO_DATE(f.expr_date, 'YYYY-MM-DD') - TO_DATE(V_SYSDAT, 'YYYYMMDD')))
          ELSE NULL 
      END AS duration_days                     -- 产品期限(天)
  FROM dwd_prdkt_info p                        -- DWD层产品信息表
  LEFT JOIN dwd_acct_fin f                     -- DWD层理财账户信息表（获取风险等级）
      ON p.prdkt_id = f.prdkt_id
  WHERE p.prdkt_state = '在售';                -- 硬过滤：产品状态为在售

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 临时表处理完成，在售产品数: ' || (SELECT COUNT(*) FROM tmp_prdkt_pool);
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

  -- 3.2 TMP2: 临时表段 - 获取客户风险承受等级
  V_NO_ID := 'TMP2';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_cust_risk;
  CREATE TEMP TABLE tmp_cust_risk AS
  SELECT 
      r.cust_id,                              -- 客户编号
      COALESCE(r.risk_lvl, 'C3') AS risk_lvl  -- 客户风险承受等级(C1-C5)
  FROM dwd_cust_indiv_risk_invst r            -- DWD层客户风险评估表
  WHERE r.estim_date <= V_SYSDAT              -- 评估日期在数据日期之前
    AND (r.expr_date IS NULL OR r.expr_date >= V_SYSDAT); -- 评估未过期

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 临时表处理完成，客户风险评估数: ' || (SELECT COUNT(*) FROM tmp_cust_risk);
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

  -- 3.3 TMP3: 临时表段 - 获取即将到期的客户产品（到期承接场景）
  V_NO_ID := 'TMP3';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_expiring_prdkt;
  CREATE TEMP TABLE tmp_expiring_prdkt AS
  SELECT 
      f.cust_id,                              -- 客户编号
      f.prdkt_id,                             -- 当前持有的产品编号
      f.prdkt_name,                           -- 当前持有的产品名称
      f.expr_date,                            -- 到期日期
      f.prdkt_cate_big,                       -- 当前产品大类
      f.risk_lvl AS curr_risk_lvl,            -- 当前产品风险等级
      f.issu_org AS curr_issu_org,            -- 当前产品发行机构
      EXTRACT(DAY FROM (TO_DATE(f.expr_date, 'YYYY-MM-DD') - TO_DATE(V_SYSDAT, 'YYYYMMDD'))) AS days_to_expire
  FROM dwd_acct_fin f                         -- DWD层理财账户信息表
  WHERE f.acct_state = '有效'                 -- 账户状态有效
    AND f.expr_date IS NOT NULL AND f.expr_date != ''
    AND TO_DATE(f.expr_date, 'YYYY-MM-DD') >= TO_DATE(V_SYSDAT, 'YYYYMMDD')
    AND TO_DATE(f.expr_date, 'YYYY-MM-DD') <= TO_DATE(V_SYSDAT, 'YYYYMMDD') + INTERVAL '30 days'
    AND f.fin_amt > 0;                        -- 理财余额大于0

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP3 临时表处理完成，即将到期客户产品数: ' || (SELECT COUNT(*) FROM tmp_expiring_prdkt);
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

  -- 3.4 TMP4: 临时表段 - 获取客户历史购买偏好
  V_NO_ID := 'TMP4';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_cust_hist_pref;
  CREATE TEMP TABLE tmp_cust_hist_pref AS
  SELECT 
      f.cust_id,                              -- 客户编号
      f.prdkt_cate_big,                       -- 产品大类
      f.issu_org,                             -- 发行机构
      COUNT(*) AS purchase_cnt,               -- 购买次数
      ROW_NUMBER() OVER (PARTITION BY f.cust_id ORDER BY COUNT(*) DESC) AS cate_rank,
      ROW_NUMBER() OVER (PARTITION BY f.cust_id ORDER BY COUNT(*) DESC) AS org_rank
  FROM dwd_acct_fin f                         -- DWD层理财账户信息表
  WHERE f.issu_date IS NOT NULL AND f.issu_date != ''
    AND TO_DATE(f.issu_date, 'YYYY-MM-DD') >= TO_DATE(V_SYSDAT, 'YYYYMMDD') - INTERVAL '365 days'
    AND f.acct_state = '有效'
  GROUP BY f.cust_id, f.prdkt_cate_big, f.issu_org;

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP4 临时表处理完成，客户历史购买偏好数: ' || (SELECT COUNT(DISTINCT cust_id) FROM tmp_cust_hist_pref);
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

  -- 3.5 TMP5: 临时表段 - 获取同类产品收益排名（用于收益吸引力评分）
  V_NO_ID := 'TMP5';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_prdkt_return_rank;
  CREATE TEMP TABLE tmp_prdkt_return_rank AS
  SELECT 
      p.prdkt_id,                              -- 产品编号
      p.prdkt_cate_big,                        -- 产品大类
      p.risk_lvl,                              -- 产品风险等级
      p.prdkt_rate,                            -- 产品收益率
      PERCENT_RANK() OVER (PARTITION BY p.prdkt_cate_big, p.risk_lvl ORDER BY p.prdkt_rate DESC) AS return_percent_rank
  FROM tmp_prdkt_pool p;                       -- 在售产品池

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP5 临时表处理完成，产品收益排名数: ' || (SELECT COUNT(*) FROM tmp_prdkt_return_rank);
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

  -- 3.6 TMP6: 临时表段 - 客户基本信息
  V_NO_ID := 'TMP6';
  V_BGN_DATE := NOW();

  DROP TABLE IF EXISTS tmp_cust_info;
  CREATE TEMP TABLE tmp_cust_info AS
  SELECT 
      c.cust_id,                              -- 客户编号
      c.cust_name,                            -- 客户名称
      c.host_cust_mngr_post_id AS post_id,    -- 主办客户经理职位编号
      c.org_lead AS org_id                    -- 归属机构
  FROM dwd_cust_indv_info c                   -- DWD层客户基本信息表
  WHERE c.data_date = V_SYSDAT;               -- 数据日期

  COMMIT;

  V_END_DATE := NOW();
  V_DURA_DATE := EXTRACT(EPOCH FROM (V_END_DATE - V_BGN_DATE))::INTEGER;
  OUTCDE := 0;
  V_LOG_MSG := 'TMP6 临时表处理完成，客户信息数: ' || (SELECT COUNT(*) FROM tmp_cust_info);
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

  -- 3.7 目标表写入 - 客户产品推荐
  V_NO_ID := '2';
  V_BGN_DATE := NOW();

  INSERT INTO ads_cust_prdkt_rcmd (
      data_date,              -- 数据日期
      cust_id,                -- 客户编号
      prdkt_id,               -- 产品编号
      prdkt_name,             -- 产品名称
      rcmd_rank,              -- 推荐排序
      total_score,            -- 总分
      return_score,           -- 收益吸引力得分
      duration_score,         -- 期限匹配度得分
      risk_comfort_score,     -- 风险舒适度得分
      hist_pref_score,        -- 历史偏好得分
      rcmd_reason,            -- 推荐理由
      cust_risk_lvl,          -- 客户风险承受等级
      prdkt_risk_lvl,         -- 产品风险等级
      prdkt_rate,             -- 产品预期收益率
      prdkt_duration,         -- 产品期限(天)
      prdkt_state,            -- 产品状态
      prdkt_cate_big,         -- 产品大类
      issu_org,               -- 发行机构
      bgn_date,               -- 产品开始日期
      end_date,               -- 产品结束日期
      cust_name,              -- 客户名称
      post_id,                -- 管户经理
      org_id                  -- 归属机构
  )
  SELECT 
      V_SYSDAT AS data_date,
      r.cust_id,
      r.prdkt_id,
      r.prdkt_name,
      r.rcmd_rank,
      r.total_score,
      r.return_score,
      r.duration_score,
      r.risk_comfort_score,
      r.hist_pref_score,
      r.rcmd_reason,
      r.cust_risk_lvl,
      r.prdkt_risk_lvl,
      r.prdkt_rate,
      r.prdkt_duration,
      r.prdkt_state,
      r.prdkt_cate_big,
      r.issu_org,
      r.bgn_date,
      r.end_date,
      COALESCE(i.cust_name, '') AS cust_name,
      COALESCE(i.post_id, '') AS post_id,
      COALESCE(i.org_id, '') AS org_id
  FROM (
      SELECT 
          e.cust_id,
          p.prdkt_id,
          p.prdkt_name,
          p.prdkt_state,
          p.prdkt_rate,
          p.duration_days AS prdkt_duration,
          p.prdkt_cate_big,
          p.issu_org,
          p.bgn_date,
          p.end_date,
          p.risk_lvl AS prdkt_risk_lvl,
          COALESCE(cr.risk_lvl, 'C3') AS cust_risk_lvl,
          r.return_score,
          d.duration_score,
          rc.risk_comfort_score,
          h.hist_pref_score,
          r.return_score + d.duration_score + rc.risk_comfort_score + h.hist_pref_score AS total_score,
          CASE 
              WHEN rc.risk_comfort_score > 0 THEN '风险等级符合客户风险承受能力，' ELSE '' END ||
              WHEN d.duration_score >= 20 THEN '期限与客户目标期限较为匹配，' ELSE '' END ||
              WHEN r.return_score >= 25 THEN '在同类产品中收益表现较优，' ELSE '' END ||
              WHEN h.hist_pref_score > 0 THEN '且与客户过往购买偏好较为一致' ELSE '' END AS rcmd_reason,
          ROW_NUMBER() OVER (PARTITION BY e.cust_id ORDER BY 
              (r.return_score + d.duration_score + rc.risk_comfort_score + h.hist_pref_score) DESC,
              d.duration_score DESC,
              r.return_score DESC,
              h.hist_pref_score DESC,
              p.prdkt_id ASC
          ) AS rcmd_rank
      FROM tmp_expiring_prdkt e                    -- 即将到期的客户产品
      CROSS JOIN tmp_prdkt_pool p                  -- 在售产品池
      LEFT JOIN tmp_cust_risk cr                   -- 客户风险评估
          ON e.cust_id = cr.cust_id
      LEFT JOIN tmp_prdkt_return_rank r            -- 产品收益排名
          ON p.prdkt_id = r.prdkt_id
      LEFT JOIN (
          SELECT 
              e.cust_id,
              p.prdkt_id,
              CASE 
                  WHEN ABS(COALESCE(p.duration_days, 0) - e.days_to_expire) <= 7 THEN 30
                  WHEN ABS(COALESCE(p.duration_days, 0) - e.days_to_expire) BETWEEN 8 AND 30 THEN 20
                  WHEN ABS(COALESCE(p.duration_days, 0) - e.days_to_expire) BETWEEN 31 AND 90 THEN 10
                  ELSE 0
              END AS duration_score
          FROM tmp_expiring_prdkt e
          CROSS JOIN tmp_prdkt_pool p
      ) d ON e.cust_id = d.cust_id AND p.prdkt_id = d.prdkt_id
      LEFT JOIN (
          SELECT 
              e.cust_id,
              p.prdkt_id,
              CASE 
                  WHEN p.risk_lvl = COALESCE(cr.risk_lvl, 'C3') THEN 20
                  WHEN SUBSTRING(p.risk_lvl, 2)::INTEGER = SUBSTRING(COALESCE(cr.risk_lvl, 'C3'), 2)::INTEGER - 1 THEN 20
                  WHEN SUBSTRING(p.risk_lvl, 2)::INTEGER = SUBSTRING(COALESCE(cr.risk_lvl, 'C3'), 2)::INTEGER - 2 THEN 15
                  ELSE 8
              END AS risk_comfort_score
          FROM tmp_expiring_prdkt e
          CROSS JOIN tmp_prdkt_pool p
          LEFT JOIN tmp_cust_risk cr ON e.cust_id = cr.cust_id
          WHERE SUBSTRING(p.risk_lvl, 2)::INTEGER <= SUBSTRING(COALESCE(cr.risk_lvl, 'C3'), 2)::INTEGER
      ) rc ON e.cust_id = rc.cust_id AND p.prdkt_id = rc.prdkt_id
      LEFT JOIN (
          SELECT 
              e.cust_id,
              p.prdkt_id,
              COALESCE(d1.score, 0) + COALESCE(d2.score, 0) + COALESCE(d3.score, 0) AS hist_pref_score
          FROM tmp_expiring_prdkt e
          CROSS JOIN tmp_prdkt_pool p
          LEFT JOIN (
              SELECT cust_id, prdkt_cate_big, 8 AS score
              FROM tmp_cust_hist_pref
              WHERE cate_rank = 1
          ) d1 ON e.cust_id = d1.cust_id AND p.prdkt_cate_big = d1.prdkt_cate_big
          LEFT JOIN (
              SELECT cust_id, issu_org, 4 AS score
              FROM tmp_cust_hist_pref
              WHERE org_rank = 1
          ) d2 ON e.cust_id = d2.cust_id AND p.issu_org = d2.issu_org
          LEFT JOIN (
              SELECT DISTINCT f.cust_id, f.prdkt_cate_big, 3 AS score
              FROM dwd_acct_fin f
              WHERE f.issu_date IS NOT NULL AND f.issu_date != ''
                AND TO_DATE(f.issu_date, 'YYYY-MM-DD') >= TO_DATE(V_SYSDAT, 'YYYYMMDD') - INTERVAL '365 days'
          ) d3 ON e.cust_id = d3.cust_id AND p.prdkt_cate_big = d3.prdkt_cate_big
      ) h ON e.cust_id = h.cust_id AND p.prdkt_id = h.prdkt_id
      WHERE SUBSTRING(p.risk_lvl, 2)::INTEGER <= SUBSTRING(COALESCE(cr.risk_lvl, 'C3'), 2)::INTEGER
        AND p.prdkt_state = '在售'
        AND p.prdkt_id != e.prdkt_id
  ) r
  LEFT JOIN tmp_cust_info i ON r.cust_id = i.cust_id
  WHERE r.rcmd_rank <= 3;

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