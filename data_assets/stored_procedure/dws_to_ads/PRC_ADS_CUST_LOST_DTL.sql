CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_LOST_DTL(
    V_SYSDAT IN VARCHAR,                                          -- 跑批日期（YYYYMMDD，T-1日=跑批日）
    OUTCDE   OUT INTEGER                                         -- 输出返回码（0=成功，-1=异常）
)
AS
  ------------------------------------------------------------------
  -- 存储过程：客户流失清单处理
  -- 处理周期: 日
  -- 过程描述: 按轻度、重度流失规则，计算接触、挽回和挽回金融资产
  -- 来源表: DWS_CUST_ASSE_LIAB, DWD_CUST_INDV_INFO, DWS_CUST_LVL_INFO, ADS_MKT_REC_INFO
  -- 目标表: ADS_CUST_LOST_DTL
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.5.0
  -- 关联需求: REQ-CUST-001
  -- 变更记录:
  --   v2.1.0: 1.已挽回金融资产口径确认：T-1日金融资产余额达标的客户，从月初~T-1日金融资产新增总金额
  --           2.明细表新增RESCUED_FINA_ASSET字段
  --   v2.3.0 2026-07-28 月/季/年切片接触状态按不同时间窗口独立计算
  --   v2.4.1 2026-07-30 去掉季/年统计周期切片仅保留月度；T-1日统一为V_SYSDAT(与潜力提升一致)；
  --            删除第5段历史客群持续经营；全字段补充注释
  --   v2.5.0 2026-08-04 F-01:接触EXISTS补PERSN_LEGAL_BK_CODE+MKT_PERSN关联；
  --                       F-02:POST_ID改用m.MNGR_POST_ID(DWD_CUST_MAN,与潜力提升一致)；
  --                       F-03:新增V_RUN_DATE_DT变量分离业务/日志用途；
  --                       F-05:阈值CASE封装为TMP_ADS_LOST_THRESH查找表(消除6处重复)；
  --                       F-06:子查询过滤NULL LVL_CHURN(消除先INSERT后DELETE)
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '客户流失清单处理';                     -- 过程描述
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_LOST_DTL';              -- 过程名称
  V_LOG_MSG              VARCHAR(4000);                                         -- 日志消息文本
  V_LOG_FLG              INTEGER;                                               -- 日志标志（0=成功）
  V_LOG_BUTTON           INTEGER := 1;                                          -- 日志记录开关（1=启用）
  V_NO_ID                VARCHAR(10);                                           -- 当前步骤序号
  V_BGN_DATE             DATE;                                                  -- 步骤开始时间
  V_END_DATE             DATE;                                                  -- 步骤结束时间
  V_DURA_DATE            INTEGER;                                               -- 步骤耗时（秒）
  V_DATA_DATE            VARCHAR2(8);                                           -- 跑批日期（=V_SYSDAT）
  V_PREV_MONTH_END       VARCHAR2(8);                                           -- 上月末日期（YYYYMMDD），用于判定轻度流失和上月末余额
  V_PREV_PREV_MONTH_END  VARCHAR2(8);                                           -- 上上月末日期（YYYYMMDD），用于判定重度流失
  V_CURR_MONTH_BEGIN_DT  DATE;                                                  -- 当月初日期，用于限定月接触窗口起点
  V_RUN_DATE_DT          DATE;                                                  -- 跑批日期DATE类型，专用于业务逻辑（接触窗口上界）
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                           -- 三年历史清理边界（参数19）

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS                                 -- 清空物理临时表
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查：校验跑批日期并初始化相对业务日期参数
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1' || '_CHK';
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  V_DATA_DATE := V_SYSDAT;                                                  -- 跑批日期=T-1日
  V_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 2);                       -- 上月末（参数2）
  V_PREV_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 6);                  -- 上上月末（参数6）
  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');                              -- 转换为DATE类型
  V_RUN_DATE_DT := V_END_DATE;                              -- 跑批日期DATE类型（业务逻辑用，V_END_DATE后续仅用于日志）
  V_CURR_MONTH_BEGIN_DT := TO_DATE(sys_fun_deal_date(V_SYSDAT, 9), 'YYYYMMDD');  -- 当月初（参数9）
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);                      -- 三年历史清理边界（参数19）

  ------------------------------------------------------------------
  -- 2. TMP1：清理当前数据日明细、三年历史数据和物理临时表，保证可重跑
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_LOST_DTL D                                           -- 清理当天数据（支持重跑）
   WHERE D.DATA_DATE = V_DATA_DATE;

  DELETE FROM ADS_CUST_LOST_DTL D                                           -- 清理三年历史清理边界（参数19）之前的数据
   WHERE D.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_LOST_BASE');                                           -- 清空物理临时表
  TRUNC_TMP('TMP_ADS_LOST_THRESH');                             -- 清空阈值查找表
  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日明细、三年前历史数据和物理临时表';
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
  -- 3. TMP2：生成轻度和重度流失客户基础数据
  --
  -- 流失判定逻辑：
  --   轻度流失(1)：上月月日均AUM达标 + 上月末时点AUM不达标
  --   重度流失(2)：上上月月日均AUM达标 + 上月月日均AUM不达标 + 上月末时点AUM不达标
  --
  -- 表别名说明：
  --   p  = 上月月日均（DATA_DATE=V_PREV_MONTH_END, BAL_TYPE='2'）
  --   pp = 上上月月日均（DATA_DATE=V_PREV_PREV_MONTH_END, BAL_TYPE='2'）
  --   c  = 客户基本信息（DWD_CUST_INDV_INFO）
  --   cur_l = 当前客户等级（DATA_DT=V_DATA_DATE）
  --   e  = 上月末时点AUM（DATA_DATE=V_PREV_MONTH_END, BAL_TYPE='1'）—用于判定上月末余额是否达标
  --   b  = T-1日时点资产（DATA_DATE=V_DATA_DATE, BAL_TYPE='1'）—用于取T-1日各资产余额
  ------------------------------------------------------------------
  -- F-05: 客户等级达标阈值查找表（消除6处CASE WHEN重复）
  INSERT INTO TMP_ADS_LOST_THRESH (LVL_CODE, THRESHOLD)
  SELECT '04', 50000 FROM DUAL UNION ALL                       -- 优质/财富1/财富2：5万
  SELECT '05', 50000 FROM DUAL UNION ALL
  SELECT '06', 50000 FROM DUAL UNION ALL
  SELECT '07', 300000 FROM DUAL UNION ALL                      -- 贵宾：30万
  SELECT '08', 500000 FROM DUAL UNION ALL                      -- 私行1：50万
  SELECT '09', 1000000 FROM DUAL UNION ALL                     -- 私行2：100万
  SELECT '10', 3000000 FROM DUAL;                              -- 私行3：300万
  COMMIT;

  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  -- F-05/F-06: 阈值通过TMP_ADS_LOST_THRESH查找；子查询过滤NULL LVL_CHURN
  INSERT INTO TMP_ADS_LOST_BASE (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      CUST_ID,                                                  -- 客户号
      CUST_NAME,                                                -- 客户姓名
      CUST_LVL,                                                 -- 当前客户等级
      LVL_CHURN,                                                -- 流失等级（1=轻度流失，2=重度流失）
      DEPO_CURNT_DEPO_BAL,                                      -- T-1日活期存款余额
      FIXD_DEPO_BAL,                                            -- T-1日定期存款余额
      FIN_AMT,                                                  -- T-1日理财余额
      CNTCT_STATE_M,                                            -- 月接触状态
      RESCUE_STATE,                                             -- 挽回状态
      CUR_AUM_BAL,                                              -- T-1日时点AUM
      LAST_MONTH_END_AUM_BAL,                                   -- 上月末时点AUM
      POST_ID,                                                  -- 管户经理岗位ID
      ORG_ID                                                    -- 归属机构ID
  )
  SELECT src.PERSN_LEGAL_BK_CODE,
         src.CUST_ID,
         src.CUST_NAME,
         src.CUST_LVL,
         src.LVL_CHURN,
         src.DEPO_CURNT_DEPO_BAL,
         src.FIXD_DEPO_BAL,
         src.FIN_AMT,
         src.CNTCT_STATE_M,
         src.RESCUE_STATE,
         src.CUR_AUM_BAL,
         src.LAST_MONTH_END_AUM_BAL,
         src.POST_ID,
         src.ORG_ID
    FROM (
         SELECT COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE) AS PERSN_LEGAL_BK_CODE,
                c.CUST_ID,
                c.CUST_NAME,
                cur_l.CUST_LVL,
                CASE                                                     -- 流失等级判定（F-05: 阈值来自TMP_ADS_LOST_THRESH）
                  -- 轻度流失(1)：上月月日均达标 AND 上月末时点不达标
                  WHEN p.AUM_BAL >= NVL(pt.THRESHOLD, 0)
                   AND NVL(e.AUM_BAL, 0) < NVL(pt.THRESHOLD, 0)
                  THEN '1'
                  -- 重度流失(2)：上上月月日均达标 AND 上月月日均不达标 AND 上月末时点不达标
                  WHEN pp.AUM_BAL >= NVL(ppt.THRESHOLD, 0)
                   AND NVL(p.AUM_BAL, 0) < NVL(ppt.THRESHOLD, 0)
                   AND NVL(e.AUM_BAL, 0) < NVL(ppt.THRESHOLD, 0)
                  THEN '2'
                END AS LVL_CHURN,
                NVL(b.DEPO_CURNT_DEPO_BAL, 0) AS DEPO_CURNT_DEPO_BAL,
                NVL(b.FIXD_DEPO_BAL, 0) AS FIXD_DEPO_BAL,
                NVL(b.FIN_BAL, 0) AS FIN_AMT,
                CASE                                                     -- 月接触（F-01: 补PERSN_LEGAL_BK_CODE+MKT_PERSN）
                  WHEN EXISTS (
                    SELECT 1
                      FROM ADS_MKT_REC_INFO r
                     WHERE r.CUST_ID = c.CUST_ID
                       AND r.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE  -- 双键关联
                       AND r.MKT_PERSN = m.MNGR_POST_ID                    -- 仅统计本管户经理的接触
                       AND r.MKT_TYP IN ('1', '2', '3', '4')
                       AND r.MKT_TIME IS NOT NULL
                       AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                           BETWEEN V_CURR_MONTH_BEGIN_DT AND V_RUN_DATE_DT  -- F-03: 使用V_RUN_DATE_DT
                  ) THEN '1'
                  ELSE '0'
                END AS CNTCT_STATE_M,
                CASE                                                     -- 挽回状态（F-05: 阈值来自TMP_ADS_LOST_THRESH）
                  WHEN NVL(b.AUM_BAL, 0) >= NVL(COALESCE(pt.THRESHOLD, ppt.THRESHOLD), 0)
                  THEN '1'
                  ELSE '0'
                END AS RESCUE_STATE,
                NVL(b.AUM_BAL, 0) AS CUR_AUM_BAL,
                NVL(e.AUM_BAL, 0) AS LAST_MONTH_END_AUM_BAL,
                m.MNGR_POST_ID AS POST_ID,                               -- F-02: 改用DWD_CUST_MAN的理财管户经理
                COALESCE(p.ORG_ID, pp.ORG_ID) AS ORG_ID
           FROM (
                 -- p：上月月日均AUM + 上月客户等级
                 SELECT a.CUST_ID, a.ORG_ID, a.PERSN_LEGAL_BK_CODE, a.AUM_BAL, l.CUST_LVL LVL
                   FROM DWS_CUST_ASSE_LIAB a
                   JOIN DWS_CUST_LVL_INFO l
                     ON l.CUST_ID = a.CUST_ID
                    AND l.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
                    AND l.DATA_DATE = a.DATA_DATE
                  WHERE a.DATA_DATE = V_PREV_MONTH_END
                    AND a.BAL_TYPE = '2'
                ) p
           LEFT JOIN TMP_ADS_LOST_THRESH pt ON pt.LVL_CODE = p.LVL      -- F-05: p对应达标阈值
           FULL JOIN (                                                  -- FULL JOIN确保上月无但上上月有的客户
                 -- pp：上上月月日均AUM + 上上月客户等级
                 SELECT a.CUST_ID, a.ORG_ID, a.PERSN_LEGAL_BK_CODE, a.AUM_BAL, l.CUST_LVL LVL
                   FROM DWS_CUST_ASSE_LIAB a
                   JOIN DWS_CUST_LVL_INFO l
                     ON l.CUST_ID = a.CUST_ID
                    AND l.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
                    AND l.DATA_DATE = a.DATA_DATE
                  WHERE a.DATA_DATE = V_PREV_PREV_MONTH_END
                    AND a.BAL_TYPE = '2'
                ) pp
             ON pp.CUST_ID = p.CUST_ID
            AND pp.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE
           LEFT JOIN TMP_ADS_LOST_THRESH ppt ON ppt.LVL_CODE = pp.LVL   -- F-05: pp对应达标阈值
           JOIN DWD_CUST_INDV_INFO c                                    -- c：客户基本信息
             ON c.CUST_ID = COALESCE(p.CUST_ID, pp.CUST_ID)
            AND c.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
           LEFT JOIN DWD_CUST_MAN m                                     -- m：理财管户（F-02: POST_ID来源）
             ON m.CUST_ID = c.CUST_ID
            AND m.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
            AND m.MNG_TYP = '1'
           LEFT JOIN DWS_CUST_LVL_INFO cur_l                            -- cur_l：当前客户等级
             ON cur_l.CUST_ID = c.CUST_ID
            AND cur_l.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE
            AND cur_l.DATA_DATE = V_DATA_DATE
           LEFT JOIN DWS_CUST_ASSE_LIAB e                               -- e：上月末时点AUM
             ON e.CUST_ID = c.CUST_ID
            AND e.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
            AND e.DATA_DATE = V_PREV_MONTH_END
            AND e.BAL_TYPE = '1'
           LEFT JOIN DWS_CUST_ASSE_LIAB b                               -- b：T-1日时点资产
             ON b.CUST_ID = c.CUST_ID
            AND b.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
            AND b.DATA_DATE = V_DATA_DATE
            AND b.BAL_TYPE = '1'
         ) src
   WHERE src.LVL_CHURN IS NOT NULL;                                     -- F-06: 子查询过滤NULL（消除DELETE）

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：生成轻度和重度流失客户基础数据';
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
  --
  -- 接触窗口：当月初至跑批日
  -- RESCUED_FINA_ASSET = MAX(T-1日时点AUM - 上月末时点AUM, 0)
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_LOST_DTL (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      DATA_DATE,                                                -- 数据日期（YYYYMMDD，=V_DATA_DATE）
      CUST_ID,                                                  -- 客户号
      CUST_NAME,                                                -- 客户姓名
      CUST_LVL,                                                 -- 当前客户等级
      LVL_CHURN,                                                -- 流失等级（1=轻度，2=重度）
      DEPO_CURNT_DEPO_BAL,                                      -- T-1日活期存款余额
      FIXD_DEPO_BAL,                                            -- T-1日定期存款余额
      FIN_AMT,                                                  -- T-1日理财余额
      CNTCT_STATE,                                              -- 月接触状态（1=有接触，0=无）
      RESCUE_STATE,                                             -- 挽回状态（1=已挽回，0=未挽回）
      RESCUED_FINA_ASSET,                                       -- 已挽回金融资产（T-1日AUM-上月末AUM，最小为0）
      POST_ID,                                                  -- 管户经理岗位ID
      ORG_ID,                                                   -- 归属机构ID
      STATIS_CYCLE                                              -- 统计周期（M=月度）
  )
  SELECT x.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         V_DATA_DATE,                                           -- 数据日期=跑批日期
         x.CUST_ID,                                             -- 客户号
         x.CUST_NAME,                                           -- 客户姓名
         x.CUST_LVL,                                            -- 当前客户等级
         x.LVL_CHURN,                                            -- 流失等级
         x.DEPO_CURNT_DEPO_BAL,                                  -- T-1日活期存款余额
         x.FIXD_DEPO_BAL,                                       -- T-1日定期存款余额
         x.FIN_AMT,                                             -- T-1日理财余额
         x.CNTCT_STATE_M,                                       -- 月接触状态（来自临时表）
         x.RESCUE_STATE,                                         -- 挽回状态
         CASE WHEN x.RESCUE_STATE = '1'                          -- 已挽回金融资产：已挽回客户才计算
              THEN GREATEST(NVL(x.CUR_AUM_BAL, 0) - NVL(x.LAST_MONTH_END_AUM_BAL, 0), 0)  -- MAX(T-1余额-上月末余额, 0)
              ELSE 0                                            -- 未挽回=0
         END,
         x.POST_ID,                                             -- 管户经理岗位ID
         x.ORG_ID,                                              -- 归属机构ID
         'M'                                                    -- 统计周期：月度
    FROM TMP_ADS_LOST_BASE x;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：写入客户流失清单';
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
  -- 发生异常时回滚本过程事务并记录失败日志。
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
