# Kingbase CRM AI Development Guide

> 企业级 AI 编程规范库，适用于 ChatGPT / Cursor / Claude Code / GitHub Copilot

**项目类型**: AI 编程工具规范库
**当前版本**: v2.1（规则精简与合并 · Token 优化）
**最后更新时间**: 2026-08-12

## 📋 项目简介

本项目是 CRM 数据开发的规范与门禁仓库，目标是把需求、Mapping、数据字典、SQL、存储过程、ETL 和发布门禁收敛到一套可执行流程里。

## AI 最小启动集（Token 优化）

会话启动时只加载：

1. [docs/core/invariants.md](docs/core/invariants.md)
2. [docs/core/output_contract.md](docs/core/output_contract.md)
3. [docs/core/routing.md](docs/core/routing.md)

然后通过 Skill 路由：

- `skill/crm-development-router`
- `skill/crm-requirement-development`
- `skill/crm-schema-change`

阶段最小加载上下文见 [.harness/config/phase_context.yaml](.harness/config/phase_context.yaml)。

## 主要入口

* 当前开发指南： [docs/offline-first-development.md](docs/offline-first-development.md)
* 项目执行流程： [docs/11_Project_SOP.md](docs/11_Project_SOP.md)
* 执行规则 [docs/16_Execution_Rules.md](docs/16_Execution_Rules.md)
* CI 和分支治理： [docs/16_CI_闭环操作说明.md](docs/16_CI_闭环操作说明.md)
* SQL / 存储过程 / 数据字典规范： [docs/02_SQL_Standard.md](docs/02_SQL_Standard.md) 、 [docs/05_Stored_Procedure.md](docs/05_Stored_Procedure.md) 、 [docs/07_Data_Dictionary.md](docs/07_Data_Dictionary.md) 、 [docs/08_Mapping.md](docs/08_Mapping.md)
* 质检规则 ID： [docs/quality_rules.md](docs/quality_rules.md)
* 错误案例（默认不加载）： [docs/lessons/](docs/lessons/)

## 当前约束

* 先确认业务和来源，再写 SQL 或存储过程。
* 任何字段、表结构、规则不确定时，必须标记为 `unresolved` 或 `【待确认】`（I-01）。
* 所有可修改内容必须能追溯到需求、字典或 Mapping（I-05）。
* 提交和推送前必须通过本地门禁与 Harness 校验（I-10）。
* 输出遵守 `docs/core/output_contract.md` 短格式（I-12）。

## 目录说明

* `docs/core/` ：L0 最小核心，包含不变量、输出合同与路由语义表
* `docs/` ：规范、流程与质检说明
* `docs/lessons/` ：错误案例（默认不加载）
* `data_assets/` ：DDL、字典、Mapping、ETL 资产
* `requirements/` ：需求文档与记忆卡片
* `scripts/` ：校验、生成与门禁脚本
* `skill/` ：执行真源 Skill
* `hooks/` ：Git 钩子
* `.github/` ：CI 配置
* `.harness/config/phase_context.yaml` ：阶段最小加载配置

## 📄 License

MIT License
