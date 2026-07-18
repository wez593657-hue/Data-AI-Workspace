CREATE OR REPLACE PROCEDURE pro_dws_cust_asse_liab_cumu_his(
    p_data_date IN VARCHAR(8),
    p_cust_id IN VARCHAR(20),
    p_acct_id IN VARCHAR(40),
    p_prdkt_id IN VARCHAR(40),
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

    IF p_cust_id IS NULL OR p_cust_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'cust_id不能为空';
        RAISE NOTICE '参数检查失败: cust_id为空';
        RETURN;
    END IF;

    IF p_acct_id IS NULL OR p_acct_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'acct_id不能为空';
        RAISE NOTICE '参数检查失败: acct_id为空';
        RETURN;
    END IF;

    IF p_prdkt_id IS NULL OR p_prdkt_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'prdkt_id不能为空';
        RAISE NOTICE '参数检查失败: prdkt_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dws_cust_asse_liab_cumu_his 开始执行';
    RAISE NOTICE '目标表: dws_cust_asse_liab_cumu_his (DWS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dws_cust_asse_liab_cumu_his (
            data_date,
            cust_id,
            acct_id,
            prdkt_id,
            prdkt_cate_big,
            prdkt_typ,
            bal,
            mth_bal,
            qrt_bal,
            yar_bal,
            mth_days,
            qrt_days,
            yar_days,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_data_date,
            p_cust_id,
            p_acct_id,
            p_prdkt_id,
            p_prdkt_cate_big,
            p_prdkt_typ,
            p_bal,
            p_mth_bal,
            p_qrt_bal,
            p_yar_bal,
            p_mth_days,
            p_qrt_days,
            p_yar_days,
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
    RAISE NOTICE '存储过程 pro_dws_cust_asse_liab_cumu_his 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
