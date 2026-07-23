---
name: crm-requirement-development
description: Execute the controlled CRM requirement development workflow. Use after the router identifies business requirements, requirement documents, business rules, target-table development, or stored procedure generation and modification.
---

# CRM Requirement Development

Use only for `workflow_profile=requirement_development`. Do not execute schema synchronization work in this skill.

## Ordered Workflow

Read `references/workflow.md` before starting. Create or load the matching Harness task and execute one stage at a time:

1. Analyze the requirement document and scan `requirements/` for matching memory cards; compare versions and recent changes.
2. Confirm the requirement scope and acceptance criteria with the user.
3. Scan project files and record the relevant evidence.
4. List target tables and source tables.
5. Analyze whether source tables and fields can satisfy the target-table requirement.
6. List implementable and unavailable fields. Ask the user to confirm unresolved items.
7. Process supplementary material repeatedly until source capability is sufficient or unresolved fields are explicitly accepted.
8. Run the requirement review role. A failed review returns to the material-supplement stage.
9. Create or update the versioned requirement memory card and change history.
10. Develop the target-table stored procedure from the applicable template in `templates/`.
11. Run the procedure/template review role. A failed review returns to procedure implementation.
12. Generate temporary-table structures used by the procedure.
13. Run full validation, obtain user approval, then enter commit and push authorization stages.

## Evidence Requirements

Record requirement analysis, scope confirmation, project scan, table lineage, source capability, field-gap confirmation, supplementary material, requirement review, memory-card update, procedure implementation, procedure review, temporary-table generation, full validation, user approval, commit authorization, and push authorization evidence using the configured purposes.

Review evidence must be structured and include `review_type`, `result`, `checked_files`, `rules_checked`, `issues`, and `return_to`. Failed reviews require non-empty issues and a valid return stage.

## Hard Constraints

- Do not guess source tables, fields, rules, types, aliases, or conversions.
- Do not update memory cards until the requirement review passes.
- Do not generate temporary-table DDL until procedure review passes.
- Do not skip the supplementary-material loop or either review.
- Do not modify files outside the confirmed change manifest.
- Work on `master` only; do not create or switch Git branches.
- Commit and push only after explicit user confirmation.
