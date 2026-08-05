-- DROP PROCEDURE crmdm.prc_dwd_acct_insur(in varchar, out int4);

CREATE OR REPLACE PROCEDURE crmdm.prc_dwd_acct_insur(v_sysdat varchar, outcde OUT integer)
AS
  ------------------------------------------------------------------
  -- 报表名称: 保险账户处理
  -- 报表编号：PRC_DWD_ACCT_INSUR
  -- 处理周期：日
  -- 过程描述：单过程分段执行保险账户数据加工：
  --           1. 参数校验 + 目标表当日清理 + TMP表清空（支持重跑）
  --           2. [A0a] 一次扫描预聚合FEE_LIST交易日期(成功缴费+终止+续期)
  --                  → TMP_DWD_ACCT_INSUR_FEE_AGGR（F-10消除双重扫描）
  --           TMP1 [A0b] 生成保单级主档聚合快照 → TMP_DWD_ACCT_INSUR_SNAP
  --                  （含INSUR_AMT清零规则：终止/趸交满一年/期缴缴满/宽限期过60天）
  --           TMP2 [A1] MERGE/UPSERT 快照 → DWD_ACCT_INSUR
  --                  （四键主键匹配，新增+更新，永不删除）
  -- 来源表：YBT_YBT_POLICY_BASE_INFO(保单信息表)、YBT_YBT_POLICY_FEE_LIST(保单交易明细表)、
  --         YBT_IB_LIST_PLAT(交易流水表)、YBT_YBT_POLICY_INSURANCE_INFO(保单承保险种信息表)、
  --         YBT_YBT_PRODUCT_INFO(保险产品信息表)、DWD_CUST_INDV_INFO(客户基本信息)
  -- 目标表：DWD_ACCT_INSUR(保险账户信息-保单级主档)
  -- 需求版本: v2.4.0
  -- 变更记录:
  --   v1.0.0 2026-06-30 初始版本
  --   v1.0.1 2026-07-28 字段映射修正(TX_TYP取TRAN_TYPE)、删除未使用变量、INSERT列顺序与DDL对齐
  --   v1.1.0 2026-08-03 新增NEW_INSUR_AMT、INSUR_AMT=新单+续期；TX_TYP置空；仅加载0/1交易(已被v2.0取代)
  --   v2.0.0 2026-08-03 保单级主档重构：UPSERT永不删除；POLICY_STATE(0/1/2)唯一状态判定源；
  --                    INSUR_AMT承担终止/缴费期满/60天宽限期清零；趸交满一年起算点=TX_DATE
  --   v2.1.0 2026-08-03 新增/更新逻辑分离(独立过程INS/UPD，已按评审要求合并回单过程)
  --   v2.2.0 2026-08-03 单过程分段执行新增与更新：快照一次计算 + 段落2.2新增 + 段落2.3更新，
  --                    参数验证、统一事务、批量/索引优化、字段与参数注释完整
  --   v2.3.0 2026-08-05 对齐YBT源表：TX_DATE取ACCEPT_DATE；LAST_TX_DATE取缴费成功
  --                    (ORD_TRAN_STATUS=2)的最近ORD_CREATE_DATE，无成功缴费时回退ACCEPT_DATE；
  --                    交易日期和终止日期改为预聚合，避免相关子查询重复扫描
  --   v2.3.1 2026-08-05 F-02 修正INSUR_PERIOD_TYP↔PAY_PERIOD_TYP列映射互换
  --                    (VALID_PER_UNIT/NUM→INSUR_*, PAY_PER_UNIT/NUM→PAY_*)；
  --                    移除INSUR_AMT中PAY_PERIOD的REGEXP_LIKE(源字段为NUMERIC型)
  --   v2.4.0 2026-08-05 全面重构：
  --     F-01 补充MERGE/UPSERT目标表写入逻辑（快照→DWD_ACCT_INSUR，四键主键匹配）
  --     F-03 拆分为4个独立步骤(1清理/2预聚合/TMP1快照/TMP2写入)，
  --          每步独立V_NO_ID+COMMIT+SYS_PRC_STEP_LOGS，符合模板规则#3/#4/#5
  --     F-05 60天宽限期改为基于最近续期日期(LAST_RENEWAL_DATE_PARSED)而非全局COUNT，
  --          避免多续期保单宽限期窗口无限延长
  --     F-10 新增TMP_DWD_ACCT_INSUR_FEE_AGGR预聚合FEE_LIST，消除[FA]子查询双重扫描
  --     v2.3.1 PAY_PERIOD REGEXP_LIKE改为数值校验已合并保留
  -- 适配数据库：人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '保险账户处理';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_DWD_ACCT_INSUR';
  V_LOG_MSG              VARCHAR(4000);
  V_START_DT             DATE;
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  V_DATA_DATE            DATE;        -- 加工日（由 V_SYSDAT 转换）
  V_CNT_MRG              INTEGER;     -- MERGE影响行数
BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;

  ------------------------------------------------------------------
  -- 步骤1: 参数校验 + 目标表当日清理 + TMP表清空
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- 1.1 参数验证：V_SYSDAT 必填且为 8 位日期(YYYYMMDD)
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
      OUTCDE := -1;
      RETURN;
  END IF;
  V_DATA_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  -- 1.2 清理当日目标数据（支持重跑）
  DELETE FROM DWD_ACCT_INSUR D
   WHERE D.TX_DATE = V_SYSDAT;

  -- 1.3 清空所有临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWD_ACCT_INSUR_FEE_AGGR';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWD_ACCT_INSUR_SNAP';

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '1 完成: 参数校验+清理目标数据+TMP表';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤2: [A0a] 预聚合FEE_LIST交易日期
  -- 作用：一次扫描YBT_YBT_POLICY_FEE_LIST，聚合每保单的成功缴费/终止/续期日期，
  --       消除后续快照查询中FEE_LIST双重扫描(F-10)，
  --       预计算最近续期日期供60天宽限期判定(F-05)
  ------------------------------------------------------------------
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWD_ACCT_INSUR_FEE_AGGR (
      PLAT_POLICY_SERIAL, LAST_SUCCESS_TX_DATE, ACTL_TERM_DATE_PARSED,
      LAST_RENEWAL_DATE_PARSED
  )
  SELECT F.PLAT_POLICY_SERIAL,
         MAX(CASE WHEN F.ORD_TRAN_STATUS = '2'
                   AND REGEXP_LIKE(TRIM(F.ORD_CREATE_DATE), '^[0-9]{8}$')
                  THEN TO_DATE(TRIM(F.ORD_CREATE_DATE), 'YYYYMMDD')
             END)                                                     AS LAST_SUCCESS_TX_DATE,  -- 最近成功缴费
         MAX(CASE WHEN F.TRAN_TYPE IN ('2','3','4','5','6','8')
                   AND REGEXP_LIKE(TRIM(F.ORD_CREATE_DATE), '^[0-9]{8}$')
                  THEN TO_DATE(TRIM(F.ORD_CREATE_DATE), 'YYYYMMDD')
             END)                                                     AS ACTL_TERM_DATE_PARSED,  -- 实际终止日期
         MAX(CASE WHEN F.TRAN_TYPE = '1'
                   AND REGEXP_LIKE(TRIM(F.ORD_CREATE_DATE), '^[0-9]{8}$')
                  THEN TO_DATE(TRIM(F.ORD_CREATE_DATE), 'YYYYMMDD')
             END)                                                     AS LAST_RENEWAL_DATE_PARSED -- F-05: 最近续期日期
    FROM YBT_YBT_POLICY_FEE_LIST F
    WHERE  F.ORD_TRAN_STATUS = '2'
GROUP BY F.PLAT_POLICY_SERIAL;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2 完成: [A0a]预聚合FEE_LIST交易日期';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤TMP1: [A0b] 生成保单级聚合快照
  -- 作用：将 ODS 保单/交易/流水/险种/产品/客户聚合为保单级一行，
  --       INSUR_AMT在此步骤完成清零判定（终止/趸交满一年/期缴缴满/宽限期过60天），
  --       避免目标表写入时重复计算。
  -- 变更：v2.4.0 FA子查询替换为TMP_DWD_ACCT_INSUR_FEE_AGGR(F-10)；
  --       60天宽限期改为基于LAST_RENEWAL_DATE_PARSED(F-05)。
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWD_ACCT_INSUR_SNAP (
      CUST_ID, CUST_TYP, ACCT_ID, PRDKT_ID, PRDKT_NAME, PRDKT_CATE_BIG, INSUR_BID_FORM_NO,
      TX_DATE, LAST_TX_DATE, TX_ORG, TX_CHNL, MKT_ORG, BGN_INSUR_DATE, CANCL_INSUR_DATE,
      ACTL_TERM_DATE, PAY_UPTO_DATE, INSUR_PERIOD_TYP, INSUR_PERIOD, PAY_PERIOD_TYP, PAY_PERIOD,
      PAY_PATRN, NEW_INSUR_AMT, INSUR_AMT, POLICY_STATE, TX_TYP, PERSN_LEGAL_BK_CODE)
  SELECT
      P.CUST_ID                                                         AS CUST_ID,            -- 客户编号
      P.CUST_TYP                                                        AS CUST_TYP,           -- 客户类型
      P.ACCT_ID                                                         AS ACCT_ID,            -- 账户
      P.PRDKT_ID                                                        AS PRDKT_ID,           -- 产品ID
      P.PRDKT_NAME                                                      AS PRDKT_NAME,         -- 产品名称
      P.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG,     -- 产品大类
      P.INSUR_BID_FORM_NO                                               AS INSUR_BID_FORM_NO,  -- 投保单号
      TO_CHAR(MIN(P.ACCEPT_DATE_PARSED), 'YYYYMMDD')                    AS TX_DATE,            -- 投保日期
      COALESCE(
          TO_CHAR(MAX(P.LAST_SUCCESS_TX_DATE), 'YYYYMMDD'),
          TO_CHAR(MIN(P.ACCEPT_DATE_PARSED), 'YYYYMMDD')
      )                                                                 AS LAST_TX_DATE,       -- 最近成功缴费日期，无成功缴费回退投保日期
      P.TX_ORG                                                          AS TX_ORG,             -- 交易机构
      P.TX_CHNL                                                         AS TX_CHNL,            -- 交易渠道
      P.MKT_ORG                                                         AS MKT_ORG,            -- 归属机构
      P.BGN_INSUR_DATE                                                  AS BGN_INSUR_DATE,     -- 起保日期
      P.CANCL_INSUR_DATE                                                AS CANCL_INSUR_DATE,   -- 保险期间结束日期(推算,仅参考)
      -- 实际终止日期：状态交易最新日期 → 状态=2 时回退 CANCL_INSUR_DATE（排除9999）
      COALESCE(
          TO_CHAR(MAX(P.ACTL_TERM_DATE_PARSED), 'YYYYMMDD'),
          CASE WHEN P.CONT_STATUS = '2'
                AND P.CANCL_INSUR_DATE IS NOT NULL
                AND P.CANCL_INSUR_DATE <> '9999-12-31'
               THEN TO_CHAR(TO_DATE(SUBSTR(P.CANCL_INSUR_DATE,1,10), 'YYYY-MM-DD'), 'YYYYMMDD')
          END)                                                          AS ACTL_TERM_DATE,     -- 实际终止日期
      P.PAY_UPTO_DATE                                                   AS PAY_UPTO_DATE,      -- 缴费截止日期
      P.INSUR_PERIOD_TYP                                                AS INSUR_PERIOD_TYP,   -- 保险期间类型
      P.INSUR_PERIOD                                                    AS INSUR_PERIOD,       -- 保险期间值
      P.PAY_PERIOD_TYP                                                  AS PAY_PERIOD_TYP,     -- 缴费期间类型
      P.PAY_PERIOD                                                      AS PAY_PERIOD,         -- 缴费期间值
      P.PAY_PATRN                                                       AS PAY_PATRN,          -- 缴费方式(0趸缴/1期缴)
      MAX(CASE WHEN P.TRAN_TYPE = '0' THEN P.PREM_TEXT END)               AS NEW_INSUR_AMT,      -- 首期保费(新单保费)
      -- 当前保险金额：未生效/失效=0；趸交满一年(TX_DATE起算)=0；期缴缴满=0；宽限期过60天未缴=0；其余=新单+续期累计
      CASE
          WHEN P.CONT_STATUS IS NULL OR P.CONT_STATUS NOT IN ('0','1','2') THEN 0
          WHEN P.CONT_STATUS = '0' THEN 0                                           -- 未生效
          WHEN P.CONT_STATUS = '2' THEN 0                                           -- 失效
          WHEN P.PAY_PATRN = '0'
           AND V_DATA_DATE >= ADD_MONTHS(MIN(P.ACCEPT_DATE_PARSED), 12) THEN 0      -- 趸交满一年
          WHEN P.PAY_PATRN = '1'
           AND P.PAY_PERIOD IS NOT NULL
           AND P.PAY_PERIOD > 0                                                     -- v2.3.1: 数值校验替代REGEXP_LIKE
           AND P.PAY_PERIOD_TYP IN ('12','1','2')
           AND V_DATA_DATE >= CASE P.PAY_PERIOD_TYP
                                   WHEN '12' THEN ADD_MONTHS(MIN(P.ACCEPT_DATE_PARSED), TO_NUMBER(P.PAY_PERIOD) * 12)
                                   WHEN '1'  THEN ADD_MONTHS(MIN(P.ACCEPT_DATE_PARSED), TO_NUMBER(P.PAY_PERIOD))
                                   WHEN '2'  THEN MIN(P.ACCEPT_DATE_PARSED) + TO_NUMBER(P.PAY_PERIOD)
                              END
          THEN 0                                                                    -- 期缴缴满(总期数×周期)
          WHEN P.PAY_PATRN = '1'
           AND P.LAST_RENEWAL_DATE_PARSED IS NOT NULL                               -- v2.4.0 F-05: 基于最近续期日期
           AND P.PAY_PERIOD_TYP IN ('12','1','2')
           AND V_DATA_DATE > CASE P.PAY_PERIOD_TYP
                                  WHEN '12' THEN ADD_MONTHS(P.LAST_RENEWAL_DATE_PARSED, 12) + 60
                                  WHEN '1'  THEN ADD_MONTHS(P.LAST_RENEWAL_DATE_PARSED, 1) + 60
                                  WHEN '2'  THEN P.LAST_RENEWAL_DATE_PARSED + 1 + 60
                             END
          THEN 0                                                                    -- 60天宽限期已过且未缴
          ELSE NVL(MAX(CASE WHEN P.TRAN_TYPE = '0' THEN P.ORD_AMT END), 0)
             + NVL(SUM(CASE WHEN P.TRAN_TYPE = '1' THEN P.ORD_AMT END), 0)         -- 新单保费+续期累计
      END                                                               AS INSUR_AMT,
      P.CONT_STATUS                                                     AS POLICY_STATE,       -- 保单状态: 0未生效/1正常/2失效
      NULL                                                              AS TX_TYP,             -- 交易类型(统一置空)
      P.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE -- 法人行号
  FROM (
      SELECT
          b.user_id                                                       AS CUST_ID,                  -- 客户编号
          '1'                                                             AS CUST_TYP,                 -- 客户类型(硬编码个人)
          c.ACC_NO                                                        AS ACCT_ID,                  -- 账户号
          e.PRODUCT_ID                                                    AS PRDKT_ID,                 -- 产品ID
          e.PRODUCT_NAME                                                  AS PRDKT_NAME,               -- 产品名称
          e.PRODUCT_BIG_TYPE                                              AS PRDKT_CATE_BIG,           -- 产品大类
          c.CONT_NO                                                       AS INSUR_BID_FORM_NO,        -- 投保单号
          c.plat_policy_serial                                            AS plat_policy_serial,       -- 保单平台流水号(GROUP BY用)
          c.CONT_STATUS                                                   AS CONT_STATUS,              -- 保单状态
          TO_DATE(c.ACCEPT_DATE, 'YYYYMMDD')                              AS ACCEPT_DATE_PARSED,       -- 投保日期(date型)
          AG.LAST_SUCCESS_TX_DATE                                         AS LAST_SUCCESS_TX_DATE,     -- v2.4.0: 来自预聚合TMP
          AG.ACTL_TERM_DATE_PARSED                                        AS ACTL_TERM_DATE_PARSED,    -- v2.4.0: 来自预聚合TMP
          AG.LAST_RENEWAL_DATE_PARSED                                     AS LAST_RENEWAL_DATE_PARSED, -- v2.4.0 F-05: 最近续期日期
          a.TRAN_TYPE                                                     AS TRAN_TYPE,                -- 交易类型
          a.ORD_AMT                                                       AS ORD_AMT,                  -- 交易金额
          TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')         AS BGN_INSUR_DATE,           -- 起保日期(源YYYYMMDD→YYYY-MM-DD)
          -- 保险期间结束日期(推算,仅参考)
          CASE
              WHEN d.VALID_PER_UNIT = '-1' THEN '9999-12-31'                                         -- 永久
              WHEN d.VALID_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{17}[0-9Xx]$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(f.CERT_ID, 7, 8), 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{15}$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(f.CERT_ID, 7, 6), 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '12' THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '1'  THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYYMMDD'), d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '2'  THEN TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYYMMDD') + d.VALID_PER_NUM, 'YYYY-MM-DD')
              ELSE NULL
          END                                                             AS CANCL_INSUR_DATE,         -- 保险期间结束日期(推算,仅参考)
          CASE
              WHEN d.PAY_TYPE = '0' THEN TO_CHAR(TO_DATE(c.ACCEPT_DATE, 'YYYYMMDD'), 'YYYYMMDD')     -- 趸交
              WHEN d.PAY_PER_UNIT = '12' THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '1'  THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYYMMDD'), d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '2'  THEN TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYYMMDD') + d.PAY_PER_NUM, 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{17}[0-9Xx]$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(f.CERT_ID, 7, 8), 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{15}$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(f.CERT_ID, 7, 6), 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '-1' THEN NULL                                                     -- 无期限
              ELSE NULL
          END                                                             AS PAY_UPTO_DATE,            -- 缴费截止日期
          d.VALID_PER_UNIT  AS INSUR_PERIOD_TYP,                                                       -- v2.3.1修正: 保险期间←VALID周期
          d.VALID_PER_NUM   AS INSUR_PERIOD,                                                           -- v2.3.1修正: 保险期间值←VALID数值
          d.PAY_PER_UNIT    AS PAY_PERIOD_TYP,                                                         -- v2.3.1修正: 缴费期间←PAY周期
          d.PAY_PER_NUM     AS PAY_PERIOD,                                                             -- v2.3.1修正: 缴费期间值←PAY数值
          d.PAY_TYPE        AS PAY_PATRN,                                                              -- 缴费方式(0趸缴/1期缴)
          SUBSTR(c.THROW_COM,1,6) AS TX_ORG,                                                           -- 交易机构
          c.CONT_SOURCE     AS TX_CHNL,                                                                -- 交易渠道
          SUBSTR(c.THROW_COM,1,6) AS MKT_ORG,                                                          -- 归属机构
          CASE WHEN SUBSTR(c.THROW_COM,1,6) LIKE '15%' THEN '1500'                                     -- 法人行号(THROW_COM推导)
               WHEN SUBSTR(c.THROW_COM,1,6) LIKE '12%' THEN '1200'
               WHEN SUBSTR(c.THROW_COM,1,6) LIKE '18%' THEN '1800'
               ELSE '9999' END                                           AS PERSN_LEGAL_BK_CODE
      FROM YBT_YBT_POLICY_BASE_INFO c
      INNER JOIN YBT_YBT_POLICY_FEE_LIST a
        ON a.plat_policy_serial = c.plat_policy_serial                                         -- 保单→交易明细
      LEFT JOIN TMP_DWD_ACCT_INSUR_FEE_AGGR AG                                                  -- v2.4.0: 预聚合FEE_LIST替代内联子查询
        ON AG.PLAT_POLICY_SERIAL = c.PLAT_POLICY_SERIAL
      INNER JOIN YBT_IB_LIST_PLAT b
        ON a.ord_pay_serial = b.plat_serial
       AND b.plat_trad_status = '2'                                                            -- 交易成功
      INNER JOIN YBT_YBT_POLICY_INSURANCE_INFO d
        ON c.plat_policy_serial = d.plat_policy_serial                                          -- 保单→险种信息
      INNER JOIN YBT_YBT_PRODUCT_INFO e
        ON c.product_id = e.product_id                                                         -- 保单→产品信息
      LEFT JOIN DWD_CUST_INDV_INFO f
        ON b.user_id = f.cust_id                                                               -- 客户信息(供身份证推算日期)
      WHERE b.user_id LIKE '1%'                                                                -- 个人客户
  ) P
  GROUP BY
      P.CUST_ID, P.CUST_TYP, P.ACCT_ID, P.PRDKT_ID, P.PRDKT_NAME, P.PRDKT_CATE_BIG,
      P.INSUR_BID_FORM_NO, P.plat_policy_serial, P.CONT_STATUS,
      P.BGN_INSUR_DATE, P.CANCL_INSUR_DATE, P.PAY_UPTO_DATE,
      P.INSUR_PERIOD_TYP, P.INSUR_PERIOD, P.PAY_PERIOD_TYP, P.PAY_PERIOD, P.PAY_PATRN,
      P.TX_ORG, P.TX_CHNL, P.MKT_ORG, P.PERSN_LEGAL_BK_CODE;

  COMMIT;   -- 快照落临时表

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := 'TMP1 完成: [A0b]生成保单级聚合快照(v2.4.0 F-05基于最近续期日期+EXT=F-10 TMP聚合)';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤TMP2: [A1] MERGE/UPSERT 快照 → DWD_ACCT_INSUR
  -- 作用：四键主键(CUST_ID, ACCT_ID, PRDKT_ID, INSUR_BID_FORM_NO)匹配，
  --       匹配→UPDATE刷新状态/余额/日期/机构，
  --       不匹配→INSERT新增保单。
  --       永不删除，终止保单保留。
  --       一次MERGE完成新增+更新(F-01修复)，
  --       POLICY_STATE/INSUR_AMT/TX_TYP全量刷新。
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  MERGE INTO DWD_ACCT_INSUR D
  USING TMP_DWD_ACCT_INSUR_SNAP S
     ON (D.CUST_ID           = S.CUST_ID
         AND D.ACCT_ID         = S.ACCT_ID
         AND D.PRDKT_ID        = S.PRDKT_ID
         AND D.INSUR_BID_FORM_NO = S.INSUR_BID_FORM_NO)
  WHEN MATCHED THEN UPDATE SET
      D.CUST_TYP           = S.CUST_TYP,
      D.PRDKT_NAME         = S.PRDKT_NAME,
      D.PRDKT_CATE_BIG     = S.PRDKT_CATE_BIG,
      D.TX_DATE            = S.TX_DATE,
      D.LAST_TX_DATE       = S.LAST_TX_DATE,
      D.TX_ORG             = S.TX_ORG,
      D.TX_CHNL            = S.TX_CHNL,
      D.MKT_ORG            = S.MKT_ORG,
      D.BGN_INSUR_DATE     = S.BGN_INSUR_DATE,
      D.CANCL_INSUR_DATE   = S.CANCL_INSUR_DATE,
      D.ACTL_TERM_DATE     = S.ACTL_TERM_DATE,
      D.PAY_UPTO_DATE      = S.PAY_UPTO_DATE,
      D.INSUR_PERIOD_TYP   = S.INSUR_PERIOD_TYP,
      D.INSUR_PERIOD       = S.INSUR_PERIOD,
      D.PAY_PERIOD_TYP     = S.PAY_PERIOD_TYP,
      D.PAY_PERIOD         = S.PAY_PERIOD,
      D.PAY_PATRN          = S.PAY_PATRN,
      D.NEW_INSUR_AMT      = S.NEW_INSUR_AMT,
      D.INSUR_AMT          = S.INSUR_AMT,
      D.POLICY_STATE       = S.POLICY_STATE,
      D.TX_TYP             = S.TX_TYP,
      D.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE
  WHEN NOT MATCHED THEN INSERT (
      CUST_ID, CUST_TYP, ACCT_ID, PRDKT_ID, PRDKT_NAME, PRDKT_CATE_BIG,
      INSUR_BID_FORM_NO, TX_DATE, LAST_TX_DATE, TX_ORG, TX_CHNL, MKT_ORG,
      BGN_INSUR_DATE, CANCL_INSUR_DATE, ACTL_TERM_DATE, PAY_UPTO_DATE,
      INSUR_PERIOD_TYP, INSUR_PERIOD, PAY_PERIOD_TYP, PAY_PERIOD,
      PAY_PATRN, NEW_INSUR_AMT, INSUR_AMT, POLICY_STATE, TX_TYP, PERSN_LEGAL_BK_CODE
  ) VALUES (
      S.CUST_ID, S.CUST_TYP, S.ACCT_ID, S.PRDKT_ID, S.PRDKT_NAME, S.PRDKT_CATE_BIG,
      S.INSUR_BID_FORM_NO, S.TX_DATE, S.LAST_TX_DATE, S.TX_ORG, S.TX_CHNL, S.MKT_ORG,
      S.BGN_INSUR_DATE, S.CANCL_INSUR_DATE, S.ACTL_TERM_DATE, S.PAY_UPTO_DATE,
      S.INSUR_PERIOD_TYP, S.INSUR_PERIOD, S.PAY_PERIOD_TYP, S.PAY_PERIOD,
      S.PAY_PATRN, S.NEW_INSUR_AMT, S.INSUR_AMT, S.POLICY_STATE, S.TX_TYP, S.PERSN_LEGAL_BK_CODE
  );

  V_CNT_MRG := SQL%ROWCOUNT;
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := 'TMP2 完成: [A1]MERGE/UPSERT快照→目标表 影响行=' || V_CNT_MRG
              || ' (v2.4.0 F-01修复+STEP独立)';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -- ***************************************
    -- 3. 异常处理区(捕获错误码并记录详细日志，整体回滚)
    -- ***************************************
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL
                        THEN NULL
                        ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END;
