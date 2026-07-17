/*
 * ETL 模板
 * 参考文档: docs/06_ETL_Standard.md
 */

-- ====================
-- ETL 任务: [任务名称]
-- 源表: [源表]
-- 目标表: [目标表]
-- 同步方式: [全量/增量]
-- ====================

-- 步骤 1: Extract（抽取）
CREATE TEMP TABLE temp_extract_[表名] AS
SELECT 
    [字段名]
FROM [源表]
WHERE [条件];

-- 步骤 2: Transform（转换）
CREATE TEMP TABLE temp_transform_[表名] AS
SELECT 
    [字段名],
    [转换规则]
FROM temp_extract_[表名];

-- 步骤 3: Load（加载）
MERGE INTO [目标表] t
USING temp_transform_[表名] s
ON (t.[主键字段] = s.[主键字段])
WHEN MATCHED THEN
    UPDATE SET [字段] = s.[字段]
WHEN NOT MATCHED THEN
    INSERT ([字段列表]) VALUES (s.[字段列表]);

-- 步骤 4: Validate（校验）
SELECT 
    (SELECT COUNT(*) FROM temp_extract_[表名]) AS source_count,
    (SELECT COUNT(*) FROM temp_transform_[表名]) AS transform_count,
    (SELECT COUNT(*) FROM [目标表] WHERE etl_time >= NOW() - INTERVAL '1 hour') AS target_count;

-- 步骤 5: Log（日志）
INSERT INTO etl_task_log (
    log_id, task_id, task_name, start_time, end_time,
    source_table, target_table, extract_count, transform_count, load_count, status
) VALUES (
    [log_id], [task_id], [task_name], [start_time], NOW(),
    [源表], [目标表], [extract_count], [transform_count], [load_count], 'SUCCESS'
);

-- 步骤 6: Finish（完成）
DROP TABLE IF EXISTS temp_extract_[表名];
DROP TABLE IF EXISTS temp_transform_[表名];
