/*
 * 上游手机系统
 * 表名: crmdm.mbk_mkp_jl_join_info
 * 来源: TB.ddl
 */

-- crmdm.mbk_mkp_jl_join_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_jl_join_info;

CREATE TABLE crmdm.mbk_mkp_jl_join_info (
    tran_no varchar(32) NOT NULL,
    order_id varchar(64) NOT NULL,
    user_id varchar(64) NULL,
    tran_date varchar(10) NULL,
    tran_time varchar(10) NULL,
    acti_no varchar(64) NULL,
    chnl varchar(6) NULL,
    crm_lvl varchar(20) NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_mbk_mkp_jl_join_info PRIMARY KEY (order_id)
);