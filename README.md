# Kingbase CRM AI Development Guide

> 企业级 AI 编程规范库，适用于 ChatGPT / Cursor / Claude Code / GitHub Copilot

**项目类型**: AI 编程工具规范库  
**当前版本**: v2.0（冻结规划版）  
**最后更新时间**: 2026-07-17

## 📋 项目简介

本项目是 CRM 数据开发的规范与门禁仓库，目标是把需求、Mapping、数据字典、SQL、存储过程、ETL 和发布门禁收敛到一套可执行流程里。

## 主要入口

- 当前开发指南：`docs/offline-first-development.md`
- 项目执行流程：`docs/11_Project_SOP.md`
- CI 和分支治理：`docs/16_CI_闭环操作说明.md`
- SQL / 存储过程 / 数据字典规范：`docs/02_SQL_Standard.md`、`docs/05_Stored_Procedure.md`、`docs/07_Data_Dictionary.md`、`docs/08_Mapping.md`

## 当前约束

- 先确认业务和来源，再写 SQL 或存储过程。
- 任何字段、表结构、规则不确定时，必须标记为 `unresolved` 或 `【待确认】`。
- 所有可修改内容必须能追溯到需求、字典或 Mapping。
- 提交和推送前必须通过本地门禁与 Harness 校验。

## 目录说明

- `docs/`：规范与流程说明
- `data_assets/`：DDL、字典、Mapping、ETL 资产
- `requirements/`：需求文档与记忆卡片
- `scripts/`：校验、生成与门禁脚本
- `hooks/`：Git 钩子
- `.github/`：CI 配置

## 📄 License

MIT License
