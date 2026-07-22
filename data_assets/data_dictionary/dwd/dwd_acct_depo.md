# DWD数据字典 - DWD_ACCT_DEPO

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | DWD - 明细数据层 |
| 表名 | DWD_ACCT_DEPO |
| 中文名称 | 存款账户信息表 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| CUST_ID | 客户编号 | VARCHAR | 20 | - | - | - | - | - | - |
| CUST_TYP | 客户类型 | VARCHAR | 2 | - | - | - | - | - | - |
| ACCT_ID | 账户 | VARCHAR | 40 | - | - | - | - | - | - |
| CARD_NO | 卡/折号 | VARCHAR | 40 | - | - | - | - | - | - |
| PRDKT_ID | 产品编号 | VARCHAR | 30 | - | - | - | - | - | - |
| PRDKT_NAME | 产品名称 | VARCHAR | 200 | - | - | - | - | - | - |
| PRDKT_CATE_BIG | 产品大类 | VARCHAR | 64 | - | - | - | - | - | - |
| ACCT_TYP | 账户类型 | VARCHAR | 10 | - | - | - | - | - | - |
| CCY_CD | 币种 | VARCHAR | 4 | - | - | - | - | - | - |
| BAL | 余额 | NUMBER | 20,2 | - | - | - | - | - | - |
| RMB_BAL | 折人民币余额 | NUMBER | 20,2 | - | - | - | - | - | - |
| OPEN_ACCT_ORG | 归属机构 | VARCHAR | 7 | - | - | - | - | - | - |
| OPEN_DATE | 开户日期 | VARCHAR | 10 | - | - | - | - | - | - |
| RATE_INTRI | 利率 | NUMBER | 20,2 | - | - | - | - | - | - |
| INTRI_BGN_DATE | 起息日期 | VARCHAR | 10 | - | - | - | - | - | - |
| EXPR_DATE | 到期日期 | VARCHAR | 10 | - | - | - | - | - | - |
| ACCT_CLOZ_DATE | 销户日期 | VARCHAR | 10 | - | - | - | - | - | - |
| ACCT_STATE | 账户状态 | VARCHAR | 10 | - | - | - | - | - | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR | 4 | - | - | - | - | - | - |
| VCHR_TYP | 凭证类型 | VARCHAR | 10 | - | - | - | - | - | - |
| CUNQ | 存期 | VARCHAR | 10 | - | - | - | - | - | - |
| FIX_CURNT_FLG | 定活标志 | VARCHAR | 1 | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
