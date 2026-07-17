/*
 * DWD 层 - CRM 客户明细表
 * 来源: ODS层 ods_sap_customer
 * 描述: 清洗去重后的客户明细数据
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS dwd_crm_customer (
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(200) NOT NULL,
    customer_code VARCHAR(50) NOT NULL,
    customer_type VARCHAR(20) DEFAULT 'PERSONAL',
    customer_status VARCHAR(20) DEFAULT 'ACTIVE',
    industry VARCHAR(100),
    region VARCHAR(100),
    contact_phone VARCHAR(50),
    contact_email VARCHAR(200),
    create_time TIMESTAMP NOT NULL DEFAULT NOW(),
    update_time TIMESTAMP,
    etl_time TIMESTAMP,
    etl_batch_id VARCHAR(50),
    PRIMARY KEY (customer_id),
    UNIQUE (customer_code)
);

CREATE INDEX IF NOT EXISTS idx_dwd_crm_customer_customer_status ON dwd_crm_customer(customer_status);
CREATE INDEX IF NOT EXISTS idx_dwd_crm_customer_customer_type ON dwd_crm_customer(customer_type);
CREATE INDEX IF NOT EXISTS idx_dwd_crm_customer_region ON dwd_crm_customer(region);
CREATE INDEX IF NOT EXISTS idx_dwd_crm_customer_create_time ON dwd_crm_customer(create_time);
CREATE INDEX IF NOT EXISTS idx_dwd_crm_customer_etl_batch_id ON dwd_crm_customer(etl_batch_id);
