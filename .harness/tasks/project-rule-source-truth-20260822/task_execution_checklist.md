# CHG-20260822-003 Source of Truth 与目录规则清单

| 项目 | 内容 |
|------|------|
| 任务编号 | `project-rule-source-truth-20260822` |
| Change ID | `CHG-20260822-003` |
| 流程类型 | `governance` |
| 需求来源 | `项目规则治理.txt` 与 `CHG-20260822-002` 审计报告 |
| 当前状态 | 进行中 |

## 验收标准

| 编号 | 验收标准 | 状态 | 证据 |
|------|----------|------|------|
| A-01 | Source of Truth 矩阵与实际目录一致 | 已完成 | `docs/governance/source_of_truth.md` |
| A-02 | L0/L1/L3 治理目录职责无冲突 | 已完成 | `docs/governance/directory_structure.md` 与引用扫描 |
| A-03 | 未跟踪 Excel、副本与备份的处置保留 unresolved | 已完成 | Source of Truth 规则第3、4节 |
| A-04 | Change Register 可登记权威来源、编码与文件处置 | 已完成 | `templates/change_register_template.yaml` |
| A-05 | 文档与既有路由/门禁无冲突 | 已完成 | 36 项定向测试、`git diff --check` |

## 实施记录

| 编号 | 阶段 | 状态 | 结果 |
|------|------|------|------|
| 01 | 审计报告读取与范围确认 | 已完成 | 仅更新规则和模板，不处理资产 |
| 02 | Source of Truth 专项规则 | 进行中 |  |
| 03 | 目录职责专项规则 | 待处理 |  |
| 04 | L0/变更模板同步 | 待处理 |  |
| 05 | 审查与验证 | 待处理 |  |

## 禁止事项

- 不修改 `requirements/`、`data_assets/`、根 `governance/`、`validation/`、`scripts/`、`.github/`、`hooks/` 或 `.git/`。
- 不删除、迁移、归档、重命名或转码任何现有文件。
