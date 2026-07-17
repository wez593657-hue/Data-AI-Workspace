# DWD 层数据字典 - CRM 客户明细表

## 表信息

| 属性 | 值 |
|------|------|
| 表名 | dwd_crm_customer |
| 中文名称 | DWD_CRM客户明细表 |
| 描述 | 清洗去重后的CRM客户明细数据 |
| 数据来源 | ODS层 ods_sap_customer |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - | ods_sap_customer.CUST_ID | 【待确认】 | 2026-07-17 |
| customer_name | 客户名称 | VARCHAR | 200 | NOT NULL | - | - | - | - | ods_sap_customer.CUST_NAME | 【待确认】 | 2026-07-17 |
| customer_code | 客户编码 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | - | ods_sap_customer.CUST_CODE | 【待确认】 | 2026-07-17 |
| customer_type | 客户类型 | VARCHAR | 20 | NULL | PERSONAL | - | - | PERSONAL-个人, ENTERPRISE-企业, UNKNOWN-未知 | ods_sap_customer.CUST_TYPE | 【待确认】 | 2026-07-17 |
| customer_status | 客户状态 | VARCHAR | 20 | NULL | ACTIVE | - | - | ACTIVE-活跃, INACTIVE-停用, UNKNOWN-未知 | ods_sap_customer.CUST_STATUS | 【待确认】 | 2026-07-17 |
| industry | 所属行业 | VARCHAR | 100 | NULL | - | - | - | - | ods_sap_customer.INDUSTRY | 【待确认】 | 2026-07-17 |
| region | 所属区域 | VARCHAR | 100 | NULL | - | - | - | - | ods_sap_customer.REGION | 【待确认】 | 2026-07-17 |
| contact_phone | 联系电话 | VARCHAR | 50 | NULL | - | - | - | - | ods_sap_customer.CONTACT_PHONE | 【待确认】 | 2026-07-17 |
| contact_email | 联系邮箱 | VARCHAR | 200 | NULL | - | - | - | - | ods_sap_customer.CONTACT_EMAIL | 【待确认】 | 2026-07-17 |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - | ods_sap_customer.CREATE_TIME | 【待确认】 | 2026-07-17 |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - | ods_sap_customer.UPDATE_TIME | 【待确认】 | 2026-07-17 |
| etl_time | ETL时间 | TIMESTAMP | - | NULL | NULL | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
| etl_batch_id | ETL批次ID | VARCHAR | 50 | NULL | - | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
