/*
 * ads_cust_sleep_wake_statis
 * 中文名称: 睡眠户唤醒统计表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS ads_cust_sleep_wake_statis (
    DATA_DATE VARCHAR(8) NOT NULL COMMENT '数据日期',
    STATIS_OBJ VARCHAR(2) NULL COMMENT '统计对象',
    STATIS_CYCLE VARCHAR(2) NULL COMMENT '统计周期',
    CUST_CNT NUMBER(8) NULL COMMENT '客户数',
    CNTCT_CUST_CNT NUMBER(8) NULL COMMENT '已接触客户',
    CNTCT_RATE NUMBER(20,2) NULL COMMENT '接触率',
    WAKE_CUST_CNT NUMBER(8) NULL COMMENT '已唤醒客户',
    WAKE_RATE NUMBER(20,2) NULL COMMENT '唤醒率'
);

COMMENT ON TABLE ads_cust_sleep_wake_statis IS '睡眠户唤醒统计表';
