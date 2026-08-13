# 01 AI SOP（工作流程规范）

> **DEPRECATED（内容层）**
> 自 2026-08-12 起，可执行流程真源为：
> - 不变量与输出：`docs/core/invariants.md`、`docs/core/output_contract.md`
> - 路由：`docs/core/routing.md` + `skill/crm-development-router`
> - 需求开发：`skill/crm-requirement-development`
> - 表结构变更：`skill/crm-schema-change`
>
> 本文仅保留旧「9 步」到新阶段的映射，供人类阅读；**AI 不得将本文当作优先加载的长规范**。

## 1.1 概述

AI 在 CRM 数据开发中须输出一致、可维护、可追溯的结果。执行时遵循 CORE 不变量（I-01～I-12）。

## 1.2 旧 9 步 → 新流程映射

| 旧步骤 | 新位置 |
|--------|--------|
| 1 理解业务需求 | requirement: REQUIREMENT_ANALYSIS |
| 2 检查缺失信息 | requirement: SCOPE_CONFIRM / FIELD_GAP（unresolved） |
| 3 输出设计方案 | 范围确认后的方案输出（短合同） |
| 4 编写 SQL/ETL/Procedure | requirement: IMPLEMENT_PROCEDURE 或专项命令 |
| 5 Explain Plan | 数据库可用后的补充验证；非每轮强制 |
| 6 性能优化 | 按需；参考 `docs/03_SQL_Performance.md` |
| 7 风险分析 | 方案/Review 短字段；非每轮长文 |
| 8 Code Review | REVIEW 阶段 + `docs/quality_rules.md` ID |
| 9 输出最终结果 | 交付阶段短合同 + 产物路径 |

## 1.3 输出格式

统一使用 **`docs/core/output_contract.md`**。
禁止每轮强制输出旧 8 段长模板。

## 1.4 禁止事项

见 `docs/core/invariants.md`。摘要：

- 禁止跳过门禁阶段
- 禁止未理解业务直接写代码
- 禁止猜测未确认信息
- 禁止无授权修改与提交
