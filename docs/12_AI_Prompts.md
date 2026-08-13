# 12 AI 提示词模板

> **DEPRECATED（长模板正文）**
> 运行时请使用短提示文件：
> - `prompts/sql_prompt.txt`
> - `prompts/procedure_prompt.txt`
> - `prompts/etl_prompt.txt`
> - `prompts/code_review_prompt.txt`
>
> 全局行为以 `docs/core/*` 与对应 Skill 为准。
> 本文件不再维护与上述来源重复的长提示词正文，避免双源与 Token 浪费。

## 使用方式

1. 加载 `docs/core/invariants.md` + `docs/core/output_contract.md`
2. 经 Router 进入目标 Skill
3. 需要专项生成时，再附加对应 `prompts/*.txt`
4. 输出遵守阶段短合同，不在此文件复制 8 段模板

## 提示词文件职责

| 文件 | 用途 |
|------|------|
| `prompts/sql_prompt.txt` | SQL 编写约束摘要 |
| `prompts/procedure_prompt.txt` | 存储过程编写约束摘要 |
| `prompts/etl_prompt.txt` | ETL 设计约束摘要 |
| `prompts/code_review_prompt.txt` | Review 约束摘要 |

修改提示词时只改 `prompts/`，并保持与 `docs/core`、域规范一致。
