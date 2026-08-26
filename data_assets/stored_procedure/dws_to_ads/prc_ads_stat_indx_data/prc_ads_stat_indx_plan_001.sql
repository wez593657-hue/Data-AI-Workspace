------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_001
-- 功能说明: 指标数据统计（写入营销活动/目标任务范围并记录执行日志）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（写入行数）
-- 需求版本: 【待确认】（原文件无头部版本信息，版本号待需求方确认）
-- 变更记录:
--   - 2026-08-26 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   - 2026-08-25 行内注释补全与对齐（仅注释与格式优化，业务逻辑零改动）
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_001(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期 YYYYMMDD
    outcde OUT INTEGER     -- 写入行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤11处理完成 1';  -- 过程描述，用于日志
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_001';   -- 过程名称，用于日志
    V_LOG_MSG    VARCHAR2(4000);                       -- 日志消息
    V_LOG_FLG    INTEGER;                              -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;                         -- 日志按钮，1启用步骤日志
    V_NO_ID      VARCHAR2(10);                         -- 日志序号标识
    V_BGN_DATE   DATE;   -- 过程开始时间
    V_END_DATE   DATE;   -- 过程结束时间
    V_DURA_DATE  INTEGER;                              -- 过程耗时（秒）
    V_NEXT_DAY   VARCHAR2(8);                          -- 次日（用于开始前一天判断）
BEGIN
    -------------------------------------------------------------------------
    -- 标准模板：参数校验与开始日志状态
    -------------------------------------------------------------------------
    V_NO_ID  := '0';  -- 初始化日志序号
    V_BGN_DATE := SYSDATE;   -- 记录过程开始时间

    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN   -- 校验业务日期为非空8位数字
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');      -- 格式非法则报错
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 业务日期字符串转日期型

    -------------------------------------------------------------------------
    -- 初始化日期边界
    -------------------------------------------------------------------------
    V_NEXT_DAY := sys_fun_deal_date(v_sysdat, 31);  -- 计算顺延31天后日期（活动范围判断基准）

    -------------------------------------------------------------------------
    -- 路径08：营销活动范围写入
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_SCOPE (
        path_code, statis_dim, indx_code, data_blng,  -- 路径编码, 统计维度, 指标编码, 归属机构
        blng_type, blng_id, term_begin_date, persn_legal_bk_code   -- 归属类型(O机构/M客户经理), 归属ID, 期间开始日, 法人行号
    )
    SELECT DISTINCT
           '08'                          AS path_code,        -- 路径08：营销活动口径
           a.mkt_act_id                 AS statis_dim,       -- 统计维度=营销活动ID
           t.indx_id                    AS indx_code,        -- 统计指标编码
           'ORG_' || ti.mkt_persn_org   AS data_blng,        -- 归属机构=客户经理所属机构加前缀
           'O'                          AS blng_type,        -- 归属类型：机构维度
           ti.mkt_persn_org             AS blng_id,          -- 归属ID=客户经理所属机构
           a.act_bgn_date               AS term_begin_date,  -- 指标期间开始日期=活动开始日期
           ti.persn_legal_bk_code       AS persn_legal_bk_code   -- 法人机构行号
      FROM DWD_MKT_ACT_INFO a                        -- 营销活动信息表
     INNER JOIN DWD_MKT_ACT_TARGT t                  -- 营销活动目标表
        ON t.mkt_act_id = a.mkt_act_id               -- 按活动ID关联
     INNER JOIN DWD_MKT_TSK_INFO ti                  -- 营销任务信息表
        ON ti.mkt_act_id          = a.mkt_act_id     -- 按活动ID关联任务
       AND ti.mkt_persn_org       = t.prtspt_org     -- 任务机构=目标参与机构
       AND ti.persn_legal_bk_code = a.persn_legal_bk_code    -- 法人行号一致
       AND ti.data_date           = v_sysdat         -- 任务数据日期=跑批日期
     WHERE a.act_bgn_date                      <= V_NEXT_DAY -- 活动开始日在顺延31天范围内
       AND NVL(a.statis_stop_date, '99991231') >= v_sysdat   -- 统计截止日未结束或晚于跑批日
       AND a.camp_act_typ IN ('1', '2')              -- 活动类型仅取1/2（营销活动口径）
       AND ti.mkt_persn_org IS NOT NULL              -- 所属机构非空

    UNION

    SELECT DISTINCT
           '08', a.mkt_act_id, t.indx_id,                   -- 路径08/活动ID/指标编码
           'MGR_' || ti.mkt_persn, 'M', ti.mkt_persn,      -- 归属机构加MGR_前缀, 归属类型=客户经理, 归属ID=客户经理
           a.act_bgn_date, ti.persn_legal_bk_code          -- 期间开始日, 法人行号
      FROM DWD_MKT_ACT_INFO a                              -- 营销活动信息表
     INNER JOIN DWD_MKT_ACT_TARGT t                        -- 营销活动目标表
        ON t.mkt_act_id = a.mkt_act_id                     -- 按活动ID关联
     INNER JOIN DWD_MKT_TSK_INFO ti                        -- 营销任务信息表
        ON ti.mkt_act_id          = a.mkt_act_id           -- 按活动ID关联任务
       AND ti.mkt_persn_org       = t.prtspt_org           -- 任务机构=目标参与机构
       AND ti.persn_legal_bk_code = a.persn_legal_bk_code  -- 法人行号一致
       AND ti.data_date           = v_sysdat               -- 任务数据日期=跑批日期
     WHERE a.act_bgn_date                      <= V_NEXT_DAY   -- 活动开始日在顺延31天范围内
       AND NVL(a.statis_stop_date, '99991231') >= v_sysdat -- 统计截止日未结束或晚于跑批日
       AND a.camp_act_typ IN ('1', '2')                    -- 活动类型仅取1/2
       AND ti.mkt_persn IS NOT NULL;                       -- 客户经理非空

    -------------------------------------------------------------------------
    -- 路径09：目标任务范围写入
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_SCOPE (
        path_code, statis_dim, indx_code, data_blng,  -- 路径编码, 统计维度, 指标编码, 归属机构
        blng_type, blng_id, term_begin_date, persn_legal_bk_code   -- 归属类型, 归属ID, 期间开始日, 法人行号
    )
    SELECT DISTINCT
           '09'                          AS path_code,         -- 路径09：目标任务口径
           it.tsk_id                    AS statis_dim,        -- 统计维度=目标任务ID
           sub.indx_id                  AS indx_code,         -- 统计指标编码
           'ORG_' || it.rsv_obj_id      AS data_blng,         -- 归属机构=预留对象ID加前缀
           'O'                          AS blng_type,         -- 归属类型：机构维度
           it.rsv_obj_id                AS blng_id,           -- 归属ID=预留对象ID
           sub.tsk_bgn_date             AS term_begin_date,   -- 指标期间开始日=任务开始日
           it.persn_legal_bk_code       AS persn_legal_bk_code-- 法人机构行号
      FROM DWD_MKT_INDX_TSK it                       -- 指标任务表
     INNER JOIN DWD_MKT_TSK_INDX_SUB sub             -- 任务指标子表
        ON sub.tsk_id              = it.tsk_id       -- 按任务ID关联
       AND sub.persn_legal_bk_code = it.persn_legal_bk_code   -- 法人行号一致
     WHERE it.rsv_obj                            = '0'        -- 预留对象类型0=机构
       AND sub.tsk_bgn_date                      <= V_NEXT_DAY-- 任务开始日在顺延31天范围内
       AND NVL(sub.tsk_end_date, '99991231')     >= v_sysdat  -- 任务结束日未结束或晚于跑批日

    UNION

    SELECT DISTINCT
           '09',                                -- 路径09
           it.tsk_id,                          -- 任务ID
           sub.indx_id,                        -- 指标编码
           'MGR_' || it.rsv_obj_id, 
           'M', 
           it.rsv_obj_id,        -- 归属机构加MGR_前缀, 归属类型=客户经理, 归属ID=预留对象ID
           sub.tsk_bgn_date, 
           it.persn_legal_bk_code            -- 期间开始日, 法人行号
      FROM DWD_MKT_INDX_TSK it         -- 指标任务表
     INNER JOIN DWD_MKT_TSK_INDX_SUB sub                       -- 任务指标子表
        ON sub.tsk_id              = it.tsk_id                 -- 按任务ID关联
       AND sub.persn_legal_bk_code = it.persn_legal_bk_code    -- 法人行号一致
     WHERE it.rsv_obj                            = '1'         -- 预留对象类型1=客户经理
       AND sub.tsk_bgn_date                      <= V_NEXT_DAY -- 任务开始日在顺延31天范围内
       AND NVL(sub.tsk_end_date, '99991231')     >= v_sysdat;  -- 任务结束日未结束或晚于跑批日

    -------------------------------------------------------------------------
    -- 提交与执行日志记录
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;                                   -- 返回最近DML影响行数
    COMMIT;                -- 提交事务
    V_END_DATE  := SYSDATE;                                   -- 记录过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时秒数
    V_LOG_MSG   := '步骤1处理完成，行数=' || NVL(outcde, 0);           -- 组装成功日志消息
    V_LOG_FLG   := 0;      -- 日志标志置成功
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录步骤日志

    -------------------------------------------------------------------------
    -- 异常处理：回滚并记录错误日志后重抛
    -------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;                                                 -- 异常回滚事务
        outcde := -1;                                             -- 输出行数置-1表示失败
        V_END_DATE  := SYSDATE;                                   -- 记录异常结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时秒数
        V_LOG_MSG   := SUBSTR(SQLERRM, 1, 1000);                  -- 截取错误信息
        V_LOG_FLG   := -1;                                        -- 日志标志置失败
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);   -- 记录错误日志
        RAISE;   -- 重新抛出异常
END prc_ads_stat_indx_plan_001;