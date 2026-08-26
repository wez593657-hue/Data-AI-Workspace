-------------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_009
-- 功能说明: 指标数据统计——步骤9（手机银行/一码付交易金额与笔数指标汇总）
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER    输出（结果行数/标志）
-- 需求版本: v5.2 (2026-08-26)
-- 变更记录:
--   v5.2 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v5.0 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_009，段首自清（并行跑批隔离）
--   v5.1 0078/0079支付退款区分：金额净额化(01退款取负)，笔数含退款单；ORDER_TYPE IN('00','01')
-------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_009
(
    V_SYSDAT  IN VARCHAR2,                     -- 跑批业务日期 YYYYMMDD
    OUTCDE OUT INTEGER  -- 输出：写入行数
) AS
    V_PRC_DESC   VARCHAR2(100) := '指标数据统计步骤99处理完成 9';  -- 过程描述（写入步骤日志；文本中'步骤99'与过程号009不一致【待确认】）
    V_PRC_NAME   VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_009';   -- 过程名
    V_LOG_MSG    VARCHAR2(4000);                       -- 日志消息内容
    V_LOG_FLG    INTEGER;                              -- 日志标志（0正常 -1异常）
    V_LOG_BUTTON INTEGER := 1;                         -- 日志按钮标识（固定1）
    V_NO_ID      VARCHAR2(10);                         -- 业务流水号（固定'0'）
    V_BGN_DATE   DATE;                                 -- 过程起始时间
    V_END_DATE   DATE;                                 -- 过程结束时间
    V_DURA_DATE  INTEGER;                              -- 运行耗时（秒）
BEGIN
    -------------------------------------------------------------------------
    -- 运行变量初始化与入参校验
    -------------------------------------------------------------------------
    V_NO_ID := '0';                                                -- 业务流水号（固定 '0'）【待确认：取值与用途】
    V_BGN_DATE := SYSDATE;                                         -- 过程起始时间
    IF V_SYSDAT IS NULL OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$') THEN  -- 校验入参必须为8位数字日期
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 不合法则抛错
    END IF;
    V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');  -- 跑批业务日期转 DATE

    -------------------------------------------------------------------------
    -- 段首自清：清空本过程专属汇总临时表，防止重跑/并行跑批残留
    -------------------------------------------------------------------------
    DELETE FROM TMP_STAT_INDX_AGGR_009;

    -------------------------------------------------------------------------
    -- 0074/0075：手机银行交易金额/笔数 (合并 A/B 路径)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_009
    (
        PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
        DATA_DATE,      -- 数据日期
        DATA_BLNG,      -- 数据归属
        STATIS_DIM,     -- 统计维度
        STATIS_CALIB,   -- 统计口径
        INDX_CODE,      -- 指标编码
        CURNT_VAL,      -- 当前值
        TERM_LAST_VAL,  -- 期初/上期值
        PERSN_LEGAL_BK_CODE  -- 法人机构编码
    )
    WITH SCOPE_ALL AS
    (
        -- 统一获取 A/B 路径的目标客户范围
        SELECT '08'           AS PATH_CODE,                          -- 路径标识：08=营销活动
               '08'      AS STATIS_CALIB,                         -- 统计口径：营销活动
               S.STATIS_DIM,                                        -- 统计维度
               S.DATA_BLNG,                                         -- 数据归属
               S.TERM_BEGIN_DATE,                                   -- 本期起始日期（统计起点）
               TI.CUST_ID,                                          -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE                                -- 法人机构编码
          FROM TMP_STAT_INDX_SCOPE S                                -- 目标客户范围表
         INNER JOIN DWD_MKT_TSK_INFO TI                             -- 营销任务信息
                 ON TI.MKT_ACT_ID = S.STATIS_DIM                    -- 营销活动ID匹配维度
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构匹配
                AND TI.DATA_DATE = V_SYSDAT                         -- 取跑批日营销任务快照
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)   -- 归属O：按营销人员机构匹配
                     OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))   -- 归属M：按营销人员匹配
         WHERE S.PATH_CODE = '08'                                    -- 仅路径08（营销活动）
           AND S.INDX_CODE IN ('INDX_0074', 'INDX_0075')            -- 仅0074/0075指标
        UNION ALL
        SELECT '09'           AS PATH_CODE,   -- 路径标识：09=目标任务
               '09'      AS STATIS_CALIB,  -- 统计口径：目标任务
               S.STATIS_DIM,                 -- 统计维度
               S.DATA_BLNG,                  -- 数据归属
               S.TERM_BEGIN_DATE,            -- 本期起始日期
               LV.CUST_ID,                   -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE         -- 法人机构编码
          FROM TMP_STAT_INDX_SCOPE S         -- 目标客户范围表
         INNER JOIN DWS_CUST_LVL_INFO LV     -- 客户层级信息
                 ON S.BLNG_TYPE = 'O'        -- 仅归属O（机构）
                AND LV.ORG_ID = S.BLNG_ID    -- 机构ID匹配归属
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                AND LV.DATA_DATE = V_SYSDAT  -- 取跑批日层级快照
         WHERE S.PATH_CODE = '09'             -- 仅路径09
           AND S.INDX_CODE IN ('INDX_0074', 'INDX_0075')   -- 仅0074/0075指标
        UNION ALL
        SELECT '09'           AS PATH_CODE,       -- 路径标识：09=目标任务
               '09'      AS STATIS_CALIB,      -- 统计口径：目标任务
               S.STATIS_DIM,                     -- 统计维度
               S.DATA_BLNG,                      -- 数据归属
               S.TERM_BEGIN_DATE,                -- 本期起始日期
               CM.CUST_ID,                       -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE             -- 法人机构编码
          FROM TMP_STAT_INDX_SCOPE S             -- 目标客户范围表
         INNER JOIN DWD_CUST_MAN CM              -- 客户经理信息
                 ON S.BLNG_TYPE = 'M'            -- 仅归属M（管户）
                AND CM.MNGR_POST_ID = S.BLNG_ID  -- 管户岗ID匹配归属
                AND CM.MNG_TYP = '1'             -- 客户经理类型=1
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
         WHERE S.PATH_CODE = '09'                 -- 仅路径09
           AND S.INDX_CODE IN ('INDX_0074', 'INDX_0075')   -- 仅0074/0075指标
    ),
    SCOPE_DISTINCT AS
    (
        -- 按维度去重后的目标客户范围
        SELECT DISTINCT PATH_CODE,        -- 路径标识
                        STATIS_CALIB,     -- 统计口径
                        STATIS_DIM,       -- 统计维度
                        DATA_BLNG,        -- 数据归属
                        TERM_BEGIN_DATE,  -- 本期起始日期
                        CUST_ID,          -- 客户ID
                        PERSN_LEGAL_BK_CODE   -- 法人机构编码
          FROM SCOPE_ALL
    ),
    MBK_BASE AS
    (
        -- 预关联客户基础信息，避免后续 10 个交易表重复 JOIN
        SELECT SC.PATH_CODE,        -- 路径标识
               SC.STATIS_CALIB,     -- 统计口径
               SC.STATIS_DIM,       -- 统计维度
               SC.DATA_BLNG,        -- 数据归属
               SC.PERSN_LEGAL_BK_CODE,  -- 法人机构编码
               SC.TERM_BEGIN_DATE,  -- 本期起始日期
               MI.CUST_NO           -- 手机银行客户号
          FROM SCOPE_DISTINCT SC
         INNER JOIN MBK_CUST_INFO MI                       -- 手机银行客户信息
                 ON MI.CUST_CORE_NO = SC.CUST_ID           -- 核心客户号匹配客户ID
                AND MI.INCORP_NO = SC.PERSN_LEGAL_BK_CODE  -- 法人机构匹配
         INNER JOIN DWD_CUST_INDV_INFO CI                  -- 客户个体信息
                 ON CI.CUST_ID = SC.CUST_ID                -- 客户ID匹配
                AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
    ),
    MBK_TRANS_ALL AS
    (
        -- 商圈
        SELECT B.PATH_CODE,                           -- 路径标识
               B.STATIS_CALIB,                        -- 统计口径
               B.STATIS_DIM,                          -- 统计维度
               B.DATA_BLNG,                           -- 数据归属
               B.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
               Y.AMT     AS TRAN_AMT,                 -- 商圈交易金额
               1         AS TRAN_NUM                  -- 商圈交易笔数（固定 1）
          FROM MBK_BASE B                             -- 复用客户基础信息
         INNER JOIN MBK_CUST_ACCT CA ON CA.CUST_NO = B.CUST_NO   -- 手机银行客户账户：按客户号关联
         INNER JOIN IBP_IB_LIST_PLAT Y                -- 平台交易流水
                 ON Y.ACCT_NO = CA.ACCT               -- 账号匹配账户
                AND Y.ITEM_ID = '100015'              -- 场景ID：商圈
                AND Y.CHANNEL_ID = '3031'             -- 渠道=3031（手机银行）
                AND Y.PLAT_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND CASE SUBSTR(Y.BRANCH_CODE, 1, 2)  -- 机构前两位折算核算机构
                        WHEN '12' THEN '1200'
                        WHEN '15' THEN '1500'
                        WHEN '18' THEN '1800'
                        ELSE '9999'
                    END = B.PERSN_LEGAL_BK_CODE
        UNION ALL
        -- 酷屏
        SELECT B.PATH_CODE,                           -- 路径标识
               B.STATIS_CALIB,                        -- 统计口径
               B.STATIS_DIM,                          -- 统计维度
               B.DATA_BLNG,                           -- 数据归属
               B.PERSN_LEGAL_BK_CODE,                 -- 法人机构编码
               Y.AMT,                                 -- 酷屏交易金额
               1                                      -- 交易笔数（固定1）
          FROM MBK_BASE B                             -- 复用客户基础信息
         INNER JOIN MBK_CUST_ACCT CA ON CA.CUST_NO = B.CUST_NO   -- 手机银行客户账户：按客户号关联
         INNER JOIN IBP_IB_LIST_PLAT Y                -- 平台交易流水
                 ON Y.ACCT_NO = CA.ACCT               -- 账号匹配账户
                AND Y.ITEM_ID = '100012'              -- 场景ID：酷屏
                AND Y.CHANNEL_ID = '3031'             -- 渠道=3031（手机银行）
                AND Y.SETTLE_CD_FLAG = 'D'            -- 结算码标志=D
                AND Y.PLAT_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND CASE SUBSTR(Y.BRANCH_CODE, 1, 2)  -- 机构前两位折算核算机构
                        WHEN '12' THEN '1200'
                        WHEN '15' THEN '1500'
                        WHEN '18' THEN '1800'
                        ELSE '9999'
                    END = B.PERSN_LEGAL_BK_CODE
        UNION ALL
        -- 转账
        SELECT B.PATH_CODE,                -- 路径标识
               B.STATIS_CALIB,             -- 统计口径
               B.STATIS_DIM,               -- 统计维度
               B.DATA_BLNG,                -- 数据归属
               B.PERSN_LEGAL_BK_CODE,      -- 法人机构编码
               T.TRAN_AMT,                 -- 转账交易金额
               1                           -- 交易笔数（固定1）
          FROM MBK_BASE B                  -- 复用客户基础信息
         INNER JOIN MBK_CUST_LOG_TRAN T    -- 转账交易流水
                 ON T.CUST_NO = B.CUST_NO  -- 按客户号关联
                AND T.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND T.TRAN_STATUS = '1'    -- 交易状态=1（成功）
                AND NVL(T.TRAN_AMT, 0) <> 0-- 排除交易金额为空的记录
        UNION ALL
        -- 理财
        SELECT B.PATH_CODE,                 -- 路径标识
               B.STATIS_CALIB,              -- 统计口径
               B.STATIS_DIM,                -- 统计维度
               B.DATA_BLNG,                 -- 数据归属
               B.PERSN_LEGAL_BK_CODE,       -- 法人机构编码
               F.TRAN_AMT,                  -- 理财交易金额
               1                            -- 交易笔数（固定1）
          FROM MBK_BASE B                   -- 复用客户基础信息
         INNER JOIN MBK_CUST_LOG_FINANCE F  -- 理财交易流水
                 ON F.CUST_NO = B.CUST_NO   -- 按客户号关联
                AND F.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND F.TRAN_STATUS = '1'     -- 交易状态=1（成功）
                AND NVL(F.TRAN_AMT, 0) <> 0 -- 排除交易金额为空的记录
        UNION ALL
        -- 生活缴费
        SELECT B.PATH_CODE,                                     -- 路径标识
               B.STATIS_CALIB,                                  -- 统计口径
               B.STATIS_DIM,                                    -- 统计维度
               B.DATA_BLNG,                                     -- 数据归属
               B.PERSN_LEGAL_BK_CODE,                           -- 法人机构编码
               CAST(NULLIF(F.TRAN_AMT, '') AS DECIMAL(31, 2)),  -- 缴费金额（空串转 NULL 再转 DECIMAL）
               1                                                -- 交易笔数（固定1）
          FROM MBK_BASE B                                       -- 复用客户基础信息
         INNER JOIN MBK_CUST_LOG_FEE F                          -- 生活缴费交易流水
                 ON F.CUST_NO = B.CUST_NO                       -- 按客户号关联
                AND F.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND F.TRAN_STATUS = '1'                         -- 交易状态=1（成功）
                AND NVL(CAST(NULLIF(F.TRAN_AMT, '') AS DECIMAL(31, 2)), 0) <> 0   -- 排除金额为空记录
                AND CASE SUBSTR(F.DEPT_ID, 1, 2)                -- 机构前两位折算核算机构
                        WHEN '12' THEN '1200'
                        WHEN '15' THEN '1500'
                        WHEN '18' THEN '1800'
                        ELSE '9999'
                    END = B.PERSN_LEGAL_BK_CODE
        UNION ALL
        -- 无卡预约取款
        SELECT B.PATH_CODE,                              -- 路径标识
               B.STATIS_CALIB,                           -- 统计口径
               B.STATIS_DIM,                             -- 统计维度
               B.DATA_BLNG,                              -- 数据归属
               B.PERSN_LEGAL_BK_CODE,                    -- 法人机构编码
               CAST(NULLIF(O.TRAN_AMT, '') AS DECIMAL(31, 2)),   -- 取款交易金额
               1                                         -- 交易笔数（固定1）
          FROM MBK_BASE B                                -- 复用客户基础信息
         INNER JOIN MBK_CUST_LOG_OPER O                  -- 手机银行操作流水（无卡取款）
                 ON O.CUST_NO = B.CUST_NO                -- 按客户号关联
                AND O.TRAN_CODE = 'atm/noCardPredMoney'  -- 交易码：无卡预约取款
                AND O.TRAN_STATUS = '1'                  -- 交易状态=1（成功）
                AND O.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
        UNION ALL
        -- 扫码取款
        SELECT B.PATH_CODE,                    -- 路径标识
               B.STATIS_CALIB,                 -- 统计口径
               B.STATIS_DIM,                   -- 统计维度
               B.DATA_BLNG,                    -- 数据归属
               B.PERSN_LEGAL_BK_CODE,          -- 法人机构编码
               CAST(NULLIF(P.SENCE_VALUE, '') AS DECIMAL(31, 2)),   -- 扫码取款交易金额
               1                               -- 交易笔数（固定1）
          FROM MBK_BASE B                      -- 复用客户基础信息
         INNER JOIN MBK_MKP_PROCESS_INFO P     -- 移动营销扫码取款处理信息
                 ON P.CUST_NO = B.CUST_NO      -- 按客户号关联
                AND P.TRANS_SN NOT LIKE 'AP%'  -- 排除预约类（AP开头）流水
                AND LENGTH(P.TRANS_SN) > 18    -- 流水号长度>18（区分真实交易）
                AND P.SENCE_TIME BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易时间在本期区间
        UNION ALL
        -- 存款/乐惠存
        SELECT B.PATH_CODE,                   -- 路径标识
               B.STATIS_CALIB,                -- 统计口径
               B.STATIS_DIM,                  -- 统计维度
               B.DATA_BLNG,                   -- 数据归属
               B.PERSN_LEGAL_BK_CODE,         -- 法人机构编码
               B2.TRAN_AMT,                   -- 存款/乐惠存交易金额
               1                              -- 交易笔数（固定1）
          FROM MBK_BASE B                     -- 复用客户基础信息
         INNER JOIN MBK_CUST_LOG_BASE_FINANCE B2   -- 基础金融产品交易流水（存款类）
                 ON B2.CUST_NO = B.CUST_NO    -- 按客户号关联
                AND B2.TRAN_STATUS = '1'      -- 交易状态=1（成功）
                AND B2.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND NVL(B2.TRAN_AMT, 0) <> 0  -- 排除交易金额为空的记录
        UNION ALL
        -- 贷款
        SELECT B.PATH_CODE,                                        -- 路径标识
               B.STATIS_CALIB,                                     -- 统计口径
               B.STATIS_DIM,                                       -- 统计维度
               B.DATA_BLNG,                                        -- 数据归属
               B.PERSN_LEGAL_BK_CODE,                              -- 法人机构编码
               CAST(NULLIF(L.BUSINESSSUM, '') AS DECIMAL(31, 2)),  -- 贷款业务金额（空串转NULL再转DECIMAL）
               1                                                   -- 交易笔数（固定1）
          FROM MBK_BASE B                                          -- 复用客户基础信息
         INNER JOIN MBK_CUST_LOG_LOAN L                            -- 贷款交易流水
                 ON L.CUST_NO = B.CUST_NO                          -- 按客户号关联
                AND L.TRAN_DATE BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易日期在本期区间
                AND NVL(CAST(NULLIF(L.BUSINESSSUM, '') AS DECIMAL(31, 2)), 0) <> 0   -- 排除金额为空记录
        UNION ALL
        -- 移动支付
        SELECT B.PATH_CODE,                                    -- 路径标识
               B.STATIS_CALIB,                                 -- 统计口径
               B.STATIS_DIM,                                   -- 统计维度
               B.DATA_BLNG,                                    -- 数据归属
               B.PERSN_LEGAL_BK_CODE,                          -- 法人机构编码
               CAST(NULLIF(Q.TXN_AMT, '') AS DECIMAL(31, 2)),  -- 移动支付交易金额
               1                                               -- 交易笔数（固定1）
          FROM MBK_BASE B                                      -- 复用客户基础信息
         INNER JOIN MBK_QR_C2B_QUERYTRANS Q                    -- 扫码(C2B)交易查询流水
                 ON Q.CUST_NO = B.CUST_NO                      -- 按客户号关联
                AND Q.STATUS = '1'                             -- 交易状态=1（成功）
                AND Q.ORDERTIME BETWEEN B.TERM_BEGIN_DATE AND V_SYSDAT   -- 交易时间在本期区间
                AND NVL(CAST(NULLIF(Q.TXN_AMT, '') AS DECIMAL(31, 2)), 0) <> 0   -- 排除金额为空记录
    )
    SELECT PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
           V_SYSDAT,       -- 数据日期（跑批业务日期）
           DATA_BLNG,      -- 数据归属
           STATIS_DIM,     -- 统计维度
           STATIS_CALIB,   -- 统计口径
           'INDX_0074',    -- 金额指标
           SUM(TRAN_AMT),  -- 交易金额合计
           0,              -- 期初/上期值（本期无上期对照）
           PERSN_LEGAL_BK_CODE  -- 法人机构编码
      FROM MBK_TRANS_ALL
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE
    UNION ALL
    SELECT PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
           V_SYSDAT,       -- 数据日期（跑批业务日期）
           DATA_BLNG,      -- 数据归属
           STATIS_DIM,     -- 统计维度
           STATIS_CALIB,   -- 统计口径
           'INDX_0075',    -- 笔数指标
           SUM(TRAN_NUM),  -- 交易笔数合计
           0,              -- 期初/上期值（本期无上期对照）
           PERSN_LEGAL_BK_CODE  -- 法人机构编码
      FROM MBK_TRANS_ALL
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- 0078/0079：一码付交易金额/笔数 (合并 A/B 路径)
    -------------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_009
    (
        PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
        DATA_DATE,      -- 数据日期
        DATA_BLNG,      -- 数据归属
        STATIS_DIM,     -- 统计维度
        STATIS_CALIB,   -- 统计口径
        INDX_CODE,      -- 指标编码
        CURNT_VAL,      -- 当前值
        TERM_LAST_VAL,  -- 期初/上期值
        PERSN_LEGAL_BK_CODE  -- 法人机构编码
    )
    WITH SCOPE_ALL AS
    (
        -- 统一获取 A/B 路径的目标客户范围
        SELECT '08'           AS PATH_CODE,                          -- 路径标识：08=营销活动
               '08'      AS STATIS_CALIB,                         -- 统计口径：营销活动
               S.STATIS_DIM,                                        -- 统计维度
               S.DATA_BLNG,                                         -- 数据归属
               S.TERM_BEGIN_DATE,                                   -- 本期起始日期（统计起点）
               TI.CUST_ID,                                          -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE                                -- 法人机构编码
          FROM TMP_STAT_INDX_SCOPE S                                -- 目标客户范围表
         INNER JOIN DWD_MKT_TSK_INFO TI                             -- 营销任务信息
                 ON TI.MKT_ACT_ID = S.STATIS_DIM                    -- 营销活动ID匹配维度
                AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE  -- 法人机构匹配
                AND TI.DATA_DATE = V_SYSDAT                         -- 取跑批日营销任务快照
                AND ((S.BLNG_TYPE = 'O' AND TI.MKT_PERSN_ORG = S.BLNG_ID)   -- 归属O：按营销人员机构匹配
                     OR (S.BLNG_TYPE = 'M' AND TI.MKT_PERSN = S.BLNG_ID))   -- 归属M：按营销人员匹配
         WHERE S.PATH_CODE = '08'                                    -- 仅路径08（营销活动）
           AND S.INDX_CODE IN ('INDX_0078', 'INDX_0079')            -- 仅0078/0079指标
        UNION ALL
        SELECT '09'           AS PATH_CODE,   -- 路径标识：09=目标任务
               '09'      AS STATIS_CALIB,  -- 统计口径：目标任务
               S.STATIS_DIM,                 -- 统计维度
               S.DATA_BLNG,                  -- 数据归属
               S.TERM_BEGIN_DATE,            -- 本期起始日期
               LV.CUST_ID,                   -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE         -- 法人机构编码
          FROM TMP_STAT_INDX_SCOPE S         -- 目标客户范围表
         INNER JOIN DWS_CUST_LVL_INFO LV     -- 客户层级信息
                 ON S.BLNG_TYPE = 'O'        -- 仅归属O（机构）
                AND LV.ORG_ID = S.BLNG_ID    -- 机构ID匹配归属
                AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                AND LV.DATA_DATE = V_SYSDAT  -- 取跑批日层级快照
         WHERE S.PATH_CODE = '09'             -- 仅路径09
           AND S.INDX_CODE IN ('INDX_0078', 'INDX_0079')   -- 仅0078/0079指标
        UNION ALL
        SELECT '09'           AS PATH_CODE,       -- 路径标识：09=目标任务
               '09'      AS STATIS_CALIB,      -- 统计口径：目标任务
               S.STATIS_DIM,                     -- 统计维度
               S.DATA_BLNG,                      -- 数据归属
               S.TERM_BEGIN_DATE,                -- 本期起始日期
               CM.CUST_ID,                       -- 目标客户ID
               S.PERSN_LEGAL_BK_CODE             -- 法人机构编码
          FROM TMP_STAT_INDX_SCOPE S             -- 目标客户范围表
         INNER JOIN DWD_CUST_MAN CM              -- 客户经理信息
                 ON S.BLNG_TYPE = 'M'            -- 仅归属M（管户）
                AND CM.MNGR_POST_ID = S.BLNG_ID  -- 管户岗ID匹配归属
                AND CM.MNG_TYP = '1'             -- 客户经理类型=1
                AND CM.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
         WHERE S.PATH_CODE = '09'                 -- 仅路径09
           AND S.INDX_CODE IN ('INDX_0078', 'INDX_0079')   -- 仅0078/0079指标
    ),
    ACQ_TRANS AS
    (
        -- 一码付收单交易（00 支付 / 01 退款）
        SELECT SC.PATH_CODE,                         -- 路径标识
               SC.STATIS_CALIB,                      -- 统计口径
               SC.STATIS_DIM,                        -- 统计维度
               SC.DATA_BLNG,                         -- 数据归属
               SC.PERSN_LEGAL_BK_CODE,               -- 法人机构编码
               CASE WHEN O.ORDER_TYPE = '01' THEN -O.ORDER_AMT ELSE O.ORDER_AMT END AS TRAN_AMT,   -- 01退款取负，00支付为正（金额净额化）
               1                                                                        AS TRAN_NUM   -- 交易笔数（固定1）
          FROM (SELECT DISTINCT PATH_CODE,           -- 路径标识
                                STATIS_CALIB,        -- 统计口径
                                STATIS_DIM,          -- 统计维度
                                DATA_BLNG,           -- 数据归属
                                TERM_BEGIN_DATE,     -- 本期起始日期
                                CUST_ID,             -- 客户ID
                                PERSN_LEGAL_BK_CODE  -- 法人机构编码
                  FROM SCOPE_ALL) SC
         INNER JOIN DWD_CUST_INDV_INFO CI                           -- 客户个体信息
                 ON CI.CUST_ID = SC.CUST_ID                         -- 客户ID匹配
                AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE -- 法人机构匹配
         INNER JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA                  -- 一码付商户结算账户
                 ON SA.CUST_NO = SC.CUST_ID                         -- 按客户号关联
                AND SA.STATUS <> '9'                                -- 排除关闭状态（状态9=注销【待确认】）
         INNER JOIN UEPP_PAY_MCT_INFO M                             -- 一码付商户信息
                 ON M.MCT_ID = SA.MCT_ID                            -- 商户ID匹配结算账户
                AND M.MCT_TYPE IN ('personage', 'smallBusinesses')  -- 仅个人/小微商户
                AND M.STATUS <> '9'                                 -- 排除关闭状态（状态9=注销【待确认】）
         INNER JOIN UEPP_PAY_ORDER_INFO O                           -- 一码付订单信息
                 ON O.MCT_ID = SA.MCT_ID                            -- 商户ID匹配
                AND O.STATUS = '02'                                 -- 订单状态=02（已支付/成功）
                AND O.ORDER_TYPE IN ('00', '01')                    -- 00支付 01退款（值域仅此两值）
                AND O.PAY_TIME BETWEEN SC.TERM_BEGIN_DATE AND V_SYSDAT   -- 支付时间在本期区间
    )
    SELECT PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
           V_SYSDAT,       -- 数据日期（跑批业务日期）
           DATA_BLNG,      -- 数据归属
           STATIS_DIM,     -- 统计维度
           STATIS_CALIB,   -- 统计口径
           'INDX_0078',    -- 金额指标
           SUM(TRAN_AMT),  -- 一码付交易金额净额合计（退款为负）
           0,              -- 期初/上期值（本期无上期对照）
           PERSN_LEGAL_BK_CODE  -- 法人机构编码
      FROM ACQ_TRANS
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE
    UNION ALL
    SELECT PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
           V_SYSDAT,       -- 数据日期（跑批业务日期）
           DATA_BLNG,      -- 数据归属
           STATIS_DIM,     -- 统计维度
           STATIS_CALIB,   -- 统计口径
           'INDX_0079',    -- 笔数指标
           SUM(TRAN_NUM),  -- 一码付交易笔数合计（含退款单）
           0,              -- 期初/上期值（本期无上期对照）
           PERSN_LEGAL_BK_CODE  -- 法人机构编码
      FROM ACQ_TRANS
     GROUP BY PATH_CODE,
              DATA_BLNG,
              STATIS_DIM,
              STATIS_CALIB,
              PERSN_LEGAL_BK_CODE;

    -------------------------------------------------------------------------
    -- 返回本次写入行数并提交
    -------------------------------------------------------------------------
    OUTCDE := SQL%ROWCOUNT;  -- 取最后一条 DML（0078/0079 写入）的影响行数
    COMMIT;

    -------------------------------------------------------------------------
    -- 记录本步骤执行日志
    -------------------------------------------------------------------------
    V_END_DATE := SYSDATE;                                    -- 过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 运行耗时（秒）
    V_LOG_MSG := '步骤9处理完成，行数=' || NVL(OUTCDE, 0);             -- 组装成功日志消息
    V_LOG_FLG := 0;                                           -- 日志标志置成功
    SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON); -- 记录步骤执行日志
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        OUTCDE := -1;                                             -- 异常以 -1 标识失败
        V_END_DATE := SYSDATE;                                    -- 过程结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 运行耗时（秒）
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);                    -- 异常信息截断记录
        V_LOG_FLG := -1;                                          -- 日志标志置失败
        SYS_PRC_STEP_LOGS(V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON); -- 记录错误日志
        RAISE;                                                    -- 重新抛出异常
END PRC_ADS_STAT_INDX_PLAN_009;