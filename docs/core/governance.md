# 项目规则治理

> 层级：L0 CORE
> 版本：v1.0
> 状态：ACTIVE
> 权威范围：项目规则层级、治理变更入口和跨流程不变量。

本文件定义项目规则如何被引入、执行、验证、审批和留痕。它不替代 `docs/core/invariants.md`、`docs/core/output_contract.md`、`docs/core/routing.md`、业务需求、Mapping Excel 或数据资产。

## 1. 规则层级

规则冲突时按以下顺序处理：

1. L0 CORE：`docs/core/` 中的不变量、输出合同、路由和本文件。
2. L1 流程与门禁：`docs/governance/`、Skill、`.harness/` 政策、阶段门禁和变更白名单。
3. L2 领域规则：SQL、ETL、存储过程、数据字典、Mapping 和根目录 `governance/` 中的专项技术规范。
4. L3 业务资产：需求、规则记忆卡片、Mapping Excel、DDL、存储过程、ETL 与离线验证资产。
5. L4 历史材料：分析、变更记录、经验和归档材料。

具体且已确认的业务事实优先于通用模板；Mapping Excel 是表结构字段事实的最高权威源。各类事实的默认权威位置和候选副本处置见 `docs/governance/source_of_truth.md`，实际目录职责见 `docs/governance/directory_structure.md`。无法确认时必须标记 `【待确认】` 或 `unresolved`，不得猜测。

## 2. 受控变更入口

所有写操作必须先归类为以下入口之一：

| 入口 | 适用内容 | 受控流程 |
|------|----------|----------|
| Requirement | 新需求、业务逻辑、目标表或存储过程 | `requirement_development` |
| Schema Change | Mapping、字段、DDL、MD/DD/数据字典同步 | `schema_change` |
| Bug Fix | 已确认实现错误 | 由路由按风险选择既有轻量/标准/严格流程 |
| Rule Governance | CORE、流程、门禁、模板、审批或生命周期规则 | `governance` |

任何业务资产变更不得借由 `governance` 流程绕开需求或 Schema 流程。规则治理与业务资产变更同时出现时，必须拆分为独立受控任务。

## 3. Change ID 与范围

每项正式变更必须采用 `CHG-YYYYMMDD-XXX` 格式的 Change ID，并以 `templates/change_register_template.yaml` 登记：来源、范围、排除项、影响资产、风险、验证证据、审批及生命周期。

开发前必须建立经用户确认的 `change_manifest.yaml`。白名单以任务为边界，任何范围扩大都必须重新分析并获得确认。

## 4. 数据与规则链路

```text
Requirement / Rule Card
  -> Business Rule
  -> Mapping
  -> DDL
  -> SQL / Procedure / ETL
  -> Validation Evidence
```

任一层不得脱离上层可追溯来源单独变更。数据结构以 Mapping Excel 为准；实现与验证不一致时必须回退到已确认来源复核。

## 5. 验证、评审与授权

QA 检查单文件静态规则，QB 检查跨文件一致性，QC 检查业务正确性和边界。必须按 QA -> QB -> QC 顺序执行；前置层失败时不得进入下一层。

评审、用户验收、提交授权和推送授权相互独立。`USER_APPROVED` 不等于 `COMMIT_ALLOWED`，`COMMIT_ALLOWED` 不等于 `PUSH_ALLOWED`。数据库不可用时只能声明离线验证结论，不得伪造运行或 Explain 结果。

## 6. 生命周期

Change Register 使用以下业务状态记录治理进度：

```text
DRAFT -> REGISTERED -> SCOPE_CONFIRMED -> BUSINESS_CONFIRMED
-> DATA_CONFIRMED -> DEVELOPING -> QA_PASSED -> QB_PASSED
-> QC_PASSED -> REVIEWED -> USER_APPROVED -> COMMITTED
-> PUSH_AUTHORIZED -> PUBLISHED -> ARCHIVED
```

失败状态为 `FAILED`，修正后回到对应阶段。该业务状态不替代 Harness 的技术状态机；Harness 仍是任务证据和阶段迁移的唯一技术状态源。

## 7. 资产生命周期

有效资产标记为 `ACTIVE`，被明确替代的资产标记为 `SUPERSEDED`，仅供审计的历史材料标记为 `ARCHIVED`。除临时文件、运行产物、敏感废弃文件或经确认无价值文件外，不得因治理而直接删除历史资产。

## 8. 持续治理

每次变更完成后，问题应按影响归类：偶发问题记录为 Lesson；流程缺陷修正规则/Skill；系统性缺陷修改 CORE；业务变化修改领域规则或业务资产。规则升级必须通过 `governance` 流程并保留 Change ID 与证据。
