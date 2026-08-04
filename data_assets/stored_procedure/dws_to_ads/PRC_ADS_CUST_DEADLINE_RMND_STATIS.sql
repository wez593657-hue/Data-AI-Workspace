-- DROP PROCEDURE crmdm.prc_ads_cust_deadline_rmnd_statis(in varchar, out int4);

CREATE OR REPLACE PROCEDURE crmdm.prc_ads_cust_deadline_rmnd_statis(
    v_sysdat varchar,      -- 输入参数：系统跑批日期，格式YYYYMMDD；业务口径T-1日=V_SYSDAT
    outcde OUT integer     -- 输出参数：返回码（0=成功，-1=异常）
)
AS 
  ------------------------------------------------------------------
  -- 存储过程名称: 到期承接统计表处理
  -- 存储过程编号: PRC_ADS_CUST_DEADLINE_RMND_STATIS
  -- 处理周期: 日
  -- 过程描述: 按机构向上汇总和客户经理维度生成到期承接统计
  -- 来源表: ADS_CUST_DEADLINE_RMND_DTL, DWS_CUST_ASSE_LIAB, DWD_SYS_ORG
  -- 目标表: ADS_CUST_DEADLINE_RMND_STATIS
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.5.0
  -- 关联需求: REQ-CUST-002
  -- 变更记录:
  --   v2.8.1: 1.注释规范化：补齐输入输出参数、变量、各处理段及列定义注释
  --           2.第4段改为按承接类型(STATIS_TYP 0-全部/1-定期存款/2-理财)分段独立计算并UNION ALL写入
  --   v2.6.0: 1.统计表方案B(口径36)：上期统计行冻结维度与基础列，仅更新6个率值列
  --           2.DATA_DATE双语义(口径37)：本期行=跑批日期V_SYSDAT，上期行=期末日期
  --           3.段1不再删除上期统计行，仅删除本期快照(口径34)
  --           4.第4段改为单个BEGIN...END块分段落（禁止嵌套过程）：本期计算段(C1/C2)/
  --             上期计算段(P1/P2)/数据验证段(V1)，MERGE仅更新率值列；独立隔离存储与边界检查
  --   v2.8.0: 1.统计表回退15列（定期存款页签三指标由STATIS_TYP=1行复用，口径2/25）
  --           2.当前AUM关联移除ORG_ID（计算单位=客户+法人行，口径23）
  --           3.存款转理财限定STATIS_TYP=1、理财转存款限定STATIS_TYP=2、保险转化率按全部口径展示（口径17/18）
  --   v2.5.0: 1.资产承接率消除舍入误差(去内层ROUND)
  --           2.新增定期存款页签三指标:FIX_DEPO_EXPR_AMT/FIX_DEPO_TTL_EXPR_AMT/FIX_DEPO_UNDTAKE_RATE
  --           3.STAT_BASE/SRC增加FIX_DEPO_MATURE_AMT/FIX_DEPO_MATURE_TTL_AMT/FIX_DEPO_TAKE_RATE三列
  --   v2.4.0: 1.简化DELETE历史清理逻辑(去掉冗余周期末日校验,仅保留三年边界)
  --   v2.3.0: 跑批日期口径统一：V_SYSDAT为当前跑批数据日；上月末、上季末、上年末分别使用sys_fun_deal_date参数2、3、4。统计过程资产汇总及关联补齐客户号、法人行、归属机构三键
  --   v2.2.0: 1.客户数统计改为按客户+机构维度去重：COUNT(DISTINCT CUST_ID || '_' || ORG_ID)
  --           2.承接状态统计同步改为按客户+机构维度去重
  --   v2.1.0: 1.理财转存款转化率和存款转理财转化率指标已实现
  --           2.统计维度0-全部、1-存款、2-理财已实现
  --           3.客户承接率长期化产品剔除保险(待实现,已做注释)
  --           4.定期存款承接率需确认通知存款过滤(待实现,已做注释)
  --           5.DATA_DATE语义变更：统一使用周期结束日期(M-月末,Q-季末,Y-年末),清理逻辑同步更新
  ------------------------------------------------------------------
  V_PRC_DESC VARCHAR(100) := '到期承接统计表处理';                  -- 过程描述（日志用）
  V_PRC_NAME VARCHAR(64) := 'PRC_ADS_CUST_DEADLINE_RMND_STATIS';     -- 过程名称（日志用）
  V_LOG_MSG VARCHAR(4000);                                           -- 日志消息文本
  V_LOG_FLG INTEGER;                                                 -- 日志标志（0=成功，-1=异常）
  V_LOG_BUTTON INTEGER := 1;                                         -- 日志记录开关（1=记录）
  V_NO_ID VARCHAR(10);                                               -- 当前处理步骤编号
  V_BGN_DATE DATE;                                                   -- 当前步骤开始时间
  V_END_DATE DATE;                                                   -- 当前步骤结束时间
  V_DURA_DATE INTEGER;                                               -- 当前步骤耗时（秒）
  V_PREV_MONTH_END VARCHAR2(8);                                      -- 上月末：sys_fun_deal_date(V_SYSDAT,2)
  V_PREV_QUARTER_END VARCHAR2(8);                                    -- 上季末：sys_fun_deal_date(V_SYSDAT,3)
  V_PREV_YEAR_END VARCHAR2(8);                                       -- 上年末：sys_fun_deal_date(V_SYSDAT,4)
  V_CURR_MONTH_BEGIN VARCHAR2(8);                                    -- 当月初：sys_fun_deal_date(V_SYSDAT,9)
  V_CURR_QUARTER_BEGIN VARCHAR2(8);                                  -- 当季初：sys_fun_deal_date(V_SYSDAT,11)
  V_CURR_YEAR_BEGIN VARCHAR2(8);                                     -- 当年初：sys_fun_deal_date(V_SYSDAT,13)
  V_CURR_MONTH_END VARCHAR2(8);                                      -- 当月末：sys_fun_deal_date(V_SYSDAT,10)
  V_CURR_QUARTER_END VARCHAR2(8);                                    -- 当季末：sys_fun_deal_date(V_SYSDAT,12)
  V_CURR_YEAR_END VARCHAR2(8);                                       -- 当年末：sys_fun_deal_date(V_SYSDAT,14)
  V_HISTORY_CUTOFF_DATE VARCHAR2(8);                                 -- 三年历史清理边界：sys_fun_deal_date(V_SYSDAT,19)

BEGIN
  IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 2);
  V_PREV_QUARTER_END := sys_fun_deal_date(V_SYSDAT, 3);
  V_PREV_YEAR_END := sys_fun_deal_date(V_SYSDAT, 4);
  V_CURR_MONTH_BEGIN := sys_fun_deal_date(V_SYSDAT, 9);
  V_CURR_QUARTER_BEGIN := sys_fun_deal_date(V_SYSDAT, 11);
  V_CURR_YEAR_BEGIN := sys_fun_deal_date(V_SYSDAT, 13);
  V_CURR_MONTH_END := sys_fun_deal_date(V_SYSDAT, 10);
  V_CURR_QUARTER_END := sys_fun_deal_date(V_SYSDAT, 12);
  V_CURR_YEAR_END := sys_fun_deal_date(V_SYSDAT, 14);
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);

  --***************************************
  -- 2.0 -- 第1段处理开始：清理当前快照和中间表
  -- 业务含义：幂等重跑准备——仅删除本期统计快照行(DATA_DATE=V_SYSDAT)及旧语义当期结束日行，
  --           严格保留上期统计行(口径34/36)，并清空两张统计中间表
  -- 数据来源：ADS_CUST_DEADLINE_RMND_STATIS + TMP_CDR_STAT_BASE/TMP_CDR_STAT_SRC
  -- 处理逻辑：DELETE(本期快照+旧语义当期结束日) + TRUNCATE_TMP × 2
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_DEADLINE_RMND_STATIS
   -- v2.6.0(口径28/34/37): 每日替换——删除当期周期区间内的本期统计快照行
   --                        (当月初/季初/年初~V_SYSDAT)，上期统计行不删除
   WHERE (STATIS_CYCLE = 'M' AND DATA_DATE >= V_CURR_MONTH_BEGIN AND DATA_DATE <= V_SYSDAT)
      OR (STATIS_CYCLE = 'Q' AND DATA_DATE >= V_CURR_QUARTER_BEGIN AND DATA_DATE <= V_SYSDAT)
      OR (STATIS_CYCLE = 'Y' AND DATA_DATE >= V_CURR_YEAR_BEGIN AND DATA_DATE <= V_SYSDAT)
      -- 过渡期清理：旧语义生成的当期结束日行(仅首日存在，后续幂等无影响)
      OR (STATIS_CYCLE = 'M' AND DATA_DATE = V_CURR_MONTH_END)
      OR (STATIS_CYCLE = 'Q' AND DATA_DATE = V_CURR_QUARTER_END)
      OR (STATIS_CYCLE = 'Y' AND DATA_DATE = V_CURR_YEAR_END);
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_STAT_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_STAT_SRC';
  -- v3.0.0: 两期隔离存储与验证日志
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_STAT_CURR_STAGE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_STAT_PREV_STAGE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_STAT_FREEZE_LOG';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_CDR_VALIDATE_RESULT';
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第1段业务逻辑处理完成：清理当前快照和中间表';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.1 -- 第2段处理开始：生成统计基础明细中间表
  -- 业务含义：将明细表当期/上期记录与当前AUM合并为统计基础行
  -- 数据来源：ADS_CUST_DEADLINE_RMND_DTL + DWS_CUST_ASSE_LIAB(当前AUM，DATA_DATE=V_SYSDAT且BAL_TYPE='1'，客户+法人行聚合)
  -- 处理逻辑：仅取本期(DATA_DATE=V_SYSDAT)与上期(DATA_DATE=期末日期)行（支持较上月对比）；
  --           当前AUM关联键不含ORG_ID(口径23)
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_STAT_BASE (
      PERSN_LEGAL_BK_CODE,          -- 法人行号
      DATA_DATE,                    -- 数据日期（周期结束日）
      STAT_PERD,                    -- 统计周期（M/Q/Y）
      STATIS_TYP,                   -- 承接类型（0-全部/1-定期存款/2-理财）
      CUST_ID,                      -- 客户编号
      ORG_ID,                       -- 归属机构（DWS取值，与法人行1:1）
      POST_ID,                      -- 管户经理岗位ID
      EXPR_AMT,                     -- 已到期金额
      MATURE_TTL_AMT,               -- 总到期金额
      TAKE_RATE_30D,                -- 30天客户承接金额占比（来自明细TAKE_RATE）
      CUST_TAKE_FLG,                -- 承接状态（TAKE_AMT/EXPR_AMT>=80%为1）
      FIXED_MATURE_TRAN_FIN_AMT,    -- 定期到期转理财金额
      FIXED_FIN_MATURE_TRAN_INSUR_AMT, -- 到期转保险金额
      FIN_MATURE_TRAN_FIXED_AMT,    -- 理财到期转定期金额
      FRST_MATURE_PK_BF_DAY_AUM_BAL,-- 本期第一笔到期前一日AUM（留存率分母）
      CURR_AUM_BAL                  -- 当前AUM（当前时点DWS，客户+法人行聚合）
  )
  SELECT d.PERSN_LEGAL_BK_CODE,
         d.DATA_DATE,
         d.STAT_PERD,
         d.STATIS_TYP,
         d.CUST_ID,
         d.ORG_ID,
         d.POST_ID,
         NVL(d.EXPR_AMT, 0),
         NVL(d.MATURE_TTL_AMT, 0),
         NVL(d.TAKE_RATE, 0),
         d.UNDTAKE_STATE,
         NVL(d.FIXED_MATURE_TRAN_FIN_AMT, 0),
         NVL(d.FIXED_FIN_MATURE_TRAN_INSUR_AMT, 0),
         NVL(d.FIN_MATURE_TRAN_FIXED_AMT, 0),
         NVL(d.FRST_MATURE_PK_BF_DAY_AUM_BAL, 0),
         NVL(a.CURR_AUM_BAL, 0)
    FROM ADS_CUST_DEADLINE_RMND_DTL d
    LEFT JOIN (
        SELECT x.CUST_ID, x.PERSN_LEGAL_BK_CODE, SUM(NVL(x.AUM_BAL, 0)) AS CURR_AUM_BAL
          FROM DWS_CUST_ASSE_LIAB x
         WHERE x.DATA_DATE = V_SYSDAT
           AND x.BAL_TYPE = '1'
         GROUP BY x.CUST_ID, x.PERSN_LEGAL_BK_CODE
    ) a
      ON a.CUST_ID = d.CUST_ID
      AND A.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE
   -- v2.6.0(口径37): 本期行DATA_DATE=V_SYSDAT；上期行DATA_DATE=上期期末日期
   WHERE (d.STAT_PERD = 'M' AND d.DATA_DATE IN (V_SYSDAT, V_PREV_MONTH_END))
      OR (d.STAT_PERD = 'Q' AND d.DATA_DATE IN (V_SYSDAT, V_PREV_QUARTER_END))
      OR (d.STAT_PERD = 'Y' AND d.DATA_DATE IN (V_SYSDAT, V_PREV_YEAR_END));
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第2段业务逻辑处理完成：生成统计基础明细中间表';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.2 -- 第3段处理开始：展开机构和客户经理统计对象
  -- 业务含义：将统计基础行展开为"机构(向上含自身及所有上级) + 管户经理"两类统计对象
  -- 数据来源：TMP_CDR_STAT_BASE × DWD_SYS_ORG(ORG_ID/SUP_ORG_ID层级)
  -- 处理逻辑：CONNECT_BY 自底向上展开机构祖先链；管户经理分支仅取POST_ID非空行；UNION ALL合并
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_CDR_STAT_SRC (
      PERSN_LEGAL_BK_CODE,          -- 法人行号
      STATIS_OBJ,                   -- 统计对象（机构ID/管户经理岗位ID）
      DATA_DATE,                    -- 数据日期（周期结束日）
      STAT_PERD,                    -- 统计周期（M/Q/Y）
      STATIS_TYP,                   -- 承接类型（0-全部/1-定期存款/2-理财）
      CUST_ID,                      -- 客户编号
      ORG_ID,                       -- 归属机构
      POST_ID,                      -- 管户经理岗位ID
      EXPR_AMT,                     -- 已到期金额
      MATURE_TTL_AMT,               -- 总到期金额
      TAKE_RATE_30D,                -- 30天客户承接金额占比
      CUST_TAKE_FLG,                -- 承接状态
      FIXED_MATURE_TRAN_FIN_AMT,    -- 定期到期转理财金额
      FIXED_FIN_MATURE_TRAN_INSUR_AMT, -- 到期转保险金额
      FIN_MATURE_TRAN_FIXED_AMT,    -- 理财到期转定期金额
      FRST_MATURE_PK_BF_DAY_AUM_BAL,-- 本期第一笔到期前一日AUM
      CURR_AUM_BAL                  -- 当前AUM
  )
  SELECT b.PERSN_LEGAL_BK_CODE,
         o.ANCESTOR_ORG_ID,
         b.DATA_DATE, b.STAT_PERD, b.STATIS_TYP, b.CUST_ID, b.ORG_ID, b.POST_ID,
         b.EXPR_AMT, b.MATURE_TTL_AMT, b.TAKE_RATE_30D, b.CUST_TAKE_FLG,
         b.FIXED_MATURE_TRAN_FIN_AMT, b.FIXED_FIN_MATURE_TRAN_INSUR_AMT, b.FIN_MATURE_TRAN_FIXED_AMT,
         b.FRST_MATURE_PK_BF_DAY_AUM_BAL, b.CURR_AUM_BAL
    FROM TMP_CDR_STAT_BASE b
    JOIN (
        SELECT DISTINCT CONNECT_BY_ROOT o.ORG_ID AS LEAF_ORG_ID,
                        o.ORG_ID AS ANCESTOR_ORG_ID
          FROM DWD_SYS_ORG o
         START WITH o.ORG_ID IN (
             SELECT DISTINCT z.ORG_ID
               FROM TMP_CDR_STAT_BASE z
              WHERE z.ORG_ID IS NOT NULL
         )
       CONNECT BY NOCYCLE PRIOR o.SUP_ORG_ID = o.ORG_ID
    ) o
      ON o.LEAF_ORG_ID = b.ORG_ID
  UNION ALL
  SELECT b.PERSN_LEGAL_BK_CODE,
         b.POST_ID,
         b.DATA_DATE, b.STAT_PERD, b.STATIS_TYP, b.CUST_ID, b.ORG_ID, b.POST_ID,
         b.EXPR_AMT, b.MATURE_TTL_AMT, b.TAKE_RATE_30D, b.CUST_TAKE_FLG,
         b.FIXED_MATURE_TRAN_FIN_AMT, b.FIXED_FIN_MATURE_TRAN_INSUR_AMT, b.FIN_MATURE_TRAN_FIXED_AMT,
         b.FRST_MATURE_PK_BF_DAY_AUM_BAL, b.CURR_AUM_BAL
    FROM TMP_CDR_STAT_BASE b
   WHERE b.POST_ID IS NOT NULL;
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第3段业务逻辑处理完成：展开机构和客户经理统计对象';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  --***************************************
  -- 2.3 -- 第4段处理开始：两期分离计算与验证（v3.0.0，单个BEGIN...END分段落）
  -- 业务含义：本期/上期/验证统计逻辑位于同一个匿名块内，以注释段落分隔；方案B(口径36)
  -- 数据来源：TMP_CDR_STAT_SRC（已按机构/管户经理展开，含三种承接类型行）
  -- 处理逻辑：4.0上期冻结快照 / 4.1本期计算段(C1/C2) / 4.2上期计算段(P1/P2) / 4.3验证段(V1，FAIL即中止)
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  DECLARE
    V_FAIL_CNT INTEGER := 0;   -- 验证段失败计数（块级局部变量）
  BEGIN
  -- 4.0 上期统计冻结快照（供验证段比对9基础列是否被修改）
  INSERT INTO TMP_CDR_STAT_FREEZE_LOG (
      BATCH_DATE, PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
      EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
      CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
      DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
  )
  SELECT V_SYSDAT, PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
         EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
         CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
         DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
    FROM ADS_CUST_DEADLINE_RMND_STATIS
   WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END);
  COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '上期统计冻结快照完成：TMP_CDR_STAT_FREEZE_LOG';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, '4', V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    -- ========== 【本期计算段】开始（边界：DATA_DATE=V_SYSDAT）==========
    V_NO_ID := 'C1';
    V_BGN_DATE := SYSDATE;

    INSERT INTO TMP_CDR_STAT_CURR_STAGE (
        PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
        EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
        CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
        DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
    )
    SELECT * FROM (
      -- 承接类型 0-全部
      SELECT s.PERSN_LEGAL_BK_CODE,
             s.DATA_DATE,
             s.STATIS_OBJ,
             s.STAT_PERD,
             '0' AS STATIS_TYP,
             COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS EXPR_CUST_CNT,
             COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS TTL_EXPR_CUST_CNT,
             SUM(s.EXPR_AMT) AS EXPR_AMT,
             SUM(s.MATURE_TTL_AMT) AS TTL_EXPR_AMT,
             CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) = 0 THEN 0
                  ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END)
                             / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) * 100, 2)
             END AS CUST_UNDTAKE_RATE,
             CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
                  ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
             END AS ASSET_KEEP_RATE,
             CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
                  ELSE ROUND(SUM(s.EXPR_AMT * s.TAKE_RATE_30D / 100) / SUM(s.EXPR_AMT) * 100, 2)
             END AS ASSET_UNDTAKE_RATE,
             NVL(ROUND((SELECT NVL(SUM(x.FIXED_MATURE_TRAN_FIN_AMT), 0) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '1')
                       / NULLIF((SELECT SUM(x.EXPR_AMT) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '1'), 0) * 100, 2), 0) AS DEPO_TO_FIN_CONVRS_RATE,
             NVL(ROUND(SUM(s.FIXED_FIN_MATURE_TRAN_INSUR_AMT) / NULLIF(SUM(s.EXPR_AMT), 0) * 100, 2), 0) AS INSUR_CONVRS_RATE,
             NVL(ROUND((SELECT NVL(SUM(x.FIN_MATURE_TRAN_FIXED_AMT), 0) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '2')
                       / NULLIF((SELECT SUM(x.EXPR_AMT) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '2'), 0) * 100, 2), 0) AS FIN_TO_DEPO_CONVRS_RATE
        FROM TMP_CDR_STAT_SRC s
       WHERE s.STATIS_TYP = '0'
       GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STAT_PERD
      UNION ALL
      -- 承接类型 1-定期存款
      SELECT s.PERSN_LEGAL_BK_CODE,
             s.DATA_DATE,
             s.STATIS_OBJ,
             s.STAT_PERD,
             '1' AS STATIS_TYP,
             COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS EXPR_CUST_CNT,
             COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS TTL_EXPR_CUST_CNT,
             SUM(s.EXPR_AMT) AS EXPR_AMT,
             SUM(s.MATURE_TTL_AMT) AS TTL_EXPR_AMT,
             CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) = 0 THEN 0
                  ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END)
                             / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) * 100, 2)
             END AS CUST_UNDTAKE_RATE,
             CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
                  ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
             END AS ASSET_KEEP_RATE,
             CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
                  ELSE ROUND(SUM(s.EXPR_AMT * s.TAKE_RATE_30D / 100) / SUM(s.EXPR_AMT) * 100, 2)
             END AS ASSET_UNDTAKE_RATE,
             NVL(ROUND(SUM(s.FIXED_MATURE_TRAN_FIN_AMT) / NULLIF(SUM(s.EXPR_AMT), 0) * 100, 2), 0) AS DEPO_TO_FIN_CONVRS_RATE,
             0 AS INSUR_CONVRS_RATE,
             0 AS FIN_TO_DEPO_CONVRS_RATE
        FROM TMP_CDR_STAT_SRC s
       WHERE s.STATIS_TYP = '1'
       GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STAT_PERD
      UNION ALL
      -- 承接类型 2-理财
      SELECT s.PERSN_LEGAL_BK_CODE,
             s.DATA_DATE,
             s.STATIS_OBJ,
             s.STAT_PERD,
             '2' AS STATIS_TYP,
             COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS EXPR_CUST_CNT,
             COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS TTL_EXPR_CUST_CNT,
             SUM(s.EXPR_AMT) AS EXPR_AMT,
             SUM(s.MATURE_TTL_AMT) AS TTL_EXPR_AMT,
             CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) = 0 THEN 0
                  ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END)
                             / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) * 100, 2)
             END AS CUST_UNDTAKE_RATE,
             CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
                  ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
             END AS ASSET_KEEP_RATE,
             CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
                  ELSE ROUND(SUM(s.EXPR_AMT * s.TAKE_RATE_30D / 100) / SUM(s.EXPR_AMT) * 100, 2)
             END AS ASSET_UNDTAKE_RATE,
             0 AS DEPO_TO_FIN_CONVRS_RATE,
             0 AS INSUR_CONVRS_RATE,
             NVL(ROUND(SUM(s.FIN_MATURE_TRAN_FIXED_AMT) / NULLIF(SUM(s.EXPR_AMT), 0) * 100, 2), 0) AS FIN_TO_DEPO_CONVRS_RATE
        FROM TMP_CDR_STAT_SRC s
       WHERE s.STATIS_TYP = '2'
       GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STAT_PERD
    ) WHERE DATA_DATE = V_SYSDAT;   -- 边界检查：仅本期统计源行

    -- 边界检查：本期统计结果 DATA_DATE 必须全部等于跑批日期
    IF EXISTS (SELECT 1 FROM TMP_CDR_STAT_CURR_STAGE WHERE DATA_DATE <> V_SYSDAT) THEN
      RAISE_APPLICATION_ERROR(-20021, '本期统计边界检查失败：CURR_STAGE存在DATA_DATE<>V_SYSDAT行（跨期引用）');
    END IF;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '本期统计计算段完成：STAT_CURR_STAGE生成并边界检查通过';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'C1', V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    V_NO_ID := 'C2';
    V_BGN_DATE := SYSDATE;
    INSERT INTO ADS_CUST_DEADLINE_RMND_STATIS (
        PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
        EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
        CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
        DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
    )
    SELECT
        PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
        EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
        CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
        DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
      FROM TMP_CDR_STAT_CURR_STAGE;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '本期统计计算段完成：写入ADS_CUST_DEADLINE_RMND_STATIS';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'C2', V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    -- ========== 【本期计算段】结束 ==========
    -- ========== 【上期计算段】开始（边界：DATA_DATE=上期期末日期）==========
    V_NO_ID := 'P1';
    V_BGN_DATE := SYSDATE;

    INSERT INTO TMP_CDR_STAT_PREV_STAGE (
        PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
        EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
        CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
        DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
    )
    SELECT * FROM (
      -- 承接类型 0-全部
      SELECT s.PERSN_LEGAL_BK_CODE,
             s.DATA_DATE,
             s.STATIS_OBJ,
             s.STAT_PERD,
             '0' AS STATIS_TYP,
             COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS EXPR_CUST_CNT,
             COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS TTL_EXPR_CUST_CNT,
             SUM(s.EXPR_AMT) AS EXPR_AMT,
             SUM(s.MATURE_TTL_AMT) AS TTL_EXPR_AMT,
             CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) = 0 THEN 0
                  ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END)
                             / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) * 100, 2)
             END AS CUST_UNDTAKE_RATE,
             CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
                  ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
             END AS ASSET_KEEP_RATE,
             CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
                  ELSE ROUND(SUM(s.EXPR_AMT * s.TAKE_RATE_30D / 100) / SUM(s.EXPR_AMT) * 100, 2)
             END AS ASSET_UNDTAKE_RATE,
             NVL(ROUND((SELECT NVL(SUM(x.FIXED_MATURE_TRAN_FIN_AMT), 0) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '1')
                       / NULLIF((SELECT SUM(x.EXPR_AMT) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '1'), 0) * 100, 2), 0) AS DEPO_TO_FIN_CONVRS_RATE,
             NVL(ROUND(SUM(s.FIXED_FIN_MATURE_TRAN_INSUR_AMT) / NULLIF(SUM(s.EXPR_AMT), 0) * 100, 2), 0) AS INSUR_CONVRS_RATE,
             NVL(ROUND((SELECT NVL(SUM(x.FIN_MATURE_TRAN_FIXED_AMT), 0) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '2')
                       / NULLIF((SELECT SUM(x.EXPR_AMT) FROM TMP_CDR_STAT_SRC x
                         WHERE x.PERSN_LEGAL_BK_CODE = s.PERSN_LEGAL_BK_CODE
                           AND x.DATA_DATE = s.DATA_DATE
                           AND x.STATIS_OBJ = s.STATIS_OBJ
                           AND x.STAT_PERD = s.STAT_PERD
                           AND x.STATIS_TYP = '2'), 0) * 100, 2), 0) AS FIN_TO_DEPO_CONVRS_RATE
        FROM TMP_CDR_STAT_SRC s
       WHERE s.STATIS_TYP = '0'
       GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STAT_PERD
      UNION ALL
      -- 承接类型 1-定期存款
      SELECT s.PERSN_LEGAL_BK_CODE,
             s.DATA_DATE,
             s.STATIS_OBJ,
             s.STAT_PERD,
             '1' AS STATIS_TYP,
             COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS EXPR_CUST_CNT,
             COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS TTL_EXPR_CUST_CNT,
             SUM(s.EXPR_AMT) AS EXPR_AMT,
             SUM(s.MATURE_TTL_AMT) AS TTL_EXPR_AMT,
             CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) = 0 THEN 0
                  ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END)
                             / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) * 100, 2)
             END AS CUST_UNDTAKE_RATE,
             CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
                  ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
             END AS ASSET_KEEP_RATE,
             CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
                  ELSE ROUND(SUM(s.EXPR_AMT * s.TAKE_RATE_30D / 100) / SUM(s.EXPR_AMT) * 100, 2)
             END AS ASSET_UNDTAKE_RATE,
             NVL(ROUND(SUM(s.FIXED_MATURE_TRAN_FIN_AMT) / NULLIF(SUM(s.EXPR_AMT), 0) * 100, 2), 0) AS DEPO_TO_FIN_CONVRS_RATE,
             0 AS INSUR_CONVRS_RATE,
             0 AS FIN_TO_DEPO_CONVRS_RATE
        FROM TMP_CDR_STAT_SRC s
       WHERE s.STATIS_TYP = '1'
       GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STAT_PERD
      UNION ALL
      -- 承接类型 2-理财
      SELECT s.PERSN_LEGAL_BK_CODE,
             s.DATA_DATE,
             s.STATIS_OBJ,
             s.STAT_PERD,
             '2' AS STATIS_TYP,
             COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS EXPR_CUST_CNT,
             COUNT(DISTINCT CASE WHEN s.MATURE_TTL_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) AS TTL_EXPR_CUST_CNT,
             SUM(s.EXPR_AMT) AS EXPR_AMT,
             SUM(s.MATURE_TTL_AMT) AS TTL_EXPR_AMT,
             CASE WHEN COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) = 0 THEN 0
                  ELSE ROUND(COUNT(DISTINCT CASE WHEN s.CUST_TAKE_FLG = '1' THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END)
                             / COUNT(DISTINCT CASE WHEN s.EXPR_AMT > 0 THEN s.CUST_ID || CHR(1) || s.PERSN_LEGAL_BK_CODE || CHR(1) || s.ORG_ID END) * 100, 2)
             END AS CUST_UNDTAKE_RATE,
             CASE WHEN SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) = 0 THEN 0
                  ELSE ROUND(SUM(s.CURR_AUM_BAL) / SUM(s.FRST_MATURE_PK_BF_DAY_AUM_BAL) * 100, 2)
             END AS ASSET_KEEP_RATE,
             CASE WHEN SUM(s.EXPR_AMT) = 0 THEN 0
                  ELSE ROUND(SUM(s.EXPR_AMT * s.TAKE_RATE_30D / 100) / SUM(s.EXPR_AMT) * 100, 2)
             END AS ASSET_UNDTAKE_RATE,
             0 AS DEPO_TO_FIN_CONVRS_RATE,
             0 AS INSUR_CONVRS_RATE,
             NVL(ROUND(SUM(s.FIN_MATURE_TRAN_FIXED_AMT) / NULLIF(SUM(s.EXPR_AMT), 0) * 100, 2), 0) AS FIN_TO_DEPO_CONVRS_RATE
        FROM TMP_CDR_STAT_SRC s
       WHERE s.STATIS_TYP = '2'
       GROUP BY s.PERSN_LEGAL_BK_CODE, s.DATA_DATE, s.STATIS_OBJ, s.STAT_PERD
    ) WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END);  -- 边界检查：仅上期周期实例(口径38)

    -- 边界检查：上期统计结果 DATA_DATE 必须与上期期末日期一一对应
    IF EXISTS (SELECT 1 FROM TMP_CDR_STAT_PREV_STAGE
                WHERE (STATIS_CYCLE = 'M' AND DATA_DATE <> V_PREV_MONTH_END)
                   OR (STATIS_CYCLE = 'Q' AND DATA_DATE <> V_PREV_QUARTER_END)
                   OR (STATIS_CYCLE = 'Y' AND DATA_DATE <> V_PREV_YEAR_END)) THEN
      RAISE_APPLICATION_ERROR(-20022, '上期统计边界检查失败：PREV_STAGE存在DATA_DATE与上期期末不一致行（跨期引用）');
    END IF;
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '上期统计计算段完成：STAT_PREV_STAGE生成并边界检查通过';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'P1', V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

    V_NO_ID := 'P2';
    V_BGN_DATE := SYSDATE;
    -- 方案B(口径36)：上期行仅更新6个率值列，缺失上期行整行补插
    MERGE INTO ADS_CUST_DEADLINE_RMND_STATIS dst
    USING TMP_CDR_STAT_PREV_STAGE src
    ON (dst.PERSN_LEGAL_BK_CODE = src.PERSN_LEGAL_BK_CODE
        AND dst.DATA_DATE = src.DATA_DATE
        AND dst.STATIS_OBJ = src.STATIS_OBJ
        AND dst.STATIS_CYCLE = src.STATIS_CYCLE
        AND dst.STATIS_TYP = src.STATIS_TYP)
    WHEN MATCHED THEN UPDATE SET
        dst.CUST_UNDTAKE_RATE     = src.CUST_UNDTAKE_RATE,
        dst.ASSET_KEEP_RATE       = src.ASSET_KEEP_RATE,
        dst.ASSET_UNDTAKE_RATE    = src.ASSET_UNDTAKE_RATE,
        dst.DEPO_TO_FIN_CONVRS_RATE = src.DEPO_TO_FIN_CONVRS_RATE,
        dst.INSUR_CONVRS_RATE     = src.INSUR_CONVRS_RATE,
        dst.FIN_TO_DEPO_CONVRS_RATE = src.FIN_TO_DEPO_CONVRS_RATE
    WHEN NOT MATCHED THEN INSERT (
        PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
        EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT,
        CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
        DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
    ) VALUES (
        src.PERSN_LEGAL_BK_CODE, src.DATA_DATE, src.STATIS_OBJ, src.STATIS_CYCLE, src.STATIS_TYP,
        src.EXPR_CUST_CNT, src.TTL_EXPR_CUST_CNT, src.EXPR_AMT, src.TTL_EXPR_AMT,
        src.CUST_UNDTAKE_RATE, src.ASSET_KEEP_RATE, src.ASSET_UNDTAKE_RATE,
        src.DEPO_TO_FIN_CONVRS_RATE, src.INSUR_CONVRS_RATE, src.FIN_TO_DEPO_CONVRS_RATE
    );
    COMMIT;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '上期统计计算段完成：仅更新6个率值列/补插缺失上期行';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'P2', V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    -- ========== 【上期计算段】结束 ==========
    -- ========== 【数据验证段】开始（冻结/一致性/互斥/值域/行数，FAIL即中止）==========
    V_NO_ID := 'V1';
    V_BGN_DATE := SYSDATE;

    -- V1: 上期9基础列冻结校验（STAT_FREEZE_LOG vs 目标表当前上期行）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'FREEZE_BASE_9',
           CASE WHEN NOT EXISTS (
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                           EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT
                      FROM TMP_CDR_STAT_FREEZE_LOG
                    MINUS
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                           EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT
                      FROM ADS_CUST_DEADLINE_RMND_STATIS
                     WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
                AND NOT EXISTS (
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                           EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT
                      FROM ADS_CUST_DEADLINE_RMND_STATIS
                     WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END)
                    MINUS
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                           EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT
                      FROM TMP_CDR_STAT_FREEZE_LOG)
           THEN 'PASS' ELSE 'FAIL' END,
           '上期9基础列冻结校验（方案B/口径36）', SYSDATE FROM dual;

    -- V2: 上期6率值列一致性（目标表上期行 vs PREV_STAGE）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'PREV_6RATES_CONSISTENT',
           CASE WHEN NOT EXISTS (
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                           CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
                           DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
                      FROM TMP_CDR_STAT_PREV_STAGE
                    MINUS
                    SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                           CUST_UNDTAKE_RATE, ASSET_KEEP_RATE, ASSET_UNDTAKE_RATE,
                           DEPO_TO_FIN_CONVRS_RATE, INSUR_CONVRS_RATE, FIN_TO_DEPO_CONVRS_RATE
                      FROM ADS_CUST_DEADLINE_RMND_STATIS
                     WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
           THEN 'PASS' ELSE 'FAIL' END,
           '上期6率值列一致性校验', SYSDATE FROM dual;

    -- V3: 本期结果不得包含上期日期（DATA_DATE互斥）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'C', 'CURR_NO_PREV_DATE',
           CASE WHEN EXISTS (SELECT 1 FROM TMP_CDR_STAT_CURR_STAGE
                              WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
                THEN 'FAIL' ELSE 'PASS' END,
           '本期统计结果与上期日期互斥校验', SYSDATE FROM dual;

    -- V4: 率值域（两期独立校验，率值>=0且非空）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'C', 'RATE_DOMAIN_CURR',
           CASE WHEN EXISTS (SELECT 1 FROM TMP_CDR_STAT_CURR_STAGE
                              WHERE CUST_UNDTAKE_RATE IS NULL OR CUST_UNDTAKE_RATE < 0
                                 OR ASSET_KEEP_RATE IS NULL OR ASSET_KEEP_RATE < 0
                                 OR ASSET_UNDTAKE_RATE IS NULL OR ASSET_UNDTAKE_RATE < 0)
                THEN 'FAIL' ELSE 'PASS' END,
           '本期统计率值域校验', SYSDATE FROM dual;
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'RATE_DOMAIN_PREV',
           CASE WHEN EXISTS (SELECT 1 FROM TMP_CDR_STAT_PREV_STAGE
                              WHERE CUST_UNDTAKE_RATE IS NULL OR CUST_UNDTAKE_RATE < 0
                                 OR ASSET_KEEP_RATE IS NULL OR ASSET_KEEP_RATE < 0
                                 OR ASSET_UNDTAKE_RATE IS NULL OR ASSET_UNDTAKE_RATE < 0)
                THEN 'FAIL' ELSE 'PASS' END,
           '上期统计率值域校验', SYSDATE FROM dual;

    -- V5: stage与目标表行数一致性（两期独立校验）
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'C', 'ROWCOUNT_CONSISTENT_CURR',
           CASE WHEN (SELECT COUNT(*) FROM TMP_CDR_STAT_CURR_STAGE)
                  = (SELECT COUNT(*) FROM ADS_CUST_DEADLINE_RMND_STATIS WHERE DATA_DATE = V_SYSDAT)
                THEN 'PASS' ELSE 'FAIL' END,
           '本期统计stage与目标表行数一致性', SYSDATE FROM dual;
    INSERT INTO TMP_CDR_VALIDATE_RESULT (BATCH_DATE, PERIOD_TYP, VALIDATE_ITEM, RESULT, DETAIL, CHECK_TIME)
    SELECT V_SYSDAT, 'P', 'ROWCOUNT_CONSISTENT_PREV',
           CASE WHEN (SELECT COUNT(*) FROM TMP_CDR_STAT_PREV_STAGE)
                  = (SELECT COUNT(*) FROM ADS_CUST_DEADLINE_RMND_STATIS
                      WHERE DATA_DATE IN (V_PREV_MONTH_END, V_PREV_QUARTER_END, V_PREV_YEAR_END))
                THEN 'PASS' ELSE 'FAIL' END,
           '上期统计stage与目标表行数一致性', SYSDATE FROM dual;

    COMMIT;

    -- 任一FAIL即中止批次（防止污染数据后继续）
    SELECT COUNT(*) INTO V_FAIL_CNT
      FROM TMP_CDR_VALIDATE_RESULT
     WHERE BATCH_DATE = V_SYSDAT AND RESULT = 'FAIL';
    IF V_FAIL_CNT > 0 THEN
      RAISE_APPLICATION_ERROR(-20023, '统计数据验证失败：' || V_FAIL_CNT || ' 项校验未通过');
    END IF;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
    OUTCDE := 0;
    V_LOG_MSG := '统计数据验证段完成：两期结果准确性与独立性校验通过';
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, 'V1', V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    -- ========== 【数据验证段】结束 ==========
  END;
  DELETE FROM ADS_CUST_DEADLINE_RMND_STATIS t
   WHERE t.DATA_DATE NOT IN (
          V_SYSDAT,
          V_PREV_MONTH_END,
          V_PREV_QUARTER_END,
          V_PREV_YEAR_END
        )
     AND t.DATA_DATE < V_HISTORY_CUTOFF_DATE;
  COMMIT;

  OUTCDE := 0;
  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  V_LOG_MSG := '第4段业务逻辑处理完成：写入到期承接统计表并清理历史';
  V_LOG_FLG := OUTCDE;
  SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);

  -- 异常处理区：任一环节异常时统一置返回码-1、回滚当前事务并记录错误日志后重抛
EXCEPTION
  WHEN OTHERS THEN
    OUTCDE := -1;
    ROLLBACK;
    V_END_DATE := SYSDATE;
    V_DURA_DATE := CASE WHEN V_BGN_DATE IS NULL THEN NULL ELSE TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60) END;
    V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);
    V_LOG_FLG := OUTCDE;
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);
    RAISE;
END

;
