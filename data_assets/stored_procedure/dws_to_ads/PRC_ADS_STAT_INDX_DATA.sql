CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_data(
  v_sysdat  VARCHAR,     -- 数据日期 (格式: YYYYMMDD)
  outcde    OUT INTEGER  -- 执行结果状态码 (0: 成功, -1: 失败)
)
AS
  V_PRC_DESC     VARCHAR(100) := '指标数据统计';               -- 存储过程描述信息
  V_PRC_NAME     VARCHAR(32)  := 'PRC_ADS_STAT_INDX_DATA'; -- 存储过程名称
  V_LOG_MSG      VARCHAR(4000);                               -- 日志记录文本
  V_NO_ID        VARCHAR(10);                                 -- 当前执行步骤序号
  V_BGN_DATE     DATE;                                        -- 当前步骤开始时间
  V_END_DATE     DATE;                                        -- 当前步骤结束时间
  V_DURA_DATE    INTEGER;                                     -- 当前步骤执行耗时(秒)
  V_MTH_END      VARCHAR(8);                                  -- 月底/上月结日期
  V_QRT_END      VARCHAR(8);                                  -- 季末/上季结日期
  V_YAR_BEGIN    VARCHAR(8);                                  -- 本年初日期
  V_YAR_PREV_END VARCHAR(8);                                  -- 上年末日期
  V_RECUR_MAX    INTEGER      := 20;                          -- 机构层级递归最大深度
BEGIN
  -- 校验输入参数格式
  IF v_sysdat IS NULL OR LENGTH(v_sysdat) <> 8 THEN
    outcde := -1;
    RAISE EXCEPTION 'V_SYSDAT必须为YYYYMMDD格式';
  END IF;

  -- 计算相关日期节点
  V_MTH_END      := sys_fun_deal_date(v_sysdat, 2);
  V_QRT_END      := sys_fun_deal_date(v_sysdat, 3);
  V_YAR_BEGIN    := sys_fun_deal_date(v_sysdat, 13);
  V_YAR_PREV_END := sys_fun_deal_date(v_sysdat, 4);

  ------------------------------------------------------------------
  -- 步骤1：清空临时表及当日历史统计数据
  ------------------------------------------------------------------
  V_NO_ID := '1'; V_BGN_DATE := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_STAT_INDX_SCOPE';       -- 清空指标统计范围临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_STAT_INDX_BAL_AGGR';    -- 清空余额预聚合临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_STAT_INDX_CUST_STATE';  -- 清空客户状态计算临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_STAT_INDX_AGGR_A';      -- 清空营销活动结果聚合临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_STAT_INDX_AGGR_B';      -- 清空目标任务结果聚合临时表
  DELETE FROM ADS_STAT_INDX_DATA a WHERE a.data_date = v_sysdat; -- 删除目标结果表中当日已有数据
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤2：仅建立非客户指标范围。客户号不得进入通用TMP表。
  ------------------------------------------------------------------
  V_NO_ID := '2'; V_BGN_DATE := SYSDATE;
  -- 营销活动路径（PATH_CODE='A'）- 机构及客户经理维度指标范围提取
  INSERT INTO TMP_STAT_INDX_SCOPE
    (path_code, statis_dim, indx_code, data_blng, blng_type, blng_id, term_begin_date, persn_legal_bk_code)
  SELECT DISTINCT 'A',                          -- 路径代码 (A: 营销活动)
         a.mkt_act_id,                          -- 统计维度ID (营销活动ID)
         t.indx_id,                             -- 指标编号
         'ORG_' || ti.mkt_persn_org,            -- 数据归属 (机构编号标识)
         'O',                                   -- 归属类型 (O: 机构)
         ti.mkt_persn_org,                      -- 归属机构ID
         a.act_bgn_date,                        -- 统计期起始日期
         ti.persn_legal_bk_code                 -- 法人行号
    FROM DWD_MKT_ACT_INFO a                     -- 营销活动主表
    INNER JOIN DWD_MKT_ACT_TARGT t              -- 营销活动目标配置表
       ON t.mkt_act_id = a.mkt_act_id
    INNER JOIN DWD_MKT_TSK_INFO ti              -- 营销任务明细表
       ON ti.mkt_act_id = a.mkt_act_id
      AND ti.mkt_persn_org = t.prtspt_org
      AND ti.persn_legal_bk_code = a.persn_legal_bk_code
      AND ti.data_date = v_sysdat
   WHERE a.act_bgn_date <= v_sysdat             -- 活动已开始
     AND NVL(a.statis_stop_date, v_sysdat) >= v_sysdat -- 活动未统计截止
     AND a.camp_act_typ IN ('1', '2')           -- 活动类型过滤
     AND ti.mkt_persn_org IS NOT NULL
  UNION
  SELECT DISTINCT 'A',                          -- 路径代码 (A: 营销活动)
         a.mkt_act_id,                          -- 统计维度ID (营销活动ID)
         t.indx_id,                             -- 指标编号
         'MGR_' || ti.mkt_persn,                -- 数据归属 (客户经理岗位标识)
         'M',                                   -- 归属类型 (M: 客户经理)
         ti.mkt_persn,                          -- 客户经理岗位编号
         a.act_bgn_date,                        -- 统计期起始日期
         ti.persn_legal_bk_code                 -- 法人行号
    FROM DWD_MKT_ACT_INFO a                     -- 营销活动主表
    INNER JOIN DWD_MKT_ACT_TARGT t              -- 营销活动目标配置表
       ON t.mkt_act_id = a.mkt_act_id
    INNER JOIN DWD_MKT_TSK_INFO ti              -- 营销任务明细表
       ON ti.mkt_act_id = a.mkt_act_id
      AND ti.mkt_persn_org = t.prtspt_org
      AND ti.persn_legal_bk_code = a.persn_legal_bk_code
      AND ti.data_date = v_sysdat
   WHERE a.act_bgn_date <= v_sysdat
     AND NVL(a.statis_stop_date, v_sysdat) >= v_sysdat
     AND a.camp_act_typ IN ('1', '2')
     AND ti.mkt_persn IS NOT NULL;

  -- 目标任务路径（PATH_CODE='B'）- 机构及客户经理维度指标范围提取
  INSERT INTO TMP_STAT_INDX_SCOPE
    (path_code, statis_dim, indx_code, data_blng, blng_type, blng_id, term_begin_date, persn_legal_bk_code)
  SELECT DISTINCT 'B',                          -- 路径代码 (B: 目标任务)
         it.tsk_id,                             -- 统计维度ID (任务ID)
         sub.indx_id,                           -- 指标编号
         'ORG_' || it.rsv_obj_id,               -- 数据归属 (机构编号标识)
         'O',                                   -- 归属类型 (O: 机构)
         it.rsv_obj_id,                         -- 接收对象机构ID
         sub.tsk_bgn_date,                      -- 任务起始日期
         it.persn_legal_bk_code                 -- 法人行号
    FROM DWD_MKT_INDX_TSK it                    -- 营销指标任务表
    INNER JOIN DWD_MKT_TSK_INDX_SUB sub         -- 营销任务指标子表
       ON sub.tsk_id = it.tsk_id
      AND sub.persn_legal_bk_code = it.persn_legal_bk_code
   WHERE it.rsv_obj = '0'                       -- 接收对象类型为机构
     AND sub.tsk_bgn_date <= v_sysdat
     AND NVL(sub.tsk_end_date, v_sysdat) >= v_sysdat
  UNION
  SELECT DISTINCT 'B',                          -- 路径代码 (B: 目标任务)
         it.tsk_id,                             -- 统计维度ID (任务ID)
         sub.indx_id,                           -- 指标编号
         'MGR_' || it.rsv_obj_id,               -- 数据归属 (客户经理岗位标识)
         'M',                                   -- 归属类型 (M: 客户经理)
         it.rsv_obj_id,                         -- 接收对象客户经理岗位ID
         sub.tsk_bgn_date,                      -- 任务起始日期
         it.persn_legal_bk_code                 -- 法人行号
    FROM DWD_MKT_INDX_TSK it                    -- 营销指标任务表
    INNER JOIN DWD_MKT_TSK_INDX_SUB sub         -- 营销任务指标子表
       ON sub.tsk_id = it.tsk_id
      AND sub.persn_legal_bk_code = it.persn_legal_bk_code
   WHERE it.rsv_obj = '1'                       -- 接收对象类型为客户经理
     AND sub.tsk_bgn_date <= v_sysdat
     AND NVL(sub.tsk_end_date, v_sysdat) >= v_sysdat;
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤3：冻结增量指标客户范围。金额只冻结成员，状态类附带状态基准。
  ------------------------------------------------------------------
  V_NO_ID := '3'; V_BGN_DATE := SYSDATE;
  -- 冻结客户级基准明细数据
  INSERT INTO ADS_STAT_INDX_BASELINE_DTL
    (statis_calib, statis_dim, indx_code, data_blng, cust_id, persn_legal_bk_code,
     base_data_date, base_run_date, base_cust_lvl, base_mth_avg_aum)
  WITH scope_member AS (
    -- 营销活动关联客户
    SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng, s.term_begin_date,
           ti.cust_id, s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
      INNER JOIN DWD_MKT_TSK_INFO ti ON s.path_code = 'A'
       AND ti.mkt_act_id = s.statis_dim AND ti.persn_legal_bk_code = s.persn_legal_bk_code
       AND ti.data_date = v_sysdat
       AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
         OR (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
     WHERE s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')
    UNION
    -- 目标任务机构下辖客户
    SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng, s.term_begin_date,
           lv.cust_id, s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
      INNER JOIN DWS_CUST_LVL_INFO lv ON s.path_code = 'B' AND s.blng_type = 'O'
       AND lv.org_id = s.blng_id AND lv.persn_legal_bk_code = s.persn_legal_bk_code
       AND lv.data_date = v_sysdat
     WHERE s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')
    UNION
    -- 目标任务客户经理管理客户
    SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng, s.term_begin_date,
           cm.cust_id, s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
      INNER JOIN DWD_CUST_MAN cm ON s.path_code = 'B' AND s.blng_type = 'M'
       AND cm.mngr_post_id = s.blng_id AND cm.mng_typ = '1'
       AND cm.persn_legal_bk_code = s.persn_legal_bk_code
     WHERE s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')
  )
  SELECT CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END, -- 统计口径
         sm.statis_dim,                                                    -- 统计维度ID
         sm.indx_code,                                                     -- 指标编号
         sm.data_blng,                                                     -- 数据归属
         sm.cust_id,                                                       -- 客户编号
         sm.persn_legal_bk_code,                                           -- 法人行号
         TO_CHAR(TO_DATE(sm.term_begin_date, 'YYYYMMDD') - 1, 'YYYYMMDD'), -- 基准数据日期 (期初前一天)
         v_sysdat,                                                         -- 冻结执行日期
         CASE WHEN sm.indx_code IN ('INDX_0052','INDX_0053','INDX_0054') THEN lv.cust_lvl END, -- 期初客户等级
         CASE WHEN sm.indx_code = 'INDX_0063' THEN NVL(b.aum_bal, 0) END                        -- 期初月日均AUM
    FROM scope_member sm
    LEFT JOIN DWS_CUST_LVL_INFO lv ON lv.cust_id = sm.cust_id
      AND lv.persn_legal_bk_code = sm.persn_legal_bk_code
      AND lv.data_date = TO_CHAR(TO_DATE(sm.term_begin_date, 'YYYYMMDD') - 1, 'YYYYMMDD')
    LEFT JOIN DWS_CUST_ASSE_LIAB b ON b.cust_id = sm.cust_id
      AND b.persn_legal_bk_code = sm.persn_legal_bk_code
      AND b.data_date = TO_CHAR(TO_DATE(sm.term_begin_date, 'YYYYMMDD') - 1, 'YYYYMMDD')
      AND b.bal_type = '2'                                                 -- 2: 月日均
   WHERE (sm.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)
     AND NOT EXISTS (
       SELECT 1 FROM ADS_STAT_INDX_BASELINE_DTL x
        WHERE x.statis_calib = CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
          AND x.statis_dim = sm.statis_dim AND x.indx_code = sm.indx_code
          AND x.data_blng = sm.data_blng AND x.cust_id = sm.cust_id
          AND x.persn_legal_bk_code = sm.persn_legal_bk_code);

  -- 汇总生成维度级基准金额汇总表
  INSERT INTO ADS_STAT_INDX_BASELINE_SUM
    (statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code,
     base_data_date, base_run_date, base_loan_bal, base_yr_avg_fin, base_mth_avg_fin,
     base_yr_avg_agen_fin, base_mth_avg_agen_fin)
  SELECT d.statis_calib, d.statis_dim, d.indx_code, d.data_blng, d.persn_legal_bk_code,
         MAX(d.base_data_date),                                            -- 期初基准数据日期
         v_sysdat,                                                         -- 冻结执行日期
         SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END),              -- 基准贷款时点余额
         SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END),              -- 基准理财年日均
         SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END),              -- 基准理财月日均
         SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END), -- 基准代销理财年日均
         SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END)  -- 基准代销理财月日均
    FROM ADS_STAT_INDX_BASELINE_DTL d
    LEFT JOIN DWS_CUST_ASSE_LIAB b ON b.cust_id = d.cust_id
      AND b.persn_legal_bk_code = d.persn_legal_bk_code
      AND b.data_date = d.base_data_date
   WHERE d.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
     AND NOT EXISTS (SELECT 1 FROM ADS_STAT_INDX_BASELINE_SUM x
       WHERE x.statis_calib = d.statis_calib AND x.statis_dim = d.statis_dim
         AND x.indx_code = d.indx_code AND x.data_blng = d.data_blng
         AND x.persn_legal_bk_code = d.persn_legal_bk_code)
   GROUP BY d.statis_calib, d.statis_dim, d.indx_code, d.data_blng, d.persn_legal_bk_code;
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤4：0046~0051余额类一次按最终粒度预聚合，不落客户级余额TMP。
  ------------------------------------------------------------------
  V_NO_ID := '4'; V_BGN_DATE := SYSDATE;
  -- 聚合计算各时间节点AUM余额
  INSERT INTO TMP_STAT_INDX_BAL_AGGR
    (path_code, statis_dim, data_blng, persn_legal_bk_code, curnt_aum, yr_begin_aum,
     mth_end_aum, qrt_end_aum, curnt_yr_avg_aum, prev_yr_avg_aum, curnt_mth_avg_aum, prev_mth_avg_aum)
  WITH base_scope AS (
    SELECT DISTINCT path_code, statis_dim, data_blng, blng_type, blng_id, persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE
     WHERE indx_code IN ('INDX_0046','INDX_0047','INDX_0048','INDX_0049','INDX_0050','INDX_0051')
  ), scope_member AS (
    SELECT s.path_code, s.statis_dim, s.data_blng, ti.cust_id, s.persn_legal_bk_code
      FROM base_scope s INNER JOIN DWD_MKT_TSK_INFO ti ON s.path_code = 'A'
       AND ti.mkt_act_id = s.statis_dim AND ti.persn_legal_bk_code = s.persn_legal_bk_code AND ti.data_date = v_sysdat
       AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) OR (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
    UNION
    SELECT s.path_code, s.statis_dim, s.data_blng, lv.cust_id, s.persn_legal_bk_code
      FROM base_scope s INNER JOIN DWS_CUST_LVL_INFO lv ON s.path_code = 'B' AND s.blng_type = 'O'
       AND lv.org_id = s.blng_id AND lv.persn_legal_bk_code = s.persn_legal_bk_code AND lv.data_date = v_sysdat
    UNION
    SELECT s.path_code, s.statis_dim, s.data_blng, cm.cust_id, s.persn_legal_bk_code
      FROM base_scope s INNER JOIN DWD_CUST_MAN cm ON s.path_code = 'B' AND s.blng_type = 'M'
       AND cm.mngr_post_id = s.blng_id AND cm.mng_typ = '1' AND cm.persn_legal_bk_code = s.persn_legal_bk_code
  )
  SELECT sm.path_code, sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code,
         SUM(CASE WHEN b.data_date = v_sysdat        AND b.bal_type = '1' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 当前AUM时点余额
         SUM(CASE WHEN b.data_date = V_YAR_BEGIN     AND b.bal_type = '1' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 年初AUM时点余额
         SUM(CASE WHEN b.data_date = V_MTH_END       AND b.bal_type = '1' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 上月结AUM时点余额
         SUM(CASE WHEN b.data_date = V_QRT_END       AND b.bal_type = '1' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 上季结AUM时点余额
         SUM(CASE WHEN b.data_date = v_sysdat        AND b.bal_type = '4' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 当年AUM年日均
         SUM(CASE WHEN b.data_date = V_YAR_PREV_END AND b.bal_type = '4' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 上年AUM年日均
         SUM(CASE WHEN b.data_date = v_sysdat        AND b.bal_type = '2' THEN NVL(b.aum_bal,0) ELSE 0 END), -- 当月AUM月日均
         SUM(CASE WHEN b.data_date = V_MTH_END       AND b.bal_type = '2' THEN NVL(b.aum_bal,0) ELSE 0 END)  -- 上月AUM月日均
    FROM scope_member sm
    LEFT JOIN DWS_CUST_ASSE_LIAB b ON b.cust_id = sm.cust_id AND b.persn_legal_bk_code = sm.persn_legal_bk_code
      AND b.data_date IN (v_sysdat, V_YAR_BEGIN, V_MTH_END, V_QRT_END, V_YAR_PREV_END)
   GROUP BY sm.path_code, sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code;
  COMMIT;

  -- 标准期间金额指标：按配置指标写入，避免未配置指标产出。
  -- 营销活动路径(A)标准AUM增量指标写入
  INSERT INTO TMP_STAT_INDX_AGGR_A
  SELECT v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,
         CASE s.indx_code 
           WHEN 'INDX_0046' THEN b.curnt_aum - b.yr_begin_aum       -- INDX_0046: 相比年初AUM增量
           WHEN 'INDX_0048' THEN b.curnt_aum - b.mth_end_aum        -- INDX_0048: 相比上月结AUM增量
           WHEN 'INDX_0049' THEN b.curnt_aum - b.qrt_end_aum        -- INDX_0049: 相比上季结AUM增量
           WHEN 'INDX_0050' THEN b.curnt_yr_avg_aum - b.prev_yr_avg_aum -- INDX_0050: 相比上年年日均AUM增量
           WHEN 'INDX_0051' THEN b.curnt_mth_avg_aum - b.prev_mth_avg_aum -- INDX_0051: 相比上月月日均AUM增量
         END,
         CASE s.indx_code 
           WHEN 'INDX_0046' THEN b.yr_begin_aum 
           WHEN 'INDX_0048' THEN b.mth_end_aum
           WHEN 'INDX_0049' THEN b.qrt_end_aum 
           WHEN 'INDX_0050' THEN b.prev_yr_avg_aum 
           WHEN 'INDX_0051' THEN b.prev_mth_avg_aum 
         END,
         s.persn_legal_bk_code
    FROM TMP_STAT_INDX_SCOPE s INNER JOIN TMP_STAT_INDX_BAL_AGGR b ON b.path_code = 'A' AND b.statis_dim=s.statis_dim
      AND b.data_blng=s.data_blng AND b.persn_legal_bk_code=s.persn_legal_bk_code
   WHERE s.path_code='A' AND s.indx_code IN ('INDX_0046','INDX_0048','INDX_0049','INDX_0050','INDX_0051');

  -- 目标任务路径(B)标准AUM增量指标写入
  INSERT INTO TMP_STAT_INDX_AGGR_B
  SELECT v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,
         CASE s.indx_code 
           WHEN 'INDX_0046' THEN b.curnt_aum - b.yr_begin_aum 
           WHEN 'INDX_0048' THEN b.curnt_aum - b.mth_end_aum
           WHEN 'INDX_0049' THEN b.curnt_aum - b.qrt_end_aum 
           WHEN 'INDX_0050' THEN b.curnt_yr_avg_aum - b.prev_yr_avg_aum
           WHEN 'INDX_0051' THEN b.curnt_mth_avg_aum - b.prev_mth_avg_aum 
         END,
         CASE s.indx_code 
           WHEN 'INDX_0046' THEN b.yr_begin_aum 
           WHEN 'INDX_0048' THEN b.mth_end_aum
           WHEN 'INDX_0049' THEN b.qrt_end_aum 
           WHEN 'INDX_0050' THEN b.prev_yr_avg_aum 
           WHEN 'INDX_0051' THEN b.prev_mth_avg_aum 
         END,
         s.persn_legal_bk_code
   FROM TMP_STAT_INDX_SCOPE s INNER JOIN TMP_STAT_INDX_BAL_AGGR b ON b.path_code = 'B' AND b.statis_dim=s.statis_dim
      AND b.data_blng=s.data_blng AND b.persn_legal_bk_code=s.persn_legal_bk_code
   WHERE s.path_code='B' AND s.indx_code IN ('INDX_0046','INDX_0048','INDX_0049','INDX_0050','INDX_0051');

  -- INDX_0047基数计算：机构行汇总本机构全部客户经理基数，经理行仅汇总本经理基数。
  INSERT INTO TMP_STAT_INDX_AGGR_A
  SELECT v_sysdat,s.data_blng,s.statis_dim,'营销活动','INDX_0047',
         b.curnt_aum - SUM(NVL(v.value_init,0)),                          -- 增量 (当前余额 - 初始基数)
         SUM(NVL(v.value_init,0)),                                        -- 期初/初始基数
         s.persn_legal_bk_code
    FROM TMP_STAT_INDX_SCOPE s
    INNER JOIN TMP_STAT_INDX_BAL_AGGR b ON b.path_code='A' AND b.statis_dim=s.statis_dim AND b.data_blng=s.data_blng AND b.persn_legal_bk_code=s.persn_legal_bk_code
    LEFT JOIN crm_sys_post p ON s.blng_type='M' AND p.post_id=s.blng_id AND p.job_cls='C'
    LEFT JOIN DEPO_VALUE_INIT v ON v.org_id=CASE WHEN s.blng_type='O' THEN s.blng_id ELSE p.org_id END
      AND v.persn_legal_bk_code=s.persn_legal_bk_code AND (s.blng_type='O' OR v.mngr_post_id=s.blng_id)
   WHERE s.path_code='A' AND s.indx_code='INDX_0047'
   GROUP BY s.data_blng,s.statis_dim,b.curnt_aum,s.persn_legal_bk_code;

  INSERT INTO TMP_STAT_INDX_AGGR_B
  SELECT v_sysdat,s.data_blng,s.statis_dim,'目标任务','INDX_0047',
         b.curnt_aum - SUM(NVL(v.value_init,0)),
         SUM(NVL(v.value_init,0)),
         s.persn_legal_bk_code
    FROM TMP_STAT_INDX_SCOPE s
    INNER JOIN TMP_STAT_INDX_BAL_AGGR b ON b.path_code='B' AND b.statis_dim=s.statis_dim AND b.data_blng=s.data_blng AND b.persn_legal_bk_code=s.persn_legal_bk_code
    LEFT JOIN crm_sys_post p ON s.blng_type='M' AND p.post_id=s.blng_id AND p.job_cls='C'
    LEFT JOIN DEPO_VALUE_INIT v ON v.org_id=CASE WHEN s.blng_type='O' THEN s.blng_id ELSE p.org_id END
      AND v.persn_legal_bk_code=s.persn_legal_bk_code AND (s.blng_type='O' OR v.mngr_post_id=s.blng_id)
   WHERE s.path_code='B' AND s.indx_code='INDX_0047'
   GROUP BY s.data_blng,s.statis_dim,b.curnt_aum,s.persn_legal_bk_code;
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤5：冻结范围金额增量。当前金额直接聚合，基准金额只取BASELINE_SUM。
  ------------------------------------------------------------------
  V_NO_ID := '5'; V_BGN_DATE := SYSDATE;
  -- 营销活动路径(A)专有金融产品余额及日均增量指标计算
  INSERT INTO TMP_STAT_INDX_AGGR_A
  SELECT v_sysdat, d.data_blng, d.statis_dim, '营销活动', d.indx_code,
         CASE d.indx_code 
           WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type='4' THEN NVL(b.fin_bal,0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)                           -- INDX_0055: 理财年日均增量
           WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type='2' THEN NVL(b.fin_bal,0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)                          -- INDX_0056: 理财月日均增量
           WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type='4' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)  -- INDX_0058: 代销理财年日均增量
           WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type='2' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin) -- INDX_0059: 代销理财月日均增量
           WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type='1' THEN NVL(b.loan_bal,0) ELSE 0 END) - MAX(bs.base_loan_bal)                            -- INDX_0062: 贷款余额增量
         END,
         CASE d.indx_code 
           WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin) 
           WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)
           WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin) 
           WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin) 
           WHEN 'INDX_0062' THEN MAX(bs.base_loan_bal) 
         END,
         d.persn_legal_bk_code
    FROM ADS_STAT_INDX_BASELINE_DTL d
    INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs ON bs.statis_calib=d.statis_calib AND bs.statis_dim=d.statis_dim
      AND bs.indx_code=d.indx_code AND bs.data_blng=d.data_blng AND bs.persn_legal_bk_code=d.persn_legal_bk_code
    LEFT JOIN DWS_CUST_ASSE_LIAB b ON b.cust_id=d.cust_id AND b.persn_legal_bk_code=d.persn_legal_bk_code AND b.data_date=v_sysdat
   WHERE d.statis_calib='营销活动' AND d.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
   GROUP BY d.data_blng,d.statis_dim,d.indx_code,d.persn_legal_bk_code;

  -- 目标任务路径(B)专有金融产品余额及日均增量指标计算
  INSERT INTO TMP_STAT_INDX_AGGR_B
  SELECT v_sysdat, d.data_blng, d.statis_dim, '目标任务', d.indx_code,
         CASE d.indx_code 
           WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type='4' THEN NVL(b.fin_bal,0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)
           WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type='2' THEN NVL(b.fin_bal,0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)
           WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type='4' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)
           WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type='2' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin)
           WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type='1' THEN NVL(b.loan_bal,0) ELSE 0 END) - MAX(bs.base_loan_bal)
         END,
         CASE d.indx_code 
           WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin) 
           WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)
           WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin) 
           WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin) 
           WHEN 'INDX_0062' THEN MAX(bs.base_loan_bal) 
         END,
         d.persn_legal_bk_code
    FROM ADS_STAT_INDX_BASELINE_DTL d
    INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs ON bs.statis_calib=d.statis_calib AND bs.statis_dim=d.statis_dim
      AND bs.indx_code=d.indx_code AND bs.data_blng=d.data_blng AND bs.persn_legal_bk_code=d.persn_legal_bk_code
    LEFT JOIN DWS_CUST_ASSE_LIAB b ON b.cust_id=d.cust_id AND b.persn_legal_bk_code=d.persn_legal_bk_code AND b.data_date=v_sysdat
   WHERE d.statis_calib='目标任务' AND d.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
   GROUP BY d.data_blng,d.statis_dim,d.indx_code,d.persn_legal_bk_code;
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤6：仅客户状态指标保留客户级短生命周期结果。
  ------------------------------------------------------------------
  V_NO_ID := '6'; V_BGN_DATE := SYSDATE;
  -- 提取客户最新等级与AUM状态
  INSERT INTO TMP_STAT_INDX_CUST_STATE
    (path_code, statis_dim, indx_code, data_blng, cust_id, persn_legal_bk_code, base_cust_lvl, curnt_cust_lvl, base_mth_avg_aum, curnt_mth_avg_aum)
  SELECT CASE WHEN d.statis_calib='营销活动' THEN 'A' ELSE 'B' END, 
         d.statis_dim, 
         d.indx_code, 
         d.data_blng, 
         d.cust_id,
         d.persn_legal_bk_code, 
         d.base_cust_lvl,          -- 期初客户等级
         lv.cust_lvl,              -- 当前客户等级
         d.base_mth_avg_aum,       -- 期初月日均AUM
         NVL(b.aum_bal,0)          -- 当前月日均AUM
    FROM ADS_STAT_INDX_BASELINE_DTL d
    LEFT JOIN DWS_CUST_LVL_INFO lv ON lv.cust_id=d.cust_id AND lv.persn_legal_bk_code=d.persn_legal_bk_code AND lv.data_date=v_sysdat
    LEFT JOIN DWS_CUST_ASSE_LIAB b ON b.cust_id=d.cust_id AND b.persn_legal_bk_code=d.persn_legal_bk_code AND b.data_date=v_sysdat AND b.bal_type='2'
   WHERE d.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063');

  -- 营销活动路径(A)客户等级提升及临界客户提升户数计算
  INSERT INTO TMP_STAT_INDX_AGGR_A
  SELECT v_sysdat, c.data_blng, c.statis_dim, '营销活动', c.indx_code,
         CASE c.indx_code 
           WHEN 'INDX_0052' THEN SUM(CASE WHEN TO_NUMBER(NVL(c.base_cust_lvl,'0')) < 4 AND TO_NUMBER(NVL(c.curnt_cust_lvl,'0')) >= 4 THEN 1 ELSE 0 END) -- INDX_0052: 升级至黄金及以上户数
           WHEN 'INDX_0053' THEN SUM(CASE WHEN TO_NUMBER(NVL(c.base_cust_lvl,'0')) < 6 AND TO_NUMBER(NVL(c.curnt_cust_lvl,'0')) >= 6 THEN 1 ELSE 0 END) -- INDX_0053: 升级至白金及以上户数
           WHEN 'INDX_0054' THEN SUM(CASE WHEN TO_NUMBER(NVL(c.base_cust_lvl,'0')) < 7 AND TO_NUMBER(NVL(c.curnt_cust_lvl,'0')) >= 7 THEN 1 ELSE 0 END) -- INDX_0054: 升级至钻石及以上户数
           WHEN 'INDX_0063' THEN SUM(CASE WHEN (c.curnt_mth_avg_aum>=45000 AND c.curnt_mth_avg_aum<50000) OR (c.curnt_mth_avg_aum>=270000 AND c.curnt_mth_avg_aum<300000) OR (c.curnt_mth_avg_aum>=450000 AND c.curnt_mth_avg_aum<500000) OR (c.curnt_mth_avg_aum>=900000 AND c.curnt_mth_avg_aum<1000000) OR (c.curnt_mth_avg_aum>=2700000 AND c.curnt_mth_avg_aum<3000000) THEN 1 ELSE 0 END)
                               - SUM(CASE WHEN (c.base_mth_avg_aum>=45000 AND c.base_mth_avg_aum<50000) OR (c.base_mth_avg_aum>=270000 AND c.base_mth_avg_aum<300000) OR (c.base_mth_avg_aum>=450000 AND c.base_mth_avg_aum<500000) OR (c.base_mth_avg_aum>=900000 AND c.base_mth_avg_aum<1000000) OR (c.base_mth_avg_aum>=2700000 AND c.base_mth_avg_aum<3000000) THEN 1 ELSE 0 END) -- INDX_0063: 临界提升客户户数增量
         END,
         CASE WHEN c.indx_code='INDX_0063' THEN SUM(CASE WHEN (c.base_mth_avg_aum>=45000 AND c.base_mth_avg_aum<50000) OR (c.base_mth_avg_aum>=270000 AND c.base_mth_avg_aum<300000) OR (c.base_mth_avg_aum>=450000 AND c.base_mth_avg_aum<500000) OR (c.base_mth_avg_aum>=900000 AND c.base_mth_avg_aum<1000000) OR (c.base_mth_avg_aum>=2700000 AND c.base_mth_avg_aum<3000000) THEN 1 ELSE 0 END) ELSE 0 END,
         c.persn_legal_bk_code
    FROM TMP_STAT_INDX_CUST_STATE c WHERE c.path_code='A'
   GROUP BY c.data_blng,c.statis_dim,c.indx_code,c.persn_legal_bk_code;

  -- 目标任务路径(B)客户等级提升及临界客户提升户数计算
  INSERT INTO TMP_STAT_INDX_AGGR_B
  SELECT v_sysdat, c.data_blng, c.statis_dim, '目标任务', c.indx_code,
         CASE c.indx_code 
           WHEN 'INDX_0052' THEN SUM(CASE WHEN TO_NUMBER(NVL(c.base_cust_lvl,'0')) < 4 AND TO_NUMBER(NVL(c.curnt_cust_lvl,'0')) >= 4 THEN 1 ELSE 0 END)
           WHEN 'INDX_0053' THEN SUM(CASE WHEN TO_NUMBER(NVL(c.base_cust_lvl,'0')) < 6 AND TO_NUMBER(NVL(c.curnt_cust_lvl,'0')) >= 6 THEN 1 ELSE 0 END)
           WHEN 'INDX_0054' THEN SUM(CASE WHEN TO_NUMBER(NVL(c.base_cust_lvl,'0')) < 7 AND TO_NUMBER(NVL(c.curnt_cust_lvl,'0')) >= 7 THEN 1 ELSE 0 END)
           WHEN 'INDX_0063' THEN SUM(CASE WHEN (c.curnt_mth_avg_aum>=45000 AND c.curnt_mth_avg_aum<50000) OR (c.curnt_mth_avg_aum>=270000 AND c.curnt_mth_avg_aum<300000) OR (c.curnt_mth_avg_aum>=450000 AND c.curnt_mth_avg_aum<500000) OR (c.curnt_mth_avg_aum>=900000 AND c.curnt_mth_avg_aum<1000000) OR (c.curnt_mth_avg_aum>=2700000 AND c.curnt_mth_avg_aum<3000000) THEN 1 ELSE 0 END)
                               - SUM(CASE WHEN (c.base_mth_avg_aum>=45000 AND c.base_mth_avg_aum<50000) OR (c.base_mth_avg_aum>=270000 AND c.base_mth_avg_aum<300000) OR (c.base_mth_avg_aum>=450000 AND c.base_mth_avg_aum<500000) OR (c.base_mth_avg_aum>=900000 AND c.base_mth_avg_aum<1000000) OR (c.base_mth_avg_aum>=2700000 AND c.base_mth_avg_aum<3000000) THEN 1 ELSE 0 END)
         END,
         CASE WHEN c.indx_code='INDX_0063' THEN SUM(CASE WHEN (c.base_mth_avg_aum>=45000 AND c.base_mth_avg_aum<50000) OR (c.base_mth_avg_aum>=270000 AND c.base_mth_avg_aum<300000) OR (c.base_mth_avg_aum>=450000 AND c.base_mth_avg_aum<500000) OR (c.base_mth_avg_aum>=900000 AND c.base_mth_avg_aum<1000000) OR (c.base_mth_avg_aum>=2700000 AND c.base_mth_avg_aum<3000000) THEN 1 ELSE 0 END) ELSE 0 END,
         c.persn_legal_bk_code
   FROM TMP_STAT_INDX_CUST_STATE c WHERE c.path_code='B'
   GROUP BY c.data_blng,c.statis_dim,c.indx_code,c.persn_legal_bk_code;
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤6B：事件/去重计数在源关联内完成，不生成客户级TMP。
  ------------------------------------------------------------------
  -- INDX_0061: 新增保险保费统计
  INSERT INTO TMP_STAT_INDX_AGGR_A
  WITH scope_member AS (
    SELECT s.statis_dim, s.data_blng, s.term_begin_date, ti.cust_id, s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
      INNER JOIN DWD_MKT_TSK_INFO ti ON ti.mkt_act_id=s.statis_dim
       AND ti.persn_legal_bk_code=s.persn_legal_bk_code AND ti.data_date=v_sysdat
       AND ((s.blng_type='O' AND ti.mkt_persn_org=s.blng_id) OR (s.blng_type='M' AND ti.mkt_persn=s.blng_id))
     WHERE s.path_code='A' AND s.indx_code='INDX_0061'
  )
  SELECT v_sysdat, sm.data_blng, sm.statis_dim, '营销活动', 'INDX_0061', 
         SUM(NVL(i.new_insur_amt,0)),                                       -- 新增保费金额总计
         0, 
         sm.persn_legal_bk_code
    FROM (SELECT DISTINCT statis_dim,data_blng,term_begin_date,cust_id,persn_legal_bk_code FROM scope_member) sm
    INNER JOIN DWD_ACCT_INSUR i ON i.cust_id=sm.cust_id AND i.persn_legal_bk_code=sm.persn_legal_bk_code
      AND i.policy_state='1' AND i.tx_date>=sm.term_begin_date AND i.tx_date<=v_sysdat
   GROUP BY sm.data_blng,sm.statis_dim,sm.persn_legal_bk_code;

  INSERT INTO TMP_STAT_INDX_AGGR_B
  WITH scope_member AS (
    SELECT s.statis_dim,s.data_blng,s.term_begin_date,lv.cust_id,s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s INNER JOIN DWS_CUST_LVL_INFO lv ON s.blng_type='O'
       AND lv.org_id=s.blng_id AND lv.persn_legal_bk_code=s.persn_legal_bk_code AND lv.data_date=v_sysdat
     WHERE s.path_code='B' AND s.indx_code='INDX_0061'
    UNION
    SELECT s.statis_dim,s.data_blng,s.term_begin_date,cm.cust_id,s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s INNER JOIN DWD_CUST_MAN cm ON s.blng_type='M'
       AND cm.mngr_post_id=s.blng_id AND cm.mng_typ='1' AND cm.persn_legal_bk_code=s.persn_legal_bk_code
     WHERE s.path_code='B' AND s.indx_code='INDX_0061'
  )
  SELECT v_sysdat,sm.data_blng,sm.statis_dim,'目标任务','INDX_0061',
         SUM(NVL(i.new_insur_amt,0)),
         0,
         sm.persn_legal_bk_code
    FROM (SELECT DISTINCT statis_dim,data_blng,term_begin_date,cust_id,persn_legal_bk_code FROM scope_member) sm
    INNER JOIN DWD_ACCT_INSUR i ON i.cust_id=sm.cust_id AND i.persn_legal_bk_code=sm.persn_legal_bk_code
      AND i.policy_state='1' AND i.tx_date>=sm.term_begin_date AND i.tx_date<=v_sysdat
   GROUP BY sm.data_blng,sm.statis_dim,sm.persn_legal_bk_code;

  -- INDX_0067: 手机银行月度登录活跃客户数统计 (基于 crmdm.mbk_cust_info 及登录日志)
  INSERT INTO TMP_STAT_INDX_AGGR_A
  WITH scope_member AS (
    SELECT s.statis_dim,s.data_blng,ti.cust_id,s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s INNER JOIN DWD_MKT_TSK_INFO ti ON ti.mkt_act_id=s.statis_dim
       AND ti.persn_legal_bk_code=s.persn_legal_bk_code AND ti.data_date=v_sysdat
       AND ((s.blng_type='O' AND ti.mkt_persn_org=s.blng_id) OR (s.blng_type='M' AND ti.mkt_persn=s.blng_id))
     WHERE s.path_code='A' AND s.indx_code='INDX_0067'
  )
  SELECT v_sysdat,sm.data_blng,sm.statis_dim,'营销活动','INDX_0067',
         COUNT(DISTINCT mi.cust_core_no),                                    -- 核心客户号去重计数 (活跃月活客户数)
         0,
         sm.persn_legal_bk_code
    FROM scope_member sm 
    INNER JOIN mbk_cust_info mi ON mi.cust_core_no=sm.cust_id AND mi.cust_status='1' -- 过滤正常状态手机银行客户 (0:注销 1:正常 ...)
    INNER JOIN mbk_cust_log_login l ON l.cust_no=mi.cust_no AND l.lgn_status='1'      -- 关联成功登录日志
   WHERE SUBSTR(l.lgn_date,1,7)=SUBSTR(v_sysdat,1,4)||'-'||SUBSTR(v_sysdat,5,2)       -- 匹配当月登录记录 (YYYY-MM)
   GROUP BY sm.data_blng,sm.statis_dim,sm.persn_legal_bk_code;

  INSERT INTO TMP_STAT_INDX_AGGR_B
  WITH scope_member AS (
    SELECT s.statis_dim,s.data_blng,lv.cust_id,s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s INNER JOIN DWS_CUST_LVL_INFO lv ON s.blng_type='O'
       AND lv.org_id=s.blng_id AND lv.persn_legal_bk_code=s.persn_legal_bk_code AND lv.data_date=v_sysdat
     WHERE s.path_code='B' AND s.indx_code='INDX_0067'
    UNION
    SELECT s.statis_dim,s.data_blng,cm.cust_id,s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s INNER JOIN DWD_CUST_MAN cm ON s.blng_type='M'
       AND cm.mngr_post_id=s.blng_id AND cm.mng_typ='1' AND cm.persn_legal_bk_code=s.persn_legal_bk_code
     WHERE s.path_code='B' AND s.indx_code='INDX_0067'
  )
  SELECT v_sysdat,sm.data_blng,sm.statis_dim,'目标任务','INDX_0067',
         COUNT(DISTINCT mi.cust_core_no),
         0,
         sm.persn_legal_bk_code
    FROM scope_member sm 
    INNER JOIN mbk_cust_info mi ON mi.cust_core_no=sm.cust_id AND mi.cust_status='1'
    INNER JOIN mbk_cust_log_login l ON l.cust_no=mi.cust_no AND l.lgn_status='1'
   WHERE SUBSTR(l.lgn_date,1,7)=SUBSTR(v_sysdat,1,4)||'-'||SUBSTR(v_sysdat,5,2)
   GROUP BY sm.data_blng,sm.statis_dim,sm.persn_legal_bk_code;
  COMMIT;

  ------------------------------------------------------------------
  -- 步骤7：最后才递归上卷机构，确保底层结果完整汇总到上级。
  ------------------------------------------------------------------
  V_NO_ID := '7'; V_BGN_DATE := SYSDATE;
  -- 递归汇总机构树并写入最终目标表 ADS_STAT_INDX_DATA
  INSERT INTO ADS_STAT_INDX_DATA (indx_code,data_blng,statis_dim,statis_calib,curnt_val,term_last_val,data_date,persn_legal_bk_code)
  WITH RECURSIVE direct_aggr AS (
    -- 汇总营销活动与目标任务的直接聚合结果
    SELECT data_date,data_blng,statis_dim,statis_calib,indx_code,curnt_val,term_last_val,persn_legal_bk_code FROM TMP_STAT_INDX_AGGR_A
    UNION ALL
    SELECT data_date,data_blng,statis_dim,statis_calib,indx_code,curnt_val,term_last_val,persn_legal_bk_code FROM TMP_STAT_INDX_AGGR_B
  ), org_hier AS (
    -- 机构层级递归展开 (向下向上关联机构树 DWD_SYS_ORG)
    SELECT a.data_date, REPLACE(a.data_blng,'ORG_','') AS org_id, a.statis_dim,a.statis_calib,a.indx_code,a.curnt_val,a.term_last_val,a.persn_legal_bk_code,1 AS hier_lvl,'|'||REPLACE(a.data_blng,'ORG_','')||'|' AS org_path
      FROM direct_aggr a WHERE a.data_blng LIKE 'ORG_%'
    UNION ALL
    SELECT h.data_date,o.sup_org_id,h.statis_dim,h.statis_calib,h.indx_code,h.curnt_val,h.term_last_val,h.persn_legal_bk_code,h.hier_lvl+1,h.org_path||o.sup_org_id||'|'
      FROM org_hier h INNER JOIN DWD_SYS_ORG o ON o.org_id=h.org_id
     WHERE o.sup_org_id IS NOT NULL AND h.hier_lvl<V_RECUR_MAX AND POSITION('|'||o.sup_org_id||'|' IN h.org_path)=0
  ), org_aggr AS (
    -- 机构层级上卷积累求和
    SELECT 'ORG_'||org_id AS data_blng,statis_dim,statis_calib,indx_code,
           SUM(curnt_val)     AS curnt_val,                                 -- 上卷当前统计值
           SUM(term_last_val) AS term_last_val,                             -- 上卷基准/上期统计值
           data_date,
           persn_legal_bk_code
      FROM org_hier GROUP BY org_id,statis_dim,statis_calib,indx_code,data_date,persn_legal_bk_code
  )
  SELECT indx_code,data_blng,statis_dim,statis_calib,curnt_val,term_last_val,data_date,persn_legal_bk_code FROM org_aggr
  UNION ALL
  SELECT indx_code,data_blng,statis_dim,statis_calib,curnt_val,term_last_val,data_date,persn_legal_bk_code FROM direct_aggr WHERE data_blng NOT LIKE 'ORG_%';
  COMMIT;

  outcde := 0;
  V_END_DATE := SYSDATE; V_DURA_DATE := TRUNC((V_END_DATE-V_BGN_DATE)*24*60*60);
  V_LOG_MSG := '客户维度分层重构完成：仅0052~0054、0063使用客户级短生命周期计算';
  SYS_PRC_STEP_LOGS(v_sysdat,V_PRC_NAME,V_PRC_DESC,V_NO_ID,V_BGN_DATE,V_END_DATE,V_DURA_DATE,V_LOG_MSG,outcde,1);
EXCEPTION
  WHEN OTHERS THEN
    outcde := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE-V_BGN_DATE)*24*60*60);
    SYS_PRC_STEP_LOGS(v_sysdat,V_PRC_NAME,V_PRC_DESC,V_NO_ID,V_BGN_DATE,V_END_DATE,V_DURA_DATE,SUBSTR(SQLERRM,1,1000),outcde,1);
    RAISE;
END;