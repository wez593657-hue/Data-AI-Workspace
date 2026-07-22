/*
 * dws_cust_lvl_info
 * 中文名称: 客户等级信息表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS dws_cust_lvl_info (
    DATA_DT VARCHAR(8) NOT NULL,
    CUST_ID VARCHAR(20) NULL,
    CUST_LVL VARCHAR(2) NULL
);

COMMENT ON TABLE dws_cust_lvl_info IS '客户等级信息表';
COMMENT ON COLUMN dws_cust_lvl_info.DATA_DT IS '数据日期';
COMMENT ON COLUMN dws_cust_lvl_info.CUST_ID IS '客户编号';
COMMENT ON COLUMN dws_cust_lvl_info.CUST_LVL IS '客户等级';