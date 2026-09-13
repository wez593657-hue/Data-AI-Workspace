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
  -- 架构: "分层TMP物化+单次评分装配直出Top3"(requirements/产品推荐新架构设计.md;
  --       v2.6.2 按requirements/产品推荐优化方案.md合并装配层与输出层, v2.6.3窄行排序):
  --       L1特征层 FTR_CUST(客户宽表) / FTR_PRD(产品宽表含A维预评分) + ANALYZE统计刷新
  --       L2+L3合并段: F1非等值JOIN单次装配, 8列窄行窗口排序出Top3后回挂宽属性+话术直出RSLT
  --       写目标表段: 目标表TRUNCATE后移至本段(下游空窗缩至写表段, 前段失败保留昨日数据)
  --       中间表 7 张精简为 3 张, 中间 UPDATE/MERGE 0 次
  --
  -- 参数说明:
  --   V_SYSDAT  跑批数据日期 YYYYMMDD
  --   OUTCDE    输出码 0-成功 -1-失败
  --
  -- 评分模型(word V1.1): 总分 = A x 35% + B x 30% + C x 20% + D x 15%
  --   A 收益吸引力(同类分组排名五档) / B 期限匹配度(年日均最大锚点偏差五档, 2026-09-02口径升级)
  --   C 风险舒适度(档位差五档)     / D 历史偏好(三因素组合制)
  --   权重/边界/阈值集中为声明区常量, 业务调整仅改常量区
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
  --   v2.5.4 2026-09-03 结构与类型修复: 日期参数改声明区纯声明+BEGIN参数校验后初始化区
  --          赋值(对齐治理规则"DECLARE区声明,初始化区赋值", 消除入参未校验先计算与声明区
  --          异常不可捕获缺陷); 理财TERM_MONTHS修复字符串隐式转数字相减(改TO_DATE显式
  --          转换后相减, DWD日期字段为VARCHAR(YYYYMMDD)上游FMS透传); 理财BUY_DATE补
  --          TO_DATE显式转换(消除NLS隐式转换依赖); 过期注释修正(类型码01-04定稿✅-46/
  --          锚点口径年日均最大v2.4.0); 理财分支外币过滤缺失标记【待确认】
  --   v2.5.5 2026-09-03 存款历史持有取数简化(用户确认): 段3存款分支删除DWD_TX_ASET
  --          交易流水关联子查询, 购买日期改取DWD_ACCT_DEPO.OPEN_DATE开户日期
  --          (TO_DATE显式转换), 近三年窗口改按OPEN_DATE过滤(原按INTRI_BGN_DATE起息日),
  --          购买金额改取BAL账户余额(原取TX_ASET发生额); 冗余清理: 参数校验去正则改
  --          LENGTH检查(05规范5.8.2)并删校验性TO_DATE解析(合法性由初始化区保证),
  --          删除恒非空维度的冗余NVL(B/C/D得分与存期档关联7处, 仅保留A维可空NVL),
  --          删除候选池恒真IS_SELL过滤, D维f2/f3冗余IS NOT NULL判空简化
  --   v2.6.0 2026-09-03 架构重构(分层TMP物化+单次评分装配, 按requirements/产品推荐
  --          新架构设计.md落地评审): TMP 7张精简为4张(新增FTR_CUST客户特征宽表/
  --          FTR_PRD产品特征宽表, 删除CUST_BASE/HIS_HOLD/PRDKT_POOL/CART_SAFE/
  --          YIELD_SCORE, SCORE_DTL删TOTAL_SCORE列); 原段2+3+4合并为L1客户特征
  --          单次INSERT(CTE窗口函数链同算风险/锚点/TOP频次/大类集合, 明细层
  --          COUNT(*) OVER直接得组内总笔数); 原段5+8合并为L1产品特征(EAV条件聚合
  --          MAX CASE替代7次DETAIL自关联, PERCENT_RANK预计算A_SCORE/GRP_CNT落表);
  --          原段6+7+9合并为L2单次INSERT(F1改JOIN ON非等值连接, B/C/D同批算出,
  --          消除CROSS JOIN与2次MERGE回填); 话术并入L3 Top3 INSERT(消除话术UPDATE,
  --          中间UPDATE/MERGE降为0); 评分权重/B维边界/A维阈值与中性分/默认档
  --          常量化(声明区CONSTANT); 业务口径✅-01~46/评分五档/同分序/话术模板
  --          全部保持不变; 理财外币过滤待确认项(O01)与TOP频次笔数口径待确认项(O02)延续
  --   v2.6.1 2026-09-03 客户粒度与期限解析修正(用户审查发现): 客户粒度确认为客户号+法人行,
  --          L1画像/锚点窗口与分组、L2评分明细(新增PERSN_LEGAL_BK_CODE列)、L3 Top3的
  --          ROW_NUMBER分区及FTR_CUST关联、占位行NOT EXISTS全部改双键(修复同客户号跨
  --          法人行画像混算/Top3跨行混排/占位行误判漏行); FTR_CUST恢复SELECT DISTINCT
  --          防御主表重复行; 定期分支期限月数由RTRIM('M')+TO_NUMBER改与✅-30同规则的
  --          D/M/Y统一解析(修复D/Y值域抛INVALID_NUMBER缺陷, 异常值域自然落NULL)
  --   v2.6.2 2026-09-04 性能优化(不改动业务口径, requirements/产品推荐优化方案.md评审确认):
  --          原段4(L2装配SCORE_DTL)+段5.1(Top3+话术)合并为单段"L2+L3合并直出"(内层单次JOIN
  --          同算B/C/D各CASE仅写一次, 中层算加权总分+ROW_NUMBER窗口排序引用内层列, 外层
  --          RN<=3截断+话术直出RSLT), 删除TMP_RCMD_SCORE_DTL(全过程中间结果集最大的写放大
  --          点: 全量明细落表+读回两次IO消除), 中间表4张精简为3张; 方案原稿2处机械错误修正
  --          (外层p./c.前缀引用、ranked未物化TERM_ANCHOR_M); 目标表TRUNCATE由段1后移至写
  --          目标表段(下游空窗由全过程时长缩至写表段, 写表段前失败保留昨日全量数据); 段3后
  --          新增ANALYZE两张特征表(TRUNCATE+重灌后统计过期影响非等值JOIN计划)【待确认:
  --          ANALYZE语句形态投产前测试库验证】; 段号6->5; 评分五档/同分序/话术模板/F1硬过滤/
  --          占位行/双键分区全部保持不变
  --   v2.6.3 2026-09-04 段4性能优化(不改动业务口径, 段4跑批耗时专项): L2+L3合并段改四层
  --          结构——内层JOIN+评分输出8列窄行, 中层总分+ROW_NUMBER窗口排序仅承载窄行
  --          (PRDKT_NAME/RATE/RISK_LVL_TXT/GRP_CNT/TERM_ANCHOR_M等宽属性剥离出WINDOW SORT,
  --          排序元组宽度降约60%), 外层RN<=3截断后按(产品编号+存期档)回挂FTR_PRD、按
  --          (客户号+法人行)回挂FTR_CUST再拼话术; 同分序键仅依赖窄行列, RN结果与话术
  --          逐字不变(与v2.6.2逐项等价); P1候选(档位x产品等值展开消除非等值Nested Loop)
  --          待测试库EXPLAIN(ANALYZE,BUFFERS)确认后另行实施
  --   v2.6.4 2026-09-05 产品名称展示拼接(用户确认): 段5写目标表ADS_CUST_PRDKT_RCMD
  --          时PRDKT_NAME改"名称-存期档"拼接(如"个人整存整取-3Y"), 存期档直接
  --          拼PRDKT_TERM原值(定期=ZB归一化形态如12M, 智能/理财=DETAIL属性原值
  --          D/M/Y+数字), 不做格式换算; 占位行名称/存期档均NULL, 拼接结果仍NULL;
  --          直接拼接不截断(拼接结果超100字符极端情形列溢出行为投产前测试库确认)
  ------------------------------------------------------------------
  ------------------------------------------------------------------
  -- 评分参数常量(word V1.1; 业务调整仅改此处, 集中管理)
  ------------------------------------------------------------------
  C_WEIGHT_A             CONSTANT NUMBER := 0.35;  -- A维收益吸引力权重
  C_WEIGHT_B             CONSTANT NUMBER := 0.30;  -- B维期限匹配度权重
  C_WEIGHT_C             CONSTANT NUMBER := 0.20;  -- C维风险舒适度权重
  C_WEIGHT_D             CONSTANT NUMBER := 0.15;  -- D维历史偏好权重
  C_B_DEV_EQ             CONSTANT NUMBER := 0;     -- B维偏差边界(月): 命中锚点
  C_B_DEV_3              CONSTANT NUMBER := 3;     -- B维偏差边界(月): 3个月
  C_B_DEV_6              CONSTANT NUMBER := 6;     -- B维偏差边界(月): 6个月
  C_B_DEV_12             CONSTANT NUMBER := 12;    -- B维偏差边界(月): 12个月
  C_A_GRP_MIN            CONSTANT NUMBER := 10;    -- A维同类样本不足阈值(走中性分, 已确认)
  C_A_NEUTRAL            CONSTANT NUMBER := 60;    -- A维中性分(样本不足/无有效收益字段)
  C_CUST_RISK_DFLT       CONSTANT NUMBER := 2;     -- 无理财测评客户默认档(C2, 已确认)
  ------------------------------------------------------------------
  -- 日志变量
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
  ------------------------------------------------------------------
  -- 业务日期参数: 仅声明本过程必需的日期, 规则见 governance/stored_procedure_date_parameter_rules.md
  -- 声明区仅声明, 由 BEGIN 内参数校验通过后的日期参数初始化区统一赋值(治理规则: DECLARE区声明, 初始化区赋值)
  ------------------------------------------------------------------
  V_HIS_3Y_BGN           VARCHAR(8);  -- 近三年窗口起点(B维, 36个月滚动, 已确认; 参数19=三年历史清理边界)
  V_HIS_1Y_BGN           VARCHAR(8);  -- 近一年窗口起点(D维, 12个月滚动, 已确认; 参数29=近一年, 已登记治理规则表)
  V_LAST_YEAR_END        VARCHAR(8);  -- 真上年末YYYY1231(B维年日均取数基准, 对齐标签表储蓄期限偏好口径; 参数4=上年末)
BEGIN
  --***************************************
  -- 1. 自定义参数区: 参数校验 + 日期参数初始化 + 中间表清理
  --***************************************
  V_NO_ID := '1';
  V_BGN_DATE := SYSDATE;

  -- 参数校验: 仅 IS NULL + LENGTH 检查(05 规范 5.8.2, 不写正则); 日期合法性由初始化区 sys_fun_deal_date 内部 TO_DATE 保证, 非法值抛错进入异常处理
  IF V_SYSDAT IS NULL OR LENGTH(V_SYSDAT) != 8 THEN
    RAISE_APPLICATION_ERROR(-20001, 'V_SYSDAT must be in YYYYMMDD format');
  END IF;

  --***************************************
  -- 1.1 日期参数初始化区(入参校验通过后由治理函数统一赋值)
  -- 对齐 governance 规则"DECLARE区声明, 初始化区赋值"与 oracle_PRC_ADS_STAT_INDX_DATA 范式
  --***************************************
  V_HIS_3Y_BGN    := sys_fun_deal_date(V_SYSDAT, 19);  -- 近三年窗口起点(36个月滚动)
  V_HIS_1Y_BGN    := sys_fun_deal_date(V_SYSDAT, 29);  -- 近一年窗口起点(12个月滚动)
  V_LAST_YEAR_END := sys_fun_deal_date(V_SYSDAT, 4);   -- 真上年末YYYY1231(原推导ADD_MONTHS(TRUNC,'YYYY'),-1实为上年末12月1日)

  -- 中间表清理(每日全量重跑, TRUNCATE保证幂等); 目标表TRUNCATE后移至写目标表段(v2.6.2:
  -- 下游空窗由全过程时长缩至写表段, 且本过程写表段前失败时目标表保留昨日全量数据)
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_FTR_CUST';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_FTR_PRD';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_RCMD_RSLT';

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第1段完成: 参数校验+日期初始化+3张中间表清理';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 2. L1特征层: 客户特征宽表 TMP_RCMD_FTR_CUST(原段2+3+4合并)
  -- 单次INSERT一次算齐: 全行圈选+理财线风险测评+历史持有双源(近三年)窗口画像
  -- (近一年TOP频次/大类集合)+年日均锚点; 逻辑单次扫描双源大表
  --***************************************
  V_NO_ID := '2';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_FTR_CUST (
      CUST_ID,             -- 客户编号
      PERSN_LEGAL_BK_CODE, -- 法人行号
      CUST_RISK_NUM,       -- 客户风险档位数值
      TERM_ANCHOR_M,       -- 期限偏好锚点(月)
      TOP_CATE,            -- 近一年频次最高大类
      TOP_ORG,             -- 近一年购买最多机构
      CATE_SET             -- 近一年购买大类集合
  )
WITH /*+ MATERIALIZE */ his_hold AS (
    -- 理财分支
    SELECT f.PERSN_LEGAL_BK_CODE,
           f.CUST_ID,
           f.PRDKT_ID,
           CASE WHEN f.PRDKT_CATE_BIG = '3' THEN '03' ELSE '04' END AS PRDKT_TYP,
           TO_DATE(f.ISSU_DATE, 'YYYYMMDD') AS BUY_DATE,
           f.FIN_AMT AS BUY_AMT,
           f.ISSU_ORG,
           CASE WHEN f.EXPR_DATE IS NOT NULL AND f.INTRI_BGN_DATE IS NOT NULL
                THEN ROUND((TO_DATE(f.EXPR_DATE, 'YYYYMMDD') - TO_DATE(f.INTRI_BGN_DATE, 'YYYYMMDD')) / 30, 2)
           END AS TERM_MONTHS,
           NVL(h0.YAR_BAL, 0) / NULLIF(NVL(h0.YAR_DAYS, 0), 0) AS YR_AVG_AMT
      FROM DWD_ACCT_FIN f
      LEFT JOIN DWS_CUST_ASSE_LIAB_CUMU_HIS h0
        ON h0.PERSN_LEGAL_BK_CODE = f.PERSN_LEGAL_BK_CODE
       AND h0.CUST_ID            = f.CUST_ID
       AND h0.ACCT_ID            = f.ACCT_ID
       AND h0.PRDKT_ID           = f.PRDKT_ID
       AND h0.PRDKT_TYP          = '3'
       AND h0.DATA_DATE          = V_LAST_YEAR_END
     WHERE f.ISSU_DATE >= V_HIS_3Y_BGN
    UNION ALL
    -- 存款分支
    SELECT d.PERSN_LEGAL_BK_CODE,
           d.CUST_ID,
           d.PRDKT_ID,
           CASE WHEN d.PRDKT_CATE_BIG IN ('03', '05') THEN '02' ELSE '01' END AS PRDKT_TYP,
           TO_DATE(d.OPEN_DATE, 'YYYYMMDD') AS BUY_DATE,
           d.BAL AS BUY_AMT,
           '9999' AS ISSU_ORG,
           CASE UPPER(SUBSTR(d.CUNQ, -1))
               WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(d.CUNQ, 1, LENGTH(d.CUNQ) - 1)) / 30, 2)
               WHEN 'M' THEN TO_NUMBER(SUBSTR(d.CUNQ, 1, LENGTH(d.CUNQ) - 1))
               WHEN 'Y' THEN TO_NUMBER(SUBSTR(d.CUNQ, 1, LENGTH(d.CUNQ) - 1)) * 12
           END AS TERM_MONTHS,
           NVL(hd.YAR_BAL, 0) / NULLIF(NVL(hd.YAR_DAYS, 0), 0) AS YR_AVG_AMT
      FROM DWD_ACCT_DEPO d
      LEFT JOIN DWS_CUST_ASSE_LIAB_CUMU_HIS hd
        ON hd.PERSN_LEGAL_BK_CODE = d.PERSN_LEGAL_BK_CODE
       AND hd.CUST_ID            = d.CUST_ID
       AND hd.ACCT_ID            = d.ACCT_ID
       AND hd.PRDKT_ID           = d.PRDKT_ID
       AND hd.PRDKT_TYP          = '1'
       AND hd.DATA_DATE          = V_LAST_YEAR_END
     WHERE (d.FIX_CURNT_FLG = '1' OR d.PRDKT_CATE_BIG IN ('03', '05'))
       AND d.OPEN_DATE >= V_HIS_3Y_BGN
),
prof_top AS (
    -- 近一年购买画像：频次最高的大类与机构
    SELECT CUST_ID,
           PERSN_LEGAL_BK_CODE,
           MAX(PRDKT_TYP) KEEP (DENSE_RANK FIRST ORDER BY cate_cnt DESC, PRDKT_TYP) AS TOP_CATE,
           MAX(ISSU_ORG) KEEP (DENSE_RANK FIRST ORDER BY org_cnt DESC, ISSU_ORG) AS TOP_ORG
      FROM (
          SELECT CUST_ID,
                 PERSN_LEGAL_BK_CODE,
                 PRDKT_TYP,
                 ISSU_ORG,
                 COUNT(*) OVER (PARTITION BY CUST_ID, PERSN_LEGAL_BK_CODE, PRDKT_TYP) AS cate_cnt,
                 COUNT(*) OVER (PARTITION BY CUST_ID, PERSN_LEGAL_BK_CODE, ISSU_ORG) AS org_cnt
            FROM his_hold
           WHERE BUY_DATE >= TO_DATE(V_HIS_1Y_BGN, 'YYYYMMDD')
      )
     GROUP BY CUST_ID, PERSN_LEGAL_BK_CODE
),
prof_cate AS (
    -- 近一年购买过的大类集合（先 DISTINCT 再 LISTAGG，兼容低版本 Oracle）
    SELECT CUST_ID,
           PERSN_LEGAL_BK_CODE,
           LISTAGG(PRDKT_TYP, ',') WITHIN GROUP (ORDER BY PRDKT_TYP) AS CATE_SET
      FROM (
          SELECT DISTINCT CUST_ID, PERSN_LEGAL_BK_CODE, PRDKT_TYP
            FROM his_hold
           WHERE BUY_DATE >= TO_DATE(V_HIS_1Y_BGN, 'YYYYMMDD')
      )
     GROUP BY CUST_ID, PERSN_LEGAL_BK_CODE
),
anch AS (
    -- 期限偏好锚点：年日均最大产品的期限
    SELECT CUST_ID,
           PERSN_LEGAL_BK_CODE,
           MAX(TERM_MONTHS) KEEP (
               DENSE_RANK FIRST
               ORDER BY YR_AVG_AMT DESC NULLS LAST, BUY_AMT DESC, BUY_DATE DESC, PRDKT_ID
           ) AS TERM_ANCHOR_M
      FROM his_hold
     WHERE TERM_MONTHS IS NOT NULL
     GROUP BY CUST_ID, PERSN_LEGAL_BK_CODE
)
SELECT DISTINCT
       c.CUST_ID,
       c.PERSN_LEGAL_BK_CODE,
       NVL(rsk.RISK_NUM, C_CUST_RISK_DFLT) AS CUST_RISK_NUM,
       anch.TERM_ANCHOR_M,
       prof_top.TOP_CATE,
       prof_top.TOP_ORG,
       prof_cate.CATE_SET
  FROM DWD_CUST_INDV_INFO c
  LEFT JOIN (
      SELECT CUST_ID,
             PERSN_LEGAL_BK_CODE,
             TO_NUMBER(RISK_LVL) AS RISK_NUM
        FROM (
            SELECT CUST_ID,
                   PERSN_LEGAL_BK_CODE,
                   RISK_LVL,
                   ROW_NUMBER() OVER (PARTITION BY CUST_ID, PERSN_LEGAL_BK_CODE ORDER BY ESTIM_DATE DESC) AS RN
              FROM DWD_CUST_INDIV_RISK_INVST
             WHERE INVEST_TYP = '3'
               AND ESTIM_DATE <= V_SYSDAT
               AND (EXPR_DATE IS NULL OR EXPR_DATE >= V_SYSDAT)
        )
       WHERE RN = 1
  ) rsk
    ON rsk.CUST_ID = c.CUST_ID
   AND rsk.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE
  LEFT JOIN anch
    ON anch.CUST_ID = c.CUST_ID
   AND anch.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE
  LEFT JOIN prof_top
    ON prof_top.CUST_ID = c.CUST_ID
   AND prof_top.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE
  LEFT JOIN prof_cate
    ON prof_cate.CUST_ID = c.CUST_ID
   AND prof_cate.PERSN_LEGAL_BK_CODE = c.PERSN_LEGAL_BK_CODE;

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第2段完成: L1客户特征宽表(圈选+风险+画像+锚点)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 3. L1特征层: 产品特征宽表 TMP_RCMD_FTR_PRD(原段5+8合并)
  -- 三候选分支+EAV条件聚合(MAX CASE替代原7次DETAIL自关联)+PERCENT_RANK预计算A_SCORE/GRP_CNT
  -- 发行机构: 存款=9999/自营理财=9999/代销理财=DETAIL TANO(均已确认); 外币不纳入候选(定期分支币种过滤, 理财分支见【待确认】)
  --***************************************
  V_NO_ID := '3';
  V_BGN_DATE := SYSDATE;

  INSERT INTO TMP_RCMD_FTR_PRD (
      PRDKT_ID,     -- 产品编号
      PRDKT_TERM,   -- 存期档
      TERM_MONTHS,  -- 期限月数
      PRDKT_NAME,   -- 产品名称
      PRDKT_TYP,    -- 推荐产品类型
      PRDKT_RATE,   -- 利率或收益率
      RISK_LVL_TXT, -- 风险等级
      RISK_NUM,     -- 风险档位数值
      ISSU_ORG,     -- 发行机构
      GRP_CNT,      -- A维同类分组键内样本数
      A_SCORE       -- A维收益吸引力得分(预计算)
  )
  WITH pool AS (
      -- 候选全集(原段5三分支口径不变)
      SELECT p.PRDKT_ID    AS PRDKT_ID,     -- 产品编号(CBS_前缀)
             z.PRDKT_TERM  AS PRDKT_TERM,   -- 存期档(ZB上游归一化1Y->12M等; 兼容D/Y原始值域)
             -- 期限月数: 与✅-30 D/M/Y同规则统一解析(修复原RTRIM('M')+TO_NUMBER对D/Y值域抛INVALID_NUMBER缺陷; 异常值域自然落NULL, L2期限缺失剔除)
             CASE UPPER(SUBSTR(z.PRDKT_TERM, -1))
                 WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(z.PRDKT_TERM, 1, LENGTH(z.PRDKT_TERM) - 1)) / 30, 2)  -- nD=天数按30天/月折算
                 WHEN 'M' THEN TO_NUMBER(SUBSTR(z.PRDKT_TERM, 1, LENGTH(z.PRDKT_TERM) - 1))                -- nM=月数
                 WHEN 'Y' THEN TO_NUMBER(SUBSTR(z.PRDKT_TERM, 1, LENGTH(z.PRDKT_TERM) - 1)) * 12           -- nY=年数x12
             END AS TERM_MONTHS,
             p.PRDKT_NAME  AS PRDKT_NAME,   -- 产品名称
             '01'          AS PRDKT_TYP,    -- 推荐产品类型(01-定期存款, ✅-46定稿)
             z.PRDKT_RATE  AS PRDKT_RATE,   -- 实际利率(ZB表, 时点正确)
             'R1'          AS RISK_LVL_TXT, -- 存款风险等级固定R1(已确认)
             1             AS RISK_NUM,     -- 存款风险档位固定1(已确认)
             '9999'        AS ISSU_ORG      -- 发行机构(存款固定9999, 已确认)
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
             agg.PRD_TERM  AS PRDKT_TERM,   -- 产品期限(DETAIL PRDKT_TERM属性, 值域D/M/Y+数字, 已确认)
             CASE UPPER(SUBSTR(agg.PRD_TERM, -1))                                   -- 期限值域D/M/Y+数字(已确认)
                 WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(agg.PRD_TERM, 1, LENGTH(agg.PRD_TERM) - 1)) / 30, 2)  -- nD=天数按30天/月折算
                 WHEN 'M' THEN TO_NUMBER(SUBSTR(agg.PRD_TERM, 1, LENGTH(agg.PRD_TERM) - 1))                -- nM=月数
                 WHEN 'Y' THEN TO_NUMBER(SUBSTR(agg.PRD_TERM, 1, LENGTH(agg.PRD_TERM) - 1)) * 12           -- nY=年数x12
             END AS TERM_MONTHS,  -- 期限月数(PRDKT_TERM解析, 已确认; 异常值域自然落NULL)
             p.PRDKT_NAME  AS PRDKT_NAME,   -- 产品名称
             '02'          AS PRDKT_TYP,    -- 推荐产品类型(02-智能存款, ✅-46定稿)
             TO_NUMBER(agg.RATE_VAL) AS PRDKT_RATE,  -- 利率(DETAIL PRDKT_RATE属性, 已确认)
             'R1'          AS RISK_LVL_TXT, -- 存款风险等级固定R1(已确认)
             1             AS RISK_NUM,     -- 存款风险档位固定1(已确认)
             '9999'        AS ISSU_ORG      -- 发行机构(存款固定9999, 已确认)
        FROM DWD_PRDKT_INFO p               -- 产品主表
       INNER JOIN DWD_PRDKT_CATLOG cl       -- 产品目录表(属性表关联中转)
          ON cl.PRDKT_CATLOG_ID = p.PRDKT_ID  -- 目录编号=产品编号(CDS_前缀)
        LEFT JOIN (                        -- EAV条件聚合(一次扫描取利率/期限两个属性, 替代原tr INNER/pt LEFT两次自关联)
            SELECT PRDKT_CATLOG_PATH,      -- 目录路径
                   MAX(CASE WHEN COL_CODE = 'PRDKT_RATE' THEN COL_VALUE END) AS RATE_VAL,  -- 利率属性值
                   MAX(CASE WHEN COL_CODE = 'PRDKT_TERM' THEN COL_VALUE END) AS PRD_TERM  -- 产品期限属性值
              FROM DWD_PRDKT_INFO_DETAIL   -- 产品属性表(EAV)
             WHERE COL_CODE IN ('PRDKT_RATE', 'PRDKT_TERM')
             GROUP BY PRDKT_CATLOG_PATH
        ) agg ON agg.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
       WHERE p.PRDKT_CATE_BIG = '1'         -- 存款大类
         AND p.SYS_SRC = 'CDS'              -- 系统来源=智能存款
         AND p.PRDKT_STATE = '0'            -- 在售(分支无分号, UNION ALL续接理财分支)
         AND agg.RATE_VAL IS NOT NULL       -- 利率属性缺失产品不入池(等价原INNER JOIN tr语义)
      UNION ALL
      SELECT p.PRDKT_ID    AS PRDKT_ID,     -- 产品编号(FMS_前缀)
             agg.PRD_TERM  AS PRDKT_TERM,   -- 理财产品期限(DETAIL PRDKT_TERM属性, 值域D/M/Y+数字同✅-30, 已确认)
             CASE UPPER(SUBSTR(agg.PRD_TERM, -1))                                   -- 理财期限值域D/M/Y+数字, 与智能存款同属性同规则(已确认)
                 WHEN 'D' THEN ROUND(TO_NUMBER(SUBSTR(agg.PRD_TERM, 1, LENGTH(agg.PRD_TERM) - 1)) / 30, 2)  -- nD=天数按30天/月折算
                 WHEN 'M' THEN TO_NUMBER(SUBSTR(agg.PRD_TERM, 1, LENGTH(agg.PRD_TERM) - 1))                -- nM=月数
                 WHEN 'Y' THEN TO_NUMBER(SUBSTR(agg.PRD_TERM, 1, LENGTH(agg.PRD_TERM) - 1)) * 12           -- nY=年数x12
             END AS TERM_MONTHS,  -- 期限月数(PRDKT_TERM解析; 异常值域自然落NULL, 缺失则产品不推)
             p.PRDKT_NAME  AS PRDKT_NAME,   -- 产品名称
             CASE WHEN p.PRDKT_CATE_BIG = '3' THEN '03' ELSE '04' END AS PRDKT_TYP,  -- 自营/代销理财类型码(03/04, ✅-46定稿)
             CASE WHEN p.PRDKT_CATE_BIG = '3' THEN TO_NUMBER(agg.MARK_EXP)             -- 自营理财: 业绩比较基准MARK_EXP(已确认, 纯数值型)
                  ELSE NVL(TO_NUMBER(agg.INCOME_3M), TO_NUMBER(agg.INCOME_7))          -- 代销理财: 近三月INCOME_RATE_3M优先, 无则七日INCOME_RATE_7兜底(已确认)
             END AS PRDKT_RATE,   -- 收益率(理财收益口径已确认)
             'R' || TO_NUMBER(agg.RISK_VAL) AS RISK_LVL_TXT,  -- 风险等级R1-R5(COL_VALUE 01-05, 已确认)
             TO_NUMBER(agg.RISK_VAL) AS RISK_NUM,     -- 风险档位数值(01-极低/02-低/03-中/04-高/05-极高, 已确认)
             CASE WHEN p.PRDKT_CATE_BIG = '3' THEN '9999'                             -- 自营理财发行机构=本行9999(已确认)
                  ELSE agg.TANO                                                       -- 代销理财发行机构=DETAIL TANO属性(已确认)
             END AS ISSU_ORG      -- 发行机构(自营9999/代销TANO, 已确认)
        FROM DWD_PRDKT_INFO p               -- 产品主表
       INNER JOIN DWD_PRDKT_CATLOG cl       -- 产品目录表(属性表关联中转)
          ON cl.PRDKT_CATLOG_ID = p.PRDKT_ID  -- 目录编号=产品编号(FMS_前缀)
        LEFT JOIN (                        -- EAV条件聚合(一次扫描取风险/收益/机构/期限六个属性, 替代原d/m1/m2/m3/t1/pt六次自关联)
            SELECT PRDKT_CATLOG_PATH,      -- 目录路径
                   MAX(CASE WHEN COL_CODE = 'PRDKT_RISK' THEN COL_VALUE END) AS RISK_VAL,    -- 风险等级属性值
                   MAX(CASE WHEN COL_CODE = 'MARK_EXP' THEN COL_VALUE END) AS MARK_EXP,      -- 业绩比较基准属性值(自营理财)
                   MAX(CASE WHEN COL_CODE = 'INCOME_RATE_3M' THEN COL_VALUE END) AS INCOME_3M,  -- 近3月年化收益率属性值(代销理财优先)
                   MAX(CASE WHEN COL_CODE = 'INCOME_RATE_7' THEN COL_VALUE END) AS INCOME_7,    -- 七日年化收益率属性值(代销理财兜底)
                   MAX(CASE WHEN COL_CODE = 'TANO' THEN COL_VALUE END) AS TANO,              -- 发行机构属性值(代销理财)
                   MAX(CASE WHEN COL_CODE = 'PRDKT_TERM' THEN COL_VALUE END) AS PRD_TERM     -- 理财产品期限属性值
              FROM DWD_PRDKT_INFO_DETAIL   -- 产品属性表(EAV)
             WHERE COL_CODE IN ('PRDKT_RISK', 'MARK_EXP', 'INCOME_RATE_3M', 'INCOME_RATE_7', 'TANO', 'PRDKT_TERM')
             GROUP BY PRDKT_CATLOG_PATH
        ) agg ON agg.PRDKT_CATLOG_PATH = cl.PRDKT_CATLOG_PATH  -- 目录路径中转关联
       WHERE p.PRDKT_CATE_BIG IN ('3', '4') -- 自营理财/代销理财大类
         AND p.PRDKT_STATE = '0'            -- 在售【待确认: 理财分支无币种过滤(定期分支有PRDKT_CCY='01'), 理财币种属性来源或"全人民币"业务口径待确认】
  ),
  scored AS (
      -- A维收益预计算(原段8口径等价: 仅有效收益产品参与分组排名; 风险属性缺失不入池等价原理财INNER JOIN语义)
      -- 设计前提(2026-09-03 评审结论): 分组键含期限维度(✅-31), 期限缺失产品(PRDKT_TERM=NULL)按SQL NULL等值
      -- 聚合规则自成一组, 与有期限产品的分组零交集, 不会稀释他组排名百分位; 其A_SCORE为落表死数据
      -- (L2期限缺失剔除后无下游消费), 且NULL组内样本通常<C_A_GRP_MIN直接走中性分。若未来分组键
      -- 调整为不含期限, 需重新评估是否补充TERM_MONTHS IS NOT NULL过滤。
      SELECT pool.PRDKT_ID,      -- 产品编号
             pool.PRDKT_TERM,    -- 存期档
             COUNT(*) OVER (PARTITION BY pool.PRDKT_TYP, pool.PRDKT_TERM, pool.RISK_NUM) AS GRP_CNT,  -- 组内样本数(同类分组键=类型+期限+等级, ✅-31)
             PERCENT_RANK() OVER (PARTITION BY pool.PRDKT_TYP, pool.PRDKT_TERM, pool.RISK_NUM
                                  ORDER BY pool.PRDKT_RATE DESC, pool.PRDKT_ID ASC) AS p_rank  -- 组内收益降序百分位(同收益按编号稳定排序)
        FROM pool
       WHERE pool.PRDKT_RATE IS NOT NULL   -- 有有效收益字段才参与排名
         AND pool.RISK_NUM IS NOT NULL     -- 风险属性缺失不入池(定活分支恒非空; 理财缺失等价原INNER语义)
  )
  SELECT pool.PRDKT_ID    AS PRDKT_ID,     -- 产品编号
         pool.PRDKT_TERM   AS PRDKT_TERM,  -- 存期档
         pool.TERM_MONTHS  AS TERM_MONTHS, -- 期限月数
         pool.PRDKT_NAME   AS PRDKT_NAME,  -- 产品名称
         pool.PRDKT_TYP    AS PRDKT_TYP,   -- 推荐产品类型
         pool.PRDKT_RATE   AS PRDKT_RATE,  -- 利率或收益率
         pool.RISK_LVL_TXT AS RISK_LVL_TXT, -- 风险等级
         pool.RISK_NUM     AS RISK_NUM,    -- 风险档位数值
         pool.ISSU_ORG     AS ISSU_ORG,    -- 发行机构
         scored.GRP_CNT    AS GRP_CNT,     -- 组内样本数(无有效收益产品NULL)
         CASE WHEN scored.GRP_CNT < C_A_GRP_MIN THEN C_A_NEUTRAL        -- 可比样本不足10个, 中性分60(已确认)
              WHEN scored.p_rank <= 0.10 THEN 100  -- A1 前10%
              WHEN scored.p_rank <= 0.30 THEN 80   -- A2 前10%-30%
              WHEN scored.p_rank <= 0.50 THEN 60   -- A3 前30%-50%
              WHEN scored.p_rank <= 0.80 THEN 30   -- A4 前50%-80%
              ELSE 0                                -- A5 后20%
         END AS A_SCORE        -- 收益吸引力得分(word 5.1五档, 左闭右开已确认)
    FROM pool
    LEFT JOIN scored
      ON scored.PRDKT_ID = pool.PRDKT_ID        -- 产品编号关联
     AND scored.PRDKT_TERM = pool.PRDKT_TERM;   -- 存期档关联(候选键1:1, 无有效收益产品得NULL组)

  -- 分档边界已确认左闭右开: 0-10%含10%, 10%-30%不含10%含30%, 以此类推(与上方CASE级联语义一致)

  COMMIT;

  -- 特征表统计刷新(v2.6.2): TRUNCATE+全量重灌后优化器统计过期, 影响段4非等值JOIN计划选择;
  -- ANALYZE为Kingbase(PG内核)语句【待确认: 投产前测试库验证语句形态; 仓库先例
  -- reference_logic/MTS_OBJECT.SYS_EXC_ANALYZE采用DBMS_STATS.GATHER_TABLE_STATS可作替代】
  EXECUTE IMMEDIATE 'ANALYZE TMP_RCMD_FTR_CUST';
  EXECUTE IMMEDIATE 'ANALYZE TMP_RCMD_FTR_PRD';

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第3段完成: L1产品特征宽表(候选池+A维预评分)+特征表统计刷新';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 4. L2+L3合并: 四维评分装配+Top3+话术直出 TMP_RCMD_RSLT(v2.6.2合并, v2.6.3窄行排序优化)
  -- 四层结构: 内层单次JOIN同算B/C/D(各CASE仅写一次, 8列窄行) -> 中层算总分+ROW_NUMBER窗口
  -- 排序(引用内层列) -> 外层RN<=3截断后回挂宽属性(JOIN FTR_PRD取名称/类型/收益/等级/GRP_CNT,
  -- JOIN FTR_CUST取TERM_ANCHOR_M)并拼话术; 消除TMP_RCMD_SCORE_DTL落表读回(v2.6.2), 且排序
  -- 负载剥离宽属性(名称等不进WINDOW SORT, 同分序键仅依赖窄行列, 排名结果不变); F1硬过滤
  -- JOIN ON非等值连接不变; 中间表精简为3张
  --***************************************
  V_NO_ID := '4';
  V_BGN_DATE := SYSDATE;

  -- 4.1 Top3推荐结果(候选不足3全出; 话术与总分同批生成, 口径与v2.6.2逐项等价; v2.6.3窄行排序:
  --     WINDOW SORT仅承载8列窄行, 宽属性在RN<=3截断后回挂, 排序元组宽度降约60%)
  INSERT /*+ APPEND PARALLEL(8) */ INTO TMP_RCMD_RSLT (
      PERSN_LEGAL_BK_CODE, -- 法人行号
      DATA_DATE,           -- 数据日期
      CUST_ID,             -- 客户编号
      PRDKT_ID,            -- 产品编号
      PRDKT_TERM,          -- 存期档
      PRDKT_NAME,          -- 产品名称
      MATCH_DEG_PRDKT,     -- 产品匹配度
      PRDKT_TYP,           -- 产品类型
      RATE_INTRI,          -- 利率或预期收益率
      RISK_LVL,            -- 风险等级
      MKT_SCRIPT,          -- 营销话术
      RN                   -- 客户内排名
  )
WITH base AS (
    SELECT c.PERSN_LEGAL_BK_CODE,
           c.CUST_ID,
           p.PRDKT_ID,
           p.PRDKT_TERM,
           p.A_SCORE,
           c.TERM_ANCHOR_M,
           c.TOP_CATE,
           c.TOP_ORG,
           c.CATE_SET,
           c.CUST_RISK_NUM,
           p.RISK_NUM,
           p.PRDKT_TYP,
           p.ISSU_ORG,
           p.GRP_CNT,
           -- B_SCORE 期限匹配度
           CASE WHEN c.TERM_ANCHOR_M IS NULL THEN 0
                WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) = C_B_DEV_EQ THEN 100
                WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) <= C_B_DEV_3 THEN 80
                WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) <= C_B_DEV_6 THEN 60
                WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) <= C_B_DEV_12 THEN 30
                ELSE 0
           END AS B_SCORE,
           -- C_SCORE 风险舒适度
           CASE c.CUST_RISK_NUM - p.RISK_NUM
                WHEN 0 THEN 100
                WHEN 1 THEN 90
                WHEN 2 THEN 80
                WHEN 3 THEN 70
                ELSE 60
           END AS C_SCORE,
           -- D_SCORE 历史偏好
           CASE (CASE WHEN p.PRDKT_TYP = c.TOP_CATE THEN 1 ELSE 0 END
                + CASE WHEN p.ISSU_ORG = c.TOP_ORG THEN 1 ELSE 0 END
                + CASE WHEN INSTR(',' || c.CATE_SET || ',', ',' || p.PRDKT_TYP || ',') > 0 THEN 1 ELSE 0 END)
                WHEN 3 THEN 100
                WHEN 2 THEN CASE WHEN p.PRDKT_TYP = c.TOP_CATE THEN 80 ELSE 60 END
                WHEN 1 THEN 30
                ELSE 0
           END AS D_SCORE,
           -- TOTAL_SCORE 加权总分
           ROUND(NVL(p.A_SCORE, C_A_NEUTRAL) * C_WEIGHT_A
               + (CASE WHEN c.TERM_ANCHOR_M IS NULL THEN 0
                       WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) = C_B_DEV_EQ THEN 100
                       WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) <= C_B_DEV_3 THEN 80
                       WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) <= C_B_DEV_6 THEN 60
                       WHEN ABS(p.TERM_MONTHS - c.TERM_ANCHOR_M) <= C_B_DEV_12 THEN 30
                       ELSE 0
                  END) * C_WEIGHT_B
               + (CASE c.CUST_RISK_NUM - p.RISK_NUM
                       WHEN 0 THEN 100
                       WHEN 1 THEN 90
                       WHEN 2 THEN 80
                       WHEN 3 THEN 70
                       ELSE 60
                  END) * C_WEIGHT_C
               + (CASE (CASE WHEN p.PRDKT_TYP = c.TOP_CATE THEN 1 ELSE 0 END
                         + CASE WHEN p.ISSU_ORG = c.TOP_ORG THEN 1 ELSE 0 END
                         + CASE WHEN INSTR(',' || c.CATE_SET || ',', ',' || p.PRDKT_TYP || ',') > 0 THEN 1 ELSE 0 END)
                         WHEN 3 THEN 100
                         WHEN 2 THEN CASE WHEN p.PRDKT_TYP = c.TOP_CATE THEN 80 ELSE 60 END
                         WHEN 1 THEN 30
                         ELSE 0
                    END) * C_WEIGHT_D, 2) AS TOTAL_SCORE
      FROM TMP_RCMD_FTR_CUST c
      JOIN TMP_RCMD_FTR_PRD p
        ON p.RISK_NUM <= c.CUST_RISK_NUM
       AND p.TERM_MONTHS IS NOT NULL
),
ranked AS (
    SELECT b.*,
           ROW_NUMBER() OVER (
               PARTITION BY b.PERSN_LEGAL_BK_CODE, b.CUST_ID
               ORDER BY b.TOTAL_SCORE DESC,
                        b.B_SCORE DESC,
                        NVL(b.A_SCORE, C_A_NEUTRAL) DESC,
                        b.D_SCORE DESC,
                        b.PRDKT_ID ASC
           ) AS RN
      FROM base b
)
SELECT r.PERSN_LEGAL_BK_CODE,
       V_SYSDAT AS DATA_DATE,
       r.CUST_ID,
       r.PRDKT_ID,
       r.PRDKT_TERM,
       p.PRDKT_NAME,
       r.TOTAL_SCORE AS MATCH_DEG_PRDKT,
       p.PRDKT_TYP,
       p.PRDKT_RATE AS RATE_INTRI,
       p.RISK_LVL_TXT AS RISK_LVL,
       '该产品'
       || CASE WHEN r.C_SCORE >= 80 THEN '风险等级符合客户承受能力，风险适配度较高'
               WHEN r.C_SCORE >= 60 THEN '产品风险等级低于客户承受上限，整体风险处于可承受范围'
               ELSE '产品风险等级与客户承受能力匹配度一般，建议结合自身风险承受能力审慎选择'
          END
       || '，'
       || CASE WHEN r.TERM_ANCHOR_M IS NULL THEN '暂无足够历史购买记录，期限偏好按中性结果处理'
               WHEN r.B_SCORE >= 80 THEN '产品期限落入客户历史偏好的主要期限区间，期限匹配度较高'
               WHEN r.B_SCORE >= 60 THEN '产品期限与客户历史偏好接近，期限匹配度一般'
               ELSE '产品期限与客户历史偏好偏差较大，期限匹配度较低'
          END
       || '，'
       || CASE WHEN r.A_SCORE IS NULL THEN '无有效收益字段，暂不判断收益表现'
               WHEN r.A_SCORE = C_A_NEUTRAL AND r.GRP_CNT < C_A_GRP_MIN THEN '暂无足够可比样本，收益表现按中性结果处理'
               WHEN r.A_SCORE >= 80 THEN '同类产品收益表现靠前'
               WHEN r.A_SCORE >= 60 THEN '同类产品收益表现处于中等水平'
               ELSE '同类产品收益表现靠后'
          END
       || '，'
       || CASE WHEN r.D_SCORE >= 80 THEN '产品与客户过往购买偏好一致，且客户曾购买同类产品'
               WHEN r.D_SCORE >= 60 THEN '产品与客户部分过往购买偏好相符'
               ELSE '产品与客户过往购买偏好匹配度较低，或客户暂无同类购买记录'
          END
       || '。' AS MKT_SCRIPT,
       r.RN
  FROM ranked r
  JOIN TMP_RCMD_FTR_PRD p
    ON p.PRDKT_ID = r.PRDKT_ID
   AND p.PRDKT_TERM = r.PRDKT_TERM
 WHERE r.RN <= 3;                      -- Top3(候选不足3时自然全出)

  -- 4.2 空候选占位行(候选为空的客户返回"暂无适配产品"); NOT EXISTS查4.1已插入RSLT行(同事务可见)
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
    FROM TMP_RCMD_FTR_CUST b                            -- 客户特征宽表
   WHERE NOT EXISTS (SELECT 1 FROM TMP_RCMD_RSLT r
                      WHERE r.CUST_ID = b.CUST_ID              -- 客户编号关联
                        AND r.PERSN_LEGAL_BK_CODE = b.PERSN_LEGAL_BK_CODE  -- 法人行号关联(客户粒度=客户号+法人行)
                        AND r.DATA_DATE = V_SYSDAT);  -- 无任何推荐行的客户(客户号+法人行)

  COMMIT;

  V_END_DATE := SYSDATE;
  V_DURA_DATE := TRUNC((V_END_DATE - V_BGN_DATE) * 24 * 60 * 60);
  OUTCDE := 0;
  V_LOG_MSG := '第4段完成: L2+L3合并Top3+话术+占位行(直出RSLT, 无评分明细表)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  --***************************************
  -- 5. 写目标表(10列定稿; 目标表TRUNCATE由段1后移至本段, v2.6.2)
  --***************************************
  V_NO_ID := '5';
  V_BGN_DATE := SYSDATE;

  -- 目标表重灌前清空(TRUNCATE为DDL隐式提交, 段4数据已落表保留; 下游空窗缩至本段时长)
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADS_CUST_PRDKT_RCMD';

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
         r.PRDKT_NAME || '-' || r.PRDKT_TERM AS PRDKT_NAME,  -- 产品名称(拼接存期档, 如"个人整存整取-3Y"; 占位行名称/存期档均NULL结果仍NULL)
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
  V_LOG_MSG := '第5段完成: 目标表重灌(写目标表)';
  V_LOG_FLG := OUTCDE;

  SYS_PRC_STEP_LOGS(
      V_SYSDAT, V_PRC_NAME, V_PRC_DESC, V_NO_ID,
      V_BGN_DATE, V_END_DATE, V_DURA_DATE,
      V_LOG_MSG, V_LOG_FLG, V_LOG_BUTTON
  );

  ------------------------------------------------------------------
  -- 7. 异常处理区(捕获错误码并记录详细日志)
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
