CREATE OR REPLACE PROCEDURE pro_ads_crm_customer_report(
    p_report_date IN DATE,
    p_period_type IN VARCHAR(10),
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
    IF p_report_date IS NULL OR p_report_date = '' THEN
        p_result_code := -1;
        p_result_msg := 'report_date不能为空';
        RAISE NOTICE '参数检查失败: report_date为空';
        RETURN;
    END IF;

    IF p_period_type IS NULL OR p_period_type = '' THEN
        p_result_code := -1;
        p_result_msg := 'period_type不能为空';
        RAISE NOTICE '参数检查失败: period_type为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_ads_crm_customer_report 开始执行';
    RAISE NOTICE '目标表: ads_crm_customer_report (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_crm_customer_report (
            report_date,
            period_type,
            total_customer,
            active_customer,
            customer_growth_rate,
            avg_customer_value,
            top_region,
            top_industry,
            monthly_target_achievement,
            etl_batch_id,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_report_date,
            p_period_type,
            p_total_customer,
            p_active_customer,
            p_customer_growth_rate,
            p_avg_customer_value,
            p_top_region,
            p_top_industry,
            p_monthly_target_achievement,
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
    RAISE NOTICE '存储过程 pro_ads_crm_customer_report 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
