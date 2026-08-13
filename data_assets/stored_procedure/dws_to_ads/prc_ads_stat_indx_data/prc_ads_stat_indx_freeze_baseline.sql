CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_freeze_baseline(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    o_row_cnt OUT INTEGER     -- 处理行数
) AS
    V_NEXT_DAY    VARCHAR2(8);
    V_MISSING_CNT INTEGER;
BEGIN
    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_NEXT_DAY := sys_fun_deal_date(v_sysdat, 28);

    -------------------------------------------------------------------------
    -- 3.1 冻结成员表 ADS_STAT_INDX_BASELINE_MEMBER
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER (
        statis_calib, statis_dim, data_blng, cust_id,
        persn_legal_bk_code, base_data_date, base_run_date
    )
    WITH scope_member AS (
        -- A路径：营销活动成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON s.path_code             = 'A'
           AND ti.mkt_act_id           = s.statis_dim
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code
           AND ti.data_date            = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))
         WHERE s.term_begin_date = V_NEXT_DAY
           AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055',
                               'INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')

        UNION

        -- B路径-机构归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,
               s.term_begin_date, lv.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.path_code             = 'B'
           AND s.blng_type             = 'O'
           AND lv.org_id               = s.blng_id
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code
           AND lv.data_date            = v_sysdat
         WHERE s.term_begin_date = V_NEXT_DAY
           AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055',
                               'INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')

        UNION

        -- B路径-客户经理归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,
               s.term_begin_date, cm.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_CUST_MAN cm
            ON s.path_code             = 'B'
           AND s.blng_type             = 'M'
           AND cm.mngr_post_id         = s.blng_id
           AND cm.mng_typ              = '1'
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code
         WHERE s.term_begin_date = V_NEXT_DAY
           AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055',
                               'INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')
    )
    SELECT DISTINCT
           CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END AS statis_calib,
           sm.statis_dim,
           sm.data_blng,
           sm.cust_id,
           sm.persn_legal_bk_code,
           v_sysdat  AS base_data_date,
           v_sysdat  AS base_run_date
      FROM scope_member sm
     WHERE NOT EXISTS (
         SELECT 1
           FROM ADS_STAT_INDX_BASELINE_MEMBER x
          WHERE x.statis_calib        = CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
            AND x.statis_dim          = sm.statis_dim
            AND x.data_blng           = sm.data_blng
            AND x.cust_id             = sm.cust_id
            AND x.persn_legal_bk_code = sm.persn_legal_bk_code
     );

    -------------------------------------------------------------------------
    -- 3.2 冻结明细表 ADS_STAT_INDX_BASELINE_DTL
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_DTL (
        statis_calib, statis_dim, indx_code, data_blng, cust_id,
        persn_legal_bk_code, base_data_date, base_run_date,
        base_cust_lvl, base_mth_avg_aum
    )
    SELECT CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END,
           s.statis_dim,
           s.indx_code,
           s.data_blng,
           m.cust_id,
           m.persn_legal_bk_code,
           m.base_data_date,
           m.base_run_date,
           CASE WHEN s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054')
                THEN lv.cust_lvl END,
           CASE WHEN s.indx_code = 'INDX_0063'
                THEN b.aum_bal END
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m
        ON m.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
       AND m.statis_dim          = s.statis_dim
       AND m.data_blng           = s.data_blng
       AND m.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWS_CUST_LVL_INFO lv
        ON lv.cust_id             = m.cust_id
       AND lv.persn_legal_bk_code = m.persn_legal_bk_code
       AND lv.data_date           = v_sysdat
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id             = m.cust_id
       AND b.persn_legal_bk_code = m.persn_legal_bk_code
       AND b.data_date           = v_sysdat
       AND b.bal_type            = '2'
     WHERE s.term_begin_date = V_NEXT_DAY
       AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')
       AND (s.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)
       AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL)
       AND NOT EXISTS (
           SELECT 1
             FROM ADS_STAT_INDX_BASELINE_DTL d
            WHERE d.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
              AND d.statis_dim          = s.statis_dim
              AND d.indx_code           = s.indx_code
              AND d.data_blng           = s.data_blng
              AND d.cust_id             = m.cust_id
              AND d.persn_legal_bk_code = m.persn_legal_bk_code
       );

    -------------------------------------------------------------------------
    -- 3.3 冻结汇总表 ADS_STAT_INDX_BASELINE_SUM
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (
        statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code,
        base_data_date, base_run_date, base_loan_bal, base_yr_avg_fin,
        base_mth_avg_fin, base_yr_avg_agen_fin, base_mth_avg_agen_fin
    )
    SELECT CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END,
           s.statis_dim,
           s.indx_code,
           s.data_blng,
           s.persn_legal_bk_code,
           MAX(m.base_data_date),
           v_sysdat,
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END),
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END),
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END),
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END)
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m
        ON m.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
       AND m.statis_dim          = s.statis_dim
       AND m.data_blng           = s.data_blng
       AND m.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id             = m.cust_id
       AND b.persn_legal_bk_code = m.persn_legal_bk_code
       AND b.data_date           = m.base_data_date
     WHERE s.term_begin_date = V_NEXT_DAY
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
       AND NOT EXISTS (
           SELECT 1
             FROM ADS_STAT_INDX_BASELINE_SUM x
            WHERE x.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
              AND x.statis_dim          = s.statis_dim
              AND x.indx_code           = s.indx_code
              AND x.data_blng           = s.data_blng
              AND x.persn_legal_bk_code = s.persn_legal_bk_code
       )
     GROUP BY s.path_code, s.statis_dim, s.indx_code, s.data_blng, s.persn_legal_bk_code
    HAVING COUNT(DISTINCT b.cust_id) = COUNT(DISTINCT m.cust_id);

    -------------------------------------------------------------------------
    -- 清理仅用于冻结的范围数据
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_SCOPE WHERE term_begin_date = V_NEXT_DAY;

    -------------------------------------------------------------------------
    -- 缺失基准强校验
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_MISSING_CNT
      FROM TMP_STAT_INDX_SCOPE s
     WHERE s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0055',
                           'INDX_0056','INDX_0058','INDX_0059','INDX_0062','INDX_0063')
       AND (
           (s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')
            AND NOT EXISTS (
                SELECT 1 FROM ADS_STAT_INDX_BASELINE_DTL d
                 WHERE d.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
                   AND d.statis_dim          = s.statis_dim
                   AND d.indx_code           = s.indx_code
                   AND d.data_blng           = s.data_blng
                   AND d.persn_legal_bk_code = s.persn_legal_bk_code
            ))
           OR
           (s.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
            AND NOT EXISTS (
                SELECT 1 FROM ADS_STAT_INDX_BASELINE_SUM b
                 WHERE b.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END
                   AND b.statis_dim          = s.statis_dim
                   AND b.indx_code           = s.indx_code
                   AND b.data_blng           = s.data_blng
                   AND b.persn_legal_bk_code = s.persn_legal_bk_code
            ))
       );

    IF V_MISSING_CNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            '已开始活动/任务缺少开始前一天冻结的基准数据，严禁在活动期间补建基准');
    END IF;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_freeze_baseline;