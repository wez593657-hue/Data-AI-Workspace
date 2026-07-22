# 07 数据字典规范

## 7.1 概述

数据字典是数据库中所有表和字段的唯一真实来源，是项目最高保护对象。任何修改必须保持一致性与可追溯性。

## 7.2 数据字典必须包含的字段

| 字段名 | 说明 | 示例 |
|--------|------|------|
| 表名 | 数据库表名称 | `crm_customer` |
| 中文名称 | 表的中文描述 | `客户信息表` |
| 字段名 | 字段名称 | `customer_id` |
| 字段中文说明 | 字段的中文描述 | `客户ID` |
| 数据类型 | 字段数据类型 | `VARCHAR(50)` |
| 长度 | 字段长度 | `50` |
| 是否为空 | 是否允许为空 | `NOT NULL` |
| 默认值 | 字段默认值 | `NULL` |
| 主键 | 是否为主键 | `PRIMARY KEY` |
| 外键 | 是否为外键及关联表 | `FOREIGN KEY → crm_order` |
| 枚举说明 | 枚举值说明 | `ACTIVE-活跃, INACTIVE-停用` |
| 数据来源 | 数据来源系统 | `SAP/自研系统` |
| 负责人 | 字段负责人 | 【待确认】 |
| 更新时间 | 最后更新时间 | `2024-01-15` |

## 7.3 数据字典模板

### 7.3.1 表级别模板

```text
========================================
表名: crm_customer
中文名称: 客户信息表
========================================
描述: 存储客户基本信息
数据来源: SAP系统
负责人: 【待确认】
更新时间: 2024-01-15

字段列表:
```

### 7.3.2 字段级别模板

| 字段名 | 字段中文说明 | 数据类型 | 长度 | 是否为空 | 默认值 | 主键 | 外键 | 枚举说明 | 数据来源 | 负责人 | 更新时间 |
|--------|-------------|----------|------|----------|--------|------|------|----------|----------|--------|----------|
| customer_id | 客户ID | VARCHAR | 50 | NOT NULL | - | PRIMARY KEY | - | - | SAP | 【待确认】 | 2024-01-15 |
| customer_name | 客户名称 | VARCHAR | 200 | NOT NULL | - | - | - | - | SAP | 【待确认】 | 2024-01-15 |
| customer_code | 客户编码 | VARCHAR | 50 | NOT NULL | - | UNIQUE | - | - | SAP | 【待确认】 | 2024-01-15 |
| customer_status | 客户状态 | VARCHAR | 20 | NULL | ACTIVE | - | - | ACTIVE-活跃, INACTIVE-停用, UNKNOWN-未知 | SAP | 【待确认】 | 2024-01-15 |
| create_time | 创建时间 | TIMESTAMP | - | NOT NULL | NOW() | - | - | - | 系统自动 | 【待确认】 | 2024-01-15 |
| update_time | 更新时间 | TIMESTAMP | - | NULL | NULL | - | - | - | 系统自动 | 【待确认】 | 2024-01-15 |

## 7.4 命名规范

### 7.4.1 表命名规则

| 类型 | 前缀 | 示例 |
|------|------|------|
| 业务表 | `crm_` | `crm_customer`, `crm_order` |
| 维度表 | `dim_` | `dim_product`, `dim_region` |
| 事实表 | `fact_` | `fact_sales`, `fact_payment` |
| 中间表 | `mid_` | `mid_customer_order` |
| 日志表 | `log_` | `log_customer_operation` |
| 会话临时表 | `temp_` | `temp_customer_batch` | `CREATE TEMP TABLE`，会话结束自动删除 |
| 物理临时表 | `TMP_` | `TMP_CRM_ORDER_PENDING` | `CREATE TABLE IF NOT EXISTS`，存储过程中使用，需手动清理 |

### 7.4.5 数据分层命名规则

数据仓库采用分层架构，各层表命名遵循以下规则：

| 层级 | 名称 | 前缀 | 说明 | 示例 |
|------|------|------|------|------|
| **ODS** | 原始数据层 | `ods_` | 原始数据落地，保留上游格式 | `ods_sap_customer`, `ods_core_banking_account` |
| **DWD** | 明细数据层 | `dwd_` | 清洗去重后的业务明细 | `dwd_crm_customer`, `dwd_crm_order` |
| **DWS** | 汇总数据层 | `dws_` | 按维度轻度聚合 | `dws_crm_customer_daily`, `dws_crm_order_monthly` |
| **ADS** | 应用数据层 | `ads_` | 面向业务指标的报表数据 | `ads_crm_customer_report`, `ads_crm_sales_dashboard` |

**分层命名格式**:

```
{层级前缀}_{业务域}_{表名}_{周期(可选)}
```

示例:
- `ods_sap_customer` - ODS层 SAP客户表
- `dwd_crm_customer` - DWD层 CRM客户明细表
- `dws_crm_customer_daily` - DWS层 CRM客户日汇总表
- `ads_crm_customer_report` - ADS层 CRM客户报表表

### 7.4.6 数据分层目录结构

数据资产统一存放在 `data_assets/` 目录下：

```
data_assets/
├── ddl/                    # DDL 建表脚本
│   ├── ods/               # ODS 层
│   ├── dwd/               # DWD 层
│   ├── dws/               # DWS 层
│   └── ads/               # ADS 层
├── data_dictionary/       # 数据字典
│   ├── source/            # 上游系统数据字典
│   ├── ods/               # ODS 层数据字典
│   ├── dwd/               # DWD 层数据字典
│   ├── dws/               # DWS 层数据字典
│   └── ads/               # ADS 层数据字典
├── mapping/               # Mapping 文件
│   ├── ods_to_dwd/        # ODS → DWD Mapping
│   ├── dwd_to_dws/        # DWD → DWS Mapping
│   └── dws_to_ads/        # DWS → ADS Mapping
└── etl/                   # ETL 脚本
    ├── ods_to_dwd/        # ODS → DWD ETL
    ├── dwd_to_dws/        # DWD → DWS ETL
    └── dws_to_ads/        # DWS → ADS ETL
```

### 7.4.2 字段命名规则

| 类型 | 规则 | 示例 |
|------|------|------|
| 主键 | `表名_id` | `customer_id`, `order_id` |
| 外键 | `关联表名_id` | `customer_id`（在 order 表中） |
| 名称 | `*_name` | `customer_name`, `product_name` |
| 编码 | `*_code` | `customer_code`, `product_code` |
| 状态 | `*_status` | `order_status`, `payment_status` |
| 金额 | `*_amount` | `order_amount`, `payment_amount` |
| 时间 | `*_time` | `create_time`, `update_time`, `order_time` |
| 数量 | `*_count` | `order_count`, `product_count` |
| 描述 | `*_desc` | `order_desc`, `product_desc` |

### 7.4.3 数据类型统一

| 用途 | 推荐类型 | 说明 |
|------|----------|------|
| ID/编码 | VARCHAR(50) | 统一使用字符串类型 |
| 名称 | VARCHAR(200) | 最大长度 200 |
| 描述 | VARCHAR(1000) | 最大长度 1000 |
| 状态 | VARCHAR(20) | 枚举值 |
| 金额 | DECIMAL(18,2) | 两位小数 |
| 整数 | INT | 普通整数 |
| 大整数 | BIGINT | 超过 INT 范围 |
| 日期 | DATE | 仅日期 |
| 时间戳 | TIMESTAMP | 日期+时间 |
| 布尔 | BOOLEAN | 真/假 |

### 7.4.4 审计字段标准

所有业务表必须包含以下审计字段：

| 字段名 | 字段中文说明 | 数据类型 | 是否为空 | 默认值 | 说明 |
|--------|-------------|----------|----------|--------|------|
| create_time | 创建时间 | TIMESTAMP | NOT NULL | NOW() | 记录数据首次创建时间，由系统自动生成 |
| update_time | 更新时间 | TIMESTAMP | NULL | NULL | 记录数据最后更新时间，更新操作时自动更新 |
| etl_time | ETL 同步时间 | TIMESTAMP | NULL | NULL | 记录 ETL 同步时的时间，仅用于从外部系统同步的数据表 |

**审计字段使用规则：**

| 规则 | 说明 |
|------|------|
| create_time | 所有业务表必须包含，默认值为 NOW()，禁止手动修改 |
| update_time | 所有业务表必须包含，更新操作时设置为 NOW() |
| etl_time | 仅用于从外部系统同步的数据表，标识数据的同步时间点 |
| 命名规范 | 统一使用 `create_time`、`update_time`、`etl_time`，禁止使用其他命名 |
| 数据类型 | 统一使用 TIMESTAMP 类型 |

## 7.5 数据字典管理规范

### 7.5.1 创建流程

```
需求分析 → 表设计 → 字段定义 → 数据字典编写 → 审核确认 → 入库
```

### 7.5.2 修改流程

```
变更申请 → 影响评估 → 数据字典更新 → Mapping 更新 → SQL 更新 → 审核确认 → 上线
```

### 7.5.3 版本控制

```text
数据字典版本: v1.0
变更记录:
- 2024-01-15: 初始创建
- 2024-02-20: 添加 customer_phone 字段
- 2024-03-10: 修改 customer_status 枚举值
```

## 7.6 数据字典与其他文档的关系

```
数据字典
    │
    ├── 映射到 Mapping（08_Mapping.md）
    │       └── 每个字段必须有对应的 Mapping 记录
    │
    ├── 映射到 SQL（02_SQL_Standard.md）
    │       └── SQL 中的字段必须与数据字典一致
    │
    └── 映射到 ETL（06_ETL_Standard.md）
            └── ETL 中的字段转换必须与数据字典一致
```

## 7.7 数据字典检查清单

| 检查项 | 检查内容 | 状态 |
|--------|----------|------|
| 命名规范 | 表名和字段名是否符合命名规则 | ✅/❌ |
| 数据类型 | 数据类型是否统一 | ✅/❌ |
| 非空约束 | 是否正确设置非空约束 | ✅/❌ |
| 主键 | 是否设置主键 | ✅/❌ |
| 外键 | 是否正确设置外键关联 | ✅/❌ |
| 默认值 | 默认值是否合理 | ✅/❌ |
| 枚举说明 | 枚举字段是否有说明 | ✅/❌ |
| 数据来源 | 是否标明数据来源 | ✅/❌ |
| 重复定义 | 是否存在重复字段定义 | ✅/❌ |
| Mapping 同步 | 是否与 Mapping 保持一致 | ✅/❌ |

## 7.8 禁止事项

- ❌ 禁止字段命名不统一
- ❌ 禁止数据类型不统一
- ❌ 禁止出现重复定义
- ❌ 禁止修改数据字典不同步更新 Mapping
- ❌ 禁止在 SQL 中使用未在数据字典中定义的字段
- ❌ 禁止猜测字段含义，必须查看数据字典
