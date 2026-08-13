CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_event_count(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    o_row_cnt OUT INTEGER     -- 处理行数
) AS
    V_MTH_BEGIN VARCHAR2(8);   -- 当月月初
BEGIN
    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_MTH_BEGIN := sys_fun_deal_date(v_sysdat, 9);

    -------------------------------------------------------------------------
    -- 7.1 保险新保保费 INDX_0061（A路径）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim, s.data_blng, s.term_begin_date,
               ti.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON ti.mkt_act_id           = s.statis_dim
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code
           AND ti.data_date            = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))
         WHERE s.path_code = 'A'
           AND s.indx_code = 'INDX_0061'
    )
    SELECT 'A', v_sysdat, sm.data_blng, sm.statis_dim, '营销活动', 'INDX_0061',
           SUM(NVL(i.new_insur_amt, 0)), 0, sm.persn_legal_bk_code
      FROM (SELECT DISTINCT statis_dim, data_blng, term_begin_date,
                   cust_id, persn_legal_bk_code
              FROM scope_member) sm
     INNER JOIN DWD_ACCT_INSUR i
        ON i.cust_id             = sm.cust_id
       AND i.persn_legal_bk_code = sm.persn_legal_bk_code
       AND i.policy_state        = '1'
       AND i.tx_date             >= sm.term_begin_date
       AND i.tx_date             <= v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 7.2 保险新保保费 INDX_0061（B路径）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim, s.data_blng, s.term_begin_date,
               lv.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.blng_type             = 'O'
           AND lv.org_id               = s.blng_id
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code
           AND lv.data_date            = v_sysdat
         WHERE s.path_code = 'B' AND s.indx_code = 'INDX_0061'

        UNION

        SELECT s.statis_dim, s.data_blng, s.term_begin_date,
               cm.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_CUST_MAN cm
            ON s.blng_type             = 'M'
           AND cm.mngr_post_id         = s.blng_id
           AND cm.mng_typ              = '1'
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code
         WHERE s.path_code = 'B' AND s.indx_code = 'INDX_0061'
    )
    SELECT 'B', v_sysdat, sm.data_blng, sm.statis_dim, '目标任务', 'INDX_0061',
           SUM(NVL(i.new_insur_amt, 0)), 0, sm.persn_legal_bk_code
      FROM (SELECT DISTINCT statis_dim, data_blng, term_begin_date,
                   cust_id, persn_legal_bk_code
              FROM scope_member) sm
     INNER JOIN DWD_ACCT_INSUR i
        ON i.cust_id             = sm.cust_id
       AND i.persn_legal_bk_code = sm.persn_legal_bk_code
       AND i.policy_state        = '1'
       AND i.tx_date             >= sm.term_begin_date
       AND i.tx_date             <= v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 7.3 手机银行月活 INDX_0067（A路径）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim, s.data_blng,
               ti.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_MKT_TSK_INFO ti
            ON ti.mkt_act_id           = s.statis_dim
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code
           AND ti.data_date            = v_sysdat
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))
         WHERE s.path_code = 'A' AND s.indx_code = 'INDX_0067'
    )
    SELECT 'A', v_sysdat, sm.data_blng, sm.statis_dim, '营销活动', 'INDX_0067',
           COUNT(DISTINCT mi.cust_core_no), 0, sm.persn_legal_bk_code
      FROM scope_member sm
     INNER JOIN mbk_cust_info mi
        ON mi.cust_core_no = sm.cust_id 
       AND mi.cust_status = '1'
     INNER JOIN mbk_cust_log_login l
        ON l.cust_no    = mi.cust_no
       AND l.lgn_status = '1'
     WHERE l.lgn_date >= SUBSTR(V_MTH_BEGIN, 1, 4) || '-' || SUBSTR(V_MTH_BEGIN, 5, 2) || '-' || SUBSTR(V_MTH_BEGIN, 7, 2)
       AND l.lgn_date <= SUBSTR(v_sysdat, 1, 4)    || '-' || SUBSTR(v_sysdat, 5, 2)    || '-' || SUBSTR(v_sysdat, 7, 2)
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    -------------------------------------------------------------------------
    -- 7.4 手机银行月活 INDX_0067（B路径）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR (
        path_code, data_date, data_blng, statis_dim, statis_calib,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    WITH scope_member AS (
        SELECT s.statis_dim, s.data_blng,
               lv.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWS_CUST_LVL_INFO lv
            ON s.blng_type             = 'O'
           AND lv.org_id               = s.blng_id
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code
           AND lv.data_date            = v_sysdat
         WHERE s.path_code = 'B' AND s.indx_code = 'INDX_0067'

        UNION

        SELECT s.statis_dim, s.data_blng,
               cm.cust_id, s.persn_legal_bk_code
          FROM TMP_STAT_INDX_SCOPE s
         INNER JOIN DWD_CUST_MAN cm
            ON s.blng_type             = 'M'
           AND cm.mngr_post_id         = s.blng_id
           AND cm.mng_typ              = '1'
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code
         WHERE s.path_code = 'B' AND s.indx_code = 'INDX_0067'
    )
    SELECT 'B', v_sysdat, sm.data_blng, sm.statis_dim, '目标任务', 'INDX_0067',
           COUNT(DISTINCT mi.cust_core_no), 0, sm.persn_legal_bk_code
      FROM scope_member sm
     INNER JOIN mbk_cust_info mi
        ON mi.cust_core_no = sm.cust_id AND mi.cust_status = '1'
     INNER JOIN mbk_cust_log_login l
        ON l.cust_no    = mi.cust_no
       AND l.lgn_status = '1'
     WHERE l.lgn_date >= SUBSTR(V_MTH_BEGIN, 1, 4) || '-' || SUBSTR(V_MTH_BEGIN, 5, 2) || '-' || SUBSTR(V_MTH_BEGIN, 7, 2)
       AND l.lgn_date <= SUBSTR(v_sysdat, 1, 4)    || '-' || SUBSTR(v_sysdat, 5, 2)    || '-' || SUBSTR(v_sysdat, 7, 2)
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_event_count;