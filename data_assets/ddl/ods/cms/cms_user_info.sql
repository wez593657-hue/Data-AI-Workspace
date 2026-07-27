-- crmdm.cms_user_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_user_info;

CREATE TABLE crmdm.cms_user_info (
	userid varchar(32) NOT NULL, -- 用户编号
	loginid varchar(32) NULL, -- 登录账号
	username varchar(32) NULL, -- 用户姓名
	"password" varchar(32) NULL, -- 用户密码
	belongorg varchar(32) NULL, -- 所属机构
	attribute1 varchar(80) NULL, -- 属性一
	attribute2 varchar(80) NULL, -- 属性二
	attribute3 varchar(80) NULL, -- 属性三
	attribute4 varchar(80) NULL, -- 属性四
	attribute5 varchar(80) NULL, -- 属性五
	attribute6 varchar(80) NULL, -- 属性六
	attribute7 varchar(80) NULL, -- 属性七
	attribute8 varchar(80) NULL, -- 属性八
	"attribute" varchar(80) NULL, -- 属性集
	describe1 varchar(250) NULL, -- 描述一
	describe2 varchar(250) NULL, -- 描述二
	describe3 varchar(250) NULL, -- 描述三
	describe4 varchar(250) NULL, -- 描述四
	status varchar(80) NULL, -- 状态
	certtype varchar(18) NULL, -- 证件类型
	certid varchar(32) NULL, -- 用户身份证号
	companytel varchar(32) NULL, -- 单位电话
	mobiletel varchar(32) NULL, -- 手机号码
	email varchar(80) NULL, -- 电子邮件
	accountid varchar(32) NULL, -- 个贷系统编号
	id1 varchar(32) NULL, -- 编号1
	id2 varchar(32) NULL, -- 编号2
	sum1 numeric(24, 6) NULL, -- 相关金额1
	sum2 numeric(24, 6) NULL, -- 相关金额2
	inputorg varchar(32) NULL, -- 登记单位
	inputuser varchar(32) NULL, -- 登记人
	inputdate varchar(20) NULL, -- 登记日期
	updatedate varchar(20) NULL, -- 更新日期
	inputtime varchar(20) NULL, -- 登记时间
	updateuser varchar(32) NULL, -- 更新人
	updatetime varchar(20) NULL, -- 更新时间
	remark varchar(250) NULL, -- 备注
	birthday varchar(10) NULL, -- 生日
	gender varchar(18) NULL, -- 性别
	familyadd varchar(250) NULL, -- 家庭住址
	educationalbg varchar(18) NULL, -- 学历
	amlevel varchar(18) NULL, -- 客户经理级别
	title varchar(18) NULL, -- 行内职务
	educationexp bpchar(800) NULL, -- 教育经历
	vocationexp bpchar(800) NULL, -- 工作经历
	"position" varchar(250) NULL, -- 职称
	qualification varchar(250) NULL, -- 任职资格
	ntid varchar(32) NULL, -- NTID
	belongteam varchar(32) NULL, -- 所属团队
	lob varchar(32) NULL, -- 业务条线
	skinpath varchar(200) NULL, -- 皮肤路径
	"language" varchar(32) NULL, -- 语言
	mfuserid varchar(32) NULL, -- 核心柜员号
	oauserid varchar(32) NULL, -- OA的UserId
	ryzd varchar(1) NULL -- 冗余字段
);
CREATE INDEX index_crmdm_cms_user_info_index_1 ON crmdm.cms_user_info USING btree (userid);

-- Column comments

COMMENT ON COLUMN crmdm.cms_user_info.userid IS '用户编号';
COMMENT ON COLUMN crmdm.cms_user_info.loginid IS '登录账号';
COMMENT ON COLUMN crmdm.cms_user_info.username IS '用户姓名';
COMMENT ON COLUMN crmdm.cms_user_info."password" IS '用户密码';
COMMENT ON COLUMN crmdm.cms_user_info.belongorg IS '所属机构';
COMMENT ON COLUMN crmdm.cms_user_info.attribute1 IS '属性一';
COMMENT ON COLUMN crmdm.cms_user_info.attribute2 IS '属性二';
COMMENT ON COLUMN crmdm.cms_user_info.attribute3 IS '属性三';
COMMENT ON COLUMN crmdm.cms_user_info.attribute4 IS '属性四';
COMMENT ON COLUMN crmdm.cms_user_info.attribute5 IS '属性五';
COMMENT ON COLUMN crmdm.cms_user_info.attribute6 IS '属性六';
COMMENT ON COLUMN crmdm.cms_user_info.attribute7 IS '属性七';
COMMENT ON COLUMN crmdm.cms_user_info.attribute8 IS '属性八';
COMMENT ON COLUMN crmdm.cms_user_info."attribute" IS '属性集';
COMMENT ON COLUMN crmdm.cms_user_info.describe1 IS '描述一';
COMMENT ON COLUMN crmdm.cms_user_info.describe2 IS '描述二';
COMMENT ON COLUMN crmdm.cms_user_info.describe3 IS '描述三';
COMMENT ON COLUMN crmdm.cms_user_info.describe4 IS '描述四';
COMMENT ON COLUMN crmdm.cms_user_info.status IS '状态';
COMMENT ON COLUMN crmdm.cms_user_info.certtype IS '证件类型';
COMMENT ON COLUMN crmdm.cms_user_info.certid IS '用户身份证号';
COMMENT ON COLUMN crmdm.cms_user_info.companytel IS '单位电话';
COMMENT ON COLUMN crmdm.cms_user_info.mobiletel IS '手机号码';
COMMENT ON COLUMN crmdm.cms_user_info.email IS '电子邮件';
COMMENT ON COLUMN crmdm.cms_user_info.accountid IS '个贷系统编号';
COMMENT ON COLUMN crmdm.cms_user_info.id1 IS '编号1';
COMMENT ON COLUMN crmdm.cms_user_info.id2 IS '编号2';
COMMENT ON COLUMN crmdm.cms_user_info.sum1 IS '相关金额1';
COMMENT ON COLUMN crmdm.cms_user_info.sum2 IS '相关金额2';
COMMENT ON COLUMN crmdm.cms_user_info.inputorg IS '登记单位';
COMMENT ON COLUMN crmdm.cms_user_info.inputuser IS '登记人';
COMMENT ON COLUMN crmdm.cms_user_info.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_user_info.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_user_info.inputtime IS '登记时间';
COMMENT ON COLUMN crmdm.cms_user_info.updateuser IS '更新人';
COMMENT ON COLUMN crmdm.cms_user_info.updatetime IS '更新时间';
COMMENT ON COLUMN crmdm.cms_user_info.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_user_info.birthday IS '生日';
COMMENT ON COLUMN crmdm.cms_user_info.gender IS '性别';
COMMENT ON COLUMN crmdm.cms_user_info.familyadd IS '家庭住址';
COMMENT ON COLUMN crmdm.cms_user_info.educationalbg IS '学历';
COMMENT ON COLUMN crmdm.cms_user_info.amlevel IS '客户经理级别';
COMMENT ON COLUMN crmdm.cms_user_info.title IS '行内职务';
COMMENT ON COLUMN crmdm.cms_user_info.educationexp IS '教育经历';
COMMENT ON COLUMN crmdm.cms_user_info.vocationexp IS '工作经历';
COMMENT ON COLUMN crmdm.cms_user_info."position" IS '职称';
COMMENT ON COLUMN crmdm.cms_user_info.qualification IS '任职资格';
COMMENT ON COLUMN crmdm.cms_user_info.ntid IS 'NTID';
COMMENT ON COLUMN crmdm.cms_user_info.belongteam IS '所属团队';
COMMENT ON COLUMN crmdm.cms_user_info.lob IS '业务条线';
COMMENT ON COLUMN crmdm.cms_user_info.skinpath IS '皮肤路径';
COMMENT ON COLUMN crmdm.cms_user_info."language" IS '语言';
COMMENT ON COLUMN crmdm.cms_user_info.mfuserid IS '核心柜员号';
COMMENT ON COLUMN crmdm.cms_user_info.oauserid IS 'OA的UserId';
COMMENT ON COLUMN crmdm.cms_user_info.ryzd IS '冗余字段';
