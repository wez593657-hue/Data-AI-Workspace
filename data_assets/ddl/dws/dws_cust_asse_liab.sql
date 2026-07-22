/*
 * dws_cust_asse_liab
 * 中文名称: 客户资产负债表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS dws_cust_asse_liab (
    DATA_DATE VARCHAR(8) NOT NULL,
    CUST_ID VARCHAR(20) NULL,
    ORG_ID VARCHAR(7) NULL,
    ORG_ID_LOAN VARCHAR(6) NULL,
    BAL_TYPE CHAR(1) NULL,
    AUM_BAL NUMBER(20,
    2) NULL,
    DEPO_BAL NUMBER(20,
    2) NULL,
    DEPO_CURNT_DEPO_BAL NUMBER(20,
    2) NULL,
    FIXD_DEPO_BAL NUMBER(20,
    2) NULL,
    LEHUI_BAL NUMBER(20,
    2) NULL,
    LARGEDP_BAL NUMBER(20,
    2) NULL,
    FIN_BAL NUMBER(20,
    2) NULL,
    INSUR_BAL NUMBER(20,
    2) NULL,
    LOAN_BAL NUMBER(20,
    2) NULL
);

COMMENT ON TABLE dws_cust_asse_liab IS '客户资产负债表';
COMMENT ON COLUMN dws_cust_asse_liab.DATA_DATE IS '数据日期';
COMMENT ON COLUMN dws_cust_asse_liab.CUST_ID IS '客户号';
COMMENT ON COLUMN dws_cust_asse_liab.ORG_ID IS '归属机构';
COMMENT ON COLUMN dws_cust_asse_liab.ORG_ID_LOAN IS '信贷归属机构';
COMMENT ON COLUMN dws_cust_asse_liab.BAL_TYPE IS '类型1-余额2-月日均3-季日均4-年日均';
COMMENT ON COLUMN dws_cust_asse_liab.AUM_BAL IS 'AUM余额';
COMMENT ON COLUMN dws_cust_asse_liab.DEPO_BAL IS '定期余额';
COMMENT ON COLUMN dws_cust_asse_liab.DEPO_CURNT_DEPO_BAL IS '活期余额';
COMMENT ON COLUMN dws_cust_asse_liab.FIXD_DEPO_BAL IS '普通定期余额';
COMMENT ON COLUMN dws_cust_asse_liab.LEHUI_BAL IS '乐惠存产品余额';
COMMENT ON COLUMN dws_cust_asse_liab.LARGEDP_BAL IS '大额存单余额';
COMMENT ON COLUMN dws_cust_asse_liab.FIN_BAL IS '理财余额';
COMMENT ON COLUMN dws_cust_asse_liab.INSUR_BAL IS '保险余额';
COMMENT ON COLUMN dws_cust_asse_liab.LOAN_BAL IS '贷款余额';