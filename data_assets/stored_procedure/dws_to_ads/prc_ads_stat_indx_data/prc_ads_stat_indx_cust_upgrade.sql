CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_cust_upgrade(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    o_row_cnt OUT INTEGER     -- 处理行数
) AS
BEGIN
    -------------------------------------------------------------------------
    -- 6.1 提取符合提升条件的客户明细
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_CUST_STATE (
        path_code, statis_dim, indx_code, data_blng, cust_id,
        persn_legal_bk_code, base_cust_lvl, curnt_cust_lvl,
        base_mth_avg_aum, curnt_mth_avg_aum
    )
    SELECT CASE WHEN d.statis_calib = '营销活动' THEN 'A' ELSE 'B' END,
           d.statis_dim,
           d.indx_code,
           d.data_blng,
           d.cust_id,
           d.persn_legal_bk_code,
           d.base_cust_lvl,
           lv.cust_lvl,
           d.base_mth_avg_aum,
           NVL(b.aum_bal, 0)
      FROM ADS_STAT_INDX_BASELINE_DTL d
      LEFT JOIN DWS_CUST_LVL_INFO lv
        ON lv.cust_id             = d.cust_id
       AND lv.persn_legal_bk_code = d.persn_legal_bk_code
       AND lv.data_date           = v_sysdat
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id             = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
       AND b.data_date           = v_sysdat
       AND b.bal_type            = '2'
     WHERE d.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')
       AND (
           (d.indx_code = 'INDX_0052'
            AND TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 4
            AND TO_NUMBER(NVL(lv.cust_lvl, '0'))    >= 4)
           OR
           (d.indx_code = 'INDX_0053'
            AND TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 6
            AND TO_NUMBER(NVL(lv.cust_lvl, '0'))    >= 6)
           OR
           (d.indx_code = 'INDX_0054'
            AND TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 7
            AND TO_NUMBER(NVL(lv.cust_lvl, '0'))    >= 7)
           OR
           (d.indx_code = 'INDX_0063'
            AND b.cust_id IS NOT NULL
            AND (
                (b.aum_bal >= 45000   AND b.aum_bal < 50000)   OR
                (b.aum_bal >= 270000  AND b.aum_bal < 300000)  OR
                (b.aum_bal >= 450000  AND b.aum_bal < 500000)  OR
                (b.aum_bal >= 900000  AND b.aum_bal < 1000000) OR
                (b.aum_bal >= 2700000 AND b.aum_bal < 3000000) OR
                (d.base_mth_avg_aum >= 45000   AND d.base_mth_avg_aum < 50000)   OR
                (d.base_mth_avg_aum >= 270000  AND d.base_mth_avg_aum < 300000)  OR
                (d.base_mth_avg_aum >= 450000  AND d.base_mth_avg_aum < 500000)  OR
                (d.base_mth_avg_aum >= 900000  AND d.base_mth_avg_aum < 1000000) OR
                (d.base_mth_avg_aum >= 2700000 AND d.base_mth_avg_aum < 3000000)
            ))
       );

    -------------------------------------------------------------------------
    -- 6.2 汇总写入 AGGR（A路径）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0052' THEN COUNT(c.cust_id)
               WHEN 'INDX_0053' THEN COUNT(c.cust_id)
               WHEN 'INDX_0054' THEN COUNT(c.cust_id)
               WHEN 'INDX_0063' THEN
                   SUM(CASE WHEN (c.curnt_mth_avg_aum >= 45000   AND c.curnt_mth_avg_aum < 50000)   OR
                                 (c.curnt_mth_avg_aum >= 270000  AND c.curnt_mth_avg_aum < 300000)  OR
                                 (c.curnt_mth_avg_aum >= 450000  AND c.curnt_mth_avg_aum < 500000)  OR
                                 (c.curnt_mth_avg_aum >= 900000  AND c.curnt_mth_avg_aum < 1000000) OR
                                 (c.curnt_mth_avg_aum >= 2700000 AND c.curnt_mth_avg_aum < 3000000)
                            THEN 1 ELSE 0 END)
                 - SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR
                                  (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR
                                  (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR
                                  (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR
                                  (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)
                             THEN 1 ELSE 0 END)
           END,
           CASE WHEN s.indx_code = 'INDX_0063' THEN
               SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR
                             (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR
                             (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR
                             (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR
                             (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)
                        THEN 1 ELSE 0 END)
           ELSE 0 END,
           s.persn_legal_bk_code
      FROM (SELECT DISTINCT path_code, statis_dim, indx_code, data_blng, persn_legal_bk_code
              FROM TMP_STAT_INDX_SCOPE
             WHERE path_code = 'A'
               AND indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')) s
      LEFT JOIN TMP_STAT_INDX_CUST_STATE c
        ON c.path_code           = s.path_code
       AND c.statis_dim          = s.statis_dim
       AND c.indx_code           = s.indx_code
       AND c.data_blng           = s.data_blng
       AND c.persn_legal_bk_code = s.persn_legal_bk_code
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 6.3 汇总写入 AGGR（B路径）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0052' THEN COUNT(c.cust_id)
               WHEN 'INDX_0053' THEN COUNT(c.cust_id)
               WHEN 'INDX_0054' THEN COUNT(c.cust_id)
               WHEN 'INDX_0063' THEN
                   SUM(CASE WHEN (c.curnt_mth_avg_aum >= 45000   AND c.curnt_mth_avg_aum < 50000)   OR
                                 (c.curnt_mth_avg_aum >= 270000  AND c.curnt_mth_avg_aum < 300000)  OR
                                 (c.curnt_mth_avg_aum >= 450000  AND c.curnt_mth_avg_aum < 500000)  OR
                                 (c.curnt_mth_avg_aum >= 900000  AND c.curnt_mth_avg_aum < 1000000) OR
                                 (c.curnt_mth_avg_aum >= 2700000 AND c.curnt_mth_avg_aum < 3000000)
                            THEN 1 ELSE 0 END)
                 - SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR
                                  (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR
                                  (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR
                                  (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR
                                  (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)
                             THEN 1 ELSE 0 END)
           END,
           CASE WHEN s.indx_code = 'INDX_0063' THEN
               SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR
                             (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR
                             (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR
                             (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR
                             (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)
                        THEN 1 ELSE 0 END)
           ELSE 0 END,
           s.persn_legal_bk_code
      FROM (SELECT DISTINCT path_code, statis_dim, indx_code, data_blng, persn_legal_bk_code
              FROM TMP_STAT_INDX_SCOPE
             WHERE path_code = 'B'
               AND indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')) s
      LEFT JOIN TMP_STAT_INDX_CUST_STATE c
        ON c.path_code           = s.path_code
       AND c.statis_dim          = s.statis_dim
       AND c.indx_code           = s.indx_code
       AND c.data_blng           = s.data_blng
       AND c.persn_legal_bk_code = s.persn_legal_bk_code
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_cust_upgrade;