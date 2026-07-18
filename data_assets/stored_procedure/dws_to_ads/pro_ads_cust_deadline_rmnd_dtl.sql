CREATE OR REPLACE PROCEDURE pro_ads_cust_deadline_rmnd_dtl(
    p_data_date IN 8,
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
    RAISE NOTICE '存储过程 pro_ads_cust_deadline_rmnd_dtl 开始执行';
    RAISE NOTICE '目标表: ads_cust_deadline_rmnd_dtl (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_cust_deadline_rmnd_dtl (
            data_date,
            cust_id,
            cust_name,
            cust_lvl,
            depo_curnt_depo_bal,
            fixd_depo_bal,
            fin_amt,
            stat_perd,
            statis_typ,
            expr_amt,
            mature_ttl_amt,
            take_rate,
            fix_depo_mature_amt,
            fix_depo_mature_ttl_amt,
            fix_depo_take_rate,
            cntct_state,
            undtake_state,
            fixed_fin_mature_tran_insur_amt,
            fin_mature_tran_fixed_amt,
            fixed_mature_tran_fin_amt,
            frst_mature_pk_bf_day_aum_bal,
            last_end_date,
            post_id,
            org_id,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_data_date,
            p_cust_id,
            p_cust_name,
            p_cust_lvl,
            p_depo_curnt_depo_bal,
            p_fixd_depo_bal,
            p_fin_amt,
            p_stat_perd,
            p_statis_typ,
            p_expr_amt,
            p_mature_ttl_amt,
            p_take_rate,
            p_fix_depo_mature_amt,
            p_fix_depo_mature_ttl_amt,
            p_fix_depo_take_rate,
            p_cntct_state,
            p_undtake_state,
            p_fixed_fin_mature_tran_insur_amt,
            p_fin_mature_tran_fixed_amt,
            p_fixed_mature_tran_fin_amt,
            p_frst_mature_pk_bf_day_aum_bal,
            p_last_end_date,
            p_post_id,
            p_org_id,
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
    RAISE NOTICE '存储过程 pro_ads_cust_deadline_rmnd_dtl 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
