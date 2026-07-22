CREATE OR REPLACE PROCEDURE pro_ads_stat_indx_data(
    p_data_date IN VARCHAR(8),
    p_result_code OUT INT,
    p_result_msg OUT VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP := NOW();
    v_end_time TIMESTAMP;
    v_duration INTERVAL;
BEGIN
    -- ====================
    -- 步骤 1: 参数检查
    -- ====================
    IF p_data_date IS NULL OR p_data_date = '' THEN
        p_result_code := -1;
        p_result_msg := 'data_date不能为空';
        RAISE NOTICE '参数检查失败: data_date为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_ads_stat_indx_data 开始执行';
    RAISE NOTICE '目标表: ads_stat_indx_data (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_stat_indx_data (
            data_date,
            blng_brch,
            blng_brch_sub,
            blng_brch_net,
            org_path,
            cust_lvl,
            cust_cnt,
            aum_bal,
            aum_mth_avg,
            comn_fixd_bal,
            lehui_bal,
            largedp_bal,
            fixd_sum,
            depo_curnt_depo_bal,
            depo_sum,
            biz_self_fin_bal,
            proxy_sell_fin_bal,
            fin_bal_sum,
            insur_bal,
            loan_bal,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_data_date,
            p_blng_brch,
            p_blng_brch_sub,
            p_blng_brch_net,
            p_org_path,
            p_cust_lvl,
            p_cust_cnt,
            p_aum_bal,
            p_aum_mth_avg,
            p_comn_fixd_bal,
            p_lehui_bal,
            p_largedp_bal,
            p_fixd_sum,
            p_depo_curnt_depo_bal,
            p_depo_sum,
            p_biz_self_fin_bal,
            p_proxy_sell_fin_bal,
            p_fin_bal_sum,
            p_insur_bal,
            p_loan_bal,
            NOW(),
            NOW(),
            CURRENT_USER,
            CURRENT_USER
        );

        IF NOT FOUND THEN
            p_result_code := -3;
            p_result_msg := '数据插入失败';
            RAISE NOTICE '数据插入失败';
            RETURN;
        END IF;

        -- 提交事务
        COMMIT;

        p_result_code := 0;
        p_result_msg := '执行成功';

    EXCEPTION
        -- ====================
        -- 步骤 4: 异常处理
        -- ====================
        WHEN UNIQUE_VIOLATION THEN
            ROLLBACK;
            p_result_code := -4;
            p_result_msg := '数据已存在';
            RAISE NOTICE '异常发生: 数据已存在';
            RETURN;
        
        WHEN OTHERS THEN
            ROLLBACK;
            p_result_code := SQLSTATE;
            p_result_msg := SQLERRM;
            RAISE NOTICE '异常发生: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;
            RETURN;
    END;

    -- ====================
    -- 步骤 5: 日志结束
    -- ====================
    v_end_time := NOW();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE '存储过程 pro_ads_stat_indx_data 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
