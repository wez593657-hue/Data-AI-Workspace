--------------------------------------------------------------------
-- 存储过程: CRMDM.PRC_ADS_STAT_INDX_PLAN_008
-- 功能说明: 指标数据统计——步骤8：0081/0069 留存率、0066 不良贷款率计算
-- 参数说明:
--   V_SYSDAT IN  VARCHAR2   跑批业务日期 YYYYMMDD
--   OUTCDE   OUT INTEGER     输出（写入行数）
-- 需求版本: v5.2 (2026-08-26)
-- 变更记录:
--   v5.2 路径编码A/B改为08/09（营销任务=08，目标任务=09），statis_calib同步编号，PATH_CODE类型扩VARCHAR(2)
--   v5.0 AGGR汇总表拆分：写入专属表 TMP_STAT_INDX_AGGR_008，段首自清（并行跑批隔离）
--   v5.1 0081/0069分母净额化：ORDER_TYPE='01'退款取负，'00'支付为正；>=500阈值按净额
--------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CRMDM.PRC_ADS_STAT_INDX_PLAN_008
(
    V_SYSDAT  IN VARCHAR2, -- 跑批业务日期 YYYYMMDD
    OUTCDE    OUT INTEGER  -- 输出：写入行数
) AS
    V_PRC_DESC VARCHAR2(100) := '指标数据统计步骤88处理完成 8';   -- 过程描述（写入步骤日志）
    V_PRC_NAME VARCHAR2(32)  := 'PRC_ADS_STAT_INDX_PLAN_008';   -- 过程名
    V_LOG_MSG VARCHAR2(4000);   -- 日志消息内容
    V_LOG_FLG INTEGER;          -- 日志标志（0正常 -1异常）
    V_LOG_BUTTON INTEGER := 1;  -- 日志按钮标识（固定1）
    V_NO_ID VARCHAR2(10);       -- 业务流水号（固定'0'）
    V_BGN_DATE DATE;            -- 过程起始时间
    V_END_DATE DATE;            -- 过程结束时间
    V_DURA_DATE INTEGER;        -- 运行耗时（秒）
    V_YAR_BEGIN VARCHAR2(8);    -- 当年年初
    V_DAY_END   VARCHAR2(20);   -- 业务日当日末（含时分秒上限）
BEGIN
    V_NO_ID := '0';  -- 业务流水号（固定'0'）
    V_BGN_DATE := SYSDATE;       -- 过程起始时间

    -- 入参校验：V_SYSDAT 必须为 8 位数字日期
    IF v_sysdat IS NULL OR NOT REGEXP_LIKE(v_sysdat, '^[0-9]{8}$') THEN   -- 校验入参必须为8位数字日期
        RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT必须为YYYYMMDD格式');  -- 不合法则抛错
    END IF;

    V_END_DATE := TO_DATE(v_sysdat, 'YYYYMMDD');  -- 跑批业务日期转 DATE

    ---------------------------------------------------------------------
    /* * 过程名 : crmdm.prc_ads_stat_indx_plan_008
      * 业务   : 一码付留存率（客户维度）
      *          INDX_0081  AUM留存率     = 年日均AUM  * 100 / 年累计交易量
      *          INDX_0069  结算存款留存率 = 年日均存款 * 100 / 年累计交易量
      * 口径   : 客户级年累计交易(00/02) >= 500 元纳入统计
      *          pay_time 为 VARCHAR2(20) 带时分秒，采用区间比较以命中索引
      **/

    ---------------------------------------------------------------------
    -- 0. 日期边界初始化
    ---------------------------------------------------------------------
    V_YAR_BEGIN := SYS_FUN_DEAL_DATE(V_SYSDAT, 13);     -- 当年年初
    V_DAY_END   := V_SYSDAT || '999999';  -- 业务日当日末（含时分秒上限）

    -- 段首自清：本过程专属汇总临时表，防止重跑/并行残留
    DELETE FROM TMP_STAT_INDX_AGGR_008;

    ---------------------------------------------------------------------
    -- 1. 0081 / 0069 合并产出：A/B 路径一次扫描，两指标共享宽表
    ---------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_008
        (PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
         DATA_DATE,      -- 数据日期
         DATA_BLNG,      -- 数据归属
         STATIS_DIM,     -- 统计维度
         STATIS_CALIB,   -- 统计口径
         INDX_CODE,      -- 指标编码
         CURNT_VAL,      -- 当前值
         TERM_LAST_VAL,  -- 期初/上期值
         PERSN_LEGAL_BK_CODE)       -- 法人机构编码
    WITH SCOPE_ALL AS
     (
        /*                                                                -- 目标客户范围：A=营销活动  B=机构/管户 --*/
        SELECT '08'                  AS PATH_CODE,                         -- 路径标识：08=营销活动
               '08'          AS STATIS_CALIB,                           -- 统计口径：营销活动
               S.STATIS_DIM,                                              -- 统计维度
               S.DATA_BLNG,                                               -- 数据归属
               S.PERSN_LEGAL_BK_CODE,                                     -- 法人机构编码
               TI.CUST_ID                                                 -- 目标客户ID
          FROM TMP_STAT_INDX_SCOPE S                                      -- 目标客户范围表
          JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID         = S.STATIS_DIM-- 营销任务关联：营销活动ID匹配维度
                                  AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                  AND TI.DATA_DATE           = V_SYSDAT   -- 取跑批日营销任务快照
                                  AND ((S.BLNG_TYPE = 'O' AND             -- 归属类型O：按营销人员机构匹配
                                        TI.MKT_PERSN_ORG = S.BLNG_ID) OR  -- 营销人员机构编码=归属机构（O分支）
                                        (S.BLNG_TYPE = 'M' AND            -- 归属类型M：按营销人员匹配
                                        TI.MKT_PERSN = S.BLNG_ID))        -- 营销人员编码=归属ID（M分支）
         WHERE S.PATH_CODE = '08'                                          -- 仅路径08（营销活动）
           AND S.INDX_CODE IN ('INDX_0081', 'INDX_0069')                  -- 仅0081/0069指标
        UNION ALL
        SELECT '09',                                                      -- 路径标识：B=目标任务
               '09',                                                   -- 统计口径：目标任务
               S.STATIS_DIM,                                             -- 统计维度
               S.DATA_BLNG,                                              -- 数据归属
               S.PERSN_LEGAL_BK_CODE,                                    -- 法人机构编码
               LV.CUST_ID                                                -- 目标客户ID
          FROM TMP_STAT_INDX_SCOPE S                                     -- 目标客户范围表
          JOIN DWS_CUST_LVL_INFO LV ON LV.ORG_ID            = S.BLNG_ID  -- 客户层级信息：机构ID匹配归属
                                    AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                    AND LV.DATA_DATE           = V_SYSDAT-- 取跑批日层级快照
         WHERE S.PATH_CODE = '09'                                         -- 仅路径09
           AND S.BLNG_TYPE = 'O'                                         -- 仅归属O（机构）
           AND S.INDX_CODE IN ('INDX_0081', 'INDX_0069')                 -- 仅0081/0069指标
        UNION ALL
        SELECT '09',                                         -- 路径标识：B=目标任务
               '09',                                      -- 统计口径：目标任务
               S.STATIS_DIM,                                -- 统计维度
               S.DATA_BLNG,                                 -- 数据归属
               S.PERSN_LEGAL_BK_CODE,                       -- 法人机构编码
               CM.CUST_ID                                   -- 目标客户ID
          FROM TMP_STAT_INDX_SCOPE S                        -- 目标客户范围表
          JOIN DWD_CUST_MAN CM ON CM.MNGR_POST_ID          = S.BLNG_ID       -- 客户经理信息：管户岗ID匹配归属
                              AND CM.MNG_TYP = '1'          -- 客户经理类型=1
                              AND CM.PERSN_LEGAL_BK_CODE    = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
         WHERE S.PATH_CODE = '09'                            -- 仅路径09
           AND S.BLNG_TYPE = 'M'                            -- 仅归属M（管户）
           AND S.INDX_CODE IN ('INDX_0081', 'INDX_0069')),  -- 仅0081/0069指标
     CUST_MCT AS
     (
        /*                                                                -- 客户 → 一码付商户：先去重到(客户,商户)对，防多结算账号膨胀 --*/
        SELECT DISTINCT SC.PATH_CODE,                                     -- 路径标识
                        SC.STATIS_CALIB,                                  -- 统计口径
                        SC.STATIS_DIM,                                    -- 统计维度
                        SC.DATA_BLNG,                                     -- 数据归属
                        SC.PERSN_LEGAL_BK_CODE,                           -- 法人机构编码
                        SC.CUST_ID,                                       -- 客户ID
                        M.MCT_ID                                          -- 一码付商户ID
          FROM (SELECT DISTINCT PATH_CODE,                                -- 先对范围去重
                                STATIS_CALIB,                             -- 统计口径
                                STATIS_DIM,                               -- 统计维度
                                DATA_BLNG,                                -- 数据归属
                                PERSN_LEGAL_BK_CODE,                      -- 法人机构编码
                                CUST_ID                                   -- 客户ID
                  FROM SCOPE_ALL) SC                                      -- 目标客户范围
          JOIN DWD_CUST_INDV_INFO CI ON CI.CUST_ID            = SC.CUST_ID-- 客户个体信息
                                    AND CI.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
          JOIN UEPP_PAY_MCT_SETTLE_ACCOUNT SA ON SA.CUST_NO = SC.CUST_ID  -- 一码付商户结算账户：客户号匹配
                                           AND SA.STATUS <> '9'           -- 排除无效（9）结算账户
          JOIN UEPP_PAY_MCT_INFO M ON M.MCT_ID      = SA.MCT_ID           -- 一码付商户信息
                                  AND M.MCT_TYPE IN ('personage', 'smallBusinesses')   -- 仅个人/小商户
                                  AND M.STATUS <> '9'),                   -- 排除无效（9）商户
     MCT_TX AS
     (
        /*              -- 商户年累计交易量预聚合：先按 mct_id 压缩订单明细 --*/
        SELECT MCT_ID,  -- 一码付商户ID
               SUM(CASE WHEN ORDER_TYPE = '01' THEN -ORDER_AMT ELSE ORDER_AMT END) AS ANNUAL_TX_AMT  -- 净额：01退款取负
          FROM UEPP_PAY_ORDER_INFO
         WHERE ORDER_TYPE IN ('00', '01')   -- 订单类型 00-支付交易  01-退款交易（值域仅此两值）
           AND STATUS = '02'            -- 订单状态  00：待付款  01：处理中 02：交易成功 03：交易失败  04：已关闭  05：已撤销  90:超时 91:异常  98：预下单  99：日终失效
           AND PAY_TIME >= V_YAR_BEGIN  -- 交易时间不早于当年年初
           AND PAY_TIME <= V_DAY_END    -- 交易时间不晚于业务日当日末
         GROUP BY MCT_ID),
     CUST_TX AS
     (
        /*                              -- 客户年累计交易量：区间比较(可走 pay_time 索引) + >=500 阈值 --*/
        SELECT CM.PATH_CODE,            -- 路径标识
               CM.STATIS_CALIB,         -- 统计口径
               CM.STATIS_DIM,           -- 统计维度
               CM.DATA_BLNG,            -- 数据归属
               CM.PERSN_LEGAL_BK_CODE,  -- 法人机构编码
               CM.CUST_ID,              -- 客户ID
               SUM(T.ANNUAL_TX_AMT) AS ANNUAL_TX_AMT   -- 客户层年累计交易量（净额）
          FROM CUST_MCT CM
          JOIN MCT_TX T ON T.MCT_ID = CM.MCT_ID        -- 关联商户交易聚合
         GROUP BY CM.PATH_CODE,  -- 按客户+维度分组
                  CM.STATIS_CALIB,
                  CM.STATIS_DIM,
                  CM.DATA_BLNG,
                  CM.PERSN_LEGAL_BK_CODE,
                  CM.CUST_ID
        HAVING SUM(T.ANNUAL_TX_AMT) >= 500),  -- 年累计交易量>=500纳入统计
     CUST_WIDE AS
     (
        /*                                        -- 客户级宽表：分母(交易量) + 分子(年日均AUM/存款)，LEFT JOIN 保零余额客户 --*/
        SELECT T.PATH_CODE,                       -- 路径标识
               T.STATIS_CALIB,                    -- 统计口径
               T.STATIS_DIM,                      -- 统计维度
               T.DATA_BLNG,                       -- 数据归属
               T.PERSN_LEGAL_BK_CODE,             -- 法人机构编码
               T.ANNUAL_TX_AMT,                   -- 年累计交易量（分母）
               NVL(B.AUM_BAL, 0)  AS ANNUAL_AUM,  -- 分子：年日均AUM
               NVL(B.DEPO_BAL, 0) AS ANNUAL_DEPO  -- 分子：年日均存款
          FROM CUST_TX T
          LEFT JOIN DWS_CUST_ASSE_LIAB B ON B.CUST_ID            = T.CUST_ID  -- 客户资产负债表：客户ID匹配
                                        AND B.PERSN_LEGAL_BK_CODE = T.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                        AND B.DATA_DATE           = V_SYSDAT  -- 取跑批日快照
                                        AND B.BAL_TYPE = '4')                 -- 余额类型=4（年日均）

    /*                          -- 0081：AUM留存率 --*/
    SELECT PATH_CODE,           -- 路径标识
           V_SYSDAT,            -- 数据日期
           DATA_BLNG,           -- 数据归属
           STATIS_DIM,          -- 统计维度
           STATIS_CALIB,        -- 统计口径
           'INDX_0081',         -- 指标编码：AUM留存率
           ROUND(SUM(ANNUAL_AUM) * 100 / NULLIF(SUM(ANNUAL_TX_AMT), 0), 2),  -- 年日均AUM/年累计交易量*100（分母0时置NULL）
           0,                   -- 期初/上期值（固定0）
           PERSN_LEGAL_BK_CODE  -- 法人机构编码
      FROM CUST_WIDE
     GROUP BY PATH_CODE,  -- 按路径/口径/归属/维度/法人分组
              STATIS_CALIB,
              DATA_BLNG,
              STATIS_DIM,
              PERSN_LEGAL_BK_CODE
    UNION ALL
    /*                          -- 0069：结算存款留存率 --*/
    SELECT PATH_CODE,           -- 路径标识
           V_SYSDAT,            -- 数据日期
           DATA_BLNG,           -- 数据归属
           STATIS_DIM,          -- 统计维度
           STATIS_CALIB,        -- 统计口径
           'INDX_0069',         -- 指标编码：结算存款留存率
           ROUND(SUM(ANNUAL_DEPO) * 100 / NULLIF(SUM(ANNUAL_TX_AMT), 0), 2),  -- 年日均存款/年累计交易量*100（分母0时置NULL）
           0,                   -- 期初/上期值（固定0）
           PERSN_LEGAL_BK_CODE  -- 法人机构编码
      FROM CUST_WIDE
     GROUP BY PATH_CODE,  -- 按路径/口径/归属/维度/法人分组
              STATIS_CALIB,
              DATA_BLNG,
              STATIS_DIM,
              PERSN_LEGAL_BK_CODE;

    ---------------------------------------------------------------------
    -- 2. 0066 个贷新形成不良贷款率: 期初基准(prc_ads_stat_indx_plan_002 3.4段建立)
    --    分母 = scope客户 ∩ 期初基准(正常1/关注2账户)余额合计
    --    分子 = 同上账户中期末(DWD_ACCT_LOAN)变不良(3次级/4可疑/5损失)的当前余额合计
    --           (期间结清账户期末不存在, 不计入分子; 期间新开账户期初不在基准, 不计入分母)
    --    率   = ROUND(分子/分母*100, 2), 分母为0时输出 NULL
    ---------------------------------------------------------------------
    INSERT INTO TMP_STAT_INDX_AGGR_008
        (PATH_CODE,      -- 路径标识（08营销活动/09目标任务）
         DATA_DATE,      -- 数据日期
         DATA_BLNG,      -- 数据归属
         STATIS_DIM,     -- 统计维度
         STATIS_CALIB,   -- 统计口径
         INDX_CODE,      -- 指标编码
         CURNT_VAL,      -- 当前值
         TERM_LAST_VAL,  -- 期初/上期值
         PERSN_LEGAL_BK_CODE)       -- 法人机构编码
    WITH SCOPE_CUST AS
     (
        SELECT SC.PATH_CODE,  -- 路径标识
               CASE
                   WHEN SC.PATH_CODE = '08' THEN
                      '08'
                   ELSE
                      '09'
               END AS STATIS_CALIB,                                               -- 口径：A→营销活动，否则→目标任务
               SC.STATIS_DIM,                                                     -- 统计维度
               SC.DATA_BLNG,                                                      -- 数据归属
               SC.PERSN_LEGAL_BK_CODE,                                            -- 法人机构编码
               SC.CUST_ID                                                         -- 目标客户ID
          FROM (SELECT DISTINCT S.PATH_CODE,                                      -- 仅0066目标客户，路径08去重
                                S.STATIS_DIM,                                     -- 统计维度
                                S.DATA_BLNG,                                      -- 数据归属
                                S.PERSN_LEGAL_BK_CODE,                            -- 法人机构编码
                                TI.CUST_ID                                        -- 目标客户ID
                  FROM TMP_STAT_INDX_SCOPE S                                      -- 目标客户范围表
                  JOIN DWD_MKT_TSK_INFO TI ON TI.MKT_ACT_ID         = S.STATIS_DIM-- 营销任务：活动ID匹配
                                          AND TI.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                          AND TI.DATA_DATE           = V_SYSDAT   -- 跑批日快照
                                          AND ((S.BLNG_TYPE = 'O' AND             -- 归属O：按营销人员机构匹配
                                                TI.MKT_PERSN_ORG = S.BLNG_ID) OR  -- 营销人员机构编码=归属机构（O分支）
                                                (S.BLNG_TYPE = 'M' AND            -- 归属M：按营销人员匹配
                                                TI.MKT_PERSN = S.BLNG_ID))        -- 营销人员编码=归属ID（M分支）
                 WHERE S.PATH_CODE = '08'                                          -- 仅路径08（营销活动）
                   AND S.INDX_CODE = 'INDX_0066'                                  -- 仅0066指标
                UNION
                SELECT DISTINCT S.PATH_CODE,   -- 0066目标客户，09机构路径去重
                                S.STATIS_DIM,  -- 统计维度
                                S.DATA_BLNG,   -- 数据归属
                                S.PERSN_LEGAL_BK_CODE,   -- 法人机构编码
                                LV.CUST_ID     -- 目标客户ID
                  FROM TMP_STAT_INDX_SCOPE S
                  JOIN DWS_CUST_LVL_INFO LV ON LV.ORG_ID            = S.BLNG_ID   -- 客户层级：机构ID匹配归属
                                           AND LV.PERSN_LEGAL_BK_CODE = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                           AND LV.DATA_DATE           = V_SYSDAT  -- 跑批日快照
                 WHERE S.PATH_CODE = '09'                                          -- 仅路径09
                   AND S.BLNG_TYPE = 'O'                                          -- 仅归属O（机构）
                   AND S.INDX_CODE = 'INDX_0066'                                  -- 仅0066指标
                UNION
                SELECT DISTINCT S.PATH_CODE,   -- 0066目标客户，09管户路径去重
                                S.STATIS_DIM,  -- 统计维度
                                S.DATA_BLNG,   -- 数据归属
                                S.PERSN_LEGAL_BK_CODE,   -- 法人机构编码
                                CM.CUST_ID     -- 目标客户ID
                  FROM TMP_STAT_INDX_SCOPE S
                  JOIN DWD_CUST_MAN CM ON CM.MNGR_POST_ID          = S.BLNG_ID  -- 客户经理：管户岗ID匹配归属
                                      AND CM.MNG_TYP = '1'                      -- 客户经理类型=1
                                      AND CM.PERSN_LEGAL_BK_CODE    = S.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                 WHERE S.PATH_CODE = '09'                                        -- 仅路径09
                   AND S.BLNG_TYPE = 'M'                                        -- 仅归属M（管户）
                   AND S.INDX_CODE = 'INDX_0066') SC),                          -- 仅0066指标
     DENOM AS
     (
        /*                              -- 分母：期初基准(正常1/关注2账户)余额合计 --*/
        SELECT SC.PATH_CODE,            -- 路径标识
               SC.STATIS_CALIB,         -- 统计口径
               SC.STATIS_DIM,           -- 统计维度
               SC.DATA_BLNG,            -- 数据归属
               SC.PERSN_LEGAL_BK_CODE,  -- 法人机构编码
               SUM(NVL(B.LOAN_BAL, 0)) AS BASE_AMT   -- 期初基准账户余额合计（分母）
          FROM SCOPE_CUST SC
          JOIN TMP_STAT_INDX_LOAN_BASE B ON B.PATH_CODE        = SC.PATH_CODE   -- 期初贷款基准表：路径匹配
                                        AND B.STATIS_DIM       = SC.STATIS_DIM  -- 维度匹配
                                        AND B.DATA_BLNG        = SC.DATA_BLNG   -- 数据归属匹配
                                        AND B.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                        AND B.CUST_ID          = SC.CUST_ID     -- 客户匹配
         GROUP BY SC.PATH_CODE,                                                 -- 按客户+维度聚合
                  SC.STATIS_CALIB,
                  SC.STATIS_DIM,
                  SC.DATA_BLNG,
                  SC.PERSN_LEGAL_BK_CODE),
     NUMER AS
     (
        /*                              -- 分子：期初基准账户中期末变不良(3/4/5)的当前余额合计 --*/
        SELECT SC.PATH_CODE,            -- 路径标识
               SC.STATIS_CALIB,         -- 统计口径
               SC.STATIS_DIM,           -- 统计维度
               SC.DATA_BLNG,            -- 数据归属
               SC.PERSN_LEGAL_BK_CODE,  -- 法人机构编码
               SUM(NVL(A.BAL, 0)) AS BAD_AMT   -- 变不良账户当前余额合计（分子）
          FROM SCOPE_CUST SC
          JOIN TMP_STAT_INDX_LOAN_BASE B ON B.PATH_CODE        = SC.PATH_CODE    -- 期初贷款基准表：路径匹配
                                        AND B.STATIS_DIM       = SC.STATIS_DIM   -- 维度匹配
                                        AND B.DATA_BLNG        = SC.DATA_BLNG    -- 数据归属匹配
                                        AND B.PERSN_LEGAL_BK_CODE = SC.PERSN_LEGAL_BK_CODE   -- 法人机构匹配
                                        AND B.CUST_ID          = SC.CUST_ID      -- 客户匹配
          JOIN DWD_ACCT_LOAN A ON A.ACCT_ID          = B.ACCT_ID                 -- 期末贷款账户：账号匹配期初基准
                              AND A.CUST_ID          = B.CUST_ID                 -- 客户ID匹配
                              AND A.PERSN_LEGAL_BK_CODE = B.PERSN_LEGAL_BK_CODE  -- 法人机构匹配
                              AND A.CATE_5LVL IN ('3', '4', '5')                 -- 五级分类：3次级/4可疑/5损失（不良）
         GROUP BY SC.PATH_CODE,                                                  -- 按客户+维度聚合
                  SC.STATIS_CALIB,
                  SC.STATIS_DIM,
                  SC.DATA_BLNG,
                  SC.PERSN_LEGAL_BK_CODE)
    SELECT D.PATH_CODE,                                        -- 路径标识
           V_SYSDAT,                                           -- 数据日期
           D.DATA_BLNG,                                        -- 数据归属
           D.STATIS_DIM,                                       -- 统计维度
           D.STATIS_CALIB,                                     -- 统计口径
           'INDX_0066',                                        -- 指标编码：个贷新形成不良贷款率
           ROUND(NVL(N.BAD_AMT, 0) * 100 / NULLIF(D.BASE_AMT, 0), 2),   -- 分子/分母*100（分母0置NULL）
           0,                                                  -- 期初/上期值（固定0）
           D.PERSN_LEGAL_BK_CODE                               -- 法人机构编码
      FROM DENOM D                                             -- 分母表
      LEFT JOIN NUMER N ON N.PATH_CODE         = D.PATH_CODE   -- 关联分子：路径匹配
                       AND N.STATIS_DIM        = D.STATIS_DIM  -- 维度匹配
                       AND N.DATA_BLNG         = D.DATA_BLNG   -- 数据归属匹配
                       AND N.PERSN_LEGAL_BK_CODE = D.PERSN_LEGAL_BK_CODE;   -- 法人机构匹配

    outcde := SQL%ROWCOUNT;  -- 写入行数（取最后DML影响行数）

    -- 日志记录（正常完成）
    COMMIT;                                                   -- 提交事务
    V_END_DATE := SYSDATE;                                    -- 过程结束时间
    V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 运行耗时（秒）
    V_LOG_MSG := '步骤8处理完成，行数=' || NVL(outcde, 0);             -- 拼接日志消息（含写入行数）
    V_LOG_FLG := 0;                                           -- 日志标志：0=正常
    SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 写入步骤执行日志
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;                                                 -- 异常回滚
        outcde := -1;                                             -- 异常标识：-1
        V_END_DATE := SYSDATE;                                    -- 过程结束时间
        V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 86400);  -- 运行耗时（秒）
        V_LOG_MSG := SUBSTR(SQLERRM, 1, 1000);                    -- 截取异常信息（前1000字符）
        V_LOG_FLG := -1;                                          -- 日志标志：-1=异常
        SYS_PRC_STEP_LOGS(v_sysdat, V_PRC_NAME, V_PRC_DESC, V_NO_ID, V_BGN_DATE, V_END_DATE, V_DURA_DATE, V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON);  -- 写入异常日志
        RAISE;                                                    -- 重新抛出异常
END PRC_ADS_STAT_INDX_PLAN_008;