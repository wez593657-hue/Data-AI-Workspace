CREATE OR REPLACE PROCEDURE pro_dwd_tx_aset(
    p_seq_id IN VARCHAR(40),
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
    IF p_seq_id IS NULL OR p_seq_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'seq_id不能为空';
        RAISE NOTICE '参数检查失败: seq_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dwd_tx_aset 开始执行';
    RAISE NOTICE '目标表: dwd_tx_aset (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_tx_aset (
            seq_id,
            cust_id,
            cust_typ,
            acct_id,
            prdkt_cate_big,
            prdkt_id,
            tx_chnl,
            tx_date,
            tx_time,
            ccy_cd,
            tx_typ,
            amt,
            tx_typ_name,
            tx_org,
            oprtr,
            loan_flg,
            acct_bal,
            tx_dsc,
            opnt_acct,
            opnt_acct_name_fst,
            opnt_bk_keep,
            opnt_name_bk,
            fee_hand,
            acct_blng_org,
            card_no,
            persn_legal_bk_code,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_seq_id,
            p_cust_id,
            p_cust_typ,
            p_acct_id,
            p_prdkt_cate_big,
            p_prdkt_id,
            p_tx_chnl,
            p_tx_date,
            p_tx_time,
            p_ccy_cd,
            p_tx_typ,
            p_amt,
            p_tx_typ_name,
            p_tx_org,
            p_oprtr,
            p_loan_flg,
            p_acct_bal,
            p_tx_dsc,
            p_opnt_acct,
            p_opnt_acct_name_fst,
            p_opnt_bk_keep,
            p_opnt_name_bk,
            p_fee_hand,
            p_acct_blng_org,
            p_card_no,
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
    RAISE NOTICE '存储过程 pro_dwd_tx_aset 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
