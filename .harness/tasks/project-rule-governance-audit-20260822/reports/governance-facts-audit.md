# CHG-20260822-002 治理事实审计报告

> 审计性质：只读事实审计
> 审计基线：`master` / `fb7f402dceb15ff849d9b73c4d76eac296b16cc8`
> 结论标记：`confirmed` 表示有命令、路径或哈希证据；`unresolved` 表示需要业务或用户决策。

## 1. 审计范围与限制

本次只读取 Git、目录、文件、引用和内容编码；仅写入本审计任务目录。未执行 `git restore`、删除、迁移、重命名、归档或编码转换。

## 2. Git 工作区事实

| 项目 | 结论 | 证据 |
|------|------|------|
| 当前分支 | confirmed：`master` | `git branch --show-current` |
| HEAD | confirmed：`fb7f402dceb15ff849d9b73c4d76eac296b16cc8` | `git rev-parse HEAD` |
| 已跟踪文件 | confirmed：1032 | `git ls-files` |
| 当前删除状态 | confirmed：0 | `git status --short` |
| 当前修改状态 | confirmed：13 | `git status --short` |
| 当前未跟踪状态 | confirmed：6（含本审计任务） | `git status --short` |
| 当前重命名状态 | confirmed：0 | `git status --short` |

方案中“465 删除、321 修改、43 未跟踪”与当前工作区不一致。近期删除记录可在已提交历史中追溯，例如 `c56869b`、`7dfcabe`、`2fbdd6`；不能将这些已提交历史删除认定为当前工作区丢失。

## 3. 文件名与内容编码

| 项目 | 结论 | 证据 |
|------|------|------|
| Git 已跟踪路径乱码 | confirmed：0 | `git ls-files` 路径审计 |
| 当前 `docs/*乱码*` | confirmed：0 | 路径 Glob |
| 当前 `requirements/*乱码*` | confirmed：0 | 路径 Glob |
| `.pyc` / `__pycache__` 被 Git 跟踪 | confirmed：0 | `git ls-files` |
| `.pyc` / `__pycache__` 规则 | confirmed：已由 `.gitignore` 忽略 | `.gitignore:32-35` |

严格 UTF-8 解码的“失败”不能直接等同编码缺陷：其中包含 XLSX、DOCX、PYC 等二进制格式，也包含现有 GBK SQL、GBK 治理方案和 GBK 参考逻辑。文本候选扫描中识别 21 个非 UTF-8 文件，其中 11 个为指标计划 SQL，1 个为 `PRC_DWD_ACCT_INSUR.sql`，4 个为 DDL 或参考 SQL，另有方案、备份和临时审计文本。

结论：`FILE-002` 不应规定“所有仓库文件均 UTF-8”。后续检查须先按文件类型区分二进制格式、已允许的 GBK SQL 和要求 UTF-8 的文本文件；文件名编码须与内容编码分开检测。

## 4. 候选重复与备份资产

### 4.1 `crmdm表结构.xlsx`

| 路径 | Git 跟踪 | SHA-256 | 结论 |
|------|----------|---------|------|
| `requirements/crmdm表结构.xlsx` | 否（被 Excel 忽略规则覆盖） | `C3628EA67C2E056A1B8746169EFC3914B9A20286BFECFEA46D35E8BE7700E4D4` | 候选重复 |
| `data_assets/mapping/crmdm表结构.xlsx` | 否（被 Excel 忽略规则覆盖） | 同上 | 候选正式 Mapping |

两文件字节完全相同，但仓库文档未发现对该精确文件名的引用。正式 Mapping 目录规则在 `docs/08_Mapping.md:100-102` 中已明确 `data_assets/mapping/`。是否保留 `requirements/` 副本、迁移为需求附件，或归档，均为 `unresolved`，必须由用户确认；本审计不删除或移动文件。

### 4.2 备份文件

| 路径 | Git 跟踪 | 忽略 | 结论 |
|------|----------|------|------|
| `.github/workflows/ai-connectivity-check.yml.bak` | 否 | 是 | 候选本地备份 |
| `data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_plan_007.sql.bak` | 否 | 是 | 候选本地备份 |
| `requirements/指标业务理解与技术口径.xlsx.bak_20260819_0070_customer` | 否 | 否 | 候选人工备份 |
| `requirements/指标业务理解与技术口径.xlsx.bak_20260819_pre_recent` | 否 | 否 | 候选人工备份 |

备份不是自动删除对象。需要在后续清理任务中逐文件确认保留、归档或删除理由与引用影响。

## 5. 目录职责与引用关系

| 目录 | 审计事实 | 结论 |
|------|----------|------|
| `docs/core/` | 4 个 Markdown；包含 L0 不变量、输出合同、路由和治理总览 | L0 CORE |
| `docs/governance/` | 5 个 Markdown；RACI、变更管理、审批、生命周期和发布 | L1 治理流程 |
| `governance/` | 3 个 Markdown、7 个临时表 JSON | 存储过程日期参数、参考逻辑、TMP 审核专项规则 |
| `requirements/` | 33 Markdown、5 Excel、2 Word | 业务需求、规则记忆卡片、口径和附件 |
| `data_assets/mapping/` | 3 Markdown、4 Excel | 正式 Mapping 资产目录 |
| `data_assets/ddl/` | 192 SQL | DDL 资产目录 |
| `data_assets/stored_procedure/` | 32 SQL | 存储过程资产目录 |
| `validation/` | 规则、夹具、期望结果、参考实现 | 离线验证资产 |

根目录 `governance/` 被 `docs/core/invariants.md`、`docs/16_Execution_Rules.md`、存储过程 Skill 和工作流直接引用。它是专项技术规则目录，不是与 `docs/governance/` 重复的 L1 流程入口。现阶段禁止删除或合并该目录。

## 6. Source of Truth 矩阵

| 对象 | 当前权威位置 | 状态 | 依据 |
|------|--------------|------|------|
| 项目不变量、路由、输出合同 | `docs/core/` | confirmed | 目录与 L0 标识 |
| 变更、审批、发布、RACI、生命周期 | `docs/governance/` | confirmed | 治理文档 |
| 业务需求与规则记忆卡片 | `requirements/` | confirmed | `AGENTS.md`、现有目录 |
| 正式字段 Mapping | `data_assets/mapping/` | confirmed | `AGENTS.md`、`docs/08_Mapping.md` |
| DDL | `data_assets/ddl/` | confirmed | `AGENTS.md` |
| 存储过程 | `data_assets/stored_procedure/` | confirmed | 实际目录 |
| 离线验证规则与样例 | `validation/` | confirmed | 实际目录与离线开发指南 |
| Harness 状态、政策和证据 | `.harness/` | confirmed | 现有任务与政策 |
| 日期参数和 TMP 专项规则 | `governance/` | confirmed | L0 与 Skill 引用 |
| `requirements/` 中 Excel 的业务/Mapping属性 | unresolved | 同一目录包含需求口径 Excel 与一个 Mapping 同名副本；须逐文件分类 |
| `data_assets/sql/` 作为正式 SQL 来源 | unresolved / 不成立 | 当前未发现该目录；实际过程在 `data_assets/stored_procedure/` |

## 7. 后续受控任务设计

### CHG-20260822-003：Source of Truth 与目录规则

仅修改治理规则和模板，不移动资产。候选白名单：

- `docs/core/governance.md`
- `docs/governance/change_management.md`
- 新建 `docs/governance/source_of_truth.md`
- 新建 `docs/governance/directory_structure.md`
- `templates/change_register_template.yaml`
- 该任务自身 `.harness/tasks/<task-id>/`

验收：权威矩阵与实际目录一致；不要求不存在的 `data_assets/sql/`；根目录 `governance/` 明确为 L3 专项规则；所有 `requirements/` Excel 分类为需求口径、需求附件或 Mapping 副本，未确认项保留 `unresolved`。

### CHG-20260822-004：治理检查设计与实现

候选白名单：

- `validation/governance/`
- `scripts/harness/`
- `scripts/harness/tests/`
- `.harness/policies/`
- `.harness/config/`
- `docs/offline-validation.md`
- `docs/governance/`
- 该任务自身 `.harness/tasks/<task-id>/`

检查原则：编码检查按类型/允许编码分类；重复检查仅报告；链接检查限仓库 Markdown；权威来源检查按路径与任务类型；冲突检查输出 `unresolved`；生命周期检查只覆盖明确范围的现役治理文件。

### CHG-YYYYMMDD-XXX：文件清理、恢复或归档

必须晚于前两项，并建立逐文件 Manifest。`restore_source`、`delete_authorization`、`rename_from`、`rename_to`、`reference_impact` 与用户批准均为必填。禁止批量 `git restore`、批量删除或自动目录合并。

## 8. 审计结论

当前治理风险集中在“未跟踪 Excel 副本和备份的分类/处置未决”以及“编码治理规则尚未按实际 GBK/二进制资产分类”。方案中关于当前大量 Git 删除、乱码文件名、根目录治理目录重复、`.pyc` 被 Git 管理的判断不成立或证据不足。

后续应先实施 `CHG-20260822-003`，再设计自动检查；恢复和清理必须独立确认。
