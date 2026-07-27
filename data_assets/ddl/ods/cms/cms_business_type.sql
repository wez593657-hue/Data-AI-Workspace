-- crmdm.cms_business_type 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_type;

CREATE TABLE crmdm.cms_business_type (
	typeno varchar(32) NOT NULL, -- 产品编号
	sortno varchar(32) NULL, -- 排序编号
	typename varchar(80) NULL, -- 产品名称
	typesortno varchar(32) NULL, -- 是否联机处理
	subtypecode varchar(32) NULL, -- 放款通知单，分类编号
	isinuse varchar(18) NULL, -- 有效标志
	basetypeno varchar(32) NULL, -- 对应基础产品
	flowno varchar(80) NULL, -- 审批流程
	loanpredetailno varchar(32) NULL, -- 贷前调查模板
	vouchtypes varchar(3000) NULL, -- 可用担保方式
	guarantyrate numeric(24, 6) NULL, -- 抵质押率（%）
	rateleft numeric(24, 6) NULL, -- 利率区间（%）
	rateright numeric(24, 6) NULL, -- 利率区间（%）
	sumlimit numeric(24, 6) NULL, -- 单笔最高金额
	afterloanday numeric NULL, -- 贷后检查提醒日
	indafterloan numeric(24, 6) NULL, -- 个人贷后金额参数
	belongorg varchar(32) NULL, -- 归属部门
	approveopinion varchar(250) NULL, -- 复核意见
	attribute1 varchar(200) NULL, -- 对公/对私
	attribute2 varchar(200) NULL, -- 主业务品种分类
	attribute3 varchar(200) NULL, -- 贷款新规适用产品
	attribute4 varchar(200) NULL, -- 新增业务是否出现
	attribute5 varchar(200) NULL, -- 补登是否出现
	attribute6 varchar(200) NULL, -- 非补登是否出现
	attribute7 varchar(200) NULL, -- 定价参数
	attribute8 varchar(200) NULL, -- 绩效考核参数
	attribute9 varchar(200) NULL, -- 审批流程
	attribute10 varchar(200) NULL, -- 允许的币种
	infoset varchar(200) NULL, -- 信息设置
	displaytemplet varchar(32) NULL, -- 出帐显示模板
	applydetailno varchar(18) NULL, -- 申请显示模板
	approvedetailno varchar(18) NULL, -- 最终审批意见显示模板
	contractdetailno varchar(18) NULL, -- 合同显示模板
	attribute11 varchar(80) NULL, -- 必备文档参数
	attribute12 varchar(80) NULL, -- 缺省高风险点
	attribute13 varchar(80) NULL, -- 属性13
	attribute14 varchar(80) NULL, -- 属性14
	attribute15 varchar(80) NULL, -- 企业征信分类
	attribute16 varchar(80) NULL, -- 是否主产品
	attribute17 varchar(80) NULL, -- 附属产品
	attribute18 varchar(80) NULL, -- 属性18
	attribute19 varchar(80) NULL, -- 属性19
	attribute20 varchar(80) NULL, -- 属性20
	attribute21 varchar(80) NULL, -- 属性21
	attribute22 varchar(80) NULL, -- 是否目录(仅展示树图时使用)
	attribute23 varchar(80) NULL, -- 信贷业务种类
	attribute24 varchar(80) NULL, -- 贷款业务种类
	attribute25 varchar(80) NULL, -- 贷款种类/融资业务种类
	offsheetflag varchar(6) NULL, -- 表内外标志
	configfile varchar(200) NULL, -- 组件配置文件
	remark varchar(200) NULL, -- 备注
	inputuser varchar(32) NULL, -- 登记人
	inputorg varchar(32) NULL, -- 登记机构
	inputtime varchar(20) NULL, -- 登记时间
	updateuser varchar(32) NULL, -- 更新人
	updatetime varchar(20) NULL, -- 更新时间
	isliquidity varchar(4) NULL, -- 流动资金贷款
	isfixed varchar(4) NULL, -- 固定资产贷款
	isproject varchar(4) NULL, -- 项目融资贷款
	prdremark varchar(2000) NULL, -- 营销产品更改备注
	linetype varchar(20) NULL, -- 所属条线，多条线之间使用【,】分割，码值ProductLineType
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_business_type PRIMARY KEY (typeno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_type.typeno IS '产品编号                  ';
COMMENT ON COLUMN crmdm.cms_business_type.sortno IS '排序编号                  ';
COMMENT ON COLUMN crmdm.cms_business_type.typename IS '产品名称                  ';
COMMENT ON COLUMN crmdm.cms_business_type.typesortno IS '是否联机处理              ';
COMMENT ON COLUMN crmdm.cms_business_type.subtypecode IS '放款通知单，分类编号      ';
COMMENT ON COLUMN crmdm.cms_business_type.isinuse IS '有效标志                  ';
COMMENT ON COLUMN crmdm.cms_business_type.basetypeno IS '对应基础产品              ';
COMMENT ON COLUMN crmdm.cms_business_type.flowno IS '审批流程                  ';
COMMENT ON COLUMN crmdm.cms_business_type.loanpredetailno IS '贷前调查模板              ';
COMMENT ON COLUMN crmdm.cms_business_type.vouchtypes IS '可用担保方式              ';
COMMENT ON COLUMN crmdm.cms_business_type.guarantyrate IS '抵质押率（%）             ';
COMMENT ON COLUMN crmdm.cms_business_type.rateleft IS '利率区间（%）             ';
COMMENT ON COLUMN crmdm.cms_business_type.rateright IS '利率区间（%）             ';
COMMENT ON COLUMN crmdm.cms_business_type.sumlimit IS '单笔最高金额              ';
COMMENT ON COLUMN crmdm.cms_business_type.afterloanday IS '贷后检查提醒日            ';
COMMENT ON COLUMN crmdm.cms_business_type.indafterloan IS '个人贷后金额参数          ';
COMMENT ON COLUMN crmdm.cms_business_type.belongorg IS '归属部门                  ';
COMMENT ON COLUMN crmdm.cms_business_type.approveopinion IS '复核意见                  ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute1 IS '对公/对私                 ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute2 IS '主业务品种分类            ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute3 IS '贷款新规适用产品          ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute4 IS '新增业务是否出现          ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute5 IS '补登是否出现              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute6 IS '非补登是否出现            ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute7 IS '定价参数                  ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute8 IS '绩效考核参数              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute9 IS '审批流程                  ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute10 IS '允许的币种                ';
COMMENT ON COLUMN crmdm.cms_business_type.infoset IS '信息设置                  ';
COMMENT ON COLUMN crmdm.cms_business_type.displaytemplet IS '出帐显示模板              ';
COMMENT ON COLUMN crmdm.cms_business_type.applydetailno IS '申请显示模板              ';
COMMENT ON COLUMN crmdm.cms_business_type.approvedetailno IS '最终审批意见显示模板      ';
COMMENT ON COLUMN crmdm.cms_business_type.contractdetailno IS '合同显示模板              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute11 IS '必备文档参数              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute12 IS '缺省高风险点              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute13 IS '属性13                    ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute14 IS '属性14                    ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute15 IS '企业征信分类              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute16 IS '是否主产品                ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute17 IS '附属产品                  ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute18 IS '属性18                    ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute19 IS '属性19                    ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute20 IS '属性20                    ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute21 IS '属性21                    ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute22 IS '是否目录(仅展示树图时使用)';
COMMENT ON COLUMN crmdm.cms_business_type.attribute23 IS '信贷业务种类              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute24 IS '贷款业务种类              ';
COMMENT ON COLUMN crmdm.cms_business_type.attribute25 IS '贷款种类/融资业务种类     ';
COMMENT ON COLUMN crmdm.cms_business_type.offsheetflag IS '表内外标志                ';
COMMENT ON COLUMN crmdm.cms_business_type.configfile IS '组件配置文件              ';
COMMENT ON COLUMN crmdm.cms_business_type.remark IS '备注                      ';
COMMENT ON COLUMN crmdm.cms_business_type.inputuser IS '登记人                    ';
COMMENT ON COLUMN crmdm.cms_business_type.inputorg IS '登记机构                  ';
COMMENT ON COLUMN crmdm.cms_business_type.inputtime IS '登记时间                  ';
COMMENT ON COLUMN crmdm.cms_business_type.updateuser IS '更新人                    ';
COMMENT ON COLUMN crmdm.cms_business_type.updatetime IS '更新时间                  ';
COMMENT ON COLUMN crmdm.cms_business_type.isliquidity IS '流动资金贷款              ';
COMMENT ON COLUMN crmdm.cms_business_type.isfixed IS '固定资产贷款              ';
COMMENT ON COLUMN crmdm.cms_business_type.isproject IS '项目融资贷款              ';
COMMENT ON COLUMN crmdm.cms_business_type.prdremark IS '营销产品更改备注';
COMMENT ON COLUMN crmdm.cms_business_type.linetype IS '所属条线，多条线之间使用【,】分割，码值ProductLineType';
COMMENT ON COLUMN crmdm.cms_business_type.ryzd IS '冗余字段';
