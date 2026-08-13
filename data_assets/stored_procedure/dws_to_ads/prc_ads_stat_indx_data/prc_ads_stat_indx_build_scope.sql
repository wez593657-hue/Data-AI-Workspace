CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_build_scope(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    o_row_cnt OUT INTEGER     -- 写入行数
) AS
    V_NEXT_DAY VARCHAR2(8);   -- 次日（用于开始前一天判断）
BEGIN
    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_NEXT_DAY := sys_fun_deal_date(v_sysdat, 28);

    -------------------------------------------------------------------------
    -- 路径A：营销活动范围写入
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_SCOPE (
        path_code, statis_dim, indx_code, data_blng,
        blng_type, blng_id, term_begin_date, persn_legal_bk_code
    )
    SELECT DISTINCT
           'A'                          AS path_code,
           a.mkt_act_id                 AS statis_dim,
           t.indx_id                    AS indx_code,
           'ORG_' || ti.mkt_persn_org   AS data_blng,
           'O'                          AS blng_type,
           ti.mkt_persn_org             AS blng_id,
           a.act_bgn_date               AS term_begin_date,
           ti.persn_legal_bk_code       AS persn_legal_bk_code
      FROM DWD_MKT_ACT_INFO a
     INNER JOIN DWD_MKT_ACT_TARGT t
        ON t.mkt_act_id = a.mkt_act_id
     INNER JOIN DWD_MKT_TSK_INFO ti
        ON ti.mkt_act_id          = a.mkt_act_id
       AND ti.mkt_persn_org       = t.prtspt_org
       AND ti.persn_legal_bk_code = a.persn_legal_bk_code
       AND ti.data_date           = v_sysdat
     WHERE a.act_bgn_date                      <= V_NEXT_DAY
       AND NVL(a.statis_stop_date, '99991231') >= v_sysdat
       AND a.camp_act_typ IN ('1', '2')
       AND ti.mkt_persn_org IS NOT NULL

    UNION

    SELECT DISTINCT
           'A', a.mkt_act_id, t.indx_id,
           'MGR_' || ti.mkt_persn, 'M', ti.mkt_persn,
           a.act_bgn_date, ti.persn_legal_bk_code
      FROM DWD_MKT_ACT_INFO a
     INNER JOIN DWD_MKT_ACT_TARGT t
        ON t.mkt_act_id = a.mkt_act_id
     INNER JOIN DWD_MKT_TSK_INFO ti
        ON ti.mkt_act_id          = a.mkt_act_id
       AND ti.mkt_persn_org       = t.prtspt_org
       AND ti.persn_legal_bk_code = a.persn_legal_bk_code
       AND ti.data_date           = v_sysdat
     WHERE a.act_bgn_date                      <= V_NEXT_DAY
       AND NVL(a.statis_stop_date, '99991231') >= v_sysdat
       AND a.camp_act_typ IN ('1', '2')
       AND ti.mkt_persn IS NOT NULL;

    -------------------------------------------------------------------------
    -- 路径B：目标任务范围写入
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_SCOPE (
        path_code, statis_dim, indx_code, data_blng,
        blng_type, blng_id, term_begin_date, persn_legal_bk_code
    )
    SELECT DISTINCT
           'B'                          AS path_code,
           it.tsk_id                    AS statis_dim,
           sub.indx_id                  AS indx_code,
           'ORG_' || it.rsv_obj_id      AS data_blng,
           'O'                          AS blng_type,
           it.rsv_obj_id                AS blng_id,
           sub.tsk_bgn_date             AS term_begin_date,
           it.persn_legal_bk_code       AS persn_legal_bk_code
      FROM DWD_MKT_INDX_TSK it
     INNER JOIN DWD_MKT_TSK_INDX_SUB sub
        ON sub.tsk_id              = it.tsk_id
       AND sub.persn_legal_bk_code = it.persn_legal_bk_code
     WHERE it.rsv_obj                            = '0'
       AND sub.tsk_bgn_date                      <= V_NEXT_DAY
       AND NVL(sub.tsk_end_date, '99991231')     >= v_sysdat

    UNION

    SELECT DISTINCT
           'B', it.tsk_id, sub.indx_id,
           'MGR_' || it.rsv_obj_id, 'M', it.rsv_obj_id,
           sub.tsk_bgn_date, it.persn_legal_bk_code
      FROM DWD_MKT_INDX_TSK it
     INNER JOIN DWD_MKT_TSK_INDX_SUB sub
        ON sub.tsk_id              = it.tsk_id
       AND sub.persn_legal_bk_code = it.persn_legal_bk_code
     WHERE it.rsv_obj                            = '1'
       AND sub.tsk_bgn_date                      <= V_NEXT_DAY
       AND NVL(sub.tsk_end_date, '99991231')     >= v_sysdat;

    o_row_cnt := SQL%ROWCOUNT;
END prc_ads_stat_indx_build_scope;