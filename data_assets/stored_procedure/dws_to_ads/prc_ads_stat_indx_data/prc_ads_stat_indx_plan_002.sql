------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_002
-- 功能说明: 指标数据统计——指标基数据冻结处理（冻结成员/明细/汇总及个贷期初基准）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（处理行数/结果标志）
-- 需求版本: v4.7 (2026-08-26)
-- 变更记录:
--   v4.7 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v4.8 (2026-09-02) 基数口径按路径拆分——路径08维持开始日前一天一次性冻结；路径09改为基准日固定(term_begin_date-1)+任务期内每日DELETE+重算；取数分流：基准日=跑批日走主表/<跑批日走HIS表；0066五级分类改用DWS_CUST_CLASSFIVE（期初按基准日/当前按跑批日）；新增V_BASE_DATE、TASK_BASE_CTE（任务期对象收集）；§3.3b仅保留路径08补跑分支
--   v4.6 0050/0051纳入基数冻结范围；新增存量活动0050/0051基准补跑分支(3.3b)；
--        汇总表新增BASE_YR_AVG_DEPO/BASE_MTH_AVG_DEPO两列；强校验覆盖0050/0051
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_002(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    outcde OUT INTEGER  -- 处理行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤22处理完成 2';  -- 步骤描述文本（步骤22处理完成）
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_002';  -- 过程名
    V_LOG_MSG    VARCHAR2(4000);  -- 日志消息文本
    V_LOG_FLG    INTEGER;         -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;    -- 日志按钮标识
    V_NO_ID      VARCHAR2(10);    -- 跑批序号
    V_BGN_DATE   DATE;            -- 开始时间
    V_END_DATE   DATE;            -- 结束时间
    V_DURA_DATE  INTEGER;         -- 耗时（秒）
    V_NEXT_DAY   VARCHAR2(8);     -- 活动/任务开始日期（YYYYMMDD）
    V_MISSING_CNT INTEGER;        -- 缺失基准的计数
    V_BASE_DATE  VARCHAR2(8);     -- 基准日（固定=开始日前一天，sys_fun_deal_date(term_begin_date,1)；用于取数分流）
BEGIN
    -------------------------------------------------------------------------
    -- 标准模板：参数校验与开始日志状态
    -------------------------------------------------------------------------
    V_NO_ID := '0';                                                -- 跑批序号置0
    V_BGN_DATE := SYSDATE;                                         -- 记录开始时间
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN  -- 校验跑批日期必须为8位数字YYYYMMDD
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 日期格式非法则报错终止
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 将跑批日期字符串转为日期类型

    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_NEXT_DAY := sys_fun_deal_date(v_sysdat, 31);  -- 调用日期处理函数获取活动/任务开始日期（下一自然日）

    -------------------------------------------------------------------------
    -- 3.1 冻结成员表 ADS_STAT_INDX_BASELINE_MEMBER
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER (        -- 插入冻结成员表
        statis_calib, statis_dim, data_blng, cust_id,  -- 统计口径、统计维度、数据归属、客户ID
        persn_legal_bk_code, base_data_date, base_run_date  -- 法人机构编号、基准数据日期、基准跑批日期
    )
    WITH scope_member AS (  -- 组装本次需冻结的成员范围（A/B多路径汇总）
        -- 路径08：营销活动成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,    -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code    -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s                                   -- 指标范围临时表
         INNER JOIN DWD_MKT_TSK_INFO ti                                -- 关联营销活动任务信息表
            ON s.path_code             = '08'                           -- 限定路径08（营销活动）
           AND ti.mkt_act_id           = s.statis_dim                  -- 营销活动ID等于统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code         -- 法人机构编号一致
           AND ti.data_date            = v_sysdat                      -- 取跑批日期当日的活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)   -- 按机构归属匹配活动归属机构
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))  -- 按客户经理归属匹配活动客户经理
         WHERE s.term_begin_date = V_NEXT_DAY                          -- 仅取开始日期为今日（活动昨日建立）的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 仅取需冻结的指标集合（含新增0050/0051）
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码

        UNION  -- 合并去重

        -- 路径09-机构归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, lv.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s                                 -- 指标范围临时表
         INNER JOIN DWS_CUST_LVL_INFO lv                             -- 关联客户层级信息表
            ON s.path_code             = '09'                         -- 限定路径09（目标任务）
           AND s.blng_type             = 'O'                         -- 归属类型为机构
           AND lv.org_id               = s.blng_id                   -- 客户机构ID等于范围归属机构ID
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code       -- 法人机构编号一致
           AND lv.data_date            = v_sysdat                    -- 取跑批日期当日的客户层级信息
         WHERE s.term_begin_date = V_NEXT_DAY                        -- 仅取开始日期为今日的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 需冻结的指标集合
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码

        UNION  -- 合并去重

        -- 路径09-客户经理归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, cm.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s                                 -- 指标范围临时表
         INNER JOIN DWD_CUST_MAN cm                                  -- 关联客户经理归属表
            ON s.path_code             = '09'                         -- 限定路径09（目标任务）
           AND s.blng_type             = 'M'                         -- 归属类型为客户经理
           AND cm.mngr_post_id         = s.blng_id                   -- 客户经理岗位ID等于范围归属岗位ID
           AND cm.mng_typ              = '1'                         -- 客户经理类型为主号
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code       -- 法人机构编号一致
         WHERE s.term_begin_date = V_NEXT_DAY                        -- 仅取开始日期为今日的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 需冻结的指标集合
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码
    )
    SELECT DISTINCT                      -- 客户维度去重
           '08' AS statis_calib,  -- 按路径映射统计口径
           sm.statis_dim,                -- 统计维度（活动ID/任务机构岗位ID）
           sm.data_blng,                 -- 数据归属
           sm.cust_id,                   -- 客户ID
           sm.persn_legal_bk_code,       -- 法人机构编号
           v_sysdat  AS base_data_date,  -- 基准数据日期=跑批日期
           v_sysdat  AS base_run_date    -- 基准跑批日期=跑批日期
      FROM scope_member sm               -- 范围成员结果集
     WHERE NOT EXISTS (                  -- 过滤掉已存在的成员基准，避免重复冻结
         SELECT 1
           FROM ADS_STAT_INDX_BASELINE_MEMBER x                 -- 冻结成员表
          WHERE x.statis_calib        = '08'  -- 口径一致
            AND x.statis_dim          = sm.statis_dim           -- 维度一致
            AND x.data_blng           = sm.data_blng            -- 归属一致
            AND x.cust_id             = sm.cust_id              -- 客户一致
            AND x.persn_legal_bk_code = sm.persn_legal_bk_code  -- 法人机构一致
     );

    -- =========================================================== 09每日重算（v4.8） ==============
    -- 3.1b 目标任务：进行中任务每日重算 ADS_STAT_INDX_BASELINE_MEMBER（路径09专用；基准日=term_begin_date前1天，
    --        基准日=跑批日走主表 DWS_CUST_LVL_INFO / 基准日<跑批日走 HIS 表 DWS_CUST_LVL_INFO_HIS；
    --        DELETE按任务键整删整插，同键仅保留当日最新行；下游 join 键不含 base_data_date，取数透明 -------------
    -- 1) DELETE：清掉本次进行中任务键的已有基准（整删整插，保证当日一行）-------------------------------
    DELETE FROM ADS_STAT_INDX_BASELINE_MEMBER WHERE ROWID IN (    -- 按任务键删除旧的基准行
       SELECT m.ROWID FROM ADS_STAT_INDX_BASELINE_MEMBER m        -- 指标基准成员表
      INNER JOIN TMP_STAT_INDX_SCOPE s                            -- 指标范围临时表
         ON m.statis_calib        = '09'                          -- 仅目标任务路径
        AND s.path_code           = '09'                          -- 仅09路径
        AND m.statis_dim          = s.statis_dim                   -- 统计维度(任务编号)一致
        AND m.data_blng           = s.data_blng                    -- 数据归属（机构/经理）一致
        AND m.persn_legal_bk_code = s.persn_legal_bk_code          -- 法人行号一致
       WHERE s.term_begin_date <= v_sysdat                         -- 任务已开始或冻结日
         AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 基准指标范围
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')
         AND EXISTS (                                              -- 仅保留「进行中」任务：tsk_end_date >= 跑批日
             SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub               -- 任务指标子表
             WHERE sub.indx_tsk_id    = s.statis_dim               -- 任务编号匹配
               AND NVL(sub.tsk_end_date,'99991231') >= v_sysdat  -- 任务未结束
         )
    );

    -- 2) INSERT：本次进行中09任务的基准成员 ----------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER (                   -- 插入冻结成员表（路径09每日重算）
        statis_calib, statis_dim, data_blng, cust_id, persn_legal_bk_code, base_data_date, base_run_date  -- 口径/维度/归属/客户/法人行号/基准日/跑批日
    )
    WITH task_lvl_src AS (                                        -- 客户等级基准取数源分流（v4.8）：基准日=跑批日主表 / <跑批日HIS表
         SELECT 'MAIN' AS src_flg, org_id, cust_id, cust_lvl, persn_legal_bk_code, data_date
           FROM DWS_CUST_LVL_INFO lv                              -- 客户等级主表（仅当日快照）
          WHERE v_sysdat IN (SELECT sys_fun_deal_date(s2.term_begin_date, 1) FROM TMP_STAT_INDX_SCOPE s2 WHERE s2.path_code = '09')  -- 基准日=跑批日时才读主表
         UNION ALL
         SELECT 'HIS'  AS src_flg, org_id, cust_id, cust_lvl, persn_legal_bk_code, data_date
           FROM DWS_CUST_LVL_INFO_HIS                             -- 客户等级历史快照表
          WHERE v_sysdat NOT IN (SELECT sys_fun_deal_date(s2.term_begin_date, 1) FROM TMP_STAT_INDX_SCOPE s2 WHERE s2.path_code = '09')  -- 基准日<跑批日时读HIS表
     ), scope_member_09 AS (                                      -- 路径09进行中任务的客户范围（O机构型+M经理型）
         -- 09-O（机构归属）：等级表按基准日取 cust_id ----------------------------------------------
         SELECT s.statis_dim, s.indx_code, s.data_blng, s.term_begin_date, lv.cust_id, s.persn_legal_bk_code
           FROM TMP_STAT_INDX_SCOPE s                             -- 指标范围临时表
          INNER JOIN task_lvl_src lv                              -- 客户等级基准源（已分主表/HIS表）
             ON s.path_code            = '09'                      -- 仅目标任务路径
            AND s.blng_type            = 'O'                      -- 机构归属型
            AND lv.org_id              = s.blng_id                 -- 归属机构ID一致
            AND lv.persn_legal_bk_code = s.persn_legal_bk_code     -- 法人行号一致
            AND lv.data_date           = sys_fun_deal_date(s.term_begin_date, 1)  -- 取 任务开始日前一天 基准快照（与冻结基准同口径）
          WHERE s.term_begin_date   <= v_sysdat                    -- 任务已开始/冻结日
            AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 基准指标范围
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')
            AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub WHERE sub.indx_tsk_id = s.statis_dim AND NVL(sub.tsk_end_date,'99991231') >= v_sysdat)  -- 进行中任务
         UNION
         -- 09-M（客户经理归属）：DWD_CUST_MAN 无历史表，按当日管户取 cust_id ----------------------------
         SELECT s.statis_dim, s.indx_code, s.data_blng, s.term_begin_date, cm.cust_id, s.persn_legal_bk_code
           FROM TMP_STAT_INDX_SCOPE s                             -- 指标范围临时表
          INNER JOIN DWD_CUST_MAN cm                              -- 客户-经理管户表（v4.8 注：无历史，名单按当日）
             ON s.path_code            = '09'                      -- 仅目标任务路径
            AND s.blng_type            = 'M'                      -- 客户经理归属型
            AND cm.mngr_post_id        = s.blng_id                 -- 客户经理岗位ID一致
            AND cm.mng_typ             = '1'                      -- 只取责任管户（借贷管户待确认）
            AND cm.persn_legal_bk_code = s.persn_legal_bk_code     -- 法人行号一致
          WHERE s.term_begin_date   <= v_sysdat                    -- 任务已开始/冻结日
            AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 基准指标范围
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')
            AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub WHERE sub.indx_tsk_id = s.statis_dim AND NVL(sub.tsk_end_date,'99991231') >= v_sysdat)  -- 进行中任务
     )
     SELECT DISTINCT                                              -- 去重（同一客户可能同时命中O型+M型）
            '09'             AS statis_calib,                      -- 统计口径=09目标任务
            sm.statis_dim,                                         -- 统计维度=任务编号
            sm.data_blng,                                          -- 数据归属（机构/经理）
            sm.cust_id,                                            -- 客户编号
            sm.persn_legal_bk_code,                                -- 法人行号
            sys_fun_deal_date(sm.term_begin_date, 1) AS base_data_date,  -- 基准业务日期=任务开始日前一天（固定）
            v_sysdat         AS base_run_date                      -- 基准落库跑批日=本次跑批日
       FROM scope_member_09 sm;                                    -- 路径09进行中任务范围
    -- =========================================================== 09每日重算 结束 ==================


    -------------------------------------------------------------------------
    -- 3.2 冻结明细表 ADS_STAT_INDX_BASELINE_DTL
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_DTL (                 -- 插入冻结明细表
        statis_calib, statis_dim, indx_code, data_blng, cust_id,  -- 统计口径、统计维度、指标代码、数据归属、客户ID
        persn_legal_bk_code, base_data_date, base_run_date,  -- 法人机构编号、基准数据日期、基准跑批日期
        base_cust_lvl, base_mth_avg_aum                      -- 基准客户等级、基准月日均AUM
    )
    SELECT CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END,  -- 路径映射统计口径
           s.statis_dim,                                             -- 统计维度
           s.indx_code,                                              -- 指标代码
           s.data_blng,                                              -- 数据归属
           m.cust_id,                                                -- 客户ID（取自成员基准）
           m.persn_legal_bk_code,                                    -- 法人机构编号
           m.base_data_date,                                         -- 基准数据日期
           m.base_run_date,                                          -- 基准跑批日期
           CASE WHEN s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054')  -- 仅客户维护/客户提升/新增类指标需要客户等级
                THEN lv.cust_lvl END,                                -- 取客户层级
           CASE WHEN s.indx_code = 'INDX_0063'                       -- 仅月日均AUM指标需要
                THEN b.aum_bal END                                   -- 取月日均金融资产余额
      FROM TMP_STAT_INDX_SCOPE s                                     -- 指标范围临时表
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m                      -- 关联已冻结的成员基准
        ON m.statis_calib        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END  -- 口径一致
       AND m.statis_dim          = s.statis_dim                      -- 维度一致
       AND m.data_blng           = s.data_blng                       -- 归属一致
       AND m.persn_legal_bk_code = s.persn_legal_bk_code             -- 法人机构一致
      LEFT JOIN DWS_CUST_LVL_INFO lv                                 -- 关联客户层级信息
        ON lv.cust_id             = m.cust_id                        -- 客户ID一致
       AND lv.persn_legal_bk_code = m.persn_legal_bk_code            -- 法人机构一致
       AND lv.data_date           = v_sysdat                         -- 取跑批日期当日层级
      LEFT JOIN DWS_CUST_ASSE_LIAB b                                 -- 关联资产负债表
        ON b.cust_id             = m.cust_id                         -- 客户ID一致
       AND b.persn_legal_bk_code = m.persn_legal_bk_code             -- 法人机构一致
       AND b.data_date           = v_sysdat                          -- 取跑批日期当日余额
       AND b.bal_type            = '2'                               -- 余额类型为月日均
     WHERE s.term_begin_date = V_NEXT_DAY                            -- 仅取开始日期为今日的范围
       AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')  -- 仅需冻结明细的指标
       AND (s.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)  -- 需客户等级的指标必须能取到层级（内连接效果）
       AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL)     -- 需AUM的指标必须能取到余额（内连接效果）
       AND NOT EXISTS (                                              -- 过滤已冻结的明细，避免重复
           SELECT 1
             FROM ADS_STAT_INDX_BASELINE_DTL d                   -- 冻结明细表
            WHERE d.statis_calib        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END  -- 口径一致
              AND d.statis_dim          = s.statis_dim           -- 维度一致
              AND d.indx_code           = s.indx_code            -- 指标一致
              AND d.data_blng           = s.data_blng            -- 归属一致
              AND d.cust_id             = m.cust_id              -- 客户一致
              AND d.persn_legal_bk_code = m.persn_legal_bk_code  -- 法人机构一致
       );

    -- =========================================================== 09每日重算（v4.8） ==============
    -- 3.2b 目标任务：进行中任务每日重算 ADS_STAT_INDX_BASELINE_DTL（路径09专用；取数源分流）
    --        DELETE按(path+dim+indx+blng+bk+cust)整删整插；基准固定为 task_begin_date前1天快照 -----
    -- 1) DELETE：清掉进行中09任务的 DTL ----------------------------------------------------------------
    DELETE FROM ADS_STAT_INDX_BASELINE_DTL WHERE ROWID IN (       -- 按任务键+指标+客户删除旧基准
       SELECT d.ROWID FROM ADS_STAT_INDX_BASELINE_DTL d           -- 基准明细表
      INNER JOIN TMP_STAT_INDX_SCOPE s                            -- 指标范围临时表
         ON d.statis_calib        = '09'                    -- 仅09路径基准
        AND s.path_code           = '09'                    -- 仅09路径
        AND d.statis_dim          = s.statis_dim                   -- 统计维度一致
        AND d.indx_code           = s.indx_code                    -- 指标一致
        AND d.data_blng           = s.data_blng                    -- 归属一致
        AND d.persn_legal_bk_code = s.persn_legal_bk_code          -- 法人行号一致
        AND d.cust_id IN (SELECT m.cust_id FROM ADS_STAT_INDX_BASELINE_MEMBER m WHERE m.statis_calib='09' AND m.statis_dim=s.statis_dim AND m.data_blng=s.data_blng AND m.persn_legal_bk_code=s.persn_legal_bk_code)
       WHERE s.term_begin_date <= v_sysdat                         -- 任务已开始/冻结日
         AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')
         AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub WHERE sub.indx_tsk_id=s.statis_dim AND NVL(sub.tsk_end_date,'99991231')>=v_sysdat)
    );

    -- 2) INSERT：DTL 基准重灌 --------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_DTL (                       -- 插入基准明细表（路径09每日重算）
        statis_calib, statis_dim, indx_code, data_blng, cust_id, persn_legal_bk_code, base_data_date, base_run_date, base_cust_lvl, base_mth_avg_aum  -- DTL基准字段列表
    )
    WITH task_lv_src AS (                                          -- 客户等级取数源分流：基准日=跑批日主表 / <跑批日HIS表
         SELECT 'MAIN' AS src_flg, cust_id, persn_legal_bk_code, cust_lvl, data_date
           FROM DWS_CUST_LVL_INFO lv                              -- 客户等级主表（当日快照）
          WHERE v_sysdat IN (SELECT sys_fun_deal_date(s2.term_begin_date,1) FROM TMP_STAT_INDX_SCOPE s2 WHERE s2.path_code='09')
         UNION ALL
         SELECT 'HIS'  AS src_flg, cust_id, persn_legal_bk_code, cust_lvl, data_date
           FROM DWS_CUST_LVL_INFO_HIS                             -- 客户等级历史快照
          WHERE v_sysdat NOT IN (SELECT sys_fun_deal_date(s2.term_begin_date,1) FROM TMP_STAT_INDX_SCOPE s2 WHERE s2.path_code='09')
     ), task_au_src AS (                                          -- AUM取数源分流：基准日=跑批日主表 / <跑批日HIS表
         SELECT 'MAIN' AS src_flg, cust_id, persn_legal_bk_code, aum_bal, data_date, bal_type
           FROM DWS_CUST_ASSE_LIAB b                              -- 资产负债主表
          WHERE v_sysdat IN (SELECT sys_fun_deal_date(s2.term_begin_date,1) FROM TMP_STAT_INDX_SCOPE s2 WHERE s2.path_code='09') AND b.bal_type='2'
         UNION ALL
         SELECT 'HIS'  AS src_flg, cust_id, persn_legal_bk_code, aum_bal, data_date, bal_type
           FROM DWS_CUST_ASSE_LIAB_HIS b_his                      -- 资产负债历史快照
          WHERE v_sysdat NOT IN (SELECT sys_fun_deal_date(s2.term_begin_date,1) FROM TMP_STAT_INDX_SCOPE s2 WHERE s2.path_code='09') AND b_his.bal_type='2')
     SELECT '09',                                          -- 统计口径=09目标任务
            s.statis_dim,                                          -- 统计维度=任务编号
            s.indx_code,                                           -- 指标编码
            s.data_blng,                                           -- 数据归属
            m.cust_id,                                             -- 客户编号（来自MEMBER重算段）
            m.persn_legal_bk_code,                                 -- 法人行号
            sys_fun_deal_date(s.term_begin_date, 1)         AS base_data_date,  -- 基准业务日期（固定）
            v_sysdat                                         AS base_run_date,  -- 本次跑批日
            CASE WHEN s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054') THEN lv.cust_lvl END  AS base_cust_lvl,  -- 层级基准
            CASE WHEN s.indx_code = 'INDX_0063' THEN b.aum_bal END                              AS base_mth_avg_aum  -- 临界AUM基准(月日均BAL_TYPE=2)
       FROM TMP_STAT_INDX_SCOPE s                                   -- 指标范围临时表
      INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m                    -- 已重算的09成员基准
         ON m.statis_calib        = '09'                    -- 仅09路径MEMBER
        AND s.path_code           = '09'
        AND m.statis_dim          = s.statis_dim
        AND m.data_blng           = s.data_blng
        AND m.persn_legal_bk_code = s.persn_legal_bk_code
      INNER JOIN task_lv_src lv                                    -- 客户等级基准源（取对应基准日快照）
         ON lv.cust_id             = m.cust_id
        AND lv.persn_legal_bk_code = m.persn_legal_bk_code
        AND lv.data_date           = sys_fun_deal_date(s.term_begin_date, 1)
       LEFT JOIN task_au_src b                                     -- AUM基准源（取对应基准日BAL_TYPE=2快照）
         ON b.cust_id              = m.cust_id
        AND b.persn_legal_bk_code  = m.persn_legal_bk_code
        AND b.data_date            = sys_fun_deal_date(s.term_begin_date, 1)
        AND b.bal_type             = '2'
      WHERE s.term_begin_date <= v_sysdat                          -- 任务已开始/冻结日
        AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')
        AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub WHERE sub.indx_tsk_id=s.statis_dim AND NVL(sub.tsk_end_date,'99991231')>=v_sysdat)  -- 进行中任务
        AND (s.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)  -- 层级指标缺等级跳过
        AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL);  -- 临界AUM指标缺快照跳过
    -- =========================================================== 09每日重算 结束 ==================


    -------------------------------------------------------------------------
    -- 3.3 冻结汇总表 ADS_STAT_INDX_BASELINE_SUM
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (                            -- 插入冻结汇总表
        statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code,  -- 统计口径、统计维度、指标代码、数据归属、法人机构编号
        base_data_date, base_run_date, base_loan_bal, base_yr_avg_fin,  -- 基准数据日期、基准跑批日期、基准贷款余额、基准年日均金融资产
        base_mth_avg_fin, base_yr_avg_agen_fin, base_mth_avg_agen_fin,  -- 基准月日均金融资产、基准年日均代发金融资产、基准月日均代发金融资产
        base_fin_bal, base_agen_fin_bal,                                -- 基准金融资产余额、基准代发金融资产余额
        base_yr_avg_depo, base_mth_avg_depo                             -- 基准年日均存款、基准月日均存款（v4.6新增）
    )
    WITH task_asse_src AS (                                          -- v4.8 ASSE基准源分流：基准日=跑批日主表 / <跑批日HIS表
         SELECT 'MAIN' AS src_flg, cust_id, persn_legal_bk_code, data_date, bal_type,
                loan_bal, fin_bal, close_agen_fin_bal, open_agen_fin_bal, depo_bal
           FROM DWS_CUST_ASSE_LIAB b                               -- ASSE主表（当日快照）
         UNION ALL
         SELECT 'HIS'  AS src_flg, cust_id, persn_legal_bk_code, data_date, bal_type,
                loan_bal, fin_bal, close_agen_fin_bal, open_agen_fin_bal, depo_bal
           FROM DWS_CUST_ASSE_LIAB_HIS b_his                       -- ASSE历史快照表
     )
    SELECT CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END,                                                     -- 路径映射统计口径
           s.statis_dim,                                                                                                -- 统计维度
           s.indx_code,                                                                                                 -- 指标代码
           s.data_blng,                                                                                                 -- 数据归属
           s.persn_legal_bk_code,                                                                                       -- 法人机构编号
           MAX(m.base_data_date),                                                                                       -- 取最大基准数据日期
           v_sysdat,                                                                                                    -- 基准跑批日期=跑批日期
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END),                                          -- 贷款余额（余额类型=贷款）
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END),                                           -- 年日均金融资产（余额类型=年日均）
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END),                                           -- 月日均金融资产（余额类型=月日均）
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),  -- 年日均代发金融资产（未代发+已代发余额）
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),  -- 月日均代发金融资产
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal, 0) ELSE 0 END),                                           -- 金融资产余额（余额类型=贷款时点为金融资产）
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),  -- 代发金融资产余额
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.depo_bal, 0) ELSE 0 END),                                          -- 年日均存款
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.depo_bal, 0) ELSE 0 END)                                           -- 月日均存款
      FROM TMP_STAT_INDX_SCOPE s                                                                                        -- 指标范围临时表
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m                                                                         -- 关联已冻结的成员基准
        ON m.statis_calib        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END                              -- 口径一致
       AND m.statis_dim          = s.statis_dim                                                                         -- 维度一致
       AND m.data_blng           = s.data_blng                                                                          -- 归属一致
       AND m.persn_legal_bk_code = s.persn_legal_bk_code                                                                -- 法人机构一致
      INNER JOIN task_asse_SRC b                                                                                              -- 关联资产负债余额表（仅取有余额的成员）
        ON b.cust_id             = m.cust_id                                                                            -- 客户ID一致
       AND b.persn_legal_bk_code = m.persn_legal_bk_code                                                                -- 法人机构一致
       AND b.data_date           = m.base_data_date                                                                     -- 余额取基准数据日期
     WHERE s.term_begin_date = V_NEXT_DAY                                                                               -- 仅取开始日期为今日的范围
       AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')  -- 需冻结至汇总表的指标集合
       AND NOT EXISTS (                                                                                                 -- 过滤已冻结的汇总，避免重复
           SELECT 1
             FROM ADS_STAT_INDX_BASELINE_SUM x                   -- 冻结汇总表
            WHERE x.statis_calib        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END  -- 口径一致
              AND x.statis_dim          = s.statis_dim           -- 维度一致
              AND x.indx_code           = s.indx_code            -- 指标一致
              AND x.data_blng           = s.data_blng            -- 归属一致
              AND x.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
       )
     GROUP BY s.path_code, s.statis_dim, s.indx_code, s.data_blng, s.persn_legal_bk_code;  -- 按路径/维度/指标/归属/法人机构分组汇总

    -- =========================================================== 09每日重算（v4.8） ==============
    -- 3.3a 目标任务：进行中任务每日重算 ADS_STAT_INDX_BASELINE_SUM（路径09专用）
    --        DELETE按(calib+dim+indx+blng+bk)整删整插；SUM源用task_asse_src09 CTE 主表/HIS分流 -----
    -- 1) DELETE：清掉进行中09任务的 SUM -------------------------------------------------------------
    DELETE FROM ADS_STAT_INDX_BASELINE_SUM WHERE ROWID IN (       -- 按任务键+指标删除旧SUM基准
       SELECT x.ROWID FROM ADS_STAT_INDX_BASELINE_SUM x          -- 基准汇总表
      INNER JOIN TMP_STAT_INDX_SCOPE s                           -- 指标范围临时表
         ON x.statis_calib        = '09'                   -- 仅09路径
        AND s.path_code           = '09'
        AND x.statis_dim          = s.statis_dim
        AND x.indx_code           = s.indx_code
        AND x.data_blng           = s.data_blng
        AND x.persn_legal_bk_code = s.persn_legal_bk_code
       WHERE s.term_begin_date <= v_sysdat
         AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')
         AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub WHERE sub.indx_tsk_id=s.statis_dim AND NVL(sub.tsk_end_date,'99991231')>=v_sysdat)
    );

    -- 2) INSERT：SUM基准重灌 ------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (                     -- 基准汇总表（09每日重算）
        statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code, base_data_date, base_run_date,
        base_loan_bal, base_yr_avg_fin, base_mth_avg_fin, base_yr_avg_agen_fin, base_mth_avg_agen_fin,
        base_fin_bal, base_agen_fin_bal, base_yr_avg_depo, base_mth_avg_depo
    )
    WITH task_asse_src09 AS (                                    -- ASSE基准源分流（v4.8）
         SELECT 'MAIN' AS src_flg, cust_id, persn_legal_bk_code, data_date, bal_type,
                loan_bal, fin_bal, close_agen_fin_bal, open_agen_fin_bal, depo_bal
           FROM DWS_CUST_ASSE_LIAB b                             -- 当日快照
         UNION ALL
         SELECT 'HIS'  AS src_flg, cust_id, persn_legal_bk_code, data_date, bal_type,
                loan_bal, fin_bal, close_agen_fin_bal, open_agen_fin_bal, depo_bal
           FROM DWS_CUST_ASSE_LIAB_HIS b_his                     -- 历史快照
     )
     SELECT '09',                                          -- 统计口径09
            s.statis_dim,                                         -- 维度=任务编号
            s.indx_code,                                          -- 指标编码
            s.data_blng,                                          -- 归属
            s.persn_legal_bk_code,                                -- 法人行号
            sys_fun_deal_date(s.term_begin_date, 1)       AS base_data_date,  -- 基准业务日期（固定）
            v_sysdat                                       AS base_run_date,  -- 本次跑批日
            SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal,0) ELSE 0 END),                    -- 个贷净增 LOAN_BAL
            SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal,0) ELSE 0 END),                     -- 理财年日均
            SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal,0) ELSE 0 END),                     -- 理财月日均
            SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END),  -- 代销年日均
            SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END),  -- 代销月日均
            SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal,0) ELSE 0 END),                      -- 理财余额
            SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal,0)+NVL(b.open_agen_fin_bal,0) ELSE 0 END),  -- 代销理财余额
            SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.depo_bal,0) ELSE 0 END),                     -- 0050储蓄年日均
            SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.depo_bal,0) ELSE 0 END)                      -- 0051储蓄月日均
       FROM TMP_STAT_INDX_SCOPE s                                  -- 指标范围临时表
      INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m                   -- 已重算的09成员基准
         ON m.statis_calib        = '09'
        AND s.path_code           = '09'
        AND m.statis_dim          = s.statis_dim
        AND m.data_blng           = s.data_blng
        AND m.persn_legal_bk_code = s.persn_legal_bk_code
      INNER JOIN task_asse_src09 b                                -- ASSE基准源（CTE已分流）
         ON b.cust_id             = m.cust_id
        AND b.persn_legal_bk_code = m.persn_legal_bk_code
        AND b.data_date           = sys_fun_deal_date(s.term_begin_date, 1)  -- 固定基准日匹配
      WHERE s.term_begin_date <= v_sysdat                         -- 任务已开始/冻结日
        AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')
        AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub WHERE sub.indx_tsk_id=s.statis_dim AND NVL(sub.tsk_end_date,'99991231')>=v_sysdat)  -- 进行中
      GROUP BY s.statis_dim, s.indx_code, s.data_blng, s.persn_legal_bk_code;  -- 分组汇总
    -- =========================================================== 09每日重算 结束 ==================




    -------------------------------------------------------------------------
    -- 3.3b 存量活动0050/0051基准补跑（v4.6）
    --     活动已开始但缺少0050/0051冻结基准时，按当日最新快照补建基准
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (                                -- 补跑插入冻结汇总表（仅存款基准）
        statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code,-- 统计口径、统计维度、指标代码、数据归属、法人机构编号
        base_data_date, base_run_date, base_yr_avg_depo, base_mth_avg_depo  -- 基准数据日期、基准跑批日期、基准年日均存款、基准月日均存款
    )
    WITH scope_member AS (  -- 组装存量活动范围内成员
        -- 路径08：营销活动成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s                                 -- 指标范围临时表
         INNER JOIN DWD_MKT_TSK_INFO ti                              -- 关联营销活动任务信息
            ON s.path_code             = '08'                         -- 限定路径08（营销活动）
           AND ti.mkt_act_id           = s.statis_dim                -- 活动ID等于统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code       -- 法人机构一致
           AND ti.data_date            = v_sysdat                    -- 取跑批日期当日活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) -- 按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))-- 按客户经理归属匹配
         WHERE s.term_begin_date < v_sysdat                          -- 仅取已开始（存量）的活动范围
           AND s.indx_code IN ('INDX_0050','INDX_0051')              -- 仅补跑0050/0051指标
    )
    SELECT '08',  -- 路径映射统计口径
           sm.statis_dim,                                             -- 统计维度
           sm.indx_code,                                              -- 指标代码
           sm.data_blng,                                              -- 数据归属
           sm.persn_legal_bk_code,                                    -- 法人机构编号
           v_sysdat,                                                  -- 基准数据日期=跑批日期
           v_sysdat,                                                  -- 基准跑批日期=跑批日期
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.depo_bal, 0) ELSE 0 END),  -- 年日均存款
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.depo_bal, 0) ELSE 0 END)  -- 月日均存款
      FROM scope_member sm                                            -- 范围成员结果集
     INNER JOIN DWS_CUST_ASSE_LIAB b                                  -- 关联资产负债余额表
        ON b.cust_id             = sm.cust_id                         -- 客户ID一致
       AND b.persn_legal_bk_code = sm.persn_legal_bk_code             -- 法人机构一致
       AND b.data_date           = v_sysdat                           -- 取跑批日期当日余额
     WHERE NOT EXISTS (                                               -- 过滤已存在基准，避免重复补跑
         SELECT 1
           FROM ADS_STAT_INDX_BASELINE_SUM x                    -- 冻结汇总表
          WHERE x.statis_calib        = '08'  -- 口径一致
            AND x.statis_dim          = sm.statis_dim           -- 维度一致
            AND x.indx_code           = sm.indx_code            -- 指标一致
            AND x.data_blng           = sm.data_blng            -- 归属一致
            AND x.persn_legal_bk_code = sm.persn_legal_bk_code  -- 法人机构一致
     )
     GROUP BY sm.path_code, sm.statis_dim, sm.indx_code, sm.data_blng, sm.persn_legal_bk_code;  -- 按路径/维度/指标/归属/机构分组汇总


    -------------------------------------------------------------------------
    -- 3.4 个贷新形成不良贷款率期初基准(0066)
    --     活动开始前一天冻结正常(1)/关注(2)贷款账户为基准, 后续沿用不重建
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_LOAN_BASE (                 -- 插入个贷贷款期初基准临时表
        path_code, statis_dim, data_blng, persn_legal_bk_code,  -- 路径代码、统计维度、数据归属、法人机构编号
        cust_id, acct_id, loan_bal, cate_5lvl, base_date  -- 客户ID、账户ID、贷款余额、五级分类、基准日期
    )
    WITH scope_cust AS (                                              -- 组装0066指标范围内客户
        SELECT s.path_code, s.statis_dim, s.data_blng, s.persn_legal_bk_code, ti.cust_id  -- 路径/维度/归属/机构及客户ID
          FROM TMP_STAT_INDX_SCOPE s                                  -- 指标范围临时表
         INNER JOIN DWD_MKT_TSK_INFO ti                               -- 关联营销活动任务信息
            ON ti.mkt_act_id           = s.statis_dim                 -- 活动ID等于统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code        -- 法人机构一致
           AND ti.data_date            = v_sysdat                     -- 取跑批日期当日活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)  -- 按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id)) -- 按客户经理归属匹配
         WHERE s.term_begin_date = V_NEXT_DAY                         -- 仅取开始日期为今日的范围
           AND s.path_code       = '08'                                -- 限定路径08（营销活动）
           AND s.indx_code       = 'INDX_0066'                        -- 仅取0066指标
    )
    SELECT sc.path_code, sc.statis_dim, sc.data_blng, sc.persn_legal_bk_code,  -- 路径/维度/归属/机构
           a.cust_id, NULL AS acct_id, a.loan_bal AS bal, a.cate_5lvl, V_NEXT_DAY  -- 客户ID、账户ID、贷款余额、五级分类、基准日期
      FROM scope_cust sc                                       -- 范围内客户
      INNER JOIN DWS_CUST_CLASSFIVE a                             -- v4.8: 客户五级分类表（data_date含全历史）
        ON a.cust_id             = sc.cust_id                  -- 客户ID一致
       AND a.persn_legal_bk_code = sc.persn_legal_bk_code      -- 法人机构一致
        AND a.data_date           = V_NEXT_DAY                     -- 活动冻结日 = 活动开始前一天
       AND a.cate_5lvl IN ('1', '2')                           -- 仅取五级分类为正常(1)、关注(2)的账户
     WHERE NOT EXISTS (                                        -- 过滤已建立的期初基准，不重复（后续沿用不重建）
         SELECT 1 FROM TMP_STAT_INDX_LOAN_BASE b               -- 个贷期初基准临时表
          WHERE b.path_code           = sc.path_code           -- 路径一致
            AND b.statis_dim          = sc.statis_dim          -- 维度一致
            AND b.data_blng           = sc.data_blng           -- 归属一致
            AND b.persn_legal_bk_code = sc.persn_legal_bk_code -- 法人机构一致
            AND b.cust_id             = sc.cust_id             -- 客户一致
     );
     -------------------------------------------------------------------------
     -- 3.4b 路径09-0066 基数每日重算（DELETE+INSERT）  v4.8
     --     固定基准日 = term_begin_date - 1；任务期内每日 DELETE 再重算
     --     分类来源：DWS_CUST_CLASSFIVE（data_date 含全历史，按 V_BASE_DATE 取）
     -------------------------------------------------------------------------
     -- 1) DELETE：删除正在进行中的任务 09 路径 0066 基数
     DELETE FROM TMP_STAT_INDX_LOAN_BASE tgt
      WHERE EXISTS (
          SELECT 1
            FROM TMP_STAT_INDX_SCOPE s
           WHERE s.path_code       = tgt.path_code
             AND s.statis_dim      = tgt.statis_dim
             AND s.data_blng       = tgt.data_blng
             AND s.persn_legal_bk_code = tgt.persn_legal_bk_code
             AND s.path_code       = '09'
             AND s.term_begin_date <= v_sysdat
             AND s.indx_code       = 'INDX_0066'
             AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub
                          WHERE sub.indx_tsk_id = s.statis_dim
                            AND NVL(sub.tsk_end_date, v_sysdat + 1) > v_sysdat)
        );

     -- 2) INSERT：09-O（机构）+ 09-M（经理）合并写入
     INSERT INTO TMP_STAT_INDX_LOAN_BASE (
         path_code, statis_dim, data_blng, persn_legal_bk_code,
         cust_id, acct_id, loan_bal, cate_5lvl, base_date
     )
     WITH lvl_scope09 AS (              -- v4.8：客户等级按基准日分流，基准日=跑批日走主表，否则走HIS
         SELECT 'MAIN' AS src_flg, cust_id, org_id, persn_legal_bk_code, data_date
           FROM DWS_CUST_LVL_INFO
          UNION ALL
         SELECT 'HIS'  AS src_flg, cust_id, org_id, persn_legal_bk_code, data_date
           FROM DWS_CUST_LVL_INFO_HIS
     ),
     scope_cust AS (
         -- 09-O：机构归属客户
         SELECT s.path_code, s.statis_dim, s.data_blng, s.persn_legal_bk_code, lv.cust_id,
                sys_fun_deal_date(s.term_begin_date, 1) AS base_date
           FROM TMP_STAT_INDX_SCOPE s
          INNER JOIN lvl_scope09 lv
             ON lv.org_id              = s.blng_id
            AND lv.persn_legal_bk_code = s.persn_legal_bk_code
            AND lv.data_date           = sys_fun_deal_date(s.term_begin_date, 1)
          WHERE s.term_begin_date <= v_sysdat
            AND s.path_code       = '09'
            AND s.blng_type       = 'O'
            AND s.indx_code       = 'INDX_0066'
            AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub
                         WHERE sub.indx_tsk_id = s.statis_dim
                           AND NVL(sub.tsk_end_date, v_sysdat + 1) > v_sysdat)
         UNION
         -- 09-M：客户经理归属客户
         SELECT s.path_code, s.statis_dim, s.data_blng, s.persn_legal_bk_code, cm.cust_id,
                sys_fun_deal_date(s.term_begin_date, 1) AS base_date
           FROM TMP_STAT_INDX_SCOPE s
          INNER JOIN DWD_CUST_MAN cm
             ON cm.mngr_post_id        = s.blng_id
            AND cm.mng_typ             = '1'
            AND cm.persn_legal_bk_code = s.persn_legal_bk_code
          WHERE s.term_begin_date <= v_sysdat
            AND s.path_code       = '09'
            AND s.blng_type       = 'M'
            AND s.indx_code       = 'INDX_0066'
            AND EXISTS (SELECT 1 FROM DWD_MKT_TSK_INDX_SUB sub
                         WHERE sub.indx_tsk_id = s.statis_dim
                           AND NVL(sub.tsk_end_date, v_sysdat + 1) > v_sysdat)
     )
     SELECT sc.path_code, sc.statis_dim, sc.data_blng, sc.persn_legal_bk_code,
            a.cust_id,
            NULL                             AS acct_id,
            NVL(a.loan_bal, 0)               AS loan_bal,
            a.cate_5lvl,
            sc.base_date
       FROM scope_cust sc
      INNER JOIN DWS_CUST_CLASSFIVE a
         ON a.cust_id             = sc.cust_id
        AND a.persn_legal_bk_code = sc.persn_legal_bk_code
        AND a.data_date           = sc.base_date
        AND a.cate_5lvl IN ('1', '2');

    -------------------------------------------------------------------------
    -- 清理仅用于冻结的范围数据
    -- 清理仅用于冻结的范围数据
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_SCOPE WHERE term_begin_date = V_NEXT_DAY;  -- 删除开始日期为今日的范围数据（冻结用毕即清）

    -------------------------------------------------------------------------
    -- 缺失基准强校验
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_MISSING_CNT                                                               -- 统计缺失基准行数
      FROM TMP_STAT_INDX_SCOPE s                                                                     -- 指标范围临时表
     WHERE s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 需校验的指标集合
                           'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余校验指标
       AND (                                                                                         -- 分两类校验其对应冻结表是否有基准
           (s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')                         -- 明细类指标
            AND NOT EXISTS (                                                                         -- 明细表中无对应基准
                SELECT 1 FROM ADS_STAT_INDX_BASELINE_DTL d                                           -- 冻结明细表
                 WHERE d.statis_calib        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END  -- 口径一致
                   AND d.statis_dim          = s.statis_dim                                          -- 维度一致
                   AND d.indx_code           = s.indx_code                                           -- 指标一致
                   AND d.data_blng           = s.data_blng                                           -- 归属一致
                   AND d.persn_legal_bk_code = s.persn_legal_bk_code                                 -- 法人机构一致
            ))
           OR
           (s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')  -- 汇总类指标
            AND NOT EXISTS (                                                                            -- 汇总表中无对应基准
                SELECT 1 FROM ADS_STAT_INDX_BASELINE_SUM b                                              -- 冻结汇总表
                 WHERE b.statis_calib        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END  -- 口径一致
                   AND b.statis_dim          = s.statis_dim                                             -- 维度一致
                   AND b.indx_code           = s.indx_code                                              -- 指标一致
                   AND b.data_blng           = s.data_blng                                              -- 归属一致
                   AND b.persn_legal_bk_code = s.persn_legal_bk_code                                    -- 法人机构一致
            ))
       );

    IF V_MISSING_CNT > 0 THEN            -- 存在缺失基准则报错
        RAISE_APPLICATION_ERROR(-20002,  -- 抛强校验错误
            '已开始活动/任务缺少开始前一天冻结的基准数据，严禁在活动期间补建基准');  -- 错误提示：禁止活动期间补建基准
    END IF;
    outcde := SQL%ROWCOUNT;                                   -- 输出影响行数
    COMMIT;                                                   -- 提交事务
    V_END_DATE := SYSDATE;                                    -- 记录结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时（秒）
    V_LOG_MSG := '步骤2处理完成，行数=' || NVL(outcde, 0);             -- 拼装成功日志消息
    V_LOG_FLG := 0;                                           -- 成功标志
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 调用通用跑批日志过程写成功日志
EXCEPTION
    WHEN OTHERS THEN                                              -- 异常捕获
        ROLLBACK;                                                 -- 回滚事务
        outcde := -1;                                             -- 输出错误标志
        V_END_DATE := SYSDATE;                                    -- 记录结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算耗时
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);                    -- 取错误信息前1000字符
        V_LOG_FLG := -1;                                          -- 失败标志
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 调用通用跑批日志过程写失败日志
        RAISE;                                                    -- 重新抛出异常
END prc_ads_stat_indx_plan_002;