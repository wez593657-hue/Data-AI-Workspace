-- ============================================================
-- 睡眠户唤醒明细存储过程临时表建表语句（整合文件）
-- 存储过程名称: PRC_ADS_CUST_SLEEP_WAKE_DTL
-- 需求版本: v2.16.2
-- 变更记录:
--   v2.11.0 2026-07-30 初始整合（TMP_ADS_SLEEP_WAKE_BASE/DWS_WAKE/CNTCT）
--   v2.12.0 2026-08-04 新增TMP_ADS_SLEEP_WAKE_PROD（IS_WAKE改账户表日期驱动）
--   v2.13.0 2026-08-04 新增TMP_ADS_SLEEP_ACTIVE_TXN（O-01主动动账预聚合）
--   v2.14.0 2026-08-04 F-1 B步骤JOIN DWS→TMP_ADS_SLEEP_DWS_WAKE（消除重复扫描）；
--                     F-2 MKT_TIME/TX_DATE字符串范围比较；F-3 TMP2拆分为TMP2~TMP8
--   v2.15.0 2026-08-05 唤醒口径确认：按本月新增持有账户业务日期判定，不使用余额基线
--   v2.16.0 2026-08-17 睡眠户来源切换：TMP_ADS_SLEEP_ACTIVE_TXN下线（定义保留用于对账）；
--                     TMP_ADS_SLEEP_DWS_WAKE新增DORMANT客户UNION补齐分支
--   v2.16.1 2026-08-17 重构为先身份后属性：TMP_ADS_SLEEP_DWS_WAKE下线（定义保留用于对账/回退），
--                     属性改由TMP8[D1]按BASE客户键联查补齐
--   v2.16.2 2026-08-17 属性计算式重构：TMP_ADS_SLEEP_WAKE_BASE瘦身为仅存身份
--                     (PERSN_LEGAL_BK_CODE/CUST_ID)；[D1]/[D2]下线，属性与
--                     接触/唤醒状态在第4段写入目标表时直接计算
-- 部署说明: 本文件包含该存储过程全部相关临时表定义，可直接在Kingbase
--           (Oracle兼容模式)中整体执行部署，支持IF NOT EXISTS幂等创建。
--           注意: TMP_ADS_SLEEP_WAKE_BASE已瘦身为2列，存量环境需先重建该表。
-- ============================================================

-- ============================================================
-- 1. TMP_ADS_SLEEP_WAKE_PROD — [A0a] 当月产品新增客户预聚合表
-- 对应步骤: TMP2
-- 用途: 预聚合当月有新增产品(定期/理财/保险)的客户，供[A0]步骤IS_WAKE判断使用
-- 数据来源: DWD_ACCT_DEPO(定期起息日INTRI_BGN_DATE, FIX_CURNT_FLG='1'),
--           DWD_ACCT_FIN(理财办理日ISSU_DATE),
--           DWD_ACCT_INSUR(保险最近交易日LAST_TX_DATE)
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_WAKE_PROD (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),   -- 法人行号
    CUST_ID             VARCHAR2(20)   -- 客户号
);

-- ============================================================
-- 2. TMP_ADS_SLEEP_ACTIVE_TXN — [A0b] 主动动账客户预聚合表
-- 对应步骤: TMP3 (v2.13.0 O-01新增)
-- 用途: 预聚合近365天有主动动账(JIOYCFFS='0')的客户，供[A][B]步骤
--       NOT EXISTS使用，消除DWD_TX_ASET重复扫描。
--       v2.14.0 F-2: TX_DATE字符串范围比较利用索引
-- 数据来源: DWD_TX_ASET
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_ACTIVE_TXN (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),   -- 法人行号
    CUST_ID             VARCHAR2(20)   -- 客户号
);

-- ============================================================
-- 3. TMP_ADS_SLEEP_DWS_WAKE — [A0] 当日DWS快照预聚合表（含唤醒标志）
-- 对应步骤: TMP4
-- 用途: 预聚合当日DWS_CUST_ASSE_LIAB快照(BAL_TYPE='1')，并JOIN预聚合产品表
--       计算IS_WAKE标志(当月有新增产品=1)。供[A]月首复核、[B]睡眠候选和[D1]
--       余额唤醒更新共用。
--       v2.14.0 F-1: [B]步骤改用此表消除DWS_CUST_ASSE_LIAB重复扫描
-- 数据来源: DWS_CUST_ASSE_LIAB, TMP_ADS_SLEEP_WAKE_PROD
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_DWS_WAKE (
    PERSN_LEGAL_BK_CODE   VARCHAR(4),
    CUST_ID               VARCHAR(20),
    ORG_ID                VARCHAR(7),
    AUM_BAL               NUMBER(20,2),
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),
    FIXD_DEPO_BAL         NUMBER(20,2),
    FIN_BAL               NUMBER(20,2),
    INSUR_BAL             NUMBER(20,2),
    IS_WAKE               NUMBER(1)
);

COMMENT ON TABLE TMP_ADS_SLEEP_DWS_WAKE IS '睡眠户DWS快照预聚合临时表（含唤醒标志）';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR(4)，与客户号、机构号构成业务粒度。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.CUST_ID IS '客户编号：VARCHAR(20)，当日DWS快照中存在记录的客户。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.ORG_ID IS '归属机构：VARCHAR(7)，资产快照机构编码，参与机构粒度匹配。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.AUM_BAL IS '当日AUM余额：NUMBER(20,2)，用于[A]月首复核判断AUM<100睡眠条件。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.DEPO_CURNT_DEPO_BAL IS '活期余额：NUMBER(20,2)，当日快照活期存款余额。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.FIXD_DEPO_BAL IS '定期余额：NUMBER(20,2)，当日快照定期存款余额。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.FIN_BAL IS '理财余额：NUMBER(20,2)，当日快照理财余额。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.INSUR_BAL IS '保险余额：NUMBER(20,2)，当日快照保险余额。';
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.IS_WAKE IS '唤醒标志：NUMBER(1)，1=本月新增持有定期、理财或保险产品，账户业务日期在当月首日至跑批日窗口内，0=未唤醒';

-- ============================================================
-- 4. TMP_ADS_SLEEP_CNTCT — [A1] 当月已接触客户临时表
-- 对应步骤: TMP5
-- 用途: 预计算当月（V_CURR_MONTH_BEGIN～V_DATA_DATE）有有效接触（MKT_TYP IN
--       ('1','2','3','4')）的客户-管户经理组合，供[D]步骤LEFT JOIN判断
--       接触状态，消除逐行EXISTS扫描ADS_MKT_REC_INFO。
--       v2.14.0 F-2: MKT_TIME字符串范围比较利用索引
-- 数据来源: ADS_MKT_REC_INFO
-- ============================================================
-- v2.15.0 最新确认口径：唤醒仅按本月新增持有产品的账户业务日期判定，
-- 不采用历史余额为零或当日余额增量条件；本注释覆盖前文旧版本基线余额描述。
COMMENT ON COLUMN TMP_ADS_SLEEP_DWS_WAKE.IS_WAKE IS '本月新增持有定期、理财或保险产品标志：1=账户业务日期在当月首日至跑批日窗口内，0=否则';

CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_CNTCT (
    PERSN_LEGAL_BK_CODE   VARCHAR(4),
    CUST_ID               VARCHAR(20),
    MKT_PERSN             VARCHAR(20)
);

COMMENT ON TABLE TMP_ADS_SLEEP_CNTCT IS '睡眠户当月已接触客户临时表';
COMMENT ON COLUMN TMP_ADS_SLEEP_CNTCT.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR(4)，与客户号、管户经理构成接触关联三键。';
COMMENT ON COLUMN TMP_ADS_SLEEP_CNTCT.CUST_ID IS '客户编号：VARCHAR(20)，当月有有效接触记录的客户。';
COMMENT ON COLUMN TMP_ADS_SLEEP_CNTCT.MKT_PERSN IS '管户经理：VARCHAR(20)，接触记录的管户经理编号，对应TMP_BASE.POST_ID。';

-- ============================================================
-- 5. TMP_ADS_SLEEP_WAKE_BASE — [A]/[B] 睡眠户身份清单临时表
-- 对应步骤: '4'身份基底、'5'当日增量
-- 用途: v2.16.2 瘦身——仅存睡眠户身份(法人行+客户号)，属性(余额/名称/
--       等级/管户经理/机构)与状态(接触/唤醒)在第6段写入目标表时
--       以LEFT JOIN/EXISTS直接计算，不使用UPDATE。
-- 数据来源: DWS_CUST_DORMANT_ACCOUT(当日快照), ADS_CUST_SLEEP_WAKE_DTL(昨日身份)
-- ============================================================
CREATE TABLE IF NOT EXISTS TMP_ADS_SLEEP_WAKE_BASE (
    PERSN_LEGAL_BK_CODE VARCHAR(4),   -- 法人行号：与客户号构成睡眠户身份键。
    CUST_ID             VARCHAR(20)   -- 客户号：客户唯一标识。
);

COMMENT ON TABLE TMP_ADS_SLEEP_WAKE_BASE IS '睡眠户身份清单临时表（仅客户号+法人行号，v2.16.2瘦身）';
COMMENT ON COLUMN TMP_ADS_SLEEP_WAKE_BASE.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR(4)，与客户号构成睡眠户身份键。';
COMMENT ON COLUMN TMP_ADS_SLEEP_WAKE_BASE.CUST_ID IS '客户编号：VARCHAR(20)，客户唯一标识。';
