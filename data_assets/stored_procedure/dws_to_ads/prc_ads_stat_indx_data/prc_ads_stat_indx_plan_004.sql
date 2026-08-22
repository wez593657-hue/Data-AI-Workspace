CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_004(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    outcde OUT INTEGER     -- 处理行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤44处理完成 4';
    V_PRC_NAME VARCHAR2(32) := 'prc_ads_stat_indx_plan_004';
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
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');
    -------------------------------------------------------------------------
    -- 营销活动路径（A）：理财产品/代销理财/贷款 0055/0056/0057/0058/0059/0060/0062
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0057' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_fin_bal)
               WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin)
               WHEN 'INDX_0060' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_agen_fin_bal)
               WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END) - MAX(bs.base_loan_bal)
           END,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0057' THEN MAX(bs.base_fin_bal)
               WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin)
               WHEN 'INDX_0060' THEN MAX(bs.base_agen_fin_bal)
               WHEN 'INDX_0062' THEN MAX(bs.base_loan_bal)
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER d
        ON d.statis_calib        = '营销活动'
       AND d.statis_dim          = s.statis_dim
       AND d.data_blng           = s.data_blng
       AND d.persn_legal_bk_code = s.persn_legal_bk_code
     INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs
        ON bs.statis_calib        = '营销活动'
       AND bs.statis_dim          = s.statis_dim
       AND bs.indx_code           = s.indx_code
       AND bs.data_blng           = s.data_blng
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN (
          SELECT cust_id, persn_legal_bk_code, bal_type, fin_bal,
                 close_agen_fin_bal, open_agen_fin_bal, loan_bal
            FROM DWS_CUST_ASSE_LIAB
           WHERE data_date = v_sysdat
             AND EXISTS (SELECT 1 FROM ADS_STAT_INDX_BASELINE_MEMBER d2 WHERE d2.cust_id = DWS_CUST_ASSE_LIAB.cust_id AND d2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB.persn_legal_bk_code)
      ) b
        ON b.cust_id             = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
     WHERE s.path_code = 'A'
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 目标任务路径（B）：理财产品/代销理财/贷款 0055/0056/0057/0058/0059/0060/0062
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0057' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_fin_bal)
               WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin)
               WHEN 'INDX_0060' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_agen_fin_bal)
               WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END) - MAX(bs.base_loan_bal)
           END,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0057' THEN MAX(bs.base_fin_bal)
               WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin)
               WHEN 'INDX_0060' THEN MAX(bs.base_agen_fin_bal)
               WHEN 'INDX_0062' THEN MAX(bs.base_loan_bal)
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER d
        ON d.statis_calib        = '目标任务'
       AND d.statis_dim          = s.statis_dim
       AND d.data_blng           = s.data_blng
       AND d.persn_legal_bk_code = s.persn_legal_bk_code
     INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs
        ON bs.statis_calib        = '目标任务'
       AND bs.statis_dim          = s.statis_dim
       AND bs.indx_code           = s.indx_code
       AND bs.data_blng           = s.data_blng
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN (
          SELECT cust_id, persn_legal_bk_code, bal_type, fin_bal,
                 close_agen_fin_bal, open_agen_fin_bal, loan_bal
            FROM DWS_CUST_ASSE_LIAB
           WHERE data_date = v_sysdat
             AND EXISTS (SELECT 1 FROM ADS_STAT_INDX_BASELINE_MEMBER d2 WHERE d2.cust_id = DWS_CUST_ASSE_LIAB.cust_id AND d2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB.persn_legal_bk_code)
      ) b
        ON b.cust_id             = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
     WHERE s.path_code = 'B'
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

        outcde := SQL%ROWCOUNT;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    V_LOG_MSG := '步骤4处理完成，行数=' || NVL(outcde, 0);
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
END prc_ads_stat_indx_plan_004;
