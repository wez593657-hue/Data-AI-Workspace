CREATE OR REPLACE PROCEDURE PRO_ADS_CUST_DEADLINE_RMND_DTL(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: 到期承接明细表处理
  -- 存储过程编号: PRO_ADS_CUST_DEADLINE_RMND_DTL
  -- 处理周期: 日
  -- 过程描述: 分段生成到期承接明细，物理中间表仅做 TRUNCATE/INSERT，便于排查
  -- 来源表: DWD_CUST_INDV_INFO(客户基本信息), DWD_ACCT_DEPO(存款账户),
  --         DWD_ACCT_FIN(理财账户), DWD_ACCT_INSUR(保险账户),
  --         DWS_CUST_ASSE_LIAB(客户资产负债表),
  --         ADS_MKT_REC_INFO(营销记录表)
  -- 目标表: ADS_CUST_DEADLINE_RMND_DTL(到期承接明细表)
  -- author :
  -- date   : 2026-07-15
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.2.0
  -- 关联需求: REQ-CUST-001, REQ-CUST-002
  -- 变更记录:
  --   v2.1.0: 1.资产承接率统计周期从14天改为30天
  --           2.到期窗口计算逻辑调整为取下一笔到期日减1（如果30天内有下一笔到期），否则取最后一笔到期日+30
  --           3.理财到期转定期金额和定期到期转理财金额计算逻辑优化（跨STATIS_TYP统计）
  --           4.客户承接率长期化产品已剔除保险：TAKE_AMT_30D 仅统计 DEPO/FIN
  --           5.定期存款承接率已过滤通知存款：PRDKT_CATE_BIG <> '04'
  --           6.DATA_DATE语义变更：统一使用周期结束日期（M-月末，Q-季末，N-年末），不再使用快照日期
  --   v2.2.0: 1.计算粒度调整：因法人行有多个，一个客户在不同归属机构/法人行算多个客户，需分开计算
  --           2.客户号+归属机构(经办机构)/法人机构才能算作一个计算单位
  --           3.到期产品源、到期窗口、购买产品源、承接金额、AUM中间表均按客户+机构维度分组
  --           4.法人行号和归属机构从账户表获取（DWD_ACCT_DEPO.OPEN_ACCT_ORG, DWD_ACCT_FIN.OPRT_ORG）
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '到期承接明细表处理';
  V_PRC_NAME             VARCHAR(64)  := 'PRO_ADS_CUST_DEADLINE_RMND_DTL';
  V_SYSDAT2              VARCHAR(10);
  V_SQL                  VARCHAR(32767);
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

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_START_DT := SYSDATE;
  V_SYSDAT2 := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'yyyy-mm-dd');
  P_INTERVAL_START_DATE := TO_CHAR(TO_DATE(V_SYSDAT, 'yyyymmdd') - 30, 'yyyymmdd');
  P_INTERVAL_END_DATE   := V_SYSDAT;

  --***************************************
  -- 2.0 -- 第1段处理开始：清理目标表和中间表
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_DEADLINE_RMND_DTL
   WHERE (STAT_PERD = 'M' AND DATA_DATE = TO_CHAR(LAST_DAY(TO_DATE(V_SYSDAT, 'yyyymmdd')), 'yyyymmdd'))
      OR (STAT_PERD = 'Q' AND DATA_DATE = TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q'), 3) - 1, 'yyyymmdd'))
      OR (STAT_PERD = 'N' AND DATA_DATE = TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), 12) - 1, 'yyyymmdd'))
      OR (STAT_PERD = 'M' AND DATA_DATE = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -1)), 'yyyymmdd'))
      OR (STAT_PERD = 'Q' AND DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q') - 1, 'yyyymmdd'))
      OR (STAT_PERD = 'N' AND DATA_DATE = TO_CHAR(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY') - 1, 'yyyymmdd'));
  TRUNC_TMP('TMP_CDR_DTL_PERIOD');
  TRUNC_TMP('TMP_CDR_DTL_MATURE_SRC');
  TRUNC_TMP('TMP_CDR_DTL_DUE_WIN');
  TRUNC_TMP('TMP_CDR_DTL_PURCHASE_SRC');
  TRUNC_TMP('TMP_CDR_DTL_TAKE_AMT');
  TRUNC_TMP('TMP_CDR_DTL_CUST_BASE');
  TRUNC_TMP('TMP_CDR_DTL_AUM_BAL');

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第1段业务逻辑处理完成：清理目标表和中间表';
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
  -- 2.1 -- 第2段处理开始：生成统计周期中间表
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_PERIOD (
      STAT_PERD, -- 统计周期：M-月，Q-季，N-年
      BGN_DT,    -- 统计周期开始日期
      END_DT     -- 统计周期结束日期
  )
  SELECT 'M' AS STAT_PERD,
         TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'MM') AS BGN_DT,
         LAST_DAY(TO_DATE(V_SYSDAT, 'yyyymmdd')) AS END_DT
    FROM dual
  UNION ALL
  SELECT 'Q' AS STAT_PERD,
         TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q') AS BGN_DT,
         ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q'), 3) - 1 AS END_DT
    FROM dual
  UNION ALL
  SELECT 'N' AS STAT_PERD,
         TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY') AS BGN_DT,
         ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), 12) - 1 AS END_DT
    FROM dual
  UNION ALL
  SELECT 'M' AS STAT_PERD,
         TRUNC(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -1), 'MM') AS BGN_DT,
         LAST_DAY(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -1)) AS END_DT
    FROM dual
  UNION ALL
  SELECT 'Q' AS STAT_PERD,
         TRUNC(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -3), 'Q') AS BGN_DT,
         TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'Q') - 1 AS END_DT
    FROM dual
  UNION ALL
  SELECT 'N' AS STAT_PERD,
         TRUNC(ADD_MONTHS(TO_DATE(V_SYSDAT, 'yyyymmdd'), -12), 'YYYY') AS BGN_DT,
         TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY') - 1 AS END_DT
    FROM dual;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第2段业务逻辑处理完成：生成统计周期中间表';
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
  -- 2.2 -- 第3段处理开始：生成到期产品源中间表
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_MATURE_SRC (
      CUST_ID,             -- 客户编号
      STATIS_TYP,          -- 承接类型：0-全部，1-存款，2-理财
      ACCT_ID,             -- 账户
      PRDKT_ID,            -- 产品编号
      PRDKT_NAME,          -- 产品名称
      EXPR_AMT,            -- 到期金额
      EXPR_DT,             -- 到期日期
      PERSN_LEGAL_BK_CODE, -- 法人行号
      ORG_ID               -- 归属机构
  )
  SELECT d.CUST_ID                                            AS CUST_ID,             -- 客户编号
         '1'                                                  AS STATIS_TYP,          -- 承接类型：1-存款
         d.ACCT_ID                                            AS ACCT_ID,             -- 账户
         d.PRDKT_ID                                           AS PRDKT_ID,            -- 产品编号
         d.PRDKT_NAME                                         AS PRDKT_NAME,          -- 产品名称
         NVL(d.BAL, 0)                                        AS EXPR_AMT,            -- 到期金额
         TO_DATE(REPLACE(SUBSTR(d.EXPR_DATE, 1, 10), '-', ''), 'yyyymmdd') AS EXPR_DT,
         d.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         d.OPEN_ACCT_ORG                                      AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_DEPO d                                      -- 存款账户
   WHERE d.FIX_CURNT_FLG = '1'                                -- 0-活期，1-定期
     AND NVL(d.PRDKT_CATE_BIG, '') <> '04'                    -- 剔除通知存款
     AND d.EXPR_DATE IS NOT NULL
  UNION ALL
  SELECT f.CUST_ID                                            AS CUST_ID,             -- 客户编号
         '2'                                                  AS STATIS_TYP,          -- 承接类型：2-理财
         f.ACCT_ID                                            AS ACCT_ID,             -- 账户
         f.PRDKT_ID                                           AS PRDKT_ID,            -- 产品编号
         f.PRDKT_NAME                                         AS PRDKT_NAME,          -- 产品名称
         NVL(f.FIN_AMT, 0)                                    AS EXPR_AMT,            -- 到期金额
         TO_DATE(REPLACE(SUBSTR(f.EXPR_DATE, 1, 10), '-', ''), 'yyyymmdd') AS EXPR_DT,
         f.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         f.OPRT_ORG                                           AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_FIN f                                       -- 理财账户
   WHERE TRIM(f.EXPR_DATE) IS NOT NULL                        -- 有明确到期日的理财纳入到期范围；开放式理财分类代码待业务确认
    AND NVL(f.PRDKT_CATE_BIG, '') NOT IN ('1','3');           --理财产品大类 1代销-开放 2代销-封闭  3自营-开放 4自营-封闭

  -- 承接类型0：同客户存款和理财到期产品汇总（按客户+机构维度）。
  INSERT INTO TMP_CDR_DTL_MATURE_SRC (
      CUST_ID, STATIS_TYP, ACCT_ID, PRDKT_ID, PRDKT_NAME, EXPR_AMT, EXPR_DT, PERSN_LEGAL_BK_CODE, ORG_ID
  )
  SELECT CUST_ID, '0', ACCT_ID, PRDKT_ID, PRDKT_NAME, EXPR_AMT, EXPR_DT, PERSN_LEGAL_BK_CODE, ORG_ID
    FROM TMP_CDR_DTL_MATURE_SRC
   WHERE STATIS_TYP IN ('1', '2');

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第3段业务逻辑处理完成：生成到期产品源中间表';
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
  -- 2.3 -- 第4段处理开始：生成到期窗口中间表
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_DUE_WIN (
      STAT_PERD,            -- 统计周期：M-月，Q-季，N-年
      BGN_DT,               -- 统计周期开始日期
      END_DT,               -- 统计周期结束日期
      CUST_ID,              -- 客户编号
      STATIS_TYP,           -- 承接类型：0-全部，1-存款，2-理财
      FIRST_EXPR_DT,        -- 本期第一笔到期日期
      LAST_EXPR_DT,         -- 本期最后一笔到期日期
      EXPR_AMT,             -- 已到期金额
      MATURE_TTL_AMT,       -- 总到期金额
      TAKE_END_DT_30D,      -- 30天承接窗口结束日期
      PERSN_LEGAL_BK_CODE,  -- 法人行号
      ORG_ID                -- 归属机构
  )
  SELECT g.STAT_PERD,
         g.BGN_DT,
         g.END_DT,
         g.CUST_ID,
         g.STATIS_TYP,
         g.FIRST_EXPR_DT,
         g.LAST_EXPR_DT,
         g.EXPR_AMT,
         g.MATURE_TTL_AMT,
         NVL(
             (SELECT MIN(n.EXPR_DT) - 1
               FROM TMP_CDR_DTL_MATURE_SRC n
               WHERE n.CUST_ID = g.CUST_ID
                 AND n.STATIS_TYP = g.STATIS_TYP
                 AND n.PERSN_LEGAL_BK_CODE = g.PERSN_LEGAL_BK_CODE
                 AND n.ORG_ID = g.ORG_ID
                 AND n.EXPR_DT > g.LAST_EXPR_DT
                 AND n.EXPR_DT <= g.LAST_EXPR_DT + 30),
             g.LAST_EXPR_DT + 30
         ) AS TAKE_END_DT_30D,
         g.PERSN_LEGAL_BK_CODE,
         g.ORG_ID
    FROM (
          SELECT p.STAT_PERD,
                 p.BGN_DT,
                 p.END_DT,
                 m.CUST_ID,
                 m.STATIS_TYP,
                 m.PERSN_LEGAL_BK_CODE,
                 m.ORG_ID,
                 MIN(m.EXPR_DT) AS FIRST_EXPR_DT,
                 MAX(m.EXPR_DT) AS LAST_EXPR_DT,
                 SUM(CASE WHEN m.EXPR_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                          THEN NVL(m.EXPR_AMT, 0) ELSE 0 END) AS EXPR_AMT,
                 SUM(NVL(m.EXPR_AMT, 0)) AS MATURE_TTL_AMT
            FROM TMP_CDR_DTL_MATURE_SRC m
            JOIN TMP_CDR_DTL_PERIOD p
              ON m.EXPR_DT BETWEEN p.BGN_DT AND p.END_DT
           GROUP BY p.STAT_PERD, p.BGN_DT, p.END_DT, m.CUST_ID, m.STATIS_TYP, m.PERSN_LEGAL_BK_CODE, m.ORG_ID
         ) g;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第4段业务逻辑处理完成：生成30天到期承接窗口';
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
  -- 2.4 -- 第5段处理开始：生成购买产品源中间表
  --***************************************
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_PURCHASE_SRC (
      CUST_ID,             -- 客户编号
      PRDKT_TYP,          -- 购买产品类型：DEPO-存款，FIN-理财，INSUR-保险
      BUY_AMT,            -- 购买金额
      BUY_DT,             -- 购买日期
      PERSN_LEGAL_BK_CODE, -- 法人行号
      ORG_ID               -- 归属机构
  )
  SELECT d.CUST_ID                                            AS CUST_ID,             -- 客户编号
         'DEPO'                                               AS PRDKT_TYP,          -- 购买产品类型：存款
         NVL(d.BAL, 0)                                        AS BUY_AMT,            -- 购买金额
         TO_DATE(REPLACE(SUBSTR(d.INTRI_BGN_DATE, 1, 10), '-', ''), 'yyyymmdd') AS BUY_DT,
         d.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         d.OPEN_ACCT_ORG                                      AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_DEPO d                                      -- 存款账户
   WHERE d.FIX_CURNT_FLG = '1'
     AND NVL(d.PRDKT_CATE_BIG, '#') <> '04'
     AND d.INTRI_BGN_DATE IS NOT NULL
  UNION ALL
  SELECT f.CUST_ID                                            AS CUST_ID,             -- 客户编号
         'FIN'                                                AS PRDKT_TYP,          -- 购买产品类型：理财
         NVL(f.FIN_AMT, 0)                                    AS BUY_AMT,            -- 购买金额
         TO_DATE(REPLACE(SUBSTR(COALESCE(f.ESTAB_DATE, f.INTRI_BGN_DATE, f.ISSU_DATE), 1, 10), '-', ''), 'yyyymmdd') AS BUY_DT,
         f.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         f.OPRT_ORG                                           AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_FIN f                                       -- 理财账户
   WHERE NVL(f.PRDKT_CATE_BIG, '#') <> '开放式理财'          -- 已知文字值；其他开放式理财分类代码待业务确认
     AND COALESCE(f.ESTAB_DATE, f.INTRI_BGN_DATE, f.ISSU_DATE) IS NOT NULL
  UNION ALL
  SELECT i.CUST_ID                                            AS CUST_ID,             -- 客户编号
         'INSUR'                                              AS PRDKT_TYP,          -- 购买产品类型：保险
         NVL(i.INSUR_AMT, 0)                                  AS BUY_AMT,            -- 购买金额
         TO_DATE(REPLACE(SUBSTR(COALESCE(i.TX_DATE, i.BGN_INSUR_DATE), 1, 10), '-', ''), 'yyyymmdd') AS BUY_DT,
         i.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         i.ORG_ID                                             AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_INSUR i                                     -- 保险账户
   WHERE COALESCE(i.TX_DATE, i.BGN_INSUR_DATE) IS NOT NULL;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第5段业务逻辑处理完成：生成购买产品源中间表';
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
  -- 2.5 -- 第6段处理开始：生成承接金额中间表
  --***************************************
  V_NO_ID := '6';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_TAKE_AMT (
      STAT_PERD,            -- 统计周期：M-月，Q-季，N-年
      CUST_ID,              -- 客户编号
      STATIS_TYP,           -- 承接类型：0-全部，1-存款，2-理财
      TAKE_AMT_30D,         -- 30天长期化产品承接金额
      BUY_DEPO_AMT_30D,     -- 30天购买定期存款金额
      BUY_FIN_AMT_30D,      -- 30天购买理财金额
      BUY_INSUR_AMT_30D,    -- 30天购买保险金额
      FIRST_BUY_DT_30D,     -- 30天窗口内首次购买日期
      PERSN_LEGAL_BK_CODE,  -- 法人行号
      ORG_ID                -- 归属机构
  )
  SELECT w.STAT_PERD,
         w.CUST_ID,
         w.STATIS_TYP,
         SUM(CASE WHEN p.PRDKT_TYP IN ('DEPO', 'FIN')
                   AND p.BUY_DT BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                  THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS TAKE_AMT_30D,
         SUM(CASE WHEN p.PRDKT_TYP = 'DEPO'
                   AND p.BUY_DT BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                  THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_DEPO_AMT_30D,
         SUM(CASE WHEN p.PRDKT_TYP = 'FIN'
                   AND p.BUY_DT BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                  THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_FIN_AMT_30D,
         SUM(CASE WHEN p.PRDKT_TYP = 'INSUR'
                   AND p.BUY_DT BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                  THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_INSUR_AMT_30D,
         MIN(CASE WHEN p.PRDKT_TYP IN ('DEPO', 'FIN', 'INSUR')
                   AND p.BUY_DT BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                  THEN p.BUY_DT END) AS FIRST_BUY_DT_30D,
         w.PERSN_LEGAL_BK_CODE,
         w.ORG_ID
    FROM TMP_CDR_DTL_DUE_WIN w
    LEFT JOIN TMP_CDR_DTL_PURCHASE_SRC p
      ON p.CUST_ID = w.CUST_ID
     AND p.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
     AND p.ORG_ID = w.ORG_ID
     AND p.BUY_DT BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
   GROUP BY w.STAT_PERD, w.CUST_ID, w.STATIS_TYP, w.PERSN_LEGAL_BK_CODE, w.ORG_ID;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第6段业务逻辑处理完成：生成30天承接金额';
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
  -- 2.6 -- 第7段处理开始：生成客户基础及余额中间表
  --***************************************
  V_NO_ID := '7';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_CUST_BASE (
      CUST_ID,             -- 客户编号
      CUST_NAME,           -- 客户名称
      CUST_LVL,            -- 客户等级
      POST_ID,             -- 管户经理
      ORG_ID,              -- 归属机构
      DEPO_CURNT_DEPO_BAL, -- 活期余额
      FIXD_DEPO_BAL,       -- 定期余额
      FIN_AMT              -- 理财余额
  )
  SELECT c.CUST_ID                                           AS CUST_ID,             -- 客户编号
         c.CUST_NAME                                         AS CUST_NAME,           -- 客户名称
         c.CUST_HRAKY                                        AS CUST_LVL,            -- 客户等级
         c.HOST_CUST_MNGR_POST_ID                            AS POST_ID,             -- 管户经理
         c.ORG_LEAD                                          AS ORG_ID,              -- 归属机构
         NVL(b.DEPO_CURNT_DEPO_BAL, 0)                       AS DEPO_CURNT_DEPO_BAL, -- 活期余额
         NVL(b.FIXD_DEPO_BAL, 0)                             AS FIXD_DEPO_BAL,       -- 定期余额
         NVL(b.FIN_AMT, 0)                                   AS FIN_AMT              -- 理财余额
    FROM DWD_CUST_INDV_INFO c                                -- 客户基本信息
    LEFT JOIN (
          SELECT a.CUST_ID                                   AS CUST_ID,             -- 客户编号
                 SUM(NVL(a.DEPO_CURNT_DEPO_BAL, 0))           AS DEPO_CURNT_DEPO_BAL, -- 活期余额
                 SUM(NVL(a.DEPO_BAL, 0))                      AS FIXD_DEPO_BAL,       -- 定期余额
                 SUM(NVL(a.FIN_BAL, 0))                       AS FIN_AMT              -- 理财余额
            FROM DWS_CUST_ASSE_LIAB a                         -- 客户资产负债表
           WHERE a.DATA_DATE = V_SYSDAT                       -- 数据日期
             AND a.BAL_TYPE = '1'                             -- 余额类型
           GROUP BY a.CUST_ID
         ) b
      ON b.CUST_ID = c.CUST_ID;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第7段业务逻辑处理完成：生成客户基础及余额中间表';
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
  -- 2.7 -- 第8段处理开始：生成AUM中间表
  --***************************************
  V_NO_ID := '8';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_AUM_BAL (
      STAT_PERD,            -- 统计周期：M-月，Q-季，N-年
      CUST_ID,              -- 客户编号
      STATIS_TYP,           -- 承接类型：0-全部，1-存款，2-理财
      AUM_TYP,              -- AUM类型：PREV-第一笔到期前一日，CURR-当前日
      DATA_DATE,            -- AUM数据日期
      AUM_BAL,              -- AUM余额
      PERSN_LEGAL_BK_CODE,  -- 法人行号
      ORG_ID                -- 归属机构
  )
  SELECT w.STAT_PERD                                         AS STAT_PERD,  -- 统计周期：M-月，Q-季，N-年
         w.CUST_ID                                           AS CUST_ID,    -- 客户编号
         w.STATIS_TYP                                        AS STATIS_TYP, -- 承接类型：0-全部，1-存款，2-理财
         'PREV'                                              AS AUM_TYP,    -- AUM类型：第一笔到期前一日
         TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')            AS DATA_DATE,  -- AUM数据日期
         SUM(NVL(h.AUM_BAL, 0))                              AS AUM_BAL,    -- AUM余额
         w.PERSN_LEGAL_BK_CODE                               AS PERSN_LEGAL_BK_CODE,
         w.ORG_ID                                            AS ORG_ID
    FROM TMP_CDR_DTL_DUE_WIN w
    LEFT JOIN DWS_CUST_ASSE_LIAB h                           -- 客户资产负债表
      ON h.CUST_ID = w.CUST_ID
     AND h.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')
     AND h.BAL_TYPE = '1'                                    -- 余额类型
   GROUP BY w.STAT_PERD, w.CUST_ID, w.STATIS_TYP, TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd'), w.PERSN_LEGAL_BK_CODE, w.ORG_ID
  UNION ALL
  SELECT w.STAT_PERD                                         AS STAT_PERD,  -- 统计周期：M-月，Q-季，N-年
         w.CUST_ID                                           AS CUST_ID,    -- 客户编号
         w.STATIS_TYP                                        AS STATIS_TYP, -- 承接类型：1-存款，2-理财
         'CURR'                                              AS AUM_TYP,    -- AUM类型：当前日
         V_SYSDAT                                            AS DATA_DATE,  -- AUM数据日期
         SUM(NVL(c.AUM_BAL, 0))                              AS AUM_BAL,    -- AUM余额
         w.PERSN_LEGAL_BK_CODE                               AS PERSN_LEGAL_BK_CODE,
         w.ORG_ID                                            AS ORG_ID
    FROM TMP_CDR_DTL_DUE_WIN w
    LEFT JOIN DWS_CUST_ASSE_LIAB c                           -- 客户资产负债表
      ON c.CUST_ID = w.CUST_ID
     AND c.DATA_DATE = V_SYSDAT
     AND c.BAL_TYPE = '1'                                    -- 余额类型
   GROUP BY w.STAT_PERD, w.CUST_ID, w.STATIS_TYP, w.PERSN_LEGAL_BK_CODE, w.ORG_ID;

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第8段业务逻辑处理完成：生成当前和历史AUM中间表';
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
  -- 2.8 -- 第9段处理开始：写入到期承接明细表
  --***************************************
  V_NO_ID := '9';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_DEADLINE_RMND_DTL (
      PERSN_LEGAL_BK_CODE,                 -- 法人行号
      DATA_DATE,                         -- 数据日期
      CUST_ID,                           -- 客户编号
      CUST_NAME,                         -- 客户名称
      CUST_LVL,                          -- 客户等级
      DEPO_CURNT_DEPO_BAL,               -- 活期余额
      FIXD_DEPO_BAL,                     -- 定期余额
      FIN_AMT,                           -- 理财余额
      STAT_PERD,                         -- 统计周期：M-月，Q-季，N-年
      STATIS_TYP,                        -- 承接类型：0-全部，1-存款，2-理财
      EXPR_AMT,                          -- 到期金额
      MATURE_TTL_AMT,                    -- 到期总金额
      TAKE_RATE,                         -- 30天客户承接金额占比
      FIX_DEPO_MATURE_AMT,               -- 定期存款到期金额
      FIX_DEPO_MATURE_TTL_AMT,           -- 定期存款到期总金额
      FIX_DEPO_TAKE_RATE,                -- 定期存款30天承接率
      CNTCT_STATE,                       -- 接触状态
      UNDTAKE_STATE,                     -- 承接状态
      FIXED_FIN_MATURE_TRAN_INSUR_AMT,   -- 到期转保险金额
      FIN_MATURE_TRAN_FIXED_AMT,         -- 理财到期转定期金额
      FIXED_MATURE_TRAN_FIN_AMT,         -- 定期到期转理财金额
      FRST_MATURE_PK_BF_DAY_AUM_BAL,     -- 本期第一笔到期产品前一日AUM余额
      LAST_END_DATE,                     -- 本期最后一笔到期产品日期
      POST_ID,                           -- 管户经理
      ORG_ID                             -- 归属机构
  )
  SELECT
      w.PERSN_LEGAL_BK_CODE                                                    AS PERSN_LEGAL_BK_CODE,               -- 使用账户所属法人行号
      TO_CHAR(w.END_DT, 'yyyymmdd')                                           AS DATA_DATE,                         -- 周期结束日期（统一使用周期结束日）
      w.CUST_ID                                                                AS CUST_ID,                           -- 客户编号
      cb.CUST_NAME                                                             AS CUST_NAME,                         -- 客户名称
      cb.CUST_LVL                                                              AS CUST_LVL,                          -- 客户等级
      cb.DEPO_CURNT_DEPO_BAL                                                   AS DEPO_CURNT_DEPO_BAL,               -- 活期余额
      cb.FIXD_DEPO_BAL                                                         AS FIXD_DEPO_BAL,                     -- 定期余额
      cb.FIN_AMT                                                               AS FIN_AMT,                           -- 理财余额
      w.STAT_PERD                                                              AS STAT_PERD,                         -- 统计周期：M-月，Q-季，N-年
      w.STATIS_TYP                                                             AS STATIS_TYP,                        -- 承接类型：0-全部，1-存款，2-理财
      NVL(w.EXPR_AMT, 0)                                                       AS EXPR_AMT,                          -- 到期金额
      NVL(w.MATURE_TTL_AMT, 0)                                                 AS MATURE_TTL_AMT,                    -- 到期总金额
      CASE WHEN NVL(w.EXPR_AMT, 0) = 0 THEN 0
           ELSE ROUND(NVL(t.TAKE_AMT_30D, 0) / w.EXPR_AMT * 100, 2)
      END                                                                      AS TAKE_RATE,                         -- 30天客户承接金额占比
      CASE WHEN w.STATIS_TYP = '1' THEN NVL(w.EXPR_AMT, 0) ELSE 0 END          AS FIX_DEPO_MATURE_AMT,               -- 定期存款到期金额
      CASE WHEN w.STATIS_TYP = '1' THEN NVL(w.MATURE_TTL_AMT, 0) ELSE 0 END    AS FIX_DEPO_MATURE_TTL_AMT,           -- 定期存款到期总金额
      CASE WHEN w.STATIS_TYP = '1' AND NVL(w.EXPR_AMT, 0) <> 0
           THEN ROUND(NVL(t.BUY_DEPO_AMT_30D, 0) / w.EXPR_AMT * 100, 2)
           ELSE 0
      END                                                                      AS FIX_DEPO_TAKE_RATE,                -- 定期存款30天承接率
      CASE WHEN EXISTS (
                 SELECT 1
                   FROM ADS_MKT_REC_INFO m                                    -- 营销记录表
                  WHERE m.CUST_ID = w.CUST_ID
                    AND m.MKT_TIME IS NOT NULL
                    AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME, 1, 10), '-', ''), 'yyyymmdd') <= TO_DATE(V_SYSDAT, 'yyyymmdd')
             )
           THEN '1' ELSE '0'
      END                                                                      AS CNTCT_STATE,                       -- 接触状态
      CASE WHEN NVL(w.EXPR_AMT, 0) > 0
                 AND NVL(t.TAKE_AMT_30D, 0) / w.EXPR_AMT >= 0.8
           THEN '1' ELSE '0' END                                               AS UNDTAKE_STATE,                     -- 承接状态：30天长期化承接金额占已到期金额不低于80%
      NVL(t.BUY_INSUR_AMT_30D, 0)                                              AS FIXED_FIN_MATURE_TRAN_INSUR_AMT,   -- 30天到期转保险金额
      (SELECT NVL(SUM(x.BUY_DEPO_AMT_30D), 0) FROM TMP_CDR_DTL_TAKE_AMT x WHERE x.CUST_ID = w.CUST_ID AND x.STATIS_TYP = '2' AND x.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE AND x.ORG_ID = w.ORG_ID) AS FIN_MATURE_TRAN_FIXED_AMT, -- 理财到期30天转定期金额（按客户+机构维度）
      (SELECT NVL(SUM(x.BUY_FIN_AMT_30D), 0) FROM TMP_CDR_DTL_TAKE_AMT x WHERE x.CUST_ID = w.CUST_ID AND x.STATIS_TYP = '1' AND x.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE AND x.ORG_ID = w.ORG_ID) AS FIXED_MATURE_TRAN_FIN_AMT, -- 定期到期30天转理财金额（按客户+机构维度）
      NVL(ap.AUM_BAL, 0)                                                       AS FRST_MATURE_PK_BF_DAY_AUM_BAL,     -- 本期第一笔到期产品前一日AUM余额
      TO_CHAR(w.LAST_EXPR_DT, 'yyyymmdd')                                      AS LAST_END_DATE,                     -- 本期最后一笔到期产品日期
      cb.POST_ID                                                               AS POST_ID,                           -- 管户经理
      w.ORG_ID                                                                 AS ORG_ID                             -- 使用账户所属归属机构
    FROM TMP_CDR_DTL_DUE_WIN w
    LEFT JOIN TMP_CDR_DTL_TAKE_AMT t
      ON t.STAT_PERD = w.STAT_PERD
     AND t.CUST_ID = w.CUST_ID
     AND t.STATIS_TYP = w.STATIS_TYP
     AND t.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
     AND t.ORG_ID = w.ORG_ID
    LEFT JOIN TMP_CDR_DTL_CUST_BASE cb
      ON cb.CUST_ID = w.CUST_ID
    LEFT JOIN TMP_CDR_DTL_AUM_BAL ap
      ON ap.STAT_PERD = w.STAT_PERD
     AND ap.CUST_ID = w.CUST_ID
     AND ap.STATIS_TYP = w.STATIS_TYP
     AND ap.AUM_TYP = 'PREV'
     AND ap.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
     AND ap.ORG_ID = w.ORG_ID;

  -- 当前周期只保留最新跑批快照；历史只保留对应期末，且最多三年。
  DELETE FROM ADS_CUST_DEADLINE_RMND_DTL d
   WHERE d.DATA_DATE <> V_SYSDAT
     AND (
          TO_DATE(d.DATA_DATE, 'yyyymmdd') < ADD_MONTHS(TRUNC(TO_DATE(V_SYSDAT, 'yyyymmdd'), 'YYYY'), -36)
          OR (d.STAT_PERD = 'M' AND d.DATA_DATE <> TO_CHAR(LAST_DAY(TO_DATE(d.DATA_DATE, 'yyyymmdd')), 'yyyymmdd'))
          OR (d.STAT_PERD = 'Q' AND d.DATA_DATE <> TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(d.DATA_DATE, 'yyyymmdd'), 'Q'), 3) - 1, 'yyyymmdd'))
          OR (d.STAT_PERD = 'N' AND d.DATA_DATE <> TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(d.DATA_DATE, 'yyyymmdd'), 'YYYY'), 12) - 1, 'yyyymmdd'))
     );

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第9段业务逻辑处理完成：写入到期承接明细表';
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
