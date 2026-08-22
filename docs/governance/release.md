# 发布与归档治理

> 层级：L1 流程规则
> 版本：v1.0

发布前必须满足：范围与 Manifest 一致、适用 QA/QB/QC 完成、Review 有结论、用户验收完成、Harness 已进入允许的发布状态，且用户明确分别授权 commit 与 push。

发布记录至少包括版本、日期、Change ID、受影响资产、验证证据、Reviewer、审批人、提交标识和发布状态。当前仓库遵循 `CONTRIBUTING.md` 的 `master` 直接提交策略；本规则不引入 PR、分支保护或自动推送。

发布后将仍有效的材料保留为 `ACTIVE`，被替代的材料按 `document_lifecycle.md` 标记，历史证据归档但不得伪造生产运行验证。
