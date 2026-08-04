CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_NEW_CUST_STATIS(
    ------------------------------------------------------------------
    -- 输入参数
    ------------------------------------------------------------------
    -- V_SYSDAT: 跑批日期，格式YYYYMMDD（如'20260730'），必填，不为空
    V_SYSDAT IN VARCHAR,
    ------------------------------------------------------------------
    -- 输出参数
    ------------------------------------------------------------------
    -- OUTCDE: 执行结果码，0=成功，-1=异常
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程名称: PRC_ADS_CUST_NEW_CUST_STATIS
  -- 中文名称: 新客经营统计处理
  -- 处理周期: 日
  -- 过程描述: 从新客经营明细表按机构向上汇总和客户经理维度
  --           生成新客经营统计数据，包含新客数、接触率、KYC完成率、
  --           金融资产区间分布等指标
  -- 来源表: ADS_CUST_NEW_CUST_DTL(新客经营明细),
  --         DWS_CUST_ASSE_LIAB(客户资产负债_获取T-1日AUM),
  --         DWD_SYS_ORG(机构层级_递归向上汇总)
  -- 目标表: ADS_CUST_NEW_CUST_STATIS(新客经营统计表)
  -- 临时表: TMP_ADS_NEW_CUST_STAT_SRC(物理临时表，存储展开后的统计源数据)
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.4.0
  -- 关联需求: REQ-CUST-007(新客定义), REQ-CUST-009(计算单位),
  --           REQ-CUST-010(去季年切片)
  -- 变更记录:
  --   v2.1.0(2026-07-22): 1.新客定义改为使用DWD_CUST_INDV_INFO的OPEN_DATE字段
  --                       2.新客周期边界值改为左闭右开（0~30、30~100、100~180）
  --   v2.2.0(2026-07-27): 计算单位调整为客户号+归属机构；统计上一日资产使用
  --                       sys_fun_deal_date(V_SYSDAT, 1)
  --   v2.3.0(2026-07-30): 1.统计周期去掉季(Q)/年(N)切片，仅保留月度(M)
  --                       2.移除PREV_QUARTER_END/PREV_YEAR_END变量
  --   v2.3.1(2026-07-30): 继承DTL的接触状态变更（无需独立修改统计逻辑）
  --   v2.3.2(2026-07-30): 修复关联计算缺少PERSN_LEGAL_BK_CODE问题，
  --                       DWS_CUST_ASSE_LIAB左关联强制联动法人行号
  --   v2.4.0(2026-08-04): F-04:DWS T-1日AUM预查询写入TMP共用(消除UNION ALL重复JOIN)；
  --                       F-05:非月末日不再重算上月末统计(消除冗余)；
  --                       F-07:删除V_END_DATE无效初始化
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  -- 局部变量声明
  ------------------------------------------------------------------
  -- V_PRC_DESC:     存储过程描述文字（用于日志记录）
  V_PRC_DESC             VARCHAR(100) := '新客经营统计处理';
  -- V_PRC_NAME:     存储过程名称（用于日志记录）
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_NEW_CUST_STATIS';
  -- V_LOG_MSG:      日志消息内容（最大4000字符）
  V_LOG_MSG              VARCHAR(4000);
  -- V_LOG_FLG:      日志标记（OUTCDE值，0=正常，-1=异常）
  V_LOG_FLG              INTEGER;
  -- V_LOG_BUTTON:    是否记录日志（1=记录，0=不记录），默认1
  V_LOG_BUTTON           INTEGER := 1;
  -- V_NO_ID:         当前步骤编号标识，用于日志定位（TMP1/TMP2/3）
  V_NO_ID                VARCHAR(10);
  -- V_BGN_DATE:      步骤开始时间（用于计算耗时）
  V_BGN_DATE             DATE;
  -- V_END_DATE:      步骤结束时间
  V_END_DATE             DATE;
  -- V_DURA_DATE:     步骤耗时（秒），(V_END_DATE - V_BGN_DATE) * 86400
  V_DURA_DATE            INTEGER;
  -- V_DATA_DATE:     数据日期，取V_SYSDAT值，格式YYYYMMDD
  V_DATA_DATE            VARCHAR2(8);
  -- V_PREV_DAY:       上一天日期（T-1），通过sys_fun_deal_date(V_SYSDAT, 1)计算，
  --                    用于获取T-1日的客户AUM余额快照
  V_PREV_DAY             VARCHAR2(8);
  -- V_PREV_MONTH_END: 上月末日期，用于关联上一月的明细数据和清理上一月统计结果
  V_PREV_MONTH_END       VARCHAR2(8);
  -- V_HISTORY_CUTOFF_DATE: 三年历史清理边界（参数19），用于清理过期历史数据
  V_HISTORY_CUTOFF_DATE   VARCHAR2(8);

  ------------------------------------------------------------------
  -- 内部辅助过程：清空指定物理临时表
  -- 参数 P_TABLE_NAME: 临时表名称
  ------------------------------------------------------------------
  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 步骤1: 参数检查
  -- 校验V_SYSDAT格式：必须为8位数字YYYYMMDD
  ------------------------------------------------------------------
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;

  -- 设置数据日期 = 跑批日期
  V_DATA_DATE := V_SYSDAT;
  -- 计算上一天日期（T-1），用于获取T-1日AUM余额
  V_PREV_DAY := sys_fun_deal_date(V_SYSDAT, 1);
  -- 计算上月末日期
  V_PREV_MONTH_END := sys_fun_deal_date(V_SYSDAT, 2);

  ------------------------------------------------------------------
  -- 步骤2_TMP1: 清理当前数据日统计结果和历史数据
  --   - 删除当天+上月末的统计结果（幂等重跑）
  --   - 删除三年前的历史过期数据
  --   - 清空物理临时表 TMP_ADS_NEW_CUST_STAT_SRC
  --   v2.3.0: 去掉季/年切片，删除条件从M/Q/N简化为M
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  -- 删除当天月度统计（支持重跑幂等）和上一月末统计（将被重新计算覆盖）
  DELETE FROM ADS_CUST_NEW_CUST_STATIS T
   WHERE T.DATA_DATE = V_DATA_DATE;                                       -- 当天统计（支持重跑幂等）

  -- 删除三年历史清理边界（参数19）之前的历史数据
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);
  DELETE FROM ADS_CUST_NEW_CUST_STATIS T
   WHERE T.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  -- 清空临时表
  TRUNC_TMP('TMP_ADS_NEW_CUST_STAT_SRC');
  TRUNC_TMP('TMP_ADS_NEW_CUST_AUM');                                     -- 清空T-1日AUM预查询表
  COMMIT;

  V_END_DATE := SYSDATE;
  -- 计算本步骤耗时（秒）
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP1 完成：清理当前数据日统计结果、三年前历史数据和物理临时表';
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
  -- 步骤3_TMP2: 展开机构和客户经理统计对象
  --   从明细表读取新客数据，按两个维度展开：
  --     维度1: 机构向上汇总 — 使用DWD_SYS_ORG递归CONNECT_BY_ROOT
  --             从网点级机构向上汇总到所有上级机构
  --     维度2: 客户经理维度 — 直接从明细表取POST_ID
  --   数据来源: ADS_CUST_NEW_CUST_DTL(新客明细) + DWS_CUST_ASSE_LIAB(T-1日AUM)
  --   v2.3.0: 去掉季/年切片，仅处理M(月度)统计周期数据
  ------------------------------------------------------------------
  -- F-04: T-1日AUM预查询（DWS只扫描一次，两个UNION ALL分支共用）
  INSERT INTO TMP_ADS_NEW_CUST_AUM (
      CUST_ID, PERSN_LEGAL_BK_CODE, ORG_ID, AUM_BAL
  )
  SELECT A.CUST_ID,
         A.PERSN_LEGAL_BK_CODE,
         A.ORG_ID,
         NVL(A.AUM_BAL, 0)
    FROM DWS_CUST_ASSE_LIAB A
   WHERE A.DATA_DATE = V_PREV_DAY
     AND A.BAL_TYPE = '1';
  COMMIT;

  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_NEW_CUST_STAT_SRC (
      PERSN_LEGAL_BK_CODE,       -- 法人行号
      DATA_DATE,                  -- 数据日期(YYYYMMDD)
      STATIS_CYCLE,               -- 统计周期(M=月度)
      STATIS_OBJ,                 -- 统计对象(机构编号或客户经理岗位编号)
      NEW_CUST_CYCLE,             -- 新客周期(1=0~30,2=30~100,3=100~180)
      CNTCT_STATE,                -- 接触状态(1=已接触,0=未接触)
      KYC_STATE,                  -- KYC完成状态(1=完整,0=不完整)
      PNT_AUM_BAL                 -- T-1日AUM余额（用于资产区间分段统计）
  )
  -- ============================
  -- 维度1: 机构向上汇总
  -- ============================
  SELECT D.PERSN_LEGAL_BK_CODE,                                               -- 法人行号
         D.DATA_DATE,                                                         -- 数据日期
         D.STATIS_CYCLE,                                                      -- 统计周期(M)
         O.ANCESTOR_ORG_ID,                                                   -- 统计对象=上级机构编号
         D.NEW_CUST_CYCLE,                                                    -- 新客周期
         D.CNTCT_STATE,                                                       -- 接触状态
         D.KYC_STATE,                                                         -- KYC状态
         NVL(P.AUM_BAL, 0)                                                    -- T-1日AUM余额（来自预查询表）
    FROM ADS_CUST_NEW_CUST_DTL D
    JOIN (
          SELECT DISTINCT
                 CONNECT_BY_ROOT X.ORG_ID AS LEAF_ORG_ID,
                 X.ORG_ID AS ANCESTOR_ORG_ID
            FROM DWD_SYS_ORG X
           START WITH X.ORG_ID IN (
                 SELECT DISTINCT ORG_ID
                   FROM ADS_CUST_NEW_CUST_DTL
                  WHERE ORG_ID IS NOT NULL
                )
         CONNECT BY NOCYCLE PRIOR X.SUP_ORG_ID = X.ORG_ID
    ) O
      ON O.LEAF_ORG_ID = D.ORG_ID
    LEFT JOIN TMP_ADS_NEW_CUST_AUM P                                          -- F-04: 预查询AUM表（替代DWS直接JOIN）
     ON P.CUST_ID = D.CUST_ID
     AND P.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE
     AND P.ORG_ID = D.ORG_ID
   WHERE D.DATA_DATE = V_DATA_DATE                                            -- F-05: 仅当日明细

  UNION ALL

  -- ============================
  -- 维度2: 客户经理维度
  -- ============================
  SELECT D.PERSN_LEGAL_BK_CODE,
         D.DATA_DATE,
         D.STATIS_CYCLE,
         D.POST_ID,                                                           -- 统计对象=客户经理岗位编号
         D.NEW_CUST_CYCLE,
         D.CNTCT_STATE,
         D.KYC_STATE,
         NVL(P.AUM_BAL, 0)                                                    -- T-1日AUM余额（来自预查询表）
    FROM ADS_CUST_NEW_CUST_DTL D
    LEFT JOIN TMP_ADS_NEW_CUST_AUM P                                          -- F-04: 预查询AUM表
     ON P.CUST_ID = D.CUST_ID
     AND P.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE
     AND P.ORG_ID = D.ORG_ID
   WHERE D.POST_ID IS NOT NULL
     AND D.DATA_DATE = V_DATA_DATE;                                           -- F-05: 仅当日明细

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：展开机构向上汇总和客户经理统计对象（仅M周期）';
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
  -- 步骤4: 目标表写入 — 按统计对象和新客周期汇总
  --   汇总维度: PERSN_LEGAL_BK_CODE + DATA_DATE + STATIS_OBJ + STATIS_CYCLE + NEW_CUST_CYCLE
  --   统计指标:
  --     NEW_CUST_CNT:          新客总数(COUNT)
  --     CNTCT_CUST_CNT:        已接触客户数(CNTCT_STATE='1')
  --     ASSET_BAL_SEG1~5:      金融资产五段区间客户数
  --     CNTCT_RATE:            接触率(已接触/总数 ×100%)
  --     KYC_CUST_CNT:          KYC完整客户数(KYC_STATE='1')
  --     COMP_RATE:             KYC完成率(KYC完整/总数 ×100%)
  --   新客周期: 通过CROSS JOIN生成全部(4)汇总行 + 各周期(1/2/3)明细行
  --
  --   金融资产区间分段（基于T-1日AUM余额PNT_AUM_BAL）:
  --     段1(0~5万):        PNT_AUM_BAL < 50,000
  --     段2(5~30万):       50,000 ≤ PNT_AUM_BAL < 300,000
  --     段3(30~100万):     300,000 ≤ PNT_AUM_BAL < 1,000,000
  --     段4(100~300万):    1,000,000 ≤ PNT_AUM_BAL < 3,000,000
  --     段5(300万及以上):   PNT_AUM_BAL ≥ 3,000,000
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_NEW_CUST_STATIS (
      PERSN_LEGAL_BK_CODE,       -- 法人行号
      DATA_DATE,                  -- 数据日期
      STATIS_OBJ,                 -- 统计对象(机构编号/客户经理编号)
      STATIS_CYCLE,               -- 统计周期(M=月度)
      NEW_CUST_CYCLE,             -- 新客周期(1/2/3/4=全部)
      NEW_CUST_CNT,               -- 新客总数
      CNTCT_CUST_CNT,             -- 已接触客户数
      ASSET_BAL_SEG1_CUST_CNT,    -- 资产段1(0~5万)客户数
      ASSET_BAL_SEG2_CUST_CNT,    -- 资产段2(5~30万)客户数
      ASSET_BAL_SEG3_CUST_CNT,    -- 资产段3(30~100万)客户数
      ASSET_BAL_SEG4_CUST_CNT,    -- 资产段4(100~300万)客户数
      ASSET_BAL_SEG5_CUST_CNT,    -- 资产段5(300万及以上)客户数
      CNTCT_RATE,                 -- 接触率(%)=已接触客户数/新客总数×100
      KYC_CUST_CNT,               -- KYC完整客户数
      COMP_RATE                   -- KYC完成率(%)=KYC完整客户数/新客总数×100
  )
  SELECT S.PERSN_LEGAL_BK_CODE,                                               -- 法人行号
         S.DATA_DATE,                                                         -- 数据日期
         S.STATIS_OBJ,                                                        -- 统计对象
         S.STATIS_CYCLE,                                                      -- 统计周期(M)
         C.NEW_CUST_CYCLE,                                                    -- 新客周期(含全部=4)
         COUNT(*) AS NEW_CUST_CNT,                                            -- 新客总数=该分组下的客户记录数
         SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END) AS CNTCT_CUST_CNT,  -- 已接触客户数
         SUM(CASE WHEN S.PNT_AUM_BAL < 50000 THEN 1 ELSE 0 END) AS ASSET_BAL_SEG1_CUST_CNT,   -- 资产段1: 0~5万
         SUM(CASE WHEN S.PNT_AUM_BAL >= 50000 AND S.PNT_AUM_BAL < 300000 THEN 1 ELSE 0 END) AS ASSET_BAL_SEG2_CUST_CNT, -- 资产段2: 5~30万
         SUM(CASE WHEN S.PNT_AUM_BAL >= 300000 AND S.PNT_AUM_BAL < 1000000 THEN 1 ELSE 0 END) AS ASSET_BAL_SEG3_CUST_CNT, -- 资产段3: 30~100万
         SUM(CASE WHEN S.PNT_AUM_BAL >= 1000000 AND S.PNT_AUM_BAL < 3000000 THEN 1 ELSE 0 END) AS ASSET_BAL_SEG4_CUST_CNT, -- 资产段4: 100~300万
         SUM(CASE WHEN S.PNT_AUM_BAL >= 3000000 THEN 1 ELSE 0 END) AS ASSET_BAL_SEG5_CUST_CNT, -- 资产段5: 300万及以上
         -- 接触率: 防止除以零，当总数为0时返回0
         CASE WHEN COUNT(*) = 0 THEN 0 ELSE ROUND(SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) END AS CNTCT_RATE,
         SUM(CASE WHEN S.KYC_STATE = '1' THEN 1 ELSE 0 END) AS KYC_CUST_CNT,  -- KYC完整客户数
         -- KYC完成率: 防止除以零，当总数为0时返回0
         CASE WHEN COUNT(*) = 0 THEN 0 ELSE ROUND(SUM(CASE WHEN S.KYC_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) END AS COMP_RATE
    FROM TMP_ADS_NEW_CUST_STAT_SRC S                                            -- 展开后的统计源数据
   CROSS JOIN (
         -- 生成新客周期维度: 1=0~30天, 2=30~100天, 3=100~180天
         SELECT NEW_CUST_CYCLE FROM TMP_ADS_NEW_CUST_STAT_SRC
         UNION
         -- 4=全部(汇总)
         SELECT '4' FROM DUAL
   ) C
   -- 对于全部(4): 包含所有周期客户; 对于具体周期: 仅包含该周期客户
   WHERE C.NEW_CUST_CYCLE = '4' OR S.NEW_CUST_CYCLE = C.NEW_CUST_CYCLE
   GROUP BY S.PERSN_LEGAL_BK_CODE,                                             -- 按法人行号分组
            S.DATA_DATE,                                                       -- 按数据日期分组
            S.STATIS_OBJ,                                                      -- 按统计对象分组
            S.STATIS_CYCLE,                                                    -- 按统计周期分组
            C.NEW_CUST_CYCLE;                                                  -- 按新客周期分组

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：按机构/客户经理和新客周期汇总写入统计';
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
