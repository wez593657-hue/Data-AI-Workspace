/*
 * SQL 模板
 * 参考文档: docs/02_SQL_Standard.md
 */

-- 1. 业务理解
-- [描述业务背景和需求]

-- 2. 实现方案
-- [描述技术方案]

-- 3. SQL
SELECT 
    [字段名],           -- [字段注释]
    [字段名]            -- [字段注释]
FROM [表名] [别名]
-- [关联说明]
JOIN [表名] [别名] ON [关联条件]
WHERE [条件]
GROUP BY [分组字段]
HAVING [聚合条件]
ORDER BY [排序字段]
LIMIT [数量] OFFSET [偏移量];

-- 4. 执行逻辑
-- [描述代码执行步骤]

-- 5. Explain
-- EXPLAIN ANALYZE [SQL 语句];

-- 6. 性能分析
-- [性能评估]

-- 7. 风险分析
-- [风险评估]

-- 8. Review
-- [Code Review 结果]
