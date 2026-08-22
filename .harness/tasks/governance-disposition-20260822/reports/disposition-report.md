# CHG-20260822-005 文件处置报告（更正）

## 处置结果

本任务最终只删除了 3 个未跟踪、Manifest 逐项授权的本地副本/备份：

| 路径 | 结果 | 正式来源/依据 |
|---|---|---|
| `requirements/crmdm表结构.xlsx` | 已删除 | `data_assets/mapping/crmdm表结构.xlsx` 保留；删除前 SHA-256=`C3628EA67C2E056A1B8746169EFC3914B9A20286BFECFEA46D35E8BE7700E4D4` |
| `.github/workflows/ai-connectivity-check.yml.bak` | 已删除 | `.github/workflows/ai-connectivity-check.yml` 保留 |
| `data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_plan_007.sql.bak` | 已删除 | 同名正式 `.sql` 保留 |

## 更正：需求备份未处置

初次处置时，两份带 `.bak_*` 后缀的 Excel 文件被错误判定为未跟踪并短暂删除。随后通过 `git ls-files --stage` 确认它们是 Git 已跟踪文件，已使用 `git restore --` 原样恢复：

| 路径 | Git blob | 最终状态 |
|---|---|---|
| `requirements/指标业务理解与技术口径.xlsx.bak_20260819_0070_customer` | `ade879029cc2b6cb1a4e05be4dc2101964c763dc` | 保留，`unresolved` |
| `requirements/指标业务理解与技术口径.xlsx.bak_20260819_pre_recent` | `0e0cde52eb47d56b3de4e633743d300e9751718b` | 保留，`unresolved` |

这两份需求历史备份需要独立 Change ID、逐文件引用影响分析和明确删除授权，不能由本任务继续处置。

## 继续保留的候选重复

- `.harness/validation-report-final.txt`、`local`、`release`、`review`：任务证据，不删除。
- `scripts/_bak_ads.xlsx` 与 `backup/mapping_20260808/ADS应用层数据模型_CRM_ V1.0.xlsx`：职责未确认，保留。
- `scripts/oracle_validation/acct_insur/sqlnet.ora` 与 `sqlnet_password_auth.ora`：可能影响验证配置，保留。

## 验收

- 3 个实际删除目标：`Test-Path=False`。
- 3 个正式来源：`Test-Path=True`。
- 2 个已跟踪需求备份：已恢复且 Git stage 存在。
- `python -m scripts.harness governance-check --report .harness/tasks/governance-disposition-20260822/reports/governance-check-final.json`：`result=passed`。
- `git diff --check`：通过；未提交、未推送。
