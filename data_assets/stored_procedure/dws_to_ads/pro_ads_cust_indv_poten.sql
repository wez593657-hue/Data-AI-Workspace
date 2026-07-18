CREATE OR REPLACE PROCEDURE pro_ads_cust_indv_poten(
    p_poten_cust_id IN VARCHAR(40),
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
    IF p_poten_cust_id IS NULL OR p_poten_cust_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'poten_cust_id不能为空';
        RAISE NOTICE '参数检查失败: poten_cust_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_ads_cust_indv_poten 开始执行';
    RAISE NOTICE '目标表: ads_cust_indv_poten (ADS层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO ads_cust_indv_poten (
            poten_cust_id,
            poten_cust_name,
            poten_typ,
            poten_cust_typ,
            gender,
            cert_typ,
            cert_id,
            tel_no,
            intent_dsc,
            dtl_addrs,
            creatr,
            creat_time,
            poten_cust_state,
            lpr_id,
            src_typ,
            mkt_persn,
            allo_date,
            mkt_org,
            serv_enter,
            post,
            mth_incom,
            yr_incom,
            rmark,
            inf_klkt_date,
            unit_addrs,
            intn_prdkt,
            no_bat,
            cust_id,
            pot_cnvrt_prdkt,
            pot_cnvrt_org,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_poten_cust_id,
            p_poten_cust_name,
            p_poten_typ,
            p_poten_cust_typ,
            p_gender,
            p_cert_typ,
            p_cert_id,
            p_tel_no,
            p_intent_dsc,
            p_dtl_addrs,
            p_creatr,
            p_creat_time,
            p_poten_cust_state,
            p_lpr_id,
            p_src_typ,
            p_mkt_persn,
            p_allo_date,
            p_mkt_org,
            p_serv_enter,
            p_post,
            p_mth_incom,
            p_yr_incom,
            p_rmark,
            p_inf_klkt_date,
            p_unit_addrs,
            p_intn_prdkt,
            p_no_bat,
            p_cust_id,
            p_pot_cnvrt_prdkt,
            p_pot_cnvrt_org,
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
    RAISE NOTICE '存储过程 pro_ads_cust_indv_poten 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
