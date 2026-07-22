# DWD数据字典 - DWD_TX_ASET

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | DWD - 明细数据层 |
| 表名 | DWD_TX_ASET |
| 中文名称 | 资产类交易 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| SEQ_ID | 流水号 | VARCHAR | 40 | - | - | - | - | - | - |
| CUST_ID | 客户编号 | VARCHAR | 21 | - | - | - | - | - | - |
| CUST_TYP | 客户类型 | VARCHAR | 4 | - | - | - | - | - | - |
| ACCT_ID | 账户 | VARCHAR | 40 | - | - | - | - | - | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR | 6 | - | - | - | - | - | - |
| PRDKT_ID | 产品ID | VARCHAR | 40 | - | - | - | - | - | - |
| TX_CHNL | 交易渠道 | VARCHAR | 10 | - | - | - | - | - | - |
| TX_DATE | 交易日期 | VARCHAR | 10 | - | - | - | - | - | - |
| TX_TIME | 交易时间 | VARCHAR | 20 | - | - | - | - | - | - |
| CCY_CD | 币种 | VARCHAR | 6 | - | - | - | - | - | - |
| TX_TYP | 交易类型 | VARCHAR | 6 | - | - | - | - | - | - |
| AMT | 发生额 | NUMBER | 18,4 | - | - | - | - | - | - |
| TX_TYP_NAME | 交易类型名称 | VARCHAR | 80 | - | - | - | - | - | - |
| TX_ORG | 交易机构 | VARCHAR | 7 | - | - | - | - | - | - |
| OPRTR | 经办人 | VARCHAR | 20 | - | - | - | - | - | - |
| LOAN_FLG | 借贷标识 | VARCHAR | 3 | - | - | - | - | - | - |
| ACCT_BAL | 账户余额 | NUMBER | 18,4 | - | - | - | - | - | - |
| TX_DSC | 交易说明 | VARCHAR | 200 | - | - | - | - | - | - |
| OPNT_ACCT | 对方账户 | VARCHAR | 32 | - | - | - | - | - | - |
| OPNT_ACCT_NAME_FST | 对方户名 | VARCHAR | 200 | - | - | - | - | - | - |
| OPNT_BK_KEEP | 对方行 | VARCHAR | 20 | - | - | - | - | - | - |
| OPNT_NAME_BK | 对方行名 | VARCHAR | 200 | - | - | - | - | - | - |
| FEE_HAND | 手续费 | NUMBER | 18,4 | - | - | - | - | - | - |
| ACCT_BLNG_ORG | 账户归属机构 | VARCHAR | 7 | - | - | - | - | - | - |
| CARD_NO | 卡/折号 | VARCHAR | 30 | - | - | - | - | - | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR | 30 | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
