# 02 SQL 编码规范

## 2.1 概述

本规范定义了 Kingbase 数据库中 SQL 编码的统一标准，确保 SQL 代码的可读性、可维护性和性能。

## 2.2 基础规则

### 2.2.1 禁止 SELECT *

```sql
-- 错误
SELECT * FROM crm_customer;

-- 正确
SELECT 
    customer_id,
    customer_name,
    customer_code,
    create_time
FROM crm_customer;
```

### 2.2.2 必须显式字段

所有查询必须明确指定字段名，不得使用通配符。

### 2.2.3 必须使用表别名

```sql
-- 错误
SELECT 
    crm_customer.customer_id,
    crm_order.order_id
FROM crm_customer
JOIN crm_order ON crm_customer.customer_id = crm_order.customer_id;

-- 正确
SELECT 
    c.customer_id,
    o.order_id
FROM crm_customer c
JOIN crm_order o ON c.customer_id = o.customer_id;
```

### 2.2.4 JOIN 必须说明关联关系

```sql
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM crm_customer c
-- 客户与订单通过 customer_id 关联，一对一或一对多关系
JOIN crm_order o ON c.customer_id = o.customer_id;
```

### 2.2.5 UPDATE/DELETE 必须带 WHERE

```sql
-- 错误
UPDATE crm_customer SET customer_name = 'New Name';
DELETE FROM crm_order;

-- 正确
UPDATE crm_customer 
SET customer_name = 'New Name'
WHERE customer_id = 'C001';

DELETE FROM crm_order
WHERE order_id = 'O001';
```

### 2.2.6 优先使用临时表拆分复杂逻辑

```sql
-- 创建临时表存储中间结果
CREATE TEMP TABLE temp_order_summary AS
SELECT 
    customer_id,
    COUNT(order_id) AS order_count,
    SUM(order_amount) AS total_amount
FROM crm_order
WHERE order_date >= '2024-01-01'
GROUP BY customer_id;

-- 使用临时表进行最终查询
SELECT 
    c.customer_id,
    c.customer_name,
    t.order_count,
    t.total_amount
FROM crm_customer c
JOIN temp_order_summary t ON c.customer_id = t.customer_id;
```

### 2.2.7 减少 WITH 使用

复杂查询优先使用临时表而非 WITH 子句，便于调试和性能优化。

## 2.3 命名规范

### 2.3.1 表命名

| 类型 | 前缀 | 示例 |
|------|------|------|
| 业务表 | `crm_` | `crm_customer`, `crm_order` |
| 临时表 | `temp_` | `temp_order_summary` |
| 中间表 | `mid_` | `mid_customer_order` |
| 维度表 | `dim_` | `dim_product` |
| 事实表 | `fact_` | `fact_sales` |

### 2.3.2 字段命名

| 类型 | 规则 | 示例 |
|------|------|------|
| 主键 | `表名_id` | `customer_id`, `order_id` |
| 外键 | `关联表名_id` | `customer_id`（在 order 表中） |
| 时间 | `*_time` | `create_time`, `update_time` |
| 金额 | `*_amount` | `order_amount`, `payment_amount` |
| 名称 | `*_name` | `customer_name`, `product_name` |
| 编码 | `*_code` | `customer_code`, `product_code` |
| 状态 | `*_status` | `order_status`, `payment_status` |

### 2.3.3 别名命名

| 类型 | 规则 | 示例 |
|------|------|------|
| 表别名 | 表名首字母或缩写 | `crm_customer` → `c`, `crm_order` → `o` |
| 列别名 | 清晰描述含义 | `SUM(order_amount)` → `total_amount` |

## 2.4 格式规范

### 2.4.1 缩进

- 每个层级缩进 4 个空格
- 字段列表每个字段单独一行

### 2.4.2 关键字大写

```sql
SELECT 
    customer_id,
    customer_name
FROM crm_customer c
WHERE c.customer_status = 'ACTIVE'
ORDER BY c.create_time DESC;
```

### 2.4.3 字段必须添加注释

```sql
SELECT 
    c.customer_id,           -- 客户ID
    c.customer_name,         -- 客户名称
    c.customer_code,         -- 客户编码
    c.customer_status,       -- 客户状态：ACTIVE-活跃，INACTIVE-停用
    c.create_time            -- 创建时间
FROM crm_customer c;
```

### 2.4.4 条件表达式

```sql
SELECT 
    order_id,
    order_amount
FROM crm_order
WHERE 
    order_date >= '2024-01-01'
    AND order_date < '2024-02-01'
    AND order_status IN ('PENDING', 'PAID')
    AND order_amount > 100;
```

## 2.5 性能规范

### 2.5.1 索引使用

- WHERE 条件字段必须有索引
- JOIN 关联字段必须有索引
- ORDER BY/DISTINCT 字段建议有索引

### 2.5.2 避免函数包装索引字段

```sql
-- 错误：无法使用索引
SELECT * FROM crm_customer WHERE DATE(create_time) = '2024-01-01';

-- 正确：可以使用索引
SELECT * FROM crm_customer 
WHERE create_time >= '2024-01-01' 
AND create_time < '2024-01-02';
```

### 2.5.3 LIMIT 分页

```sql
-- 分页查询，每页 10 条
SELECT 
    customer_id,
    customer_name
FROM crm_customer
ORDER BY create_time DESC
LIMIT 10 OFFSET 0;
```

### 2.5.4 批量操作

```sql
-- 批量插入
INSERT INTO crm_customer (customer_id, customer_name, customer_code)
VALUES 
    ('C001', '客户A', 'CODE001'),
    ('C002', '客户B', 'CODE002'),
    ('C003', '客户C', 'CODE003');

-- 批量更新
UPDATE crm_customer 
SET customer_status = 'INACTIVE'
WHERE customer_id IN ('C001', 'C002', 'C003');
```

## 2.6 事务规范

```sql
BEGIN;

-- 业务操作
UPDATE crm_order 
SET order_status = 'PAID'
WHERE order_id = 'O001';

INSERT INTO crm_payment (order_id, payment_amount, payment_time)
VALUES ('O001', 1000.00, NOW());

-- 提交事务
COMMIT;

-- 或回滚
-- ROLLBACK;
```

## 2.7 SQL 输出固定模板

所有 SQL 输出必须包含以下 8 个部分：

```text
=======================
1. 业务理解
=======================
[描述业务背景和需求]

=======================
2. 实现方案
=======================
[描述技术方案]

=======================
3. SQL
=======================
[SQL 代码]

=======================
4. 执行逻辑
=======================
[描述代码执行步骤]

=======================
5. Explain
=======================
[Explain Plan 结果]

=======================
6. 性能分析
=======================
[性能评估]

=======================
7. 风险分析
=======================
[风险评估]

=======================
8. Review
=======================
[Code Review 结果]
```

## 2.8 禁止事项

- ❌ 禁止 SELECT *
- ❌ 禁止 UPDATE/DELETE 不带 WHERE
- ❌ 禁止函数包装索引字段
- ❌ 禁止使用隐式转换
- ❌ 禁止在 WHERE 中使用 OR 连接多个条件（建议拆分为 UNION）
