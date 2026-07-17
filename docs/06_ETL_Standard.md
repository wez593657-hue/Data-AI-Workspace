# 06 ETL 规范

## 6.1 概述

本规范定义了 CRM 数据 ETL（Extract-Transform-Load）过程的统一标准，确保数据同步的准确性、可靠性和可维护性。

## 6.2 ETL 统一流程

```
Extract（抽取）
    │
    ▼
Transform（转换）
    │
    ▼
Load（加载）
    │
    ▼
Validate（校验）
    │
    ▼
Log（日志）
    │
    ▼
Finish（完成）
```

## 6.3 ETL 设计原则

### 6.3.1 幂等性

ETL 任务必须支持重复执行，不会因为重复运行导致数据重复或不一致。

### 6.3.2 可重跑

ETL 任务支持失败后重新执行，从失败点继续处理。

### 6.3.3 断点恢复

【待确认】- 需要确认具体实现方案

### 6.3.4 数据校验

每一步数据处理后必须执行数据校验。

### 6.3.5 日志完整

ETL 过程必须记录完整的日志，包括开始时间、结束时间、处理数据量、错误信息等。

## 6.4 ETL 详细流程

### 6.4.1 Extract（抽取）

**抽取策略：**

| 抽取方式 | 适用场景 | 实现方式 |
|----------|----------|----------|
| 全量抽取 | 首次同步、数据量小 | `SELECT * FROM source_table` |
| 增量抽取 | 定期同步、数据量大 | 基于时间戳 `WHERE update_time > last_sync_time` |
| CDC | 实时同步 | 【待确认】 |

**抽取代码示例：**

```sql
-- 全量抽取
CREATE TEMP TABLE temp_extract_customer AS
SELECT 
    customer_id,
    customer_name,
    customer_code,
    customer_status,
    create_time,
    update_time
FROM source_customer;

-- 增量抽取
CREATE TEMP TABLE temp_extract_customer_inc AS
SELECT 
    customer_id,
    customer_name,
    customer_code,
    customer_status,
    create_time,
    update_time
FROM source_customer
WHERE update_time > (SELECT last_sync_time FROM etl_sync_log WHERE sync_table = 'source_customer');
```

### 6.4.2 Transform（转换）

**转换规则：**

| 转换类型 | 示例 |
|----------|------|
| 字段映射 | `source_name` → `customer_name` |
| 数据类型转换 | `VARCHAR` → `INT` |
| 格式转换 | `'2024/01/01'` → `'2024-01-01'` |
| 业务规则转换 | `'Y'/'N'` → `'ACTIVE'/'INACTIVE'` |
| 默认值填充 | NULL → 默认值 |
| 数据清洗 | 去除空格、特殊字符 |

**转换代码示例：**

```sql
CREATE TEMP TABLE temp_transform_customer AS
SELECT 
    customer_id,
    TRIM(customer_name) AS customer_name,
    customer_code,
    CASE 
        WHEN customer_status = 'Y' THEN 'ACTIVE'
        WHEN customer_status = 'N' THEN 'INACTIVE'
        ELSE 'UNKNOWN'
    END AS customer_status,
    TO_DATE(create_time, 'YYYY/MM/DD') AS create_time,
    TO_DATE(update_time, 'YYYY/MM/DD') AS update_time,
    COALESCE(contact_phone, '') AS contact_phone,
    NOW() AS etl_time
FROM temp_extract_customer;
```

### 6.4.3 Load（加载）

**加载策略：**

| 加载方式 | 适用场景 | 实现方式 |
|----------|----------|----------|
| INSERT | 首次加载 | 直接插入 |
| MERGE | 增量更新 | INSERT OR UPDATE |
| DELETE + INSERT | 全量更新 | 先删后插 |

**加载代码示例：**

```sql
-- MERGE 方式（UPSERT）
MERGE INTO crm_customer t
USING temp_transform_customer s
ON (t.customer_id = s.customer_id)
WHEN MATCHED THEN
    UPDATE SET 
        customer_name = s.customer_name,
        customer_code = s.customer_code,
        customer_status = s.customer_status,
        update_time = s.update_time,
        etl_time = s.etl_time
WHEN NOT MATCHED THEN
    INSERT (customer_id, customer_name, customer_code, customer_status, create_time, update_time, etl_time)
    VALUES (s.customer_id, s.customer_name, s.customer_code, s.customer_status, s.create_time, s.update_time, s.etl_time);
```

### 6.4.4 Validate（校验）

**校验规则：**

| 校验类型 | 校验内容 | 示例 |
|----------|----------|------|
| 数量校验 | 源数据与目标数据数量一致 | `COUNT(source) = COUNT(target)` |
| 主键校验 | 主键非空且唯一 | `customer_id IS NOT NULL` |
| 字段校验 | 字段值符合规则 | `customer_status IN ('ACTIVE', 'INACTIVE')` |
| 业务规则校验 | 业务逻辑正确 | `order_amount > 0` |
| 完整性校验 | 关键字段非空 | `customer_name IS NOT NULL` |

**校验代码示例：**

```sql
-- 数量校验
SELECT 
    (SELECT COUNT(*) FROM temp_extract_customer) AS source_count,
    (SELECT COUNT(*) FROM temp_transform_customer) AS transform_count,
    (SELECT COUNT(*) FROM crm_customer WHERE etl_time >= NOW() - INTERVAL '1 hour') AS target_count;

-- 主键校验
SELECT COUNT(*) AS null_count
FROM crm_customer
WHERE customer_id IS NULL;

-- 字段校验
SELECT COUNT(*) AS invalid_count
FROM crm_customer
WHERE customer_status NOT IN ('ACTIVE', 'INACTIVE', 'UNKNOWN');
```

### 6.4.5 Log（日志）

**日志记录：**

| 日志字段 | 说明 |
|----------|------|
| task_id | 任务ID |
| task_name | 任务名称 |
| start_time | 开始时间 |
| end_time | 结束时间 |
| duration | 执行时长 |
| source_table | 源表 |
| target_table | 目标表 |
| extract_count | 抽取数量 |
| transform_count | 转换数量 |
| load_count | 加载数量 |
| insert_count | 插入数量 |
| update_count | 更新数量 |
| delete_count | 删除数量 |
| status | 状态（RUNNING/SUCCESS/FAILED） |
| error_message | 错误信息 |

**日志表设计：**

```sql
CREATE TABLE etl_task_log (
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
```

### 6.4.6 Finish（完成）

**完成步骤：**

1. 更新任务状态为 SUCCESS
2. 记录结束时间和执行时长
3. 更新同步时间戳
4. 清理临时表
5. 发送通知（可选）

## 6.5 ETL 任务调度

### 6.5.1 调度策略

| 任务类型 | 调度频率 | 示例 |
|----------|----------|------|
| 全量同步 | 每日凌晨 | 02:00 |
| 增量同步 | 每小时 | 整点 |
| 实时同步 | 持续 | CDC |

### 6.5.2 依赖管理

```text
任务 A（客户数据）
    │
    ├── 任务 B（订单数据）依赖任务 A
    │       │
    │       └── 任务 C（销售统计）依赖任务 B
    │
    └── 任务 D（客户画像）依赖任务 A
```

## 6.6 ETL 错误处理

### 6.6.1 错误类型

| 错误类型 | 处理方式 |
|----------|----------|
| 连接错误 | 重试 3 次，间隔 5 分钟 |
| 数据格式错误 | 记录错误数据，继续处理 |
| 主键冲突 | 使用 MERGE 策略 |
| 业务规则错误 | 记录错误数据，人工处理 |
| 系统错误 | 停止任务，通知管理员 |

### 6.6.2 错误日志

```sql
CREATE TABLE etl_error_log (
    error_id VARCHAR(50) PRIMARY KEY,
    task_id VARCHAR(50) NOT NULL,
    error_time TIMESTAMP NOT NULL,
    error_type VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    source_data JSON,
    target_table VARCHAR(100),
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING/PROCESSED/IGNORED
    process_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT NOW()
);
```

## 6.7 ETL 性能优化

### 6.7.1 分批处理

```sql
-- 分批抽取
CREATE TEMP TABLE temp_extract_batch AS
SELECT * FROM source_table
WHERE id BETWEEN 1 AND 10000;

-- 分批加载
INSERT INTO target_table
SELECT * FROM temp_extract_batch;

-- 循环处理
FOR v_batch IN 1..10 LOOP
    -- 处理每批数据
END LOOP;
```

### 6.7.2 并行处理

```sql
-- 并行执行多个 ETL 任务
-- 任务 A 和任务 B 可以并行执行
```

### 6.7.3 索引管理

```sql
-- 加载前禁用索引
ALTER INDEX idx_crm_customer_customer_status DISABLE;

-- 执行加载
INSERT INTO crm_customer SELECT * FROM temp_transform_customer;

-- 加载后重建索引
ALTER INDEX idx_crm_customer_customer_status REBUILD;
```

## 6.8 禁止事项

- ❌ 禁止 ETL 任务不支持幂等性
- ❌ 禁止 ETL 任务不进行数据校验
- ❌ 禁止 ETL 任务不记录日志
- ❌ 禁止直接在生产环境执行全量 DELETE + INSERT
- ❌ 禁止忽略错误继续执行可能导致数据不一致
