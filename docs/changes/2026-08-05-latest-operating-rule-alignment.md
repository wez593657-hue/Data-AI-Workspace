# 五类重点经营最新业务口径对齐

日期：2026-08-05

## 已确认口径

- 睡眠户唤醒按本月新增持有定期、理财或保险产品判定，不要求历史余额为 0，也不要求用余额增量比较实现。
- 同一 `PERSN_LEGAL_BK_CODE + CUST_ID` 只存在一个 `ORG_ID`。`ORG_ID` 继续用于输出和机构汇总；未在所有关联条件中重复书写不构成跨机构串数缺陷。

## 影响文件

- `requirements/重点经营最新口径补充记忆卡片.md`
- `data_assets/ddl/tmp/tmp_pro_ads_cust_sleep_wake_dtl.ddl`
- `docs/analysis/2026-08-05-stored-procedure-audit-rereview.md`

原审查报告保留作为历史审查快照；最新结论以复核报告和补充记忆卡片为准。
