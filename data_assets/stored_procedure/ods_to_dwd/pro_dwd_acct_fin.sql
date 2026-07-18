CREATE OR REPLACE PROCEDURE pro_dwd_acct_fin(
    p_cust_id IN VARCHAR(20),
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
    IF p_cust_id IS NULL OR p_cust_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'cust_id不能为空';
        RAISE NOTICE '参数检查失败: cust_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dwd_acct_fin 开始执行';
    RAISE NOTICE '目标表: dwd_acct_fin (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_acct_fin (
            cust_id,
            cust_typ,
            acct_id,
            card_no,
            prdkt_id,
            prdkt_name,
            prdkt_cate_big,
            estab_date,
            fin_amt,
            rate_intri,
            acct_state,
            intri_bgn_date,
            expr_date,
            oprt_org,
            chnl_no,
            persn_legal_bk_code,
            issu_org,
            issu_date,
            risk_lvl,
            cust_id,
            cust_typ,
            acct_id,
            card_no,
            prdkt_id,
            prdkt_name,
            prdkt_cate_big,
            estab_date,
            fin_amt,
            fin_mth_avg,
            fin_qrt_avg,
            fin_yr_avg,
            rate_intri,
            acct_state,
            intri_bgn_date,
            expr_date,
            oprt_org,
            chnl_no,
            persn_legal_bk_code,
            issu_org,
            issu_date,
            risk_lvl,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_cust_id,
            p_cust_typ,
            p_acct_id,
            p_card_no,
            p_prdkt_id,
            p_prdkt_name,
            p_prdkt_cate_big,
            p_estab_date,
            p_fin_amt,
            p_rate_intri,
            p_acct_state,
            p_intri_bgn_date,
            p_expr_date,
            p_oprt_org,
            p_chnl_no,
            p_persn_legal_bk_code,
            p_issu_org,
            p_issu_date,
            p_risk_lvl,
            p_cust_id,
            p_cust_typ,
            p_acct_id,
            p_card_no,
            p_prdkt_id,
            p_prdkt_name,
            p_prdkt_cate_big,
            p_estab_date,
            p_fin_amt,
            p_fin_mth_avg,
            p_fin_qrt_avg,
            p_fin_yr_avg,
            p_rate_intri,
            p_acct_state,
            p_intri_bgn_date,
            p_expr_date,
            p_oprt_org,
            p_chnl_no,
            p_persn_legal_bk_code,
            p_issu_org,
            p_issu_date,
            p_risk_lvl,
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
    RAISE NOTICE '存储过程 pro_dwd_acct_fin 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
