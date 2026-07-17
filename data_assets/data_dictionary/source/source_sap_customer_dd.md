# 上游系统数据字典 - SAP 客户信息表

## 表信息

| 属性 | 值 |
|------|------|
| 系统名称 | SAP |
| 表名 | S_CUSTOMER |
| 中文名称 | SAP客户信息表 |
| 描述 | SAP系统中的客户主数据表 |
| 数据来源 | SAP ECC系统 |
| 负责人 | 【待确认】 |
| 更新时间 | 2026-07-17 |

## 字段列表

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 业务含义 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|
| CUST_ID | 客户ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - | 客户唯一标识 |
| CUST_NAME | 客户名称 | VARCHAR | 200 | NOT NULL | - | - | - | - | 客户全称 |
| CUST_CODE | 客户编码 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | - | 客户业务编码 |
| CUST_TYPE | 客户类型 | VARCHAR | 20 | NULL | P | - | - | P-个人, E-企业 | 客户分类 |
| CUST_STATUS | 客户状态 | VARCHAR | 10 | NULL | Y | - | - | Y-有效, N-无效 | 客户有效性状态 |
| INDUSTRY | 所属行业 | VARCHAR | 100 | NULL | - | - | - | - | 客户所属行业 |
| REGION | 所属区域 | VARCHAR | 100 | NULL | - | - | - | - | 客户所属区域 |
| CONTACT_PHONE | 联系电话 | VARCHAR | 50 | NULL | - | - | - | - | 客户联系电话 |
| CONTACT_EMAIL | 联系邮箱 | VARCHAR | 200 | NULL | - | - | - | - | 客户联系邮箱 |
| CREATE_TIME | 创建时间 | VARCHAR | 20 | NULL | - | - | - | - | 记录创建时间（格式：YYYY/MM/DD HH24:MI:SS） |
| UPDATE_TIME | 更新时间 | VARCHAR | 20 | NULL | - | - | - | - | 记录更新时间（格式：YYYY/MM/DD HH24:MI:SS） |
