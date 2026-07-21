# ADS数据字典 - ADS_CUST_DEADLINE_RMND_STATIS

## 表信息

| 属性 | 值 |
| --- | --- |
| 层级 | ADS - 应用数据层 |
| 表名 | ADS_CUST_DEADLINE_RMND_STATIS |
| 中文名称 | 到期承接统计表 |
| 来源模型 | ADS应用层数据模型_CRM_ V1.0.xlsx / 到期承接统计表 |
| 更新时间 | 2026-07-20 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 | 4 | 【待确认】 | - | - | - | - | 法人行号 |
| DATA_DATE | 周期结束日期 | VARCHAR2 | 8 | 【待确认】 | - | - | - | - | 周期结束日期（M-月末，Q-季末，N-年末） |
| STATIS_OBJ | 统计对象 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 统计对象 |
| STATIS_CYCLE | 统计周期 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 统计周期 |
| STATIS_TYP | 承接类型0-全部1-存款2-理财 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 承接类型0-全部1-存款2-理财 |
| EXPR_CUST_CNT | 已到期客户数 | NUMBER | 8 | 【待确认】 | - | - | - | - | 已到期客户数 |
| TTL_EXPR_CUST_CNT | 总到期客户数 | NUMBER | 8 | 【待确认】 | - | - | - | - | 总到期客户数 |
| EXPR_AMT | 已到期金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 已到期金额 |
| TTL_EXPR_AMT | 总到期金额 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 总到期金额 |
| CUST_UNDTAKE_RATE | 客户承接率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 客户承接率 |
| ASSET_KEEP_RATE | 资产留存率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 资产留存率 |
| ASSET_UNDTAKE_RATE | 资产承接率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 资产承接率 |
| DEPO_TO_FIN_CONVRS_RATE | 存款转理财转化率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 存款转理财转化率 |
| INSUR_CONVRS_RATE | 保险转化率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 保险转化率 |
| FIN_TO_DEPO_CONVRS_RATE | 理财转存款转化率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 理财转存款转化率 |

---

*数据字典版本: v1.0 | 生成时间: 2026-07-20*
