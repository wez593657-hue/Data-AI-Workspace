/*
 * 上游手机系统
 * 表名: crmdm.mbk_mkp_acti_drawn_list
 * 来源: TB.ddl
 */

-- crmdm.mbk_mkp_acti_drawn_list 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_acti_drawn_list;

CREATE TABLE crmdm.mbk_mkp_acti_drawn_list (
    drawn_no varchar(32) NOT NULL,
    busi_type bpchar(1) NOT NULL,
    acti_no varchar(32) NULL,
    prize_detail_no varchar(32) NULL,
    finish_no varchar(32) NULL,
    drawn_time varchar(20) NULL,
    darwn_num numeric NULL,
    grant_way bpchar(1) NULL,
    receive_time varchar(20) NULL,
    cust_no varchar(32) NULL,
    is_delivery bpchar(1) NULL,
    prize_no varchar(32) NULL,
    agpi_no varchar(32) NULL,
    cust_core_no varchar(32) NULL,
    point_redeem_name varchar(32) NULL,
    share_no varchar(32) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_mbk_mkp_acti_drawn_list PRIMARY KEY (drawn_no)
);