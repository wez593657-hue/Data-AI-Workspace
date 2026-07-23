# CRM Process Skill Registry

| Profile | Process skill | Route when the command includes | Do not route when |
|---|---|---|---|
| `requirement_development` | `crm-requirement-development` | 需求开发、业务需求、需求文档、业务规则、目标表开发、生成/修改存储过程 | The request only asks to scan, compare, or validate |
| `schema_change` | `crm-schema-change` | 表结构变更、Mapping Excel 变更、同步 Excel、MD/DD/数据字典对齐、字段结构同步 | The request only asks for read-only analysis |
| `read_only` | No process skill | 分析、扫描、查看、校验、对比且未要求修改 | Any explicit write or generation action |

## Routing Priority

1. If both process groups match, select `requirement_development` and return `schema_change` as a required follow-up.
2. If one process group matches with a write action, select its process skill.
3. If only read-only terms match, return `read_only` and do not create a write task.
4. If no unique route matches, stop and ask for clarification.

## Adding A Process

For every new process:

1. Create `skill/<process-skill>/SKILL.md` and optional references.
2. Register one unique Harness `workflow_profile` and its trigger terms here.
3. Add the complete state sequence, return edges, evidence purposes, and phase gates.
4. Add routing and transition tests before enabling the process.
