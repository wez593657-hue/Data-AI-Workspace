-- ============================================================
-- Required production indexes for sleep-wake procedures
-- (DEFECT-SLEEP-002 deployment deliverable; performance improves
--  ~400x: 30k customers 229s -> 0.56s)
-- Run as DBA/schema owner on target environment.
-- ============================================================

-- 1. Active-transaction lookup in [B] NOT EXISTS (per-customer)
CREATE INDEX IDX_DWD_TX_ASET_CUST_DATE ON DWD_TX_ASET(CUST_ID, TX_DATE);
-- optional extended covering variant:
-- CREATE INDEX IDX_DWD_TX_ASET_CUST_DATE_FLG ON DWD_TX_ASET(CUST_ID, PERSN_LEGAL_BK_CODE, TX_DATE, JIOYCFFS);

-- 2. Balance-sheet join for current-day and baseline snapshots ([D] UPDATE)
CREATE INDEX IDX_DWS_ASSE_CUST_ORG_DATE ON DWS_CUST_ASSE_LIAB(CUST_ID, PERSN_LEGAL_BK_CODE, ORG_ID, DATA_DATE);

PROMPT INDEX_SCRIPT_DONE
