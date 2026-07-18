CREATE OR REPLACE PROCEDURE pro_dws_cust_capital_rmnd(
    p_rmnd_id IN VARCHAR(40),
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
    IF p_rmnd_id IS NULL OR p_rmnd_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'rmnd_id不能为空';
        RAISE NOTICE '参数检查失败: rmnd_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dws_cust_capital_rmnd 开始执行';
    RAISE NOTICE '目标表: dws_cust_capital_rmnd (DWS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dws_cust_capital_rmnd (
            rmnd_id,
            mngr_post_id,
            mngr_name,
            cust_id,
            cust_typ,
            cust_name,
            acct_no,
            hapn_bal,
            org_id,
            phone_no,
            hdle_state,
            dc_flag,
            rmnd_time,
            tx_chnl,
            opnt_bk_keep,
            opnt_name,
            persn_legal_bk_code,
            hdle_time,
            remark,
            cust_lvl,
            rmnd_inf,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_rmnd_id,
            p_mngr_post_id,
            p_mngr_name,
            p_cust_id,
            p_cust_typ,
            p_cust_name,
            p_acct_no,
            p_hapn_bal,
            p_org_id,
            p_phone_no,
            p_hdle_state,
            p_dc_flag,
            p_rmnd_time,
            p_tx_chnl,
            p_opnt_bk_keep,
            p_opnt_name,
            p_persn_legal_bk_code,
            p_hdle_time,
            p_remark,
            p_cust_lvl,
            p_rmnd_inf,
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
    RAISE NOTICE '存储过程 pro_dws_cust_capital_rmnd 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
