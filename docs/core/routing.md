# 路由语义表（Routing）

> 层级：L0 CORE
> 版本：v1.0
> 用途：与 `skill/crm-development-router` 对齐的请求→流程判定表。执行器按本表路由，禁止直接读整目录 docs/。

## 1. 请求分类与路由

| 请求类型 | 触发语义（含但不限于） | 路由结果 |
|----------|------------------------|----------|
| 只读分析/问答 | 分析、扫描、查看、校验、对比且未要求修改 | `read_only`，不创建写任务 |
| 需求开发 | 需求开发、业务需求、需求文档、业务规则、目标表开发、生成/修改存储过程 | `requirement_development` |
| 表结构变更 | 表结构变更、Mapping Excel 变更、同步 Excel、MD/DD/数据字典对齐、字段结构同步 | `schema_change` |
| 歧义/无法唯一判断 | 以上信号同时出现或语义不清 | 停止并请求澄清（I-11） |

路由优先级：两流程信号并存 → 先 `requirement_development`，`schema_change` 作为后续任务；单一信号 → 对应流程；仅只读信号 → `read_only`。

## 2. 流程 profile 与阶段序列

### 2.1 requirement_development（对应 Skill：crm-requirement-development）

```text
ROUTE → REQUIREMENT_ANALYSIS → SCOPE_CONFIRM → IMPLEMENT_PROCEDURE → REVIEW → VALIDATE → COMMIT
```

阶段门禁与证据定义见 `.harness/policies/phase_gates.yaml`；最小加载上下文见 `.harness/config/phase_context.yaml`。

### 2.2 schema_change（对应 Skill：crm-schema-change）

```text
ROUTE → CHANGE_SCOPE → ASSETS_UPDATE → REVIEW → VALIDATE → COMMIT
```

### 2.3 read_only

不创建 Harness 写任务；只做分析、校验，遵守 I-02（只读范围内执行）。

## 3. 加载策略

- 会话启动必载：`docs/core/invariants.md`、`docs/core/output_contract.md`、本文件。
- 写流程进入对应 Skill 后，按 `.harness/config/phase_context.yaml` 加载当前 phase 的最小上下文。
- 校验/Review 阶段只加载失败相关规则 ID 与脚本输出摘要。
- `docs/lessons/`（L4）默认不加载；`docs/domain/`、`docs/examples/` 按需加载。
