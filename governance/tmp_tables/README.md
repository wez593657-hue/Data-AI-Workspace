# TMP_ 物理临时表审核清单

> 历史参考：本目录中的“特性分支”“受保护分支 PR”和审批描述属于历史流程。当前统一在 `master` 分支开发，用户确认脚本后直接提交和推送。

AI 可以在特性分支生成存储过程和 `TMP_` 表。每张 TMP_ 表在提交受保护分支 PR 前，必须创建同名 JSON 清单。

```json
{
  "table_name": "TMP_DWD_CUSTOMER_STAGE",
  "procedure": "PRC_dwd_customer.sql",
  "purpose": "客户数据分阶段处理",
  "source_tables": ["ods_customer"],
  "columns": [
    {"name": "customer_id", "type": "VARCHAR(50)", "nullable": false}
  ],
  "indexes": ["customer_id"],
  "lifecycle": {"cleanup": "过程成功或异常退出时 TRUNCATE", "concurrency": "batch_id 隔离"},
  "approval_status": "approved",
  "approved_by": "GitHub Code Owner"
}
```

草稿可使用 `approval_status: "draft"`；仅 `approved` 清单可通过受保护分支 PR 校验。
