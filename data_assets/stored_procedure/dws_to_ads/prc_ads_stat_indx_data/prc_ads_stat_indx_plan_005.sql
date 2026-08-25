CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_005(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    outcde OUT INTEGER     -- 处理行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤55处理完成 5';
    V_PRC_NAME VARCHAR2(32) := 'prc_ads_stat_indx_plan_005';
    V_LOG_MSG VARCHAR2(4000);
    V_LOG_FLG INTEGER;
    V_LOG_BUTTON INTEGER := 1;
    V_NO_ID VARCHAR2(10);
    V_BGN_DATE DATE;
    V_END_DATE DATE;
    V_DURA_DATE INTEGER;
BEGIN
    V_NO_ID := '0';
    V_BGN_DATE := SYSDATE;
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
    END IF;

    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    DELETE FROM TMP_STAT_INDX_AGGR_005;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');
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
    INSERT INTO TMP_STAT_INDX_AGGR_005 (
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
    INSERT INTO TMP_STAT_INDX_AGGR_005 (
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

        outcde := SQL%ROWCOUNT;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    V_LOG_MSG := '步骤5处理完成，行数=' || NVL(outcde, 0);
    V_LOG_FLG := 0;
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
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
END prc_ads_stat_indx_plan_005;
