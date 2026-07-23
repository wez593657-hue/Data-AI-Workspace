# CRM 两类开发流程与 Harness 设计

## 目标

将项目开发明确拆分为“需求开发”和“表结构变更”两类流程，并通过语义路由 skill 和 Harness 状态机强制按顺序执行。两类流程均只在 `master` 分支进行，不创建 Git 分支，不使用 PR。

## 流程路由

新增 `crm-development-router` 路由 skill，并为每个可写流程建立独立 skill：

| Harness profile | Process skill |
|---|---|
| `requirement_development` | `crm-requirement-development` |
| `schema_change` | `crm-schema-change` |

路由 skill 只负责依据用户命令和输入材料判断流程类型并指向目标 skill，不执行具体开发：

- 需求文档、业务需求、生成存储过程、实现业务规则，路由到 `requirement_development`。
- Mapping Excel 变更、MD/DD/数据字典同步、表结构对齐，路由到 `schema_change`。
- 同时包含两类目标时，先完成需求开发，再执行表结构变更。
- 仅分析、查询或校验时保持只读，不创建修改任务。
- 语义不足以唯一判断时，必须暂停并请求用户确认。

路由结果必须包含流程类型、目标 skill、判断依据、当前阶段、下一允许动作和禁止动作。后续新增流程时，必须同步新增流程 skill、Harness profile、状态/门禁和路由注册项。

## 需求开发流程

```text
CREATED
→ REQUIREMENT_ANALYZED
→ SCOPE_CONFIRMED
→ PROJECT_SCANNED
→ TABLE_LINEAGE_IDENTIFIED
→ SOURCE_CAPABILITY_ANALYZED
→ FIELD_GAP_CONFIRMED
→ REQUIREMENT_REVIEW_PASSED
→ MEMORY_CARD_UPDATED
→ PROCEDURE_IMPLEMENTED
→ PROCEDURE_REVIEW_PASSED
→ TMP_TABLES_GENERATED
→ FULL_VALIDATION_PASSED
→ USER_APPROVED
→ COMMIT_ALLOWED
→ PUSH_ALLOWED
→ COMPLETED
```

必须记录需求版本、记忆卡片扫描结果、需求范围、目标表、源表、字段可实现性、缺失材料、审核结论、存储过程模板依据和临时表清单。

字段不足时，`FIELD_GAP_CONFIRMED` 退回 `MATERIALS_SUPPLEMENTED`，补充材料后回到 `SOURCE_CAPABILITY_ANALYZED`，重新分析后再进入字段确认和审核。

允许退回：

- `SOURCE_CAPABILITY_ANALYZED`、`FIELD_GAP_CONFIRMED`、`REQUIREMENT_REVIEW_PASSED` 失败时退回 `MATERIALS_SUPPLEMENTED`；
- `PROCEDURE_REVIEW_PASSED` 失败时退回 `PROCEDURE_IMPLEMENTED`。

## 表结构变更流程

```text
CREATED
→ MAPPING_EXCEL_ANALYZED
→ RELATED_FILES_SCANNED
→ CHANGE_SCOPE_IDENTIFIED
→ USER_SCOPE_CONFIRMED
→ ASSETS_UPDATED
→ ASSETS_REVIEW_PASSED
→ FULL_VALIDATION_PASSED
→ USER_APPROVED
→ COMMIT_ALLOWED
→ PUSH_ALLOWED
→ COMPLETED
```

必须记录 Excel 最近变更、MD/DD/数据字典扫描结果、修改范围、用户确认、实际修改文件和一致性审核结果。`ASSETS_REVIEW_PASSED` 失败时退回 `CHANGE_SCOPE_IDENTIFIED`。

## Agent 与证据

开发和审核是 Harness 中的独立阶段。审核必须生成结构化证据，包含审核类型、结果、检查文件、检查规则、问题、退回状态和证据引用。需求可实现性审核与存储过程审核支持独立 Codex 子任务；子任务只读、不创建 Git 分支，结果必须回写 Harness。

## 门禁

- 未选择流程 profile 不能修改文件；
- 需求开发在记忆卡片、范围、源表能力和用户确认未完成前不能进入实现；
- 表结构变更在 Excel 差异、修改范围和用户确认未完成前不能修改资产；
- 审核失败必须退回，不允许跳过；
- `FULL_VALIDATION_PASSED` 和 `USER_APPROVED` 未完成前不能提交；
- `COMMIT_ALLOWED` 未完成前不能推送；
- 所有任务只能在 `master` 分支执行，不创建分支。

## 验证

测试覆盖流程语义路由、状态顺序、退回路径、证据结构、用户确认门禁、提交推送门禁和无分支约束。
