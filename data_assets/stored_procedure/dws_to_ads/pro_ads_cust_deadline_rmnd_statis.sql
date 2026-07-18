CREATE OR REPLACE PROCEDURE pro_ads_cust_deadline_rmnd_statis(
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
    RAISE NOTICE '存储过程 pro_ads_cust_deadline_rmnd_statis 开始执行';
    RAISE NOTICE '目标表: ads_cust_deadline_rmnd_statis (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_cust_deadline_rmnd_statis (
            data_date,
            statis_obj,
            statis_cycle,
            statis_typ,
            expr_cust_cnt,
            ttl_expr_cust_cnt,
            expr_amt,
            ttl_expr_amt,
            cust_undtake_rate,
            asset_keep_rate,
            asset_undtake_rate,
            depo_to_fin_convrs_rate,
            insur_convrs_rate,
            fin_to_depo_convrs_rate,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_data_date,
            p_statis_obj,
            p_statis_cycle,
            p_statis_typ,
            p_expr_cust_cnt,
            p_ttl_expr_cust_cnt,
            p_expr_amt,
            p_ttl_expr_amt,
            p_cust_undtake_rate,
            p_asset_keep_rate,
            p_asset_undtake_rate,
            p_depo_to_fin_convrs_rate,
            p_insur_convrs_rate,
            p_fin_to_depo_convrs_rate,
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
    RAISE NOTICE '存储过程 pro_ads_cust_deadline_rmnd_statis 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
