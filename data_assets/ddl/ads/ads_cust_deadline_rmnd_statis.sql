/*
 * ads_cust_deadline_rmnd_statis
 * 中文名称: 到期承接统计表
 * 版本: v1.0
 * 创建时间: 2026-07-17
 */

CREATE TABLE IF NOT EXISTS ads_cust_deadline_rmnd_statis (
    DATA_DATE 8 NOT NULL COMMENT '数据日期',
    STATIS_OBJ 2 NULL COMMENT '统计对象',
    STATIS_CYCLE 2 NULL COMMENT '统计周期',
    STATIS_TYP 2 NULL COMMENT '承接类型1-存款2-理财',
    EXPR_CUST_CNT 8 NULL COMMENT '已到期客户数',
    TTL_EXPR_CUST_CNT 8 NULL COMMENT '总到期客户数',
    EXPR_AMT 20,2 NULL COMMENT '已到期金额',
    TTL_EXPR_AMT 20,2 NULL COMMENT '总到期金额',
    CUST_UNDTAKE_RATE 20,2 NULL COMMENT '客户承接率',
    ASSET_KEEP_RATE 20,2 NULL COMMENT '资产留存率',
    ASSET_UNDTAKE_RATE 20,2 NULL COMMENT '资产承接率',
    DEPO_TO_FIN_CONVRS_RATE 20,2 NULL COMMENT '存款转理财转化率',
    INSUR_CONVRS_RATE 20,2 NULL COMMENT '保险转化率',
    FIN_TO_DEPO_CONVRS_RATE 20,2 NULL COMMENT '理财转存款转化率'
);

COMMENT ON TABLE ads_cust_deadline_rmnd_statis IS '到期承接统计表';
