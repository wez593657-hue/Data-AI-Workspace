CREATE OR REPLACE PROCEDURE pro_dwd_tmp_jigou_base(
    p_jigouhao IN VARCHAR(10),
    p_farendma IN VARCHAR(4),
    p_fenhdaim IN VARCHAR(30),
    p_jigoleix IN VARCHAR(30),
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
    IF p_jigouhao IS NULL OR p_jigouhao = '' THEN
        p_result_code := -1;
        p_result_msg := 'jigouhao不能为空';
        RAISE NOTICE '参数检查失败: jigouhao为空';
        RETURN;
    END IF;

    IF p_farendma IS NULL OR p_farendma = '' THEN
        p_result_code := -1;
        p_result_msg := 'farendma不能为空';
        RAISE NOTICE '参数检查失败: farendma为空';
        RETURN;
    END IF;

    IF p_fenhdaim IS NULL OR p_fenhdaim = '' THEN
        p_result_code := -1;
        p_result_msg := 'fenhdaim不能为空';
        RAISE NOTICE '参数检查失败: fenhdaim为空';
        RETURN;
    END IF;

    IF p_jigoleix IS NULL OR p_jigoleix = '' THEN
        p_result_code := -1;
        p_result_msg := 'jigoleix不能为空';
        RAISE NOTICE '参数检查失败: jigoleix为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 pro_dwd_tmp_jigou_base 开始执行';
    RAISE NOTICE '目标表: dwd_tmp_jigou_base (DWD层)';


    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        -- 插入数据
        INSERT INTO dwd_tmp_jigou_base (
            jigouhao,
            farendma,
            fenhdaim,
            jigoleix,
            jigouzwm,
            dizhiiii,
            youzhnbm,
            dianhhma,
            weihriqi,
            weihshij,
            jingduxx,
            weiduxxz,
            yewugxjg,
            yewugxjb,
            create_time,
            update_time,
            create_by,
            update_by
        ) VALUES (
            p_jigouhao,
            p_farendma,
            p_fenhdaim,
            p_jigoleix,
            p_jigouzwm,
            p_dizhiiii,
            p_youzhnbm,
            p_dianhhma,
            p_weihriqi,
            p_weihshij,
            p_jingduxx,
            p_weiduxxz,
            p_yewugxjg,
            p_yewugxjb,
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
    RAISE NOTICE '存储过程 pro_dwd_tmp_jigou_base 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
