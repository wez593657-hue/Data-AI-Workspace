# 数据资产目录（data_assets）

## 目录概述

本目录存放 CRM 数据仓库各层的实际数据资产，包括 DDL 脚本、Mapping 文件和 ETL 脚本。

## 目录结构

```
data_assets/
├── ddl/                    # DDL 建表脚本
│   ├── ods/               # ODS 层（原始数据层）
│   ├── dwd/               # DWD 层（明细数据层）
│   ├── dws/               # DWS 层（汇总数据层）
│   └── ads/               # ADS 层（应用数据层）
│
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



### Mapping 文件

支持两种命名方式：

**中文汇总命名**（适用于包含多个表映射的文档）：
- `ods到dwd映射.md`
- `dwd到dws映射.md`
- `dws到ads映射.md`

**英文单表命名**（适用于单表映射文档）：
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

## 使用流程

### 1. 新增上游系统表

```
1. 创建 ODS 层 DDL: data_assets/ddl/ods/ods_{系统}_{表名}.sql
```

### 2. ODS → DWD 转换

```
1. 创建 Mapping: data_assets/mapping/ods_to_dwd/ods_to_dwd_{系统}_{表名}_mapping.md
2. 创建 DWD 层 DDL: data_assets/ddl/dwd/dwd_{业务域}_{表名}.sql
3. 创建 ETL 脚本: data_assets/etl/ods_to_dwd/ods_to_dwd_{系统}_{表名}_etl.sql
```

### 3. DWD → DWS 转换

```
1. 创建 Mapping: data_assets/mapping/dwd_to_dws/dwd_to_dws_{业务域}_{表名}_mapping.md
2. 创建 DWS 层 DDL: data_assets/ddl/dws/dws_{业务域}_{表名}_{周期}.sql
3. 创建 ETL 脚本: data_assets/etl/dwd_to_dws/dwd_to_dws_{业务域}_{表名}_etl.sql
```

### 4. DWS → ADS 转换

```
1. 创建 Mapping: data_assets/mapping/dws_to_ads/dws_to_ads_{业务域}_{表名}_mapping.md
2. 创建 ADS 层 DDL: data_assets/ddl/ads/ads_{业务域}_{表名}.sql
3. 创建 ETL 脚本: data_assets/etl/dws_to_ads/dws_to_ads_{业务域}_{表名}_etl.sql
```

## 一致性检查

| 检查项 | 说明 |
|--------|------|
| Mapping 一致性 | Mapping 转换规则与 ETL 脚本一致 |
| DDL 一致性 | DDL 字段与 Mapping 一致 |
| 命名一致性 | 表名、字段名遵循统一命名规范 |
| 可追溯性 | 每个字段可追溯到上游来源 |

## 更新流程

```
1. 更新 ODS → DWD Mapping → 更新 DWD 层 DDL
2. 更新 DWD → DWS Mapping → 更新 DWS 层 DDL
3. 更新 DWS → ADS Mapping → 更新 ADS 层 DDL
4. 更新相关 ETL 脚本
5. 提交 Git
```

> 注：数据字典已废弃，字段事实以 Mapping Excel 为最高权威源；DDL 与 Mapping 的一致性由校验脚本统一检查。

## 核心原则

> **任何修改必须保持一致性与可追溯性（Traceability）。**
> 
> **数据字典、Mapping、SQL、存储过程为项目最高保护对象。**
