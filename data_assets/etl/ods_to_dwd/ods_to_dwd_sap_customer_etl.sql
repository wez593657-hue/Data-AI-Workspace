/*
 * ETL 脚本: ODS → DWD - SAP 客户信息同步
 * 来源: ods_sap_customer
 * 目标: dwd_crm_customer
 * 同步方式: 增量同步（基于 UPDATE_TIME）
 * 参考 Mapping: data_assets/mapping/ods_to_dwd/ods_to_dwd_sap_customer_mapping.md
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

BEGIN;

INSERT INTO dwd_crm_customer (
    customer_id,
    customer_name,
    customer_code,
    customer_type,
    customer_status,
    industry,
    region,
    contact_phone,
    contact_email,
    create_time,
    update_time,
    etl_time,
    etl_batch_id
)
SELECT
    TRIM(src.CUST_ID) AS customer_id,
    TRIM(src.CUST_NAME) AS customer_name,
    TRIM(src.CUST_CODE) AS customer_code,
    CASE
        WHEN TRIM(src.CUST_TYPE) = 'P' THEN 'PERSONAL'
        WHEN TRIM(src.CUST_TYPE) = 'E' THEN 'ENTERPRISE'
        ELSE 'UNKNOWN'
    END AS customer_type,
    CASE
        WHEN TRIM(src.CUST_STATUS) = 'Y' THEN 'ACTIVE'
        WHEN TRIM(src.CUST_STATUS) = 'N' THEN 'INACTIVE'
        ELSE 'UNKNOWN'
    END AS customer_status,
    TRIM(src.INDUSTRY) AS industry,
    TRIM(src.REGION) AS region,
    TRIM(src.CONTACT_PHONE) AS contact_phone,
    TRIM(src.CONTACT_EMAIL) AS contact_email,
    TO_TIMESTAMP(src.CREATE_TIME, 'YYYY/MM/DD HH24:MI:SS') AS create_time,
    TO_TIMESTAMP(src.UPDATE_TIME, 'YYYY/MM/DD HH24:MI:SS') AS update_time,
    NOW() AS etl_time,
    '${ETL_BATCH_ID}' AS etl_batch_id
FROM ods_sap_customer src
WHERE src.UPDATE_TIME > (
    SELECT COALESCE(MAX(update_time), '1900/01/01 00:00:00')
    FROM dwd_crm_customer
)
ON CONFLICT (customer_id) DO UPDATE SET
    customer_name = EXCLUDED.customer_name,
    customer_code = EXCLUDED.customer_code,
    customer_type = EXCLUDED.customer_type,
    customer_status = EXCLUDED.customer_status,
    industry = EXCLUDED.industry,
    region = EXCLUDED.region,
    contact_phone = EXCLUDED.contact_phone,
    contact_email = EXCLUDED.contact_email,
    update_time = EXCLUDED.update_time,
    etl_time = NOW(),
    etl_batch_id = '${ETL_BATCH_ID}';

COMMIT;
