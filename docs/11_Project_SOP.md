# 11 项目 SOP

## 11.1 概述

本文件只保留项目主流程总纲。

- 不变量与输出合同：`docs/core/invariants.md`、`docs/core/output_contract.md`
- 路由：`docs/core/routing.md`
- 执行细则：`docs/16_Execution_Rules.md`
- 离线优先：`docs/offline-first-development.md`
- 可执行阶段：对应 Skill（`skill/crm-requirement-development`、`skill/crm-schema-change`）

## 11.2 项目主流程

业务项目开发只使用两类主流程，规则控制面另设独立治理流程：

1. `requirement_development`：根据需求文件分析并开发目标表存储过程及临时表。
2. `schema_change`：根据 Mapping Excel 最近变更同步 MD、DD 和数据字典。
3. `governance`：根据规则治理变更更新 CORE、流程、门禁、模板、审批或生命周期控制面；不得借此流程修改业务数据资产。

流程由用户命令语义自动路由。语义无法唯一判断时，必须停止修改并请求确认。

## 11.3 执行顺序（索引）

需求开发与表结构变更的阶段顺序以 **Skill workflow** 为准，此处不重复维护长列表，避免双源。

人类可读摘要：

**需求开发：** 需求分析与确认 → 数据分析 → 字典/Mapping 确认 → SQL/存储过程 → ETL（如需）→ 校验与 Review → 用户确认 → 上线相关授权

**表结构变更：** Mapping 变更分析 → 关联资产扫描 → 范围确认 → 资产修改 → 一致性审核 → 完整校验 → 用户确认

## 11.4 约束

- 遵守 I-01～I-12（`docs/core/invariants.md`）
- 任何阶段不能无门禁跳过
- 不确定内容标记 `【待确认】` 或 `unresolved`
- 需求、字典、Mapping、SQL、存储过程保持可追溯一致
