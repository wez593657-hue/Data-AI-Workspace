-- ============================================================
-- Sleep-wake validation environment (SCOTT, Oracle 11g syntax)
-- ============================================================
BEGIN
  FOR t IN (SELECT table_name FROM user_tables
             WHERE table_name IN (
               'ADS_CUST_SLEEP_WAKE_DTL','ADS_CUST_SLEEP_WAKE_STATIS',
               'TMP_ADS_SLEEP_WAKE_BASE','TMP_ADS_SLEEP_CANDIDATE','TMP_ADS_SLEEP_STAT_SRC',
               'DWD_TX_ASET')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name;
  END LOOP;
END;
/

CREATE TABLE DWD_TX_ASET (
    SEQ_ID               VARCHAR2(40) NOT NULL,
    CUST_ID              VARCHAR2(21),
    CUST_TYP             VARCHAR2(4),
    ACCT_ID              VARCHAR2(40),
    PRDKT_CATE_BIG       VARCHAR2(6),
    PRDKT_ID             VARCHAR2(40),
    TX_CHNL              VARCHAR2(10),
    TX_DATE              VARCHAR2(10),
    TX_TIME              VARCHAR2(20),
    CCY_CD               VARCHAR2(6),
    TX_TYP               VARCHAR2(6),
    AMT                  NUMBER(18,4),
    TX_TYP_NAME          VARCHAR2(80),
    TX_ORG               VARCHAR2(7),
    OPRTR                VARCHAR2(20),
    LOAN_FLG             VARCHAR2(3),
    ACCT_BAL             NUMBER(18,4),
    TX_DSC               VARCHAR2(200),
    JIOYCFFS             VARCHAR2(1),
    OPNT_ACCT            VARCHAR2(32),
    OPNT_ACCT_NAME_FST   VARCHAR2(200),
    OPNT_BK_KEEP         VARCHAR2(20),
    OPNT_NAME_BK         VARCHAR2(200),
    FEE_HAND             NUMBER(18,4),
    ACCT_BLNG_ORG        VARCHAR2(7),
    CARD_NO              VARCHAR2(30),
    PERSN_LEGAL_BK_CODE  VARCHAR2(30)
);

CREATE TABLE TMP_ADS_SLEEP_WAKE_BASE (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    INSUR_AMT           NUMBER(20,2),
    CNTCT_STATE         VARCHAR2(1),
    WAKE_STATE          VARCHAR2(1),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7)
);

CREATE TABLE TMP_ADS_SLEEP_CANDIDATE (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    INSUR_AMT           NUMBER(20,2),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7)
);

CREATE TABLE TMP_ADS_SLEEP_STAT_SRC (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_CYCLE        VARCHAR2(2),
    STATIS_OBJ          VARCHAR2(20),
    CNTCT_STATE         VARCHAR2(1),
    WAKE_STATE          VARCHAR2(1)
);

CREATE TABLE ADS_CUST_SLEEP_WAKE_DTL (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    INSUR_AMT           NUMBER(20,2),
    CNTCT_STATE         VARCHAR2(1),
    WAKE_STATE          VARCHAR2(1),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7),
    STATIS_CYCLE        VARCHAR2(2)
);

CREATE TABLE ADS_CUST_SLEEP_WAKE_STATIS (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_OBJ          VARCHAR2(20),
    STATIS_CYCLE        VARCHAR2(2),
    CUST_CNT            NUMBER(8),
    CNTCT_CUST_CNT      NUMBER(8),
    CNTCT_RATE          NUMBER(20,2),
    WAKE_CUST_CNT       NUMBER(8),
    WAKE_RATE           NUMBER(20,2)
);

PROMPT SETUP_SLEEP_TABLES_DONE
