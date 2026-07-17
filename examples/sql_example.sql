/*
 * SQL 示例: 查询客户订单统计
 * 参考文档: docs/02_SQL_Standard.md
 */

-- 1. 业务理解
-- 需求：查询每个活跃客户的订单数量和订单总金额
-- 核心目标：统计客户的交易活跃度
-- 业务规则：只统计状态为 ACTIVE 的客户

-- 2. 实现方案
-- 使用 JOIN 关联客户表和订单表
-- 使用 GROUP BY 按客户分组统计
-- 使用 COALESCE 处理无订单的客户

-- 3. SQL
SELECT 
    c.customer_id,           -- 客户ID
    c.customer_name,         -- 客户名称
    c.customer_code,         -- 客户编码
    COALESCE(COUNT(o.order_id), 0) AS order_count,        -- 订单数量
    COALESCE(SUM(o.order_amount), 0.00) AS total_amount   -- 订单总金额
FROM crm_customer c
-- 客户与订单通过 customer_id 关联，一对多关系
LEFT JOIN crm_order o ON c.customer_id = o.customer_id
WHERE c.customer_status = 'ACTIVE'
GROUP BY c.customer_id, c.customer_name, c.customer_code
ORDER BY total_amount DESC
LIMIT 100;

-- 4. 执行逻辑
-- 1. 从 crm_customer 表筛选状态为 ACTIVE 的客户
-- 2. 通过 customer_id 左关联 crm_order 表
-- 3. 按客户分组统计订单数量和总金额
-- 4. 使用 COALESCE 将 NULL 转换为 0
-- 5. 按总金额降序排序，取前 100 条

-- 5. Explain
-- EXPLAIN ANALYZE
-- SELECT ...

-- 6. 性能分析
-- - 索引使用: idx_crm_customer_customer_status, idx_crm_order_customer_id
-- - 执行时间: 预估 < 1s
-- - 数据量: 取决于客户数量

-- 7. 风险分析
-- - 数据一致性: 依赖订单表数据完整性
-- - 性能风险: 客户数量大时可能需要优化

-- 8. Review
-- - SQL 正确性: 符合业务需求
-- - 命名规范: 符合规范
-- - 注释: 完整
-- - 索引: 使用了必要索引
