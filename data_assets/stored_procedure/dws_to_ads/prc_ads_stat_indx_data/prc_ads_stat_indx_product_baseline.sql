CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_product_baseline(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    o_row_cnt OUT INTEGER     -- 处理行数
) AS
BEGIN
    -------------------------------------------------------------------------
    -- 营销活动路径（A）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin)
               WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END) - MAX(bs.base_loan_bal)
           END,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin)
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
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id             = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
       AND b.data_date           = v_sysdat
     WHERE s.path_code = 'A'
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 目标任务路径（B）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin)
               WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END) - MAX(bs.base_loan_bal)
           END,
           CASE s.indx_code
               WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin)
               WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)
               WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin)
               WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin)
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
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id             = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
       AND b.data_date           = v_sysdat
     WHERE s.path_code = 'B'
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0058','INDX_0059','INDX_0062')
    GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 个人理财产品销量 INDX_0057 - 营销活动路径（A）
    -- 仅统计ISSU_DATE为8位且位于活动开始日至跑批日期内的购买确认金额。
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim,
               s.indx_code,
               s.data_blng,
               s.term_begin_date,
               ti.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON ti.mkt_act_id          = s.statis_dim
           AND ti.persn_legal_bk_code = s.persn_legal_bk_code
           AND ti.data_date           = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))
         WHERE s.path_code = 'A'
           AND s.indx_code = 'INDX_0057'
    ),
    scope_member_distinct AS (
        SELECT DISTINCT sm.statis_dim,
               sm.indx_code,
               sm.data_blng,
               sm.term_begin_date,
               sm.cust_id,
               sm.persn_legal_bk_code
          FROM scope_member sm
    )
    SELECT 'A',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '营销活动',
           'INDX_0057',
           SUM(NVL(f.cfm_amt, 0)),
           0,
           sm.persn_legal_bk_code
      FROM scope_member_distinct sm
     INNER JOIN DWD_ACCT_FIN f
        ON f.cust_id             = sm.cust_id
       AND f.persn_legal_bk_code = sm.persn_legal_bk_code
       AND LENGTH(f.issu_date) = 8
       AND f.issu_date BETWEEN sm.term_begin_date AND v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 代销理财产品销量 INDX_0060 - 营销活动路径（A）
    -- 仅统计产品大类为1、2，且ISSU_DATE为8位、位于活动窗口内的购买确认金额。
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim,
               s.data_blng,
               s.term_begin_date,
               ti.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON ti.mkt_act_id          = s.statis_dim
           AND ti.persn_legal_bk_code = s.persn_legal_bk_code
           AND ti.data_date           = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))
         WHERE s.path_code = 'A'
           AND s.indx_code = 'INDX_0060'
    ),
    scope_member_distinct AS (
        SELECT DISTINCT sm.statis_dim,
               sm.data_blng,
               sm.term_begin_date,
               sm.cust_id,
               sm.persn_legal_bk_code
          FROM scope_member sm
    )
    SELECT 'A',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '营销活动',
           'INDX_0060',
           SUM(NVL(f.cfm_amt, 0)),
           0,
           sm.persn_legal_bk_code
      FROM scope_member_distinct sm
     INNER JOIN DWD_ACCT_FIN f
        ON f.cust_id             = sm.cust_id
       AND f.persn_legal_bk_code = sm.persn_legal_bk_code
       AND f.prdkt_cate_big IN ('1', '2')
       AND LENGTH(f.issu_date) = 8
       AND f.issu_date BETWEEN sm.term_begin_date AND v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 个人理财产品销量 INDX_0057 - 目标任务路径（B）
    -- 仅统计ISSU_DATE为8位且位于任务开始日至跑批日期内的购买确认金额。
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim,
               s.indx_code,
               s.data_blng,
               s.term_begin_date,
               lv.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.blng_type            = 'O'
           AND lv.org_id              = s.blng_id
           AND lv.persn_legal_bk_code = s.persn_legal_bk_code
           AND lv.data_date           = v_sysdat
         WHERE s.path_code = 'B'
           AND s.indx_code = 'INDX_0057'

        UNION

        SELECT s.statis_dim,
               s.indx_code,
               s.data_blng,
               s.term_begin_date,
               cm.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_CUST_MAN cm
            ON s.blng_type            = 'M'
           AND cm.mngr_post_id        = s.blng_id
           AND cm.mng_typ             = '1'
           AND cm.persn_legal_bk_code = s.persn_legal_bk_code
         WHERE s.path_code = 'B'
           AND s.indx_code = 'INDX_0057'
    ),
    scope_member_distinct AS (
        SELECT DISTINCT sm.statis_dim,
               sm.indx_code,
               sm.data_blng,
               sm.term_begin_date,
               sm.cust_id,
               sm.persn_legal_bk_code
          FROM scope_member sm
    )
    SELECT 'B',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '目标任务',
           'INDX_0057',
           SUM(NVL(f.cfm_amt, 0)),
           0,
           sm.persn_legal_bk_code
      FROM scope_member_distinct sm
     INNER JOIN DWD_ACCT_FIN f
        ON f.cust_id             = sm.cust_id
       AND f.persn_legal_bk_code = sm.persn_legal_bk_code
       AND LENGTH(f.issu_date) = 8
       AND f.issu_date BETWEEN sm.term_begin_date AND v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 代销理财产品销量 INDX_0060 - 目标任务路径（B）
    -- 仅统计产品大类为1、2，且ISSU_DATE为8位、位于任务窗口内的购买确认金额。
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim,
               s.data_blng,
               s.term_begin_date,
               lv.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.blng_type            = 'O'
           AND lv.org_id              = s.blng_id
           AND lv.persn_legal_bk_code = s.persn_legal_bk_code
           AND lv.data_date           = v_sysdat
         WHERE s.path_code = 'B'
           AND s.indx_code = 'INDX_0060'

        UNION

        SELECT s.statis_dim,
               s.data_blng,
               s.term_begin_date,
               cm.cust_id,
               s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_CUST_MAN cm
            ON s.blng_type            = 'M'
           AND cm.mngr_post_id        = s.blng_id
           AND cm.mng_typ             = '1'
           AND cm.persn_legal_bk_code = s.persn_legal_bk_code
         WHERE s.path_code = 'B'
           AND s.indx_code = 'INDX_0060'
    ),
    scope_member_distinct AS (
        SELECT DISTINCT sm.statis_dim,
               sm.data_blng,
               sm.term_begin_date,
               sm.cust_id,
               sm.persn_legal_bk_code
          FROM scope_member sm
    )
    SELECT 'B',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '目标任务',
           'INDX_0060',
           SUM(NVL(f.cfm_amt, 0)),
           0,
           sm.persn_legal_bk_code
      FROM scope_member_distinct sm
     INNER JOIN DWD_ACCT_FIN f
        ON f.cust_id             = sm.cust_id
       AND f.persn_legal_bk_code = sm.persn_legal_bk_code
       AND f.prdkt_cate_big IN ('1', '2')
       AND LENGTH(f.issu_date) = 8
       AND f.issu_date BETWEEN sm.term_begin_date AND v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_product_baseline;
