# CHG-20260822-005 文件处置清单

| 项目 | 内容 |
|------|------|
| 任务编号 | `governance-disposition-20260822` |
| Change ID | `CHG-20260822-005` |
| 流程类型 | `governance` |
| 当前状态 | 进行中 |

## 逐文件处置

| 文件 | 状态 | 依据 |
|---|---|---|
| `requirements/crmdm表结构.xlsx` | 已删除 | 与 `data_assets/mapping/crmdm表结构.xlsx` SHA-256 相同，未跟踪，无精确引用 |
| `requirements/指标业务理解与技术口径.xlsx.bak_20260819_0070_customer` | 已恢复并保留 | Git已跟踪（blob `ade8790`）；先前误判后已原样恢复，处置为 `unresolved` |
| `requirements/指标业务理解与技术口径.xlsx.bak_20260819_pre_recent` | 已恢复并保留 | Git已跟踪（blob `0e0cde5`）；先前误判后已原样恢复，处置为 `unresolved` |
| `.github/workflows/ai-connectivity-check.yml.bak` | 已删除 | 未跟踪、已忽略、明确 `.bak`，正式工作流保留 |
| `data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_plan_007.sql.bak` | 已删除 | 未跟踪、已忽略、明确 `.bak`，正式 SQL 保留 |

## 明确不处置

- `scripts/_bak_ads.xlsx` 与 `backup/mapping_20260808/ADS应用层数据模型_CRM_ V1.0.xlsx`：候选重复但职责/引用未完成确认。
- `.harness/validation-report-*.txt`：任务证据候选重复，不删除。
- `scripts/oracle_validation/acct_insur/sqlnet*.ora`：配置文件候选重复，不删除。

## 验收标准

1. 已完成：3 个未跟踪清单目标不存在；2 个已跟踪需求备份已恢复并保留。
2. 已完成：3 个正式来源均存在。
3. 已完成：治理检查通过；其他重复组和两份已跟踪备份均只报告。
4. 已完成：未执行 commit 或 push；更正报告见 `reports/disposition-report.md`。
