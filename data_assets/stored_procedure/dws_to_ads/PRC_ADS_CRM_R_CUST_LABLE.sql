CREATE OR REPLACE PROCEDURE PRC_ADS_CRM_R_CUST_LABLE(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：对私客户标签表
  -- 处理周期: 日
  -- 过程描述: 生成对私客户的12个标签字段，当前版本实现8个可直接开发字段
  -- 来源表: DWD_CUST_INDV_INFO, DWD_TX_ASET
  -- 目标表: ADS_CRM_R_CUST_LABLE
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v1.1.0
  -- 变更记录:
  --   v1.1.0 2026-07-29 合规修复：日期参数改用sys_fun_deal_date(code=20/21)，移除DATA_DATE，目标表改为全量快照
  --   v1.0.0 2026-07-28 初始版本：实现8个Y标记可直接开发字段
  --     - PERSN_LEGAL_BK_CODE, CUST_ID（取自DWD_CUST_INDV_INFO）
  --     - NEAR_MTH_TX_CNT, NEAR_MTH_TX_AMT（DWD_TX_ASET近1月主动动账）
  --     - NEAR_MTH_THIRD_PAY_OUT_CNT, NEAR_MTH_THIRD_PAY_OUT_AMT（网联渠道）
  --     - IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME（近半年每月至少一笔他行同名转账）
  --     - 4个字段待补充材料后开发（收单商户、校园缴费、水电气缴费）
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '对私客户标签表';
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CRM_R_CUST_LABLE';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  V_ONE_MONTH_AGO        VARCHAR2(8);      -- code=20 1月前
  V_SIX_MONTH_AGO        VARCHAR2(8);      -- code=21 6月前

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

  ------------------------------------------------------------------
  -- 2. TMP1：清理目标表和临时表（全量快照模式）
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  TRUNC_TMP('ADS_CRM_R_CUST_LABLE');
  TRUNC_TMP('TMP_ADS_CRM_CUST_LABLE_BASE');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理目标表和临时表';
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

  ------------------------------------------------------------------
  -- 3. TMP2：生成基础客户数据及交易指标
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  ------------------------------------------------------------------
  -- 3.1 基础客户+近1月交易汇总（主动动账）
  -- TODO[待确认]: 主动动账判定字段，当前不过滤主动/被动，后续需根据TX_TYP或TX_DSC区分
  ------------------------------------------------------------------
  INSERT INTO TMP_ADS_CRM_CUST_LABLE_BASE (
      PERSN_LEGAL_BK_CODE,
      CUST_ID,
      NEAR_MTH_TX_CNT,
      NEAR_MTH_TX_AMT
  )
  SELECT c.PERSN_LEGAL_BK_CODE,
         c.CUST_ID,
         NVL(t.TX_CNT, 0),
         NVL(t.TX_AMT, 0)
    FROM DWD_CUST_INDV_INFO c
    LEFT JOIN (
         -- TODO[待确认]: 主动动账判定字段，当前不过滤，后续需补充 WHERE 主动动账条件
         SELECT CUST_ID,
                COUNT(*)    AS TX_CNT,
                SUM(AMT)    AS TX_AMT
           FROM DWD_TX_ASET
          WHERE TX_DATE >= V_ONE_MONTH_AGO
          GROUP BY CUST_ID
    ) t
      ON t.CUST_ID = c.CUST_ID;

  ------------------------------------------------------------------
  -- 3.2 更新：近1月第三方支付交易（网联渠道）
  -- TODO[待确认]: 网联渠道码值范围，当前使用3026+3030，后续需确认完整码值清单
  ------------------------------------------------------------------
  MERGE INTO TMP_ADS_CRM_CUST_LABLE_BASE b
  USING (
      SELECT CUST_ID,
             COUNT(*)    AS THIRD_TX_CNT,
             SUM(AMT)    AS THIRD_TX_AMT
        FROM DWD_TX_ASET
       WHERE TX_DATE >= V_ONE_MONTH_AGO
         -- TODO[待确认]: 网联渠道码值，当前：3026(WLYYPT网联应用平台) + 3030(WLYZF网联翼支付)
         AND TX_CHNL IN ('3026', '3030')
       GROUP BY CUST_ID
  ) t
     ON (b.CUST_ID = t.CUST_ID)
  WHEN MATCHED THEN UPDATE SET
      b.NEAR_MTH_THIRD_PAY_OUT_CNT  = t.THIRD_TX_CNT,
      b.NEAR_MTH_THIRD_PAY_OUT_AMT  = t.THIRD_TX_AMT;

  ------------------------------------------------------------------
  -- 3.3 更新：是否向他行同名户规律转出
  -- 口径：近半年（含当月）每月至少向他行同名账户转账一笔
  -- TODO[待确认]: 本行联行号标识，当前OPNT_BK_KEEP NOT LIKE '9999%'，后续需确认本行联行号完整范围
  ------------------------------------------------------------------
  MERGE INTO TMP_ADS_CRM_CUST_LABLE_BASE b
  USING (
      -- 统计近6个月每月的他行同名转账月数
      SELECT CUST_ID,
             CASE WHEN COUNT(DISTINCT TX_MONTH) >= 6 THEN 'Y' ELSE 'N' END AS RGLAR_FLAG
        FROM (
             -- 按月统计符合条件的转账
             SELECT a.CUST_ID,
                    SUBSTR(a.TX_DATE, 1, 6) AS TX_MONTH
               FROM DWD_TX_ASET a
               JOIN DWD_CUST_INDV_INFO c
                 ON c.CUST_ID = a.CUST_ID
              WHERE a.TX_DATE >= V_SIX_MONTH_AGO
                -- 过滤转出交易（贷方=资金流出）
                AND a.LOAN_FLG = '贷方'
                -- TODO[待确认]: 本行联行号标识，当前排除9999开头
                AND a.OPNT_BK_KEEP NOT LIKE '9999%'
                -- 同名判定：对方户名包含客户姓名
                AND INSTR(a.OPNT_ACCT_NAME_FST, c.CUST_NAME) > 0
              GROUP BY a.CUST_ID, SUBSTR(a.TX_DATE, 1, 6)
        ) m
       GROUP BY CUST_ID
  ) t
     ON (b.CUST_ID = t.CUST_ID)
  WHEN MATCHED THEN UPDATE SET
      b.IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME = t.RGLAR_FLAG;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成基础客户数据及交易指标';
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

  ------------------------------------------------------------------
  -- 4. 目标表写入
  --    12个字段中8个已实现，4个待补充材料后开发
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
      -- 以下4个字段待补充材料后开发
      BILL_RSV_MKNT_CNT_MTH_LAST,
      BILL_RSV_MKNT_AMT_MTH_LAST,
      YR_CAMPUS_PAY_CNT,
      MTH_UTIL_PAY_TRAN_AMT,
      MTH_UTIL_PAY_TRAN_CNT
  )
  SELECT b.PERSN_LEGAL_BK_CODE,
         b.CUST_ID,
         b.NEAR_MTH_TX_CNT,
         b.NEAR_MTH_TX_AMT,
         b.NEAR_MTH_THIRD_PAY_OUT_CNT,
         b.NEAR_MTH_THIRD_PAY_OUT_AMT,
         b.IS_NOT_RGLAR_TRANS_BK_OTHER_SAMENAME,
         -- TODO: BILL_RSV_MKNT_CNT_MTH_LAST 待补充收单商户CUST_ID映射逻辑后开发
         NULL,
         -- TODO: BILL_RSV_MKNT_AMT_MTH_LAST 待补充收单商户CUST_ID映射逻辑后开发
         NULL,
         -- TODO: YR_CAMPUS_PAY_CNT 待确认mbk_cust_log_fee中CUST_ID映射逻辑后开发
         NULL,
         -- TODO: MTH_UTIL_PAY_TRAN_AMT 待确认mbk_cust_log_fee中CUST_ID映射逻辑后开发
         NULL,
         -- TODO: MTH_UTIL_PAY_TRAN_CNT 待确认mbk_cust_log_fee中CUST_ID映射逻辑后开发
         NULL
    FROM TMP_ADS_CRM_CUST_LABLE_BASE b;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入对私客户标签表';
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
