-- crmdm.mbk_mkp_acti_drawn_list 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_acti_drawn_list;

CREATE TABLE crmdm.mbk_mkp_acti_drawn_list (
	drawn_no varchar(32) NOT NULL, -- 中奖记录编号
	busi_type bpchar(1) NOT NULL, -- 业务类型1:游戏  2：直接领取 3：第三方活动 4：积分兑换的奖品
	acti_no varchar(32) NULL, -- 活动编号
	prize_detail_no varchar(32) NULL, -- 奖品明细编号（奖品类型为外部卡券时，此字段必输）
	finish_no varchar(32) NULL, -- 活动完成编号
	drawn_time varchar(20) NULL, -- 中奖时间
	darwn_num numeric NULL, -- 奖品数量
	grant_way bpchar(1) NULL, -- 发放方式 1-平方发放 2-邮寄 3-现场领取
	receive_time varchar(20) NULL, -- 领取时间
	cust_no varchar(32) NULL, -- 中奖客户号
	is_delivery bpchar(1) NULL, -- 是否中奖   0-没中奖  1-中奖
	prize_no varchar(32) NULL, -- 奖品编号
	agpi_no varchar(32) NULL, -- 奖项编号（具体等级奖品编号）
	cust_core_no varchar(32) NULL, -- 核心客户号
	point_redeem_name varchar(32) NULL, -- 积分兑换奖品的名称
	share_no varchar(32) NULL, -- 分享关系号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_acti_drawn_list PRIMARY KEY (drawn_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.drawn_no IS '中奖记录编号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.busi_type IS '业务类型1:游戏  2：直接领取 3：第三方活动 4：积分兑换的奖品';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.acti_no IS '活动编号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.prize_detail_no IS '奖品明细编号（奖品类型为外部卡券时，此字段必输）';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.finish_no IS '活动完成编号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.drawn_time IS '中奖时间';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.darwn_num IS '奖品数量';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.grant_way IS '发放方式 1-平方发放 2-邮寄 3-现场领取';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.receive_time IS '领取时间';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.cust_no IS '中奖客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.is_delivery IS '是否中奖   0-没中奖  1-中奖';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.prize_no IS '奖品编号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.agpi_no IS '奖项编号（具体等级奖品编号）';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.cust_core_no IS '核心客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.point_redeem_name IS '积分兑换奖品的名称';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.share_no IS '分享关系号';
COMMENT ON COLUMN crmdm.mbk_mkp_acti_drawn_list.ryzd IS '冗余字段';
