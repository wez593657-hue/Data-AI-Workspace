# ADS数据字典 - ADS_CUST_DEADLINE_RMND_DTL

## 表信息

| 属性 | 值 |
| --- | --- |
| 层级 | ADS - 应用数据层 |
| 表名 | ADS_CUST_DEADLINE_RMND_DTL |
| 中文名称 | 到期承接明细表 |
| 来源模型 | ADS应用层数据模型_CRM_ V1.0.xlsx / 到期承接明细表 |
| 更新时间 | 2026-07-20 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR | 4 | 【待确认】 | - | - | - | - | 法人行号 |
| DATA_DATE | 周期结束日期 | VARCHAR | 8 | 【待确认】 | - | - | - | - | 周期结束日期（M-月末，Q-季末，N-年末） |
| CUST_ID | 客户编号 | VARCHAR | 20 | 【待确认】 | - | - | - | - | 客户编号 |
| CUST_NAME | 客户名称 | VARCHAR | 100 | 【待确认】 | - | - | - | - | 客户名称 |
| CUST_LVL | 客户等级 | VARCHAR | 2 | 【待确认】 | - | - | - | - | 客户等级 |
| DEPO_CURNT_DEPO_BAL | 活期余额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 活期余额 |
| FIXD_DEPO_BAL | 定期余额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 定期余额 |
| FIN_AMT | 理财余额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 理财余额 |
| STAT_PERD | 统计周期 | VARCHAR | 2 | 【待确认】 | - | - | - | - | 统计周期 |
| STATIS_TYP | 承接类型0-全部1-存款2-理财 | VARCHAR | 2 | 【待确认】 | - | - | - | - | 承接类型0-全部1-存款2-理财 |
| EXPR_AMT | 到期金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 到期金额 |
| MATURE_TTL_AMT | 到期总金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 到期总金额 |
| TAKE_RATE | 承接率 | NUMBER | 10,2 | 【待确认】 | - | - | - | - | 承接率 |
| FIX_DEPO_MATURE_AMT | 定期存款到期金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 定期存款到期金额 |
| FIX_DEPO_MATURE_TTL_AMT | 定期存款到期总金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 定期存款到期总金额 |
| FIX_DEPO_TAKE_RATE | 定期存款承接率 | NUMBER | 10,2 | 【待确认】 | - | - | - | - | 定期存款承接率 |
| CNTCT_STATE | 接触状态 | VARCHAR | 1 | 【待确认】 | - | - | - | - | 接触状态 |
| UNDTAKE_STATE | 承接状态 | VARCHAR | 1 | 【待确认】 | - | - | - | - | 承接状态 |
| FIXED_FIN_MATURE_TRAN_INSUR_AMT | 定期理财到期转保险金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 定期理财到期转保险金额 |
| FIN_MATURE_TRAN_FIXED_AMT | 理财到期转定期金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 理财到期转定期金额 |
| FIXED_MATURE_TRAN_FIN_AMT | 定期到期转理财金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 定期到期转理财金额 |
| FRST_MATURE_PK_BF_DAY_AUM_BAL | 本期第一笔到期产品前一日AUM余额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 本期第一笔到期产品前一日AUM余额 |
| LAST_END_DATE | 本期最后一笔到期产品日期 | VARCHAR | 8 | 【待确认】 | - | - | - | - | 本期最后一笔到期产品日期 |
| POST_ID | 管户经理 | VARCHAR | 20 | 【待确认】 | - | - | - | - | 管户经理 |
| ORG_ID | 归属机构 | VARCHAR | 7 | 【待确认】 | - | - | - | - | 归属机构 |

---

*数据字典版本: v1.0 | 生成时间: 2026-07-20*
