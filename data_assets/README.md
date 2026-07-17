# 数据资产目录（data_assets）

## 目录概述

本目录存放 CRM 数据仓库各层的实际数据资产，包括 DDL 脚本、数据字典、Mapping 文件和 ETL 脚本。

## 目录结构

```
data_assets/
├── ddl/                    # DDL 建表脚本
│   ├── ods/               # ODS 层（原始数据层）
│   ├── dwd/               # DWD 层（明细数据层）
│   ├── dws/               # DWS 层（汇总数据层）
│   └── ads/               # ADS 层（应用数据层）
│
├── data_dictionary/       # 数据字典
│   ├── source/            # 上游系统数据字典
│   ├── ods/               # ODS 层数据字典
│   ├── dwd/               # DWD 层数据字典
│   ├── dws/               # DWS 层数据字典
│   └── ads/               # ADS 层数据字典
│
├── mapping/               # Mapping 文件
│   ├── ods_to_dwd/        # ODS → DWD Mapping
│   ├── dwd_to_dws/        # DWD → DWS Mapping
│   └── dws_to_ads/        # DWS → ADS Mapping
│
└── etl/                   # ETL 脚本
    ├── ods_to_dwd/        # ODS → DWD ETL
    ├── dwd_to_dws/        # DWD → DWS ETL
    └── dws_to_ads/        # DWS → ADS ETL
```

## 数据分层说明

| 层级 | 名称 | 说明 | 数据特点 |
|------|------|------|----------|
| **ODS** | 原始数据层 | 原始数据落地，不做清洗 | 保留原始格式，字段名与上游一致 |
| **DWD** | 明细数据层 | 清洗、去重、过滤脏数据 | 业务主键完整，字段标准化 |
| **DWS** | 汇总数据层 | 按维度轻度聚合 | 按天/周/月汇总，支持快速查询 |
| **ADS** | 应用数据层 | 面向业务指标 | 最终报表、仪表盘数据源 |

## 文件命名规范

### DDL 文件

```
{层级前缀}_{业务域}_{表名}.sql
```

示例:
- `ods_sap_customer.sql`
- `dwd_crm_customer.sql`
- `dws_crm_customer_daily.sql`
- `ads_crm_customer_report.sql`

### 数据字典文件

```
{层级前缀}_{业务域}_{表名}_dd.md
```

示例:
- `ods_sap_customer_dd.md`
- `dwd_crm_customer_dd.md`
- `dws_crm_customer_daily_dd.md`
- `ads_crm_customer_report_dd.md`

### Mapping 文件

```
{来源层级}_{目标层级}_{业务域}_{表名}_mapping.md
```

示例:
- `ods_to_dwd_sap_customer_mapping.md`
- `dwd_to_dws_crm_customer_mapping.md`
- `dws_to_ads_crm_report_mapping.md`

### ETL 文件

```
{来源层级}_{目标层级}_{业务域}_{表名}_etl.sql
```

示例:
- `ods_to_dwd_sap_customer_etl.sql`
- `dwd_to_dws_crm_customer_etl.sql`
- `dws_to_ads_crm_report_etl.sql`

## 上游系统数据字典

### 存放位置

```
data_assets/data_dictionary/source/
```

### 命名规范

```
source_{系统名称}_{表名}_dd.md
```

示例:
- `source_sap_customer_dd.md`
- `source_core_banking_account_dd.md`
- `source_mobile_banking_transaction_dd.md`

### 内容要求

| 字段名 | 说明 | 示例 |
|--------|------|------|
| 系统名称 | 上游系统名称 | `SAP` |
| 表名 | 上游系统表名 | `S_CUSTOMER` |
| 中文名称 | 表的中文描述 | `客户信息表` |
| 字段名 | 上游字段名 | `CUST_ID` |
| 字段中文说明 | 字段描述 | `客户ID` |
| 数据类型 | 上游数据类型 | `VARCHAR(50)` |
| 长度 | 字段长度 | `50` |
| 是否为空 | 是否允许为空 | `NOT NULL` |
| 默认值 | 字段默认值 | `NULL` |
| 主键 | 是否为主键 | `PRIMARY KEY` |
| 业务含义 | 字段的业务含义 | `客户唯一标识` |

## 使用流程

### 1. 新增上游系统表

```
1. 创建上游数据字典: data_assets/data_dictionary/source/source_{系统}_{表名}_dd.md
2. 创建 ODS 层 DDL: data_assets/ddl/ods/ods_{系统}_{表名}.sql
3. 创建 ODS 数据字典: data_assets/data_dictionary/ods/ods_{系统}_{表名}_dd.md
```

### 2. ODS → DWD 转换

```
1. 创建 Mapping: data_assets/mapping/ods_to_dwd/ods_to_dwd_{系统}_{表名}_mapping.md
2. 创建 DWD 层 DDL: data_assets/ddl/dwd/dwd_{业务域}_{表名}.sql
3. 创建 DWD 数据字典: data_assets/data_dictionary/dwd/dwd_{业务域}_{表名}_dd.md
4. 创建 ETL 脚本: data_assets/etl/ods_to_dwd/ods_to_dwd_{系统}_{表名}_etl.sql
```

### 3. DWD → DWS 转换

```
1. 创建 Mapping: data_assets/mapping/dwd_to_dws/dwd_to_dws_{业务域}_{表名}_mapping.md
2. 创建 DWS 层 DDL: data_assets/ddl/dws/dws_{业务域}_{表名}_{周期}.sql
3. 创建 DWS 数据字典: data_assets/data_dictionary/dws/dws_{业务域}_{表名}_{周期}_dd.md
4. 创建 ETL 脚本: data_assets/etl/dwd_to_dws/dwd_to_dws_{业务域}_{表名}_etl.sql
```

### 4. DWS → ADS 转换

```
1. 创建 Mapping: data_assets/mapping/dws_to_ads/dws_to_ads_{业务域}_{表名}_mapping.md
2. 创建 ADS 层 DDL: data_assets/ddl/ads/ads_{业务域}_{表名}.sql
3. 创建 ADS 数据字典: data_assets/data_dictionary/ads/ads_{业务域}_{表名}_dd.md
4. 创建 ETL 脚本: data_assets/etl/dws_to_ads/dws_to_ads_{业务域}_{表名}_etl.sql
```

## 一致性检查

| 检查项 | 说明 |
|--------|------|
| 数据字典一致性 | 各层数据字典字段定义一致 |
| Mapping 一致性 | Mapping 转换规则与 ETL 脚本一致 |
| DDL 一致性 | DDL 字段与数据字典一致 |
| 命名一致性 | 表名、字段名遵循统一命名规范 |
| 可追溯性 | 每个字段可追溯到上游来源 |

## 更新流程

```
1. 修改上游数据字典 → 更新 ODS 数据字典
2. 更新 ODS → DWD Mapping → 更新 DWD 数据字典
3. 更新 DWD → DWS Mapping → 更新 DWS 数据字典
4. 更新 DWS → ADS Mapping → 更新 ADS 数据字典
5. 更新相关 ETL 脚本
6. 更新 CHANGELOG.md
7. 提交 Git
```

## 核心原则

> **任何修改必须保持一致性与可追溯性（Traceability）。**
> 
> **数据字典、Mapping、SQL、存储过程为项目最高保护对象。**
