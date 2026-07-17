/*
 * ADS 层 - CRM 客户报表表
 * 来源: DWS层 dws_crm_customer_daily
 * 描述: 面向业务报表的客户分析数据
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS ads_crm_customer_report (
    report_date DATE NOT NULL,
    period_type VARCHAR(10) NOT NULL,
    total_customer INT DEFAULT 0,
    active_customer INT DEFAULT 0,
    customer_growth_rate DECIMAL(10,4),
    avg_customer_value DECIMAL(18,2),
    top_region VARCHAR(100),
    top_industry VARCHAR(100),
    monthly_target_achievement DECIMAL(10,4),
    create_time TIMESTAMP NOT NULL DEFAULT NOW(),
    etl_batch_id VARCHAR(50),
    PRIMARY KEY (report_date, period_type)
);

CREATE INDEX IF NOT EXISTS idx_ads_crm_customer_report_period_type ON ads_crm_customer_report(period_type);
CREATE INDEX IF NOT EXISTS idx_ads_crm_customer_report_etl_batch_id ON ads_crm_customer_report(etl_batch_id);


COMMENT ON TABLE ADS_CRM_CUSTOMER_REPORT IS '【待补充】';
