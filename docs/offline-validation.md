# 无数据库离线验证

当无法连接 Kingbase 或源系统时，使用规则目录、合成 Fixture、Expected 结果和独立参考实现验证业务逻辑。

## 目录

```text
validation/
├── rules/       # 需求规则和来源
├── fixtures/    # 脱机输入数据
├── expected/    # 人工确认的预期结果
└── reference/   # 简单、独立的参考实现
```

## 执行

```powershell
python -m scripts.harness offline-validate
```

生成报告：

```powershell
python -m scripts.harness offline-validate --report validation/reports/offline-report.json
```

## 规则要求

每条规则必须包含：

- `rule_id`
- 需求来源 `source`
- 已确认状态 `status: confirmed`
- 独立参考实现 `reference`
- 必要测试标签 `required_case_tags`

未解决规则不能进入离线验证。每个已确认规则必须至少有一个 Fixture，并覆盖规则声明的正常、边界、否定和空值场景。

## 治理健康检查

治理健康检查只报告目录、编码分类、候选重复、仓库内 Markdown 链接、权威来源路径和治理文档生命周期元数据；它不会修改、移动、删除、重命名、归档或转码任何文件。

```powershell
python -m scripts.harness governance-check
python -m scripts.harness governance-check --report .harness/tasks/<task-id>/reports/governance-check.json
```

编码检查按 `validation/governance/policy.yaml` 区分二进制格式、要求 UTF-8 的文本和允许 GBK 的既有 SQL/参考逻辑。候选重复或来源不明材料只产生 warning 或 unresolved，不替代用户对资产处置的确认。

## 结果边界

离线验证通过表示规则、结构化输入和参考结果一致，不代表已经完成真实 Kingbase 执行、执行计划、数据分布和生产权限验证。报告必须保留数据库验证待完成状态。
