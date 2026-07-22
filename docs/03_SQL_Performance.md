# 03 SQL 性能优化指南

## 3.1 概述

本指南提供 Kingbase 数据库 SQL 性能优化的标准方法和最佳实践。

## 3.2 性能分析步骤

```
步骤 1: 执行 Explain Plan
        │
        ▼
步骤 2: 识别性能瓶颈
        │
        ▼
步骤 3: 制定优化方案
        │
        ▼
步骤 4: 实施优化
        │
        ▼
步骤 5: 验证优化效果
        │
        ▼
步骤 6: 输出优化报告
```

## 3.3 Explain Plan 分析

### 3.3.1 执行 Explain

```sql
EXPLAIN ANALYZE
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM crm_customer c
LEFT JOIN crm_order o ON c.customer_id = o.customer_id
WHERE c.customer_status = 'ACTIVE'
GROUP BY c.customer_id, c.customer_name;
```

### 3.3.2 关键指标解读

| 指标 | 说明 | 优化建议 |
|------|------|----------|
| Seq Scan | 全表扫描 | 添加索引 |
| Index Scan | 索引扫描 | 正常 |
| Index Only Scan | 仅索引扫描 | 最优 |
| Nested Loop | 嵌套循环 | 小表驱动大表 |
| Hash Join | 哈希连接 | 中等数据量 |
| Merge Join | 排序合并连接 | 大数据量 |
| Sort | 排序操作 | 添加排序索引 |
| Hash | 哈希操作 | 内存不足可能溢出 |

### 3.3.3 常见问题识别

```sql
-- 问题：全表扫描
-- 现象：Seq Scan on crm_customer
-- 原因：customer_status 字段没有索引
-- 解决方案：添加索引

CREATE INDEX idx_crm_customer_customer_status 
ON crm_customer(customer_status);
```

## 3.4 索引优化

### 3.4.1 索引类型

| 类型 | 适用场景 | 示例 |
|------|----------|------|
| B-Tree | 等值查询、范围查询、排序 | `customer_id`, `order_date` |
| Hash | 等值查询 | `customer_code` |
| GiST | 全文搜索、几何类型 | 【待确认】 |
| GIN | 数组、JSONB | 【待确认】 |

### 3.4.2 索引创建规范

```sql
-- 单列索引
CREATE INDEX idx_crm_customer_customer_status 
ON crm_customer(customer_status);

-- 组合索引（遵循最左前缀原则）
CREATE INDEX idx_crm_order_customer_id_order_date 
ON crm_order(customer_id, order_date DESC);

-- 唯一索引
CREATE UNIQUE INDEX idx_crm_customer_customer_code 
ON crm_customer(customer_code);

-- 部分索引（条件索引）
CREATE INDEX idx_crm_order_pending_status 
ON crm_order(order_id)
WHERE order_status = 'PENDING';
```

### 3.4.3 索引使用规则

| 规则 | 说明 |
|------|------|
| 最左前缀 | 组合索引必须从最左列开始使用 |
| 避免函数包装 | `DATE(create_time)` 无法使用索引 |
| 避免类型转换 | `customer_id = '123'` 可能无法使用索引 |
| LIKE 前缀匹配 | `customer_name LIKE '张%'` 可以使用索引 |

### 3.4.4 索引维护

```sql
-- 查看索引使用情况
SELECT 
    indexrelname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE relname = 'crm_customer';

-- 重建索引
REINDEX INDEX idx_crm_customer_customer_status;

-- 重建表所有索引
REINDEX TABLE crm_customer;
```

## 3.5 查询优化

### 3.5.1 拆分复杂查询

```sql
-- 优化前：复杂单查询
SELECT 
    c.customer_id,
    c.customer_name,
    (SELECT COUNT(*) FROM crm_order o WHERE o.customer_id = c.customer_id) AS order_count,
    (SELECT SUM(order_amount) FROM crm_order o WHERE o.customer_id = c.customer_id) AS total_amount,
    (SELECT MAX(order_date) FROM crm_order o WHERE o.customer_id = c.customer_id) AS last_order_date
FROM crm_customer c;

-- 优化后：使用会话临时表（temp_ 前缀，会话结束自动删除）
CREATE TEMP TABLE temp_order_stats AS
SELECT 
    customer_id,
    COUNT(order_id) AS order_count,
    SUM(order_amount) AS total_amount,
    MAX(order_date) AS last_order_date
FROM crm_order
GROUP BY customer_id;

SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(t.order_count, 0) AS order_count,
    COALESCE(t.total_amount, 0) AS total_amount,
    t.last_order_date
FROM crm_customer c
LEFT JOIN temp_order_stats t ON c.customer_id = t.customer_id;
```

### 3.5.2 使用 LIMIT 限制结果

```sql
-- 获取最新的 10 条订单
SELECT 
    order_id,
    customer_id,
    order_amount,
    order_date
FROM crm_order
ORDER BY order_date DESC
LIMIT 10;
```

### 3.5.3 避免不必要的排序

```sql
-- 优化前：不必要的排序
SELECT 
    customer_id,
    customer_name
FROM crm_customer
WHERE customer_status = 'ACTIVE'
ORDER BY customer_id;

-- 优化后：如果 customer_id 是主键，已有排序，不需要 ORDER BY
SELECT 
    customer_id,
    customer_name
FROM crm_customer
WHERE customer_status = 'ACTIVE';
```

### 3.5.4 使用 UNION ALL 替代 OR

```sql
-- 优化前：OR 条件
SELECT * FROM crm_order 
WHERE order_status = 'PENDING' OR order_status = 'PAID';

-- 优化后：UNION ALL
SELECT * FROM crm_order WHERE order_status = 'PENDING'
UNION ALL
SELECT * FROM crm_order WHERE order_status = 'PAID';
```

## 3.6 连接优化

### 3.6.1 选择合适的连接方式

| 连接方式 | 适用场景 | 条件 |
|----------|----------|------|
| Nested Loop | 小表驱动大表 | 驱动表数据量小 |
| Hash Join | 中等数据量 | 内存充足 |
| Merge Join | 大数据量 | 已排序或有排序索引 |

### 3.6.2 小表优先原则

```sql
-- 优化：确保小表作为驱动表
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id
FROM crm_customer c
JOIN crm_order o ON c.customer_id = o.customer_id
WHERE c.customer_status = 'ACTIVE';

-- 强制使用小表驱动
SELECT /*+ LEADING(c) */
    c.customer_id,
    c.customer_name,
    o.order_id
FROM crm_customer c
JOIN crm_order o ON c.customer_id = o.customer_id;
```

## 3.7 数据量控制

### 3.7.1 分批处理

```sql
-- 分批更新，每批 1000 条
WITH batch AS (
    SELECT customer_id 
    FROM crm_customer 
    WHERE customer_status = 'INACTIVE'
    LIMIT 1000
)
UPDATE crm_customer 
SET customer_status = 'DELETED'
WHERE customer_id IN (SELECT customer_id FROM batch);
```

### 3.7.2 时间范围限制

```sql
-- 仅查询最近 30 天的数据
SELECT 
    order_id,
    order_amount,
    order_date
FROM crm_order
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';
```

## 3.8 性能监控

### 3.8.1 慢查询日志

```sql
-- 查看慢查询配置
SHOW log_min_duration_statement;

-- 设置慢查询阈值（单位：毫秒）
SET log_min_duration_statement = 1000;
```

### 3.8.2 实时性能监控

```sql
-- 查看当前运行的查询
SELECT 
    pid,
    query,
    duration,
    state
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY duration DESC;

-- 查看锁等待
SELECT 
    a.pid,
    a.query,
    l.mode,
    l.locktype
FROM pg_stat_activity a
JOIN pg_locks l ON a.pid = l.pid
WHERE l.granted = false;
```

## 3.9 优化报告模板

```text
=======================
【性能优化报告】
=======================

1. 原始查询
-----------
[原始 SQL 代码]

2. Explain Plan 分析
--------------------
[Explain 结果]
- 扫描类型：[Seq Scan / Index Scan]
- 连接方式：[Nested Loop / Hash Join / Merge Join]
- 预估行数：[xxx]
- 实际行数：[xxx]
- 执行时间：[xxx ms]

3. 性能问题识别
--------------
- 问题 1：[描述]
- 问题 2：[描述]

4. 优化方案
----------
- 方案 1：[添加索引/重写查询/调整连接顺序]
- 方案 2：[描述]

5. 优化后查询
------------
[优化后的 SQL 代码]

6. 优化效果验证
--------------
- 执行时间：[xxx ms]（优化前：xxx ms）
- 提升比例：[xxx%]
- Explain Plan：[优化后的执行计划]

7. 风险评估
----------
- 索引维护成本：[高/中/低]
- 存储空间增加：[xxx MB]
- 对写入性能影响：[高/中/低]
```
