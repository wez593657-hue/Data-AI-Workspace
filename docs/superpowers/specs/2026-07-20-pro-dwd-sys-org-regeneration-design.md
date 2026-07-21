# PRO_DWD_SYS_ORG Regeneration Design

## Goal

Regenerate `PRO_DWD_SYS_ORG` so that it produces the CRM organization hierarchy from `cbs_kbrp_jgcshu` and `cbs_kbrp_jggxii` without hard-coded organization identifiers for missing relationship records.

## Parent Resolution

1. Join the organization and relationship tables by `FARENDMA` and `JIGOUHAO`.
2. When a relationship row exists, use `YEWUGXJG` as the parent source.
3. When no relationship row exists, derive a candidate branch parent as `LPAD(FENHDAIM, 2, '0') || '0000'`.
4. Use the fallback only when that candidate exists in the organization source and is not the current organization. Otherwise retain an empty parent.
5. Keep the existing synthetic `a` organization-node rule for branch management nodes.

## Compatibility Rules

- Compare organization identifiers as character values, preserving six-digit codes and leading zeroes.
- Keep the four existing batch stages, logging pattern, temporary tables, and target procedure name.
- Generate paths with `SYS_CONNECT_BY_PATH(ORG_ID, '/') || '/'`; do not add a second leading slash.
- Do not change source or target table DDL in this procedure regeneration.

## Validation

Use the provided source workbook and CRM target workbook to verify the output ID set, parent IDs, hierarchy paths, and the four reported organizations. The procedure must not create duplicate organizations from the supplied snapshot.
