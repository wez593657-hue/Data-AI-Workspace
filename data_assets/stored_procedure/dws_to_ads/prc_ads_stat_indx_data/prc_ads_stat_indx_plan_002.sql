------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_002
-- 功能说明: 指标数据统计——指标基数据冻结处理（冻结成员/明细/汇总及个贷期初基准）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（处理行数/结果标志）
-- 需求版本: v4.6 (2026-08-22)
-- 变更记录:
--   v4.6 0050/0051纳入基数冻结范围；新增存量活动0050/0051基准补跑分支(3.3b)；
--        汇总表新增BASE_YR_AVG_DEPO/BASE_MTH_AVG_DEPO两列；强校验覆盖0050/0051
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE crmdm.prc_ads_stat_indx_plan_002(
    v_sysdat  IN  VARCHAR2,   -- 跑批业务日期
    outcde OUT INTEGER     -- 处理行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤22处理完成 2';  -- 步骤描述文本（步骤22处理完成）
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_002';  -- 过程名
    V_LOG_MSG    VARCHAR2(4000);  -- 日志消息文本
    V_LOG_FLG    INTEGER;  -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;  -- 日志按钮标识
    V_NO_ID      VARCHAR2(10);  -- 跑批序号
    V_BGN_DATE   DATE;  -- 开始时间
    V_END_DATE   DATE;  -- 结束时间
    V_DURA_DATE  INTEGER;  -- 耗时（秒）
    V_NEXT_DAY   VARCHAR2(8);  -- 活动/任务开始日期（YYYYMMDD）
    V_MISSING_CNT INTEGER;  -- 缺失基准的计数
BEGIN
    -------------------------------------------------------------------------
    -- 标准模板：参数校验与开始日志状态
    -------------------------------------------------------------------------
    V_NO_ID := '0';  -- 跑批序号置0
    V_BGN_DATE := SYSDATE;  -- 记录开始时间
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
    INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER (  -- 插入冻结成员表
        statis_calib, statis_dim, data_blng, cust_id,  -- 统计口径、统计维度、数据归属、客户ID
        persn_legal_bk_code, base_data_date, base_run_date  -- 法人机构编号、基准数据日期、基准跑批日期
    )
    WITH scope_member AS (  -- 组装本次需冻结的成员范围（A/B多路径汇总）
        -- A路径：营销活动成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWD_MKT_TSK_INFO ti  -- 关联营销活动任务信息表
            ON s.path_code             = 'A'  -- 限定A路径（营销活动）
           AND ti.mkt_act_id           = s.statis_dim  -- 营销活动ID等于统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构编号一致
           AND ti.data_date            = v_sysdat  -- 取跑批日期当日的活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)  -- 按机构归属匹配活动归属机构
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))  -- 按客户经理归属匹配活动客户经理
         WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日（活动昨日建立）的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 仅取需冻结的指标集合（含新增0050/0051）
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码

        UNION  -- 合并去重

        -- B路径-机构归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, lv.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWS_CUST_LVL_INFO lv  -- 关联客户层级信息表
            ON s.path_code             = 'B'  -- 限定B路径（目标任务）
           AND s.blng_type             = 'O'  -- 归属类型为机构
           AND lv.org_id               = s.blng_id  -- 客户机构ID等于范围归属机构ID
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构编号一致
           AND lv.data_date            = v_sysdat  -- 取跑批日期当日的客户层级信息
         WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 需冻结的指标集合
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码

        UNION  -- 合并去重

        -- B路径-客户经理归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, cm.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWD_CUST_MAN cm  -- 关联客户经理归属表
            ON s.path_code             = 'B'  -- 限定B路径（目标任务）
           AND s.blng_type             = 'M'  -- 归属类型为客户经理
           AND cm.mngr_post_id         = s.blng_id  -- 客户经理岗位ID等于范围归属岗位ID
           AND cm.mng_typ              = '1'  -- 客户经理类型为主号
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构编号一致
         WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 需冻结的指标集合
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码
    )
    SELECT DISTINCT  -- 客户维度去重
           CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END AS statis_calib,  -- 按路径映射统计口径
           sm.statis_dim,  -- 统计维度（活动ID/任务机构岗位ID）
           sm.data_blng,  -- 数据归属
           sm.cust_id,  -- 客户ID
           sm.persn_legal_bk_code,  -- 法人机构编号
           v_sysdat  AS base_data_date,  -- 基准数据日期=跑批日期
           v_sysdat  AS base_run_date  -- 基准跑批日期=跑批日期
      FROM scope_member sm  -- 范围成员结果集
     WHERE NOT EXISTS (  -- 过滤掉已存在的成员基准，避免重复冻结
         SELECT 1
           FROM ADS_STAT_INDX_BASELINE_MEMBER x  -- 冻结成员表
          WHERE x.statis_calib        = CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
            AND x.statis_dim          = sm.statis_dim  -- 维度一致
            AND x.data_blng           = sm.data_blng  -- 归属一致
            AND x.cust_id             = sm.cust_id  -- 客户一致
            AND x.persn_legal_bk_code = sm.persn_legal_bk_code  -- 法人机构一致
     );

    -------------------------------------------------------------------------
    -- 3.2 冻结明细表 ADS_STAT_INDX_BASELINE_DTL
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_DTL (  -- 插入冻结明细表
        statis_calib, statis_dim, indx_code, data_blng, cust_id,  -- 统计口径、统计维度、指标代码、数据归属、客户ID
        persn_legal_bk_code, base_data_date, base_run_date,  -- 法人机构编号、基准数据日期、基准跑批日期
        base_cust_lvl, base_mth_avg_aum  -- 基准客户等级、基准月日均AUM
    )
    SELECT CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END,  -- 路径映射统计口径
           s.statis_dim,  -- 统计维度
           s.indx_code,  -- 指标代码
           s.data_blng,  -- 数据归属
           m.cust_id,  -- 客户ID（取自成员基准）
           m.persn_legal_bk_code,  -- 法人机构编号
           m.base_data_date,  -- 基准数据日期
           m.base_run_date,  -- 基准跑批日期
           CASE WHEN s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054')  -- 仅客户维护/客户提升/新增类指标需要客户等级
                THEN lv.cust_lvl END,  -- 取客户层级
           CASE WHEN s.indx_code = 'INDX_0063'  -- 仅月日均AUM指标需要
                THEN b.aum_bal END  -- 取月日均金融资产余额
      FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m  -- 关联已冻结的成员基准
        ON m.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
       AND m.statis_dim          = s.statis_dim  -- 维度一致
       AND m.data_blng           = s.data_blng  -- 归属一致
       AND m.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
      LEFT JOIN DWS_CUST_LVL_INFO lv  -- 关联客户层级信息
        ON lv.cust_id             = m.cust_id  -- 客户ID一致
       AND lv.persn_legal_bk_code = m.persn_legal_bk_code  -- 法人机构一致
       AND lv.data_date           = v_sysdat  -- 取跑批日期当日层级
      LEFT JOIN DWS_CUST_ASSE_LIAB b  -- 关联资产负债表
        ON b.cust_id             = m.cust_id  -- 客户ID一致
       AND b.persn_legal_bk_code = m.persn_legal_bk_code  -- 法人机构一致
       AND b.data_date           = v_sysdat  -- 取跑批日期当日余额
       AND b.bal_type            = '2'  -- 余额类型为月日均
     WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
       AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')  -- 仅需冻结明细的指标
       AND (s.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)  -- 需客户等级的指标必须能取到层级（内连接效果）
       AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL)  -- 需AUM的指标必须能取到余额（内连接效果）
       AND NOT EXISTS (  -- 过滤已冻结的明细，避免重复
           SELECT 1
             FROM ADS_STAT_INDX_BASELINE_DTL d  -- 冻结明细表
            WHERE d.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
              AND d.statis_dim          = s.statis_dim  -- 维度一致
              AND d.indx_code           = s.indx_code  -- 指标一致
              AND d.data_blng           = s.data_blng  -- 归属一致
              AND d.cust_id             = m.cust_id  -- 客户一致
              AND d.persn_legal_bk_code = m.persn_legal_bk_code  -- 法人机构一致
       );

    -------------------------------------------------------------------------
    -- 3.3 冻结汇总表 ADS_STAT_INDX_BASELINE_SUM
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (  -- 插入冻结汇总表
        statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code,  -- 统计口径、统计维度、指标代码、数据归属、法人机构编号
        base_data_date, base_run_date, base_loan_bal, base_yr_avg_fin,  -- 基准数据日期、基准跑批日期、基准贷款余额、基准年日均金融资产
        base_mth_avg_fin, base_yr_avg_agen_fin, base_mth_avg_agen_fin,  -- 基准月日均金融资产、基准年日均代发金融资产、基准月日均代发金融资产
        base_fin_bal, base_agen_fin_bal,  -- 基准金融资产余额、基准代发金融资产余额
        base_yr_avg_depo, base_mth_avg_depo  -- 基准年日均存款、基准月日均存款（v4.6新增）
    )
    SELECT CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END,  -- 路径映射统计口径
           s.statis_dim,  -- 统计维度
           s.indx_code,  -- 指标代码
           s.data_blng,  -- 数据归属
           s.persn_legal_bk_code,  -- 法人机构编号
           MAX(m.base_data_date),  -- 取最大基准数据日期
           v_sysdat,  -- 基准跑批日期=跑批日期
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.loan_bal, 0) ELSE 0 END),  -- 贷款余额（余额类型=贷款）
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.fin_bal, 0) ELSE 0 END),  -- 年日均金融资产（余额类型=年日均）
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.fin_bal, 0) ELSE 0 END),  -- 月日均金融资产（余额类型=月日均）
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),  -- 年日均代发金融资产（未代发+已代发余额）
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),  -- 月日均代发金融资产
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.fin_bal, 0) ELSE 0 END),  -- 金融资产余额（余额类型=贷款时点为金融资产）
           SUM(CASE WHEN b.bal_type = '1' THEN NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0) ELSE 0 END),  -- 代发金融资产余额
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.depo_bal, 0) ELSE 0 END),  -- 年日均存款
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.depo_bal, 0) ELSE 0 END)  -- 月日均存款
      FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m  -- 关联已冻结的成员基准
        ON m.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
       AND m.statis_dim          = s.statis_dim  -- 维度一致
       AND m.data_blng           = s.data_blng  -- 归属一致
       AND m.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
      INNER JOIN DWS_CUST_ASSE_LIAB b  -- 关联资产负债余额表（仅取有余额的成员）
        ON b.cust_id             = m.cust_id  -- 客户ID一致
       AND b.persn_legal_bk_code = m.persn_legal_bk_code  -- 法人机构一致
       AND b.data_date           = m.base_data_date  -- 余额取基准数据日期
     WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
       AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')  -- 需冻结至汇总表的指标集合
       AND NOT EXISTS (  -- 过滤已冻结的汇总，避免重复
           SELECT 1
             FROM ADS_STAT_INDX_BASELINE_SUM x  -- 冻结汇总表
            WHERE x.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
              AND x.statis_dim          = s.statis_dim  -- 维度一致
              AND x.indx_code           = s.indx_code  -- 指标一致
              AND x.data_blng           = s.data_blng  -- 归属一致
              AND x.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
       )
     GROUP BY s.path_code, s.statis_dim, s.indx_code, s.data_blng, s.persn_legal_bk_code;  -- 按路径/维度/指标/归属/法人机构分组汇总



    -------------------------------------------------------------------------
    -- 3.3b 存量活动0050/0051基准补跑（v4.6）
    --     活动已开始但缺少0050/0051冻结基准时，按当日最新快照补建基准
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (  -- 补跑插入冻结汇总表（仅存款基准）
        statis_calib, statis_dim, indx_code, data_blng, persn_legal_bk_code,  -- 统计口径、统计维度、指标代码、数据归属、法人机构编号
        base_data_date, base_run_date, base_yr_avg_depo, base_mth_avg_depo  -- 基准数据日期、基准跑批日期、基准年日均存款、基准月日均存款
    )
    WITH scope_member AS (  -- 组装存量活动范围内成员
        -- A路径：营销活动成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWD_MKT_TSK_INFO ti  -- 关联营销活动任务信息
            ON s.path_code             = 'A'  -- 限定A路径（营销活动）
           AND ti.mkt_act_id           = s.statis_dim  -- 活动ID等于统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构一致
           AND ti.data_date            = v_sysdat  -- 取跑批日期当日活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)  -- 按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))  -- 按客户经理归属匹配
         WHERE s.term_begin_date < v_sysdat  -- 仅取已开始（存量）的活动范围
           AND s.indx_code IN ('INDX_0050','INDX_0051')  -- 仅补跑0050/0051指标
        UNION  -- 合并
        -- B路径-机构归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, lv.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWS_CUST_LVL_INFO lv  -- 关联客户层级信息
            ON s.path_code             = 'B'  -- 限定B路径
           AND s.blng_type             = 'O'  -- 归属类型为机构
           AND lv.org_id               = s.blng_id  -- 机构ID一致
           AND lv.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构一致
           AND lv.data_date            = v_sysdat  -- 取跑批日期当日层级
         WHERE s.term_begin_date < v_sysdat  -- 仅取已开始范围
           AND s.indx_code IN ('INDX_0050','INDX_0051')  -- 仅补跑0050/0051
        UNION  -- 合并
        -- B路径-客户经理归属成员
        SELECT s.path_code, s.statis_dim, s.indx_code, s.data_blng,  -- 路径代码、统计维度、指标代码、数据归属
               s.term_begin_date, cm.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWD_CUST_MAN cm  -- 关联客户经理归属表
            ON s.path_code             = 'B'  -- 限定B路径
           AND s.blng_type             = 'M'  -- 归属类型为客户经理
           AND cm.mngr_post_id         = s.blng_id  -- 客户经理岗位ID一致
           AND cm.mng_typ              = '1'  -- 客户经理类型主号
           AND cm.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构一致
         WHERE s.term_begin_date < v_sysdat  -- 仅取已开始范围
           AND s.indx_code IN ('INDX_0050','INDX_0051')  -- 仅补跑0050/0051
    )
    SELECT CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END,  -- 路径映射统计口径
           sm.statis_dim,  -- 统计维度
           sm.indx_code,  -- 指标代码
           sm.data_blng,  -- 数据归属
           sm.persn_legal_bk_code,  -- 法人机构编号
           v_sysdat,  -- 基准数据日期=跑批日期
           v_sysdat,  -- 基准跑批日期=跑批日期
           SUM(CASE WHEN b.bal_type = '4' THEN NVL(b.depo_bal, 0) ELSE 0 END),  -- 年日均存款
           SUM(CASE WHEN b.bal_type = '2' THEN NVL(b.depo_bal, 0) ELSE 0 END)  -- 月日均存款
      FROM scope_member sm  -- 范围成员结果集
     INNER JOIN DWS_CUST_ASSE_LIAB b  -- 关联资产负债余额表
        ON b.cust_id             = sm.cust_id  -- 客户ID一致
       AND b.persn_legal_bk_code = sm.persn_legal_bk_code  -- 法人机构一致
       AND b.data_date           = v_sysdat  -- 取跑批日期当日余额
     WHERE NOT EXISTS (  -- 过滤已存在基准，避免重复补跑
         SELECT 1
           FROM ADS_STAT_INDX_BASELINE_SUM x  -- 冻结汇总表
          WHERE x.statis_calib        = CASE WHEN sm.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
            AND x.statis_dim          = sm.statis_dim  -- 维度一致
            AND x.indx_code           = sm.indx_code  -- 指标一致
            AND x.data_blng           = sm.data_blng  -- 归属一致
            AND x.persn_legal_bk_code = sm.persn_legal_bk_code  -- 法人机构一致
     )
     GROUP BY sm.path_code, sm.statis_dim, sm.indx_code, sm.data_blng, sm.persn_legal_bk_code;  -- 按路径/维度/指标/归属/机构分组汇总


    -------------------------------------------------------------------------
    -- 3.4 个贷新形成不良贷款率期初基准(0066)
    --     活动开始前一天冻结正常(1)/关注(2)贷款账户为基准, 后续沿用不重建
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_LOAN_BASE (  -- 插入个贷贷款期初基准临时表
        path_code, statis_dim, data_blng, persn_legal_bk_code,  -- 路径代码、统计维度、数据归属、法人机构编号
        cust_id, acct_id, loan_bal, cate_5lvl, base_date  -- 客户ID、账户ID、贷款余额、五级分类、基准日期
    )
    WITH scope_cust AS (  -- 组装0066指标范围内客户
        SELECT s.path_code, s.statis_dim, s.data_blng, s.persn_legal_bk_code, ti.cust_id  -- 路径/维度/归属/机构及客户ID
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWD_MKT_TSK_INFO ti  -- 关联营销活动任务信息
            ON ti.mkt_act_id           = s.statis_dim  -- 活动ID等于统计维度
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code  -- 法人机构一致
           AND ti.data_date            = v_sysdat  -- 取跑批日期当日活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)  -- 按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))  -- 按客户经理归属匹配
         WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
           AND s.path_code       = 'A'  -- 限定A路径（营销活动）
           AND s.indx_code       = 'INDX_0066'  -- 仅取0066指标
        UNION  -- 合并
        SELECT s.path_code, s.statis_dim, s.data_blng, s.persn_legal_bk_code, lv.cust_id  -- 路径/维度/归属/机构及客户ID
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWS_CUST_LVL_INFO lv  -- 关联客户层级信息
            ON lv.org_id              = s.blng_id  -- 机构ID一致
           AND lv.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
           AND lv.data_date           = v_sysdat  -- 取跑批日期当日层级
         WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
           AND s.path_code       = 'B'  -- 限定B路径
           AND s.blng_type       = 'O'  -- 归属类型为机构
           AND s.indx_code       = 'INDX_0066'  -- 仅取0066指标
        UNION  -- 合并
        SELECT s.path_code, s.statis_dim, s.data_blng, s.persn_legal_bk_code, cm.cust_id  -- 路径/维度/归属/机构及客户ID
          FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
         INNER JOIN DWD_CUST_MAN cm  -- 关联客户经理归属表
            ON cm.mngr_post_id        = s.blng_id  -- 客户经理岗位ID一致
           AND cm.mng_typ             = '1'  -- 客户经理类型主号
           AND cm.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
         WHERE s.term_begin_date = V_NEXT_DAY  -- 仅取开始日期为今日的范围
           AND s.path_code       = 'B'  -- 限定B路径
           AND s.blng_type       = 'M'  -- 归属类型为客户经理
           AND s.indx_code       = 'INDX_0066'  -- 仅取0066指标
    )
    SELECT sc.path_code, sc.statis_dim, sc.data_blng, sc.persn_legal_bk_code,  -- 路径/维度/归属/机构
           a.cust_id, a.acct_id, a.bal, a.cate_5lvl, v_sysdat  -- 客户ID、账户ID、贷款余额、五级分类、基准日期
      FROM scope_cust sc  -- 范围内客户
     INNER JOIN DWD_ACCT_LOAN a  -- 关联个贷账户表（仅取有贷款账户的客户）
        ON a.cust_id             = sc.cust_id  -- 客户ID一致
       AND a.persn_legal_bk_code = sc.persn_legal_bk_code  -- 法人机构一致
       AND a.cate_5lvl IN ('1', '2')  -- 仅取五级分类为正常(1)、关注(2)的账户
     WHERE NOT EXISTS (  -- 过滤已建立的期初基准，不重复（后续沿用不重建）
         SELECT 1 FROM TMP_STAT_INDX_LOAN_BASE b  -- 个贷期初基准临时表
          WHERE b.path_code           = sc.path_code  -- 路径一致
            AND b.statis_dim          = sc.statis_dim  -- 维度一致
            AND b.data_blng           = sc.data_blng  -- 归属一致
            AND b.persn_legal_bk_code = sc.persn_legal_bk_code  -- 法人机构一致
            AND b.cust_id             = sc.cust_id  -- 客户一致
     );

    -------------------------------------------------------------------------
    -- 清理仅用于冻结的范围数据
    -- 清理仅用于冻结的范围数据
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_SCOPE WHERE term_begin_date = V_NEXT_DAY;  -- 删除开始日期为今日的范围数据（冻结用毕即清）

    -------------------------------------------------------------------------
    -- 缺失基准强校验
    -------------------------------------------------------------------------
    SELECT COUNT(*) INTO V_MISSING_CNT  -- 统计缺失基准行数
      FROM TMP_STAT_INDX_SCOPE s  -- 指标范围临时表
     WHERE s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 需校验的指标集合
                           'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余校验指标
       AND (  -- 分两类校验其对应冻结表是否有基准
           (s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')  -- 明细类指标
            AND NOT EXISTS (  -- 明细表中无对应基准
                SELECT 1 FROM ADS_STAT_INDX_BASELINE_DTL d  -- 冻结明细表
                 WHERE d.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
                   AND d.statis_dim          = s.statis_dim  -- 维度一致
                   AND d.indx_code           = s.indx_code  -- 指标一致
                   AND d.data_blng           = s.data_blng  -- 归属一致
                   AND d.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
            ))
           OR
           (s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')  -- 汇总类指标
            AND NOT EXISTS (  -- 汇总表中无对应基准
                SELECT 1 FROM ADS_STAT_INDX_BASELINE_SUM b  -- 冻结汇总表
                 WHERE b.statis_calib        = CASE WHEN s.path_code = 'A' THEN '营销活动' ELSE '目标任务' END  -- 口径一致
                   AND b.statis_dim          = s.statis_dim  -- 维度一致
                   AND b.indx_code           = s.indx_code  -- 指标一致
                   AND b.data_blng           = s.data_blng  -- 归属一致
                   AND b.persn_legal_bk_code = s.persn_legal_bk_code  -- 法人机构一致
            ))
       );

    IF V_MISSING_CNT > 0 THEN  -- 存在缺失基准则报错
        RAISE_APPLICATION_ERROR(-20002,  -- 抛强校验错误
            '已开始活动/任务缺少开始前一天冻结的基准数据，严禁在活动期间补建基准');  -- 错误提示：禁止活动期间补建基准
    END IF;
    outcde := SQL%ROWCOUNT;  -- 输出影响行数
    COMMIT;  -- 提交事务
    V_END_DATE := SYSDATE;  -- 记录结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时（秒）
    V_LOG_MSG := '步骤2处理完成，行数=' || NVL(outcde, 0);  -- 拼装成功日志消息
    V_LOG_FLG := 0;  -- 成功标志
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 调用通用跑批日志过程写成功日志
EXCEPTION
    WHEN OTHERS THEN  -- 异常捕获
        ROLLBACK;  -- 回滚事务
        outcde := -1;  -- 输出错误标志
        V_END_DATE := SYSDATE;  -- 记录结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算耗时
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);  -- 取错误信息前1000字符
        V_LOG_FLG := -1;  -- 失败标志
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 调用通用跑批日志过程写失败日志
        RAISE;  -- 重新抛出异常
END prc_ads_stat_indx_plan_002;