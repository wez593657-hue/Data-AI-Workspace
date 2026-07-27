-- crmdm.cds_tb_cust_trans_log 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_cust_trans_log;

CREATE TABLE crmdm.cds_tb_cust_trans_log (
	trans_serno varchar(32) NOT NULL, -- 系统交易流水号
	trans_date bpchar(8) NOT NULL, -- 交易日期
	business_serno varchar(32) NULL, -- 业务流水号
	channel_serno varchar(32) NULL, -- 渠道流水号
	cash_acct_no varchar(32) NULL, -- 虚拟账号编号
	reserve varchar(32) NULL, -- 传票号
	trans_type bpchar(2) NOT NULL, -- 交易类型 00：签约01：解约02：购买03：支取04： 解约结息05：支取结息06：开户 07：销户 08：质押 09：转让10：定期还本金11-计提 12-活期增值置顶 13: 单笔兑付 14: 批量续存 23: 司法扣划
	fnc_trans_acct_no bpchar(17) NULL, -- 理财交易账号
	card_no varchar(32) NULL, -- 卡号
	cust_no bpchar(8) NULL, -- 客户号
	cust_name varchar(128) NULL, -- 客户名称
	id_type varchar(2) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	mobile varchar(20) NULL, -- 电话
	cust_type bpchar(1) NULL, -- 客户类型
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型
	exclusive_code bpchar(4) NULL, -- 专享码 字母不区分大小写
	ori_trans_serno varchar(32) NULL, -- 原系统交易流水号
	agr_sav_rate numeric(12, 5) NULL, -- 协定利率(协定产品)
	agr_term varchar(4) NULL, -- 协定存期(协定产品)
	term_acct_no varchar(32) NULL, -- 定期、专户账户
	buy_type bpchar(1) NULL, -- 定期购买方式0-活期账号购买1-定期账号购买
	acct_no varchar(32) NULL, -- 活期账户
	trans_amt numeric(16, 2) NULL, -- 交易金额
	prod_code varchar(32) NULL, -- 产品代码
	agent_name varchar(128) NULL, -- 经办人姓名
	agent_id_type varchar(2) NULL, -- 经办人证件类型
	agent_id_code varchar(32) NULL, -- 经办人证件号码
	cust_manager varchar(20) NULL, -- 客户经理代码
	trans_status bpchar(2) NOT NULL, -- 交易状态（00未处理 01交易超时 02交易成功 03交易失败 07交易处理中 99其他）
	rtn_code varchar(16) NULL, -- 返回码
	rtn_desc varchar(256) NULL, -- 返回信息
	host_trans_serno varchar(32) NULL, -- 主机流水号
	host_rtn_code varchar(16) NULL, -- 主机返回码
	host_rtn_desc varchar(256) NULL, -- 主机返回信息
	oper_teller varchar(20) NOT NULL, -- 操作柜员
	auth_teller varchar(20) NULL, -- 授权柜员
	daily_batch bpchar(1) NULL, -- 日间批量0:日间，1:批量用于区分数据是日间交易插入的，还是跑批时插入到的
	remark varchar(256) NULL, -- 备注
	capital_status bpchar(2) NOT NULL, -- 资金状态（00未处理 01已冲正 02冲正失败 03冲正超时 04扣款成功 05扣款失败 06扣款超时07还款成功08还款失败09还款超时 10其他
	trans_channel bpchar(1) NOT NULL, -- 交易渠道
	trans_orgno varchar(20) NOT NULL, -- 交易机构
	trans_branch varchar(20) NOT NULL, -- 交易机构所属分行
	trans_head_office varchar(20) NOT NULL, -- 交易机构所属总行
	card_orgno varchar(20) NOT NULL, -- 开户机构
	card_branch varchar(20) NOT NULL, -- 开户机构所属分行
	card_head_office varchar(20) NOT NULL, -- 开户机构所属总行
	exp_date bpchar(8) NULL, -- 失效日期
	should_date bpchar(8) NOT NULL, -- 应该执行日 日间交易不走审批的，直接 插入当前工作日，如走审批的则更新为走审批的工作日
	term_serial_no varchar(32) NULL, -- 定期/专户序号
	card_serno varchar(20) NULL, -- 活期账号子序号
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	oper_orgno varchar(20) NOT NULL, -- OPER_ORGNO
	agent_phone_num varchar(18) NULL, -- 代理人联系方式
	agent_nationality varchar(32) NULL, -- 代理人国籍
	agent_english_name varchar(32) NULL, -- 代理人英文名
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_tb_cust_trans_log PRIMARY KEY (trans_serno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_serno IS '系统交易流水号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_date IS '交易日期';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.business_serno IS '业务流水号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.channel_serno IS '渠道流水号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cash_acct_no IS '虚拟账号编号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.reserve IS '传票号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_type IS '交易类型 00：签约01：解约02：购买03：支取04： 解约结息05：支取结息06：开户 07：销户 08：质押 09：转让10：定期还本金11-计提 12-活期增值置顶 13: 单笔兑付 14: 批量续存 23: 司法扣划';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.card_no IS '卡号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.mobile IS '电话';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cust_card_type IS '客户卡类型';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.exclusive_code IS '专享码 字母不区分大小写';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.ori_trans_serno IS '原系统交易流水号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agr_sav_rate IS '协定利率(协定产品)';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agr_term IS '协定存期(协定产品)';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.term_acct_no IS '定期、专户账户';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.buy_type IS '定期购买方式0-活期账号购买1-定期账号购买';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.acct_no IS '活期账户';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_amt IS '交易金额';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agent_name IS '经办人姓名';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agent_id_type IS '经办人证件类型';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agent_id_code IS '经办人证件号码';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_status IS '交易状态（00未处理 01交易超时 02交易成功 03交易失败 07交易处理中 99其他）';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.rtn_code IS '返回码';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.rtn_desc IS '返回信息';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.host_trans_serno IS '主机流水号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.host_rtn_code IS '主机返回码';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.host_rtn_desc IS '主机返回信息';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.oper_teller IS '操作柜员';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.auth_teller IS '授权柜员';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.daily_batch IS '日间批量0:日间，1:批量用于区分数据是日间交易插入的，还是跑批时插入到的';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.remark IS '备注';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.capital_status IS '资金状态（00未处理 01已冲正 02冲正失败 03冲正超时 04扣款成功 05扣款失败 06扣款超时07还款成功08还款失败09还款超时 10其他';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_channel IS '交易渠道';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_orgno IS '交易机构';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_branch IS '交易机构所属分行';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.trans_head_office IS '交易机构所属总行';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.card_orgno IS '开户机构';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.card_branch IS '开户机构所属分行';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.card_head_office IS '开户机构所属总行';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.exp_date IS '失效日期';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.should_date IS '应该执行日 日间交易不走审批的，直接 插入当前工作日，如走审批的则更新为走审批的工作日';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.term_serial_no IS '定期/专户序号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.card_serno IS '活期账号子序号';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.oper_orgno IS 'OPER_ORGNO';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agent_phone_num IS '代理人联系方式';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agent_nationality IS '代理人国籍';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.agent_english_name IS '代理人英文名';
COMMENT ON COLUMN crmdm.cds_tb_cust_trans_log.ryzd IS '冗余字段';
