CREATE OR REPLACE PROCEDURE pro_ads_mkt_rec_info(
    p_mkt_rec_seq_id IN 40,
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
    IF p_mkt_rec_seq_id IS NULL OR p_mkt_rec_seq_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'mkt_rec_seq_id不能为空';
        RAISE NOTICE '参数检查失败: mkt_rec_seq_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_ads_mkt_rec_info 开始执行';
    RAISE NOTICE '目标表: ads_mkt_rec_info (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_mkt_rec_info (
            mkt_rec_seq_id,
            rel_id,
            mkt_typ,
            rel_typ,
            cust_id,
            cust_name,
            mkt_site,
            mkt_time,
            mkt_persn,
            mkt_persn_name,
            mkt_org,
            mkt_dura,
            mkt_dtl_situ,
            mkt_apdix_id,
            temp_id,
            temp_name,
            msg_short_seq_id,
            persn_legal_bk_code,
            cordnat_visitor,
            cordnat_visitor_name,
            lgtud,
            lattud,
            tel_no,
            chnl_no,
            rmark,
            no_bat,
            msg_short_inf,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_mkt_rec_seq_id,
            p_rel_id,
            p_mkt_typ,
            p_rel_typ,
            p_cust_id,
            p_cust_name,
            p_mkt_site,
            p_mkt_time,
            p_mkt_persn,
            p_mkt_persn_name,
            p_mkt_org,
            p_mkt_dura,
            p_mkt_dtl_situ,
            p_mkt_apdix_id,
            p_temp_id,
            p_temp_name,
            p_msg_short_seq_id,
            p_persn_legal_bk_code,
            p_cordnat_visitor,
            p_cordnat_visitor_name,
            p_lgtud,
            p_lattud,
            p_tel_no,
            p_chnl_no,
            p_rmark,
            p_no_bat,
            p_msg_short_inf,
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
    RAISE NOTICE '存储过程 pro_ads_mkt_rec_info 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
