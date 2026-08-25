-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_007
-- 功能说明: 指标数据统计——步骤7（按多路径计算多项新增类指标，汇总写入专属临时表）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（影响行数 / 错误标志）
-- 需求版本: v5.0 (2026-08-25)
-- 变更记录:
--   v5.0 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_007，段首自清（并行跑批隔离）
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_007
(
    V_SYSDAT  IN VARCHAR2,  -- 跑批业务日期 YYYYMMDD
    OUTCDE OUT INTEGER  -- 输出影响行数/错误标志
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤77处理完成 7';  -- 步骤描述
    V_PRC_NAME VARCHAR2(32) := 'PRC_ADS_STAT_INDX_PLAN_007';          -- 过程名
    V_LOG_MSG VARCHAR2(4000);                        -- 日志消息文本
    V_LOG_FLG INTEGER;                               -- 日志标志（0成功/-1失败）
    V_LOG_BUTTON INTEGER := 1;                       -- 日志按钮标识
    V_NO_ID VARCHAR2(10);                            -- 跑批序号
    V_BGN_DATE DATE;                                 -- 开始时间
    V_END_DATE DATE;                                 -- 结束时间
    V_DURA_DATE INTEGER;                             -- 耗时（秒）
    V_180_DAY_BEGIN VARCHAR2(8);                     -- 180天猫新客判定起始日期
BEGIN
    V_NO_ID := '0';  -- 跑批序号置0
    V_BGN_DATE := SYSDATE;  -- 记录开始时间
    -- 参数校验：跑批日期必须为 8 位数字 YYYYMMDD
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN  -- 校验跑批日期格式
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 日期非法则报错终止
    END IF;
    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 将跑批日期字符串转为日期类型
    -- 计算往前回推 27 个自然日（约 180 天口径）的起始日期，用于新客判定
    V_180_DAY_BEGIN := SYS_FUN_DEAL_DATE(V_SYSDAT, 27);  -- 调用日期函数求180天窗口起始日

    -------------------------------------------------------------------------
    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_AGGR_007;  -- 清空本过程专属汇总累计临时表

    -------------------------------------------------------------------------
    -- INDX_0080 新客交叉销售 (合并 A/B)
    -- 说明: 营销活动(A)/目标任务(B)两路径取数并经客户维度去重后，
    --       统计开户时间在 180 天窗口内且持有两类及以上产品（手机银行/存款/理财/贷款）的交叉销售客户数
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007                           -- 插入专属累计表（0080）
        (PATH_CODE,                                              -- 路径代码
         DATA_DATE,                                              -- 数据日期
         DATA_BLNG,                                              -- 数据归属
         STATIS_DIM,                                             -- 统计维度
         STATIS_CALIB,                                           -- 统计口径
         INDX_CODE,                                              -- 指标代码
         CURNT_VAL,                                              -- 本期值
         TERM_LAST_VAL,                                          -- 上期值
         PERSN_LEGAL_BK_CODE)                                    -- 法人机构编号
        WITH SCOPE_ALL AS                                        -- 组装A/B各路径范围内客户
         (SELECT 'A'       AS PATH_CODE,                         -- 路径代码A（营销活动）
                 '营销活动' AS STATIS_CALIB,                         -- 统计口径=营销活动
                 S.STATIS_DIM,                                   -- 统计维度（活动ID）
                 S.DATA_BLNG,                                    -- 数据归属
                 S.TERM_BEGIN_DATE,                              -- 活动开始日期
                 TI.CUST_ID,                                     -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                           -- 法人机构编号
            FROM TMP_STAT_INDX_SCOPE S                           -- 指标范围临时表
        INNER JOIN DWD_MKT_TSK_INFO TI                           -- 关联营销活动任务信息
               ON TI.MKT_ACT_ID = S.STATIS_DIM                   -- 活动ID等于统计维度
              AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE -- 法人机构一致
              AND TI.DATA_DATE = V_SYSDAT                        -- 取跑批日期当日活动
              AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)  -- 按机构归属匹配
                OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))  -- 按客户经理归属匹配
          WHERE S.PATH_CODE = 'A'                                -- 限定A路径
            AND S.INDX_CODE = 'INDX_0080'                        -- 仅取0080指标
         UNION ALL                                               -- 合并（保留重复）
         SELECT 'B',                                             -- 路径代码B（目标任务）
                '目标任务',                                          -- 统计口径=目标任务
                S.STATIS_DIM,                                    -- 统计维度
                S.DATA_BLNG,                                     -- 数据归属
                S.TERM_BEGIN_DATE,                               -- 任务开始日期
                LV.CUST_ID,                                      -- 客户ID
                S.PERSN_LEGAL_BK_CODE                            -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S                            -- 指标范围临时表
        INNER JOIN DWS_CUST_LVL_INFO LV                          -- 关联客户层级信息
               ON S.BLNG_TYPE = 'O'                              -- 归属类型为机构
              AND LV.ORG_ID = S.BLNG_ID                          -- 机构ID一致
              AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE -- 法人机构一致
              AND LV.DATA_DATE = V_SYSDAT                        -- 取跑批日期当日层级
          WHERE S.PATH_CODE = 'B'                                -- 限定B路径
            AND S.INDX_CODE = 'INDX_0080'                        -- 仅取0080指标
         UNION ALL                                               -- 合并（保留重复）
         SELECT 'B',                                             -- 路径代码B
                '目标任务',                                          -- 统计口径
                S.STATIS_DIM,                                    -- 统计维度
                S.DATA_BLNG,                                     -- 数据归属
                S.TERM_BEGIN_DATE,                               -- 任务开始日期
                CM.CUST_ID,                                      -- 客户ID
                S.PERSN_LEGAL_BK_CODE                            -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S                            -- 指标范围临时表
        INNER JOIN DWD_CUST_MAN CM                               -- 关联客户经理归属表
               ON S.BLNG_TYPE = 'M'                              -- 归属类型为客户经理
              AND CM.MNGR_POST_ID = S.BLNG_ID                    -- 客户经理岗位ID一致
              AND CM.MNG_TYP = '1'                               -- 客户经理类型主号
              AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE -- 法人机构一致
          WHERE S.PATH_CODE = 'B'                                -- 限定B路径
            AND S.INDX_CODE = 'INDX_0080'),                      -- 仅取0080指标
        CUST_FLAGS AS                                            -- 客户维度打标（四类产品持有标志）
         (SELECT SM.PATH_CODE,                                   -- 路径代码
                 SM.STATIS_CALIB,                                -- 统计口径
                 SM.STATIS_DIM,                                  -- 统计维度
                 SM.DATA_BLNG,                                   -- 数据归属
                 SM.TERM_BEGIN_DATE,                             -- 开始日期
                 SM.CUST_ID,                                     -- 客户ID
                 SM.PERSN_LEGAL_BK_CODE,                         -- 法人机构编号
                 CI.OPEN_DATE,                                   -- 客户开户日期
                 MAX(CASE WHEN MI.CUST_NO IS NOT NULL THEN 1 ELSE 0 END) AS HAS_MBK,  -- 是否持有手机银行
                 MAX(CASE WHEN NVL(B.DEPO_CURNT_DEPO_BAL, 0) + NVL(B.FIXD_DEPO_BAL, 0) >= 100 THEN 1 ELSE 0 END) AS HAS_DEPO,  -- 是否持有存款（活期+定期≥100）
                 MAX(CASE WHEN NVL(B.FIN_BAL, 0) > 0 THEN 1 ELSE 0 END) AS HAS_FIN,  -- 是否持有理财（金融资产）
                 MAX(CASE WHEN NVL(B.LOAN_BAL, 0) > 0 THEN 1 ELSE 0 END) AS HAS_LOAN  -- 是否持有贷款
           FROM (SELECT DISTINCT PATH_CODE,                      -- 去重：路径
                                  STATIS_CALIB,                  -- 口径
                                  STATIS_DIM,                    -- 维度
                                  DATA_BLNG,                     -- 归属
                                  TERM_BEGIN_DATE,               -- 开始日期
                                  CUST_ID,                       -- 客户ID
                                  PERSN_LEGAL_BK_CODE            -- 法人机构
                   FROM SCOPE_ALL) SM                            -- 范围客户去重后的结果集
       LEFT JOIN DWD_CUST_INDV_INFO CI                           -- 关联个人客户基本信息
              ON CI.CUST_ID = SM.CUST_ID                         -- 客户ID一致
             AND CI.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE -- 法人机构一致
       LEFT JOIN MBK_CUST_INFO MI                                -- 关联手机银行客户信息
              ON MI.CUST_CORE_NO = SM.CUST_ID                    -- 客户核心号等于客户ID
             AND MI.INCORP_NO = SM.PERSN_LEGAL_BK_CODE           -- 法人机构一致
             AND MI.CUST_STATUS = '1'                            -- 客户状态为有效
       LEFT JOIN DWS_CUST_ASSE_LIAB B                            -- 关联资产负债余额表
              ON B.CUST_ID = SM.CUST_ID                          -- 客户ID一致
             AND B.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE  -- 法人机构一致
             AND B.DATA_DATE = V_SYSDAT                          -- 取跑批日期当日余额
             AND B.BAL_TYPE = '1'                                -- 余额类型为贷款/存款时点
        GROUP BY SM.PATH_CODE,                                   -- 按路径分组
                 SM.STATIS_CALIB,                                -- 按口径分组
                 SM.STATIS_DIM,                                  -- 按维度分组
                 SM.DATA_BLNG,                                   -- 按归属分组
                 SM.TERM_BEGIN_DATE,                             -- 按开始日期分组
                 SM.CUST_ID,                                     -- 按客户分组
                 SM.PERSN_LEGAL_BK_CODE,                         -- 按法人机构分组
                 CI.OPEN_DATE)                                   -- 按开户日期分组
        SELECT PATH_CODE,                                        -- 路径代码
               V_SYSDAT,                                         -- 数据日期=跑批日期
               DATA_BLNG,                                        -- 数据归属
               STATIS_DIM,                                       -- 统计维度
               STATIS_CALIB,                                     -- 统计口径
               'INDX_0080',                                      -- 指标代码固定0080
               COUNT(DISTINCT CASE                               -- 计数满足交叉销售条件的客户
                    WHEN OPEN_DATE BETWEEN V_180_DAY_BEGIN AND V_SYSDAT  -- 客户开户日在180天窗口内（新客）
                     AND HAS_MBK + HAS_DEPO + HAS_FIN + HAS_LOAN >= 2 THEN  -- 持有两类及以上产品
                        CUST_ID                                  -- 计入客户ID
                  END),                                          -- 结束去重计数
               0,                                                -- 上期值置0
               PERSN_LEGAL_BK_CODE                               -- 法人机构编号
          FROM CUST_FLAGS                                        -- 打标后的结果集
        GROUP BY PATH_CODE,                                      -- 按路径分组
                 DATA_BLNG,                                      -- 按归属分组
                 STATIS_DIM,                                     -- 按维度分组
                 STATIS_CALIB,                                   -- 按口径分组
                 PERSN_LEGAL_BK_CODE;                            -- 按法人机构分组

    -------------------------------------------------------------------------
    -- INDX_0082 新增客户数 (合并 A/B)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007          -- 插入专属累计表（0082）
        (PATH_CODE,                             -- 路径代码
         DATA_DATE,                             -- 数据日期
         DATA_BLNG,                             -- 数据归属
         STATIS_DIM,                            -- 统计维度
         STATIS_CALIB,                          -- 统计口径
         INDX_CODE,                             -- 指标代码
         CURNT_VAL,                             -- 本期值
         TERM_LAST_VAL,                         -- 上期值
         PERSN_LEGAL_BK_CODE)                   -- 法人机构编号
        WITH SCOPE_ALL AS                       -- 组装A/B各路径范围内客户
         (SELECT 'A'       AS PATH_CODE,        -- 路径代码A
                 '营销活动' AS STATIS_CALIB,        -- 统计口径
                 S.STATIS_DIM,                  -- 统计维度
                 S.DATA_BLNG,                   -- 数据归属
                 S.TERM_BEGIN_DATE,             -- 开始日期
                 TI.CUST_ID,                    -- 客户ID
                 S.PERSN_LEGAL_BK_CODE          -- 法人机构编号
            FROM TMP_STAT_INDX_SCOPE S          -- 指标范围临时表
        INNER JOIN DWD_MKT_TSK_INFO TI          -- 关联营销活动任务信息
               ON TI.MKT_ACT_ID = S.STATIS_DIM  -- 活动ID等于统计维度
              AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
              AND TI.DATA_DATE = V_SYSDAT       -- 取跑批日期当日活动
              AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)  -- 按机构归属匹配
                OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))  -- 按客户经理归属匹配
          WHERE S.PATH_CODE = 'A'               -- 限定A路径
            AND S.INDX_CODE = 'INDX_0082'       -- 仅取0082指标
         UNION ALL                              -- 合并（保留重复）
         SELECT 'B',                            -- 路径代码B
                '目标任务',                         -- 统计口径
                S.STATIS_DIM,                   -- 统计维度
                S.DATA_BLNG,                    -- 数据归属
                S.TERM_BEGIN_DATE,              -- 开始日期
                LV.CUST_ID,                     -- 客户ID
                S.PERSN_LEGAL_BK_CODE           -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S           -- 指标范围临时表
        INNER JOIN DWS_CUST_LVL_INFO LV         -- 关联客户层级信息
               ON S.BLNG_TYPE = 'O'             -- 归属类型为机构
              AND LV.ORG_ID = S.BLNG_ID         -- 机构ID一致
              AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
              AND LV.DATA_DATE = V_SYSDAT       -- 取跑批日期当日层级
          WHERE S.PATH_CODE = 'B'               -- 限定B路径
            AND S.INDX_CODE = 'INDX_0082'       -- 仅取0082指标
         UNION ALL                              -- 合并（保留重复）
         SELECT 'B',                            -- 路径代码B
                '目标任务',                         -- 统计口径
                S.STATIS_DIM,                   -- 统计维度
                S.DATA_BLNG,                    -- 数据归属
                S.TERM_BEGIN_DATE,              -- 开始日期
                CM.CUST_ID,                     -- 客户ID
                S.PERSN_LEGAL_BK_CODE           -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S           -- 指标范围临时表
        INNER JOIN DWD_CUST_MAN CM              -- 关联客户经理归属表
               ON S.BLNG_TYPE = 'M'             -- 归属类型为客户经理
              AND CM.MNGR_POST_ID = S.BLNG_ID   -- 客户经理岗位ID一致
              AND CM.MNG_TYP = '1'              -- 客户经理类型主号
              AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
          WHERE S.PATH_CODE = 'B'               -- 限定B路径
            AND S.INDX_CODE = 'INDX_0082')      -- 仅取0082指标
        SELECT SM.PATH_CODE,                    -- 路径代码
               V_SYSDAT,                        -- 数据日期=跑批日期
               SM.DATA_BLNG,                    -- 数据归属
               SM.STATIS_DIM,                   -- 统计维度
               SM.STATIS_CALIB,                 -- 统计口径
               'INDX_0082',                     -- 指标代码固定0082
               COUNT(DISTINCT CASE              -- 计数开户日期在活动/任务开始日期与跑批日期之间的新增客户
                    WHEN CI.OPEN_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT THEN  -- 开户日在活动期内
                        SM.CUST_ID              -- 计入客户ID
                  END),                         -- 结束去重计数
               0,                               -- 上期值置0
               SM.PERSN_LEGAL_BK_CODE           -- 法人机构编号
          FROM (SELECT DISTINCT PATH_CODE,      -- 去重：路径
                                 STATIS_CALIB,  -- 口径
                                 STATIS_DIM,    -- 维度
                                 DATA_BLNG,     -- 归属
                                 TERM_BEGIN_DATE,  -- 开始日期
                                 CUST_ID,       -- 客户ID
                                 PERSN_LEGAL_BK_CODE  -- 法人机构
                   FROM SCOPE_ALL) SM           -- 范围客户去重后结果集
       LEFT JOIN DWD_CUST_INDV_INFO CI          -- 关联个人客户基本信息
              ON CI.CUST_ID = SM.CUST_ID        -- 客户ID一致
             AND CI.PERSN_LEGAL_BK_CODE = SM.PERSN_LEGAL_BK_CODE  -- 法人机构一致
        GROUP BY SM.PATH_CODE,                  -- 按路径分组
                 SM.DATA_BLNG,                  -- 按归属分组
                 SM.STATIS_DIM,                 -- 按维度分组
                 SM.STATIS_CALIB,               -- 按口径分组
                 SM.PERSN_LEGAL_BK_CODE;        -- 按法人机构分组

    -------------------------------------------------------------------------
    -- INDX_0073 手机银行客户数新增 (合并 A/B)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007          -- 插入专属累计表（0073）
        (PATH_CODE,                             -- 路径代码
         DATA_DATE,                             -- 数据日期
         DATA_BLNG,                             -- 数据归属
         STATIS_DIM,                            -- 统计维度
         STATIS_CALIB,                          -- 统计口径
         INDX_CODE,                             -- 指标代码
         CURNT_VAL,                             -- 本期值
         TERM_LAST_VAL,                         -- 上期值
         PERSN_LEGAL_BK_CODE)                   -- 法人机构编号
        WITH SCOPE_ALL AS                       -- 组装A/B各路径范围内客户
         (SELECT 'A'       AS PATH_CODE,        -- 路径代码A
                 '营销活动' AS STATIS_CALIB,        -- 统计口径
                 S.STATIS_DIM,                  -- 统计维度
                 S.DATA_BLNG,                   -- 数据归属
                 S.TERM_BEGIN_DATE,             -- 开始日期
                 TI.CUST_ID,                    -- 客户ID
                 S.PERSN_LEGAL_BK_CODE          -- 法人机构编号
            FROM TMP_STAT_INDX_SCOPE S          -- 指标范围临时表
        INNER JOIN DWD_MKT_TSK_INFO TI          -- 关联营销活动任务信息
               ON TI.MKT_ACT_ID = S.STATIS_DIM  -- 活动ID等于统计维度
              AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
              AND TI.DATA_DATE = V_SYSDAT       -- 取跑批日期当日活动
              AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)  -- 按机构归属匹配
                OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))  -- 按客户经理归属匹配
          WHERE S.PATH_CODE = 'A'               -- 限定A路径
            AND S.INDX_CODE = 'INDX_0073'       -- 仅取0073指标
         UNION ALL                              -- 合并（保留重复）
         SELECT 'B',                            -- 路径代码B
                '目标任务',                         -- 统计口径
                S.STATIS_DIM,                   -- 统计维度
                S.DATA_BLNG,                    -- 数据归属
                S.TERM_BEGIN_DATE,              -- 开始日期
                LV.CUST_ID,                     -- 客户ID
                S.PERSN_LEGAL_BK_CODE           -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S           -- 指标范围临时表
        INNER JOIN DWS_CUST_LVL_INFO LV         -- 关联客户层级信息
               ON S.BLNG_TYPE = 'O'             -- 归属类型为机构
              AND LV.ORG_ID = S.BLNG_ID         -- 机构ID一致
              AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
              AND LV.DATA_DATE = V_SYSDAT       -- 取跑批日期当日层级
          WHERE S.PATH_CODE = 'B'               -- 限定B路径
            AND S.INDX_CODE = 'INDX_0073'       -- 仅取0073指标
         UNION ALL                              -- 合并（保留重复）
         SELECT 'B',                            -- 路径代码B
                '目标任务',                         -- 统计口径
                S.STATIS_DIM,                   -- 统计维度
                S.DATA_BLNG,                    -- 数据归属
                S.TERM_BEGIN_DATE,              -- 开始日期
                CM.CUST_ID,                     -- 客户ID
                S.PERSN_LEGAL_BK_CODE           -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S           -- 指标范围临时表
        INNER JOIN DWD_CUST_MAN CM              -- 关联客户经理归属表
               ON S.BLNG_TYPE = 'M'             -- 归属类型为客户经理
              AND CM.MNGR_POST_ID = S.BLNG_ID   -- 客户经理岗位ID一致
              AND CM.MNG_TYP = '1'              -- 客户经理类型主号
              AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
          WHERE S.PATH_CODE = 'B'               -- 限定B路径
            AND S.INDX_CODE = 'INDX_0073')      -- 仅取0073指标
        SELECT SM.PATH_CODE,                    -- 路径代码
               V_SYSDAT,                        -- 数据日期=跑批日期
               SM.DATA_BLNG,                    -- 数据归属
               SM.STATIS_DIM,                   -- 统计维度
               SM.STATIS_CALIB,                 -- 统计口径
               'INDX_0073',                     -- 指标代码固定0073
               COUNT(DISTINCT CASE              -- 计数手机银行开户日期在活动期内的新增客户
                    WHEN MI.CUST_OPEN_DATE BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT THEN  -- 手机银行开户日在活动期内
                        SM.CUST_ID              -- 计入客户ID
                  END),                         -- 结束去重计数
               0,                               -- 上期值置0
               SM.PERSN_LEGAL_BK_CODE           -- 法人机构编号
          FROM (SELECT DISTINCT PATH_CODE,      -- 去重：路径
                                 STATIS_CALIB,  -- 口径
                                 STATIS_DIM,    -- 维度
                                 DATA_BLNG,     -- 归属
                                 TERM_BEGIN_DATE,  -- 开始日期
                                 CUST_ID,       -- 客户ID
                                 PERSN_LEGAL_BK_CODE  -- 法人机构
                   FROM SCOPE_ALL) SM           -- 范围客户去重后结果集
       LEFT JOIN MBK_CUST_INFO MI               -- 关联手机银行客户信息
              ON MI.CUST_CORE_NO = SM.CUST_ID   -- 客户核心号等于客户ID
             AND MI.INCORP_NO = SM.PERSN_LEGAL_BK_CODE  -- 法人机构一致
        GROUP BY SM.PATH_CODE,                  -- 按路径分组
                 SM.DATA_BLNG,                  -- 按归属分组
                 SM.STATIS_DIM,                 -- 按维度分组
                 SM.STATIS_CALIB,               -- 按口径分组
                 SM.PERSN_LEGAL_BK_CODE;        -- 按法人机构分组

    -------------------------------------------------------------------------
    -- INDX_0083 借记卡新开净增量（CBS发卡日期，合并 A/B）
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_007                -- 插入专属累计表（0083）
        (PATH_CODE,                                   -- 路径代码
         DATA_DATE,                                   -- 数据日期
         DATA_BLNG,                                   -- 数据归属
         STATIS_DIM,                                  -- 统计维度
         STATIS_CALIB,                                -- 统计口径
         INDX_CODE,                                   -- 指标代码
         CURNT_VAL,                                   -- 本期值
         TERM_LAST_VAL,                               -- 上期值
         PERSN_LEGAL_BK_CODE)                         -- 法人机构编号
        WITH SCOPE_ALL AS                             -- 组装A/B各路径范围内客户
         (SELECT 'A'       AS PATH_CODE,              -- 路径代码A
                 '营销活动' AS STATIS_CALIB,              -- 统计口径
                 S.STATIS_DIM,                        -- 统计维度
                 S.DATA_BLNG,                         -- 数据归属
                 S.TERM_BEGIN_DATE,                   -- 开始日期
                 TI.CUST_ID,                          -- 客户ID
                 S.PERSN_LEGAL_BK_CODE                -- 法人机构编号
            FROM TMP_STAT_INDX_SCOPE S                -- 指标范围临时表
        INNER JOIN DWD_MKT_TSK_INFO TI                -- 关联营销活动任务信息
               ON TI.MKT_ACT_ID = S.STATIS_DIM        -- 活动ID等于统计维度
              AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
              AND TI.DATA_DATE = V_SYSDAT             -- 取跑批日期当日活动
              AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)  -- 按机构归属匹配
                OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))  -- 按客户经理归属匹配
          WHERE S.PATH_CODE = 'A'                     -- 限定A路径
            AND S.INDX_CODE = 'INDX_0083'             -- 仅取0083指标
         UNION ALL                                    -- 合并（保留重复）
         SELECT 'B',                                  -- 路径代码B
                '目标任务',                               -- 统计口径
                S.STATIS_DIM,                         -- 统计维度
                S.DATA_BLNG,                          -- 数据归属
                S.TERM_BEGIN_DATE,                    -- 开始日期
                LV.CUST_ID,                           -- 客户ID
                S.PERSN_LEGAL_BK_CODE                 -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S                 -- 指标范围临时表
        INNER JOIN DWS_CUST_LVL_INFO LV               -- 关联客户层级信息
               ON S.BLNG_TYPE = 'O'                   -- 归属类型为机构
              AND LV.ORG_ID = S.BLNG_ID               -- 机构ID一致
              AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
              AND LV.DATA_DATE = V_SYSDAT             -- 取跑批日期当日层级
          WHERE S.PATH_CODE = 'B'                     -- 限定B路径
            AND S.INDX_CODE = 'INDX_0083'             -- 仅取0083指标
         UNION ALL                                    -- 合并（保留重复）
         SELECT 'B',                                  -- 路径代码B
                '目标任务',                               -- 统计口径
                S.STATIS_DIM,                         -- 统计维度
                S.DATA_BLNG,                          -- 数据归属
                S.TERM_BEGIN_DATE,                    -- 开始日期
                CM.CUST_ID,                           -- 客户ID
                S.PERSN_LEGAL_BK_CODE                 -- 法人机构编号
           FROM TMP_STAT_INDX_SCOPE S                 -- 指标范围临时表
        INNER JOIN DWD_CUST_MAN CM                    -- 关联客户经理归属表
               ON S.BLNG_TYPE = 'M'                   -- 归属类型为客户经理
              AND CM.MNGR_POST_ID = S.BLNG_ID         -- 客户经理岗位ID一致
              AND CM.MNG_TYP = '1'                    -- 客户经理类型主号
              AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构一致
          WHERE S.PATH_CODE = 'B'                     -- 限定B路径
            AND S.INDX_CODE = 'INDX_0083')            -- 仅取0083指标
        SELECT SM.PATH_CODE,                          -- 路径代码
               V_SYSDAT,                              -- 数据日期=跑批日期
               SM.DATA_BLNG,                          -- 数据归属
               SM.STATIS_DIM,                         -- 统计维度
               SM.STATIS_CALIB,                       -- 统计口径
               'INDX_0083',                           -- 指标代码固定0083
               COUNT(DISTINCT C.KAHAOOOO),            -- 计数去重后的卡号（新开卡净增量）
               0,                                     -- 上期值置0
               SM.PERSN_LEGAL_BK_CODE                 -- 法人机构编号
          FROM (SELECT DISTINCT PATH_CODE,            -- 去重：路径
                                 STATIS_CALIB,        -- 口径
                                 STATIS_DIM,          -- 维度
                                 DATA_BLNG,           -- 归属
                                 TERM_BEGIN_DATE,     -- 开始日期
                                 CUST_ID,             -- 客户ID
                                 PERSN_LEGAL_BK_CODE  -- 法人机构
                   FROM SCOPE_ALL) SM                 -- 范围客户去重后结果集
        INNER JOIN CBS_KCDA_PZJCXX C                  -- 关联CBS卡类账户基本信息表
               ON C.KEHUHAOO = SM.CUST_ID             -- 客户好号等于客户ID
              AND CASE                                -- 按发卡机构号段映射法人机构
                    WHEN C.FAKAJIGO LIKE '12%' THEN '1200'  -- 12开头归1200
                    WHEN C.FAKAJIGO LIKE '15%' THEN '1500'  -- 15开头归1500
                    WHEN C.FAKAJIGO LIKE '18%' THEN '1800'  -- 18开头归1800
                    ELSE '9999'                       -- 其他归9999
                  END = SM.PERSN_LEGAL_BK_CODE        -- 映射后的机构等于法人机构编号
              AND C.FAKARIQI BETWEEN SM.TERM_BEGIN_DATE AND V_SYSDAT  -- 发卡日期在开始日期与跑批日期之间（新发卡）
              AND C.PZSYZTAI IN ('0','1','3','4','5','6','D','E','F','K','N','M','j','m','n','h','y')  -- 仅取有效卡状态
        INNER JOIN CBS_KDPA_KEHUZH K                  -- 关联CBS卡片账户客户账表
               ON K.KEHUZHAO = C.KAHAOOOO             -- 客户账号等于卡号
              AND K.ZHHUFENL IN ('1','2')             -- 一类户 二类户
        GROUP BY SM.PATH_CODE,                        -- 按路径分组
                 SM.DATA_BLNG,                        -- 按归属分组
                 SM.STATIS_DIM,                       -- 按维度分组
                 SM.STATIS_CALIB,                     -- 按口径分组
                 SM.PERSN_LEGAL_BK_CODE;              -- 按法人机构分组

    -------------------------------------------------------------------------
    -- 汇总入库收尾：记录影响行数、提交事务、写跑批日志（成功路径）
    -------------------------------------------------------------------------
    outcde := SQL%ROWCOUNT;                                   -- 输出影响行数
    COMMIT;                                                   -- 提交事务
    V_END_DATE := SYSDATE;                                    -- 记录结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算过程耗时（秒）
    V_LOG_MSG := '步骤7处理完成，行数=' || NVL(outcde, 0);             -- 拼装成功日志消息
    V_LOG_FLG := 0;                                           -- 成功标志
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 调用通用跑批日志过程写成功日志
EXCEPTION
    WHEN OTHERS THEN  -- 异常捕获
        -- 异常处理：回滚事务并记录错误日志后重新抛出
        ROLLBACK;                                                 -- 回滚事务
        outcde := -1;                                             -- 输出错误标志
        V_END_DATE := SYSDATE;                                    -- 记录结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 计算耗时
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);                    -- 取错误信息前1000字符
        V_LOG_FLG := -1;                                          -- 失败标志
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 调用通用跑批日志过程写失败日志
        RAISE;                                                    -- 重新抛出异常
END PRC_ADS_STAT_INDX_PLAN_007;