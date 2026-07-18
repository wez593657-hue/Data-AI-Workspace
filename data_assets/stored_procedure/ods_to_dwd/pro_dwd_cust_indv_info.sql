CREATE OR REPLACE PROCEDURE pro_dwd_cust_indv_info(
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
    RAISE NOTICE '存储过程 pro_dwd_cust_indv_info 开始执行';
    RAISE NOTICE '目标表: dwd_cust_indv_info (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_cust_indv_info (
            cust_id,
            cust_name,
            cert_typ,
            cert_id,
            cert_prd_vlid,
            cert_prd_vlid_end,
            cert_issuing_authority,
            cust_typ,
            nationality,
            nation,
            mari_situ,
            max_deg_edu,
            now_enter,
            occu_cls,
            cust_hraky,
            persn_legal_bk_code,
            gend,
            phone_no,
            contact_address,
            contact_address_detail,
            id_address,
            id_address_detail,
            home_address,
            home_address_detail,
            residence_address,
            residence_address_detail,
            office_address,
            office_address_detail,
            host_cust_mngr_post_id,
            host_cust_mngr_name,
            host_cust_mngr_emp_id,
            org_lead,
            org_lead_path,
            cospsr_cust_mngr_post_id,
            cospsr_cust_mngr_name,
            cospsr_cust_mngr_emp_id,
            cospsr_org,
            cospsr_org_path,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_cust_id,
            p_cust_name,
            p_cert_typ,
            p_cert_id,
            p_cert_prd_vlid,
            p_cert_prd_vlid_end,
            p_cert_issuing_authority,
            p_cust_typ,
            p_nationality,
            p_nation,
            p_mari_situ,
            p_max_deg_edu,
            p_now_enter,
            p_occu_cls,
            p_cust_hraky,
            p_persn_legal_bk_code,
            p_gend,
            p_phone_no,
            p_contact_address,
            p_contact_address_detail,
            p_id_address,
            p_id_address_detail,
            p_home_address,
            p_home_address_detail,
            p_residence_address,
            p_residence_address_detail,
            p_office_address,
            p_office_address_detail,
            p_host_cust_mngr_post_id,
            p_host_cust_mngr_name,
            p_host_cust_mngr_emp_id,
            p_org_lead,
            p_org_lead_path,
            p_cospsr_cust_mngr_post_id,
            p_cospsr_cust_mngr_name,
            p_cospsr_cust_mngr_emp_id,
            p_cospsr_org,
            p_cospsr_org_path,
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
    RAISE NOTICE '存储过程 pro_dwd_cust_indv_info 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
