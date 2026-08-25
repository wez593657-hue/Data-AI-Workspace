-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_003
-- 功能说明: 指标数据统计——步骤3（余额预聚合与各指标增量写入汇总表）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    处理行数
-- 需求版本: v4.7 (2026-08-25)
-- 变更记录:
--   v4.7 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_003，段首自清（并行跑批隔离）
--   v4.6 0047基数缺失时增量与期初值置NULL；0050/0051基准改为基数表
--        ADS_STAT_INDX_BASELINE_SUM（活动前一日冻结/存量补跑）；
--        删除HIS直取的prev_yr_avg_aum/prev_mth_avg_aum及V_YAR_PREV_END
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_003(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    outcde OUT INTEGER     -- 处理行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤3';
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_003';
    V_LOG_MSG    VARCHAR2(4000);
    V_LOG_FLG    INTEGER;
    V_LOG_BUTTON INTEGER := 1;
    V_NO_ID      VARCHAR2(10);
    V_BGN_DATE   DATE;
    V_END_DATE   DATE;
    V_DURA_DATE  INTEGER;
    V_MTH_BEGIN    VARCHAR2(8);   -- 当月月初
    V_MTH_END      VARCHAR2(8);   -- 上月月末
    V_QRT_END      VARCHAR2(8);   -- 上季末
    V_YAR_BEGIN    VARCHAR2(8);   -- 当年初
BEGIN
    -------------------------------------------------------------------------
    -- 标准模板：参数校验与开始日志状态
    -------------------------------------------------------------------------
    V_NO_ID := '0';
    V_BGN_DATE := SYSDATE;
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
    END IF;

    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    DELETE FROM TMP_STAT_INDX_AGGR_003;

    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');

    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_MTH_BEGIN    := sys_fun_deal_date(v_sysdat, 9);
    V_MTH_END      := sys_fun_deal_date(v_sysdat, 2);
    V_QRT_END      := sys_fun_deal_date(v_sysdat, 3);
    V_YAR_BEGIN    := sys_fun_deal_date(v_sysdat, 13);

    -------------------------------------------------------------------------
    -- 4.1 余额预聚合到 TMP_STAT_INDX_BAL_AGGR
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_BAL_AGGR (
        path_code, statis_dim, data_blng, persn_legal_bk_code,
        curnt_aum, yr_begin_aum, mth_end_aum, qrt_end_aum,
        curnt_yr_avg_aum, curnt_mth_avg_aum
    )
    WITH base_scope AS (
        SELECT DISTINCT path_code, statis_dim, data_blng,
               blng_type, blng_id, persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE
         WHERE indx_code IN ('INDX_0046','INDX_0047','INDX_0048',
                             'INDX_0049','INDX_0050','INDX_0051')
           AND (indx_code <> 'INDX_0047' OR blng_type = 'O')   -- INDX_0047 仅机构维度口径
    ),
    scope_member AS (
        -- A路径：营销活动成员
        SELECT s.path_code, s.statis_dim, s.data_blng,
               ti.cust_id, s.persn_legal_bk_code
          FROM base_scope s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON s.path_code             = 'A'
           AND ti.mkt_act_id           = s.statis_dim
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code
           AND ti.data_date            = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))

        UNION

        -- B路径-机构归属
        SELECT s.path_code, s.statis_dim, s.data_blng,
               lv.cust_id, s.persn_legal_bk_code
          FROM base_scope s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.path_code             = 'B'
           AND s.blng_type             = 'O'
           AND lv.org_id               = s.blng_id
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code
           AND lv.data_date            = v_sysdat

        UNION

        -- B路径-客户经理归属
        SELECT s.path_code, s.statis_dim, s.data_blng,
               cm.cust_id, s.persn_legal_bk_code
          FROM base_scope s
         INNER JOIN DWD_CUST_MAN cm
            ON s.path_code             = 'B'
           AND s.blng_type             = 'M'
           AND cm.mngr_post_id         = s.blng_id
           AND cm.mng_typ              = '1'
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code
    )
    SELECT sm.path_code,
           sm.statis_dim,
           sm.data_blng,
           sm.persn_legal_bk_code,
           SUM(NVL(b.curnt_aum, 0))         AS curnt_aum,
           SUM(NVL(hb.yr_begin_aum, 0))     AS yr_begin_aum,
           SUM(NVL(hb.mth_end_aum, 0))      AS mth_end_aum,
           SUM(NVL(hb.qrt_end_aum, 0))      AS qrt_end_aum,
           SUM(NVL(b.curnt_yr_avg_aum, 0))  AS curnt_yr_avg_aum,
           SUM(NVL(b.curnt_mth_avg_aum, 0)) AS curnt_mth_avg_aum
      FROM scope_member sm
      LEFT JOIN (
          SELECT cust_id,
                 persn_legal_bk_code,
                 SUM(CASE WHEN bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS curnt_aum,
                 SUM(CASE WHEN bal_type = '4' THEN NVL(depo_bal, 0) ELSE 0 END) AS curnt_yr_avg_aum,
                 SUM(CASE WHEN bal_type = '2' THEN NVL(depo_bal, 0) ELSE 0 END) AS curnt_mth_avg_aum
            FROM DWS_CUST_ASSE_LIAB
           WHERE data_date = v_sysdat
             AND EXISTS (SELECT 1 FROM scope_member sm2
                          WHERE sm2.cust_id = DWS_CUST_ASSE_LIAB.cust_id
                            AND sm2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB.persn_legal_bk_code)
           GROUP BY cust_id, persn_legal_bk_code
      ) b
        ON b.cust_id             = sm.cust_id
       AND b.persn_legal_bk_code = sm.persn_legal_bk_code
      LEFT JOIN (
          SELECT cust_id,
                 persn_legal_bk_code,
                 SUM(CASE WHEN data_date = V_YAR_BEGIN
                            AND bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS yr_begin_aum,
                 SUM(CASE WHEN data_date = V_MTH_END
                            AND bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS mth_end_aum,
                 SUM(CASE WHEN data_date = V_QRT_END
                            AND bal_type = '1' THEN NVL(depo_bal, 0) ELSE 0 END) AS qrt_end_aum
            FROM DWS_CUST_ASSE_LIAB_HIS
           WHERE data_date IN (V_YAR_BEGIN, V_MTH_END, V_QRT_END)
             AND EXISTS (SELECT 1 FROM scope_member sm2
                          WHERE sm2.cust_id = DWS_CUST_ASSE_LIAB_HIS.cust_id
                            AND sm2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB_HIS.persn_legal_bk_code)
           GROUP BY cust_id, persn_legal_bk_code
      ) hb
        ON hb.cust_id             = sm.cust_id
       AND hb.persn_legal_bk_code = sm.persn_legal_bk_code
     GROUP BY sm.path_code, sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 4.2 标准期间增量写入（INDX_0046/0048/0049/0050/0051）- A路径
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0046' THEN b.curnt_aum - b.yr_begin_aum
               WHEN 'INDX_0048' THEN b.curnt_aum - b.mth_end_aum
               WHEN 'INDX_0049' THEN b.curnt_aum - b.qrt_end_aum
               WHEN 'INDX_0050' THEN b.curnt_yr_avg_aum - bs.base_yr_avg_depo
               WHEN 'INDX_0051' THEN b.curnt_mth_avg_aum - bs.base_mth_avg_depo
           END,
           CASE s.indx_code
               WHEN 'INDX_0046' THEN b.yr_begin_aum
               WHEN 'INDX_0048' THEN b.mth_end_aum
               WHEN 'INDX_0049' THEN b.qrt_end_aum
               WHEN 'INDX_0050' THEN bs.base_yr_avg_depo
               WHEN 'INDX_0051' THEN bs.base_mth_avg_depo
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code           = 'A'
       AND b.statis_dim          = s.statis_dim
       AND b.data_blng           = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN ADS_STAT_INDX_BASELINE_SUM bs
        ON bs.statis_calib        = '营销活动'
       AND bs.statis_dim          = s.statis_dim
       AND bs.indx_code           = s.indx_code
       AND bs.data_blng           = s.data_blng
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code
     WHERE s.path_code = 'A'
       AND s.indx_code IN ('INDX_0046','INDX_0048','INDX_0049','INDX_0050','INDX_0051');

    -------------------------------------------------------------------------
    -- 4.2 标准期间增量写入（INDX_0046/0048/0049/0050/0051）- B路径
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0046' THEN b.curnt_aum - b.yr_begin_aum
               WHEN 'INDX_0048' THEN b.curnt_aum - b.mth_end_aum
               WHEN 'INDX_0049' THEN b.curnt_aum - b.qrt_end_aum
               WHEN 'INDX_0050' THEN b.curnt_yr_avg_aum - bs.base_yr_avg_depo
               WHEN 'INDX_0051' THEN b.curnt_mth_avg_aum - bs.base_mth_avg_depo
           END,
           CASE s.indx_code
               WHEN 'INDX_0046' THEN b.yr_begin_aum
               WHEN 'INDX_0048' THEN b.mth_end_aum
               WHEN 'INDX_0049' THEN b.qrt_end_aum
               WHEN 'INDX_0050' THEN bs.base_yr_avg_depo
               WHEN 'INDX_0051' THEN bs.base_mth_avg_depo
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code           = 'B'
       AND b.statis_dim          = s.statis_dim
       AND b.data_blng           = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN ADS_STAT_INDX_BASELINE_SUM bs
        ON bs.statis_calib        = '目标任务'
       AND bs.statis_dim          = s.statis_dim
       AND bs.indx_code           = s.indx_code
       AND bs.data_blng           = s.data_blng
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code
     WHERE s.path_code = 'B'
       AND s.indx_code IN ('INDX_0046','INDX_0048','INDX_0049','INDX_0050','INDX_0051');

    -------------------------------------------------------------------------
    -- 4.3 存款基数扣减指标 INDX_0047 - A路径（仅机构维度）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', 'INDX_0047',
           CASE WHEN SUM(v.value_init) IS NULL THEN NULL
                ELSE b.curnt_aum - SUM(NVL(v.value_init, 0)) END,
           SUM(v.value_init),
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code           = 'A'
       AND b.statis_dim          = s.statis_dim
       AND b.data_blng           = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWD_DEPO_VALUE_INIT v
        ON v.org_id = s.blng_id
     WHERE s.path_code = 'A'
       AND s.blng_type = 'O'
       AND s.indx_code = 'INDX_0047'
     GROUP BY s.data_blng, s.statis_dim, b.curnt_aum, s.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 4.3 存款基数扣减指标 INDX_0047 - B路径（仅机构维度）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_003 (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', 'INDX_0047',
           CASE WHEN SUM(v.value_init) IS NULL THEN NULL
                ELSE b.curnt_aum - SUM(NVL(v.value_init, 0)) END,
           SUM(v.value_init),
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code           = 'B'
       AND b.statis_dim          = s.statis_dim
       AND b.data_blng           = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWD_DEPO_VALUE_INIT v
        ON v.org_id = s.blng_id
     WHERE s.path_code = 'B'
       AND s.blng_type = 'O'
       AND s.indx_code = 'INDX_0047'
     GROUP BY s.data_blng, s.statis_dim, b.curnt_aum, s.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 收尾：本次处理行数回填、提交并记录步骤日志
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    V_LOG_MSG := '步骤3处理完成，行数=' || NVL(outcde, 0);
    V_LOG_FLG := 0;
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -------------------------------------------------------------------------
    -- 异常处理：回滚并记录错误日志后重抛
    -------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        outcde := -1;
        V_END_DATE := SYSDATE;
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
        V_LOG_FLG := -1;
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
        RAISE;
END prc_ads_stat_indx_plan_003;