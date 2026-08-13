---
name: crm-schema-change
description: Execute the controlled CRM schema change workflow. Use after the router identifies Mapping Excel changes, table-structure changes, or synchronization of MD, DD, and data-dictionary assets.
---

# CRM Schema Change

Use only for `workflow_profile=schema_change`. Do not perform business requirement or stored procedure development in this skill.

Must load `docs/core/invariants.md` and `docs/core/output_contract.md` first (I-01, I-12). Do not modify assets before user scope confirmation (I-03, I-04).

## Ordered Workflow

Read `references/workflow.md` before starting. Create or load the matching Harness task and execute one stage at a time:

1. Analyze the latest changes in the relevant Mapping Excel.
2. Scan related MD, DD, and data-dictionary files and record their versions/hashes.
3. Produce a file, table, and field-level change-scope list.
4. Stop and obtain user confirmation for the scope (I-03).
5. Before modifying assets, execute and record the required specialized skills:
   - `kingbase-ddl-generator`: generate DDL and data-dictionary fields from the confirmed Excel rows.
   - `scripts/harness/mapping_excel_sync.py`: generate Mapping Markdown from the same workbook.
   - `prc-sql`: refresh a stored procedure when the scope includes a procedure output.
   - `validate-procedure-date-parameters`: validate `sys_fun_deal_date(V_SYSDAT, n)` usage when a procedure is changed (I-06).
6. Modify only the confirmed MD, DD, data-dictionary, and procedure targets.
7. Run the schema consistency review against the Excel.
8. If review fails, return to scope identification and do not continue.
9. Run full validation, obtain user approval, then enter commit and push authorization stages.

## Evidence Requirements

Record Mapping Excel analysis, related-file scan, change scope, scope confirmation, asset update, schema consistency review, full validation, user approval, commit authorization, and push authorization evidence using the configured purposes.

Schema review evidence must be structured and include `review_type=schema_consistency`, `result`, `checked_files`, `rules_checked`, `issues`, and `return_to`. Failed reviews require `return_to=CHANGE_SCOPE_IDENTIFIED`. Rules are referenced by ID only (`docs/quality_rules.md`), not pasted in full.

Before `USER_SCOPE_CONFIRMED -> ASSETS_UPDATED`, record `purpose=skill_execution` with `input_workbook`, `skills`, `steps`, and `output_files`. The steps must include `excel_to_mapping`, `excel_to_ddl`, and `excel_to_dictionary`. If a procedure is included, `skills` must also include `prc-sql` and `validate-procedure-date-parameters`.

## Hard Constraints

All global invariants apply: `docs/core/invariants.md` (I-01～I-12), not repeated here. Process-specific constraints:

- Do not modify files outside the confirmed change manifest (I-04).
- Do not rewrite unrelated tables or columns from the Excel (I-04).
- Do not guess missing fields, types, comments, or mappings (I-01).
- Do not manually patch Excel-derived DDL or data dictionaries as a substitute for `kingbase-ddl-generator`.
- Do not manually patch a procedure as a substitute for `prc-sql` when the task includes procedure output.
- Mapping Excel is the highest-priority canonical source for table structure (I-05). When DDL, MD, or data dictionary conflicts with Excel, Excel always wins and DDL/MD must be updated to match.
- Field additions/deletions/renames that modify the target table schema must be listed in the change scope and confirmed by the user before execution (I-03, I-05).
