-- ============================================================
-- Concurrency: two sessions run same batch simultaneously
-- Session A executes the procedure; results asserted after both.
-- Run this twice in parallel shells with SESSION_LABEL param.
-- ============================================================
SET SERVEROUTPUT ON
DECLARE
  v_rc NUMBER;
  v_batch VARCHAR2(8) := '20260803';
BEGIN
  DBMS_OUTPUT.PUT_LINE('SESSION '||USER||' start '||TO_CHAR(SYSDATE,'HH24:MI:SS'));
  PRC_DWD_ACCT_INSUR(v_batch, v_rc);
  DBMS_OUTPUT.PUT_LINE('SESSION '||USER||' rc='||v_rc||' end '||TO_CHAR(SYSDATE,'HH24:MI:SS'));
END;
/
SELECT COUNT(*) AS DWD_ROWS FROM DWD_ACCT_INSUR;
EXIT
