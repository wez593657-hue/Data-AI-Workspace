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
  -- 需求版本: v2.4.1
  -- 关联需求: REQ-CUST-001
  -- 变更记录:
  --   v2.1.0: 1.已挽回金融资产口径确认：T-1日金融资产余额达标的客户，从月初~T-1日金融资产新增总金额
  --           2.明细表新增RESCUED_FINA_ASSET字段
  --   v2.3.0 2026-07-28 月/季/年切片接触状态按不同时间窗口独立计算
  --   v2.4.1 2026-07-30 去掉季/年统计周期切片仅保留月度；T-1日统一为V_SYSDAT(与潜力提升一致)；
  --            删除第5段历史客群持续经营；全字段补充注释
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
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_LOST_BASE (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      CUST_ID,                                                  -- 客户号
      CUST_NAME,                                                -- 客户姓名
      CUST_LVL,                                                 -- 当前客户等级（来源cur_l.CUST_LVL）
      LVL_CHURN,                                                -- 流失等级（1=轻度流失，2=重度流失）
      DEPO_CURNT_DEPO_BAL,                                      -- T-1日活期存款余额（来源b.DEPO_CURNT_DEPO_BAL）
      FIXD_DEPO_BAL,                                            -- T-1日定期存款余额（来源b.FIXD_DEPO_BAL）
      FIN_AMT,                                                  -- T-1日理财余额（来源b.FIN_BAL）
      CNTCT_STATE_M,                                            -- 月接触状态（1=当月初至跑批日有营销接触，0=无）
      RESCUE_STATE,                                             -- 挽回状态（1=T-1日时点AUM达标，0=未达标）
      CUR_AUM_BAL,                                              -- T-1日时点AUM（来源b.AUM_BAL，用于RESCUED_FINA_ASSET计算）
      LAST_MONTH_END_AUM_BAL,                                    -- 上月末时点AUM（来源e.AUM_BAL，用于RESCUED_FINA_ASSET计算）
      POST_ID,                                                  -- 管户经理岗位ID（来源DWD_CUST_INDV_INFO.HOST_CUST_MNGR_POST_ID）
      ORG_ID                                                    -- 归属机构ID（优先取p.ORG_ID，其次pp.ORG_ID）
  )
  SELECT COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE), -- 法人行号（优先上月，其次上上月）
         c.CUST_ID,                                               -- 客户号
         c.CUST_NAME,                                             -- 客户姓名（来源DWD_CUST_INDV_INFO）
         cur_l.CUST_LVL,                                          -- 当前客户等级（跑批日最新等级）
         CASE                                                     -- 流失等级判定
           -- 轻度流失(1)：上月月日均达标 AND 上月末时点不达标
           WHEN p.AUM_BAL >= CASE                                 -- 上月月日均达标阈值：按客户等级判定
                               WHEN p.LVL IN ('04', '05', '06') THEN 50000      -- 优质/财富1/财富2：5万
                               WHEN p.LVL = '07' THEN 300000                   -- 贵宾：30万
                               WHEN p.LVL = '08' THEN 500000                   -- 财富2（高等级）：50万
                               WHEN p.LVL = '09' THEN 1000000                  -- 私行1：100万
                               WHEN p.LVL = '10' THEN 3000000                  -- 私行2：300万
                             END
                AND NVL(e.AUM_BAL, 0) < CASE                     -- 上月末时点AUM不达标
                                           WHEN p.LVL IN ('04', '05', '06') THEN 50000
                                           WHEN p.LVL = '07' THEN 300000
                                           WHEN p.LVL = '08' THEN 500000
                                           WHEN p.LVL = '09' THEN 1000000
                                           WHEN p.LVL = '10' THEN 3000000
                                         END
           THEN '1'                                               -- 轻度流失
           -- 重度流失(2)：上上月月日均达标 AND 上月月日均不达标 AND 上月末时点不达标
           WHEN pp.AUM_BAL >= CASE                                -- 上上月月日均达标
                               WHEN pp.LVL IN ('04', '05', '06') THEN 50000
                               WHEN pp.LVL = '07' THEN 300000
                               WHEN pp.LVL = '08' THEN 500000
                               WHEN pp.LVL = '09' THEN 1000000
                               WHEN pp.LVL = '10' THEN 3000000
                             END
                AND NVL(p.AUM_BAL, 0) < CASE                     -- 上月月日均不达标
                                           WHEN pp.LVL IN ('04', '05', '06') THEN 50000
                                           WHEN pp.LVL = '07' THEN 300000
                                           WHEN pp.LVL = '08' THEN 500000
                                           WHEN pp.LVL = '09' THEN 1000000
                                           WHEN pp.LVL = '10' THEN 3000000
                                         END
                AND NVL(e.AUM_BAL, 0) < CASE                     -- 上月末时点AUM不达标
                                           WHEN pp.LVL IN ('04', '05', '06') THEN 50000
                                           WHEN pp.LVL = '07' THEN 300000
                                           WHEN pp.LVL = '08' THEN 500000
                                           WHEN pp.LVL = '09' THEN 1000000
                                           WHEN pp.LVL = '10' THEN 3000000
                                         END
           THEN '2'                                               -- 重度流失
         END,
         NVL(b.DEPO_CURNT_DEPO_BAL, 0),                           -- T-1日活期存款余额（BAL_TYPE='1'时点，若无则0）
         NVL(b.FIXD_DEPO_BAL, 0),                                 -- T-1日定期存款余额（BAL_TYPE='1'时点，若无则0）
         NVL(b.FIN_BAL, 0),                                       -- T-1日理财余额（BAL_TYPE='1'时点，若无则0）
         CASE                                                     -- 月接触：当月初至跑批日存在有效营销接触记录
           WHEN EXISTS (
             SELECT 1
               FROM ADS_MKT_REC_INFO r                             -- 营销接触记录表
              WHERE r.CUST_ID = c.CUST_ID
                AND r.MKT_TYP IN ('1', '2', '3', '4')             -- 营销接触类型（1=电话/2=短信/3=微信/4=上门）
                AND r.MKT_TIME IS NOT NULL                        -- 接触时间不为空
                AND TO_DATE(REPLACE(SUBSTR(r.MKT_TIME, 1, 10), '-', ''), 'YYYYMMDD')
                    BETWEEN V_CURR_MONTH_BEGIN_DT AND V_END_DATE   -- 接触时间在当月初至跑批日范围内
           ) THEN '1'                                             -- 有接触
           ELSE '0'                                               -- 无接触
         END,
         CASE                                                     -- 挽回状态：T-1日时点AUM达到客户等级对应阈值
           WHEN NVL(b.AUM_BAL, 0) >= CASE                         -- T-1日=T-1时点AUM（b.DATA_DATE=V_DATA_DATE, BAL_TYPE='1'）
                                        WHEN COALESCE(p.LVL, pp.LVL) IN ('04', '05', '06') THEN 50000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '07' THEN 300000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '08' THEN 500000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '09' THEN 1000000
                                        WHEN COALESCE(p.LVL, pp.LVL) = '10' THEN 3000000
                                      END
           THEN '1'                                               -- 已挽回
           ELSE '0'                                               -- 未挽回
         END,
         NVL(b.AUM_BAL, 0),                                       -- T-1日时点AUM（用于计算已挽回金融资产）
         NVL(e.AUM_BAL, 0),                                       -- 上月末时点AUM（用于计算已挽回金融资产）
         c.HOST_CUST_MNGR_POST_ID,                                 -- 管户经理岗位ID（取自DWD_CUST_INDV_INFO）
         COALESCE(p.ORG_ID, pp.ORG_ID)                            -- 归属机构ID（优先上月，其次上上月）
    FROM (
          -- p：上月月日均AUM + 上月客户等级，用于筛选轻度流失候选
          SELECT a.CUST_ID,
                 a.ORG_ID,
                 a.PERSN_LEGAL_BK_CODE,
                 a.AUM_BAL,                                        -- 上月月日均AUM
                 l.CUST_LVL LVL                                    -- 上月客户等级（与月日均同一日期）
            FROM DWS_CUST_ASSE_LIAB a
            JOIN DWS_CUST_LVL_INFO l
              ON l.CUST_ID = a.CUST_ID
             AND l.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
             AND l.DATA_DATE = a.DATA_DATE                           -- 等级取月日均同一天
           WHERE a.DATA_DATE = V_PREV_MONTH_END                    -- 上月末
             AND a.BAL_TYPE = '2'                                  -- 月日均余额类型
         ) p
    FULL JOIN (                                                    -- FULL JOIN确保上月无但上上月有的客户也能被识别
          -- pp：上上月月日均AUM + 上上月客户等级，用于筛选重度流失候选
          SELECT a.CUST_ID,
                 a.ORG_ID,
                 a.PERSN_LEGAL_BK_CODE,
                 a.AUM_BAL,                                        -- 上上月月日均AUM
                 l.CUST_LVL LVL                                    -- 上上月客户等级
            FROM DWS_CUST_ASSE_LIAB a
            JOIN DWS_CUST_LVL_INFO l
              ON l.CUST_ID = a.CUST_ID
             AND l.PERSN_LEGAL_BK_CODE = a.PERSN_LEGAL_BK_CODE
             AND l.DATA_DATE = a.DATA_DATE
           WHERE a.DATA_DATE = V_PREV_PREV_MONTH_END               -- 上上月末
             AND a.BAL_TYPE = '2'
         ) pp
      ON pp.CUST_ID = p.CUST_ID
     AND pp.PERSN_LEGAL_BK_CODE = p.PERSN_LEGAL_BK_CODE            -- 二键关联：客户号+法人行号
    JOIN DWD_CUST_INDV_INFO c                                      -- c：客户基本信息（姓名+管户经理）
      ON c.CUST_ID = COALESCE(p.CUST_ID, pp.CUST_ID)
     AND c.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
    LEFT JOIN DWD_CUST_MAN m                                                    -- v2.3.4: 信贷管户关系表
      ON m.CUST_ID = c.CUST_ID                                                  -- 关联客户号
     AND m.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE) -- v2.3.2: 强制联动法人行号
     AND m.MNG_TYP = '1'                                                        -- MNG_TYP='1'=理财管户,仅取理财管户经理
    LEFT JOIN DWS_CUST_LVL_INFO cur_l                              -- cur_l：当前客户等级（跑批日最新）
      ON cur_l.CUST_ID = c.CUST_ID
     AND cur_l.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE
     AND cur_l.DATA_DATE = V_DATA_DATE
    LEFT JOIN DWS_CUST_ASSE_LIAB e                                 -- e：上月末时点AUM（用于判定上月末余额达标）
     ON e.CUST_ID = c.CUST_ID
     AND e.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
     AND e.DATA_DATE = V_PREV_MONTH_END                            -- 上月末
     AND e.BAL_TYPE = '1'                                          -- 时点余额类型
    LEFT JOIN DWS_CUST_ASSE_LIAB b                                 -- b：T-1日时点资产（T-1=跑批日，BAL_TYPE='1'）
     ON b.CUST_ID = c.CUST_ID
     AND b.PERSN_LEGAL_BK_CODE = COALESCE(p.PERSN_LEGAL_BK_CODE, pp.PERSN_LEGAL_BK_CODE)
     AND b.DATA_DATE = V_DATA_DATE                                 -- T-1日=跑批日期
     AND b.BAL_TYPE = '1';                                         -- 时点余额类型

  DELETE FROM TMP_ADS_LOST_BASE                                    -- 删除未命中任何流失等级的记录
   WHERE LVL_CHURN IS NULL;

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
