/*
 * 上游理财系统
 * 表名: crmdm.fms_t5_prod_period
 * 来源: TB.ddl
 */

-- crmdm.fms_t5_prod_period 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_period;

CREATE TABLE crmdm.fms_t5_prod_period (
    prod_code varchar(32) NOT NULL,
    booking_begin_date bpchar(8) NULL,
    booking_invalid_date bpchar(8) NULL,
    order_begin_date bpchar(8) NULL,
    subs_begin_date bpchar(8) NOT NULL,
    subs_end_date bpchar(8) NOT NULL,
    value_date bpchar(8) NOT NULL,
    establish_date bpchar(8) NOT NULL,
    first_establish_date bpchar(8) NOT NULL,
    open_begin_date bpchar(8) NULL,
    open_end_date bpchar(8) NULL,
    winding_date bpchar(8) NOT NULL,
    next_winding_date bpchar(8) NULL,
    advance_winding_date bpchar(8) NULL,
    pay_date bpchar(8) NOT NULL,
    ryzd varchar(1) NULL,
    CONSTRAINT pk_fms_t5_prod_period PRIMARY KEY (prod_code,
    establish_date)
);