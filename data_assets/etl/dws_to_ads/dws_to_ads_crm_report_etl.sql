/*
 * ETL 脚本: DWS → ADS - CRM 客户报表
 * 来源: dws_crm_customer_daily, dwd_crm_order
 * 目标: ads_crm_customer_report
 * 同步方式: 按周期汇总（日/周/月/季/年）
 * 参考 Mapping: data_assets/mapping/dws_to_ads/dws_to_ads_crm_report_mapping.md
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

BEGIN;

INSERT INTO ads_crm_customer_report (
    report_date,
    period_type,
    total_customer,
    active_customer,
    customer_growth_rate,
    avg_customer_value,
    top_region,
    top_industry,
    monthly_target_achievement,
    create_time,
    etl_batch_id
)
SELECT
    '${REPORT_DATE}'::DATE AS report_date,
    '${PERIOD_TYPE}' AS period_type,
    COALESCE(SUM(dws.total_count), 0) AS total_customer,
    COALESCE(SUM(dws.active_count), 0) AS active_customer,
    CASE
        WHEN prev.total_count > 0 THEN (SUM(dws.total_count) - prev.total_count)::DECIMAL / prev.total_count::DECIMAL
        ELSE 0
    END AS customer_growth_rate,
    CASE
        WHEN COUNT(DISTINCT ord.customer_id) > 0 THEN SUM(ord.order_amount)::DECIMAL / COUNT(DISTINCT ord.customer_id)::DECIMAL
        ELSE 0
    END AS avg_customer_value,
    NULL AS top_region,
    NULL AS top_industry,
    0 AS monthly_target_achievement,
    NOW() AS create_time,
    '${ETL_BATCH_ID}' AS etl_batch_id
FROM dws_crm_customer_daily dws
LEFT JOIN dwd_crm_order ord ON ord.customer_id = dwd.customer_id
LEFT JOIN (
    SELECT SUM(total_count) AS total_count
    FROM dws_crm_customer_daily
    WHERE stat_date BETWEEN '${PREV_PERIOD_START}' AND '${PREV_PERIOD_END}'
) prev ON 1=1
WHERE dws.stat_date BETWEEN '${PERIOD_START}' AND '${PERIOD_END}'
ON CONFLICT (report_date, period_type) DO UPDATE SET
    total_customer = EXCLUDED.total_customer,
    active_customer = EXCLUDED.active_customer,
    customer_growth_rate = EXCLUDED.customer_growth_rate,
    avg_customer_value = EXCLUDED.avg_customer_value,
    top_region = EXCLUDED.top_region,
    top_industry = EXCLUDED.top_industry,
    monthly_target_achievement = EXCLUDED.monthly_target_achievement,
    create_time = NOW(),
    etl_batch_id = '${ETL_BATCH_ID}';

COMMIT;
