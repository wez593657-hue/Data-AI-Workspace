# Requirement Development Harness Workflow

Use `python -m scripts.harness route` first, then create the task with `--workflow-profile requirement_development`.

```text
CREATED
→ REQUIREMENT_ANALYZED
→ SCOPE_CONFIRMED
→ PROJECT_SCANNED
→ TABLE_LINEAGE_IDENTIFIED
→ SOURCE_CAPABILITY_ANALYZED
→ FIELD_GAP_CONFIRMED
→ REQUIREMENT_REVIEW_PASSED
→ MEMORY_CARD_UPDATED
→ PROCEDURE_IMPLEMENTED
→ PROCEDURE_REVIEW_PASSED
→ TMP_TABLES_GENERATED
→ FULL_VALIDATION_PASSED
→ USER_APPROVED
→ COMMIT_ALLOWED
→ PUSH_ALLOWED
→ COMPLETED
```

`FIELD_GAP_CONFIRMED` may return to `MATERIALS_SUPPLEMENTED` when fields cannot be implemented. `MATERIALS_SUPPLEMENTED` must return to `SOURCE_CAPABILITY_ANALYZED`. `REQUIREMENT_REVIEW_PASSED` may return to `MATERIALS_SUPPLEMENTED`; `PROCEDURE_REVIEW_PASSED` may return to `PROCEDURE_IMPLEMENTED`.

## Date-Parameter Gate

For stored procedure work, read `governance/stored_procedure_date_parameter_rules.md` during requirement analysis, implementation, and procedure review. The memory card must list the date codes, parameter names, and business meanings actually used. Procedure-review evidence must confirm all V_SYSDAT-relative business dates use named `sys_fun_deal_date` parameters, direct V_SYSDAT calendar derivation is absent, and target date output is `YYYYMMDD`.

The exact allowed transitions and evidence purposes are defined in `.harness/policies/phase_gates.yaml` and `scripts/harness/state_machine.py`.
