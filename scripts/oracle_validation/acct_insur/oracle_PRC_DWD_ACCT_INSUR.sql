-- DROP PROCEDURE prc_dwd_acct_insur(in varchar, out int4);

CREATE OR REPLACE PROCEDURE prc_dwd_acct_insur(v_sysdat varchar, outcde OUT integer)
AS
  ------------------------------------------------------------------
  -- 报表名称: 保险账户处理
  -- 报表编号：PRC_DWD_ACCT_INSUR
  -- 处理周期：日
  -- 过程描述：单过程分段执行保险账户数据加工：
  --           2.1 生成保单级主档聚合快照（一次计算，供后续段落复用）
  --           2.2 新增逻辑：快照主键(CUST_ID,ACCT_ID,PRDKT_ID,INSUR_BID_FORM_NO)
  --               在目标表 DWD_ACCT_INSUR 中【不存在】时批量 INSERT
  --           2.3 更新逻辑：主键【已存在】时批量 UPDATE（刷新状态/余额/日期/机构）
  --           2.4 统一提交（新增+更新同一事务，失败整体回滚）
  --           永不删除，终止保单保留。
  -- 来源表：YBT_POLICY_BASE_INFO(保单信息表)、YBT_POLICY_FEE_LIST(保单交易明细表)、
  --         IBP_IB_LIST_PLAT(交易流水表)、YBT_POLICY_INSURANCE_INFO(保单承保险种信息表)、
  --         YBT_PRODUCT_INFO(保险产品信息表)、DWD_CUST_INDV_INFO(客户基本信息)
  -- 目标表：DWD_ACCT_INSUR(保险账户信息-保单级主档)、TMP_DWD_ACCT_INSUR_SNAP(聚合快照)
  -- 需求版本: v2.2.0
  -- 变更记录:
  --   v1.0.0 2026-06-30 初始版本
  --   v1.0.1 2026-07-28 字段映射修正(TX_TYP取TRAN_TYPE)、删除未使用变量、INSERT列顺序与DDL对齐
  --   v1.1.0 2026-08-03 新增NEW_INSUR_AMT、INSUR_AMT=新单+续期；TX_TYP置空；仅加载0/1交易(已被v2.0取代)
  --   v2.0.0 2026-08-03 保单级主档重构：UPSERT永不删除；POLICY_STATE(0/1/2)唯一状态判定源；
  --                    INSUR_AMT承担终止/缴费期满/60天宽限期清零；趸交满一年起算点=TX_DATE
  --   v2.1.0 2026-08-03 新增/更新逻辑分离(独立过程INS/UPD，已按评审要求合并回单过程)
  --   v2.2.0 2026-08-03 单过程分段执行新增与更新：快照一次计算 + 段落2.2新增 + 段落2.3更新，
  --                    参数验证、统一事务、批量/索引优化、字段与参数注释完整
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
  V_CNT_INS              INTEGER;     -- 段落2.2 新增行数
  V_CNT_UPD              INTEGER;     -- 段落2.3 更新行数
begin
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  V_START_DT := SYSDATE;

  -- 2.0 参数验证：V_SYSDAT 必填且为 8 位日期(YYYYMMDD)
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
      OUTCDE := -1;
      RETURN;
  END IF;
  V_DATA_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  --***************************************
  -- 2.1 生成保单级聚合快照（一次计算，供 2.2/2.3 段落复用）
  -- 作用：将 ODS 保单/交易/流水/险种/产品/客户聚合为保单级一行，
  --       避免新增与更新各自重复扫描 ODS。
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DWD_ACCT_INSUR_SNAP';

  INSERT INTO TMP_DWD_ACCT_INSUR_SNAP (
      CUST_ID, CUST_TYP, ACCT_ID, PRDKT_ID, PRDKT_NAME, PRDKT_CATE_BIG, INSUR_BID_FORM_NO,
      TX_DATE, LAST_TX_DATE, TX_ORG, TX_CHNL, MKT_ORG, BGN_INSUR_DATE, CANCL_INSUR_DATE,
      ACTL_TERM_DATE, PAY_UPTO_DATE, INSUR_PERIOD_TYP, INSUR_PERIOD, PAY_PERIOD_TYP, PAY_PERIOD,
      PAY_PATRN, NEW_INSUR_AMT, INSUR_AMT, POLICY_STATE, TX_TYP, PERSN_LEGAL_BK_CODE)
  SELECT
      P.CUST_ID                                                         AS CUST_ID,
      P.CUST_TYP                                                        AS CUST_TYP,
      P.ACCT_ID                                                         AS ACCT_ID,
      P.PRDKT_ID                                                        AS PRDKT_ID,
      P.PRDKT_NAME                                                      AS PRDKT_NAME,
      P.PRDKT_CATE_BIG                                                  AS PRDKT_CATE_BIG,
      P.INSUR_BID_FORM_NO                                               AS INSUR_BID_FORM_NO,
      TO_CHAR(MIN(P.TX_DATE_PARSED), 'YYYYMMDD')                        AS TX_DATE,      -- 首次交易日期
      TO_CHAR(MAX(P.TX_DATE_PARSED), 'YYYYMMDD')                        AS LAST_TX_DATE, -- 最近交易日期
      P.TX_ORG                                                          AS TX_ORG,
      P.TX_CHNL                                                         AS TX_CHNL,
      P.MKT_ORG                                                         AS MKT_ORG,
      P.BGN_INSUR_DATE                                                  AS BGN_INSUR_DATE,
      P.CANCL_INSUR_DATE                                                AS CANCL_INSUR_DATE,
      -- 实际终止日期：状态交易最新日期 → 状态=2 时回退 CANCL_INSUR_DATE（排除9999）
      COALESCE(
          (SELECT TO_CHAR(MAX(TO_DATE(SUBSTR(x.TX_DATE,1,10), 'YYYY-MM-DD')), 'YYYYMMDD')
             FROM YBT_POLICY_FEE_LIST x
            WHERE x.plat_policy_serial = P.plat_policy_serial
              AND x.TRAN_TYPE IN ('2','3','4','5','6','8')),
          CASE WHEN P.CONT_STATUS = '2'
                AND P.CANCL_INSUR_DATE IS NOT NULL
                AND P.CANCL_INSUR_DATE <> '9999-12-31'
               THEN TO_CHAR(TO_DATE(SUBSTR(P.CANCL_INSUR_DATE,1,10), 'YYYY-MM-DD'), 'YYYYMMDD')
          END)                                                          AS ACTL_TERM_DATE,
      P.PAY_UPTO_DATE                                                   AS PAY_UPTO_DATE,
      P.INSUR_PERIOD_TYP                                                AS INSUR_PERIOD_TYP,
      P.INSUR_PERIOD                                                    AS INSUR_PERIOD,
      P.PAY_PERIOD_TYP                                                  AS PAY_PERIOD_TYP,
      P.PAY_PERIOD                                                      AS PAY_PERIOD,
      P.PAY_PATRN                                                       AS PAY_PATRN,
      MAX(CASE WHEN P.TRAN_TYPE = '0' THEN P.ORD_AMT END)               AS NEW_INSUR_AMT,
      -- 当前保险金额：未生效/失效=0；趸交满一年(TX_DATE起算)=0；期缴缴满=0；宽限期过60天未缴=0；其余=新单+续期累计
      CASE
          WHEN P.CONT_STATUS IS NULL OR P.CONT_STATUS NOT IN ('0','1','2') THEN 0
          WHEN P.CONT_STATUS = '0' THEN 0
          WHEN P.CONT_STATUS = '2' THEN 0
          WHEN P.PAY_PATRN = '0'
           AND V_DATA_DATE >= ADD_MONTHS(MIN(P.TX_DATE_PARSED), 12) THEN 0
          WHEN P.PAY_PATRN = '1'
           AND P.PAY_PERIOD IS NOT NULL
           AND REGEXP_LIKE(P.PAY_PERIOD, '^[0-9]+$')
           AND P.PAY_PERIOD_TYP IN ('12','1','2')
           AND V_DATA_DATE >= CASE P.PAY_PERIOD_TYP
                                   WHEN '12' THEN ADD_MONTHS(MIN(P.TX_DATE_PARSED), TO_NUMBER(P.PAY_PERIOD) * 12)
                                   WHEN '1'  THEN ADD_MONTHS(MIN(P.TX_DATE_PARSED), TO_NUMBER(P.PAY_PERIOD))
                                   WHEN '2'  THEN MIN(P.TX_DATE_PARSED) + TO_NUMBER(P.PAY_PERIOD)
                              END
          THEN 0                                                        -- 期缴缴满(最后一期后再过一个缴费期间)
          WHEN P.PAY_PATRN = '1'
           AND P.PAY_PERIOD_TYP IN ('12','1','2')
           AND V_DATA_DATE > CASE P.PAY_PERIOD_TYP
                                  WHEN '12' THEN ADD_MONTHS(MIN(P.TX_DATE_PARSED),
                                              (1 + COUNT(CASE WHEN P.TRAN_TYPE = '1' THEN 1 END)) * 12) + 60
                                  WHEN '1'  THEN ADD_MONTHS(MIN(P.TX_DATE_PARSED),
                                              (1 + COUNT(CASE WHEN P.TRAN_TYPE = '1' THEN 1 END))) + 60
                                  WHEN '2'  THEN MIN(P.TX_DATE_PARSED)
                                              + (1 + COUNT(CASE WHEN P.TRAN_TYPE = '1' THEN 1 END)) + 60
                             END
          THEN 0                                                        -- 60天宽限期已过且未缴
          ELSE NVL(MAX(CASE WHEN P.TRAN_TYPE = '0' THEN P.ORD_AMT END), 0)
             + NVL(SUM(CASE WHEN P.TRAN_TYPE = '1' THEN P.ORD_AMT END), 0)
      END                                                               AS INSUR_AMT,
      P.CONT_STATUS                                                     AS POLICY_STATE,
      NULL                                                              AS TX_TYP,
      P.PERSN_LEGAL_BK_CODE                                             AS PERSN_LEGAL_BK_CODE
  FROM (
      SELECT
          b.user_id                                                       AS CUST_ID,
          '1'                                                             AS CUST_TYP,
          c.ACC_NO                                                        AS ACCT_ID,
          e.PRODUCT_ID                                                    AS PRDKT_ID,
          e.PRODUCT_NAME                                                  AS PRDKT_NAME,
          e.PRODUCT_BIG_TYPE                                              AS PRDKT_CATE_BIG,
          c.CONT_NO                                                       AS INSUR_BID_FORM_NO,
          c.plat_policy_serial                                            AS plat_policy_serial,
          c.CONT_STATUS                                                   AS CONT_STATUS,
          TO_DATE(SUBSTR(a.TX_DATE,1,10), 'YYYY-MM-DD')                   AS TX_DATE_PARSED, -- ODS交易日期(格式/字段名上线前核对)
          a.TRAN_TYPE                                                     AS TRAN_TYPE,
          a.ORD_AMT                                                       AS ORD_AMT,
          TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')       AS BGN_INSUR_DATE,
          -- 保险期间结束日期(推算,仅参考)
          CASE
              WHEN d.VALID_PER_UNIT = '-1' THEN '9999-12-31'
              WHEN d.VALID_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{17}[0-9Xx]$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(f.CERT_ID, 7, 8), 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{15}$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(f.CERT_ID, 7, 6), 'YYYYMMDD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '12' THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), 12 * d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '1'  THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), d.VALID_PER_NUM), 'YYYY-MM-DD')
              WHEN d.VALID_PER_UNIT = '2'  THEN TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD') + d.VALID_PER_NUM, 'YYYY-MM-DD')
              ELSE NULL
          END                                                             AS CANCL_INSUR_DATE,
          CASE
              WHEN d.PAY_TYPE = '0' THEN TO_CHAR(TO_DATE(c.ACCEPT_DATE, 'YYYY-MM-DD'), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '12' THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), 12 * d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '1'  THEN TO_CHAR(ADD_MONTHS(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD'), d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '2'  THEN TO_CHAR(TO_DATE(c.VALI_DATE, 'YYYY-MM-DD') + d.PAY_PER_NUM, 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{17}[0-9Xx]$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(f.CERT_ID, 7, 8), 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '0'
               AND REGEXP_LIKE(f.CERT_ID, '^[0-9]{15}$')
              THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(f.CERT_ID, 7, 6), 'YYYYMMDD'), 12 * d.PAY_PER_NUM), 'YYYYMMDD')
              WHEN d.PAY_PER_UNIT = '-1' THEN NULL
              ELSE NULL
          END                                                             AS PAY_UPTO_DATE,
          d.PAY_PER_UNIT    AS INSUR_PERIOD_TYP,
          d.PAY_PER_NUM     AS INSUR_PERIOD,
          d.VALID_PER_UNIT  AS PAY_PERIOD_TYP,
          d.VALID_PER_NUM   AS PAY_PERIOD,
          d.PAY_TYPE        AS PAY_PATRN,
          SUBSTR(c.THROW_COM,1,6) AS TX_ORG,
          c.CONT_SOURCE     AS TX_CHNL,
          SUBSTR(c.THROW_COM,1,6) AS MKT_ORG,
          CASE WHEN SUBSTR(c.THROW_COM,1,6) LIKE '15%' THEN '1500'
               WHEN SUBSTR(c.THROW_COM,1,6) LIKE '12%' THEN '1200'
               WHEN SUBSTR(c.THROW_COM,1,6) LIKE '18%' THEN '1800'
               ELSE '9999' END                                           AS PERSN_LEGAL_BK_CODE
      FROM YBT_POLICY_BASE_INFO c
      INNER JOIN YBT_POLICY_FEE_LIST a
        ON a.plat_policy_serial = c.plat_policy_serial
      INNER JOIN IBP_IB_LIST_PLAT b
        ON a.ord_pay_serial = b.plat_serial
       AND b.plat_trad_status = '2'
      INNER JOIN YBT_POLICY_INSURANCE_INFO d
        ON c.plat_policy_serial = d.plat_policy_serial
      INNER JOIN YBT_PRODUCT_INFO e
        ON c.product_id = e.product_id
      LEFT JOIN DWD_CUST_INDV_INFO f
        ON b.user_id = f.cust_id
      WHERE b.user_id LIKE '1%'
  ) P
  GROUP BY
      P.CUST_ID, P.CUST_TYP, P.ACCT_ID, P.PRDKT_ID, P.PRDKT_NAME, P.PRDKT_CATE_BIG,
      P.INSUR_BID_FORM_NO, P.plat_policy_serial, P.CONT_STATUS,
      P.BGN_INSUR_DATE, P.CANCL_INSUR_DATE, P.PAY_UPTO_DATE,
      P.INSUR_PERIOD_TYP, P.INSUR_PERIOD, P.PAY_PERIOD_TYP, P.PAY_PERIOD, P.PAY_PATRN,
      P.TX_ORG, P.TX_CHNL, P.MKT_ORG, P.PERSN_LEGAL_BK_CODE;

  COMMIT;   -- 快照落临时表，供后续段落读取

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.1 生成保单级聚合快照';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.2 新增逻辑
  -- 触发条件：快照保单主键在 DWD_ACCT_INSUR 中不存在（NOT EXISTS 走目标表主键索引）
  -- 批量 INSERT ... SELECT，整批集合操作
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_ACCT_INSUR (
      CUST_ID, CUST_TYP, ACCT_ID, PRDKT_ID, PRDKT_NAME, PRDKT_CATE_BIG, INSUR_BID_FORM_NO,
      TX_DATE, LAST_TX_DATE, TX_ORG, TX_CHNL, MKT_ORG, BGN_INSUR_DATE, CANCL_INSUR_DATE,
      ACTL_TERM_DATE, PAY_UPTO_DATE, INSUR_PERIOD_TYP, INSUR_PERIOD, PAY_PERIOD_TYP, PAY_PERIOD,
      PAY_PATRN, NEW_INSUR_AMT, INSUR_AMT, POLICY_STATE, TX_TYP, PERSN_LEGAL_BK_CODE)
  SELECT
      S.CUST_ID, S.CUST_TYP, S.ACCT_ID, S.PRDKT_ID, S.PRDKT_NAME, S.PRDKT_CATE_BIG, S.INSUR_BID_FORM_NO,
      S.TX_DATE, S.LAST_TX_DATE, S.TX_ORG, S.TX_CHNL, S.MKT_ORG, S.BGN_INSUR_DATE, S.CANCL_INSUR_DATE,
      S.ACTL_TERM_DATE, S.PAY_UPTO_DATE, S.INSUR_PERIOD_TYP, S.INSUR_PERIOD, S.PAY_PERIOD_TYP, S.PAY_PERIOD,
      S.PAY_PATRN, S.NEW_INSUR_AMT, S.INSUR_AMT, S.POLICY_STATE, S.TX_TYP, S.PERSN_LEGAL_BK_CODE
  FROM TMP_DWD_ACCT_INSUR_SNAP S
  WHERE NOT EXISTS (
      SELECT 1
        FROM DWD_ACCT_INSUR T
       WHERE T.CUST_ID            = S.CUST_ID
         AND T.ACCT_ID            = S.ACCT_ID
         AND T.PRDKT_ID           = S.PRDKT_ID
         AND T.INSUR_BID_FORM_NO  = S.INSUR_BID_FORM_NO
  );
  V_CNT_INS := SQL%ROWCOUNT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.2 新增保险保单行数: ' || TO_CHAR(V_CNT_INS);
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.3 更新逻辑
  -- 触发条件：快照保单主键在 DWD_ACCT_INSUR 中已存在
  -- 批量 MERGE 仅 WHEN MATCHED（新增由 2.2 段落负责），ON 走目标表主键索引
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  MERGE INTO DWD_ACCT_INSUR T
  USING TMP_DWD_ACCT_INSUR_SNAP S
  ON (T.CUST_ID = S.CUST_ID AND T.ACCT_ID = S.ACCT_ID
      AND T.PRDKT_ID = S.PRDKT_ID AND T.INSUR_BID_FORM_NO = S.INSUR_BID_FORM_NO)
  WHEN MATCHED THEN UPDATE SET
      T.CUST_TYP          = S.CUST_TYP,
      T.PRDKT_NAME        = S.PRDKT_NAME,
      T.PRDKT_CATE_BIG    = S.PRDKT_CATE_BIG,
      T.TX_DATE           = S.TX_DATE,
      T.LAST_TX_DATE      = S.LAST_TX_DATE,
      T.TX_ORG            = S.TX_ORG,
      T.TX_CHNL           = S.TX_CHNL,
      T.MKT_ORG           = S.MKT_ORG,
      T.BGN_INSUR_DATE    = S.BGN_INSUR_DATE,
      T.CANCL_INSUR_DATE  = S.CANCL_INSUR_DATE,
      T.ACTL_TERM_DATE    = S.ACTL_TERM_DATE,
      T.PAY_UPTO_DATE     = S.PAY_UPTO_DATE,
      T.INSUR_PERIOD_TYP  = S.INSUR_PERIOD_TYP,
      T.INSUR_PERIOD      = S.INSUR_PERIOD,
      T.PAY_PERIOD_TYP    = S.PAY_PERIOD_TYP,
      T.PAY_PERIOD        = S.PAY_PERIOD,
      T.PAY_PATRN         = S.PAY_PATRN,
      T.NEW_INSUR_AMT     = S.NEW_INSUR_AMT,
      T.INSUR_AMT         = S.INSUR_AMT,
      T.POLICY_STATE      = S.POLICY_STATE,
      T.TX_TYP            = S.TX_TYP,
      T.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE;
  V_CNT_UPD := SQL%ROWCOUNT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2.3 更新保险保单行数: ' || TO_CHAR(V_CNT_UPD);
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.4 统一提交（新增+更新同一事务；任一失败由异常区整体回滚）
  --***************************************
  COMMIT;
  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '保险账户处理完成';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -- ***************************************
    -- 3. 异常处理区(捕获错误码并记录详细日志，整体回滚)
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
/