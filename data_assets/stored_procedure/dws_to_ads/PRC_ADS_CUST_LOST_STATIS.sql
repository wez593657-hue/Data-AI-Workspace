CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_LOST_STATIS(
    V_SYSDAT IN VARCHAR,                                          -- 跑批日期（YYYYMMDD）
    OUTCDE   OUT INTEGER                                         -- 输出返回码（0=成功，-1=异常）
)
AS
  ------------------------------------------------------------------
  -- 存储过程：客户挽回统计处理
  -- 处理周期: 日
  -- 过程描述: 按机构向上汇总和客户经理维度生成客户挽回统计（月度统计周期）
  -- 来源表: ADS_CUST_LOST_DTL, DWS_CUST_ASSE_LIAB, DWD_SYS_ORG
  -- 目标表: ADS_CUST_LOST_STATIS
  -- 适配数据库: Kingbase Oracle 兼容模式
  -- 需求版本: v2.4.2
  -- 关联需求: REQ-CUST-001
  -- 变更记录:
  --   v2.1.0: 1.已挽回金融资产口径确认
  --           2.统计表使用明细表RESCUED_FINA_ASSET字段汇总已挽回金融资产
  --   v2.3.0 2026-07-28 年码值N→Y统一；配合DTL月/季/年切片接触状态按不同时间窗口独立计算
  --   v2.4.1 2026-07-30 去掉季/年统计周期切片仅保留月度；简化TMP1/TMP2清理逻辑；
  --            统计周期统一为月度；全字段补充注释
  --   v2.4.2 2026-08-04 F-07:删除V_END_DATE无效初始化赋值
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '客户挽回统计处理';                     -- 过程描述
  V_PRC_NAME             VARCHAR(64)  := 'PRC_ADS_CUST_LOST_STATIS';          -- 过程名称
  V_LOG_MSG              VARCHAR(4000);                                        -- 日志消息文本
  V_LOG_FLG              INTEGER;                                              -- 日志标志（0=成功）
  V_LOG_BUTTON           INTEGER := 1;                                         -- 日志记录开关（1=启用）
  V_NO_ID                VARCHAR(10);                                          -- 当前步骤序号
  V_BGN_DATE             DATE;                                                 -- 步骤开始时间
  V_END_DATE             DATE;                                                 -- 步骤结束时间
  V_DURA_DATE            INTEGER;                                              -- 步骤耗时（秒）
  V_DATA_DATE            VARCHAR2(8);                                          -- 跑批日期（=V_SYSDAT）
  V_HISTORY_CUTOFF_DATE  VARCHAR2(8);                                          -- 三年历史清理边界（参数19）

  PROCEDURE TRUNC_TMP(P_TABLE_NAME VARCHAR2) IS                                 -- 清空物理临时表
  BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || P_TABLE_NAME;
  END;

BEGIN
  ------------------------------------------------------------------
  -- 1. 参数检查：校验跑批日期格式
  ------------------------------------------------------------------
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');
  END IF;
  V_DATA_DATE := V_SYSDAT;                                                  -- 跑批日期
  V_HISTORY_CUTOFF_DATE := sys_fun_deal_date(V_SYSDAT, 19);                 -- 三年历史清理边界（参数19）

  ------------------------------------------------------------------
  -- 2. TMP1：清理当前数据日统计结果、三年历史数据和物理临时表，保证可重跑
  ------------------------------------------------------------------
  V_NO_ID := 'TMP1';
  V_BGN_DATE := SYSDATE;

  DELETE FROM ADS_CUST_LOST_STATIS T                                       -- 清理当天数据（支持重跑）
   WHERE T.DATA_DATE = V_DATA_DATE;

  DELETE FROM ADS_CUST_LOST_STATIS T                                       -- 清理超过三年的历史数据
   WHERE T.DATA_DATE < V_HISTORY_CUTOFF_DATE;

  TRUNC_TMP('TMP_ADS_LOST_STAT_SRC');                                       -- 清空物理临时表
  COMMIT;

  V_END_DATE := SYSDATE;
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
  -- 3. TMP2：展开机构和客户经理统计对象
  --
  -- 将明细按机构层级向上展开为祖先机构统计口径，同时保存管户经理维度。
  -- 表别名说明：
  --   D = 流失挽回明细（ADS_CUST_LOST_DTL）
  --   X = 机构树（DWD_SYS_ORG）
  --   O = 机构层级展开结果（叶子机构→祖先机构）
  ------------------------------------------------------------------
  V_NO_ID := 'TMP2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_ADS_LOST_STAT_SRC (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      DATA_DATE,                                                -- 数据日期（YYYYMMDD）
      STATIS_CYCLE,                                             -- 统计周期（M=月度）
      STATIS_OBJ,                                               -- 统计对象（机构ID或管户经理岗位ID）
      LVL_CHURN,                                                -- 流失等级（1=轻度，2=重度）
      CNTCT_STATE,                                              -- 接触状态（1=有接触，0=无）
      RESCUE_STATE,                                             -- 挽回状态（1=已挽回，0=未挽回）
      RESCUED_FINA_ASSET                                        -- 已挽回金融资产金额
  )
  -- 机构分支：将客户所属叶子机构向上展开至各级祖先机构，形成机构统计口径。
  SELECT D.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         D.DATA_DATE,                                           -- 数据日期
         D.STATIS_CYCLE,                                        -- 统计周期
         O.ANCESTOR_ORG_ID,                                     -- 祖先机构ID（作为统计对象）
         D.LVL_CHURN,                                           -- 流失等级
         D.CNTCT_STATE,                                          -- 接触状态（直接取自明细表）
         D.RESCUE_STATE,                                         -- 挽回状态（直接取自明细表）
         D.RESCUED_FINA_ASSET                                    -- 已挽回金融资产
    FROM ADS_CUST_LOST_DTL D                                    -- D：流失挽回客户明细
    JOIN (
          SELECT DISTINCT
                 CONNECT_BY_ROOT X.ORG_ID AS LEAF_ORG_ID,       -- 叶子机构ID（起点）
                 X.ORG_ID AS ANCESTOR_ORG_ID                    -- 祖先机构ID（向上展开的所有祖先）
            FROM DWD_SYS_ORG X                                  -- X：机构树表
           START WITH X.ORG_ID IN (
                 SELECT DISTINCT ORG_ID
                   FROM ADS_CUST_LOST_DTL
                  WHERE ORG_ID IS NOT NULL                      -- 以明细中出现的机构为起点
                )
         CONNECT BY NOCYCLE PRIOR X.SUP_ORG_ID = X.ORG_ID       -- 沿上级机构向上递归
    ) O                                                        -- O：机构层级展开结果
      ON O.LEAF_ORG_ID = D.ORG_ID                               -- 明细的叶子机构匹配展开起点的叶子机构
   WHERE D.DATA_DATE = V_DATA_DATE                              -- 仅统计当天跑批产生的明细

  UNION ALL

  -- 客户经理分支：按管户经理岗位ID直接分组统计。
  SELECT D.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         D.DATA_DATE,                                           -- 数据日期
         D.STATIS_CYCLE,                                        -- 统计周期
         D.POST_ID,                                             -- 管户经理岗位ID（作为统计对象）
         D.LVL_CHURN,                                           -- 流失等级
         D.CNTCT_STATE,                                          -- 接触状态
         D.RESCUE_STATE,                                         -- 挽回状态
         D.RESCUED_FINA_ASSET                                    -- 已挽回金融资产
    FROM ADS_CUST_LOST_DTL D
   WHERE D.POST_ID IS NOT NULL                                  -- 仅统计有管户经理的客户
     AND D.DATA_DATE = V_DATA_DATE;                             -- 仅统计当天跑批产生的明细

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := 'TMP2 完成：展开机构和客户经理统计对象';
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
  -- 4. 目标表写入：按统计对象和流失等级汇总客户数、接触数、挽回数及比例
  ------------------------------------------------------------------
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO ADS_CUST_LOST_STATIS (
      PERSN_LEGAL_BK_CODE,                                      -- 法人行号
      DATA_DATE,                                                -- 数据日期（YYYYMMDD）
      STATIS_OBJ,                                               -- 统计对象（机构ID或管户经理岗位ID）
      STATIS_CYCLE,                                             -- 统计周期（M=月度）
      LVL_CHURN,                                                -- 流失等级（1=轻度，2=重度）
      CUST_CNT,                                                 -- 总客户数
      CNTCT_CUST_CNT,                                           -- 已接触客户数
      CNTCT_RATE,                                               -- 接触率（%，保留2位小数）
      RESCUED_CUST_CNT,                                         -- 已挽回客户数
      RESCUE_RATE,                                              -- 挽回率（%，保留2位小数）
      RESCUED_FINA_ASSET                                        -- 已挽回金融资产总额
  )
  SELECT S.PERSN_LEGAL_BK_CODE,                                 -- 法人行号
         S.DATA_DATE,                                           -- 数据日期
         S.STATIS_OBJ,                                           -- 统计对象
         S.STATIS_CYCLE,                                        -- 统计周期
         S.LVL_CHURN,                                           -- 流失等级
         COUNT(*),                                              -- 总客户数：每个展开记录算1个统计单位
         SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END),  -- 已接触客户数
         CASE WHEN COUNT(*) = 0 THEN 0                          -- 接触率=接触数/总数×100
              ELSE ROUND(SUM(CASE WHEN S.CNTCT_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
         END,
         SUM(CASE WHEN S.RESCUE_STATE = '1' THEN 1 ELSE 0 END), -- 已挽回客户数
         CASE WHEN COUNT(*) = 0 THEN 0                          -- 挽回率=挽回数/总数×100
              ELSE ROUND(SUM(CASE WHEN S.RESCUE_STATE = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
         END,
         SUM(S.RESCUED_FINA_ASSET)                              -- 已挽回金融资产总额：SUM各客户RESCUED_FINA_ASSET
    FROM TMP_ADS_LOST_STAT_SRC S                                 -- S：统计源数据（已按机构/客户经理展开）
   GROUP BY S.PERSN_LEGAL_BK_CODE,                               -- 按法人行号
            S.DATA_DATE,                                         -- 按数据日期
            S.STATIS_OBJ,                                         -- 按统计对象
            S.STATIS_CYCLE,                                      -- 按统计周期
            S.LVL_CHURN;                                          -- 按流失等级

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成：按统计对象和流失等级汇总写入统计';
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
