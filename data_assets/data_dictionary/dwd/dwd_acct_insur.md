# DWD数据字典 - DWD_ACCT_INSUR

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | DWD - 明细数据层 |
| 表名 | DWD_ACCT_INSUR |
| 中文名称 | 保险账户信息 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| CUST_ID | 客户编号 | VARCHAR | 20 | - | - | - | - | - | - |
| CUST_TYP | 客户类型 | VARCHAR | 4 | - | - | - | - | - | - |
| ACCT_ID | 账户 | VARCHAR | 40 | - | - | - | - | - | - |
| PRDKT_ID | 产品ID | VARCHAR | 40 | - | - | - | - | - | - |
| PRDKT_NAME | 产品名称 | VARCHAR | 100 | - | - | - | - | - | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR | 64 | - | - | - | - | - | - |
| INSUR_BID_FORM_NO | 投保单号 | VARCHAR | 40 | - | - | - | - | - | - |
| TX_DATE | 交易日期 | VARCHAR | 10 | - | - | - | - | - | - |
| TX_ORG | 交易机构 | VARCHAR | 7 | - | - | - | - | - | - |
| TX_CHNL | 交易渠道 | VARCHAR | 10 | - | - | - | - | - | - |
| MKT_ORG | 归属机构 | VARCHAR | 7 | - | - | - | - | - | - |
| BGN_INSUR_DATE | 起保日期 | VARCHAR | 10 | - | - | - | - | - | - |
| CANCL_INSUR_DATE | 退保日期 | VARCHAR | 10 | - | - | - | - | - | - |
| INSUR_PERIOD_TYP | 保险期间类型 | VARCHAR | 2 | - | - | - | - | - | - |
| INSUR_PERIOD | 保险期间值 | VARCHAR | 6 | - | - | - | - | - | - |
| PAY_PERIOD_TYP | 缴费期间类型 | VARCHAR | 2 | - | - | - | - | - | - |
| PAY_PERIOD | 缴费期间值 | VARCHAR | 6 | - | - | - | - | - | - |
| PAY_PATRN | 缴费方式 | VARCHAR | 2 | - | - | - | - | - | - |
| INSUR_AMT | 保费金额 | NUMBER | 20,2 | - | - | - | - | - | - |
| POLICY_STATE | 保单状态 | VARCHAR | 10 | - | - | - | - | - | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR | 4 | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
