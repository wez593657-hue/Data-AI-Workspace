# Schema Change Harness Workflow

Use `python -m scripts.harness route` first, then create the task with `--workflow-profile schema_change`.

```text
CREATED
→ MAPPING_EXCEL_ANALYZED
→ RELATED_FILES_SCANNED
→ CHANGE_SCOPE_IDENTIFIED
→ USER_SCOPE_CONFIRMED
→ ASSETS_UPDATED
→ ASSETS_REVIEW_PASSED
→ FULL_VALIDATION_PASSED
→ USER_APPROVED
→ COMMIT_ALLOWED
→ PUSH_ALLOWED
→ COMPLETED
```

The asset-update gate is closed until a `skill_execution` evidence record proves that the same confirmed workbook was processed by `kingbase-ddl-generator`, Mapping synchronization, and, when applicable, `prc-sql` plus `validate-procedure-date-parameters`. Manual edits without that record are not a valid schema-change workflow result.

`ASSETS_REVIEW_PASSED` may return to `CHANGE_SCOPE_IDENTIFIED` only with a failed structured schema review. The exact allowed transitions and evidence purposes are defined in `.harness/policies/phase_gates.yaml` and `scripts/harness/state_machine.py`.
