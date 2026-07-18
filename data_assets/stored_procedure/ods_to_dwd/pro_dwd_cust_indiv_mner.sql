CREATE OR REPLACE PROCEDURE pro_dwd_cust_indiv_mner(
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
    RAISE NOTICE '存储过程 pro_dwd_cust_indiv_mner 开始执行';
    RAISE NOTICE '目标表: dwd_cust_indiv_mner (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_cust_indiv_mner (
            cust_id,
            mber_name,
            mber_rel,
            gend,
            tel_no,
            bk_self_cust_flg,
            inner_bk_cust_id,
            bth_date,
            mari_day_mem,
            cert_id,
            cert_typ,
            sys_src,
            persn_legal_bk_code,
            pk_id,
            post_id,
            remark,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_cust_id,
            p_mber_name,
            p_mber_rel,
            p_gend,
            p_tel_no,
            p_bk_self_cust_flg,
            p_inner_bk_cust_id,
            p_bth_date,
            p_mari_day_mem,
            p_cert_id,
            p_cert_typ,
            p_sys_src,
            p_persn_legal_bk_code,
            p_pk_id,
            p_post_id,
            p_remark,
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
    RAISE NOTICE '存储过程 pro_dwd_cust_indiv_mner 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
