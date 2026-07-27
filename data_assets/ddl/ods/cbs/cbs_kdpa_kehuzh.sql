-- crmdm.cbs_kdpa_kehuzh 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_kehuzh;

CREATE TABLE crmdm.cbs_kdpa_kehuzh (
	farendma varchar(4) NOT NULL, -- 法人代码
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	kehuzhlx varchar(1) NOT NULL, -- 客户账号类型
	kehuhaoo varchar(16) NOT NULL, -- 客户号
	kehuzhmc varchar(500) NOT NULL, -- 客户账户名称
	zhfutojn varchar(1) NOT NULL, -- 支付条件
	tduibzhi varchar(1) NOT NULL, -- 通兑标志
	tduifwei varchar(1) NOT NULL, -- 通兑范围
	xnjntdbz varchar(1) NOT NULL, -- 现金通兑标志
	zhnztdbz varchar(1) NOT NULL, -- 转账通兑标志
	tcunbzhi varchar(1) NOT NULL, -- 通存标志
	tcunfwei varchar(1) NOT NULL, -- 通存范围
	xjtcbzhi varchar(1) NOT NULL, -- 现金通存标志
	zztcbzhi varchar(1) NOT NULL, -- 转账通存标志
	lminzhhu varchar(1) NOT NULL, -- 联名账户标志
	gxileixn varchar(1) NOT NULL, -- 关系类型
	zhzhleix varchar(1) NOT NULL, -- 组合账户类型
	zhuzhhao varchar(35) NOT NULL, -- 组合主客户账号
	zhuxuhao varchar(8) NULL, -- 组合子账户序号
	kaihjigo varchar(10) NOT NULL, -- 开户机构
	kaihriqi varchar(8) NOT NULL, -- 开户日期
	kaihguiy varchar(8) NOT NULL, -- 账户开户柜员
	xiohjigo varchar(10) NULL, -- 账户销户机构
	xiohriqi varchar(8) NULL, -- 账户销户日期
	xiohguiy varchar(10) NULL, -- 账户销户柜员
	xuhaoooo numeric(19) NULL, -- 序号
	bishuuuu numeric(19) NULL, -- 人民币活期未压缩笔数
	glpinzbz varchar(1) NULL, -- 关联凭证标志
	zuhecpdh varchar(10) NULL, -- 组合产品
	xzhileix varchar(1) NULL, -- 限制类型
	zhjedjbz varchar(1) NULL, -- 账户金额冻结标志
	zhfbdjbz varchar(1) NULL, -- 账户封闭冻结标志
	zhzsbfbz varchar(1) NULL, -- 账户只收不付标志
	zhzfbsbz varchar(1) NULL, -- 账户只付不收标志
	morzfxuh varchar(8) NULL, -- 默认支付账户序号
	morcrxuh varchar(8) NULL, -- 默认存入账户序号
	zhhuztai varchar(1) NULL, -- 账户状态
	khzhztzd varchar(50) NULL, -- 客户账号状态字段
	wdzzdsxh numeric(19) NULL, -- 当前未登折最大顺序号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	zhhufenl varchar(1) NOT NULL, -- 账户分类
	mdmhsbaz varchar(1) NULL, -- 面对面身份核实标志
	rujinnbz varchar(1) NULL, -- 入金功能标志
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kehuzhlx IS '客户账号类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kehuhaoo IS '客户号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kehuzhmc IS '客户账户名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhfutojn IS '支付条件';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.tduibzhi IS '通兑标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.tduifwei IS '通兑范围';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xnjntdbz IS '现金通兑标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhnztdbz IS '转账通兑标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.tcunbzhi IS '通存标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.tcunfwei IS '通存范围';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xjtcbzhi IS '现金通存标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zztcbzhi IS '转账通存标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.lminzhhu IS '联名账户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.gxileixn IS '关系类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhzhleix IS '组合账户类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhuzhhao IS '组合主客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhuxuhao IS '组合子账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kaihjigo IS '开户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kaihriqi IS '开户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.kaihguiy IS '账户开户柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xiohjigo IS '账户销户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xiohriqi IS '账户销户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xiohguiy IS '账户销户柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xuhaoooo IS '序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.bishuuuu IS '人民币活期未压缩笔数';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.glpinzbz IS '关联凭证标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zuhecpdh IS '组合产品';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.xzhileix IS '限制类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhjedjbz IS '账户金额冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhfbdjbz IS '账户封闭冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhzsbfbz IS '账户只收不付标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhzfbsbz IS '账户只付不收标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.morzfxuh IS '默认支付账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.morcrxuh IS '默认存入账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhhuztai IS '账户状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.khzhztzd IS '客户账号状态字段';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.wdzzdsxh IS '当前未登折最大顺序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.zhhufenl IS '账户分类';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.mdmhsbaz IS '面对面身份核实标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.rujinnbz IS '入金功能标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_kehuzh.ryzd IS '冗余字段';
