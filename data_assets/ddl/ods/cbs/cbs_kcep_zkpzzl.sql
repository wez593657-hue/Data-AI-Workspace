-- crmdm.cbs_kcep_zkpzzl 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kcep_zkpzzl;

CREATE TABLE crmdm.cbs_kcep_zkpzzl (
	farendma varchar(4) NOT NULL, -- 法人代码
	pingzhzl varchar(3) NOT NULL, -- 凭证种类 :001-现金支票,002-转帐支票（非清分）,003-转帐支票（清分）,004-电汇凭证,005-银行汇票申请书,006-商业承兑汇票,007-本票申请书,008-对公存折,010-单位存款证实书,011-单位定期存单,012-银行汇票,013-银行承兑汇票,014-股金证,015-印鉴卡片,016-本票（不定额）,017-定额本票,020-活期一本通存折,021-储蓄普通存折,022-个人活期存单,023-普通存单,024-个人存款证明书,025-定期一本通存折,026-对公存款证明书,028-业务公章,029-定活一本通,030-罚没收据,031-电话费收据（网通）,032-移动手机话费收据,033-留学存款证明书,034-凭证式国债,035-凭证式国债(手工),036-水费发票,037-交通管理处罚收据,039-电话费收据（中国电信）,040-咪表充值收据,041-住宅专项维修资金,042-城镇居民医疗保险基金,043-个体劳动者基本养老保险费收据,044-中英人寿保险收据,046-中国人寿保险收据,047-新华人寿保险收据,048-嘉禾人寿保险收据,049-渤海财险丰利保单,050-假币收缴凭证,051-有线收费专用发票,052-企业USBKEY,053-银行代收费业务专用发票,054-个人普通USBKEY,055-国土UK,056-个人刮刮卡,...
	pngzminc varchar(500) NULL, -- 凭证名称
	pngzbiem varchar(500) NOT NULL, -- 凭证别名
	fenhdaim varchar(4) NOT NULL, -- 分行代码
	pzglfwei varchar(1) NULL, -- 管理机构范围 :0-全行,1-分行,2-机构级别,3-机构范围
	pzsyfwei varchar(1) NULL, -- 使用机构范围 :0-全行,1-本分行,2-谁入谁用,3-机构范围
	huobdaih varchar(3) NOT NULL, -- 货币代码 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币
	pzzhlbie varchar(6) NOT NULL, -- 凭证账户类别
	pzdxzhlb varchar(30) NULL, -- 待销账户类别
	pingzhlx varchar(4) NULL, -- 凭证类型 :1-卡,2-票据,3-存单折,4-其他
	pingzcch varchar(1) NULL, -- 凭证存储 :A-卡,B-活期一本通,C-定期一本通,0-其他凭证
	zkpzbzhi varchar(1) NULL, -- 重要空白凭证标志 :1-是,0-否
	zkpzlxin varchar(2) NULL, -- 重要空白凭证类型 :00-本行重要空白凭证,01-购买他行重要空白凭证,02-其他重要空白凭证
	youjiadz varchar(1) NULL, -- 是否有价单证 :1-是,0-否
	nbkhsyon varchar(1) NULL, -- 是否内部控号 :1-是,0-否
	wbkhsyon varchar(1) NULL, -- 是否控号使用 :1-是,0-否
	lungzbzh varchar(1) NULL, -- 是否有轮冠字 :1-是,0-否
	kfcsduig varchar(1) NULL, -- 可否出售-公 :1-是,0-否
	kfcsduis varchar(1) NULL, -- 可否出售-私 :1-是,0-否
	kefoguas varchar(1) NULL, -- 可否挂失 :1-是,0-否
	kfzypzzz varchar(1) NULL, -- 是否可质押 :1-是,0-否
	kfzfmima varchar(1) NULL, -- 是否可使用支付密码 :1-是,0-否
	sfqfdwei varchar(1) NULL, -- 是否区分单位 :1-是,0-否
	jcdanwzh varchar(1) NULL, -- 单位基础值 :1-张,2-本,3-个,4-把
	kehuifbz varchar(1) NOT NULL, -- 是否可恢复标志 :1-是,0-否
	kezpzsyn varchar(1) NOT NULL, -- 是否可作凭证使用 :1-是,0-否
	sflxzpia varchar(1) NULL, -- 是否旅行支票 :1-是,0-否
	sfzpzhhu varchar(1) NULL, -- 是否支票户标志 :1-是,0-否
	pinzglfs varchar(1) NULL, -- 凭证关联方式 :0-客户账号,1-系统账号
	youxhshu numeric(19) NULL, -- 有效行数
	youxaoys numeric(19) NULL, -- 有效页数
	yeshouhs numeric(19) NULL, -- 页首行数
	shbyhshu numeric(19) NULL, -- 上半页行数
	zhongfhs numeric(19) NULL, -- 中缝行数
	xiabyhsh numeric(19) NULL, -- 下半页行数
	zuidwdzs numeric(19) NULL, -- 最大未登折数
	kazhbzhi varchar(1) NULL, -- 折卡标志 :0-非卡,1-卡,2-无折/卡
	feiygsdm varchar(30) NULL, -- 扉页格式代码
	neiygsdm varchar(10) NULL, -- 内页格式代码
	zidgeshi varchar(10) NULL, -- 字段格式
	shenming varchar(200) NULL, -- 说明
	beiyngzd varchar(200) NULL, -- 备用字段
	beiyngda varchar(200) NULL, -- 备用字段
	beiyngdb varchar(200) NULL, -- 备用字段
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态 :0-正常,1-删除
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pingzhzl IS '凭证种类 :001-现金支票,002-转帐支票（非清分）,003-转帐支票（清分）,004-电汇凭证,005-银行汇票申请书,006-商业承兑汇票,007-本票申请书,008-对公存折,010-单位存款证实书,011-单位定期存单,012-银行汇票,013-银行承兑汇票,014-股金证,015-印鉴卡片,016-本票（不定额）,017-定额本票,020-活期一本通存折,021-储蓄普通存折,022-个人活期存单,023-普通存单,024-个人存款证明书,025-定期一本通存折,026-对公存款证明书,028-业务公章,029-定活一本通,030-罚没收据,031-电话费收据（网通）,032-移动手机话费收据,033-留学存款证明书,034-凭证式国债,035-凭证式国债(手工),036-水费发票,037-交通管理处罚收据,039-电话费收据（中国电信）,040-咪表充值收据,041-住宅专项维修资金,042-城镇居民医疗保险基金,043-个体劳动者基本养老保险费收据,044-中英人寿保险收据,046-中国人寿保险收据,047-新华人寿保险收据,048-嘉禾人寿保险收据,049-渤海财险丰利保单,050-假币收缴凭证,051-有线收费专用发票,052-企业USBKEY,053-银行代收费业务专用发票,054-个人普通USBKEY,055-国土UK,056-个人刮刮卡,...';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pngzminc IS '凭证名称';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pngzbiem IS '凭证别名';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.fenhdaim IS '分行代码';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pzglfwei IS '管理机构范围 :0-全行,1-分行,2-机构级别,3-机构范围';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pzsyfwei IS '使用机构范围 :0-全行,1-本分行,2-谁入谁用,3-机构范围';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.huobdaih IS '货币代码 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pzzhlbie IS '凭证账户类别';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pzdxzhlb IS '待销账户类别';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pingzhlx IS '凭证类型 :1-卡,2-票据,3-存单折,4-其他';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pingzcch IS '凭证存储 :A-卡,B-活期一本通,C-定期一本通,0-其他凭证';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.zkpzbzhi IS '重要空白凭证标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.zkpzlxin IS '重要空白凭证类型 :00-本行重要空白凭证,01-购买他行重要空白凭证,02-其他重要空白凭证';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.youjiadz IS '是否有价单证 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.nbkhsyon IS '是否内部控号 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.wbkhsyon IS '是否控号使用 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.lungzbzh IS '是否有轮冠字 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kfcsduig IS '可否出售-公 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kfcsduis IS '可否出售-私 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kefoguas IS '可否挂失 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kfzypzzz IS '是否可质押 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kfzfmima IS '是否可使用支付密码 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.sfqfdwei IS '是否区分单位 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.jcdanwzh IS '单位基础值 :1-张,2-本,3-个,4-把';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kehuifbz IS '是否可恢复标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kezpzsyn IS '是否可作凭证使用 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.sflxzpia IS '是否旅行支票 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.sfzpzhhu IS '是否支票户标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.pinzglfs IS '凭证关联方式 :0-客户账号,1-系统账号';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.youxhshu IS '有效行数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.youxaoys IS '有效页数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.yeshouhs IS '页首行数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.shbyhshu IS '上半页行数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.zhongfhs IS '中缝行数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.xiabyhsh IS '下半页行数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.zuidwdzs IS '最大未登折数';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.kazhbzhi IS '折卡标志 :0-非卡,1-卡,2-无折/卡';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.feiygsdm IS '扉页格式代码';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.neiygsdm IS '内页格式代码';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.zidgeshi IS '字段格式';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.shenming IS '说明';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.beiyngda IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.beiyngdb IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.jiluztai IS '记录状态 :0-正常,1-删除';
COMMENT ON COLUMN crmdm.cbs_kcep_zkpzzl.ryzd IS '冗余字段';
