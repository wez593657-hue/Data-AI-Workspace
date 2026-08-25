CREATE OR REPLACE PROCEDURE PRC_ADS_CRM_R_CUST_LABLE_TX_INFO(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：对私客户标签表
  -- 处理周期: 日
  -- 过程描述: 生成对私客户的12个标签字段
  -- 来源表: DWD_CUST_INDV_INFO, DWD_TX_ASET, crmdm.mbk_cust_log_fee, crmdm.mbk_cust_info, crmdm.uepp_pay_order_info
  -- 目标表: ADS_CRM_R_CUST_LABLE
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v1.4.0
  -- 变更记录:
  --   v1.4.0 2026-08-14 日期参数补充：新增sys_fun_deal_date code=30（6月前的前一天，近6月窗口滚动清理边界）
  --   v1.3.2 2026-08-04 F-01:修复TMP_02/TMP_03 SELECT列顺序与INSERT不一致导致PERSN_LEGAL_BK_CODE与CUST_ID交叉写入；
  --                        F-02:补充TMP_02/TMP_03近1月窗口上界TX_DATE<=V_SYSDAT；
  --                        F-03:删除V_END_DATE无效初始化；
  --                        F-04:确认DWD_TX_ASET.AMT字段存在(NUMBER(18,4)发生额)，引用正确
  --   v1.3.1 2026-07-29 补充材料开发：BILL_RSV_MKNT_CNT_MTH_LAST+AMT_MTH_LAST(收单商户上月交易)，源表uepp_pay_order_info
  --   v1.3.0 2026-07-29 架构重构：拆分6个独立临时表，每段独立INSERT，最终多表LEFT JOIN汇聚到目标表
  --   v1.2.1 2026-07-29 双键关联：所有源表关联统一使用CUST_ID+PERSN_LEGAL_BK_CODE作为计算单位
  --   v1.2.0 2026-07-29 补充材料开发：YR_CAMPUS_PAY_CNT(校园缴费)+MTH_UTIL_PAY_*(水电气缴费)，源表mbk_cust_log_fee
  --   v1.1.0 2026-07-29 合规修复：日期参数改用sys_fun_deal_date(code=20/21)，移除DATA_DATE，目标表改为全量快照
  --   v1.0.0 2026-07-28 初始版本：实现8个Y标记可直接开发字段
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '对私客户标签表';
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CRM_R_CUST_LABLE_TX_INFO';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  V_ONE_MONTH_AGO        VARCHAR2(8);      -- code=20 1月前
  V_SIX_MONTH_AGO        VARCHAR2(8);      -- code=21 6月前
  V_SIX_MONTH_AGO_AGO    VARCHAR2(8);      -- code=30 6月前的前一天
  V_CURR_YEAR_BEGIN      VARCHAR2(8);      -- code=13 本年1月1日
  V_CURR_MONTH_BEGIN     VARCHAR2(8);      -- code=9  本月1日
  V_PREV_MONTH_BEGIN     VARCHAR2(8);      -- code=15 上月1日
  V_PREV_MONTH_END       VARCHAR2(8);      -- code=2  上月末

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查
  ------------------------------------------------------------------
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_ONE_MONTH_AGO        := sys_fun_deal_date(V_SYSDAT, 20);  -- 20:1月前
  V_SIX_MONTH_AGO        := sys_fun_deal_date(V_SYSDAT, 21);  -- 21:6月前
  V_SIX_MONTH_AGO_AGO    := sys_fun_deal_date(V_SYSDAT, 30);  -- 30:6月前的前一天
  V_CURR_YEAR_BEGIN      := sys_fun_deal_date(V_SYSDAT, 13);  -- 13:本年1月1日
  V_CURR_MONTH_BEGIN     := sys_fun_deal_date(V_SYSDAT, 9);   -- 9:本月1日
  V_PREV_MONTH_BEGIN     := sys_fun_deal_date(V_SYSDAT, 15);  -- 15:上月1日
  V_PREV_MONTH_END       := sys_fun_deal_date(V_SYSDAT, 2);   -- 2:上月末

  ------------------------------------------------------------------
  -- 2. TMP1：清理目标表和所有临时表（全量快照模式）
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  TRUNC_TMP('ADS_CRM_R_CUST_LABLE');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_01');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_02');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_03');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_04');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_05');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_06');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_07');
  COMMIT;

  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理目标表和7个临时表';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 3. TMP2：各段独立建临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  -- 3.1 基础客户列表
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_01 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID
  )
  SELECT PERSN_LEGAL_BK_CODE,
         CUST_ID
    FROM DWD_CUST_INDV_INFO;

  -- 3.2 近1月交易汇总（主动动账：JIOYCFFS='0'）
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_02 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      NEAR_MTH_TX_CNT,
      NEAR_MTH_TX_AMT
  )
  SELECT PERSN_LEGAL_BK_CODE,
         CUST_ID,
         COUNT(*)    AS TX_CNT,
         SUM(AMT)    AS TX_AMT
    FROM DWD_TX_ASET
   WHERE TX_DATE >= V_ONE_MONTH_AGO
     AND TX_DATE <= V_SYSDAT
     AND JIOYCFFS = '0'
     AND CHONGZBZ = '0' --要未冲正的数据
   GROUP BY PERSN_LEGAL_BK_CODE, CUST_ID;

  -- 3.3 近1月第三方支付交易（网联渠道）
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_03 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      NEAR_MTH_THIRD_PAY_OUT_CNT,
      NEAR_MTH_THIRD_PAY_OUT_AMT
  )
WITH txt AS (
    SELECT PYER_ACCT_NO AS card_no, SYS_DATE, TRX_AMT_D
    FROM ECPP_E_TXN_COLLECTION
    WHERE TRX_STATUS IN ('00','03')
      AND REPLACE(SYS_DATE,'_','') BETWEEN V_ONE_MONTH_AGO AND V_SYSDAT
    UNION ALL
    SELECT PYER_ACCT_NO_DE, SYS_DATE, TRX_AMT_D
    FROM EPCC.E_TXN_PAYMENT
    WHERE REPLACE(SYS_DATE,'_','') BETWEEN V_ONE_MONTH_AGO AND V_SYSDAT
)
SELECT B.PERSN_LEGAL_BK_CODE, B.CUST_ID,
       COUNT(1) AS txn_cnt,
       SUM(A.TRX_AMT_D) AS total_amt
FROM txt A
INNER JOIN (SELECT DISTINCT CUST_ID, CARD_NO, PERSN_LEGAL_BK_CODE FROM DWD_ACCT_DEPO) B
   ON A.card_no = B.CARD_NO
GROUP BY B.PERSN_LEGAL_BK_CODE, B.CUST_ID;

  -- 3.4 是否向他行同名户规律转出
  -- 口径：近半年每月至少向他行同名账户转账一笔

 --将每天数据导入中间表
 DELETE FROM TMP_ADS_CRM_CUST_LABLE_04_01 WHERE TX_DATE = V_SIX_MONTH_AGO_AGO; --删除6个月前的前一天数据
 
 INSERT INTO TMP_ADS_CRM_CUST_LABLE_04_01  (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      TX_DATE
)
   SELECT a.CUST_ID,
                a.PERSN_LEGAL_BK_CODE,
                a.TX_DATE
           FROM DWD_TX_ASET a
          WHERE a.TX_DATE = V_SYSDAT 
            AND a.LOAN_FLG = '0' --0借 1贷
            --交易对手行号不为本行机构号
            AND A.CHONGZBZ = '0'
            AND A.XIANZZBZ = '1'		--现转标志(0-现金,1-转账)
            AND INSTR(a.OPNT_ACCT_NAME_FST, A.CUST_NAME) > 0
            AND a.OPNT_BK_KEEP NOT IN (SELECT ORG_ID FROM DWD_SYS_ORG) --
          GROUP BY a.CUST_ID, a.PERSN_LEGAL_BK_CODE, a.TX_DATE;

--从中间表取近半年每月至少向他行同名账户转账一笔
   INSERT INTO TMP_ADS_CRM_CUST_LABLE_04 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME
  )
  SELECT CUST_ID,
         PERSN_LEGAL_BK_CODE,
         CASE WHEN COUNT(DISTINCT SUBSTR(a.TX_DATE, 1, 6)) >= 6 THEN '1' ELSE '0' END AS RGLAR_FLAG
    FROM TMP_ADS_CRM_CUST_LABLE_04_01 m where TX_DATE >= V_SIX_MONTH_AGO
   GROUP BY CUST_ID, PERSN_LEGAL_BK_CODE;  
   
   

  -- 3.5 当年校园缴费笔数（tran_type='1', tran_status='1',cust_status = '1'）
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_05 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      YR_CAMPUS_PAY_CNT
  )
  SELECT i.cust_core_no          AS CUST_ID,
         CASE WHEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2) IN ('12','15','18')
              THEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2)||'00'
              ELSE '9999' END    AS PERSN_LEGAL_BK_CODE,
         COUNT(*)        AS CAMPUS_CNT
    FROM crmdm.mbk_cust_log_fee f
    JOIN crmdm.mbk_cust_info    i
      ON i.cust_no = f.cust_no
   WHERE f.tran_type   = '1'
     AND f.tran_status = '1'
     AND I.cust_status = '1'
     AND f.tran_date  >= V_CURR_YEAR_BEGIN
   GROUP BY i.cust_core_no, 
   CASE WHEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2) IN ('12','15','1')
              THEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2)||'00'
              ELSE '9999' END;

  -- 3.6 当月水电气缴费交易金额+笔数（tran_type='0', tran_status='1',cust_status = '1'）
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_06 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      MTH_UTIL_PAY_TRAN_AMT,
      MTH_UTIL_PAY_TRAN_CNT
  )
  SELECT i.cust_core_no             AS CUST_ID,
         CASE WHEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2) IN ('12','15','1')
              THEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2)||'00'
              ELSE '9999' END                AS PERSN_LEGAL_BK_CODE,
         SUM(TO_NUMBER(f.tran_amt)) AS UTIL_TRAN_AMT,
         COUNT(*)                   AS UTIL_TRAN_CNT
    FROM crmdm.mbk_cust_log_fee f
    JOIN crmdm.mbk_cust_info    i
      ON i.cust_no = f.cust_no
   WHERE f.tran_type   = '0'
     AND f.tran_status = '1'
     AND I.cust_status = '1'
     AND f.tran_date  >= V_CURR_MONTH_BEGIN
   GROUP BY i.cust_core_no, 
   CASE WHEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2) IN ('12','15','1')
              THEN SUBSTR(NVL(F.DEPT_ID,I.CUST_ORG_NO),1,2)||'00'
              ELSE '9999' END;

  -- 3.7 收单商户上月交易（uepp_pay_order_info: status='02'，pay_time在上月范围内）
  -- isscode映射法人行号：前2位=12/15/18 → isscode||'00'，其余 → '9999'
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_07 (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      BILL_RSV_MKNT_CNT_MTH_LAST,
      BILL_RSV_MKNT_AMT_MTH_LAST
  )
  SELECT CASE WHEN SUBSTR(isscode, 1, 2) IN ('12', '15', '18')
              THEN SUBSTR(isscode, 1, 2) || '00'
              ELSE '9999'
         END          AS PERSN_LEGAL_BK_CODE,
         cust_no  AS CUST_ID,
         COUNT(*)     AS MKT_CNT,
         SUM(order_amt) AS MKT_AMT
    FROM crmdm.uepp_pay_order_info upo
    inner join crmdm.uepp_pay_mct_settle_account upm
      on upm.mct_id = upo.mct_id
   WHERE upo.status   = '02'                            -- 交易成功
     AND replace(SUBSTR(pay_time, 1, 10),'-','') >= V_PREV_MONTH_BEGIN
     AND replace(SUBSTR(pay_time, 1, 10),'-','') <= V_PREV_MONTH_END
   GROUP BY CASE WHEN SUBSTR(isscode, 1, 2) IN ('12', '15', '18')
                 THEN SUBSTR(isscode, 1, 2) || '00'
                 ELSE '9999'
            END,
            cust_no;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：7个临时表独立写入';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 4. 目标表写入：多表LEFT JOIN汇聚
  --    12个字段全部实现
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CRM_R_CUST_LABLE (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      NEAR_MTH_TX_CNT,
      NEAR_MTH_TX_AMT,
      NEAR_MTH_THIRD_PAY_OUT_CNT,
      NEAR_MTH_THIRD_PAY_OUT_AMT,
      IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME,
      BILL_RSV_MKNT_CNT_MTH_LAST,
      BILL_RSV_MKNT_AMT_MTH_LAST,
      YR_CAMPUS_PAY_CNT,
      MTH_UTIL_PAY_TRAN_AMT,
      MTH_UTIL_PAY_TRAN_CNT
  )
  SELECT a.PERSN_LEGAL_BK_CODE,
         a.CUST_ID,
         NVL(b.NEAR_MTH_TX_CNT, 0),
         NVL(b.NEAR_MTH_TX_AMT, 0),
         NVL(c.NEAR_MTH_THIRD_PAY_OUT_CNT, 0),
         NVL(c.NEAR_MTH_THIRD_PAY_OUT_AMT, 0),
         NVL(d.IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME, '0'),
         NVL(g.BILL_RSV_MKNT_CNT_MTH_LAST, 0),
         NVL(g.BILL_RSV_MKNT_AMT_MTH_LAST, 0),
         NVL(e.YR_CAMPUS_PAY_CNT, 0),
         NVL(f.MTH_UTIL_PAY_TRAN_AMT, 0),
         NVL(f.MTH_UTIL_PAY_TRAN_CNT, 0)
    FROM TMP_ADS_CRM_CUST_LABLE_01 a
    LEFT JOIN TMP_ADS_CRM_CUST_LABLE_02 b
           ON b.CUST_ID            = a.CUST_ID
          AND b.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
    LEFT JOIN TMP_ADS_CRM_CUST_LABLE_03 c
           ON c.CUST_ID            = a.CUST_ID
          AND c.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
    LEFT JOIN TMP_ADS_CRM_CUST_LABLE_04 d
           ON d.CUST_ID            = a.CUST_ID
          AND d.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
    LEFT JOIN TMP_ADS_CRM_CUST_LABLE_05 e
           ON e.CUST_ID            = a.CUST_ID
          AND e.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
    LEFT JOIN TMP_ADS_CRM_CUST_LABLE_06 f
           ON f.CUST_ID            = a.CUST_ID
          AND f.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
    LEFT JOIN TMP_ADS_CRM_CUST_LABLE_07 g
           ON g.CUST_ID            = a.CUST_ID
          AND g.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：多表LEFT JOIN汇聚写入对私客户标签表';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

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
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
        V_BGN_DATE, V_END_DATE, V_DURA_DATE,
        V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );

    RAISE;
END;
/
