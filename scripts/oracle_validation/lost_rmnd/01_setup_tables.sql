-- ============================================================
-- Lost-recovery validation environment (SCOTT, Oracle 11g syntax)
-- NOTE: ADS_CUST_LOST_DTL includes RESCUED_FINA_ASSET column
-- (required by procedure; source DDL file lacks it - see DEFECTS.md)
-- ============================================================
BEGIN
  FOR t IN (SELECT table_name FROM user_tables
             WHERE table_name IN (
               'ADS_CUST_LOST_DTL','ADS_CUST_LOST_STATIS',
               'TMP_ADS_LOST_BASE','TMP_ADS_LOST_STAT_SRC')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name;
  END LOOP;
END;
/

CREATE TABLE TMP_ADS_LOST_BASE (
    PERSN_LEGAL_BK_CODE     VARCHAR2(4),
    CUST_ID                 VARCHAR2(20),
    CUST_NAME               VARCHAR2(100),
    CUST_LVL                VARCHAR2(2),
    LVL_CHURN               VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL     NUMBER(20,2),
    FIXD_DEPO_BAL           NUMBER(20,2),
    FIN_AMT                 NUMBER(20,2),
    CNTCT_STATE_M           VARCHAR2(1),
    RESCUE_STATE            VARCHAR2(1),
    CUR_AUM_BAL             NUMBER(20,2),
    LAST_MONTH_END_AUM_BAL  NUMBER(20,2),
    POST_ID                 VARCHAR2(20),
    ORG_ID                  VARCHAR2(7)
);

CREATE TABLE TMP_ADS_LOST_STAT_SRC (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_CYCLE        VARCHAR2(2),
    STATIS_OBJ          VARCHAR2(20),
    LVL_CHURN           VARCHAR2(2),
    CNTCT_STATE         VARCHAR2(1),
    RESCUE_STATE        VARCHAR2(1),
    RESCUED_FINA_ASSET  NUMBER(20,2)
);

CREATE TABLE ADS_CUST_LOST_DTL (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    LVL_CHURN           VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    CNTCT_STATE         VARCHAR2(1),
    RESCUE_STATE        VARCHAR2(1),
    RESCUED_FINA_ASSET  NUMBER(20,2),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7),
    STATIS_CYCLE        VARCHAR2(2)
);

CREATE TABLE ADS_CUST_LOST_STATIS (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_OBJ          VARCHAR2(20),
    STATIS_CYCLE        VARCHAR2(2),
    LVL_CHURN           VARCHAR2(1),
    CUST_CNT            NUMBER(8),
    CNTCT_CUST_CNT      NUMBER(8),
    CNTCT_RATE          NUMBER(20,2),
    RESCUED_CUST_CNT    NUMBER(8),
    RESCUE_RATE         NUMBER(20,2),
    RESCUED_FINA_ASSET  NUMBER(20,2)
);

PROMPT SETUP_LOST_TABLES_DONE
