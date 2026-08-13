CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_new_cust_rule(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    o_row_cnt OUT INTEGER     -- 本模块写入行数
) AS
    V_180_DAY_BEGIN VARCHAR2(8);   -- 180天新客识别窗口起点
BEGIN
    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_180_DAY_BEGIN := sys_fun_deal_date(v_sysdat, 27);

    -------------------------------------------------------------------------
    -- 路径A：营销活动（INDX_0080 / 0082 / 0083）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT DISTINCT
               s.statis_dim,
               s.data_blng,
               s.term_begin_date,
               ti.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON ti.mkt_act_id           = s.statis_dim
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code
           AND ti.data_date            = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))
         WHERE s.path_code = 'A'
           AND s.indx_code IN ('INDX_0080', 'INDX_0082', 'INDX_0083')
    ),
    cust_flags AS (
        SELECT sm.statis_dim,
               sm.data_blng,
               sm.term_begin_date,
               sm.cust_id,
               sm.persn_legal_bk_code,
               ci.open_date,
               MAX(CASE WHEN mi.cust_no IS NOT NULL THEN 1 ELSE 0 END)                                      AS has_mbk,
               MAX(CASE WHEN NVL(b.depo_curnt_depo_bal, 0) + NVL(b.fixd_depo_bal, 0) >= 100 THEN 1 ELSE 0 END) AS has_depo,
               MAX(CASE WHEN NVL(b.fin_bal, 0) > 0 THEN 1 ELSE 0 END)                                       AS has_fin,
               MAX(CASE WHEN NVL(b.loan_bal, 0) > 0 THEN 1 ELSE 0 END)                                      AS has_loan
          FROM scope_member sm
          LEFT JOIN DWD_CUST_INDV_INFO ci
            ON ci.cust_id = sm.cust_id
          LEFT JOIN mbk_cust_info mi
            ON mi.cust_core_no = sm.cust_id AND mi.cust_status = '1'
          LEFT JOIN DWS_CUST_ASSE_LIAB b
            ON b.cust_id             = sm.cust_id
           AND b.persn_legal_bk_code = sm.persn_legal_bk_code
           AND b.data_date           = v_sysdat
           AND b.bal_type            = '1'
         GROUP BY sm.statis_dim, sm.data_blng, sm.term_begin_date,
                  sm.cust_id, sm.persn_legal_bk_code, ci.open_date
    ),
    cust_result AS (
        -- INDX_0080：新客交叉销售
        SELECT 'A'            AS path_code,
               v_sysdat       AS data_date,
               data_blng,
               statis_dim,
               '营销活动'      AS statis_calib,
               'INDX_0080'     AS indx_code,
               COUNT(DISTINCT CASE
                   WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$')            THEN open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN REPLACE(open_date, '-', '')
                        END BETWEEN V_180_DAY_BEGIN AND v_sysdat
                        AND has_mbk + has_depo + has_fin + has_loan >= 2
                   THEN cust_id
               END)           AS curnt_val,
               0              AS term_last_val,
               persn_legal_bk_code
          FROM cust_flags
         WHERE EXISTS (
             SELECT 1 FROM TMP_STAT_INDX_SCOPE s
              WHERE s.path_code           = 'A'
                AND s.statis_dim          = cust_flags.statis_dim
                AND s.data_blng           = cust_flags.data_blng
                AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                AND s.indx_code           = 'INDX_0080'
         )
         GROUP BY data_blng, statis_dim, persn_legal_bk_code

        UNION ALL

        -- INDX_0082：新增客户数
        SELECT 'A', v_sysdat, data_blng, statis_dim, '营销活动', 'INDX_0082',
               COUNT(DISTINCT CASE
                   WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$')            THEN open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN REPLACE(open_date, '-', '')
                        END BETWEEN term_begin_date AND v_sysdat
                   THEN cust_id
               END),
               0, persn_legal_bk_code
          FROM cust_flags
         WHERE EXISTS (
             SELECT 1 FROM TMP_STAT_INDX_SCOPE s
              WHERE s.path_code           = 'A'
                AND s.statis_dim          = cust_flags.statis_dim
                AND s.data_blng           = cust_flags.data_blng
                AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                AND s.indx_code           = 'INDX_0082'
         )
         GROUP BY data_blng, statis_dim, persn_legal_bk_code
    ),
    debit_card_result AS (
        -- INDX_0083：借记卡新发卡量
        SELECT 'A'            AS path_code,
               v_sysdat       AS data_date,
               sm.data_blng,
               sm.statis_dim,
               '营销活动'      AS statis_calib,
               'INDX_0083'     AS indx_code,
               COUNT(DISTINCT d.acct_id) AS curnt_val,
               0              AS term_last_val,
               sm.persn_legal_bk_code
          FROM scope_member sm
         INNER JOIN DWD_ACCT_DEPO d
            ON d.cust_id             = sm.cust_id
           AND d.persn_legal_bk_code = sm.persn_legal_bk_code
           AND TRIM(d.acct_typ) IN ('01', '02')
           AND d.card_no IS NOT NULL
           AND CASE
                   WHEN REGEXP_LIKE(d.open_date, '^[0-9]{8}$')            THEN d.open_date
                   WHEN REGEXP_LIKE(d.open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN REPLACE(d.open_date, '-', '')
               END BETWEEN sm.term_begin_date AND v_sysdat
         WHERE EXISTS (
             SELECT 1 FROM TMP_STAT_INDX_SCOPE s
              WHERE s.path_code           = 'A'
                AND s.statis_dim          = sm.statis_dim
                AND s.data_blng           = sm.data_blng
                AND s.persn_legal_bk_code = sm.persn_legal_bk_code
                AND s.indx_code           = 'INDX_0083'
         )
         GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code
    )
    SELECT path_code, data_date, data_blng, statis_dim, statis_calib,
           indx_code, curnt_val, term_last_val, persn_legal_bk_code
      FROM cust_result
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim, statis_calib,
           indx_code, curnt_val, term_last_val, persn_legal_bk_code
      FROM debit_card_result;

    -------------------------------------------------------------------------
    -- 路径B：目标任务（INDX_0080 / 0082 / 0083）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT DISTINCT
               s.statis_dim, s.data_blng, s.term_begin_date,
               lv.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.blng_type             = 'O'
           AND lv.org_id               = s.blng_id
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code
           AND lv.data_date            = v_sysdat
         WHERE s.path_code = 'B'
           AND s.indx_code IN ('INDX_0080', 'INDX_0082', 'INDX_0083')

        UNION

        SELECT DISTINCT
               s.statis_dim, s.data_blng, s.term_begin_date,
               cm.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_CUST_MAN cm
            ON s.blng_type             = 'M'
           AND cm.mngr_post_id         = s.blng_id
           AND cm.mng_typ              = '1'
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code
         WHERE s.path_code = 'B'
           AND s.indx_code IN ('INDX_0080', 'INDX_0082', 'INDX_0083')
    ),
    cust_flags AS (
        SELECT sm.statis_dim, sm.data_blng, sm.term_begin_date,
               sm.cust_id, sm.persn_legal_bk_code, ci.open_date,
               MAX(CASE WHEN mi.cust_no IS NOT NULL THEN 1 ELSE 0 END)                                      AS has_mbk,
               MAX(CASE WHEN NVL(b.depo_curnt_depo_bal, 0) + NVL(b.fixd_depo_bal, 0) >= 100 THEN 1 ELSE 0 END) AS has_depo,
               MAX(CASE WHEN NVL(b.fin_bal, 0) > 0 THEN 1 ELSE 0 END)                                       AS has_fin,
               MAX(CASE WHEN NVL(b.loan_bal, 0) > 0 THEN 1 ELSE 0 END)                                      AS has_loan
          FROM scope_member sm
          LEFT JOIN DWD_CUST_INDV_INFO ci ON ci.cust_id = sm.cust_id
          LEFT JOIN mbk_cust_info mi ON mi.cust_core_no = sm.cust_id AND mi.cust_status = '1'
          LEFT JOIN DWS_CUST_ASSE_LIAB b
            ON b.cust_id = sm.cust_id AND b.persn_legal_bk_code = sm.persn_legal_bk_code
           AND b.data_date = v_sysdat AND b.bal_type = '1'
         GROUP BY sm.statis_dim, sm.data_blng, sm.term_begin_date,
                  sm.cust_id, sm.persn_legal_bk_code, ci.open_date
    ),
    cust_result AS (
        -- INDX_0080：新客交叉销售
        SELECT 'B', v_sysdat, data_blng, statis_dim, '目标任务', 'INDX_0080',
               COUNT(DISTINCT CASE
                   WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$')            THEN open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN REPLACE(open_date, '-', '')
                        END BETWEEN V_180_DAY_BEGIN AND v_sysdat
                        AND has_mbk + has_depo + has_fin + has_loan >= 2
                   THEN cust_id
               END), 0, persn_legal_bk_code
          FROM cust_flags
         WHERE EXISTS (
             SELECT 1 FROM TMP_STAT_INDX_SCOPE s
              WHERE s.path_code = 'B' AND s.statis_dim = cust_flags.statis_dim
                AND s.data_blng = cust_flags.data_blng
                AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                AND s.indx_code = 'INDX_0080'
         )
         GROUP BY data_blng, statis_dim, persn_legal_bk_code

        UNION ALL

        -- INDX_0082：新增客户数
        SELECT 'B', v_sysdat, data_blng, statis_dim, '目标任务', 'INDX_0082',
               COUNT(DISTINCT CASE
                   WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$')            THEN open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN REPLACE(open_date, '-', '')
                        END BETWEEN term_begin_date AND v_sysdat
                   THEN cust_id
               END), 0, persn_legal_bk_code
          FROM cust_flags
         WHERE EXISTS (
             SELECT 1 FROM TMP_STAT_INDX_SCOPE s
              WHERE s.path_code = 'B' AND s.statis_dim = cust_flags.statis_dim
                AND s.data_blng = cust_flags.data_blng
                AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                AND s.indx_code = 'INDX_0082'
         )
         GROUP BY data_blng, statis_dim, persn_legal_bk_code
    ),
    debit_card_result AS (
        -- INDX_0083：借记卡新发卡量
        SELECT 'B', v_sysdat, sm.data_blng, sm.statis_dim, '目标任务', 'INDX_0083',
               COUNT(DISTINCT d.acct_id), 0, sm.persn_legal_bk_code
          FROM scope_member sm
         INNER JOIN DWD_ACCT_DEPO d
            ON d.cust_id = sm.cust_id AND d.persn_legal_bk_code = sm.persn_legal_bk_code
           AND TRIM(d.acct_typ) IN ('01', '02')
           AND d.card_no IS NOT NULL
           AND CASE
                   WHEN REGEXP_LIKE(d.open_date, '^[0-9]{8}$')            THEN d.open_date
                   WHEN REGEXP_LIKE(d.open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN REPLACE(d.open_date, '-', '')
               END BETWEEN sm.term_begin_date AND v_sysdat
         WHERE EXISTS (
             SELECT 1 FROM TMP_STAT_INDX_SCOPE s
              WHERE s.path_code = 'B' AND s.statis_dim = sm.statis_dim
                AND s.data_blng = sm.data_blng
                AND s.persn_legal_bk_code = sm.persn_legal_bk_code
                AND s.indx_code = 'INDX_0083'
         )
         GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code
    )
    SELECT path_code, data_date, data_blng, statis_dim, statis_calib,
           indx_code, curnt_val, term_last_val, persn_legal_bk_code
      FROM cust_result
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim, statis_calib,
           indx_code, curnt_val, term_last_val, persn_legal_bk_code
      FROM debit_card_result;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_new_cust_rule;