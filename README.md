# Kingbase CRM AI Development Guide

> 企业级 AI 编程规范库，适用于 ChatGPT / Cursor / Claude Code / GitHub Copilot

**项目类型**: AI 编程工具规范库  
**当前版本**: v2.0（冻结规划版）  
**最后更新时间**: 2026-07-17

## 📋 项目简介

本项目旨在建立一套统一的 AI 编程规范库，使 AI 在整个 CRM 数据开发过程中保持一致的开发思路、输出格式和质量标准。

### 核心目标

- ✅ 保证 SQL、存储过程、ETL、Mapping、数据字典的一致性
- ✅ 保证 AI 输出可维护、可追溯、可 Review
- ✅ 降低 AI 幻觉（Hallucination）
- ✅ 形成可长期维护的 Git 知识库
- ✅ 建立统一的数据开发 SOP

## 📁 目录结构

```
Kingbase-CRM-AI-Development-Guide
├── README.md
├── CHANGELOG.md
├── docs/                      # 核心规范文档（已冻结，12个）
│   ├── 01_AI_SOP.md          # AI 工作流程规范
│   ├── 02_SQL_Standard.md    # SQL 编码规范
│   ├── 03_SQL_Performance.md # SQL 性能优化指南
│   ├── 04_Kingbase_Guide.md  # Kingbase 数据库指南
│   ├── 05_Stored_Procedure.md# 存储过程规范
│   ├── 06_ETL_Standard.md    # ETL 规范
│   ├── 07_Data_Dictionary.md # 数据字典规范
│   ├── 08_Mapping.md         # Mapping 规范
│   ├── 09_CRM_Model.md       # CRM 数据模型
│   ├── 10_Code_Review.md     # Code Review 规范
│   ├── 11_Project_SOP.md     # 项目 SOP
│   └── 12_AI_Prompts.md      # AI 提示词模板
├── data_assets/               # 数据资产（新增）
│   ├── ddl/                  # DDL 建表脚本
│   │   ├── ods/              # ODS 层
│   │   ├── dwd/              # DWD 层
│   │   ├── dws/              # DWS 层
│   │   └── ads/              # ADS 层
│   ├── data_dictionary/      # 数据字典
│   │   ├── source/           # 上游系统数据字典
│   │   ├── ods/              # ODS 层数据字典
│   │   ├── dwd/              # DWD 层数据字典
│   │   ├── dws/              # DWS 层数据字典
│   │   └── ads/              # ADS 层数据字典
│   ├── mapping/              # Mapping 文件
│   │   ├── ods_to_dwd/       # ODS → DWD Mapping
│   │   ├── dwd_to_dws/       # DWD → DWS Mapping
│   │   └── dws_to_ads/       # DWS → ADS Mapping
│   └── etl/                  # ETL 脚本
│       ├── ods_to_dwd/       # ODS → DWD ETL
│       ├── dwd_to_dws/       # DWD → DWS ETL
│       └── dws_to_ads/       # DWS → ADS ETL
├── requirements/              # 需求文档（新增）
│   └── *.md                   # 需求文档、规格说明书
├── templates/                 # 模板文件
├── examples/                  # 示例代码
├── checklists/                # 检查清单
├── prompts/                   # AI 提示词
└── temp/                      # 临时文件（新增，已忽略）
    ├── logs/                  # 日志文件
    ├── scripts/               # 临时脚本
    └── outputs/               # 执行输出
```

## 🚀 快速开始

### AI 工作流

所有 AI 工具统一执行以下流程：

1. **理解业务需求** → 2. **检查缺失信息** → 3. **输出设计方案** → 4. **编写代码** → 5. **Explain Plan 分析** → 6. **性能优化** → 7. **风险分析** → 8. **Code Review** → 9. **输出最终结果**

### 项目开发流程

```
需求分析 → 需求确认 → 数据分析 → 数据字典确认 → Mapping设计 → SQL设计 → 存储过程设计 → ETL设计 → Explain分析 → Code Review → 测试 → 上线
```

## ⚠️ 核心原则

| 原则 | 说明 |
|------|------|
| 业务优先 | 先理解业务，再设计方案，禁止直接编写 SQL |
| 准确性优先 | 不允许猜测字段、表结构、业务规则，不确定内容使用【待确认】标记 |
| 可追溯原则 | Mapping、数据字典、SQL 必须标明来源 |
| 生产环境原则 | 默认所有代码运行于生产环境，必须考虑性能、事务、锁、日志、异常 |
| 统一输出原则 | 所有 AI 输出遵循统一模板 |

## 🔒 最高保护对象

- **数据字典** - 数据的唯一真实来源
- **Mapping** - 字段转换的唯一记录
- **SQL** - 业务逻辑的实现载体
- **存储过程** - 复杂业务逻辑的封装

任何修改必须保持一致性与可追溯性（Traceability）。

## 📊 版本管理

| 版本 | 状态 | 说明 |
|------|------|------|
| v2.0 | 冻结规划版 | 当前版本 |
| v2.1 | 待开发 | 内容完善 |
| v2.2 | 待开发 | 案例补充 |
| v3.0 | 【待确认】 | 后续规划 |

## 📝 待确认事项

1. CRM 业务模块边界【待确认】
2. 数据库版本及补丁级别【待确认】
3. 数据同步方式（CDC / 定时 / MQ）【待确认】
4. 日志框架标准【待确认】
5. Explain Plan 输出模板【待确认】
6. 存储过程统一异常码【待确认】
7. Mapping 模板字段是否需要扩展【待确认】
8. 数据字典维护责任人【待确认】
9. 项目发布流程细节【待确认】
10. 自动化 Review 工具接入方案【待确认】

## 📄 License

MIT License
