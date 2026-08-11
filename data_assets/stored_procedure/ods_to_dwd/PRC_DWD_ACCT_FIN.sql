-- DROP PROCEDURE crmdm.prc_dwd_acct_fin(in varchar, out int4);

CREATE OR REPLACE PROCEDURE crmdm.prc_dwd_acct_fin(v_sysdat varchar, outcde OUT integer)
AS
  ------------------------------------------------------------------
  -- 报表名称: 理财账户处理
  -- 报表编号：PRC_DWD_ACCT_FIN
  -- 处理周期：日
  -- 过程描述：DELETE+INSERT方案加工理财账户数据，保留到期记录供下游识别
  -- 来源表：FMS_T1_CUST_INFO、FMS_T1_CUST_FNC_ACCT、
  --         FMS_TD_CUST_VOL、FMS_TD_PROD_INFO、FMS_TD_PROD_NAV、
  --         FMS_T5_CUST_VOL、FMS_T5_PROD_INFO、FMS_T5_PROD_NAV、FMS_T5_PROD_PERIOD
  -- 目标表：DWD_ACCT_FIN
  -- 需求版本: v2.0.0
  -- 适配数据库：人大金仓 Oracle 兼容模式
  -- 变更记录:
  --   v1.0.0 2026-07-10 初始版本：TRUNCATE+INSERT全量覆盖方案
  --   v1.0.1 2026-07-28 删除未使用变量、补版本号、DDL删除重复列及日均字段、补行内注释
  --   v2.0.0 2026-08-06 重构：TRUNCATE+INSERT → DELETE+INSERT + 到期标记四步骤方案；
  --                     新增TMP_DWD_ACCT_FIN_ACTIVE临时表；
  --                     FIN_AMT增加ROUND(,2)保留2位小数；
  --                     RATE_INTRI改为ROUND(NVL(,0),2)写入NUMBER；
  --                     增加V_SYSDAT参数校验；
  --                     精简冗余过滤条件(NVL(TOTAL_AMT,0)>0)；
  --                     DDL补充CFM_AMT列
  ------------------------------------------------------------------
  V_PRC_DESC     VARCHAR(100) := '理财账户处理';   -- 过程描述，用于SYS_PRC_STEP_LOGS日志标识
  V_PRC_NAME     VARCHAR(32)  := 'PRC_DWD_ACCT_FIN'; -- 过程编号，对应报表编号
  V_LOG_MSG      VARCHAR(4000);                     -- 日志消息缓存，拼接各步骤日志描述文本
  V_START_DT     DATE;                              -- 过程开始时间，记录整体执行起始时刻
  V_LOG_FLG      INTEGER;                           -- 日志标记，0=正常，-1=参数异常，-3=系统异常
  V_LOG_BUTTON   INTEGER := 1;                      -- 日志开关，固定为1（启用日志记录）
  V_NO_ID        VARCHAR(10);                       -- 步骤编号，取值1~4，用于SYS_PRC_STEP_LOGS步骤标识
  V_BGN_DATE     DATE;                              -- 步骤开始时间，记录当前步骤开始时刻
  V_END_DATE     DATE;                              -- 步骤结束时间，记录当前步骤结束时刻
  V_DURA_DATE    INTEGER;                           -- 步骤耗时(秒)，= TRUNC((V_END_DATE - V_BGN_DATE) * 86400)
BEGIN
  V_START_DT := SYSDATE;

  ------------------------------------------------------------------
  -- 步骤1: 参数校验 + TMP表清空
  ------------------------------------------------------------------
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- V_SYSDAT 必填且为8位字符串(YYYYMMDD)，否则返回-1
  IF V_SYSDAT IS NULL OR LENGTH(V_SYSDAT) != 8 THEN
      OUTCDE := -1;    -- 返回码：-1=参数校验失败
      RETURN;
  END IF;

  DELETE FROM TMP_DWD_ACCT_FIN_ACTIVE;                         -- 清空活跃快照表
  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '1 完成: 参数校验+TMP表清空';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤2: [快照层] 构建活跃快照 → TMP_DWD_ACCT_FIN_ACTIVE
  --        2.1 代销理财 + 2.2 自营理财 UNION ALL 合并写入
  --        过滤条件: TOTAL_VOL>0、个人客户(HOST_CUST_NO以1开头)
  ------------------------------------------------------------------
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_DWD_ACCT_FIN_ACTIVE (
      cust_id,             -- 客户编号(三键主键)
      cust_typ,            -- 客户类型，固定'1'=个人客户
      acct_id,             -- 账户(三键主键)
      card_no,             -- 卡/折号
      prdkt_id,            -- 产品ID(三键主键)
      prdkt_name,          -- 产品名称
      prdkt_cate_big,      -- 产品大类
      estab_date,          -- 成立日期
      fin_amt,             -- 理财余额(=ROUND(净值×份额,2))
      rate_intri,          -- 收益率
      acct_state,          -- 理财账户状态
      intri_bgn_date,      -- 起息日期
      expr_date,           -- 到期日期
      oprt_org,            -- 归属机构
      chnl_no,             -- 办理渠道
      persn_legal_bk_code, -- 法人行号
      issu_org,            -- 发行机构
      issu_date,           -- 办理日期
      risk_lvl,            -- 风险等级
      cfm_amt              -- 交易确认金额
  )
  -- 2.1 代销理财：FMS_TD_CUST_VOL驱动
  SELECT
      ci.HOST_CUST_NO,                                                       -- 核心客户号
      '1',                                                                   -- 客户类型，固定为'1'=个人客户
      fa.ACCT_NO,                                                            -- 理财账户
      fa.CARD_NO,                                                            -- 卡折号
      pi.REGIST_CODE,                                                        -- 理财产品编号
      pi.PROD_NAME,                                                          -- 理财产品名称
      CASE WHEN pi.PROD_TYPE IN ('2','3') THEN '1' ELSE '2' END,             -- 产品大类：1=代销开放/2=代销封闭
      pi.ESTABLISH_DATE,                                                     -- 成立日期
      ROUND(NVL(pn.NAV, 0) * NVL(cv.TOTAL_VOL, 0), 2),                       -- 理财余额=ROUND(净值×份额,2)
      ROUND(NVL(pn.TONOWCLIENTRATIO, 0), 2),                                 -- 收益率=成立以来参考年化收益率
      fa.ACCT_STATUS,                                                        -- 理财账户状态
      pi.VALUE_DATE,                                                         -- 起息日期
      pi.WINDING_DATE,                                                       -- 到期日期
      ctl.TRANS_ORGNO,                                                       -- 归属机构（无交易记录时为NULL）
      fa.ISS_BANK_CODE,                                                      -- 办理渠道
      -- 法人行号推导：15开头→1500，12开头→1200，18开头→1800，其他→9999
      CASE WHEN ctl.TRANS_ORGNO LIKE '15%' THEN '1500'
           WHEN ctl.TRANS_ORGNO LIKE '12%' THEN '1200'
           WHEN ctl.TRANS_ORGNO LIKE '18%' THEN '1800'
           ELSE '9999' END,
      pi.TANO,                                                               -- 发行机构
      fa.CRT_DATE,                                                           -- 办理日期
      pi.PROD_RISK_LEVEL,                                                    -- 风险等级
      ctl.cfm_amt                                                            -- 交易确认金额（认购+申购合计）
    FROM FMS_TD_CUST_VOL cv                                         -- 理财客户份额表（驱动表）
    INNER JOIN FMS_T1_CUST_FNC_ACCT fa                              -- 客户理财交易账号表
      ON fa.CUST_NO           = cv.CUST_NO
     AND fa.FNC_TRANS_ACCT_NO = cv.FNC_TRANS_ACCT_NO
    INNER JOIN FMS_T1_CUST_INFO ci                                  -- 客户信息表
      ON ci.CUST_NO = fa.CUST_NO
    LEFT JOIN (                                                      -- 客户交易请求日志（认购/申购成功汇总）
        SELECT fnc_trans_acct_no,
               CUST_NO,
               TRANS_ORGNO,
               SUM(cfm_amt) cfm_amt
          FROM FMS_TD_CUST_TRANS_REQ_LOG
         WHERE TRANS_STATUS IN ('1','3')                            -- 申请成功 确认成功
           AND busi_code IN ('020','022')                           -- 认购 申购
         GROUP BY fnc_trans_acct_no, CUST_NO, TRANS_ORGNO
    ) ctl
      ON ctl.CUST_NO           = cv.CUST_NO
     AND ctl.FNC_TRANS_ACCT_NO = cv.FNC_TRANS_ACCT_NO
    INNER JOIN FMS_TD_PROD_INFO pi                                  -- 理财产品信息表
      ON cv.TANO                  = pi.TANO
     AND cv.PROD_CODE             = pi.PROD_CODE
     AND NVL(cv.SHARE_CLASS, '~') = NVL(pi.SHARE_CLASS, '~')
    LEFT JOIN (
        SELECT
            x.TANO,
            x.PROD_CODE,
            x.SHARE_CLASS,
            x.NAV,
            x.TONOWCLIENTRATIO,
            ROW_NUMBER() OVER (
                PARTITION BY x.TANO, x.PROD_CODE, x.SHARE_CLASS
                ORDER BY x.NAV_DATE DESC                            -- 取最新净值日期
            ) AS RN
          FROM FMS_TD_PROD_NAV x                                    -- 理财产品行情表
         WHERE x.NET_VALUE_TYPE = '0'
    ) pn
      ON cv.TANO                  = pn.TANO
     AND cv.PROD_CODE             = pn.PROD_CODE
     AND NVL(cv.SHARE_CLASS, '~') = NVL(pn.SHARE_CLASS, '~')
     AND pn.RN = 1
   WHERE NVL(cv.TOTAL_VOL, 0) <> 0                                  -- 份额为0不入库
     AND SUBSTR(ci.HOST_CUST_NO, 1, 1) = '1'                        -- 仅个人客户

  UNION ALL

  -- 2.2 自营理财：FMS_T5_CUST_VOL驱动
  SELECT
      ci.HOST_CUST_NO,                                                       -- 核心客户号
      '1',                                                                   -- 客户类型，固定为'1'=个人客户
      fa.ACCT_NO,                                                            -- 理财账户
      fa.CARD_NO,                                                            -- 卡折号
      pi.REGIST_CODE,                                                        -- 理财产品编号
      pi.PROD_NAME,                                                          -- 理财产品名称
      CASE WHEN pi.PERIOD_TYPE = '0' THEN '3' ELSE '4' END,                  -- 产品大类：3=自营开放/4=自营封闭
      pp.ESTABLISH_DATE,                                                     -- 成立日期
      ROUND(NVL(pn.NAV, 0) * NVL(cv.TOTAL_VOL, 0), 2),                       -- 理财余额=ROUND(净值×份额,2)
      ROUND(NVL(pn.SEVEN_DAYS_INCOME, 0), 2),                                -- 收益率=7日年化收益率
      fa.ACCT_STATUS,                                                        -- 理财账户状态
      pp.VALUE_DATE,                                                         -- 起息日期
      pp.WINDING_DATE,                                                       -- 到期日期
      ci.SUB_BRANCH_CODE,                                                    -- 归属机构
      fa.TRADINGMETHOD,                                                      -- 办理渠道
      -- 法人行号推导：15开头→1500，12开头→1200，18开头→1800，其他→9999
      CASE WHEN ctl.SUB_BRANCH_CODE LIKE '15%' THEN '1500'
           WHEN ctl.SUB_BRANCH_CODE LIKE '12%' THEN '1200'
           WHEN ctl.SUB_BRANCH_CODE LIKE '18%' THEN '1800'
           ELSE '9999' END,
      pi.ORGNO,                                                              -- 发行机构
      fa.CRT_DATE,                                                           -- 办理日期
      pi.PROD_RISK_LEVEL,                                                    -- 风险等级
      ctl.ack_amt                                                            -- 交易确认金额（认购+申购合计）
    FROM FMS_T5_CUST_VOL cv                                         -- 客户份额汇总表（驱动表）
    INNER JOIN FMS_T1_CUST_FNC_ACCT fa                              -- 客户理财交易账号表
      ON fa.CUST_NO           = cv.CUST_NO
     AND fa.FNC_TRANS_ACCT_NO = cv.FNC_TRANS_ACCT_NO
    LEFT JOIN (                                                      -- 客户交易日志（认购/申购成功汇总）
        SELECT fnc_trans_acct_no,
               CUST_NO,
               sub_branch_code,
               SUM(ack_amt) ack_amt
          FROM FMS_T5_CUST_TRANS_LOG
         WHERE TRANS_STATUS IN ('1','3')                            -- 申请成功 确认成功
           AND busi_code IN ('120','122')                           -- 认购 申购
         GROUP BY fnc_trans_acct_no, CUST_NO, sub_branch_code
    ) ctl
      ON ctl.CUST_NO           = cv.CUST_NO
     AND ctl.FNC_TRANS_ACCT_NO = cv.FNC_TRANS_ACCT_NO
    INNER JOIN FMS_T1_CUST_INFO ci                                  -- 客户信息表
      ON ci.CUST_NO = fa.CUST_NO
    INNER JOIN (
        SELECT
            x.PROD_CODE,
            x.REGIST_CODE,
            x.PROD_NAME,
            x.PERIOD_TYPE,
            x.ORGNO,
            x.PROD_RISK_LEVEL,
            ROW_NUMBER() OVER (
                PARTITION BY x.PROD_CODE
                ORDER BY NVL(x.UPDATE_PROD_DATE, '00000000') DESC,
                         NVL(x.UPDATE_PROD_TIME, '000000')  DESC,
                         NVL(x.NAV_DATE,         '00000000') DESC   -- 取最新产品信息
            ) AS RN
          FROM FMS_T5_PROD_INFO x                                    -- 产品信息表
    ) pi
      ON cv.PROD_CODE = pi.PROD_CODE
     AND pi.RN = 1
    INNER JOIN (
        SELECT
            x.PROD_CODE,
            x.ESTABLISH_DATE,
            x.VALUE_DATE,
            x.WINDING_DATE,
            ROW_NUMBER() OVER (
                PARTITION BY x.PROD_CODE
                ORDER BY x.ESTABLISH_DATE DESC                      -- 取最新产品周期
            ) AS RN
          FROM FMS_T5_PROD_PERIOD x                                  -- 产品周期信息表
    ) pp
      ON pi.PROD_CODE = pp.PROD_CODE
     AND pp.RN = 1
    INNER JOIN (
        SELECT
            x.PROD_CODE,
            x.NAV,
            x.SEVEN_DAYS_INCOME,
            ROW_NUMBER() OVER (
                PARTITION BY x.PROD_CODE
                ORDER BY x.NAV_DATE DESC                            -- 取最新净值日期
            ) AS RN
          FROM FMS_T5_PROD_NAV x                                    -- 产品净值信息表
    ) pn
      ON pi.PROD_CODE = pn.PROD_CODE
     AND pn.RN = 1
   WHERE NVL(cv.TOTAL_VOL, 0) <> 0                                  -- 份额为0不入库
     AND SUBSTR(ci.HOST_CUST_NO, 1, 1) = '1';                       -- 仅个人客户

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '2 完成: [快照层] 代销+自营合并快照';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
  -- 步骤3: [写入] DELETE + INSERT 同一事务
  --        DELETE: 按三键主键删除TMP中存在的已在目标表的记录
  --        INSERT: 插入TMP中所有活跃记录
  --        两步在同一事务中，要么都执行要么都回滚，保证数据一致性
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  DELETE FROM DWD_ACCT_FIN
   WHERE (CUST_ID, ACCT_ID, PRDKT_ID) IN (
       SELECT cust_id, acct_id, prdkt_id FROM TMP_DWD_ACCT_FIN_ACTIVE
   );

  INSERT INTO DWD_ACCT_FIN (
      CUST_ID,             -- 客户编号
      CUST_TYP,            -- 客户类型
      ACCT_ID,             -- 账户
      CARD_NO,             -- 卡/折号
      PRDKT_ID,            -- 产品ID
      PRDKT_NAME,          -- 产品名称
      PRDKT_CATE_BIG,      -- 产品大类
      ESTAB_DATE,          -- 成立日期
      FIN_AMT,             -- 理财余额
      RATE_INTRI,          -- 收益率
      ACCT_STATE,          -- 状态
      INTRI_BGN_DATE,      -- 起息日期
      EXPR_DATE,           -- 到期日期
      OPRT_ORG,            -- 归属机构
      CHNL_NO,             -- 办理渠道
      PERSN_LEGAL_BK_CODE, -- 法人行号
      ISSU_ORG,            -- 发行机构
      ISSU_DATE,           -- 办理日期
      RISK_LVL,            -- 风险等级
      CFM_AMT              -- 交易确认金额
  )
  SELECT
      cust_id,
      cust_typ,
      acct_id,
      card_no,
      prdkt_id,
      prdkt_name,
      prdkt_cate_big,
      estab_date,
      fin_amt,
      rate_intri,
      acct_state,
      intri_bgn_date,
      expr_date,
      oprt_org,
      chnl_no,
      persn_legal_bk_code,
      issu_org,
      issu_date,
      risk_lvl,
      cfm_amt
    FROM TMP_DWD_ACCT_FIN_ACTIVE;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE  := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG   := '3 完成: [写入] DELETE+INSERT同一事务';
  V_LOG_FLG   := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  ------------------------------------------------------------------
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
