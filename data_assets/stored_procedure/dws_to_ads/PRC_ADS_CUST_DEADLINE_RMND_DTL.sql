-- DROP PROCEDURE crmdm.prc_ads_cust_deadline_rmnd_dtl(in varchar, out int4);

CREATE OR REPLACE PROCEDURE crmdm.prc_ads_cust_deadline_rmnd_dtl(
    v_sysdat varchar,      -- 输入参数：系统跑批日期，格式YYYYMMDD；业务口径T-1日=V_SYSDAT
    outcde OUT integer     -- 输出参数：返回码（0=成功，-1=异常）
)
AS 
  ------------------------------------------------------------------
  -- 存储过程名称: 到期承接明细表处理
  -- 存储过程编号: PRC_ADS_CUST_DEADLINE_RMND_DTL
  -- 处理周期: 日
  -- 过程描述: 分段生成到期承接明细,物理中间表仅做 TRUNCATE/INSERT,便于排查
  -- 来源表: DWD_CUST_INDV_INFO(客户基本信息), DWD_ACCT_DEPO(存款账户),
  --         DWD_ACCT_FIN(理财账户), DWD_ACCT_INSUR(保险账户),
  --         DWS_CUST_ASSE_LIAB(客户资产负债表)、DWS_CUST_ASSE_LIAB_HIS(历史日期),
  --         ADS_MKT_REC_INFO(营销记录表)
  -- 目标表: ADS_CUST_DEADLINE_RMND_DTL(到期承接明细表)
  -- author :
  -- date   : 2026-07-15
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.7.0
  -- 关联需求: REQ-CUST-001, REQ-CUST-002
  -- 变更记录:
  --   v3.1.1: DUE_WIN生成优化：两条INSERT合并为一条（统一窗口子查询w × 按类型金额子查询a），
  --           三个日期字段统一来自w，金额按类型独立来自a，逻辑更清晰
   --   v3.2.0【待确认】: 段8 AUM基准查询(DATA_DATE=本期第一笔到期日前一日)改用DWS_CUST_ASSE_LIAB_HIS(与当期表同构)
  --   v3.1.0: 1.F-01修复：30天到期窗口仅按STATIS_TYP=0统一计算（口径40），STATIS_TYP=1/2
  --             JOIN复用统一窗口日期(FIRST_EXPR_DT/LAST_EXPR_DT/TAKE_END_DT_30D)，
  --             金额按类型独立汇总；消除存款/理财页签窗口被缩短导致承接金额遗漏
  --           2.F-02修复：理财购买源过滤条件由文字'开放式理财'改为数字代码NOT IN('1','3')，
  --             与到期源过滤条件统一(口径3)
  --   v3.0.0: 两期计算完全分离架构（单过程、单块分段落、禁止嵌套过程）：
  --           段9为单个BEGIN...END块，块内以注释段落分隔本期计算段(C1/C2)/上期计算段(P1/P2)/
  --           数据验证段(V1)；独立存储TMP_CDR_DTL_CURR_STAGE/TMP_CDR_DTL_PREV_STAGE/
  --           FREEZE_LOG/VALIDATE_RESULT；严格边界检查(RAISE -2001x)；日志内联并C/P/V前缀隔离
  --   v2.8.1: 注释规范化：补齐输入输出参数、变量、各处理段(数据来源/业务含义/处理逻辑)注释
  --   v2.9.0: 1.上期基础数据冻结(口径34)：段1不再删除上期行，仅删除本期快照
  --           2.上期仅定点更新7字段(口径35)：TAKE_RATE/FIX_DEPO_TAKE_RATE/UNDTAKE_STATE/
  --             CNTCT_STATE/FIXED_FIN_MATURE_TRAN_INSUR_AMT/FIN_MATURE_TRAN_FIXED_AMT/
  --             FIXED_MATURE_TRAN_FIN_AMT，随30天承接窗口滚动更新
  --           3.DATA_DATE双语义(口径37)：本期行=跑批日期V_SYSDAT，上期行=期末日期
  --           4.承接窗口购买增加BUY_DT<=V_SYSDAT截止(口径39)，与EXPR_AMT截止口径对齐
  --   v2.8.0: 1.DWS关联统一补 BAL_TYPE='1' 并移除关联键 ORG_ID（口径15/22/23）
  --           2.CROSS_CONV增加STATIS_TYP维度；TAKE_AMT/AUM_BAL按客户+法人行粒度（口径11/23）
  --           3.接触状态改为30天承接窗口判定（口径30）
  --   v2.7.0: 1.EXPR_AMT截止日期V_PREV_DAY→V_SYSDAT(自然日=跑批日期)
  --           2.CROSS_CONV增加STAT_PERD维度(修复跨类型转化金额月/季/年混淆)
  --   v2.6.0: 1.存款/理财账户JOIN DWS补ORG_ID三键关联(账户表),资产表法人行优先关联
  --           2.合并DWS_CUST_ASSE_LIAB当前AUM查询到CUST_BASE(减少1次大表扫描)
  --           3.跨类型转化金额改为预聚合临时表TMP_CDR_DTL_CROSS_CONV(消除N×2关联子查询)
  --           4.简化DELETE历史清理逻辑(去掉冗余周期末日校验,仅保留三年边界)
  --           5.TMP_CDR_DTL_CUST_BASE列名ORG_ID修正为PERSN_LEGAL_BK_CODE
  --   v2.5.0: 所有基于跑批日的业务日期均使用 SYS_FUN_DEAL_DATE 具名参数；目标表日期统一输出 YYYYMMDD。
  --   v2.2.0: 1.计算粒度调整：因法人行有多个,一个客户在不同归属机构/法人行算多个客户,需分开计算
  --           2.客户号+归属机构(经办机构)/法人机构才能算作一个计算单位
  --           3.到期产品源、到期窗口、购买产品源、承接金额、AUM中间表均按客户+机构维度分组
  --           4.法人行号和归属机构从账户表获取(DWD_ACCT_DEPO.OPEN_ACCT_ORG, DWD_ACCT_FIN.OPRT_ORG)
  --   v2.1.0: 1.资产承接率统计周期从14天改为30天
  --           2.到期窗口计算逻辑调整为取下一笔到期日减1(如果30天内有下一笔到期),否则取最后一笔到期日+30
  --           3.理财到期转定期金额和定期到期转理财金额计算逻辑优化(跨STATIS_TYP统计)
  --           4.客户承接率长期化产品已剔除保险：TAKE_AMT_30D 仅统计 DEPO/FIN
  --           5.定期存款承接率已过滤通知存款：PRDKT_CATE_BIG <> '04'
  --           6.DATA_DATE语义变更：统一使用周期结束日期(M-月末,Q-季末,Y-年末),不再使用快照日期
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  --***************************************
  --1.自定义参数区
  --***************************************
  V_PRC_DESC             VARCHAR(100) := '到期承接明细表处理';                    -- 过程描述（日志用）
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_DEADLINE_RMND_DTL';       -- 过程名称（日志用）
  -- V_SYSDAT 为跑批日期：用于源表 DATA_DATE 快照等值关联，不表示需求语义中的上一日。
  V_PREV_DAY             VARCHAR2(8);  -- 上一日：跑批日期的上一日，取 SYS_FUN_DEAL_DATE(V_SYSDAT, 1)。
  V_CURR_MONTH_BEGIN     VARCHAR2(8);  -- 当月初：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 9)。
  V_CURR_MONTH_END       VARCHAR2(8);  -- 当月末：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 10)。
  V_CURR_QUARTER_BEGIN   VARCHAR2(8);  -- 当季初：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 11)。
  V_CURR_QUARTER_END     VARCHAR2(8);  -- 当季末：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 12)。
  V_CURR_YEAR_BEGIN      VARCHAR2(8);  -- 当年初：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 13)。
  V_CURR_YEAR_END        VARCHAR2(8);  -- 当年末：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 14)。
  V_PREV_MONTH_BEGIN     VARCHAR2(8);  -- 上月初：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 15)。
  V_PREV_QUARTER_BEGIN   VARCHAR2(8);  -- 上季初：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 16)。
  V_PREV_YEAR_BEGIN      VARCHAR2(8);  -- 上年初：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 17)。
  V_SQL                  VARCHAR(32767);  -- V_SQL：预留动态SQL变量（当前未使用）
  V_LOG_MSG              VARCHAR(4000);   -- V_LOG_MSG：日志消息文本
  V_START_DT             DATE;            -- V_START_DT：过程开始时间（耗时统计用）
  V_LOG_FLG              INTEGER;         -- V_LOG_FLG：日志标志（0=成功，-1=异常）
  V_LOG_BUTTON           INTEGER := 1;    -- V_LOG_BUTTON：日志记录开关（1=记录）
  V_NO_ID                VARCHAR(10);     -- V_NO_ID：当前处理步骤编号（日志定位用）
  V_BGN_DATE             DATE;            -- V_BGN_DATE：当前步骤开始时间
  V_END_DATE             DATE;            -- V_END_DATE：当前步骤结束时间
  V_DURA_DATE            INTEGER;         -- V_DURA_DATE：当前步骤耗时（秒）
  P_INTERVAL_START_DATE  VARCHAR(8);   -- 30天承接窗口开始日：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 18)。
  P_INTERVAL_END_DATE    VARCHAR(8);   -- 30天承接窗口结束日：上一日，即 V_PREV_DAY。
  V_PREV_MONTH_END       VARCHAR2(8);  -- 上月末：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 2)。
  V_PREV_QUARTER_END     VARCHAR2(8);  -- 上季末：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 3)。
  V_PREV_YEAR_END        VARCHAR2(8);  -- 上年末：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 4)。
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);  -- 三年历史清理边界：取 SYS_FUN_DEAL_DATE(V_SYSDAT, 19)。

BEGIN
  --***************************************
  -- 2. 业务逻辑区
  --***************************************
  -- 1. 校验跑批日期并初始化全部相对业务日期具名参数（sys_fun_deal_date，编号定义见
  --    governance/stored_procedure_date_parameter_rules.md）
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_START_DT := SYSDATE;
  V_PREV_DAY := sys_fun_deal_date(V_SYSDAT, 1);
  V_CURR_MONTH_BEGIN := sys_fun_deal_date(V_SYSDAT, 9);
  V_CURR_MONTH_END := sys_fun_deal_date(V_SYSDAT, 10);
  V_CURR_QUARTER_BEGIN := sys_fun_deal_date(V_SYSDAT, 11);
  V_CURR_QUARTER_END := sys_fun_deal_date(V_SYSDAT, 12);
  V_CURR_YEAR_BEGIN := sys_fun_deal_date(V_SYSDAT, 13);
  V_CURR_YEAR_END := sys_fun_deal_date(V_SYSDAT, 14);
  V_PREV_MONTH_BEGIN := sys_fun_deal_date(V_SYSDAT, 15);
  V_PREV_QUARTER_BEGIN := sys_fun_deal_date(V_SYSDAT, 16);
  V_PREV_YEAR_BEGIN := sys_fun_deal_date(V_SYSDAT, 17);
  P_INTERVAL_START_DATE := sys_fun_deal_date(V_SYSDAT, 18);
  P_INTERVAL_END_DATE   := V_PREV_DAY;
  V_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 2);
  V_PREV_QUARTER_END := sys_fun_deal_date(V_SYSDAT, 3);
  V_PREV_YEAR_END := sys_fun_deal_date(V_SYSDAT, 4);
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);

  --***************************************
  -- 2.0 -- 第1段处理开始：清理目标表和中间表
  -- 业务含义：幂等重跑准备——仅删除本期快照行(DATA_DATE=V_SYSDAT)及旧语义当期结束日行，
  --           严格保留上期(上月/上季/上年)基础数据行(口径34)，并清空全部物理中间表
  -- 数据来源：ADS_CUST_DEADLINE_RMND_DTL + 12张TMP_CDR_DTL_*中间表/隔离存储
  -- 处理逻辑：DELETE(本期快照+旧语义当期结束日) + TRUNCATE_TMP × 12
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_DEADLINE_RMND_DTL
   -- v2.9.0(口径28/34/37): 每日替换——删除当期周期区间内的本期快照行
   --                        (当月初/季初/年初~V_SYSDAT)，上期行不删除
   WHERE (STAT_PERD = 'M' AND DATA_DATE >= V_CURR_MONTH_BEGIN AND DATA_DATE <= V_SYSDAT)
      OR (STAT_PERD = 'Q' AND DATA_DATE >= V_CURR_QUARTER_BEGIN AND DATA_DATE <= V_SYSDAT)
      OR (STAT_PERD = 'Y' AND DATA_DATE >= V_CURR_YEAR_BEGIN AND DATA_DATE <= V_SYSDAT)
      -- 过渡期清理：旧语义生成的当期结束日行(仅首日存在，后续幂等无影响)
      OR (STAT_PERD = 'M' AND DATA_DATE = V_CURR_MONTH_END)
      OR (STAT_PERD = 'Q' AND DATA_DATE = V_CURR_QUARTER_END)
      OR (STAT_PERD = 'Y' AND DATA_DATE = V_CURR_YEAR_END);
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_PERIOD';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_MATURE_SRC';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_DUE_WIN';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_PURCHASE_SRC';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_TAKE_AMT';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_CUST_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_AUM_BAL';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_CROSS_CONV';
  -- v3.0.0: 两期隔离存储与验证日志
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_CURR_STAGE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_PREV_STAGE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_DTL_FREEZE_LOG';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_VALIDATE_RESULT';

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
  -- 业务含义：生成当前+上一周期的 M/Q/Y 六条统计周期区间，供到期窗口归属判断
  -- 数据来源：sys_fun_deal_date 具名参数（9~17 对应当期/上期初末）
  -- 处理逻辑：UNION ALL 六行（M/Q/Y 当期+上期），BGN_DT/END_DT 均为 DATE 类型
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_PERIOD (
      STAT_PERD, -- 统计周期：M-月,Q-季,Y-年
      BGN_DT,    -- 统计周期开始日期
      END_DT     -- 统计周期结束日期
  )
  SELECT 'M' AS STAT_PERD,
         TO_DATE(V_CURR_MONTH_BEGIN, 'yyyymmdd') AS BGN_DT,
         TO_DATE(V_CURR_MONTH_END, 'yyyymmdd') AS END_DT
    FROM dual
  UNION ALL
  SELECT 'Q' AS STAT_PERD,
         TO_DATE(V_CURR_QUARTER_BEGIN, 'yyyymmdd') AS BGN_DT,
         TO_DATE(V_CURR_QUARTER_END, 'yyyymmdd') AS END_DT
    FROM dual
  UNION ALL
  SELECT 'Y' AS STAT_PERD,
         TO_DATE(V_CURR_YEAR_BEGIN, 'yyyymmdd') AS BGN_DT,
         TO_DATE(V_CURR_YEAR_END, 'yyyymmdd') AS END_DT
    FROM dual
  UNION ALL
  SELECT 'M' AS STAT_PERD,
         TO_DATE(V_PREV_MONTH_BEGIN, 'yyyymmdd') AS BGN_DT,
         TO_DATE(V_PREV_MONTH_END, 'yyyymmdd') AS END_DT
    FROM dual
  UNION ALL
  SELECT 'Q' AS STAT_PERD,
         TO_DATE(V_PREV_QUARTER_BEGIN, 'yyyymmdd') AS BGN_DT,
         TO_DATE(V_PREV_QUARTER_END, 'yyyymmdd') AS END_DT
    FROM dual
  UNION ALL
  SELECT 'Y' AS STAT_PERD,
         TO_DATE(V_PREV_YEAR_BEGIN, 'yyyymmdd') AS BGN_DT,
         TO_DATE(V_PREV_YEAR_END, 'yyyymmdd') AS END_DT
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
  -- 业务含义：提取当期有明确到期日的定期存款与理财到期产品（含产品级金额/到期日）
  -- 数据来源：DWD_ACCT_DEPO(FIX_CURNT_FLG='1'且非通知存款)、DWD_ACCT_FIN(剔除开放理财1/3)
  --          + DWS_CUST_ASSE_LIAB(CA：客户号+法人行号关联，BAL_TYPE='1'，口径15)
  -- 处理逻辑：两段UNION后复制生成承接类型0（同客户存款+理财合并到期）
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_MATURE_SRC (
      CUST_ID,             -- 客户编号
      STATIS_TYP,          -- 承接类型：0-全部,1-存款,2-理财
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
         sum(NVL(d.BAL, 0))                                        AS EXPR_AMT,            -- 到期金额
         TO_DATE(REPLACE(SUBSTR(d.EXPR_DATE, 1, 10), '-', ''), 'yyyymmdd') AS EXPR_DT,
         CA.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         CA.ORG_ID                                             AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_DEPO d                                      -- 存款账户
  INNER JOIN DWS_CUST_ASSE_LIAB CA
  ON CA.CUST_ID = D.CUST_ID
  AND CA.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE
   WHERE d.FIX_CURNT_FLG = '1'                                -- 0-活期,1-定期
     AND NVL(d.PRDKT_CATE_BIG, '') <> '04'                    -- 剔除通知存款
     AND d.EXPR_DATE IS NOT NULL
     AND CA.DATA_DATE = V_SYSDAT
     AND CA.BAL_TYPE = '1'                                     -- 统一取余额类型（口径15）
     group by d.CUST_ID,
     d.ACCT_ID,
     d.PRDKT_ID,
     d.PRDKT_NAME,
     TO_DATE(REPLACE(SUBSTR(d.EXPR_DATE, 1, 10), '-', ''), 'yyyymmdd'),
     CA.PERSN_LEGAL_BK_CODE,
     CA.ORG_ID
  UNION ALL
  SELECT f.CUST_ID                                            AS CUST_ID,             -- 客户编号
         '2'                                                  AS STATIS_TYP,          -- 承接类型：2-理财
         f.ACCT_ID                                            AS ACCT_ID,             -- 账户
         f.PRDKT_ID                                           AS PRDKT_ID,            -- 产品编号
         f.PRDKT_NAME                                         AS PRDKT_NAME,          -- 产品名称
         SUM(NVL(f.FIN_AMT, 0))                                    AS EXPR_AMT,            -- 到期金额
         TO_DATE(REPLACE(SUBSTR(f.EXPR_DATE, 1, 10), '-', ''), 'yyyymmdd') AS EXPR_DT,
         CA.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         CA.ORG_ID                                             AS ORG_ID               -- 归属机构
    FROM DWD_ACCT_FIN f                                       -- 理财账户
    INNER JOIN DWS_CUST_ASSE_LIAB CA
  ON CA.CUST_ID = F.CUST_ID
  AND CA.PERSN_LEGAL_BK_CODE = F.PERSN_LEGAL_BK_CODE
   WHERE TRIM(f.EXPR_DATE) IS NOT NULL                        -- 有明确到期日的理财纳入到期范围；开放式理财分类代码待业务确认
     AND NVL(f.PRDKT_CATE_BIG, '') NOT IN ('1','3')            --理财产品大类 1代销-开放 2代销-封闭  3自营-开放 4自营-封闭
     AND CA.DATA_DATE = V_SYSDAT 
     AND CA.BAL_TYPE = '1'                                     -- 统一取余额类型（口径15）
  group by f.CUST_ID,
  f.ACCT_ID,
  f.PRDKT_ID,
  f.PRDKT_NAME,
  TO_DATE(REPLACE(SUBSTR(f.EXPR_DATE, 1, 10), '-', ''), 'yyyymmdd'),
  CA.PERSN_LEGAL_BK_CODE,
  CA.ORG_ID;
  -- 承接类型0：同客户存款和理财到期产品汇总(按客户+机构维度)。
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
  -- 业务含义：三个日期字段(FIRST_EXPR_DT/LAST_EXPR_DT/TAKE_END_DT_30D)均按STATIS_TYP=0
  --           (全部产品)统一计算（口径40），金额(EXPR_AMT/MATURE_TTL_AMT)按类型独立汇总
  -- 数据来源：TMP_CDR_DTL_MATURE_SRC × TMP_CDR_DTL_PERIOD
  -- 处理逻辑：单条INSERT，统一窗口子查询w × 按类型金额子查询a，一次JOIN完成
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  -- 统一窗口(口径40)：w子查询提供三个日期字段(仅STATIS_TYP=0计算)，a子查询提供按类型金额
  INSERT INTO TMP_CDR_DTL_DUE_WIN (
      STAT_PERD,            -- 统计周期：M-月,Q-季,Y-年
      BGN_DT,               -- 统计周期开始日期
      END_DT,               -- 统计周期结束日期
      CUST_ID,              -- 客户编号
      STATIS_TYP,           -- 承接类型：0-全部,1-存款,2-理财
      FIRST_EXPR_DT,        -- 本期第一笔到期日期（统一，来自STATIS_TYP=0）
      LAST_EXPR_DT,         -- 本期最后一笔到期日期（统一，来自STATIS_TYP=0）
      EXPR_AMT,             -- 已到期金额（按类型独立）
      MATURE_TTL_AMT,       -- 总到期金额（按类型独立）
      TAKE_END_DT_30D,      -- 30天承接窗口结束日期（统一，来自STATIS_TYP=0）
      PERSN_LEGAL_BK_CODE,  -- 法人行号
      ORG_ID                -- 归属机构
  )
  SELECT w.STAT_PERD,
         w.BGN_DT,
         w.END_DT,
         a.CUST_ID,
         a.STATIS_TYP,                                          -- 0-全部/1-存款/2-理财
         w.FIRST_EXPR_DT,                                       -- 统一窗口（全部产品最早到期日）
         w.LAST_EXPR_DT,                                        -- 统一窗口（全部产品最晚到期日）
         a.EXPR_AMT,                                            -- 金额按类型独立
         a.MATURE_TTL_AMT,                                      -- 金额按类型独立
         w.TAKE_END_DT_30D,                                     -- 统一窗口
         a.PERSN_LEGAL_BK_CODE,
         a.ORG_ID
    FROM (
          -- 统一窗口子查询w：仅STATIS_TYP=0(全部产品)计算FIRST/LAST_EXPR_DT + TAKE_END_DT_30D
          SELECT g.STAT_PERD, g.BGN_DT, g.END_DT, g.CUST_ID,
                 g.PERSN_LEGAL_BK_CODE, g.ORG_ID,
                 g.FIRST_EXPR_DT, g.LAST_EXPR_DT,
                 NVL(
                     -- 窗口结束点优先级(口径16)：初始=最后一笔到期日+30天；
                     -- 若下一期到期日落在该+30范围内，取下一期到期日前一日为最终结束点
                     (SELECT MIN(n.EXPR_DT) - 1
                       FROM TMP_CDR_DTL_MATURE_SRC n
                       WHERE n.CUST_ID = g.CUST_ID
                         AND n.STATIS_TYP = '0'                                      -- 统一窗口：查全部产品
                         AND n.PERSN_LEGAL_BK_CODE = g.PERSN_LEGAL_BK_CODE
                         AND n.ORG_ID = g.ORG_ID
                         AND n.EXPR_DT > g.LAST_EXPR_DT
                         AND n.EXPR_DT <= g.LAST_EXPR_DT + 30),
                     g.LAST_EXPR_DT + 30
                 ) AS TAKE_END_DT_30D
            FROM (
                  SELECT p.STAT_PERD, p.BGN_DT, p.END_DT, m.CUST_ID,
                         m.PERSN_LEGAL_BK_CODE, m.ORG_ID,
                         MIN(m.EXPR_DT) AS FIRST_EXPR_DT,
                         MAX(m.EXPR_DT) AS LAST_EXPR_DT
                    FROM TMP_CDR_DTL_MATURE_SRC m
                    JOIN TMP_CDR_DTL_PERIOD p
                      ON m.EXPR_DT BETWEEN p.BGN_DT AND p.END_DT
                   WHERE m.STATIS_TYP = '0'                                          -- 仅STATIS_TYP=0计算统一窗口
                   GROUP BY p.STAT_PERD, p.BGN_DT, p.END_DT, m.CUST_ID, m.PERSN_LEGAL_BK_CODE, m.ORG_ID
                 ) g
         ) w
    JOIN (
          -- 按类型金额子查询a：STATIS_TYP=0(全部)+1(存款)+2(理财)各自汇总金额
          SELECT p.STAT_PERD, p.BGN_DT, p.END_DT, m.CUST_ID, m.STATIS_TYP,
                 m.PERSN_LEGAL_BK_CODE, m.ORG_ID,
                 -- 已到期金额截止日=跑批日V_SYSDAT(口径12/T-1)
                 SUM(CASE WHEN m.EXPR_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                          THEN NVL(m.EXPR_AMT, 0) ELSE 0 END) AS EXPR_AMT,
                 SUM(NVL(m.EXPR_AMT, 0)) AS MATURE_TTL_AMT
            FROM TMP_CDR_DTL_MATURE_SRC m
            JOIN TMP_CDR_DTL_PERIOD p
              ON m.EXPR_DT BETWEEN p.BGN_DT AND p.END_DT
           WHERE m.STATIS_TYP IN ('0', '1', '2')                     -- 0=全部产品,1=存款,2=理财
           GROUP BY p.STAT_PERD, p.BGN_DT, p.END_DT, m.CUST_ID, m.STATIS_TYP, m.PERSN_LEGAL_BK_CODE, m.ORG_ID
         ) a
      ON a.STAT_PERD = w.STAT_PERD
     AND a.BGN_DT = w.BGN_DT
     AND a.END_DT = w.END_DT
     AND a.CUST_ID = w.CUST_ID
     AND a.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
     AND a.ORG_ID = w.ORG_ID;

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
  -- 业务含义：提取客户在承接窗口内的购买记录（存款/理财/保险），用于承接与转化率计算
  -- 数据来源：DWD_ACCT_DEPO(定期非通知)、DWD_ACCT_FIN(非开放理财)、DWD_ACCT_INSUR
  -- 处理逻辑：购买日期统一为购买发生日期(口径19)：DEPO=INTRI_BGN_DATE；FIN=ESTAB/INTRI/ISSU顺序；INSUR=TX/BGN_INSUR顺序
  --***************************************
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_PURCHASE_SRC (
      CUST_ID,             -- 客户编号
      PRDKT_TYP,          -- 购买产品类型：DEPO-存款,FIN-理财,INSUR-保险
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
   WHERE NVL(f.PRDKT_CATE_BIG, '#') NOT IN ('1','3')          -- 剔除开放式理财(口径3: PRDKT_CATE_BIG=1或3为开放式)，与到期源过滤一致
     AND COALESCE(f.ESTAB_DATE, f.INTRI_BGN_DATE, f.ISSU_DATE) IS NOT NULL
  UNION ALL
  SELECT i.CUST_ID                                            AS CUST_ID,             -- 客户编号
         'INSUR'                                              AS PRDKT_TYP,          -- 购买产品类型：保险
         NVL(i.INSUR_AMT, 0)                                  AS BUY_AMT,            -- 购买金额
         TO_DATE(REPLACE(SUBSTR(COALESCE(i.TX_DATE, i.BGN_INSUR_DATE), 1, 10), '-', ''), 'yyyymmdd') AS BUY_DT,
         i.PERSN_LEGAL_BK_CODE                                AS PERSN_LEGAL_BK_CODE, -- 法人行号
         i.MKT_ORG                                             AS ORG_ID               -- 归属机构
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
  -- 业务含义：按客户+承接类型汇总30天窗口内各类购买金额与首次购买日期
  -- 数据来源：TMP_CDR_DTL_DUE_WIN × TMP_CDR_DTL_PURCHASE_SRC（客户号+法人行号关联，计算单位=客户+法人行）
  -- 处理逻辑：TAKE_AMT_30D 仅统计DEPO/FIN(长期化)；购买计入到期产品所属原统计周期(口径26)
  --***************************************
  V_NO_ID := '6';
  V_BGN_DATE := SYSDATE;

  -- DEFECT-006 修复(2026-08-01): 承接金额不再按 STAT_PERD 聚合写入 TAKE_AMT 中间表,
  -- 改为在第9段最终写入明细时按统计周期实例(BGN_DT/END_DT)内联计算,
  -- 避免上季/上月与当季/当月周期合并导致的购买金额错配。
  -- TMP_CDR_DTL_TAKE_AMT 表结构保留(第1段仍 TRUNCATE), 不再生成数据。

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
  -- 2.5.1 -- 第6.1段处理开始：生成跨类型转化金额中间表(优化:预聚合替代关联子查询)
  -- 业务含义：理财到期转定期金额(STATIS_TYP=2)、定期到期转理财金额(STATIS_TYP=1)，按类型预聚合
  -- 数据来源：TMP_CDR_DTL_TAKE_AMT
  -- 处理逻辑：按 STAT_PERD+CUST_ID+STATIS_TYP+PERSN_LEGAL_BK_CODE 分组(口径11)，避免明细层跨类型混计
  --***************************************
  V_NO_ID := '6.1';
  V_BGN_DATE := SYSDATE;

  -- DEFECT-006 修复(2026-08-01): 跨类型转化金额同样改为第9段内联计算(按周期实例),
  -- TMP_CDR_DTL_CROSS_CONV 表结构保留, 不再生成数据。

  COMMIT;

  OUTCDE      := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第6.1段业务逻辑处理完成：生成跨类型转化金额中间表';
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
  -- 业务含义：客户名称/等级/管户经理及当前余额(AUM/活期/定期/理财)，供明细展示与留存率计算
  -- 数据来源：DWD_CUST_INDV_INFO、DWS_CUST_LVL_INFO(DATA_DATE=V_SYSDAT)、DWD_CUST_MAN(MNG_TYP='1')
  --          + DWS_CUST_ASSE_LIAB(当前余额，DATA_DATE=V_SYSDAT且BAL_TYPE='1'，按客户+法人行聚合)
  -- 处理逻辑：LEFT JOIN补属性，余额统一按客户号+法人行号口径
  --***************************************
  V_NO_ID := '7';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_CUST_BASE (
      CUST_ID,             -- 客户编号
      CUST_NAME,           -- 客户名称
      CUST_LVL,            -- 客户等级
      POST_ID,             -- 管户经理
      PERSN_LEGAL_BK_CODE, -- 法人行号
      DEPO_CURNT_DEPO_BAL, -- 活期余额
      FIXD_DEPO_BAL,       -- 定期余额
      FIN_AMT,             -- 理财余额
      AUM_BAL              -- 当前AUM余额
  )
  SELECT c.CUST_ID                                           AS CUST_ID,             -- 客户编号
         c.CUST_NAME                                         AS CUST_NAME,           -- 客户名称
         CL.CUST_LVL                                         AS CUST_LVL,            -- 客户等级
         CM.MNGR_POST_ID                                     AS POST_ID,             -- 管户经理
         C.PERSN_LEGAL_BK_CODE                               AS PERSN_LEGAL_BK_CODE, -- 归属机构
         NVL(b.DEPO_CURNT_DEPO_BAL, 0)                       AS DEPO_CURNT_DEPO_BAL, -- 活期余额
         NVL(b.FIXD_DEPO_BAL, 0)                             AS FIXD_DEPO_BAL,       -- 定期余额
         NVL(b.FIN_AMT, 0)                                   AS FIN_AMT,              -- 理财余额
         NVL(b.AUM_BAL, 0)                                   AS AUM_BAL               -- 当前AUM余额
    FROM DWD_CUST_INDV_INFO c                                -- 客户基本信息
    LEFT JOIN DWS_CUST_LVL_INFO CL
           on CL.CUST_ID = C.CUST_ID
          and CL.PERSN_LEGAL_BK_CODE = C.PERSN_LEGAL_BK_CODE
          AND CL.DATA_DATE = V_SYSDAT
    LEFT JOIN DWD_CUST_MAN CM
           on CM.CUST_ID = C.cust_id
          and CM.PERSN_LEGAL_BK_CODE = C.PERSN_LEGAL_BK_CODE
          and CM.mng_typ = '1'
    LEFT JOIN (
          SELECT a.CUST_ID                                    AS CUST_ID,             -- 客户编号
                 A.PERSN_LEGAL_BK_CODE                        AS PERSN_LEGAL_BK_CODE, --法人行号
                 SUM(NVL(a.DEPO_CURNT_DEPO_BAL, 0))           AS DEPO_CURNT_DEPO_BAL, -- 活期余额
                 SUM(NVL(a.DEPO_BAL, 0))                      AS FIXD_DEPO_BAL,       -- 定期余额
                 SUM(NVL(a.FIN_BAL, 0))                       AS FIN_AMT,              -- 理财余额
                 SUM(NVL(a.AUM_BAL, 0))                       AS AUM_BAL               -- 当前AUM余额
            FROM DWS_CUST_ASSE_LIAB a                         -- 客户资产负债表
           WHERE a.DATA_DATE = V_SYSDAT                       -- 数据日期
             AND a.BAL_TYPE = '1'                             -- 余额类型
           GROUP BY a.CUST_ID,A.PERSN_LEGAL_BK_CODE
         ) b
      ON b.CUST_ID = c.CUST_ID
     and B.PERSN_LEGAL_BK_CODE = C.PERSN_LEGAL_BK_CODE;

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
  -- 业务含义：生成"本期第一笔到期日前一日"的AUM基准(PREV)，作为资产留存率分母
  -- 数据来源：TMP_CDR_DTL_DUE_WIN × DWS_CUST_ASSE_LIAB_HIS(DATA_DATE=FIRST_EXPR_DT-1，BAL_TYPE='1'，客户+法人行关联)
  -- 处理逻辑：LEFT JOIN缺失快照按0处理(口径24)
  --***************************************
  V_NO_ID := '8';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_DTL_AUM_BAL (
      STAT_PERD,            -- 统计周期：M-月,Q-季,Y-年
      CUST_ID,              -- 客户编号
      STATIS_TYP,           -- 承接类型：0-全部,1-存款,2-理财
      AUM_TYP,              -- AUM类型：PREV-第一笔到期前一日,CURR-当前日
      DATA_DATE,            -- AUM数据日期
      AUM_BAL,              -- AUM余额
      PERSN_LEGAL_BK_CODE   -- 法人行号（计算单位=客户+法人行，口径23）
  )
  SELECT w.STAT_PERD                                         AS STAT_PERD,  -- 统计周期：M-月,Q-季,Y-年
         w.CUST_ID                                           AS CUST_ID,    -- 客户编号
         w.STATIS_TYP                                        AS STATIS_TYP, -- 承接类型：0-全部,1-存款,2-理财
         'PREV'                                              AS AUM_TYP,    -- AUM类型：第一笔到期前一日
         TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')            AS DATA_DATE,  -- AUM数据日期
         SUM(NVL(h.AUM_BAL, 0))                              AS AUM_BAL,    -- AUM余额
         w.PERSN_LEGAL_BK_CODE                               AS PERSN_LEGAL_BK_CODE
    FROM TMP_CDR_DTL_DUE_WIN w
    LEFT JOIN DWS_CUST_ASSE_LIAB_HIS h                           -- 客户资产负债表（HIS，DATA_DATE=第一笔到期日前一日）
      ON h.CUST_ID = w.CUST_ID
      and H.PERSN_LEGAL_BK_CODE = W.PERSN_LEGAL_BK_CODE
     AND h.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')
     AND h.BAL_TYPE = '1'                                    -- 余额类型
   GROUP BY w.STAT_PERD, w.CUST_ID, w.STATIS_TYP, TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd'), w.PERSN_LEGAL_BK_CODE;

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
  -- 2.8 -- 第9段处理开始：两期分离计算与验证（v3.0.0，单个BEGIN...END分段落）
  -- 业务含义：本期/上期/验证逻辑位于同一个匿名块内，以注释段落分隔，界限清晰
  -- 数据来源：DUE_WIN×TAKE_AMT×CUST_BASE×AUM_BAL×CROSS_CONV（关联键均不含ORG_ID，口径23）
  -- 处理逻辑：9.0冻结快照 / 9.1本期计算段(C1/C2) / 9.2上期计算段(P1/P2) / 9.3验证段(V1，FAIL即中止)
  --***************************************
  V_NO_ID := '9';
  V_BGN_DATE := SYSDATE;

  DECLARE
    V_FAIL_CNT INTEGER := 0;   -- 验证段失败计数（块级局部变量）
  BEGIN
  -- 9.0 上期冻结快照（供验证模块比对18基础字段是否被修改）
  INSERT INTO TMP_CDR_DTL_FREEZE_LOG (
      BATCH_DATE, PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
      DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
      EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
      FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
      FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
      LAST_END_DATE, POST_ID, ORG_ID
  )
  SELECT V_SYSDAT, PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
         DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
         EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
         FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
         FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
         LAST_END_DATE, POST_ID, ORG_ID
    FROM ADS_CUST_DEADLINE_RMND_DTL
   WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END);
  COMMIT;
      V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '上期冻结快照完成：TMP_CDR_DTL_FREEZE_LOG';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(
        V_SYSDAT,
        V_PRC_NAME,
        V_PRC_DESC,
        '9',
        V_BGN_DATE,
        V_END_DATE,
        V_DURA_DATE,
        V_LOG_MSG,
        V_LOG_FLG,
        V_LOG_BUTTON
    );

    -- ========== 【本期计算段】开始（边界：END_DT=当期结束日，DATA_DATE=V_SYSDAT）==========
    V_NO_ID := 'C1';
    V_BGN_DATE := SYSDATE;

    INSERT INTO TMP_CDR_DTL_CURR_STAGE (
        PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
        EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
        FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
        LAST_END_DATE, POST_ID, ORG_ID
    )
    SELECT
        w.PERSN_LEGAL_BK_CODE,
        V_SYSDAT                                                   AS DATA_DATE,   -- 本期行: DATA_DATE=跑批日期(口径37)
        w.CUST_ID,
        cb.CUST_NAME,
        cb.CUST_LVL,
        cb.DEPO_CURNT_DEPO_BAL,
        cb.FIXD_DEPO_BAL,
        cb.FIN_AMT,
        w.STAT_PERD,
        w.STATIS_TYP,
        NVL(w.EXPR_AMT, 0),
        NVL(w.MATURE_TTL_AMT, 0),
        CASE WHEN NVL(w.EXPR_AMT, 0) = 0 THEN 0
             ELSE ROUND(NVL(t.TAKE_AMT_30D, 0) / w.EXPR_AMT * 100, 2)
        END,
        CASE WHEN w.STATIS_TYP = '1' THEN NVL(w.EXPR_AMT, 0) ELSE 0 END,
        CASE WHEN w.STATIS_TYP = '1' THEN NVL(w.MATURE_TTL_AMT, 0) ELSE 0 END,
        CASE WHEN w.STATIS_TYP = '1' AND NVL(w.EXPR_AMT, 0) <> 0
             THEN ROUND(NVL(t.BUY_DEPO_AMT_30D, 0) / w.EXPR_AMT * 100, 2)
             ELSE 0
        END,
        CASE WHEN EXISTS (
                   SELECT 1
                     FROM ADS_MKT_REC_INFO m
                    WHERE m.CUST_ID = w.CUST_ID
                      AND m.MKT_TIME IS NOT NULL
                      AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME, 1, 10), '-', ''), 'yyyymmdd')
                          BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                      AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME, 1, 10), '-', ''), 'yyyymmdd')
                          <= TO_DATE(V_SYSDAT, 'yyyymmdd')
             ) THEN '1' ELSE '0'
        END,
        CASE WHEN NVL(w.EXPR_AMT, 0) > 0
                  AND NVL(t.TAKE_AMT_30D, 0) / w.EXPR_AMT >= 0.8
             THEN '1' ELSE '0'
        END,
        NVL(t.BUY_INSUR_AMT_30D, 0),
        NVL(cv.FIN_MATURE_TRAN_FIXED_AMT, 0),
        NVL(cv.FIXED_MATURE_TRAN_FIN_AMT, 0),
        NVL(ap.AUM_BAL, 0),
        TO_CHAR(w.LAST_EXPR_DT, 'yyyymmdd'),
        cb.POST_ID,
        w.ORG_ID
      FROM TMP_CDR_DTL_DUE_WIN w
      LEFT JOIN (
            SELECT w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE,
                   SUM(CASE WHEN p.PRDKT_TYP IN ('DEPO', 'FIN')
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS TAKE_AMT_30D,
                   SUM(CASE WHEN p.PRDKT_TYP = 'DEPO'
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_DEPO_AMT_30D,
                   SUM(CASE WHEN p.PRDKT_TYP = 'FIN'
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_FIN_AMT_30D,
                   SUM(CASE WHEN p.PRDKT_TYP = 'INSUR'
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_INSUR_AMT_30D
              FROM TMP_CDR_DTL_DUE_WIN w2
              LEFT JOIN TMP_CDR_DTL_PURCHASE_SRC p
                ON p.CUST_ID = w2.CUST_ID
               AND p.PERSN_LEGAL_BK_CODE = w2.PERSN_LEGAL_BK_CODE
               AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
               AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
             GROUP BY w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE
           ) t
        ON t.STAT_PERD = w.STAT_PERD
       AND t.BGN_DT = w.BGN_DT
       AND t.END_DT = w.END_DT
       AND t.CUST_ID = w.CUST_ID
       AND t.STATIS_TYP = w.STATIS_TYP
       AND t.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
      LEFT JOIN TMP_CDR_DTL_CUST_BASE cb
        ON cb.CUST_ID = w.CUST_ID
       AND cb.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
      LEFT JOIN TMP_CDR_DTL_AUM_BAL ap
        ON ap.STAT_PERD = w.STAT_PERD
       AND ap.CUST_ID = w.CUST_ID
       AND ap.STATIS_TYP = w.STATIS_TYP
       AND ap.AUM_TYP = 'PREV'
       AND ap.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
       AND ap.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')
      LEFT JOIN (
            SELECT ta.STAT_PERD, ta.BGN_DT, ta.END_DT, ta.CUST_ID, ta.STATIS_TYP, ta.PERSN_LEGAL_BK_CODE,
                   SUM(CASE WHEN ta.STATIS_TYP = '2' THEN ta.BUY_DEPO_AMT_30D ELSE 0 END) AS FIN_MATURE_TRAN_FIXED_AMT,
                   SUM(CASE WHEN ta.STATIS_TYP = '1' THEN ta.BUY_FIN_AMT_30D ELSE 0 END) AS FIXED_MATURE_TRAN_FIN_AMT
              FROM (
                    SELECT w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE,
                           SUM(CASE WHEN p.PRDKT_TYP = 'DEPO'
                                     AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                                     AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                                    THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_DEPO_AMT_30D,
                           SUM(CASE WHEN p.PRDKT_TYP = 'FIN'
                                     AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                                     AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                                    THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_FIN_AMT_30D
                      FROM TMP_CDR_DTL_DUE_WIN w2
                      LEFT JOIN TMP_CDR_DTL_PURCHASE_SRC p
                        ON p.CUST_ID = w2.CUST_ID
                       AND p.PERSN_LEGAL_BK_CODE = w2.PERSN_LEGAL_BK_CODE
                       AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                       AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                     GROUP BY w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE
                   ) ta
             GROUP BY ta.STAT_PERD, ta.BGN_DT, ta.END_DT, ta.CUST_ID, ta.STATIS_TYP, ta.PERSN_LEGAL_BK_CODE
           ) cv
        ON cv.STAT_PERD = w.STAT_PERD
       AND cv.BGN_DT = w.BGN_DT
       AND cv.END_DT = w.END_DT
       AND cv.CUST_ID = w.CUST_ID
       AND cv.STATIS_TYP = w.STATIS_TYP
       AND cv.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
     -- 边界检查：仅本期周期实例（END_DT=当期结束日），杜绝读取上期/历史实例
     WHERE (w.STAT_PERD = 'M' AND w.END_DT = TO_DATE(V_CURR_MONTH_END, 'yyyymmdd'))
        OR (w.STAT_PERD = 'Q' AND w.END_DT = TO_DATE(V_CURR_QUARTER_END, 'yyyymmdd'))
        OR (w.STAT_PERD = 'Y' AND w.END_DT = TO_DATE(V_CURR_YEAR_END, 'yyyymmdd'));

    -- 边界检查：本期结果 DATA_DATE 必须全部等于跑批日期（防止跨期引用）
    IF EXISTS (SELECT 1 FROM TMP_CDR_DTL_CURR_STAGE WHERE DATA_DATE <> V_SYSDAT) THEN
      RAISE_APPLICATION_ERROR(-20011, '本期边界检查失败：CURR_STAGE存在DATA_DATE<>V_SYSDAT行（跨期引用）');
    END IF;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '本期计算段完成：CURR_STAGE生成并边界检查通过';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'C1',
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );

    V_NO_ID := 'C2';
    V_BGN_DATE := SYSDATE;
    INSERT INTO ADS_CUST_DEADLINE_RMND_DTL (
        PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
        EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
        FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
        LAST_END_DATE, POST_ID, ORG_ID
    )
    SELECT
        PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
        EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
        FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
        LAST_END_DATE, POST_ID, ORG_ID
      FROM TMP_CDR_DTL_CURR_STAGE;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '本期计算段完成：写入ADS_CUST_DEADLINE_RMND_DTL';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'C2',
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );
    -- ========== 【本期计算段】结束 ==========
    -- ========== 【上期计算段】开始（边界：END_DT=上期结束日，DATA_DATE=上期期末日期）==========
    V_NO_ID := 'P1';
    V_BGN_DATE := SYSDATE;

    INSERT INTO TMP_CDR_DTL_PREV_STAGE (
        PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
        EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
        FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
        LAST_END_DATE, POST_ID, ORG_ID
    )
    SELECT
        w.PERSN_LEGAL_BK_CODE,
        TO_CHAR(w.END_DT, 'yyyymmdd')                               AS DATA_DATE,   -- 上期行: DATA_DATE=期末日期(口径37)
        w.CUST_ID,
        cb.CUST_NAME,
        cb.CUST_LVL,
        cb.DEPO_CURNT_DEPO_BAL,
        cb.FIXD_DEPO_BAL,
        cb.FIN_AMT,
        w.STAT_PERD,
        w.STATIS_TYP,
        NVL(w.EXPR_AMT, 0),
        NVL(w.MATURE_TTL_AMT, 0),
        CASE WHEN NVL(w.EXPR_AMT, 0) = 0 THEN 0
             ELSE ROUND(NVL(t.TAKE_AMT_30D, 0) / w.EXPR_AMT * 100, 2)
        END,
        CASE WHEN w.STATIS_TYP = '1' THEN NVL(w.EXPR_AMT, 0) ELSE 0 END,
        CASE WHEN w.STATIS_TYP = '1' THEN NVL(w.MATURE_TTL_AMT, 0) ELSE 0 END,
        CASE WHEN w.STATIS_TYP = '1' AND NVL(w.EXPR_AMT, 0) <> 0
             THEN ROUND(NVL(t.BUY_DEPO_AMT_30D, 0) / w.EXPR_AMT * 100, 2)
             ELSE 0
        END,
        CASE WHEN EXISTS (
                   SELECT 1
                     FROM ADS_MKT_REC_INFO m
                    WHERE m.CUST_ID = w.CUST_ID
                      AND m.MKT_TIME IS NOT NULL
                      AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME, 1, 10), '-', ''), 'yyyymmdd')
                          BETWEEN w.FIRST_EXPR_DT AND w.TAKE_END_DT_30D
                      AND TO_DATE(REPLACE(SUBSTR(m.MKT_TIME, 1, 10), '-', ''), 'yyyymmdd')
                          <= TO_DATE(V_SYSDAT, 'yyyymmdd')
             ) THEN '1' ELSE '0'
        END,
        CASE WHEN NVL(w.EXPR_AMT, 0) > 0
                  AND NVL(t.TAKE_AMT_30D, 0) / w.EXPR_AMT >= 0.8
             THEN '1' ELSE '0'
        END,
        NVL(t.BUY_INSUR_AMT_30D, 0),
        NVL(cv.FIN_MATURE_TRAN_FIXED_AMT, 0),
        NVL(cv.FIXED_MATURE_TRAN_FIN_AMT, 0),
        NVL(ap.AUM_BAL, 0),
        TO_CHAR(w.LAST_EXPR_DT, 'yyyymmdd'),
        cb.POST_ID,
        w.ORG_ID
      FROM TMP_CDR_DTL_DUE_WIN w
      LEFT JOIN (
            SELECT w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE,
                   SUM(CASE WHEN p.PRDKT_TYP IN ('DEPO', 'FIN')
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS TAKE_AMT_30D,
                   SUM(CASE WHEN p.PRDKT_TYP = 'DEPO'
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_DEPO_AMT_30D,
                   SUM(CASE WHEN p.PRDKT_TYP = 'FIN'
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_FIN_AMT_30D,
                   SUM(CASE WHEN p.PRDKT_TYP = 'INSUR'
                             AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                             AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                            THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_INSUR_AMT_30D
              FROM TMP_CDR_DTL_DUE_WIN w2
              LEFT JOIN TMP_CDR_DTL_PURCHASE_SRC p
                ON p.CUST_ID = w2.CUST_ID
               AND p.PERSN_LEGAL_BK_CODE = w2.PERSN_LEGAL_BK_CODE
               AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
               AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
             GROUP BY w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE
           ) t
        ON t.STAT_PERD = w.STAT_PERD
       AND t.BGN_DT = w.BGN_DT
       AND t.END_DT = w.END_DT
       AND t.CUST_ID = w.CUST_ID
       AND t.STATIS_TYP = w.STATIS_TYP
       AND t.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
      LEFT JOIN TMP_CDR_DTL_CUST_BASE cb
        ON cb.CUST_ID = w.CUST_ID
       AND cb.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
      LEFT JOIN TMP_CDR_DTL_AUM_BAL ap
        ON ap.STAT_PERD = w.STAT_PERD
       AND ap.CUST_ID = w.CUST_ID
       AND ap.STATIS_TYP = w.STATIS_TYP
       AND ap.AUM_TYP = 'PREV'
       AND ap.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
       AND ap.DATA_DATE = TO_CHAR(w.FIRST_EXPR_DT - 1, 'yyyymmdd')
      LEFT JOIN (
            SELECT ta.STAT_PERD, ta.BGN_DT, ta.END_DT, ta.CUST_ID, ta.STATIS_TYP, ta.PERSN_LEGAL_BK_CODE,
                   SUM(CASE WHEN ta.STATIS_TYP = '2' THEN ta.BUY_DEPO_AMT_30D ELSE 0 END) AS FIN_MATURE_TRAN_FIXED_AMT,
                   SUM(CASE WHEN ta.STATIS_TYP = '1' THEN ta.BUY_FIN_AMT_30D ELSE 0 END) AS FIXED_MATURE_TRAN_FIN_AMT
              FROM (
                    SELECT w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE,
                           SUM(CASE WHEN p.PRDKT_TYP = 'DEPO'
                                     AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                                     AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                                    THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_DEPO_AMT_30D,
                           SUM(CASE WHEN p.PRDKT_TYP = 'FIN'
                                     AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                                     AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                                    THEN NVL(p.BUY_AMT, 0) ELSE 0 END) AS BUY_FIN_AMT_30D
                      FROM TMP_CDR_DTL_DUE_WIN w2
                      LEFT JOIN TMP_CDR_DTL_PURCHASE_SRC p
                        ON p.CUST_ID = w2.CUST_ID
                       AND p.PERSN_LEGAL_BK_CODE = w2.PERSN_LEGAL_BK_CODE
                       AND p.BUY_DT BETWEEN w2.FIRST_EXPR_DT AND w2.TAKE_END_DT_30D
                       AND p.BUY_DT <= TO_DATE(V_SYSDAT, 'yyyymmdd')
                     GROUP BY w2.STAT_PERD, w2.BGN_DT, w2.END_DT, w2.CUST_ID, w2.STATIS_TYP, w2.PERSN_LEGAL_BK_CODE
                   ) ta
             GROUP BY ta.STAT_PERD, ta.BGN_DT, ta.END_DT, ta.CUST_ID, ta.STATIS_TYP, ta.PERSN_LEGAL_BK_CODE
           ) cv
        ON cv.STAT_PERD = w.STAT_PERD
       AND cv.BGN_DT = w.BGN_DT
       AND cv.END_DT = w.END_DT
       AND cv.CUST_ID = w.CUST_ID
       AND cv.STATIS_TYP = w.STATIS_TYP
       AND cv.PERSN_LEGAL_BK_CODE = w.PERSN_LEGAL_BK_CODE
     -- 边界检查：仅上期周期实例（END_DT=上期结束日），数据来源=上一周期实例(口径38)
     WHERE (w.STAT_PERD = 'M' AND w.END_DT = TO_DATE(V_PREV_MONTH_END, 'yyyymmdd'))
        OR (w.STAT_PERD = 'Q' AND w.END_DT = TO_DATE(V_PREV_QUARTER_END, 'yyyymmdd'))
        OR (w.STAT_PERD = 'Y' AND w.END_DT = TO_DATE(V_PREV_YEAR_END, 'yyyymmdd'));

    -- 边界检查：上期结果 DATA_DATE 必须与上期期末日期一一对应（防止跨期引用）
    IF EXISTS (SELECT 1 FROM TMP_CDR_DTL_PREV_STAGE
                WHERE (STAT_PERD = 'M' AND DATA_DATE <> V_PREV_MONTH_END)
                   OR (STAT_PERD = 'Q' AND DATA_DATE <> V_PREV_QUARTER_END)
                   OR (STAT_PERD = 'Y' AND DATA_DATE <> V_PREV_YEAR_END)) THEN
      RAISE_APPLICATION_ERROR(-20012, '上期边界检查失败：PREV_STAGE存在DATA_DATE与上期期末不一致行（跨期引用）');
    END IF;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '上期计算段完成：PREV_STAGE生成并边界检查通过';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'P1',
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );

    V_NO_ID := 'P2';
    V_BGN_DATE := SYSDATE;
    -- 定点更新：上期行仅更新7字段（口径35），缺失上期行整行补插
    MERGE INTO ADS_CUST_DEADLINE_RMND_DTL dst
    USING TMP_CDR_DTL_PREV_STAGE src
    ON (dst.STAT_PERD = src.STAT_PERD
        AND dst.DATA_DATE = src.DATA_DATE
        AND dst.CUST_ID = src.CUST_ID
        AND dst.STATIS_TYP = src.STATIS_TYP
        AND dst.PERSN_LEGAL_BK_CODE = src.PERSN_LEGAL_BK_CODE)
    WHEN MATCHED THEN UPDATE SET
        dst.TAKE_RATE = src.TAKE_RATE,
        dst.FIX_DEPO_TAKE_RATE = src.FIX_DEPO_TAKE_RATE,
        dst.UNDTAKE_STATE = src.UNDTAKE_STATE,
        dst.CNTCT_STATE = src.CNTCT_STATE,
        dst.FIXED_FIN_MATURE_TRAN_INSUR_AMT = src.FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        dst.FIN_MATURE_TRAN_FIXED_AMT = src.FIN_MATURE_TRAN_FIXED_AMT,
        dst.FIXED_MATURE_TRAN_FIN_AMT = src.FIXED_MATURE_TRAN_FIN_AMT
    WHEN NOT MATCHED THEN INSERT (
        PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
        DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
        EXPR_AMT, MATURE_TTL_AMT, TAKE_RATE, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
        FIX_DEPO_TAKE_RATE, CNTCT_STATE, UNDTAKE_STATE, FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        FIN_MATURE_TRAN_FIXED_AMT, FIXED_MATURE_TRAN_FIN_AMT, FRST_MATURE_PK_BF_DAY_AUM_BAL,
        LAST_END_DATE, POST_ID, ORG_ID
    ) VALUES (
        src.PERSN_LEGAL_BK_CODE, src.DATA_DATE, src.CUST_ID, src.CUST_NAME, src.CUST_LVL,
        src.DEPO_CURNT_DEPO_BAL, src.FIXD_DEPO_BAL, src.FIN_AMT, src.STAT_PERD, src.STATIS_TYP,
        src.EXPR_AMT, src.MATURE_TTL_AMT, src.TAKE_RATE, src.FIX_DEPO_MATURE_AMT, src.FIX_DEPO_MATURE_TTL_AMT,
        src.FIX_DEPO_TAKE_RATE, src.CNTCT_STATE, src.UNDTAKE_STATE, src.FIXED_FIN_MATURE_TRAN_INSUR_AMT,
        src.FIN_MATURE_TRAN_FIXED_AMT, src.FIXED_MATURE_TRAN_FIN_AMT, src.FRST_MATURE_PK_BF_DAY_AUM_BAL,
        src.LAST_END_DATE, src.POST_ID, src.ORG_ID
    );
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '上期计算段完成：仅更新7字段/补插缺失上期行';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'P2',
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );
    -- ========== 【上期计算段】结束 ==========
    -- ========== 【数据验证段】开始（冻结/一致性/互斥/值域/行数，FAIL即中止）==========
    V_NO_ID := 'V1';
    V_BGN_DATE := SYSDATE;

    -- V1: 上期18基础字段冻结校验（FREEZE_LOG快照 vs 目标表当前上期行）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'FREEZE_BASE_18',
           CASE WHEN NOT EXISTS (
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                           DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                           EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                           FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
                      FROM TMP_CDR_DTL_FREEZE_LOG
                    MINUS
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                           DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                           EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                           FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
                      FROM ADS_CUST_DEADLINE_RMND_DTL
                     WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
                AND NOT EXISTS (
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                           DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                           EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                           FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
                      FROM ADS_CUST_DEADLINE_RMND_DTL
                     WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END)
                    MINUS
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                           DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                           EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                           FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
                      FROM TMP_CDR_DTL_FREEZE_LOG)
           THEN 'PASS' ELSE 'FAIL' END,
           '上期18基础字段冻结校验（口径34）', SYSDATE FROM dual;

    -- V2: 上期7更新字段一致性（目标表上期行 vs PREV_STAGE）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'PREV_7FIELDS_CONSISTENT',
           CASE WHEN NOT EXISTS (
                    SELECT STAT_PERD, DATA_DATE, CUST_ID, STATIS_TYP, PERSN_LEGAL_BK_CODE,
                           TAKE_RATE, FIX_DEPO_TAKE_RATE, UNDTAKE_STATE, CNTCT_STATE,
                           FIXED_FIN_MATURE_TRAN_INSUR_AMT, FIN_MATURE_TRAN_FIXED_AMT,
                           FIXED_MATURE_TRAN_FIN_AMT
                      FROM TMP_CDR_DTL_PREV_STAGE
                    MINUS
                    SELECT STAT_PERD, DATA_DATE, CUST_ID, STATIS_TYP, PERSN_LEGAL_BK_CODE,
                           TAKE_RATE, FIX_DEPO_TAKE_RATE, UNDTAKE_STATE, CNTCT_STATE,
                           FIXED_FIN_MATURE_TRAN_INSUR_AMT, FIN_MATURE_TRAN_FIXED_AMT,
                           FIXED_MATURE_TRAN_FIN_AMT
                      FROM ADS_CUST_DEADLINE_RMND_DTL
                     WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
           THEN 'PASS' ELSE 'FAIL' END,
           '上期7更新字段一致性校验（口径35）', SYSDATE FROM dual;

    -- V3: 本期结果不得包含上期日期（DATA_DATE互斥，防止跨期引用）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'C', 'CURR_NO_PREV_DATE',
           CASE WHEN EXISTS (SELECT 1 FROM TMP_CDR_DTL_CURR_STAGE
                              WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
                THEN 'FAIL' ELSE 'PASS' END,
           '本期结果与上期日期互斥校验', SYSDATE FROM dual;

    -- V4: 率值域与状态值域（两期独立校验）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'C', 'RATE_DOMAIN_CURR',
           CASE WHEN EXISTS (SELECT 1 FROM TMP_CDR_DTL_CURR_STAGE
                              WHERE TAKE_RATE IS NULL OR TAKE_RATE < 0
                                 OR FIX_DEPO_TAKE_RATE IS NULL OR FIX_DEPO_TAKE_RATE < 0
                                 OR CNTCT_STATE NOT IN ('0', '1')
                                 OR UNDTAKE_STATE NOT IN ('0', '1'))
                THEN 'FAIL' ELSE 'PASS' END,
           '本期率值/状态值域校验', SYSDATE FROM dual;
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'RATE_DOMAIN_PREV',
           CASE WHEN EXISTS (SELECT 1 FROM TMP_CDR_DTL_PREV_STAGE
                              WHERE TAKE_RATE IS NULL OR TAKE_RATE < 0
                                 OR FIX_DEPO_TAKE_RATE IS NULL OR FIX_DEPO_TAKE_RATE < 0
                                 OR CNTCT_STATE NOT IN ('0', '1')
                                 OR UNDTAKE_STATE NOT IN ('0', '1'))
                THEN 'FAIL' ELSE 'PASS' END,
           '上期率值/状态值域校验', SYSDATE FROM dual;

    -- V5: stage与目标表行数一致性（两期独立校验）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'C', 'ROWCOUNT_CONSISTENT_CURR',
           CASE WHEN (SELECT COUNT(*) FROM TMP_CDR_DTL_CURR_STAGE)
                  = (SELECT COUNT(*) FROM ADS_CUST_DEADLINE_RMND_DTL WHERE DATA_DATE = V_SYSDAT)
                THEN 'PASS' ELSE 'FAIL' END,
           '本期stage与目标表行数一致性', SYSDATE FROM dual;
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'ROWCOUNT_CONSISTENT_PREV',
           CASE WHEN (SELECT COUNT(*) FROM TMP_CDR_DTL_PREV_STAGE)
                  = (SELECT COUNT(*) FROM ADS_CUST_DEADLINE_RMND_DTL
                      WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
                THEN 'PASS' ELSE 'FAIL' END,
           '上期stage与目标表行数一致性', SYSDATE FROM dual;

    COMMIT;

    -- 任一FAIL即中止批次（防止污染数据后继续）
    SELECT COUNT(*) INTO V_FAIL_CNT
      FROM TMP_CDR_VALIDATE_RESULT
     WHERE BATCH_DATE = V_SYSDAT AND RESULT = 'FAIL';
    IF V_FAIL_CNT > 0 THEN
      RAISE_APPLICATION_ERROR(-20013, '数据验证失败：' || V_FAIL_CNT || ' 项校验未通过');
    END IF;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '数据验证段完成：两期计算结果准确性与独立性校验通过';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'V1',
        V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );
    -- ========== 【数据验证段】结束 ==========
  END;


  -- 当前周期只保留最新跑批快照；上期行冻结保留(口径34)；历史只保留最多三年。
  DELETE FROM ADS_CUST_DEADLINE_RMND_DTL d
   WHERE d.DATA_DATE <> V_SYSDAT
     AND d.DATA_DATE < V_HISTORY_CUTOFF_DATE;

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
  -- 3. 异常处理区(捕获错误码并记录详细日志)
  -- 业务含义：任一环节异常时统一置返回码-1、回滚当前事务并记录错误日志后重抛
  -- 处理逻辑：EXCEPTION WHEN OTHERS → OUTCDE=-1 → ROLLBACK → SYS_PRC_STEP_LOGS(SQLERRM) → RAISE
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
END





;
