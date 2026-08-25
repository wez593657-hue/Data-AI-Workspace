------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_004
-- 功能说明: 指标数据统计——步骤4（营销活动/目标任务两路径的指标汇总写入临时汇总表）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER     输出（处理行数/结果标志）
-- 需求版本: 【待确认】（原文件中无需求版本/变更记录信息，版本号待需求方确认）
-- 变更记录:
--   - 2026-08-25 行内注释补全与对齐（仅注释与格式优化，业务逻辑零改动）
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_004(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    outcde OUT INTEGER  -- 处理行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤44处理完成 4';  -- 过程描述，用于日志
    V_PRC_NAME VARCHAR2(32) := 'prc_ads_stat_indx_plan_004';   -- 过程名称，用于日志
    V_LOG_MSG VARCHAR2(4000);                        -- 日志消息
    V_LOG_FLG INTEGER;                               -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;                       -- 日志按钮，1启用步骤日志
    V_NO_ID VARCHAR2(10);                            -- 日志序号标识
    V_BGN_DATE DATE;                                 -- 过程开始时间
    V_END_DATE DATE;                                 -- 过程结束时间
    V_DURA_DATE INTEGER;                             -- 过程耗时（秒）
BEGIN
    V_NO_ID := '0';  -- 初始化日志序号
    V_BGN_DATE := SYSDATE;   -- 记录过程开始时间
    -------------------------------------------------------------------------
    -- 参数校验：跑批业务日期格式校验（必须为 8 位数字 YYYYMMDD）
    -------------------------------------------------------------------------
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN   -- 校验业务日期为非空8位数字
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 格式非法报错
    END IF;

    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    DELETE FROM TMP_STAT_INDX_AGGR_004;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 业务日期字符串转日期型
    -------------------------------------------------------------------------
    -- 营销活动路径（A）：理财产品/代销理财/贷款 0055/0056/0057/0058/0059/0060/0062
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_004 (
        path_code, data_date, data_blng, statis_dim, statis_calib,-- 路径, 数据日期, 归属机构, 统计维度, 统计口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code  -- 指标编码, 当期值, 上期值, 法人行号
    )
    SELECT 'A', v_sysdat, s.data_blng, s.statis_dim, '营销活动', s.indx_code,                                                                                                       -- 路径A/数据日期/归属机构/统计维度/口径/指标编码
           CASE s.indx_code                                                                                                                                                     -- 按指标编码取当期增量
               WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)                                                -- 当年日均理财增量=当年日均理财-年度基数日均理财
               WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)                                               -- 当月日均理财增量=当月日均理财-月份基数日均理财
               WHEN 'INDX_0057' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_fin_bal)                                                   -- 当月理财新增=当期理财余额-基数理财余额
               WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)  -- 当年日均代销理财增量
               WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin) -- 当月日均代销理财增量
               WHEN 'INDX_0060' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_agen_fin_bal)     -- 当月代销理财新增
               WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END) - MAX(bs.base_loan_bal)                                                 -- 当月贷款新增=当期贷款余额-基数贷款余额
           END,
           CASE s.indx_code                                        -- 按指标编码取对应上期值
               WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin)       -- 上期值=年度基数日均理财
               WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)      -- 上期值=月份基数日均理财
               WHEN 'INDX_0057' THEN MAX(bs.base_fin_bal)          -- 上期值=基数理财余额
               WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin)  -- 上期值=年度基数日均代销理财
               WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin) -- 上期值=月份基数日均代销理财
               WHEN 'INDX_0060' THEN MAX(bs.base_agen_fin_bal)     -- 上期值=基数代销理财余额
               WHEN 'INDX_0062' THEN MAX(bs.base_loan_bal)         -- 上期值=基数贷款余额
           END,
           s.persn_legal_bk_code                  -- 法人行号
      FROM TMP_STAT_INDX_SCOPE s                  -- 指标统计范围表（A路径源数据）
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER d   -- 指标基数成员表
        ON d.statis_calib        = '营销活动'         -- 统计口径=营销活动
       AND d.statis_dim          = s.statis_dim   -- 统计维度一致
       AND d.data_blng           = s.data_blng    -- 归属机构一致
       AND d.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
     INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs     -- 指标基数汇总表
        ON bs.statis_calib        = '营销活动'        -- 统计口径=营销活动
       AND bs.statis_dim          = s.statis_dim  -- 统计维度一致
       AND bs.indx_code           = s.indx_code   -- 指标编码一致
       AND bs.data_blng           = s.data_blng   -- 归属机构一致
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN (
          SELECT cust_id, persn_legal_bk_code, bal_type, fin_bal,  -- 客户ID, 法人行号, 余额类型, 理财余额
                 close_agen_fin_bal, open_agen_fin_bal, loan_bal   -- 封闭期代销理财余额, 开放期代销理财余额, 贷款余额
            FROM DWS_CUST_ASSE_LIAB                                -- 客户资产负债表（当日）
           WHERE data_date = v_sysdat                              -- 取跑批日数据
             AND EXISTS (SELECT 1 FROM ADS_STAT_INDX_BASELINE_MEMBER d2 WHERE d2.cust_id = DWS_CUST_ASSE_LIAB.cust_id AND d2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB.persn_legal_bk_code)   -- 仅统计基数范围内客户
      ) b
        ON b.cust_id             = d.cust_id                                  -- 按客户ID关联
       AND b.persn_legal_bk_code = d.persn_legal_bk_code                      -- 法人行号一致
     WHERE s.path_code = 'A'                                                  -- 仅A路径
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')   -- 仅理财/贷款类指标
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;  -- 按机构/维度/指标/法人行聚合

    -------------------------------------------------------------------------
    -- 目标任务路径（B）：理财产品/代销理财/贷款 0055/0056/0057/0058/0059/0060/0062
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_004 (
        path_code, data_date, data_blng, statis_dim, statis_calib,-- 路径, 数据日期, 归属机构, 统计维度, 统计口径
        indx_code, curnt_val, term_last_val, persn_legal_bk_code  -- 指标编码, 当期值, 上期值, 法人行号
    )
    SELECT 'B', v_sysdat, s.data_blng, s.statis_dim, '目标任务', s.indx_code,                                                                                                       -- 路径B/数据日期/归属机构/统计维度/口径/指标编码
           CASE s.indx_code                                                                                                                                                     -- 按指标编码取当期增量
               WHEN 'INDX_0055' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_fin)                                                -- 当年日均理财增量
               WHEN 'INDX_0056' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_fin)                                               -- 当月日均理财增量
               WHEN 'INDX_0057' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal, 0) ELSE 0 END) - MAX(bs.base_fin_bal)                                                   -- 当月理财新增
               WHEN 'INDX_0058' THEN SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_yr_avg_agen_fin)  -- 当年日均代销理财增量
               WHEN 'INDX_0059' THEN SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_mth_avg_agen_fin) -- 当月日均代销理财增量
               WHEN 'INDX_0060' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END) - MAX(bs.base_agen_fin_bal)     -- 当月代销理财新增
               WHEN 'INDX_0062' THEN SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END) - MAX(bs.base_loan_bal)                                                 -- 当月贷款新增
           END,
           CASE s.indx_code                                        -- 按指标编码取对应上期值
               WHEN 'INDX_0055' THEN MAX(bs.base_yr_avg_fin)       -- 上期值=年度基数日均理财
               WHEN 'INDX_0056' THEN MAX(bs.base_mth_avg_fin)      -- 上期值=月份基数日均理财
               WHEN 'INDX_0057' THEN MAX(bs.base_fin_bal)          -- 上期值=基数理财余额
               WHEN 'INDX_0058' THEN MAX(bs.base_yr_avg_agen_fin)  -- 上期值=年度基数日均代销理财
               WHEN 'INDX_0059' THEN MAX(bs.base_mth_avg_agen_fin) -- 上期值=月份基数日均代销理财
               WHEN 'INDX_0060' THEN MAX(bs.base_agen_fin_bal)     -- 上期值=基数代销理财余额
               WHEN 'INDX_0062' THEN MAX(bs.base_loan_bal)         -- 上期值=基数贷款余额
           END,
           s.persn_legal_bk_code                  -- 法人行号
      FROM TMP_STAT_INDX_SCOPE s                  -- 指标统计范围表（B路径源数据）
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER d   -- 指标基数成员表
        ON d.statis_calib        = '目标任务'         -- 统计口径=目标任务
       AND d.statis_dim          = s.statis_dim   -- 统计维度一致
       AND d.data_blng           = s.data_blng    -- 归属机构一致
       AND d.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
     INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs     -- 指标基数汇总表
        ON bs.statis_calib        = '目标任务'        -- 统计口径=目标任务
       AND bs.statis_dim          = s.statis_dim  -- 统计维度一致
       AND bs.indx_code           = s.indx_code   -- 指标编码一致
       AND bs.data_blng           = s.data_blng   -- 归属机构一致
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code   -- 法人行号一致
      LEFT JOIN (
          SELECT cust_id, persn_legal_bk_code, bal_type, fin_bal,  -- 客户ID, 法人行号, 余额类型, 理财余额
                 close_agen_fin_bal, open_agen_fin_bal, loan_bal   -- 封闭期代销理财余额, 开放期代销理财余额, 贷款余额
            FROM DWS_CUST_ASSE_LIAB                                -- 客户资产负债表（当日）
           WHERE data_date = v_sysdat                              -- 取跑批日数据
             AND EXISTS (SELECT 1 FROM ADS_STAT_INDX_BASELINE_MEMBER d2 WHERE d2.cust_id = DWS_CUST_ASSE_LIAB.cust_id AND d2.persn_legal_bk_code = DWS_CUST_ASSE_LIAB.persn_legal_bk_code)   -- 仅统计基数范围内客户
      ) b
        ON b.cust_id             = d.cust_id                                  -- 按客户ID关联
       AND b.persn_legal_bk_code = d.persn_legal_bk_code                      -- 法人行号一致
     WHERE s.path_code = 'B'                                                  -- 仅B路径
       AND s.indx_code IN ('INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')   -- 仅理财/贷款类指标
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;  -- 按机构/维度/指标/法人行聚合

    outcde := SQL%ROWCOUNT;  -- 返回最近DML影响行数
    -------------------------------------------------------------------------
    -- 提交事务并记录成功日志
    -------------------------------------------------------------------------
    COMMIT;                                                   -- 提交事务
    V_END_DATE := SYSDATE;                                    -- 记录过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时秒数
    V_LOG_MSG := '步骤4处理完成，行数=' || NVL(outcde, 0);             -- 组装成功日志消息
    V_LOG_FLG := 0;                                           -- 日志标志置成功
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录步骤日志
EXCEPTION
    -------------------------------------------------------------------------
    -- 异常处理：回滚事务、记录失败日志后向上抛出
    -------------------------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;                                                 -- 异常回滚事务
        outcde := -1;                                             -- 输出行数置-1表示失败
        V_END_DATE := SYSDATE;                                    -- 记录异常结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时秒数
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);                    -- 截取错误信息
        V_LOG_FLG := -1;                                          -- 日志标志置失败
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录错误日志
        RAISE;                                                    -- 重新抛出异常
END prc_ads_stat_indx_plan_004;