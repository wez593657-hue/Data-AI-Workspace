  -- DROP PROCEDURE crmdm.prc_dwd_cust_indiv_risk_invst(in varchar, out int4);

  CREATE OR REPLACE PROCEDURE crmdm.prc_dwd_cust_indiv_risk_invst(v_sysdat VARCHAR, outcde OUT INTEGER) AS
  ------------------------------------------------------------------
  -- 存储过程名称: 客户风险评估
  -- 存储过程编号: PRC_DWD_CUST_INDIV_RISK_INVST
  -- 处理周期: 日
  -- 过程描述: 根据 FMS_T4_CUST_RISK_ASSESS_INFO 映射关系生成客户风险评估信息
  -- 来源表: FMS_T4_CUST_RISK_ASSESS_INFO(客户风险承受能力评估信息表)
  -- 目标表: DWD_CUST_INDIV_RISK_INVST(客户风险评估)
  -- author :
  -- date   : 2026-07-15
  -- 适配数据库: 人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  v_prc_desc            VARCHAR(100) := '客户风险评估';
  v_prc_name            VARCHAR(32) := 'PRC_DWD_CUST_INDIV_RISK_INVST';
  v_sysdat2             VARCHAR(10);
  v_sql                 VARCHAR(4000);
  v_log_msg             VARCHAR(4000);
  v_start_dt            DATE;
  v_log_flg             INTEGER;
  v_log_button          INTEGER := 1;
  v_no_id               VARCHAR(10);
  v_bgn_date            DATE;
  v_end_date            DATE;
  v_dura_date           INTEGER;
  p_interval_start_date VARCHAR(8);
  p_interval_end_date   VARCHAR(8);
BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  v_start_dt            := SYSDATE;
  v_sysdat2             := sys_fun_deal_date(v_sysdat,
                                             1); -- 参数1：上一日
  p_interval_start_date := sys_fun_deal_date(v_sysdat,
                                             18); -- 参数18：30天承接窗口开始日
  p_interval_end_date   := sys_fun_deal_date(v_sysdat,
                                             1); -- 参数1：上一日

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_INDIV_RISK_INVST';

  --***************************************
  -- 2.1 理财-客户风险评估落库
  --***************************************
  v_no_id    := '1';
  v_bgn_date := SYSDATE;

  INSERT INTO dwd_cust_indiv_risk_invst
    (cust_id
    ,invest_typ
    ,estim_rslt
    ,score
    ,risk_lvl
    ,estim_date
    ,expr_date
    ,persn_legal_bk_code)
    SELECT cust_id,
           invest_typ,
           estim_rslt,
           score,
           risk_lvl,
           estim_date,
           expr_date,
           persn_legal_bk_code
      FROM (SELECT host_cust_no AS cust_id, --主机客户号
                   '3' AS invest_typ, --投资类型--理财
                   NULL AS estim_rslt, --评估结果
                   NULL AS score, --分数
                   cust_risk_level AS risk_lvl, --风险承受等级
                   assess_date AS estim_date, --评估日期
                   invalid_date AS expr_date, --失效日期
                   CASE
                     WHEN sub_branch_code LIKE '15%' THEN
                      '1500'
                     WHEN sub_branch_code LIKE '12%' THEN
                      '1200'
                     WHEN sub_branch_code LIKE '18%' THEN
                      '1800'
                     ELSE
                      '9999'
                   END AS persn_legal_bk_code, --法人行号
                   row_number() over(PARTITION BY host_cust_no,
                   CASE
                     WHEN sub_branch_code LIKE '15%' THEN
                      '1500'
                     WHEN sub_branch_code LIKE '12%' THEN
                      '1200'
                     WHEN sub_branch_code LIKE '18%' THEN
                      '1800'
                     ELSE
                      '9999'
                   END ORDER BY assess_date || upd_date || upd_time DESC) AS rn
              FROM fms_t4_cust_risk_assess_info -- 客户风险承受能力评估信息表
             WHERE host_cust_no IS NOT NULL)
     WHERE rn = '1';
  COMMIT;

  outcde      := 0;
  v_end_date  := SYSDATE;
  v_dura_date := trunc((v_end_date - v_bgn_date) * 24 * 60 * 60);
  outcde      := 0;
  v_log_msg   := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和物理临时表';
  v_log_flg   := outcde;

  sys_prc_step_logs(v_sysdat,
                    v_prc_name,
                    v_prc_desc,
                    v_no_id,
                    v_bgn_date,
                    v_end_date,
                    v_dura_date,
                    v_log_msg,
                    v_log_flg,
                    v_log_button);

  --***************************************
  -- 2.2 保险-客户风险评估落库
  --***************************************
  v_no_id    := '2';
  v_bgn_date := SYSDATE;
  /*9月保险上线后*/
  v_end_date  := SYSDATE;
  v_dura_date := trunc((v_end_date - v_bgn_date) * 24 * 60 * 60);
  outcde      := 0;
  v_log_msg   := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和物理临时表';
  v_log_flg   := outcde;

  sys_prc_step_logs(v_sysdat,
                    v_prc_name,
                    v_prc_desc,
                    v_no_id,
                    v_bgn_date,
                    v_end_date,
                    v_dura_date,
                    v_log_msg,
                    v_log_flg,
                    v_log_button);

  --***************************************
  -- 3. 异常处理区(捕获错误码并记录详细日志)
  --***************************************
EXCEPTION
  WHEN OTHERS THEN
    outcde := -1;
    ROLLBACK;
  
    v_end_date  := SYSDATE;
    v_dura_date := CASE WHEN v_bgn_date IS NULL OR v_end_date IS NULL THEN NULL ELSE trunc((v_end_date - v_bgn_date) * 24 * 60 * 60) END;
    v_log_msg   := substr(SQLERRM,
                          1,
                          1000);
    v_log_flg   := outcde;
  
    sys_prc_step_logs(v_sysdat,
                      v_prc_name,
                      v_prc_desc,
                      v_no_id,
                      v_bgn_date,
                      v_end_date,
                      v_dura_date,
                      v_log_msg,
                      v_log_flg,
                      v_log_button);
  
    RAISE;
END

  ;
