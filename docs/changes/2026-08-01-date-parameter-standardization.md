# 日期参数标准化 v2.11.0 变更记录

## 结论

按已确认的三个决策点，完成 `DWS_CUST_ASSE_LIAB` 与 `dwd_acct_*_his` 相关存储过程的日期参数标准化：所有基于跑批日的相对业务日期统一由 `sys_fun_deal_date` 具名参数生成；新增参数22（365天动账窗口开始日）、23（180天新客窗口开始日）；`dws_cust_lvl_info` 日期列统一为 `DATA_DATE`；日期参数校验器同步消除 `V_DATA_DATE` 别名推导盲区。

## 决策点（2026-08-01 已确认）

| 决策点 | 结论 |
|---|---|
| 1. 历史清理边界口径 | 统一为参数19（`add_months(V_SYSDAT, -36)`，36个月前当日），替代原"三年前年初"（`TRUNC(年)-36月`）口径 |
| 2. 固定窗口登记 | 规则文档新增 参数22=365天动账窗口开始日、参数23=180天新客窗口开始日 |
| 3. 等级表日期列 | 以数据库实际列 `DATA_DATE` 为准：修正独立 DDL `dws_cust_lvl_info.sql`，全部过程引用统一为 `DATA_DATE` |

## 规则与实现

| 文件 | 变更 |
|---|---|
| `governance/stored_procedure_date_parameter_rules.md` | 日期参数映射表新增编号22、23；新增"新增与使用日期参数流程（强制）"章节（先查函数实现、新增必同步函数、禁止只登记不实现） |
| `docs/16_Execution_Rules.md` | 新增 16.3.6 日期参数使用规范（先查函数、再使用、新增必同步，作为后续开发统一标准） |
| `data_assets/function/sys_fun_deal_date.sql` | 实现参数22（365天动账窗口开始日 = V_DATE-365天）、23（180天新客窗口开始日 = V_DATE-180天） |
| `data_assets/ddl/dws/dws_cust_lvl_info.sql` | 列 `DATA_DTTE` 改为 `DATA_DATE`（与 SYDDL 及全部过程引用一致） |
| `data_assets/stored_procedure/dwd_to_dws/PRC_DWS_CUST_ASSE_LIAB_CUMU.sql` | 上一日→参数1；当月初→参数9；当季初→参数11；当年初→参数13；月/季/年已过天数改用具名参数转换后的日期运算 |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_NEW_CUST_DTL.sql` | 当月初→参数9；历史清理→参数19；180天新客窗口→参数23；等级表列改 `DATA_DATE` |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_NEW_CUST_STATIS.sql` | 历史清理边界改具名参数19（`V_HISTORY_CUTOFF_DATE`） |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_LOST_DTL.sql` | 当月初→参数9；历史清理→参数19；等级表列 `DATA_DT`→`DATA_DATE`（3处） |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_LOST_STATIS.sql` | 历史清理内联推导改具名参数19 |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_DTL.sql` | 365天动账窗口→参数22；月接触窗口→参数9；历史清理→参数19；`V_PREV_MONTH_END` 语义重载改为具名变量 `V_WAKE_BASELINE_DATE` |
| `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_STATIS.sql` | 历史清理内联推导改具名参数19 |
| `data_assets/stored_procedure/ods_to_dwd/PRC_DWD_CRM_SYS_XTHLCS.sql` | 移除未使用的预留区间参数 P_INTERVAL_START/END_DATE（原直接推导 V_SYSDAT-30）；文件编码由 GBK 转为 UTF-8（无 BOM） |
| `data_assets/stored_procedure/ods_to_dwd/PRC_DWD_CUST_INDIV_CRDT.sql` | 移除未使用的预留区间参数 P_INTERVAL_START/END_DATE（原直接推导 V_SYSDAT-30） |
| `data_assets/stored_procedure/ods_to_dwd/PRC_DWD_CUST_SIGN_CTRAKT.sql` | 移除未使用的预留区间参数 P_INTERVAL_START/END_DATE（原直接推导 V_SYSDAT-30） |
| `scripts/validate_procedure_date_parameters.py` | 直接推导拦截扩展至 `V_DATA_DATE` 别名变体；新增"使用的每个参数编号必须已在 sys_fun_deal_date.sql 中实现"硬校验 |
| `scripts/harness/tests/test_procedure_date_parameters.py` | 新增 V_DATA_DATE 直接推导拦截、记录自身日期运算放行、未实现参数拦截与函数实现一致性测试 |
| `requirements/睡眠户唤醒、新客经营、流失挽回、潜力提升、指标数据统计_记忆卡片.md` | 补充各过程实际使用的参数编号、变量名与业务含义 |

## 测试与验证

- `scripts/validate_procedure_date_parameters.py` 对全部涉及过程（CUMU、NEW_CUST_DTL/STATIS、LOST_DTL/STATIS、SLEEP_WAKE_DTL/STATIS、POTN_UPGRADE_*、DEADLINE_RMND_*）静态校验通过。
- `scripts/harness/tests/test_procedure_date_parameters.py` 8 个用例全部通过（含新增 4 个）。
- 数据库连接不可用时以静态规则校验替代；部署前仍需在 Kingbase Oracle 兼容模式执行过程编译和样例数据回放。

## 发布前风险

1. 历史清理边界由"三年前年初"变为"36个月前当日"，删除范围收窄（保留数据更多）；重跑首日可能保留少量此前会被删除的历史行，属预期行为。
2. `dws_cust_lvl_info` 独立 DDL 与 SYDDL 已统一为 `data_date`；若数据库实际对象与 SYDDL 不一致，需先核对再发布。
3. 本次为存量过程改造，未涉及表结构变更以外的 DDL；正式发布前需在测试库完成过程编译验证。

## 补充记录：函数实现同步（同日追加）

按"新增日期参数必须同步函数实现"规范自查时发现：参数22/23 已在规则表登记并被存储过程使用，但 `sys_fun_deal_date.sql` 的 `CASE p_pd` 尚未实现（会返回 NULL）。本次已同步补齐函数实现，并在校验器中增加硬校验，防止"只登记不实现"再次发生。
