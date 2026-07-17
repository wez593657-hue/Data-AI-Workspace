# 04 Kingbase 数据库指南

## 4.1 概述

本指南提供 Kingbase 数据库的使用规范和最佳实践，包括数据库配置、SQL 语法、特有功能等。

## 4.2 数据库版本

| 版本 | 状态 | 说明 |
|------|------|------|
| KingbaseES V8 | 推荐 | 最新稳定版本 |
| 补丁级别 | 【待确认】 | 需确认具体补丁版本 |

## 4.3 Kingbase 特有语法

### 4.3.1 数据类型

| Kingbase 类型 | PostgreSQL 对应 | 说明 |
|---------------|-----------------|------|
| `VARCHAR2(n)` | `VARCHAR(n)` | 变长字符串 |
| `NUMBER(p,s)` | `NUMERIC(p,s)` | 数值类型 |
| `DATE` | `DATE` | 日期类型 |
| `TIMESTAMP` | `TIMESTAMP` | 时间戳 |
| `CLOB` | `TEXT` | 大文本 |
| `BLOB` | `BYTEA` | 二进制大对象 |

### 4.3.2 序列

```sql
-- 创建序列
CREATE SEQUENCE seq_crm_customer
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCYCLE;

-- 使用序列
INSERT INTO crm_customer (customer_id, customer_name)
VALUES (nextval('seq_crm_customer'), '客户A');

-- 获取当前值
SELECT currval('seq_crm_customer');
```

### 4.3.3 自增字段

```sql
-- 创建表时定义自增字段
CREATE TABLE crm_customer (
    customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_name VARCHAR(200) NOT NULL,
    customer_code VARCHAR(50) UNIQUE NOT NULL
);

-- 或使用序列
CREATE TABLE crm_customer (
    customer_id INT PRIMARY KEY DEFAULT nextval('seq_crm_customer'),
    customer_name VARCHAR(200) NOT NULL
);
```

### 4.3.4 分区表

```sql
-- 创建范围分区表
CREATE TABLE crm_order (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_amount DECIMAL(18,2) NOT NULL,
    order_date DATE NOT NULL
)
PARTITION BY RANGE (order_date);

-- 创建分区
CREATE TABLE crm_order_202401
PARTITION OF crm_order
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE crm_order_202402
PARTITION OF crm_order
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
```

### 4.3.5 物化视图

```sql
-- 创建物化视图
CREATE MATERIALIZED VIEW mv_customer_order_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_amount) AS total_amount
FROM crm_customer c
LEFT JOIN crm_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 刷新物化视图
REFRESH MATERIALIZED VIEW mv_customer_order_summary;

-- 并发刷新
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_customer_order_summary;
```

## 4.4 Kingbase 性能特性

### 4.4.1 并行查询

```sql
-- 查看并行查询配置
SHOW max_parallel_workers_per_gather;

-- 设置并行度
SET max_parallel_workers_per_gather = 4;

-- 强制并行查询
SELECT /*+ PARALLEL(4) */
    customer_id,
    customer_name
FROM crm_customer;
```

### 4.4.2 查询优化器提示

```sql
-- 指定连接顺序
SELECT /*+ LEADING(c o) */
    c.customer_id,
    o.order_id
FROM crm_customer c
JOIN crm_order o ON c.customer_id = o.customer_id;

-- 指定连接方式
SELECT /*+ USE_NL(c o) */      -- Nested Loop
SELECT /*+ USE_HASH(c o) */     -- Hash Join
SELECT /*+ USE_MERGE(c o) */    -- Merge Join

-- 指定索引
SELECT /*+ INDEX(c idx_crm_customer_customer_status) */
    customer_id,
    customer_name
FROM crm_customer c
WHERE c.customer_status = 'ACTIVE';
```

### 4.4.3 内存配置

```sql
-- 查看内存配置
SHOW work_mem;
SHOW maintenance_work_mem;
SHOW shared_buffers;

-- 设置内存参数
SET work_mem = '64MB';
SET maintenance_work_mem = '256MB';
```

## 4.5 Kingbase 安全

### 4.5.1 用户管理

```sql
-- 创建用户
CREATE USER crm_user WITH PASSWORD 'password';

-- 授予权限
GRANT SELECT, INSERT, UPDATE, DELETE ON crm_customer TO crm_user;
GRANT ALL ON SEQUENCE seq_crm_customer TO crm_user;

-- 创建角色
CREATE ROLE crm_read;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO crm_read;

-- 授予角色
GRANT crm_read TO crm_user;
```

### 4.5.2 连接限制

```sql
-- 设置连接数限制
ALTER USER crm_user WITH CONNECTION LIMIT 10;

-- 设置空闲超时
SET idle_in_transaction_session_timeout = '60000';
```

## 4.6 Kingbase 备份与恢复

### 4.6.1 逻辑备份

```sql
-- 使用 sys_dump 备份
sys_dump -U username -d dbname -f backup.sql

-- 使用 sys_dumpall 备份所有数据库
sys_dumpall -U username -f all_backup.sql
```

### 4.6.2 恢复

```sql
-- 使用 sys_restore 恢复
sys_restore -U username -d dbname backup.sql

-- 直接执行 SQL 文件
sys_sql -U username -d dbname -f backup.sql
```

### 4.6.3 定时备份策略

| 备份类型 | 频率 | 保留期 |
|----------|------|--------|
| 全量备份 | 每日 | 7 天 |
| 增量备份 | 每小时 | 24 小时 |
| 日志备份 | 持续 | 7 天 |

## 4.7 Kingbase 监控

### 4.7.1 系统视图

```sql
-- 数据库状态
SELECT * FROM sys_stat_database;

-- 表统计信息
SELECT * FROM sys_stat_user_tables;

-- 索引统计信息
SELECT * FROM sys_stat_user_indexes;

-- 锁状态
SELECT * FROM sys_locks;

-- 慢查询日志
SELECT * FROM sys_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### 4.7.2 性能指标

| 指标 | 监控对象 | 阈值 |
|------|----------|------|
| CPU 使用率 | 数据库服务器 | < 80% |
| 内存使用率 | 数据库服务器 | < 85% |
| 磁盘 I/O | 数据目录 | < 90% |
| 连接数 | 数据库连接 | < 80% |
| 锁等待 | 表/行锁 | 0 |
| 慢查询 | 查询执行时间 | < 1s |

## 4.8 Kingbase 与 PostgreSQL 兼容性

### 4.8.1 兼容特性

- SQL 语法兼容 PostgreSQL
- 系统视图兼容（部分前缀为 sys_ 而非 pg_）
- 存储过程语法兼容
- 函数和操作符兼容

### 4.8.2 差异点

| 特性 | Kingbase | PostgreSQL |
|------|----------|------------|
| 系统视图前缀 | sys_ | pg_ |
| 数据类型 | VARCHAR2, NUMBER | VARCHAR, NUMERIC |
| 备份工具 | sys_dump, sys_restore | pg_dump, pg_restore |
| 特有功能 | 分区表增强, 并行查询 | 原生功能 |

## 4.9 注意事项

- ❌ 禁止使用 PostgreSQL 特有语法而未确认 Kingbase 兼容性
- ❌ 禁止修改系统级配置而未经过测试
- ❌ 禁止在生产环境直接执行未验证的 DDL
- ⚠️ 所有 SQL 变更必须在测试环境验证后才能上线
