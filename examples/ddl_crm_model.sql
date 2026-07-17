/*
 * CRM 数据模型 DDL 脚本
 * 参考文档: docs/09_CRM_Model.md
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

-- ====================
-- 1. 创建客户表（crm_customer）
-- ====================
CREATE TABLE IF NOT EXISTS crm_customer (
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
    PRIMARY KEY (customer_id),
    UNIQUE (customer_code)
);

-- 客户表索引
CREATE INDEX IF NOT EXISTS idx_crm_customer_customer_status ON crm_customer(customer_status);
CREATE INDEX IF NOT EXISTS idx_crm_customer_customer_type ON crm_customer(customer_type);
CREATE INDEX IF NOT EXISTS idx_crm_customer_region ON crm_customer(region);
CREATE INDEX IF NOT EXISTS idx_crm_customer_create_time ON crm_customer(create_time);

-- ====================
-- 2. 创建订单表（crm_order）
-- ====================
CREATE TABLE IF NOT EXISTS crm_order (
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    order_code VARCHAR(50) NOT NULL,
    order_type VARCHAR(20) DEFAULT 'NORMAL',
    order_status VARCHAR(20) DEFAULT 'PENDING',
    order_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(18,2) DEFAULT 0.00,
    actual_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    pay_time TIMESTAMP,
    ship_time TIMESTAMP,
    complete_time TIMESTAMP,
    create_time TIMESTAMP NOT NULL DEFAULT NOW(),
    update_time TIMESTAMP,
    etl_time TIMESTAMP,
    PRIMARY KEY (order_id),
    UNIQUE (order_code),
    FOREIGN KEY (customer_id) REFERENCES crm_customer(customer_id) ON DELETE CASCADE
);

-- 订单表索引
CREATE INDEX IF NOT EXISTS idx_crm_order_customer_id ON crm_order(customer_id);
CREATE INDEX IF NOT EXISTS idx_crm_order_order_status ON crm_order(order_status);
CREATE INDEX IF NOT EXISTS idx_crm_order_order_date ON crm_order(order_date);
CREATE INDEX IF NOT EXISTS idx_crm_order_customer_id_order_date ON crm_order(customer_id, order_date DESC);

-- ====================
-- 3. 创建支付表（crm_payment）
-- ====================
CREATE TABLE IF NOT EXISTS crm_payment (
    payment_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    payment_method VARCHAR(20) DEFAULT 'ONLINE',
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    payment_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    refund_amount DECIMAL(18,2) DEFAULT 0.00,
    payment_time TIMESTAMP,
    refund_time TIMESTAMP,
    transaction_no VARCHAR(100),
    create_time TIMESTAMP NOT NULL DEFAULT NOW(),
    update_time TIMESTAMP,
    etl_time TIMESTAMP,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (order_id) REFERENCES crm_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES crm_customer(customer_id) ON DELETE CASCADE
);

-- 支付表索引
CREATE INDEX IF NOT EXISTS idx_crm_payment_order_id ON crm_payment(order_id);
CREATE INDEX IF NOT EXISTS idx_crm_payment_customer_id ON crm_payment(customer_id);
CREATE INDEX IF NOT EXISTS idx_crm_payment_payment_status ON crm_payment(payment_status);
CREATE INDEX IF NOT EXISTS idx_crm_payment_transaction_no ON crm_payment(transaction_no);

-- ====================
-- 4. 创建联系人表（crm_contact）
-- ====================
CREATE TABLE IF NOT EXISTS crm_contact (
    contact_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(50),
    contact_email VARCHAR(200),
    contact_position VARCHAR(100),
    is_primary BOOLEAN DEFAULT FALSE,
    create_time TIMESTAMP NOT NULL DEFAULT NOW(),
    update_time TIMESTAMP,
    PRIMARY KEY (contact_id),
    FOREIGN KEY (customer_id) REFERENCES crm_customer(customer_id) ON DELETE CASCADE
);

-- 联系人表索引
CREATE INDEX IF NOT EXISTS idx_crm_contact_customer_id ON crm_contact(customer_id);
CREATE INDEX IF NOT EXISTS idx_crm_contact_is_primary ON crm_contact(is_primary);

-- ====================
-- 5. 创建地址表（crm_address）
-- ====================
CREATE TABLE IF NOT EXISTS crm_address (
    address_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    contact_id VARCHAR(50),
    address_type VARCHAR(20) DEFAULT 'SHIPPING',
    province VARCHAR(50),
    city VARCHAR(50),
    district VARCHAR(50),
    detail_address VARCHAR(500),
    zip_code VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    create_time TIMESTAMP NOT NULL DEFAULT NOW(),
    update_time TIMESTAMP,
    PRIMARY KEY (address_id),
    FOREIGN KEY (customer_id) REFERENCES crm_customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (contact_id) REFERENCES crm_contact(contact_id) ON DELETE SET NULL
);

-- 地址表索引
CREATE INDEX IF NOT EXISTS idx_crm_address_customer_id ON crm_address(customer_id);
CREATE INDEX IF NOT EXISTS idx_crm_address_contact_id ON crm_address(contact_id);
CREATE INDEX IF NOT EXISTS idx_crm_address_address_type ON crm_address(address_type);
CREATE INDEX IF NOT EXISTS idx_crm_address_is_default ON crm_address(is_default);

-- ====================
-- 6. 创建 ETL 日志表（etl_task_log）
-- ====================
CREATE TABLE IF NOT EXISTS etl_task_log (
    log_id VARCHAR(50) PRIMARY KEY,
    task_id VARCHAR(50) NOT NULL,
    task_name VARCHAR(200) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    duration INTERVAL,
    source_table VARCHAR(100),
    target_table VARCHAR(100),
    extract_count INT DEFAULT 0,
    transform_count INT DEFAULT 0,
    load_count INT DEFAULT 0,
    insert_count INT DEFAULT 0,
    update_count INT DEFAULT 0,
    delete_count INT DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'RUNNING',
    error_message TEXT,
    create_time TIMESTAMP DEFAULT NOW()
);

-- ETL 日志表索引
CREATE INDEX IF NOT EXISTS idx_etl_task_log_task_id ON etl_task_log(task_id);
CREATE INDEX IF NOT EXISTS idx_etl_task_log_status ON etl_task_log(status);
CREATE INDEX IF NOT EXISTS idx_etl_task_log_start_time ON etl_task_log(start_time);

-- ====================
-- 7. 创建客户操作日志表（crm_customer_log）
-- ====================
CREATE TABLE IF NOT EXISTS crm_customer_log (
    log_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    operation_type VARCHAR(50) NOT NULL,
    operation_time TIMESTAMP NOT NULL DEFAULT NOW(),
    operator VARCHAR(100),
    operation_detail TEXT,
    create_time TIMESTAMP DEFAULT NOW()
);

-- 客户操作日志表索引
CREATE INDEX IF NOT EXISTS idx_crm_customer_log_customer_id ON crm_customer_log(customer_id);
CREATE INDEX IF NOT EXISTS idx_crm_customer_log_operation_type ON crm_customer_log(operation_type);
CREATE INDEX IF NOT EXISTS idx_crm_customer_log_operation_time ON crm_customer_log(operation_time);

-- ====================
-- 8. 创建 ETL 错误日志表（etl_error_log）
-- ====================
CREATE TABLE IF NOT EXISTS etl_error_log (
    error_id VARCHAR(50) PRIMARY KEY,
    task_id VARCHAR(50) NOT NULL,
    error_time TIMESTAMP NOT NULL,
    error_type VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    source_data JSON,
    target_table VARCHAR(100),
    status VARCHAR(20) DEFAULT 'PENDING',
    process_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT NOW()
);

-- ETL 错误日志表索引
CREATE INDEX IF NOT EXISTS idx_etl_error_log_task_id ON etl_error_log(task_id);
CREATE INDEX IF NOT EXISTS idx_etl_error_log_status ON etl_error_log(status);
CREATE INDEX IF NOT EXISTS idx_etl_error_log_error_time ON etl_error_log(error_time);

-- ====================
-- 9. 创建序列
-- ====================
CREATE SEQUENCE IF NOT EXISTS seq_crm_customer
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE;

CREATE SEQUENCE IF NOT EXISTS seq_crm_order
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE;

CREATE SEQUENCE IF NOT EXISTS seq_crm_payment
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE;

CREATE SEQUENCE IF NOT EXISTS seq_crm_contact
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE;

CREATE SEQUENCE IF NOT EXISTS seq_crm_address
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE;

-- ====================
-- 10. 创建物化视图示例
-- ====================
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_customer_order_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM crm_customer c
LEFT JOIN crm_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 物化视图索引
CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_customer_order_summary_customer_id 
ON mv_customer_order_summary(customer_id);

-- ====================
-- DDL 脚本结束
-- ====================
