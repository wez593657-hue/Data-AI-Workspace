CREATE OR REPLACE PROCEDURE pro_dwd_acct_depo_his(
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


    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dwd_acct_depo_his 开始执行';
    RAISE NOTICE '目标表: dwd_acct_depo_his (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_acct_depo_his (
            cust_id,
            cust_typ,
            acct_id,
            card_no,
            prdkt_id,
            prdkt_name,
            prdkt_cate_big,
            acct_typ,
            ccy_cd,
            bal,
            rmb_bal,
            open_acct_org,
            open_date,
            rate_intri,
            intri_bgn_date,
            expr_date,
            acct_cloz_date,
            acct_state,
            persn_legal_bk_code,
            vchr_typ,
            cunq,
            fix_curnt_flg,
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
            p_acct_typ,
            p_ccy_cd,
            p_bal,
            p_rmb_bal,
            p_open_acct_org,
            p_open_date,
            p_rate_intri,
            p_intri_bgn_date,
            p_expr_date,
            p_acct_cloz_date,
            p_acct_state,
            p_persn_legal_bk_code,
            p_vchr_typ,
            p_cunq,
            p_fix_curnt_flg,
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
    RAISE NOTICE '存储过程 pro_dwd_acct_depo_his 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
