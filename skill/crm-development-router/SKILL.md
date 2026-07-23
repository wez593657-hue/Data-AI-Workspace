---
name: crm-development-router
description: Route CRM requests to the matching process-specific skill. Use when a user asks for CRM requirement development, stored procedure development, Mapping Excel or data-dictionary synchronization, schema changes, or a new development workflow that needs routing.
---

# CRM Development Router

This skill only classifies the user's command and points to one process skill. It does not perform development, modify files, review artifacts, or commit code.

## Routing

1. Read `references/route-rules.md`.
2. Determine whether the request is read-only, `requirement_development`, `schema_change`, or ambiguous.
3. Report the matched terms, selected profile, target skill, and any follow-up workflow.
4. For a write request, invoke the target process skill and create/load its matching Harness profile.
5. Stop when no unique route exists and ask the user to clarify.

If both process signals are present, route to `crm-requirement-development` first and record `crm-schema-change` as the follow-up skill. Do not execute both skills in one uncontrolled step.

## Skill Registry Rule

Every writable Harness profile must have exactly one process skill. Adding a new process requires adding a new skill directory, registering its trigger terms and profile in `references/route-rules.md`, and adding matching Harness states and phase gates before the process can be used.

All process skills work on `master` only. The router never creates or switches Git branches.
