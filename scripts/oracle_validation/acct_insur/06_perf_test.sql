-- ============================================================
-- Performance: 10k / 30k / 50k policies x 2 successful transactions
-- Prerequisite: run 01_setup_tables.sql and deploy PRC_DWD_ACCT_INSUR.sql.
-- ============================================================
SET SERVEROUTPUT ON
SET PAGESIZE 200

DECLARE
  v_rc    NUMBER;
  v_t1    NUMBER;
  v_t2    NUMBER;
  v_sec   NUMBER;
  v_rows  NUMBER;
  v_batch VARCHAR2(8) := '20260803';
BEGIN
  FOR rec IN (SELECT 10000 AS n FROM dual UNION ALL
              SELECT 30000 FROM dual UNION ALL
              SELECT 50000 FROM dual) LOOP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE YBT_YBT_POLICY_BASE_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE YBT_YBT_POLICY_FEE_LIST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE IBP_IB_LIST_PLAT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE YBT_YBT_POLICY_INSURANCE_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE YBT_YBT_PRODUCT_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DWD_ACCT_INSUR';

    EXECUTE IMMEDIATE
      'INSERT INTO YBT_YBT_PRODUCT_INFO(PRODUCT_ID, PRODUCT_NAME, PRODUCT_BIG_TYPE)
       SELECT ''P001'', ''Life'', ''01'' FROM dual';
    EXECUTE IMMEDIATE
      'INSERT INTO YBT_YBT_POLICY_BASE_INFO
          (PLAT_POLICY_SERIAL, ITEM_ID, CONT_NO, PROPOSAL_PRT_NO, ACCEPT_DATE,
           VALI_DATE, PRODUCT_ID, PRODUCT_NAME, CONT_STATUS, CONT_SOURCE, ACC_NO, THROW_COM)
       SELECT ''PL'' || LPAD(LEVEL, 8, ''0''), ''104001'', ''C'' || LEVEL,
              ''B'' || LEVEL, ''20260101'', ''20260101'', ''P001'', ''Life'',
              ''1'', ''0'', ''ACCT'' || LEVEL, ''120000000001''
         FROM dual CONNECT BY LEVEL <= ' || rec.n;
    EXECUTE IMMEDIATE
      'INSERT INTO YBT_YBT_POLICY_INSURANCE_INFO
          (PLAT_POLICY_SERIAL, PAY_TYPE, PAY_FREQ, PAY_PER_UNIT, PAY_PER_NUM, VALID_PER_UNIT, VALID_PER_NUM)
       SELECT ''PL'' || LPAD(LEVEL, 8, ''0''), ''1'', ''12'', ''12'', 10, ''12'', 20
         FROM dual CONNECT BY LEVEL <= ' || rec.n;
    EXECUTE IMMEDIATE
      'INSERT INTO YBT_YBT_POLICY_FEE_LIST
          (PLAT_POLICY_SERIAL, ORD_AMT, ORD_PAY_SERIAL, ORD_CREATE_DATE, TRAN_TYPE, ORD_TRAN_STATUS)
       SELECT ''PL'' || LPAD(CEIL(LEVEL / 2), 8, ''0''), 10000,
              ''ORD'' || LPAD(LEVEL, 8, ''0''),
              TO_CHAR(TO_DATE(''20260101'', ''YYYYMMDD'') + MOD(LEVEL, 60), ''YYYYMMDD''),
              CASE MOD(LEVEL, 2) WHEN 1 THEN ''0'' ELSE ''1'' END, ''2''
         FROM dual CONNECT BY LEVEL <= ' || (rec.n * 2);
    EXECUTE IMMEDIATE
      'INSERT INTO IBP_IB_LIST_PLAT(PLAT_SERIAL, PLAT_DATE, PLAT_TRAD_STATUS, USER_ID, TRAN_DATE)
       SELECT ''ORD'' || LPAD(LEVEL, 8, ''0''), ''20260101'', ''2'', ''100000000001'', ''20260101''
         FROM dual CONNECT BY LEVEL <= ' || (rec.n * 2);

    v_t1 := DBMS_UTILITY.GET_TIME;
    PRC_DWD_ACCT_INSUR(v_batch, v_rc);
    v_t2 := DBMS_UTILITY.GET_TIME;
    v_sec := (v_t2 - v_t1) / 100;
    SELECT COUNT(*) INTO v_rows FROM DWD_ACCT_INSUR;
    DBMS_OUTPUT.PUT_LINE(
        'N=' || rec.n || ' policies | SEC=' || ROUND(v_sec, 2)
        || ' | DWD_ROWS=' || v_rows || ' | rc=' || v_rc
    );
  END LOOP;
END;
/

EXIT
