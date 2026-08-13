CREATE OR REPLACE PROCEDURE prc_ads_stat_indx_data(v_sysdat IN VARCHAR, -- 跑批业务日期：VARCHAR(8)，YYYYMMDD 格式，无默认值，必须为合法自然日
                                                         outcde   OUT INTEGER -- 执行结果状态码：INTEGER，0=成功，-1=失败；仅由存储过程内部覆盖写入
                                                         ) AS
  -- ----------------------------------------------------------------
  -- 全局常量与基础控制变量声明
  -- ----------------------------------------------------------------
  V_PRC_DESC        VARCHAR2(100) := '指标数据统计'; -- 过程业务描述：固定字符串
  V_PRC_NAME        VARCHAR2(32) := 'PRC_ADS_STAT_INDX_DATA'; -- 存储过程名称：固定字符串
  V_LOG_MSG         VARCHAR2(4000); -- 步骤日志详细文本：最大 4000 字符
  V_LOG_FLG         INTEGER; -- 日志状态标识：0=成功，-1=失败
  V_LOG_BUTTON      INTEGER := 1; -- 日志记录总开关：1=开启日志记录，0=关闭
  V_SUCCESS_LOG_SUM VARCHAR2(4000) := ''; -- 成功步骤日志汇总：最终提交后一次性持久化，避免日志过程提交业务事务
  V_NO_ID           VARCHAR2(10); -- 当前处理步骤编号：如 1、2、3、4、4B、5、6、6B、6C、6D、7
  V_BGN_DATE        DATE; -- 当前步骤开始时间：每个步骤初始化时赋值
  V_END_DATE        DATE; -- 当前步骤结束时间：写日志前赋值
  V_DURA_DATE       INTEGER; -- 当前步骤执行耗时（单位：秒）：非负整数
  V_ROW_COUNT       INTEGER; -- 记录最近一条 DML 操作受影响的数据行数

  -- ----------------------------------------------------------------
  -- 数据质量校验与监控计数变量
  -- ----------------------------------------------------------------
  V_BASELINE_DTL_COUNT     INTEGER; -- 统计开始前一天冻结的客户基准明细行数
  V_MISSING_BASELINE_COUNT INTEGER; -- 已开始执行但缺失基准数据的对象数量（大于 0 则触发异常终止）
  V_INVALID_RESULT_COUNT   INTEGER; -- 发布前校验：主键字段存在空值的结果行数
  V_DUPLICATE_RESULT_COUNT INTEGER; -- 发布前校验：重复业务主键的结果组数

  -- ----------------------------------------------------------------
  -- 日期边界衍生变量（YYYYMMDD 格式）
  -- ----------------------------------------------------------------
  V_MTH_BEGIN     VARCHAR2(8); -- 当月月初日期：由 SYS_FUN_DEAL_DATE(v_sysdat, 9) 衍生
  V_MTH_END       VARCHAR2(8); -- 上月月末日期：由 SYS_FUN_DEAL_DATE(v_sysdat, 2) 衍生
  V_QRT_END       VARCHAR2(8); -- 上季末日期：由 SYS_FUN_DEAL_DATE(v_sysdat, 3) 衍生
  V_YAR_BEGIN     VARCHAR2(8); -- 当年初日期：由 SYS_FUN_DEAL_DATE(v_sysdat, 13) 衍生
  V_YAR_PREV_END  VARCHAR2(8); -- 上年末日期：由 SYS_FUN_DEAL_DATE(v_sysdat, 4) 衍生
  V_180_DAY_BEGIN VARCHAR2(8); -- 新客识别窗口起点：SYS_FUN_DEAL_DATE(v_sysdat, 27)
  V_NEXT_DAY      VARCHAR2(8); -- 跑批日期次日：SYS_FUN_DEAL_DATE(v_sysdat, 28)，用于开始日前一天范围和基准冻结

  -- ----------------------------------------------------------------
  -- 内部子程序：汇总步骤成功日志；不调用日志过程，避免其内部 COMMIT 打断业务事务。
  -- 参数：P_MESSAGE - 业务逻辑执行描述文本
  -- ----------------------------------------------------------------
  PROCEDURE LOG_STEP(P_MESSAGE IN VARCHAR2) IS
  BEGIN
    V_END_DATE        := SYSDATE;
    V_DURA_DATE       := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    V_SUCCESS_LOG_SUM := SUBSTR(V_SUCCESS_LOG_SUM || CASE
                                  WHEN V_SUCCESS_LOG_SUM IS NULL OR
                                       V_SUCCESS_LOG_SUM = '' THEN
                                   ''
                                  ELSE
                                   '；'
                                END || '[' || V_NO_ID || ']' || P_MESSAGE,
                                1,
                                4000);
  END LOG_STEP;

BEGIN
  -- ----------------------------------------------------------------
  -- 输入参数规范性强校验：防止空值、非8位数字及非法日期引起的报错
  -- ----------------------------------------------------------------
  IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN
    outcde := -1;
    RAISE_APPLICATION_ERROR(-20001,
                            '入参 V_SYSDAT 必须为 8 位数字 YYYYMMDD 格式');
  END IF;

  BEGIN
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');
  EXCEPTION
    WHEN OTHERS THEN
      outcde := -1;
      RAISE_APPLICATION_ERROR(-20001,
                              '入参 V_SYSDAT 并非合法的自然日日期: ' || v_sysdat);
  END;

  -- ----------------------------------------------------------------
  -- 日期边界派生计算：统一调用日期函数，避免后续 SQL 内重复计算
  -- ----------------------------------------------------------------
  V_MTH_BEGIN     := sys_fun_deal_date(v_sysdat, 9); -- 当月初
  V_MTH_END       := sys_fun_deal_date(v_sysdat, 2); -- 上月末
  V_QRT_END       := sys_fun_deal_date(v_sysdat, 3); -- 上季末
  V_YAR_BEGIN     := sys_fun_deal_date(v_sysdat, 13); -- 当年初
  V_YAR_PREV_END  := sys_fun_deal_date(v_sysdat, 4); -- 上年末
  V_180_DAY_BEGIN := sys_fun_deal_date(v_sysdat, 27); -- 180 天新客窗口开始日
  V_NEXT_DAY      := sys_fun_deal_date(v_sysdat, 28); -- 次日

  -- ================================================================
  -- 段落名称：步骤1 - 清空会话临时表与环境准备
  -- 业务功能：Truncate 会话相关的统计临时表，确保当前跑批环境无残留数据干扰。
  -- ================================================================
  V_NO_ID    := '1';
  V_BGN_DATE := SYSDATE;

  -- TMP 为共享物理表；先获得事务级排他锁，禁止同过程并发清理或写入。
  LOCK TABLE TMP_STAT_INDX_SCOPE IN EXCLUSIVE MODE NOWAIT;
  LOCK TABLE TMP_STAT_INDX_BAL_AGGR IN EXCLUSIVE MODE NOWAIT;
  LOCK TABLE TMP_STAT_INDX_CUST_STATE IN EXCLUSIVE MODE NOWAIT;
  LOCK TABLE TMP_STAT_INDX_AGGR IN EXCLUSIVE MODE NOWAIT;

  DELETE FROM TMP_STAT_INDX_SCOPE;
  DELETE FROM TMP_STAT_INDX_BAL_AGGR;
  DELETE FROM TMP_STAT_INDX_CUST_STATE;
  DELETE FROM TMP_STAT_INDX_AGGR;

  LOG_STEP('STEP');

  -- ================================================================
  -- 段落名称：步骤2 - 提取并构建非客户维度的指标统计范围
  -- 业务功能：按营销活动（路径 A）和目标任务（路径 B）抽取有效的统计范围，
  --           限定在机构（ORG）和客户经理（MGR）维度，禁止客户明细落入 scope 表。
  -- ================================================================
  V_NO_ID    := '2';
  V_BGN_DATE := SYSDATE;

  -- 2.1 营销活动路径（PATH_CODE = 'A'）：提取机构与客户经理维度统计范围
  INSERT INTO TMP_STAT_INDX_SCOPE
    (path_code,
     statis_dim,
     indx_code,
     data_blng,
     blng_type,
     blng_id,
     term_begin_date,
     persn_legal_bk_code)
    SELECT DISTINCT 'A', -- 路径代码：A=营销活动
                    a.mkt_act_id, -- 统计维度ID：营销活动编号
                    t.indx_id, -- 指标编码
                    'ORG_' || ti.mkt_persn_org, -- 数据归属：机构组合键
                    'O', -- 归属类型：O=机构
                    ti.mkt_persn_org, -- 归属机构ID
                    a.act_bgn_date, -- 统计期起始日期
                    ti.persn_legal_bk_code -- 法人行号
      FROM DWD_MKT_ACT_INFO a
     INNER JOIN DWD_MKT_ACT_TARGT t
        ON t.mkt_act_id = a.mkt_act_id
     INNER JOIN DWD_MKT_TSK_INFO ti
        ON ti.mkt_act_id = a.mkt_act_id
       AND ti.mkt_persn_org = t.prtspt_org
       AND ti.persn_legal_bk_code = a.persn_legal_bk_code
       AND ti.data_date = v_sysdat
     WHERE a.act_bgn_date <= V_NEXT_DAY
       AND NVL(a.statis_stop_date, '99991231') >= v_sysdat
       AND a.camp_act_typ IN ('1', '2')
       AND ti.mkt_persn_org IS NOT NULL
    UNION
    SELECT DISTINCT 'A', -- 路径代码：A=营销活动
                    a.mkt_act_id, -- 统计维度ID：营销活动编号
                    t.indx_id, -- 指标编码
                    'MGR_' || ti.mkt_persn, -- 数据归属：客户经理组合键
                    'M', -- 归属类型：M=客户经理
                    ti.mkt_persn, -- 归属岗位ID
                    a.act_bgn_date, -- 统计期起始日期
                    ti.persn_legal_bk_code -- 法人行号
      FROM DWD_MKT_ACT_INFO a
     INNER JOIN DWD_MKT_ACT_TARGT t
        ON t.mkt_act_id = a.mkt_act_id
     INNER JOIN DWD_MKT_TSK_INFO ti
        ON ti.mkt_act_id = a.mkt_act_id
       AND ti.mkt_persn_org = t.prtspt_org
       AND ti.persn_legal_bk_code = a.persn_legal_bk_code
       AND ti.data_date = v_sysdat
     WHERE a.act_bgn_date <= V_NEXT_DAY
       AND NVL(a.statis_stop_date, '99991231') >= v_sysdat
       AND a.camp_act_typ IN ('1', '2')
       AND ti.mkt_persn IS NOT NULL;

  -- 2.2 目标任务路径（PATH_CODE = 'B'）：提取机构与客户经理维度统计范围
  INSERT INTO TMP_STAT_INDX_SCOPE
    (path_code,
     statis_dim,
     indx_code,
     data_blng,
     blng_type,
     blng_id,
     term_begin_date,
     persn_legal_bk_code)
    SELECT DISTINCT 'B', -- 路径代码：B=目标任务
                    it.tsk_id, -- 统计维度ID：任务编号
                    sub.indx_id, -- 指标编码
                    'ORG_' || it.rsv_obj_id, -- 数据归属：机构组合键
                    'O', -- 归属类型：O=机构
                    it.rsv_obj_id, -- 接收机构ID
                    sub.tsk_bgn_date, -- 任务起始日期
                    it.persn_legal_bk_code -- 法人行号
      FROM DWD_MKT_INDX_TSK it
     INNER JOIN DWD_MKT_TSK_INDX_SUB sub
        ON sub.tsk_id = it.tsk_id
       AND sub.persn_legal_bk_code = it.persn_legal_bk_code
     WHERE it.rsv_obj = '0' -- 接收对象类型：0=机构
       AND sub.tsk_bgn_date <= V_NEXT_DAY
       AND NVL(sub.tsk_end_date, '99991231') >= v_sysdat
    UNION
    SELECT DISTINCT 'B', -- 路径代码：B=目标任务
                    it.tsk_id, -- 统计维度ID：任务编号
                    sub.indx_id, -- 指标编码
                    'MGR_' || it.rsv_obj_id, -- 数据归属：客户经理组合键
                    'M', -- 归属类型：M=客户经理
                    it.rsv_obj_id, -- 接收岗位ID
                    sub.tsk_bgn_date, -- 任务起始日期
                    it.persn_legal_bk_code -- 法人行号
      FROM DWD_MKT_INDX_TSK it
     INNER JOIN DWD_MKT_TSK_INDX_SUB sub
        ON sub.tsk_id = it.tsk_id
       AND sub.persn_legal_bk_code = it.persn_legal_bk_code
     WHERE it.rsv_obj = '1' -- 接收对象类型：1=客户经理
       AND sub.tsk_bgn_date <= V_NEXT_DAY
       AND NVL(sub.tsk_end_date, '99991231') >= v_sysdat;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤2完成：路径A/B非客户指标范围构建完毕，写入行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤3 - 活动/任务开始前一天冻结增量指标客户范围与期初基准
  -- 业务功能：对增量指标（0052-0056, 0058, 0059, 0062, 0063），仅在活动开始前一天
  --           冻结客户成员表（BASELINE_MEMBER）与基准快照（BASELINE_DTL / SUM）。
  --           活动期间严禁补建，如缺失则中断跑批抛出异常。
  -- ================================================================
  V_NO_ID    := '3';
  V_BGN_DATE := SYSDATE;

  -- 3.1 冻结客户成员范围表（ADS_STAT_INDX_BASELINE_MEMBER）
  INSERT INTO ADS_STAT_INDX_BASELINE_MEMBER
    (statis_calib,
     statis_dim,
     data_blng,
     cust_id,
     persn_legal_bk_code,
     base_data_date,
     base_run_date)
    WITH scope_member AS
     (
      -- 营销活动路径关联客户
      SELECT s.path_code,
              s.statis_dim,
              s.indx_code,
              s.data_blng,
              s.term_begin_date,
              ti.cust_id,
              s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_MKT_TSK_INFO ti
          ON s.path_code = 'A'
         AND ti.mkt_act_id = s.statis_dim
         AND ti.persn_legal_bk_code = s.persn_legal_bk_code
         AND ti.data_date = v_sysdat
         AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) OR
             (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
       WHERE s.term_begin_date = V_NEXT_DAY
         AND s.indx_code IN ('INDX_0052',
                             'INDX_0053',
                             'INDX_0054',
                             'INDX_0055',
                             'INDX_0056',
                             'INDX_0058',
                             'INDX_0059',
                             'INDX_0062',
                             'INDX_0063')
      UNION
      -- 目标任务路径 - 机构管辖客户
      SELECT s.path_code,
             s.statis_dim,
             s.indx_code,
             s.data_blng,
             s.term_begin_date,
             lv.cust_id,
             s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWS_CUST_LVL_INFO lv
          ON s.path_code = 'B'
         AND s.blng_type = 'O'
         AND lv.org_id = s.blng_id
         AND lv.persn_legal_bk_code = s.persn_legal_bk_code
         AND lv.data_date = v_sysdat
       WHERE s.term_begin_date = V_NEXT_DAY
         AND s.indx_code IN ('INDX_0052',
                             'INDX_0053',
                             'INDX_0054',
                             'INDX_0055',
                             'INDX_0056',
                             'INDX_0058',
                             'INDX_0059',
                             'INDX_0062',
                             'INDX_0063')
      UNION
      -- 目标任务路径 - 客户经理名下客户
      SELECT s.path_code,
             s.statis_dim,
             s.indx_code,
             s.data_blng,
             s.term_begin_date,
             cm.cust_id,
             s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_CUST_MAN cm
          ON s.path_code = 'B'
         AND s.blng_type = 'M'
         AND cm.mngr_post_id = s.blng_id
         AND cm.mng_typ = '1'
         AND cm.persn_legal_bk_code = s.persn_legal_bk_code
       WHERE s.term_begin_date = V_NEXT_DAY
         AND s.indx_code IN ('INDX_0052',
                             'INDX_0053',
                             'INDX_0054',
                             'INDX_0055',
                             'INDX_0056',
                             'INDX_0058',
                             'INDX_0059',
                             'INDX_0062',
                             'INDX_0063'))
    SELECT DISTINCT CASE
                      WHEN sm.path_code = 'A' THEN
                       '营销活动'
                      ELSE
                       '目标任务'
                    END,
                    sm.statis_dim,
                    sm.data_blng,
                    sm.cust_id,
                    sm.persn_legal_bk_code,
                    v_sysdat,
                    v_sysdat
      FROM scope_member sm
     WHERE NOT EXISTS
     (SELECT 1
              FROM ADS_STAT_INDX_BASELINE_MEMBER x
             WHERE x.statis_calib = CASE
                     WHEN sm.path_code = 'A' THEN
                      '营销活动'
                     ELSE
                      '目标任务'
                   END
               AND x.statis_dim = sm.statis_dim
               AND x.data_blng = sm.data_blng
               AND x.cust_id = sm.cust_id
               AND x.persn_legal_bk_code = sm.persn_legal_bk_code);

  -- 3.2 冻结客户状态明细表（ADS_STAT_INDX_BASELINE_DTL）
  INSERT INTO ADS_STAT_INDX_BASELINE_DTL
    (statis_calib,
     statis_dim,
     indx_code,
     data_blng,
     cust_id,
     persn_legal_bk_code,
     base_data_date,
     base_run_date,
     base_cust_lvl,
     base_mth_avg_aum)
    SELECT CASE
             WHEN s.path_code = 'A' THEN
              '营销活动'
             ELSE
              '目标任务'
           END,
           s.statis_dim,
           s.indx_code,
           s.data_blng,
           m.cust_id,
           m.persn_legal_bk_code,
           m.base_data_date,
           m.base_run_date,
           CASE
             WHEN s.indx_code IN ('INDX_0052', 'INDX_0053', 'INDX_0054') THEN
              lv.cust_lvl
           END,
           CASE
             WHEN s.indx_code = 'INDX_0063' THEN
              b.aum_bal
           END
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m
        ON m.statis_calib = CASE
             WHEN s.path_code = 'A' THEN
              '营销活动'
             ELSE
              '目标任务'
           END
       AND m.statis_dim = s.statis_dim
       AND m.data_blng = s.data_blng
       AND m.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWS_CUST_LVL_INFO lv
        ON lv.cust_id = m.cust_id
       AND lv.persn_legal_bk_code = m.persn_legal_bk_code
       AND lv.data_date = v_sysdat
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id = m.cust_id
       AND b.persn_legal_bk_code = m.persn_legal_bk_code
       AND b.data_date = v_sysdat
       AND b.bal_type = '2'
     WHERE s.term_begin_date = V_NEXT_DAY
       AND s.indx_code IN
           ('INDX_0052', 'INDX_0053', 'INDX_0054', 'INDX_0063')
       AND (s.indx_code NOT IN ('INDX_0052', 'INDX_0053', 'INDX_0054') OR
           lv.cust_id IS NOT NULL)
       AND (s.indx_code <> 'INDX_0063' OR b.cust_id IS NOT NULL)
       AND NOT EXISTS
     (SELECT 1
              FROM ADS_STAT_INDX_BASELINE_DTL d
             WHERE d.statis_calib = CASE
                     WHEN s.path_code = 'A' THEN
                      '营销活动'
                     ELSE
                      '目标任务'
                   END
               AND d.statis_dim = s.statis_dim
               AND d.indx_code = s.indx_code
               AND d.data_blng = s.data_blng
               AND d.cust_id = m.cust_id
               AND d.persn_legal_bk_code = m.persn_legal_bk_code);

  V_BASELINE_DTL_COUNT := SQL%ROWCOUNT;

  -- 3.3 汇总生成维度级金额基准表（ADS_STAT_INDX_BASELINE_SUM）
  INSERT INTO ADS_STAT_INDX_BASELINE_SUM
    (statis_calib,
     statis_dim,
     indx_code,
     data_blng,
     persn_legal_bk_code,
     base_data_date,
     base_run_date,
     base_loan_bal,
     base_yr_avg_fin,
     base_mth_avg_fin,
     base_yr_avg_agen_fin,
     base_mth_avg_agen_fin)
    SELECT CASE
             WHEN s.path_code = 'A' THEN
              '营销活动'
             ELSE
              '目标任务'
           END,
           s.statis_dim,
           s.indx_code,
           s.data_blng,
           s.persn_legal_bk_code,
           MAX(m.base_data_date),
           v_sysdat,
           SUM(CASE
                 WHEN b.bal_type = '1' THEN
                  NVL(b.loan_bal, 0)
                 ELSE
                  0
               END),
           SUM(CASE
                 WHEN b.bal_type = '4' THEN
                  NVL(b.fin_bal, 0)
                 ELSE
                  0
               END),
           SUM(CASE
                 WHEN b.bal_type = '2' THEN
                  NVL(b.fin_bal, 0)
                 ELSE
                  0
               END),
           SUM(CASE
                 WHEN b.bal_type = '4' THEN
                  NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0)
                 ELSE
                  0
               END),
           SUM(CASE
                 WHEN b.bal_type = '2' THEN
                  NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0)
                 ELSE
                  0
               END)
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER m
        ON m.statis_calib = CASE
             WHEN s.path_code = 'A' THEN
              '营销活动'
             ELSE
              '目标任务'
           END
       AND m.statis_dim = s.statis_dim
       AND m.data_blng = s.data_blng
       AND m.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id = m.cust_id
       AND b.persn_legal_bk_code = m.persn_legal_bk_code
       AND b.data_date = m.base_data_date
     WHERE s.term_begin_date = V_NEXT_DAY
       AND s.indx_code IN
           ('INDX_0055', 'INDX_0056', 'INDX_0058', 'INDX_0059', 'INDX_0062')
       AND NOT EXISTS
     (SELECT 1
              FROM ADS_STAT_INDX_BASELINE_SUM x
             WHERE x.statis_calib = CASE
                     WHEN s.path_code = 'A' THEN
                      '营销活动'
                     ELSE
                      '目标任务'
                   END
               AND x.statis_dim = s.statis_dim
               AND x.indx_code = s.indx_code
               AND x.data_blng = s.data_blng
               AND x.persn_legal_bk_code = s.persn_legal_bk_code)
     GROUP BY s.path_code,
              s.statis_dim,
              s.indx_code,
              s.data_blng,
              s.persn_legal_bk_code
    HAVING COUNT(DISTINCT b.cust_id) = COUNT(DISTINCT m.cust_id);

  V_ROW_COUNT := SQL%ROWCOUNT;

  -- 剔除仅用于开始日前一天冻结基准的范围数据
  DELETE FROM TMP_STAT_INDX_SCOPE s WHERE s.term_begin_date = V_NEXT_DAY;

  -- 3.4 缺失基准校验：已开始的项目必须具备基准快照
  SELECT COUNT(*)
    INTO V_MISSING_BASELINE_COUNT
    FROM TMP_STAT_INDX_SCOPE s
   WHERE s.indx_code IN ('INDX_0052',
                         'INDX_0053',
                         'INDX_0054',
                         'INDX_0055',
                         'INDX_0056',
                         'INDX_0058',
                         'INDX_0059',
                         'INDX_0062',
                         'INDX_0063')
     AND ((s.indx_code IN
         ('INDX_0052', 'INDX_0053', 'INDX_0054', 'INDX_0063') AND
         NOT EXISTS
          (SELECT 1
              FROM ADS_STAT_INDX_BASELINE_DTL d
             WHERE d.statis_calib = CASE
                     WHEN s.path_code = 'A' THEN
                      '营销活动'
                     ELSE
                      '目标任务'
                   END
               AND d.statis_dim = s.statis_dim
               AND d.indx_code = s.indx_code
               AND d.data_blng = s.data_blng
               AND d.persn_legal_bk_code = s.persn_legal_bk_code)) OR
         (s.indx_code IN
         ('INDX_0055', 'INDX_0056', 'INDX_0058', 'INDX_0059', 'INDX_0062') AND
         NOT EXISTS
          (SELECT 1
              FROM ADS_STAT_INDX_BASELINE_SUM b
             WHERE b.statis_calib = CASE
                     WHEN s.path_code = 'A' THEN
                      '营销活动'
                     ELSE
                      '目标任务'
                   END
               AND b.statis_dim = s.statis_dim
               AND b.indx_code = s.indx_code
               AND b.data_blng = s.data_blng
               AND b.persn_legal_bk_code = s.persn_legal_bk_code)));

  IF V_MISSING_BASELINE_COUNT > 0 THEN
    outcde := -1;
    RAISE_APPLICATION_ERROR(-20002,
                            '已开始活动/任务缺少开始前一天冻结的基准数据，严禁在活动期间补建基准');
  END IF;

  LOG_STEP('步骤3完成：期初客户及金额基准冻结完成，明细行数=' || NVL(V_BASELINE_DTL_COUNT, 0) ||
           '，汇总行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤4 - 余额类指标（0046-0051）预聚合与计算
  -- 业务功能：对 AUM 时点及日均余额指标进行直接聚合计算，不落地客户明细。
  -- ================================================================
  V_NO_ID    := '4';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_STAT_INDX_BAL_AGGR
    (path_code,
     statis_dim,
     data_blng,
     persn_legal_bk_code,
     curnt_aum,
     yr_begin_aum,
     mth_end_aum,
     qrt_end_aum,
     curnt_yr_avg_aum,
     prev_yr_avg_aum,
     curnt_mth_avg_aum,
     prev_mth_avg_aum)
    WITH base_scope AS
     (SELECT DISTINCT path_code,
                      statis_dim,
                      data_blng,
                      blng_type,
                      blng_id,
                      persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE
       WHERE indx_code IN ('INDX_0046',
                           'INDX_0047',
                           'INDX_0048',
                           'INDX_0049',
                           'INDX_0050',
                           'INDX_0051')),
    scope_member AS
     (SELECT s.path_code,
             s.statis_dim,
             s.data_blng,
             ti.cust_id,
             s.persn_legal_bk_code
        FROM base_scope s
       INNER JOIN DWD_MKT_TSK_INFO ti
          ON s.path_code = 'A'
         AND ti.mkt_act_id = s.statis_dim
         AND ti.persn_legal_bk_code = s.persn_legal_bk_code
         AND ti.data_date = v_sysdat
         AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) OR
             (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
      UNION
      SELECT s.path_code,
             s.statis_dim,
             s.data_blng,
             lv.cust_id,
             s.persn_legal_bk_code
        FROM base_scope s
       INNER JOIN DWS_CUST_LVL_INFO lv
          ON s.path_code = 'B'
         AND s.blng_type = 'O'
         AND lv.org_id = s.blng_id
         AND lv.persn_legal_bk_code = s.persn_legal_bk_code
         AND lv.data_date = v_sysdat
      UNION
      SELECT s.path_code,
             s.statis_dim,
             s.data_blng,
             cm.cust_id,
             s.persn_legal_bk_code
        FROM base_scope s
       INNER JOIN DWD_CUST_MAN cm
          ON s.path_code = 'B'
         AND s.blng_type = 'M'
         AND cm.mngr_post_id = s.blng_id
         AND cm.mng_typ = '1'
         AND cm.persn_legal_bk_code = s.persn_legal_bk_code)
    SELECT sm.path_code,
           sm.statis_dim,
           sm.data_blng,
           sm.persn_legal_bk_code,
           SUM(CASE
                 WHEN b.data_date = v_sysdat AND b.bal_type = '1' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 当前 AUM 时点余额
           SUM(CASE
                 WHEN b.data_date = V_YAR_BEGIN AND b.bal_type = '1' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 年初 AUM 时点余额
           SUM(CASE
                 WHEN b.data_date = V_MTH_END AND b.bal_type = '1' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 上月结 AUM 时点余额
           SUM(CASE
                 WHEN b.data_date = V_QRT_END AND b.bal_type = '1' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 上季结 AUM 时点余额
           SUM(CASE
                 WHEN b.data_date = v_sysdat AND b.bal_type = '4' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 当年 AUM 年日均
           SUM(CASE
                 WHEN b.data_date = V_YAR_PREV_END AND b.bal_type = '4' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 上年 AUM 年日均
           SUM(CASE
                 WHEN b.data_date = v_sysdat AND b.bal_type = '2' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END), -- 当月 AUM 月日均
           SUM(CASE
                 WHEN b.data_date = V_MTH_END AND b.bal_type = '2' THEN
                  NVL(b.aum_bal, 0)
                 ELSE
                  0
               END) -- 上月 AUM 月日均
      FROM scope_member sm
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id = sm.cust_id
       AND b.persn_legal_bk_code = sm.persn_legal_bk_code
       AND b.data_date IN
           (v_sysdat, V_YAR_BEGIN, V_MTH_END, V_QRT_END, V_YAR_PREV_END)
     GROUP BY sm.path_code,
              sm.statis_dim,
              sm.data_blng,
              sm.persn_legal_bk_code;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤4完成：AUM余额预聚合计算完成，处理行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤4B - 标准期间与存款基数增量指标结果写入
  -- 业务功能：计算 0046-0051 增量及 0047 存款基数扣减指标，写入 AGGR_A / AGGR_B。
  -- ================================================================
  V_NO_ID    := '4B';
  V_BGN_DATE := SYSDATE;

  -- 营销活动路径（A）写入
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'A',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '营销活动',
           s.indx_code,
           CASE s.indx_code
             WHEN 'INDX_0046' THEN
              b.curnt_aum - b.yr_begin_aum
             WHEN 'INDX_0048' THEN
              b.curnt_aum - b.mth_end_aum
             WHEN 'INDX_0049' THEN
              b.curnt_aum - b.qrt_end_aum
             WHEN 'INDX_0050' THEN
              b.curnt_yr_avg_aum - b.prev_yr_avg_aum
             WHEN 'INDX_0051' THEN
              b.curnt_mth_avg_aum - b.prev_mth_avg_aum
           END,
           CASE s.indx_code
             WHEN 'INDX_0046' THEN
              b.yr_begin_aum
             WHEN 'INDX_0048' THEN
              b.mth_end_aum
             WHEN 'INDX_0049' THEN
              b.qrt_end_aum
             WHEN 'INDX_0050' THEN
              b.prev_yr_avg_aum
             WHEN 'INDX_0051' THEN
              b.prev_mth_avg_aum
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code = 'A'
       AND b.statis_dim = s.statis_dim
       AND b.data_blng = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
     WHERE s.path_code = 'A'
       AND s.indx_code IN
           ('INDX_0046', 'INDX_0048', 'INDX_0049', 'INDX_0050', 'INDX_0051');

  -- 目标任务路径（B）写入
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'B',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '目标任务',
           s.indx_code,
           CASE s.indx_code
             WHEN 'INDX_0046' THEN
              b.curnt_aum - b.yr_begin_aum
             WHEN 'INDX_0048' THEN
              b.curnt_aum - b.mth_end_aum
             WHEN 'INDX_0049' THEN
              b.curnt_aum - b.qrt_end_aum
             WHEN 'INDX_0050' THEN
              b.curnt_yr_avg_aum - b.prev_yr_avg_aum
             WHEN 'INDX_0051' THEN
              b.curnt_mth_avg_aum - b.prev_mth_avg_aum
           END,
           CASE s.indx_code
             WHEN 'INDX_0046' THEN
              b.yr_begin_aum
             WHEN 'INDX_0048' THEN
              b.mth_end_aum
             WHEN 'INDX_0049' THEN
              b.qrt_end_aum
             WHEN 'INDX_0050' THEN
              b.prev_yr_avg_aum
             WHEN 'INDX_0051' THEN
              b.prev_mth_avg_aum
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code = 'B'
       AND b.statis_dim = s.statis_dim
       AND b.data_blng = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
     WHERE s.path_code = 'B'
       AND s.indx_code IN
           ('INDX_0046', 'INDX_0048', 'INDX_0049', 'INDX_0050', 'INDX_0051');

  -- INDX_0047 存款基数扣减指标写入（A / B 路径）
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'A',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '营销活动',
           'INDX_0047',
           b.curnt_aum - SUM(NVL(v.value_init, 0)),
           SUM(NVL(v.value_init, 0)),
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code = 'A'
       AND b.statis_dim = s.statis_dim
       AND b.data_blng = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN crm_sys_post p
        ON s.blng_type = 'M'
       AND p.post_id = s.blng_id
       AND p.job_cls = 'C'
      LEFT JOIN DEPO_VALUE_INIT v
        ON v.org_id = CASE
             WHEN s.blng_type = 'O' THEN
              s.blng_id
             ELSE
              p.org_id
           END
       AND v.persn_legal_bk_code = s.persn_legal_bk_code
       AND (s.blng_type = 'O' OR v.mngr_post_id = s.blng_id)
     WHERE s.path_code = 'A'
       AND s.indx_code = 'INDX_0047'
     GROUP BY s.data_blng, s.statis_dim, b.curnt_aum, s.persn_legal_bk_code;

  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'B',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '目标任务',
           'INDX_0047',
           b.curnt_aum - SUM(NVL(v.value_init, 0)),
           SUM(NVL(v.value_init, 0)),
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN TMP_STAT_INDX_BAL_AGGR b
        ON b.path_code = 'B'
       AND b.statis_dim = s.statis_dim
       AND b.data_blng = s.data_blng
       AND b.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN crm_sys_post p
        ON s.blng_type = 'M'
       AND p.post_id = s.blng_id
       AND p.job_cls = 'C'
      LEFT JOIN DEPO_VALUE_INIT v
        ON v.org_id = CASE
             WHEN s.blng_type = 'O' THEN
              s.blng_id
             ELSE
              p.org_id
           END
       AND v.persn_legal_bk_code = s.persn_legal_bk_code
       AND (s.blng_type = 'O' OR v.mngr_post_id = s.blng_id)
     WHERE s.path_code = 'B'
       AND s.indx_code = 'INDX_0047'
     GROUP BY s.data_blng, s.statis_dim, b.curnt_aum, s.persn_legal_bk_code;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤4B完成：标准期间及存款基数指标写入完毕，处理行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤5 - 冻结范围下的细分金融产品增量指标计算
  -- 业务功能：计算理财年日均/月日均（0055, 0056）、代销理财（0058, 0059）、
  --           贷款余额（0062）基于期初冻结基准（BASELINE_SUM）的增量。
  -- ================================================================
  V_NO_ID    := '5';
  V_BGN_DATE := SYSDATE;

  -- 营销活动路径（A）产品增量计算
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'A',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '营销活动',
           s.indx_code,
           CASE s.indx_code
             WHEN 'INDX_0055' THEN
              SUM(CASE
                    WHEN b.bal_type = '4' THEN
                     NVL(b.fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_yr_avg_fin)
             WHEN 'INDX_0056' THEN
              SUM(CASE
                    WHEN b.bal_type = '2' THEN
                     NVL(b.fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_mth_avg_fin)
             WHEN 'INDX_0058' THEN
              SUM(CASE
                    WHEN b.bal_type = '4' THEN
                     NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_yr_avg_agen_fin)
             WHEN 'INDX_0059' THEN
              SUM(CASE
                    WHEN b.bal_type = '2' THEN
                     NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_mth_avg_agen_fin)
             WHEN 'INDX_0062' THEN
              SUM(CASE
                    WHEN b.bal_type = '1' THEN
                     NVL(b.loan_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_loan_bal)
           END,
           CASE s.indx_code
             WHEN 'INDX_0055' THEN
              MAX(bs.base_yr_avg_fin)
             WHEN 'INDX_0056' THEN
              MAX(bs.base_mth_avg_fin)
             WHEN 'INDX_0058' THEN
              MAX(bs.base_yr_avg_agen_fin)
             WHEN 'INDX_0059' THEN
              MAX(bs.base_mth_avg_agen_fin)
             WHEN 'INDX_0062' THEN
              MAX(bs.base_loan_bal)
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER d
        ON d.statis_calib = '营销活动'
       AND d.statis_dim = s.statis_dim
       AND d.data_blng = s.data_blng
       AND d.persn_legal_bk_code = s.persn_legal_bk_code
     INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs
        ON bs.statis_calib = '营销活动'
       AND bs.statis_dim = s.statis_dim
       AND bs.indx_code = s.indx_code
       AND bs.data_blng = s.data_blng
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
       AND b.data_date = v_sysdat
     WHERE s.path_code = 'A'
       AND s.indx_code IN
           ('INDX_0055', 'INDX_0056', 'INDX_0058', 'INDX_0059', 'INDX_0062')
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

  -- 目标任务路径（B）产品增量计算
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'B',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '目标任务',
           s.indx_code,
           CASE s.indx_code
             WHEN 'INDX_0055' THEN
              SUM(CASE
                    WHEN b.bal_type = '4' THEN
                     NVL(b.fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_yr_avg_fin)
             WHEN 'INDX_0056' THEN
              SUM(CASE
                    WHEN b.bal_type = '2' THEN
                     NVL(b.fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_mth_avg_fin)
             WHEN 'INDX_0058' THEN
              SUM(CASE
                    WHEN b.bal_type = '4' THEN
                     NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_yr_avg_agen_fin)
             WHEN 'INDX_0059' THEN
              SUM(CASE
                    WHEN b.bal_type = '2' THEN
                     NVL(b.close_agen_fin_bal, 0) + NVL(b.open_agen_fin_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_mth_avg_agen_fin)
             WHEN 'INDX_0062' THEN
              SUM(CASE
                    WHEN b.bal_type = '1' THEN
                     NVL(b.loan_bal, 0)
                    ELSE
                     0
                  END) - MAX(bs.base_loan_bal)
           END,
           CASE s.indx_code
             WHEN 'INDX_0055' THEN
              MAX(bs.base_yr_avg_fin)
             WHEN 'INDX_0056' THEN
              MAX(bs.base_mth_avg_fin)
             WHEN 'INDX_0058' THEN
              MAX(bs.base_yr_avg_agen_fin)
             WHEN 'INDX_0059' THEN
              MAX(bs.base_mth_avg_agen_fin)
             WHEN 'INDX_0062' THEN
              MAX(bs.base_loan_bal)
           END,
           s.persn_legal_bk_code
      FROM TMP_STAT_INDX_SCOPE s
     INNER JOIN ADS_STAT_INDX_BASELINE_MEMBER d
        ON d.statis_calib = '目标任务'
       AND d.statis_dim = s.statis_dim
       AND d.data_blng = s.data_blng
       AND d.persn_legal_bk_code = s.persn_legal_bk_code
     INNER JOIN ADS_STAT_INDX_BASELINE_SUM bs
        ON bs.statis_calib = '目标任务'
       AND bs.statis_dim = s.statis_dim
       AND bs.indx_code = s.indx_code
       AND bs.data_blng = s.data_blng
       AND bs.persn_legal_bk_code = s.persn_legal_bk_code
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
       AND b.data_date = v_sysdat
     WHERE s.path_code = 'B'
       AND s.indx_code IN
           ('INDX_0055', 'INDX_0056', 'INDX_0058', 'INDX_0059', 'INDX_0062')
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤5完成：专有金融产品余额及日均增量计算完毕，处理行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤6 - 客户状态提升与临界客户提升户数指标计算
  -- 业务功能：根据期初基准等级与当前等级计算等级提升客户户数（0052, 0053, 0054），
  --           以及 AUM 临界点提升客户户数（0063）。
  -- ================================================================
  V_NO_ID    := '6';
  V_BGN_DATE := SYSDATE;

  -- 6.1 提取符合提升条件与临界范围的客户明细至 TMP_STAT_INDX_CUST_STATE
  INSERT INTO TMP_STAT_INDX_CUST_STATE
    (path_code,
     statis_dim,
     indx_code,
     data_blng,
     cust_id,
     persn_legal_bk_code,
     base_cust_lvl,
     curnt_cust_lvl,
     base_mth_avg_aum,
     curnt_mth_avg_aum)
    SELECT CASE
             WHEN d.statis_calib = '营销活动' THEN
              'A'
             ELSE
              'B'
           END,
           d.statis_dim,
           d.indx_code,
           d.data_blng,
           d.cust_id,
           d.persn_legal_bk_code,
           d.base_cust_lvl,
           lv.cust_lvl,
           d.base_mth_avg_aum,
           NVL(b.aum_bal, 0)
      FROM ADS_STAT_INDX_BASELINE_DTL d
      LEFT JOIN DWS_CUST_LVL_INFO lv
        ON lv.cust_id = d.cust_id
       AND lv.persn_legal_bk_code = d.persn_legal_bk_code
       AND lv.data_date = v_sysdat
      LEFT JOIN DWS_CUST_ASSE_LIAB b
        ON b.cust_id = d.cust_id
       AND b.persn_legal_bk_code = d.persn_legal_bk_code
       AND b.data_date = v_sysdat
       AND b.bal_type = '2'
     WHERE d.indx_code IN
           ('INDX_0052', 'INDX_0053', 'INDX_0054', 'INDX_0063')
       AND ((d.indx_code = 'INDX_0052' AND
           TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 4 AND
           TO_NUMBER(NVL(lv.cust_lvl, '0')) >= 4) OR
           (d.indx_code = 'INDX_0053' AND
           TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 6 AND
           TO_NUMBER(NVL(lv.cust_lvl, '0')) >= 6) OR
           (d.indx_code = 'INDX_0054' AND
           TO_NUMBER(NVL(d.base_cust_lvl, '0')) < 7 AND
           TO_NUMBER(NVL(lv.cust_lvl, '0')) >= 7) OR
           (d.indx_code = 'INDX_0063' AND b.cust_id IS NOT NULL AND
           ((b.aum_bal >= 45000 AND b.aum_bal < 50000) OR
           (b.aum_bal >= 270000 AND b.aum_bal < 300000) OR
           (b.aum_bal >= 450000 AND b.aum_bal < 500000) OR
           (b.aum_bal >= 900000 AND b.aum_bal < 1000000) OR
           (b.aum_bal >= 2700000 AND b.aum_bal < 3000000) OR
           (d.base_mth_avg_aum >= 45000 AND d.base_mth_avg_aum < 50000) OR
           (d.base_mth_avg_aum >= 270000 AND d.base_mth_avg_aum < 300000) OR
           (d.base_mth_avg_aum >= 450000 AND d.base_mth_avg_aum < 500000) OR
           (d.base_mth_avg_aum >= 900000 AND
           d.base_mth_avg_aum < 1000000) OR
           (d.base_mth_avg_aum >= 2700000 AND
           d.base_mth_avg_aum < 3000000))));

  -- 6.2 汇总户数并写入 AGGR_A
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'A',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '营销活动',
           s.indx_code,
           CASE s.indx_code
             WHEN 'INDX_0052' THEN
              COUNT(c.cust_id)
             WHEN 'INDX_0053' THEN
              COUNT(c.cust_id)
             WHEN 'INDX_0054' THEN
              COUNT(c.cust_id)
             WHEN 'INDX_0063' THEN
              SUM(CASE
                    WHEN (c.curnt_mth_avg_aum >= 45000 AND
                         c.curnt_mth_avg_aum < 50000) OR
                         (c.curnt_mth_avg_aum >= 270000 AND
                         c.curnt_mth_avg_aum < 300000) OR
                         (c.curnt_mth_avg_aum >= 450000 AND
                         c.curnt_mth_avg_aum < 500000) OR
                         (c.curnt_mth_avg_aum >= 900000 AND
                         c.curnt_mth_avg_aum < 1000000) OR
                         (c.curnt_mth_avg_aum >= 2700000 AND
                         c.curnt_mth_avg_aum < 3000000) THEN
                     1
                    ELSE
                     0
                  END) - SUM(CASE
                               WHEN (c.base_mth_avg_aum >= 45000 AND
                                    c.base_mth_avg_aum < 50000) OR
                                    (c.base_mth_avg_aum >= 270000 AND
                                    c.base_mth_avg_aum < 300000) OR
                                    (c.base_mth_avg_aum >= 450000 AND
                                    c.base_mth_avg_aum < 500000) OR
                                    (c.base_mth_avg_aum >= 900000 AND
                                    c.base_mth_avg_aum < 1000000) OR
                                    (c.base_mth_avg_aum >= 2700000 AND
                                    c.base_mth_avg_aum < 3000000) THEN
                                1
                               ELSE
                                0
                             END)
           END,
           CASE
             WHEN s.indx_code = 'INDX_0063' THEN
              SUM(CASE
                    WHEN (c.base_mth_avg_aum >= 45000 AND
                         c.base_mth_avg_aum < 50000) OR
                         (c.base_mth_avg_aum >= 270000 AND
                         c.base_mth_avg_aum < 300000) OR
                         (c.base_mth_avg_aum >= 450000 AND
                         c.base_mth_avg_aum < 500000) OR
                         (c.base_mth_avg_aum >= 900000 AND
                         c.base_mth_avg_aum < 1000000) OR
                         (c.base_mth_avg_aum >= 2700000 AND
                         c.base_mth_avg_aum < 3000000) THEN
                     1
                    ELSE
                     0
                  END)
             ELSE
              0
           END,
           s.persn_legal_bk_code
      FROM (SELECT DISTINCT path_code,
                            statis_dim,
                            indx_code,
                            data_blng,
                            persn_legal_bk_code
              FROM TMP_STAT_INDX_SCOPE
             WHERE path_code = 'A'
               AND indx_code IN
                   ('INDX_0052', 'INDX_0053', 'INDX_0054', 'INDX_0063')) s
      LEFT JOIN TMP_STAT_INDX_CUST_STATE c
        ON c.path_code = s.path_code
       AND c.statis_dim = s.statis_dim
       AND c.indx_code = s.indx_code
       AND c.data_blng = s.data_blng
       AND c.persn_legal_bk_code = s.persn_legal_bk_code
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

  -- 6.3 汇总户数并写入 AGGR_B
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    SELECT 'B',
           v_sysdat,
           s.data_blng,
           s.statis_dim,
           '目标任务',
           s.indx_code,
           CASE s.indx_code
             WHEN 'INDX_0052' THEN
              COUNT(c.cust_id)
             WHEN 'INDX_0053' THEN
              COUNT(c.cust_id)
             WHEN 'INDX_0054' THEN
              COUNT(c.cust_id)
             WHEN 'INDX_0063' THEN
              SUM(CASE
                    WHEN (c.curnt_mth_avg_aum >= 45000 AND
                         c.curnt_mth_avg_aum < 50000) OR
                         (c.curnt_mth_avg_aum >= 270000 AND
                         c.curnt_mth_avg_aum < 300000) OR
                         (c.curnt_mth_avg_aum >= 450000 AND
                         c.curnt_mth_avg_aum < 500000) OR
                         (c.curnt_mth_avg_aum >= 900000 AND
                         c.curnt_mth_avg_aum < 1000000) OR
                         (c.curnt_mth_avg_aum >= 2700000 AND
                         c.curnt_mth_avg_aum < 3000000) THEN
                     1
                    ELSE
                     0
                  END) - SUM(CASE
                               WHEN (c.base_mth_avg_aum >= 45000 AND
                                    c.base_mth_avg_aum < 50000) OR
                                    (c.base_mth_avg_aum >= 270000 AND
                                    c.base_mth_avg_aum < 300000) OR
                                    (c.base_mth_avg_aum >= 450000 AND
                                    c.base_mth_avg_aum < 500000) OR
                                    (c.base_mth_avg_aum >= 900000 AND
                                    c.base_mth_avg_aum < 1000000) OR
                                    (c.base_mth_avg_aum >= 2700000 AND
                                    c.base_mth_avg_aum < 3000000) THEN
                                1
                               ELSE
                                0
                             END)
           END,
           CASE
             WHEN s.indx_code = 'INDX_0063' THEN
              SUM(CASE
                    WHEN (c.base_mth_avg_aum >= 45000 AND
                         c.base_mth_avg_aum < 50000) OR
                         (c.base_mth_avg_aum >= 270000 AND
                         c.base_mth_avg_aum < 300000) OR
                         (c.base_mth_avg_aum >= 450000 AND
                         c.base_mth_avg_aum < 500000) OR
                         (c.base_mth_avg_aum >= 900000 AND
                         c.base_mth_avg_aum < 1000000) OR
                         (c.base_mth_avg_aum >= 2700000 AND
                         c.base_mth_avg_aum < 3000000) THEN
                     1
                    ELSE
                     0
                  END)
             ELSE
              0
           END,
           s.persn_legal_bk_code
      FROM (SELECT DISTINCT path_code,
                            statis_dim,
                            indx_code,
                            data_blng,
                            persn_legal_bk_code
              FROM TMP_STAT_INDX_SCOPE
             WHERE path_code = 'B'
               AND indx_code IN
                   ('INDX_0052', 'INDX_0053', 'INDX_0054', 'INDX_0063')) s
      LEFT JOIN TMP_STAT_INDX_CUST_STATE c
        ON c.path_code = s.path_code
       AND c.statis_dim = s.statis_dim
       AND c.indx_code = s.indx_code
       AND c.data_blng = s.data_blng
       AND c.persn_legal_bk_code = s.persn_legal_bk_code
     GROUP BY s.data_blng, s.statis_dim, s.indx_code, s.persn_legal_bk_code;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤6完成：客户等级提升及临界提升户数计算完毕，处理行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤6B - 业务事件与行为去重计数指标聚合
  -- 业务功能：计算新增保险保费（0061）与手机银行月度登录活跃客户数（0067）。
  -- ================================================================
  V_NO_ID    := '6B';
  V_BGN_DATE := SYSDATE;

  -- 6B.1 保险新保保费（INDX_0061）：营销活动路径（A）
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_member AS
     (SELECT s.statis_dim,
             s.data_blng,
             s.term_begin_date,
             ti.cust_id,
             s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_MKT_TSK_INFO ti
          ON ti.mkt_act_id = s.statis_dim
         AND ti.persn_legal_bk_code = s.persn_legal_bk_code
         AND ti.data_date = v_sysdat
         AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) OR
             (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
       WHERE s.path_code = 'A'
         AND s.indx_code = 'INDX_0061')
    SELECT 'A',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '营销活动',
           'INDX_0061',
           SUM(NVL(i.new_insur_amt, 0)),
           0,
           sm.persn_legal_bk_code
      FROM (SELECT DISTINCT statis_dim,
                            data_blng,
                            term_begin_date,
                            cust_id,
                            persn_legal_bk_code
              FROM scope_member) sm
     INNER JOIN DWD_ACCT_INSUR i
        ON i.cust_id = sm.cust_id
       AND i.persn_legal_bk_code = sm.persn_legal_bk_code
       AND i.policy_state = '1'
       AND i.tx_date >= sm.term_begin_date
       AND i.tx_date <= v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

  -- 6B.2 保险新保保费（INDX_0061）：目标任务路径（B）
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_member AS
     (SELECT s.statis_dim,
             s.data_blng,
             s.term_begin_date,
             lv.cust_id,
             s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWS_CUST_LVL_INFO lv
          ON s.blng_type = 'O'
         AND lv.org_id = s.blng_id
         AND lv.persn_legal_bk_code = s.persn_legal_bk_code
         AND lv.data_date = v_sysdat
       WHERE s.path_code = 'B'
         AND s.indx_code = 'INDX_0061'
      UNION
      SELECT s.statis_dim,
             s.data_blng,
             s.term_begin_date,
             cm.cust_id,
             s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_CUST_MAN cm
          ON s.blng_type = 'M'
         AND cm.mngr_post_id = s.blng_id
         AND cm.mng_typ = '1'
         AND cm.persn_legal_bk_code = s.persn_legal_bk_code
       WHERE s.path_code = 'B'
         AND s.indx_code = 'INDX_0061')
    SELECT 'B',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '目标任务',
           'INDX_0061',
           SUM(NVL(i.new_insur_amt, 0)),
           0,
           sm.persn_legal_bk_code
      FROM (SELECT DISTINCT statis_dim,
                            data_blng,
                            term_begin_date,
                            cust_id,
                            persn_legal_bk_code
              FROM scope_member) sm
     INNER JOIN DWD_ACCT_INSUR i
        ON i.cust_id = sm.cust_id
       AND i.persn_legal_bk_code = sm.persn_legal_bk_code
       AND i.policy_state = '1'
       AND i.tx_date >= sm.term_begin_date
       AND i.tx_date <= v_sysdat
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

  -- 6B.3 手机银行月活客户数（INDX_0067）：营销活动路径（A）
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_member AS
     (SELECT s.statis_dim, s.data_blng, ti.cust_id, s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_MKT_TSK_INFO ti
          ON ti.mkt_act_id = s.statis_dim
         AND ti.persn_legal_bk_code = s.persn_legal_bk_code
         AND ti.data_date = v_sysdat
         AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) OR
             (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
       WHERE s.path_code = 'A'
         AND s.indx_code = 'INDX_0067')
    SELECT 'A',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '营销活动',
           'INDX_0067',
           COUNT(DISTINCT mi.cust_core_no),
           0,
           sm.persn_legal_bk_code
      FROM scope_member sm
     INNER JOIN mbk_cust_info mi
        ON mi.cust_core_no = sm.cust_id
       AND mi.cust_status = '1'
     INNER JOIN mbk_cust_log_login l
        ON l.cust_no = mi.cust_no
       AND l.lgn_status = '1'
     WHERE l.lgn_date >=
           SUBSTR(V_MTH_BEGIN, 1, 4) || '-' || SUBSTR(V_MTH_BEGIN, 5, 2) || '-' ||
           SUBSTR(V_MTH_BEGIN, 7, 2)
       AND l.lgn_date <=
           SUBSTR(v_sysdat, 1, 4) || '-' || SUBSTR(v_sysdat, 5, 2) || '-' ||
           SUBSTR(v_sysdat, 7, 2)
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

  -- 6B.4 手机银行月活客户数（INDX_0067）：目标任务路径（B）
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_member AS
     (SELECT s.statis_dim, s.data_blng, lv.cust_id, s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWS_CUST_LVL_INFO lv
          ON s.blng_type = 'O'
         AND lv.org_id = s.blng_id
         AND lv.persn_legal_bk_code = s.persn_legal_bk_code
         AND lv.data_date = v_sysdat
       WHERE s.path_code = 'B'
         AND s.indx_code = 'INDX_0067'
      UNION
      SELECT s.statis_dim, s.data_blng, cm.cust_id, s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_CUST_MAN cm
          ON s.blng_type = 'M'
         AND cm.mngr_post_id = s.blng_id
         AND cm.mng_typ = '1'
         AND cm.persn_legal_bk_code = s.persn_legal_bk_code
       WHERE s.path_code = 'B'
         AND s.indx_code = 'INDX_0067')
    SELECT 'B',
           v_sysdat,
           sm.data_blng,
           sm.statis_dim,
           '目标任务',
           'INDX_0067',
           COUNT(DISTINCT mi.cust_core_no),
           0,
           sm.persn_legal_bk_code
      FROM scope_member sm
     INNER JOIN mbk_cust_info mi
        ON mi.cust_core_no = sm.cust_id
       AND mi.cust_status = '1'
     INNER JOIN mbk_cust_log_login l
        ON l.cust_no = mi.cust_no
       AND l.lgn_status = '1'
     WHERE l.lgn_date >=
           SUBSTR(V_MTH_BEGIN, 1, 4) || '-' || SUBSTR(V_MTH_BEGIN, 5, 2) || '-' ||
           SUBSTR(V_MTH_BEGIN, 7, 2)
       AND l.lgn_date <=
           SUBSTR(v_sysdat, 1, 4) || '-' || SUBSTR(v_sysdat, 5, 2) || '-' ||
           SUBSTR(v_sysdat, 7, 2)
     GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤6B完成：保险新保及手机银行月活指标聚合完成，处理行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤6C - 固定口径拓展指标计算（0080~0083）
  -- 业务功能：按经确认的静态口径计算新客交叉销售（0080）、聚合支付 AUM 留存率（0081）、
  --           新增客户数（0082）及借记卡新发卡量（0083）。
  -- ================================================================
  V_NO_ID    := '6C';
  V_BGN_DATE := SYSDATE;

  -- 6C.1 营销活动路径（A）：INDX_0080 / 0082 / 0083 计算
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_member AS
     (SELECT DISTINCT s.statis_dim,
                      s.data_blng,
                      s.term_begin_date,
                      ti.cust_id,
                      s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_MKT_TSK_INFO ti
          ON ti.mkt_act_id = s.statis_dim
         AND ti.persn_legal_bk_code = s.persn_legal_bk_code
         AND ti.data_date = v_sysdat
         AND ((s.blng_type = 'O' AND ti.mkt_persn_org = s.blng_id) OR
             (s.blng_type = 'M' AND ti.mkt_persn = s.blng_id))
       WHERE s.path_code = 'A'
         AND s.indx_code IN ('INDX_0080', 'INDX_0082', 'INDX_0083')),
    cust_flags AS
     (SELECT sm.statis_dim,
             sm.data_blng,
             sm.term_begin_date,
             sm.cust_id,
             sm.persn_legal_bk_code,
             ci.open_date,
             MAX(CASE
                   WHEN mi.cust_no IS NOT NULL THEN
                    1
                   ELSE
                    0
                 END) AS has_mbk,
             -- 来源：原指标参数初始化值 INDX_0080/DEPO_THRESHOLD=100；已确认固化口径。
             MAX(CASE
                   WHEN NVL(b.depo_curnt_depo_bal, 0) + NVL(b.fixd_depo_bal, 0) >= 100 THEN
                    1
                   ELSE
                    0
                 END) AS has_depo,
             MAX(CASE
                   WHEN NVL(b.fin_bal, 0) > 0 THEN
                    1
                   ELSE
                    0
                 END) AS has_fin,
             MAX(CASE
                   WHEN NVL(b.loan_bal, 0) > 0 THEN
                    1
                   ELSE
                    0
                 END) AS has_loan
        FROM scope_member sm
        LEFT JOIN DWD_CUST_INDV_INFO ci
          ON ci.cust_id = sm.cust_id
        LEFT JOIN mbk_cust_info mi
          ON mi.cust_core_no = sm.cust_id
         AND mi.cust_status = '1'
        LEFT JOIN DWS_CUST_ASSE_LIAB b
          ON b.cust_id = sm.cust_id
         AND b.persn_legal_bk_code = sm.persn_legal_bk_code
         AND b.data_date = v_sysdat
         AND b.bal_type = '1'
       GROUP BY sm.statis_dim,
                sm.data_blng,
                sm.term_begin_date,
                sm.cust_id,
                sm.persn_legal_bk_code,
                ci.open_date),
    cust_result AS
     (SELECT 'A' AS path_code,
             v_sysdat AS data_date,
             data_blng,
             statis_dim,
             '营销活动' AS statis_calib,
             'INDX_0080' AS indx_code,
             COUNT(DISTINCT CASE
                     WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$') THEN
                             open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
                             REPLACE(open_date, '-', '')
                          END BETWEEN V_180_DAY_BEGIN AND v_sysdat
                         -- 来源：原指标参数初始化值 INDX_0080/MIN_PRODUCT_COUNT=2；已确认固化口径。
                          AND has_mbk + has_depo + has_fin + has_loan >= 2 THEN
                      cust_id
                   END) AS curnt_val,
             0 AS term_last_val,
             persn_legal_bk_code
        FROM cust_flags
       WHERE EXISTS
       (SELECT 1
                FROM TMP_STAT_INDX_SCOPE s
               WHERE s.path_code = 'A'
                 AND s.statis_dim = cust_flags.statis_dim
                 AND s.data_blng = cust_flags.data_blng
                 AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                 AND s.indx_code = 'INDX_0080')
       GROUP BY data_blng, statis_dim, persn_legal_bk_code
      UNION ALL
      SELECT 'A',
             v_sysdat,
             data_blng,
             statis_dim,
             '营销活动',
             'INDX_0082',
             COUNT(DISTINCT CASE
                     WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$') THEN
                             open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
                             REPLACE(open_date, '-', '')
                          END BETWEEN term_begin_date AND v_sysdat THEN
                      cust_id
                   END),
             0,
             persn_legal_bk_code
        FROM cust_flags
       WHERE EXISTS
       (SELECT 1
                FROM TMP_STAT_INDX_SCOPE s
               WHERE s.path_code = 'A'
                 AND s.statis_dim = cust_flags.statis_dim
                 AND s.data_blng = cust_flags.data_blng
                 AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                 AND s.indx_code = 'INDX_0082')
       GROUP BY data_blng, statis_dim, persn_legal_bk_code),
    debit_card_result AS
     (SELECT 'A' AS path_code,
             v_sysdat AS data_date,
             sm.data_blng,
             sm.statis_dim,
             '营销活动' AS statis_calib,
             'INDX_0083' AS indx_code,
             COUNT(DISTINCT d.acct_id) AS curnt_val,
             0 AS term_last_val,
             sm.persn_legal_bk_code
        FROM scope_member sm
       INNER JOIN DWD_ACCT_DEPO d
          ON d.cust_id = sm.cust_id
         AND d.persn_legal_bk_code = sm.persn_legal_bk_code
            -- 来源：data_assets/reference_logic/MTS_OBJECT.sql，MTS.CDS_TB_CASH_ACCT_INFO.ACCT_TYPE，检索关键字 comment on column MTS.CDS_TB_CASH_ACCT_INFO.acct_type；01、02 为允许账户类型。
         AND TRIM(d.acct_typ) IN ('01', '02')
         AND d.card_no IS NOT NULL
         AND CASE
               WHEN REGEXP_LIKE(d.open_date, '^[0-9]{8}$') THEN
                d.open_date
               WHEN REGEXP_LIKE(d.open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
                REPLACE(d.open_date, '-', '')
             END BETWEEN sm.term_begin_date AND v_sysdat
       WHERE EXISTS (SELECT 1
                FROM TMP_STAT_INDX_SCOPE s
               WHERE s.path_code = 'A'
                 AND s.statis_dim = sm.statis_dim
                 AND s.data_blng = sm.data_blng
                 AND s.persn_legal_bk_code = sm.persn_legal_bk_code
                 AND s.indx_code = 'INDX_0083')
       GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code)
    SELECT path_code,
           data_date,
           data_blng,
           statis_dim,
           statis_calib,
           indx_code,
           curnt_val,
           term_last_val,
           persn_legal_bk_code
      FROM cust_result
    UNION ALL
    SELECT path_code,
           data_date,
           data_blng,
           statis_dim,
           statis_calib,
           indx_code,
           curnt_val,
           term_last_val,
           persn_legal_bk_code
      FROM debit_card_result;

  -- 6C.2 目标任务路径（B）：INDX_0080 / 0082 / 0083 计算
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_member AS
     (SELECT DISTINCT s.statis_dim,
                      s.data_blng,
                      s.term_begin_date,
                      lv.cust_id,
                      s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWS_CUST_LVL_INFO lv
          ON s.blng_type = 'O'
         AND lv.org_id = s.blng_id
         AND lv.persn_legal_bk_code = s.persn_legal_bk_code
         AND lv.data_date = v_sysdat
       WHERE s.path_code = 'B'
         AND s.indx_code IN ('INDX_0080', 'INDX_0082', 'INDX_0083')
      UNION
      SELECT DISTINCT s.statis_dim,
                      s.data_blng,
                      s.term_begin_date,
                      cm.cust_id,
                      s.persn_legal_bk_code
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN DWD_CUST_MAN cm
          ON s.blng_type = 'M'
         AND cm.mngr_post_id = s.blng_id
         AND cm.mng_typ = '1'
         AND cm.persn_legal_bk_code = s.persn_legal_bk_code
       WHERE s.path_code = 'B'
         AND s.indx_code IN ('INDX_0080', 'INDX_0082', 'INDX_0083')),
    cust_flags AS
     (SELECT sm.statis_dim,
             sm.data_blng,
             sm.term_begin_date,
             sm.cust_id,
             sm.persn_legal_bk_code,
             ci.open_date,
             MAX(CASE
                   WHEN mi.cust_no IS NOT NULL THEN
                    1
                   ELSE
                    0
                 END) AS has_mbk,
             -- 来源：原指标参数初始化值 INDX_0080/DEPO_THRESHOLD=100；已确认固化口径。
             MAX(CASE
                   WHEN NVL(b.depo_curnt_depo_bal, 0) + NVL(b.fixd_depo_bal, 0) >= 100 THEN
                    1
                   ELSE
                    0
                 END) AS has_depo,
             MAX(CASE
                   WHEN NVL(b.fin_bal, 0) > 0 THEN
                    1
                   ELSE
                    0
                 END) AS has_fin,
             MAX(CASE
                   WHEN NVL(b.loan_bal, 0) > 0 THEN
                    1
                   ELSE
                    0
                 END) AS has_loan
        FROM scope_member sm
        LEFT JOIN DWD_CUST_INDV_INFO ci
          ON ci.cust_id = sm.cust_id
        LEFT JOIN mbk_cust_info mi
          ON mi.cust_core_no = sm.cust_id
         AND mi.cust_status = '1'
        LEFT JOIN DWS_CUST_ASSE_LIAB b
          ON b.cust_id = sm.cust_id
         AND b.persn_legal_bk_code = sm.persn_legal_bk_code
         AND b.data_date = v_sysdat
         AND b.bal_type = '1'
       GROUP BY sm.statis_dim,
                sm.data_blng,
                sm.term_begin_date,
                sm.cust_id,
                sm.persn_legal_bk_code,
                ci.open_date),
    cust_result AS
     (SELECT 'B' AS path_code,
             v_sysdat AS data_date,
             data_blng,
             statis_dim,
             '目标任务' AS statis_calib,
             'INDX_0080' AS indx_code,
             COUNT(DISTINCT CASE
                     WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$') THEN
                             open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
                             REPLACE(open_date, '-', '')
                          END BETWEEN V_180_DAY_BEGIN AND v_sysdat
                         -- 来源：原指标参数初始化值 INDX_0080/MIN_PRODUCT_COUNT=2；已确认固化口径。
                          AND has_mbk + has_depo + has_fin + has_loan >= 2 THEN
                      cust_id
                   END) AS curnt_val,
             0 AS term_last_val,
             persn_legal_bk_code
        FROM cust_flags
       WHERE EXISTS
       (SELECT 1
                FROM TMP_STAT_INDX_SCOPE s
               WHERE s.path_code = 'B'
                 AND s.statis_dim = cust_flags.statis_dim
                 AND s.data_blng = cust_flags.data_blng
                 AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                 AND s.indx_code = 'INDX_0080')
       GROUP BY data_blng, statis_dim, persn_legal_bk_code
      UNION ALL
      SELECT 'B',
             v_sysdat,
             data_blng,
             statis_dim,
             '目标任务',
             'INDX_0082',
             COUNT(DISTINCT CASE
                     WHEN CASE
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{8}$') THEN
                             open_date
                            WHEN REGEXP_LIKE(open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
                             REPLACE(open_date, '-', '')
                          END BETWEEN term_begin_date AND v_sysdat THEN
                      cust_id
                   END),
             0,
             persn_legal_bk_code
        FROM cust_flags
       WHERE EXISTS
       (SELECT 1
                FROM TMP_STAT_INDX_SCOPE s
               WHERE s.path_code = 'B'
                 AND s.statis_dim = cust_flags.statis_dim
                 AND s.data_blng = cust_flags.data_blng
                 AND s.persn_legal_bk_code = cust_flags.persn_legal_bk_code
                 AND s.indx_code = 'INDX_0082')
       GROUP BY data_blng, statis_dim, persn_legal_bk_code),
    debit_card_result AS
     (SELECT 'B' AS path_code,
             v_sysdat AS data_date,
             sm.data_blng,
             sm.statis_dim,
             '目标任务' AS statis_calib,
             'INDX_0083' AS indx_code,
             COUNT(DISTINCT d.acct_id) AS curnt_val,
             0 AS term_last_val,
             sm.persn_legal_bk_code
        FROM scope_member sm
       INNER JOIN DWD_ACCT_DEPO d
          ON d.cust_id = sm.cust_id
         AND d.persn_legal_bk_code = sm.persn_legal_bk_code
            -- 来源：data_assets/reference_logic/MTS_OBJECT.sql，MTS.CDS_TB_CASH_ACCT_INFO.ACCT_TYPE，检索关键字 comment on column MTS.CDS_TB_CASH_ACCT_INFO.acct_type；01、02 为允许账户类型。
         AND TRIM(d.acct_typ) IN ('01', '02')
         AND d.card_no IS NOT NULL
         AND CASE
               WHEN REGEXP_LIKE(d.open_date, '^[0-9]{8}$') THEN
                d.open_date
               WHEN REGEXP_LIKE(d.open_date, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
                REPLACE(d.open_date, '-', '')
             END BETWEEN sm.term_begin_date AND v_sysdat
       WHERE EXISTS (SELECT 1
                FROM TMP_STAT_INDX_SCOPE s
               WHERE s.path_code = 'B'
                 AND s.statis_dim = sm.statis_dim
                 AND s.data_blng = sm.data_blng
                 AND s.persn_legal_bk_code = sm.persn_legal_bk_code
                 AND s.indx_code = 'INDX_0083')
       GROUP BY sm.data_blng, sm.statis_dim, sm.persn_legal_bk_code)
    SELECT path_code,
           data_date,
           data_blng,
           statis_dim,
           statis_calib,
           indx_code,
           curnt_val,
           term_last_val,
           persn_legal_bk_code
      FROM cust_result
    UNION ALL
    SELECT path_code,
           data_date,
           data_blng,
           statis_dim,
           statis_calib,
           indx_code,
           curnt_val,
           term_last_val,
           persn_legal_bk_code
      FROM debit_card_result;

  -- 6C.3 聚合支付 AUM 留存率（INDX_0081）：营销活动（A）与目标任务（B）路径计算
  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_merchant AS
     (SELECT DISTINCT s.statis_dim,
                      s.data_blng,
                      s.persn_legal_bk_code,
                      m.mct_id
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN uepp_pay_mct_info m
      -- 来源：原指标参数初始化值 INDX_0081/MERCHANT_TYPE=personage；已确认固化口径。
          ON m.mct_type = 'personage'
         AND ((s.blng_type = 'O' AND m.org_id = s.blng_id) OR
             (s.blng_type = 'M' AND m.job_id = s.blng_id))
       WHERE s.path_code = 'A'
         AND s.indx_code = 'INDX_0081'),
    annual_tx AS
     (SELECT sm.statis_dim,
             sm.data_blng,
             sm.persn_legal_bk_code,
             sm.mct_id,
             SUM(NVL(o.order_amt, 0)) AS annual_tx_amt
        FROM scope_merchant sm
       INNER JOIN uepp_pay_order_info o
          ON o.mct_id = sm.mct_id
         AND o.order_type = '00'
         AND o.status = '02'
         AND SUBSTR(o.pay_time, 1, 8) BETWEEN V_YAR_BEGIN AND v_sysdat
       GROUP BY sm.statis_dim,
                sm.data_blng,
                sm.persn_legal_bk_code,
                sm.mct_id
      -- 来源：原指标参数初始化值 INDX_0081/ACTIVE_TX_THRESHOLD=500；已确认固化口径。
      HAVING SUM(NVL(o.order_amt, 0)) >= 500),
    merchant_cust AS
     (SELECT DISTINCT a.statis_dim,
                      a.data_blng,
                      a.persn_legal_bk_code,
                      a.mct_id,
                      sa.cust_no
        FROM annual_tx a
       INNER JOIN uepp_pay_mct_settle_account sa
          ON sa.mct_id = a.mct_id
         AND sa.cust_no IS NOT NULL),
    merchant_aum AS
     (SELECT mc.statis_dim,
             mc.data_blng,
             mc.persn_legal_bk_code,
             mc.mct_id,
             SUM(NVL(b.aum_bal, 0)) AS annual_aum
        FROM merchant_cust mc
        LEFT JOIN DWS_CUST_ASSE_LIAB b
          ON b.cust_id = mc.cust_no
         AND b.persn_legal_bk_code = mc.persn_legal_bk_code
         AND b.data_date = v_sysdat
         AND b.bal_type = '4'
       GROUP BY mc.statis_dim,
                mc.data_blng,
                mc.persn_legal_bk_code,
                mc.mct_id)
    SELECT 'A',
           v_sysdat,
           a.data_blng,
           a.statis_dim,
           '营销活动',
           'INDX_0081',
           ROUND(SUM(NVL(ma.annual_aum, 0)) * 100 /
                 NULLIF(SUM(a.annual_tx_amt), 0),
                 2),
           0,
           a.persn_legal_bk_code
      FROM annual_tx a
      LEFT JOIN merchant_aum ma
        ON ma.statis_dim = a.statis_dim
       AND ma.data_blng = a.data_blng
       AND ma.persn_legal_bk_code = a.persn_legal_bk_code
       AND ma.mct_id = a.mct_id
     GROUP BY a.data_blng, a.statis_dim, a.persn_legal_bk_code;

  INSERT INTO TMP_STAT_INDX_AGGR
    (path_code,
     data_date,
     data_blng,
     statis_dim,
     statis_calib,
     indx_code,
     curnt_val,
     term_last_val,
     persn_legal_bk_code)
    WITH scope_merchant AS
     (SELECT DISTINCT s.statis_dim,
                      s.data_blng,
                      s.persn_legal_bk_code,
                      m.mct_id
        FROM TMP_STAT_INDX_SCOPE s
       INNER JOIN uepp_pay_mct_info m
      -- 来源：原指标参数初始化值 INDX_0081/MERCHANT_TYPE=personage；已确认固化口径。
          ON m.mct_type = 'personage'
         AND ((s.blng_type = 'O' AND m.org_id = s.blng_id) OR
             (s.blng_type = 'M' AND m.job_id = s.blng_id))
       WHERE s.path_code = 'B'
         AND s.indx_code = 'INDX_0081'),
    annual_tx AS
     (SELECT sm.statis_dim,
             sm.data_blng,
             sm.persn_legal_bk_code,
             sm.mct_id,
             SUM(NVL(o.order_amt, 0)) AS annual_tx_amt
        FROM scope_merchant sm
       INNER JOIN uepp_pay_order_info o
          ON o.mct_id = sm.mct_id
         AND o.order_type = '00'
         AND o.status = '02'
         AND SUBSTR(o.pay_time, 1, 8) BETWEEN V_YAR_BEGIN AND v_sysdat
       GROUP BY sm.statis_dim,
                sm.data_blng,
                sm.persn_legal_bk_code,
                sm.mct_id
      -- 来源：原指标参数初始化值 INDX_0081/ACTIVE_TX_THRESHOLD=500；已确认固化口径。
      HAVING SUM(NVL(o.order_amt, 0)) >= 500),
    merchant_cust AS
     (SELECT DISTINCT a.statis_dim,
                      a.data_blng,
                      a.persn_legal_bk_code,
                      a.mct_id,
                      sa.cust_no
        FROM annual_tx a
       INNER JOIN uepp_pay_mct_settle_account sa
          ON sa.mct_id = a.mct_id
         AND sa.cust_no IS NOT NULL),
    merchant_aum AS
     (SELECT mc.statis_dim,
             mc.data_blng,
             mc.persn_legal_bk_code,
             mc.mct_id,
             SUM(NVL(b.aum_bal, 0)) AS annual_aum
        FROM merchant_cust mc
        LEFT JOIN DWS_CUST_ASSE_LIAB b
          ON b.cust_id = mc.cust_no
         AND b.persn_legal_bk_code = mc.persn_legal_bk_code
         AND b.data_date = v_sysdat
         AND b.bal_type = '4'
       GROUP BY mc.statis_dim,
                mc.data_blng,
                mc.persn_legal_bk_code,
                mc.mct_id)
    SELECT 'B',
           v_sysdat,
           a.data_blng,
           a.statis_dim,
           '目标任务',
           'INDX_0081',
           ROUND(SUM(NVL(ma.annual_aum, 0)) * 100 /
                 NULLIF(SUM(a.annual_tx_amt), 0),
                 2),
           0,
           a.persn_legal_bk_code
      FROM annual_tx a
      LEFT JOIN merchant_aum ma
        ON ma.statis_dim = a.statis_dim
       AND ma.data_blng = a.data_blng
       AND ma.persn_legal_bk_code = a.persn_legal_bk_code
       AND ma.mct_id = a.mct_id
     GROUP BY a.data_blng, a.statis_dim, a.persn_legal_bk_code;

  V_ROW_COUNT := SQL%ROWCOUNT;
  LOG_STEP('步骤6C完成：扩展规则指标（0080~0083）聚合完成，处理行数=' || NVL(V_ROW_COUNT, 0));

  -- ================================================================
  -- 段落名称：步骤6D - 结果数据集一致性与主键唯一性强校验
  -- 业务功能：在正式写入目标表前，校验是否有空主键或重复的复合主键，
  --           存在数据质量异常时抛错并中止。
  -- ================================================================
  V_NO_ID    := '6D';
  V_BGN_DATE := SYSDATE;

  -- 6D.1 非法与空主键结果校验
  SELECT COUNT(*)
    INTO V_INVALID_RESULT_COUNT
    FROM (SELECT a.data_date,
                 a.data_blng,
                 a.statis_dim,
                 a.statis_calib,
                 a.indx_code,
                 a.persn_legal_bk_code
            FROM TMP_STAT_INDX_AGGR a) x
   WHERE x.data_date IS NULL
      OR x.data_blng IS NULL
      OR x.statis_dim IS NULL
      OR x.indx_code IS NULL
      OR x.persn_legal_bk_code IS NULL;

  -- 6D.2 重复复合主键校验
  SELECT COUNT(*)
    INTO V_DUPLICATE_RESULT_COUNT
    FROM (SELECT x.data_date,
                 x.data_blng,
                 x.statis_dim,
                 x.statis_calib,
                 x.indx_code,
                 x.persn_legal_bk_code
            FROM (SELECT a.data_date,
                         a.data_blng,
                         a.statis_dim,
                         a.statis_calib,
                         a.indx_code,
                         a.persn_legal_bk_code
                    FROM TMP_STAT_INDX_AGGR a) x
           GROUP BY x.data_date,
                    x.data_blng,
                    x.statis_dim,
                    x.statis_calib,
                    x.indx_code,
                    x.persn_legal_bk_code
          HAVING COUNT(*) > 1) d;

  IF V_INVALID_RESULT_COUNT > 0 OR V_DUPLICATE_RESULT_COUNT > 0 THEN
    outcde := -1;
    RAISE_APPLICATION_ERROR(-20002,
                            '结果数据集发布前强校验失败: 非法结果行数=' ||
                            V_INVALID_RESULT_COUNT || ', 重复主键组数=' ||
                            V_DUPLICATE_RESULT_COUNT);
  END IF;

  LOG_STEP('STEP');

  -- ================================================================
  -- 段落名称：步骤7 - 机构树递归上卷汇总与最终目标表原子发布
  -- 业务功能：利用 DWD_SYS_ORG 机构树将底层客户经理与网点数据逐级向上汇总，
  --           清理目标表当日历史记录，并将全部结果原子写入目标表 ADS_STAT_INDX_DATA。
  -- ================================================================
  V_NO_ID    := '7';
  V_BGN_DATE := SYSDATE;

  -- 7.1 删除目标表当天的跑批数据（保证幂等性）
  DELETE FROM ADS_STAT_INDX_DATA WHERE data_date = v_sysdat;

  -- 7.2 汇总原子层数据（客户经理 + 直接机构数据）与祖先机构上卷数据，统一发布至目标表
  INSERT INTO ADS_STAT_INDX_DATA
    (indx_code,
     data_blng,
     statis_dim,
     statis_calib,
     curnt_val,
     term_last_val,
     data_date,
     persn_legal_bk_code)
    WITH raw_aggr AS
     (
      -- 合并营销活动（A）与目标任务（B）的基础聚合结果
      SELECT data_date,
              data_blng,
              statis_dim,
              statis_calib,
              indx_code,
              curnt_val,
              term_last_val,
              persn_legal_bk_code
        FROM TMP_STAT_INDX_AGGR),
    org_closure AS
     (
      -- 构建祖先机构到全部后代机构的闭包关系；NOCYCLE 防止异常机构树循环。
      SELECT CONNECT_BY_ROOT org_id AS ancestor_org_id,
              org_id          AS descendant_org_id
        FROM DWD_SYS_ORG
       START WITH org_id IS NOT NULL
      CONNECT BY NOCYCLE PRIOR org_id = sup_org_id
             AND LEVEL < 20),
    org_rolled_up AS
     (
      -- 仅将直接机构结果汇总至真实祖先机构，客户经理行不参与机构上卷。
      SELECT r.data_date,
              'ORG_' || c.ancestor_org_id AS data_blng,
              r.statis_dim,
              r.statis_calib,
              r.indx_code,
              SUM(r.curnt_val) AS curnt_val,
              SUM(r.term_last_val) AS term_last_val,
              r.persn_legal_bk_code
        FROM raw_aggr r
       INNER JOIN org_closure c
          ON r.data_blng = 'ORG_' || c.descendant_org_id
         AND c.ancestor_org_id <> c.descendant_org_id
       GROUP BY r.data_date,
                 c.ancestor_org_id,
                 r.statis_dim,
                 r.statis_calib,
                 r.indx_code,
                 r.persn_legal_bk_code)
    -- 1. 写入明细原子层数据（客户经理及直接机构结果）
    SELECT indx_code,
           data_blng,
           statis_dim,
           statis_calib,
           curnt_val,
           term_last_val,
           data_date,
           persn_legal_bk_code
      FROM raw_aggr
    UNION ALL
    -- 2. 写入机构递归上卷后的汇总数据
    SELECT indx_code,
           data_blng,
           statis_dim,
           statis_calib,
           curnt_val,
           term_last_val,
           data_date,
           persn_legal_bk_code
      FROM org_rolled_up;

  V_ROW_COUNT := SQL%ROWCOUNT;

  -- 设置成功状态码并提交事务
  outcde := 0;
  COMMIT;

  LOG_STEP('步骤7完成：机构递归上卷及目标表（ADS_STAT_INDX_DATA）写入成功，总发布行数=' ||
           NVL(V_ROW_COUNT, 0));
  BEGIN
    SYS_PRC_STEP_LOGS(v_sysdat,
                      V_PRC_NAME,
                      V_PRC_DESC,
                      'SUCCESS',
                      V_BGN_DATE,
                      SYSDATE,
                      0,
                      V_SUCCESS_LOG_SUM,
                      0,
                      V_LOG_BUTTON);
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- 日志失败不得将已提交的业务批次误报为失败。
  END;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    outcde      := -1;
    V_END_DATE  := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - NVL(V_BGN_DATE, SYSDATE)) * 24 * 60 * 60);
    V_LOG_MSG   := '存储过程执行异常中断 [步骤:' || NVL(V_NO_ID, 'N/A') || ']: ' ||
                   SQLERRM;
    V_LOG_FLG   := -1;
  
    -- 记录异常日志
    BEGIN
      SYS_PRC_STEP_LOGS(v_sysdat,
                        V_PRC_NAME,
                        V_PRC_DESC,
                        NVL(V_NO_ID, 'ERR'),
                        NVL(V_BGN_DATE, SYSDATE),
                        V_END_DATE,
                        V_DURA_DATE,
                        V_LOG_MSG,
                        V_LOG_FLG,
                        V_LOG_BUTTON);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    RAISE_APPLICATION_ERROR(-20099, V_LOG_MSG);
END prc_ads_stat_indx_data;
