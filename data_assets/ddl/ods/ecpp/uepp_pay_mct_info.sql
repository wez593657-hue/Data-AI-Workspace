-- crmdm.uepp_pay_mct_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_info;

CREATE TABLE crmdm.uepp_pay_mct_info (
	mct_id varchar(40) NOT NULL, -- 商户号
	"name" varchar(300) NOT NULL, -- 商户全称
	short_name varchar(100) NOT NULL, -- 商户简称
	category_id varchar(40) NULL, -- 行业子类目
	mct_type varchar(20) NULL, -- 商户类型 company-企业， institution-党政机关/事业单位, otherOrganizations-其他组织，personage-个体商户， smallBusinesses-小微商户
	phone varchar(20) NULL, -- 电话
	email varchar(200) NULL, -- 邮箱
	website varchar(300) NULL, -- 网址
	contacts varchar(40) NULL, -- 负责人
	contacts_cert_type varchar(2) NULL, -- 负责人证件类型 01-身份证 02-港澳通行证 03-台湾通行证 04-护照 05-其他
	contacts_cert_no varchar(50) NULL, -- 负责人证件号
	contacts_cert_back_url varchar(300) NULL, -- 负责人证件反面图片地址
	contacts_cert_face_url varchar(300) NULL, -- 负责人证件正面图片地址
	contacts_phone varchar(20) NULL, -- 负责人电话
	customer_phone varchar(20) NULL, -- 客服电话
	chain_id varchar(40) NULL, -- 所属连锁商户
	mct_dept_id varchar(40) NULL, -- 所属商户部门
	is_own_data varchar(1) NULL, -- 是否 独立基础资料  直营商户或者加盟商户
	is_settle_acc varchar(1) NULL, -- 是否  独立结算卡信息
	agree_url varchar(300) NULL, -- 协议图片路径
	shop_url varchar(300) NULL, -- 门头照图片路径
	settle_type varchar(2) NULL, -- 清算类型 T0：T+0当日清算  T1：T+1下日清算
	province varchar(10) NULL, -- 省
	city varchar(10) NULL, -- 市
	area varchar(10) NULL, -- 区
	address varchar(300) NULL, -- 详细地址
	dit_id varchar(40) NULL, -- 所属渠道商
	org_id varchar(40) NULL, -- 所属机构
	job_id varchar(40) NULL, -- 所属业务人员/客户经理编号
	remark varchar(300) NULL, -- 备注
	check_status varchar(2) NULL, -- 审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过
	status varchar(2) NULL, -- 状态 0-正常（可交易） 1-未生效 2-冻结 3-待第三方确认 9-注销
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	lng varchar(30) NULL, -- 经度
	lat varchar(30) NULL, -- 纬度
	sign_date varchar(10) NULL, -- 商户签约日期
	is_become_t0_flag varchar(1) NULL, -- 是否可以成为T+0商户标识 0：否 1：是
	mct_logo_url varchar(100) NULL, -- 商户logo图路径
	check_task_id varchar(40) NULL, -- 当前审核任务ID
	banker_id varchar(40) NULL, -- 商户所属银行家ID
	banker_name varchar(100) NULL, -- 商户所属银行家名称
	category_parent_id varchar(40) NULL, -- 行业父类目
	risk_level varchar(2) NULL, -- 风险等级 A- A级  B-B级 C-C级 D-D级 W-未评定
	rade_area_id varchar(10) NULL, -- 商圈编号
	from_way varchar(10) NULL, -- 入驻渠道来源  app-app端  pc-pc后管
	cancel_date varchar(8) NULL, -- 注销日期/解约日期  当商户注销的时候使用
	last_org_trf_id varchar(40) NULL, -- 商户最后一次机构变更流水
	last_cmg_trf_id varchar(40) NULL, -- 商户最后一次客户经理变更流水
	month_deposit numeric(16, 2) NULL, -- 月日均存款额
	season_deposit numeric(16, 2) NULL, -- 季日均存款额
	shop_back_url varchar(300) NULL, -- 商户店内照片路径
	yunhorn varchar(20) NULL, -- 0 关闭云喇叭推送 1开启云喇叭推送
	expire_check_type varchar(2) NULL, -- 过期提醒类型 0-无需提醒1-身份证将到期需提醒2-营业执照将到期需提醒3-均要到期需提醒4-已过期
	company_size varchar(2) NULL, -- 企业规模 1 大型 、 2 小型
	order_remark_flag varchar(1) NULL, -- 商户下单备注标志，null 或 0未开启、 1开启（下单时备注必输）
	mct_power varchar(10) NULL, -- 商户权限字段，！暂时10位，第一位代：对满足T+0申请的商户进行t0提醒，0提醒，1不提醒；第二位代：商户是否接受所有店员的语音播报的提醒，0不播报，1播报；第三位代：商户是否启用微信交易提醒，0不提醒，1提醒；其他位备用
	push_start varchar(10) NULL, -- 设置商户消息推送  1 代表开启  0 代表关闭
	assist_remark varchar(1000) NULL, -- 辅助材料备注
	assist_data1 varchar(60) NULL, -- 辅助材料1
	assist_data2 varchar(60) NULL, -- 辅助材料2
	assist_data3 varchar(60) NULL, -- 辅助材料3
	assist_data4 varchar(60) NULL, -- 辅助材料4  预留字段
	assist_data5 varchar(60) NULL, -- 辅助材料5  预留字段
	collect_flag varchar(10) NULL, -- 商户报送A/T状态   0-未报送/报送失败   1-报送成功
	wx_category_code varchar(20) NULL, -- 微信类目编号
	ali_category_code varchar(20) NULL, -- 支付宝类目编号
	ali_mcc varchar(20) NULL, -- 支付宝ACC码
	union_mcc varchar(20) NULL, -- 银联MCC码
	xcx_push_start varchar(20) NULL, -- XCX_PUSH_START
	xcx_push_cashier varchar(2) NULL, -- 商户小程序是否接收店员消息，1是  0否
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_info PRIMARY KEY (mct_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_info.mct_id IS '商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info."name" IS '商户全称';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.short_name IS '商户简称';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.category_id IS '行业子类目';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.mct_type IS '商户类型 company-企业， institution-党政机关/事业单位, otherOrganizations-其他组织，personage-个体商户， smallBusinesses-小微商户';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.phone IS '电话';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.email IS '邮箱';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.website IS '网址';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.contacts IS '负责人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.contacts_cert_type IS '负责人证件类型 01-身份证 02-港澳通行证 03-台湾通行证 04-护照 05-其他';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.contacts_cert_no IS '负责人证件号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.contacts_cert_back_url IS '负责人证件反面图片地址';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.contacts_cert_face_url IS '负责人证件正面图片地址';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.contacts_phone IS '负责人电话';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.customer_phone IS '客服电话';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.chain_id IS '所属连锁商户';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.mct_dept_id IS '所属商户部门';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.is_own_data IS '是否 独立基础资料  直营商户或者加盟商户';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.is_settle_acc IS '是否  独立结算卡信息';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.agree_url IS '协议图片路径';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.shop_url IS '门头照图片路径';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.settle_type IS '清算类型 T0：T+0当日清算  T1：T+1下日清算';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.province IS '省';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.city IS '市';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.area IS '区';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.address IS '详细地址';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.dit_id IS '所属渠道商';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.org_id IS '所属机构';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.job_id IS '所属业务人员/客户经理编号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.remark IS '备注';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.check_status IS '审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.status IS '状态 0-正常（可交易） 1-未生效 2-冻结 3-待第三方确认 9-注销';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.lng IS '经度';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.lat IS '纬度';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.sign_date IS '商户签约日期';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.is_become_t0_flag IS '是否可以成为T+0商户标识 0：否 1：是';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.mct_logo_url IS '商户logo图路径';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.check_task_id IS '当前审核任务ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.banker_id IS '商户所属银行家ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.banker_name IS '商户所属银行家名称';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.category_parent_id IS '行业父类目';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.risk_level IS '风险等级 A- A级  B-B级 C-C级 D-D级 W-未评定';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.rade_area_id IS '商圈编号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.from_way IS '入驻渠道来源  app-app端  pc-pc后管';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.cancel_date IS '注销日期/解约日期  当商户注销的时候使用';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.last_org_trf_id IS '商户最后一次机构变更流水';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.last_cmg_trf_id IS '商户最后一次客户经理变更流水';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.month_deposit IS '月日均存款额';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.season_deposit IS '季日均存款额';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.shop_back_url IS '商户店内照片路径';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.yunhorn IS '0 关闭云喇叭推送 1开启云喇叭推送';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.expire_check_type IS '过期提醒类型 0-无需提醒1-身份证将到期需提醒2-营业执照将到期需提醒3-均要到期需提醒4-已过期';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.company_size IS '企业规模 1 大型 、 2 小型';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.order_remark_flag IS '商户下单备注标志，null 或 0未开启、 1开启（下单时备注必输）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.mct_power IS '商户权限字段，！暂时10位，第一位代：对满足T+0申请的商户进行t0提醒，0提醒，1不提醒；第二位代：商户是否接受所有店员的语音播报的提醒，0不播报，1播报；第三位代：商户是否启用微信交易提醒，0不提醒，1提醒；其他位备用';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.push_start IS '设置商户消息推送  1 代表开启  0 代表关闭';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.assist_remark IS '辅助材料备注';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.assist_data1 IS '辅助材料1';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.assist_data2 IS '辅助材料2';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.assist_data3 IS '辅助材料3';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.assist_data4 IS '辅助材料4  预留字段';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.assist_data5 IS '辅助材料5  预留字段';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.collect_flag IS '商户报送A/T状态   0-未报送/报送失败   1-报送成功';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.wx_category_code IS '微信类目编号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.ali_category_code IS '支付宝类目编号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.ali_mcc IS '支付宝ACC码';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.union_mcc IS '银联MCC码';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.xcx_push_start IS 'XCX_PUSH_START';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.xcx_push_cashier IS '商户小程序是否接收店员消息，1是  0否';
COMMENT ON COLUMN crmdm.uepp_pay_mct_info.ryzd IS '冗余字段';
