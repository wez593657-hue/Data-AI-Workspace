/*
 * 存储过程示例: 更新客户状态
 * 参考文档: docs/05_Stored_Procedure.md
 */

CREATE OR REPLACE PROCEDURE proc_crm_customer_update_status(
    p_customer_id IN VARCHAR(50),
    p_new_status IN VARCHAR(20),
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
        p_result_msg := '客户ID不能为空';
        RAISE NOTICE '参数检查失败: 客户ID为空';
        RETURN;
    END IF;

    IF p_new_status IS NULL OR p_new_status = '' THEN
        p_result_code := -2;
        p_result_msg := '新状态不能为空';
        RAISE NOTICE '参数检查失败: 新状态为空';
        RETURN;
    END IF;

    IF p_new_status NOT IN ('ACTIVE', 'INACTIVE', 'UNKNOWN') THEN
        p_result_code := -3;
        p_result_msg := '无效的状态值: ' || p_new_status;
        RAISE NOTICE '参数检查失败: 无效状态值 %', p_new_status;
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 proc_crm_customer_update_status 开始执行';
    RAISE NOTICE '输入参数: customer_id=%, new_status=%', p_customer_id, p_new_status;

    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        UPDATE crm_customer 
        SET 
            customer_status = p_new_status,
            update_time = NOW()
        WHERE customer_id = p_customer_id;

        IF NOT FOUND THEN
            p_result_code := -4;
            p_result_msg := '客户不存在: ' || p_customer_id;
            RAISE NOTICE '客户不存在: customer_id=%', p_customer_id;
            RETURN;
        END IF;

        INSERT INTO crm_customer_log (
            customer_id,
            operation_type,
            operation_time,
            operator,
            operation_detail
        ) VALUES (
            p_customer_id,
            'UPDATE_STATUS',
            NOW(),
            CURRENT_USER,
            '状态变更为: ' || p_new_status
        );

        -- ====================
        -- 步骤 4: 事务提交
        -- ====================
        COMMIT;

        p_result_code := 0;
        p_result_msg := '客户状态更新成功';

    EXCEPTION
        -- ====================
        -- 步骤 5: 异常处理
        -- ====================
        WHEN OTHERS THEN
            ROLLBACK;
            p_result_code := SQLSTATE;
            p_result_msg := SQLERRM;
            RAISE NOTICE '异常发生: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;
            RETURN;
    END;

    -- ====================
    -- 步骤 6: 日志结束
    -- ====================
    v_end_time := NOW();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE '存储过程 proc_crm_customer_update_status 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
