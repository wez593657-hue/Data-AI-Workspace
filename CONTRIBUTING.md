# 贡献指南

## 代码托管

远程仓库地址: `https://github.com/wez593657-hue/Data-AI-Workspace.git`

## 钩子安装

克隆仓库后，必须安装Git钩子以启用本地门禁：

```bash
python scripts/install_hooks.py
ls -la .git/hooks/
```

安装的钩子：`pre-commit`（提交前校验）、`pre-push`（推送前检查）、`commit-msg`（提交信息格式校验）。

## 分支模型

统一在 `master` 分支开发，用户确认后直接 commit 和 push，不使用 PR。

## 开发流程

```
需求分析 → 本地开发 → 质检 → 用户确认 → commit → push
```

两类开发流程：

| 流程 | 适用场景 | 产出物 |
|------|----------|--------|
| 需求开发 | 业务需求、存储过程开发 | 存储过程、DDL、临时表、规则记忆卡片 |
| 表结构变更 | Mapping Excel 变更同步 | 更新后的 DDL、受影响存储过程 |

项目目标详见 [docs/project_goals.md](docs/project_goals.md)，质检规则详见 [docs/quality_rules.md](docs/quality_rules.md)。

## 提交规范

| 类型 | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug修复 |
| `docs` | 文档更新 |
| `refactor` | 代码重构 |
| `sync` | Mapping同步 |

格式：
```
<type>(<scope>): <subject>

<body>

Task-ID: <task-id>
```

## 技术约束

| 钩子 | 校验内容 | 失败处理 |
|------|----------|----------|
| `pre-commit` | 数据资产一致性、文件生成校验 | 阻止提交 |
| `pre-push` | 远程更新检查、校验状态 | 阻止推送 |
