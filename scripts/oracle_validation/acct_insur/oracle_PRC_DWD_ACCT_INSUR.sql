-- DROP PROCEDURE prc_dwd_acct_insur(in varchar, out int4);

CREATE OR REPLACE PROCEDURE prc_dwd_acct_insur(v_sysdat varchar, outcde OUT integer)
AS
  ------------------------------------------------------------------
  -- 报表名称: 保险账户处理
  -- 报表编号: PRC_DWD_ACCT_INSUR
  -- 处理周期: 日
  -- 过程描述: 从 ODS 保险保单与交易数据生成 DWD 保险账户快照
  -- 目标表: DWD_ACCT_INSUR
  -- 需求版本: v3.3.0
  -- 变更记录:
  --   v3.3.0 2026-08-13 单次集合化写入，移除过程内三张 TMP 表的
  --                    清理、写入和回读；保留原明细、日期聚合和四键聚合口径
  -- 适配数据库: 人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  V_PRC_DESC     VARCHAR(100) := '保险账户处理';
  V_PRC_NAME     VARCHAR(32)  := 'PRC_DWD_ACCT_INSUR';
  V_LOG_MSG      VARCHAR(4000);
  V_LOG_FLG      INTEGER;
  V_LOG_BUTTON   INTEGER := 1;
  V_NO_ID        VARCHAR(10);
  V_BGN_DATE     DATE;
  V_END_DATE     DATE;
  V_DURA_DATE    INTEGER;
  V_DATA_DATE    DATE;
  V_CNT_INS      INTEGER;
BEGIN
  ------------------------------------------------------------------
  -- 步骤1: 参数校验并清理目标表
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  IF V_SYSDAT IS NULL OR LENGTH(V_SYSDAT) != 8 THEN
      OUTCDE := -1;
      RETURN;
  END IF;
  V_DATA_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');

  DELETE FROM DWD_ACCT_INSUR;
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '1 完成: 参数校验+清理目标数据';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤2: 明细、交易日期预聚合和四键快照在同一集合 SQL 内完成
  ------------------------------------------------------------------
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_ACCT_INSUR (
      cust_id, cust_typ, acct_id, prdkt_id, prdkt_name, prdkt_cate_big,
      insur_bid_form_no, tx_date, last_tx_date, tx_org, tx_chnl, mkt_org,
      bgn_insur_date, cancl_insur_date, actl_term_date, pay_upto_date,
      insur_period_typ, insur_period, pay_period_typ, pay_period, pay_patrn,
      new_insur_amt, insur_amt, policy_state, tx_typ, persn_legal_bk_code
  )
  WITH detail AS (
      SELECT
          c.plat_policy_serial,
          a.tran_type,
          a.ord_amt,
          a.ord_tran_status,
          a.ord_create_date,
          b.user_id AS cust_id,
          '1' AS cust_typ,
          c.acc_no AS acct_id,
          e.product_id AS prdkt_id,
          e.product_name AS prdkt_name,
          e.product_big_type AS prdkt_cate_big,
          c.cont_no AS insur_bid_form_no,
          c.cont_status,
          TO_DATE(c.accept_date, 'YYYYMMDD') AS accept_date_parsed,
          TO_CHAR(TO_DATE(c.vali_date, 'YYYYMMDD'), 'YYYY-MM-DD') AS bgn_insur_date,
          d.valid_per_unit,
          d.valid_per_num,
          d.pay_per_unit,
          d.pay_per_num,
          d.pay_type,
          SUBSTR(c.throw_com, 1, 6) AS tx_org,
          c.cont_source AS tx_chnl,
          SUBSTR(c.throw_com, 1, 6) AS mkt_org,
          CASE
              WHEN SUBSTR(c.throw_com, 1, 6) LIKE '15%' THEN '1500'
              WHEN SUBSTR(c.throw_com, 1, 6) LIKE '12%' THEN '1200'
              WHEN SUBSTR(c.throw_com, 1, 6) LIKE '18%' THEN '1800'
              ELSE '9999'
          END AS persn_legal_bk_code,
          f.cert_id,
          c.vali_date
      FROM YBT_YBT_POLICY_BASE_INFO c
      INNER JOIN YBT_YBT_POLICY_FEE_LIST a
        ON a.plat_policy_serial = c.plat_policy_serial
       AND a.ord_tran_status = '2'
      INNER JOIN IBP_IB_LIST_PLAT b
        ON a.ord_pay_serial = b.plat_serial
       AND b.plat_trad_status = '2'
      INNER JOIN YBT_YBT_POLICY_INSURANCE_INFO d
        ON c.plat_policy_serial = d.plat_policy_serial
      INNER JOIN YBT_YBT_PRODUCT_INFO e
        ON c.product_id = e.product_id
      LEFT JOIN (
          SELECT DISTINCT cust_id, cert_id
          FROM DWD_CUST_INDV_INFO
      ) f
        ON b.user_id = f.cust_id
      WHERE b.user_id LIKE '1%'
        AND c.cont_no IS NOT NULL
  ),
  fee_aggr AS (
      SELECT
          d.plat_policy_serial,
          MAX(TO_DATE(TRIM(d.ord_create_date), 'YYYYMMDD')) AS last_success_tx_date,
          MAX(CASE
                  WHEN d.tran_type IN ('2', '3', '4', '5', '6', '8')
                  THEN TO_DATE(TRIM(d.ord_create_date), 'YYYYMMDD')
              END) AS actl_term_date_parsed,
          MAX(CASE
                  WHEN d.tran_type = '1'
                  THEN TO_DATE(TRIM(d.ord_create_date), 'YYYYMMDD')
              END) AS last_renewal_date_parsed
      FROM detail d
      WHERE d.ord_tran_status = '2'
      GROUP BY d.plat_policy_serial
  )
  SELECT
      d.cust_id,
      d.cust_typ,
      d.acct_id,
      d.prdkt_id,
      d.prdkt_name,
      d.prdkt_cate_big,
      d.insur_bid_form_no,
      TO_CHAR(MIN(d.accept_date_parsed), 'YYYYMMDD'),
      COALESCE(
          TO_CHAR(MAX(ag.last_success_tx_date), 'YYYYMMDD'),
          TO_CHAR(MIN(d.accept_date_parsed), 'YYYYMMDD')
      ),
      d.tx_org,
      d.tx_chnl,
      d.mkt_org,
      d.bgn_insur_date,
      CASE
          WHEN MIN(d.valid_per_unit) = '-1' THEN '9999-12-31'
          WHEN MIN(d.valid_per_unit) = '0' AND LENGTH(MIN(d.cert_id)) = 18
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(MIN(d.cert_id), 7, 8), 'YYYYMMDD'),
                                  12 * MIN(d.valid_per_num)), 'YYYY-MM-DD')
          WHEN MIN(d.valid_per_unit) = '0' AND LENGTH(MIN(d.cert_id)) = 15
          THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(MIN(d.cert_id), 7, 6), 'YYYYMMDD'),
                                  12 * MIN(d.valid_per_num)), 'YYYY-MM-DD')
          WHEN MIN(d.valid_per_unit) = '12'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(d.vali_date), 'YYYYMMDD'),
                                  12 * MIN(d.valid_per_num)), 'YYYY-MM-DD')
          WHEN MIN(d.valid_per_unit) = '1'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(d.vali_date), 'YYYYMMDD'),
                                  MIN(d.valid_per_num)), 'YYYY-MM-DD')
          WHEN MIN(d.valid_per_unit) = '2'
          THEN TO_CHAR(TO_DATE(MIN(d.vali_date), 'YYYYMMDD') + MIN(d.valid_per_num),
                       'YYYY-MM-DD')
      END,
      COALESCE(
          TO_CHAR(MAX(ag.actl_term_date_parsed), 'YYYYMMDD'),
          CASE
              WHEN MIN(d.cont_status) = '2' AND MIN(d.vali_date) IS NOT NULL
              THEN TO_CHAR(TO_DATE(MIN(d.vali_date), 'YYYYMMDD'), 'YYYYMMDD')
          END
      ),
      CASE
          WHEN MIN(d.pay_type) = '0'
          THEN TO_CHAR(MIN(d.accept_date_parsed), 'YYYYMMDD')
          WHEN MIN(d.pay_per_unit) = '12'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(d.vali_date), 'YYYYMMDD'),
                                  12 * MIN(d.pay_per_num)), 'YYYYMMDD')
          WHEN MIN(d.pay_per_unit) = '1'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(d.vali_date), 'YYYYMMDD'),
                                  MIN(d.pay_per_num)), 'YYYYMMDD')
          WHEN MIN(d.pay_per_unit) = '2'
          THEN TO_CHAR(TO_DATE(MIN(d.vali_date), 'YYYYMMDD') + MIN(d.pay_per_num),
                       'YYYYMMDD')
          WHEN MIN(d.pay_per_unit) = '0' AND LENGTH(MIN(d.cert_id)) = 18
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(MIN(d.cert_id), 7, 8), 'YYYYMMDD'),
                                  12 * MIN(d.pay_per_num)), 'YYYYMMDD')
          WHEN MIN(d.pay_per_unit) = '0' AND LENGTH(MIN(d.cert_id)) = 15
          THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(MIN(d.cert_id), 7, 6), 'YYYYMMDD'),
                                  12 * MIN(d.pay_per_num)), 'YYYYMMDD')
      END,
      MIN(d.valid_per_unit),
      MIN(d.valid_per_num),
      MIN(d.pay_per_unit),
      MIN(d.pay_per_num),
      MIN(d.pay_type),
      SUM(CASE WHEN d.tran_type = '0' THEN d.ord_amt ELSE 0 END),
      CASE
          WHEN MIN(d.cont_status) IS NULL
            OR MIN(d.cont_status) NOT IN ('0', '1', '2') THEN 0
          WHEN MIN(d.cont_status) = '0' THEN 0
          WHEN MIN(d.cont_status) = '2' THEN 0
          WHEN MIN(d.pay_type) = '0'
           AND V_DATA_DATE >= ADD_MONTHS(MIN(d.accept_date_parsed), 12) THEN 0
          WHEN MIN(d.pay_type) = '1'
           AND MIN(d.pay_per_num) IS NOT NULL
           AND MIN(d.pay_per_num) > 0
           AND MIN(d.pay_per_unit) IN ('12', '1', '2')
           AND V_DATA_DATE >= CASE MIN(d.pay_per_unit)
                                   WHEN '12' THEN ADD_MONTHS(MIN(d.accept_date_parsed),
                                                             MIN(d.pay_per_num) * 12)
                                   WHEN '1' THEN ADD_MONTHS(MIN(d.accept_date_parsed),
                                                            MIN(d.pay_per_num))
                                   WHEN '2' THEN MIN(d.accept_date_parsed) + MIN(d.pay_per_num)
                               END THEN 0
          WHEN MIN(d.pay_type) = '1'
           AND MAX(ag.last_renewal_date_parsed) IS NOT NULL
           AND MIN(d.pay_per_unit) IN ('12', '1', '2')
           AND V_DATA_DATE > CASE MIN(d.pay_per_unit)
                                  WHEN '12' THEN ADD_MONTHS(MAX(ag.last_renewal_date_parsed), 12) + 60
                                  WHEN '1' THEN ADD_MONTHS(MAX(ag.last_renewal_date_parsed), 1) + 60
                                  WHEN '2' THEN MAX(ag.last_renewal_date_parsed) + 1 + 60
                              END THEN 0
          ELSE SUM(CASE WHEN d.tran_type = '0' THEN d.ord_amt ELSE 0 END)
             + SUM(CASE WHEN d.tran_type = '1' THEN d.ord_amt ELSE 0 END)
      END,
      MIN(d.cont_status),
      NULL,
      MIN(d.persn_legal_bk_code)
  FROM detail d
  LEFT JOIN fee_aggr ag
    ON ag.plat_policy_serial = d.plat_policy_serial
  GROUP BY
      d.cust_id, d.cust_typ, d.acct_id, d.prdkt_id, d.prdkt_name,
      d.prdkt_cate_big, d.insur_bid_form_no, d.tx_org, d.tx_chnl,
      d.mkt_org, d.bgn_insur_date;

  V_CNT_INS := SQL%ROWCOUNT;
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2 完成: 集合化写入 影响行=' || V_CNT_INS;
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -3;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE
                       WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL THEN NULL
                       ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END;
/
