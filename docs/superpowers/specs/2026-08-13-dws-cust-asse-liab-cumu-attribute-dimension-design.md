# 客户资产负债基数明细属性维度设计

## 目标

`DWS_CUST_ASSE_LIAB_CUMU` 及历史表新增办理渠道、办理日期、投保单号或者借据号三个属性字段。保险余额必须按客户、账户、产品、渠道、办理日期、投保单号、机构及法人行号的完整明细维度读取、累计和留存，避免同账户同产品下的不同保单被合并。

## 字段定义与来源

| 目标字段 | 类型 | 含义 | 存款 | 贷款 | 理财 | 保险 |
|---|---|---|---|---|---|---|
| `CHNL_NO` | `VARCHAR(10)` | 办理渠道 | `NULL` | `NULL` | `DWD_ACCT_FIN.CHNL_NO` | `DWD_ACCT_INSUR.TX_CHNL` |
| `ISSU_DATE` | `VARCHAR(10)` | 办理日期 | `DWD_ACCT_DEPO.OPEN_DATE` | `DWD_ACCT_LOAN.LOAN_ISSU_DATE` | `DWD_ACCT_FIN.ISSU_DATE` | `DWD_ACCT_INSUR.TX_DATE` |
| `IOU_NO` | `VARCHAR(100)` | 投保单号或借据号 | `NULL` | `DWD_ACCT_LOAN.IOU_NO` | `NULL` | `DWD_ACCT_INSUR.INSUR_BID_FORM_NO` |

保险机构继续取 `DWD_ACCT_INSUR.MKT_ORG` 写入 `OPRT_ORG`，法人行号取 `DWD_ACCT_INSUR.PERSN_LEGAL_BK_CODE`。

## 明细与累计口径

当前表、历史表以及五张临时表统一采用以下业务明细维度：

```text
PERSN_LEGAL_BK_CODE + OPRT_ORG + CUST_ID + ACCT_ID + PRDKT_ID
+ PRDKT_CATE_BIG + CHNL_NO + ISSU_DATE + IOU_NO + PRDKT_TYP
```

`CHNL_NO`、`ISSU_DATE`、`IOU_NO` 可为空。过程在当日聚合与历史累计关联中使用空值安全等值比较，使来源为空的存款、贷款、理财记录能在相同空值维度上延续累计，不产生漏关联。

保险临时余额表以完整保险维度分组，`INSUR_AMT` 仅对 `POLICY_STATE = '1'` 的保单汇总。不同投保单号、渠道、办理日期或机构的保单不会相互合并。

## 流程调整

1. 步骤 2.2 从 `DWD_ACCT_INSUR` 读取 `TX_CHNL`、`TX_DATE`、`INSUR_BID_FORM_NO`，并与客户、账户、产品、产品大类、机构、法人行号共同分组。
2. 步骤 2.11 将四类产品的属性字段写入当日明细临时表。
3. 步骤 2.12 至 2.14 将属性字段传递至当日聚合、补零键集与历史累计临时表。
4. 步骤 2.15 使用完整明细维度关联当日和上日累计数据，写入当前表。
5. 步骤 2.16 将新增属性同步写入历史表，保证次日累计可按同一明细维度续算。

## DDL 影响

以下对象增加 `CHNL_NO VARCHAR(10)`、`ISSU_DATE VARCHAR(10)`、`IOU_NO VARCHAR(100)`：

- `DWS_CUST_ASSE_LIAB_CUMU`
- `DWS_CUST_ASSE_LIAB_CUMU_HIS`
- `TMP_DWS_CUST_ASSE_LIAB_INSUR_BAL`
- `TMP_DWS_CUST_ASSE_LIAB_TODAY_BAL`
- `TMP_DWS_CUST_ASSE_LIAB_TODAY_AGG`
- `TMP_DWS_CUST_ASSE_LIAB_KEY_SET`
- `TMP_DWS_CUST_ASSE_LIAB_HIS_AGG`

独立 DDL 与 `SYDDL.ddl.sql` 必须同时发布。现有正式表需要先执行 `ALTER TABLE ... ADD` 方式补列，再发布过程；不应使用重建表方式处理生产数据。

## 上线与历史数据

新增维度不会自动回填历史行。上线日之前的历史数据属性均为空，保险新明细首次与旧历史无法按完整维度匹配，月、季、年累计将从上线日重新起算。

推荐以发布日作为新维度累计基线日。若业务要求保留发布日前的累计连续性，必须先基于可追溯保险主档回灌三项属性，再发布本过程；缺少可追溯来源的数据不能臆造回填值。

## 测试矩阵

| 场景 | 预期结果 |
|---|---|
| 同客户、账户、产品但两张投保单号不同 | 输出两行，不合并余额 |
| 投保单号相同但渠道或办理日期不同 | 输出两行，不合并余额 |
| 两笔贷款借据不同 | 输出两行，各自累计 |
| 理财渠道、办理日期 | 原值写入当前表和历史表 |
| 次日正常跑批 | 同一完整维度的月、季、年累计在上日值上加当日余额 |
| 月初跑批 | 月累计重置为当日余额，季/年累计按既有规则延续 |
| 同日重跑 | 先删除当日当前和历史数据，结果不重复 |

本次只完成离线静态和合成数据脚本验证。未连接 Kingbase 数据库，数据库编译、真实执行结果和执行计划需在测试库完成验证。
