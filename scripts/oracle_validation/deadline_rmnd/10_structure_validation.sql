-- ============================================================
-- Structure & integrity validation for deadline tables
-- ============================================================
SET PAGESIZE 300
SET LINESIZE 200

PROMPT ============ STR1 DTL columns (expect 25) ============
SELECT column_name, data_type, data_length, nullable
  FROM user_tab_columns WHERE table_name='ADS_CUST_DEADLINE_RMND_DTL'
 ORDER BY column_id;

PROMPT ============ STR2 STATIS columns (expect 15) ============
SELECT column_name, data_type, data_length, nullable
  FROM user_tab_columns WHERE table_name='ADS_CUST_DEADLINE_RMND_STATIS'
 ORDER BY column_id;

PROMPT ============ STR3 Constraints & indexes ============
SELECT table_name, COUNT(*) AS constraint_cnt FROM user_constraints
 WHERE table_name IN ('ADS_CUST_DEADLINE_RMND_DTL','ADS_CUST_DEADLINE_RMND_STATIS')
 GROUP BY table_name;
SELECT table_name, COUNT(*) AS index_cnt FROM user_indexes
 WHERE table_name IN ('ADS_CUST_DEADLINE_RMND_DTL','ADS_CUST_DEADLINE_RMND_STATIS')
 GROUP BY table_name;
SELECT CASE WHEN (SELECT COUNT(*) FROM user_constraints
                  WHERE table_name IN ('ADS_CUST_DEADLINE_RMND_DTL','ADS_CUST_DEADLINE_RMND_STATIS')
                    AND constraint_type='P') = 0 THEN 'NO-PK' ELSE 'HAS-PK' END AS PK_STATUS
  FROM dual;
SELECT CASE WHEN (SELECT COUNT(*) FROM user_indexes
                  WHERE table_name IN ('ADS_CUST_DEADLINE_RMND_DTL','ADS_CUST_DEADLINE_RMND_STATIS')) = 0
            THEN 'NO-INDEX' ELSE 'HAS-INDEX' END AS INDEX_STATUS
  FROM dual;

EXIT
