CREATE OR REPLACE PROCEDURE pro_dws_crm_customer_daily(
    p_stat_date IN DATE,
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
    IF p_stat_date IS NULL OR p_stat_date = '' THEN
        p_result_code := -1;
        p_result_msg := 'stat_date不能为空';
        RAISE NOTICE '参数检查失败: stat_date为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dws_crm_customer_daily 开始执行';
    RAISE NOTICE '目标表: dws_crm_customer_daily (DWS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dws_crm_customer_daily (
            stat_date,
            total_count,
            active_count,
            inactive_count,
            personal_count,
            enterprise_count,
            new_add_count,
            lost_count,
            avg_region_count,
            etl_time,
            etl_batch_id,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_stat_date,
            p_total_count,
            p_active_count,
            p_inactive_count,
            p_personal_count,
            p_enterprise_count,
            p_new_add_count,
            p_lost_count,
            p_avg_region_count,
            p_etl_time,
            p_etl_batch_id,
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
    RAISE NOTICE '存储过程 pro_dws_crm_customer_daily 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
