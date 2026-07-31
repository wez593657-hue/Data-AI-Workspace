# 睡眠户唤醒 v2.10.0 变更记录

## 结论

本次修复使月初处理同时覆盖上月末清单复核、月初当天新增睡眠户和月初当天产品唤醒；月内清单及接触/唤醒状态按已确认规则累计。未新增睡眠开始时间、唤醒时间、清单变更日志或存量/新增独立统计字段。

## 规则与实现

| 项目 | 实现 |
|---|---|
| 睡眠条件 | 当日资产快照 `AUM_BAL < 100` 且近365天不存在 `DWD_TX_ASET.JIOYCFFS='0'` 的主动动账交易 |
| 月首继承 | 从上月末明细读取，并按当前日AUM/近365天主动动账条件复核；不满足者进入新月清单前被剔除 |
| 月首新增 | 月首继续执行候选筛选和合并，避免遗漏月初当天首次满足条件的客户 |
| 月首唤醒 | 唤醒基线取上月末资产快照，比较定期、理财、保险余额从0到大于0的增量 |
| 月内清单 | 继承昨日清单并只增不减，被唤醒客户保留至月底 |
| 状态 | 月首 `CNTCT_STATE`、`WAKE_STATE` 重置为0，月内分别按有效接触、产品新增累计 |
| 粒度 | 法人行号+客户号+归属机构；资产、管户、明细关联均增加机构约束 |
| 缺失快照 | 当日资产快照不存在时不更新余额、接触和唤醒状态，避免历史状态被置空 |
| 统计 | 明细过程完成月首合并后，统计过程继续仅输出总数、接触数/率、唤醒数/率 |

## 涉及文件

- `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_DTL.sql`
- `data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_SLEEP_WAKE_STATIS.sql`
- `data_assets/ddl/ads/ads_cust_sleep_wake_dtl.sql`
- `data_assets/ddl/ads/ads_cust_sleep_wake_statis.sql`
- `data_assets/ddl/tmp/tmp_ads_sleep_wake_base.ddl`
- `data_assets/ddl/tmp/tmp_ads_sleep_candidate.ddl`
- `data_assets/ddl/dwd/dwd_tx_aset.sql`
- `data_assets/mapping/ods_to_dwd/ods到dwd映射.md`
- `requirements/睡眠户唤醒规则记忆卡片.md`

## 测试与验证

新增 `scripts/harness/tests/test_sleep_wake_logic.py`，覆盖月首继承复核、月首新增、月首唤醒、月内状态累计、法人/机构粒度、快照缺失保护、三类产品唤醒、统计字段契约和日期清理索引友好性。

数据库连接不可用时，SQL单元测试以静态规则测试替代；部署前仍需在Kingbase Oracle兼容模式执行过程编译和样例数据回放。

## 发布前风险

当前工作簿 `data_assets/mapping/ods_to_dwd/DWD明细层数据模型_CRM_ V1.0.xlsx` 未检索到 `JIOYCFFS` 行，但 ODS 来源表已有该字段且本次已确认 DWD 需提供该字段。此次代码按已确认规则补入 DWD DDL 和 Markdown 映射；发布前应先更新 Excel 源文件并重新生成映射，避免后续 Excel 同步覆盖 `JIOYCFFS` 声明。
