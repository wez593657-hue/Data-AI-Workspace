---
name: crm-requirement-development
description: Execute the controlled CRM requirement development workflow. Use after the router identifies business requirements, requirement documents, business rules, target-table development, or stored procedure generation and modification.
---

# CRM Requirement Development

Use only for `workflow_profile=requirement_development`. Do not execute schema synchronization work in this skill.

Must load `docs/core/invariants.md` and `docs/core/output_contract.md` first (I-01, I-12). Do not modify assets, commit, or push without explicit user confirmation and manifest scope (I-02, I-03, I-04).

## Ordered Workflow

Read `references/workflow.md` before starting. Create or load the matching Harness task and execute one stage at a time:

1. Analyze the requirement document and scan `requirements/` for matching memory cards; compare versions and recent changes (I-08).
2. Confirm the requirement scope and acceptance criteria with the user (I-03).
3. Scan project files and record the relevant evidence.
4. List target tables and source tables.
5. Analyze whether source tables and fields can satisfy the target-table requirement.
6. List implementable and unavailable fields. Ask the user to confirm unresolved items (I-01).
7. Process supplementary material repeatedly until source capability is sufficient or unresolved fields are explicitly accepted.
8. Run the requirement review role. A failed review returns to the material-supplement stage.
9. Create or update the versioned requirement memory card and change history.
10. Develop the target-table stored procedure from the applicable template in `templates/`.
11. Run the procedure/template review role. A failed review returns to procedure implementation.
12. Generate temporary-table structures used by the procedure.
13. Run full validation, obtain user approval, then enter commit and push authorization stages.

For every new or modified stored procedure, read `governance/stored_procedure_date_parameter_rules.md` during stages 1, 10, and 11 (I-06).

## Evidence Requirements

Record requirement analysis, scope confirmation, project scan, table lineage, source capability, field-gap confirmation, supplementary material, requirement review, memory-card update, procedure implementation, procedure review, temporary-table generation, full validation, user approval, commit authorization, and push authorization evidence using the configured purposes.

Review evidence must be structured and include `review_type`, `result`, `checked_files`, `rules_checked`, `issues`, and `return_to`. Failed reviews require non-empty issues and a valid return stage. Rules are referenced by ID only (`docs/quality_rules.md`), not pasted in full.

## Hard Constraints

All global invariants apply: `docs/core/invariants.md` (I-01～I-12), not repeated here. Process-specific constraints:

- Do not update memory cards until the requirement review passes (I-09).
- Do not generate temporary-table DDL until procedure review passes (I-09).
- Do not skip the supplementary-material loop or either review (I-09).
- Target-table date output is `YYYYMMDD`; record every used date parameter in the requirement memory card and procedure-review evidence (I-06, I-07).
- New output fields require Mapping Excel update and user confirmation first (I-05); field additions/deletions/renames in target DDL require explicit user confirmation (I-03, I-05).
