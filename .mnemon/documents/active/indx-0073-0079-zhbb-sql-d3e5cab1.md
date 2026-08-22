---
id: "d3e5cab1-b93d-4a5a-92d5-7f60038b9427"
title: "INDX_0073~0079 综合报表 zhbb.sql 表替换与过程归属（考核期累计已落地）"
description: "zhbb 表替换对照 + 用户确认方案A落地：0073→new_cust_rule，0076/0077→event_count，0074/0075/0078/0079→prc_ads_stat_indx_trans_count（plan 6C3）；0074/0075 仅 4 类已确认交易。"
status: "active"
created_at: "2026-08-18T15:08:51.587Z"
updated_at: "2026-08-18T16:13:43.830Z"
content_hash: "3fd457fe622ffdfd4d421b86c06b79e37aa76cf2f671c07f9457883b1677cf6b"
source_paths:
  - "data_assets/reference_logic/zhbb.sql"
  - "data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_plan.sql"
  - "data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_event_count.sql"
  - "data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_new_cust_rule.sql"
  - "data_assets/stored_procedure/dws_to_ads/prc_ads_stat_indx_data/prc_ads_stat_indx_trans_count.sql"
  - "data_assets/ddl/ods/mbk/mbk_cust_info.sql"
  - "data_assets/ddl/ods/uepp/uepp_pay_mct_info.sql"
  - "data_assets/ddl/ods/uepp/uepp_pay_order_info.sql"
session_ids:
  - "101eb7aa-4c78-4b7c-ab5c-63e941fdd1af"
  - "a20d375d-90da-4967-9ec4-a00c53e4c403"
  - "d47e3b97-1c5f-48e6-8bf2-81f59cccff72"
  - "29041262-b4e8-4814-b6a8-f10a42b2b6d2"
memory_body_ids:
  []
---

# INDX_0073~0079 综合报表（zhbb.sql）表替换与过程归属

> 口径源：`data_assets/reference_logic/zhbb.sql`（GBK）。指标 **0073~0079 共 7 个**（口头「8 个」为口误）。离线实施，待数据库验证。
> 状态：**2026-08-18 用户确认方案 A + 过程名，代码已落地**。既有交接文档 `indx-0046-0083-42425226` §五「0073~0079 本期不处理」已过时。

## 过程归属（用户确认，勿再改回）

惯例：「一个过程管一类指标」。`build_scope` / `org_rollup_publish` 按活动/任务 INDX_ID 自动覆盖，无需改。

| 指标 | 模式 | 归属 | 理由 |
|---|---|---|---|
| 0073 手机银行客户新增 | 开户日 COUNT 客户 | `prc_ads_stat_indx_new_cust_rule` | 与 0082/0083 同为新客计数；`mbk_cust_info.cust_open_date` ∈ [term_begin_date, v_sysdat] |
| 0076/0077 一码付户数/新增商户 | 商户 COUNT | `prc_ads_stat_indx_event_count`（7.7~7.10） | 与 0068 同 uepp 商户 scope；0076 不映射客户；0077 用 `SIGN_DATE`；`mct_type IN ('personage','smallBusinesses') AND status<>'9'` |
| 0074/0075 手机银行交易金额/笔数 | 流水 SUM/COUNT | **新建** `prc_ads_stat_indx_trans_count` | 现无专职交易汇总过程 |
| 0078/0079 一码付交易金额/笔数 | 订单 SUM/COUNT | 同上 | 同源结构必须同过程；`uepp_pay_order_info` order_type='00' status='02' |

- plan 新增步骤 **6C3** 调用 `prc_ads_stat_indx_trans_count`。
- 与已删的 0068 `val_merchant`+6C3 不冲突：交易汇总是新一类，不是计数类再拆文件。
- 编码：new_cust_rule / event_count = GBK；trans_count / plan = UTF-8。

## 实施记录

1. `prc_ads_stat_indx_new_cust_rule.sql`（GBK）：A/B 加 INDX_0073；cust_flags 带 `mi.cust_open_date`。
2. `prc_ads_stat_indx_event_count.sql`（GBK）：7.7~7.10 加 0076/0077 A/B。
3. **新建** `prc_ads_stat_indx_trans_count.sql`（UTF-8）：A/B 覆盖 0074/0075/0078/0079。
4. `prc_ads_stat_indx_plan.sql`：步骤 6C3。
5. 离线校验：四文件括号平衡 diff=0。

0074/0075 **仅纳入已确认 4 类交易**（当日 `v_sysdat` 窗口）：`ibp_ib_list_plat`（ITEM_ID 100015/100012，CHANNEL_ID=3031）、`mbk_cust_log_fee`、`mbk_mkp_process_info`、`fms_t5_cust_trans_log`（trans_status='3'，channel_flag IN ('MB','AT')【待确认】）。

## zhbb 表 → 项目 DDL

| SDM 表 | 用途 | 项目表 | 结论 |
|---|---|---|---|
| T3031_CUSTINFO_C | 电子银行客户 | `mbk_cust_info` | ✅ 0073 |
| T3031_CUSTDETAILINFO_C | 营销机构 | `mbk_cust_detail_info` | ✅ |
| T3031_CUSTACCT_C | 卡号 | `mbk_cust_acct` | ✅ 0074 商圈关联链 |
| T4014_IBLISTPLAT_A | 商圈 100015 / 酷屏 100012 | `ibp_ib_list_plat` | ✅ 已纳入 0074/0075 |
| T3031_CUSTLOGFEE_C | 生活缴费 | `mbk_cust_log_fee` | ✅ 已纳入 |
| T3031_MKPPROCESSINFO_C | 扫码取款 | `mbk_mkp_process_info` | ✅ 已纳入 |
| T3031_CUSTLOGFINANCE_A | 理财日志 | `fms_t5_cust_trans_log` | ✅ 已纳入 |
| T3035_PAYMCTINFO_C | 商户主档 | `uepp_pay_mct_info` | ✅ 0076~0079 |
| T3035_PAYMCTSETTLEACCOUNT_C | 结算账户 | `uepp_pay_mct_settle_account` | ✅（0068/0069 映射；0076/0077 不映射客户） |
| T3035_PAYORDERINFO_C | 订单 | `uepp_pay_order_info` | ✅ 0078/0079 |
| T3035_TSYSORG_C | 商户所属机构 | `dwd_sys_org` | 机构可替；BR_NO 拼接 vs ORG_ID【待确认】 |
| T3031_CUSTLOGTRAN_A | 转账 | `DWD_TX_ASET` | ⚠️ 未纳入 |
| T3031_CUSTLOGBASEFINANCE_A | 存款/乐惠存 | `cds_tb_cust_trans_log` | ⚠️ 未纳入 |
| T3031_CUSTLOGOPER_A | 预约取款 | — | ❌ 缺表 |
| T3031_CUSTLOGLOAN_C | 贷款发放日志 | — | ❌ 缺表（`dwd_acct_loan` 是余额） |
| T3031_QRC2BQUERYTRANS_C | 移动支付二维码 | `uepp_pay_order_info` | ⚠️ 未纳入；与 0078/0079 是否重复【待确认】 |

## 【待确认】阻塞 0074/0075 补齐

1. 转账能否用 `DWD_TX_ASET`（TX_CHNL 能否筛手机银行、XIANZZBZ='1' 是否等同转账日志）。
2. 存款/乐惠存能否用 `cds_tb_cust_trans_log`。
3. 预约取款：无 ODS，放弃或补建。
4. 贷款日志：无流水表，放弃或另找 cbs/cms。
5. 移动支付能否用 `uepp_pay_order_info`；与 0078/0079 是否重复计数。
6. 0074/0075 窗口按当日还是考核期累计（现按 zhbb 当日）。
7. `fms_t5_cust_trans_log.channel_flag IN ('MB','AT')` 值域是否准确。
