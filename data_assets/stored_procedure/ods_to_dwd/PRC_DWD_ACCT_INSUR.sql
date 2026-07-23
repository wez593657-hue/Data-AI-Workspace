CREATE OR REPLACE PROCEDURE PRC_DWD_ACCT_INSUR(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 报表名称: 保险账户处理
  -- 报表编号：PRC_DWD_ACCT_INSUR
  -- 处理周期：日
  -- 过程描述：根据 DWD_ACCT_INSUR 映射生成保险账户数据
  -- 来源表：YBT_POLICY_FEE_LIST(保单交易明细表)、IBP_IB_LIST_PLAT(交易流水表)、YBT_POLICY_BASE_INFO(保单信息表)、
             --YBT_POLICY_INSURANCE_INFO(保单承保险种信息表)、YBT_PRODUCT_INFO(保险产品信息表)、DWD_CUST_INDV_INFO(客户基本信息)
  -- 目标表：DWD_ACCT_INSUR(保险账户信息)
  -- author :
  -- date   ： 2026-06-30
  -- 适配数据库：人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '保险账户处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_ACCT_INSUR';
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
  P_INTERVAL_START_DATE   VARCHAR(8);
  P_INTERVAL_END_DATE     VARCHAR(8);
begin
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE MTS_ACCT_INSUR';

  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;
  INSERT INTO DWD_ACCT_INSUR (
      CUST_ID, CUST_TYP, ACCT_ID, PRDKT_ID, PRDKT_NAME, PRDKT_CATE_BIG, INSUR_BID_FORM_NO, TX_DATE, TX_ORG, TX_CHNL, MKT_ORG, BGN_INSUR_DATE, 
      CANCL_INSUR_DATE, PAY_UPTO_DATE, PAY_PERIOD_TYP, PAY_PERIOD, INSUR_PERIOD_TYP, INSUR_PERIOD, PAY_PATRN, INSUR_AMT, POLICY_STATE, TX_TYP, PERSN_LEGAL_BK_CODE, INSUR_MTH_AVG, INSUR_QRT_AVG, INSUR_YR_AVG
  )
  SELECT
    b.user_id           AS CUST_ID,            -- 核心客户号
    '1'                 AS CUST_TYP,           -- 客户类型
    c.ACC_NO            AS ACCT_ID,            -- 保险关联账号
    e.PRODUCT_ID        AS PRDKT_ID,           -- 保险产品编号
    e.PRODUCT_NAME      AS PRDKT_NAME,         -- 保险产品名称
    e.PRODUCT_BIG_TYPE  AS PRDKT_CATE_BIG,     -- 保险产品大类
    c.CONT_NO           AS INSUR_BID_FORM_NO,  -- 投保单号
    c.ACCEPT_DATE       AS TX_DATE,            -- 交易日期
    c.THROW_COM         AS TX_ORG,             -- 交易机构
    c.CONT_SOURCE       AS TX_CHNL,            -- 交易渠道
    c.THROW_COM         AS MKT_ORG,            -- 归属机构
    TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), 'YYYYMMDD') AS BGN_INSUR_DATE, -- 保险起保日期，统一返回 VARCHAR2(8)
    CASE
          WHEN d.VALID_PER_UNIT = '-1' THEN '9999-12-31'
          WHEN d.VALID_PER_UNIT = '0'
           AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{17}[0-9Xx]$')
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(f.CERT_ID, 7, 8), 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYYMMDD')
          WHEN d.VALID_PER_UNIT = '0'
           AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{15}$')
          THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(f.CERT_ID, 7, 6), 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
          WHEN d.VALID_PER_UNIT = '12' THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
          WHEN d.VALID_PER_UNIT = '1'  THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), d.VALID_PER_NUM), 'YYYY-MM-DD')
          WHEN d.VALID_PER_UNIT = '2'  THEN TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD') + d.VALID_PER_NUM, 'YYYY-MM-DD')
          ELSE NULL
     END AS CANCL_INSUR_DATE,   -- 退保日期/保险期间结束日期，统一返回 VARCHAR2(10)；0-保至某确定年龄时按客户证件号码截取出生日期后计算
     CASE
          WHEN d.PAY_TYPE = '0' THEN TO_CHAR(TO_DATE(c.ACCEPT_DATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
          WHEN d.PAY_PER_UNIT = '12' THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), 12 * d.PAY_PER_NUM), 'YYYY-MM-DD')
          WHEN d.PAY_PER_UNIT = '1'  THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), d.PAY_PER_NUM), 'YYYY-MM-DD')
          WHEN d.PAY_PER_UNIT = '2'  THEN TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD') + d.PAY_PER_NUM, 'YYYY-MM-DD')
          WHEN d.PAY_PER_UNIT = '0'
           AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{17}[0-9Xx]$')
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(f.CERT_ID, 7, 8), 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYY-MM-DD')
          WHEN d.PAY_PER_UNIT = '0'
           AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{15}$')
          THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(f.CERT_ID, 7, 6), 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYY-MM-DD')
          WHEN d.PAY_PER_UNIT = '-1' THEN NULL
          ELSE NULL
     END AS PAY_UPTO_DATE, -- 缴费截止日期，统一返回 VARCHAR2(10)；按缴费期间类型和缴费期间值计算，0-交至某确定年龄时按客户证件号码截取出生日期后计算
    d.PAY_PER_UNIT      AS PAY_PERIOD_TYP,     -- 缴费期间类型
    d.PAY_PER_NUM       AS PAY_PERIOD,         -- 缴费期间值 
    d.VALID_PER_UNIT    AS INSUR_PERIOD_TYP,   -- 保险期间类型
    d.VALID_PER_NUM     AS INSUR_PERIOD,       -- 保险期间值 
    d.PAY_TYPE          AS PAY_PATRN,          -- 保险缴费方式
    a.ORD_AMT           AS INSUR_AMT,          -- 保险保费金额
    c.CONT_STATUS       AS POLICY_STATE,       -- 保险单状态
    a.TRAN_TYPE         AS TX_TYP,             -- 交易类型
    NULL                AS PERSN_LEGAL_BK_CODE -- 法人行号
  FROM YBT_POLICY_FEE_LIST a                -- 保单交易明细表
  INNER JOIN IBP_IB_LIST_PLAT b                 -- 交易流水表
    ON a.ord_pay_serial = b.plat_serial
   AND b.plat_trad_status = '2'
  INNER JOIN YBT_POLICY_BASE_INFO c         -- 保单信息表
    ON a.plat_policy_serial = c.plat_policy_serial
  INNER JOIN YBT_POLICY_INSURANCE_INFO d    -- 保单承保险种信息表
    ON c.plat_policy_serial = d.plat_policy_serial
  INNER JOIN YBT_PRODUCT_INFO e             -- 保险产品信息表
    ON c.product_id = e.product_id
  LEFT JOIN DWD_CUST_INDV_INFO f                -- 客户基本信息，用于按证件号码推算出生日期
    ON b.user_id = f.cust_id
  ;
  COMMIT;
  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '保险账户处理完成';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -- ***************************************  
    -- 3. 异常处理区（捕获错误码并记录详细日志）
    -- ***************************************  
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60) END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END;
