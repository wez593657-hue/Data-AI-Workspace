------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_006
-- 功能说明: 指标数据统计——步骤6（多类指标汇总计算并写入专属汇总临时表 TMP_STAT_INDX_AGGR_006）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER     输出（结果行数/错误标志，异常为 -1）
------------------------------------------------------------------------
-- 需求版本: v5.1 (2026-08-26)
-- 变更记录:
--   v5.1 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v4.6 0071年龄边界修正：70岁以下改为AGE<70（原<=70）
--   v4.7 0064改标签表口径：基数表ADS_CRM_R_SALRY_PAYROL_BASE按活动/任务隔离取新增
--   v4.8 0065代销业务收入（暂不含贵金属）：理财FIN_AMT+保险INSUR_AMT合并，期间[开始日,跑批日]
--   v4.9 修复0071/0072未声明变量V_YEAR_BEGIN/V_180_DAY_BEGIN；补全代发薪客户净增INDX_0064汇总段(7.17/7.18)
--   v5.0 AGGR汇总表拆分：写入专属表TMP_STAT_INDX_AGGR_006并段首自清；基数表按活动结束日+3个自然月清理
------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_006    -- 创建存储过程
(                        -- 参数列表开始
    V_SYSDAT IN VARCHAR2,                                       -- 跑批业务日期（YYYYMMDD）
    OUTCDE   OUT INTEGER -- 输出结果标志（成功返回行数，异常为-1）
) AS                     -- 参数定义结束，过程体声明开始
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤66处理完成 6';           -- 过程描述文本
    V_PRC_NAME   VARCHAR2(32) := 'PRC_ADS_STAT_INDX_PLAN_006';  -- 过程名
    V_LOG_MSG    VARCHAR2(4000);                                -- 日志消息缓冲
    V_LOG_FLG    INTEGER;                                       -- 日志写入标志（0成功，-1失败）
    V_LOG_BUTTON INTEGER := 1;                                  -- 日志按钮标识
    V_NO_ID      VARCHAR2(10);                                  -- 步骤编号
    V_BGN_DATE   DATE;   -- 开始时间
    V_END_DATE   DATE;   -- 结束时间
    V_DURA_DATE  INTEGER;                                       -- 耗时（秒）
    V_YEAR_BEGIN    VARCHAR2(8) := SYS_FUN_DEAL_DATE(V_SYSDAT, 13);    -- 本年起始日（YYYYMMDD），用于 INDX_0071
    V_180_DAY_BEGIN VARCHAR2(8) := SYS_FUN_DEAL_DATE(V_SYSDAT, 27);    -- 近180天起始日（YYYYMMDD），用于 INDX_0072
BEGIN
    V_NO_ID    := '0';      -- 步骤编号
    V_BGN_DATE := SYSDATE;  -- 记录开始时间
    IF V_SYSDAT IS NULL     -- 跑批日期为空校验
       OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')         -- 非YYYYMMDD格式校验
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 参数非法抛错
    END IF;
    V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');  -- 跑批日期转日期型

    -------------------------------------------------------------------------
    -- 7.0.0 基数表生命周期清理（INDX_0064）
    -- 每日巡检：活动/任务结束日+3个自然月 <= 跑批日 → 删除该活动基数
    --   路径08: DWD_MKT_ACT_INFO.STATIS_STOP_DATE
    --   路径09: DWD_MKT_TSK_INDX_SUB.TSK_END_DATE（任务级一致）
    --   另：AGGR 段首自清，本过程专属汇总临时表，防止重跑/并行残留
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_AGGR_006;  -- AGGR 汇总临时表段首自清

    DELETE FROM ADS_CRM_R_SALRY_PAYROL_BASE T                       -- 代发薪客户基数表
     WHERE (T.PATH_CODE = '08'                                       -- 08=营销活动路径
            AND EXISTS (SELECT 1                                    -- 存在该活动基数记录则进入清理判定
                          FROM DWD_MKT_ACT_INFO A                   -- 营销活动信息表
                         WHERE A.MKT_ACT_ID = T.STATIS_DIM          -- 活动ID与统计维度匹配
                           AND ADD_MONTHS(TO_DATE(A.STATIS_STOP_DATE, 'YYYYMMDD'), 3)  -- 活动结束日+3个自然月
                               <= TO_DATE(V_SYSDAT, 'YYYYMMDD')))   -- 不晚于跑批日可清理
        OR (T.PATH_CODE = '09'                                       -- 09=目标任务路径
            AND EXISTS (SELECT 1                                    -- 存在该任务基数记录则进入清理判定
                          FROM DWD_MKT_TSK_INDX_SUB S               -- 任务指标明细表
                         WHERE S.TSK_ID = T.STATIS_DIM              -- 任务ID与统计维度匹配
                           AND ADD_MONTHS(TO_DATE(S.TSK_END_DATE, 'YYYYMMDD'), 3)  -- 任务结束日+3个自然月
                               <= TO_DATE(V_SYSDAT, 'YYYYMMDD')));  -- 不晚于跑批日可清理
    -------------------------------------------------------------------------
    -- 7.0 代发薪客户基数表刷新（INDX_0064）
    -- 每日跑批：范围内客户标签 IS_NOT_SALRY_PAYROL_BK='1' 入基数表
    --   新活动/任务首次出现：FRST_MARK_DATE='19000101'（活动前基数，不计新增）
    --   活动期间新增标记：FRST_MARK_DATE=跑批日
    -------------------------------------------------------------------------
    INSERT INTO ADS_CRM_R_SALRY_PAYROL_BASE                           -- 写入代发薪客户基数表
          (PATH_CODE, STATIS_DIM, PERSN_LEGAL_BK_CODE, CUST_ID, FRST_MARK_DATE)  -- 插入列：路径/统计维度/法人机构/客户ID/首次标记日期
          WITH SCOPE_BASE AS            -- 范围客户集合基础CTE
           (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                   S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                   TI.CUST_ID,          -- 客户ID
                   S.PERSN_LEGAL_BK_CODE                              -- 法人机构编码
              FROM TMP_STAT_INDX_SCOPE S                              -- 范围集合表(源)
             INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM   -- 活动ID关联
                  AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
                  AND TI.DATA_DATE = V_SYSDAT                         -- 跑批当日参与机构
                  AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR   -- 机构级归属匹配
                       (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))   -- 经理级归属匹配
             WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
               AND S.INDX_CODE = 'INDX_0064'                          -- 指标编码
             UNION ALL                  -- 合并路径08与路径09
            SELECT '09',                 -- 路径标识 B=目标任务
                   S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                   LV.CUST_ID,          -- 客户ID
                   S.PERSN_LEGAL_BK_CODE                              -- 法人机构编码
              FROM TMP_STAT_INDX_SCOPE S                              -- 范围集合表(源)
             INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'     -- 机构级客户层级
                  AND LV.ORG_ID = S.BLNG_ID                           -- 机构ID关联
                  AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
                  AND LV.DATA_DATE = V_SYSDAT                         -- 跑批当日
             WHERE S.PATH_CODE = '09'    -- 目标任务路径
               AND S.INDX_CODE = 'INDX_0064'                          -- 指标编码
             UNION ALL                  -- 合并路径08与路径09
            SELECT '09',                 -- 路径标识 B=目标任务
                   S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                   CM.CUST_ID,          -- 客户ID
                   S.PERSN_LEGAL_BK_CODE                              -- 法人机构编码
              FROM TMP_STAT_INDX_SCOPE S                              -- 范围集合表(源)
             INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'          -- 经理级客户经理关系
                  AND CM.MNGR_POST_ID = S.BLNG_ID                     -- 客户经理岗位ID关联
                  AND CM.MNG_TYP = '1'  -- 主管类型
                  AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
             WHERE S.PATH_CODE = '09'    -- 目标任务路径
               AND S.INDX_CODE = 'INDX_0064')                         -- 指标编码
          SELECT DISTINCT               -- 去重后的目标插入行
                 SB.PATH_CODE,          -- 路径标识
                 SB.STATIS_DIM,         -- 统计维度（活动/任务编号）
                 SB.PERSN_LEGAL_BK_CODE,                              -- 法人机构编码
                 SB.CUST_ID,            -- 客户ID
                 CASE                   -- 判断活动是首次出现(初始基数)还是期间新增
                     WHEN EXISTS (SELECT 1
                                    FROM ADS_CRM_R_SALRY_PAYROL_BASE EB  -- 基数表已有记录判定
                                   WHERE EB.PATH_CODE = SB.PATH_CODE   -- 同活动/任务路径已存在
                                     AND EB.STATIS_DIM = SB.STATIS_DIM) THEN  -- 同活动/任务已存在→期间新增分支
                         V_SYSDAT                                      -- 已存在→本次为活动期间新增，记跑批日
                     ELSE
                         '19000101'  -- 新活动→活动前基数，标记初始值
                 END AS FRST_MARK_DATE
            FROM SCOPE_BASE SB                                     -- 主表为范围客户基础集
           INNER JOIN ADS_CRM_R_CUST_LABLE L                       -- 关联客户标签表
               ON L.CUST_ID = SB.CUST_ID                           -- 客户ID对应
              AND L.PERSN_LEGAL_BK_CODE = SB.PERSN_LEGAL_BK_CODE   -- 法人机构一致
           WHERE L.IS_NOT_SALRY_PAYROL_BK = '1'                    -- 非代发薪客户标签
             AND NOT EXISTS (SELECT 1                              -- 基数表中不存在该客户才新增
                               FROM ADS_CRM_R_SALRY_PAYROL_BASE NB -- 基数表子查询
                              WHERE NB.PATH_CODE = SB.PATH_CODE    -- 同路径判定
                                AND NB.STATIS_DIM = SB.STATIS_DIM  -- 同统计维度判定
                                AND NB.CUST_ID = SB.CUST_ID        -- 同客户ID判定
                                AND NB.PERSN_LEGAL_BK_CODE = SB.PERSN_LEGAL_BK_CODE);  -- 基数表不存在则新增

    -------------------------------------------------------------------------
    -- 7.1/7.2 保险新保保费 INDX_0061 (合并 A/B)
    -- 范围客户保单（POLICY_STATE='1'）在[活动开始日,跑批日]内新保保费之和，SUM(NEW_INSUR_AMT)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                          -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                        -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                          -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                          -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                     -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0061'                      -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                          -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                          -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O' -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                       -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                     -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0061'                      -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                          -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                          -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'      -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                 -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 仅目标任务路径
             AND S.INDX_CODE = 'INDX_0061')                     -- 指标编码
        SELECT SM.PATH_CODE,          -- 路径标识
               V_SYSDAT,              -- 跑批业务日期
               SM.DATA_BLNG,          -- 数据归属
               SM.STATIS_DIM,         -- 统计维度（活动/任务编号）
               SM.STATIS_CALIB,       -- 统计口径名称
               'INDX_0061',           -- 指标编码
               SUM(NVL(I.NEW_INSUR_AMT, 0)),                    -- 保险新保保费合计
               0,                     -- 上期值（本期不统计）
               SM.PERSN_LEGAL_BK_CODE -- 法人机构编码
          FROM (SELECT DISTINCT PATH_CODE,                      -- 路径标识
                                STATIS_CALIB,                   -- 统计口径名称
                                STATIS_DIM,                     -- 统计维度（活动/任务编号）
                                DATA_BLNG,                      -- 数据归属
                                TERM_BEGIN_DATE,                -- 活动开始日期
                                CUST_ID,                        -- 客户ID
                                PERSN_LEGAL_BK_CODE             -- 法人机构编码
                  FROM SCOPE_ALL) SM  -- 去重后的范围集
         INNER JOIN DWD_ACCT_INSUR I ON I.CUST_ID = SM.CUST_ID  -- 客户保单关联
              AND I.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE-- 法人机构一致
              AND I.POLICY_STATE = '1'                          -- 保单有效状态
              AND I.TX_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT      -- 保单交易日落在[开始日,跑批日]
         GROUP BY SM.PATH_CODE,       -- 按路径分组
                  SM.DATA_BLNG,       -- 按数据归属分组
                  SM.STATIS_DIM,      -- 按统计维度分组
                  SM.STATIS_CALIB,    -- 按统计口径分组
                  SM.PERSN_LEGAL_BK_CODE;                       -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.3/7.4 手机银行活跃客户数 INDX_0067 (合并 A/B)
    -- 范围客户中手机银行活跃标签（IS_NOT_BK_PHONE_ACTV_CUST='1'）的去重客户数，COUNT(DISTINCT CUST_ID)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                           -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                         -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                      -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0067'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'  -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                        -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                      -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0067'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'       -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                  -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0067')                      -- 指标编码
        SELECT SM.PATH_CODE,          -- 路径标识
               V_SYSDAT,              -- 跑批业务日期
               SM.DATA_BLNG,          -- 数据归属
               SM.STATIS_DIM,         -- 统计维度（活动/任务编号）
               SM.STATIS_CALIB,       -- 统计口径名称
               'INDX_0067',           -- 指标编码
               COUNT(DISTINCT SM.CUST_ID),                       -- 手机银行活跃客户去重数
               0,                     -- 上期值（本期不统计）
               SM.PERSN_LEGAL_BK_CODE -- 法人机构编码
          FROM SCOPE_ALL SM           -- 全范围客户集为主表
         INNER JOIN ADS_CRM_R_CUST_LABLE L ON L.CUST_ID = SM.CUST_ID      -- 客户标签关联
              AND L.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE -- 法人机构一致
              AND L.IS_NOT_BK_PHONE_ACTV_CUST = '1'              -- 手机银行活跃客户标签
         GROUP BY SM.PATH_CODE,       -- 按路径分组
                  SM.DATA_BLNG,       -- 按数据归属分组
                  SM.STATIS_DIM,      -- 按统计维度分组
                  SM.STATIS_CALIB,    -- 按统计口径分组
                  SM.PERSN_LEGAL_BK_CODE;                        -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.5/7.6 收单价值商户数 INDX_0068 (合并 A/B)
    -- 范围商户经结算户关联的标签客户为收单价值商户（IS_NOT_BILL_RSV_VAL_MKNT='1'）的去重客户数
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                  -- 写入步骤6专属汇总临时表
        (PATH_CODE,                                     -- 路径标识
         DATA_DATE,                                     -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                                     -- 数据归属
         STATIS_DIM,                                    -- 统计维度(活动/任务编号)
         STATIS_CALIB,                                  -- 统计口径名称
         INDX_CODE,                                     -- 指标编码
         CURNT_VAL,                                     -- 本期统计值
         TERM_LAST_VAL,                                 -- 上期统计值
         PERSN_LEGAL_BK_CODE)                           -- 法人机构编码
        WITH SCOPE_ALL AS                               -- 全范围商户集合CTE
         (SELECT '08' AS PATH_CODE,                      -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                -- 统计口径名称
                 S.STATIS_DIM,                          -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,                           -- 数据归属
                 S.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
                 M.MCT_ID                               -- 商户ID（收单商户）
            FROM TMP_STAT_INDX_SCOPE S                  -- 范围集合表(源)
           INNER JOIN UEPP_PAY_MCT_INFO M ON ((S.BLNG_TYPE = 'O' AND M.ORG_ID = S.BLNG_ID) OR    -- 机构级归属匹配
                                              (S.BLNG_TYPE = 'M' AND M.JOB_ID = S.BLNG_ID))     -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'                      -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0068'              -- 指标编码
          UNION ALL                                     -- 合并A/路径09
          SELECT '09',                                   -- 路径标识 B=目标任务
                 '09',                                -- 统计口径名称
                 S.STATIS_DIM,                          -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,                           -- 数据归属
                 S.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
                 M.MCT_ID                               -- 商户ID（收单商户）
            FROM TMP_STAT_INDX_SCOPE S                  -- 范围集合表(源)
           INNER JOIN UEPP_PAY_MCT_INFO M ON ((S.BLNG_TYPE = 'O' AND M.ORG_ID = S.BLNG_ID) OR    -- 机构级归属匹配
                                              (S.BLNG_TYPE = 'M' AND M.JOB_ID = S.BLNG_ID))     -- 经理级归属匹配
           WHERE S.PATH_CODE = '09'                      -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0068'),            -- 指标编码
        VAL_MERCHANT AS                                 -- 收单价值商户集合CTE
         (SELECT DISTINCT SM.PATH_CODE,                 -- 路径标识
                          SM.STATIS_CALIB,              -- 统计口径名称
                          SM.STATIS_DIM,                -- 统计维度（活动/任务编号）
                          SM.DATA_BLNG,                 -- 数据归属
                          SM.PERSN_LEGAL_BK_CODE,       -- 法人机构编码
                          L.CUST_ID                     -- 收单价值商户客户ID
            FROM (SELECT DISTINCT PATH_CODE,            -- 去重范围集内层：路径
                                  STATIS_CALIB,         -- 统计口径
                                  STATIS_DIM,           -- 统计维度
                                  DATA_BLNG,            -- 数据归属
                                  PERSN_LEGAL_BK_CODE,  -- 法人机构编码
                                  MCT_ID                -- 商户ID
                    FROM SCOPE_ALL) SM                  -- 去重后的范围集
           INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.MCT_ID = SM.MCT_ID    -- 商户结算账户关联
                AND SA.CUST_NO IS NOT NULL              -- 结算账户已有客户号
           INNER JOIN ADS_CRM_R_CUST_LABLE L ON L.CUST_ID = SA.CUST_NO  -- 商户结算账户关联标签客户
                AND L.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE  -- 法人机构一致
                AND L.IS_NOT_BILL_RSV_VAL_MKNT = '1')   -- 收单价值商户标签
        SELECT PATH_CODE,                               -- 路径标识
               V_SYSDAT,                                -- 跑批业务日期
               DATA_BLNG,                               -- 数据归属
               STATIS_DIM,                              -- 统计维度（活动/任务编号）
               STATIS_CALIB,                            -- 统计口径名称
               'INDX_0068',                             -- 指标编码
               COUNT(DISTINCT CUST_ID),                 -- 收单价值商户去重数
               0,  -- 上期值（本期不统计）
               PERSN_LEGAL_BK_CODE                      -- 法人机构编码
          FROM VAL_MERCHANT                             -- 收单价值商户集为主表
         GROUP BY PATH_CODE,                            -- 按路径分组
                  DATA_BLNG,                            -- 按数据归属分组
                  STATIS_DIM,                           -- 按统计维度分组
                  STATIS_CALIB,                         -- 按统计口径分组
                  PERSN_LEGAL_BK_CODE;                  -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.7/7.8 一码付收款客户数 INDX_0076 (合并 A/B)
    -- 范围客户（个人/个体类商户、非注销）的一码付收款客户去重数，COUNT(DISTINCT CUST_ID)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                             -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                           -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                             -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                             -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                        -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0076'                         -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                             -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                             -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'    -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                          -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                        -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0076'                         -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                             -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                             -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'         -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                    -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0076'),                       -- 指标编码
        MERCHANT_CUSTOMER AS          -- 商户客户集合CTE
         (SELECT DISTINCT SC.PATH_CODE,                            -- 路径标识
                          SC.STATIS_CALIB,                         -- 统计口径名称
                          SC.STATIS_DIM,                           -- 统计维度（活动/任务编号）
                          SC.DATA_BLNG,                            -- 数据归属
                          SC.PERSN_LEGAL_BK_CODE,                  -- 法人机构编码
                          SA.CUST_NO AS CUST_ID                    -- 一码付收款客户号
            FROM (SELECT DISTINCT PATH_CODE,                       -- 去重范围集内层：路径
                                  STATIS_CALIB,                    -- 统计口径
                                  STATIS_DIM,                      -- 统计维度
                                  DATA_BLNG,                       -- 数据归属
                                  TERM_BEGIN_DATE,                 -- 活动开始日期
                                  CUST_ID,                         -- 客户ID
                                  PERSN_LEGAL_BK_CODE              -- 法人机构编码
                    FROM SCOPE_ALL) SC                             -- 去重后的范围集
           INNER JOIN DWD_CUST_INDV_INFO CI ON CI.CUST_ID = SC.CUST_ID       -- 个人客户信息关联
                AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE-- 法人机构一致
           INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.CUST_NO = SC.CUST_ID   -- 结算账户关联
                AND SA.STATUS <> '9'  -- 结算账户非注销
           INNER JOIN UEPP_PAY_MCT_INFO M ON M.MCT_ID = SA.MCT_ID  -- 商户信息关联
                AND M.MCT_TYPE IN ('personage', 'smallBusinesses') -- 个人/小型商户
                AND M.STATUS <> '9')  -- 商户状态非注销
        SELECT PATH_CODE,             -- 路径标识
               V_SYSDAT,              -- 跑批业务日期
               DATA_BLNG,             -- 数据归属
               STATIS_DIM,            -- 统计维度（活动/任务编号）
               STATIS_CALIB,          -- 统计口径名称
               'INDX_0076',           -- 指标编码
               COUNT(DISTINCT CUST_ID),                            -- 一码付收款客户去重数
               0,                     -- 上期值（本期不统计）
               PERSN_LEGAL_BK_CODE    -- 法人机构编码
          FROM MERCHANT_CUSTOMER      -- 商户客户集为主表
         GROUP BY PATH_CODE,          -- 按路径分组
                  DATA_BLNG,          -- 按数据归属分组
                  STATIS_DIM,         -- 按统计维度分组
                  STATIS_CALIB,       -- 按统计口径分组
                  PERSN_LEGAL_BK_CODE;                             -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.9/7.10 一码付新增客户数 INDX_0077 (合并 A/B)
    -- 一码付签约日期落在[活动开始日,跑批日]的商户客户去重数，COUNT(DISTINCT 满足期间条件客户)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                              -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                            -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                              -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                              -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                         -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0077'                          -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                              -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                              -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'     -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                           -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                         -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0077'                          -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                              -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                              -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'          -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                     -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0077'),                        -- 指标编码
        MERCHANT_CUSTOMER AS          -- 商户客户集合CTE
         (SELECT DISTINCT SC.PATH_CODE,                             -- 路径标识
                          SC.STATIS_CALIB,                          -- 统计口径名称
                          SC.STATIS_DIM,                            -- 统计维度（活动/任务编号）
                          SC.DATA_BLNG,                             -- 数据归属
                          SC.TERM_BEGIN_DATE,                       -- 活动开始日期
                          SC.PERSN_LEGAL_BK_CODE,                   -- 法人机构编码
                          SA.CUST_NO AS CUST_ID,                    -- 一码付客户号
                          M.SIGN_DATE -- 一码付签约日期
            FROM (SELECT DISTINCT PATH_CODE,                        -- 去重范围集内层：路径
                                  STATIS_CALIB,                     -- 统计口径
                                  STATIS_DIM,                       -- 统计维度
                                  DATA_BLNG,                        -- 数据归属
                                  TERM_BEGIN_DATE,                  -- 活动开始日期
                                  CUST_ID,                          -- 客户ID
                                  PERSN_LEGAL_BK_CODE               -- 法人机构编码
                    FROM SCOPE_ALL) SC                              -- 去重后的范围集
           INNER JOIN DWD_CUST_INDV_INFO CI ON CI.CUST_ID = SC.CUST_ID       -- 个人客户信息关联
                AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE -- 法人机构一致
           INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.CUST_NO = SC.CUST_ID   -- 结算账户关联
                AND SA.STATUS <> '9'  -- 结算账户非注销
           INNER JOIN UEPP_PAY_MCT_INFO M ON M.MCT_ID = SA.MCT_ID   -- 商户信息关联
                AND M.MCT_TYPE IN ('personage', 'smallBusinesses')  -- 个人/小型商户
                AND M.STATUS <> '9')  -- 商户状态非注销
        SELECT PATH_CODE,             -- 路径标识
               V_SYSDAT,              -- 跑批业务日期
               DATA_BLNG,             -- 数据归属
               STATIS_DIM,            -- 统计维度（活动/任务编号）
               STATIS_CALIB,          -- 统计口径名称
               'INDX_0077',           -- 指标编码
               COUNT(DISTINCT CASE    -- 期间内新签约客户去重统计
                   WHEN SIGN_DATE BETWEEN TERM_BEGIN_DATE AND V_SYSDAT THEN   -- 签约日落在[开始日,跑批日]
                       CUST_ID        -- 期间内新签约客户ID
                   END),              -- 期间内新签约一码付客户的去重数
               0,                     -- 上期值(本期不统计)
               PERSN_LEGAL_BK_CODE    -- 法人机构编码
          FROM MERCHANT_CUSTOMER      -- 商户客户集为主表
         GROUP BY PATH_CODE,          -- 按路径分组
                  DATA_BLNG,          -- 按数据归属分组
                  STATIS_DIM,         -- 按统计维度分组
                  STATIS_CALIB,       -- 按统计口径分组
                  PERSN_LEGAL_BK_CODE;                              -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.11/7.12 银行卡三方支付绑卡数 INDX_0070（A/B，活动期间）
    -- 绑卡交易（签约 >= 指定清算机构且 BIND_DATE 落在[开始日,跑批日]）去重客户数
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                           -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH BIND_CARD AS             -- 已绑卡集合CTE
         (SELECT SGN_ACCT_ID_DE AS CARD_NO,                      -- 绑卡卡号
                 MIN(TXN_DATE) AS BIND_DATE                      -- 首次绑卡日期
            FROM ECPP_E_TXN_SIGN      -- 签约交易表
           WHERE STATUS = '00'        -- 签约有效
             AND INSTG_ID IN ('Z2004944000010', 'Z2007933000010', 'Z2009331000015')  -- 指定清算机构
           GROUP BY SGN_ACCT_ID_DE),  -- 按卡号分组
        SCOPE_ALL AS                  -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                         -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                      -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0070'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'  -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                        -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                      -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0070'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'       -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                  -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0070'),                     -- 指标编码
        CARD_SCOPE AS                 -- 卡片范围CTE
         (SELECT DISTINCT X.PATH_CODE,                           -- 路径标识
                          X.STATIS_CALIB,                        -- 统计口径名称
                          X.STATIS_DIM,                          -- 统计维度（活动/任务编号）
                          X.DATA_BLNG,                           -- 数据归属
                          X.TERM_BEGIN_DATE,                     -- 活动开始日期
                          X.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
                          C.KEHUHAOO         AS CUST_ID,         -- 客户号
                          C.KAHAOOOO         AS CARD_NO          -- 卡号
            FROM SCOPE_ALL X          -- 范围集为主表
           INNER JOIN CBS_KCDA_PZJCXX C ON C.KEHUHAOO = X.CUST_ID-- 卡介质台账关联客户号
                AND CASE              -- 发卡机构→法人标识映射判定
                    WHEN C.FAKAJIGO LIKE '12%' THEN '1200'       -- 发卡机构号→法人标识映射
                    WHEN C.FAKAJIGO LIKE '15%' THEN '1500'       -- 15开头发卡机构→法人标识
                    WHEN C.FAKAJIGO LIKE '18%' THEN '1800'       -- 18开头发卡机构→法人标识
                    ELSE '9999'       -- 其他发卡机构默认法人标识
                END = X.PERSN_LEGAL_BK_CODE)
        SELECT X.PATH_CODE,                -- 路径标识
               V_SYSDAT,   -- 跑批业务日期
               X.DATA_BLNG,                -- 数据归属
               X.STATIS_DIM,               -- 统计维度（活动/任务编号）
               X.STATIS_CALIB,             -- 统计口径名称
               'INDX_0070',                -- 指标编码
               COUNT(DISTINCT X.CUST_ID),  -- 活动期间三方面绑卡客户去重数
               0,          -- 上期值（本期不统计）
               X.PERSN_LEGAL_BK_CODE       -- 法人机构编码
          FROM CARD_SCOPE X                -- 卡片范围集为主表
         INNER JOIN BIND_CARD B ON B.CARD_NO = X.CARD_NO             -- 卡号关联绑卡集合
              AND B.BIND_DATE BETWEEN X.TERM_BEGIN_DATE AND V_SYSDAT      -- 绑卡日落在活动期间
         GROUP BY X.PATH_CODE,             -- 按路径分组
                  X.DATA_BLNG,             -- 按数据归属分组
                  X.STATIS_DIM,            -- 按统计维度分组
                  X.STATIS_CALIB,          -- 按统计口径分组
                  X.PERSN_LEGAL_BK_CODE;   -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.13/7.14 银行卡三方支付绑卡率 INDX_0071（A/B，本年）
    -- 本年新发卡（FAKARIQI∈[年初,跑批日]）且年龄<70的客户中，已绑卡客户占比（百分比，两位小数）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                           -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH BIND_CARD AS             -- 已绑卡集合CTE
         (SELECT DISTINCT SGN_ACCT_ID_DE AS CARD_NO              -- 已绑卡卡号集合
            FROM ECPP_E_TXN_SIGN      -- 签约表
           WHERE STATUS = '00'        -- 签约有效
             AND INSTG_ID IN ('Z2004944000010', 'Z2007933000010', 'Z2009331000015')),  -- 指定清算机构
        SCOPE_ALL AS                  -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                         -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                      -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0071'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'  -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                        -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                      -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0071'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'       -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                  -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0071'),                     -- 指标编码
        NEW_CUST AS                   -- 本年新发卡客户CTE
         (SELECT DISTINCT X.PATH_CODE,                           -- 路径标识
                          X.STATIS_CALIB,                        -- 统计口径名称
                          X.STATIS_DIM,                          -- 统计维度（活动/任务编号）
                          X.DATA_BLNG,                           -- 数据归属
                          X.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
                          C.KEHUHAOO         AS CUST_ID,         -- 客户号
                          C.KAHAOOOO         AS CARD_NO          -- 卡号
            FROM SCOPE_ALL X          -- 范围集为主表
           INNER JOIN CBS_KCDA_PZJCXX C ON C.KEHUHAOO = X.CUST_ID-- 卡介质台账关联客户号
                AND CASE              -- 发卡机构→法人标识映射
                    WHEN C.FAKAJIGO LIKE '12%' THEN '1200'       -- 发卡机构号→法人标识映射
                    WHEN C.FAKAJIGO LIKE '15%' THEN '1500'       -- 15开头发卡机构→法人标识
                    WHEN C.FAKAJIGO LIKE '18%' THEN '1800'       -- 18开头发卡机构→法人标识
                    ELSE '9999'       -- 其他发卡机构默认法人标识
                END = X.PERSN_LEGAL_BK_CODE
                AND C.FAKARIQI BETWEEN V_YEAR_BEGIN AND V_SYSDAT), -- 本年新发卡
        ELIGIBLE AS -- 合格客户CTE(年龄<70)
         (SELECT N.*                                               -- 取新增客户全部字段
            FROM NEW_CUST N                                        -- 主表为新增客户集
           INNER JOIN DWD_CUST_INDV_INFO I ON I.CUST_ID = N.CUST_ID-- 个人客户信息关联
                AND I.PERSN_LEGAL_BK_CODE = N.PERSN_LEGAL_BK_CODE  -- 法人机构一致
                AND I.AGE < 70),                                   -- 年龄按70岁以下口径
        CUST_FLAG AS                                               -- 客户绑卡标志CTE
         (SELECT E.PATH_CODE,                                      -- 路径标识
                 E.STATIS_CALIB,                                   -- 统计口径名称
                 E.STATIS_DIM,                                     -- 统计维度（活动/任务编号）
                 E.DATA_BLNG,                                      -- 数据归属
                 E.PERSN_LEGAL_BK_CODE,                            -- 法人机构编码
                 E.CUST_ID,                                        -- 客户ID
                 MAX(CASE                                          -- 该客户是否已绑卡(取最大)
                     WHEN B.CARD_NO IS NOT NULL THEN               -- 该卡已绑卡
                         1                                         -- 已绑卡
                     ELSE
                         0  -- 未绑卡
                 END) AS HAS_BIND       -- 该客户是否已绑卡
            FROM ELIGIBLE E -- 合格客户集为主表
            LEFT JOIN BIND_CARD B ON B.CARD_NO = E.CARD_NO             -- 卡号关联绑卡集合
           GROUP BY E.PATH_CODE,        -- 按路径分组
                    E.STATIS_CALIB,     -- 按统计口径分组
                    E.STATIS_DIM,       -- 按统计维度分组
                    E.DATA_BLNG,        -- 按数据归属分组
                    E.PERSN_LEGAL_BK_CODE,  -- 按法人机构分组
                    E.CUST_ID)          -- 按客户维度分组
        SELECT PATH_CODE,   -- 路径标识
               V_SYSDAT,    -- 跑批业务日期
               DATA_BLNG,   -- 数据归属
               STATIS_DIM,  -- 统计维度（活动/任务编号）
               STATIS_CALIB,            -- 统计口径名称
               'INDX_0071', -- 指标编码
               ROUND(SUM(HAS_BIND) * 100 / NULLIF(COUNT(*), 0), 2),       -- 绑卡率（百分比）
               0,           -- 上期值（本期不统计）
               PERSN_LEGAL_BK_CODE      -- 法人机构编码
          FROM CUST_FLAG    -- 客户绑卡标志集为主表
         GROUP BY PATH_CODE,            -- 按路径分组
                  DATA_BLNG,            -- 按数据归属分组
                  STATIS_DIM,           -- 按统计维度分组
                  STATIS_CALIB,         -- 按统计口径分组
                  PERSN_LEGAL_BK_CODE;  -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.15/7.16 活跃卡数 INDX_0072（A/B，近180天）
    -- 近180天内发生借记类交易（JIOYCFFS='0' 且 CHONGZBZ='0'）的卡号去重数
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                           -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                         -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                      -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0072'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'  -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                        -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                      -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0072'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'       -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                  -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0072'),                     -- 指标编码
        CARD_SCOPE AS                 -- 卡片范围CTE
         (SELECT DISTINCT X.PATH_CODE,                           -- 路径标识
                          X.STATIS_CALIB,                        -- 统计口径名称
                          X.STATIS_DIM,                          -- 统计维度（活动/任务编号）
                          X.DATA_BLNG,                           -- 数据归属
                          X.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
                          C.KAHAOOOO AS CARD_NO                  -- 卡号
            FROM SCOPE_ALL X          -- 范围集为主表
           INNER JOIN CBS_KCDA_PZJCXX C ON C.KEHUHAOO = X.CUST_ID-- 卡介质台账关联客户号
                AND CASE              -- 发卡机构→法人标识映射
                    WHEN C.FAKAJIGO LIKE '12%' THEN '1200'       -- 发卡机构号→法人标识映射
                    WHEN C.FAKAJIGO LIKE '15%' THEN '1500'       -- 15开头发卡机构→法人标识
                    WHEN C.FAKAJIGO LIKE '18%' THEN '1800'       -- 18开头发卡机构→法人标识
                    ELSE '9999'       -- 其他发卡机构默认法人标识
                END = X.PERSN_LEGAL_BK_CODE)
        SELECT X.PATH_CODE,                -- 路径标识
               V_SYSDAT,   -- 跑批业务日期
               X.DATA_BLNG,                -- 数据归属
               X.STATIS_DIM,               -- 统计维度（活动/任务编号）
               X.STATIS_CALIB,             -- 统计口径名称
               'INDX_0072',                -- 指标编码
               COUNT(DISTINCT X.CARD_NO),  -- 近180天活跃卡数
               0,          -- 上期值（本期不统计）
               X.PERSN_LEGAL_BK_CODE       -- 法人机构编码
          FROM CARD_SCOPE X                -- 卡片范围集为主表
         INNER JOIN DWD_TX_ASET T ON T.CARD_NO = X.CARD_NO           -- 卡号关联交易流水
              AND T.TX_DATE BETWEEN V_180_DAY_BEGIN AND V_SYSDAT           -- 近180天内交易
              AND T.JIOYCFFS = '0'         -- 交易日切标识
              AND T.CHONGZBZ = '0'         -- 冲正标识
         GROUP BY X.PATH_CODE,             -- 按路径分组
                  X.DATA_BLNG,             -- 按数据归属分组
                  X.STATIS_DIM,            -- 按统计维度分组
                  X.STATIS_CALIB,          -- 按统计口径分组
                  X.PERSN_LEGAL_BK_CODE;   -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.17/7.18 代发薪客户净增 INDX_0064（合并 A/B，标签表+基数表）
    -- 范围客户 ∩ 基数表：FRST_MARK_DATE∈[活动开始日,跑批日]即活动期间新增标记，COUNT(DISTINCT CUST_ID)
    -- 基数客户首现记'19000101'自动剔除；按活动/任务编号(STATIS_DIM)隔离防多活动重复
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                           -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                         -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                      -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0064'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'  -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                        -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                      -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0064'                       -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                           -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'       -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID                  -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0064')                      -- 指标编码
        SELECT SM.PATH_CODE,             -- 路径标识
               V_SYSDAT,              -- 跑批业务日期
               DATA_BLNG,             -- 数据归属
               SM.STATIS_DIM,            -- 统计维度（活动/任务编号）
               STATIS_CALIB,          -- 统计口径名称
               'INDX_0064',           -- 指标编码
               COUNT(DISTINCT SM.CUST_ID),                          -- 活动期间代发薪净增客户去重数
               0,                     -- 上期值（本期不统计）
               SM.PERSN_LEGAL_BK_CODE    -- 法人机构编码
          FROM (SELECT DISTINCT PATH_CODE,                    -- 路径标识
                                STATIS_CALIB,                 -- 统计口径名称
                                STATIS_DIM,                   -- 统计维度（活动/任务编号）
                                DATA_BLNG,                    -- 数据归属
                                TERM_BEGIN_DATE,              -- 活动开始日期
                                CUST_ID,                      -- 客户ID
                                PERSN_LEGAL_BK_CODE           -- 法人机构编码
                  FROM SCOPE_ALL) SM  -- 去重后的范围集
         INNER JOIN ADS_CRM_R_SALRY_PAYROL_BASE B ON B.CUST_ID = SM.CUST_ID   -- 基数表客户关联
              AND B.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE -- 法人机构一致
              AND B.STATIS_DIM = SM.STATIS_DIM                   -- 统计维度一致（防多活动重复）
              AND B.PATH_CODE = SM.PATH_CODE                     -- 路径一致
              AND B.FRST_MARK_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT   -- 活动期间新增标记
         GROUP BY SM.PATH_CODE,          -- 按路径分组
                  DATA_BLNG,          -- 按数据归属分组
                  SM.STATIS_DIM,         -- 按统计维度分组
                  STATIS_CALIB,       -- 按统计口径分组
                  SM.PERSN_LEGAL_BK_CODE;                           -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 7.19/7.20 代销业务收入 INDX_0065（合并 A/B，暂不含贵金属）
    -- 理财：DWD_ACCT_FIN.PRDKT_CATE_BIG IN('1','2')，ISSU_DATE∈[开始日,跑批日]，SUM(FIN_AMT)
    -- 保险：DWD_ACCT_INSUR.POLICY_STATE='1'，TX_DATE∈[开始日,跑批日]，SUM(INSUR_AMT)
    -- 本期值 = 理财合计 + 保险合计（UNION ALL 后统一 SUM，一个活动/任务一条记录）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_006                      -- 写入步骤6专属汇总临时表
        (PATH_CODE,                   -- 路径标识
         DATA_DATE,                   -- 跑批业务日期(YYYYMMDD)
         DATA_BLNG,                   -- 数据归属
         STATIS_DIM,                  -- 统计维度(活动/任务编号)
         STATIS_CALIB,                -- 统计口径名称
         INDX_CODE,                   -- 指标编码
         CURNT_VAL,                   -- 本期统计值
         TERM_LAST_VAL,               -- 上期统计值
         PERSN_LEGAL_BK_CODE)         -- 法人机构编码
        WITH SCOPE_ALL AS             -- 全范围客户集合CTE
         (SELECT '08' AS PATH_CODE,    -- 路径标识 08=营销活动
                 '08' AS STATIS_CALIB,                    -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 TI.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                      -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                      -- 范围集合表(源)
           INNER JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID关联
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE              -- 法人机构一致
                AND TI.DATA_DATE = V_SYSDAT                 -- 跑批当日参与机构
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID) OR    -- 机构级归属匹配
                     (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))          -- 经理级归属匹配
           WHERE S.PATH_CODE = '08'    -- 仅营销活动路径
             AND S.INDX_CODE = 'INDX_0065'                  -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 LV.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                      -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                      -- 范围集合表(源)
           INNER JOIN DWS_CUST_LVL_INFO LV ON S.BLNG_TYPE = 'O'                 -- 机构级客户层级
                AND LV.ORG_ID = S.BLNG_ID                   -- 机构ID关联
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE             -- 法人机构一致
                AND LV.DATA_DATE = V_SYSDAT                 -- 跑批当日
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0065'                  -- 指标编码
          UNION ALL                   -- 合并A/路径09
          SELECT '09',                 -- 路径标识 B=目标任务
                 '09',              -- 统计口径名称
                 S.STATIS_DIM,        -- 统计维度（活动/任务编号）
                 S.DATA_BLNG,         -- 数据归属
                 S.TERM_BEGIN_DATE,   -- 活动开始日期
                 CM.CUST_ID,          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                      -- 法人机构编码
            FROM TMP_STAT_INDX_SCOPE S                      -- 范围集合表(源)
           INNER JOIN DWD_CUST_MAN CM ON S.BLNG_TYPE = 'M'  -- 经理级客户经理关系
                AND CM.MNGR_POST_ID = S.BLNG_ID             -- 客户经理岗位ID关联
                AND CM.MNG_TYP = '1'  -- 主管类型
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE            -- 法人机构一致
           WHERE S.PATH_CODE = '09'    -- 目标任务路径
             AND S.INDX_CODE = 'INDX_0065')                 -- 指标编码
        SELECT SM.PATH_CODE,             -- 路径标识
               V_SYSDAT,              -- 跑批业务日期
               SM.DATA_BLNG,             -- 数据归属
               SM.STATIS_DIM,            -- 统计维度（活动/任务编号）
               SM.STATIS_CALIB,          -- 统计口径名称
               'INDX_0065',           -- 指标编码
               SUM(AMT),              -- 理财+保险代销收入合计
               0,                     -- 上期值（本期不统计）
               SM.PERSN_LEGAL_BK_CODE    -- 法人机构编码
          FROM (SELECT DISTINCT PATH_CODE,               -- 路径标识
                                STATIS_CALIB,            -- 统计口径名称
                                STATIS_DIM,              -- 统计维度（活动/任务编号）
                                DATA_BLNG,               -- 数据归属
                                TERM_BEGIN_DATE,         -- 活动开始日期
                                CUST_ID,                 -- 客户ID
                                PERSN_LEGAL_BK_CODE      -- 法人机构编码
                  FROM SCOPE_ALL) SM  -- 去重后的范围集
         INNER JOIN (SELECT F.CUST_ID,                      -- 客户ID
                            F.PERSN_LEGAL_BK_CODE,          -- 法人机构编码
                            NVL(F.FIN_AMT, 0) AS AMT,       -- 理财销售金额（空转0）
                            F.ISSU_DATE       AS TX_DATE    -- 理财发行日期
                       FROM DWD_ACCT_FIN F                  -- 理财账户表(收益类产品)
                      WHERE F.PRDKT_CATE_BIG IN ('1', '2')  -- 理财收益类产品
                      UNION ALL       -- 合并理财与保险
                     SELECT I.CUST_ID,                      -- 客户ID
                            I.PERSN_LEGAL_BK_CODE,          -- 法人机构编码
                            NVL(I.INSUR_AMT, 0) AS AMT,     -- 保险销售金额（空转0）
                            I.TX_DATE           AS TX_DATE  -- 保险交易日期
                       FROM DWD_ACCT_INSUR I                -- 保险账户表(有效保单)
                      WHERE I.POLICY_STATE = '1') D         -- 保险有效保单
              ON D.CUST_ID = SM.CUST_ID                     -- 客户ID关联
             AND D.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE               -- 法人机构一致
             AND D.TX_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT            -- 交易日期在活动期间内
         GROUP BY SM.PATH_CODE,          -- 按路径分组
                  SM.DATA_BLNG,          -- 按数据归属分组
                  SM.STATIS_DIM,         -- 按统计维度分组
                  SM.STATIS_CALIB,       -- 按统计口径分组
                  SM.PERSN_LEGAL_BK_CODE;                      -- 按法人机构分组
    OUTCDE := SQL%ROWCOUNT;           -- 输出影响行数（最后一次INSERT处理行数）
    COMMIT;                           -- 提交本段事务
    V_END_DATE  := SYSDATE;           -- 记录结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);-- 计算耗时（秒）
    V_LOG_MSG   := '步骤6处理完成，行数=' || NVL(OUTCDE, 0);         -- 拼装日志消息
    V_LOG_FLG   := 0;                 -- 日志标志（0成功）
    SYS_PRC_STEP_LOGS(V_SYSDAT,       -- 记录步骤日志（过程名/时间/耗时/消息/标志）
                      V_PRC_NAME,     -- 过程名
                      V_PRC_DESC,     -- 过程描述
                      V_NO_ID,        -- 步骤编号
                      V_BGN_DATE,     -- 开始时间
                      V_END_DATE,     -- 结束时间
                      V_DURA_DATE,    -- 耗时(秒)
                      V_LOG_MSG,      -- 日志消息
                      V_LOG_FLG,      -- 日志标志
                      V_LOG_BUTTON);  -- 日志按钮标识
EXCEPTION                             -- 异常处理块
    WHEN OTHERS THEN
        ROLLBACK;                    -- 异常回滚
        OUTCDE      := -1;           -- 输出异常标志
        V_END_DATE  := SYSDATE;      -- 记录结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算耗时（秒）
        V_LOG_MSG   := SUBSTR(SQLERRM, 1, 1000);  -- 错误信息截断记录
        V_LOG_FLG   := -1;           -- 日志标志（-1失败）
        SYS_PRC_STEP_LOGS(V_SYSDAT,  -- 写失败日志
                          V_PRC_NAME,     -- 过程名
                          V_PRC_DESC,     -- 过程描述
                          V_NO_ID,   -- 步骤编号
                          V_BGN_DATE,     -- 开始时间
                          V_END_DATE,     -- 结束时间
                          V_DURA_DATE,    -- 耗时(秒)
                          V_LOG_MSG, -- 日志消息
                          V_LOG_FLG, -- 日志标志
                          V_LOG_BUTTON);  -- 日志按钮标识
        RAISE;                       -- 重新抛出异常
END PRC_ADS_STAT_INDX_PLAN_006;