# 变更管理

> 层级：L1 流程规则
> 版本：v1.0

## 1. 登记

所有正式变更先创建 Change Register，使用 `templates/change_register_template.yaml`。Change ID 必须唯一，格式为 `CHG-YYYYMMDD-XXX`。

登记至少包含变更类型、来源、范围、排除项、受影响资产、风险、验证计划和审批责任人。

## 2. 范围与影响

开始写入前，必须明确：修改什么、不修改什么、影响什么以及只读上游材料。业务规则、字段、表结构、来源或验收标准不明确时，登记 `unresolved` 并停止写入。

治理变更只能更新规则、模板、Harness 或文档控制面；一旦涉及业务需求、Mapping、DDL、SQL、存储过程或 ETL，必须转入对应 `requirement_development` 或 `schema_change` 流程。

## 3. 变更状态

Change Register 采用 `docs/core/governance.md` 定义的业务状态。Harness 任务状态、Change Register 状态和 Git 状态分别表达技术门禁、业务治理和版本控制，禁止用任一状态替代其他状态。

## 4. 范围扩大

发现新增受影响资产或新的业务规则时，必须停止当前写入，更新影响分析和 Change Register，并由用户重新确认 Manifest 后恢复。

## 5. 权威来源与文件处置

Change Register 必须列出本次事实来源及其权威位置。发现同名、同哈希、备份、编码异常或目录职责不清的文件时，只能先按 `docs/governance/source_of_truth.md` 分类为 `confirmed`、`warning` 或 `unresolved`。

恢复、删除、归档、迁移、重命名和转码均为独立高风险变更：Manifest 必须逐文件声明 `restore_source`、`delete_authorization`、`rename_from`、`rename_to`、`reference_impact`、验证和用户授权。禁止批量处置或以自动检查结果替代授权。
