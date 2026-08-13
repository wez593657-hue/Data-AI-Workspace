# 客户资产负债基数属性维度变更记录

变更日期：2026-08-13  
涉及过程：`PRC_DWS_CUST_ASSE_LIAB_CUMU`

## 变更内容

1. 当前表、历史表及相关临时表新增 `CHNL_NO`（办理渠道）、`ISSU_DATE`（办理日期）、`IOU_NO`（投保单号或者借据号）。
2. 保险余额从 `DWD_ACCT_INSUR` 按客户、账户、产品、产品大类、`TX_CHNL`、`TX_DATE`、`INSUR_BID_FORM_NO`、法人行号和 `MKT_ORG` 分组读取。
3. 新增字段贯通当日余额、当日聚合、补零键集、历史累计、当前表和历史表，且参与累计关联条件。
4. 存款、贷款、理财字段映射同步更新：存款取开户日期；贷款取发放日期和借据号；理财取办理渠道和办理日期。
5. 新增 `data_assets/ddl/dws/alter_dws_cust_asse_liab_cumu_attribute_dimension.sql`，用于对已部署的当前表和历史表执行增列及字段注释更新；正式表不采用重建方式。

## 影响与边界

- 保险保单不再因客户、账户和产品相同而被合并，保单、渠道、日期或机构不同即保留独立行。
- 新维度上线前的历史数据默认属性为空。未执行历史回灌时，保险累计以发布日作为新明细维度基线。
- 本次未调整既有分段提交、保险状态判定或累计周期计算逻辑。

## 验证

新增 `scripts/oracle_validation/cust_asse_liab_cumu/01_attribute_dimension_assert.sql`，以合成数据验证保单、借据、理财属性和日累计口径。未连接 Kingbase 测试库，未执行数据库编译、运行或执行计划分析。
