------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_005
-- 功能说明: 指标数据统计——步骤5（提取符合提升条件的客户明细并汇总A/路径09指标）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER     输出（处理行数）
-- 需求版本: 【待确认】（原文件无头部版本信息，版本号待需求方确认）
-- 变更记录:
--   - 2026-08-26 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   - 2026-08-25 行内注释补全与对齐（仅注释与格式优化，业务逻辑零改动）
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_005(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    outcde OUT INTEGER  -- 处理行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤55处理完成 5';  -- 过程描述（写入步骤日志）
    V_PRC_NAME VARCHAR2(32) := 'prc_ads_stat_indx_plan_005';     -- 过程名
    V_LOG_MSG VARCHAR2(4000);                        -- 日志消息内容
    V_LOG_FLG INTEGER;                               -- 日志标志（0正常 -1异常）
    V_LOG_BUTTON INTEGER := 1;                       -- 日志按钮标识（固定1）
    V_NO_ID VARCHAR2(10);                            -- 业务流水号（固定'0'）
    V_BGN_DATE DATE;                                 -- 过程起始时间
    V_END_DATE DATE;                                 -- 过程结束时间
    V_DURA_DATE INTEGER;                             -- 运行耗时（秒）
BEGIN
    V_NO_ID := '0';                                                -- 业务流水号（固定'0'）
    V_BGN_DATE := SYSDATE;                                         -- 过程起始时间
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN  -- 校验入参必须为8位数字日期
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 入参非法则抛错
    END IF;

    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    DELETE FROM TMP_STAT_INDX_AGGR_005;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 跑批业务日期转 DATE

    -------------------------------------------------------------------------
    -- 段落: 6.1 提取符合提升条件的客户明细
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_CUST_STATE (                   -- 写入客户提升状态明细表
        path_code, statis_dim, indx_code, data_blng, cust_id,-- 路径/维度/指标/数据归属/客户
        persn_legal_bk_code, base_cust_lvl, curnt_cust_lvl,  -- 法人机构/期初层级/当前层级
        base_mth_avg_aum, curnt_mth_avg_aum                  -- 期初月日均AUM/当前月日均AUM
    )
    SELECT CASE WHEN d.statis_calib = '08' THEN '08' ELSE '09' END,  -- 路径标识：营销活动→A 目标任务→B
           d.statis_dim,                                  -- 统计维度
           d.indx_code,                                   -- 指标编码
           d.data_blng,                                   -- 数据归属
           d.cust_id,                                     -- 客户ID
           d.persn_legal_bk_code,                         -- 法人机构编码
           d.base_cust_lvl,                               -- 期初客户层级
           lv.cust_lvl,                                   -- 当前客户层级
           d.base_mth_avg_aum,                            -- 期初月日均AUM
           NVL(b.aum_bal, 0)                              -- 当前月日均AUM（无AUM记录取0）
      FROM ADS_STAT_INDX_BASELINE_DTL d                   -- 期初提升基准明细表
      LEFT JOIN DWS_CUST_LVL_INFO lv                      -- 客户层级信息表
        ON lv.cust_id             = d.cust_id             -- 客户ID匹配
       AND lv.persn_legal_bk_code = d.persn_legal_bk_code -- 法人机构匹配
       AND lv.data_date           = v_sysdat              -- 取跑批日层级快照
      LEFT JOIN DWS_CUST_ASSE_LIAB b                      -- 客户资产负债(AUM)表
        ON b.cust_id             = d.cust_id              -- 客户ID匹配
       AND b.persn_legal_bk_code = d.persn_legal_bk_code  -- 法人机构匹配
       AND b.data_date           = v_sysdat               -- 取跑批日快照
       AND b.bal_type            = '2'                    -- 余额类型=2（AUM）
     WHERE d.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')  -- 仅统计提升类指标
       AND (
           (d.indx_code = 'INDX_0052'                     -- 指标0052：层级提升至4级
            AND TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 4  -- 期初层级<4
            AND TO_NUMBER(NVL(lv.cust_lvl, '0'))    >= 4) -- 当前层级>=4（达成提升）
           OR
           (d.indx_code = 'INDX_0053'                     -- 指标0053：层级提升至6级
            AND TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 6  -- 期初层级<6
            AND TO_NUMBER(NVL(lv.cust_lvl, '0'))    >= 6) -- 当前层级>=6
           OR
           (d.indx_code = 'INDX_0054'                     -- 指标0054：层级提升至7级
            AND TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 7  -- 期初层级<7
            AND TO_NUMBER(NVL(lv.cust_lvl, '0'))    >= 7) -- 当前层级>=7
           OR
           (d.indx_code = 'INDX_0063'  -- 指标0063：AUM临界档提升
            AND b.cust_id IS NOT NULL  -- 存在AUM记录
            AND (
                (b.aum_bal >= 45000   AND b.aum_bal < 50000)   OR                    -- 当前AUM 4.5万~5万档
                (b.aum_bal >= 270000  AND b.aum_bal < 300000)  OR                    -- 当前AUM 27万~30万档
                (b.aum_bal >= 450000  AND b.aum_bal < 500000)  OR                    -- 当前AUM 45万~50万档
                (b.aum_bal >= 900000  AND b.aum_bal < 1000000) OR                    -- 当前AUM 90万~100万档
                (b.aum_bal >= 2700000 AND b.aum_bal < 3000000) OR                    -- 当前AUM 270万~300万档
                (d.base_mth_avg_aum >= 45000   AND d.base_mth_avg_aum < 50000)   OR  -- 期初AUM 4.5万~5万档
                (d.base_mth_avg_aum >= 270000  AND d.base_mth_avg_aum < 300000)  OR  -- 期初AUM 27万~30万档
                (d.base_mth_avg_aum >= 450000  AND d.base_mth_avg_aum < 500000)  OR  -- 期初AUM 45万~50万档
                (d.base_mth_avg_aum >= 900000  AND d.base_mth_avg_aum < 1000000) OR  -- 期初AUM 90万~100万档
                (d.base_mth_avg_aum >= 2700000 AND d.base_mth_avg_aum < 3000000)     -- 期初AUM 270万~300万档
            ))
       );

    -------------------------------------------------------------------------
    -- 段落: 6.2 汇总写入 AGGR（路径08：营销活动）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_005 (                          -- 写入本步骤专项汇总表
        path_code, data_date, data_blng, statis_dim, statis_calib,-- 路径/数据日期/归属/维度/口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code  -- 指标/当前值/期初值/法人机构
    )
    SELECT '08', v_sysdat, s.data_blng, s.statis_dim, '08', s.indx_code,                               -- 路径08汇总头：数据日期/归属/维度/营销活动/指标
           CASE s.indx_code                                                                             -- 按指标分类型计算客户数
               WHEN 'INDX_0052' THEN COUNT(c.cust_id)                                                   -- 0052：层级提升至4级的客户数
               WHEN 'INDX_0053' THEN COUNT(c.cust_id)                                                   -- 0053：层级提升至6级的客户数
               WHEN 'INDX_0054' THEN COUNT(c.cust_id)                                                   -- 0054：层级提升至7级的客户数
               WHEN 'INDX_0063' THEN                                                                    -- 0063：AUM临界档提升客户数（当前档-期初档）
                   SUM(CASE WHEN (c.curnt_mth_avg_aum >= 45000   AND c.curnt_mth_avg_aum < 50000)   OR  -- 当前AUM 4.5万~5万档
                                 (c.curnt_mth_avg_aum >= 270000  AND c.curnt_mth_avg_aum < 300000)  OR  -- 当前AUM 27万~30万档
                                 (c.curnt_mth_avg_aum >= 450000  AND c.curnt_mth_avg_aum < 500000)  OR  -- 当前AUM 45万~50万档
                                 (c.curnt_mth_avg_aum >= 900000  AND c.curnt_mth_avg_aum < 1000000) OR  -- 当前AUM 90万~100万档
                                 (c.curnt_mth_avg_aum >= 2700000 AND c.curnt_mth_avg_aum < 3000000)     -- 当前AUM 270万~300万档
                            THEN 1 ELSE 0 END)
                 - SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR   -- 期初AUM 4.5万~5万档（减去已在档客户）
                                  (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR  -- 期初AUM 27万~30万档
                                  (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR  -- 期初AUM 45万~50万档
                                  (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR  -- 期初AUM 90万~100万档
                                  (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)     -- 期初AUM 270万~300万档
                             THEN 1 ELSE 0 END)
           END,
           CASE WHEN s.indx_code = 'INDX_0063' THEN                                               -- 期初值：仅0063统计期初临界档客户数
               SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR  -- 期初AUM 4.5万~5万档
                             (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR  -- 期初AUM 27万~30万档
                             (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR  -- 期初AUM 45万~50万档
                             (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR  -- 期初AUM 90万~100万档
                             (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)     -- 期初AUM 270万~300万档
                        THEN 1 ELSE 0 END)
           ELSE 0 END,
           s.persn_legal_bk_code                                              -- 法人机构编码
      FROM (SELECT DISTINCT path_code, statis_dim, indx_code, data_blng, persn_legal_bk_code  -- 子查询：路径08去重(路径/维度/指标/归属/法人)
              FROM TMP_STAT_INDX_SCOPE                                        -- A/路径09目标客户范围表
             WHERE path_code = '08'                                            -- 仅路径08（营销活动）
               AND indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')) s  -- 仅提升类指标
      LEFT JOIN TMP_STAT_INDX_CUST_STATE c                                    -- 关联客户提升状态明细（取客户数）
        ON c.path_code           = s.path_code                                -- 路径匹配
       AND c.statis_dim          = s.statis_dim                               -- 维度匹配
       AND c.indx_code           = s.indx_code                                -- 指标匹配
       AND c.data_blng           = s.data_blng                                -- 数据归属匹配
       AND c.persn_legal_bk_code = s.persn_legal_bk_code                      -- 法人机构匹配
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;  -- 按归属/维度/指标/法人机构分组

    -------------------------------------------------------------------------
    -- 段落: 6.3 汇总写入 AGGR（路径09：目标任务）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_005 (                          -- 写入本步骤专项汇总表
        path_code, data_date, data_blng, statis_dim, statis_calib,-- 路径/数据日期/归属/维度/口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code  -- 指标/当前值/期初值/法人机构
    )
    SELECT '09', v_sysdat, s.data_blng, s.statis_dim, '09', s.indx_code,                               -- 路径09汇总头：数据日期/归属/维度/目标任务/指标
           CASE s.indx_code                                                                             -- 按指标分类型计算客户数
               WHEN 'INDX_0052' THEN COUNT(c.cust_id)                                                   -- 0052：层级提升至4级的客户数
               WHEN 'INDX_0053' THEN COUNT(c.cust_id)                                                   -- 0053：层级提升至6级的客户数
               WHEN 'INDX_0054' THEN COUNT(c.cust_id)                                                   -- 0054：层级提升至7级的客户数
               WHEN 'INDX_0063' THEN                                                                    -- 0063：AUM临界档提升客户数（当前档-期初档）
                   SUM(CASE WHEN (c.curnt_mth_avg_aum >= 45000   AND c.curnt_mth_avg_aum < 50000)   OR  -- 当前AUM 4.5万~5万档
                                 (c.curnt_mth_avg_aum >= 270000  AND c.curnt_mth_avg_aum < 300000)  OR  -- 当前AUM 27万~30万档
                                 (c.curnt_mth_avg_aum >= 450000  AND c.curnt_mth_avg_aum < 500000)  OR  -- 当前AUM 45万~50万档
                                 (c.curnt_mth_avg_aum >= 900000  AND c.curnt_mth_avg_aum < 1000000) OR  -- 当前AUM 90万~100万档
                                 (c.curnt_mth_avg_aum >= 2700000 AND c.curnt_mth_avg_aum < 3000000)     -- 当前AUM 270万~300万档
                            THEN 1 ELSE 0 END)
                 - SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR   -- 期初AUM 4.5万~5万档（减去已在档客户）
                                  (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR  -- 期初AUM 27万~30万档
                                  (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR  -- 期初AUM 45万~50万档
                                  (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR  -- 期初AUM 90万~100万档
                                  (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)     -- 期初AUM 270万~300万档
                             THEN 1 ELSE 0 END)
           END,
           CASE WHEN s.indx_code = 'INDX_0063' THEN                                               -- 期初值：仅0063统计期初临界档客户数
               SUM(CASE WHEN (c.base_mth_avg_aum >= 45000   AND c.base_mth_avg_aum < 50000)   OR  -- 期初AUM 4.5万~5万档
                             (c.base_mth_avg_aum >= 270000  AND c.base_mth_avg_aum < 300000)  OR  -- 期初AUM 27万~30万档
                             (c.base_mth_avg_aum >= 450000  AND c.base_mth_avg_aum < 500000)  OR  -- 期初AUM 45万~50万档
                             (c.base_mth_avg_aum >= 900000  AND c.base_mth_avg_aum < 1000000) OR  -- 期初AUM 90万~100万档
                             (c.base_mth_avg_aum >= 2700000 AND c.base_mth_avg_aum < 3000000)     -- 期初AUM 270万~300万档
                        THEN 1 ELSE 0 END)
           ELSE 0 END,
           s.persn_legal_bk_code                                              -- 法人机构编码
      FROM (SELECT DISTINCT path_code, statis_dim, indx_code, data_blng, persn_legal_bk_code  -- 子查询：路径09去重(路径/维度/指标/归属/法人)
              FROM TMP_STAT_INDX_SCOPE                                        -- A/路径09目标客户范围表
             WHERE path_code = '09'                                            -- 仅路径09（目标任务）
               AND indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')) s  -- 仅提升类指标
      LEFT JOIN TMP_STAT_INDX_CUST_STATE c                                    -- 关联客户提升状态明细（取客户数）
        ON c.path_code           = s.path_code                                -- 路径匹配
       AND c.statis_dim          = s.statis_dim                               -- 维度匹配
       AND c.indx_code           = s.indx_code                                -- 指标匹配
       AND c.data_blng           = s.data_blng                                -- 数据归属匹配
       AND c.persn_legal_bk_code = s.persn_legal_bk_code                      -- 法人机构匹配
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;  -- 按归属/维度/指标/法人机构分组

    -------------------------------------------------------------------------
    -- 段落: 结果行数回写与日志记录
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;                                   -- 写入行数（取最后一条DML的影响行数）
    COMMIT;                                                   -- 提交事务
    V_END_DATE := SYSDATE;                                    -- 过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 运行耗时（秒）
    V_LOG_MSG := '步骤5处理完成，行数=' || NVL(outcde, 0);             -- 拼接日志消息（含写入行数）
    V_LOG_FLG := 0;                                           -- 日志标志：0=正常
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 写入步骤执行日志
EXCEPTION
    WHEN OTHERS THEN
    -------------------------------------------------------------------------
    -- 段落: 异常处理——回滚并记录错误日志后重抛
    -------------------------------------------------------------------------
        ROLLBACK;                                                 -- 异常回滚
        outcde := -1;                                             -- 异常标识：-1
        V_END_DATE := SYSDATE;                                    -- 过程结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 运行耗时（秒）
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);                    -- 截取异常信息（前1000字符）
        V_LOG_FLG := -1;                                          -- 日志标志：-1=异常
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 写入异常日志
        RAISE;                                                    -- 重新抛出异常
END prc_ads_stat_indx_plan_005;