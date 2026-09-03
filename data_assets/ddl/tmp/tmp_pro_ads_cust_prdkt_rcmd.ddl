-- ============================================================
-- 产品推荐存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_PRDKT_RCMD
-- 需求版本: REQ-RCMD-001 V1.1 (word 载体 LSCCB_零售CRM平台项目_产品推荐方案v1.1.docx)
-- 候选粒度: 普通定期存款按"产品 x 存期档"独立候选(方案A)
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
-- ============================================================

-- 2.0 历史持有合并中间表(段0, 存款depo+理财fin双源UNION, 近三年窗口)
DROP TABLE IF NOT EXISTS TMP_RCMD_HIS_HOLD;
CREATE TABLE IF NOT EXISTS TMP_RCMD_HIS_HOLD (
    CUST_ID              VARCHAR2(64),  -- 客户编号
    PRDKT_ID             VARCHAR2(64),  -- 产品编号
    PRDKT_TYP            VARCHAR2(6),   -- 持有产品类型:01-定期,02-智能,03-自营理财,04-代销理财【编码待确认B-06】
    BUY_DATE             DATE,          -- 购买日期(理财=办理日期,存款=起息日期,口径待确认T-05)
    BUY_AMT              NUMBER(20,2),  -- 购买金额(理财=确认金额,存款=余额,口径待确认T-05)
    ISSU_ORG             VARCHAR2(30),  -- 发行机构(存款=9999,自营理财=9999,代销理财=TANO属性,均已确认)
    TERM_MONTHS          NUMBER(12,2),  -- 持有期限月数(存款=CUNQ按D/M/Y解析: nD=天数/30折月,nM=月数,nY=年x12; 理财=T-03未决NULL)
    YR_AVG_AMT           NUMBER(20,2),  -- 年日均余额(来源DWS_CUST_ASSE_LIAB_CUMU_HIS按上年末快照, 存款PRDKT_TYP='1'/理财'3'; v1.4锚点取数口径)
    SRC_TBL              VARCHAR2(10)   -- 来源表:DEPO-存款账户,FIN-理财账户
);

-- 2.1 客户画像中间表(段0, 圈选客户+风险等级+期限偏好+购买偏好)
DROP TABLE IF NOT EXISTS TMP_RCMD_CUST_BASE;
CREATE TABLE IF NOT EXISTS TMP_RCMD_CUST_BASE (
    CUST_ID              VARCHAR2(64),  -- 客户编号(全行客户,来源DWD_CUST_INDV_INFO)
    PERSN_LEGAL_BK_CODE  VARCHAR2(32),  -- 法人行号
    CUST_RISK_TXT        VARCHAR2(20),  -- 客户风险等级原始值(risk_lvl,值域1-5已确认;invest_typ='3'理财线,保险线不参与)
    CUST_RISK_NUM        NUMBER(2),     -- 客户风险档位数值(1-5直接作档位,已确认;无理财测评默认C2=2,已确认)
    TERM_ANCHOR_M        NUMBER(12,2),  -- 期限偏好锚点(月)=近三年金额最大产品的单点期限,已确认;无历史持有客户NULL(段7判0分)
    TOP_CATE             VARCHAR2(10),  -- 近一年购买频次最高大类
    TOP_ORG              VARCHAR2(30),  -- 近一年购买最多机构(D2因素用)
    CATE_SET             VARCHAR2(500)  -- 近一年购买过的大类集合(逗号分隔,D3因素用)
);

-- 2.2 候选产品池中间表(段0, 方案A粒度: 产品x存期档)
DROP TABLE IF NOT EXISTS TMP_RCMD_PRDKT_POOL;
CREATE TABLE IF NOT EXISTS TMP_RCMD_PRDKT_POOL (
    PRDKT_ID             VARCHAR2(64),  -- 产品编号(定期=CBS_||编号,理财=FMS_||编号)
    PRDKT_TERM           VARCHAR2(10),  -- 存期档(定期=ZB表存期xxM,智能存款=DETAIL PRDKT_TERM值域D/M/Y+数字,理财=投资期限T-03未决)
    TERM_MONTHS          NUMBER(12,2),  -- 期限月数(定期=存期档转月数,智能=PRDKT_TERM按D/M/Y解析,理财=T-03未决)
    PRDKT_NAME           VARCHAR2(200), -- 产品名称
    PRDKT_TYP            VARCHAR2(6),   -- 推荐产品类型:01-定期,02-智能,03-自营理财,04-代销理财【编码待确认】
    PRDKT_RATE           NUMBER(12,7),  -- 利率或收益率(定期=ZB实际利率,智能=DETAIL PRDKT_RATE,自营=MARK_EXP业绩基准,代销=近三月优先七日兜底,均已确认)
    RISK_LVL_TXT         VARCHAR2(10),  -- 风险等级(存款固定R1,理财R1-R5=COL_VALUE 01-05映射,已确认)
    RISK_NUM             NUMBER(2),     -- 风险档位数值(存款固定1,理财TO_NUMBER(COL_VALUE)01-05,已确认)
    ISSU_ORG             VARCHAR2(30),  -- 发行机构(存款=9999,自营理财=9999,代销理财=DETAIL TANO属性,均已确认)
    IS_SELL              VARCHAR2(2)    -- 是否在售(是/否,F2仅校验在售,渠道可售已删除)
);

-- 2.3 安全候选交叉中间表(段1, F1硬过滤后客户x候选交叉, 含C维分)
DROP TABLE IF NOT EXISTS TMP_RCMD_CART_SAFE;
CREATE TABLE IF NOT EXISTS TMP_RCMD_CART_SAFE (
    CUST_ID              VARCHAR2(64),  -- 客户编号
    PRDKT_ID             VARCHAR2(64),  -- 产品编号
    PRDKT_TERM           VARCHAR2(10),  -- 存期档(候选唯一键组成)
    C_SCORE              NUMBER(3)      -- 风险舒适度得分(0-100,word 5.3五档)
);

-- 2.4 收益排名中间表(段3, A维产品级预计算, 与客户无关)
DROP TABLE IF NOT EXISTS TMP_RCMD_YIELD_SCORE;
CREATE TABLE IF NOT EXISTS TMP_RCMD_YIELD_SCORE (
    PRDKT_ID             VARCHAR2(64),  -- 产品编号
    PRDKT_TERM           VARCHAR2(10),  -- 存期档(定期A维分组键含存期档,N-5)
    GRP_KEY              VARCHAR2(60),  -- 同类分组键(产品类型+期限+等级,已确认)
    GRP_CNT              NUMBER(10),    -- 组内样本数(小于10走中性分60,已确认)
    A_SCORE              NUMBER(3)      -- 收益吸引力得分(0-100,word 5.1五档)
);

-- 2.5 评分明细中间表(段2/段4/段5, 全量候选评分与总分)
DROP TABLE IF NOT EXISTS TMP_RCMD_SCORE_DTL;
CREATE TABLE IF NOT EXISTS TMP_RCMD_SCORE_DTL (
    CUST_ID              VARCHAR2(64),  -- 客户编号
    PRDKT_ID             VARCHAR2(64),  -- 产品编号
    PRDKT_TERM           VARCHAR2(10),  -- 存期档
    A_SCORE              NUMBER(3),     -- 收益吸引力得分(段3回填)
    B_SCORE              NUMBER(3),     -- 期限匹配度得分(段2,锚点偏差五档已确认;无历史持有0分,产品期限缺失NULL中性60)
    C_SCORE              NUMBER(3),     -- 风险舒适度得分(段1)
    D_SCORE              NUMBER(3),     -- 历史偏好/熟悉度得分(段4)
    TOTAL_SCORE          NUMBER(5,2)    -- 综合总分=A*35%+B*30%+C*20%+D*15%(四舍五入2位,已确认)
);

-- 2.6 推荐结果中间表(段5, Top3+空候选占位, 目标表10列+过程用PRDKT_TERM/RN列)
DROP TABLE IF NOT EXISTS TMP_RCMD_RSLT;
CREATE TABLE IF NOT EXISTS TMP_RCMD_RSLT (
    PERSN_LEGAL_BK_CODE  VARCHAR2(4),   -- 法人行号
    DATA_DATE            VARCHAR2(8),   -- 数据日期
    CUST_ID              VARCHAR2(20),  -- 客户编号
    PRDKT_ID             VARCHAR2(40),  -- 产品编号(对齐目标表v2.1; 占位行=NA)
    PRDKT_TERM           VARCHAR2(10),  -- 存期档(方案A候选键组成, 3.9.3话术关联用; 占位行=NULL)
    PRDKT_NAME           VARCHAR2(100), -- 产品名称
    MATCH_DEG_PRDKT      NUMBER(22,2),  -- 产品匹配度(总分)
    PRDKT_TYP            VARCHAR2(6),   -- 产品类型
    RATE_INTRI           NUMBER(12,7),  -- 利率或预期收益率(按原有精度, 对齐目标表v2.1)
    RISK_LVL             VARCHAR2(10),  -- 风险等级
    MKT_SCRIPT           VARCHAR2(1000),-- 营销话术(占位行=暂无适配产品)
    RN                   NUMBER(3)      -- 客户内排名(1-3,调试用,不落目标表)
);
