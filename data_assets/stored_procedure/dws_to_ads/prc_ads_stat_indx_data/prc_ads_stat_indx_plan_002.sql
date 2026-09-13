------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_002
-- 功能说明: 指标数据统计——指标基数据冻结处理（冻结成员/明细/汇总及个贷期初基准）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（处理行数/结果标志）
-- 需求版本: v4.9.7 (2026-09-08)
-- 变更记录:
--   2026-09-10 统计维度/统计口径内容互换：STATIS_DIM改存08/09路径编码、STATIS_CALIB改存活动号/任务号；单列表(范围/余额汇总/客户状态/贷款基数/代发基数等)STATIS_DIM列更名STATIS_CALIB
--   v4.9.7 (2026-09-08) §3.4-0删除阈值参数化：新增V_BFR_3MON（初始化日期边界段经sys_fun_deal_date(v_sysdat,32)一次生成，函数新增模式32=3个月前），四段删除条件改用变量直比，消除四处重复日期函数调用
--   v4.9.6 (2026-09-08) §3.4-0删除条件等价改写：ADD_MONTHS(STATIS_STOP_DATE,3)<=跑批日 改为 STATIS_STOP_DATE<=跑批日-3个自然月（TO_CHAR(ADD_MONTHS(TO_DATE(V_SYSDAT,'YYYYMMDD'),-3),'YYYYMMDD')），日期函数仅作用常量侧、列侧为裸列（对齐v4.9.1日期确定性原则）；ADD_MONTHS单调且往返恒等，语义完全等价
--   v4.9.5 (2026-09-08) 0066余额源修复：DWS_CUST_CLASSFIVE无LOAN_BAL列（编译错误）——期初余额改LEFT JOIN DWS_CUST_ASSE_LIAB/HIS（BAL_TYPE='1'，data_date=冻结日/base_date），与§3.3/3.3a base_loan_bal同源；INSERT目标列名class_five回退class_five（以LOAN_BASE DDL为准）；分类列维持CLASSFIVE实际列名class_five
--   v4.9.4 (2026-09-08) §3.4-0生命周期清理扩展至MEMBER/DTL/SUM（路径08活动结束+3自然月；09行已由每日全量清自洁）；按需求决策整体删除缺失基准强校验（含V_MISSING_CNT），缺失基准不再拦截跑批
--   v4.9.3 (2026-09-08) 09路径删除简化：四段09 DELETE改为按 statis_calib/path_code='09' 全量清+按scope/判活重插（09行由本过程唯一写入，已结束任务残留行次日自清；§3.4-0移除路径09分支）；重跑幂等性与输出不变
--   v4.9.2 (2026-09-08) 重跑安全修复：08路径四段冻结（MEMBER/DTL/SUM/LOAN_BASE）入数前按 base_run_date/base_date=v_sysdat 清理当日批次行，并移除对应NOT EXISTS防重（重跑幂等）；§3.3b补跑与强校验NOT EXISTS保留；无表结构变更
--   v4.9.1 (2026-09-08) 基准取数源构造简化（日期确定性原则）：删除六条"主表∪HIS按行日期分流"基准CTE（task_lvl_src/task_lv_src/task_au_src/task_asse_src/task_asse_src09/lvl_scope09）——09重算段(§3.1b/3.2b/3.3a/3.4b)改直连HIS表（基准日=任务开始前一天，恒<跑批日），08冻结段(§3.3)改直连主表（基准日=v_sysdat）；消除各语句死分支与"函数谓词下推进UNION ALL"的优化器依赖，v1.1.6所修两类缺陷（开关式丢基准/裸UNION双计）在新构造下由构造消除；输出结果与v4.9完全一致（有效日期由JOIN等值条件钉死）
--   v4.9 (2026-09-07) 判活口径修正：进行中任务判定 CRM.MKT_TSK_INDX_SUB 关联字段 indx_tsk_id 改为 tsk_id（对齐 plan_001 装载/plan_006 清理口径）；新增 TMP_STAT_INDX_LOAN_BASE 生命周期清理（活动/任务结束日+3个自然月，对齐 plan_006 §7.0.0 规则）；0066 基准缺失维持不纳入强校验（需求决策）
--   v4.7 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v4.8 (2026-09-02) 基数口径按路径拆分——路径08维持开始日前一天一次性冻结；路径09改为基准日固定(term_begin_date-1)+任务期内每日DELETE+重算；取数分流：基准日=跑批日走主表/<跑批日走HIS表；0066五级分类改用DWS_CUST_CLASSFIVE（期初按基准日/当前按跑批日）；§3.3b仅保留路径08补跑分支
--   v4.8.1 (2026-09-02) 复核修复：§3.1删除残留09冻结分支(防成员基准以08口径污染)；四处取数源统一按行日期分流(主表=当日/HIS<当日，修复混合场景丢基准与HIS含当日双计)；§3.4冻结日口径修正(V_NEXT_DAY→v_sysdat)；进行中判定统一为NVL(tsk_end_date,'99991231')>=v_sysdat；删除未使用变量V_BASE_DATE
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
    V_BFR_3MON   VARCHAR2(8);     -- 跑批日-3个自然月（YYYYMMDD，§3.4-0基准生命周期清理阈值）
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
    V_BFR_3MON := sys_fun_deal_date(v_sysdat, 32);  -- 调用日期处理函数获取跑批日-3个自然月（清理边界）

    -------------------------------------------------------------------------
    -- 3.1 冻结成员表 ADS_STAT_INDX_BASELINE_MEMBER
    -------------------------------------------------------------------------
    -- DELETE：入数前清掉今日批次已写入的08冻结成员（base_run_date=跑批日；历史冻结行保留，保证重跑幂等）
    DELETE FROM ADS_STAT_INDX_BASELINE_MEMBER
     WHERE statis_dim = '08'
       AND base_run_date = v_sysdat;                         -- 仅清当日批次行（v4.9.2）

    INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER (        -- 插入冻结成员表
        statis_dim, statis_calib, data_blng, cust_id,  -- 统计维度、统计口径、数据归属、客户ID
        persn_legal_bk_code, base_data_date, base_run_date  -- 法人机构编号、基准数据日期、基准跑批日期
    )
    WITH scope_member AS (  -- 组装本次需冻结的成员范围（A/B多路径汇总）
        -- 路径08：营销活动成员
        SELECT s.path_code, s.statis_calib, s.indx_code, s.data_blng,    -- 路径代码、统计口径、指标代码、数据归属
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code    -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s                                   -- 指标范围临时表
         INNER JOIN CRM.MKT_TSK_INFO ti                                -- 关联营销活动任务信息表
            ON s.path_code             = '08'                           -- 限定路径08（营销活动）
           AND ti.mkt_act_id           = s.statis_calib                  -- 营销活动ID等于统计口径
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code         -- 法人机构编号一致
           --AND ti.data_date            = v_sysdat                      -- 取跑批日期当日的活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)   -- 按机构归属匹配活动归属机构
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))  -- 按客户经理归属匹配活动客户经理
         WHERE s.term_begin_date = V_NEXT_DAY                          -- 仅取开始日期为今日（活动昨日建立）的范围
           AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 仅取需冻结的指标集合（含新增0050/0051）
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')  -- 其余需冻结指标代码
    )
    SELECT DISTINCT                      -- 客户维度去重
           '08' AS statis_dim,  -- 按路径映射统计维度
           sm.statis_calib,                -- 统计口径（活动ID/任务机构岗位ID）
           sm.data_blng,                 -- 数据归属
           sm.cust_id,                   -- 客户ID
           sm.persn_legal_bk_code,       -- 法人机构编号
           v_sysdat  AS base_data_date,  -- 基准数据日期=跑批日期
           v_sysdat  AS base_run_date    -- 基准跑批日期=跑批日期
      FROM scope_member sm;               -- 范围成员结果集

    -- =========================================================== 09每日重算（v4.8） ==============
    -- 3.1b 目标任务：进行中任务每日重算 ADS_STAT_INDX_BASELINE_MEMBER（路径09专用；基准日=term_begin_date前1天，
    --        基准日=跑批日走主表 DWS_CUST_LVL_INFO / 基准日<跑批日走 HIS 表 DWS_CUST_LVL_INFO_HIS；
    --        DELETE按任务键整删整插，同键仅保留当日最新行；下游 join 键不含 base_data_date，取数透明 -------------
    -- 1) DELETE：全量清空09路径基准行（v4.9.3：09行由本过程唯一写入；已结束任务残留行次日自清；下游仅经scope关联取数）
    DELETE FROM ADS_STAT_INDX_BASELINE_MEMBER
     WHERE statis_dim = '09';

    -- 2) INSERT：本次进行中09任务的基准成员 ----------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER (                   -- 插入冻结成员表（路径09每日重算）
        statis_dim, statis_calib, data_blng, cust_id, persn_legal_bk_code, base_data_date, base_run_date  -- 维度/口径/归属/客户/法人行号/基准日/跑批日
    )
    WITH scope_member_09 AS (                                      -- 路径09进行中任务的客户范围（O机构型+M经理型）
         -- 09-O（机构归属）：等级表按基准日取 cust_id ----------------------------------------------
         SELECT s.statis_calib, s.indx_code, s.data_blng, s.term_begin_date, lv.cust_id, s.persn_legal_bk_code
           FROM TMP_STAT_INDX_SCOPE s                             -- 指标范围临时表
          INNER JOIN DWS_CUST_LVL_INFO_HIS lv                              -- 客户等级基准源（HIS，基准日=开始前一天）
             ON s.path_code            = '09'                      -- 仅目标任务路径
            AND s.blng_type            = 'O'                      -- 机构归属型
            AND lv.org_id              = s.blng_id                 -- 归属机构ID一致
            AND lv.persn_legal_bk_code = s.persn_legal_bk_code     -- 法人行号一致
            AND lv.data_date           = sys_fun_deal_date(s.term_begin_date, 1)  -- 取 任务开始日前一天 基准快照（与冻结基准同口径）
          WHERE s.term_begin_date   <= v_sysdat                    -- 任务已开始/冻结日
            AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0052','INDX_0053','INDX_0054','INDX_0055',  -- 基准指标范围
                               'INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062','INDX_0063')
            AND EXISTS (SELECT 1 FROM CRM.MKT_TSK_INDX_SUB sub WHERE sub.tsk_id = s.statis_calib AND NVL(sub.tsk_end_date,'99991231') >= v_sysdat)  -- 进行中任务
         UNION
         -- 09-M（客户经理归属）：DWD_CUST_MAN 无历史表，按当日管户取 cust_id ----------------------------
         SELECT s.statis_calib, s.indx_code, s.data_blng, s.term_begin_date, cm.cust_id, s.persn_legal_bk_code
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
            AND EXISTS (SELECT 1 FROM CRM.MKT_TSK_INDX_SUB sub WHERE sub.tsk_id = s.statis_calib AND NVL(sub.tsk_end_date,'99991231') >= v_sysdat)  -- 进行中任务
     )
     SELECT DISTINCT                                              -- 去重（同一客户可能同时命中O型+M型）
            '09'             AS statis_dim,                      -- 统计维度=09目标任务
            sm.statis_calib,                                         -- 统计口径=任务编号
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
    -- DELETE：入数前清掉今日批次已写入的08冻结明细（base_run_date=跑批日；历史冻结行保留，保证重跑幂等）
    DELETE FROM ADS_STAT_INDX_BASELINE_DTL
     WHERE statis_dim = '08'
       AND base_run_date = v_sysdat;                         -- 仅清当日批次行（v4.9.2）

    INSERT INTO ADS_STAT_INDX_BASELINE_DTL (                 -- 插入冻结明细表
        statis_dim, statis_calib, indx_code, data_blng, cust_id,  -- 统计维度、统计口径、指标代码、数据归属、客户ID
        persn_legal_bk_code, base_data_date, base_run_date,  -- 法人机构编号、基准数据日期、基准跑批日期
        base_cust_lvl, base_mth_avg_aum                      -- 基准客户等级、基准月日均AUM
    )
    SELECT CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END,  -- 路径映射统计维度
           s.statis_calib,                                             -- 统计口径
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
        ON m.statis_dim        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END  -- 维度一致
       AND m.statis_calib          = s.statis_calib                      -- 口径一致
       AND m.data_blng           = s.data_blng                       -- 归属一致
       AND m.persn_legal_bk_code = s.persn_legal_bk_code             -- 法人机构一致
      LEFT JOIN DWS_CUST_LVL_INFO lv                                 -- 关联客户层级信息
        ON lv.cust_id             = m.cust_id                        -- 客户ID一致
       AND lv.persn_legal_bk_code = m.persn_legal_bk_code            -- 法人机构一致
       AND lv.data_date           = v_sysdat                         -- 取跑批日期当日层级
      LEFT JOIN DWS_CUST_ASSE_LIAB b                                 -- 关联资产负债表
        ON b.cust_id             = m.cust_id                         -- 客户ID一致
       AND b.persn_legal_bk_code = m.persn_legal_bk_code             -- 法人机构一致
      -- AND b.data_date           = v_sysdat                          -- 取跑批日期当日余额
       AND b.bal_type            = '2'                               -- 余额类型为月日均
     WHERE s.term_begin_date = V_NEXT_DAY                            -- 仅取开始日期为今日的范围
       AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')  -- 仅需冻结明细的指标
       AND (s.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)  -- 需客户等级的指标必须能取到层级（内连接效果）
       AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL);     -- 需AUM的指标必须能取到余额（内连接效果）

    -- =========================================================== 09每日重算（v4.8） ==============
    -- 3.2b 目标任务：进行中任务每日重算 ADS_STAT_INDX_BASELINE_DTL（路径09专用；基准日等值直连HIS）
    --        DELETE按(path+dim+indx+blng+bk+cust)整删整插；基准固定为 task_begin_date前1天快照 -----
    -- 1) DELETE：全量清空09路径基准明细行（v4.9.3，同§3.1b口径；顺带消除按客户收窄删除的孤儿明细行残留）
    DELETE FROM ADS_STAT_INDX_BASELINE_DTL
     WHERE statis_dim = '09';

    -- 2) INSERT：DTL 基准重灌 --------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_DTL (                       -- 插入基准明细表（路径09每日重算）
        statis_dim, statis_calib, indx_code, data_blng, cust_id, persn_legal_bk_code, base_data_date, base_run_date, base_cust_lvl, base_mth_avg_aum  -- DTL基准字段列表
    )
SELECT '09',                                          -- 统计维度=09目标任务
            s.statis_calib,                                          -- 统计口径=任务编号
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
         ON m.statis_dim        = '09'                    -- 仅09路径MEMBER
        AND s.path_code           = '09'
        AND m.statis_calib          = s.statis_calib
        AND m.data_blng           = s.data_blng
        AND m.persn_legal_bk_code = s.persn_legal_bk_code
      INNER JOIN DWS_CUST_LVL_INFO_HIS lv                                    -- 客户等级基准源（取对应基准日快照）
         ON lv.cust_id             = m.cust_id
        AND lv.persn_legal_bk_code = m.persn_legal_bk_code
        AND lv.data_date           = sys_fun_deal_date(s.term_begin_date, 1)
       LEFT JOIN DWS_CUST_ASSE_LIAB_HIS b                                     -- AUM基准源（取对应基准日BAL_TYPE=2快照）
         ON b.cust_id              = m.cust_id
        AND b.persn_legal_bk_code  = m.persn_legal_bk_code
        AND b.data_date            = sys_fun_deal_date(s.term_begin_date, 1)
        AND b.bal_type             = '2'
      WHERE s.term_begin_date <= v_sysdat                          -- 任务已开始/冻结日
        AND s.indx_code IN ('INDX_0052','INDX_0053','INDX_0054','INDX_0063')
        AND EXISTS (SELECT 1 FROM CRM.MKT_TSK_INDX_SUB sub WHERE sub.tsk_id=s.statis_calib AND NVL(sub.tsk_end_date,'99991231')>=v_sysdat)  -- 进行中任务
        AND (s.indx_code NOT IN ('INDX_0052','INDX_0053','INDX_0054') OR lv.cust_id IS NOT NULL)  -- 层级指标缺等级跳过
        AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL);  -- 临界AUM指标缺快照跳过
    -- =========================================================== 09每日重算 结束 ==================


    -------------------------------------------------------------------------
    -- 3.3 冻结汇总表 ADS_STAT_INDX_BASELINE_SUM
    -------------------------------------------------------------------------
    -- DELETE：入数前清掉今日批次已写入的08冻结汇总（base_run_date=跑批日；历史冻结行保留，保证重跑幂等）
    DELETE FROM ADS_STAT_INDX_BASELINE_SUM
     WHERE statis_dim = '08'
       AND base_run_date = v_sysdat;                         -- 仅清当日批次行（v4.9.2）

    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (                            -- 插入冻结汇总表
        statis_dim, statis_calib, indx_code, data_blng, persn_legal_bk_code,  -- 统计维度、统计口径、指标代码、数据归属、法人机构编号
        base_data_date, base_run_date, base_loan_bal, base_yr_avg_fin,  -- 基准数据日期、基准跑批日期、基准贷款余额、基准年日均金融资产
        base_mth_avg_fin, base_yr_avg_agen_fin, base_mth_avg_agen_fin,  -- 基准月日均金融资产、基准年日均代发金融资产、基准月日均代发金融资产
        base_fin_bal, base_agen_fin_bal,                                -- 基准金融资产余额、基准代发金融资产余额
        base_yr_avg_depo, base_mth_avg_depo                             -- 基准年日均存款、基准月日均存款（v4.6新增）
    )
SELECT CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END,                                                     -- 路径映射统计维度
           s.statis_calib,                                                                                                -- 统计口径
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
        ON m.statis_dim        = CASE WHEN s.path_code = '08' THEN '08' ELSE '09' END                              -- 维度一致
       AND m.statis_calib          = s.statis_calib                                                                         -- 口径一致
       AND m.data_blng           = s.data_blng                                                                          -- 归属一致
       AND m.persn_legal_bk_code = s.persn_legal_bk_code                                                                -- 法人机构一致
      INNER JOIN DWS_CUST_ASSE_LIAB b                                                                                              -- 关联资产负债余额表（仅取有余额的成员）
        ON b.cust_id             = m.cust_id                                                                            -- 客户ID一致
       AND b.persn_legal_bk_code = m.persn_legal_bk_code                                                                -- 法人机构一致
      -- AND b.data_date           = m.base_data_date                                                                     -- 余额取基准数据日期
     WHERE s.term_begin_date = V_NEXT_DAY                                                                               -- 仅取开始日期为今日的范围
       AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')  -- 需冻结至汇总表的指标集合
     GROUP BY s.path_code, s.statis_calib, s.indx_code, s.data_blng, s.persn_legal_bk_code;  -- 按路径/口径/指标/归属/法人机构分组汇总

    -- =========================================================== 09每日重算（v4.8） ==============
    -- 3.3a 目标任务：进行中任务每日重算 ADS_STAT_INDX_BASELINE_SUM（路径09专用）
    --        DELETE按(calib+dim+indx+blng+bk)整删整插；SUM源直连HIS表（基准日=开始前一天） -----
    -- 1) DELETE：全量清空09路径基准汇总行（v4.9.3，同§3.1b口径）
    DELETE FROM ADS_STAT_INDX_BASELINE_SUM
     WHERE statis_dim = '09';

    -- 2) INSERT：SUM基准重灌 ------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (                     -- 基准汇总表（09每日重算）
        statis_dim, statis_calib, indx_code, data_blng, persn_legal_bk_code, base_data_date, base_run_date,
        base_loan_bal, base_yr_avg_fin, base_mth_avg_fin, base_yr_avg_agen_fin, base_mth_avg_agen_fin,
        base_fin_bal, base_agen_fin_bal, base_yr_avg_depo, base_mth_avg_depo
    )
SELECT '09',                                          -- 统计维度09
            s.statis_calib,                                         -- 口径=任务编号
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
         ON m.statis_dim        = '09'
        AND s.path_code           = '09'
        AND m.statis_calib          = s.statis_calib
        AND m.data_blng           = s.data_blng
        AND m.persn_legal_bk_code = s.persn_legal_bk_code
      INNER JOIN DWS_CUST_ASSE_LIAB_HIS b                                -- ASSE基准源（HIS，基准日=开始前一天）
         ON b.cust_id             = m.cust_id
        AND b.persn_legal_bk_code = m.persn_legal_bk_code
        AND b.data_date           = sys_fun_deal_date(s.term_begin_date, 1)  -- 固定基准日匹配
      WHERE s.term_begin_date <= v_sysdat                         -- 任务已开始/冻结日
        AND s.indx_code IN ('INDX_0050','INDX_0051','INDX_0055','INDX_0056','INDX_0057','INDX_0058','INDX_0059','INDX_0060','INDX_0062')
        AND EXISTS (SELECT 1 FROM CRM.MKT_TSK_INDX_SUB sub WHERE sub.tsk_id=s.statis_calib AND NVL(sub.tsk_end_date,'99991231')>=v_sysdat)  -- 进行中
      GROUP BY s.statis_calib, s.indx_code, s.data_blng, s.persn_legal_bk_code,
         sys_fun_deal_date(s.term_begin_date, 1);  -- 分组汇总
    -- =========================================================== 09每日重算 结束 ==================




    -------------------------------------------------------------------------
    -- 3.3b 存量活动0050/0051基准补跑（v4.6）
    --     活动已开始但缺少0050/0051冻结基准时，按当日最新快照补建基准
    -------------------------------------------------------------------------
    INSERT INTO ADS_STAT_INDX_BASELINE_SUM (                                -- 补跑插入冻结汇总表（仅存款基准）
        statis_dim, statis_calib, indx_code, data_blng, persn_legal_bk_code,-- 统计维度、统计口径、指标代码、数据归属、法人机构编号
        base_data_date, base_run_date, base_yr_avg_depo, base_mth_avg_depo  -- 基准数据日期、基准跑批日期、基准年日均存款、基准月日均存款
    )
    WITH scope_member AS (  -- 组装存量活动范围内成员
        -- 路径08：营销活动成员
        SELECT s.path_code, s.statis_calib, s.indx_code, s.data_blng,  -- 路径代码、统计口径、指标代码、数据归属
               s.term_begin_date, ti.cust_id, s.persn_legal_bk_code  -- 开始日期、客户ID、法人机构编号
          FROM TMP_STAT_INDX_SCOPE s                                 -- 指标范围临时表
         INNER JOIN CRM.MKT_TSK_INFO ti                              -- 关联营销活动任务信息
            ON s.path_code             = '08'                         -- 限定路径08（营销活动）
           AND ti.mkt_act_id           = s.statis_calib                -- 活动ID等于统计口径
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code       -- 法人机构一致
           --AND ti.data_date            = v_sysdat                    -- 取跑批日期当日活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) -- 按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id))-- 按客户经理归属匹配
         WHERE s.term_begin_date < v_sysdat                          -- 仅取已开始（存量）的活动范围
           AND s.indx_code IN ('INDX_0050','INDX_0051')              -- 仅补跑0050/0051指标
    )
    SELECT '08',  -- 路径映射统计维度
           sm.statis_calib,                                             -- 统计口径
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
       --AND b.data_date           = v_sysdat                           -- 取跑批日期当日余额
     WHERE NOT EXISTS (                                               -- 过滤已存在基准，避免重复补跑
         SELECT 1
           FROM ADS_STAT_INDX_BASELINE_SUM x                    -- 冻结汇总表
          WHERE x.statis_dim        = '08'  -- 维度一致
            AND x.statis_calib          = sm.statis_calib           -- 口径一致
            AND x.indx_code           = sm.indx_code            -- 指标一致
            AND x.data_blng           = sm.data_blng            -- 归属一致
            AND x.persn_legal_bk_code = sm.persn_legal_bk_code  -- 法人机构一致
     )
     GROUP BY sm.path_code, sm.statis_calib, sm.indx_code, sm.data_blng, sm.persn_legal_bk_code;  -- 按路径/口径/指标/归属/机构分组汇总


    -------------------------------------------------------------------------
    -- 3.4-0 基准表生命周期清理（v4.9 新增 LOAN_BASE，v4.9.4 扩展 MEMBER/DTL/SUM；仅路径08——09行由各段每日全量清自洁）
    --     活动结束日+3个自然月（路径08） <= 跑批日 → 删除对应期初基准（清理规则对齐 plan_006 §7.0.0 基数表清理）
    --     v4.9.6: 删除条件实现为 STATIS_STOP_DATE <= 跑批日-3个自然月（日期函数仅作用常量侧，列侧为裸列；与结束日+3月<=跑批日语义等价）
    --     路径08: CRM.MKT_ACT_INFO.STATIS_STOP_DATE
    --     结束日为空或 '99991231' 视为无限期，不清理
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_LOAN_BASE T
     WHERE (T.PATH_CODE = '08'
            AND EXISTS (SELECT 1
                          FROM CRM.MKT_ACT_INFO A
                         WHERE A.MKT_ACT_ID = T.STATIS_CALIB
                           AND A.STATIS_STOP_DATE IS NOT NULL
                           AND A.STATIS_STOP_DATE <> '99991231'
                           AND A.STATIS_STOP_DATE <= V_BFR_3MON));

    -- MEMBER/DTL/SUM 同规则清理（v4.9.4 扩展；仅路径08——09行由各段每日全量清自洁，无需生命周期清理）
    DELETE FROM ADS_STAT_INDX_BASELINE_MEMBER M
     WHERE M.STATIS_DIM = '08'
       AND EXISTS (SELECT 1
                     FROM CRM.MKT_ACT_INFO A
                    WHERE A.MKT_ACT_ID = M.STATIS_CALIB
                      AND A.STATIS_STOP_DATE IS NOT NULL
                      AND A.STATIS_STOP_DATE <> '99991231'
                      AND A.STATIS_STOP_DATE <= V_BFR_3MON);

    DELETE FROM ADS_STAT_INDX_BASELINE_DTL D
     WHERE D.STATIS_DIM = '08'
       AND EXISTS (SELECT 1
                     FROM CRM.MKT_ACT_INFO A
                    WHERE A.MKT_ACT_ID = D.STATIS_CALIB
                      AND A.STATIS_STOP_DATE IS NOT NULL
                      AND A.STATIS_STOP_DATE <> '99991231'
                      AND A.STATIS_STOP_DATE <= V_BFR_3MON);

    DELETE FROM ADS_STAT_INDX_BASELINE_SUM B
     WHERE B.STATIS_DIM = '08'
       AND EXISTS (SELECT 1
                     FROM CRM.MKT_ACT_INFO A
                    WHERE A.MKT_ACT_ID = B.STATIS_CALIB
                      AND A.STATIS_STOP_DATE IS NOT NULL
                      AND A.STATIS_STOP_DATE <> '99991231'
                      AND A.STATIS_STOP_DATE <= V_BFR_3MON);

    -------------------------------------------------------------------------
    -- 3.4 个贷新形成不良贷款率期初基准(0066)
    --     活动开始前一天冻结正常(1)/关注(2)贷款账户为基准, 后续沿用不重建
    -------------------------------------------------------------------------
    -- DELETE：入数前清掉今日批次已写入的08冻结个贷基准（base_date=跑批日即活动开始前一天冻结日；历史冻结行保留，保证重跑幂等）
    DELETE FROM TMP_STAT_INDX_LOAN_BASE
     WHERE path_code = '08'
       AND base_date = v_sysdat;                             -- 仅清当日批次行（v4.9.2）

    INSERT INTO TMP_STAT_INDX_LOAN_BASE (                 -- 插入个贷贷款期初基准临时表
        path_code, statis_calib, data_blng, persn_legal_bk_code,  -- 路径代码、统计口径、数据归属、法人机构编号
        cust_id, acct_id, loan_bal, class_five, base_date  -- 客户ID、账户ID、贷款余额、五级分类、基准日期
    )
    WITH scope_cust AS (                                              -- 组装0066指标范围内客户
        SELECT s.path_code, s.statis_calib, s.data_blng, s.persn_legal_bk_code, ti.cust_id  -- 路径/口径/归属/机构及客户ID
          FROM TMP_STAT_INDX_SCOPE s                                  -- 指标范围临时表
         INNER JOIN CRM.MKT_TSK_INFO ti                               -- 关联营销活动任务信息
            ON ti.mkt_act_id           = s.statis_calib                 -- 活动ID等于统计口径
           AND ti.persn_legal_bk_code  = s.persn_legal_bk_code        -- 法人机构一致
           --AND ti.data_date            = v_sysdat                     -- 取跑批日期当日活动信息
           AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id)  -- 按机构归属匹配
             OR (s.blng_type = 'M' AND ti.mkt_persn     = s.blng_id)) -- 按客户经理归属匹配
         WHERE s.term_begin_date = V_NEXT_DAY                         -- 仅取开始日期为今日的范围
           AND s.path_code       = '08'                                -- 限定路径08（营销活动）
           AND s.indx_code       = 'INDX_0066'                        -- 仅取0066指标
    )
    SELECT sc.path_code, sc.statis_calib, sc.data_blng, sc.persn_legal_bk_code,  -- 路径/口径/归属/机构
           a.cust_id, NULL AS acct_id, NVL(b.loan_bal, 0) AS loan_bal,  -- 客户ID、账户ID(恒NULL)、期初贷款余额
           a.class_five, v_sysdat                                  -- 五级分类(基准日快照)、基准建立日期
      FROM scope_cust sc                                       -- 范围内客户
      INNER JOIN DWS_CUST_CLASSFIVE a                             -- 客户五级分类表（data_date含全历史）
        ON a.cust_id             = sc.cust_id                  -- 客户ID一致
       AND a.persn_legal_bk_code = sc.persn_legal_bk_code      -- 法人机构一致
        AND a.data_date           = v_sysdat                       -- 活动冻结日 = 跑批日(活动开始前一天)
        AND a.class_five IN ('1', '2')                           -- 仅取五级分类为正常(1)、关注(2)的客户
      LEFT JOIN DWS_CUST_ASSE_LIAB b                             -- v4.9.5: 期初余额源（与§3.3 base_loan_bal同源）
        ON b.cust_id             = a.cust_id                  -- 客户ID一致
       AND b.persn_legal_bk_code = a.persn_legal_bk_code      -- 法人机构一致
        --AND b.data_date           = v_sysdat                       -- 冻结日=跑批日，取主表当日余额
        AND b.bal_type            = '1';                           -- 类型1-余额
     -------------------------------------------------------------------------
     -- 3.4b 路径09-0066 基数每日重算（DELETE+INSERT）  v4.8
     --     固定基准日 = term_begin_date - 1；任务期内每日 DELETE 再重算
     --     分类来源：DWS_CUST_CLASSFIVE（data_date 含全历史，期初按基准日 sys_fun_deal_date(s.term_begin_date,1) 取）
     -------------------------------------------------------------------------
    -- 1) DELETE：全量清空09路径0066基数行（v4.9.3，同§3.1b口径；08行不受影响）
    DELETE FROM TMP_STAT_INDX_LOAN_BASE
     WHERE path_code = '09';

     -- 2) INSERT：09-O（机构）+ 09-M（经理）合并写入
     INSERT INTO TMP_STAT_INDX_LOAN_BASE (
         path_code, statis_calib, data_blng, persn_legal_bk_code,
         cust_id, acct_id, loan_bal, class_five, base_date
     )
     WITH scope_cust AS (
         -- 09-O：机构归属客户
         SELECT s.path_code, s.statis_calib, s.data_blng, s.persn_legal_bk_code, lv.cust_id,
                sys_fun_deal_date(s.term_begin_date, 1) AS base_date
           FROM TMP_STAT_INDX_SCOPE s
          INNER JOIN DWS_CUST_LVL_INFO_HIS lv
             ON lv.org_id              = s.blng_id
            AND lv.persn_legal_bk_code = s.persn_legal_bk_code
            AND lv.data_date           = sys_fun_deal_date(s.term_begin_date, 1)
          WHERE s.term_begin_date <= v_sysdat
            AND s.path_code       = '09'
            AND s.blng_type       = 'O'
            AND s.indx_code       = 'INDX_0066'
            AND EXISTS (SELECT 1 FROM CRM.MKT_TSK_INDX_SUB sub
                         WHERE sub.tsk_id = s.statis_calib
                           AND NVL(sub.tsk_end_date, '99991231') >= v_sysdat)
         UNION
         -- 09-M：客户经理归属客户
         SELECT s.path_code, s.statis_calib, s.data_blng, s.persn_legal_bk_code, cm.cust_id,
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
            AND EXISTS (SELECT 1 FROM CRM.MKT_TSK_INDX_SUB sub
                         WHERE sub.tsk_id = s.statis_calib
                           AND NVL(sub.tsk_end_date, '99991231') >= v_sysdat)
     )
     SELECT sc.path_code, sc.statis_calib, sc.data_blng, sc.persn_legal_bk_code,
            a.cust_id,
            NULL                             AS acct_id,
            NVL(b.loan_bal, 0)               AS loan_bal,
            a.class_five,
            sc.base_date
       FROM scope_cust sc
      INNER JOIN DWS_CUST_CLASSFIVE a
         ON a.cust_id             = sc.cust_id
        AND a.persn_legal_bk_code = sc.persn_legal_bk_code
        AND a.data_date           = sc.base_date
        AND a.class_five IN ('1', '2')
      LEFT JOIN DWS_CUST_ASSE_LIAB_HIS b                          -- v4.9.5: 期初余额源（HIS，基准日=任务开始前一天，同§3.3a模式）
         ON b.cust_id              = a.cust_id
        AND b.persn_legal_bk_code  = a.persn_legal_bk_code
        AND b.data_date            = sc.base_date              -- 基准日余额
        AND b.bal_type             = '1';                      -- 类型1-余额

    -------------------------------------------------------------------------
    -- 清理仅用于冻结的范围数据
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_SCOPE WHERE term_begin_date = V_NEXT_DAY;  -- 冻结用毕即清（注：scope写者=plan_001，属跨过程清理【规则例外·待决策】，迁移需同步改造冻结段防明日对象提前计算）

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