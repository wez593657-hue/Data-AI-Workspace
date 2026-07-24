# Harness P0 发布状态闭环设计

## 目标

修复当前 Harness 发布闭环断裂问题：标准门禁已经通过，但任务仍停留在 `USER_APPROVED`，导致 `publish_guard.py` 要求的 `PUSH_ALLOWED` 永远无法满足。

本次只处理 P0，不重构整个工作流，不放宽发布门禁。

## 当前问题

- `task.yaml` 是发布门禁的权威输入，当前状态为 `USER_APPROVED`。
- `publish_guard.py` 只允许 `PUSH_ALLOWED` 状态推送。
- `phases.yaml` 显示阶段已完成，但 `change_manifest.yaml` 仍显示 `current_phase: offline_rule_validation`。
- 结果是开发校验和发布授权不是同一个闭环。

## 推荐方案

采用最小闭环修复：

1. 保持 `task.yaml` 作为唯一发布状态源。
2. 保持 `publish_guard.py` 只接受 `PUSH_ALLOWED`，不允许 `USER_APPROVED` 直接推送。
3. 增加或修复显式状态迁移路径：
   - `USER_APPROVED -> COMMIT_ALLOWED`
   - `COMMIT_ALLOWED -> PUSH_ALLOWED`
4. 同步当前任务元数据：
   - `task.yaml` 更新到 `PUSH_ALLOWED`
   - `phases.yaml` 的 `next_action` 更新为可推送
   - `change_manifest.yaml` 移除或修正过期的阶段字段，避免它像状态源一样被误用
5. 增加测试覆盖：
   - 状态机允许上述发布迁移
   - 发布门禁在 `PUSH_ALLOWED` 时通过
   - 发布门禁在 `USER_APPROVED` 时仍失败

## 不做的事

- 不允许 `USER_APPROVED` 直接推送。
- 不合并全部 Harness 状态机。
- 不调整业务需求、DDL、Mapping、数据字典或存储过程。
- 不改变 `Task-ID` 发布规则。

## 验收标准

以下命令必须通过：

```powershell
python -m unittest scripts.harness.tests.test_state_integrity scripts.harness.tests.test_publish_guard scripts.harness.tests.test_ci_integration
python -m scripts.harness risk-check standard
python scripts/harness/publish_guard.py --old origin/master --new HEAD
```

## 风险控制

- 若任务状态不是 `PUSH_ALLOWED`，发布门禁仍必须失败。
- 若同一批待推送提交包含多个 `Task-ID`，发布门禁仍必须失败。
- 若变更文件超出 `change_manifest.yaml` 授权范围，发布门禁仍必须失败。
