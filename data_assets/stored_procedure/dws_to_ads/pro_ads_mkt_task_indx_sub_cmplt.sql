CREATE OR REPLACE PROCEDURE pro_ads_mkt_task_indx_sub_cmplt(
    p_tsk_indx_id IN VARCHAR(40),
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
    IF p_tsk_indx_id IS NULL OR p_tsk_indx_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'tsk_indx_id不能为空';
        RAISE NOTICE '参数检查失败: tsk_indx_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_ads_mkt_task_indx_sub_cmplt 开始执行';
    RAISE NOTICE '目标表: ads_mkt_task_indx_sub_cmplt (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_mkt_task_indx_sub_cmplt (
            tsk_indx_id,
            tsk_id,
            main_tsk_id,
            indx_id,
            tsk_next_send_typ,
            rsv_obj,
            rsv_obj_id,
            tsk_bgn_date,
            tsk_end_date,
            indx_unit,
            indx_val,
            indx_val_add,
            acum_cmplt_indx,
            day_curnt_cmplt_indx,
            base_val,
            curnt_val,
            persn_legal_bk_code,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_tsk_indx_id,
            p_tsk_id,
            p_main_tsk_id,
            p_indx_id,
            p_tsk_next_send_typ,
            p_rsv_obj,
            p_rsv_obj_id,
            p_tsk_bgn_date,
            p_tsk_end_date,
            p_indx_unit,
            p_indx_val,
            p_indx_val_add,
            p_acum_cmplt_indx,
            p_day_curnt_cmplt_indx,
            p_base_val,
            p_curnt_val,
            p_persn_legal_bk_code,
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
    RAISE NOTICE '存储过程 pro_ads_mkt_task_indx_sub_cmplt 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
