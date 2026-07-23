# Harness 发布门禁设计

## 目标

统一本地 `pre-push` 和 GitHub Actions 的发布授权规则，确保推送到 `master` 前同时满足任务授权、任务状态和变更范围要求。

## 任务识别

每个待推送提交必须在提交正文中包含一个 `Task-ID: <task-id>` trailer。同一次推送包含多个提交时，所有提交必须使用同一个任务 ID。任务 ID 必须符合 Harness 现有的小写字母、数字、点、下划线和连字符规则。

## 发布校验

共享脚本 `scripts/harness/publish_guard.py` 负责：

1. 读取待推送提交范围和提交正文。
2. 提取并校验唯一任务 ID。
3. 读取 `.harness/tasks/<task-id>/task.yaml` 和 `change_manifest.yaml`。
4. 要求任务存在、未归档，且状态为 `PUSH_ALLOWED`。
5. 使用现有变更门禁校验待推送文件是否在 `allowed_changes` 内，且未修改只读输入。

该脚本不迁移任务状态、不写入证据，也不修改业务资产。

## 接入点

- `hooks/pre-push` 从 Git 提供的真实远端旧 SHA、新 SHA 和 ref 中校验 `master` 推送。
- 非 `master` 分支更新被拒绝；删除远程非主分支允许通过，以支持清理已合并分支。
- `.github/workflows/validate.yml` 和 `.github/workflows/push-check.yml` 使用 `github.event.before` 与 `github.sha` 执行相同发布门禁。
- 发布门禁通过后，继续执行现有数据资产一致性校验和提交信息校验。

## 失败策略

以下任一情况阻止发布：缺少任务 ID、同一推送包含多个任务 ID、任务不存在、任务已归档、任务状态不是 `PUSH_ALLOWED`、变更超出白名单、修改只读输入、远端分支存在本地未包含的新提交，或推送到非 `master` 分支。

## 验证

单元测试覆盖任务 ID 提取、缺少 trailer、多提交任务不一致、任务状态不足和变更越权场景。发布门禁通过后仍执行完整工作区校验。
