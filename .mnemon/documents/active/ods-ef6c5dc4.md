---
id: "ef6c5dc4-5b0f-43c2-923a-5105b62851b0"
title: "存储过程时间窗口与 ODS 数据保留期分析（离线审核）"
description: "31 个存储过程对上游源表（追至 ODS）的时间过滤窗口与最短数据保留期结论，含对父会话错误结论的勘误。"
status: "active"
created_at: "2026-08-18T12:39:30.132Z"
updated_at: "2026-08-18T12:39:30.132Z"
content_hash: "0550178c70f09065d860166e5ac09b47835762c33051615e0960695ef43200da"
source_paths:
  []
session_ids:
  - "d9cb4a40-9ee6-420d-a269-44dfcb8d0ce6"
memory_body_ids:
  []
---

# 存储过程时间窗口与 ODS 数据保留期分析（离线审核）

> 方式：离线源码审核（仓库无数据库，未做真实编译/执行）。证据来源：`data_assets/stored_procedure` 下 31 个过程（SYS_PRC_STEP_LOGS 与 .bak 除外）的 FROM/JOIN 全量抽取、`data_assets/function/sys_fun_deal_date.sql`（参数码实现）、`governance/stored_procedure_date_parameter_rules.md`、`data_assets/mapping/ods_to_dwd/ods到dwd映射.md`、`data_assets/mapping/dwd_to_dws/dwd到dws映射.md`。
> 状态：结论已修正并核验，待数据库验证与 3 项待确认。

## 一、勘误（相对父会话错误结论）

1. **sys_fun_deal_date 参数 19（3 年）不是源表保留期**。参数 19 只用于 ADS 目标表的自身历史清理（如 `DELETE FROM ADS_CUST_SLEEP_WAKE_STATIS WHERE DATA_DATE < V_HISTORY_CUTOFF_DATE`），不构成任何上游源表的保留要求。父会话把它计入"源表保留 365 天/3 年"是错的。
2. **FMS_TD_CUST_VOL_DETAIL / FMS_T5_CUST_VOL_LIST 无日期过滤**（PRC_DWD_ACCT_FIN 按键 JOIN 的当日份额快照），"需保留 365 天"无依据；份额表替换设计（含置0规则）尚未落地，见 §四待确认。
3. 父会话声称"已通过 `python -m scripts.harness risk-check standard`"为虚构证据，会话中未实际执行任何门禁命令；本分析仅为只读源码审查。
4. 真实的最大源表窗口不是 365 天上限：**YBT/FMS 流水类表是无日期过滤的全量聚合**（见 §二.2），保留期取决于保单/产品存续期，不可按固定天数裁剪。

## 二、结论（按读取方式分类）

### 1. 直接带日期窗口读 ODS（或经 DWD 传导）→ ODS 必须保留该窗口

| ODS 表 | 系统 | 消费过程 | 时间字段/窗口 | 建议保留 | 理由 |
|---|---|---|---|---|---|
| ECPP_E_TXN_COLLECTION、EPCC.E_TXN_PAYMENT | 网联收单 | PRC_ADS_CRM_R_CUST_LABLE_TX_INFO | SYS_DATE ∈ [T-1月, T]（参数20） | ≥1 个月 | 近1月第三方支付笔数/金额标签 |
| crmdm.mbk_cust_log_fee | MBK | PRC_ADS_CRM_R_CUST_LABLE_TX_INFO | tran_date ≥ 当年初（参数13） | ≥ 当前年（最长365天） | 当年校园缴费笔数、当月水电气缴费 |
| crmdm.uepp_pay_order_info | UEPP | PRC_ADS_CRM_R_CUST_LABLE_TX_INFO、prc_ads_stat_indx_retention_rate | pay_time ∈ [上月初, 上月末]；∈ [当年初, T]（参数13/15/2） | ≥ 当前年（最长365天） | 上月收单标签 + 商户留存率年窗口 |
| crmdm.uepp_pay_mct_info、uepp_pay_mct_settle_account | UEPP | retention_rate / event_count | 无日期过滤（商户主档 JOIN） | T 即可（当前主档） | 商户维表与核心客户号映射 |

### 2. 无日期过滤的全量聚合 → 不可滚动裁剪，需全量历史

| ODS 表 | 系统 | 消费过程 | 逻辑 | 建议保留 | 理由 |
|---|---|---|---|---|---|
| YBT_YBT_POLICY_BASE_INFO、YBT_YBT_POLICY_FEE_LIST、YBT_YBT_POLICY_INSURANCE_INFO、YBT_YBT_PRODUCT_INFO | IBP/保险 | PRC_DWD_ACCT_INSUR | 无日期过滤；MIN(accept_date)、MAX(ord_create_date)、按 tran_type 取状态交易日期、fee_aggr 全量聚合 | 保单全生命周期（≥ 最大缴费期） | LAST_TX_DATE/ACTL_TERM_DATE/续期保费需全部缴费记录；截断则余额与终止日期错误 |
| IBP_IB_LIST_PLAT | IBP | PRC_DWD_ACCT_INSUR | 按 ord_pay_serial 关联支付平台流水 | 与 fee 记录对齐的全量 | 支付流水关联 |
| FMS_TD_CUST_TRANS_REQ_LOG、FMS_T5_CUST_TRANS_LOG | FMS | PRC_DWD_ACCT_FIN | 无日期过滤；SUM(cfm_amt/ack_amt) 按账户聚合成功认购/申购 | 全量（≥ 在产品最长存续期） | CFM_AMT 为累计确认金额，截断则余额口径错误 |

### 3. 当日快照/当前主档 → T 即可（全量覆盖）

FMS_TD_CUST_VOL_DETAIL、FMS_T5_CUST_VOL_LIST（当前份额快照）、FMS_TD_PROD_NAV/FMS_T5_PROD_NAV（取 NAV_DATE 最新一行）、FMS_T1_CUST_INFO、FMS_T1_CUST_FNC_ACCT、FMS_T4_CUST_RISK_ASSESS_INFO、FMS_T5_PROD_INFO、FMS_T5_PROD_PERIOD、FMS_TD_PROD_INFO、CBS_KBRP_JGCSHU、CBS_KBRP_JGGXII、CBS_KFXP_XTHLCS（取 ROWNUM=1）、ECIF_T01_P_CUST_INFO、ECIF_T02_A_CUST_SIGN_REL、ECIF_T05_A_ACC_SIGN、CMS_CUSTOMER_INFO、CMS_BUSINESS_CONTRACT、CMS_BUSINESS_TYPE、CMS_ORG_INFO —— 均为无日期过滤的主档/最新值读取，ODS 只需当日全量。

### 4. 仓内中间层窗口（历史在仓内管理，ODS 只需支撑其生成）

| 表 | 消费过程 | 窗口 | 仓内保留 |
|---|---|---|---|
| DWS_CUST_ASSE_LIAB_HIS | deadline/lost/potn/indx | DATA_DATE ∈ {上月末(2), 上上月末(6), 当年初(13), 上季末(3), 上年末(4), FIRST_EXPR_DT-1} | ≥ 上年初至今（最长366天）连续日快照（到期承接按 FIRST_EXPR_DT-1 任意日） |
| DWS_CUST_ASSE_LIAB_CUMU_HIS | PRC_DWS_CUST_ASSE_LIAB_CUMU | DATA_DATE ≥ 当年初 且 < T；= T-1 | ≥ 当前年 |
| DWS_CUST_LVL_INFO_HIS | PRC_ADS_CUST_LOST_DTL | {上月末, 上上月末} | ≥ 2 个月 |
| DWS_CUST_DORMANT_ACCOUT | sleep_wake | {T, T-1} | 2 天 |
| ADS_MKT_REC_INFO | new_cust/lost/potn/deadline | MKT_TIME ∈ [OPEN_DATE..T]（≤180天）/ [当月初..T] / [FIRST_EXPR_DT..+30天]（可回溯至上年初） | ≥ 上年初至今（最长~365天） |
| DWD_TX_ASET | PRC_ADS_CRM_R_CUST_LABLE_TX_INFO | TX_DATE ∈ [T-1月, T]（参数20） | DWD ≥ 1 月；其 ODS 源 CBS_KDPL_ZHMINX 保留期【待确认】 |
| DWD_ACCT_DEPO/LOAN/FIN/INSUR | 各 DWS/ADS | 无日期过滤（当前快照）；EXPR_DATE/LAST_TX_DATE 属性过滤 | T 即可 |

## 三、结论速览

- 最长固定窗口：**当年初至今（最长 365 天）** —— uepp_pay_order_info、mbk_cust_log_fee、DWS_CUST_ASSE_LIAB_HIS/CUMU_HIS、ADS_MKT_REC_INFO。
- 不可裁剪全量：**YBT 保单缴费流水、FMS 理财交易流水**（无日期过滤聚合，保留期=业务存续期）。
- 其余 ODS 主档/快照：T 即可。
- 不存在因"3 年清理"产生的 3 年源表保留要求。

## 四、待确认项

1. DWD_TX_ASET / DWD_ACCT_DEPO / DWD_ACCT_LOAN / DWD_CUST_INDV_INFO 等的生成过程不在本仓库（stored_procedure 仅 8 个 ods_to_dwd），其 ODS 读取窗口无法从仓库确认；CBS_KDPL_ZHMINX、CBS_KDPA_ZHXINX、CMS_ACCT_LOAN 等 ODS 表最短保留期需向数据平台确认 DWD 侧是"日全量覆盖"还是"增量累积"。
2. PRC_DWD_ACCT_FIN 份额表替换设计（FMS_TD_CUST_VOL_DETAIL/T5_CUST_VOL_LIST + 置0规则）未落地；落地后需复核存在性判定是否引入跨期读取。
3. 真实执行/Explain 需数据库恢复后验证（offline-first 约束）。
