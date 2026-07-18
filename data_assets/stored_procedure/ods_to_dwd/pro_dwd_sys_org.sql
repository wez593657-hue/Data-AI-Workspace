CREATE OR REPLACE PROCEDURE pro_dwd_sys_org(
    p_org_id IN 40,
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
    IF p_org_id IS NULL OR p_org_id = '' THEN
        p_result_code := -1;
        p_result_msg := 'org_id不能为空';
        RAISE NOTICE '参数检查失败: org_id为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dwd_sys_org 开始执行';
    RAISE NOTICE '目标表: dwd_sys_org (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_sys_org (
            org_id,
            sup_org_id,
            org_path,
            org_name,
            sup_org_name,
            direct_under_org,
            org_typ,
            org_harcy,
            org_addrs,
            org_state,
            dsply_seq,
            creatr,
            creat_time,
            creat_org,
            persn_legal_bk_code,
            hr_ms_org_id,
            org_lgtud,
            org_lattud,
            org_rsponr,
            org_tel,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_org_id,
            p_sup_org_id,
            p_org_path,
            p_org_name,
            p_sup_org_name,
            p_direct_under_org,
            p_org_typ,
            p_org_harcy,
            p_org_addrs,
            p_org_state,
            p_dsply_seq,
            p_creatr,
            p_creat_time,
            p_creat_org,
            p_persn_legal_bk_code,
            p_hr_ms_org_id,
            p_org_lgtud,
            p_org_lattud,
            p_org_rsponr,
            p_org_tel,
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
    RAISE NOTICE '存储过程 pro_dwd_sys_org 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
