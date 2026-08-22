# CHG-20260822-002 治理事实审计清单

## 任务信息

| 项目 | 内容 |
|------|------|
| 任务编号 | `project-rule-governance-audit-20260822` |
| Change ID | `CHG-20260822-002` |
| 流程类型 | `read_only` |
| 来源 | `项目规则治理.txt` 最新版 |
| 目标 | 建立 Git、编码、目录、重复资产和 Source of Truth 的可复核事实基线 |
| 当前状态 | 进行中 |

## 验收标准

| 编号 | 验收标准 | 状态 | 证据 |
|------|----------|------|------|
| A-01 | Git HEAD、分支、修改/删除/未跟踪数量可复核 | 已完成 | Git 命令输出 |
| A-02 | 文件名与内容编码问题按实际文件确认 | 已完成 | 路径与严格 UTF-8 分类扫描 |
| A-03 | 同名/同哈希/引用重叠资产列入候选清单 | 已完成 | SHA-256、Git 跟踪和引用扫描 |
| A-04 | `docs/core`、`docs/governance`、`governance` 职责与引用关系明确 | 已完成 | 目录统计和引用扫描 |
| A-05 | Source of Truth 矩阵区分 confirmed 与 unresolved | 已完成 | `reports/governance-facts-audit.md` |
| A-06 | 后续变更任务的最小白名单与验收命令明确 | 已完成 | `reports/governance-facts-audit.md` |

## 执行记录

| 编号 | 项目 | 状态 | 实际命令/文件 | 结果 |
|------|------|------|---------------|------|
| 01 | 创建审计任务 | 已完成 | `python -m scripts.harness create` | 创建于 `master`，HEAD `fb7f402` |
| 02 | 建立审计白名单 | 已完成 | `change_manifest.yaml` | 仅允许写入本任务目录 |
| 03 | Git 基线 | 已完成 | `git branch/rev-parse/status` | 13 modified、5 untracked；无 deleted |
| 04 | 文件路径与编码 | 已完成 | 严格 UTF-8 分类扫描、Git 路径审计 | 无乱码 Git 路径；文本编码存在 GBK/二进制分类需求 |
| 05 | 重复与引用关系 | 已完成 | SHA-256、Git 跟踪、引用扫描 | `crmdm表结构.xlsx` 字节重复，处置 unresolved |
| 06 | 目录职责与权威来源 | 已完成 | 目录统计、Markdown 引用扫描 | 根 `governance/` 为 L3 专项规则，非重复 L1 入口 |
| 07 | 审计报告与后续任务设计 | 已完成 | `reports/governance-facts-audit.md` | 已提出 CHG-003、CHG-004 和独立清理任务 |

## 明确禁止

- 不恢复或覆盖 Git 工作区。
- 不删除 `.pyc`、`__pycache__`、`.bak`、Excel 或历史文件。
- 不移动、重命名或合并目录。
- 不修改业务规则、Mapping、DDL、SQL、存储过程、ETL、测试、CI 或 Hook。
