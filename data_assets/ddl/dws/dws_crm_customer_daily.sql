/*
 * DWS 层 - CRM 客户日汇总表
 * 来源: DWD层 dwd_crm_customer
 * 描述: 按天汇总的客户统计数据
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS dws_crm_customer_daily (
    stat_date DATE NOT NULL,
    total_count INT DEFAULT 0,
    active_count INT DEFAULT 0,
    inactive_count INT DEFAULT 0,
    personal_count INT DEFAULT 0,
    enterprise_count INT DEFAULT 0,
    new_add_count INT DEFAULT 0,
    lost_count INT DEFAULT 0,
    avg_region_count DECIMAL(10,2),
    etl_time TIMESTAMP,
    etl_batch_id VARCHAR(50),
    PRIMARY KEY (stat_date)
);

CREATE INDEX IF NOT EXISTS idx_dws_crm_customer_daily_etl_batch_id ON dws_crm_customer_daily(etl_batch_id);
