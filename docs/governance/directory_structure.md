# 目录职责治理

> 层级：L1 治理流程
> 版本：v1.0
> 状态：ACTIVE
> 适用范围：仓库内项目文档、业务资产、验证和任务证据的目录职责。

## 1. 实际目录结构

```text
README.md
AGENTS.md
├── docs/
│   ├── core/          L0 不变量、输出合同、路由与治理总览
│   ├── governance/    L1 变更、审批、发布、RACI、生命周期与权威来源
│   ├── analysis/      离线分析材料
│   ├── changes/       已记录的变更说明
│   ├── lessons/       历史经验
│   └── standards/     专项技术或测试策略
├── governance/        L3 日期参数、参考逻辑、TMP 专项技术规则
├── requirements/      业务需求、规则记忆卡片、口径与需求附件
├── data_assets/
│   ├── mapping/       正式字段 Mapping
│   ├── ddl/           DDL
│   ├── stored_procedure/ 正式存储过程
│   ├── reference_logic/ 参考实现逻辑
│   └── etl/           正式 ETL（存在时）
├── validation/        离线规则、夹具、期望结果和参考实现
├── templates/         受控模板
├── scripts/           工具与 Harness 实现
├── .harness/          任务、政策、配置与证据
└── .github/           CI 工作流
```

未列出的目录必须先经审计确认职责，禁止按目标蓝图假设其已存在。

## 2. 层级与读取顺序

| 层级 | 目录或资产 | 用途 |
|---|---|---|
| L0 | `docs/core/` | 全局不变量、输出合同和路由 |
| L1 | `docs/governance/`、`.harness/policies/` | 治理流程和可执行门禁 |
| L2 | `docs/02_SQL_Standard.md`、`docs/05_Stored_Procedure.md`、`docs/07_Data_Dictionary.md`、`docs/08_Mapping.md`、`governance/` | 技术规范与专项规则 |
| L3 | `requirements/`、`data_assets/`、`validation/` | 已确认业务事实、资产和离线验证 |
| L4 | `docs/analysis/`、`docs/changes/`、`docs/lessons/` | 审计、变更记录和经验 |

根目录 `governance/` 与 `docs/governance/` 名称相近但职责不同：前者是 L2/L3 专项技术规则，后者是 L1 流程治理。禁止将二者自动合并、移动或删除。

## 3. 目录变更规则

1. 目录迁移、合并、删除或重命名必须作为独立治理 Change，先完成引用扫描和逐文件影响分析。
2. `requirements/`、`data_assets/`、`validation/` 属于业务/验证资产目录，治理任务不得借目录规范名义修改其内容。
3. `.github/`、`hooks/`、`.harness/` 为高风险控制面；任何恢复或修改均需独立白名单和用户确认。
4. 运行产物和备份即使未跟踪，也不能因目录规则自动删除。

## 4. 目录健康检查边界

自动检查可以检查路径职责、未知目录、候选重复和受控文档链接；不得：

- 自动建立方案中不存在的目录；
- 自动移动或删除文件；
- 仅依据文件名判断业务权威性；
- 将历史材料误报为业务资产冲突。
