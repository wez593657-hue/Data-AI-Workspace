CREATE OR REPLACE PROCEDURE PRC_ADS_CUST_PRDKT_RCMD(
    V_SYSDAT IN VARCHAR,
    OUTCDE   OUT INTEGER
)
AS
  ------------------------------------------------------------------
  -- 存储过程: 产品推荐
  --
  -- 功能: 对全行所有客户, 就普通定期存款/智能存款/理财三类在售产品
  --       执行"硬过滤 + 四维评分排序", 输出 Top3 推荐至 ADS_CUST_PRDKT_RCMD
  --
  -- 参数说明:
  --   V_SYSDAT  跑批数据日期 YYYYMMDD
  --   OUTCDE    输出码 0-成功 -1-失败
  --
  -- 评分模型(word V1.1): 总分 = A x 35% + B x 30% + C x 20% + D x 15%
  --   A 收益吸引力(同类分组排名五档) / B 期限匹配度(年日均最大锚点偏差五档, 2026-09-02口径升级)
  --   C 风险舒适度(档位差五档)     / D 历史偏好(三因素组合制)
  --
  -- 需求版本: REQ-RCMD-001 V1.1
  -- 变更记录:
  --   v1.0.0 2026-08-25 初版(基于已废弃草稿口径, 整体重构废弃)
  --   v2.0.0 2026-08-26 按word客户确认版V1.0.2重构: 百分制x权重评分卡,
  --          候选粒度方案A(定期按产品x存期档), 目标表10列定稿
  --   v2.1.0 2026-09-02 落地业务确认8项+4项执行确认: 客户范围=全行所有客户
  --          (DWD_CUST_INDV_INFO圈选), 客户风险=invest_typ'3'测评线risk_lvl
  --          1-5直接作档位, 存款风险固定R1/理财COL_VALUE 01-05映射, F2仅
  --          校验在售(渠道可售删除), A维边界左闭右开, 近三年=36个月滚动/
  --          近一年=12个月滚动, 产品期限均为固定到点, 存款发行机构固定9999
  --          (D维机构因素f2启用, 完整D1-D5判定), 无测评客户存款放行理财剔除
  --   v2.2.0 2026-09-02 需求升级word V1.1并落地业务确认9项: 测评每客户同
  --          invest_typ仅一条/过期视为无测评, 无理财测评默认C2档统一判定
  --          (替代v2.1.0"存款放行理财剔除"), B维锚点=近三年金额最大产品单
  --          点期限(偏差五档100/80/60/30/0), 收益口径四类回填(定期=ZB实际
  --          利率/智能存款=DETAIL PRDKT_RATE/自营理财=MARK_EXP业绩基准/代销
  --          理财=近三月INCOME_RATE_3M优先七日INCOME_RATE_7兜底), A维样本
  --          阈值<10中性60, A维得分回填MERGE补齐(修复v2.1.0缺回填缺陷),
  --          推荐话术对齐word V1.1第7章模板(等级三档+数据不足专用话术)
  --   v2.3.0 2026-09-02 落地业务确认17项: 期限值域D/M/Y+数字(智能存款与
  --          CUNQ同规则解析: nD=天数/30折月, nM=月数, nY=年x12), 同类分组
  --          键=类型+期限+等级(已确认), 理财发行机构自营=9999/代销=DETAIL
  --          TANO属性, 客户无历史持有B维0分(替代中性60), 智能存款属性加工
  --          与ZB表加载缺陷已修复(上游), 无HIS表直接当前表取数(正式口径),
  --          加权总分四舍五入, 外币不纳入候选, 持有产品可再次推荐, 目标表
  --          PRDKT_ID扩至40/RATE_INTRI按原有精度NUMBER(12,7)
  --   v2.4.0 2026-09-02 B维历史持有期限偏好口径升级: 锚点选取由"近三年金额最大
  --          产品的单点期限"改为"近三年年日均(YAR_BAL/YAR_DAYS)最大产品的单点
  --          期限"; 存期不做三档归并(仍按D/M/Y解析保留月数单点); 年日均来源
  --          DWS_CUST_ASSE_LIAB_CUMU_HIS按上年末快照(DATA_DATE=V_LAST_YEAR_END),
  --          存款关联PRDKT_TYP='1'/理财关联'3', 双源对齐标签表储蓄期限偏好口径;
  --          理财锚点若取到期限为NULL的产品则不计入; 段3历史持有合并表新增
  --          YR_AVG_AMT年日均列; 段7评分五档逻辑不变
  --   v2.5.0 2026-09-02 修复审查P0/P1缺陷6项: 段3理财持有类型映射'1'→'3'(对齐
  --          段5候选池判据); 段5智能存款分支期限改取DETAIL PRDKT_TERM属性(修复
  --          误取PRDKT_RATE利率值, 新增EAV属性LEFT JOIN); TMP_RCMD_RSLT新增
  --          PRDKT_TERM存期档列(DDL v1.5, 3.9.1回填方案A候选键/3.9.2占位NULL,
  --          支撑3.9.3话术UPDATE关联); 段4 TOP_CATE/TOP_ORG改跨机构/跨大类
  --          总频次口径(SUM(COUNT(*)) OVER窗口合计, 替代rk2=1单行过滤);
  --          3.9.1排序补总分主键(总分>期限>收益>偏好>编号, 对齐word 6同分序);
  --          3.9.3话术数据不足判据修复(B死分支改TERM_ANCHOR_M判无历史持有,
  --          A维拆分"无有效收益字段"与"样本不足GRP_CNT<10"两分支, 对齐word
  --          7.3.2/7.3.3模板)
  --   v2.5.1 2026-09-02 修复v2.5.0残留缺陷4项: 3.9.1/3.9.2 INSERT列列表补
  --          PRDKT_TERM(修复INSERT/SELECT列数不匹配11vs12运行时报错); 段5智能存款
  --          分支5处tr.COL_VALUE改pt.COL_VALUE(修复期限误取利率值致全部智能存款
  --          被段6过滤); 段3理财TERM_MONTHS改CASE WHEN两日期非空(修复NVL(NULL,0)
  --          致缺日期产品以0月参与锚点, 对齐✅-45)
  --   v2.5.2 2026-09-02 业务确认落地: 存款账户表存款大类中乐惠存(PRDKT_CATE_BIG
  --          ='03')及大额存单('05')属于智能存款, 段3存款分支历史持有类型由一律
  --          '01'改CASE拆分(03/05→'02'智能, 其余'01'定期); WHERE改(FIX_CURNT_FLG
  --          ='1' OR 大类IN('03','05'))大类兜底纳入(定活标志值域未确认, 与参考
  --          逻辑ALL_PRC历史持有口径同源); TERM_MONTHS沿用CUNQ解析(✅-30同规则,
  --          乐惠存CUNQ为空则NULL不参与锚点, 对齐✅-45); 下游段4 TOP_CATE/
  --          CATE_SET/锚点及段9 D维类型匹配自动兼容'02'无需改动
  --   v2.5.3 2026-09-03 日期参数合规修复: V_HIS_3Y_BGN/V_HIS_1Y_BGN/V_LAST_YEAR_END
  --          改由 sys_fun_deal_date(V_SYSDAT, 19/29/4) 初始化, 不再直接基于 V_SYSDAT
  --          推导(对齐 governance/stored_procedure_date_parameter_rules.md); 上年末
  --          修复为真上年末YYYY1231(参数4, 原推导实为上年末12月1日); 参数29(近一年)
  --          已登记治理规则表; 数据源维持 DWS_CUST_ASSE_LIAB_CUMU_HIS 关联具体产品
  --          (2026-09-03 用户确认不变更)
  ------------------------------------------------------------------
  V_PRC_DESC             VARCHAR(100) := '产品推荐';
  V_PRC_NAME             VARCHAR(32)  := 'PRC_ADS_CUST_PRDKT_RCMD';
  V_LOG_MSG              VARCHAR(4000);
  V_LOG_FLG              INTEGER;
  V_LOG_BUTTON           INTEGER := 1;
  V_NO_ID                VARCHAR(10);
  V_BGN_DATE             DATE;
  V_END_DATE             DATE;
  V_DURA_DATE            INTEGER;
  -- 业务日期参数: 仅声明本过程必需的日期, 规则见 governance/stored_procedure_date_parameter_rules.md
  V_HIS_3Y_BGN           VARCHAR(8) := sys_fun_deal_date(V_SYSDAT, 19);  -- 近三年窗口起点(B维, 36个月滚动, 已确认; 参数19=三年历史清理边界)
  V_HIS_1Y_BGN           VARCHAR(8) := sys_fun_deal_date(V_SYSDAT, 29);  -- 近一年窗口起点(D维, 12个月滚动, 已确认; 参数29=近一年, 已登记治理规则表)
  V_LAST_YEAR_END        VARCHAR(8) := sys_fun_deal_date(V_SYSDAT, 4);   -- 真上年末YYYY1231(B维年日均取数基准, 对齐标签表储蓄期限偏好口径; 参数4=上年末, 原推导ADD_MONTHS(TRUNC,'YYYY'),-1实为上年末12月1日)
BEGIN
  --***************************************
  -- 1. 自定义参数区
  --***************************************
  IF V_SYSDAT IS NULL
     OR NOT REGEXP_LIKE(V_SYSDAT, '^[0-9]{8}$')
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT must be in YYYYMMDD format');
  END IF;

  V_END_DATE := TO_DATE(V_SYSDAT, 'YYYYMMDD');   -- 解析日期以校验格式正确但日期非法的输入

  --***************************************
  -- 2. 目标表与中间表准备(每日全量清理)
  --***************************************
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_PRDKT_RCMD';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_HIS_HOLD';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_CUST_BASE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_PRDKT_POOL';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_CART_SAFE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_YIELD_SCORE';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_SCORE_DTL';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_RSLT';

  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第1段完成: 目标表与7张中间表清理';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.1 第2段: 客户圈选与风险等级挂接(段0)
  -- 触发范围 = 全行所有客户(DWD_CUST_INDV_INFO, 已确认), 风险测评仅取invest_typ='3'理财线
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_CUST_BASE (
      CUST_ID,             -- 客户编号
      PERSN_LEGAL_BK_CODE, -- 法人行号
      CUST_RISK_TXT,       -- 客户风险等级原始值
      CUST_RISK_NUM        -- 客户风险档位数值
  )
  SELECT DISTINCT
         c.CUST_ID             AS CUST_ID,             -- 客户编号
         c.PERSN_LEGAL_BK_CODE AS PERSN_LEGAL_BK_CODE, -- 法人行号
         NVL(r.RISK_LVL, '2')  AS CUST_RISK_TXT,       -- 客户风险等级原始值(值域1-5; 无理财测评默认C2档, 已确认)
         NVL(TO_NUMBER(r.RISK_LVL), 2) AS CUST_RISK_NUM -- 风险档位数值(1-5直接作档位; 无理财测评默认C2=2, 已确认)
    FROM DWD_CUST_INDV_INFO c                     -- 客户基本信息表(全行客户圈选源, 已确认)
    LEFT JOIN (
        SELECT t.CUST_ID,                        -- 客户编号
               t.PERSN_LEGAL_BK_CODE,            -- 法人行号
               t.RISK_LVL                        -- 风险级别原始值
          FROM (
              SELECT x.CUST_ID,                  -- 客户编号
                     x.PERSN_LEGAL_BK_CODE,      -- 法人行号
                     x.RISK_LVL,                 -- 风险级别原始值
                     ROW_NUMBER() OVER (PARTITION BY x.CUST_ID, x.PERSN_LEGAL_BK_CODE ORDER BY x.ESTIM_DATE DESC) AS RN  -- 防御性去重(上游已限制每客户同invest_typ仅一条, 已确认)
                FROM DWD_CUST_INDIV_RISK_INVST x -- 客户风险评估表
               WHERE x.INVEST_TYP = '3'          -- 仅取理财测评线(已确认; 3-理财,4-保险,保险线不参与)
                 AND x.ESTIM_DATE <= V_SYSDAT    -- 测评生效日不晚于跑批日
                 AND (x.EXPR_DATE IS NULL OR x.EXPR_DATE >= V_SYSDAT)  -- 测评未过期(过期视为无测评, 已确认)
          ) t
         WHERE t.RN = 1                           -- 取最新一条
    ) r ON r.CUST_ID = c.CUST_ID                 -- 客户风险等级左挂接(无测评客户按默认C2档统一判定)
       AND r.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE;  -- 法人行号联合关联(沿用参考逻辑口径)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第2段完成: 客户圈选与风险等级挂接';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.2 第3段: 历史持有合并(段0, 存款/理财双源UNION)
  -- 双源无HIS表, 直接从当前表取数(已确认为正式口径); 近三年36个月滚动窗口
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_HIS_HOLD (
      CUST_ID,     -- 客户编号
      PRDKT_ID,    -- 产品编号
      PRDKT_TYP,   -- 持有产品类型
      BUY_DATE,    -- 购买日期
      BUY_AMT,     -- 购买金额
      ISSU_ORG,    -- 发行机构
      TERM_MONTHS, -- 持有期限月数
      YR_AVG_AMT,  -- 年日均余额
      SRC_TBL      -- 来源表
  )
  SELECT f.CUST_ID     AS CUST_ID,     -- 客户编号
         f.PRDKT_ID    AS PRDKT_ID,    -- 产品编号
         CASE WHEN f.PRDKT_CATE_BIG = '3' THEN '03'  -- 自营理财类型码(大类3=自营理财, 对齐✅-09与段5候选池判据)
              ELSE '04'                              -- 代销理财类型码
         END           AS PRDKT_TYP,   -- 持有产品类型【占位编码, 与候选池类型码对齐待确认】
         f.ISSU_DATE   AS BUY_DATE,    -- 购买日期(理财=办理日期, 已确认)
         f.FIN_AMT     AS BUY_AMT,     -- 购买金额(理财=FIN_AMT理财余额, 已确认)
         f.ISSU_ORG    AS ISSU_ORG,    -- 发行机构(理财有ISSU_ORG, 自营侧见✅-32)
         CASE WHEN f.EXPR_DATE IS NOT NULL AND f.INTRI_BGN_DATE IS NOT NULL  -- 理财历史持有期限=到期日-起息日(天数/30折月, 已确认); 任一日期缺失则NULL不计入锚点(对齐✅-45)
              THEN ROUND((f.EXPR_DATE - f.INTRI_BGN_DATE) / 30, 2)
         END           AS TERM_MONTHS,
         NVL(h0.YAR_BAL, 0) / NULLIF(NVL(h0.YAR_DAYS, 0), 0) AS YR_AVG_AMT,      -- 年日均余额(理财侧, 关联资产负债基数历史表上年末快照, PRDKT_TYP='3')
         'FIN'         AS SRC_TBL      -- 来源表标记
    FROM DWD_ACCT_FIN f                -- 理财账户信息表
    LEFT JOIN DWS_CUST_ASSE_LIAB_CUMU_HIS h0  -- 客户资产负债基数历史表(年日均取数, 对齐标签表储蓄期限偏好口径)
      ON h0.PERSN_LEGAL_BK_CODE = f.PERSN_LEGAL_BK_CODE  -- 法人行号一致
     AND h0.CUST_ID            = f.CUST_ID            -- 客户编号一致
     AND h0.ACCT_ID            = f.ACCT_ID            -- 账户一致
     AND h0.PRDKT_ID           = f.PRDKT_ID           -- 产品编号一致
     AND h0.PRDKT_TYP          = '3'                  -- 产品类型=理财
     AND h0.DATA_DATE          = V_LAST_YEAR_END      -- 上年末快照
   WHERE f.ISSU_DATE >= V_HIS_3Y_BGN   -- 近三年窗口(滚动)
  UNION ALL
  SELECT d.CUST_ID     AS CUST_ID,     -- 客户编号
         d.PRDKT_ID    AS PRDKT_ID,    -- 产品编号
         CASE WHEN d.PRDKT_CATE_BIG IN ('03', '05') THEN '02' ELSE '01' END AS PRDKT_TYP,  -- 持有产品类型(乐惠存03/大额存单05=智能存款'02', 其余定期'01', 对齐✅-46)
         TO_DATE(t.TX_DATE, 'YYYYMMDD') AS BUY_DATE,  -- 购买日期(经DWD_TX_ASET交易日期TX_DATE, 已确认; 日期格式按YYYYMMDD【待核对】)
         t.AMT         AS BUY_AMT,     -- 购买金额(经DWD_TX_ASET交易发生额AMT, 已确认)
         '9999'        AS ISSU_ORG,    -- 发行机构(存款固定9999, 已确认)
         CASE UPPER(SUBSTR(d.CUNQ, -1))                                   -- 存期值域D/M/Y+数字(已确认)
             WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(d.CUNQ, 1, LENGTH(d.CUNQ) - 1)) / 30, 2)  -- nD=天数按30天/月折算
             WHEN 'M' THEN TO_NUMBER(SUBSTR(d.CUNQ, 1, LENGTH(d.CUNQ) - 1))                -- nM=月数
             WHEN 'Y' THEN TO_NUMBER(SUBSTR(d.CUNQ, 1, LENGTH(d.CUNQ) - 1)) * 12           -- nY=年数x12
        END           AS TERM_MONTHS, -- 期限月数(CUNQ解析, 已确认; 异常值域自然落NULL)
        NVL(hd.YAR_BAL, 0) / NULLIF(NVL(hd.YAR_DAYS, 0), 0) AS YR_AVG_AMT,   -- 年日均余额(存款侧, 关联资产负债基数历史表上年末快照, PRDKT_TYP='1')
        'DEPO'        AS SRC_TBL      -- 来源表标记
   FROM DWD_ACCT_DEPO d               -- 存款账户信息表
   LEFT JOIN (                        -- DWD_TX_ASET与DWD_ACCT_DEPO关联, 取买入交易最近一笔(日期X金额, 已确认)
       SELECT t1.CUST_ID,             -- 客户编号
              t1.ACCT_ID,             -- 账户(与存款账户关联键, 待确认)
              t1.TX_DATE,             -- 交易日期
              t1.AMT,                 -- 发生额
              ROW_NUMBER() OVER (PARTITION BY t1.CUST_ID, t1.ACCT_ID ORDER BY t1.TX_DATE DESC) AS RN  -- 每账户取交易日期最近一笔
         FROM DWD_TX_ASET t1          -- 资产类交易流水表
   ) t
     ON t.CUST_ID = d.CUST_ID         -- 客户编号关联
    AND t.ACCT_ID = d.ACCT_ID         -- 账户关联(关联键, 待确认)
    AND t.RN = 1                      -- 最近一笔
   LEFT JOIN DWS_CUST_ASSE_LIAB_CUMU_HIS hd  -- 客户资产负债基数历史表(年日均取数, 对齐标签表储蓄期限偏好口径)
     ON hd.PERSN_LEGAL_BK_CODE = d.PERSN_LEGAL_BK_CODE  -- 法人行号一致
    AND hd.CUST_ID            = d.CUST_ID            -- 客户编号一致
    AND hd.ACCT_ID            = d.ACCT_ID            -- 账户一致
    AND hd.PRDKT_ID           = d.PRDKT_ID           -- 产品编号一致
    AND hd.PRDKT_TYP          = '1'                  -- 产品类型=存款
    AND hd.DATA_DATE          = V_LAST_YEAR_END      -- 上年末快照
  WHERE (d.FIX_CURNT_FLG = '1'        -- 定期(0-活期,1-定期)
     OR d.PRDKT_CATE_BIG IN ('03', '05'))  -- 大类兜底纳入乐惠存/大额存单(定活标志值域未确认, 与参考逻辑ALL_PRC历史持有口径同源)
    AND d.INTRI_BGN_DATE >= V_HIS_3Y_BGN;  -- 近三年窗口(滚动)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成: 存款/理财双源历史持有合并';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.3 第4段: 客户画像归纳(段0, D维三因素+B维锚点)
  -- B维锚点=近三年金额最大产品的单点期限TERM_ANCHOR_M(已确认)
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  MERGE INTO TMP_RCMD_CUST_BASE b
  USING (
      SELECT h.CUST_ID,                       -- 客户编号
             MAX(CASE WHEN h.rk1 = 1 THEN h.PRDKT_TYP END) AS TOP_CATE,   -- 近一年频次最高大类(按笔数, 跨机构合计【待确认: 笔数还是金额口径】)
             MAX(CASE WHEN h.rk2 = 1 THEN h.ISSU_ORG END) AS TOP_ORG,     -- 近一年购买最多机构(按笔数, 跨大类合计)
             LISTAGG(DISTINCT h.PRDKT_TYP, ',') AS CATE_SET               -- 近一年购买过的大类集合
        FROM (
            SELECT h2.CUST_ID,                -- 客户编号
                   h2.PRDKT_TYP,              -- 持有产品类型
                   h2.ISSU_ORG,               -- 发行机构
                   ROW_NUMBER() OVER (PARTITION BY h2.CUST_ID ORDER BY h2.cate_cnt DESC, h2.PRDKT_TYP) AS rk1,  -- 大类总频次排名(该大类近一年全部购买笔数, 并列按类型码稳定)
                   ROW_NUMBER() OVER (PARTITION BY h2.CUST_ID ORDER BY h2.org_cnt DESC, h2.ISSU_ORG) AS rk2    -- 机构总频次排名(该机构近一年全部购买笔数, 并列按机构码稳定)
              FROM (
                  SELECT h1.CUST_ID,          -- 客户编号
                         h1.PRDKT_TYP,        -- 持有产品类型
                         h1.ISSU_ORG,         -- 发行机构
                         SUM(COUNT(*)) OVER (PARTITION BY h1.CUST_ID, h1.PRDKT_TYP) AS cate_cnt,  -- 大类总笔数(跨机构合计, 修复原组内频次切分)
                         SUM(COUNT(*)) OVER (PARTITION BY h1.CUST_ID, h1.ISSU_ORG) AS org_cnt     -- 机构总笔数(跨大类合计, 修复原组内频次切分)
                    FROM TMP_RCMD_HIS_HOLD h1  -- 历史持有合并表
                   WHERE h1.BUY_DATE >= TO_DATE(V_HIS_1Y_BGN, 'YYYYMMDD')  -- 近一年窗口
                   GROUP BY h1.CUST_ID, h1.PRDKT_TYP, h1.ISSU_ORG
              ) h2
        ) h
       GROUP BY h.CUST_ID
  ) p ON (b.CUST_ID = p.CUST_ID)
  WHEN MATCHED THEN UPDATE SET
      b.TOP_CATE = p.TOP_CATE,                -- 频次最高大类
      b.TOP_ORG  = p.TOP_ORG,                 -- 购买最多机构
      b.CATE_SET = p.CATE_SET;                -- 购买大类集合

  -- B维期限偏好锚点: 近三年持有中年日均最大的产品的单点期限(2026-09-02 口径升级, 对齐标签表储蓄期限偏好)
  MERGE INTO TMP_RCMD_CUST_BASE b
  USING (
      SELECT h2.CUST_ID              AS CUST_ID,       -- 客户编号
             h2.TERM_MONTHS          AS TERM_ANCHOR_M  -- 年日均最大产品的期限月数作锚点
        FROM (
            SELECT h1.CUST_ID,                          -- 客户编号
                   h1.TERM_MONTHS,                      -- 期限月数
                   ROW_NUMBER() OVER (PARTITION BY h1.CUST_ID
                                      ORDER BY h1.YR_AVG_AMT DESC NULLS LAST, h1.BUY_AMT DESC, h1.BUY_DATE DESC, h1.PRDKT_ID ASC) AS rk3  -- 年日均最大优先(并列按金额/日期/编号稳定; 年日均无值排后)
              FROM TMP_RCMD_HIS_HOLD h1                 -- 历史持有合并表(段3已按36个月窗口过滤)
             WHERE h1.TERM_MONTHS IS NOT NULL            -- 期限可解析的记录才参与锚点(理财锚点取到期限NULL则不计入)
        ) h2
       WHERE h2.rk3 = 1                                  -- 每客户年日均最大一笔
  ) t ON (b.CUST_ID = t.CUST_ID)
  WHEN MATCHED THEN UPDATE SET
      b.TERM_ANCHOR_M = t.TERM_ANCHOR_M;                 -- 期限偏好锚点回填(存款侧CUNQ已解析; 理财侧期限T-03未决)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第4段完成: D维客户画像归纳+B维期限锚点';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.4 第5段: 候选产品池构建(段0, 方案A粒度)
  -- 定期=主表内联ZB表按存期档展开; 智能存款=DETAIL取利率PRDKT_RATE/期限PRDKT_TERM(D/M/Y解析);
  -- 理财=DETAIL取风险等级, 收益: 自营=MARK_EXP业绩基准/代销=近三月优先七日兜底;
  -- 发行机构: 存款=9999/自营理财=9999/代销理财=DETAIL TANO(均已确认); 外币不纳入候选
  --***************************************
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_PRDKT_POOL (
      PRDKT_ID,     -- 产品编号
      PRDKT_TERM,   -- 存期档
      TERM_MONTHS,  -- 期限月数
      PRDKT_NAME,   -- 产品名称
      PRDKT_TYP,    -- 推荐产品类型
      PRDKT_RATE,   -- 利率或收益率
      RISK_LVL_TXT, -- 风险等级
      RISK_NUM,     -- 风险档位数值
      ISSU_ORG,     -- 发行机构
      IS_SELL       -- 是否在售
  )
  SELECT p.PRDKT_ID    AS PRDKT_ID,     -- 产品编号(CBS_前缀)
         z.PRDKT_TERM  AS PRDKT_TERM,   -- 存期档(已归一化xxM)
         TO_NUMBER(RTRIM(z.PRDKT_TERM, 'M')) AS TERM_MONTHS,  -- 存期档转月数
         p.PRDKT_NAME  AS PRDKT_NAME,   -- 产品名称
         '01'          AS PRDKT_TYP,    -- 推荐产品类型(定期存款)【占位编码, 值域待确认】
         z.PRDKT_RATE  AS PRDKT_RATE,   -- 实际利率(ZB表, 时点正确)
         'R1'          AS RISK_LVL_TXT, -- 存款风险等级固定R1(已确认)
         1             AS RISK_NUM,     -- 存款风险档位固定1(已确认)
         '9999'        AS ISSU_ORG,     -- 发行机构(存款固定9999, 已确认)
         z.IS_SELL     AS IS_SELL       -- 是否在售(ZB表口径)
    FROM DWD_PRDKT_INFO p               -- 产品主表
   INNER JOIN DWD_PRDKT_INFO_ZB z       -- 定期存款产品子表(方案A候选源)
      ON z.PRDKT_ID = p.PRDKT_ID        -- 产品编号直连(不经属性表名称中转)
     AND z.DATA_DATE = V_SYSDAT         -- 当日快照
     AND z.IS_SELL = '是'               -- 在售(ZB口径, 上游加载已修复)
     AND z.PRDKT_CCY = '01'             -- 人民币(外币不纳入候选, 已确认)
   WHERE p.PRDKT_CATE_BIG = '1'         -- 存款大类
     AND p.SYS_SRC = 'CBS'              -- 系统来源=核心(普通定期)
     AND p.PRDKT_STATE = '0'            -- 主表在售(0-在售, 分支无分号续接UNION ALL)
  UNION ALL
  SELECT p.PRDKT_ID    AS PRDKT_ID,     -- 产品编号(CDS_前缀)
         pt.COL_VALUE  AS PRDKT_TERM,   -- 产品期限(DETAIL PRDKT_TERM属性, 值域D/M/Y+数字, 已确认)
         CASE UPPER(SUBSTR(pt.COL_VALUE, -1))                                   -- 期限值域D/M/Y+数字(已确认)
             WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(pt.COL_VALUE, 1, LENGTH(pt.COL_VALUE) - 1)) / 30, 2)  -- nD=天数按30天/月折算
             WHEN 'M' THEN TO_NUMBER(SUBSTR(pt.COL_VALUE, 1, LENGTH(pt.COL_VALUE) - 1))                -- nM=月数
             WHEN 'Y' THEN TO_NUMBER(SUBSTR(pt.COL_VALUE, 1, LENGTH(pt.COL_VALUE) - 1)) * 12           -- nY=年数x12
         END           AS TERM_MONTHS,  -- 期限月数(PRDKT_TERM解析, 已确认; 异常值域自然落NULL)
         p.PRDKT_NAME  AS PRDKT_NAME,   -- 产品名称
         '02'          AS PRDKT_TYP,    -- 推荐产品类型(智能存款)【占位编码】
         TO_NUMBER(tr.COL_VALUE) AS PRDKT_RATE,  -- 利率(DETAIL PRDKT_RATE属性, 已确认)
         'R1'          AS RISK_LVL_TXT, -- 存款风险等级固定R1(已确认)
         1             AS RISK_NUM,     -- 存款风险档位固定1(已确认)
         '9999'        AS ISSU_ORG,     -- 发行机构(存款固定9999, 已确认)
         '是'          AS IS_SELL       -- 在售(主表口径)
    FROM DWD_PRDKT_INFO p               -- 产品主表
    INNER JOIN DWD_PRDKT_CATLOG cl      -- 产品目录表(属性表关联中转)
      ON cl.PRDKT_CATLOG_ID = p.PRDKT_ID  -- 目录编号=产品编号(CDS_前缀)
    INNER JOIN DWD_PRDKT_INFO_DETAIL tr  -- 产品属性表(EAV)
      ON tr.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND tr.COL_CODE = 'PRDKT_RATE'     -- 利率属性(已确认)
    LEFT JOIN DWD_PRDKT_INFO_DETAIL pt  -- 产品属性表(EAV)
      ON pt.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND pt.COL_CODE = 'PRDKT_TERM'     -- 产品期限属性(已确认; 与理财分支同模式, 修复v2.4.0期限误取利率值)
   WHERE p.PRDKT_CATE_BIG = '1'         -- 存款大类
     AND p.SYS_SRC = 'CDS'              -- 系统来源=智能存款
     AND p.PRDKT_STATE = '0'            -- 在售(分支无分号, UNION ALL续接理财分支; 修复v2.1.0误加分号截断缺陷)
  UNION ALL
  SELECT p.PRDKT_ID    AS PRDKT_ID,     -- 产品编号(FMS_前缀)
         pt.COL_VALUE  AS PRDKT_TERM,   -- 理财产品期限(DETAIL PRDKT_TERM属性, 值域D/M/Y+数字同✅-30, 已确认)
         CASE UPPER(SUBSTR(pt.COL_VALUE, -1))                                   -- 理财期限值域D/M/Y+数字, 与智能存款同属性同规则(已确认)
             WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(pt.COL_VALUE, 1, LENGTH(pt.COL_VALUE) - 1)) / 30, 2)  -- nD=天数按30天/月折算
             WHEN 'M' THEN TO_NUMBER(SUBSTR(pt.COL_VALUE, 1, LENGTH(pt.COL_VALUE) - 1))                -- nM=月数
             WHEN 'Y' THEN TO_NUMBER(SUBSTR(pt.COL_VALUE, 1, LENGTH(pt.COL_VALUE) - 1)) * 12           -- nY=年数x12
         END           AS TERM_MONTHS,  -- 期限月数(PRDKT_TERM解析; 异常值域自然落NULL, 缺失则产品不推)
         p.PRDKT_NAME  AS PRDKT_NAME,   -- 产品名称
         CASE WHEN p.PRDKT_CATE_BIG = '3' THEN '03' ELSE '04' END AS PRDKT_TYP,  -- 自营/代销理财类型码【占位编码】
         CASE WHEN p.PRDKT_CATE_BIG = '3' THEN TO_NUMBER(m1.COL_VALUE)             -- 自营理财: 业绩比较基准MARK_EXP(已确认, 纯数值型)
              ELSE NVL(TO_NUMBER(m2.COL_VALUE), TO_NUMBER(m3.COL_VALUE))           -- 代销理财: 近三月INCOME_RATE_3M优先, 无则七日INCOME_RATE_7兜底(已确认)
         END           AS PRDKT_RATE,   -- 收益率(理财收益口径已确认)
         'R' || TO_NUMBER(d.COL_VALUE) AS RISK_LVL_TXT,  -- 风险等级R1-R5(COL_VALUE 01-05, 已确认)
         TO_NUMBER(d.COL_VALUE) AS RISK_NUM,     -- 风险档位数值(01-极低/02-低/03-中/04-高/05-极高, 已确认)
         CASE WHEN p.PRDKT_CATE_BIG = '3' THEN '9999'                             -- 自营理财发行机构=本行9999(已确认)
              ELSE t1.COL_VALUE                                                   -- 代销理财发行机构=DETAIL TANO属性(已确认)
         END           AS ISSU_ORG,     -- 发行机构(自营9999/代销TANO, 已确认)
         '是'          AS IS_SELL       -- 在售(主表口径)
    FROM DWD_PRDKT_INFO p               -- 产品主表
    INNER JOIN DWD_PRDKT_CATLOG cl      -- 产品目录表(属性表关联中转)
      ON cl.PRDKT_CATLOG_ID = p.PRDKT_ID  -- 目录编号=产品编号(FMS_前缀)
    INNER JOIN DWD_PRDKT_INFO_DETAIL d  -- 产品属性表(EAV)
      ON d.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND d.COL_CODE = 'PRDKT_RISK'      -- 风险等级属性
    LEFT JOIN DWD_PRDKT_INFO_DETAIL m1  -- 产品属性表(EAV)
      ON m1.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND m1.COL_CODE = 'MARK_EXP'       -- 业绩比较基准属性(自营理财)
    LEFT JOIN DWD_PRDKT_INFO_DETAIL m2  -- 产品属性表(EAV)
      ON m2.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND m2.COL_CODE = 'INCOME_RATE_3M' -- 近3月年化收益率属性(代销理财优先)
    LEFT JOIN DWD_PRDKT_INFO_DETAIL m3  -- 产品属性表(EAV)
      ON m3.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND m3.COL_CODE = 'INCOME_RATE_7'  -- 七日年化收益率属性(代销理财兜底)
    LEFT JOIN DWD_PRDKT_INFO_DETAIL t1  -- 产品属性表(EAV)
      ON t1.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND t1.COL_CODE = 'TANO'           -- 发行机构属性(代销理财)
    LEFT JOIN DWD_PRDKT_INFO_DETAIL pt  -- 产品属性表(EAV)
      ON pt.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
     AND pt.COL_CODE = 'PRDKT_TERM'     -- 理财产品期限属性(已确认)
   WHERE p.PRDKT_CATE_BIG IN ('3', '4') -- 自营理财/代销理财大类
     AND p.PRDKT_STATE = '0';           -- 在售

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第5段完成: 候选产品池构建(方案A粒度)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.5 第6段: F1风险适配硬过滤 + C维评分(段1)
  -- F1统一判定: 客户等级(无理财测评默认C2=2)不低于产品等级(已确认)
  --***************************************
  V_NO_ID := '6';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_CART_SAFE (
      CUST_ID,     -- 客户编号
      PRDKT_ID,    -- 产品编号
      PRDKT_TERM,  -- 存期档
      C_SCORE      -- 风险舒适度得分
  )
  SELECT b.CUST_ID     AS CUST_ID,     -- 客户编号
         p.PRDKT_ID    AS PRDKT_ID,    -- 产品编号
         p.PRDKT_TERM  AS PRDKT_TERM,  -- 存期档
         CASE
             WHEN b.CUST_RISK_NUM - p.RISK_NUM = 0 THEN 100  -- C1 同档
             WHEN b.CUST_RISK_NUM - p.RISK_NUM = 1 THEN 90   -- C2 低1档
             WHEN b.CUST_RISK_NUM - p.RISK_NUM = 2 THEN 80   -- C3 低2档
             WHEN b.CUST_RISK_NUM - p.RISK_NUM = 3 THEN 70   -- C4 低3档
             ELSE 60                                          -- C5 低4档及以上(及格底线)
         END           AS C_SCORE      -- 风险舒适度得分(word 5.3五档; CUST_RISK_NUM默认C2恒有值)
    FROM TMP_RCMD_CUST_BASE b          -- 客户画像表
   CROSS JOIN TMP_RCMD_PRDKT_POOL p    -- 候选产品池
   WHERE b.CUST_RISK_NUM >= p.RISK_NUM -- F1: 客户等级不低于产品等级(无理财测评客户按默认C2统一判定, 已确认)
     AND p.TERM_MONTHS IS NOT NULL;    -- 产品期限缺失则不推此产品(已确认)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第6段完成: F1硬过滤与C维评分(无测评默认C2)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.6 第7段: B维期限匹配(段2, 锚点偏差五档)
  -- 锚点=近三年金额最大产品单点期限(已确认); 偏差=|产品期限月数-锚点月数|
  -- 客户无历史持有记录(锚点NULL)按0分(已确认); 产品期限缺失在段6已剔除不推(已确认)
  --***************************************
  V_NO_ID := '7';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_SCORE_DTL (
      CUST_ID,    -- 客户编号
      PRDKT_ID,   -- 产品编号
      PRDKT_TERM, -- 存期档
      C_SCORE,    -- 风险舒适度得分
      B_SCORE     -- 期限匹配度得分
  )
  SELECT s.CUST_ID    AS CUST_ID,    -- 客户编号
         s.PRDKT_ID   AS PRDKT_ID,   -- 产品编号
         s.PRDKT_TERM AS PRDKT_TERM, -- 存期档
         s.C_SCORE    AS C_SCORE,    -- 风险舒适度得分(段1回填)
         CASE
             WHEN b.TERM_ANCHOR_M IS NULL THEN 0                         -- 客户无历史持有记录0分(已确认)
             WHEN ABS(p.TERM_MONTHS - b.TERM_ANCHOR_M) = 0  THEN 100  -- B1 命中锚点
             WHEN ABS(p.TERM_MONTHS - b.TERM_ANCHOR_M) <= 3 THEN 80   -- B2 偏差小于等于3个月
             WHEN ABS(p.TERM_MONTHS - b.TERM_ANCHOR_M) <= 6 THEN 60   -- B3 偏差3个月至6个月
             WHEN ABS(p.TERM_MONTHS - b.TERM_ANCHOR_M) <= 12 THEN 30  -- B4 偏差6个月至12个月
             ELSE 0                                                    -- B5 偏差大于12个月
         END           AS B_SCORE     -- 期限匹配度得分(word 5.2锚点偏差五档, 已确认)
    FROM TMP_RCMD_CART_SAFE s         -- 安全候选交叉表
    JOIN TMP_RCMD_CUST_BASE b         -- 客户画像表
      ON b.CUST_ID = s.CUST_ID        -- 客户编号关联
    JOIN TMP_RCMD_PRDKT_POOL p        -- 候选产品池
      ON p.PRDKT_ID = s.PRDKT_ID      -- 产品编号关联
     AND NVL(p.PRDKT_TERM, 'X') = NVL(s.PRDKT_TERM, 'X');  -- 存期档关联(NULL档统一)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第7段完成: B维锚点偏差评分(五档)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.7 第8段: A维收益排名与回填(段3, 产品级预计算)
  -- 分组键: 类型+期限+等级(已确认); 样本阈值: 组内可比样本数<10时中性60(已确认)
  --***************************************
  V_NO_ID := '8';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_YIELD_SCORE (
      PRDKT_ID,   -- 产品编号
      PRDKT_TERM, -- 存期档
      GRP_KEY,    -- 同类分组键
      GRP_CNT,    -- 组内样本数
      A_SCORE     -- 收益吸引力得分
  )
  SELECT g.PRDKT_ID    AS PRDKT_ID,   -- 产品编号
         g.PRDKT_TERM  AS PRDKT_TERM, -- 存期档
         g.GRP_KEY     AS GRP_KEY,    -- 同类分组键(类型+期限+等级, 已确认)
         g.GRP_CNT     AS GRP_CNT,    -- 组内样本数
         CASE
             WHEN g.GRP_CNT < 10 THEN 60               -- 可比样本不足10个, 中性分60(已确认)
             WHEN g.p_rank <= 0.10 THEN 100  -- A1 前10%
             WHEN g.p_rank <= 0.30 THEN 80   -- A2 前10%-30%
             WHEN g.p_rank <= 0.50 THEN 60   -- A3 前30%-50%
             WHEN g.p_rank <= 0.80 THEN 30   -- A4 前50%-80%
             ELSE 0                           -- A5 后20%
         END           AS A_SCORE     -- 收益吸引力得分(word 5.1五档)
    FROM (
        SELECT p.PRDKT_ID     AS PRDKT_ID,     -- 产品编号
               p.PRDKT_TERM   AS PRDKT_TERM,   -- 存期档
               p.PRDKT_TYP || NVL(p.PRDKT_TERM, 'XX') || NVL(TO_CHAR(p.RISK_NUM), 'X') AS GRP_KEY,  -- 同类分组键
               COUNT(*) OVER (PARTITION BY p.PRDKT_TYP, p.PRDKT_TERM, p.RISK_NUM) AS GRP_CNT,       -- 组内样本数
               PERCENT_RANK() OVER (PARTITION BY p.PRDKT_TYP, p.PRDKT_TERM, p.RISK_NUM
                                    ORDER BY p.PRDKT_RATE DESC, p.PRDKT_ID ASC) AS p_rank          -- 组内收益降序百分位(同收益按编号稳定排序)
          FROM TMP_RCMD_PRDKT_POOL p            -- 候选产品池
         WHERE p.PRDKT_RATE IS NOT NULL         -- 有有效收益字段才参与排名
           AND p.IS_SELL = '是'                 -- 在售
    ) g;
  -- 分档边界已确认左闭右开: 0-10%含10%, 10%-30%不含10%含30%, 以此类推(与上方CASE级联语义一致)

  -- A维得分回填评分明细(产品级预计算结果挂接, 修复v2.1.0缺回填缺陷)
  MERGE INTO TMP_RCMD_SCORE_DTL s
  USING (
      SELECT y.PRDKT_ID   AS PRDKT_ID,   -- 产品编号
             y.PRDKT_TERM AS PRDKT_TERM, -- 存期档
             y.A_SCORE    AS A_SCORE     -- 收益吸引力得分
        FROM TMP_RCMD_YIELD_SCORE y      -- A维预计算表
  ) y ON (s.PRDKT_ID = y.PRDKT_ID
      AND NVL(s.PRDKT_TERM, 'X') = NVL(y.PRDKT_TERM, 'X'))
  WHEN MATCHED THEN UPDATE SET
      s.A_SCORE = y.A_SCORE;             -- 收益得分回填(无有效收益字段的产品保持NULL, 总分按中性60计)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第8段完成: A维收益排名与回填(样本阈值10)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.8 第9段: D维历史偏好组合判定(段4, 完整D1-D5)
  -- f2机构因素全类型生效: 存款=9999/自营理财=9999/代销理财=DETAIL TANO(均已确认)
  --***************************************
  V_NO_ID := '9';
  V_BGN_DATE := SYSDATE;

  MERGE INTO TMP_RCMD_SCORE_DTL s
  USING (
      SELECT s1.CUST_ID     AS CUST_ID,     -- 客户编号
             s1.PRDKT_ID    AS PRDKT_ID,    -- 产品编号
             s1.PRDKT_TERM  AS PRDKT_TERM,  -- 存期档
             CASE
                 WHEN f1 + f2 + f3 = 3 THEN 100            -- D1 三因素全中
                 WHEN f1 + f2 + f3 = 2 AND f1 = 1 THEN 80  -- D2 命中两项且含类型
                 WHEN f1 + f2 + f3 = 2 THEN 60             -- D3 命中两项不含类型
                 WHEN f1 + f2 + f3 = 1 THEN 30             -- D4 仅命中一项
                 ELSE 0                                     -- D5 均未命中
             END            AS D_SCORE      -- 历史偏好得分(word 5.4组合制)
        FROM (
            SELECT s0.CUST_ID,              -- 客户编号
                   s0.PRDKT_ID,             -- 产品编号
                   s0.PRDKT_TERM,           -- 存期档
                   CASE WHEN p.PRDKT_TYP = b.TOP_CATE THEN 1 ELSE 0 END AS f1,  -- 因素一: 类型与频次最高大类一致
                   CASE WHEN p.ISSU_ORG IS NOT NULL
                         AND b.TOP_ORG IS NOT NULL
                         AND p.ISSU_ORG = b.TOP_ORG
                        THEN 1 ELSE 0 END AS f2,                             -- 因素二: 发行机构与近一年购买最多机构一致
                   CASE WHEN b.CATE_SET IS NOT NULL
                         AND INSTR(',' || b.CATE_SET || ',', ',' || p.PRDKT_TYP || ',') > 0
                        THEN 1 ELSE 0 END AS f3                              -- 因素三: 近一年买过同类
              FROM TMP_RCMD_SCORE_DTL s0     -- 评分明细表
              JOIN TMP_RCMD_CUST_BASE b      -- 客户画像表
                ON b.CUST_ID = s0.CUST_ID    -- 客户编号关联
              JOIN TMP_RCMD_PRDKT_POOL p     -- 候选产品池
                ON p.PRDKT_ID = s0.PRDKT_ID  -- 产品编号关联
               AND NVL(p.PRDKT_TERM, 'X') = NVL(s0.PRDKT_TERM, 'X')  -- 存期档关联(NULL档统一)
        ) s1
  ) d ON (s.CUST_ID = d.CUST_ID
      AND s.PRDKT_ID = d.PRDKT_ID
      AND NVL(s.PRDKT_TERM, 'X') = NVL(d.PRDKT_TERM, 'X'))
  WHEN MATCHED THEN UPDATE SET
      s.D_SCORE = d.D_SCORE;                 -- 历史偏好得分回填

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第9段完成: D维组合判定(D1-D5全量)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3.9 第10段: 汇总评分/Top3/占位行/写目标表(段5)
  -- 总分 = NVL(A,60)x35% + NVL(B,60)x30% + NVL(C,60)x20% + NVL(D,0)x15%, 四舍五入2位(已确认)
  -- 中性分口径: A维无有效收益/样本不足60(word 5.1) / B维产品期限缺失60(数据不足; 客户无历史=0分段7已判) / D维无命中0(word 5.4)
  -- 当前持有产品可再次推荐(已确认, 无持有排除逻辑); 同分序以需求文档为准(已确认)
  --***************************************
  V_NO_ID := '10';
  V_BGN_DATE := SYSDATE;

  -- 3.9.1 Top3推荐结果(候选不足3全出, 同分序: 期限>收益>偏好>编号)
  INSERT INTO TMP_RCMD_RSLT (
      PERSN_LEGAL_BK_CODE, -- 法人行号
      DATA_DATE,           -- 数据日期
      CUST_ID,             -- 客户编号
      PRDKT_ID,            -- 产品编号
      PRDKT_TERM,          -- 存期档(方案A候选键, 3.9.3话术关联用)
      PRDKT_NAME,          -- 产品名称
      MATCH_DEG_PRDKT,     -- 产品匹配度
      PRDKT_TYP,           -- 产品类型
      RATE_INTRI,          -- 利率或预期收益率
      RISK_LVL,            -- 风险等级
      MKT_SCRIPT,          -- 营销话术
      RN                   -- 客户内排名
  )
  SELECT b.PERSN_LEGAL_BK_CODE AS PERSN_LEGAL_BK_CODE, -- 法人行号
         V_SYSDAT              AS DATA_DATE,           -- 数据日期
         t.CUST_ID             AS CUST_ID,             -- 客户编号
         t.PRDKT_ID            AS PRDKT_ID,            -- 产品编号
         t.PRDKT_TERM          AS PRDKT_TERM,          -- 存期档
         t.PRDKT_NAME          AS PRDKT_NAME,          -- 产品名称
         t.TOTAL_SCORE         AS MATCH_DEG_PRDKT,     -- 产品匹配度(加权总分)
         t.PRDKT_TYP           AS PRDKT_TYP,           -- 产品类型
         t.PRDKT_RATE          AS RATE_INTRI,          -- 利率或收益率(按原有精度落表, 已确认)
         t.RISK_LVL_TXT        AS RISK_LVL,            -- 风险等级
         NULL                  AS MKT_SCRIPT,          -- 营销话术(3.9.2拼接回填)
         t.RN                  AS RN                   -- 客户内排名(1-3)
    FROM (
        SELECT s.CUST_ID     AS CUST_ID,     -- 客户编号
               s.PRDKT_ID    AS PRDKT_ID,    -- 产品编号
               s.PRDKT_TERM  AS PRDKT_TERM,  -- 存期档
               p.PRDKT_NAME  AS PRDKT_NAME,  -- 产品名称
               p.PRDKT_TYP   AS PRDKT_TYP,   -- 产品类型
               p.PRDKT_RATE  AS PRDKT_RATE,  -- 利率或收益率
               p.RISK_LVL_TXT AS RISK_LVL_TXT,  -- 风险等级中文
               ROUND(NVL(s.A_SCORE, 60) * 0.35
                   + NVL(s.B_SCORE, 60) * 0.30
                   + NVL(s.C_SCORE, 60) * 0.20
                   + NVL(s.D_SCORE, 0) * 0.15, 2) AS TOTAL_SCORE,  -- 加权总分(四舍五入2位, 已确认; B维产品期限缺失中性60)
               ROW_NUMBER() OVER (
                   PARTITION BY s.CUST_ID
                   ORDER BY ROUND(NVL(s.A_SCORE, 60) * 0.35
                              + NVL(s.B_SCORE, 60) * 0.30
                              + NVL(s.C_SCORE, 60) * 0.20
                              + NVL(s.D_SCORE, 0) * 0.15, 2) DESC,  -- 同分序一: 综合总分降序(word 6)
                           NVL(s.B_SCORE, 60) DESC,                 -- 同分序二: 期限匹配度
                           NVL(s.A_SCORE, 60) DESC,                 -- 同分序三: 收益吸引力
                           NVL(s.D_SCORE, 0) DESC,                  -- 同分序四: 历史偏好
                           s.PRDKT_ID ASC                           -- 兜底: 产品编号升序
               ) AS RN                                              -- 客户内排名
          FROM TMP_RCMD_SCORE_DTL s                 -- 评分明细表
          JOIN TMP_RCMD_PRDKT_POOL p                -- 候选产品池
            ON p.PRDKT_ID = s.PRDKT_ID              -- 产品编号关联
           AND NVL(p.PRDKT_TERM, 'X') = NVL(s.PRDKT_TERM, 'X')  -- 存期档关联
    ) t
    JOIN TMP_RCMD_CUST_BASE b                       -- 客户画像表(法人行号补全)
      ON b.CUST_ID = t.CUST_ID                      -- 客户编号关联
   WHERE t.RN <= 3;                                 -- Top3(候选不足3时自然全出)

  -- 3.9.2 空候选占位行(候选为空的客户返回"暂无适配产品")
  INSERT INTO TMP_RCMD_RSLT (
      PERSN_LEGAL_BK_CODE, -- 法人行号
      DATA_DATE,           -- 数据日期
      CUST_ID,             -- 客户编号
      PRDKT_ID,            -- 产品编号
      PRDKT_TERM,          -- 存期档(占位行=NULL)
      PRDKT_NAME,          -- 产品名称
      MATCH_DEG_PRDKT,     -- 产品匹配度
      PRDKT_TYP,           -- 产品类型
      RATE_INTRI,          -- 利率或预期收益率
      RISK_LVL,            -- 风险等级
      MKT_SCRIPT,          -- 营销话术
      RN                   -- 客户内排名
  )
  SELECT b.PERSN_LEGAL_BK_CODE AS PERSN_LEGAL_BK_CODE,  -- 法人行号
         V_SYSDAT              AS DATA_DATE,            -- 数据日期
         b.CUST_ID             AS CUST_ID,              -- 客户编号
         'NA'                  AS PRDKT_ID,             -- 占位产品编号
         NULL                  AS PRDKT_TERM,           -- 占位存期档
         NULL                  AS PRDKT_NAME,           -- 占位产品名称
         NULL                  AS MATCH_DEG_PRDKT,      -- 占位匹配度
         NULL                  AS PRDKT_TYP,            -- 占位产品类型
         NULL                  AS RATE_INTRI,           -- 占位利率
         NULL                  AS RISK_LVL,             -- 占位风险等级
         '暂无适配产品'         AS MKT_SCRIPT,           -- 空候选提示语(word 6)
         1                     AS RN                    -- 占位排名
    FROM TMP_RCMD_CUST_BASE b                           -- 客户画像表
   WHERE NOT EXISTS (SELECT 1 FROM TMP_RCMD_RSLT r WHERE r.CUST_ID = b.CUST_ID AND r.DATA_DATE = V_SYSDAT);  -- 无任何推荐行的客户

  -- 3.9.3 推荐理由(word V1.1第7章: 组装顺序风险->期限->收益->偏好, 等级三档高>=80/中60-79/低<60, 数据不足用专用话术)
  UPDATE TMP_RCMD_RSLT r
     SET r.MKT_SCRIPT =
         '该产品'
         || h.risk_msg || '，'    -- 风险适配话术(RISK_MATCH)
         || h.term_msg || '，'    -- 期限命中的话术(TERM_MATCH)
         || h.yield_msg || '，'   -- 收益命中的话术(YIELD_TOP)
         || h.pref_msg || '。'    -- 偏好命中的话术(HISTORY_MATCH)
   FROM (
       SELECT s.CUST_ID     AS cust,      -- 客户编号
              s.PRDKT_ID    AS prd,       -- 产品编号
              s.PRDKT_TERM  AS term,      -- 存期档
              CASE WHEN NVL(s.C_SCORE, 60) >= 80 THEN '风险等级符合客户承受能力，风险适配度较高'          -- 高(>=80)
                   WHEN NVL(s.C_SCORE, 60) >= 60 THEN '产品风险等级低于客户承受上限，整体风险处于可承受范围'  -- 中(60-79)
                   ELSE '产品风险等级与客户承受能力匹配度一般，建议结合自身风险承受能力审慎选择'           -- 低(<60)
              END AS risk_msg,            -- 风险适配话术(word 7.3.1)
              CASE WHEN b2.TERM_ANCHOR_M IS NULL THEN '暂无足够历史购买记录，期限偏好按中性结果处理'      -- 客户无历史持有(段7按0分, 数据不足专用话术word 7.3.2)
                   WHEN s.B_SCORE >= 80        THEN '产品期限落入客户历史偏好的主要期限区间，期限匹配度较高'  -- 高(>=80)
                   WHEN s.B_SCORE >= 60        THEN '产品期限与客户历史偏好接近，期限匹配度一般'            -- 中(60-79)
                   ELSE '产品期限与客户历史偏好偏差较大，期限匹配度较低'                    -- 低(<60, 有历史偏差大于12个月)
              END AS term_msg,            -- 期限命中的话术(word 7.3.2)
              CASE WHEN s.A_SCORE IS NULL      THEN '无有效收益字段，暂不判断收益表现'                  -- 无有效收益字段(段8未回填, NVL中性60, 数据不足专用话术word 7.3.3)
                   WHEN s.A_SCORE = 60 AND ys.GRP_CNT < 10 THEN '暂无足够可比样本，收益表现按中性结果处理'  -- 组内可比样本不足10(段8中性60, 数据不足专用话术word 7.3.3)
                   WHEN s.A_SCORE >= 80        THEN '同类产品收益表现靠前'                             -- 高(>=80)
                   WHEN s.A_SCORE >= 60        THEN '同类产品收益表现处于中等水平'                       -- 中(60-79)
                   ELSE '同类产品收益表现靠后'                                               -- 低(<60)
              END AS yield_msg,           -- 收益命中的话术(word 7.3.3)
              CASE WHEN NVL(s.D_SCORE, 0) >= 80 THEN '产品与客户过往购买偏好一致，且客户曾购买同类产品'     -- 高(>=80)
                   WHEN NVL(s.D_SCORE, 0) >= 60 THEN '产品与客户部分过往购买偏好相符'                     -- 中(60-79)
                   ELSE '产品与客户过往购买偏好匹配度较低，或客户暂无同类购买记录'             -- 低(<60)
              END AS pref_msg             -- 偏好命中的话术(word 7.3.4)
         FROM TMP_RCMD_SCORE_DTL s         -- 评分明细表
         JOIN TMP_RCMD_CUST_BASE b2        -- 客户画像表(取期限偏好锚点判无历史持有)
           ON b2.CUST_ID = s.CUST_ID       -- 客户编号关联
         LEFT JOIN TMP_RCMD_YIELD_SCORE ys -- A维预计算表(取组内样本数判样本不足)
           ON ys.PRDKT_ID = s.PRDKT_ID     -- 产品编号关联
          AND NVL(ys.PRDKT_TERM, 'X') = NVL(s.PRDKT_TERM, 'X')  -- 存期档关联(NULL档统一, 与段8回填一致)
   ) h
   WHERE r.CUST_ID = h.cust                -- 客户编号关联
     AND r.PRDKT_ID = h.prd                -- 产品编号关联
     AND NVL(r.PRDKT_TERM, 'X') = NVL(h.term, 'X')  -- 存期档关联
     AND r.PRDKT_ID <> 'NA';               -- 排除占位行

  -- 3.9.4 写目标表(10列定稿)
  INSERT INTO ADS_CUST_PRDKT_RCMD (
      PERSN_LEGAL_BK_CODE, -- 法人行号
      DATA_DATE,           -- 数据日期
      CUST_ID,             -- 客户编号
      PRDKT_ID,            -- 产品编号
      PRDKT_NAME,          -- 产品名称
      MATCH_DEG_PRDKT,     -- 产品匹配度
      PRDKT_TYP,           -- 产品类型
      RATE_INTRI,          -- 利率或预期收益率
      RISK_LVL,            -- 风险等级
      MKT_SCRIPT           -- 营销话术
  )
  SELECT r.PERSN_LEGAL_BK_CODE AS PERSN_LEGAL_BK_CODE,  -- 法人行号
         r.DATA_DATE           AS DATA_DATE,            -- 数据日期
         r.CUST_ID             AS CUST_ID,              -- 客户编号
         r.PRDKT_ID            AS PRDKT_ID,             -- 产品编号
         r.PRDKT_NAME          AS PRDKT_NAME,           -- 产品名称
         r.MATCH_DEG_PRDKT     AS MATCH_DEG_PRDKT,      -- 产品匹配度
         r.PRDKT_TYP           AS PRDKT_TYP,            -- 产品类型
         r.RATE_INTRI          AS RATE_INTRI,           -- 利率或预期收益率
         r.RISK_LVL            AS RISK_LVL,             -- 风险等级
         r.MKT_SCRIPT          AS MKT_SCRIPT            -- 营销话术
    FROM TMP_RCMD_RSLT r;                               -- 推荐结果中间表

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第10段完成: 汇总评分/Top3/占位行/写目标表';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 4. 异常处理区(捕获错误码并记录详细日志)
  ------------------------------------------------------------------
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
        V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
        V_BGN_DATE, V_END_DATE, V_DURA_DATE,
        V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
    );

    RAISE;
END;
