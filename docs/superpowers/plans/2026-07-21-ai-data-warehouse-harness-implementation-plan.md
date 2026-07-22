# AI 数据仓库开发 Harness 实施计划

## 1. 实施目标

根据已批准的 [Harness 设计](../specs/2026-07-21-ai-data-warehouse-harness-design.md)，在当前仓库内实现默认失败关闭的本地 Harness，并接入现有 Git Hooks、校验脚本和 GitHub Actions。

本计划只实现可验证的流程、权限、证据和一致性门禁，不实现“自动猜测业务规则”。任何未确认的业务规则都必须进入阻塞状态。

## 2. 实施约束

- 保留当前已有用户工作区修改，不执行清理或回退。
- 每个阶段完成后先执行对应校验，再进入下一阶段。
- 修改前记录允许修改文件和禁止修改文件。
- 不修改业务数据资产，除非任务清单和用户确认明确授权。
- 不执行 `git commit`、`git push` 或 PR 操作，除非用户明确下达命令。
- Harness 本身的变更也必须经过现有 `workspace_validation.py`、Hooks 和 CI。

## 3. 目标产物

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
├── policies/allowed_paths.yaml
├── policies/phase_gates.yaml
├── policies/required_evidence.yaml
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

## 4. 分阶段实施

### 阶段 0：基线和隔离

任务：

1. 检查当前分支、工作区、远程同步状态和已有 Hook。
2. 确认 Harness 文件不与用户已有修改重叠。
3. 建立 Harness 专用测试目录和最小配置。
4. 明确 Harness 自身允许修改路径。

验收：

- Harness 变更范围可列举；
- 用户已有修改未被覆盖；
- 测试可以在当前仓库独立运行。

### 阶段 1：Schema 和状态机

实现：

- `task.schema.json`；
- `requirement.schema.json`；
- `business_rule.schema.json`；
- `lineage.schema.json`；
- `evidence.schema.json`；
- `state_machine.py`；
- `task_manager.py`。

状态机必须支持 `data_warehouse` 和 `harness` 两类 workflow profile。Harness 自身实施不得伪造业务需求、记忆卡片或数据血缘状态。

Harness 工作流必须支持持续开发循环：`USER_APPROVED → NEXT_PHASE_ALLOWED → IMPLEMENTATION_READY`；最终发布审批必须独立于继续开发授权，`COMMIT_ALLOWED` 只能由发布授权触发。

要求：

- 状态只能按设计顺序迁移；
- 状态迁移必须验证前置证据；
- 非法跳转返回明确错误；
- 状态文件使用原子写入；
- 每次迁移记录时间、调用者、原因和证据引用。

测试：

- 每个合法状态迁移至少一个测试；
- 每个关键非法跳转至少一个测试；
- 缺失证据、过期证据和重复迁移测试；
- 中断写入后状态文件完整性测试。

### 阶段 2：任务创建、证据和阻塞

实现：

- `evidence_store.py`；
- `permission_guard.py`；
- `cli.py` 的 `create`、`status`、`record`、`block`、`resume` 命令；
- `task.yaml`、`evidence/` 和 `blocking.yaml` 生成逻辑。

证据字段：

```yaml
evidence_id: E-0001
task_id: TASK-001
phase: REQUIREMENT_PARSED
kind: file_read
path: requirements/example.md
sha256: <hash>
command: <command-id>
result: passed
created_at: <timestamp>
```

阻塞恢复必须验证：

- 用户决策已记录；
- 恢复条件已重新检查；
- 相关证据没有过期；
- 当前状态仍允许恢复。

测试：

- 缺少阻塞原因时拒绝写入；
- 缺少恢复条件时拒绝恢复；
- 阻塞状态禁止修改和提交能力；
- 证据文件哈希变化时标记过期。

### 阶段 3：需求、版本和记忆卡片

实现：

- `requirement_parser.py`；
- `version_guard.py`；
- `memory_card_guard.py`；
- 需求文件版本、变更记录和规则编号提取。

要求：

- 每条业务规则必须有来源文件和章节；
- 规则状态只能是 `confirmed`、`pending` 或 `blocked`；
- 需求和记忆卡片版本不一致时不能自动继续；
- 缺少规则来源时不能标记为已确认。

测试：

- 正常需求版本解析；
- 缺少版本号；
- 记忆卡片不存在；
- 版本不一致；
- 重复规则编号；
- 无来源规则拒绝通过。

### 阶段 4：读取清单和数据血缘

实现：

- `read_manifest.yaml` 校验；
- `lineage_analyzer.py`；
- `artifact_graph.py`；
- ODS、DWD、DWS、ADS 文件依赖关系校验。

要求：

- 读取顺序必须满足声明的依赖关系；
- 必需文件缺失时阻塞；
- 目标字段必须有来源和转换逻辑；
- 未解析字段统一标记 `UNRESOLVED`；
- 不允许用相似字段自动替代未确认字段。

测试：

- 完整血缘通过；
- 缺少中间层 Mapping；
- 目标字段无来源；
- 读取顺序逆序；
- 文件版本或哈希变化；
- 多来源字段冲突。

### 阶段 5：DDL、数据字典和 Mapping 门禁

实现：

- 接入现有 `validate_cross_layer_consistency.py`；
- 增加 DDL 与数据字典字段级比对；
- 增加 Mapping 目标字段完整性检查；
- 生成 `artifact_graph.yaml` 和差异报告。

校验：

- 表名、字段名、类型、长度、精度和可空性；
- 主键、唯一性和注释；
- 来源表、来源字段和转换规则；
- Mapping 与 DDL 的目标字段一致性；
- 未确认字段必须阻塞。

测试：

- 类型不一致；
- 长度不一致；
- 字段缺失；
- Mapping 多字段或少字段；
- 无转换说明；
- 注释缺失。

### 阶段 6：SQL、存储过程和 ETL 逻辑门禁

实现：

- `rule_coverage_checker.py`；
- `reverse_logic_checker.py`；
- SQL、存储过程和 ETL 的目标字段、来源表、JOIN、WHERE、CASE、聚合和异常处理提取。

要求：

- 需求规则覆盖率必须为 100%；
- SQL 实现逻辑必须能映射到需求或 Mapping；
- 禁止 `SELECT *`；
- JOIN 条件必须完整；
- 不能对未确认业务规则进行默认补全。

测试：

- 需求规则缺少实现；
- SQL 出现未声明业务分支；
- Mapping 与 SQL 来源不一致；
- 隐式类型转换；
- 缺少异常处理或事务控制；
- 重复扫描和未提前过滤。

### 阶段 7：静态测试矩阵门禁

实现：

- `test_case_generator.py`；
- 测试证据格式。

测试矩阵生成器必须使用当前任务输入，不得写死任何需求的目标表或业务规则；规则缺失、未确认或来源不完整时必须输出 `UNRESOLVED`。

测试矩阵至少包含：

- 正例；
- 反例；
- 边界日期和金额；
- 空值；
- 重复数据；
- 无匹配和多匹配关联；
- 历史数据；
- 重复执行；
- 异常回滚。

本阶段不执行真实数据库测试，不生成或审查 Explain 执行计划。

### 阶段 8：变更白名单、Hooks 和 CI

实现：

- `change_guard.py`；
- `gate_checker.py`；
- 更新 `hooks/pre-commit`、`hooks/pre-push`；
- 更新 `scripts/workspace_validation.py` 的 Harness 接入点；
- 更新 `.github/workflows/validate.yml`、`pr-check.yml` 或对应工作流。

要求：

- 未创建任务不能提交；
- 变更超出白名单时本地和 CI 均失败；
- 没有完整校验证据不能进入提交门禁；
- CI 从可信默认分支读取校验逻辑；
- PR 必须通过分支保护、必需检查和 Code Owner 审批。

测试：

- 越权修改业务文件；
- 修改禁止目录；
- 缺少任务记录；
- 缺少完整校验；
- Hook 与 CI 结果不一致；
- 尝试绕过本地 Hook 时服务端仍拒绝合并。

### 阶段 9：全链路回归

选择一条完整 CRM 需求，覆盖需求、记忆卡片、ODS、DWD、DWS、ADS、Mapping、DDL、存储过程和静态测试矩阵。

验收必须证明：

1. 正常链路可以按状态机推进；
2. 每个关键错误都能阻塞；
3. 阻塞记录可解释并可恢复；
4. 规则、血缘、Mapping 和实现可以相互追溯；
5. 变更越权时 Hook 和 CI 都能拒绝；
6. 没有用户授权时不能提交或推送。

## 4. 风险与回滚

| 风险 | 控制措施 | 回滚方式 |
|------|----------|----------|
| 现有工作流被阻断 | 先以报告模式运行，再切换失败模式 | 恢复对应工作流和 Hook 的前一版本 |
| 旧任务没有 Harness 记录 | 对旧任务提供只读导入或明确标记为遗留任务 | 不自动补齐业务证据 |
| SQL 解析器覆盖不足 | 未解析语句默认阻塞，不降级为通过 | 保留人工审查路径 |
| 校验耗时过长 | 本地快速校验、CI 完整校验分层 | 保留完整校验为合并门禁 |
| 规则提取误判 | 规则必须绑定原文位置并人工确认 | 删除未确认规则，不生成实现 |

## 5. 计划验收

- 所有计划文件均有明确输入、输出、实现范围和测试；
- 每个状态转换都有正向和反向测试；
- 业务规则、数据血缘和实现逻辑均可追溯；
- 未确认项默认阻塞；
- Harness 本身通过现有工作区校验和 CI；
- 完成一次全链路 CRM 回归。
