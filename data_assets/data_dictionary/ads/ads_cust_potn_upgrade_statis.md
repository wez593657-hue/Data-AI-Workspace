# ADS数据字典 - ADS_CUST_POTN_UPGRADE_STATIS

## 表信息

| 属性 | 值 |
| --- | --- |
| 层级 | ADS - 应用数据层 |
| 表名 | ADS_CUST_POTN_UPGRADE_STATIS |
| 中文名称 | 潜力提升统计表 |
| 来源模型 | ADS应用层数据模型_CRM_ V1.0.xlsx / 潜力提升统计表 |
| 更新时间 | 2026-07-20 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PERSN_LEGAL_BK_CODE | 法人行号 | VARCHAR2 | 4 | 【待确认】 | - | - | - | - | 法人行号 |
| DATA_DATE | 数据日期 | VARCHAR2 | 8 | 【待确认】 | - | - | - | - | 数据日期 |
| STATIS_OBJ | 统计对象 | VARCHAR2 | 20 | 【待确认】 | - | - | - | - | 统计对象 |
| STATIS_CYCLE | 统计周期(月/季/年) | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 统计周期(月/季/年) |
| LVL_CRIT | 临界等级 | VARCHAR2 | 2 | 【待确认】 | - | - | - | - | 临界等级 |
| TTL_CUST_CNT | 总客户数 | NUMBER | 8 | 【待确认】 | - | - | - | - | 总客户数 |
| MTH_AVG_QUAL_CNT | 月均达标 | NUMBER | 8 | 【待确认】 | - | - | - | - | 月均达标 |
| MTH_AVG_QUAL_RATE | 月均达标率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 月均达标率 |
| PNT_QUAL_CNT | 时点达标 | NUMBER | 8 | 【待确认】 | - | - | - | - | 时点达标 |
| PNT_QUAL_RATE | 时点达标率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 时点达标率 |
| CNTCT_CUST_CNT | 已接触客户 | NUMBER | 8 | 【待确认】 | - | - | - | - | 已接触客户 |
| CNTCT_RATE | 接触率 | NUMBER | 20,2 | 【待确认】 | - | - | - | - | 接触率 |

---

*数据字典版本: v1.0 | 生成时间: 2026-07-20*
