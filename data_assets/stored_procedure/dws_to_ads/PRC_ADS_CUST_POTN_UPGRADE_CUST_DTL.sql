CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程：潜力提升客户明细处理
  -- 处理周期: 日
  -- 过程描述: 按临界等级、月日均资产和T-1时点资产计算达标、接触及统计指标
  -- 来源表: DWS_CUST_ASSE_LIAB, DWD_CUST_INDV_INFO, DWD_CUST_MAN, DWS_CUST_LVL_INFO, ADS_MKT_REC_INFO
  -- 目标表: ADS_CUST_POTN_UPGRADE_CUST_DTL
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v3.1.2
  -- 变更记录:
  --   v2.2.0 2026-07-27 计算单位调整为客户号+归属机构(ORG_ID)
  --   v2.3.0 2026-07-27 相对日期统一使用sys_fun_deal_date
  --   v2.4.0 2026-07-27 补充三键关联及业务处理段说明
  --   v2.4.1 2026-07-28 年码值N→Y；DWS_CUST_LVL_INFO关联补PERSN_LEGAL_BK_CODE
  --   v2.4.2 2026-07-28 月初日期参数改用DATE类型声明
  --   v2.4.3 2026-07-28 DWS_CUST_ASSE_LIAB关联移除ORG_ID条件
  --   v2.4.4 2026-07-28 DWD_CUST_INDV_INFO关联补PERSN_LEGAL_BK_CODE
  --   v2.5.0 2026-07-28 管户经理改用DWD_CUST_MAN表(MNG_TYP='1'理财管户)
  --   v3.0.0 2026-07-28 月/季/年切片按不同时间窗口独立计算接触状态：月=当月初，季=TRUNC(Q)，年=TRUNC(Y)
  --   v3.1.0 2026-07-30 去掉季/年统计周期切片，仅保留月度（对应v2.0.3需求变更）
  --   v3.1.1 2026-07-30 T-1日=跑批日期V_SYSDAT；PNT_AUM_BAL改为从b取AUM_BAL，移除冗余q关联和V_PREV_DAY变量
  --   v3.1.2 2026-07-30 补充所有变量、字段、表别名、逻辑参数的注释
  --   v3.2.0 2026-08-04 F-01:接触EXISTS补PERSN_LEGAL_BK_CODE+MKT_PERSN关联(防跨法人行误匹配)；
  --                       F-02:LVL_CRIT先INSERT后DELETE改为WHERE条件直接过滤；
  --                       F-04:新增V_RUN_DATE_DT变量专用于业务逻辑，V_END_DATE仅用于日志
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '潜力提升客户明细处理';                  -- 过程描述
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL';  -- 过程名称
  V_LOG_MSG              VARCHAR(4000);                                         -- 日志消息文本
  V_LOG_FLG              INTEGER;                                               -- 日志标志（0=成功）
  V_LOG_BUTTON           INTEGER := 1;                                          -- 日志记录开关（1=启用）
  V_NO_ID                VARCHAR(10);                                           -- 当前步骤序号
  V_BGN_DATE             DATE;                                                  -- 步骤开始时间
  V_END_DATE             DATE;                                                  -- 步骤结束时间
  V_DURA_DATE            INTEGER;                                               -- 步骤耗时（秒）
  V_PREV_MONTH_END       VARCHAR2(8);                                           -- 上月末日期（YYYYMMDD），用于取上月月日均资产筛选临界客户
  V_CURR_MONTH_BEGIN_DT  DATE;                                                  -- 当月初日期，用于限定月接触窗口起点
  V_RUN_DATE_DT          DATE;                                                  -- 跑批日期DATE类型，专用于业务逻辑（接触窗口上界）
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                           -- 三年历史清理边界（YYYYMMDD），sys_fun_deal_date(V_SYSDAT,19)

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查
  ------------------------------------------------------------------
  -- 1. 校验跑批日期并初始化本过程使用的相对业务日期参数。
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');
  V_RUN_DATE_DT := V_END_DATE;                                                  -- 跑批日期DATE类型（业务逻辑用，V_END_DATE后续仅用于日志）
  V_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 2);
  V_CURR_MONTH_BEGIN_DT := TO_DATE(sys_fun_deal_date(V_SYSDAT, 9), 'YYYYMMDD');
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);

  ------------------------------------------------------------------
  -- 2. TMP1：清理当前数据日明细和物理临时表
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  -- 2. 清理本跑批日已生成的明细和超过保留期限的历史数据，保证过程可重跑。
  DELETE FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D
   WHERE D.DATA_DATE = V_SYSDAT;

  DELETE FROM ADS_CUST_POTN_UPGRADE_CUST_DTL D
   WHERE D.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_POTN_BASE');
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日明细和物理临时表';
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
  -- 3. TMP2：生成临界客户及月均、时点、接触基础数据
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  -- 3. 基于上月末月日均资产筛选临界客户，并按客户、法人行、归属机构关联资产和接触记录。
  INSERT INTO TMP_ADS_POTN_BASE (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      CUST_ID,                                                  -- 客户号
      CUST_NAME,                                                -- 客户姓名
      CUST_LVL,                                                 -- 当前客户等级（来源DWS_CUST_LVL_INFO）
      LVL_CRIT,                                                 -- 临界升级等级（03=优质/04=财富1/05=财富2/06=贵宾/07=私行）
      DEPO_CURNT_DEPO_BAL,                                      -- T-1日活期存款余额（来源b.DEPO_CURNT_DEPO_BAL）
      FIXD_DEPO_BAL,                                            -- T-1日定期存款余额（来源b.FIXD_DEPO_BAL）
      FIN_AMT,                                                  -- T-1日理财余额（来源b.FIN_BAL）
      CURR_MTH_AVG_AUM,                                         -- 当月月日均AUM（来源m.AUM_BAL，BAL_TYPE='2'）
      PNT_AUM_BAL,                                              -- T-1日时点AUM（T-1=跑批日，来源b.AUM_BAL，BAL_TYPE='1'）
      CNTCT_STATE_M,                                            -- 月接触状态（1=当月初至跑批日有营销接触，0=无）
      POST_ID,                                                  -- 管户经理岗位ID（来源DWD_CUST_MAN，MNG_TYP='1'理财管户）
      ORG_ID                                                    -- 归属机构ID（来源上月末资产记录的ORG_ID）
  )
  SELECT p.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         c.CUST_ID,                                             -- 客户号
         c.CUST_NAME,                                           -- 客户姓名（来源DWD_CUST_INDV_INFO）
         l.CUST_LVL,                                            -- 当前客户等级（来源DWS_CUST_LVL_INFO，取跑批日最新等级）
         CASE                                                   -- 根据上月末月日均AUM确定临界升级等级
           WHEN p.AUM_BAL >= 45000 AND p.AUM_BAL < 50000 THEN '03'       -- 临界优质：4.5万≤AUM<5万
           WHEN p.AUM_BAL >= 270000 AND p.AUM_BAL < 300000 THEN '04'     -- 临界财富1：27万≤AUM<30万
           WHEN p.AUM_BAL >= 450000 AND p.AUM_BAL < 500000 THEN '05'     -- 临界财富2：45万≤AUM<50万
           WHEN p.AUM_BAL >= 900000 AND p.AUM_BAL < 1000000 THEN '06'    -- 临界贵宾：90万≤AUM<100万
           WHEN p.AUM_BAL >= 2700000 AND p.AUM_BAL < 3000000 THEN '07'   -- 临界私行：270万≤AUM<300万
         END,
         NVL(b.DEPO_CURNT_DEPO_BAL, 0),                         -- T-1日活期存款余额（BAL_TYPE='1'时点，若无则0）
         NVL(b.FIXD_DEPO_BAL, 0),                               -- T-1日定期存款余额（BAL_TYPE='1'时点，若无则0）
         NVL(b.FIN_BAL, 0),                                     -- T-1日理财余额（BAL_TYPE='1'时点，若无则0）
         NVL(m.AUM_BAL, 0),                                     -- 当月月日均AUM（BAL_TYPE='2'月日均，若无则0）
         NVL(b.AUM_BAL, 0),                                     -- T-1日时点AUM（T-1=跑批日，BAL_TYPE='1'时点）
         CASE                                                   -- 月接触：当月初至跑批日存在有效营销接触记录
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO r                           -- 营销接触记录表
              WHERE r.CUST_ID = c.CUST_ID
                AND r.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE  -- 双键关联：客户号+法人行号
                AND r.MKT_PERSN = cm.MNGR_POST_ID               -- 仅统计本管户经理的接触
                AND r.MKT_TYP IN ('1', '2', '3', '4')           -- 营销接触类型（1=电话/2=短信/3=微信/4=上门）
                AND r.MKT_TIME IS NOT NULL                      -- 接触时间不为空
                AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN V_CURR_MONTH_BEGIN_DT AND V_RUN_DATE_DT  -- 接触时间在当月初至跑批日范围内
           ) THEN '1'                                           -- 有接触
           ELSE '0'                                             -- 无接触
         END,
         cm.MNGR_POST_ID,                                       -- 管户经理岗位ID
         p.ORG_ID                                               -- 归属机构ID
    FROM DWS_CUST_ASSE_LIAB p                                   -- p：上月末月日均资产，用于筛选临界客户（DATA_DATE=V_PREV_MONTH_END, BAL_TYPE='2'）
    JOIN DWD_CUST_INDV_INFO c                                   -- c：客户基本信息（客户姓名）
      ON c.CUST_ID = p.CUST_ID
     AND c.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE         -- 双键关联：客户号+法人行号
    LEFT JOIN DWD_CUST_MAN cm                                   -- cm：管户经理关系（理财管户）
      ON cm.CUST_ID = p.CUST_ID
     AND cm.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND cm.MNG_TYP = '1'                                       -- 理财管户类型
    LEFT JOIN DWS_CUST_LVL_INFO l                               -- l：客户等级（跑批日最新等级）
      ON l.CUST_ID = p.CUST_ID
     AND l.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND l.DATA_DATE = V_SYSDAT                                 -- 取跑批日等级数据
    LEFT JOIN DWS_CUST_ASSE_LIAB m                              -- m：当月月日均AUM（DATA_DATE=V_SYSDAT, BAL_TYPE='2'）
     ON m.CUST_ID = p.CUST_ID
     AND m.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND m.DATA_DATE = V_SYSDAT
     AND m.BAL_TYPE = '2'                                       -- 月日均余额类型
    LEFT JOIN DWS_CUST_ASSE_LIAB b                              -- b：T-1日时点资产（DATA_DATE=V_SYSDAT, BAL_TYPE='1'）
     ON b.CUST_ID = p.CUST_ID
     AND b.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
     AND b.DATA_DATE = V_SYSDAT                                 -- T-1日=跑批日期
     AND b.BAL_TYPE = '1'                                       -- 时点余额类型
   WHERE p.DATA_DATE = V_PREV_MONTH_END                         -- 取上月末月日均资产
     AND p.BAL_TYPE = '2'                                       -- 月日均余额类型
     AND (
       (p.AUM_BAL >= 45000 AND p.AUM_BAL < 50000) OR           -- 临界优质：4.5万≤AUM<5万
       (p.AUM_BAL >= 270000 AND p.AUM_BAL < 300000) OR         -- 临界财富1：27万≤AUM<30万
       (p.AUM_BAL >= 450000 AND p.AUM_BAL < 500000) OR         -- 临界财富2：45万≤AUM<50万
       (p.AUM_BAL >= 900000 AND p.AUM_BAL < 1000000) OR        -- 临界贵宾：90万≤AUM<100万
       (p.AUM_BAL >= 2700000 AND p.AUM_BAL < 3000000)          -- 临界私行：270万≤AUM<300万
     );

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成临界客户及月均、时点、接触基础数据';
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
  -- 4. 目标表写入：生成月度统计周期明细
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  -- 4. 接触窗口为当月初至跑批日，达标判断使用T-1时点AUM。
  INSERT INTO ADS_CUST_POTN_UPGRADE_CUST_DTL (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      DATA_DATE,                                                -- 数据日期（YYYYMMDD，=跑批日期V_SYSDAT）
      CUST_ID,                                                  -- 客户号
      CUST_NAME,                                                -- 客户姓名
      CUST_LVL,                                                 -- 当前客户等级
      LVL_CRIT,                                                 -- 临界升级等级（03/04/05/06/07）
      DEPO_CURNT_DEPO_BAL,                                      -- T-1日活期存款余额
      FIXD_DEPO_BAL,                                            -- T-1日定期存款余额
      FIN_AMT,                                                  -- T-1日理财余额
      CNTCT_STATE,                                              -- 月接触状态（1=有接触，0=无接触）
      QUAL_STATE,                                               -- T-1时点达标状态（1=达标，0=未达标）
      POST_ID,                                                  -- 管户经理岗位ID
      ORG_ID,                                                   -- 归属机构ID
      STATIS_CYCLE                                              -- 统计周期（M=月度）
  )
  SELECT x.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         V_SYSDAT,                                              -- 数据日期=跑批日期
         x.CUST_ID,                                             -- 客户号
         x.CUST_NAME,                                           -- 客户姓名
         x.CUST_LVL,                                            -- 当前客户等级
         x.LVL_CRIT,                                            -- 临界升级等级
         x.DEPO_CURNT_DEPO_BAL,                                 -- T-1日活期存款余额
         x.FIXD_DEPO_BAL,                                       -- T-1日定期存款余额
         x.FIN_AMT,                                             -- T-1日理财余额
         x.CNTCT_STATE_M,                                       -- 月接触状态（来自TMP_ADS_POTN_BASE.CNTCT_STATE_M）
         CASE                                                   -- T-1时点达标判断：按临界等级阈值比较T-1时点AUM
           WHEN (x.LVL_CRIT = '03' AND x.PNT_AUM_BAL >= 50000)      -- 临界优质→达标阈值5万
             OR (x.LVL_CRIT = '04' AND x.PNT_AUM_BAL >= 300000)     -- 临界财富1→达标阈值30万
             OR (x.LVL_CRIT = '05' AND x.PNT_AUM_BAL >= 500000)     -- 临界财富2→达标阈值50万
             OR (x.LVL_CRIT = '06' AND x.PNT_AUM_BAL >= 1000000)    -- 临界贵宾→达标阈值100万
             OR (x.LVL_CRIT = '07' AND x.PNT_AUM_BAL >= 3000000)    -- 临界私行→达标阈值300万
           THEN '1'                                             -- 达标
           ELSE '0'                                             -- 未达标
         END,
         x.POST_ID,                                             -- 管户经理岗位ID
         x.ORG_ID,                                              -- 归属机构ID
         'M'                                                    -- 统计周期：月度
    FROM TMP_ADS_POTN_BASE x;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入潜力提升客户明细';
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
  -- 5. 发生异常时回滚本过程事务并记录失败日志。
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
