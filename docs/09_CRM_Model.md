# 09 CRM 数据模型

## 9.1 概述

本文档定义 CRM 系统的核心数据模型，包括实体关系、表结构设计和业务规则。

## 9.2 CRM 业务模块边界

【待确认】- 需要确认具体业务模块划分

## 9.3 核心实体关系图

```
┌─────────────┐     1:N      ┌─────────────┐
│   Customer  │◄────────────►│    Order    │
│   (客户)    │              │    (订单)   │
└─────────────┘              └─────────────┘
       │                            │
       │ 1:N                        │ 1:N
       ▼                            ▼
┌─────────────┐              ┌─────────────┐
│   Contact   │              │  Payment    │
│  (联系人)   │              │   (支付)    │
└─────────────┘              └─────────────┘
       │
       │ 1:N
       ▼
┌─────────────┐
│ Address     │
│  (地址)     │
└─────────────┘
```

## 9.4 核心表结构

### 9.4.1 客户表（crm_customer）

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 |
|--------|-------------|----------|------|----------|--------|------|------|----------|
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - |
| customer_name | 客户名称 | VARCHAR | 200 | NOT NULL | - | - | - | - |
| customer_code | 客户编码 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | - |
| customer_type | 客户类型 | VARCHAR | 20 | NULL | PERSONAL | - | - | PERSONAL-个人, ENTERPRISE-企业 |
| customer_status | 客户状态 | VARCHAR | 20 | NULL | ACTIVE | - | - | ACTIVE-活跃, INACTIVE-停用, UNKNOWN-未知 |
| industry | 所属行业 | VARCHAR | 100 | NULL | - | - | - | - |
| region | 所属地区 | VARCHAR | 100 | NULL | - | - | - | - |
| contact_phone | 联系电话 | VARCHAR | 50 | NULL | - | - | - | - |
| contact_email | 联系邮箱 | VARCHAR | 200 | NULL | - | - | - | - |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| etl_time | ETL 同步时间 | TIMESTAMP | - | NULL | NULL | - | - | - |

### 9.4.2 订单表（crm_order）

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 |
|--------|-------------|----------|------|----------|--------|------|------|----------|
| order_id | 订单ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - |
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | - | FOREIGN KEY → crm_customer | - |
| order_code | 订单编码 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | - |
| order_type | 订单类型 | VARCHAR | 20 | NULL | NORMAL | - | - | NORMAL-普通, VIP-VIP客户, GROUP-团购 |
| order_status | 订单状态 | VARCHAR | 20 | NULL | PENDING | - | - | PENDING-待支付, PAID-已支付, SHIPPED-已发货, COMPLETED-已完成, CANCELLED-已取消 |
| order_amount | 订单金额 | DECIMAL | 18,2 | NOT NULL | 0.00 | - | - | - |
| discount_amount | 优惠金额 | DECIMAL | 18,2 | NULL | 0.00 | - | - | - |
| actual_amount | 实际支付金额 | DECIMAL | 18,2 | NOT NULL | 0.00 | - | - | - |
| order_date | 下单日期 | DATE | - | NOT NULL | CURRENT_DATE | - | - | - |
| pay_time | 支付时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| ship_time | 发货时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| complete_time | 完成时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| etl_time | ETL 同步时间 | TIMESTAMP | - | NULL | NULL | - | - | - |

### 9.4.3 支付表（crm_payment）

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 |
|--------|-------------|----------|------|----------|--------|------|------|----------|
| payment_id | 支付ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - |
| order_id | 订单ID | VARCHAR | 50 | NOT NULL | - | - | FOREIGN KEY → crm_order | - |
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | - | FOREIGN KEY → crm_customer | - |
| payment_method | 支付方式 | VARCHAR | 20 | NULL | ONLINE | - | - | ONLINE-在线支付, OFFLINE-线下支付, TRANSFER-转账 |
| payment_status | 支付状态 | VARCHAR | 20 | NULL | PENDING | - | - | PENDING-待支付, SUCCESS-成功, FAILED-失败, REFUNDED-已退款 |
| payment_amount | 支付金额 | DECIMAL | 18,2 | NOT NULL | 0.00 | - | - | - |
| refund_amount | 退款金额 | DECIMAL | 18,2 | NULL | 0.00 | - | - | - |
| payment_time | 支付时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| refund_time | 退款时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| transaction_no | 交易流水号 | VARCHAR | 100 | NULL | - | - | - | - |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - |
| etl_time | ETL 同步时间 | TIMESTAMP | - | NULL | NULL | - | - | - |

### 9.4.4 联系人表（crm_contact）

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 |
|--------|-------------|----------|------|----------|--------|------|------|----------|
| contact_id | 联系人ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - |
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | - | FOREIGN KEY → crm_customer | - |
| contact_name | 联系人姓名 | VARCHAR | 100 | NOT NULL | - | - | - | - |
| contact_phone | 联系人电话 | VARCHAR | 50 | NULL | - | - | - | - |
| contact_email | 联系人邮箱 | VARCHAR | 200 | NULL | - | - | - | - |
| contact_position | 联系人职位 | VARCHAR | 100 | NULL | - | - | - | - |
| is_primary | 是否主联系人 | BOOLEAN | - | NULL | FALSE | - | - | - |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - |

### 9.4.5 地址表（crm_address）

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 |
|--------|-------------|----------|------|----------|--------|------|------|----------|
| address_id | 地址ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - |
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | - | FOREIGN KEY → crm_customer | - |
| contact_id | 联系人ID | VARCHAR | 50 | NULL | - | - | FOREIGN KEY → crm_contact | - |
| address_type | 地址类型 | VARCHAR | 20 | NULL | SHIPPING | - | - | SHIPPING-收货地址, BILLING-账单地址, CONTACT-联系地址 |
| province | 省份 | VARCHAR | 50 | NULL | - | - | - | - |
| city | 城市 | VARCHAR | 50 | NULL | - | - | - | - |
| district | 区县 | VARCHAR | 50 | NULL | - | - | - | - |
| detail_address | 详细地址 | VARCHAR | 500 | NULL | - | - | - | - |
| zip_code | 邮政编码 | VARCHAR | 20 | NULL | - | - | - | - |
| is_default | 是否默认地址 | BOOLEAN | - | NULL | FALSE | - | - | - |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - |

## 9.5 索引设计

### 9.5.1 客户表索引

| 索引名 | 字段 | 类型 | 说明 |
|--------|------|------|------|
| pk_crm_customer | customer_id | PRIMARY KEY | 主键索引 |
| uk_crm_customer_customer_code | customer_code | UNIQUE | 唯一索引 |
| idx_crm_customer_customer_status | customer_status | INDEX | 状态查询 |
| idx_crm_customer_customer_type | customer_type | INDEX | 类型查询 |
| idx_crm_customer_region | region | INDEX | 地区查询 |
| idx_crm_customer_create_time | create_time | INDEX | 创建时间查询 |

### 9.5.2 订单表索引

| 索引名 | 字段 | 类型 | 说明 |
|--------|------|------|------|
| pk_crm_order | order_id | PRIMARY KEY | 主键索引 |
| uk_crm_order_order_code | order_code | UNIQUE | 唯一索引 |
| idx_crm_order_customer_id | customer_id | INDEX | 客户关联 |
| idx_crm_order_order_status | order_status | INDEX | 状态查询 |
| idx_crm_order_order_date | order_date | INDEX | 日期查询 |
| idx_crm_order_customer_id_order_date | customer_id, order_date | INDEX | 组合索引 |

### 9.5.3 支付表索引

| 索引名 | 字段 | 类型 | 说明 |
|--------|------|------|------|
| pk_crm_payment | payment_id | PRIMARY KEY | 主键索引 |
| idx_crm_payment_order_id | order_id | INDEX | 订单关联 |
| idx_crm_payment_customer_id | customer_id | INDEX | 客户关联 |
| idx_crm_payment_payment_status | payment_status | INDEX | 状态查询 |
| idx_crm_payment_transaction_no | transaction_no | INDEX | 流水号查询 |

## 9.6 业务规则

### 9.6.1 客户规则

- 客户编码必须唯一
- 客户名称不能为空
- 客户状态默认为 ACTIVE
- 一个客户可以有多个联系人
- 一个客户可以有多个地址

### 9.6.2 订单规则

- 订单编码必须唯一
- 订单金额必须大于 0
- 实际支付金额 = 订单金额 - 优惠金额
- 订单状态流转：PENDING → PAID → SHIPPED → COMPLETED 或 CANCELLED
- 已取消的订单不能重新支付

### 9.6.3 支付规则

- 支付金额必须等于订单实际支付金额
- 支付状态流转：PENDING → SUCCESS 或 FAILED → REFUNDED（仅 SUCCESS 状态）
- 退款金额不能超过支付金额

## 9.7 待确认事项

1. CRM 业务模块边界【待确认】
2. 是否需要添加产品表（crm_product）【待确认】
3. 是否需要添加订单明细表（crm_order_item）【待确认】
4. 是否需要添加营销活动表（crm_marketing）【待确认】
5. 是否需要添加服务工单表（crm_service）【待确认】
