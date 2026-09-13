-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_010
-- 功能说明: 指标数据统计，步骤10——合并各过程专属AGGR汇总表、强校验后机构树上卷并原子发布到结果表
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2  跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER   输出（处理行数）
-- 需求版本: v1.1 (2026-08-26)
-- 变更记录:
--   v1.4 (2026-09-13) 补零可见性保障：合并各步骤AGGR后，按分发清单TMP_STAT_INDX_SCOPE补零缺失的(机构/客户经理+活动/任务+指标)组合，确保被分发对象无指标数据时目标表仍能取到0值行
--   2026-09-10 统计维度/统计口径内容互换：STATIS_DIM改存08/09路径编码、STATIS_CALIB改存活动号/任务号；单列表(范围/余额汇总/客户状态/贷款基数/代发基数等)STATIS_DIM列更名STATIS_CALIB
--   v1.3 (2026-09-10) 两段式发布修复与格式整理：INNERT语法错误修复；中转表转主表增加data_date当日过滤；主表删除清单补INDX_0082/0083；合并为单次COMMIT保证原子发布；修正日志描述与耗时统计
--   v1.2 (2026-09-10) 归属值去前缀：data_blng不再携带ORG_/MGR_前缀（与plan_001去前缀配套）；机构树上卷改用DWD_SYS_ORG成员判断识别机构型归属行
--   v1.1 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v1.0 AGGR汇总表拆分配套：合并各过程专属表_003~_009至_010后统一强校验+落库
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_010(
    v_sysdat  IN  VARCHAR2,-- 跑批业务日期
    outcde    OUT INTEGER  -- 处理行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤10处理完成';      -- 过程描述，用于日志
    V_PRC_NAME VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_010';   -- 过程名称，用于日志
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
        statis_calib,     -- 统计口径
        statis_dim,   -- 统计维度
        indx_code,      -- 指标编码
        curnt_val,      -- 当期值
        term_last_val,  -- 上期值
        persn_legal_bk_code  -- 客户编码(个人/法人)
    )
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_003                        -- 步骤3专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_004                        -- 步骤4专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_005                        -- 步骤5专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_006                        -- 步骤6专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_007                        -- 步骤7专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_008                        -- 步骤8专属汇总表
    UNION ALL
    SELECT path_code, data_date, data_blng, statis_calib,  -- 路径编码, 数据日期, 归属机构, 统计口径
           statis_dim, indx_code, curnt_val, term_last_val,   -- 统计维度, 指标编码, 当期值, 上期值
           persn_legal_bk_code                           -- 法人行号
      FROM TMP_STAT_INDX_AGGR_009;                       -- 步骤9专属汇总表
    -------------------------------------------------------------------------
    -- 补零可见性保障：被分发的机构/客户经理在活动/任务下的指标若无数据，落0行，
    -- 确保目标表能取到被分发对象（指标为0也显示）；仅覆盖本流水线指标范围0046~0083
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_010 (
        path_code, data_date, data_blng, statis_calib, statis_dim,
        indx_code, curnt_val, term_last_val, persn_legal_bk_code
    )
    SELECT s.path_code, v_sysdat, s.data_blng, s.statis_calib, s.path_code,
           s.indx_code, 0, 0, s.persn_legal_bk_code
      FROM (SELECT DISTINCT path_code, statis_calib, indx_code, data_blng, persn_legal_bk_code
              FROM TMP_STAT_INDX_SCOPE) s
     WHERE s.indx_code >= 'INDX_0046'
       AND s.indx_code <= 'INDX_0083'
       AND NOT EXISTS (SELECT 1
                         FROM TMP_STAT_INDX_AGGR_010 t
                        WHERE t.data_date           = v_sysdat
                          AND t.data_blng           = s.data_blng
                          AND t.statis_calib        = s.statis_calib
                          AND t.statis_dim          = s.path_code
                          AND t.indx_code           = s.indx_code
                          AND t.persn_legal_bk_code = s.persn_legal_bk_code);
    -------------------------------------------------------------------------
    -- 发布前强校验：空值检查
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_INVALID_CNT  -- 统计空值非法行数
      FROM TMP_STAT_INDX_AGGR_010       -- 合并后的汇总表
     WHERE data_date           IS NULL  -- 数据日期为空
        OR data_blng           IS NULL  -- 归属机构为空
        OR statis_calib          IS NULL  -- 统计口径为空
        OR indx_code           IS NULL  -- 指标编码为空
        OR persn_legal_bk_code IS NULL; -- 法人行号为空

    -------------------------------------------------------------------------
    -- 发布前强校验：重复主键检查
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_DUPLICATE_CNT  -- 统计重复主键组数
      FROM (
          SELECT data_date, data_blng, statis_calib, statis_dim,  -- 数据日期, 归属机构, 统计口径, 统计维度
                 indx_code, persn_legal_bk_code                   -- 指标编码, 法人行号
            FROM TMP_STAT_INDX_AGGR_010                           -- 合并后的汇总表
           GROUP BY data_date, data_blng, statis_calib, statis_dim,   -- 按主键字段分组
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
    DELETE FROM ADS_STAT_INDX_DATA_MKT WHERE data_date = v_sysdat;  -- 删除跑批当日的旧结果数据

    -------------------------------------------------------------------------
    -- 机构树上卷 + 原子发布
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_DATA_MKT (
        indx_code, data_blng, statis_calib, statis_dim,  -- 指标编码, 归属机构, 统计口径, 统计维度
        curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
    )
    WITH raw_aggr AS (
        SELECT data_date, data_blng, statis_calib, statis_dim,  -- 数据日期, 归属机构, 统计口径, 统计维度
               indx_code, curnt_val, term_last_val, persn_legal_bk_code   -- 指标编码, 当期值, 上期值, 法人行号
          FROM TMP_STAT_INDX_AGGR_010                           -- 合并后的汇总表（原始粒度）
    ),
    org_closure AS (
        SELECT org_id                 AS ancestor_org_id,  -- 祖先机构
               CONNECT_BY_ROOT org_id AS descendant_org_id -- 根(子孙)机构
          FROM DWD_SYS_ORG                                 -- 机构信息表
         START WITH org_id IN (                            -- 从结果中涉及的机构开始
             SELECT DISTINCT r.data_blng                   -- 归属机构编码（裸值，无前缀）
               FROM raw_aggr r                             -- 合并后明细汇总数据
              WHERE EXISTS (SELECT 1 FROM DWD_SYS_ORG o WHERE o.org_id = r.data_blng)) -- 仅取机构型归属（机构编码命中机构表）
       CONNECT BY NOCYCLE PRIOR sup_org_id = org_id        -- 按上级机构向上递归
               AND LEVEL < 20                              -- 限制机构层级数
    ),
    org_rolled_up AS (
        SELECT r.data_date,                                 -- 数据日期
               c.ancestor_org_id AS data_blng,              -- 归属机构=祖先机构（裸值，无前缀）
               r.statis_calib,                                -- 统计口径
               r.statis_dim,                              -- 统计维度
               r.indx_code,                                 -- 指标编码
               SUM(r.curnt_val)      AS curnt_val,          -- 当期值上卷汇总
               SUM(r.term_last_val)  AS term_last_val,      -- 上期值上卷汇总
               r.persn_legal_bk_code                        -- 法人行号
          FROM raw_aggr r                                   -- 合并后明细汇总数据
         INNER JOIN org_closure c                           -- 机构上下级闭包关系
            ON r.data_blng = c.descendant_org_id            -- 明细机构匹配其祖先（裸值直接匹配）
           AND c.ancestor_org_id <> c.descendant_org_id     -- 排除自身（只上卷祖先）
         GROUP BY r.data_date, c.ancestor_org_id, r.statis_calib,   -- 按祖先机构汇总
                  r.statis_dim, r.indx_code, r.persn_legal_bk_code   -- 按祖先机构汇总
    )
    SELECT indx_code, data_blng, statis_calib, statis_dim,  -- 指标编码, 归属机构, 统计口径, 统计维度
           curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
      FROM raw_aggr                                         -- 原始机构粒度
    UNION ALL
    SELECT indx_code, data_blng, statis_calib, statis_dim,  -- 指标编码, 归属机构, 统计口径, 统计维度
           curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
      FROM org_rolled_up;                                   -- 上卷后的祖先机构

    outcde := SQL%ROWCOUNT;   -- 返回最近DML影响行数
    -------------------------------------------------------------------------
    -- 记录过程执行日志
    -------------------------------------------------------------------------
    V_END_DATE := SYSDATE;                                    -- 记录过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时秒数
    V_LOG_MSG := '步骤10处理完成，行数=' || NVL(outcde, 0);            -- 组装成功日志消息
    V_LOG_FLG := 0;                                           -- 日志标志置成功
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录步骤日志

    -------------------------------------------------------------------------
    --汇总到ADS_STAT_INDX_DATA表
    V_NO_ID := '2';                                                -- 初始化日志序号

    DELETE FROM ADS_STAT_INDX_DATA WHERE data_date = v_sysdat AND indx_code IN (                          -- 删除新流水线指标范围当日旧数据
        'INDX_0046','INDX_0047','INDX_0048','INDX_0049','INDX_0050','INDX_0051','INDX_0052','INDX_0053',   -- INDX_0046~INDX_0053
        'INDX_0054','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0061',   -- INDX_0054~INDX_0061
        'INDX_0062','INDX_0063','INDX_0064','INDX_0065','INDX_0066','INDX_0067','INDX_0068','INDX_0069',   -- INDX_0062~INDX_0069
        'INDX_0070','INDX_0071','INDX_0072','INDX_0073','INDX_0074','INDX_0075','INDX_0076','INDX_0077',   -- INDX_0070~INDX_0077
        'INDX_0078','INDX_0079','INDX_0080','INDX_0081','INDX_0082','INDX_0083');                          -- INDX_0078~INDX_0083

    INSERT INTO ADS_STAT_INDX_DATA (
        indx_code, data_blng, statis_calib, statis_dim,  -- 指标编码, 归属机构, 统计口径, 统计维度
        curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
    )
    SELECT indx_code, data_blng, statis_calib, statis_dim,  -- 指标编码, 归属机构, 统计口径, 统计维度
        curnt_val, term_last_val, data_date, persn_legal_bk_code   -- 当期值, 上期值, 数据日期, 法人行号
    FROM ADS_STAT_INDX_DATA_MKT
        WHERE data_date = v_sysdat;   -- 仅取当日发布的数据
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