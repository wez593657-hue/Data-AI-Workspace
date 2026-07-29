# 指标数据统计

**表名**: `ADS_STAT_INDX_DATA`  
**中文名**: 指标数据统计  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| INDX_CODE | VARCHAR2(100) | 指标编码 | |
| DATA_BLNG | VARCHAR2(100) | 数据归属 | |
| STATIS_DIM | VARCHAR2(100) | 统计维度 | |
| STATIS_CALIB | VARCHAR2(100) | 统计口径 | |
| CURNT_VAL | NUMBER(20,2) | 本期值 | |
| TERM_LAST_VAL | NUMBER(20,2) | 上期值 | |
| MTH_END_VAL | NUMBER(20,2) | 月末值 | |
| YR_BGN_VAL | NUMBER(20,2) | 年初值 | |
| MTH_LAST_END_AVG_DAY_VAL | NUMBER(20,2) | 上月末日均值 | |
| YR_LAST_END_AVG_DAY_VAL | NUMBER(20,2) | 上年末日均值 | |
| DATA_DATE | VARCHAR2(10) | 数据日期 | |
| PERSN_LEGAL_BK_CODE | VARCHAR2(30) | 法人行号 | |
| ID | VARCHAR2(10) | [NULL] | |
