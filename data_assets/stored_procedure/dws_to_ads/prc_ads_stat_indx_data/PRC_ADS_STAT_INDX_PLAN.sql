CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan(
    v_sysdat IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    outcde   OUT INTEGER     -- 0=成功, -1=失败
) AS
    V_PRC_DESC   VARCHAR2(100)  := '指标数据统计';
    V_PRC_NAME   VARCHAR2(32)   := 'PRC_ADS_STAT_INDX_DATA';
    V_LOG_MSG    VARCHAR2(4000);
    V_LOG_BUTTON INTEGER        := 1;
    V_NO_ID      VARCHAR2(10);
    V_BGN_DATE   DATE;
    V_END_DATE   DATE;
    V_DURA_DATE  INTEGER;
    V_ROW_COUNT  INTEGER;
BEGIN
    -------------------------------------------------------------------------
    -- 输入参数强校验
    -------------------------------------------------------------------------
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
        outcde := -1;
        RAISE_APPLICATION_ERROR(-20001,
            '入参 V_SYSDAT 必须为 8 位数字 YYYYMMDD 格式');
    END IF;

    BEGIN
        V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');
    EXCEPTION
        WHEN OTHERS THEN
            outcde := -1;
            RAISE_APPLICATION_ERROR(-20001,
                '入参 V_SYSDAT 并非合法的自然日日期: ' || v_sysdat);
    END;

    -------------------------------------------------------------------------
    -- 步骤1：清空临时表
    -------------------------------------------------------------------------
    V_NO_ID    := '1';
    V_BGN_DATE := SYSDATE;

    LOCK TABLE TMP_STAT_INDX_SCOPE      IN ACCESS EXCLUSIVE MODE NOWAIT;
    LOCK TABLE TMP_STAT_INDX_BAL_AGGR   IN ACCESS EXCLUSIVE MODE NOWAIT;
    LOCK TABLE TMP_STAT_INDX_CUST_STATE IN ACCESS EXCLUSIVE MODE NOWAIT;
    LOCK TABLE TMP_STAT_INDX_AGGR       IN ACCESS EXCLUSIVE MODE NOWAIT;

    DELETE FROM TMP_STAT_INDX_SCOPE;
    DELETE FROM TMP_STAT_INDX_BAL_AGGR;
    DELETE FROM TMP_STAT_INDX_CUST_STATE;
    DELETE FROM TMP_STAT_INDX_AGGR;

    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '步骤1完成：临时表清空完毕', 0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤2：构建统计范围
    -------------------------------------------------------------------------
    V_NO_ID    := '2';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_build_scope(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '步骤2完成：统计范围构建完毕，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤3：期初基准冻结
    -------------------------------------------------------------------------
    V_NO_ID    := '3';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_freeze_baseline(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '步骤3完成：期初基准冻结完毕', 0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤4：AUM余额增量模块
    -------------------------------------------------------------------------
    V_NO_ID    := '4';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_aum_balance(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          'AUM余额增量模块完成，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤5：理财产品指标模块
    -------------------------------------------------------------------------
    V_NO_ID    := '5';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_product_baseline(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '理财产品指标模块完成，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤6：客户等级提升模块
    -------------------------------------------------------------------------
    V_NO_ID    := '6';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_cust_upgrade(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '客户等级提升模块完成，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤6B：事件行为计数模块
    -------------------------------------------------------------------------
    V_NO_ID    := '6B';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_event_count(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '事件行为计数模块完成，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤6C1：新客规则指标模块
    -------------------------------------------------------------------------
    V_NO_ID    := '6C1';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_new_cust_rule(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '新客规则指标模块完成，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤6C2：留存率计算模块
    -------------------------------------------------------------------------
    V_NO_ID    := '6C2';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_retention_rate(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '留存率计算模块完成，行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 步骤7：机构树上卷与最终发布
    -------------------------------------------------------------------------
    V_NO_ID    := '7';
    V_BGN_DATE := SYSDATE;
    prc_ads_stat_indx_org_rollup_publish(v_sysdat, V_ROW_COUNT);
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);
    BEGIN
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
                          V_BGN_DATE, V_END_DATE, V_DURA_DATE,
                          '机构树上卷与目标表发布完成，总行数=' || NVL(V_ROW_COUNT, 0),
                          0, V_LOG_BUTTON);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -------------------------------------------------------------------------
    -- 提交事务
    -------------------------------------------------------------------------
    outcde := 0;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        outcde    := -1;
        V_LOG_MSG := '主过程异常中断 [步骤:' || NVL(V_NO_ID, 'N/A') || ']: ' || SQLERRM;
        BEGIN
            SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC,
                              NVL(V_NO_ID, 'ERR'), NVL(V_BGN_DATE, SYSDATE),
                              SYSDATE, 0, V_LOG_MSG, -1, V_LOG_BUTTON);
            COMMIT;
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20099, V_LOG_MSG);
END prc_ads_stat_indx_plan;
