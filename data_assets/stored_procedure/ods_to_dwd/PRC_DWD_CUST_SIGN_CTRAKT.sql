CREATE OR REPLACE PROCEDURE PRC_DWD_CUST_SIGN_CTRAKT(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: 客户签约信息
  -- 存储过程编号：PRC_DWD_CUST_SIGN_CTRAKT
  -- 处理周期：日
  -- 过程描述：
  -- 来源表：
  --   ECIF_T01_P_CUST_INFO
  --   ECIF_T02_A_CUST_SIGN_REL
  --   ECIF_T05_A_ACC_SIGN
  -- 目标表：
  --   DWD_CUST_SIGN_CTRAKT
  -- author :
  -- date   ： 2020-07-13
  -- 适配数据库：人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_CUST_SIGN_CTRAKT';
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
  -- 默认返回成功，异常时统一改为 -1
  --OUTCDE := 0;

  -- 记录跑批开始时间，用于统计整个过程耗时
  V_START_DT := SYSDATE;

  -- 将输入的批处理日期转换为标准格式，便于后续日志和区间处理
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');

  -- 预留时间区间参数，方便后续扩展按天/按月增量处理
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  -- 每次跑批前先清空目标表，保证结果为当日全量重算
  EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_CUST_SIGN_CTRAKT';

  --***************************************
  -- 2.0 客户签约信息
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_CUST_SIGN_CTRAKT (
      CUST_ID,
      CTRAKT_ACCT,
      CTRAKT_TYP,
      CTRAKT_DATE,
      PHONE_NO,
      CTRAKT_ORG,
      CTRAKT_OPRTR,
      CTRAKT_STATE,
      PERSN_LEGAL_BK_CODE
  )
  SELECT
      t0.ECIF_CUST_NO    AS CUST_ID,              -- 客户编号
      t1.ACC_SIGN_ID     AS CTRAKT_ACCT,          -- 签约账号
      t1.SIGN_TYPE       AS CTRAKT_TYP,           -- 签约类型
      t2.SIGN_DATE       AS CTRAKT_DATE,          -- 签约日期
      t2.SIGN_REL_PHONE  AS PHONE_NO,             -- 预留手机号
      t2.SIGN_ORG        AS CTRAKT_ORG,           -- 签约机构
      t2.ATTN_NAME       AS CTRAKT_OPRTR,         -- 签约经办人
      t1.SIGN_STATE      AS CTRAKT_STATE,         -- 签约状态
      CASE WHEN t2.SIGN_ORG LIKE '15%' THEN '1500' 
      	   WHEN t2.SIGN_ORG LIKE '12%' THEN '1200'
      	   WHEN t2.SIGN_ORG LIKE '18%' THEN '1800'
      	   ELSE '9999' END            AS PERSN_LEGAL_BK_CODE   -- 法人行号
    FROM ECIF_T01_P_CUST_INFO t0                  -- 客户信息
   INNER JOIN ECIF_T02_A_CUST_SIGN_REL t1         -- 参与人与业务签约的关系
      ON t0.PARTY_ID = t1.PARTY_ID
    LEFT JOIN ECIF_T05_A_ACC_SIGN t2              -- 账户签约信息
      ON t1.ACC_SIGN_ID = t2.ACC_SIGN_ID;
  -- 提交第1段结果，确保已完成数据不被后续异常影响
  COMMIT;

  -- 记录第1段结束时间和耗时
  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '客户签约信息';
  V_LOG_FLG := OUTCDE;

  -- 调用日志过程，记录第1段正常结束信息
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

  -- ***************************************
  -- 3. 异常处理区（捕获错误码并记录详细日志）
  -- ***************************************
EXCEPTION
  WHEN OTHERS THEN
    -- 异常时先回滚当前未提交数据，避免留下半成品
    OUTCDE := -1;
    ROLLBACK;

    -- 记录异常发生后的结束时间和耗时
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                     WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                     ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;

    -- 用 Oracle 标准错误信息写入日志，保留前 1000 个字符
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;

    -- 异常信息也走同一个日志过程，保证审计链路一致
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

    -- 继续抛出异常，交给上层调度器感知失败
    RAISE;
END;
