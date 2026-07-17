/*
 * ETL 脚本: DWD → DWS - CRM 客户日汇总
 * 来源: dwd_crm_customer
 * 目标: dws_crm_customer_daily
 * 同步方式: 每日增量汇总
 * 参考 Mapping: data_assets/mapping/dwd_to_dws/dwd_to_dws_crm_customer_mapping.md
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

BEGIN;

INSERT INTO dws_crm_customer_daily (
    stat_date,
    total_count,
    active_count,
    inactive_count,
    personal_count,
    enterprise_count,
    new_add_count,
    lost_count,
    avg_region_count,
    etl_time,
    etl_batch_id
)
SELECT
    '${STAT_DATE}'::DATE AS stat_date,
    COUNT(DISTINCT customer_id) AS total_count,
    COUNT(DISTINCT CASE WHEN customer_status = 'ACTIVE' THEN customer_id END) AS active_count,
    COUNT(DISTINCT CASE WHEN customer_status = 'INACTIVE' THEN customer_id END) AS inactive_count,
    COUNT(DISTINCT CASE WHEN customer_type = 'PERSONAL' THEN customer_id END) AS personal_count,
    COUNT(DISTINCT CASE WHEN customer_type = 'ENTERPRISE' THEN customer_id END) AS enterprise_count,
    COUNT(DISTINCT CASE WHEN DATE(create_time) = '${STAT_DATE}'::DATE THEN customer_id END) AS new_add_count,
    0 AS lost_count,
    CASE
        WHEN COUNT(DISTINCT region) > 0 THEN COUNT(DISTINCT customer_id)::DECIMAL / COUNT(DISTINCT region)::DECIMAL
        ELSE 0
    END AS avg_region_count,
    NOW() AS etl_time,
    '${ETL_BATCH_ID}' AS etl_batch_id
FROM dwd_crm_customer
ON CONFLICT (stat_date) DO UPDATE SET
    total_count = EXCLUDED.total_count,
    active_count = EXCLUDED.active_count,
    inactive_count = EXCLUDED.inactive_count,
    personal_count = EXCLUDED.personal_count,
    enterprise_count = EXCLUDED.enterprise_count,
    new_add_count = EXCLUDED.new_add_count,
    lost_count = EXCLUDED.lost_count,
    avg_region_count = EXCLUDED.avg_region_count,
    etl_time = NOW(),
    etl_batch_id = '${ETL_BATCH_ID}';

COMMIT;
