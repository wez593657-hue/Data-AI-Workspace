---
id: "084364d8-3856-4ad6-9a9b-8fc92683c839"
title: "产品推荐方案分析报告复核与开发阻塞点补充"
description: "复核客户确认版产品推荐方案两维度分析报告，记录已核验结论、ODS层翻案证据及遗漏开发阻塞点，供后续需求确认与开发门禁使用。"
status: "active"
created_at: "2026-08-31T08:26:34.693Z"
updated_at: "2026-08-31T08:26:34.693Z"
content_hash: "d43aa2e1da0353ce7316fc2661ac45334aa7f50bebf2a4574023cd8e5f6cf10c"
source_paths:
  - "requirements/2026-07-06-客户确认版-产品推荐方案(2).docx"
  - "requirements/产品推荐方案-两维度分析报告.docx"
  - "requirements/产品推荐方案.md"
  - "requirements/产品推荐规则记忆卡片.md"
  - "data_assets/stored_procedure/dws_to_ads/PRC_ADS_CUST_PRDKT_RCMD.sql"
  - "data_assets/ddl/ads/ads_cust_prdkt_rcmd.sql"
  - "data_assets/ddl/dwd/dwd_prdkt_info.sql"
  - "data_assets/ddl/dwd/dwd_prdkt_info_detail.sql"
  - "data_assets/ddl/dwd/dwd_acct_depo.sql"
  - "data_assets/ddl/dwd/dwd_acct_fin.sql"
  - "data_assets/ddl/dwd/dwd_cust_indiv_risk_invst.sql"
  - "data_assets/ddl/dwd/dwd_cust_indv_info.sql"
  - "data_assets/ddl/dwd/dwd_acct_depo_his.sql"
  - "data_assets/ddl/dwd/dwd_acct_fin_his.sql"
  - "data_assets/ddl/ods/fms/fms_td_prod_info.sql"
  - "data_assets/mapping/ods_to_dwd/ods到dwd映射.md"
  - "data_assets/mapping/dws_to_ads/dws到ads映射.md"
session_ids:
  - "58cf1065-5ab6-4a0f-8e2e-611993da4a90"
memory_body_ids:
  []
---

# 产品推荐方案分析报告复核与开发阻塞点补充

## 结论

《产品推荐方案-两维度分析报告》总体合理，“不满足开发启动条件”的结论成立。报告对 DWD/ADS 层的主要事实核验基本准确，并有效识别了规则质量、范围扩展和数据落差问题。但其分析范围未覆盖 ODS 产品源、法人行和工程交付约束，因此不能直接作为完整开发门禁清单。

## 已核验的关键事实

- `DWD_PRDKT_INFO` 实为 12 个字段，不是报告所述 13 个；有 `PERSN_LEGAL_BK_CODE`、`BGN_DATE`、`END_DATE`，但无结构化期限字段。
- `ADS_CUST_PRDKT_RCMD` 为 9 列，现有 `PRC_ADS_CUST_PRDKT_RCMD` 的 INSERT 为 23 列，且现有 SP 引用了风险测评和客户信息表中不存在的字段。
- `DWD_ACCT_DEPO` 与 `DWD_ACCT_FIN` 的日期、金额、发行机构等字段语义确实不一致；两张历史表的表注释均为“【待补充】”。
- 风险测评真实字段为 `RISK_LVL`、`ESTIM_DATE`、`EXPR_DATE`、`INVEST_TYP`，现有 SP 的 `fin_risk_lvl`、`ins_risk_lvl` 等字段不存在。
- `DWD_CUST_INDV_INFO` 无 `DATA_DATE`，现有 SP 的按日期过滤无法成立。

## 对报告的修正

报告存在三类需要校正或降级的表述：

1. “DWD_PRDKT_INFO 全部 13 字段”应改为 12 字段。
2. “渠道可售无数据源”不应绝对化。`data_assets/ddl/ods/fms/fms_td_prod_info.sql` 已有 `sale_status`、`channel_show_flag` 等候选字段。
3. “理财产品期限只能由持仓日期近似”不完整。ODS 产品表有 `prod_days`、`operation_period_day`、`min_hold`、`max_lock_days`；同时有 `prod_risk_level`、`benchmarks`、`benchmarks_text`、`prod_rate` 等候选字段。需先确认这些字段是否可通过现有映射纳入推荐使用口径。

此外，Mapping 已有产品相关章节；存款产品大类注释中出现 `01活期(含智慧存)`、`02定期` 等值域线索，但产品主表章节的源字段/规则仍为空，且实际库内覆盖率仍需查询。

## 报告遗漏的阻塞点

### P0

- 多法人行维度未设计：产品、客户、账户、风险表均带法人行，字段长度还存在 4/7/30 等差异；目标表没有法人行键，现有 SP 也未按法人行过滤。需明确法人行映射、客户复合键和产品隔离规则。
- `DWD_PRDKT_INFO` Mapping 的源表、源字段和映射规则为空，产品主数据溯源不完整；存款产品是否进入产品主数据同步范围也未闭环。
- 目标表没有主键或唯一约束；方案只讨论列结构，没有明确 `(DATA_DATE, 法人行, CUST_ID, PRDKT_ID)` 等唯一性设计及并发/重跑保护。

### P1

- `PRDKT_ID`、`CUST_ID`、`PRDKT_CATE_BIG`、法人行字段在各层长度不一致，存在隐式转换、截断和关联丢失风险。
- ODS 产品表的期限、风险、销售状态、渠道展示、收益字段的值域、覆盖率和 Mapping 扩列路径未核查。
- 活期排除与“智慧存/智能存款”识别未闭环；需核实 `FIX_CURNT_FLG`、产品大类和业务名称是否一致。
- 金额和币种口径未定义：存款 `BAL`/`RMB_BAL`、理财 `CFM_AMT` 与产品币种之间如何统一。
- 风险测评需利用 `INVEST_TYP` 区分测评类型，并明确多笔、过期和法人行取数规则。
- 存储过程目标方言未明确；现有 SP 混用正则 `~`、`EXTRACT(EPOCH)`、`::` 等 PostgreSQL 写法和仓库既有 Kingbase/Oracle 兼容写法。

### P2 或待确认

- 权重、阈值、TopN 是否参数化，以及参数表是否纳入字典/Mapping。
- DATA_DATE 快照历史保留、清理、分区和目标表索引策略。
- 工作台/营销系统下游字段、刷新时点、话术长度和方案 A/B 契约。
- 客户×产品 CROSS JOIN、历史表近三年扫描和全量跑批性能验证。
- `PRC_ADS_CUST_PRDKT_RCMD` 的调度注册方式及上游快照就绪校验，仓库内暂未发现该过程的 plan 引用，具体调度方式为【待确认】。

## 建议前置核查

先查 `fms_td_prod_info` 到 DWD 的字段覆盖和产品覆盖率，再查法人行分布/键长度、存款产品关联覆盖率、历史表回灌范围和关键值域。完成这些查询并取得业务书面确认后，才能冻结目标表、Mapping、风险策略和期限/可售规则。
