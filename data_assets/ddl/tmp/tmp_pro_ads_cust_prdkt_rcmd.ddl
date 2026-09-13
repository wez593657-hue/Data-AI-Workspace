-- ============================================================
-- 产品推荐存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_PRDKT_RCMD
-- 需求版本: REQ-RCMD-001 V1.1 (word 载体 LSCCB_零售CRM平台项目_产品推荐方案v1.1.docx)
-- 架构: "分层TMP物化+单次评分装配直出Top3"(L1特征层FTR_CUST/FTR_PRD + L2+L3合并段直出RSLT, v2.6.2)
-- 客户范围: 全行所有客户(圈选源 DWD_CUST_INDV_INFO, 2026-09-02 已确认)
-- 创建时间: 2026-08-26
-- 变更记录:
--   v1.0 2026-08-26 初版(7张TMP表)
--   v1.1 2026-09-02 ISSU_ORG注释同步/客户表风险注释/候选池加发行机构列
--   v1.2 2026-09-02 锚点形态落地: TERM_PREF_LO/HI废弃删除(区间形态),
--          TERM_ANCHOR_M注释确认; 收益口径四类注释同步; 样本阈值10;
--          无理财测评默认C2
--   v1.3 2026-09-02 RSLT表PRDKT_ID 30→40/RATE_INTRI NUMBER(22,2)→(12,7)
--          同步目标表v2.1; 各表注释同步(D/M/Y期限值域/机构来源/无HIS表)
--   v1.4 2026-09-02 历史持有期限偏好口径升级: 锚点选取由"金额最大"改为"年日均最大",
--          TMP_RCMD_HIS_HOLD 新增 YR_AVG_AMT 年日均列(来源DWS_CUST_ASSE_LIAB_CUMU_HIS,
--          存款PRDKT_TYP='1'/理财'3', 按上年末快照; 与标签表储蓄期限偏好口径对齐)
--   v1.5 2026-09-03 RSLT表新增PRDKT_TERM存期档列(方案A候选键, 3.9.1候选键/3.9.2占位NULL/
--          3.9.3话术关联, SP v2.5.0同步; 补记此前遗漏的changelog条目);
--          注释同步SP v2.5.4: 类型码01-04定稿(✅-46)移除占位待确认标记;
--          BUY_DATE/BUY_AMT口径按落地实现修正(理财=ISSU_DATE办理日期/FIN_AMT余额,
--          存款=TX_ASET最近一笔交易日期/发生额); TERM_MONTHS理财侧=到期日-起息日
--          (TO_DATE显式转换后相减, 修复字符串隐式转数字相减, v2.5.4);
--          TERM_ANCHOR_M口径修正为年日均最大(v2.4.0遗留未同步);
--          候选池理财期限=DETAIL PRDKT_TERM属性D/M/Y解析(v2.5.0遗留未同步)
--   v1.6 2026-09-03 存款历史持有取数简化同步SP v2.5.5: BUY_DATE存款侧=DWD_ACCT_DEPO
--          OPEN_DATE开户日期(原TX_ASET最近一笔TX_DATE), BUY_AMT存款侧=BAL账户余额
--          (原TX_ASET发生额AMT); HIS_HOLD不再引用DWD_TX_ASET
--   v2.0 2026-09-03 架构重构同步SP v2.6.0(分层TMP物化+单次评分装配):
--          新增L1特征层 TMP_RCMD_FTR_CUST(客户特征宽表: 圈选+风险+画像+锚点,
--          合并原CUST_BASE/HIS_HOLD/段4逻辑)与 TMP_RCMD_FTR_PRD(产品特征宽表:
--          候选池+A维预评分GRP_CNT/A_SCORE, 合并原PRDKT_POOL/YIELD_SCORE);
--          删除废弃表 CUST_BASE/HIS_HOLD/PRDKT_POOL/CART_SAFE/YIELD_SCORE(5张);
--          SCORE_DTL保留精简(删除TOTAL_SCORE列, L3直接计算不再落表); RSLT保留不变
--   v2.1 2026-09-03 客户粒度修正同步SP v2.6.1(用户审查发现): 客户粒度=客户号+法人行,
--          SCORE_DTL新增PERSN_LEGAL_BK_CODE列(L2装配透出, L3按双键关联与Top3分区)
--   v2.2 2026-09-04 性能优化同步SP v2.6.2(不改动业务口径): L2装配+L3输出合并为单段
--          直出RSLT, 删除TMP_RCMD_SCORE_DTL(全过程中间结果集最大的写放大点, 消除
--          全量明细落表+读回两次IO), TMP表4张精简为3张
-- ============================================================

-- 2.0 L1特征层: 客户特征宽表(原段2圈选+段3历史持有+段4画像合并, 单次INSERT一次算齐)
DROP TABLE  TMP_RCMD_FTR_CUST;
CREATE TABLE  TMP_RCMD_FTR_CUST (
    CUST_ID              VARCHAR2(64),  -- 客户编号(全行客户,来源DWD_CUST_INDV_INFO)
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    CUST_RISK_NUM        NUMBER(2),     -- 客户风险档位数值(invest_typ='3'理财线risk_lvl 1-5直接作档位,已确认; 无理财测评默认C2=2)
    TERM_ANCHOR_M        NUMBER(12,2),  -- 期限偏好锚点(月)=近三年年日均(YAR_BAL/YAR_DAYS)最大产品的单点期限(2026-09-02 v2.4.0口径升级); 无历史持有客户NULL(L2判0分)
    TOP_CATE             VARCHAR2(10),  -- 近一年购买频次最高大类(按笔数, 跨机构合计; 笔数/金额口径见卡片O02待确认)
    TOP_ORG              VARCHAR2(30),  -- 近一年购买最多机构(按笔数, 跨大类合计; D2因素用)
    CATE_SET             VARCHAR2(500)  -- 近一年购买过的大类集合(逗号分隔, D3因素用)
);

-- 2.1 L1特征层: 产品特征宽表(原段5候选池+段8 A维预计算合并, 三候选分支+EAV条件聚合+PERCENT_RANK一次算齐)
DROP TABLE  TMP_RCMD_FTR_PRD;
CREATE TABLE  TMP_RCMD_FTR_PRD (
    PRDKT_ID             VARCHAR2(64),  -- 产品编号(定期=CBS_||编号, 智能存款=CDS_||编号, 理财=FMS_||编号)
    PRDKT_TERM           VARCHAR2(10),  -- 存期档(定期=ZB表存期xxM, 智能存款/理财=DETAIL PRDKT_TERM属性, 值域D/M/Y+数字)
    TERM_MONTHS          NUMBER(12,2),  -- 期限月数(定期=存期档转月数, 智能/理财=PRDKT_TERM按D/M/Y解析: nD=天数/30折月,nM=月数,nY=年x12; 异常值域自然落NULL)
    PRDKT_NAME           VARCHAR2(200), -- 产品名称
    PRDKT_TYP            VARCHAR2(6),   -- 推荐产品类型:01-定期,02-智能,03-自营理财,04-代销理财(✅-46定稿)
    PRDKT_RATE           NUMBER(12,7),  -- 利率或收益率(定期=ZB实际利率, 智能=DETAIL PRDKT_RATE, 自营=MARK_EXP业绩基准, 代销=近三月优先七日兜底, 均已确认)
    RISK_LVL_TXT         VARCHAR2(10),  -- 风险等级(存款固定R1, 理财R1-R5=COL_VALUE 01-05映射, 已确认)
    RISK_NUM             NUMBER(2),     -- 风险档位数值(存款固定1, 理财TO_NUMBER(COL_VALUE)01-05, 已确认; 缺失不入池)
    ISSU_ORG             VARCHAR2(30),  -- 发行机构(存款=9999,自营理财=9999,代销理财=DETAIL TANO属性,均已确认)
    GRP_CNT              NUMBER(10),    -- A维同类分组键(类型+期限+等级,✅-31)内样本数(小于阈值走中性分60,已确认; 无有效收益字段产品为NULL)
    A_SCORE              NUMBER(3)      -- A维收益吸引力得分(0-100,word 5.1五档, PERCENT_RANK预计算; 无有效收益字段产品为NULL, 仍为候选, L2预置NULL由L3按中性60计总分)
);

-- 2.2 L3输出层(并入L2装配段直出, v2.6.2): 推荐结果中间表(Top3+话术同批INSERT+空候选占位; 目标表10列+过程用PRDKT_TERM/RN列)
DROP TABLE  TMP_RCMD_RSLT;
CREATE TABLE  TMP_RCMD_RSLT (
    PERSN_LEGAL_BK_CODE  VARCHAR2(4),   -- 法人行号
    DATA_DATE            VARCHAR2(8),   -- 数据日期
    CUST_ID              VARCHAR2(20),  -- 客户编号
    PRDKT_ID             VARCHAR2(40),  -- 产品编号(对齐目标表v2.1; 占位行=NA)
    PRDKT_TERM           VARCHAR2(10),  -- 存期档(方案A候选键组成, 话术关联用; 占位行=NULL)
    PRDKT_NAME           VARCHAR2(100), -- 产品名称
    MATCH_DEG_PRDKT      NUMBER(22,2),  -- 产品匹配度(总分, L3直接计算)
    PRDKT_TYP            VARCHAR2(6),   -- 产品类型
    RATE_INTRI           NUMBER(12,7),  -- 利率或预期收益率(按原有精度, 对齐目标表v2.1)
    RISK_LVL             VARCHAR2(10),  -- 风险等级
    MKT_SCRIPT           VARCHAR2(1000),-- 营销话术(推荐理由/暂无适配产品)
    RN                   NUMBER(3)      -- 客户内排名(1-3,调试用,不落目标表)
);
