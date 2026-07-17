/*
 * ads_cust_potn_upgrade_statis
 * 中文名称: 潜力提升统计表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS ads_cust_potn_upgrade_statis (
    DATA_DATE VARCHAR(8) NOT NULL COMMENT '数据日期',
    STATIS_OBJ VARCHAR(2) NULL COMMENT '统计对象',
    STATIS_CYCLE VARCHAR(2) NULL COMMENT '统计周期',
    LVL_CRIT VARCHAR(2) NULL COMMENT '临界等级',
    TTL_CUST_CNT NUMBER(8) NULL COMMENT '总客户数',
    MTH_AVG_QUAL_CNT NUMBER(8) NULL COMMENT '月均达标',
    MTH_AVG_QUAL_RATE NUMBER(20,2) NULL COMMENT '月均达标率',
    PNT_QUAL_CNT NUMBER(8) NULL COMMENT '时点达标',
    PNT_QUAL_RATE NUMBER(20,2) NULL COMMENT '时点达标率',
    CNTCT_CUST_CNT NUMBER(8) NULL COMMENT '已接触客户',
    CNTCT_RATE NUMBER(20,2) NULL COMMENT '接触率'
);

COMMENT ON TABLE ads_cust_potn_upgrade_statis IS '潜力提升统计表';
