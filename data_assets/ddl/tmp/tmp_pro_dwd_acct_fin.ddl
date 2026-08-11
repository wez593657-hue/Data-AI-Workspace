-- ============================================================
-- 理财账户处理存储过程临时表建表语句
-- 存储过程名称: PRC_DWD_ACCT_FIN
-- 需求版本: v2.0.0
-- 设计：单层快照架构，1张临时表
--       01: TMP_DWD_ACCT_FIN_ACTIVE 活跃快照表（三键主键粒度）
--           代销(2.1) + 自营(2.2) UNION ALL 合并写入
-- ============================================================

-- 01: 活跃快照表
--     按三键主键(CUST_ID+ACCT_ID+PRDKT_ID)存储当日活跃理财记录，
--     供步骤3 DELETE+INSERT和步骤4到期标记使用
CREATE TABLE IF NOT EXISTS TMP_DWD_ACCT_FIN_ACTIVE (
    cust_id              VARCHAR(20)    NOT NULL,  -- 客户编号(三键主键)
    cust_typ             VARCHAR(2)     NULL,      -- 客户类型('1'=个人)
    acct_id              VARCHAR(40)    NOT NULL,  -- 账户(三键主键)
    card_no              VARCHAR(30)    NULL,      -- 卡/折号
    prdkt_id             VARCHAR(40)    NOT NULL,  -- 产品ID(三键主键)
    prdkt_name           VARCHAR(100)   NULL,      -- 产品名称
    prdkt_cate_big       VARCHAR(64)    NULL,      -- 产品大类(1代销开放/2代销封闭/3自营开放/4自营封闭)
    estab_date           VARCHAR(10)    NULL,      -- 成立日期
    fin_amt              NUMBER(20,2)   NULL,      -- 理财余额(=ROUND(净值×份额,2))
    rate_intri           NUMBER(20,2)   NULL,      -- 收益率(代销=成立以来参考年化/自营=7日年化)
    acct_state           VARCHAR(10)    NULL,      -- 理财账户状态
    intri_bgn_date       VARCHAR(10)    NULL,      -- 起息日期
    expr_date            VARCHAR(10)    NULL,      -- 到期日期
    oprt_org             VARCHAR(7)     NULL,      -- 归属机构
    chnl_no              VARCHAR(10)    NULL,      -- 办理渠道
    persn_legal_bk_code  VARCHAR(4)     NULL,      -- 法人行号(15→1500/12→1200/18→1800/其他→9999)
    issu_org             VARCHAR(6)     NULL,      -- 发行机构
    issu_date            VARCHAR(10)    NULL,      -- 办理日期
    risk_lvl             VARCHAR(2)     NULL,      -- 风险等级
    cfm_amt              NUMBER(20,2)   NULL,      -- 交易确认金额
    PRIMARY KEY (cust_id, acct_id, prdkt_id)
);
