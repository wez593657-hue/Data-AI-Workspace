CREATE OR REPLACE PROCEDURE pro_ads_mkt_tsk_info(
    p_mkt_tsk_id IN VARCHAR(40),
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
    IF p_mkt_tsk_id IS NULL OR p_mkt_tsk_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'mkt_tsk_id不能为空';
        RAISE NOTICE '参数检查失败: mkt_tsk_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_ads_mkt_tsk_info 开始执行';
    RAISE NOTICE '目标表: ads_mkt_tsk_info (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_mkt_tsk_info (
            mkt_tsk_id,
            mkt_act_id,
            cust_id,
            cust_name,
            cover_flg,
            convrs_flg,
            mkt_persn,
            mkt_persn_org,
            creatr,
            creat_time,
            creat_org,
            base_val,
            curnt_val,
            data_date,
            persn_legal_bk_code,
            act_dsc,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_mkt_tsk_id,
            p_mkt_act_id,
            p_cust_id,
            p_cust_name,
            p_cover_flg,
            p_convrs_flg,
            p_mkt_persn,
            p_mkt_persn_org,
            p_creatr,
            p_creat_time,
            p_creat_org,
            p_base_val,
            p_curnt_val,
            p_data_date,
            p_persn_legal_bk_code,
            p_act_dsc,
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
    RAISE NOTICE '存储过程 pro_ads_mkt_tsk_info 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
