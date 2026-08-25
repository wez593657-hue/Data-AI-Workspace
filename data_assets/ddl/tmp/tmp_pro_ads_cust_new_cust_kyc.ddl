-- ============================================================
-- 新客经营明细存储过程临时表建表语句
-- 存储过程名称: PRC_ADS_CUST_NEW_CUST_DTL
-- 需求版本: v2.5.0
-- 临时表: TMP_ADS_NEW_CUST_KYC(物理临时表，存储客户级KYC完整度)
-- 用途: v2.5.0新增，按5张KYC表(DWD_CUST_INDV_KYC/DWD_CUST_INDV_CAR_KYC/
--       DWD_CUST_INDV_HOUSE_KYC/DWD_CUST_INDV_KYC_OTHR/DWD_CUST_INDV_SHOP_KYC)
--       计算客户级KYC完整度(28项字段，阈值≥23)，供新客基础数据生成使用
-- ============================================================

CREATE TABLE IF NOT EXISTS TMP_ADS_NEW_CUST_KYC (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),       -- 法人行号
    CUST_ID               VARCHAR2(20),      -- 客户编号
    KYC_STATE             VARCHAR2(1)        -- KYC完成状态(1=完整≥23/28,0=不完整)
);

COMMENT ON TABLE TMP_ADS_NEW_CUST_KYC IS '客户级KYC完整度临时表';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_KYC.PERSN_LEGAL_BK_CODE IS '法人行号：VARCHAR2(4)，与客户号构成基础计算单位。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_KYC.CUST_ID IS '客户编号：VARCHAR2(20)，客户唯一标识。';
COMMENT ON COLUMN TMP_ADS_NEW_CUST_KYC.KYC_STATE IS 'KYC完成状态：VARCHAR2(1)，按5张KYC表28项字段判定(主表14+车辆4+房产4+商铺4+其他2，跨表同名字段不去重，子表任一记录非空即计1项)，1=≥23项不为空，0=不完整。';
