-- ============================================================
-- 新客经营明细存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_NEW_CUST_DTL
-- 需求版本: v2.5.0
-- 临时表: TMP_ADS_NEW_CUST_BASE(物理临时表，存储180天内新客基础数据)
-- 用途: 存储新客定义、周期分类、资产余额、接触状态、KYC状态、
--       管户经理与归属机构，供明细表写入使用
-- 变更记录:
--   v2.5.0(2026-08-25): KYC_STATE改由TMP_ADS_NEW_CUST_KYC临时表提供(见
--                       tmp_pro_ads_cust_new_cust_kyc.ddl)，口径28项≥23
-- ============================================================

CREATE TABLE IF NOT EXISTS TMP_ADS_NEW_CUST_BASE (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    CUST_ID               VARCHAR2(20),      -- 客户编号
    CUST_NAME             VARCHAR2(100),     -- 客户姓名
    CUST_LVL              VARCHAR2(2),       -- 客户等级(码值11=未评级)
    NEW_CUST_CYCLE        VARCHAR2(1),       -- 新客周期(1=0~30天,2=30~100天,3=100~180天)
    DEPO_CURNT_DEPO_BAL   NUMBER(20,2),      -- 活期存款余额
    FIXD_DEPO_BAL         NUMBER(20,2),      -- 定期存款余额
    FIN_AMT               NUMBER(20,2),      -- 理财余额
    CNTCT_STATE           VARCHAR2(1),       -- 接触状态(1=已接触,0=未接触)
    KYC_STATE             VARCHAR2(1),       -- KYC完成状态(1=完整≥23/28,0=不完整)
    POST_ID               VARCHAR2(20),      -- 管户经理岗位编号
    ORG_ID                VARCHAR2(7)        -- 归属机构
);

COMMENT ON TABLE TMP_ADS_NEW_CUST_BASE IS '新客经营明细基础数据临时表';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR2(4)，取资产快照，与客户号构成基础计算单位。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.CUST_ID IS '客户编号：VARCHAR2(20)，客户唯一标识。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.CUST_NAME IS '客户姓名：VARCHAR2(100)，取客户基本信息。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.CUST_LVL IS '客户等级：VARCHAR2(2)，码值11=未评级，无等级记录时兜底11。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.NEW_CUST_CYCLE IS '新客周期：VARCHAR2(1)，1=0~30天，2=30~100天，3=100~180天，左闭右开。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.DEPO_CURNT_DEPO_BAL IS '活期存款余额：NUMBER(20,2)，金额元，缺失按0处理。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.FIXD_DEPO_BAL IS '定期存款余额：NUMBER(20,2)，金额元，缺失按0处理。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.FIN_AMT IS '理财余额：NUMBER(20,2)，金额元，缺失按0处理。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.CNTCT_STATE IS '接触状态：VARCHAR2(1)，1=新客周期内有有效接触，0=无。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.KYC_STATE IS 'KYC完成状态：VARCHAR2(1)，v2.5.0起取自TMP_ADS_NEW_CUST_KYC临时表，1=28项中≥23个不为空，0=不完整，无KYC记录兜底0。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.POST_ID IS '管户经理岗位编号：VARCHAR2(20)，取DWD_CUST_MAN(MNG_TYP=1)理财管户经理，允许空值。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_BASE.ORG_ID IS '归属机构：VARCHAR2(7)，取资产快照机构编码。';
