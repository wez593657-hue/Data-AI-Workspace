-- ============================================================
-- Potn-upgrade validation environment (SCOTT, Oracle 11g syntax)
-- Intermediate + target tables for
-- PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL / PRC_ADS_CUST_POTN_UPGRADE_STATIS
-- ============================================================
BEGIN
  FOR t IN (SELECT table_name FROM user_tables
             WHERE table_name IN (
               'ADS_CUST_POTN_UPGRADE_CUST_DTL','ADS_CUST_POTN_UPGRADE_STATIS',
               'TMP_ADS_POTN_BASE','TMP_ADS_POTN_STAT_SRC')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name;
  END LOOP;
END;
/

CREATE TABLE TMP_ADS_POTN_BASE (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    LVL_CRIT            VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    CURR_MTH_AVG_AUM    NUMBER(20,2),
    PNT_AUM_BAL         NUMBER(20,2),
    CNTCT_STATE_M       VARCHAR2(1),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7)
);

CREATE TABLE TMP_ADS_POTN_STAT_SRC (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_CYCLE        VARCHAR2(2),
    STATIS_OBJ          VARCHAR2(20),
    LVL_CRIT            VARCHAR2(2),
    MTH_AVG_QUAL_STATE  VARCHAR2(1),
    PNT_QUAL_STATE      VARCHAR2(1),
    CNTCT_STATE         VARCHAR2(1)
);

CREATE TABLE ADS_CUST_POTN_UPGRADE_CUST_DTL (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    LVL_CRIT            VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    CNTCT_STATE         VARCHAR2(1),
    QUAL_STATE          VARCHAR2(1),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7),
    STATIS_CYCLE        VARCHAR2(2)
);

CREATE TABLE ADS_CUST_POTN_UPGRADE_STATIS (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_OBJ          VARCHAR2(20),
    STATIS_CYCLE        VARCHAR2(2),
    LVL_CRIT            VARCHAR2(2),
    TTL_CUST_CNT        NUMBER(8),
    MTH_AVG_QUAL_CNT    NUMBER(8),
    MTH_AVG_QUAL_RATE   NUMBER(20,2),
    PNT_QUAL_CNT        NUMBER(8),
    PNT_QUAL_RATE       NUMBER(20,2),
    CNTCT_CUST_CNT      NUMBER(8),
    CNTCT_RATE          NUMBER(20,2)
);

PROMPT SETUP_POTN_TABLES_DONE
