---
name: crm-schema-change
description: Execute the controlled CRM schema change workflow. Use after the router identifies Mapping Excel changes, table-structure changes, or synchronization of MD, DD, and data-dictionary assets.
---

# CRM Schema Change

Use only for `workflow_profile=schema_change`. Do not perform business requirement or stored procedure development in this skill.

## Ordered Workflow

Read `references/workflow.md` before starting. Create or load the matching Harness task and execute one stage at a time:

1. Analyze the latest changes in the relevant Mapping Excel.
2. Scan related MD, DD, and data-dictionary files and record their versions/hashes.
3. Produce a file, table, and field-level change-scope list.
4. Stop and obtain user confirmation for the scope.
5. Modify only the confirmed MD, DD, and data-dictionary targets.
6. Run the schema consistency review against the Excel.
7. If review fails, return to scope identification and do not continue.
8. Run full validation, obtain user approval, then enter commit and push authorization stages.

## Evidence Requirements

Record Mapping Excel analysis, related-file scan, change scope, scope confirmation, asset update, schema consistency review, full validation, user approval, commit authorization, and push authorization evidence using the configured purposes.

Schema review evidence must be structured and include `review_type=schema_consistency`, `result`, `checked_files`, `rules_checked`, `issues`, and `return_to`. Failed reviews require `return_to=CHANGE_SCOPE_IDENTIFIED`.

## Hard Constraints

- Do not modify assets before user scope confirmation.
- Do not modify files outside the confirmed change manifest.
- Do not rewrite unrelated tables or columns from the Excel.
- Do not guess missing fields, types, comments, or mappings.
- Work on `master` only; do not create or switch Git branches.
- Commit and push only after explicit user confirmation.
