CREATE OR REPLACE PROCEDURE pro_ads_cust_potn_upgrade_cust_dtl(
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
    
    v_prc_desc VARCHAR(100) := '潜力提升客户明细';
    v_prc_name VARCHAR(32) := 'pro_ads_cust_potn_upgrade_cust_dtl';
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

    RAISE NOTICE '存储过程 pro_ads_cust_potn_upgrade_cust_dtl 开始执行';
    RAISE NOTICE '目标表: ads_cust_potn_upgrade_cust_dtl (ADS层)';
    RAISE NOTICE '数据日期: %', p_data_date;

    BEGIN
        v_no_id := '1';
        v_bgn_date := NOW();
        
        DELETE FROM ads_cust_potn_upgrade_cust_dtl 
        WHERE data_date = p_data_date;
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := '清理目标表完成，删除数据日期: ' || p_data_date;
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        v_no_id := 'TMP1';
        v_bgn_date := NOW();
        
        DROP TABLE IF EXISTS tmp_potn_upgrade_cust;
        CREATE TEMP TABLE tmp_potn_upgrade_cust AS
        SELECT 
            a.cust_id,
            a.org_id,
            a.aum_bal,
            a.depo_curnt_depo_bal,
            a.fixd_depo_bal,
            a.fin_bal,
            CASE 
                WHEN a.aum_bal >= 45000 AND a.aum_bal < 50000 THEN '03'
                WHEN a.aum_bal >= 270000 AND a.aum_bal < 300000 THEN '06'
                WHEN a.aum_bal >= 450000 AND a.aum_bal < 500000 THEN '07'
                WHEN a.aum_bal >= 900000 AND a.aum_bal < 1000000 THEN '08'
                WHEN a.aum_bal >= 2700000 AND a.aum_bal < 3000000 THEN '09'
                ELSE NULL
            END AS lvl_crit,
            CASE 
                WHEN a.aum_bal >= 0 AND a.aum_bal < 10000 THEN '01'
                WHEN a.aum_bal >= 10000 AND a.aum_bal < 30000 THEN '02'
                WHEN a.aum_bal >= 30000 AND a.aum_bal < 50000 THEN '03'
                WHEN a.aum_bal >= 50000 AND a.aum_bal < 100000 THEN '04'
                WHEN a.aum_bal >= 100000 AND a.aum_bal < 200000 THEN '05'
                WHEN a.aum_bal >= 200000 AND a.aum_bal < 300000 THEN '06'
                WHEN a.aum_bal >= 300000 AND a.aum_bal < 500000 THEN '07'
                WHEN a.aum_bal >= 500000 AND a.aum_bal < 1000000 THEN '08'
                WHEN a.aum_bal >= 1000000 AND a.aum_bal < 3000000 THEN '09'
                WHEN a.aum_bal >= 3000000 THEN '10'
                ELSE '00'
            END AS cust_lvl
        FROM dws_cust_asse_liab a
        WHERE a.data_date = p_data_date
          AND a.bal_type = '2';
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := 'TMP1 临时表处理完成，临界客户数: ' || (SELECT COUNT(*) FROM tmp_potn_upgrade_cust WHERE lvl_crit IS NOT NULL);
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        v_no_id := 'TMP2';
        v_bgn_date := NOW();
        
        DROP TABLE IF EXISTS tmp_cust_contact;
        CREATE TEMP TABLE tmp_cust_contact AS
        SELECT 
            m.cust_id,
            '1' AS cntct_state
        FROM ads_mkt_rec_info m
        WHERE TO_CHAR(TO_DATE(m.mkt_time, 'YYYY-MM-DD HH24:MI:SS'), 'YYYYMMDD') <= p_data_date
          AND m.mkt_time >= TO_CHAR(TO_DATE(p_data_date, 'YYYYMMDD') - INTERVAL '1 month', 'YYYY-MM-DD HH24:MI:SS')
          AND m.mkt_typ IN ('1', '2', '3', '4')
        GROUP BY m.cust_id;
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := 'TMP2 临时表处理完成，已接触客户数: ' || (SELECT COUNT(*) FROM tmp_cust_contact);
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        v_no_id := 'TMP3';
        v_bgn_date := NOW();
        
        DROP TABLE IF EXISTS tmp_cust_info;
        CREATE TEMP TABLE tmp_cust_info AS
        SELECT 
            c.cust_id,
            c.cust_name,
            c.post_id
        FROM dwd_crm_customer c
        WHERE c.data_date = p_data_date;
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := 'TMP3 临时表处理完成，客户信息数: ' || (SELECT COUNT(*) FROM tmp_cust_info);
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        v_no_id := '2';
        v_bgn_date := NOW();
        
        INSERT INTO ads_cust_potn_upgrade_cust_dtl (
            data_date,
            cust_id,
            cust_name,
            cust_lvl,
            lvl_crit,
            depo_curnt_depo_bal,
            fixd_depo_bal,
            fin_amt,
            cntct_state,
            qual_state,
            post_id,
            org_id
        )
        SELECT 
            p_data_date AS data_date,
            t.cust_id,
            COALESCE(i.cust_name, '') AS cust_name,
            t.cust_lvl,
            t.lvl_crit,
            t.depo_curnt_depo_bal,
            t.fixd_depo_bal,
            t.fin_bal AS fin_amt,
            COALESCE(c.cntct_state, '0') AS cntct_state,
            CASE 
                WHEN t.lvl_crit = '03' AND t.aum_bal >= 50000 THEN '1'
                WHEN t.lvl_crit = '06' AND t.aum_bal >= 300000 THEN '1'
                WHEN t.lvl_crit = '07' AND t.aum_bal >= 500000 THEN '1'
                WHEN t.lvl_crit = '08' AND t.aum_bal >= 1000000 THEN '1'
                WHEN t.lvl_crit = '09' AND t.aum_bal >= 3000000 THEN '1'
                ELSE '0'
            END AS qual_state,
            COALESCE(i.post_id, '') AS post_id,
            t.org_id
        FROM tmp_potn_upgrade_cust t
        LEFT JOIN tmp_cust_contact c ON t.cust_id = c.cust_id
        LEFT JOIN tmp_cust_info i ON t.cust_id = i.cust_id
        WHERE t.lvl_crit IS NOT NULL;
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := '第2个业务处理段完成，插入记录数: ' || SQL%ROWCOUNT;
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        p_result_code := 0;
        p_result_msg := '执行成功，插入记录数: ' || (SELECT COUNT(*) FROM ads_cust_potn_upgrade_cust_dtl WHERE data_date = p_data_date);

    EXCEPTION
        WHEN OTHERS THEN
            p_result_code := SQLSTATE::INT;
            p_result_msg := SQLERRM;
            RAISE NOTICE '异常发生: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;
            RETURN;
    END;

    v_end_time := NOW();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE '存储过程 pro_ads_cust_potn_upgrade_cust_dtl 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;