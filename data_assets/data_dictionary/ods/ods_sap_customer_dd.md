# ODS 层数据字典 - SAP 客户信息表

## 表信息

| 属性 | 值 |
|------|------|
| 表名 | ods_sap_customer |
| 中文名称 | ODS_SAP客户信息表 |
| 描述 | SAP客户数据原始落地表，保留原始格式 |
| 数据来源 | SAP系统 S_CUSTOMER 表 |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| CUST_ID | 客户ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - | SAP S_CUSTOMER.CUST_ID | 【待确认】 | 2026-07-17 |
| CUST_NAME | 客户名称 | VARCHAR | 200 | NOT NULL | - | - | - | - | SAP S_CUSTOMER.CUST_NAME | 【待确认】 | 2026-07-17 |
| CUST_CODE | 客户编码 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | - | SAP S_CUSTOMER.CUST_CODE | 【待确认】 | 2026-07-17 |
| CUST_TYPE | 客户类型 | VARCHAR | 20 | NULL | - | - | - | P-个人, E-企业 | SAP S_CUSTOMER.CUST_TYPE | 【待确认】 | 2026-07-17 |
| CUST_STATUS | 客户状态 | VARCHAR | 10 | NULL | - | - | - | Y-有效, N-无效 | SAP S_CUSTOMER.CUST_STATUS | 【待确认】 | 2026-07-17 |
| INDUSTRY | 所属行业 | VARCHAR | 100 | NULL | - | - | - | - | SAP S_CUSTOMER.INDUSTRY | 【待确认】 | 2026-07-17 |
| REGION | 所属区域 | VARCHAR | 100 | NULL | - | - | - | - | SAP S_CUSTOMER.REGION | 【待确认】 | 2026-07-17 |
| CONTACT_PHONE | 联系电话 | VARCHAR | 50 | NULL | - | - | - | - | SAP S_CUSTOMER.CONTACT_PHONE | 【待确认】 | 2026-07-17 |
| CONTACT_EMAIL | 联系邮箱 | VARCHAR | 200 | NULL | - | - | - | - | SAP S_CUSTOMER.CONTACT_EMAIL | 【待确认】 | 2026-07-17 |
| CREATE_TIME | 创建时间 | VARCHAR | 20 | NULL | - | - | - | - | SAP S_CUSTOMER.CREATE_TIME | 【待确认】 | 2026-07-17 |
| UPDATE_TIME | 更新时间 | VARCHAR | 20 | NULL | - | - | - | - | SAP S_CUSTOMER.UPDATE_TIME | 【待确认】 | 2026-07-17 |
| ETL_LOAD_TIME | ETL加载时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
| ETL_BATCH_ID | ETL批次ID | VARCHAR | 50 | NULL | - | - | - | - | 系统自动 | 【待确认】 | 2026-07-17 |
