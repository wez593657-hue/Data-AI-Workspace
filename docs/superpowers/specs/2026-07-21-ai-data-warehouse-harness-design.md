# AI 数据仓库开发 Harness 设计

## 1. 目标与边界

本设计为当前 Kingbase CRM 数据仓库项目提供一套可审计、默认失败关闭的 AI 开发 Harness，覆盖：

```text
需求文档 → 规则记忆卡片 → 数据分析 → DDL → 数据字典 → Mapping
→ SQL → 存储过程 → ETL → Explain → Code Review → 测试 → CI/PR → 发布
```

Harness 的目标不是声称 AI 能绝对正确理解业务，而是建立以下强制条件：没有完整证据、可追溯来源、规则覆盖、验证结果和必要审批时，AI 不得进入下一阶段，也不得提交或发布。

本期不实现外部任务平台、不替代业务人员确认业务口径、不自动猜测缺失规则、不允许 AI 直接绕过 Harness 修改或提交仓库。

## 2. 设计原则

1. **失败关闭**：状态、证据、权限或校验缺失时拒绝继续。
2. **事实优先**：读取、修改、校验和审批都必须产生机器可复核证据。
3. **需求驱动**：每条业务规则必须有需求来源、实现落点和测试证据。
4. **血缘完整**：目标字段必须可追溯到来源字段和转换逻辑。
5. **状态不可跳过**：阶段转换由 Harness 校验，不能由 AI 自行声明完成。
6. **权限最小化**：AI 只能申请当前阶段和白名单路径所需的能力。
7. **人工负责口径**：业务规则存在歧义时只能阻塞并请求确认。

## 3. 总体架构

```text
AI 对话层
    ↓ 仅提交读取、分析、变更和校验请求
Harness 控制层
    ├── 任务状态机
    ├── 权限与路径白名单
    ├── 需求/版本/记忆卡片校验
    ├── 数据血缘和产物依赖图
    ├── 业务规则覆盖与反向逻辑校验
    ├── 测试和 Explain 门禁
    └── 证据与阻塞记录
    ↓ 通过门禁后才执行
隔离工作区
    ↓
本地 Hooks → CI → PR 保护和人工审批
```

AI 不应拥有任意文件写入、任意 Shell、`git commit` 或 `git push` 权限。所有变更必须由 Harness 代为执行，或至少由 Harness 在执行前后进行不可绕过的校验。

## 4. 目录与组件

建议新增：

```text
scripts/harness/
├── cli.py
├── task_manager.py
├── state_machine.py
├── permission_guard.py
├── evidence_store.py
├── requirement_parser.py
├── version_guard.py
├── memory_card_guard.py
├── lineage_analyzer.py
├── artifact_graph.py
├── rule_coverage_checker.py
├── reverse_logic_checker.py
├── test_case_generator.py
├── explain_checker.py
├── change_guard.py
├── gate_checker.py
└── schemas/
    ├── task.schema.json
    ├── requirement.schema.json
    ├── business_rule.schema.json
    ├── lineage.schema.json
    └── evidence.schema.json

.harness/
├── config.yaml
├── policies/
│   ├── allowed_paths.yaml
│   ├── phase_gates.yaml
│   └── required_evidence.yaml
└── tasks/<task-id>/
    ├── task.yaml
    ├── requirement.yaml
    ├── business_rules.yaml
    ├── read_manifest.yaml
    ├── artifact_graph.yaml
    ├── change_manifest.yaml
    ├── test_cases.yaml
    ├── evidence/
    ├── reports/
    └── blocking.yaml
```

现有 `scripts/workspace_validation.py`、`scripts/validate_cross_layer_consistency.py`、Git Hooks 和 `.github/workflows/` 保留，由 Harness 统一编排和读取结果。

## 5. 状态机与阶段门禁

Harness 支持两类工作流配置。`data_warehouse` 用于业务需求开发，覆盖需求、规则、血缘、DDL、字典、Mapping、SQL、存储过程、ETL、测试和发布；`harness` 用于 Harness 自身开发，避免伪造业务需求证据：

```text
harness:
CREATED → WORKSPACE_CHECKED → IMPLEMENTATION_READY
→ QUICK_VALIDATION_PASSED → FULL_VALIDATION_PASSED
→ USER_APPROVED → NEXT_PHASE_ALLOWED → IMPLEMENTATION_READY
→ ... → RELEASE_APPROVED → COMMIT_ALLOWED → COMPLETED
```

任务必须在 `task.yaml` 中声明 `workflow_profile`。缺失或不属于允许值时阻塞。

任务状态必须严格按以下顺序推进：

```text
CREATED
→ WORKSPACE_CHECKED
→ REQUIREMENT_PARSED
→ MEMORY_CARD_VERIFIED
→ BUSINESS_RULES_CONFIRMED
→ DATA_LINEAGE_CONFIRMED
→ DDL_READY
→ DICTIONARY_READY
→ MAPPING_READY
→ SQL_READY
→ PROCEDURE_READY
→ ETL_READY
→ REVERSE_LOGIC_PASSED
→ TEST_PASSED
→ EXPLAIN_PASSED
→ REVIEW_PASSED
→ USER_APPROVED
→ FULL_VALIDATION_PASSED
→ COMMIT_ALLOWED
→ PUSH_ALLOWED
→ PR_APPROVED
→ COMPLETED
```

关键门禁：

| 目标状态 | 必要条件 |
|----------|----------|
| `BUSINESS_RULES_CONFIRMED` | 需求规则已结构化，来源位置完整，歧义已确认 |
| `DATA_LINEAGE_CONFIRMED` | ODS 到目标层的字段血缘和转换规则完整 |
| `DDL_READY` | 目标表结构、注释、类型和约束已确认 |
| `MAPPING_READY` | 每个目标字段有来源、转换和规则落点 |
| `PROCEDURE_READY` | 存储过程与 Mapping、DDL、业务规则一致 |
| `REVERSE_LOGIC_PASSED` | 从实现反向提取的逻辑与需求规则一致 |
| `TEST_PASSED` | 正例、反例、边界、空值、重复和重跑测试通过 |
| `EXPLAIN_PASSED` | 性能检查通过或风险已获得明确批准 |
| `COMMIT_ALLOWED` | 完整校验通过且用户明确允许提交 |
| `PUSH_ALLOWED` | 用户明确允许推送，分支和远程状态满足要求 |

没有前置证据时，状态转换必须失败并生成阻塞记录。

## 6. 需求、版本和规则模型

需求解析器输出结构化规则，每条规则必须有唯一编号：

```yaml
- rule_id: RISK-001
  description: 客户风险等级不得高于有效风险测评等级
  source:
    file: requirements/客户风险评估.md
    section: 3.2
    version: v1.2
  status: confirmed
```

开始开发前必须核对：

```text
需求文档版本
规则记忆卡片版本
代码版本标注
Mapping 版本
DDL/数据字典版本
```

版本不一致时必须列出差异、影响和处理方案，等待用户确认后才能恢复。

## 7. 文件读取和数据血缘

`read_manifest.yaml` 必须记录读取顺序、用途、版本或哈希、读取结果和证据。默认依赖顺序为：

```text
项目规则和模板
→ 需求文档
→ 规则记忆卡片
→ ODS 数据字典
→ ODS 到 DWD Mapping
→ DWD DDL/数据字典
→ DWD 到 DWS Mapping
→ DWS DDL/数据字典
→ DWS 到 ADS Mapping
→ ADS DDL/数据字典
→ 现有 SQL、存储过程和 ETL
```

每个目标字段必须追溯到来源表、来源字段、转换逻辑、过滤条件、聚合逻辑、空值处理、关联条件和业务规则编号。无法追溯的字段必须为 `UNRESOLVED` 并阻塞，禁止猜测。

## 8. 产物一致性与反向逻辑验证

Harness 必须构建以下依赖图：

```text
需求规则
→ 数据字典
→ DDL
→ Mapping
→ SQL
→ 存储过程/ETL
→ 测试
→ Explain/Review
```

从 SQL、存储过程和 ETL 中反向提取：来源表、目标表、字段映射、JOIN、过滤、CASE、聚合、时间条件、异常处理和清理逻辑，并与需求规则和 Mapping 比对。

出现以下任一情况必须阻塞：

- 需求规则没有实现落点；
- 实现逻辑没有需求或 Mapping 来源；
- 目标字段没有来源；
- Mapping 与 SQL 不一致；
- 业务分支无法解释；
- 需求、DDL、字典或代码版本不一致。

## 9. 测试与性能门禁

每条业务规则至少生成并验证：一个正例、一个反例和一个边界例。测试矩阵必须覆盖正常、空值、重复、边界日期、边界金额、无匹配关联、多匹配关联、历史数据、重复执行和异常回滚。

Explain 检查至少覆盖：索引命中、全表扫描、隐式类型转换、函数导致索引失效、重复扫描、提前过滤、JOIN 顺序、排序、临时空间和估算行数。

## 10. 权限、变更和提交控制

能力令牌按阶段发放，例如：

```text
read-token → plan-token → ddl-token → dictionary-token → mapping-token
→ procedure-token → validate-token → commit-token → push-token
```

每个令牌必须绑定前置状态和允许路径。`change_manifest.yaml` 必须列出允许修改和禁止修改的文件；`pre-commit`、`pre-push` 和 CI 必须拒绝越界变更。

本地 Hook 不是最终安全边界。最终提交必须经过服务端分支保护、必需状态检查、Code Owner 审批和人工批准。

## 11. 阻塞协议与证据

阻塞记录必须至少包含：停止原因、原因分类、文件/命令证据、影响范围、推荐方案、备选方案、需要用户决定的事项、恢复条件、用户决策和当前状态。

阻塞期间只允许执行定位、取证和恢复条件验证等只读操作。收到用户决策后，必须重新验证恢复条件并记录恢复证据，不能仅凭口头说明恢复。

## 12. 实施阶段

第一期按以下顺序实现：

1. 定义 JSON/YAML Schema、状态机和阶段门禁。
2. 实现任务创建、状态迁移、证据记录和阻塞记录。
3. 接入需求版本、记忆卡片和读取清单校验。
4. 接入 DDL、数据字典、Mapping 和跨层一致性校验。
5. 实现变更白名单和 Git Hooks 门禁。
6. 接入规则覆盖、反向逻辑、测试矩阵和 Explain 报告。
7. 接入 `workspace_validation.py` 和 GitHub Actions。
8. 使用一条完整 CRM 需求链路进行回归验证。

本期不实现 Harness 自己生成业务规则；业务规则必须来自需求文档或用户确认。

## 13. 验收标准

- 未创建任务记录不能进入开发。
- 未完成需求、版本和记忆卡片核对不能进入数据设计。
- 未完成字段血缘不能生成 Mapping 或存储过程。
- 需求规则覆盖率不为 100% 时不能继续。
- 反向逻辑与需求不一致时必须阻塞。
- 正例、反例和边界测试不完整时不能通过。
- Explain 风险未处理时不能通过性能门禁。
- 变更超出白名单时 Hook 和 CI 均失败。
- 没有完整校验和用户明确命令时不能提交或推送。
- 阻塞记录缺少原因、证据、影响或恢复条件时不能恢复。
- 最终结果必须经过人工业务确认和 Code Owner 审批。

## 14. 非绝对保证声明

Harness 可以强制证据、顺序、权限、验证和审批，但不能数学意义上证明 AI 完全理解业务。业务正确性仍需要结构化需求、可追溯血缘、反向逻辑验证、测试数据和人工业务审批共同确认。任何证据不足或语义不确定的情况都必须失败关闭，而不是猜测补全。
