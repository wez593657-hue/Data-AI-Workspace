# AI 数据仓库 Harness 设计任务执行清单

## 1. 任务信息

| 项目 | 内容 |
|------|------|
| 任务名称 | AI 数据仓库开发 Harness 设计 |
| 开始时间 | 2026-07-21 |
| 当前分支 | feature/ai-repair-loop |
| 目标分支 | feature/ai-repair-loop |
| 当前状态 | 阶段 5 一致性门禁已通过，后续业务Mapping按需求逐表补齐 |

## 2. 验收标准

| 编号 | 验收标准 | 完成条件 | 状态 | 验证证据 |
|------|----------|----------|------|----------|
| A-01 | 覆盖需求到发布的完整数据仓库链路 | 设计文档列出各阶段及门禁 | 已完成 | 设计文档第1、5、12节 |
| A-02 | AI 不能绕过状态、权限和验证门禁 | 明确状态机、能力令牌和服务端裁决 | 已完成 | 设计文档第3、5、10节 |
| A-03 | 需求规则与实现逻辑可反向核对 | 定义规则模型、覆盖率和反向逻辑校验 | 已完成 | 设计文档第6、8节 |
| A-04 | 阻塞可解释并可恢复 | 定义阻塞字段和恢复条件 | 已完成 | 设计文档第11节 |
| A-05 | 设计文档自检通过 | 无占位、无矛盾、范围完整 | 已完成 | 结构、内容、占位符和 Markdown 检查通过 |
| A-06 | 用户审阅设计文档 | 用户确认后再制定实施计划 | 已完成 | 用户已确认 |

## 3. 执行记录

| 阶段 | 状态 | 实际文件/命令 | 结果与证据 |
|------|------|---------------|------------|
| 读取项目规则和现有 Harness 能力 | 已完成 | `docs/16_Execution_Rules.md`、`docs/11_Project_SOP.md`、`scripts/`、`hooks/`、`.github/workflows/` | 已确认现有校验、Hooks 和 CI 能力 |
| 用户确认覆盖全链路 | 已完成 | 对话记录 | 已确认覆盖当前项目全部数据仓库开发链路 |
| 编写设计文档 | 已完成 | `docs/superpowers/specs/2026-07-21-ai-data-warehouse-harness-design.md` | 已覆盖全链路、状态机、权限、证据、反向校验、测试和 CI |
| 编写本任务清单 | 已完成 | 本文件 | 清单已建立并同步维护 |
| 设计文档自检 | 已完成 | Markdown 结构检查、内容检查、占位符检查、`git diff --check` | 全部通过 |
| 用户审阅 | 已完成 | 对话确认 | 用户已批准设计，进入实施计划阶段 |
| 编写实施计划 | 已完成 | `docs/superpowers/plans/2026-07-21-ai-data-warehouse-harness-implementation-plan.md` | 已拆分为状态机、证据、需求、血缘、跨层校验、逻辑、测试、Hooks/CI 和回归阶段 |

## 5. 阶段 5 执行记录：DDL、数据字典和 Mapping 门禁

| 项目 | 结果 | 证据 |
|------|------|------|
| 设计确认 | 已完成 | `docs/superpowers/specs/2026-07-22-schema-consistency-gate-design.md` |
| 字段级解析器 | 已完成 | `scripts/harness/schema_consistency.py` |
| 明确 Mapping 血缘图 | 已完成 | `scripts/harness/artifact_graph.py`、任务报告 `artifact-graph.yaml` |
| CLI 和门禁 | 已完成 | `check-schema-consistency`、`check-schema-gate` |
| 单元测试 | 已完成 | 11/11 通过 |
| 工作区完整校验 | 已完成 | `python scripts/workspace_validation.py full` 全部通过 |
| 用户补齐规则确认 | 已完成 | E-0002、当前规则：临时表免数据字典；DDL类型长度为准；仅SYS/SYS.DATE/SYS."DATE"规范为DATE，其它日期以Excel为准；三层Mapping来源可空 |
| Excel→Mapping Markdown 同步 | 已完成 | ODS→DWD 247 条、DWD→DWS 114 条、DWS→ADS 307 条 |
| 全量基线复核 | 已通过 | 163 张非临时DDL、189份数据字典、668条Mapping；结构差异0、阻塞性未解析0；667条来源/规则空缺按当前规则记录为可选未补齐 |

### 阶段 5 恢复说明

- 阻塞任务：`.harness/tasks/schema-consistency-gate-v1/`
- 处理结果：补齐 `DWD_CUST_INDV_INFO.OPEN_DATE`、`OPEN_ORG`，并按 Excel 重建 `DWD_CUST_INDIV_RISK_INVST` 的 8 个字段；DDL、数据字典和 ODS→DWD Markdown 已同步。
- 门禁结果：结构差异 0；阻塞性未解析 Mapping 0；三层 Mapping 共有 667 条来源或规则暂空，仅作为可选未补齐记录。
- 后续规则：开始具体需求开发后，按需求文档或存储过程逐表补齐 DWD→DWS、DWS→ADS 的 Excel 和 Markdown；不确定业务逻辑仍必须阻塞并说明原因。

## 6. 当前边界

本阶段已允许按用户明确规则修改指定 Harness 和数据资产；当前仍不执行 commit、push 或 PR。对无法由需求文档或存储过程证明的业务映射不自动补齐。

## 7. 历史阻塞记录

阶段 5 初始阻塞、恢复证据和当前结论已记录在 `.harness/tasks/schema-consistency-gate-v1/blocking.yaml`。

## 8. 任务结束状态

```text
任务状态：阶段 5 一致性门禁通过
任务结束说明：两个DWD模型已按用户确认规则修正；空Mapping不再阻塞，后续业务Mapping按需求文档和存储过程逐表补齐。
```

## 9. 阶段 6 执行记录：到期承接明细逻辑门禁

| 项目 | 结果 | 证据 |
|------|------|------|
| 测试任务 | 已创建并阻塞 | `.harness/tasks/phase6-deadline-detail-v1/` |
| 测试对象 | 到期承接明细存储过程 | `data_assets/stored_procedure/dws_to_ads/PRC_ads_cust_deadline_rmnd_dtl.sql` |
| 需求版本 | 已识别 | `requirements/到期承接规则记忆卡片.md`，v2.1.0 |
| 规则覆盖 | 5项通过、2项阻塞 | REQ-CUST-001、003、004、005、006通过；REQ-CUST-007、008待实现 |
| 反向逻辑 | 阻塞 | 存储过程目标列使用 `CUST_HRAKY`，ADS目标DDL字段为 `CUST_LVL` |
| Harness代码 | 已完成最小实现 | `rule_coverage_checker.py`、`reverse_logic_checker.py`、`logic_gate.py` |
| 单元测试 | 已完成 | 14/14通过 |

### 阶段 6 阻塞与恢复记录

- 初始阻塞原因：ADS `INSERT` 目标列使用 `CUST_HRAKY`，而 ADS DDL 和数据字典字段为 `CUST_LVL`；REQ-CUST-007 和 REQ-CUST-008 尚保留待实现标记。
- 用户确认：到期承接的 `CUST_HRAKY` 修正为 `CUST_LVL`；REQ-CUST-007 已实现保险剔除；REQ-CUST-008 已实现通知存款过滤。
- 已执行修正：存储过程目标列改为 `CUST_LVL`；`TAKE_AMT_30D` 仅统计 `DEPO/FIN`；定期存款来源通过 `PRDKT_CATE_BIG <> '04'` 排除通知存款；需求记忆卡片和需求-代码映射追踪表同步更新。
- 当前结论：阶段 6 逻辑门禁报告为 `passed`，7 条规则全部通过，目标字段检查通过且阻塞项为 0。详见 `.harness/tasks/phase6-deadline-detail-v1/reports/logic-gate.yaml` 和证据 `E-0004`。
