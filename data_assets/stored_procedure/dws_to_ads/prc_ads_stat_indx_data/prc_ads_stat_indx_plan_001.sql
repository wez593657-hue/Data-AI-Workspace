------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_001
-- 功能说明: 指标数据统计（写入营销活动/目标任务范围并记录执行日志）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（写入行数）
-- 需求版本: 【待确认】（原文件无头部，未提供版本信息）
-- 变更记录: 【待确认】（原文件无头部，未提供变更记录）
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_001(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    outcde OUT INTEGER        -- 写入行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤11处理完成 1';
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_001';
    V_LOG_MSG    VARCHAR2(4000);
    V_LOG_FLG    INTEGER;
    V_LOG_BUTTON INTEGER := 1;
    V_NO_ID      VARCHAR2(10);
    V_BGN_DATE   DATE;
    V_END_DATE   DATE;
    V_DURA_DATE  INTEGER;
    V_NEXT_DAY   VARCHAR2(8);  -- 次日（用于开始前一天判断）
BEGIN
    -------------------------------------------------------------------------
    -- 标准模板：参数校验与开始日志状态
    -------------------------------------------------------------------------
    V_NO_ID  := '0';
    V_BGN_DATE := SYSDATE;

    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');

    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_NEXT_DAY := sys_fun_deal_date(v_sysdat, 31);

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

    -------------------------------------------------------------------------
    -- 提交与执行日志记录
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;
    COMMIT;
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    V_LOG_MSG   := '步骤1处理完成，行数=' || NVL(outcde, 0);
    V_LOG_FLG   := 0;
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -------------------------------------------------------------------------
    -- 异常处理：回滚并记录错误日志后重抛
    -------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        outcde := -1;
        V_END_DATE  := SYSDATE;
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
        V_LOG_MSG   := SUBSTR(SQLERRM, 1, 1000);
        V_LOG_FLG   := -1;
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
        RAISE;
END prc_ads_stat_indx_plan_001;