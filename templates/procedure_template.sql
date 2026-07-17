/*
 * 存储过程模板
 * 参考文档: docs/05_Stored_Procedure.md
 * 
 * 事务处理说明:
 * - Kingbase/PostgreSQL 的 PL/pgSQL 中，EXCEPTION 块会自动回滚到进入块之前的状态
 * - 本模板使用外部事务控制模式，由调用方管理事务的 BEGIN/COMMIT/ROLLBACK
 * - 如果需要在存储过程内部管理事务，请使用 BEGIN TRANSACTION/COMMIT/ROLLBACK 语句
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

        p_result_code := 0;
        p_result_msg := '[操作]成功';

    EXCEPTION
        -- ====================
        -- 步骤 4: 异常处理
        -- ====================
        -- PL/pgSQL EXCEPTION 块会自动回滚到进入块之前的状态
        WHEN NO_DATA_FOUND THEN
            p_result_code := -3;
            p_result_msg := '数据不存在';
            RAISE NOTICE '异常发生: 数据不存在';
        
        WHEN UNIQUE_VIOLATION THEN
            p_result_code := -4;
            p_result_msg := '数据已存在';
            RAISE NOTICE '异常发生: 数据已存在';
        
        WHEN OTHERS THEN
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
    RAISE NOTICE '存储过程 proc_[模块名]_[操作名] 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
