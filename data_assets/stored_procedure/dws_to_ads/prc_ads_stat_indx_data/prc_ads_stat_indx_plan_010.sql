-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_010
-- 功能说明: 指标数据统计，步骤10——合并各过程专属AGGR汇总表、强校验后机构树上卷并原子发布到结果表
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2  跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER   输出（处理行数）
-- 需求版本: v1.1 (2026-08-26)
-- 变更记录:
--   v1.1 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v1.0 AGGR汇总表拆分配套：合并各过程专属表_003~_009至_010后统一强校验+落库
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_010(
    v_sysdat  IN  VARCHAR2,-- 跑批业务日期
    outcde    OUT INTEGER  -- 处理行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤1010处理完成 10';   -- 过程描述，用于日志
    V_PRC_NAME VARCHAR2(32)  := 'prc_ads_stat_indx_plan_010';   -- 过程名称，用于日志
    V_LOG_MSG VARCHAR2(4000);   -- 日志消息
    V_LOG_FLG INTEGER;          -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;  -- 日志按钮，1启用步骤日志
    V_NO_ID VARCHAR2(10);       -- 日志序号标识
    V_BGN_DATE DATE;            -- 过程开始时间
    V_END_DATE DATE;            -- 过程结束时间
    V_DURA_DATE INTEGER;        -- 过程耗时（秒）
    V_INVALID_CNT   INTEGER;    -- 空值非法行数统计
    V_DUPLICATE_CNT INTEGER;    -- 重复主键组数统计
BEGIN
    -------------------------------------------------------------------------
    -- 初始化运行参数并校验跑批业务日期
    -------------------------------------------------------------------------
    V_NO_ID := '0';                                                -- 初始化日志序号
    V_BGN_DATE := SYSDATE;                                         -- 记录过程开始时间
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN   -- 校验业务日期为非空8位数字
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 格式非法报错
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 业务日期字符串转日期型

    -------------------------------------------------------------------------
    -- 0. 合并各过程专属汇总临时表（TMP_STAT_INDX_AGGR_003 ~ _009）
    --    段首自清：防止重跑/并行残留
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_AGGR_010;

    INSERT INTO TMP_STAT_INDX_AGGR_010 (
        path_code,      -- 路径编码
        data_date,      -- 数据日期
        data_blng,      -- 归属机构
        statis_dim,     -- 统计维度
        statis_calib,   -- 统计口径
        indx_code,      -- 指标编码
        curnt_val,      -- 当期值
        term_last_val,  -- 上期值
        persn_legal_bk_code  -- 客户编码(个人/法人)
    )
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_003                        -- 步骤3专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_004                        -- 步骤4专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_005                        -- 步骤5专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_006                        -- 步骤6专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_007                        -- 步骤7专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_008                        -- 步骤8专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_dim,  -- 路径编码, 数据日期, 归属机构, 统计维度
           statis_calib, indx_code, curnt_val, term_last_val,   -- 统计口径, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_009;                       -- 步骤9专属汇总表
    -------------------------------------------------------------------------
    -- 发布前强校验：空值检查
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_INVALID_CNT  -- 统计空值非法行数
      FROM TMP_STAT_INDX_AGGR_010       -- 合并后的汇总表
     WHERE data_date           IS NULL  -- 数据日期为空
        OR data_blng           IS NULL  -- 归属机构为空
        OR statis_dim          IS NULL  -- 统计维度为空
        OR indx_code           IS NULL  -- 指标编码为空
        OR persn_legal_bk_code IS NULL; -- 法人行号为空

    -------------------------------------------------------------------------
    -- 发布前强校验：重复主键检查
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_DUPLICATE_CNT  -- 统计重复主键组数
      FROM (
          SELECT data_date, data_blng, statis_dim, statis_calib,  -- 数据日期, 归属机构, 统计维度, 统计口径
                 indx_code, persn_legal_bk_code                   -- 指标编码, 法人行号
            FROM TMP_STAT_INDX_AGGR_010                           -- 合并后的汇总表
           GROUP BY data_date, data_blng, statis_dim, statis_calib,   -- 按主键字段分组
                    indx_code, persn_legal_bk_code                -- 按主键字段分组
          HAVING COUNT(*) > 1                                     -- 出现重复的主键组
      );

    IF V_INVALID_CNT > 0 OR V_DUPLICATE_CNT > 0 THEN  -- 存在非法空值或重复主键即校验失败
        RAISE_APPLICATION_ERROR(-20002,               -- 抛出强校验失败错误
            '结果数据集发布前强校验失败: 非法结果行数=' || V_INVALID_CNT ||   -- 报出非法行数
            ', 重复主键组数=' || V_DUPLICATE_CNT);          -- 报出重复主键组数
    END IF;

    -------------------------------------------------------------------------
    -- 删除当日旧数据
    -------------------------------------------------------------------------
    DELETE FROM ADS_STAT_INDX_DATA WHERE data_date = v_sysdat;  -- 删除跑批当日的旧结果数据

    -------------------------------------------------------------------------
    -- 机构树上卷 + 原子发布
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_DATA (
        indx_code, data_blng, statis_dim, statis_calib,  -- 指标编码, 归属机构, 统计维度, 统计口径
        curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
    )
    WITH raw_aggr AS (
        SELECT data_date, data_blng, statis_dim, statis_calib,  -- 数据日期, 归属机构, 统计维度, 统计口径
               indx_code, curnt_val, term_last_val, persn_legal_bk_code   -- 指标编码, 当期值, 上期值, 法人行号
          FROM TMP_STAT_INDX_AGGR_010                           -- 合并后的汇总表（原始粒度）
    ),
    org_closure AS (
        SELECT org_id                 AS ancestor_org_id,  -- 祖先机构
               CONNECT_BY_ROOT org_id AS descendant_org_id -- 根(子孙)机构
          FROM DWD_SYS_ORG                                 -- 机构信息表
         START WITH org_id IN (                            -- 从结果中涉及的机构开始
             SELECT DISTINCT SUBSTR(r.data_blng, 5)        -- 提取归属机构编码（去掉ORG_前缀）
               FROM raw_aggr r                             -- 合并后明细汇总数据
              WHERE SUBSTR(r.data_blng, 1, 4) = 'ORG_')    -- 仅取机构型归属
       CONNECT BY NOCYCLE PRIOR sup_org_id = org_id        -- 按上级机构向上递归
               AND LEVEL < 20                              -- 限制机构层级数
    ),
    org_rolled_up AS (
        SELECT r.data_date,                                 -- 数据日期
               'ORG_' || c.ancestor_org_id AS data_blng,    -- 归属机构=祖先机构加前缀
               r.statis_dim,                                -- 统计维度
               r.statis_calib,                              -- 统计口径
               r.indx_code,                                 -- 指标编码
               SUM(r.curnt_val)      AS curnt_val,          -- 当期值上卷汇总
               SUM(r.term_last_val)  AS term_last_val,      -- 上期值上卷汇总
               r.persn_legal_bk_code                        -- 法人行号
          FROM raw_aggr r                                   -- 合并后明细汇总数据
         INNER JOIN org_closure c                           -- 机构上下级闭包关系
            ON r.data_blng = 'ORG_' || c.descendant_org_id  -- 明细机构匹配其祖先
           AND c.ancestor_org_id <> c.descendant_org_id     -- 排除自身（只上卷祖先）
         GROUP BY r.data_date, c.ancestor_org_id, r.statis_dim,   -- 按祖先机构汇总
                  r.statis_calib, r.indx_code, r.persn_legal_bk_code   -- 按祖先机构汇总
    )
    SELECT indx_code, data_blng, statis_dim, statis_calib,  -- 指标编码, 归属机构, 统计维度, 统计口径
           curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
      FROM raw_aggr                                         -- 原始机构粒度
    UNION ALL
    SELECT indx_code, data_blng, statis_dim, statis_calib,  -- 指标编码, 归属机构, 统计维度, 统计口径
           curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
      FROM org_rolled_up;                                   -- 上卷后的祖先机构

    outcde := SQL%ROWCOUNT;   -- 返回最近DML影响行数
    COMMIT;  -- 提交事务
    -------------------------------------------------------------------------
    -- 记录过程执行日志
    -------------------------------------------------------------------------
    V_END_DATE := SYSDATE;                                    -- 记录过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时秒数
    V_LOG_MSG := '步骤10处理完成，行数=' || NVL(outcde, 0);            -- 组装成功日志消息
    V_LOG_FLG := 0;                                           -- 日志标志置成功
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录步骤日志
EXCEPTION
    -------------------------------------------------------------------------
    -- 异常处理：回滚事务并记录错误日志后重新抛出
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
END prc_ads_stat_indx_plan_010;