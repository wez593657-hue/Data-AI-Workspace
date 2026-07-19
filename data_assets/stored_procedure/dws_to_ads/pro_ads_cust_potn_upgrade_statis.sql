CREATE OR REPLACE PROCEDURE pro_ads_cust_potn_upgrade_statis(
    p_data_date IN VARCHAR(8),
    p_result_code OUT INT,
    p_result_msg OUT VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP := NOW();
    v_end_time TIMESTAMP;
    v_duration INTERVAL;
    
    v_prc_desc VARCHAR(100) := '潜力提升统计';
    v_prc_name VARCHAR(32) := 'pro_ads_cust_potn_upgrade_statis';
    v_log_msg VARCHAR(4000);
    v_log_flg INTEGER;
    v_log_button INTEGER := 1;
    v_no_id VARCHAR(10);
    v_bgn_date TIMESTAMP;
    v_end_date TIMESTAMP;
    v_dura_date INTEGER;
BEGIN
    IF p_data_date IS NULL OR p_data_date = '' THEN
        p_result_code := -1;
        p_result_msg := 'data_date不能为空';
        RAISE NOTICE '参数检查失败: data_date为空';
        RETURN;
    END IF;

    IF NOT p_data_date ~ '^[0-9]{8}$' THEN
        p_result_code := -1;
        p_result_msg := 'data_date格式不正确，应为YYYYMMDD格式';
        RAISE NOTICE '参数检查失败: data_date格式不正确';
        RETURN;
    END IF;

    RAISE NOTICE '存储过程 pro_ads_cust_potn_upgrade_statis 开始执行';
    RAISE NOTICE '目标表: ads_cust_potn_upgrade_statis (ADS层)';
    RAISE NOTICE '数据日期: %', p_data_date;

    BEGIN
        v_no_id := '1';
        v_bgn_date := NOW();
        
        DELETE FROM ads_cust_potn_upgrade_statis 
        WHERE data_date = p_data_date;
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := '清理目标表完成，删除数据日期: ' || p_data_date;
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        v_no_id := '2';
        v_bgn_date := NOW();
        
        INSERT INTO ads_cust_potn_upgrade_statis (
            data_date,
            statis_obj,
            statis_cycle,
            lvl_crit,
            ttl_cust_cnt,
            mth_avg_qual_cnt,
            mth_avg_qual_rate,
            pnt_qual_cnt,
            pnt_qual_rate,
            cntct_cust_cnt,
            cntct_rate
        )
        SELECT 
            p_data_date AS data_date,
            '0' AS statis_obj,
            '01' AS statis_cycle,
            d.lvl_crit,
            COUNT(*) AS ttl_cust_cnt,
            SUM(CASE WHEN d.qual_state = '1' THEN 1 ELSE 0 END) AS mth_avg_qual_cnt,
            ROUND(CASE WHEN COUNT(*) > 0 THEN SUM(CASE WHEN d.qual_state = '1' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) ELSE 0 END * 100, 2) AS mth_avg_qual_rate,
            SUM(CASE WHEN d.qual_state = '1' THEN 1 ELSE 0 END) AS pnt_qual_cnt,
            ROUND(CASE WHEN COUNT(*) > 0 THEN SUM(CASE WHEN d.qual_state = '1' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) ELSE 0 END * 100, 2) AS pnt_qual_rate,
            SUM(CASE WHEN d.cntct_state = '1' THEN 1 ELSE 0 END) AS cntct_cust_cnt,
            ROUND(CASE WHEN COUNT(*) > 0 THEN SUM(CASE WHEN d.cntct_state = '1' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) ELSE 0 END * 100, 2) AS cntct_rate
        FROM ads_cust_potn_upgrade_cust_dtl d
        WHERE d.data_date = p_data_date
        GROUP BY d.lvl_crit;
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := '第2个业务处理段完成，插入统计记录数: ' || SQL%ROWCOUNT;
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        p_result_code := 0;
        p_result_msg := '执行成功，插入记录数: ' || (SELECT COUNT(*) FROM ads_cust_potn_upgrade_statis WHERE data_date = p_data_date);

    EXCEPTION
        WHEN OTHERS THEN
            p_result_code := SQLSTATE::INT;
            p_result_msg := SQLERRM;
            RAISE NOTICE '异常发生: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;
            RETURN;
    END;

    v_end_time := NOW();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE '存储过程 pro_ads_cust_potn_upgrade_statis 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;