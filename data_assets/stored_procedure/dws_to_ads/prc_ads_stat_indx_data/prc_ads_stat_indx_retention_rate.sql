CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_retention_rate(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    o_row_cnt OUT INTEGER     -- 处理行数
) AS
    V_YAR_BEGIN VARCHAR2(8);   -- 当年初
BEGIN
    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_YAR_BEGIN := sys_fun_deal_date(v_sysdat, 13);

    -------------------------------------------------------------------------
    -- A路径：营销活动 INDX_0081
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_merchant AS (
        SELECT DISTINCT s.statis_dim, s.data_blng,
               s.persn_legal_bk_code, m.mct_id
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN uepp_pay_mct_info m
            ON m.mct_type = 'personage'
           AND ((s.blng_type = 'O' AND m.org_id = s.blng_id)
             OR (s.blng_type = 'M' AND m.job_id = s.blng_id))
         WHERE s.path_code = 'A' AND s.indx_code = 'INDX_0081'
    ),
    annual_tx AS (
        SELECT sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code, sm.mct_id,
               SUM(NVL(o.order_amt, 0)) AS annual_tx_amt
          FROM scope_merchant sm
         INNER JOIN uepp_pay_order_info o
            ON o.mct_id     = sm.mct_id
           AND o.order_type = '00'
           AND o.status     = '02'
           AND SUBSTR(o.pay_time, 1, 8) BETWEEN V_YAR_BEGIN AND v_sysdat
         GROUP BY sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code, sm.mct_id
        HAVING SUM(NVL(o.order_amt, 0)) >= 500
    ),
    merchant_cust AS (
        SELECT DISTINCT a.statis_dim, a.data_blng,
               a.persn_legal_bk_code, a.mct_id, sa.cust_no
          FROM annual_tx a
         INNER JOIN uepp_pay_mct_settle_account sa
            ON sa.mct_id  = a.mct_id
           AND sa.cust_no IS NOT NULL
    ),
    merchant_aum AS (
        SELECT mc.statis_dim, mc.data_blng, mc.persn_legal_bk_code, mc.mct_id,
               SUM(NVL(b.aum_bal, 0)) AS annual_aum
          FROM merchant_cust mc
          LEFT JOIN DWS_CUST_ASSE_LIAB b
            ON b.cust_id             = mc.cust_no
           AND b.persn_legal_bk_code = mc.persn_legal_bk_code
           AND b.data_date           = v_sysdat
           AND b.bal_type            = '4'
         GROUP BY mc.statis_dim, mc.data_blng, mc.persn_legal_bk_code, mc.mct_id
    )
    SELECT 'A', v_sysdat, a.data_blng, a.statis_dim, '营销活动', 'INDX_0081',
           ROUND(SUM(NVL(ma.annual_aum, 0)) * 100 / NULLIF(SUM(a.annual_tx_amt), 0), 2),
           0, a.persn_legal_bk_code
      FROM annual_tx a
      LEFT JOIN merchant_aum ma
        ON ma.statis_dim          = a.statis_dim
       AND ma.data_blng           = a.data_blng
       AND ma.persn_legal_bk_code = a.persn_legal_bk_code
       AND ma.mct_id              = a.mct_id
     GROUP BY a.data_blng, a.statis_dim, a.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- B路径：目标任务 INDX_0081
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_merchant AS (
        SELECT DISTINCT s.statis_dim, s.data_blng,
               s.persn_legal_bk_code, m.mct_id
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN uepp_pay_mct_info m
            ON m.mct_type = 'personage'
           AND ((s.blng_type = 'O' AND m.org_id = s.blng_id)
             OR (s.blng_type = 'M' AND m.job_id = s.blng_id))
         WHERE s.path_code = 'B' AND s.indx_code = 'INDX_0081'
    ),
    annual_tx AS (
        SELECT sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code, sm.mct_id,
               SUM(NVL(o.order_amt, 0)) AS annual_tx_amt
          FROM scope_merchant sm
         INNER JOIN uepp_pay_order_info o
            ON o.mct_id     = sm.mct_id
           AND o.order_type = '00'
           AND o.status     = '02'
           AND SUBSTR(o.pay_time, 1, 8) BETWEEN V_YAR_BEGIN AND v_sysdat
         GROUP BY sm.statis_dim, sm.data_blng, sm.persn_legal_bk_code, sm.mct_id
        HAVING SUM(NVL(o.order_amt, 0)) >= 500
    ),
    merchant_cust AS (
        SELECT DISTINCT a.statis_dim, a.data_blng,
               a.persn_legal_bk_code, a.mct_id, sa.cust_no
          FROM annual_tx a
         INNER JOIN uepp_pay_mct_settle_account sa
            ON sa.mct_id  = a.mct_id
           AND sa.cust_no IS NOT NULL
    ),
    merchant_aum AS (
        SELECT mc.statis_dim, mc.data_blng, mc.persn_legal_bk_code, mc.mct_id,
               SUM(NVL(b.aum_bal, 0)) AS annual_aum
          FROM merchant_cust mc
          LEFT JOIN DWS_CUST_ASSE_LIAB b
            ON b.cust_id             = mc.cust_no
           AND b.persn_legal_bk_code = mc.persn_legal_bk_code
           AND b.data_date           = v_sysdat
           AND b.bal_type            = '4'
         GROUP BY mc.statis_dim, mc.data_blng, mc.persn_legal_bk_code, mc.mct_id
    )
    SELECT 'B', v_sysdat, a.data_blng, a.statis_dim, '目标任务', 'INDX_0081',
           ROUND(SUM(NVL(ma.annual_aum, 0)) * 100 / NULLIF(SUM(a.annual_tx_amt), 0), 2),
           0, a.persn_legal_bk_code
      FROM annual_tx a
      LEFT JOIN merchant_aum ma
        ON ma.statis_dim          = a.statis_dim
       AND ma.data_blng           = a.data_blng
       AND ma.persn_legal_bk_code = a.persn_legal_bk_code
       AND ma.mct_id              = a.mct_id
     GROUP BY a.data_blng, a.statis_dim, a.persn_legal_bk_code;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_retention_rate;