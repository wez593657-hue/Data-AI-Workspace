-- crmdm.cbs_kdpa_zhbcxx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhbcxx;

CREATE TABLE crmdm.cbs_kdpa_zhbcxx (
	farendma varchar(4) NOT NULL, -- 法人代码
	zhanghao varchar(40) NOT NULL, -- 负债账号
	dlirminc varchar(500) NULL, -- 开户代理人名称
	dlirzhjn varchar(2) NULL, -- 开户代理人证件种类
	dlirzhjh varchar(80) NULL, -- 开户代理人证件号码
	dlirguoj varchar(10) NULL, -- 开户代理人国籍
	dlirdhua varchar(40) NULL, -- 开户代理人电话
	tuozrenn varchar(500) NULL, -- 开户拓展人
	tuozrbho varchar(8) NULL, -- 开拓人编号
	kaihdjbz varchar(1) NULL, -- 开户冻结标志
	dongjbho varchar(32) NULL, -- 冻结编号
	qiyongrq varchar(8) NULL, -- 启用日期
	jibhkhho varchar(12) NULL, -- 基本户开户行行号
	jibhkhhm varchar(120) NULL, -- 基本户开户行行名
	jibhzhho varchar(35) NULL, -- 基本户账户
	jibhhzho varchar(30) NULL, -- 基本账户开户许可证核准号
	xukezhho varchar(30) NULL, -- 临时/专户许可证号
	bqicishu numeric(19) NULL, -- 补齐次数
	loucunys numeric(19) NULL, -- 漏存月数
	weiyriqi varchar(8) NULL, -- 违约日期
	zhdquxng varchar(1) NULL, -- 指定去向
	dxkehuzh varchar(35) NULL, -- 定向客户账号
	dxzhuxho varchar(8) NULL, -- 定向账户序号
	dingxzht varchar(1) NULL, -- 定向状态
	quxjiech varchar(1) NULL, -- 去向解除方式
	yerzzkhz varchar(35) NULL, -- 余额入总账客户账号
	yerzzzhx varchar(8) NULL, -- 余额入总账账户序号
	beiyzd01 varchar(50) NULL, -- 备用字段01
	beiyzd02 varchar(50) NULL, -- 备用字段02
	beiyzd03 varchar(50) NULL, -- 备用字段03
	beiyye01 numeric(21, 2) NULL, -- 备用余额01
	beiyye02 numeric(21, 2) NULL, -- 备用余额02
	beiyye03 numeric(21, 2) NULL, -- 备用余额03
	ljplhsbz varchar(1) NULL, -- 联机费用批量后收标志
	zhphbzhi varchar(1) NULL, -- 支票户标志
	ylzhmmbz varchar(1) NULL, -- 预留对公支票户密码标志
	kehuzhao varchar(35) NULL, -- 客户账号
	zhhaoxuh varchar(8) NULL, -- 子账户序号
	zmwjzlei varchar(2) NULL, -- 证明文件种类
	zmwjbhao varchar(30) NULL, -- 证明文件编号
	kehuzhmc varchar(500) NULL, -- 客户账户名称
	jigouhao varchar(12) NULL, -- 机构号
	kehuhaoo varchar(16) NULL, -- 客户号
	scnjriqi varchar(8) NULL, -- 上次年检日期
	bcnjriqi varchar(8) NULL, -- 本次年检日期
	njanztai varchar(1) NULL, -- 年检状态
	sfbztshi varchar(1) NULL, -- 是否备注提示
	beizhuxx varchar(200) NULL, -- 备注信息
	kouhhpnz varchar(1) NULL, -- 扣划换凭证标志
	kaihriqi varchar(8) NULL, -- 开户日期
	kaihlius varchar(32) NULL, -- 开户流水
	xiohriqi varchar(8) NULL, -- 账户销户日期
	xiahlius varchar(32) NULL, -- 销户流水
	xiaohuje numeric(17, 2) NULL, -- 销户金额
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(12) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	dlirywmc varchar(500) NULL, -- 开户代理人英文名
	tyzhleix varchar(2) NULL, -- 同业账户类型
	scjioyrq varchar(8) NULL, -- 账户上次超期延长日期
	sscijyrq varchar(8) NULL, -- 账户上上次超期延期日期
	sfxwgshu varchar(1) NULL, -- SFXWGSHU
	nmggzhbz varchar(1) NULL, -- 农民工工资专户标志
	smsfhsrq varchar(8) NULL, -- 睡眠户身份核实日期
	zhhufxdj varchar(1) NULL, -- 账户风险等级
	fxdjpdrq varchar(8) NULL, -- 风险等级评定日期
	zhahlxzx varchar(5) NULL, -- 账户类型子项
	zjinxinz varchar(5) NULL, -- 资金性质
	xiaohuyy varchar(5) NULL, -- 销户原因
	yxkzclfs varchar(5) NULL, -- 原许可证处理方式
	yfqqudao varchar(7) NULL, -- 原发起渠道
	yingxjig varchar(12) NULL, -- 营销机构
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dlirminc IS '开户代理人名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dlirzhjn IS '开户代理人证件种类';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dlirzhjh IS '开户代理人证件号码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dlirguoj IS '开户代理人国籍';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dlirdhua IS '开户代理人电话';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.tuozrenn IS '开户拓展人';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.tuozrbho IS '开拓人编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kaihdjbz IS '开户冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dongjbho IS '冻结编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.qiyongrq IS '启用日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.jibhkhho IS '基本户开户行行号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.jibhkhhm IS '基本户开户行行名';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.jibhzhho IS '基本户账户';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.jibhhzho IS '基本账户开户许可证核准号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.xukezhho IS '临时/专户许可证号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.bqicishu IS '补齐次数';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.loucunys IS '漏存月数';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.weiyriqi IS '违约日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zhdquxng IS '指定去向';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dxkehuzh IS '定向客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dxzhuxho IS '定向账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dingxzht IS '定向状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.quxjiech IS '去向解除方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.yerzzkhz IS '余额入总账客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.yerzzzhx IS '余额入总账账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beiyzd01 IS '备用字段01';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beiyzd02 IS '备用字段02';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beiyzd03 IS '备用字段03';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beiyye01 IS '备用余额01';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beiyye02 IS '备用余额02';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beiyye03 IS '备用余额03';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.ljplhsbz IS '联机费用批量后收标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zhphbzhi IS '支票户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.ylzhmmbz IS '预留对公支票户密码标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zhhaoxuh IS '子账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zmwjzlei IS '证明文件种类';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zmwjbhao IS '证明文件编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kehuzhmc IS '客户账户名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.jigouhao IS '机构号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kehuhaoo IS '客户号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.scnjriqi IS '上次年检日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.bcnjriqi IS '本次年检日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.njanztai IS '年检状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.sfbztshi IS '是否备注提示';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.beizhuxx IS '备注信息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kouhhpnz IS '扣划换凭证标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kaihriqi IS '开户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.kaihlius IS '开户流水';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.xiohriqi IS '账户销户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.xiahlius IS '销户流水';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.xiaohuje IS '销户金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.dlirywmc IS '开户代理人英文名';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.tyzhleix IS '同业账户类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.scjioyrq IS '账户上次超期延长日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.sscijyrq IS '账户上上次超期延期日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.sfxwgshu IS 'SFXWGSHU';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.nmggzhbz IS '农民工工资专户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.smsfhsrq IS '睡眠户身份核实日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zhhufxdj IS '账户风险等级';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.fxdjpdrq IS '风险等级评定日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zhahlxzx IS '账户类型子项';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.zjinxinz IS '资金性质';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.xiaohuyy IS '销户原因';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.yxkzclfs IS '原许可证处理方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.yfqqudao IS '原发起渠道';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.yingxjig IS '营销机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhbcxx.ryzd IS '冗余字段';
