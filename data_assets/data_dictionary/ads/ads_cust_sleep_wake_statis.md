# 睡眠户唤醒统计表

**表名**: `ADS_CUST_SLEEP_WAKE_STATIS`  
**中文名**: 睡眠户唤醒统计表  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| PERSN_LEGAL_BK_CODE | VARCHAR2(4) | 法人行号 | |
| DATA_DATE | VARCHAR2(8) | 数据日期 | |
| STATIS_OBJ | VARCHAR2(20) | 统计对象 | |
| STATIS_CYCLE | VARCHAR2(2) | 统计周期(月/季/年) | |
| CUST_CNT | NUMBER(8) | 客户数 | |
| CNTCT_CUST_CNT | NUMBER(8) | 已接触客户 | |
| CNTCT_RATE | NUMBER(20,2) | 接触率 | |
| WAKE_CUST_CNT | NUMBER(8) | 已唤醒客户 | |
| WAKE_RATE | NUMBER(20,2) | 唤醒率 | |
