-- DROP PROCEDURE crmdm.prc_dwd_acct_insur(in varchar, out int4);

CREATE OR REPLACE PROCEDURE crmdm.prc_dwd_acct_insur(v_sysdat varchar, outcde OUT integer)
AS
  ------------------------------------------------------------------
  -- 报表名称: 保险账户处理
  -- 报表编号：PRC_DWD_ACCT_INSUR
  -- 处理周期：日
  -- 过程描述：两层架构(明细层→聚合层)加工保险账户数据
  -- 来源表：YBT_YBT_POLICY_BASE_INFO、YBT_YBT_POLICY_FEE_LIST、YBT_IB_LIST_PLAT、
  --         YBT_YBT_POLICY_INSURANCE_INFO、YBT_YBT_PRODUCT_INFO、DWD_CUST_INDV_INFO
  -- 目标表：DWD_ACCT_INSUR
  -- 需求版本: v3.2.0
  -- 适配数据库：人大金仓 Oracle 兼容模式
  ------------------------------------------------------------------
  V_PRC_DESC     VARCHAR(100) := '保险账户处理';   -- 过程描述，用于SYS_PRC_STEP_LOGS日志标识
  V_PRC_NAME     VARCHAR(32)  := 'PRC_DWD_ACCT_INSUR'; -- 过程编号，对应报表编号
  V_LOG_MSG      VARCHAR(4000);                     -- 日志消息缓存，拼接各步骤日志描述文本
  V_START_DT     DATE;                              -- 过程开始时间，记录整体执行起始时刻
  V_LOG_FLG      INTEGER;                           -- 日志标记，0=正常，-3=异常
  V_LOG_BUTTON   INTEGER := 1;                      -- 日志开关，固定为1（启用日志记录）
  V_NO_ID        VARCHAR(10);                       -- 步骤编号，取值1~5，用于SYS_PRC_STEP_LOGS步骤标识
  V_BGN_DATE     DATE;                              -- 步骤开始时间，记录当前步骤开始时刻，用于计算耗时
  V_END_DATE     DATE;                              -- 步骤结束时间，记录当前步骤结束时刻
  V_DURA_DATE    INTEGER;                           -- 步骤耗时(秒)，= TRUNC((V_END_DATE - V_BGN_DATE) * 86400)
  V_DATA_DATE    DATE;                              -- 加工日期，由V_SYSDAT转换，用于INSUR_AMT清零条件判断
  V_CNT_INS      INTEGER;                           -- INSERT影响行数，步骤5写入后由SQL%ROWCOUNT赋值
BEGIN
  V_START_DT := SYSDATE;

  ------------------------------------------------------------------
  -- 步骤1: 参数校验 + 目标表当日清理 + TMP表清空
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- V_SYSDAT 必填且为8位字符串(YYYYMMDD)，否则返回-1
  IF V_SYSDAT IS NULL OR LENGTH(V_SYSDAT) != 8 THEN
      OUTCDE := -1;    -- 返回码：-1=参数校验失败
      RETURN;
  END IF;
  V_DATA_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');   -- 将8位字符串日期转换为DATE，用于INSUR_AMT清零条件

  DELETE FROM DWD_ACCT_INSUR;                                 -- 清理当日数据
  DELETE FROM TMP_DWD_ACCT_INSUR_DETAIL;                      -- 清空明细层临时表
  DELETE FROM TMP_DWD_ACCT_INSUR_FEE_AGGR;                    -- 清空预聚合临时表
  DELETE FROM TMP_DWD_ACCT_INSUR_SNAP;                        -- 清空聚合层快照表
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '1 完成: 参数校验+清理目标数据+TMP表';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤2: [明细层] 构建明细表，PLAT_POLICY_SERIAL+INSURANCE_CODE+TRAN_TYPE 粒度
  --        JOIN 条件强制 ORD_TRAN_STATUS='2'，仅缴费成功的交易进入明细层
  ------------------------------------------------------------------
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWD_ACCT_INSUR_DETAIL (
      plat_policy_serial,  -- 保单平台流水号(主键)，唯一标识一笔保单业务
      insurance_code,      -- 险种代码(主键)，标识保单下的具体险种
      tran_type,           -- 交易类型(主键)，0=新单/1=续期/2=撤单/3=退保/4=退保/5=满期/6=理赔/7=保全/8=终止撤销/9=复效
      ord_amt,             -- 交易金额-保费，该笔交易的保费金额
      ord_tran_status,     -- 交易状态，固定为'2'=缴费成功，由JOIN条件保证
      ord_create_date,     -- 订单创建日期(主键)，格式YYYYMMDD
      cust_id,             -- 客户编号，以'1'开头的个人客户
      cust_typ,            -- 客户类型，固定为'1'=个人客户
      acct_id,             -- 账户(四键主键)，客户银行卡号
      prdkt_id,            -- 产品ID(四键主键)
      prdkt_name,          -- 产品名称
      prdkt_cate_big,      -- 产品大类
      insur_bid_form_no,   -- 投保单号(四键主键)，保险单号
      cont_status,         -- 保单状态，0=未生效/1=正常/2=失效
      accept_date_parsed,  -- 投保日期(DATE型)，由ACCEPT_DATE(YYYYMMDD)转换
      bgn_insur_date,      -- 起保日期(YYYY-MM-DD)，由VALI_DATE(YYYYMMDD)转换
      valid_per_unit,      -- 保险期间类型，-1=永久/0=保至年龄/12=年/1=月/2=日
      valid_per_num,       -- 保险期间值，与VALID_PER_UNIT配合使用
      pay_per_unit,        -- 缴费期间类型，-1=无期限/0=保至年龄/12=年/1=月/2=日
      pay_per_num,         -- 缴费期间值，与PAY_PER_UNIT配合使用
      pay_type,            -- 缴费方式，0=趸缴(一次性)/1=期缴(分期)
      tx_org,              -- 交易机构，从THROW_COM截取前6位
      tx_chnl,             -- 交易渠道，1=柜面/2=手机银行/3=保险公司
      mkt_org,             -- 归属机构，与TX_ORG同源
      persn_legal_bk_code, -- 法人行号，由THROW_COM前2位推导：15→1500/12→1200/18→1800/其他→9999
      cert_id,             -- 证件号码，来自DWD_CUST_INDV_INFO，用于身份证推算日期
      vali_date            -- 起保日期(YYYYMMDD)，保持源格式，供聚合层日期计算
  )
  SELECT
      c.plat_policy_serial,                                                      -- 保单平台流水号
      d.insurance_code,                                                          -- 险种代码
      a.tran_type,                                                               -- 交易类型
      a.ord_amt,                                                                 -- 交易金额(保费)
      a.ord_tran_status,                                                         -- 交易状态
      a.ord_create_date,                                                         -- 订单创建日期
      b.user_id,                                                                 -- 客户编号
      '1',                                                                       -- 客户类型，固定为'1'=个人客户
      c.acc_no,                                                                  -- 账户，客户银行卡号
      e.product_id,                                                              -- 产品ID
      e.product_name,                                                            -- 产品名称
      e.product_big_type,                                                        -- 产品大类
      c.cont_no,                                                                 -- 投保单号/保险单号
      c.cont_status,                                                             -- 保单状态
      TO_DATE(c.accept_date, 'YYYYMMDD'),                                        -- 投保日期，YYYYMMDD→DATE
      TO_CHAR(TO_DATE(c.vali_date, 'YYYYMMDD'), 'YYYY-MM-DD'),                   -- 起保日期，YYYYMMDD→YYYY-MM-DD
      d.valid_per_unit,                                                          -- 保险期间类型
      d.valid_per_num,                                                           -- 保险期间值
      d.pay_per_unit,                                                            -- 缴费期间类型
      d.pay_per_num,                                                             -- 缴费期间值
      d.pay_type,                                                                -- 缴费方式
      SUBSTR(c.throw_com, 1, 6),                                                 -- 交易机构，截取投保网点编码前6位
      c.cont_source,                                                             -- 交易渠道
      SUBSTR(c.throw_com, 1, 6),                                                 -- 归属机构，与TX_ORG同源
      -- 法人行号推导：15开头→1500，12开头→1200，18开头→1800，其他→9999
      CASE WHEN SUBSTR(c.throw_com, 1, 6) LIKE '15%' THEN '1500'
           WHEN SUBSTR(c.throw_com, 1, 6) LIKE '12%' THEN '1200'
           WHEN SUBSTR(c.throw_com, 1, 6) LIKE '18%' THEN '1800'
           ELSE '9999' END,
      f.cert_id,                                                                 -- 证件号码
      c.vali_date                                                                -- 起保日期(YYYYMMDD)
  FROM YBT_YBT_POLICY_BASE_INFO c                                    -- 保单基本信息表（驱动表）
  INNER JOIN YBT_YBT_POLICY_FEE_LIST a                               -- 保单交易明细表
    ON a.plat_policy_serial = c.plat_policy_serial
   AND a.ord_tran_status = '2'                                       -- 仅缴费成功的交易(0=未缴费/1=处理中/2=成功/3=失败)
  INNER JOIN YBT_IB_LIST_PLAT b                                      -- 交易流水表
    ON a.ord_pay_serial = b.plat_serial
   AND b.plat_trad_status = '2'                                      -- 仅交易成功的流水
  INNER JOIN YBT_YBT_POLICY_INSURANCE_INFO d                         -- 保单承保险种信息表
    ON c.plat_policy_serial = d.plat_policy_serial
  INNER JOIN YBT_YBT_PRODUCT_INFO e                                  -- 保险产品信息表
    ON c.product_id = e.product_id
  LEFT JOIN DWD_CUST_INDV_INFO f                                     -- 客户基本信息表（LEFT JOIN，可能无匹配）
    ON b.user_id = f.cust_id
  WHERE b.user_id LIKE '1%';                                         -- 仅个人客户

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2 完成: [明细层]';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: [预聚合] 从明细层聚合交易日期 → TMP_DWD_ACCT_INSUR_FEE_AGGR
  --        last_success_tx_date:    最近缴费成功日期(ORD_TRAN_STATUS='2')
  --        actl_term_date_parsed:   最近终止交易日期(TRAN_TYPE IN 2/3/4/5/6/8)
  --        last_renewal_date_parsed: 最近续期日期(TRAN_TYPE='1')
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWD_ACCT_INSUR_FEE_AGGR (
      plat_policy_serial,       -- 保单平台流水号，GROUP BY分组键
      last_success_tx_date,     -- 最近缴费成功日期(DATE)，max(ORD_CREATE_DATE) where ORD_TRAN_STATUS='2'
      actl_term_date_parsed,    -- 最近终止交易日期(DATE)，max(ORD_CREATE_DATE) where TRAN_TYPE IN 终止类型
      last_renewal_date_parsed  -- 最近续期日期(DATE)，max(ORD_CREATE_DATE) where TRAN_TYPE='1'
  )
  SELECT D.plat_policy_serial,
         -- 最近缴费成功日期：ORD_CREATE_DATE→TO_DATE，仅ORD_TRAN_STATUS='2'且日期有效
         MAX(TO_DATE(TRIM(D.ord_create_date), 'YYYYMMDD')),
         -- 最近终止交易日期：撤单(2)/退保(3/4)/满期(5)/理赔(6)/终止撤销(8)
         MAX(CASE WHEN D.tran_type IN ('2','3','4','5','6','8')
                  THEN TO_DATE(TRIM(D.ord_create_date), 'YYYYMMDD') END),
         -- 最近续期日期：TRAN_TYPE='1'(续期)
         MAX(CASE WHEN D.tran_type = '1'
                  THEN TO_DATE(TRIM(D.ord_create_date), 'YYYYMMDD') END)
    FROM TMP_DWD_ACCT_INSUR_DETAIL D
    WHERE D.ord_tran_status = '2'
GROUP BY D.plat_policy_serial;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '3 完成: [预聚合]';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤4: [聚合层] 明细层+预聚合层按四键主键聚合 → TMP_DWD_ACCT_INSUR_SNAP
  --        CANCL_INSUR_DATE: 按VALID_PER_UNIT推算(-1永久/0保至年龄/12年/1月/2日)
  --        PAY_UPTO_DATE:    按PAY_PER_UNIT推算(0趸交/-1无期限/12年/1月/2日)
  --        INSUR_AMT 清零规则: 未生效/失效/趸交满一年/期缴缴满/宽限期过60天
  ------------------------------------------------------------------
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWD_ACCT_INSUR_SNAP (
      cust_id,             -- 客户编号(四键主键)
      cust_typ,            -- 客户类型，固定为'1'=个人客户
      acct_id,             -- 账户(四键主键)，银行卡号
      prdkt_id,            -- 产品ID(四键主键)
      prdkt_name,          -- 产品名称
      prdkt_cate_big,      -- 产品大类
      insur_bid_form_no,   -- 投保单号(四键主键)，保险单号
      tx_date,             -- 交易日期(YYYYMMDD)，最小投保日期
      last_tx_date,        -- 最近交易日期(YYYYMMDD)，最近缴费成功日期，无则回退投保日期
      tx_org,              -- 交易机构，投保网点编码前6位
      tx_chnl,             -- 交易渠道，1=柜面/2=手机银行/3=保险公司
      mkt_org,             -- 归属机构，与TX_ORG同源
      bgn_insur_date,      -- 起保日期(YYYY-MM-DD)
      cancl_insur_date,    -- 保险期间结束日期(YYYY-MM-DD)，按VALID_PER_UNIT推算
      actl_term_date,      -- 实际终止日期(YYYYMMDD)，取终止交易日期或保单失效回退
      pay_upto_date,       -- 缴费截止日期(YYYYMMDD)，按PAY_PER_UNIT推算
      insur_period_typ,    -- 保险期间类型，-1=永久/0=保至年龄/12=年/1=月/2=日
      insur_period,        -- 保险期间值
      pay_period_typ,      -- 缴费期间类型，-1=无期限/0=保至年龄/12=年/1=月/2=日
      pay_period,          -- 缴费期间值
      pay_patrn,           -- 缴费方式，0=趸缴/1=期缴
      new_insur_amt,       -- 首期保费，新单(TRAN_TYPE='0')保费累计
      insur_amt,           -- 当前保险金额，新单保费+续期累计，受5种清零规则约束
      policy_state,        -- 保单状态，0=未生效/1=正常/2=失效
      tx_typ,              -- 交易类型，当前置空
      persn_legal_bk_code  -- 法人行号，由投保网点前2位推导
  )
  SELECT
      D.cust_id,                                                        -- 客户编号
      D.cust_typ,                                                       -- 客户类型
      D.acct_id,                                                        -- 账户
      D.prdkt_id,                                                       -- 产品ID
      D.prdkt_name,                                                     -- 产品名称
      D.prdkt_cate_big,                                                 -- 产品大类
      D.insur_bid_form_no,                                              -- 投保单号
      TO_CHAR(MIN(D.accept_date_parsed), 'YYYYMMDD'),                   -- 交易日期，取最小投保日期
      -- 最近交易日期：COALESCE(最近缴费成功日期, 投保日期回退)
      COALESCE(TO_CHAR(MAX(AG.last_success_tx_date), 'YYYYMMDD'),
               TO_CHAR(MIN(D.accept_date_parsed), 'YYYYMMDD')),
      D.tx_org,                                                         -- 交易机构
      D.tx_chnl,                                                        -- 交易渠道
      D.mkt_org,                                                        -- 归属机构
      D.bgn_insur_date,                                                 -- 起保日期
      -- 保险期间结束日期推算：-1=永久→9999-12-31，0=保至年龄→身份证推算，12=年/1=月/2=日
      CASE
          WHEN MIN(D.valid_per_unit) = '-1' THEN '9999-12-31'           -- 永久有效
          WHEN MIN(D.valid_per_unit) = '0'
           AND LENGTH(MIN(D.cert_id)) = 18
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(MIN(D.cert_id), 7, 8), 'YYYYMMDD'),
                                  12 * MIN(D.valid_per_num)), 'YYYY-MM-DD') -- 18位身份证推算
          WHEN MIN(D.valid_per_unit) = '0'
           AND LENGTH(MIN(D.cert_id)) = 15
          THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(MIN(D.cert_id), 7, 6), 'YYYYMMDD'),
                                  12 * MIN(D.valid_per_num)), 'YYYY-MM-DD') -- 15位身份证推算
          WHEN MIN(D.valid_per_unit) = '12'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(D.vali_date), 'YYYYMMDD'),
                                  12 * MIN(D.valid_per_num)), 'YYYY-MM-DD') -- 年单位
          WHEN MIN(D.valid_per_unit) = '1'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(D.vali_date), 'YYYYMMDD'),
                                  MIN(D.valid_per_num)), 'YYYY-MM-DD')      -- 月单位
          WHEN MIN(D.valid_per_unit) = '2'
          THEN TO_CHAR(TO_DATE(MIN(D.vali_date), 'YYYYMMDD') + MIN(D.valid_per_num),
                       'YYYY-MM-DD')                                         -- 日单位
      END,
      -- 实际终止日期：COALESCE(终止交易最新日期, 状态=2失效时回退起保日期)
      COALESCE(
          TO_CHAR(MAX(AG.actl_term_date_parsed), 'YYYYMMDD'),
          CASE WHEN MIN(D.cont_status) = '2' AND MIN(D.vali_date) IS NOT NULL
               THEN TO_CHAR(TO_DATE(MIN(D.vali_date), 'YYYYMMDD'), 'YYYYMMDD') END),
      -- 缴费截止日期推算：0=趸交→投保日期，-1=无期限→NULL，12=年/1=月/2=日，0=保至年龄→身份证推算
      CASE
          WHEN MIN(D.pay_type) = '0'
          THEN TO_CHAR(MIN(D.accept_date_parsed), 'YYYYMMDD')               -- 趸交，投保日期即为截止日期
          WHEN MIN(D.pay_per_unit) = '12'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(D.vali_date), 'YYYYMMDD'),
                                  12 * MIN(D.pay_per_num)), 'YYYYMMDD')     -- 年单位
          WHEN MIN(D.pay_per_unit) = '1'
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(MIN(D.vali_date), 'YYYYMMDD'),
                                  MIN(D.pay_per_num)), 'YYYYMMDD')          -- 月单位
          WHEN MIN(D.pay_per_unit) = '2'
          THEN TO_CHAR(TO_DATE(MIN(D.vali_date), 'YYYYMMDD') + MIN(D.pay_per_num),
                       'YYYYMMDD')                                           -- 日单位
          WHEN MIN(D.pay_per_unit) = '0' AND LENGTH(MIN(D.cert_id)) = 18
          THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(MIN(D.cert_id), 7, 8), 'YYYYMMDD'),
                                  12 * MIN(D.pay_per_num)), 'YYYYMMDD')     -- 18位身份证推算
          WHEN MIN(D.pay_per_unit) = '0' AND LENGTH(MIN(D.cert_id)) = 15
          THEN TO_CHAR(ADD_MONTHS(TO_DATE('19' || SUBSTR(MIN(D.cert_id), 7, 6), 'YYYYMMDD'),
                                  12 * MIN(D.pay_per_num)), 'YYYYMMDD')     -- 15位身份证推算
      END,
      MIN(D.valid_per_unit),                                            -- 保险期间类型
      MIN(D.valid_per_num),                                             -- 保险期间值
      MIN(D.pay_per_unit),                                              -- 缴费期间类型
      MIN(D.pay_per_num),                                               -- 缴费期间值
      MIN(D.pay_type),                                                  -- 缴费方式
      SUM(CASE WHEN D.tran_type = '0' THEN D.ord_amt ELSE 0 END),       -- 首期保费，新单(TRAN_TYPE='0')交易金额之和
      -- 当前保险金额清零规则（按优先级递减）：
      --   1.保单状态无效(不在0/1/2) 2.未生效(0) 3.失效(2)
      --   4.趸交满一年 5.期缴缴满 6.宽限期过60天 7.正常=新单保费+续期累计
      CASE
          WHEN MIN(D.cont_status) IS NULL
            OR MIN(D.cont_status) NOT IN ('0','1','2') THEN 0               -- 规则1: 保单状态无效
          WHEN MIN(D.cont_status) = '0' THEN 0                               -- 规则2: 未生效
          WHEN MIN(D.cont_status) = '2' THEN 0                               -- 规则3: 失效
          WHEN MIN(D.pay_type) = '0'
           AND V_DATA_DATE >= ADD_MONTHS(MIN(D.accept_date_parsed), 12)
          THEN 0                                                              -- 规则4: 趸交满一年
          WHEN MIN(D.pay_type) = '1'
           AND MIN(D.pay_per_num) IS NOT NULL
           AND MIN(D.pay_per_num) > 0
           AND MIN(D.pay_per_unit) IN ('12','1','2')
           AND V_DATA_DATE >= CASE MIN(D.pay_per_unit)
                                  WHEN '12' THEN ADD_MONTHS(MIN(D.accept_date_parsed),
                                                            MIN(D.pay_per_num) * 12)
                                  WHEN '1'  THEN ADD_MONTHS(MIN(D.accept_date_parsed),
                                                            MIN(D.pay_per_num))
                                  WHEN '2'  THEN MIN(D.accept_date_parsed)
                                               + MIN(D.pay_per_num)
                              END
          THEN 0                                                              -- 规则5: 期缴缴满
          WHEN MIN(D.pay_type) = '1'
           AND MAX(AG.last_renewal_date_parsed) IS NOT NULL
           AND MIN(D.pay_per_unit) IN ('12','1','2')
           AND V_DATA_DATE > CASE MIN(D.pay_per_unit)
                                 WHEN '12' THEN ADD_MONTHS(MAX(AG.last_renewal_date_parsed), 12) + 60
                                 WHEN '1'  THEN ADD_MONTHS(MAX(AG.last_renewal_date_parsed), 1) + 60
                                 WHEN '2'  THEN MAX(AG.last_renewal_date_parsed) + 1 + 60
                             END
          THEN 0                                                              -- 规则6: 60天宽限期已过
          ELSE SUM(CASE WHEN D.tran_type = '0' THEN D.ord_amt ELSE 0 END)     -- 规则7: 新单保费
             + SUM(CASE WHEN D.tran_type = '1' THEN D.ord_amt ELSE 0 END)     --       + 续期累计
      END,
      MIN(D.cont_status),                                                -- 保单状态
      NULL,                                                              -- 交易类型，当前置空
      MIN(D.persn_legal_bk_code)                                         -- 法人行号
  FROM TMP_DWD_ACCT_INSUR_DETAIL D
  LEFT JOIN TMP_DWD_ACCT_INSUR_FEE_AGGR AG
    ON AG.plat_policy_serial = D.plat_policy_serial
  GROUP BY
      D.cust_id, D.cust_typ, D.acct_id, D.prdkt_id, D.prdkt_name, D.prdkt_cate_big,
      D.insur_bid_form_no, D.tx_org, D.tx_chnl, D.mkt_org, D.bgn_insur_date;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '4 完成: [聚合层]';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤5: [写入] INSERT 快照 → DWD_ACCT_INSUR
  --        步骤1已清理当日数据，直接INSERT
  ------------------------------------------------------------------
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  INSERT INTO DWD_ACCT_INSUR (
      cust_id,             -- 客户编号(四键主键)
      cust_typ,            -- 客户类型，固定'1'=个人客户
      acct_id,             -- 账户(四键主键)，银行卡号
      prdkt_id,            -- 产品ID(四键主键)
      prdkt_name,          -- 产品名称
      prdkt_cate_big,      -- 产品大类
      insur_bid_form_no,   -- 投保单号(四键主键)，保险单号
      tx_date,             -- 交易日期(YYYYMMDD)
      last_tx_date,        -- 最近交易日期(YYYYMMDD)
      tx_org,              -- 交易机构
      tx_chnl,             -- 交易渠道
      mkt_org,             -- 归属机构
      bgn_insur_date,      -- 起保日期(YYYY-MM-DD)
      cancl_insur_date,    -- 保险期间结束日期(YYYY-MM-DD)，推算值
      actl_term_date,      -- 实际终止日期(YYYYMMDD)
      pay_upto_date,       -- 缴费截止日期(YYYYMMDD)
      insur_period_typ,    -- 保险期间类型
      insur_period,        -- 保险期间值
      pay_period_typ,      -- 缴费期间类型
      pay_period,          -- 缴费期间值
      pay_patrn,           -- 缴费方式，0=趸缴/1=期缴
      new_insur_amt,       -- 首期保费
      insur_amt,           -- 当前保险金额，含清零规则
      policy_state,        -- 保单状态，0=未生效/1=正常/2=失效
      tx_typ,              -- 交易类型，当前置空
      persn_legal_bk_code  -- 法人行号
  )
  SELECT
      S.cust_id, S.cust_typ, S.acct_id, S.prdkt_id, S.prdkt_name, S.prdkt_cate_big,
      S.insur_bid_form_no, S.tx_date, S.last_tx_date, S.tx_org, S.tx_chnl, S.mkt_org,
      S.bgn_insur_date, S.cancl_insur_date, S.actl_term_date, S.pay_upto_date,
      S.insur_period_typ, S.insur_period, S.pay_period_typ, S.pay_period,
      S.pay_patrn, S.new_insur_amt, S.insur_amt, S.policy_state, S.tx_typ, S.persn_legal_bk_code
  FROM TMP_DWD_ACCT_INSUR_SNAP S;

  V_CNT_INS := SQL%ROWCOUNT;   -- INSERT影响行数，由SQL%ROWCOUNT返回最近DML影响的行数
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '5 完成: [写入] 影响行=' || V_CNT_INS;
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -- ***************************************
    -- 异常处理区：捕获错误，整体回滚，记录日志，向上传播
    -- ***************************************
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -3;    -- 返回码：-3=系统异常
    ROLLBACK;        -- 整体回滚，撤销本事务内所有未提交的数据变更
    V_END_DATE := SYSDATE;
    -- 计算耗时，若BGN_DATE或END_DATE为NULL则耗时置NULL
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NULL OR V_END_DATE IS NULL
                        THEN NULL
                        ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60)
                   END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);   -- 截取错误消息前1000字符
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;   -- 向上传播异常
END;