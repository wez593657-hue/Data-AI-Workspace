CREATE OR REPLACE PROCEDURE pro_dwd_crm_customer(
    p_customer_id IN VARCHAR(50),
    p_customer_name IN VARCHAR(200),
    p_customer_code IN VARCHAR(50),
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
    IF p_customer_id IS NULL OR p_customer_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'customer_id不能为空';
        RAISE NOTICE '参数检查失败: customer_id为空';
        RETURN;
    END IF;

    IF p_customer_name IS NULL OR p_customer_name = '' THEN
        p_result_code := -1;
        p_result_msg := 'customer_name不能为空';
        RAISE NOTICE '参数检查失败: customer_name为空';
        RETURN;
    END IF;

    IF p_customer_code IS NULL OR p_customer_code = '' THEN
        p_result_code := -1;
        p_result_msg := 'customer_code不能为空';
        RAISE NOTICE '参数检查失败: customer_code为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dwd_crm_customer 开始执行';
    RAISE NOTICE '目标表: dwd_crm_customer (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_crm_customer (
            customer_id,
            customer_name,
            customer_code,
            customer_type,
            customer_status,
            industry,
            region,
            contact_phone,
            contact_email,
            etl_time,
            etl_batch_id,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_customer_id,
            p_customer_name,
            p_customer_code,
            p_customer_type,
            p_customer_status,
            p_industry,
            p_region,
            p_contact_phone,
            p_contact_email,
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
    RAISE NOTICE '存储过程 pro_dwd_crm_customer 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
