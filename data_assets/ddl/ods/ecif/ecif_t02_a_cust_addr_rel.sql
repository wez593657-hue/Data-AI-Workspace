/*
 * 上游ECIF系统
 * 表名: crmdm.ecif_t02_a_cust_addr_rel
 * 来源: TB.ddl
 */

-- crmdm.ecif_t02_a_cust_addr_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_addr_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_addr_rel (
    addr_seq_id bpchar(20) NOT NULL,
    party_id bpchar(20) NOT NULL,
    addr_type varchar(30) NOT NULL,
    addr_id bpchar(20) NULL,
    addr_tab_id bpchar(8) NULL,
    role_id bpchar(20) NULL,
    role_tab_id bpchar(8) NULL,
    last_updated_te varchar(20) NULL,
    last_updated_org varchar(20) NULL,
    created_ts timestamp(6) NULL,
    updated_ts timestamp(6) NULL,
    init_system_id varchar(30) NOT NULL,
    init_created_ts timestamp(6) NULL,
    last_system_id varchar(30) NOT NULL,
    last_updated_ts timestamp(6) NULL,
    ryzd varchar(1) NULL
);