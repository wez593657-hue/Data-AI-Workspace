-- ============================================================
-- New-customer validation environment (SCOTT, Oracle 11g syntax)
-- ============================================================
BEGIN
  FOR t IN (SELECT table_name FROM user_tables
             WHERE table_name IN (
               'ADS_CUST_NEW_CUST_DTL','ADS_CUST_NEW_CUST_STATIS',
               'TMP_ADS_NEW_CUST_BASE','TMP_ADS_NEW_CUST_STAT_SRC',
               'DWD_CUST_INDV_KYC')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name;
  END LOOP;
END;
/

CREATE TABLE DWD_CUST_INDV_KYC (
    CUST_ID              VARCHAR2(20) NOT NULL,
    CUST_NM              VARCHAR2(100),
    BK_OUTER_DEPO        NUMBER(20),
    BK_OUTER_FIN         NUMBER(20),
    BK_OUTER_FUND        NUMBER(20),
    BK_OUTER_INSUR       NUMBER(20),
    BK_OUTER_GOLD        NUMBER(20),
    STK_INVEST           VARCHAR2(2),
    ESTT_INF             VARCHAR2(2),
    PROP_OWNER_CERT_NO   VARCHAR2(60),
    HOUSE_AREA           NUMBER(10),
    IS_HOUSE_MORTGAGED   VARCHAR2(1),
    RES_ADDRS            VARCHAR2(254),
    SHOP_INVEST          VARCHAR2(2),
    VIKL_INF             VARCHAR2(2),
    VEHICLE_PLATE_NO     VARCHAR2(10),
    USAGE_NATURE         VARCHAR2(100),
    IS_CAR_LOAN          VARCHAR2(2),
    IS_CAR_MORTGAGED     VARCHAR2(2),
    MTH_INCOM            NUMBER(20),
    YR_INCOM             NUMBER(20),
    BK_OUTER_LOAN_BAL    NUMBER(20),
    BK_OUTER_CRDT_LMT    NUMBER(20),
    AVAIL_LMT            NUMBER(20),
    CREATR               VARCHAR2(20),
    CREAT_ORG            VARCHAR2(7),
    CREAT_TIME           VARCHAR2(20)
);

CREATE TABLE TMP_ADS_NEW_CUST_BASE (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    NEW_CUST_CYCLE      VARCHAR2(1),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    CNTCT_STATE         VARCHAR2(1),
    KYC_STATE           VARCHAR2(1),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7)
);

CREATE TABLE TMP_ADS_NEW_CUST_STAT_SRC (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    STATIS_CYCLE        VARCHAR2(2),
    STATIS_OBJ          VARCHAR2(20),
    NEW_CUST_CYCLE      VARCHAR2(1),
    CNTCT_STATE         VARCHAR2(1),
    KYC_STATE           VARCHAR2(1),
    PNT_AUM_BAL         NUMBER(20,2)
);

CREATE TABLE ADS_CUST_NEW_CUST_DTL (
    PERSN_LEGAL_BK_CODE VARCHAR2(4),
    DATA_DATE           VARCHAR2(8),
    CUST_ID             VARCHAR2(20),
    CUST_NAME           VARCHAR2(100),
    CUST_LVL            VARCHAR2(2),
    NEW_CUST_CYCLE      VARCHAR2(1),
    DEPO_CURNT_DEPO_BAL NUMBER(20,2),
    FIXD_DEPO_BAL       NUMBER(20,2),
    FIN_AMT             NUMBER(20,2),
    CNTCT_STATE         VARCHAR2(1),
    KYC_STATE           VARCHAR2(1),
    POST_ID             VARCHAR2(20),
    ORG_ID              VARCHAR2(7),
    STATIS_CYCLE        VARCHAR2(2)
);

CREATE TABLE ADS_CUST_NEW_CUST_STATIS (
    PERSN_LEGAL_BK_CODE   VARCHAR2(4),
    DATA_DATE             VARCHAR2(8),
    STATIS_OBJ            VARCHAR2(20),
    STATIS_CYCLE          VARCHAR2(2),
    NEW_CUST_CYCLE        VARCHAR2(1),
    NEW_CUST_CNT          NUMBER(8),
    CNTCT_CUST_CNT        NUMBER(8),
    ASSET_BAL_SEG1_CUST_CNT NUMBER(8),
    ASSET_BAL_SEG2_CUST_CNT NUMBER(8),
    ASSET_BAL_SEG3_CUST_CNT NUMBER(8),
    ASSET_BAL_SEG4_CUST_CNT NUMBER(8),
    ASSET_BAL_SEG5_CUST_CNT NUMBER(8),
    CNTCT_RATE            NUMBER(20,2),
    KYC_CUST_CNT          NUMBER(8),
    COMP_RATE             NUMBER(20,2)
);

PROMPT SETUP_NEWCUST_TABLES_DONE

