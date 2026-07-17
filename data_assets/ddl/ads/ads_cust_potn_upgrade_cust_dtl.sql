/*
 * ads_cust_potn_upgrade_cust_dtl
 * 中文名称: 潜力提升客户明细列表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS ads_cust_potn_upgrade_cust_dtl (
    DATA_DATE VARCHAR(8) NOT NULL COMMENT '数据日期',
    CUST_ID VARCHAR(20) NULL COMMENT '客户编号',
    CUST_NAME VARCHAR(100) NULL COMMENT '客户名称',
    CUST_LVL VARCHAR(2) NULL COMMENT '客户等级',
    LVL_CRIT VARCHAR(2) NULL COMMENT '临界等级',
    DEPO_CURNT_DEPO_BAL NUMBER(20,2) NULL COMMENT '活期余额',
    FIXD_DEPO_BAL NUMBER(20,2) NULL COMMENT '定期余额',
    FIN_AMT NUMBER(20,2) NULL COMMENT '理财余额',
    CNTCT_STATE VARCHAR(1) NULL COMMENT '接触状态',
    QUAL_STATE VARCHAR(1) NULL COMMENT '达标状态',
    POST_ID VARCHAR(20) NULL COMMENT '管户经理',
    ORG_ID VARCHAR(6) NULL COMMENT '归属机构'
);

COMMENT ON TABLE ads_cust_potn_upgrade_cust_dtl IS '潜力提升客户明细列表';
