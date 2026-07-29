# 指标任务完成情况

**表名**: `ADS_MKT_TASK_INDX_SUB_CMPLT`  
**中文名**: 指标任务完成情况  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| TSK_INDX_ID | VARCHAR2(40) | 指标任务映射编号 | |
| TSK_ID | VARCHAR2(40) | 任务编号 | |
| MAIN_TSK_ID | VARCHAR2(40) | 主任务编号 | |
| INDX_ID | VARCHAR2(40) | 指标ID | |
| TSK_NEXT_SEND_TYP | VARCHAR2(6) | 任务下发类型(0总行下发,1分行/区行下发,2支行下发) | |
| RSV_OBJ | VARCHAR2(6) | 接收对象0机构1客户经理 | |
| RSV_OBJ_ID | VARCHAR2(30) | 接收对象ID | |
| TSK_BGN_DATE | VARCHAR2(10) | 任务开始时间 | |
| TSK_END_DATE | VARCHAR2(10) | 任务结束时间 | |
| INDX_UNIT | VARCHAR2(20) | 指标单位(万元/个数/百分比) | |
| INDX_VAL | NUMBER(18,4) | 指标额 | |
| INDX_VAL_ADD | NUMBER(18,4) | 指标加码 | |
| ACUM_CMPLT_INDX | NUMBER(18,4) | 累计完成指标 | |
| DAY_CURNT_CMPLT_INDX | NUMBER(18,4) | 当天完成指标 | |
| BASE_VAL | NUMBER(18,4) | 基准值 | |
| CURNT_VAL | NUMBER(18,4) | 当前值 | |
| PERSN_LEGAL_BK_CODE | VARCHAR2(30) | 法人行号 | |
