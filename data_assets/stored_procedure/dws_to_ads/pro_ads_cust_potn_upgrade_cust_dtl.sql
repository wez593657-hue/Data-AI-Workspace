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
            a.cust_id,                              -- 客户编号
            a.aum_bal,                              -- AUM余额（月日均）
            a.depo_curnt_depo_bal,                  -- 活期存款余额
            a.fixd_depo_bal,                        -- 定期存款余额
            a.fin_bal,                              -- 金融资产余额
            COALESCE(l.cust_lvl, '00') AS cust_lvl, -- 客户等级（从客户等级信息表获取）
            CASE 
                WHEN a.aum_bal >= 45000 AND a.aum_bal < 50000 THEN '03'   -- 临界优质
                WHEN a.aum_bal >= 270000 AND a.aum_bal < 300000 THEN '06' -- 临界财富1
                WHEN a.aum_bal >= 450000 AND a.aum_bal < 500000 THEN '07' -- 临界财富2
                WHEN a.aum_bal >= 900000 AND a.aum_bal < 1000000 THEN '08' -- 临界贵宾
                WHEN a.aum_bal >= 2700000 AND a.aum_bal < 3000000 THEN '09' -- 临界私行
                ELSE NULL
            END AS lvl_crit                         -- 临界等级
        FROM dws_cust_asse_liab a                  -- DWS层客户资产负债表
        LEFT JOIN dws_cust_lvl_info l              -- DWS层客户等级信息表
            ON a.cust_id = l.cust_id 
            AND a.data_date = l.data_dt
        WHERE a.data_date = p_data_date            -- 数据日期
          AND a.bal_type = '2';                    -- 余额类型：2表示月日均
        
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
            m.cust_id,                              -- 客户编号
            '1' AS cntct_state                      -- 接触状态：1表示已接触
        FROM ads_mkt_rec_info m                    -- ADS层营销记录表
        WHERE TO_CHAR(TO_DATE(m.mkt_time, 'YYYY-MM-DD HH24:MI:SS'), 'YYYYMMDD') <= p_data_date
          AND m.mkt_time >= TO_CHAR(TO_DATE(p_data_date, 'YYYYMMDD') - INTERVAL '1 month', 'YYYY-MM-DD HH24:MI:SS')
          AND m.mkt_typ IN ('1', '2', '3', '4')    -- 营销类型：1面访/2电话/3短信/4企微
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
            c.cust_id,                              -- 客户编号
            c.cust_name,                            -- 客户名称
            c.host_cust_mngr_post_id AS post_id,    -- 主办客户经理职位编号
            c.org_lead AS org_id                    -- 归属机构
        FROM dwd_cust_indv_info c                  -- DWD层客户基本信息表
        WHERE c.data_date = p_data_date;           -- 数据日期
        
        COMMIT;
        
        v_end_date := NOW();
        v_dura_date := EXTRACT(EPOCH FROM (v_end_date - v_bgn_date))::INTEGER;
        v_log_msg := 'TMP3 临时表处理完成，客户信息数: ' || (SELECT COUNT(*) FROM tmp_cust_info);
        v_log_flg := 0;
        RAISE NOTICE '%', v_log_msg;

        v_no_id := '2';
        v_bgn_date := NOW();
        
        INSERT INTO ads_cust_potn_upgrade_cust_dtl (
            data_date,           -- 数据日期
            cust_id,             -- 客户编号
            cust_name,           -- 客户名称
            cust_lvl,            -- 客户等级
            lvl_crit,            -- 临界等级
            depo_curnt_depo_bal, -- 活期存款余额
            fixd_depo_bal,       -- 定期存款余额
            fin_amt,             -- 金融资产余额
            cntct_state,         -- 接触状态
            qual_state,          -- 达标状态
            post_id,             -- 主办客户经理职位编号
            org_id               -- 归属机构
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
            COALESCE(c.cntct_state, '0') AS cntct_state,  -- 接触状态：0未接触/1已接触
            CASE 
                WHEN t.lvl_crit = '03' AND t.aum_bal >= 50000 THEN '1'
                WHEN t.lvl_crit = '06' AND t.aum_bal >= 300000 THEN '1'
                WHEN t.lvl_crit = '07' AND t.aum_bal >= 500000 THEN '1'
                WHEN t.lvl_crit = '08' AND t.aum_bal >= 1000000 THEN '1'
                WHEN t.lvl_crit = '09' AND t.aum_bal >= 3000000 THEN '1'
                ELSE '0'
            END AS qual_state,                            -- 达标状态：0未达标/1已达标
            COALESCE(i.post_id, '') AS post_id,
            COALESCE(i.org_id, '') AS org_id
        FROM tmp_potn_upgrade_cust t                    -- 临时表：潜力提升客户
        LEFT JOIN tmp_cust_contact c                    -- 临时表：已接触客户
            ON t.cust_id = c.cust_id
        LEFT JOIN tmp_cust_info i                       -- 临时表：客户基本信息
            ON t.cust_id = i.cust_id
        WHERE t.lvl_crit IS NOT NULL;                   -- 只保留有临界等级的客户
        
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