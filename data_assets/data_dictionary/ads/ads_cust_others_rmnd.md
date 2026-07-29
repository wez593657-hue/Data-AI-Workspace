# 其他事件提醒

**表名**: `ADS_CUST_OTHERS_RMND`  
**中文名**: 其他事件提醒  
**来源**: Mapping Excel (ADS应用层数据模型)  
**更新时间**: 2026-07-29  

## 字段列表

| 字段名 | 数据类型 | 中文名 | 备注 |
|---|---|---|---|
| RMND_ID | VARCHAR2 | 提醒ID | |
| RMND_CATE_BIG | VARCHAR2 | 提醒类型(1-贷款逾期提醒,2-贷款欠息提醒,3-贷款还款余额不足提醒,4-收单商户长期无交易提醒,5-销户提醒,6-客户分配,7-客户回收,8-客户移交,9-客户调配) | |
| RMND_CATE_SML | VARCHAR2 | 提醒名称 | |
| MNGR_POST_ID | VARCHAR2 | 客户经理编号 | |
| MNGR_NAME | VARCHAR2 | 客户经理名称 | |
| ORG_ID | VARCHAR2 | 机构编号 | |
| CUST_TYP | VARCHAR2 | 客户类型 | |
| CUST_ID | VARCHAR2 | 客户ID | |
| CUST_NAME | VARCHAR2 | 客户名称 | |
| PHONE_NO | VARCHAR2 | 手机号 | |
| RMND_INF | VARCHAR2 | 提醒内容 | |
| HDLE_STATE | VARCHAR2 | 处理状态(0未读 1已读) | |
| RMND_DATE | VARCHAR2 | 提醒日期 | |
| PERSN_LEGAL_BK_CODE | VARCHAR2 | 法人行号 | |
| HDLE_TIME | VARCHAR2 | 处理时间 | |
| DEL_FLG | VARCHAR2 | 删除标志 | |
| HDLE_DSC | VARCHAR2 | 处理说明 | |
