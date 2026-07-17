/*
 * DWD层表
 * 表名: crmdm.dwd_acct_loan
 * 来源: TB.ddl
 */

-- crmdm.dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_loan;

CREATE TABLE crmdm.dwd_acct_loan (
	cust_id varchar(20) NOT NULL,
	cust_typ varchar(6) NULL,
	acct_id varchar(40) NOT NULL,
	prdkt_id varchar(40) NOT NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(60) NULL,
	loan_issu_amt numeric(20, 2) NULL,
	loan_issu_date varchar(10) NULL,
	bal numeric(20, 2) NULL,
	rate_intri numeric(10, 4) NULL,
	expr_date varchar(10) NULL,
	acct_state varchar(10) NULL,
	persn_legal_bk_code varchar(4) NULL,
	oprt_org varchar(6) NULL,
	iou_no varchar(100) NULL,
	int_arrears_ttl numeric(20, 2) NULL,
	repay_typ varchar(6) NULL,
	repay_acct_no varchar(30) NULL,
	cate_5lvl varchar(2) NULL
);

