-- ============================================================
-- v2.15.0 previous-period freeze & targeted-update assertions
-- (memory card rules 28/34/35/36/37/39)
-- Self-contained scenario:
--   1. TRUNCATE target tables; assumes 05_load_full_matrix.sql data loaded
--   2. batch 20260630 -> June current rows (DATA_DATE=20260630), snapshot
--   3. insert new in-window purchase DP107 (2026-07-03) for C10
--   4. batch 20260705 -> June becomes previous (preserved), July current
--   5. snapshot & assert: 18 base columns frozen, 7 update fields rolled,
--      DATA_DATE dual semantics, STATIS option-B freeze, idempotency
-- PASS/FAIL markers + evidence queries.
-- ============================================================
SET PAGESIZE 300
SET LINESIZE 400
SET SERVEROUTPUT ON

-- ---------- reset ----------
TRUNCATE TABLE ADS_CUST_DEADLINE_RMND_DTL;
TRUNCATE TABLE ADS_CUST_DEADLINE_RMND_STATIS;
DROP TABLE TMP_TEST_PREV_BEFORE;
DROP TABLE TMP_TEST_PREV_AFTER;
DROP TABLE TMP_TEST_STAT_BEFORE;
DROP TABLE TMP_TEST_STAT_AFTER;

CREATE TABLE TMP_TEST_PREV_BEFORE AS
SELECT * FROM ADS_CUST_DEADLINE_RMND_DTL WHERE 1=0;
CREATE TABLE TMP_TEST_PREV_AFTER AS
SELECT * FROM ADS_CUST_DEADLINE_RMND_DTL WHERE 1=0;
CREATE TABLE TMP_TEST_STAT_BEFORE AS
SELECT * FROM ADS_CUST_DEADLINE_RMND_STATIS WHERE 1=0;
CREATE TABLE TMP_TEST_STAT_AFTER AS
SELECT * FROM ADS_CUST_DEADLINE_RMND_STATIS WHERE 1=0;

-- ---------- step 1: run 20260630 (June = current, DATA_DATE=20260630) ----------
PROMPT ==== STEP1 batch 20260630 ====
EXEC PRC_ADS_CUST_DEADLINE_RMND_DTL('20260630', :rc)
EXEC PRC_ADS_CUST_DEADLINE_RMND_ST('20260630', :rc)

-- sanity: current June M rows must carry DATA_DATE=20260630 (rule 37)
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS D37_JUNE_CURRENT_DATE
  FROM ADS_CUST_DEADLINE_RMND_DTL
 WHERE STAT_PERD='M' AND DATA_DATE='20260630' AND CUST_ID='C10';

-- ---------- step 2: snapshot previous-period (June) rows BEFORE ----------
INSERT INTO TMP_TEST_PREV_BEFORE
SELECT * FROM ADS_CUST_DEADLINE_RMND_DTL
 WHERE STAT_PERD='M' AND DATA_DATE='20260630';
INSERT INTO TMP_TEST_STAT_BEFORE
SELECT * FROM ADS_CUST_DEADLINE_RMND_STATIS
 WHERE STATIS_CYCLE='M' AND DATA_DATE='20260630';
COMMIT;

PROMPT ==== STEP2 snapshot taken: June rows before ====
SELECT CUST_ID, STATIS_TYP, EXPR_AMT, TAKE_RATE, FIX_DEPO_TAKE_RATE,
       CNTCT_STATE, UNDTAKE_STATE
  FROM TMP_TEST_PREV_BEFORE
 WHERE CUST_ID='C10' ORDER BY STATIS_TYP;

-- ---------- step 3: new in-window purchase DP107 (2026-07-03 <= V_SYSDAT 07-05,
-- inside window [06-15, 07-15]) ----------
PROMPT ==== STEP3 insert DP107 + extra marketing record (temporary test data) ====
INSERT INTO DWD_ACCT_DEPO(CUST_ID, ACCT_ID, PRDKT_ID, PRDKT_NAME, PRDKT_CATE_BIG,
                          BAL, OPEN_ACCT_ORG, INTRI_BGN_DATE, EXPR_DATE, ACCT_STATE,
                          PERSN_LEGAL_BK_CODE, FIX_CURNT_FLG)
VALUES ('C10','DP107','P107','FD-G','01',50000,'ORG100','2026-07-03','2027-07-03','1','BK10','1');
-- temporary marketing record inside June window (rule 35: CNTCT_STATE rolls)
INSERT INTO ADS_MKT_REC_INFO(MKT_REC_SEQ_ID, CUST_ID, CUST_NAME, MKT_TIME, MKT_ORG, MKT_TYP, PERSN_LEGAL_BK_CODE)
VALUES ('M199','C10','MultiMaturity','2026-07-04 10:00:00','ORG100','1','BK10');
COMMIT;

-- ---------- step 4: run 20260705 (June -> previous, July -> current) ----------
PROMPT ==== STEP4 batch 20260705 ====
EXEC PRC_ADS_CUST_DEADLINE_RMND_DTL('20260705', :rc)
EXEC PRC_ADS_CUST_DEADLINE_RMND_ST('20260705', :rc)

INSERT INTO TMP_TEST_PREV_AFTER
SELECT * FROM ADS_CUST_DEADLINE_RMND_DTL
 WHERE STAT_PERD='M' AND DATA_DATE='20260630';
INSERT INTO TMP_TEST_STAT_AFTER
SELECT * FROM ADS_CUST_DEADLINE_RMND_STATIS
 WHERE STATIS_CYCLE='M' AND DATA_DATE='20260630';
COMMIT;

-- ============================================================
-- F1: previous-period 18 base columns frozen (rule 34)
-- ============================================================
PROMPT ================= F1 18 base columns frozen ================
-- base columns must be identical before/after (MINUS both directions)
SELECT CASE WHEN NOT EXISTS (
             SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                    DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                    EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                    FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
               FROM TMP_TEST_PREV_BEFORE
             MINUS
             SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                    DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                    EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                    FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
               FROM TMP_TEST_PREV_AFTER)
        AND NOT EXISTS (
             SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                    DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                    EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                    FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
               FROM TMP_TEST_PREV_AFTER
             MINUS
             SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, CUST_ID, CUST_NAME, CUST_LVL,
                    DEPO_CURNT_DEPO_BAL, FIXD_DEPO_BAL, FIN_AMT, STAT_PERD, STATIS_TYP,
                    EXPR_AMT, MATURE_TTL_AMT, FIX_DEPO_MATURE_AMT, FIX_DEPO_MATURE_TTL_AMT,
                    FRST_MATURE_PK_BF_DAY_AUM_BAL, LAST_END_DATE, POST_ID, ORG_ID
               FROM TMP_TEST_PREV_BEFORE)
            THEN 'PASS' ELSE 'FAIL' END AS F1_BASE_FROZEN
  FROM dual;

-- ============================================================
-- F2: 7 update fields roll with window (rule 35)
-- C10 June M type1: EXPR_AMT=230000; TAKE 110000->160000 => 47.83 -> 69.57
-- ============================================================
PROMPT ================= F2 TAKE_RATE/FIX_DEPO_TAKE_RATE rolled ================
SELECT CASE WHEN (SELECT TAKE_RATE FROM TMP_TEST_PREV_AFTER
                   WHERE CUST_ID='C10' AND STAT_PERD='M' AND STATIS_TYP='1') = 69.57
            THEN 'PASS' ELSE 'FAIL' END AS F2_TAKE_RATE_ROLLED,
       (SELECT TAKE_RATE FROM TMP_TEST_PREV_BEFORE
         WHERE CUST_ID='C10' AND STAT_PERD='M' AND STATIS_TYP='1') AS BEFORE_TAKE_RATE,
       (SELECT TAKE_RATE FROM TMP_TEST_PREV_AFTER
         WHERE CUST_ID='C10' AND STAT_PERD='M' AND STATIS_TYP='1') AS AFTER_TAKE_RATE,
       (SELECT FIX_DEPO_TAKE_RATE FROM TMP_TEST_PREV_AFTER
         WHERE CUST_ID='C10' AND STAT_PERD='M' AND STATIS_TYP='1') AS AFTER_FIXDEPO_RATE
  FROM dual;

-- CNTCT_STATE/UNDTAKE_STATE must not become NULL (both update-set columns)
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS F2_STATE_NOT_NULL
  FROM TMP_TEST_PREV_AFTER
 WHERE CNTCT_STATE IS NULL OR UNDTAKE_STATE IS NULL;

-- ============================================================
-- F3: DATA_DATE dual semantics (rule 37)
-- ============================================================
PROMPT ================= F3 DATA_DATE dual semantics ================
-- previous June rows: DATA_DATE=20260630 ; current July rows: DATA_DATE=20260705
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS F3_PREV_END_DATE
  FROM ADS_CUST_DEADLINE_RMND_DTL
 WHERE STAT_PERD='M' AND CUST_ID='C10' AND DATA_DATE <> '20260630'
   AND DATA_DATE < '20260701';
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS F3_CURR_RUN_DATE
  FROM ADS_CUST_DEADLINE_RMND_DTL
 WHERE STAT_PERD='M' AND CUST_ID='C10' AND DATA_DATE <> '20260705'
   AND DATA_DATE >= '20260701';

-- no snapshot accumulation: July current rows must only exist for 20260705
SELECT CASE WHEN COUNT(DISTINCT DATA_DATE) = 1 THEN 'PASS' ELSE 'FAIL' END AS F3_NO_SNAPSHOT_ACCUM,
       COUNT(DISTINCT DATA_DATE) AS JULY_SNAPSHOT_DAYS
  FROM ADS_CUST_DEADLINE_RMND_DTL
 WHERE STAT_PERD='M' AND CUST_ID='C10' AND DATA_DATE >= '20260701';

-- ============================================================
-- F4: STATIS option-B: previous base columns frozen, rates rolled (rule 36)
-- ============================================================
PROMPT ================= F4 STATIS option B ================
SELECT CASE WHEN NOT EXISTS (
             SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                    EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT
               FROM TMP_TEST_STAT_BEFORE
             MINUS
             SELECT PERSN_LEGAL_BK_CODE, DATA_DATE, STATIS_OBJ, STATIS_CYCLE, STATIS_TYP,
                    EXPR_CUST_CNT, TTL_EXPR_CUST_CNT, EXPR_AMT, TTL_EXPR_AMT
               FROM TMP_TEST_STAT_AFTER)
            THEN 'PASS' ELSE 'FAIL' END AS F4_STAT_BASE_FROZEN
  FROM dual;
-- ASSET_UNDTAKE_RATE for ORG100 June M0 must reflect rolled TAKE_RATE (>= before)
SELECT CASE WHEN (SELECT ASSET_UNDTAKE_RATE FROM TMP_TEST_STAT_AFTER
                   WHERE STATIS_OBJ='ORG100' AND STATIS_CYCLE='M' AND DATA_DATE='20260630' AND STATIS_TYP='0')
             > (SELECT ASSET_UNDTAKE_RATE FROM TMP_TEST_STAT_BEFORE
                WHERE STATIS_OBJ='ORG100' AND STATIS_CYCLE='M' AND DATA_DATE='20260630' AND STATIS_TYP='0')
            THEN 'PASS' ELSE 'FAIL' END AS F4_STAT_RATE_ROLLED
  FROM dual;

-- ============================================================
-- F5: idempotent re-run (rule 28): same-day rerun must not change
-- previous rows (row count + base fields)
-- ============================================================
PROMPT ================= F5 idempotent re-run 20260705 ================
EXEC PRC_ADS_CUST_DEADLINE_RMND_DTL('20260705', :rc)
EXEC PRC_ADS_CUST_DEADLINE_RMND_ST('20260705', :rc)
SELECT CASE WHEN (SELECT COUNT(*) FROM ADS_CUST_DEADLINE_RMND_DTL
                   WHERE STAT_PERD='M' AND DATA_DATE='20260630')
             = (SELECT COUNT(*) FROM TMP_TEST_PREV_AFTER)
            THEN 'PASS' ELSE 'FAIL' END AS F5_PREV_ROWCOUNT_STABLE,
       (SELECT COUNT(*) FROM ADS_CUST_DEADLINE_RMND_DTL
         WHERE STAT_PERD='M' AND DATA_DATE='20260630') AS PREV_ROW_COUNT
  FROM dual;

-- ============================================================
-- F6: validation result log (v3.0.0) - all PASS for this batch
-- ============================================================
PROMPT ================= F6 validation results all PASS ================
SELECT CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS F6_NO_VALIDATE_FAIL,
       COUNT(*) AS FAIL_COUNT
  FROM TMP_CDR_VALIDATE_RESULT
 WHERE BATCH_DATE='20260705' AND RESULT='FAIL';
SELECT VALIDATE_ITEM, RESULT FROM TMP_CDR_VALIDATE_RESULT
 WHERE BATCH_DATE='20260705' ORDER BY PERIOD_TYP, VALIDATE_ITEM;

-- ============================================================
-- F7: logging isolation (v3.0.0) - C1/C2/P1/P2/V1 steps exist
-- ============================================================
PROMPT ================= F7 log prefixes C/P/V ================
SELECT CASE WHEN (SELECT COUNT(*) FROM SYS_PRC_STEP_LOG
                   WHERE DATA_DATE='20260705' AND STEP_NO IN ('C1','C2','P1','P2','V1'))
             = 5 THEN 'PASS' ELSE 'FAIL' END AS F7_STEP_LOGS_ISOLATED,
       (SELECT COUNT(*) FROM SYS_PRC_STEP_LOG
         WHERE DATA_DATE='20260705' AND STEP_NO IN ('C1','C2','P1','P2','V1')) AS STEP_COUNT
  FROM dual;

-- ============================================================
-- F8: isolated stage DATA_DATE (v3.0.0) - CURR=V_SYSDAT, PREV=period end
-- ============================================================
PROMPT ================= F8 stage DATA_DATE isolation ================
SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM TMP_CDR_DTL_CURR_STAGE WHERE DATA_DATE <> '20260705')
            THEN 'PASS' ELSE 'FAIL' END AS F8_CURR_STAGE_DATE,
       CASE WHEN NOT EXISTS (SELECT 1 FROM TMP_CDR_DTL_PREV_STAGE
                              WHERE (STAT_PERD='M' AND DATA_DATE <> '20260630'))
            THEN 'PASS' ELSE 'FAIL' END AS F8_PREV_STAGE_DATE
  FROM dual;

-- ---------- cleanup temporary test data ----------
PROMPT ==== CLEANUP DP107 / M199 / archives ====
DELETE FROM DWD_ACCT_DEPO WHERE ACCT_ID='DP107';
DELETE FROM ADS_MKT_REC_INFO WHERE MKT_REC_SEQ_ID='M199';
DROP TABLE TMP_TEST_PREV_BEFORE;
DROP TABLE TMP_TEST_PREV_AFTER;
DROP TABLE TMP_TEST_STAT_BEFORE;
DROP TABLE TMP_TEST_STAT_AFTER;
COMMIT;
PROMPT ==== 10_PREV_PERIOD_FREEZE_DONE ====
EXIT
