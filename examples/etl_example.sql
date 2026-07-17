/*
 * ETL 示例: 客户数据从 SAP 同步到 CRM
 * 参考文档: docs/06_ETL_Standard.md
 * 同步方式: 增量同步（基于 UPDATE_TIME）
 */

-- ====================
-- ETL 任务: sync_sap_customer_to_crm
-- 源表: sap_customer (SAP系统)
-- 目标表: crm_customer (CRM系统)
-- ====================

-- 步骤 1: Extract（抽取）
-- 抽取 SAP 系统中更新时间大于上次同步时间的客户数据
CREATE TEMP TABLE temp_extract_customer AS
SELECT 
    cust_id AS customer_id,
    cust_name AS customer_name,
    cust_code AS customer_code,
    cust_type AS customer_type,
    cust_status AS customer_status,
    industry,
    region,
    contact_phone,
    contact_email,
    create_time,
    update_time
FROM sap_customer
WHERE update_time > (
    SELECT COALESCE(MAX(etl_time), '1970-01-01') 
    FROM crm_customer 
    WHERE etl_time IS NOT NULL
);

RAISE NOTICE '抽取客户数据数量: %', (SELECT COUNT(*) FROM temp_extract_customer);

-- 步骤 2: Transform（转换）
-- 数据转换和清洗
CREATE TEMP TABLE temp_transform_customer AS
SELECT 
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(customer_code) AS customer_code,
    CASE 
        WHEN customer_type = 'P' THEN 'PERSONAL'
        WHEN customer_type = 'E' THEN 'ENTERPRISE'
        ELSE 'UNKNOWN'
    END AS customer_type,
    CASE 
        WHEN customer_status = 'Y' THEN 'ACTIVE'
        WHEN customer_status = 'N' THEN 'INACTIVE'
        ELSE 'UNKNOWN'
    END AS customer_status,
    TRIM(industry) AS industry,
    TRIM(region) AS region,
    TRIM(contact_phone) AS contact_phone,
    TRIM(contact_email) AS contact_email,
    TO_TIMESTAMP(create_time, 'YYYY/MM/DD HH24:MI:SS') AS create_time,
    TO_TIMESTAMP(update_time, 'YYYY/MM/DD HH24:MI:SS') AS update_time,
    NOW() AS etl_time
FROM temp_extract_customer
WHERE TRIM(customer_id) IS NOT NULL AND TRIM(customer_id) <> '';

RAISE NOTICE '转换后客户数据数量: %', (SELECT COUNT(*) FROM temp_transform_customer);

-- 步骤 3: Load（加载）
-- 使用 MERGE 实现 UPSERT（幂等性）
MERGE INTO crm_customer t
USING temp_transform_customer s
ON (t.customer_id = s.customer_id)
WHEN MATCHED THEN
    UPDATE SET 
        customer_name = s.customer_name,
        customer_code = s.customer_code,
        customer_type = s.customer_type,
        customer_status = s.customer_status,
        industry = s.industry,
        region = s.region,
        contact_phone = s.contact_phone,
        contact_email = s.contact_email,
        update_time = s.update_time,
        etl_time = s.etl_time
WHEN NOT MATCHED THEN
    INSERT (
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
        etl_time
    ) VALUES (
        s.customer_id,
        s.customer_name,
        s.customer_code,
        s.customer_type,
        s.customer_status,
        s.industry,
        s.region,
        s.contact_phone,
        s.contact_email,
        s.create_time,
        s.update_time,
        s.etl_time
    );

-- 步骤 4: Validate（校验）
SELECT 
    (SELECT COUNT(*) FROM temp_extract_customer) AS source_count,
    (SELECT COUNT(*) FROM temp_transform_customer) AS transform_count,
    (SELECT COUNT(*) FROM crm_customer WHERE etl_time >= NOW() - INTERVAL '1 hour') AS target_count;

-- 检查主键非空
SELECT COUNT(*) AS null_customer_id_count
FROM crm_customer
WHERE customer_id IS NULL;

-- 检查状态值有效性
SELECT COUNT(*) AS invalid_status_count
FROM crm_customer
WHERE customer_status NOT IN ('ACTIVE', 'INACTIVE', 'UNKNOWN');

-- 步骤 5: Log（日志）
INSERT INTO etl_task_log (
    log_id,
    task_id,
    task_name,
    start_time,
    end_time,
    source_table,
    target_table,
    extract_count,
    transform_count,
    load_count,
    status
) VALUES (
    'LOG_' || REPLACE(CAST(NOW() AS VARCHAR), ' ', '_'),
    'sync_sap_customer_to_crm',
    'SAP客户数据同步到CRM',
    NOW() - INTERVAL '5 minutes',
    NOW(),
    'sap_customer',
    'crm_customer',
    (SELECT COUNT(*) FROM temp_extract_customer),
    (SELECT COUNT(*) FROM temp_transform_customer),
    (SELECT COUNT(*) FROM temp_transform_customer),
    'SUCCESS'
);

-- 步骤 6: Finish（完成）
DROP TABLE IF EXISTS temp_extract_customer;
DROP TABLE IF EXISTS temp_transform_customer;

RAISE NOTICE 'ETL 任务 sync_sap_customer_to_crm 执行完成';
