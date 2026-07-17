/*
 * 存储过程模板
 * 参考文档: docs/05_Stored_Procedure.md
 */

CREATE OR REPLACE PROCEDURE proc_[模块名]_[操作名](
    p_[参数名] IN [数据类型],
    p_[参数名] IN [数据类型],
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
    IF p_[参数名] IS NULL OR p_[参数名] = '' THEN
        p_result_code := -1;
        p_result_msg := '[参数名]不能为空';
        RAISE NOTICE '参数检查失败: [参数名]为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 proc_[模块名]_[操作名] 开始执行';
    RAISE NOTICE '输入参数: [参数]=%', p_[参数名];

    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- [业务逻辑]

        -- ====================
        -- 步骤 4: 事务提交
        -- ====================
        COMMIT;

        p_result_code := 0;
        p_result_msg := '[操作]成功';

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
    RAISE NOTICE '存储过程 proc_[模块名]_[操作名] 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
