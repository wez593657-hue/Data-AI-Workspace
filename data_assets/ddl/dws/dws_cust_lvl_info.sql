/*
 * dws_cust_lvl_info
 * 中文名称: 客户等级信息表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 * 更新时间: 2026-08-01 v1.1 日期列名统一为 DATA_DATE（与 SYDDL 及全部过程引用一致）
 */

CREATE TABLE IF NOT EXISTS dws_cust_lvl_info (
    DATA_DATE VARCHAR(8) NOT NULL,
    CUST_ID VARCHAR(20) NULL,
    CUST_LVL VARCHAR(2) NULL,
    PERSN_LEGAL_BK_CODE VARCHAR2(7)	
);

COMMENT ON TABLE dws_cust_lvl_info IS '客户等级信息表';
COMMENT ON COLUMN dws_cust_lvl_info.DATA_DATE IS '数据日期';
COMMENT ON COLUMN dws_cust_lvl_info.CUST_ID IS '客户编号';
COMMENT ON COLUMN dws_cust_lvl_info.CUST_LVL IS '客户等级';
COMMENT ON COLUMN dws_cust_lvl_info.PERSN_LEGAL_BK_CODE IS '法人行号';
