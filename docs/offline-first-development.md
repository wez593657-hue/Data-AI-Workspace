# 离线优先持续开发指南

## 目标

项目的开发主流程统一使用一个 Harness 任务，按阶段持续推进。数据库不可连接时，仍然可以验证需求规则、字段关系和离线逻辑；真实数据库执行、Explain、索引命中和生产性能必须等数据库恢复后单独验证。

当前任务：`offline-first-development-architecture-v1`

## 开发闭环

```text
需求来源
  -> 规则目录
  -> 影响关系
  -> 参考实现与测试
  -> 离线报告
  -> 风险门禁
  -> 用户确认
```

所有阶段写入同一个目录：

```text
.harness/tasks/offline-first-development-architecture-v1/
```

阶段状态和验收命令维护在 `phases.yaml`，可修改文件维护在 `change_manifest.yaml`，报告和证据维护在 `reports/`、`evidence/`。

## 日常命令

普通规则开发使用快速门禁：

```powershell
python -m scripts.harness risk-check fast
```

标准开发使用 standard 门禁：

```powershell
python -m scripts.harness risk-check standard
```

提交或推送前使用严格门禁：

```powershell
python -m scripts.harness risk-check strict
```

重点单项检查：

```powershell
python -m scripts.harness offline-validate
python -m scripts.harness impact-analyze
python -m scripts.harness coverage-analyze
python -m scripts.harness property-validate
python -m scripts.harness dialect-check
```

## 阶段规则

1. 规则必须有来源、输入、输出、边界和测试案例。
2. `offline_only` 规则只证明离线参考实现，不计入生产实现覆盖率。
3. 规则、字段或目标表无法确认时必须标记 `unresolved`，不得猜测。
4. 当前阶段验收通过并记录证据后，才能进入下一阶段。
5. 用户确认只授权继续当前任务，不自动授权提交、推送或生产发布。

## 简化与保留

以下内容不再作为每次开发的独立入口：重复创建阶段任务、重复编写相同校验脚本、没有业务变化的重复审批和数据库不可用时的伪执行验证。

以下内容仍然保留：需求来源追溯、影响关系、规则覆盖、失败阻塞、变更白名单、CI/pre-push 门禁和用户确认。

历史 Harness 任务和旧报告只作为审计记录，不作为当前开发入口。新的架构能力继续追加到当前任务，不再拆分成多个阶段任务。

## 数据库恢复后的补充验证

数据库恢复后，另行执行真实 SQL/存储过程验证、Explain 计划、索引命中、全表扫描、隐式类型转换、函数导致的索引失效、重复扫描、排序和临时空间检查。离线报告不能替代这些验证。
