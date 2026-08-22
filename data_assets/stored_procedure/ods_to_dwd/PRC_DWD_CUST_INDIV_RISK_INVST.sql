-- DROP PROCEDURE crmdm.prc_dwd_cust_indiv_risk_invst(in varchar, out int4);

CREATE OR REPLACE PROCEDURE crmdm.prc_dwd_cust_indiv_risk_invst(v_sysdat varchar, outcde OUT integer)
AS
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
  V_PRC_DESC             VARCHAR(100) := '客户风险评估';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_CUST_INDIV_RISK_INVST';
  V_SYSDAT2              VARCHAR(10);
  V_SQL                  VARCHAR(4000);
  V_LOG_MSG              VARCHAR(4000);
  V_START_DT             DATE;
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  P_INTERVAL_START_DATE  VARCHAR(8);
  P_INTERVAL_END_DATE    VARCHAR(8);
BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;
  V_SYSDAT2 := sys_fun_deal_date(V_SYSDAT, 1);  -- 参数1：上一日
  P_INTERVAL_START_DATE := sys_fun_deal_date(V_SYSDAT, 18);  -- 参数18：30天承接窗口开始日
  P_INTERVAL_END_DATE   := sys_fun_deal_date(V_SYSDAT, 1);  -- 参数1：上一日

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_INDIV_RISK_INVST';

  --***************************************
  -- 2.1 理财-客户风险评估落库
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_CUST_INDIV_RISK_INVST (
      CUST_ID,
      INVEST_TYP,
      ESTIM_RSLT,
      SCORE,
      RISK_LVL,
      ESTIM_DATE,
      EXPR_DATE,
      PERSN_LEGAL_BK_CODE
  )
  SELECT
      host_cust_no	  AS CUST_ID,   --主机客户号
      '1'             AS INVEST_TYP,--投资类型
      NULL	          AS ESTIM_RSLT,--评估结果
      NULL	          AS SCORE,     --分数
      CUST_RISK_LEVEL	AS RISK_LVL,  --风险承受等级
      ASSESS_DATE	    AS ESTIM_DATE,--评估日期
      INVALID_DATE	  AS EXPR_DATE, --失效日期
      CASE WHEN sub_branch_code LIKE '15%' THEN '1500' 
      	   WHEN sub_branch_code LIKE '12%' THEN '1200'
      	   WHEN sub_branch_code LIKE '18%' THEN '1800'
      	   ELSE '9999' END          AS PERSN_LEGAL_BK_CODE --法人行号
    FROM FMS_T4_CUST_RISK_ASSESS_INFO	-- 客户风险承受能力评估信息表
where host_cust_no is not NULL;
  COMMIT;

  OUTCDE := 0;
    V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和物理临时表';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );


  --***************************************
  -- 2.2 保险-客户风险评估落库
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;
/*9月保险上线后*/
    V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和物理临时表';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT,
      V_PRC_NAME,
      V_PRC_DESC,
      V_NO_ID,
      V_BGN_DATE,
      V_END_DATE,
      V_DURA_DATE,
      V_LOG_MSG,
      V_LOG_FLG,
      V_LOG_BUTTON
  );


  --***************************************
  -- 3. 异常处理区(捕获错误码并记录详细日志)
  --***************************************
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;

    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;

    SYS_PRC_STEP_LOGS(
        V_SYSDAT,
        V_PRC_NAME,
        V_PRC_DESC,
        V_NO_ID,
        V_BGN_DATE,
        V_END_DATE,
        V_DURA_DATE,
        V_LOG_MSG,
        V_LOG_FLG,
        V_LOG_BUTTON
    );

    RAISE;
END


;
