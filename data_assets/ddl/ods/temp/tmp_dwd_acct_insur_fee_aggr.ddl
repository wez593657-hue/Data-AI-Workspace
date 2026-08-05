-- crmdm.tmp_dwd_acct_insur_fee_aggr 定义
-- 用途：PRC_DWD_ACCT_INSUR v2.4.0 预聚合FEE_LIST交易日期临时表
--       一次扫描YBT_YBT_POLICY_FEE_LIST，聚合成功缴费/终止/续期日期，
--       供[A0b]快照段落JOIN使用，消除FEE_LIST双重扫描(F-10)，
--       并预计算最近续期日期供60天宽限期判定(F-05)
-- 版本：v2.4.0

-- Drop table
-- DROP TABLE crmdm.tmp_dwd_acct_insur_fee_aggr;

CREATE TABLE crmdm.tmp_dwd_acct_insur_fee_aggr (
    plat_policy_serial        varchar(200) NOT NULL,  -- 保单平台流水号(FEE_LIST→POLICY_BASE_INFO关联键)
    last_success_tx_date      date         NULL,      -- 最近成功缴费日期(ORD_TRAN_STATUS='2')
    actl_term_date_parsed     date         NULL,      -- 实际终止日期(状态交易TRAN_TYPE 2/3/4/5/6/8)
    last_renewal_date_parsed  date         NULL,      -- 最近续期日期(TRAN_TYPE='1'，F-05 60天宽限期基准)
    PRIMARY KEY (plat_policy_serial)
);
