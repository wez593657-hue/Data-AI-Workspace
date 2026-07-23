CREATE OR REPLACE PROCEDURE PRC_DWD_CUST_INDIV_CRDT(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: 个人客户授信信息处理
  -- 存储过程编号: PRC_DWD_CUST_INDIV_CRDT
  -- 处理周期: 日
  -- 过程描述: 根据 CUST_INDIV_CRDT 映射关系生成个人客户授信信息
  -- 来源表: CMS_CUSTOMER_INFO(客户信息表), CMS_BUSINESS_CONTRACT(合同业务表)
  -- 目标表: DWD_CUST_INDIV_CRDT(个人客户授信信息)
  -- author :
  -- date   : 2026-07-15
  -- 适配数据库: 人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '个人客户授信信息处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_CUST_INDIV_CRDT';
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

  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_INDIV_CRDT';

  --***************************************
  -- 2.1 个人客户授信信息落库
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_CUST_INDIV_CRDT (
      CUST_ID,
      CUST_NAME,
      CRDT_AGRE_NO,
      CRDT_AGRE_TYP,
      CRDT_TTL_LMT,
      BGN_DATE,
      EXPR_DATE,
      CRDT_STATUS,
      PERSN_LEGAL_BK_CODE
  )
  SELECT
      c.mfcustomerid     AS CUST_ID,             -- 客户编号；核心客户号
      c.customername     AS CUST_NAME,           -- 客户名称
      bc.serialno        AS CRDT_AGRE_NO,        -- 授信协议号；合同流水号
      NULL               AS CRDT_AGRE_TYP,       -- 授信协议类型；映射表未提供可确认来源
      bc.businesssum     AS CRDT_TTL_LMT,        -- 授信额度；单笔授信额度
      bc.putoutdate      AS BGN_DATE,            -- 开始日期；授信起始日期
      bc.maturity        AS EXPR_DATE,           -- 到期日期；映射字段 MaturityDate 在 new 5 中对应 maturity
      NULL               AS CRDT_STATUS,         -- 授信状态；映射表未提供可确认来源
      NULL               AS PERSN_LEGAL_BK_CODE  -- 法人行号；映射表未提供可确认来源
    FROM CMS_CUSTOMER_INFO c                          -- 客户信息表
   INNER JOIN CMS_BUSINESS_CONTRACT bc                -- 合同业务表
      ON bc.customerid = c.customerid;

  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '2.1 个人客户授信信息落库';
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
