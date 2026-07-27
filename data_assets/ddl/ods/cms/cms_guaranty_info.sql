-- crmdm.cms_guaranty_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_guaranty_info;

CREATE TABLE crmdm.cms_guaranty_info (
	guarantyid varchar(40) NOT NULL, -- 质物编号
	guarantytype varchar(20) NULL, -- 质物类型
	guarantystatus varchar(20) NULL, -- 担保物状态
	ownerid varchar(40) NULL, -- 出质人代码
	ownername varchar(80) NULL, -- 出质人名称
	ownertype varchar(20) NULL, -- 出质人类型
	rate numeric(24, 6) NULL, -- 担保利率
	custguarantytype varchar(20) NULL, -- 客户担保物类型
	subjectno varchar(40) NULL, -- 科目编号
	relativeaccount varchar(40) NULL, -- 权利人账户账号
	guarantyrightid varchar(2000) NULL, -- 票据号码
	otherguarantyright varchar(300) NULL, -- 他项权证号
	guarantyname varchar(120) NULL, -- 承兑行名称
	guarantysubtype varchar(20) NULL, -- 土地级别
	guarantyownway varchar(20) NULL, -- 存单支取方式
	guarantyusing varchar(200) NULL, -- 土地现状
	guarantylocation varchar(300) NULL, -- 债券代理发行机构
	guarantyamount numeric(24, 6) NULL, -- 债券数量
	guarantyamount1 numeric(24, 6) NULL, -- 申请前一日基金收盘价
	guarantyamount2 numeric(24, 6) NULL, -- 质押基金份额
	guarantyresouce varchar(80) NULL, -- 债券发行单位
	guarantydate varchar(80) NULL, -- 签发日期
	begindate varchar(10) NULL, -- 开始日期
	ownertime varchar(80) NULL, -- 提单到期日期
	guarantydescript varchar(300) NULL, -- 抵押物说明
	aboutotherid1 varchar(500) NULL, -- 车辆型号
	aboutotherid2 varchar(40) NULL, -- 供应商
	aboutotherid3 varchar(40) NULL, -- 车架号
	aboutotherid4 varchar(40) NULL, -- 担保物其他相关号码4
	purpose varchar(300) NULL, -- 地上附着物名称
	aboutsum1 numeric(24, 6) NULL, -- 票面金额
	aboutsum2 numeric(24, 6) NULL, -- 担保本金债权金额
	aboutrate numeric(24, 6) NULL, -- 质押基金份额占总额
	guarantyana varchar(200) NULL, -- 存放地点
	guarantyprice numeric(24, 6) NULL, -- 车辆购入价值
	evalmethod varchar(20) NULL, -- 质物价值评估方式
	evalorgid varchar(40) NULL, -- 评估机构组织机构代码
	evalorgname varchar(120) NULL, -- 价值评估机构名称
	evaldate varchar(10) NULL, -- 价值首次估值日期
	evalnetvalue numeric(24, 6) NULL, -- 质物金额
	confirmvalue numeric(24, 6) NULL, -- 质押金额
	guarantyrate numeric(24, 6) NULL, -- 抵质押率
	thirdparty1 varchar(200) NULL, -- 车辆类型
	thirdparty2 varchar(2000) NULL, -- 币种
	thirdparty3 varchar(200) NULL, -- 车辆品牌
	guarantydescribe1 varchar(200) NULL, -- 开证行国家地区
	guarantydescribe2 varchar(300) NULL, -- 保兑行名称
	guarantydescribe3 varchar(200) NULL, -- 保兑行所在国家和地区
	flag1 varchar(20) NULL, -- 是否记名债券
	flag2 varchar(20) NULL, -- 是否需要办理止付
	flag3 varchar(20) NULL, -- 是否有当年车船使用税证
	flag4 varchar(20) NULL, -- 年检是否正常
	guarantyregno varchar(40) NULL, -- 抵押登记编号
	guarantyregorg varchar(80) NULL, -- 抵押登记机关
	guarantyregdate varchar(10) NULL, -- 抵押登记日期
	guarantywodate varchar(10) NULL, -- 抵押登记注销日期
	insurecertno varchar(40) NULL, -- 抵押物保险单编号
	otherassumpsit varchar(300) NULL, -- 其它特别约定
	inputorgid varchar(40) NULL, -- 登记机构
	inputuserid varchar(40) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updateuserid varchar(40) NULL, -- 更新用户编号
	updatedate varchar(10) NULL, -- 更新日期
	remark varchar(300) NULL, -- 备注
	sapvouchtype varchar(20) NULL, -- SAP抵质押物类型
	certtype varchar(18) NULL, -- 出质人证件类型
	certid varchar(50) NULL, -- 出质人证件号码
	loancardno varchar(32) NULL, -- 出质人贷款卡号
	guarantycurrency varchar(18) NULL, -- 质押币种
	evalcurrency varchar(18) NULL, -- 质物币种
	guarantydescribe4 numeric(24, 6) NULL, -- 已投入工程款
	evaldate1 varchar(10) NULL, -- 价值最新估值日期
	evaldate2 varchar(10) NULL, -- 价值估值到期日期
	guarantyvalue numeric(24, 6) NULL, -- 抵押价值
	useyear numeric(10) NULL, -- 法定折旧年限
	enddate varchar(10) NULL, -- 到期日期
	isreverse varchar(2) NULL, -- 是否反担保品
	yz varchar(2) NULL, -- 是否移植数据
	outbounddate varchar(20) NULL, -- 出库时间
	instoragedate varchar(20) NULL, -- 入库时间
	ispwancredit varchar(4) NULL, -- 是否占用保贴人额度
	pwancreditno varchar(32) NULL, -- 保贴人额度流水号
	pwancreditdivno varchar(32) NULL, -- 保贴人额度分项流水号
	guarantyaddress varchar(200) NULL, -- 抵质押物地址
	keepaccountingorgid varchar(32) NULL -- 记账机构
);
CREATE INDEX idx_guaranty_info_01 ON crmdm.cms_guaranty_info USING btree (inputorgid);
COMMENT ON TABLE crmdm.cms_guaranty_info IS '担保物信息表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyid IS '质物编号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantytype IS '质物类型';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantystatus IS '担保物状态';
COMMENT ON COLUMN crmdm.cms_guaranty_info.ownerid IS '出质人代码';
COMMENT ON COLUMN crmdm.cms_guaranty_info.ownername IS '出质人名称';
COMMENT ON COLUMN crmdm.cms_guaranty_info.ownertype IS '出质人类型';
COMMENT ON COLUMN crmdm.cms_guaranty_info.rate IS '担保利率';
COMMENT ON COLUMN crmdm.cms_guaranty_info.custguarantytype IS '客户担保物类型';
COMMENT ON COLUMN crmdm.cms_guaranty_info.subjectno IS '科目编号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.relativeaccount IS '权利人账户账号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyrightid IS '票据号码';
COMMENT ON COLUMN crmdm.cms_guaranty_info.otherguarantyright IS '他项权证号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyname IS '承兑行名称';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantysubtype IS '土地级别';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyownway IS '存单支取方式';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyusing IS '土地现状';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantylocation IS '债券代理发行机构';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyamount IS '债券数量';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyamount1 IS '申请前一日基金收盘价';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyamount2 IS '质押基金份额';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyresouce IS '债券发行单位';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantydate IS '签发日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.begindate IS '开始日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.ownertime IS '提单到期日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantydescript IS '抵押物说明';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutotherid1 IS '车辆型号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutotherid2 IS '供应商';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutotherid3 IS '车架号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutotherid4 IS '担保物其他相关号码4';
COMMENT ON COLUMN crmdm.cms_guaranty_info.purpose IS '地上附着物名称';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutsum1 IS '票面金额';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutsum2 IS '担保本金债权金额';
COMMENT ON COLUMN crmdm.cms_guaranty_info.aboutrate IS '质押基金份额占总额';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyana IS '存放地点';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyprice IS '车辆购入价值';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evalmethod IS '质物价值评估方式';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evalorgid IS '评估机构组织机构代码';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evalorgname IS '价值评估机构名称';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evaldate IS '价值首次估值日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evalnetvalue IS '质物金额';
COMMENT ON COLUMN crmdm.cms_guaranty_info.confirmvalue IS '质押金额';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyrate IS '抵质押率';
COMMENT ON COLUMN crmdm.cms_guaranty_info.thirdparty1 IS '车辆类型';
COMMENT ON COLUMN crmdm.cms_guaranty_info.thirdparty2 IS '币种';
COMMENT ON COLUMN crmdm.cms_guaranty_info.thirdparty3 IS '车辆品牌';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantydescribe1 IS '开证行国家地区';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantydescribe2 IS '保兑行名称';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantydescribe3 IS '保兑行所在国家和地区';
COMMENT ON COLUMN crmdm.cms_guaranty_info.flag1 IS '是否记名债券';
COMMENT ON COLUMN crmdm.cms_guaranty_info.flag2 IS '是否需要办理止付';
COMMENT ON COLUMN crmdm.cms_guaranty_info.flag3 IS '是否有当年车船使用税证';
COMMENT ON COLUMN crmdm.cms_guaranty_info.flag4 IS '年检是否正常';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyregno IS '抵押登记编号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyregorg IS '抵押登记机关';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyregdate IS '抵押登记日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantywodate IS '抵押登记注销日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.insurecertno IS '抵押物保险单编号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.otherassumpsit IS '其它特别约定';
COMMENT ON COLUMN crmdm.cms_guaranty_info.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_guaranty_info.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_guaranty_info.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.updateuserid IS '更新用户编号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_guaranty_info.sapvouchtype IS 'SAP抵质押物类型';
COMMENT ON COLUMN crmdm.cms_guaranty_info.certtype IS '出质人证件类型';
COMMENT ON COLUMN crmdm.cms_guaranty_info.certid IS '出质人证件号码';
COMMENT ON COLUMN crmdm.cms_guaranty_info.loancardno IS '出质人贷款卡号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantycurrency IS '质押币种';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evalcurrency IS '质物币种';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantydescribe4 IS '已投入工程款';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evaldate1 IS '价值最新估值日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.evaldate2 IS '价值估值到期日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyvalue IS '抵押价值';
COMMENT ON COLUMN crmdm.cms_guaranty_info.useyear IS '法定折旧年限';
COMMENT ON COLUMN crmdm.cms_guaranty_info.enddate IS '到期日期';
COMMENT ON COLUMN crmdm.cms_guaranty_info.isreverse IS '是否反担保品';
COMMENT ON COLUMN crmdm.cms_guaranty_info.yz IS '是否移植数据';
COMMENT ON COLUMN crmdm.cms_guaranty_info.outbounddate IS '出库时间';
COMMENT ON COLUMN crmdm.cms_guaranty_info.instoragedate IS '入库时间';
COMMENT ON COLUMN crmdm.cms_guaranty_info.ispwancredit IS '是否占用保贴人额度';
COMMENT ON COLUMN crmdm.cms_guaranty_info.pwancreditno IS '保贴人额度流水号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.pwancreditdivno IS '保贴人额度分项流水号';
COMMENT ON COLUMN crmdm.cms_guaranty_info.guarantyaddress IS '抵质押物地址';
COMMENT ON COLUMN crmdm.cms_guaranty_info.keepaccountingorgid IS '记账机构';
