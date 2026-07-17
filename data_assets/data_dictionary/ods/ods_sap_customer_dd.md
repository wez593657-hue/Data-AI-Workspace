# ODS 层数据字典 - ods_sap_customer

## 表信息

| 属性 | 值 |
|------|----|
| 表名 | ods_sap_customer |
| 中文名称 | 【待确认】 |
| 描述 | 根据 ODS DDL 自动生成，业务含义待确认 |
| 数据来源 | DDL: ods_sap_customer |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|--------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| CUST_ID | 【待确认】 | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | 【待确认】 | ods_sap_customer.CUST_ID | 【待确认】 | 2026-07-17 |
| CUST_NAME | 【待确认】 | VARCHAR | 200 | NOT NULL | - | - | - | 【待确认】 | ods_sap_customer.CUST_NAME | 【待确认】 | 2026-07-17 |
| CUST_CODE | 【待确认】 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | 【待确认】 | ods_sap_customer.CUST_CODE | 【待确认】 | 2026-07-17 |
| CUST_TYPE | 【待确认】 | VARCHAR | 20 | NULL | - | - | - | 【待确认】 | ods_sap_customer.CUST_TYPE | 【待确认】 | 2026-07-17 |
| CUST_STATUS | 【待确认】 | VARCHAR | 10 | NULL | - | - | - | 【待确认】 | ods_sap_customer.CUST_STATUS | 【待确认】 | 2026-07-17 |
| INDUSTRY | 【待确认】 | VARCHAR | 100 | NULL | - | - | - | 【待确认】 | ods_sap_customer.INDUSTRY | 【待确认】 | 2026-07-17 |
| REGION | 【待确认】 | VARCHAR | 100 | NULL | - | - | - | 【待确认】 | ods_sap_customer.REGION | 【待确认】 | 2026-07-17 |
| CONTACT_PHONE | 【待确认】 | VARCHAR | 50 | NULL | - | - | - | 【待确认】 | ods_sap_customer.CONTACT_PHONE | 【待确认】 | 2026-07-17 |
| CONTACT_EMAIL | 【待确认】 | VARCHAR | 200 | NULL | - | - | - | 【待确认】 | ods_sap_customer.CONTACT_EMAIL | 【待确认】 | 2026-07-17 |
| CREATE_TIME | 【待确认】 | VARCHAR | 20 | NULL | - | - | - | 【待确认】 | ods_sap_customer.CREATE_TIME | 【待确认】 | 2026-07-17 |
| UPDATE_TIME | 【待确认】 | VARCHAR | 20 | NULL | - | - | - | 【待确认】 | ods_sap_customer.UPDATE_TIME | 【待确认】 | 2026-07-17 |
| ETL_LOAD_TIME | 【待确认】 | TIMESTAMP | - | NOT NULL | NOW() | - | - | 【待确认】 | ods_sap_customer.ETL_LOAD_TIME | 【待确认】 | 2026-07-17 |
| ETL_BATCH_ID | 【待确认】 | VARCHAR | 50 | NULL | - | - | - | 【待确认】 | ods_sap_customer.ETL_BATCH_ID | 【待确认】 | 2026-07-17 |
