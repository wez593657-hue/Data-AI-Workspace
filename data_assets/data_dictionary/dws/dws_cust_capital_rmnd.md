# DWS数据字典 - DWS_CUST_CAPITAL_RMND

## 表信息

| 属性 | 值 |
|------|------|
| 层级 | DWS - 汇总数据层 |
| 表名 | DWS_CUST_CAPITAL_RMND |
| 中文名称 | 客户资金异动提醒表 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| RMND_ID | 提醒ID | VARCHAR | 40 | - | - | - | - | - | - |
| MNGR_POST_ID | 客户经理编号 | VARCHAR | 20 | - | - | - | - | - | - |
| MNGR_NAME | 客户经理名称 | VARCHAR | 120 | - | - | - | - | - | - |
| CUST_ID | 客户编号 | VARCHAR | 20 | - | - | - | - | - | - |
| CUST_TYP | 客户类型 | VARCHAR | 4 | - | - | - | - | - | - |
| CUST_NAME | 客户名称 | VARCHAR | 100 | - | - | - | - | - | - |
| ACCT_NO | 账号 | VARCHAR | 40 | - | - | - | - | - | - |
| HAPN_BAL | 发生金额 | NUMBER | 20,2 | - | - | - | - | - | - |
| ORG_ID | 机构ID | VARCHAR | 7 | - | - | - | - | - | - |
| PHONE_NO | 手机号 | VARCHAR | 32 | - | - | - | - | - | - |
| HDLE_STATE | 处理状态(0为浏览,1已浏览) | VARCHAR | 2 | - | - | - | - | - | - |
| DC_FLAG | 借贷标志 | VARCHAR | 2 | - | - | - | - | - | - |
| RMND_TIME | 发生时间 | VARCHAR | 20 | - | - | - | - | - | - |
| TX_CHNL | 交易渠道 | VARCHAR | 20 | - | - | - | - | - | - |
| OPNT_BK_KEEP | 对手行 | VARCHAR | 200 | - | - | - | - | - | - |
| OPNT_NAME | 对手姓名 | VARCHAR | 200 | - | - | - | - | - | - |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR | 4 | - | - | - | - | - | - |
| HDLE_TIME | 处理时间 | VARCHAR | 20 | - | - | - | - | - | - |
| REMARK | 备注 | VARCHAR | 200 | - | - | - | - | - | - |
| CUST_LVL | 客户层级 | VARCHAR | 2 | - | - | - | - | - | - |
| RMND_INF | 提醒内容 | VARCHAR | 600 | - | - | - | - | - | - |

---
*数据字典版本: v1.0 | 生成时间: 2026-07-17*
