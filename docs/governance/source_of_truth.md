# 权威来源治理

> 层级：L1 治理流程
> 版本：v1.0
> 状态：ACTIVE
> 适用范围：项目规则、业务资产、验证和任务证据的权威位置判定。

## 1. 目的

本规则定义每类项目事实的默认权威位置，避免将需求附件、历史备份、参考逻辑或运行产物误当作正式来源。它不改变已确认业务口径，也不授权迁移、删除或重命名资产。

## 2. 权威来源矩阵

| 事实类型 | 默认权威位置 | 非权威材料的用途 | 冲突处理 |
|---|---|---|---|
| L0 不变量、输出合同、路由 | `docs/core/` | 其他文档只能引用，不得覆盖 | 停止写入，按 `governance` 流程修订 L0 |
| 变更、审批、发布、RACI、生命周期 | `docs/governance/` | 任务报告记录某次执行事实 | 以 L1 规则为准，任务记录不得改写规则 |
| 业务需求 | `requirements/` | 分析与变更文档可引用 | 业务负责人确认后更新需求 |
| 规则记忆卡片 | `requirements/*规则记忆卡片.md` | 历史分析仅供参考 | 与需求版本不一致时标记 `unresolved` |
| 正式字段 Mapping | `data_assets/mapping/` | `requirements/` 中工作簿只能是需求口径、附件或候选副本 | Mapping Excel 与 MD/DD/DDL 冲突时以 Excel 为字段事实，并按 `schema_change` 处理 |
| DDL | `data_assets/ddl/` | 数据字典和 Mapping 说明其结构含义 | 与 Mapping 冲突时不得猜测，按 Mapping 与用户确认复核 |
| 存储过程 | `data_assets/stored_procedure/` | `data_assets/reference_logic/` 仅作实现参考 | 与需求/Mapping 不一致时进入 `requirement_development` 或 `schema_change` |
| ETL | `data_assets/etl/`（存在时） | 其他脚本不得替代正式 ETL | 未找到正式资产时标记 `unresolved` |
| 离线验证规则、夹具、期望与参考实现 | `validation/` | `.harness/` 保存门禁和任务证据 | 离线结果不替代真实数据库验证 |
| Harness 状态、政策、证据 | `.harness/` | 变更登记记录业务状态 | Harness 技术状态是阶段门禁唯一来源 |
| 日期参数、参考逻辑与 TMP 专项规则 | `governance/` | `docs/governance/` 不复制专项正文 | 专项规则变更走 `governance` 流程 |
| 历史分析、变更说明与经验 | `docs/analysis/`、`docs/changes/`、`docs/lessons/` | 不作为默认业务事实来源 | 必须回溯到上述正式来源验证 |

## 3. 文件分类

`requirements/` 中的 Office 文件必须逐文件登记为以下之一：

| 分类 | 含义 | 写入/处置规则 |
|---|---|---|
| `requirement_source` | 已确认需求、业务口径或用户提供材料 | 可作为需求依据，不替代正式 Mapping |
| `requirement_attachment` | 需求附件或参考材料 | 必须在需求或 Change Register 中说明关联关系 |
| `mapping_duplicate_candidate` | 与 `data_assets/mapping/` 正式资产同名或同哈希的候选副本 | 处置前必须做哈希、引用和用户确认；默认 `unresolved` |
| `backup_candidate` | 备份或历史副本 | 不得自动删除；逐文件记录保留、归档或删除理由 |
| `unresolved` | 无法确认分类 | 禁止据此修改正式资产或执行清理 |

`requirements/crmdm表结构.xlsx` 当前登记为 `mapping_duplicate_candidate`；审计已确认其与 `data_assets/mapping/crmdm表结构.xlsx` SHA-256 相同，但尚未获得处置授权。

## 4. 冲突与处置

1. 权威来源冲突、来源缺失或同名副本均不得以路径名称推断。
2. 发现候选重复资产时，先记录哈希、引用、Git 跟踪状态和影响范围；自动检查只报告，不修改文件。
3. 删除、归档、恢复、迁移、重命名或转码必须建立独立 Change ID，并在 Manifest 中逐文件列出来源、目标、引用影响、验证和用户授权。
4. 同一事实只能有一个默认权威来源；非权威副本必须记录其类别或保持 `unresolved`。

## 5. 验收

- 规则、任务清单和 Change Register 均能列出相应权威来源。
- 未确认材料不进入业务开发、表结构同步或自动清理。
- 自动化检查输出 `confirmed`、`warning` 或 `unresolved`，不自行裁决业务冲突。
