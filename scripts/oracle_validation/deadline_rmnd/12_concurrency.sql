-- ============================================================
-- Concurrency: two sessions run DTL+STATIS same batch
-- Run twice in parallel shells.
-- ============================================================
SET SERVEROUTPUT ON
DECLARE
  v_rc NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('SESSION '||USER||' start '||TO_CHAR(SYSDATE,'HH24:MI:SS'));
  PRC_ADS_CUST_DEADLINE_RMND_DTL('20260630', v_rc);
  DBMS_OUTPUT.PUT_LINE('DTL rc='||v_rc||' '||TO_CHAR(SYSDATE,'HH24:MI:SS'));
  PRC_ADS_CUST_DEADLINE_RMND_ST('20260630', v_rc);
  DBMS_OUTPUT.PUT_LINE('STATIS rc='||v_rc||' end '||TO_CHAR(SYSDATE,'HH24:MI:SS'));
END;
/
SELECT COUNT(*) AS DTL_ROWS FROM ADS_CUST_DEADLINE_RMND_DTL;
EXIT
