CREATE OR REPLACE PROCEDURE PRC_DWD_CUST_CTRAKT_INFO(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: 客户合同信息处理
  -- 存储过程编号: PRC_DWD_CUST_CTRAKT_INFO
  -- 处理周期: 日
  -- 过程描述: 根据 CUST_CTRAKT_INFO 映射关系生成客户合同信息
  -- 来源表: CMS_CUSTOMER_INFO(客户信息表), CMS_BUSINESS_CONTRACT(合同业务表)
  -- 目标表: DWD_CUST_CTRAKT_INFO(客户合同信息)
  -- author :
  -- date   : 2026-07-15
  -- 适配数据库: 人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '客户合同信息处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_CUST_CTRAKT_INFO';
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
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_CTRAKT_INFO';

  --***************************************
  -- 2.1 客户合同信息落库
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_CUST_CTRAKT_INFO (
      CUST_ID,
      CTRAKT_ID,
      LOAN_ACCT,
      CRDT_LMT,
      LOAN_BAL,
      GUARANT_MODE,
      CATE_5LVL,
      CCY_CD,
      RATE_INTRI,
      CONTR_AMT,
      BGN_DATE,
      END_DATE,
      OPRTR,
      OPRT_ORG,
      PERSN_LEGAL_BK_CODE
  )
  SELECT
      c.mfcustomerid       AS CUST_ID,             -- 客户编号；核心客户号
      bc.serialno          AS CTRAKT_ID,           -- 合同编号；合同流水号
      NULL                 AS LOAN_ACCT,           -- 贷款账号；映射表未提供可确认来源
      bc.businesssum       AS CRDT_LMT,            -- 授信额度；备注：个人没有授信额度，是否取业务合同金额
      bc.balance           AS LOAN_BAL,            -- 贷款余额
      bc.vouchtype         AS GUARANT_MODE,        -- 担保方式
      bc.classifyresult    AS CATE_5LVL,           -- 五级分类；分类结果
      bc.businesscurrency  AS CCY_CD,              -- 币种
      bc.businessrate      AS RATE_INTRI,          -- 利率；new 5 中 BUSINESS_CONTRACT 已有 businessrate，未额外关联 ACCT_RATE_SEGMENT
      bc.businesssum       AS CONTR_AMT,           -- 合同金额
      bc.putoutdate        AS BGN_DATE,            -- 发放日期；new 5 字段为 putoutdate
      bc.maturity          AS END_DATE,            -- 结束日期；映射字段 MaturityDate 在 new 5 中对应 maturity
      bc.manageuserid      AS OPRTR,               -- 经办人；主办客户经理
      bc.manageorgid       AS OPRT_ORG,            -- 经办机构；主办机构
      NULL                 AS PERSN_LEGAL_BK_CODE  -- 法人行号；映射表未提供可确认来源
    FROM CMS_CUSTOMER_INFO c                            -- 客户信息表
   INNER JOIN CMS_BUSINESS_CONTRACT bc                  -- 合同业务表
      ON bc.customerid = c.customerid;

  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 客户合同信息落库';
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
  -- 3. 异常处理区（捕获错误码并记录详细日志）
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
END;
/
