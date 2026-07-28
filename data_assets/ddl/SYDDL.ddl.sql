-- crmdm.ads_cust_deadline_rmnd_dtl 定义

-- Drop table

-- DROP TABLE crmdm.ads_cust_deadline_rmnd_dtl;

CREATE TABLE crmdm.ads_cust_deadline_rmnd_dtl (
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	data_date varchar(8) NULL, -- 数据日期
	cust_id varchar(20) NULL, -- 客户编号
	cust_name varchar(100) NULL, -- 客户名称
	cust_lvl varchar(2) NULL, -- 客户等级
	depo_curnt_depo_bal numeric(20, 2) NULL, -- 活期余额
	fixd_depo_bal numeric(20, 2) NULL, -- 定期余额
	fin_amt numeric(20, 2) NULL, -- 理财余额
	stat_perd varchar(2) NULL, -- 统计周期
	statis_typ varchar(2) NULL, -- 承接类型0-全部1-存款2-理财
	expr_amt numeric(20, 2) NULL, -- 到期金额
	mature_ttl_amt numeric(20, 2) NULL, -- 到期总金额
	take_rate numeric(10, 2) NULL, -- 承接率
	fix_depo_mature_amt numeric(20, 2) NULL, -- 定期存款到期金额
	fix_depo_mature_ttl_amt numeric(20, 2) NULL, -- 定期存款到期总金额
	fix_depo_take_rate numeric(10, 2) NULL, -- 定期存款承接率
	cntct_state varchar(1) NULL, -- 接触状态
	undtake_state varchar(1) NULL, -- 承接状态
	fixed_fin_mature_tran_insur_amt numeric(20, 2) NULL, -- 定期理财到期转保险金额
	fin_mature_tran_fixed_amt numeric(20, 2) NULL, -- 理财到期转定期金额
	fixed_mature_tran_fin_amt numeric(20, 2) NULL, -- 定期到期转理财金额
	frst_mature_pk_bf_day_aum_bal numeric(20, 2) NULL, -- 本期第一笔到期产品前一日AUM余额
	last_end_date varchar(8) NULL, -- 本期最后一笔到期产品日期
	post_id varchar(20) NULL, -- 管户经理
	org_id varchar(7) NULL -- 归属机构
);
COMMENT ON TABLE crmdm.ads_cust_deadline_rmnd_dtl IS '到期承接明细表';

-- Column comments

COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.cust_lvl IS '客户等级';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.depo_curnt_depo_bal IS '活期余额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fixd_depo_bal IS '定期余额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fin_amt IS '理财余额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.stat_perd IS '统计周期';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.statis_typ IS '承接类型0-全部1-存款2-理财';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.expr_amt IS '到期金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.mature_ttl_amt IS '到期总金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.take_rate IS '承接率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fix_depo_mature_amt IS '定期存款到期金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fix_depo_mature_ttl_amt IS '定期存款到期总金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fix_depo_take_rate IS '定期存款承接率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.cntct_state IS '接触状态';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.undtake_state IS '承接状态';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fixed_fin_mature_tran_insur_amt IS '定期理财到期转保险金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fin_mature_tran_fixed_amt IS '理财到期转定期金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.fixed_mature_tran_fin_amt IS '定期到期转理财金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.frst_mature_pk_bf_day_aum_bal IS '本期第一笔到期产品前一日AUM余额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.last_end_date IS '本期最后一笔到期产品日期';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.post_id IS '管户经理';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_dtl.org_id IS '归属机构';


-- crmdm.ads_cust_deadline_rmnd_statis 定义

-- Drop table

-- DROP TABLE crmdm.ads_cust_deadline_rmnd_statis;

CREATE TABLE crmdm.ads_cust_deadline_rmnd_statis (
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	data_date varchar(8) NULL, -- 数据日期
	statis_obj varchar(20) NULL, -- 统计对象
	statis_cycle varchar(2) NULL, -- 统计周期
	statis_typ varchar(2) NULL, -- 承接类型0-全部1-存款2-理财
	expr_cust_cnt numeric(8) NULL, -- 已到期客户数
	ttl_expr_cust_cnt numeric(8) NULL, -- 总到期客户数
	expr_amt numeric(20, 2) NULL, -- 已到期金额
	ttl_expr_amt numeric(20, 2) NULL, -- 总到期金额
	cust_undtake_rate numeric(20, 2) NULL, -- 客户承接率
	asset_keep_rate numeric(20, 2) NULL, -- 资产留存率
	asset_undtake_rate numeric(20, 2) NULL, -- 资产承接率
	depo_to_fin_convrs_rate numeric(20, 2) NULL, -- 存款转理财转化率
	insur_convrs_rate numeric(20, 2) NULL, -- 保险转化率
	fin_to_depo_convrs_rate numeric(20, 2) NULL -- 理财转存款转化率
);
COMMENT ON TABLE crmdm.ads_cust_deadline_rmnd_statis IS '到期承接统计表';

-- Column comments

COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.statis_obj IS '统计对象';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.statis_cycle IS '统计周期';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.statis_typ IS '承接类型0-全部1-存款2-理财';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.expr_cust_cnt IS '已到期客户数';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.ttl_expr_cust_cnt IS '总到期客户数';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.expr_amt IS '已到期金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.ttl_expr_amt IS '总到期金额';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.cust_undtake_rate IS '客户承接率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.asset_keep_rate IS '资产留存率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.asset_undtake_rate IS '资产承接率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.depo_to_fin_convrs_rate IS '存款转理财转化率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.insur_convrs_rate IS '保险转化率';
COMMENT ON COLUMN crmdm.ads_cust_deadline_rmnd_statis.fin_to_depo_convrs_rate IS '理财转存款转化率';


-- crmdm.ads_mkt_rec_info 定义

-- Drop table

-- DROP TABLE crmdm.ads_mkt_rec_info;

CREATE TABLE crmdm.ads_mkt_rec_info (
	mkt_rec_seq_id varchar(40) NULL, -- 营销记录流水号
	rel_id varchar(40) NULL, -- 关联ID(商机ID、客户群ID/营销活动ID)
	mkt_typ varchar(6) NULL, -- 营销类型(1面访/2电话/3短信/4企微)
	rel_typ varchar(6) NULL, -- 关联类型(客户群/商机/营销活动)
	cust_id varchar(20) NULL, -- 客户ID
	cust_name varchar(100) NULL, -- 客户名称
	mkt_site varchar(200) NULL, -- 营销地点
	mkt_time varchar(20) NULL, -- 营销时间
	mkt_persn varchar(30) NULL, -- 营销人ID
	mkt_persn_name varchar(64) NULL, -- 营销人名称
	mkt_org varchar(7) NULL, -- 营销机构
	mkt_dura varchar(20) NULL, -- 营销时长
	mkt_dtl_situ varchar(400) NULL, -- 营销详细情况
	mkt_apdix_id varchar(40) NULL, -- 营销附件ID(录音/图片)
	temp_id varchar(40) NULL, -- 模板ID
	temp_name varchar(100) NULL, -- 模板名称
	msg_short_seq_id varchar(40) NULL, -- 短信流水号
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	cordnat_visitor varchar(100) NULL, -- 协同拜访人
	cordnat_visitor_name varchar(200) NULL, -- 协同拜访人名称
	lgtud varchar(40) NULL, -- 经度
	lattud varchar(40) NULL, -- 纬度
	tel_no varchar(40) NULL, -- 联系电话
	chnl_no varchar(6) NULL, -- 渠道编号
	rmark varchar(400) NULL, -- 备注
	no_bat varchar(40) NULL, -- 批次号
	msg_short_inf varchar(500) NULL -- 短信内容
);
COMMENT ON TABLE crmdm.ads_mkt_rec_info IS '营销记录表';

-- Column comments

COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_rec_seq_id IS '营销记录流水号';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.rel_id IS '关联ID(商机ID、客户群ID/营销活动ID)';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_typ IS '营销类型(1面访/2电话/3短信/4企微)';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.rel_typ IS '关联类型(客户群/商机/营销活动)';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.cust_id IS '客户ID';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_site IS '营销地点';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_time IS '营销时间';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_persn IS '营销人ID';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_persn_name IS '营销人名称';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_org IS '营销机构';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_dura IS '营销时长';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_dtl_situ IS '营销详细情况';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.mkt_apdix_id IS '营销附件ID(录音/图片)';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.temp_id IS '模板ID';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.temp_name IS '模板名称';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.msg_short_seq_id IS '短信流水号';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.cordnat_visitor IS '协同拜访人';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.cordnat_visitor_name IS '协同拜访人名称';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.lgtud IS '经度';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.lattud IS '纬度';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.tel_no IS '联系电话';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.chnl_no IS '渠道编号';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.rmark IS '备注';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.no_bat IS '批次号';
COMMENT ON COLUMN crmdm.ads_mkt_rec_info.msg_short_inf IS '短信内容';


-- crmdm.cbs_kapp_jioyxx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kapp_jioyxx;

CREATE TABLE crmdm.cbs_kapp_jioyxx (
	jiaoyima varchar(10) NULL, -- 交易码
	jiaoyimc varchar(1000) NULL, -- 交易名称
	jiaoyilx varchar(1) NULL, -- 交易类型
	macflags varchar(1) NULL, -- 验MAC标志
	pinflags varchar(1) NULL, -- 验PIN标志
	dmyunxbz varchar(1) NULL, -- 当日抹账允许标志
	gmyunxbz varchar(1) NULL, -- 隔日抹账允许标志
	neibclma varchar(10) NULL, -- 内部处理码
	caidanma varchar(10) NULL, -- 菜单归属
	yunxzxbz varchar(1) NULL, -- 是否允许执行
	djblusbz varchar(1) NULL, -- 是否登记包流水日志
	sfwzdjbw varchar(1) NULL, -- 是否完整登记报文信息
	csshjian numeric(19) NULL, -- 超时时间
	rzhjibie varchar(8) NULL, -- 日志级别
	jiluztai varchar(1) NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.jiaoyima IS '交易码';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.jiaoyimc IS '交易名称';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.jiaoyilx IS '交易类型';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.macflags IS '验MAC标志';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.pinflags IS '验PIN标志';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.dmyunxbz IS '当日抹账允许标志';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.gmyunxbz IS '隔日抹账允许标志';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.neibclma IS '内部处理码';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.caidanma IS '菜单归属';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.yunxzxbz IS '是否允许执行';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.djblusbz IS '是否登记包流水日志';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.sfwzdjbw IS '是否完整登记报文信息';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.csshjian IS '超时时间';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.rzhjibie IS '日志级别';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kapp_jioyxx.ryzd IS '冗余字段';


-- crmdm.cbs_kbrp_gxdyii 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_gxdyii;

CREATE TABLE crmdm.cbs_kbrp_gxdyii (
	farendma varchar(4) NOT NULL, -- 法人代码
	guanxizl varchar(2) NOT NULL, -- 关系种类
	relnamee varchar(6) NOT NULL, -- 业务关系名
	yewugxms varchar(200) NOT NULL, -- 关系描述
	yewugxzl varchar(6) NULL, -- 业务关系种类
	guanxbzg varchar(1) NULL, -- 关系币种规则
	guanxshj varchar(1) NULL, -- 关系多上级
	guxiqxjc varchar(1) NULL, -- 关系权限继承
	moduleee varchar(2) NULL, -- 模块
	shenming varchar(200) NULL, -- 说明
	beiyngzd varchar(200) NULL, -- 备用字段
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guanxizl IS '关系种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.relnamee IS '业务关系名';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.yewugxms IS '关系描述';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.yewugxzl IS '业务关系种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guanxbzg IS '关系币种规则';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guanxshj IS '关系多上级';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.guxiqxjc IS '关系权限继承';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.moduleee IS '模块';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.shenming IS '说明';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_gxdyii.ryzd IS '冗余字段';


-- crmdm.cbs_kbrp_jgcshu 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_jgcshu;

CREATE TABLE crmdm.cbs_kbrp_jgcshu (
	farendma varchar(4) NOT NULL, -- 法人代码
	jigouhao varchar(10) NOT NULL, -- 营业机构号
	fenhdaim varchar(4) NOT NULL, -- 分行代码
	jigoleix varchar(1) NOT NULL, -- 机构类型
	jigouzwm varchar(500) NULL, -- 机构中文名称
	jigoujch varchar(50) NULL, -- 机构简称
	jigouywm varchar(500) NULL, -- 机构英文名称
	jigoujpi varchar(50) NULL, -- 机构简拼
	diqdaima varchar(20) NULL, -- 地区代号
	shengquh varchar(20) NULL, -- 省区代号
	dizhiiii varchar(500) NULL, -- 地址
	yinwendz varchar(200) NULL, -- 英文地址
	youzhnbm varchar(10) NULL, -- 邮政编码
	dianhhma varchar(20) NULL, -- 电话号码
	chunzhen varchar(40) NULL, -- 传真号码
	dbguahao varchar(20) NULL, -- 金融许可证号
	lianxirm varchar(500) NULL, -- 联系人
	lnxrdhua varchar(40) NULL, -- 联系人电话
	emaildiz varchar(200) NULL, -- email地址
	wangzhii varchar(200) NULL, -- 网址
	songbsbm varchar(20) NULL, -- 设备名
	dyduilmc varchar(20) NULL, -- 报表队列名
	fenhipdz varchar(32) NULL, -- 分行ip地址
	fenhport varchar(4) NULL, -- 分行port号
	cunzyhbz varchar(1) NULL, -- 村镇银行村志
	zmaoqubz varchar(1) NULL, -- 自贸区标志
	jgfwqdzm varchar(500) NULL, -- 机构服务器地址名称
	qiyongrq varchar(8) NULL, -- 启用
	beiyngzd varchar(200) NULL, -- 备用字段
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	zjgcbibz varchar(1) NULL, -- 整机构撤并标志
	jingduxx varchar(200) NULL, -- 经度
	weiduxxz varchar(200) NULL, -- 纬度
	dgyiyesj varchar(200) NULL, -- 对公营业时间
	dsyiyesj varchar(200) NULL, -- 个人营业时间
	ssdiqudm varchar(12) NULL, -- 行政区划代码
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigouhao IS '营业机构号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.fenhdaim IS '分行代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigoleix IS '机构类型';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigouzwm IS '机构中文名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigoujch IS '机构简称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigouywm IS '机构英文名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jigoujpi IS '机构简拼';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.diqdaima IS '地区代号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.shengquh IS '省区代号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dizhiiii IS '地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.yinwendz IS '英文地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.youzhnbm IS '邮政编码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dianhhma IS '电话号码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.chunzhen IS '传真号码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dbguahao IS '金融许可证号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.lianxirm IS '联系人';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.lnxrdhua IS '联系人电话';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.emaildiz IS 'email地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.wangzhii IS '网址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.songbsbm IS '设备名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dyduilmc IS '报表队列名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.fenhipdz IS '分行ip地址';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.fenhport IS '分行port号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.cunzyhbz IS '村镇银行村志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.zmaoqubz IS '自贸区标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jgfwqdzm IS '机构服务器地址名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.qiyongrq IS '启用';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.zjgcbibz IS '整机构撤并标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.jingduxx IS '经度';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.weiduxxz IS '纬度';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dgyiyesj IS '对公营业时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.dsyiyesj IS '个人营业时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.ssdiqudm IS '行政区划代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jgcshu.ryzd IS '冗余字段';


-- crmdm.cbs_kbrp_jggxii 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_jggxii;

CREATE TABLE crmdm.cbs_kbrp_jggxii (
	farendma varchar(4) NOT NULL, -- 法人代码
	jigouhao varchar(10) NOT NULL, -- 机构号
	yewugxzl varchar(6) NOT NULL, -- 业务关系种类
	bizhjihe varchar(3) NOT NULL, -- 币种集合
	yewugxjg varchar(10) NOT NULL, -- 业务关系机构
	yewugxjb varchar(1) NOT NULL, -- 业务关系级别
	guxiqxjg varchar(10) NULL, -- 关系权限机构
	shenming varchar(200) NULL, -- 说明
	beiyngzd varchar(200) NULL, -- 备用字段
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.jigouhao IS '机构号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.yewugxzl IS '业务关系种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.bizhjihe IS '币种集合';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.yewugxjg IS '业务关系机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.yewugxjb IS '业务关系级别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.guxiqxjg IS '关系权限机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.shenming IS '说明';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.beiyngzd IS '备用字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_jggxii.ryzd IS '冗余字段';


-- crmdm.cbs_kbrp_jycshu 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kbrp_jycshu;

CREATE TABLE crmdm.cbs_kbrp_jycshu (
	farendma varchar(4) NOT NULL, -- 法人代码
	jiaoyima varchar(20) NOT NULL, -- 交易码
	jiaoyimc varchar(200) NULL, -- 交易名称
	fenhfanw varchar(4) NULL, -- 分行范围
	jigoufwe varchar(10) NULL, -- 机构范围
	bizhfanw varchar(2) NULL, -- 币种范围
	chpfawei varchar(10) NULL, -- 产品范围
	qudaofaw varchar(3) NULL, -- 渠道范围
	kehulxfw varchar(2) NULL, -- 客户类型范围
	sfhecalx varchar(1) NULL, -- 身份核查类型
	jiarczbz varchar(1) NULL, -- 假日操作标志
	drmzyxbz varchar(1) NULL, -- 当日抹帐允许标志
	grmzyxbz varchar(1) NULL, -- 隔日抹帐允许标志
	jiaoyifs varchar(1) NULL, -- 交易方式
	jioyzxms varchar(1) NULL, -- 交易执行模式
	qxjcfshi varchar(1) NULL, -- 交易检查标志
	joyizblb varchar(1000) NULL, -- 交易组别列表
	kuajgczb varchar(1) NULL, -- 跨机构操作标志
	shouqzle varchar(1) NULL, -- 授权种类
	bizhsxxx varchar(1) NULL, -- 币种顺序
	qhtsqboz varchar(1) NULL, -- 前后台授权标志
	ercilrbz varchar(1) NULL, -- 授权二次录入标志
	shoqjibe varchar(1) NULL, -- 授权级别
	shoqfans varchar(1) NULL, -- 授权方式
	bendsqcs numeric(19) NULL, -- 本地授权次数
	shoqcjdm varchar(10) NULL, -- 授权层级代码
	jigyyjib varchar(1) NULL, -- 授权机构级别
	shoqjigo varchar(10) NULL, -- 授权机构
	shoqguiy varchar(8) NULL, -- 授权柜员
	kajigoth varchar(1) NULL, -- 机构替换标志
	thzhzidm varchar(20) NULL, -- 替换帐号字段名
	jioyshux varchar(1) NULL, -- 交易属性
	jiaoyleb varchar(1) NULL, -- 交易类别
	guiylslx varchar(1) NULL, -- 柜员流水类型
	fujinejz varchar(1) NULL, -- 负金额记账允许标志
	fuwumasj varchar(20) NULL, -- 服务码
	zjlaiyqx varchar(20) NULL, -- 资金来源去向检查字段名
	jyjdjczd varchar(20) NULL, -- 借贷检查字段名
	jigohozd varchar(20) NULL, -- 机构号检查字段名
	chpjczid varchar(20) NULL, -- 产品代码检查字段名
	kehhjczd varchar(20) NULL, -- 客户号检查字段名
	zhjchazd varchar(20) NULL, -- 帐号检查字段名
	hbdhjczd varchar(20) NULL, -- 货币代号检查字段名
	chhjczid varchar(20) NULL, -- 钞汇检查字段
	zhleixzd varchar(20) NULL, -- 帐号类型检查字段名
	zhxhaozd varchar(20) NULL, -- 帐号序号检查字段名
	qishisji numeric(19) NULL, -- 起始时间
	zhongzsj numeric(19) NULL, -- 终止时间
	yemianfh varchar(1) NULL, -- 页面返回
	beiyngzd varchar(200) NULL, -- 备用字段1
	rowidddd varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyima IS '交易码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyimc IS '交易名称';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.fenhfanw IS '分行范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jigoufwe IS '机构范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.bizhfanw IS '币种范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.chpfawei IS '产品范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qudaofaw IS '渠道范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kehulxfw IS '客户类型范围';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.sfhecalx IS '身份核查类型';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiarczbz IS '假日操作标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.drmzyxbz IS '当日抹帐允许标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.grmzyxbz IS '隔日抹帐允许标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyifs IS '交易方式';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jioyzxms IS '交易执行模式';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qxjcfshi IS '交易检查标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.joyizblb IS '交易组别列表';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kuajgczb IS '跨机构操作标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shouqzle IS '授权种类';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.bizhsxxx IS '币种顺序';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qhtsqboz IS '前后台授权标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.ercilrbz IS '授权二次录入标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqjibe IS '授权级别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqfans IS '授权方式';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.bendsqcs IS '本地授权次数';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqcjdm IS '授权层级代码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jigyyjib IS '授权机构级别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqjigo IS '授权机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shoqguiy IS '授权柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kajigoth IS '机构替换标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.thzhzidm IS '替换帐号字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jioyshux IS '交易属性';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiaoyleb IS '交易类别';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.guiylslx IS '柜员流水类型';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.fujinejz IS '负金额记账允许标志';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.fuwumasj IS '服务码';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zjlaiyqx IS '资金来源去向检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jyjdjczd IS '借贷检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jigohozd IS '机构号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.chpjczid IS '产品代码检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.kehhjczd IS '客户号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhjchazd IS '帐号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.hbdhjczd IS '货币代号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.chhjczid IS '钞汇检查字段';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhleixzd IS '帐号类型检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhxhaozd IS '帐号序号检查字段名';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.qishisji IS '起始时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.zhongzsj IS '终止时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.yemianfh IS '页面返回';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.beiyngzd IS '备用字段1';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.rowidddd IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kbrp_jycshu.ryzd IS '冗余字段';


-- crmdm.cbs_kcda_pzjcxx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kcda_pzjcxx;

CREATE TABLE crmdm.cbs_kcda_pzjcxx (
	farendma varchar(4) NOT NULL, -- 法人代码
	kahaoooo varchar(35) NOT NULL, -- 卡号
	kehuhaoo varchar(16) NULL, -- 客户号
	chanphao varchar(10) NOT NULL, -- 产品编号
	kaxingzh varchar(1) NOT NULL, -- 卡种性质
	kazhongl varchar(1) NOT NULL, -- 卡种类
	kajiezhi varchar(1) NOT NULL, -- 卡介质
	kadxiang varchar(1) NOT NULL, -- 卡对象
	ckrzwenm varchar(500) NULL, -- 持卡人中文名
	ckrmpyin varchar(500) NULL, -- 持卡人姓名拼音
	kadengji varchar(1) NOT NULL, -- 卡等级
	zhukahao varchar(35) NULL, -- 主卡号
	youwuzbz varchar(10) NULL, -- 有无折标志
	ksqjigou varchar(10) NULL, -- 卡申请机构
	ksqriqii varchar(8) NULL, -- 卡申请日期
	fakajigo varchar(10) NULL, -- 发卡机构
	fakariqi varchar(8) NULL, -- 发卡日期
	fakaguiy varchar(8) NULL, -- 发卡柜员
	fakafngs varchar(1) NULL, -- 发卡方式
	hxiojigo varchar(10) NULL, -- 核销机构
	hxioriqi varchar(8) NULL, -- 核销日期
	hxioguiy varchar(8) NULL, -- 核销柜员
	xlaommbz varchar(1) NULL, -- 新老密码标志
	youxriqi varchar(200) NULL, -- 有效日期
	pzsyztai varchar(1) NOT NULL, -- 凭证使用状态
	sfymmfbz varchar(1) NOT NULL, -- 需要密码封标志
	fakaqdao varchar(7) NULL, -- 发卡渠道
	fkalxren varchar(500) NULL, -- 发卡联系人
	weixjigo varchar(10) NULL, -- 尾箱账务机构
	jccvnnbz varchar(1) NULL, -- 检查CVN标志
	gnkzhibz varchar(1) NULL, -- 功能控制标志
	yuxhriqi varchar(8) NULL, -- 预销户日期
	vipptkbz varchar(2) NULL, -- VIP/普卡标志
	ygkbiaoz varchar(1) NULL, -- 员工卡标志
	sfzdxqbz varchar(1) NULL, -- 自动续期标志
	sfzdxkbz varchar(1) NULL, -- 自动续卡标志
	sfcszdbz varchar(1) NULL, -- 产生对账单标志
	gjkbiaoz varchar(1) NULL, -- 国际卡标志
	yikatobz varchar(1) NULL, -- 一卡通标志
	xlaokabz varchar(1) NULL, -- 新老卡标志
	sbkbiaoz varchar(1) NULL, -- 社保卡标志
	gzkbiaoz varchar(1) NULL, -- 工资卡标志
	mnnfqiii varchar(8) NULL, -- 免年费期
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	shifskbz varchar(1) NULL, -- 是否锁卡标志
	gmjmjioy varchar(10) NULL, -- 国密加密校验位
	gmmacjyw varchar(10) NULL, -- 国密MAC校验位
	gmmaczxx varchar(2000) NULL, -- 国密MAC值信息
	gmzjmipz varchar(2000) NULL, -- 国密四级字段转加密配置
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kahaoooo IS '卡号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kehuhaoo IS '客户号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.chanphao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kaxingzh IS '卡种性质';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kazhongl IS '卡种类';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kajiezhi IS '卡介质';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kadxiang IS '卡对象';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ckrzwenm IS '持卡人中文名';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ckrmpyin IS '持卡人姓名拼音';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.kadengji IS '卡等级';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.zhukahao IS '主卡号';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.youwuzbz IS '有无折标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ksqjigou IS '卡申请机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ksqriqii IS '卡申请日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakajigo IS '发卡机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakariqi IS '发卡日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakaguiy IS '发卡柜员';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakafngs IS '发卡方式';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.hxiojigo IS '核销机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.hxioriqi IS '核销日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.hxioguiy IS '核销柜员';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.xlaommbz IS '新老密码标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.youxriqi IS '有效日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.pzsyztai IS '凭证使用状态';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfymmfbz IS '需要密码封标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fakaqdao IS '发卡渠道';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.fkalxren IS '发卡联系人';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weixjigo IS '尾箱账务机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.jccvnnbz IS '检查CVN标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gnkzhibz IS '功能控制标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.yuxhriqi IS '预销户日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.vipptkbz IS 'VIP/普卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ygkbiaoz IS '员工卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfzdxqbz IS '自动续期标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfzdxkbz IS '自动续卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sfcszdbz IS '产生对账单标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gjkbiaoz IS '国际卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.yikatobz IS '一卡通标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.xlaokabz IS '新老卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.sbkbiaoz IS '社保卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gzkbiaoz IS '工资卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.mnnfqiii IS '免年费期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.shifskbz IS '是否锁卡标志';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmjmjioy IS '国密加密校验位';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmmacjyw IS '国密MAC校验位';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmmaczxx IS '国密MAC值信息';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.gmzjmipz IS '国密四级字段转加密配置';
COMMENT ON COLUMN crmdm.cbs_kcda_pzjcxx.ryzd IS '冗余字段';


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


-- crmdm.cbs_kcfp_cfzlcs 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kcfp_cfzlcs;

CREATE TABLE crmdm.cbs_kcfp_cfzlcs (
	farendma varchar(4) NOT NULL, -- 法人代码
	canshmch varchar(500) NOT NULL, -- 参数名称
	canshuzh varchar(35) NOT NULL, -- 参数值
	cansshju varchar(80) NULL, -- 参数数据
	beiyshju varchar(80) NULL, -- 备用数据
	canshshm varchar(200) NOT NULL, -- 参数说明
	xuliehao varchar(30) NULL, -- 序列号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.canshmch IS '参数名称';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.canshuzh IS '参数值';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.cansshju IS '参数数据';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.beiyshju IS '备用数据';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.canshshm IS '参数说明';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.xuliehao IS '序列号';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kcfp_cfzlcs.ryzd IS '冗余字段';


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


-- crmdm.cbs_kdpa_zhduiz 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhduiz;

CREATE TABLE crmdm.cbs_kdpa_zhduiz (
	farendma varchar(4) NOT NULL, -- 法人代码
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	zhhaoxuh varchar(8) NOT NULL, -- 子账户序号
	kehuzhlx varchar(1) NOT NULL, -- 客户账号类型
	zhanghao varchar(40) NOT NULL, -- 负债账号
	zhhuxinz varchar(4) NULL, -- 账户性质
	huobdaih varchar(3) NOT NULL, -- 货币代号
	chaohubz varchar(1) NOT NULL, -- 账户钞汇标志
	mingxxuh numeric(19) NULL, -- 负债账号明细序号
	sfyzbzhi varchar(1) NULL, -- 是否有折标志
	zhhuztai varchar(1) NOT NULL, -- 账户状态
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhhaoxuh IS '子账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.kehuzhlx IS '客户账号类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhhuxinz IS '账户性质';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.chaohubz IS '账户钞汇标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.mingxxuh IS '负债账号明细序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.sfyzbzhi IS '是否有折标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.zhhuztai IS '账户状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhduiz.ryzd IS '冗余字段';


-- crmdm.cbs_kdpa_zhlldy 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhlldy;

CREATE TABLE crmdm.cbs_kdpa_zhlldy (
	farendma varchar(4) NOT NULL, -- 法人代码
	zhanghao varchar(40) NOT NULL, -- 负债账号
	pcljigoh varchar(10) NULL, -- 批处理机构
	kaihjigo varchar(10) NOT NULL, -- 开户机构
	huobdaih varchar(3) NULL, -- 货币代号
	fzlvleix varchar(8) NOT NULL, -- 负债利率类型
	shunxhao numeric(19) NOT NULL, -- 顺序号
	shezlljh varchar(1) NOT NULL, -- 设置利率计划标志
	lilvbhao varchar(20) NULL, -- 利率编号
	lilvbhlx varchar(1) NULL, -- 利率编号类型
	cencllbh varchar(20) NULL, -- 层次利率编号
	lilvdanc numeric(17, 2) NULL, -- 利率档次
	cencllcq varchar(6) NULL, -- 层次利率存期
	cunqiiii varchar(6) NULL, -- 存期
	lilvcqbz varchar(1) NULL, -- 利率存期标志
	lilvyebz varchar(1) NULL, -- 利率余额标志
	lilvkdfs varchar(1) NOT NULL, -- 利率靠档方式
	shxoriqi varchar(8) NULL, -- 账户利率编号生效日
	llbhsxrq varchar(8) NULL, -- 账户利率编号失效日
	lilvqdrq varchar(1) NULL, -- 利率确定日期
	ymdflagg varchar(1) NULL, -- 开户利率的年月利率标识
	kaihlilv numeric(12, 7) NULL, -- 开户利率
	jizhunll numeric(12, 7) NULL, -- 基准利率
	zhxililv numeric(12, 7) NULL, -- 当前执行利率
	lilvfdbz varchar(1) NOT NULL, -- 利率浮动标志
	llfdonbz varchar(1) NULL, -- 利率浮动标志1
	lilvfdlx varchar(1) NULL, -- 利率浮动类型
	lilvfdsz numeric(12, 7) NULL, -- 利率浮动值
	youhuibz varchar(1) NULL, -- 优惠标志
	youhuilx varchar(1) NULL, -- 优惠类型
	youhuisz numeric(12, 7) NULL, -- 优惠值
	lilvgxpl varchar(8) NULL, -- 利率更新频率
	shcigxrq varchar(8) NOT NULL, -- 利率上次更新日
	xacigxrq varchar(8) NULL, -- 利率下次更新日
	scjitilv numeric(12, 7) NULL, -- 上次计提利率
	tzlixibz varchar(1) NOT NULL, -- 利率变化调整利息标志
	tzlilvbz varchar(1) NOT NULL, -- 利率变化调整利率标志
	lilvdmlx varchar(1) NULL, -- 利率代码类型
	youhtzpl varchar(8) NULL, -- 优惠调整频率
	tzyouhbz varchar(1) NULL, -- 优惠变化调整优惠标志
	yhscriqi varchar(8) NULL, -- 优惠上次更新日
	yhxcriqi varchar(8) NULL, -- 优惠下次更新日
	fencleix varchar(2) NULL, -- 分层类型
	pjyeleix varchar(2) NULL, -- 平均余额类型
	zdqixian varchar(8) NULL, -- 指定期限
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.pcljigoh IS '批处理机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.kaihjigo IS '开户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.fzlvleix IS '负债利率类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shunxhao IS '顺序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shezlljh IS '设置利率计划标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvbhao IS '利率编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvbhlx IS '利率编号类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.cencllbh IS '层次利率编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvdanc IS '利率档次';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.cencllcq IS '层次利率存期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.cunqiiii IS '存期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvcqbz IS '利率存期标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvyebz IS '利率余额标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvkdfs IS '利率靠档方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shxoriqi IS '账户利率编号生效日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.llbhsxrq IS '账户利率编号失效日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvqdrq IS '利率确定日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.ymdflagg IS '开户利率的年月利率标识';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.kaihlilv IS '开户利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.jizhunll IS '基准利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.zhxililv IS '当前执行利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvfdbz IS '利率浮动标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.llfdonbz IS '利率浮动标志1';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvfdlx IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvfdsz IS '利率浮动值';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhuibz IS '优惠标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhuilx IS '优惠类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhuisz IS '优惠值';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvgxpl IS '利率更新频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shcigxrq IS '利率上次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.xacigxrq IS '利率下次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.scjitilv IS '上次计提利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.tzlixibz IS '利率变化调整利息标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.tzlilvbz IS '利率变化调整利率标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.lilvdmlx IS '利率代码类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.youhtzpl IS '优惠调整频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.tzyouhbz IS '优惠变化调整优惠标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.yhscriqi IS '优惠上次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.yhxcriqi IS '优惠下次更新日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.fencleix IS '分层类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.pjyeleix IS '平均余额类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.zdqixian IS '指定期限';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhlldy.ryzd IS '冗余字段';


-- crmdm.cbs_kdpa_zhxinx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpa_zhxinx;

CREATE TABLE crmdm.cbs_kdpa_zhxinx (
	farendma varchar(4) NOT NULL, -- 法人代码
	zhanghao varchar(40) NOT NULL, -- 负债账号
	zhhuzwmc varchar(500) NOT NULL, -- 账户名称
	kehuhaoo varchar(16) NOT NULL, -- 客户号
	guobdaim varchar(10) NULL, -- 国别代码
	huobdaih varchar(3) NOT NULL, -- 货币代号
	chaohubz varchar(1) NOT NULL, -- 账户钞汇标志
	cunqiiii varchar(6) NOT NULL, -- 存期
	doqiriqi varchar(8) NULL, -- 到期日期
	qixifans varchar(1) NOT NULL, -- 起息方式
	csqixirq varchar(8) NOT NULL, -- 初始起息日期
	csdoqirq varchar(8) NULL, -- 初始到期日期
	yewudhao varchar(6) NULL, -- 业务代号
	pcljigoh varchar(10) NULL, -- 批处理机构
	zhujigoh varchar(10) NULL, -- 账户所属机构
	kaihjigo varchar(10) NOT NULL, -- 开户机构
	kaihriqi varchar(8) NOT NULL, -- 开户日期
	kaihguiy varchar(8) NOT NULL, -- 账户开户柜员
	xiohjigo varchar(10) NULL, -- 账户销户机构
	xiohriqi varchar(8) NULL, -- 账户销户日期
	xiohguiy varchar(10) NULL, -- 账户销户柜员
	lancreny varchar(500) NULL, -- 揽存人员
	lancrymc varchar(500) NULL, -- 账户经理名称
	youxriqi varchar(8) NULL, -- 账户有效期
	weiyxuho numeric(19) NULL, -- 当前未用序号
	zhhuyuee numeric(21, 2) NOT NULL, -- 当前账户余额
	shrizhye numeric(21, 2) NOT NULL, -- 上日账户余额
	yegxriqi varchar(8) NOT NULL, -- 余额最近更新日期
	sccrriqi varchar(8) NULL, -- 首次存入日期
	scywriqi varchar(8) NULL, -- 上次业务日期
	scsfriqi varchar(8) NULL, -- 上次代收付日期
	chapbhao varchar(10) NOT NULL, -- 产品编号
	fzcpleix varchar(1) NOT NULL, -- 负债产品类型
	suoshudx varchar(1) NOT NULL, -- 产品所属对象
	zhufldm1 varchar(10) NULL, -- 账户分类代码1
	zhufldm2 varchar(10) NULL, -- 账户分类代码2
	zhufldm3 varchar(10) NULL, -- 账户分类代码3
	huansbiz varchar(3) NOT NULL, -- 换算币种
	zuidlcye numeric(21, 2) NULL, -- 最大留存余额
	zuixlcye numeric(21, 2) NULL, -- 最小留存余额
	cunrkzhi varchar(1) NOT NULL, -- 存入控制方式
	cunrkzff varchar(1) NULL, -- 存入控制方法
	cunrclsx varchar(32) NOT NULL, -- 存入处理顺序
	zhiqkzfs varchar(1) NOT NULL, -- 支取控制方式
	zhiqkzff varchar(1) NULL, -- 支取控制方法
	zdzqkzfs varchar(4) NULL, -- 自定义支取控制方式
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	zhcunfsh varchar(1) NULL, -- 转存方式
	beiyjine numeric(21, 2) NULL, -- 备用金额
	kaihjine numeric(21, 2) NULL, -- 开户金额
	cunkzlei varchar(2) NOT NULL, -- 存款种类
	zhhuztai varchar(1) NOT NULL, -- 账户状态
	yezztbbz varchar(1) NOT NULL, -- 余额与总账同步标志
	zhcphaoo varchar(10) NULL, -- 组合产品号
	zhcpxuho varchar(8) NULL, -- 组合产品序号
	zhcpmuzh varchar(35) NULL, -- 组合产品母账户号
	zhzhleix varchar(1) NULL, -- 组合账户类型
	zhhuxzbz varchar(1) NOT NULL, -- 账户限制标志
	xzhileix varchar(1) NULL, -- 限制类型
	xunhdkbz varchar(1) NOT NULL, -- 循环贷款标志
	zhbhgxbz varchar(1) NOT NULL, -- 账户保护关系标志
	zhiqbhsx varchar(32) NOT NULL, -- 支取保护顺序
	gltouzbz varchar(1) NOT NULL, -- 关联透支标志
	xtaizybz varchar(1) NOT NULL, -- 形态转移标志
	budhjzch varchar(20) NULL, -- BUDHJZCH
	dghushux varchar(1) NULL, -- 对公活期户属性
	jinkzhbz varchar(1) NOT NULL, -- 监控账户标志
	yuxutzbz varchar(1) NOT NULL, -- 允许透支标志
	waihjgbz varchar(1) NOT NULL, -- 外汇监管标志ABOQ
	waihhcbz varchar(1) NOT NULL, -- 外汇核查标志
	jieszhbz varchar(1) NOT NULL, -- 结算账户标志
	qyuelxbz varchar(1) NOT NULL, -- 签约理财标志
	yxxjzqbz varchar(1) NOT NULL, -- 允许现金支取标志
	yxzzzqbz varchar(1) NOT NULL, -- 允许转账支取标志
	yxxjcrbz varchar(1) NOT NULL, -- 允许现金存入标志
	yxzzcrbz varchar(1) NOT NULL, -- 允许转账存入标志
	xiedckbz varchar(1) NOT NULL, -- 协定存款标志
	shfojdjx varchar(1) NOT NULL, -- 是否简单计息
	sfdylxjh varchar(1) NOT NULL, -- 是否定义利息计划
	lxzffans varchar(1) NOT NULL, -- 利息支付方式
	shcifxri varchar(8) NULL, -- 上次付息日
	xiacfxri varchar(8) NULL, -- 下次付息日
	fuxipinl varchar(8) NULL, -- 付息频率
	shcijxri varchar(8) NULL, -- 上次计息日
	xiacjxri varchar(8) NULL, -- 下次计息日
	jixipnlv varchar(8) NULL, -- 计息频率
	tzlixibz varchar(1) NULL, -- 利率变化调整利息标志
	lilvbhao varchar(20) NULL, -- 利率编号
	zhixlilv numeric(12, 7) NULL, -- 执行利率
	lilvsffd varchar(1) NOT NULL, -- 利率是否浮动
	leijlixi numeric(20, 7) NULL, -- 累计利息
	jishuuuu numeric(21, 2) NULL, -- 积数
	yjyjlixi numeric(20, 7) NULL, -- 应加/减利息
	yjyjjish numeric(21, 2) NULL, -- 应加/减积数
	shfoyouz varchar(1) NOT NULL, -- 是否有折标志
	shishbbz varchar(1) NOT NULL, -- 实时划拨标志
	yueegjbz varchar(1) NOT NULL, -- 余额归集标志
	zhjedjbz varchar(1) NOT NULL, -- 账户金额冻结标志
	zhfbdjbz varchar(1) NOT NULL, -- 账户封闭冻结标志
	zhzsbfbz varchar(1) NOT NULL, -- 账户只收不付标志
	zhzfbsbz varchar(1) NOT NULL, -- 账户只付不收标志
	jiaoyanm varchar(200) NULL, -- 校验码
	beiyzd01 varchar(50) NULL, -- 备用字段01
	beiyzd02 varchar(50) NULL, -- 备用字段02
	beiyzd03 varchar(50) NULL, -- 备用字段03
	beiyye01 numeric(21, 2) NULL, -- 备用余额01
	beiyrq01 varchar(8) NULL, -- 备用日期1
	kaihuqud varchar(7) NULL, -- 开户渠道
	jitiywbm varchar(32) NULL, -- 计提业务编码
	sffydszh varchar(1) NULL, -- 是否反应到实账户
	zhhuztzd varchar(50) NULL, -- 账户状态字段
	plcffzzh varchar(16) NOT NULL, -- 批量拆分组号
	fsfyuerq varchar(8) NULL, -- 非收费余额更新日期
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	khzjlyzh varchar(40) NULL, -- KHZJLYZH
	bjlxzrzh varchar(35) NULL, -- 本金/利息转入账号
	bxzrzhao varchar(40) NULL, -- 本金/利息转入系统账号
	drjfxjje numeric(21, 2) NULL, -- 当日借方现金金额
	drjfzzje numeric(21, 2) NULL, -- 当日借方转账金额
	drdfxjje numeric(21, 2) NULL, -- 当日贷方现金金额
	drdfzzje numeric(21, 2) NULL, -- 当日贷方转账金额
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuzwmc IS '账户名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kehuhaoo IS '客户号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.guobdaim IS '国别代码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.chaohubz IS '账户钞汇标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunqiiii IS '存期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.doqiriqi IS '到期日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.qixifans IS '起息方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.csqixirq IS '初始起息日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.csdoqirq IS '初始到期日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yewudhao IS '业务代号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.pcljigoh IS '批处理机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhujigoh IS '账户所属机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihjigo IS '开户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihriqi IS '开户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihguiy IS '账户开户柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiohjigo IS '账户销户机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiohriqi IS '账户销户日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiohguiy IS '账户销户柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lancreny IS '揽存人员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lancrymc IS '账户经理名称';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.youxriqi IS '账户有效期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weiyxuho IS '当前未用序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuyuee IS '当前账户余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shrizhye IS '上日账户余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yegxriqi IS '余额最近更新日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.sccrriqi IS '首次存入日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.scywriqi IS '上次业务日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.scsfriqi IS '上次代收付日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.fzcpleix IS '负债产品类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.suoshudx IS '产品所属对象';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhufldm1 IS '账户分类代码1';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhufldm2 IS '账户分类代码2';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhufldm3 IS '账户分类代码3';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.huansbiz IS '换算币种';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zuidlcye IS '最大留存余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zuixlcye IS '最小留存余额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunrkzhi IS '存入控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunrkzff IS '存入控制方法';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunrclsx IS '存入处理顺序';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhiqkzfs IS '支取控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhiqkzff IS '支取控制方法';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zdzqkzfs IS '自定义支取控制方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcunfsh IS '转存方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyjine IS '备用金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihjine IS '开户金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.cunkzlei IS '存款种类';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuztai IS '账户状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yezztbbz IS '余额与总账同步标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcphaoo IS '组合产品号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcpxuho IS '组合产品序号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhcpmuzh IS '组合产品母账户号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhzhleix IS '组合账户类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuxzbz IS '账户限制标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xzhileix IS '限制类型';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xunhdkbz IS '循环贷款标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhbhgxbz IS '账户保护关系标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhiqbhsx IS '支取保护顺序';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.gltouzbz IS '关联透支标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xtaizybz IS '形态转移标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.budhjzch IS 'BUDHJZCH';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.dghushux IS '对公活期户属性';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jinkzhbz IS '监控账户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yuxutzbz IS '允许透支标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.waihjgbz IS '外汇监管标志ABOQ';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.waihhcbz IS '外汇核查标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jieszhbz IS '结算账户标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.qyuelxbz IS '签约理财标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxxjzqbz IS '允许现金支取标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxzzzqbz IS '允许转账支取标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxxjcrbz IS '允许现金存入标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yxzzcrbz IS '允许转账存入标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiedckbz IS '协定存款标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shfojdjx IS '是否简单计息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.sfdylxjh IS '是否定义利息计划';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lxzffans IS '利息支付方式';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shcifxri IS '上次付息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiacfxri IS '下次付息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.fuxipinl IS '付息频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shcijxri IS '上次计息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.xiacjxri IS '下次计息日';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jixipnlv IS '计息频率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.tzlixibz IS '利率变化调整利息标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lilvbhao IS '利率编号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhixlilv IS '执行利率';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.lilvsffd IS '利率是否浮动';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.leijlixi IS '累计利息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jishuuuu IS '积数';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yjyjlixi IS '应加/减利息';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yjyjjish IS '应加/减积数';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shfoyouz IS '是否有折标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shishbbz IS '实时划拨标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.yueegjbz IS '余额归集标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhjedjbz IS '账户金额冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhfbdjbz IS '账户封闭冻结标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhzsbfbz IS '账户只收不付标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhzfbsbz IS '账户只付不收标志';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jiaoyanm IS '校验码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyzd01 IS '备用字段01';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyzd02 IS '备用字段02';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyzd03 IS '备用字段03';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyye01 IS '备用余额01';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.beiyrq01 IS '备用日期1';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.kaihuqud IS '开户渠道';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jitiywbm IS '计提业务编码';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.sffydszh IS '是否反应到实账户';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.zhhuztzd IS '账户状态字段';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.plcffzzh IS '批量拆分组号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.fsfyuerq IS '非收费余额更新日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.khzjlyzh IS 'KHZJLYZH';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.bjlxzrzh IS '本金/利息转入账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.bxzrzhao IS '本金/利息转入系统账号';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drjfxjje IS '当日借方现金金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drjfzzje IS '当日借方转账金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drdfxjje IS '当日贷方现金金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.drdfzzje IS '当日贷方转账金额';
COMMENT ON COLUMN crmdm.cbs_kdpa_zhxinx.ryzd IS '冗余字段';


-- crmdm.cbs_kdpb_kouhua 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpb_kouhua;

CREATE TABLE crmdm.cbs_kdpb_kouhua (
	farendma varchar(4) NOT NULL, -- 法人代码
	kouhabho varchar(32) NOT NULL, -- 扣划编号
	kouhuafs varchar(1) NOT NULL, -- 扣划方式
	dongjbho varchar(32) NULL, -- 冻结编号
	kehuzhao varchar(35) NOT NULL, -- 客户账号
	zhanghao varchar(40) NULL, -- 负债账号
	kouhuaje numeric(17, 2) NOT NULL, -- 扣划金额
	dxzhxhao varchar(40) NULL, -- 待销账序号
	skrkhuzh varchar(35) NULL, -- 收款人客户账号
	skzhxuho varchar(8) NULL, -- 收款人子账户序号
	zfbmleix varchar(1) NULL, -- 执法部门
	khbmenmc varchar(100) NULL, -- 扣划部门名称
	khwshaoo varchar(200) NULL, -- 扣划文书号
	khryzle1 varchar(2) NULL, -- 扣划人员1证件种类
	khryzjh1 varchar(80) NULL, -- 扣划人员1证件号码
	khryzle3 varchar(2) NULL, -- 扣划人员1证件种类2
	khryzjh3 varchar(80) NULL, -- 扣划人员1证件号码2
	khryxmm1 varchar(500) NULL, -- 扣划人员1姓名
	khryzle2 varchar(2) NULL, -- 扣划人员2证件种类
	khryzjh2 varchar(80) NULL, -- 扣划人员2证件号码
	khryzle4 varchar(2) NULL, -- 扣划人员2证件种类2
	khryzjh4 varchar(80) NULL, -- 扣划人员2证件号码2
	khryxmm2 varchar(500) NULL, -- 扣划人员2姓名
	zhaiyoms varchar(80) NULL, -- 摘要描述
	jiaoyijg varchar(10) NOT NULL, -- 交易机构
	jinbguiy varchar(8) NOT NULL, -- 经办人
	fuheguiy varchar(8) NULL, -- 复核人
	shnpguiy varchar(8) NULL, -- 审批人
	wbjoyima varchar(20) NOT NULL, -- 外部交易码
	nbjoyima varchar(20) NOT NULL, -- 内部交易码
	jiaoyirq varchar(8) NULL, -- 交易日期
	jiaoyisj numeric(19) NULL, -- 交易时间
	guiylius varchar(32) NULL, -- 柜员流水号
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	khrywmc1 varchar(500) NULL, -- 扣划人员1英文名
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kouhabho IS '扣划编号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kouhuafs IS '扣划方式';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.dongjbho IS '冻结编号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kehuzhao IS '客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.zhanghao IS '负债账号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.kouhuaje IS '扣划金额';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.dxzhxhao IS '待销账序号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.skrkhuzh IS '收款人客户账号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.skzhxuho IS '收款人子账户序号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.zfbmleix IS '执法部门';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khbmenmc IS '扣划部门名称';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khwshaoo IS '扣划文书号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle1 IS '扣划人员1证件种类';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh1 IS '扣划人员1证件号码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle3 IS '扣划人员1证件种类2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh3 IS '扣划人员1证件号码2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryxmm1 IS '扣划人员1姓名';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle2 IS '扣划人员2证件种类';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh2 IS '扣划人员2证件号码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzle4 IS '扣划人员2证件种类2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryzjh4 IS '扣划人员2证件号码2';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khryxmm2 IS '扣划人员2姓名';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.zhaiyoms IS '摘要描述';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiaoyijg IS '交易机构';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jinbguiy IS '经办人';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.fuheguiy IS '复核人';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.shnpguiy IS '审批人';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.wbjoyima IS '外部交易码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.nbjoyima IS '内部交易码';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiaoyirq IS '交易日期';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiaoyisj IS '交易时间';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.guiylius IS '柜员流水号';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.khrywmc1 IS '扣划人员1英文名';
COMMENT ON COLUMN crmdm.cbs_kdpb_kouhua.ryzd IS '冗余字段';


-- crmdm.cbs_kdpf_chpshx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpf_chpshx;

CREATE TABLE crmdm.cbs_kdpf_chpshx (
	farendma varchar(4) NOT NULL, -- 法人代码
	chapbhao varchar(10) NOT NULL, -- 产品编号
	chanpshm varchar(200) NULL, -- 产品说明
	yinxoshm varchar(200) NULL, -- 产品营销说明
	shenxriq varchar(8) NULL, -- 生效日期
	shixriqi varchar(8) NULL, -- 负债产品失效日
	dinhuobz varchar(1) NULL, -- 产品定活标志 :0-活期产品,1-定期产品
	suoshudx varchar(1) NULL, -- 产品所属对象 :1-对私存款产品,2-对公存款产品,3-同业存款产品
	chapleix varchar(1) NULL, -- 产品类型 :0-传统产品,1-扩展产品
	chapbizh varchar(3) NULL, -- 产品默认币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币
	xnjntdbz varchar(1) NULL, -- 现金通兑标志 :1-是,0-否
	zhnztdbz varchar(1) NULL, -- 转账通兑标志 :1-是,0-否
	tduifwei varchar(1) NULL, -- 通兑范围 :0-不通兑,1-分行通兑,2-全行通兑
	tcunfwei varchar(1) NULL, -- 通存范围 :0-开户机构通存,1-分行通存,2-全行通存
	qudknzbz varchar(1) NULL, -- 渠道控制标志 :0-不控制,1-限制控制,2-排除控制
	bizhkzbz varchar(1) NULL, -- 币种控制标志 :0-不控制,1-限制控制,2-排除控制
	jigknzbz varchar(1) NULL, -- 机构控制标志 :0-不控制,1-限制控制,2-排除控制
	kehknzbz varchar(1) NULL, -- 客户控制标志 :0-不控制,1-限制控制,2-排除控制
	zhhuflbz varchar(1) NULL, -- 账户分类标志 :1-是,0-否
	pngzkzbz varchar(1) NULL, -- 凭证控制标志 :0-不控制,1-限制控制,2-排除控制
	cunqkzfs varchar(1) NULL, -- 存期控制方式 :0-不定存期,1-产品控制存期,2-自定义存期
	morzhhlx varchar(2) NULL, -- 默认账户类型
	chapzhut varchar(1) NULL, -- 产品状态 :0-正常,1-待生效,2-注销
	shfodqdy varchar(1) NULL, -- 是否到期定义 :1-是,0-否
	shfotzdy varchar(1) NULL, -- 是否透支定义 :1-是,0-否
	shfosfdy varchar(1) NULL, -- 是否收费定义 :1-是,0-否
	shfojdjx varchar(1) NULL, -- 是否简单计息 :1-是,0-否
	shfojshu varchar(1) NULL, -- 是否结算户 :1-是,0-否
	zidojhbz varchar(1) NULL, -- 自动结汇标志 :0-不自动,1-自动
	zidoshbz varchar(1) NULL, -- 自动售汇标志 :0-不自动,1-自动
	yxjiehbz varchar(1) NULL, -- 允许结汇标志 :0-不允许,1-允许
	yezztbbz varchar(1) NULL, -- 余额与总账同步标志 :1-是,0-否
	shfoxtzy varchar(1) NULL, -- 是否形态转移定义 :1-是,0-否
	zongeduu numeric(17, 2) NULL, -- 总额度
	jimbiaoz varchar(1) NULL, -- 记名标志 :0-不记名,1-记名
	chenbzhx varchar(4) NULL, -- 成本中心
	cunkzlei varchar(2) NULL, -- 存款种类 :00-普通活期,01-整存整取,02-定活两便,03-存本取息,04-零存整取,05-通知存款,06-教育储蓄,07-整存零取,08-协议存款,09-协定存款,10-通知理财,11-对公活期,12-对公整存整取,13-对公通知存款,14-对公活期保证金,15-对公定期保证金,16-对私活期保证金,17-对私定期保证金,18-同业活期存款,19-同业定期存款,20-同业通知存款,21-财政存款,22-对公理财,23-同业活期保证金,24-同业定期保证金,25-对私理财,26-大额存单,27-账户透支
	huansbiz varchar(3) NULL, -- 换算币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态 :0-正常,1-删除
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapbhao IS '产品编号';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chanpshm IS '产品说明';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.yinxoshm IS '产品营销说明';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shenxriq IS '生效日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shixriqi IS '负债产品失效日';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.dinhuobz IS '产品定活标志 :0-活期产品,1-定期产品';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.suoshudx IS '产品所属对象 :1-对私存款产品,2-对公存款产品,3-同业存款产品';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapleix IS '产品类型 :0-传统产品,1-扩展产品';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapbizh IS '产品默认币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.xnjntdbz IS '现金通兑标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zhnztdbz IS '转账通兑标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.tduifwei IS '通兑范围 :0-不通兑,1-分行通兑,2-全行通兑';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.tcunfwei IS '通存范围 :0-开户机构通存,1-分行通存,2-全行通存';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.qudknzbz IS '渠道控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.bizhkzbz IS '币种控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.jigknzbz IS '机构控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.kehknzbz IS '客户控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zhhuflbz IS '账户分类标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.pngzkzbz IS '凭证控制标志 :0-不控制,1-限制控制,2-排除控制';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.cunqkzfs IS '存期控制方式 :0-不定存期,1-产品控制存期,2-自定义存期';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.morzhhlx IS '默认账户类型';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chapzhut IS '产品状态 :0-正常,1-待生效,2-注销';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfodqdy IS '是否到期定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfotzdy IS '是否透支定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfosfdy IS '是否收费定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfojdjx IS '是否简单计息 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfojshu IS '是否结算户 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zidojhbz IS '自动结汇标志 :0-不自动,1-自动';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zidoshbz IS '自动售汇标志 :0-不自动,1-自动';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.yxjiehbz IS '允许结汇标志 :0-不允许,1-允许';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.yezztbbz IS '余额与总账同步标志 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shfoxtzy IS '是否形态转移定义 :1-是,0-否';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.zongeduu IS '总额度';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.jimbiaoz IS '记名标志 :0-不记名,1-记名';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.chenbzhx IS '成本中心';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.cunkzlei IS '存款种类 :00-普通活期,01-整存整取,02-定活两便,03-存本取息,04-零存整取,05-通知存款,06-教育储蓄,07-整存零取,08-协议存款,09-协定存款,10-通知理财,11-对公活期,12-对公整存整取,13-对公通知存款,14-对公活期保证金,15-对公定期保证金,16-对私活期保证金,17-对私定期保证金,18-同业活期存款,19-同业定期存款,20-同业通知存款,21-财政存款,22-对公理财,23-同业活期保证金,24-同业定期保证金,25-对私理财,26-大额存单,27-账户透支';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.huansbiz IS '换算币种 :01-人民币,12-英镑,13-港币,14-美元,15-瑞士法郎,27-日元,28-加拿大元,29-澳大利亚元,18-新加坡元,38-欧元,43-韩元,81-澳门元,82-新台币,83-津巴布韦币,99-所有币种,98-所有外币';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.jiluztai IS '记录状态 :0-正常,1-删除';
COMMENT ON COLUMN crmdm.cbs_kdpf_chpshx.ryzd IS '冗余字段';


-- crmdm.cbs_kdpl_zhminx 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kdpl_zhminx;

CREATE TABLE crmdm.cbs_kdpl_zhminx (
	farendma varchar(4) NOT NULL, -- FARENDMA
	zhanghao varchar(40) NOT NULL, -- ZHANGHAO
	zhhuzwmc varchar(500) NOT NULL, -- ZHHUZWMC
	kehuzhlx varchar(1) NULL, -- KEHUZHLX
	yezdminc varchar(32) NOT NULL, -- YEZDMINC
	mxixuhao numeric(19) NOT NULL, -- MXIXUHAO
	jiedaibz varchar(1) NOT NULL, -- JIEDAIBZ
	jiaoybiz varchar(3) NOT NULL, -- JIAOYBIZ
	chaohubz varchar(1) NOT NULL, -- CHAOHUBZ
	jiaoyije numeric(17, 2) NOT NULL, -- JIAOYIJE
	zhanghye numeric(21, 2) NOT NULL, -- ZHANGHYE
	kehuzhao varchar(35) NOT NULL, -- KEHUZHAO
	zhhaoxuh varchar(8) NULL, -- ZHHAOXUH
	shifoudy varchar(1) NULL, -- SHIFOUDY
	zhondhao varchar(200) NULL, -- ZHONDHAO
	butiiibz varchar(1) NULL, -- BUTIIIBZ
	chapbhao varchar(10) NOT NULL, -- CHAPBHAO
	suoshudx varchar(1) NOT NULL, -- SUOSHUDX
	zhqixzhi varchar(6) NULL, -- ZHQIXZHI
	pngzzlei varchar(3) NULL, -- PNGZZLEI
	pngzphao varchar(8) NULL, -- PNGZPHAO
	pngzxhao varchar(18) NULL, -- PNGZXHAO
	zhaiyodm varchar(10) NULL, -- ZHAIYODM
	zhaiyoms varchar(80) NULL, -- ZHAIYOMS
	qdaoleix varchar(7) NULL, -- QDAOLEIX
	wbjoyima varchar(10) NOT NULL, -- WBJOYIMA
	nbjoyima varchar(10) NOT NULL, -- NBJOYIMA
	xianzzbz varchar(1) NOT NULL, -- XIANZZBZ
	duifkhzh varchar(35) NULL, -- DUIFKHZH
	dfzhhxuh varchar(8) NULL, -- DFZHHXUH
	duifxtzh varchar(40) NULL, -- DUIFXTZH
	duifminc varchar(500) NULL, -- DUIFMINC
	duifkhlx varchar(2) NULL, -- DUIFKHLX
	duifjgmc varchar(60) NULL, -- DUIFJGMC
	duifjglx varchar(2) NULL, -- DUIFJGLX
	duifjgdm varchar(20) NULL, -- DUIFJGDM
	dailxinm varchar(500) NULL, -- DAILXINM
	dailzjlx varchar(2) NULL, -- DAILZJLX
	dailzjho varchar(80) NULL, -- DAILZJHO
	dailguoj varchar(10) NULL, -- DAILGUOJ
	zhcphaoo varchar(10) NULL, -- ZHCPHAOO
	zhcpzhao varchar(40) NULL, -- ZHCPZHAO
	yhywbhao varchar(30) NULL, -- YHYWBHAO
	xgywbhao varchar(40) NULL, -- XGYWBHAO
	guiylius varchar(32) NOT NULL, -- GUIYLIUS
	jyyyjigo varchar(10) NOT NULL, -- JYYYJIGO
	kaihjigo varchar(10) NOT NULL, -- KAIHJIGO
	caozguiy varchar(8) NOT NULL, -- CAOZGUIY
	fuheguiy varchar(8) NULL, -- FUHEGUIY
	shoqguiy varchar(8) NULL, -- SHOQGUIY
	jiaoyirq varchar(8) NOT NULL, -- JIAOYIRQ
	jiaoyisj numeric(19) NOT NULL, -- JIAOYISJ
	zhujriqi varchar(8) NULL, -- ZHUJRIQI
	chongzbz varchar(1) NOT NULL, -- CHONGZBZ
	bchongbz varchar(1) NOT NULL, -- BCHONGBZ
	cuozriqi varchar(8) NULL, -- CUOZRIQI
	cuozlius varchar(32) NULL, -- CUOZLIUS
	beizhuuu varchar(200) NULL, -- BEIZHUUU
	jioycffs varchar(1) NULL, -- JIOYCFFS
	dayiyesh numeric(19) NULL, -- DAYIYESH
	weihguiy varchar(8) NOT NULL, -- WEIHGUIY
	weihjigo varchar(10) NOT NULL, -- WEIHJIGO
	weihriqi varchar(8) NOT NULL, -- WEIHRIQI
	weihshij varchar(9) NULL, -- WEIHSHIJ
	shijchuo numeric(19) NOT NULL, -- SHIJCHUO
	jiluztai varchar(1) NOT NULL, -- JILUZTAI
	xnjnxmdm varchar(4) NULL, -- XNJNXMDM
	dailreyw varchar(500) NULL, -- DAILREYW
	dlirdhua varchar(40) NULL, -- DLIRDHUA
	qianfarq varchar(8) NULL, -- QIANFARQ
	doqiriqi varchar(8) NULL, -- DOQIRIQI
	ipdizhii varchar(32) NULL, -- IP地址
	macdizhi varchar(32) NULL, -- MAC地址
	zijnlaiy varchar(200) NULL, -- 资金来源
	qxyongtu varchar(200) NULL, -- 取现用途
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.farendma IS 'FARENDMA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhanghao IS 'ZHANGHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhhuzwmc IS 'ZHHUZWMC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.kehuzhlx IS 'KEHUZHLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.yezdminc IS 'YEZDMINC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.mxixuhao IS 'MXIXUHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiedaibz IS 'JIEDAIBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoybiz IS 'JIAOYBIZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.chaohubz IS 'CHAOHUBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoyije IS 'JIAOYIJE';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhanghye IS 'ZHANGHYE';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.kehuzhao IS 'KEHUZHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhhaoxuh IS 'ZHHAOXUH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.shifoudy IS 'SHIFOUDY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhondhao IS 'ZHONDHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.butiiibz IS 'BUTIIIBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.chapbhao IS 'CHAPBHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.suoshudx IS 'SUOSHUDX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhqixzhi IS 'ZHQIXZHI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.pngzzlei IS 'PNGZZLEI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.pngzphao IS 'PNGZPHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.pngzxhao IS 'PNGZXHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhaiyodm IS 'ZHAIYODM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhaiyoms IS 'ZHAIYOMS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.qdaoleix IS 'QDAOLEIX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.wbjoyima IS 'WBJOYIMA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.nbjoyima IS 'NBJOYIMA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.xianzzbz IS 'XIANZZBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifkhzh IS 'DUIFKHZH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dfzhhxuh IS 'DFZHHXUH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifxtzh IS 'DUIFXTZH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifminc IS 'DUIFMINC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifkhlx IS 'DUIFKHLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifjgmc IS 'DUIFJGMC';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifjglx IS 'DUIFJGLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.duifjgdm IS 'DUIFJGDM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailxinm IS 'DAILXINM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailzjlx IS 'DAILZJLX';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailzjho IS 'DAILZJHO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailguoj IS 'DAILGUOJ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhcphaoo IS 'ZHCPHAOO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhcpzhao IS 'ZHCPZHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.yhywbhao IS 'YHYWBHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.xgywbhao IS 'XGYWBHAO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.guiylius IS 'GUIYLIUS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jyyyjigo IS 'JYYYJIGO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.kaihjigo IS 'KAIHJIGO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.caozguiy IS 'CAOZGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.fuheguiy IS 'FUHEGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.shoqguiy IS 'SHOQGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoyirq IS 'JIAOYIRQ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiaoyisj IS 'JIAOYISJ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zhujriqi IS 'ZHUJRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.chongzbz IS 'CHONGZBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.bchongbz IS 'BCHONGBZ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.cuozriqi IS 'CUOZRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.cuozlius IS 'CUOZLIUS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.beizhuuu IS 'BEIZHUUU';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jioycffs IS 'JIOYCFFS';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dayiyesh IS 'DAYIYESH';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihguiy IS 'WEIHGUIY';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihjigo IS 'WEIHJIGO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihriqi IS 'WEIHRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.weihshij IS 'WEIHSHIJ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.shijchuo IS 'SHIJCHUO';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.jiluztai IS 'JILUZTAI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.xnjnxmdm IS 'XNJNXMDM';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dailreyw IS 'DAILREYW';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.dlirdhua IS 'DLIRDHUA';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.qianfarq IS 'QIANFARQ';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.doqiriqi IS 'DOQIRIQI';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.ipdizhii IS 'IP地址';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.macdizhi IS 'MAC地址';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.zijnlaiy IS '资金来源';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.qxyongtu IS '取现用途';
COMMENT ON COLUMN crmdm.cbs_kdpl_zhminx.ryzd IS '冗余字段';


-- crmdm.cbs_kfxp_xthlcs 定义

-- Drop table

-- DROP TABLE crmdm.cbs_kfxp_xthlcs;

CREATE TABLE crmdm.cbs_kfxp_xthlcs (
	farendma varchar(4) NOT NULL, -- 法人代码
	shenxriq varchar(8) NOT NULL, -- 生效日期
	shenxshj numeric(19) NOT NULL, -- 生效时间
	huobdaih varchar(3) NOT NULL, -- 货币代号
	pjdanwei numeric(12, 7) NOT NULL, -- 牌价单位
	huobfhao varchar(4) NOT NULL, -- 货币符号
	mairujia numeric(12, 7) NOT NULL, -- 买入价
	maichjia numeric(12, 7) NOT NULL, -- 卖出价
	zhngjjia numeric(12, 7) NOT NULL, -- 中间价
	caomrjia numeric(12, 7) NOT NULL, -- 钞买价
	caomcjia numeric(12, 7) NOT NULL, -- 钞卖价
	ppmrujia numeric(12, 7) NOT NULL, -- 平盘买入价
	ppmchjia numeric(12, 7) NOT NULL, -- 平盘卖出价
	beizhuxx varchar(200) NOT NULL, -- 备注信息
	weihguiy varchar(8) NOT NULL, -- 维护柜员
	weihjigo varchar(10) NOT NULL, -- 维护机构
	weihriqi varchar(8) NOT NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	shijchuo numeric(19) NOT NULL, -- 时间戳
	jiluztai varchar(1) NOT NULL, -- 记录状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.shenxriq IS '生效日期';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.shenxshj IS '生效时间';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.pjdanwei IS '牌价单位';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.huobfhao IS '货币符号';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.mairujia IS '买入价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.maichjia IS '卖出价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.zhngjjia IS '中间价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.caomrjia IS '钞买价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.caomcjia IS '钞卖价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.ppmrujia IS '平盘买入价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.ppmchjia IS '平盘卖出价';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.beizhuxx IS '备注信息';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihguiy IS '维护柜员';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihjigo IS '维护机构';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.shijchuo IS '时间戳';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.jiluztai IS '记录状态';
COMMENT ON COLUMN crmdm.cbs_kfxp_xthlcs.ryzd IS '冗余字段';


-- crmdm.cds_t1_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_t1_cust_info;

CREATE TABLE crmdm.cds_t1_cust_info (
	cust_no bpchar(8) NOT NULL, -- 客户号
	fund_id_type varchar(2) NULL, -- 基金证件类型
	main_trans_acct_no bpchar(17) NULL, -- 主交易账号
	id_type varchar(2) NOT NULL, -- 证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 A：营业执照 B：同业机构代码 C：法人登记证 D：证明文件 E：经营许可证 F：组织机构代码证 G：其他 H：基金会 O：开户证明 ）
	id_code varchar(32) NOT NULL, -- 证件号码
	cust_name varchar(128) NOT NULL, -- 客户名称
	cust_type bpchar(1) NOT NULL, -- 客户类型（ 0：企业 1：同业机构（金融业企业） 2：行政机构 3：个人 ）
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型（ 0：不限 1：珠联璧合卡 2：握美卡 ）
	instrepr_name varchar(128) NULL, -- 法人名称
	instrepr_id_type varchar(2) NULL, -- 法人证件类型（身份证/护照/军官证/士兵证/回乡证/户口本/外国护照/其它/无/技术监督局代码/营业执照/行政机关/社会团体/军队/武警/下属机构（具有主管单位批文号）/基金会）
	instrepr_id_code varchar(32) NULL, -- 法人证件号码
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(2) NULL, -- 经办(代理)人证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 ）
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	birthday bpchar(8) NULL, -- 出生日期
	sex bpchar(1) NULL, -- 性别 0-男 1-女 2-中性
	education bpchar(1) NULL, -- 学历 0-小学 1-初中 2-中技 3-中专 4-大专 5-本科 6-硕士 7-博士
	mobile varchar(20) NULL, -- 手机号码
	home_tel varchar(20) NULL, -- 家庭电话
	office_tel varchar(20) NULL, -- 办公电话
	fax varchar(20) NULL, -- 传真号码
	postcode bpchar(6) NULL, -- 邮政编码
	addr varchar(128) NULL, -- 通信地址
	email varchar(64) NULL, -- 邮箱地址
	cust_manager varchar(20) NULL, -- 客户经理代码
	fnc_manager varchar(20) NULL, -- 理财经理代码
	protocol_serno varchar(32) NULL, -- 协议单号（纸质上显示的编号）
	protocol_status bpchar(1) NOT NULL, -- 协议状态 0-正常 1-注销
	bank_code varchar(20) NOT NULL, -- 总行代码
	branch_code varchar(20) NOT NULL, -- 分行代码
	sub_branch_code varchar(20) NOT NULL, -- 网点代码
	inputuser varchar(20) NOT NULL, -- 录入柜员
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	inv_date bpchar(8) NULL, -- 注销日期
	inv_time bpchar(6) NULL, -- 注销时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	ifemployee bpchar(1) NULL, -- 是否是内部员工（1：是 0：否）
	host_cust_no varchar(32) NULL, -- 核心客户号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_t1_cust_info PRIMARY KEY (cust_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.fund_id_type IS '基金证件类型';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.main_trans_acct_no IS '主交易账号';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.id_type IS '证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 A：营业执照 B：同业机构代码 C：法人登记证 D：证明文件 E：经营许可证 F：组织机构代码证 G：其他 H：基金会 O：开户证明 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_type IS '客户类型（ 0：企业 1：同业机构（金融业企业） 2：行政机构 3：个人 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_card_type IS '客户卡类型（ 0：不限 1：珠联璧合卡 2：握美卡 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.instrepr_name IS '法人名称';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.instrepr_id_type IS '法人证件类型（身份证/护照/军官证/士兵证/回乡证/户口本/外国护照/其它/无/技术监督局代码/营业执照/行政机关/社会团体/军队/武警/下属机构（具有主管单位批文号）/基金会）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.instrepr_id_code IS '法人证件号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.agent_id_type IS '经办(代理)人证件类型（ 1：身份证 2：临时身份证 3：户口簿 4：护照 5：军人证 6：武警证 7：港澳来往通行证 8：台湾来往通行证 9：其他证件 ）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.birthday IS '出生日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.sex IS '性别 0-男 1-女 2-中性';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.education IS '学历 0-小学 1-初中 2-中技 3-中专 4-大专 5-本科 6-硕士 7-博士';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.mobile IS '手机号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.home_tel IS '家庭电话';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.office_tel IS '办公电话';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.fax IS '传真号码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.postcode IS '邮政编码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.addr IS '通信地址';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.email IS '邮箱地址';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.fnc_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.protocol_serno IS '协议单号（纸质上显示的编号）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.protocol_status IS '协议状态 0-正常 1-注销';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.bank_code IS '总行代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.branch_code IS '分行代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.sub_branch_code IS '网点代码';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.inv_date IS '注销日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.inv_time IS '注销时间';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.remark IS '备注';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.ifemployee IS '是否是内部员工（1：是 0：否）';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.host_cust_no IS '核心客户号';
COMMENT ON COLUMN crmdm.cds_t1_cust_info.ryzd IS '冗余字段';


-- crmdm.cds_tb_cash_acct_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_cash_acct_info;

CREATE TABLE crmdm.cds_tb_cash_acct_info (
	cash_acct_no varchar(32) NOT NULL, -- 虚拟账户编号
	fnc_trans_acct_no bpchar(17) NOT NULL, -- 理财交易账号
	cust_no bpchar(8) NOT NULL, -- 客户号
	cust_level varchar(8) NULL, -- 客户级别
	acct_type bpchar(2) NULL, -- 账户类型 （00：活期留存 01：冻结金额 02：活期增值 03：定期增值 04:核心计息账户）
	status bpchar(1) NULL, -- 账户状态 （ 0:正常 1:关户 2：等待结息）
	prod_code varchar(32) NULL, -- 产品代码
	prod_class bpchar(1) NULL, -- 产品大类 （0：活期 1：定期）
	prod_subclass bpchar(1) NULL, -- 产品子类( 0：活期日终型 2：活期日均型 3：协定活期型  4：定期型 5：大额存单 6：协定定期型）
	carry_interest_date bpchar(8) NOT NULL, -- 起息日期
	expire_date bpchar(8) NULL, -- 到期日期
	buy_amt numeric(16, 2) NULL, -- 购买金额
	buy_type bpchar(1) NULL, -- 定期购买方式0-活期账号购买1-定期账号购买
	balance numeric(16, 2) NULL, -- 余额
	cumulative numeric(16, 2) NULL, -- 金额积数 （定期不累计；活期累计）
	balance_pay_interest numeric(16, 2) NULL, -- 当前余额已付利息
	interest_no varchar(32) NULL, -- 计息方案代码
	reach_avg_balance numeric(16, 2) NULL, -- 达标日均余额
	total_interest numeric(16, 2) NULL, -- 总利息
	interest numeric(16, 2) NULL, -- 利息 （推到重算覆盖）
	pay_interest numeric(16, 2) NULL, -- 已付利息（累计）
	sign_interest numeric(16, 2) NULL, -- 签约未付利息
	draw_interest numeric(16, 2) NULL, -- 支取未付利息
	draw_interest_no varchar(32) NULL, -- 支取计息方案代码
	calc_amt numeric(16, 2) NULL, -- 已计提金额 （累计）
	draw_seri_no numeric(3) NOT NULL, -- 支取顺序号 （支取时，判断支取顺序）
	drawed_times numeric(2) NULL, -- 已支取次数
	trans_orgno varchar(20) NOT NULL, -- 交易机构
	trans_branch varchar(20) NOT NULL, -- 交易机构所属分行
	trans_head_office varchar(20) NOT NULL, -- 交易机构所属总行
	card_orgno varchar(20) NOT NULL, -- 开户机构
	card_branch varchar(20) NOT NULL, -- 开户机构所属分行
	card_head_office varchar(20) NOT NULL, -- 开户机构所属总行
	term_acct_no varchar(32) NULL, -- 定期、专户账户
	agr_sav_rate numeric(12, 5) NULL, -- 协定利率 (协定产品)
	agr_term varchar(4) NULL, -- 协定存期 (协定产品)
	agr_amt numeric(16, 2) NULL, -- 协定金额
	calc_date bpchar(8) NULL, -- 计提日期
	interest_date bpchar(8) NULL, -- 结息日期
	term_serial_no varchar(32) NULL, -- 定期/专账序号
	ret_interest numeric(16, 2) NULL, -- 返息金额
	trans_channel varchar(2) NULL, -- 交易渠道
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	no_ret_interest numeric(16, 2) NULL, -- 无法补扣金额
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_tb_cash_acct_info PRIMARY KEY (cash_acct_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cash_acct_no IS '虚拟账户编号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.acct_type IS '账户类型 （00：活期留存 01：冻结金额 02：活期增值 03：定期增值 04:核心计息账户）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.status IS '账户状态 （ 0:正常 1:关户 2：等待结息）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.prod_class IS '产品大类 （0：活期 1：定期）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.prod_subclass IS '产品子类( 0：活期日终型 2：活期日均型 3：协定活期型  4：定期型 5：大额存单 6：协定定期型）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.carry_interest_date IS '起息日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.expire_date IS '到期日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.buy_amt IS '购买金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.buy_type IS '定期购买方式0-活期账号购买1-定期账号购买';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.balance IS '余额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.cumulative IS '金额积数 （定期不累计；活期累计）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.balance_pay_interest IS '当前余额已付利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.interest_no IS '计息方案代码';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.reach_avg_balance IS '达标日均余额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.total_interest IS '总利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.interest IS '利息 （推到重算覆盖）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.pay_interest IS '已付利息（累计）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.sign_interest IS '签约未付利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.draw_interest IS '支取未付利息';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.draw_interest_no IS '支取计息方案代码';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.calc_amt IS '已计提金额 （累计）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.draw_seri_no IS '支取顺序号 （支取时，判断支取顺序）';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.drawed_times IS '已支取次数';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_orgno IS '交易机构';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_branch IS '交易机构所属分行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_head_office IS '交易机构所属总行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.card_orgno IS '开户机构';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.card_branch IS '开户机构所属分行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.card_head_office IS '开户机构所属总行';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.term_acct_no IS '定期、专户账户';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.agr_sav_rate IS '协定利率 (协定产品)';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.agr_term IS '协定存期 (协定产品)';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.agr_amt IS '协定金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.calc_date IS '计提日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.interest_date IS '结息日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.term_serial_no IS '定期/专账序号';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.ret_interest IS '返息金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.trans_channel IS '交易渠道';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.no_ret_interest IS '无法补扣金额';
COMMENT ON COLUMN crmdm.cds_tb_cash_acct_info.ryzd IS '冗余字段';


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


-- crmdm.cds_tb_interest_prj_detail 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_interest_prj_detail;

CREATE TABLE crmdm.cds_tb_interest_prj_detail (
	interest_no varchar(32) NOT NULL, -- 方案信息代码
	time_step varchar(3) NULL, -- D1：1天通知存款 D2：7天通知存款 M1：1个月定期存款 M3：3个月定期存款 M6：6个月定期存款 Y1：1年定期存款 Y2：2年定期存款 Y3：3年定期存款 Y5：5年定期存款
	begin_amt numeric(16, 2) NULL, -- 起点金额
	end_amt numeric(16, 2) NULL, -- 截止金额
	host_rate numeric(12, 5) NULL, -- 核心对应档位利率
	trans_channel varchar(8) NULL, -- 交易渠道0-智能存款柜台,1-后台产生,2-银行柜台,3-银行网银, 6-磁盘导入,7-自助终端,8-手机银行,9-微信银行
	begin_cust_level varchar(8) NULL, -- 起始客户级别
	end_cust_level varchar(8) NULL, -- 结束客户级别
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	rate numeric(12, 8) NULL, -- RATE
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.interest_no IS '方案信息代码';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.time_step IS 'D1：1天通知存款 D2：7天通知存款 M1：1个月定期存款 M3：3个月定期存款 M6：6个月定期存款 Y1：1年定期存款 Y2：2年定期存款 Y3：3年定期存款 Y5：5年定期存款';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.begin_amt IS '起点金额';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.end_amt IS '截止金额';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.host_rate IS '核心对应档位利率';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.trans_channel IS '交易渠道0-智能存款柜台,1-后台产生,2-银行柜台,3-银行网银, 6-磁盘导入,7-自助终端,8-手机银行,9-微信银行';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.begin_cust_level IS '起始客户级别';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.end_cust_level IS '结束客户级别';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.rate IS 'RATE';
COMMENT ON COLUMN crmdm.cds_tb_interest_prj_detail.ryzd IS '冗余字段';


-- crmdm.cds_tb_prod_pub_info 定义

-- Drop table

-- DROP TABLE crmdm.cds_tb_prod_pub_info;

CREATE TABLE crmdm.cds_tb_prod_pub_info (
	prod_code varchar(32) NOT NULL, -- 产品代码
	prod_glob_code varchar(32) NULL, -- 全国唯一编码
	prod_name varchar(128) NOT NULL, -- 产品名称
	prod_status bpchar(1) NOT NULL, -- 产品状态（0：待售 1：开始销售 2：停止销售）
	prod_class bpchar(1) NOT NULL, -- 产品大类（0：活期 1：定期）
	prod_subclass bpchar(1) NOT NULL, -- 产品子类( 0：活期日终型 1：活期日均型 2：协定活期型  3：定期型 4：大额存单 5：协定定期型）
	sale_begin_date bpchar(8) NOT NULL, -- 销售日期
	sale_begin_time bpchar(6) NOT NULL, -- 销售时间
	sale_end_date bpchar(8) NULL, -- 停售日期
	sale_end_time bpchar(6) NULL, -- 停售时间
	allow_sale_channel varchar(20) NOT NULL, -- 允许交易渠道 （0：银行柜台 1：银行网银 2：ATM 3：电话银行 4：手机银行）-1为不限制(多选)
	allow_sex_limit varchar(2) NOT NULL, -- 允许交易性别（单选）0:男 1:女 -1:不限
	allow_cust_type bpchar(1) NOT NULL, -- 允许交易客户类型 （0：企业客户 3：个人客户）（单选）
	allow_card_type varchar(20) NULL, -- 允许交易卡类型(多选)-1为不限制
	allow_cust_level varchar(20) NULL, -- 允许交易客户级别(多选)-1为不限制
	allow_white_type varchar(32) NULL, -- 允许交易白名单编号 -1为不限制
	allow_max_age numeric(3) NULL, -- 允许交易年龄上限 -1为不限
	allow_min_age numeric(3) NULL, -- 允许交易年龄下限 -1为不限制
	sale_org bpchar(1) NULL, -- 销售机构范围（0：不限制 1：限制）
	rate_days bpchar(1) NULL, -- 年天数(0：360 1：365 2：366)
	calc_type varchar(3) NOT NULL, -- 计提频率（D1-每天、M1-每月、M3-每季、Z-到期、Z0-不计提）
	calc_date bpchar(8) NULL, -- 计提日期（计提周期为每月、每季时填写）
	interest_type varchar(3) NOT NULL, -- 结息频率（D1-每天、M1-每月、M3-每季、Z-到期）
	interest_date bpchar(8) NULL, -- 结息日期（当计提周期为每月、每季时，并且为产品子类为“日终型”，为必填项。其他产品类型不填写。）
	part_draw_interest bpchar(1) NULL, -- 部分支取是否结息 （1 是 0 否 协定型、日均型不支持提前支取，这两种产品不填。）
	account_no varchar(32) NULL, -- 计提结息会计分录方案编号
	is_exclusive bpchar(1) NULL, -- 是否为专享产品 1是 0否
	exclusive_count numeric(10) NULL, -- 专享码数量 (为专享产品时，为产品生产对应数目的专享码)
	min_deposit_amt numeric(16, 2) NULL, -- 起存金额 (活期型：账户在满足留存金额的前提下，需要达到增值收益的起点为起存金额。（即生成第一个增值账户的起点）定期型：每一次定期购买的金额最低额度)
	step_amt numeric(16, 2) NULL, -- 递增减基数金额（活期型：生成第一个增值账户以后，后续生成增值账户按照递增减基数金额得出增值本金。定期型：超过起存金额部分，必须按照递增减基数金额进入增值本金。）
	min_hold_amt numeric(16, 2) NULL, -- 最低持有金额 (发生支取时，判断是否继续增值收益。活期型：所有增值账户的增值本金汇总最低额度。定期型：针对每一个定期发生支取之后的金额最低额度。)
	max_hold_amt numeric(16, 2) NULL, -- 最高持有金额 （活期型：所有增值账户的增值本金汇总最高额度定期型：针对每一个定期购买的金额最高额度。）
	inc_due varchar(4) NULL, -- 增值期限 日终、定期：每一个增值账户期限。日均：日均余额的考核周期。协定：最大协定期限。D1：一天 D7：七天 M1：一个月 M3:三个月M6：六个月 Y1：一年Y2：两年Y3：三年Y5：五年(自定义期限通过数据字典配置)
	crt_user varchar(20) NULL, -- 创建用户
	crt_orgno varchar(20) NULL, -- 创建机构
	draw_due varchar(4) NULL, -- 支取期限 （1-1月、2-2月、3-3月、4-4月、5-5月、6-6月、7-7月、8-8月、9-9月、10-10月、11-11月、12-12月）
	belong_org varchar(20) NULL, -- 归属机构
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	is_boutique bpchar(1) NULL, -- 是否是精品推荐产品(1-是 0-否)
	prod_flag bpchar(1) NOT NULL, -- 产品标记 1普通2尊享码3白名单
	seven_notice_amt numeric(16, 2) NULL, -- 七天通知金额
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cds_tb_prod_pub_info PRIMARY KEY (prod_code)
);

-- Column comments

COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_glob_code IS '全国唯一编码';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_name IS '产品名称';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_status IS '产品状态（0：待售 1：开始销售 2：停止销售）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_class IS '产品大类（0：活期 1：定期）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_subclass IS '产品子类( 0：活期日终型 1：活期日均型 2：协定活期型  3：定期型 4：大额存单 5：协定定期型）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_begin_date IS '销售日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_begin_time IS '销售时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_end_date IS '停售日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_end_time IS '停售时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_sale_channel IS '允许交易渠道 （0：银行柜台 1：银行网银 2：ATM 3：电话银行 4：手机银行）-1为不限制(多选)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_sex_limit IS '允许交易性别（单选）0:男 1:女 -1:不限';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_cust_type IS '允许交易客户类型 （0：企业客户 3：个人客户）（单选）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_card_type IS '允许交易卡类型(多选)-1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_cust_level IS '允许交易客户级别(多选)-1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_white_type IS '允许交易白名单编号 -1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_max_age IS '允许交易年龄上限 -1为不限';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.allow_min_age IS '允许交易年龄下限 -1为不限制';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.sale_org IS '销售机构范围（0：不限制 1：限制）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.rate_days IS '年天数(0：360 1：365 2：366)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.calc_type IS '计提频率（D1-每天、M1-每月、M3-每季、Z-到期、Z0-不计提）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.calc_date IS '计提日期（计提周期为每月、每季时填写）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.interest_type IS '结息频率（D1-每天、M1-每月、M3-每季、Z-到期）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.interest_date IS '结息日期（当计提周期为每月、每季时，并且为产品子类为“日终型”，为必填项。其他产品类型不填写。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.part_draw_interest IS '部分支取是否结息 （1 是 0 否 协定型、日均型不支持提前支取，这两种产品不填。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.account_no IS '计提结息会计分录方案编号';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.is_exclusive IS '是否为专享产品 1是 0否';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.exclusive_count IS '专享码数量 (为专享产品时，为产品生产对应数目的专享码)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.min_deposit_amt IS '起存金额 (活期型：账户在满足留存金额的前提下，需要达到增值收益的起点为起存金额。（即生成第一个增值账户的起点）定期型：每一次定期购买的金额最低额度)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.step_amt IS '递增减基数金额（活期型：生成第一个增值账户以后，后续生成增值账户按照递增减基数金额得出增值本金。定期型：超过起存金额部分，必须按照递增减基数金额进入增值本金。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.min_hold_amt IS '最低持有金额 (发生支取时，判断是否继续增值收益。活期型：所有增值账户的增值本金汇总最低额度。定期型：针对每一个定期发生支取之后的金额最低额度。)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.max_hold_amt IS '最高持有金额 （活期型：所有增值账户的增值本金汇总最高额度定期型：针对每一个定期购买的金额最高额度。）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.inc_due IS '增值期限 日终、定期：每一个增值账户期限。日均：日均余额的考核周期。协定：最大协定期限。D1：一天 D7：七天 M1：一个月 M3:三个月M6：六个月 Y1：一年Y2：两年Y3：三年Y5：五年(自定义期限通过数据字典配置)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_user IS '创建用户';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_orgno IS '创建机构';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.draw_due IS '支取期限 （1-1月、2-2月、3-3月、4-4月、5-5月、6-6月、7-7月、8-8月、9-9月、10-10月、11-11月、12-12月）';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.belong_org IS '归属机构';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.is_boutique IS '是否是精品推荐产品(1-是 0-否)';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.prod_flag IS '产品标记 1普通2尊享码3白名单';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.seven_notice_amt IS '七天通知金额';
COMMENT ON COLUMN crmdm.cds_tb_prod_pub_info.ryzd IS '冗余字段';


-- crmdm.cms_acct_business_account 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_business_account;

CREATE TABLE crmdm.cms_acct_business_account (
	serialno varchar(40) NOT NULL, -- 流水号
	objecttype varchar(40) NULL, -- 对象类型
	objectno varchar(40) NULL, -- 对象编号
	accountindicator varchar(10) NULL, -- 账户性质（系统内使用）
	priorityflag varchar(10) NULL, -- 优先级（Code:PRI）
	accountflag varchar(10) NULL, -- 存款账户标示（多存款系统使用）
	accounttype varchar(10) NULL, -- 存款账户类型(Code:AccountType)
	accountno varchar(40) NULL, -- 存款账户账号
	accountcurrency varchar(10) NULL, -- 存款账户币种
	accountname varchar(80) NULL, -- 存款账户名称
	accountorgid varchar(32) NULL, -- 存款账号核心机构号
	status varchar(10) NULL, -- 状态（0:无效,1:有效）
	mfcustomerid varchar(32) NULL, -- MFCUSTOMERID
	suoshudx varchar(12) NULL, -- 所属对象
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_business_account PRIMARY KEY (serialno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_business_account.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.objecttype IS '对象类型';
COMMENT ON COLUMN crmdm.cms_acct_business_account.objectno IS '对象编号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountindicator IS '账户性质（系统内使用）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.priorityflag IS '优先级（Code:PRI）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountflag IS '存款账户标示（多存款系统使用）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accounttype IS '存款账户类型(Code:AccountType)';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountno IS '存款账户账号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountcurrency IS '存款账户币种';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountname IS '存款账户名称';
COMMENT ON COLUMN crmdm.cms_acct_business_account.accountorgid IS '存款账号核心机构号';
COMMENT ON COLUMN crmdm.cms_acct_business_account.status IS '状态（0:无效,1:有效）';
COMMENT ON COLUMN crmdm.cms_acct_business_account.mfcustomerid IS 'MFCUSTOMERID';
COMMENT ON COLUMN crmdm.cms_acct_business_account.suoshudx IS '所属对象';
COMMENT ON COLUMN crmdm.cms_acct_business_account.ryzd IS '冗余字段';


-- crmdm.cms_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_loan;

CREATE TABLE crmdm.cms_acct_loan (
	serialno varchar(40) NOT NULL, -- 贷款账号
	accountno varchar(40) NULL, -- 贷款文本账号
	contractserialno varchar(40) NULL, -- 关联合同号
	customerid varchar(40) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	businesstype varchar(40) NULL, -- 业务品种
	productid varchar(40) NULL, -- 产品编号
	specificid varchar(40) NULL, -- 特殊账户编号
	versionid varchar(40) NULL, -- 版本编号
	currency varchar(10) NULL, -- 币种
	businesssum numeric(24, 2) NULL, -- 贷款金额
	putoutdate varchar(10) NULL, -- 贷款发放日期
	maturitydate varchar(10) NULL, -- 贷款到期日
	originalmaturitydate varchar(10) NULL, -- 贷款原始到期日
	operateorgid varchar(40) NULL, -- 经办行号（用做异地支行标识）
	accountingorgid varchar(32) NULL, -- 贷款入账机构
	loanstatus varchar(10) NULL, -- 贷款状态
	finishdate varchar(10) NULL, -- 结清日期
	businessdate varchar(10) NULL, -- 贷款处理日期
	lockflag varchar(10) NULL, -- 锁定标识
	overduedays numeric NULL, -- 逾期天数
	classifyresult varchar(10) NULL, -- 分类结果
	putoutserialno varchar(40) NULL, -- 出账流水号
	approveserialno varchar(40) NULL, -- 审批流水号
	applyserialno varchar(40) NULL, -- 申请流水号
	businessstatus varchar(10) NULL, -- 业务状态
	maxoverduedays numeric NULL, -- 最大逾期天数
	normalbalance numeric(24, 2) NULL, -- 正常本金余额
	overduebalance numeric(24, 2) NULL, -- 逾期本金
	accruedinterest numeric(24, 2) NULL, -- 计提利息
	overdueinterest numeric(24, 2) NULL, -- 逾期利息
	principalpenalty numeric(24, 2) NULL, -- 本金罚息
	interestpenalty numeric(24, 2) NULL, -- 利息罚息
	overduefee numeric(24, 2) NULL, -- 逾期费用
	impairmentflag varchar(10) NULL, -- 减值状态
	graceinteestamt numeric(24, 2) NULL, -- 宽限期利息
	loanratetermid varchar(20) NULL, -- 贷款利率功能组件编号
	gracedays numeric NULL, -- 逾期宽限期天数
	currentrpttermid varchar(32) NULL, -- 当前时点还款方式
	batchno varchar(10) NULL, -- 批扣组号
	occurtype varchar(10) NULL, -- 是否垫款标识
	vouchtype varchar(18) NULL, -- 担保方式
	businessloantype varchar(20) NULL, -- 贷款类型
	lastdaynormalbalance numeric(24, 2) NULL, -- 上日正常本金余额
	lastdayoverduebalance numeric(24, 2) NULL, -- 上日逾期本金余额
	lastdayaccruedinterest numeric(24, 2) NULL, -- 上日计提利息
	lastdayoverdueinterest numeric(24, 2) NULL, -- 上日逾期利息
	lastdayprincipalpenalty numeric(24, 2) NULL, -- 上日本金罚息
	lastdayinterestpenalty numeric(24, 2) NULL, -- 上日利息罚息
	lastdayoverduefee numeric(24, 2) NULL, -- 上日欠费金额
	dongjbho varchar(40) NULL, -- 冻结编号
	corpuspaymethod varchar(20) NULL, -- 还款方式
	autopayflag varchar(20) NULL, -- 批量扣款标识
	nextduedate varchar(20) NULL, -- 下次还款日
	lcatimes numeric(22) NULL, -- 逾期次数
	guaranteeway varchar(18) NULL, -- 担保方式（科目映射使用）
	basebusinesstype varchar(18) NULL, -- 基础产品
	accountflag varchar(10) NULL, -- 科目特殊映射标识
	gjflag varchar(18) NULL, -- 国结标识
	dutyfreecode varchar(2) NULL, -- 免税标识
	batchflag varchar(10) NULL, -- 批量执行标识
	yzflag varchar(2) NULL, -- 移植标识
	iswriteoffaccrualflag varchar(2) NULL, -- 核销后是否计息标志(YesNo)
	loanwriteofftype varchar(10) NULL, -- 核销类型（01-核销（继续清收）；02-核销结清（清收完成））
	xwmsswitchstatus varchar(10) NULL, -- 小微免税考核开关状态
	intpaymode varchar(2) NULL, -- 利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_loan PRIMARY KEY (serialno)
);
CREATE UNIQUE INDEX pk_acct_loan ON crmdm.cms_acct_loan USING btree (serialno);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_loan.serialno IS '贷款账号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.accountno IS '贷款文本账号                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.contractserialno IS '关联合同号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.customerid IS '客户编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.customername IS '客户名称                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businesstype IS '业务品种                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.productid IS '产品编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.specificid IS '特殊账户编号                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.versionid IS '版本编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.currency IS '币种                        ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businesssum IS '贷款金额                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.putoutdate IS '贷款发放日期                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.maturitydate IS '贷款到期日                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.originalmaturitydate IS '贷款原始到期日              ';
COMMENT ON COLUMN crmdm.cms_acct_loan.operateorgid IS '经办行号（用做异地支行标识）';
COMMENT ON COLUMN crmdm.cms_acct_loan.accountingorgid IS '贷款入账机构                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.loanstatus IS '贷款状态                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.finishdate IS '结清日期                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businessdate IS '贷款处理日期                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lockflag IS '锁定标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overduedays IS '逾期天数                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.classifyresult IS '分类结果                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.putoutserialno IS '出账流水号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.approveserialno IS '审批流水号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.applyserialno IS '申请流水号                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businessstatus IS '业务状态                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.maxoverduedays IS '最大逾期天数                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.normalbalance IS '正常本金余额                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overduebalance IS '逾期本金                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.accruedinterest IS '计提利息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overdueinterest IS '逾期利息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.principalpenalty IS '本金罚息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.interestpenalty IS '利息罚息                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.overduefee IS '逾期费用                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.impairmentflag IS '减值状态                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.graceinteestamt IS '宽限期利息                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.loanratetermid IS '贷款利率功能组件编号        ';
COMMENT ON COLUMN crmdm.cms_acct_loan.gracedays IS '逾期宽限期天数              ';
COMMENT ON COLUMN crmdm.cms_acct_loan.currentrpttermid IS '当前时点还款方式            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.batchno IS '批扣组号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.occurtype IS '是否垫款标识                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.vouchtype IS '担保方式                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.businessloantype IS '贷款类型                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdaynormalbalance IS '上日正常本金余额            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayoverduebalance IS '上日逾期本金余额            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayaccruedinterest IS '上日计提利息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayoverdueinterest IS '上日逾期利息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayprincipalpenalty IS '上日本金罚息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayinterestpenalty IS '上日利息罚息                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lastdayoverduefee IS '上日欠费金额                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.dongjbho IS '冻结编号                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.corpuspaymethod IS '还款方式                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.autopayflag IS '批量扣款标识                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.nextduedate IS '下次还款日                  ';
COMMENT ON COLUMN crmdm.cms_acct_loan.lcatimes IS '逾期次数                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.guaranteeway IS '担保方式（科目映射使用）    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.basebusinesstype IS '基础产品                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.accountflag IS '科目特殊映射标识            ';
COMMENT ON COLUMN crmdm.cms_acct_loan.gjflag IS '国结标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.dutyfreecode IS '免税标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.batchflag IS '批量执行标识                ';
COMMENT ON COLUMN crmdm.cms_acct_loan.yzflag IS '移植标识                    ';
COMMENT ON COLUMN crmdm.cms_acct_loan.iswriteoffaccrualflag IS '核销后是否计息标志(YesNo)';
COMMENT ON COLUMN crmdm.cms_acct_loan.loanwriteofftype IS '核销类型（01-核销（继续清收）；02-核销结清（清收完成））';
COMMENT ON COLUMN crmdm.cms_acct_loan.xwmsswitchstatus IS '小微免税考核开关状态';
COMMENT ON COLUMN crmdm.cms_acct_loan.intpaymode IS '利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)';
COMMENT ON COLUMN crmdm.cms_acct_loan.ryzd IS '冗余字段';


-- crmdm.cms_acct_payment_schedule 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_payment_schedule;

CREATE TABLE crmdm.cms_acct_payment_schedule (
	serialno varchar(40) NOT NULL, -- 流水号
	parentserialno varchar(40) NULL, -- 父还款计划流水号
	objecttype varchar(40) NULL, -- 还款日志关联对象类型
	objectno varchar(40) NULL, -- 还款日志关联对象编号
	relativeobjecttype varchar(40) NULL, -- 还款主体对象类型
	relativeobjectno varchar(40) NULL, -- 还款主体对象编号
	periodno int4 NULL, -- 期次
	paydate varchar(10) NULL, -- 应还日期
	pstype varchar(10) NULL, -- 偿付类型
	payitemcode varchar(10) NULL, -- 还款项目
	intedate varchar(10) NULL, -- 节假日及宽限期顺延后的还款日期
	holidayintedate varchar(10) NULL, -- 节假日顺延后的还款日
	graceintedate varchar(10) NULL, -- 宽限期顺延后的还款日期（开始计算罚息的日期）
	settledate varchar(10) NULL, -- 结算日
	autopayflag varchar(10) NULL, -- 自动扣款标识
	currency varchar(10) NULL, -- 币种
	fixpayprincipalamt numeric(24, 2) NULL, -- 手工指定当期还款额
	fixpayinstalmentamt numeric(24, 2) NULL, -- 手工指定当期本金还款额
	payprincipalamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还本金
	actualpayprincipalamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还本金
	waiveprincipalamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免本金金额
	principalbalance numeric(24, 2) DEFAULT 0.00 NULL, -- 剩余本金余额
	payinterestamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还利息
	actualpayinterestamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还利息
	waiveinterestamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免利息金额
	payprincipalpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还本金罚息
	actualpayprincipalpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还本金罚息
	waiveprincipalpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免本金罚息
	payinterestpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还利息罚息
	actualpayinterestpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还利息罚息
	waiveinterestpenaltyamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免利息罚息
	status varchar(10) NULL, -- 状态
	finishdate varchar(10) NULL, -- 结清日期
	remark varchar(400) NULL, -- 备注
	direction varchar(10) NULL, -- 收付方向
	payfeeamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还费用
	actualpayfeeamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还费用
	waivefeeamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免费用
	fixpayinterestflag varchar(10) NULL, -- 当期是否还息
	fixpayprincipaldate varchar(10) NULL, -- 当期指定还本日期
	paygraceinteamt numeric(24, 2) DEFAULT 0.00 NULL, -- 应还宽限期利息
	actualpaygraceinteamt numeric(24, 2) DEFAULT 0.00 NULL, -- 实还宽限期利息
	waivegraceinteamt numeric(24, 2) DEFAULT 0.00 NULL, -- 减免宽限期利息
	oldpstype varchar(2) NULL -- 老系统计划类型
);
CREATE INDEX idx_payment_schedule_1 ON crmdm.cms_acct_payment_schedule USING btree (objectno, objecttype);
CREATE INDEX idx_payment_schedule_2 ON crmdm.cms_acct_payment_schedule USING btree (relativeobjectno, relativeobjecttype);
CREATE INDEX idx_payment_schedule_3 ON crmdm.cms_acct_payment_schedule USING btree (paydate, pstype);
COMMENT ON TABLE crmdm.cms_acct_payment_schedule IS '贷款-还款日志';

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.parentserialno IS '父还款计划流水号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.objecttype IS '还款日志关联对象类型';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.objectno IS '还款日志关联对象编号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.relativeobjecttype IS '还款主体对象类型';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.relativeobjectno IS '还款主体对象编号';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.periodno IS '期次';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.paydate IS '应还日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.pstype IS '偿付类型';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payitemcode IS '还款项目';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.intedate IS '节假日及宽限期顺延后的还款日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.holidayintedate IS '节假日顺延后的还款日';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.graceintedate IS '宽限期顺延后的还款日期（开始计算罚息的日期）';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.settledate IS '结算日';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.autopayflag IS '自动扣款标识';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.currency IS '币种';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayprincipalamt IS '手工指定当期还款额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayinstalmentamt IS '手工指定当期本金还款额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payprincipalamt IS '应还本金';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayprincipalamt IS '实还本金';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveprincipalamt IS '减免本金金额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.principalbalance IS '剩余本金余额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payinterestamt IS '应还利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayinterestamt IS '实还利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveinterestamt IS '减免利息金额';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payprincipalpenaltyamt IS '应还本金罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayprincipalpenaltyamt IS '实还本金罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveprincipalpenaltyamt IS '减免本金罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payinterestpenaltyamt IS '应还利息罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayinterestpenaltyamt IS '实还利息罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waiveinterestpenaltyamt IS '减免利息罚息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.status IS '状态';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.finishdate IS '结清日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.direction IS '收付方向';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.payfeeamt IS '应还费用';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpayfeeamt IS '实还费用';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waivefeeamt IS '减免费用';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayinterestflag IS '当期是否还息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.fixpayprincipaldate IS '当期指定还本日期';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.paygraceinteamt IS '应还宽限期利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.actualpaygraceinteamt IS '实还宽限期利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.waivegraceinteamt IS '减免宽限期利息';
COMMENT ON COLUMN crmdm.cms_acct_payment_schedule.oldpstype IS '老系统计划类型';


-- crmdm.cms_acct_rate_segment 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_rate_segment;

CREATE TABLE crmdm.cms_acct_rate_segment (
	serialno varchar(40) NOT NULL, -- 流水号
	objectno varchar(40) NULL, -- 对象类型
	objecttype varchar(40) NULL, -- 对象编号
	segno numeric NULL, -- 区段序号
	segfromdate varchar(10) NULL, -- 区段生效日期
	segtodate varchar(10) NULL, -- 区段结束日期
	segfromstage numeric NULL, -- 区段生效期次
	segtostage numeric NULL, -- 区段结束期次
	segstages numeric NULL, -- 区段持续期次
	termid varchar(20) NULL, -- 组件编号
	ratetype varchar(20) NULL, -- 利率类型
	rateunit varchar(10) NULL, -- 利率单位
	baserategrade varchar(10) NULL, -- 基准利率档次
	baseratetype varchar(10) NULL, -- 基准利率类型
	baserate numeric(12, 8) NULL, -- 基准利率
	ratefloattype varchar(10) NULL, -- 利率浮动类型
	ratefloat numeric(10, 6) NULL, -- 浮动幅度
	businessrate numeric(12, 8) NULL, -- 执行利率
	repricetype varchar(4) NULL, -- 利率调整方式
	repricetermunit varchar(10) NULL, -- 利率调整周期单位
	repriceterm numeric NULL, -- 利率调整周期
	defaultrepricedate varchar(10) NULL, -- 指定利率调整日期
	lastrepricedate varchar(10) NULL, -- 上次利率调整日期
	nextrepricedate varchar(10) NULL, -- 下次利率调整日期
	remark varchar(400) NULL, -- 备注
	status varchar(10) NULL, -- 状态
	segname varchar(120) NULL, -- 区段名称
	segtermid varchar(20) NULL, -- 组件编号
	yearbaseday numeric NULL, -- 年基准天数
	transserialno varchar(40) NULL, -- 交易流水号
	splitmethod varchar(10) NULL, -- 拆分方式
	accrueinteflag varchar(10) NULL, -- 是否计收利息(Code:YsesNo)
	accruecompflag varchar(10) NULL, -- 是否收取复利(Code:YsesNo)
	accruefineflag varchar(10) NULL, -- 是否收取罚利(Code:YsesNo)
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_rate_segment PRIMARY KEY (serialno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_rate_segment.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.objectno IS '对象类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.objecttype IS '对象编号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segno IS '区段序号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segfromdate IS '区段生效日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segtodate IS '区段结束日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segfromstage IS '区段生效期次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segtostage IS '区段结束期次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segstages IS '区段持续期次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.termid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ratetype IS '利率类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.rateunit IS '利率单位';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.baserategrade IS '基准利率档次';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.baserate IS '基准利率';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ratefloattype IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ratefloat IS '浮动幅度';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.businessrate IS '执行利率';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.repricetype IS '利率调整方式';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.repricetermunit IS '利率调整周期单位';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.repriceterm IS '利率调整周期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.defaultrepricedate IS '指定利率调整日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.lastrepricedate IS '上次利率调整日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.nextrepricedate IS '下次利率调整日期';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.status IS '状态';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segname IS '区段名称';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.segtermid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.yearbaseday IS '年基准天数';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.transserialno IS '交易流水号';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.splitmethod IS '拆分方式';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.accrueinteflag IS '是否计收利息(Code:YsesNo)';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.accruecompflag IS '是否收取复利(Code:YsesNo)';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.accruefineflag IS '是否收取罚利(Code:YsesNo)';
COMMENT ON COLUMN crmdm.cms_acct_rate_segment.ryzd IS '冗余字段';


-- crmdm.cms_acct_rpt_segment 定义

-- Drop table

-- DROP TABLE crmdm.cms_acct_rpt_segment;

CREATE TABLE crmdm.cms_acct_rpt_segment (
	serialno varchar(40) NOT NULL, -- 流水号
	objectno varchar(40) NULL, -- 对象编号
	objecttype varchar(40) NULL, -- 对象类型
	pstype varchar(10) NULL, -- 还款计划类型
	termid varchar(10) NULL, -- 组件编号
	segno numeric NULL, -- 区段序号
	segname varchar(120) NULL, -- 区段名称
	termruleid varchar(10) NULL, -- 组件编号
	segtermid varchar(10) NULL, -- 组件编号
	segfromdate varchar(10) NULL, -- 区段生效日期
	segtodate varchar(10) NULL, -- 区段结束日期
	segfromstage numeric NULL, -- 区段生效期次
	segtostage numeric NULL, -- 区段结束期次
	segstages numeric NULL, -- 区段持续期次
	status varchar(10) NULL, -- 状态
	segtermflag varchar(10) NULL, -- 区段期限标志
	segtermunit varchar(10) NULL, -- 指定区段期限单位，默认为月M
	segterm numeric NULL, -- 指定区段期限
	firstduedate varchar(10) NULL, -- 首次还款日
	defaultdueday varchar(2) NULL, -- 默认还款日
	lastduedate varchar(10) NULL, -- 上次还款日
	nextduedate varchar(10) NULL, -- 下次还款日
	totalperiod numeric NULL, -- 总期次
	currentperiod numeric NULL, -- 当前期次
	gaincyc numeric NULL, -- 递变周期
	gainamount numeric(24, 2) NULL, -- 递变幅度
	payfrequencytype varchar(10) NULL, -- 还款周期
	payfrequencyunit varchar(10) NULL, -- 指定还款周期单位
	payfrequency varchar(10) NULL, -- 指定还款周期
	segrptamountflag varchar(20) NULL, -- 指定区段金额标志
	segrptamount numeric(24, 2) NULL, -- 指定区段拟还本金金额
	segrptpercent numeric(5, 2) NULL, -- 指定区段拟还本金比例
	seginstalmentamt numeric(24, 2) NULL, -- 期供金额
	segrptbalance numeric(24, 2) NULL, -- 本区段剩余待归还本金
	firstinstalmentflag varchar(10) NULL, -- 首次还款金额标识
	finalinstalmentflag varchar(10) NULL, -- 末次还款金额标识
	gracedays numeric NULL, -- 宽限期天数
	autopayflag varchar(10) NULL, -- 自动扣款标识
	remark varchar(200) NULL, -- 备注
	psrestructureflag varchar(10) NULL, -- 更新期供标示(0 不生成还款计划也不重算期供，1 只算还款计划不计算期供，2 还款计划期供都算)
	postponerule varchar(200) NULL, -- 逾期延期规则
	transserialno varchar(40) NULL, -- 交易流水号
	gracedaysaccrualflag varchar(2) NULL, -- 宽限期计息标志
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_acct_rpt_segment PRIMARY KEY (serialno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.objectno IS '对象编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.objecttype IS '对象类型';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.pstype IS '还款计划类型';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.termid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segno IS '区段序号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segname IS '区段名称';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.termruleid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtermid IS '组件编号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segfromdate IS '区段生效日期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtodate IS '区段结束日期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segfromstage IS '区段生效期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtostage IS '区段结束期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segstages IS '区段持续期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.status IS '状态';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtermflag IS '区段期限标志';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segtermunit IS '指定区段期限单位，默认为月M';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segterm IS '指定区段期限';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.firstduedate IS '首次还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.defaultdueday IS '默认还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.lastduedate IS '上次还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.nextduedate IS '下次还款日';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.totalperiod IS '总期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.currentperiod IS '当前期次';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gaincyc IS '递变周期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gainamount IS '递变幅度';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.payfrequencytype IS '还款周期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.payfrequencyunit IS '指定还款周期单位';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.payfrequency IS '指定还款周期';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptamountflag IS '指定区段金额标志';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptamount IS '指定区段拟还本金金额';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptpercent IS '指定区段拟还本金比例';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.seginstalmentamt IS '期供金额';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.segrptbalance IS '本区段剩余待归还本金';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.firstinstalmentflag IS '首次还款金额标识';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.finalinstalmentflag IS '末次还款金额标识';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gracedays IS '宽限期天数';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.autopayflag IS '自动扣款标识';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.psrestructureflag IS '更新期供标示(0 不生成还款计划也不重算期供，1 只算还款计划不计算期供，2 还款计划期供都算)';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.postponerule IS '逾期延期规则';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.transserialno IS '交易流水号';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.gracedaysaccrualflag IS '宽限期计息标志';
COMMENT ON COLUMN crmdm.cms_acct_rpt_segment.ryzd IS '冗余字段';


-- crmdm.cms_business_approve 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_approve;

CREATE TABLE crmdm.cms_business_approve (
	serialno varchar(32) NOT NULL, -- 流水号字段
	relativeserialno varchar(40) NULL, -- 关联流水号字段
	occurdate varchar(10) NULL, -- 发生日期
	customerid varchar(32) NULL, -- 客户编号
	customername varchar(120) NULL, -- 客户名称
	businesstype varchar(18) NULL, -- 业务品种
	businesssubtype varchar(18) NULL, -- 保理类型
	occurtype varchar(18) NULL, -- 发生类型
	currenylist varchar(18) NULL, -- 其他可融通币种表
	currencymode varchar(18) NULL, -- 汇率计算模式
	businesstypelist varchar(18) NULL, -- 可混用品种表
	calculatemode varchar(18) NULL, -- 金额占用计算模式
	useorglist varchar(18) NULL, -- 额度可使用机构范围
	flowreduceflag varchar(18) NULL, -- 额度是否简化审批流程
	contractflag varchar(18) NULL, -- 是否使用额度
	subcontractflag varchar(18) NULL, -- 额度下业务是否需要签署合同
	selfuseflag varchar(18) NULL, -- 自用额度
	creditaggreement varchar(32) NULL, -- 额度协议流水号字段
	relativeagreement varchar(32) NULL, -- 额度品种
	loanflag varchar(18) NULL, -- 是否可直接申请出账
	totalsum numeric(24, 6) NULL, -- 展期前金额
	ourrole varchar(18) NULL, -- 额度控制类型
	reversibility varchar(18) NULL, -- 有无追索权
	billnum int4 NULL, -- 票据数量
	housetype varchar(18) NULL, -- 房产类型
	lctermtype varchar(18) NULL, -- 信用证期限类型
	riskattribute varchar(18) NULL, -- 风险类型
	suretype varchar(18) NULL, -- 运单种类
	safeguardtype varchar(18) NULL, -- 保函类型
	creditbusiness varchar(18) NULL, -- 单项额度指定品种
	businesscurrency varchar(18) NULL, -- 业务品种
	businesssum numeric(24, 6) NULL, -- 金额
	businessprop numeric(10, 6) NULL, -- 贷款成数
	termyear int4 NULL, -- 期限
	termmonth int4 NULL, -- 期限
	termday int4 NULL, -- 期限
	lgterm int4 NULL, -- 远期天数
	baseratetype varchar(18) NULL, -- 基准利率类型
	baserate numeric(10, 6) NULL, -- 基准年利率
	ratefloattype varchar(18) NULL, -- 利率浮动方式
	ratefloat numeric(10, 6) NULL, -- 利率浮动值
	businessrate numeric(10, 6) NULL, -- 执行月利率
	ictype varchar(18) NULL, -- 收费方式
	iccyc varchar(18) NULL, -- 计息周期
	pdgratio numeric(10, 6) NULL, -- 手续费率
	pdgsum numeric(24, 6) NULL, -- 手续费金额
	pdgpaymethod varchar(18) NULL, -- 手续费支付方式
	pdgpayperiod varchar(18) NULL, -- 收费周期
	promisesfeeratio numeric(10, 6) NULL, -- 承诺费率
	promisesfeesum numeric(24, 6) NULL, -- 承诺费
	promisesfeeperiod int4 NULL, -- 承诺费计收期
	promisesfeebegin varchar(10) NULL, -- 承诺费计收起始日
	mfeeratio numeric(10, 6) NULL, -- 管理费率
	mfeesum numeric(24, 6) NULL, -- 管理费金额
	mfeepaymethod varchar(18) NULL, -- 管理费支付方式
	agentfee numeric(24, 6) NULL, -- 代理费/单据处理费（元）
	dealfee numeric(24, 6) NULL, -- 银行费用
	totalcast numeric(24, 6) NULL, -- 总成本
	discountinterest numeric(24, 6) NULL, -- 贴现利息
	purchaserinterest numeric(24, 6) NULL, -- 买房应付贴现利息
	bargainorinterest numeric(24, 6) NULL, -- 卖方应付贴现利息
	discountsum numeric(24, 6) NULL, -- 实付贴现金额
	bailratio numeric(10, 6) NULL, -- 保证金比例/要求保证金比例(%)
	bailcurrency varchar(18) NULL, -- 保证金币种
	bailsum numeric(24, 6) NULL, -- 保证金金额/要求保证金金额
	bailaccount varchar(80) NULL, -- 保证金账号
	fineratetype varchar(18) NULL, -- 罚息利率类型
	finerate numeric(10, 6) NULL, -- 垫款利率
	drawingtype varchar(18) NULL, -- 提款方式
	firstdrawingdate varchar(10) NULL, -- 首次提款日
	drawingperiod int4 NULL, -- 提款期限
	paytimes int4 NULL, -- 还款期数
	paycyc varchar(18) NULL, -- 还本付息方式
	graceperiod int4 NULL, -- 贷款宽限期
	overdraftperiod int4 NULL, -- 连续透支期
	oldlcno varchar(32) NULL, -- 信用证编号
	oldlctermtype varchar(18) NULL, -- 原信用证期限类型
	remitmode varchar(18) NULL, -- 汇款方式
	oldlcsum numeric(24, 6) NULL, -- 原信用证金额
	oldlcloadingdate varchar(10) NULL, -- 信用证装期
	oldlcvaliddate varchar(10) NULL, -- 信用证效期
	direction varchar(18) NULL, -- 行业投向
	purpose varchar(2000) NULL, -- 用途
	planallocation varchar(300) NULL, -- 用款计划
	immediacypaysource varchar(300) NULL, -- 重组条件（直接还款来源）
	paysource varchar(300) NULL, -- 还款来源
	corpuspaymethod varchar(18) NULL, -- 还款方式
	interestpaymethod varchar(18) NULL, -- 利息支付方式
	thirdparty1 varchar(300) NULL, -- 承兑人名称
	thirdpartyid1 varchar(60) NULL, -- 房屋详址
	thirdparty2 varchar(300) NULL, -- 开发商资质等级
	thirdpartyid2 varchar(60) NULL, -- 受益人所在国家或地区
	thirdparty3 varchar(300) NULL, -- 议付行/寄单行
	thirdpartyid3 varchar(32) NULL, -- 最高成数
	thirdpartyregion varchar(18) NULL, -- 所在国家或地区
	thirdpartyaccounts varchar(32) NULL, -- 单据号
	cargoinfo varchar(80) NULL, -- 进口货物名称
	projectname varchar(120) NULL, -- 项目名称
	operationinfo varchar(600) NULL, -- 房产地址
	contextinfo varchar(300) NULL, -- 提款说明
	securitiestype varchar(18) NULL, -- 有价证券类型
	securitiesregion varchar(18) NULL, -- 有价证券发行地
	constructionarea numeric(24, 6) NULL, -- 建筑面积
	usearea numeric(24, 6) NULL, -- 面积
	flag1 varchar(18) NULL, -- FLAG1
	flag2 varchar(18) NULL, -- FLAG1
	flag3 varchar(18) NULL, -- FLAG1
	tradecontractno varchar(60) NULL, -- 相关贸易合同号码
	invoiceno varchar(32) NULL, -- 发票号
	tradecurrency varchar(18) NULL, -- 贸易合同币种
	tradesum numeric(24, 6) NULL, -- 贸易合同金额
	paymentdate varchar(10) NULL, -- 票据查询、回复日期
	operationmode varchar(18) NULL, -- 业务处理方式
	vouchclass varchar(18) NULL, -- 担保形式
	vouchtype varchar(18) NULL, -- 主要担保方式
	vouchtype1 varchar(18) NULL, -- 其他担保方式
	vouchtype2 varchar(18) NULL, -- 担保方式2
	vouchflag varchar(18) NULL, -- 有无其他担保方式
	warrantor varchar(80) NULL, -- 担保人
	warrantorid varchar(32) NULL, -- 担保人编号
	othercondition varchar(600) NULL, -- 其他条件和要求
	guarantyvalue numeric(24, 6) NULL, -- 担保总价值
	guarantyrate numeric(10, 6) NULL, -- 担保率
	baseevaluateresult varchar(18) NULL, -- 基期信用等级
	riskrate numeric(24, 6) NULL, -- 综合风险度
	lowrisk varchar(18) NULL, -- 是否低风险业务
	otherarealoan varchar(18) NULL, -- 是否异地业务
	lowriskbailsum numeric(24, 6) NULL, -- 低风险担保金额
	originalputoutdate varchar(10) NULL, -- 首次放款日期
	extendtimes int4 NULL, -- 展期次数
	lngotimes int4 NULL, -- 借新还旧次数
	golntimes int4 NULL, -- 还旧借新次数
	drtimes int4 NULL, -- 债务重组次数
	baseclassifyresult varchar(18) NULL, -- 基期分类结果
	applytype varchar(18) NULL, -- 申请类型
	bailrate numeric(24, 6) NULL, -- 保证金比例
	finishorg varchar(18) NULL, -- 终批机构
	describe1 varchar(300) NULL, -- 宽限期期数
	operateorgid varchar(32) NULL, -- 经办机构
	operateuserid varchar(32) NULL, -- 经办人
	operatedate varchar(10) NULL, -- 经办日期
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(20) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	pigeonholedate varchar(10) NULL, -- 归档日期
	remark varchar(600) NULL, -- 备注
	paycurrency varchar(18) NULL, -- 单据币种
	paydate varchar(10) NULL, -- 装期
	flag4 varchar(18) NULL, -- 交单方式
	fundsource varchar(18) NULL, -- 资金来源
	operatetype varchar(18) NULL, -- 操作方式
	approvetype varchar(20) NULL, -- 最终审批意见类型
	cycleflag varchar(20) NULL, -- 是否循环
	classifyresult varchar(80) NULL, -- 当前风险分类结果
	classifydate varchar(10) NULL, -- 风险分类日期
	classifyfrequency int4 NULL, -- 检查频率
	vouchnewflag varchar(20) NULL, -- 是否新增担保
	adjustratetype varchar(18) NULL, -- 利率调整方式/宽限期还款法
	adjustrateterm varchar(18) NULL, -- 利率调整日月数
	rateadjustcyc varchar(18) NULL, -- 利率调整周期
	fzanbalance numeric(24, 6) NULL, -- 单据金额
	acceptinttype varchar(18) NULL, -- 收息类型
	ratio numeric(24, 6) NULL, -- 押汇比例
	thirdpartyadd1 varchar(160) NULL, -- 首付金额
	thirdpartyzip1 varchar(32) NULL, -- 首付比例
	thirdpartyadd2 varchar(80) NULL, -- 首付款来源
	thirdpartyzip2 varchar(32) NULL, -- 按揭贷款成数
	thirdpartyadd3 varchar(80) NULL, -- 发运地
	thirdpartyzip3 varchar(50) NULL, -- 进口许可证(批文)编号
	effectarea varchar(18) NULL, -- 交货地
	termdate1 varchar(10) NULL, -- 到期日
	termdate2 varchar(10) NULL, -- 交单期
	termdate3 varchar(10) NULL, -- 申请开证日期
	fixcyc int4 NULL, -- 固定周期
	describe2 varchar(300) NULL, -- 宽限期付息方法
	approveopinion varchar(300) NULL, -- 最终审批意见
	tempsaveflag varchar(18) NULL, -- 暂存标志
	approvedate varchar(10) NULL, -- 批复日期
	flag5 varchar(18) NULL, -- 关联状态
	creditcycle varchar(18) NULL, -- 是否循环
	guarantyflag varchar(18) NULL, -- 征信担保标志
	executeyearrate numeric(10, 6) NULL, -- 执行年利率
	paysourcen varchar(18) NULL, -- 还款来源
	returnfrequency varchar(18) NULL, -- 还款频率
	backfrequency varchar(18) NULL, -- 还息频率
	ishostbank varchar(18) NULL, -- 银团贷款我行是否主办行
	havepayplan varchar(2) NULL, -- 是否设定还款计划表
	ipcode varchar(4) NULL, -- 还息频率（日或月）
	frcode varchar(4) NULL, -- 还款频率（日或月）
	paysourcedetail varchar(300) NULL, -- 还款来源说明
	businesssource varchar(6) NULL, -- 业务渠道
	barcode varchar(64) NULL, -- 条形码
	creditmethod varchar(18) NULL, -- 授信模式
	titularsum1 numeric(24, 6) NULL, -- 名义金额1
	titularsum2 numeric(24, 6) NULL, -- 名义金额2
	titularsum3 numeric(24, 6) NULL, -- 名义金额3
	titularsum4 numeric(24, 6) NULL, -- 名义金额4
	titularsum5 numeric(24, 6) NULL, -- 名义金额5
	exposuresum1 numeric(24, 6) NULL, -- 敞口金额1
	exposuresum2 numeric(24, 6) NULL, -- 敞口金额2
	exposuresum3 numeric(24, 6) NULL, -- 敞口金额3
	exposuresum4 numeric(24, 6) NULL, -- 敞口金额4
	exposuresum5 numeric(24, 6) NULL, -- 敞口金额5
	overagesum1 numeric(24, 6) NULL, -- 敞口余额1
	overagesum2 numeric(24, 6) NULL, -- 敞口余额2
	overagesum3 numeric(24, 6) NULL, -- 敞口余额3
	operateuserid1 varchar(32) NULL, -- 辅办客户经理
	reapply varchar(18) NULL, -- 复议标志(Code:ReApply)
	usedepositpile varchar(4) NULL, -- 存款积数
	depositpilesum numeric(24, 6) NULL, -- 本次所使用存款积数
	preappno varchar(32) NULL, -- 预审号
	direction1 varchar(18) NULL, -- 本行行业分类
	billtype varchar(4) NULL, -- 票据类型
	basebusinesstype varchar(18) NULL, -- 基础产品
	investedcapital numeric(24, 6) NULL, -- 项目总投资额
	promisesfeetype varchar(18) NULL, -- 承诺费支付方式
	issuetype varchar(20) NULL, -- 签发类型
	issuebankname varchar(90) NULL, -- 代签银行名称
	isinsurance varchar(4) NULL, -- 是否保险贷款
	extend numeric(24, 6) NULL, -- 单价（元/平米）
	extend1 varchar(80) NULL, -- 购房合同号
	businessloantype varchar(20) NULL, -- 贷款类型
	extend3 varchar(20) NULL, -- 目前客户名下房屋数量
	extend4 numeric(24, 6) NULL, -- 借款人月收入
	approveartificialno varchar(60) NULL, -- 批复文本号
	isfarming varchar(10) NULL, -- 是否涉农
	xwbz varchar(80) NULL, -- 小微备注
	farmorg varchar(50) NULL, -- 所属专合组织名称
	industrialadjust varchar(10) NULL, -- 产业结构调整类型
	industrialupgrading varchar(10) NULL, -- 是否工业转型升级行业
	newindustry varchar(10) NULL, -- 战略新兴产业类型
	firstdrawingterm int4 NULL, -- 首笔提款期
	enddrawingterm int4 NULL, -- 最晚提款期
	enddrawingdate varchar(10) NULL, -- 最晚提款日
	reauditterm int4 NULL, -- 额度下次重审期限
	reauditdate varchar(10) NULL, -- 额度下次重审日
	yz varchar(2) NULL, -- 是否移植数据
	redeclare varchar(10) NULL, -- 是否重新申报额度
	businesssum1 numeric(24, 6) NULL, -- 个人住宅按揭额度
	businesssum2 numeric(24, 6) NULL, -- 个人营业用房按揭额度
	relaserialno varchar(32) NULL, -- 关联流水号
	bridlemark varchar(4000) NULL, -- 审贷约束条件
	linetype varchar(32) NULL, -- 授信条线
	ispolicyloan varchar(10) NULL, -- 是否保险贷款
	bankvouchtype varchar(18) NULL, -- 担保方式
	productid varchar(32) NULL, -- 产品编号
	isdiscount varchar(10) NULL, -- ISDISCOUNT
	vouchcompanybailaccount varchar(40) NULL, -- VOUCHCOMPANYBAILACCOUNT
	oldputoutdate varchar(20) NULL, -- 原始发放时间
	approveuser varchar(18) NULL, -- APPROVEUSER
	imagebatchno varchar(90) NULL, -- 影像批次号
	oldoccurtype varchar(18) NULL, -- 原发生方式
	oldapplytype varchar(18) NULL, -- 原申请类型
	finishuser varchar(32) NULL, -- 终批人
	channel varchar(20) NULL, -- 渠道号
	oldmaturity varchar(20) NULL, -- 原始到期日
	loanpersontype varchar(10) NULL, -- 借款人主体CodeNo:LoanPersonType
	graduatetype varchar(10) NULL, -- 高校毕业生类型CodeNo:GraduateType
	disabletype varchar(10) NULL, -- 是否残疾人
	femaleflag varchar(10) NULL, -- 是否女性人员
	greencredit varchar(15) NULL, -- 是否绿色贷款
	exposuresum numeric(24, 6) NULL
);
CREATE INDEX idx1_business_approve ON crmdm.cms_business_approve USING btree (customerid);
CREATE INDEX idx2_business_approve ON crmdm.cms_business_approve USING btree (businesstype);
CREATE INDEX idx3_business_approve ON crmdm.cms_business_approve USING btree (relativeserialno);
CREATE INDEX idx4_business_approve ON crmdm.cms_business_approve USING btree (operateuserid, operateorgid);
CREATE INDEX idx6_business_approve ON crmdm.cms_business_approve USING btree (operateorgid);
COMMENT ON TABLE crmdm.cms_business_approve IS '业务批准信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_approve.serialno IS '流水号字段';
COMMENT ON COLUMN crmdm.cms_business_approve.relativeserialno IS '关联流水号字段';
COMMENT ON COLUMN crmdm.cms_business_approve.occurdate IS '发生日期';
COMMENT ON COLUMN crmdm.cms_business_approve.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_business_approve.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_business_approve.businesstype IS '业务品种';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssubtype IS '保理类型';
COMMENT ON COLUMN crmdm.cms_business_approve.occurtype IS '发生类型';
COMMENT ON COLUMN crmdm.cms_business_approve.currenylist IS '其他可融通币种表';
COMMENT ON COLUMN crmdm.cms_business_approve.currencymode IS '汇率计算模式';
COMMENT ON COLUMN crmdm.cms_business_approve.businesstypelist IS '可混用品种表';
COMMENT ON COLUMN crmdm.cms_business_approve.calculatemode IS '金额占用计算模式';
COMMENT ON COLUMN crmdm.cms_business_approve.useorglist IS '额度可使用机构范围';
COMMENT ON COLUMN crmdm.cms_business_approve.flowreduceflag IS '额度是否简化审批流程';
COMMENT ON COLUMN crmdm.cms_business_approve.contractflag IS '是否使用额度';
COMMENT ON COLUMN crmdm.cms_business_approve.subcontractflag IS '额度下业务是否需要签署合同';
COMMENT ON COLUMN crmdm.cms_business_approve.selfuseflag IS '自用额度';
COMMENT ON COLUMN crmdm.cms_business_approve.creditaggreement IS '额度协议流水号字段';
COMMENT ON COLUMN crmdm.cms_business_approve.relativeagreement IS '额度品种';
COMMENT ON COLUMN crmdm.cms_business_approve.loanflag IS '是否可直接申请出账';
COMMENT ON COLUMN crmdm.cms_business_approve.totalsum IS '展期前金额';
COMMENT ON COLUMN crmdm.cms_business_approve.ourrole IS '额度控制类型';
COMMENT ON COLUMN crmdm.cms_business_approve.reversibility IS '有无追索权';
COMMENT ON COLUMN crmdm.cms_business_approve.billnum IS '票据数量';
COMMENT ON COLUMN crmdm.cms_business_approve.housetype IS '房产类型';
COMMENT ON COLUMN crmdm.cms_business_approve.lctermtype IS '信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_approve.riskattribute IS '风险类型';
COMMENT ON COLUMN crmdm.cms_business_approve.suretype IS '运单种类';
COMMENT ON COLUMN crmdm.cms_business_approve.safeguardtype IS '保函类型';
COMMENT ON COLUMN crmdm.cms_business_approve.creditbusiness IS '单项额度指定品种';
COMMENT ON COLUMN crmdm.cms_business_approve.businesscurrency IS '业务品种';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssum IS '金额';
COMMENT ON COLUMN crmdm.cms_business_approve.businessprop IS '贷款成数';
COMMENT ON COLUMN crmdm.cms_business_approve.termyear IS '期限';
COMMENT ON COLUMN crmdm.cms_business_approve.termmonth IS '期限';
COMMENT ON COLUMN crmdm.cms_business_approve.termday IS '期限';
COMMENT ON COLUMN crmdm.cms_business_approve.lgterm IS '远期天数';
COMMENT ON COLUMN crmdm.cms_business_approve.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_approve.baserate IS '基准年利率';
COMMENT ON COLUMN crmdm.cms_business_approve.ratefloattype IS '利率浮动方式';
COMMENT ON COLUMN crmdm.cms_business_approve.ratefloat IS '利率浮动值';
COMMENT ON COLUMN crmdm.cms_business_approve.businessrate IS '执行月利率';
COMMENT ON COLUMN crmdm.cms_business_approve.ictype IS '收费方式';
COMMENT ON COLUMN crmdm.cms_business_approve.iccyc IS '计息周期';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgratio IS '手续费率';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgsum IS '手续费金额';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgpaymethod IS '手续费支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.pdgpayperiod IS '收费周期';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeeratio IS '承诺费率';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeesum IS '承诺费';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeeperiod IS '承诺费计收期';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeebegin IS '承诺费计收起始日';
COMMENT ON COLUMN crmdm.cms_business_approve.mfeeratio IS '管理费率';
COMMENT ON COLUMN crmdm.cms_business_approve.mfeesum IS '管理费金额';
COMMENT ON COLUMN crmdm.cms_business_approve.mfeepaymethod IS '管理费支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.agentfee IS '代理费/单据处理费（元）';
COMMENT ON COLUMN crmdm.cms_business_approve.dealfee IS '银行费用';
COMMENT ON COLUMN crmdm.cms_business_approve.totalcast IS '总成本';
COMMENT ON COLUMN crmdm.cms_business_approve.discountinterest IS '贴现利息';
COMMENT ON COLUMN crmdm.cms_business_approve.purchaserinterest IS '买房应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_approve.bargainorinterest IS '卖方应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_approve.discountsum IS '实付贴现金额';
COMMENT ON COLUMN crmdm.cms_business_approve.bailratio IS '保证金比例/要求保证金比例(%)';
COMMENT ON COLUMN crmdm.cms_business_approve.bailcurrency IS '保证金币种';
COMMENT ON COLUMN crmdm.cms_business_approve.bailsum IS '保证金金额/要求保证金金额';
COMMENT ON COLUMN crmdm.cms_business_approve.bailaccount IS '保证金账号';
COMMENT ON COLUMN crmdm.cms_business_approve.fineratetype IS '罚息利率类型';
COMMENT ON COLUMN crmdm.cms_business_approve.finerate IS '垫款利率';
COMMENT ON COLUMN crmdm.cms_business_approve.drawingtype IS '提款方式';
COMMENT ON COLUMN crmdm.cms_business_approve.firstdrawingdate IS '首次提款日';
COMMENT ON COLUMN crmdm.cms_business_approve.drawingperiod IS '提款期限';
COMMENT ON COLUMN crmdm.cms_business_approve.paytimes IS '还款期数';
COMMENT ON COLUMN crmdm.cms_business_approve.paycyc IS '还本付息方式';
COMMENT ON COLUMN crmdm.cms_business_approve.graceperiod IS '贷款宽限期';
COMMENT ON COLUMN crmdm.cms_business_approve.overdraftperiod IS '连续透支期';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcno IS '信用证编号';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlctermtype IS '原信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_approve.remitmode IS '汇款方式';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcsum IS '原信用证金额';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcloadingdate IS '信用证装期';
COMMENT ON COLUMN crmdm.cms_business_approve.oldlcvaliddate IS '信用证效期';
COMMENT ON COLUMN crmdm.cms_business_approve.direction IS '行业投向';
COMMENT ON COLUMN crmdm.cms_business_approve.purpose IS '用途';
COMMENT ON COLUMN crmdm.cms_business_approve.planallocation IS '用款计划';
COMMENT ON COLUMN crmdm.cms_business_approve.immediacypaysource IS '重组条件（直接还款来源）';
COMMENT ON COLUMN crmdm.cms_business_approve.paysource IS '还款来源';
COMMENT ON COLUMN crmdm.cms_business_approve.corpuspaymethod IS '还款方式';
COMMENT ON COLUMN crmdm.cms_business_approve.interestpaymethod IS '利息支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdparty1 IS '承兑人名称';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyid1 IS '房屋详址';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdparty2 IS '开发商资质等级';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyid2 IS '受益人所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdparty3 IS '议付行/寄单行';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyid3 IS '最高成数';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyregion IS '所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyaccounts IS '单据号';
COMMENT ON COLUMN crmdm.cms_business_approve.cargoinfo IS '进口货物名称';
COMMENT ON COLUMN crmdm.cms_business_approve.projectname IS '项目名称';
COMMENT ON COLUMN crmdm.cms_business_approve.operationinfo IS '房产地址';
COMMENT ON COLUMN crmdm.cms_business_approve.contextinfo IS '提款说明';
COMMENT ON COLUMN crmdm.cms_business_approve.securitiestype IS '有价证券类型';
COMMENT ON COLUMN crmdm.cms_business_approve.securitiesregion IS '有价证券发行地';
COMMENT ON COLUMN crmdm.cms_business_approve.constructionarea IS '建筑面积';
COMMENT ON COLUMN crmdm.cms_business_approve.usearea IS '面积';
COMMENT ON COLUMN crmdm.cms_business_approve.flag1 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_approve.flag2 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_approve.flag3 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_approve.tradecontractno IS '相关贸易合同号码';
COMMENT ON COLUMN crmdm.cms_business_approve.invoiceno IS '发票号';
COMMENT ON COLUMN crmdm.cms_business_approve.tradecurrency IS '贸易合同币种';
COMMENT ON COLUMN crmdm.cms_business_approve.tradesum IS '贸易合同金额';
COMMENT ON COLUMN crmdm.cms_business_approve.paymentdate IS '票据查询、回复日期';
COMMENT ON COLUMN crmdm.cms_business_approve.operationmode IS '业务处理方式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchclass IS '担保形式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchtype IS '主要担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchtype1 IS '其他担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchtype2 IS '担保方式2';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchflag IS '有无其他担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.warrantor IS '担保人';
COMMENT ON COLUMN crmdm.cms_business_approve.warrantorid IS '担保人编号';
COMMENT ON COLUMN crmdm.cms_business_approve.othercondition IS '其他条件和要求';
COMMENT ON COLUMN crmdm.cms_business_approve.guarantyvalue IS '担保总价值';
COMMENT ON COLUMN crmdm.cms_business_approve.guarantyrate IS '担保率';
COMMENT ON COLUMN crmdm.cms_business_approve.baseevaluateresult IS '基期信用等级';
COMMENT ON COLUMN crmdm.cms_business_approve.riskrate IS '综合风险度';
COMMENT ON COLUMN crmdm.cms_business_approve.lowrisk IS '是否低风险业务';
COMMENT ON COLUMN crmdm.cms_business_approve.otherarealoan IS '是否异地业务';
COMMENT ON COLUMN crmdm.cms_business_approve.lowriskbailsum IS '低风险担保金额';
COMMENT ON COLUMN crmdm.cms_business_approve.originalputoutdate IS '首次放款日期';
COMMENT ON COLUMN crmdm.cms_business_approve.extendtimes IS '展期次数';
COMMENT ON COLUMN crmdm.cms_business_approve.lngotimes IS '借新还旧次数';
COMMENT ON COLUMN crmdm.cms_business_approve.golntimes IS '还旧借新次数';
COMMENT ON COLUMN crmdm.cms_business_approve.drtimes IS '债务重组次数';
COMMENT ON COLUMN crmdm.cms_business_approve.baseclassifyresult IS '基期分类结果';
COMMENT ON COLUMN crmdm.cms_business_approve.applytype IS '申请类型';
COMMENT ON COLUMN crmdm.cms_business_approve.bailrate IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_approve.finishorg IS '终批机构';
COMMENT ON COLUMN crmdm.cms_business_approve.describe1 IS '宽限期期数';
COMMENT ON COLUMN crmdm.cms_business_approve.operateorgid IS '经办机构';
COMMENT ON COLUMN crmdm.cms_business_approve.operateuserid IS '经办人';
COMMENT ON COLUMN crmdm.cms_business_approve.operatedate IS '经办日期';
COMMENT ON COLUMN crmdm.cms_business_approve.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_business_approve.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_business_approve.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_business_approve.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_business_approve.pigeonholedate IS '归档日期';
COMMENT ON COLUMN crmdm.cms_business_approve.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_business_approve.paycurrency IS '单据币种';
COMMENT ON COLUMN crmdm.cms_business_approve.paydate IS '装期';
COMMENT ON COLUMN crmdm.cms_business_approve.flag4 IS '交单方式';
COMMENT ON COLUMN crmdm.cms_business_approve.fundsource IS '资金来源';
COMMENT ON COLUMN crmdm.cms_business_approve.operatetype IS '操作方式';
COMMENT ON COLUMN crmdm.cms_business_approve.approvetype IS '最终审批意见类型';
COMMENT ON COLUMN crmdm.cms_business_approve.cycleflag IS '是否循环';
COMMENT ON COLUMN crmdm.cms_business_approve.classifyresult IS '当前风险分类结果';
COMMENT ON COLUMN crmdm.cms_business_approve.classifydate IS '风险分类日期';
COMMENT ON COLUMN crmdm.cms_business_approve.classifyfrequency IS '检查频率';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchnewflag IS '是否新增担保';
COMMENT ON COLUMN crmdm.cms_business_approve.adjustratetype IS '利率调整方式/宽限期还款法';
COMMENT ON COLUMN crmdm.cms_business_approve.adjustrateterm IS '利率调整日月数';
COMMENT ON COLUMN crmdm.cms_business_approve.rateadjustcyc IS '利率调整周期';
COMMENT ON COLUMN crmdm.cms_business_approve.fzanbalance IS '单据金额';
COMMENT ON COLUMN crmdm.cms_business_approve.acceptinttype IS '收息类型';
COMMENT ON COLUMN crmdm.cms_business_approve.ratio IS '押汇比例';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyadd1 IS '首付金额';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyzip1 IS '首付比例';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyadd2 IS '首付款来源';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyzip2 IS '按揭贷款成数';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyadd3 IS '发运地';
COMMENT ON COLUMN crmdm.cms_business_approve.thirdpartyzip3 IS '进口许可证(批文)编号';
COMMENT ON COLUMN crmdm.cms_business_approve.effectarea IS '交货地';
COMMENT ON COLUMN crmdm.cms_business_approve.termdate1 IS '到期日';
COMMENT ON COLUMN crmdm.cms_business_approve.termdate2 IS '交单期';
COMMENT ON COLUMN crmdm.cms_business_approve.termdate3 IS '申请开证日期';
COMMENT ON COLUMN crmdm.cms_business_approve.fixcyc IS '固定周期';
COMMENT ON COLUMN crmdm.cms_business_approve.describe2 IS '宽限期付息方法';
COMMENT ON COLUMN crmdm.cms_business_approve.approveopinion IS '最终审批意见';
COMMENT ON COLUMN crmdm.cms_business_approve.tempsaveflag IS '暂存标志';
COMMENT ON COLUMN crmdm.cms_business_approve.approvedate IS '批复日期';
COMMENT ON COLUMN crmdm.cms_business_approve.flag5 IS '关联状态';
COMMENT ON COLUMN crmdm.cms_business_approve.creditcycle IS '是否循环';
COMMENT ON COLUMN crmdm.cms_business_approve.guarantyflag IS '征信担保标志';
COMMENT ON COLUMN crmdm.cms_business_approve.executeyearrate IS '执行年利率';
COMMENT ON COLUMN crmdm.cms_business_approve.paysourcen IS '还款来源';
COMMENT ON COLUMN crmdm.cms_business_approve.returnfrequency IS '还款频率';
COMMENT ON COLUMN crmdm.cms_business_approve.backfrequency IS '还息频率';
COMMENT ON COLUMN crmdm.cms_business_approve.ishostbank IS '银团贷款我行是否主办行';
COMMENT ON COLUMN crmdm.cms_business_approve.havepayplan IS '是否设定还款计划表';
COMMENT ON COLUMN crmdm.cms_business_approve.ipcode IS '还息频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_approve.frcode IS '还款频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_approve.paysourcedetail IS '还款来源说明';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssource IS '业务渠道';
COMMENT ON COLUMN crmdm.cms_business_approve.barcode IS '条形码';
COMMENT ON COLUMN crmdm.cms_business_approve.creditmethod IS '授信模式';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum1 IS '名义金额1';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum2 IS '名义金额2';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum3 IS '名义金额3';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum4 IS '名义金额4';
COMMENT ON COLUMN crmdm.cms_business_approve.titularsum5 IS '名义金额5';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum1 IS '敞口金额1';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum2 IS '敞口金额2';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum3 IS '敞口金额3';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum4 IS '敞口金额4';
COMMENT ON COLUMN crmdm.cms_business_approve.exposuresum5 IS '敞口金额5';
COMMENT ON COLUMN crmdm.cms_business_approve.overagesum1 IS '敞口余额1';
COMMENT ON COLUMN crmdm.cms_business_approve.overagesum2 IS '敞口余额2';
COMMENT ON COLUMN crmdm.cms_business_approve.overagesum3 IS '敞口余额3';
COMMENT ON COLUMN crmdm.cms_business_approve.operateuserid1 IS '辅办客户经理';
COMMENT ON COLUMN crmdm.cms_business_approve.reapply IS '复议标志(Code:ReApply)';
COMMENT ON COLUMN crmdm.cms_business_approve.usedepositpile IS '存款积数';
COMMENT ON COLUMN crmdm.cms_business_approve.depositpilesum IS '本次所使用存款积数';
COMMENT ON COLUMN crmdm.cms_business_approve.preappno IS '预审号';
COMMENT ON COLUMN crmdm.cms_business_approve.direction1 IS '本行行业分类';
COMMENT ON COLUMN crmdm.cms_business_approve.billtype IS '票据类型';
COMMENT ON COLUMN crmdm.cms_business_approve.basebusinesstype IS '基础产品';
COMMENT ON COLUMN crmdm.cms_business_approve.investedcapital IS '项目总投资额';
COMMENT ON COLUMN crmdm.cms_business_approve.promisesfeetype IS '承诺费支付方式';
COMMENT ON COLUMN crmdm.cms_business_approve.issuetype IS '签发类型';
COMMENT ON COLUMN crmdm.cms_business_approve.issuebankname IS '代签银行名称';
COMMENT ON COLUMN crmdm.cms_business_approve.isinsurance IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_approve.extend IS '单价（元/平米）';
COMMENT ON COLUMN crmdm.cms_business_approve.extend1 IS '购房合同号';
COMMENT ON COLUMN crmdm.cms_business_approve.businessloantype IS '贷款类型';
COMMENT ON COLUMN crmdm.cms_business_approve.extend3 IS '目前客户名下房屋数量';
COMMENT ON COLUMN crmdm.cms_business_approve.extend4 IS '借款人月收入';
COMMENT ON COLUMN crmdm.cms_business_approve.approveartificialno IS '批复文本号';
COMMENT ON COLUMN crmdm.cms_business_approve.isfarming IS '是否涉农';
COMMENT ON COLUMN crmdm.cms_business_approve.xwbz IS '小微备注';
COMMENT ON COLUMN crmdm.cms_business_approve.farmorg IS '所属专合组织名称';
COMMENT ON COLUMN crmdm.cms_business_approve.industrialadjust IS '产业结构调整类型';
COMMENT ON COLUMN crmdm.cms_business_approve.industrialupgrading IS '是否工业转型升级行业';
COMMENT ON COLUMN crmdm.cms_business_approve.newindustry IS '战略新兴产业类型';
COMMENT ON COLUMN crmdm.cms_business_approve.firstdrawingterm IS '首笔提款期';
COMMENT ON COLUMN crmdm.cms_business_approve.enddrawingterm IS '最晚提款期';
COMMENT ON COLUMN crmdm.cms_business_approve.enddrawingdate IS '最晚提款日';
COMMENT ON COLUMN crmdm.cms_business_approve.reauditterm IS '额度下次重审期限';
COMMENT ON COLUMN crmdm.cms_business_approve.reauditdate IS '额度下次重审日';
COMMENT ON COLUMN crmdm.cms_business_approve.yz IS '是否移植数据';
COMMENT ON COLUMN crmdm.cms_business_approve.redeclare IS '是否重新申报额度';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssum1 IS '个人住宅按揭额度';
COMMENT ON COLUMN crmdm.cms_business_approve.businesssum2 IS '个人营业用房按揭额度';
COMMENT ON COLUMN crmdm.cms_business_approve.relaserialno IS '关联流水号';
COMMENT ON COLUMN crmdm.cms_business_approve.bridlemark IS '审贷约束条件';
COMMENT ON COLUMN crmdm.cms_business_approve.linetype IS '授信条线';
COMMENT ON COLUMN crmdm.cms_business_approve.ispolicyloan IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_approve.bankvouchtype IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_approve.productid IS '产品编号';
COMMENT ON COLUMN crmdm.cms_business_approve.isdiscount IS 'ISDISCOUNT';
COMMENT ON COLUMN crmdm.cms_business_approve.vouchcompanybailaccount IS 'VOUCHCOMPANYBAILACCOUNT';
COMMENT ON COLUMN crmdm.cms_business_approve.oldputoutdate IS '原始发放时间';
COMMENT ON COLUMN crmdm.cms_business_approve.approveuser IS 'APPROVEUSER';
COMMENT ON COLUMN crmdm.cms_business_approve.imagebatchno IS '影像批次号';
COMMENT ON COLUMN crmdm.cms_business_approve.oldoccurtype IS '原发生方式';
COMMENT ON COLUMN crmdm.cms_business_approve.oldapplytype IS '原申请类型';
COMMENT ON COLUMN crmdm.cms_business_approve.finishuser IS '终批人';
COMMENT ON COLUMN crmdm.cms_business_approve.channel IS '渠道号';
COMMENT ON COLUMN crmdm.cms_business_approve.oldmaturity IS '原始到期日';
COMMENT ON COLUMN crmdm.cms_business_approve.loanpersontype IS '借款人主体CodeNo:LoanPersonType';
COMMENT ON COLUMN crmdm.cms_business_approve.graduatetype IS '高校毕业生类型CodeNo:GraduateType';
COMMENT ON COLUMN crmdm.cms_business_approve.disabletype IS '是否残疾人';
COMMENT ON COLUMN crmdm.cms_business_approve.femaleflag IS '是否女性人员';
COMMENT ON COLUMN crmdm.cms_business_approve.greencredit IS '是否绿色贷款';


-- crmdm.cms_business_contract 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_contract;

CREATE TABLE crmdm.cms_business_contract (
	serialno varchar(40) NOT NULL, -- 合同编号
	relativeserialno varchar(40) NULL, -- 关联流水号字段
	artificialno varchar(100) NULL, -- 文本合同编号
	occurdate varchar(10) NULL, -- 发生日期
	customerid varchar(32) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	businesstype varchar(18) NULL, -- 业务品种
	oldbusinesstype varchar(18) NULL, -- 老业务品种
	businesssubtype varchar(18) NULL, -- 信用证类型
	occurtype varchar(18) NULL, -- 发生类型
	creditdigest varchar(18) NULL, -- 额度是否融通
	creditcycle varchar(18) NULL, -- 是否循环
	credittype varchar(18) NULL, -- 额度品种
	currenylist varchar(18) NULL, -- 其他可融通币种表
	currencymode varchar(18) NULL, -- 汇率计算模式
	businesstypelist varchar(18) NULL, -- 可混用品种表
	calculatemode varchar(18) NULL, -- 金额占用计算模式
	useorglist varchar(18) NULL, -- 额度可使用机构范围
	flowreduceflag varchar(18) NULL, -- 额度是否简化审批流程
	contractflag varchar(18) NULL, -- 是否使用额度
	subcontractflag varchar(18) NULL, -- 项下业务是否签署合同
	selfuseflag varchar(18) NULL, -- 自用额度
	creditindex numeric(10, 6) NULL, -- 额度占用系数
	creditreducesum numeric(24, 6) NULL, -- 额度扣减金额
	limitationterm varchar(10) NULL, -- 额度使用最迟日期
	useterm varchar(10) NULL, -- 到期日期
	creditaggreement varchar(32) NULL, -- 额度协议流水号字段
	relativeagreement varchar(4000) NULL, -- 额度品种
	loanflag varchar(18) NULL, -- 是否可直接申请出账
	totalsum numeric(24, 6) NULL, -- 总金额
	ourrole varchar(18) NULL, -- 额度控制类型
	reversibility varchar(18) NULL, -- 有无追索权
	billnum numeric NULL, -- 票据数量
	housetype varchar(18) NULL, -- 房产类型
	lctermtype varchar(18) NULL, -- 信用证期限类型
	riskattribute varchar(18) NULL, -- 风险类型
	suretype varchar(18) NULL, -- 运单种类
	safeguardtype varchar(18) NULL, -- 保函类型
	creditbusiness varchar(18) NULL, -- 单项额度指定品种
	businesscurrency varchar(18) NULL, -- 币种
	businesssum numeric(24, 6) NULL, -- 合同金额
	businessprop numeric(10, 6) NULL, -- 贷款成数
	termyear numeric NULL, -- 期限（年）
	termmonth numeric NULL, -- 期限
	termday numeric NULL, -- 期限
	lgterm numeric NULL, -- 远期天数
	baseratetype varchar(18) NULL, -- 基准利率类型
	baserate numeric(10, 6) NULL, -- 基准年利率
	ratefloattype varchar(18) NULL, -- 利率浮动方式
	ratefloat numeric(10, 6) NULL, -- 利率浮动值
	businessrate numeric(10, 6) NULL, -- 执行月利率
	ictype varchar(18) NULL, -- 收费方式
	iccyc varchar(18) NULL, -- 计息周期
	pdgratio numeric(10, 6) NULL, -- 费率
	pdgsum numeric(24, 6) NULL, -- 手续费金额
	pdgpaymethod varchar(18) NULL, -- 手续费支付方式
	pdgpayperiod varchar(18) NULL, -- 收费周期
	promisesfeeratio numeric(10, 6) NULL, -- 承诺费率
	promisesfeesum numeric(24, 6) NULL, -- 承诺费
	promisesfeeperiod numeric NULL, -- 承诺费计收期
	promisesfeebegin varchar(10) NULL, -- 承诺费计收起始日
	mfeeratio numeric(10, 6) NULL, -- 管理费率
	mfeesum numeric(24, 6) NULL, -- 管理费金额
	mfeepaymethod varchar(18) NULL, -- 管理费支付方式
	agentfee numeric(24, 6) NULL, -- 代理费
	dealfee numeric(24, 6) NULL, -- 银行费用
	totalcast numeric(24, 6) NULL, -- 总成本
	discountinterest numeric(24, 6) NULL, -- 贴现利息
	purchaserinterest numeric(24, 6) NULL, -- 买方应付贴现利息
	bargainorinterest numeric(24, 6) NULL, -- 卖方应付贴现利息
	discountsum numeric(24, 6) NULL, -- 贴现金额
	bailratio numeric(10, 6) NULL, -- 保证金比例
	bailcurrency varchar(18) NULL, -- 保证金币种
	bailsum numeric(24, 6) NULL, -- 保证金金额
	bailaccount varchar(80) NULL, -- 保证金账号
	fineratetype varchar(18) NULL, -- 罚息利率类型
	finerate numeric(10, 6) NULL, -- 垫款利率
	drawingtype varchar(18) NULL, -- 提款方式
	firstdrawingdate varchar(10) NULL, -- 首次提款日
	drawingperiod numeric NULL, -- 提款期限
	paytimes numeric NULL, -- 还款期数
	paycyc varchar(18) NULL, -- 还本付息方式
	graceperiod numeric NULL, -- 贷款宽限期
	overdraftperiod numeric NULL, -- 连续透支期
	oldlcno varchar(32) NULL, -- 信用证编号
	oldlctermtype varchar(18) NULL, -- 原信用证期限类型
	remitmode varchar(18) NULL, -- 汇款方式
	oldlcsum numeric(24, 6) NULL, -- 原信用证金额"
	oldlcloadingdate varchar(10) NULL, -- 装运日期
	oldlcvaliddate varchar(10) NULL, -- 信用证效期
	direction varchar(18) NULL, -- 行业投向
	purpose varchar(2000) NULL, -- 用途
	planallocation varchar(200) NULL, -- 用款计划
	immediacypaysource varchar(200) NULL, -- 直接还款来源
	paysource varchar(200) NULL, -- 还款说明
	corpuspaymethod varchar(18) NULL, -- 还款方式
	interestpaymethod varchar(18) NULL, -- 利息支付方式
	putoutdate varchar(10) NULL, -- 起始日期
	maturity varchar(10) NULL, -- 到期日期
	thirdparty1 varchar(200) NULL, -- 承兑人名称
	thirdpartyid1 varchar(32) NULL, -- 房屋详址
	thirdparty2 varchar(200) NULL, -- 开发商资质等级
	thirdpartyid2 varchar(32) NULL, -- 受益人所在国家或地区
	thirdparty3 varchar(200) NULL, -- 议付行/寄单行
	thirdpartyid3 varchar(100) NULL, -- 最高成数
	thirdpartyregion varchar(18) NULL, -- 所在国家或地区
	thirdpartyaccounts varchar(32) NULL, -- 委托单位账号
	cargoinfo varchar(80) NULL, -- 进口货物名称
	projectname varchar(80) NULL, -- 项目编号
	operationinfo varchar(400) NULL, -- 参与行情况
	contextinfo varchar(200) NULL, -- 提款说明
	securitiestype varchar(18) NULL, -- 有价证券类型
	securitiesregion varchar(18) NULL, -- 有价证券发行地
	constructionarea numeric(24, 6) NULL, -- 建筑面积
	usearea numeric(24, 6) NULL, -- 使用面积
	flag1 varchar(18) NULL, -- FLAG1
	flag2 varchar(18) NULL, -- FLAG2
	flag3 varchar(18) NULL, -- FLAG3
	tradecontractno varchar(32) NULL, -- 贸易合同号
	invoiceno varchar(32) NULL, -- 增值税发票
	tradecurrency varchar(18) NULL, -- 贸易合同币种
	tradesum numeric(24, 6) NULL, -- 贸易金额
	lcno varchar(32) NULL, -- 信用证编号
	paymentdate varchar(10) NULL, -- 票据查询、回复日期
	operationmode varchar(18) NULL, -- 业务处理方式
	begindate varchar(10) NULL, -- 额度生效日
	enddate varchar(10) NULL, -- 拆借到期日
	vouchclass varchar(18) NULL, -- 担保形式
	vouchtype varchar(18) NULL, -- 主要担保方式
	vouchtype1 varchar(18) NULL, -- 担保方式
	vouchtype2 varchar(18) NULL, -- 担保方式2
	vouchflag varchar(18) NULL, -- 有无其他担保方式
	warrantor varchar(80) NULL, -- 主要担保人
	warrantorid varchar(32) NULL, -- 主要担保人ID
	othercondition varchar(400) NULL, -- 其他条件和要求
	guarantyvalue numeric(24, 6) NULL, -- 担保总价值
	guarantyrate numeric(10, 6) NULL, -- 抵质押率
	baseevaluateresult varchar(18) NULL, -- 基期信用等级
	riskrate numeric(24, 6) NULL, -- 综合风险度
	lowrisk varchar(18) NULL, -- 是否低风险业务
	otherarealoan varchar(18) NULL, -- 是否异地业务
	lowriskbailsum numeric(24, 6) NULL, -- 低风险担保金额
	applytype varchar(18) NULL, -- 申请类型
	originalputoutdate varchar(10) NULL, -- 首次放款日期
	extendtimes numeric NULL, -- 展期次数
	lngotimes numeric NULL, -- 借新还旧次数
	golntimes numeric NULL, -- 还旧借新次数
	drtimes numeric NULL, -- 债务重组次数
	guarantyno varchar(32) NULL, -- 抵质押编号
	putoutsum numeric(24, 6) NULL, -- 放款金额(原币)
	actualputoutsum numeric(24, 6) NULL, -- 实际出账金额
	balance numeric(24, 6) NULL, -- 总余额
	normalbalance numeric(24, 6) NULL, -- 正常余额
	overduebalance numeric(24, 6) NULL, -- 逾期/垫款金额
	dullbalance numeric(24, 6) NULL, -- 呆滞余额
	badbalance numeric(24, 6) NULL, -- 呆账余额
	interestbalance1 numeric(24, 6) NULL, -- 表内欠息
	interestbalance2 numeric(24, 6) NULL, -- 表外欠息余额
	finebalance1 numeric(24, 6) NULL, -- 本金罚息
	finebalance2 numeric(24, 6) NULL, -- 利息罚息
	overduedays numeric NULL, -- 逾期天数
	oweinterestdays numeric NULL, -- 欠息天数
	tabalance numeric(24, 6) NULL, -- 分期业务欠本金
	tainterestbalance numeric(24, 6) NULL, -- 分期业务欠利息
	tatimes numeric NULL, -- 累计欠款期数
	lcatimes numeric(24, 6) NULL, -- 连续欠款期数
	pbinterestsum numeric(24, 6) NULL, -- 累计收回利息
	pbmfeesum numeric(24, 6) NULL, -- 累计收回管理费
	pbpdgsum numeric(24, 6) NULL, -- 累计收回手续费
	pblegalcostsum numeric(24, 6) NULL, -- 累计收回诉讼费
	polegalcostsum numeric(24, 6) NULL, -- 累计付出诉讼费
	originalbaddate varchar(10) NULL, -- 首次认定不良日期
	baseclassifyresult varchar(18) NULL, -- 基期风险分类结果
	classifyresult varchar(80) NULL, -- 当前风险分类结果
	classifytype varchar(18) NULL, -- 最新风险分类方式
	classifydate varchar(10) NULL, -- 风险分类日期
	classifyorgid varchar(32) NULL, -- 分类认定机构
	reservesum numeric(24, 6) NULL, -- 计提准备金额
	expectlosssum numeric(24, 6) NULL, -- 预测损失金额
	bailrate numeric(24, 6) NULL, -- 保证金比率
	finishorg varchar(18) NULL, -- 批复机构
	finishtype varchar(18) NULL, -- 终结类型
	finishdate varchar(10) NULL, -- 终结日期
	describe1 varchar(100) NULL, -- 宽限期期数
	reinforceflag varchar(18) NULL, -- 补登标志
	manageorgid varchar(32) NULL, -- 贷后管理机构
	manageuserid varchar(32) NULL, -- 贷后管理人员
	recoveryorgid varchar(32) NULL, -- 保全管理机构
	recoveryuserid varchar(32) NULL, -- 保全管理人
	statorgid varchar(32) NULL, -- 成本中心机构名称
	statuserid varchar(32) NULL, -- 当前统计人
	operateorgid varchar(32) NULL, -- 经办机构
	operateuserid varchar(32) NULL, -- 经办人
	operatedate varchar(10) NULL, -- 经办时间
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	pigeonholedate varchar(10) NULL, -- 归档日期
	remark varchar(400) NULL, -- 备注
	flag4 varchar(18) NULL, -- 交单方式
	paycurrency varchar(18) NULL, -- 单据币种
	paydate varchar(10) NULL, -- 装期
	flag5 varchar(18) NULL, -- 转建行标志
	classifysum1 numeric(24, 6) NULL, -- 最新分类正常金额
	classifysum2 numeric(24, 6) NULL, -- 最新分类关注金额
	classifysum3 numeric(24, 6) NULL, -- 最新分类次级金额
	classifysum4 numeric(24, 6) NULL, -- 最新分类可疑金额
	classifysum5 numeric(24, 6) NULL, -- 最新分类损失金额
	shifttype varchar(18) NULL, -- 移交类型
	operatetype varchar(18) NULL, -- 操作方式
	fundsource varchar(18) NULL, -- 资金来源
	cycleflag varchar(18) NULL, -- 循环标志
	creditfreezeflag varchar(18) NULL, -- 额度是否冻结
	shiftbalance numeric(24, 6) NULL, -- 移交余额
	classifyfrequency numeric NULL, -- 检查频率
	classifylevel varchar(18) NULL, -- 当前认定人员角色
	vouchnewflag varchar(18) NULL, -- 是否新增担保
	actualartificialno varchar(32) NULL, -- 实际合同号
	deleteflag varchar(18) NULL, -- 合并标志
	accountno varchar(32) NULL, -- 结算账号
	loanaccountno varchar(32) NULL, -- 贷款入账账号
	secondpayaccount varchar(32) NULL, -- 第二还款账号
	adjustratetype varchar(18) NULL, -- 利率调整方式
	adjustrateterm varchar(18) NULL, -- 利率调整日月数
	overinttype varchar(18) NULL, -- 逾期计息方式
	rateadjustcyc varchar(18) NULL, -- 利率调整周期
	pdgaccountno varchar(32) NULL, -- 手续费支出帐号
	deductdate varchar(10) NULL, -- 扣款日期
	fzanbalance numeric(24, 6) NULL, -- 到单金额
	acceptinttype varchar(18) NULL, -- 贴现付息方式
	ratio numeric(24, 6) NULL, -- 比例
	thirdpartyadd1 varchar(80) NULL, -- 首付金额
	thirdpartyzip1 varchar(32) NULL, -- 首付比例
	thirdpartyadd2 varchar(80) NULL, -- 首付款来源
	thirdpartyzip2 varchar(32) NULL, -- 按揭贷款成数
	thirdpartyadd3 varchar(80) NULL, -- 发运地
	thirdpartyzip3 varchar(80) NULL, -- 进口许可证(批文)编号
	effectarea varchar(18) NULL, -- 交货地
	termdate1 varchar(10) NULL, -- 期限
	termdate2 varchar(10) NULL, -- 交单期
	termdate3 varchar(10) NULL, -- 申请开证日期
	fixcyc numeric NULL, -- 固定周期
	describe2 varchar(100) NULL, -- 宽限期付息方法
	cancelsum numeric(24, 6) NULL, -- 核销本金
	cancelinterest numeric(24, 6) NULL, -- 核销利息
	loanterm varchar(18) NULL, -- 期限
	putoutorgid varchar(32) NULL, -- 放贷机构
	tempsaveflag varchar(18) NULL, -- 暂存标志
	overduedate varchar(10) NULL, -- 逾期日期
	oweinterestdate varchar(10) NULL, -- 欠息日期
	freezeflag varchar(2) NULL, -- 冻结标志
	approvedate varchar(10) NULL, -- 批复日期
	shiftstatus varchar(18) NULL, -- 不良资产移交状态
	recoverycognorgid varchar(32) NULL, -- 不良资产认定机构
	recoverycognuserid varchar(32) NULL, -- 不良资产认定人员
	shiftdocdescribe varchar(800) NULL, -- 不良资产移交文档清单
	guarantyflag varchar(18) NULL, -- 征信担保标志
	totalbalance numeric(24, 6) NULL, -- 剩余额度
	grouplineid varchar(40) NULL, -- 集团授信额度合同编号
	transformtimes numeric NULL, -- 变更次数
	transformflag varchar(1) NULL, -- 担保合同变更标志
	fundbackaccount varchar(32) NULL, -- 还款准备金账户
	requitalaccount varchar(32) NULL, -- 资金回笼账户
	paymentmode varchar(20) NULL, -- 支付方式
	executeyearrate numeric(10, 6) NULL, -- 执行年利率
	offsheetflag varchar(6) NULL, -- 表内外标志
	paysourcen varchar(18) NULL, -- 还款来源
	returnfrequency varchar(18) NULL, -- 还款频率
	backfrequency varchar(18) NULL, -- 还息频率
	paysourcedetail varchar(200) NULL, -- 还款来源说明
	ishostbank varchar(18) NULL, -- 银团贷款我行是否主办行
	lendaccountno varchar(32) NULL, -- 放款账号
	payaccountno varchar(32) NULL, -- 还款账号
	breachratio numeric(10, 6) NULL, -- 提前还款违约金比例（还款一年内）
	breachratio1 numeric(10, 6) NULL, -- 提前还款违约金比例（还款一年以上）
	havepayplan varchar(2) NULL, -- 是否设定还款计划表
	ipcode varchar(4) NULL, -- 还息频率（日或月）
	frcode varchar(4) NULL, -- 还款频率（日或月）
	breachfinetype varchar(40) NULL, -- 违约罚息方式
	businesssource varchar(6) NULL, -- 业务渠道
	barcode varchar(64) NULL, -- 条形码
	status varchar(32) NULL, -- 合同状态
	creditmethod varchar(18) NULL, -- 授信模式
	titularsum1 numeric(24, 6) NULL, -- 名义金额1
	titularsum2 numeric(24, 6) NULL, -- 名义金额2
	titularsum3 numeric(24, 6) NULL, -- 名义金额3
	titularsum4 numeric(24, 6) NULL, -- 名义金额4
	titularsum5 numeric(24, 6) NULL, -- 名义金额5
	exposuresum1 numeric(24, 6) NULL, -- 敞口金额1
	exposuresum2 numeric(24, 6) NULL, -- 敞口金额2
	exposuresum3 numeric(24, 6) NULL, -- 敞口金额3
	exposuresum4 numeric(24, 6) NULL, -- 敞口金额4
	exposuresum5 numeric(24, 6) NULL, -- 敞口金额5
	overagesum1 numeric(24, 6) NULL, -- 敞口余额1
	overagesum2 numeric(24, 6) NULL, -- 敞口余额2
	overagesum3 numeric(24, 6) NULL, -- 敞口余额3
	operateuserid1 varchar(32) NULL, -- 辅办客户经理
	reapply varchar(18) NULL, -- 复议标志(Code:ReApply)
	usedepositpile varchar(4) NULL, -- 存款积数
	depositpilesum numeric(24, 6) NULL, -- 本次所使用存款积数
	preappno varchar(32) NULL, -- 预审号
	direction1 varchar(18) NULL, -- 本行行业分类
	billtype varchar(4) NULL, -- 票据类型
	basebusinesstype varchar(18) NULL, -- 基础产品
	investedcapital numeric(24, 6) NULL, -- 项目总投资额
	promisesfeetype varchar(18) NULL, -- 承诺费支付方式
	issuetype varchar(20) NULL, -- 签发类型
	issuebankname varchar(90) NULL, -- 代签银行名称
	isinsurance varchar(4) NULL, -- 是否保险贷款
	extend numeric(24, 6) NULL, -- 单价（元/平米）
	extend1 varchar(80) NULL, -- 购房合同号
	businessloantype varchar(20) NULL, -- 贷款类型
	extend3 varchar(20) NULL, -- 目前客户名下房屋数量
	extend4 numeric(24, 6) NULL, -- 借款人月收入
	isfarming varchar(10) NULL, -- 是否涉农
	xwbz varchar(80) NULL, -- 小微备注
	farmorg varchar(50) NULL, -- 所属专合组织名称
	industrialadjust varchar(10) NULL, -- 产业结构调整类型
	industrialupgrading varchar(10) NULL, -- 是否工业转型升级行业
	newindustry varchar(10) NULL, -- 战略新兴产业类型
	firstdrawingterm numeric NULL, -- 首笔提款期
	enddrawingterm numeric NULL, -- 最晚提款期
	enddrawingdate varchar(10) NULL, -- 最晚提款日
	reauditterm numeric NULL, -- 额度下次重审期限
	reauditdate varchar(10) NULL, -- 额度下次重审日
	yz varchar(2) NULL, -- 是否移植数据
	isliquidity varchar(4) NULL, -- 流动资金贷款
	isfixed varchar(4) NULL, -- 固定资产贷款
	isproject varchar(4) NULL, -- 项目融资
	redeclare varchar(10) NULL, -- 是否重新申报额度
	businesssum1 numeric(24, 6) NULL, -- 个人住宅按揭额度
	businesssum2 numeric(24, 6) NULL, -- 个人营业用房按揭额度
	businessproduct varchar(40) NULL, -- 微贷业务产品
	relaserialno varchar(32) NULL, -- 关联流水号
	bridlemark varchar(2000) NULL, -- 审贷约束条件
	linetype varchar(32) NULL, -- 授信条线
	policynumber varchar(20) NULL, -- 保单号
	ispolicyloan varchar(10) NULL, -- 是否保险贷款
	bankvouchtype varchar(18) NULL, -- 担保方式
	isdiscount varchar(10) NULL, -- 属性5
	productid varchar(32) NULL, -- 产品编号
	vouchcompanybailaccount varchar(40) NULL, -- 属性3
	oldputoutdate varchar(20) NULL, -- 原始发放时间
	dealloan varchar(18) NULL, -- 是否经营类贷款
	approveuser varchar(18) NULL, -- 复核人
	paytype varchar(10) NULL, -- 转账标识
	imagebatchno varchar(90) NULL, -- 影像批次号
	oldoccurtype varchar(18) NULL, -- 原发生方式
	oldapplytype varchar(18) NULL, -- 原申请类型
	dutyfreecode varchar(2) NULL, -- 免税标识
	finishuser varchar(32) NULL, -- 终批人
	channel varchar(20) NULL, -- 渠道号
	oldmaturity varchar(20) NULL, -- 原始到期日
	loanpersontype varchar(10) NULL, -- 借款人主体CodeNo:LoanPersonType
	graduatetype varchar(10) NULL, -- 高校毕业生类型CodeNo:GraduateType
	disabletype varchar(10) NULL, -- 是否残疾人
	femaleflag varchar(10) NULL, -- 是否女性人员
	greencredit varchar(10) NULL, -- 是否绿色贷款
	firstloanflag varchar(2) NULL, -- 是否为首套住房贷款
	exposuresum numeric(24, 6) NULL, -- EXPOSURESUM
	ismicropro varchar(32) NOT NULL, -- 是否属于小微批量项目贷款
	microproname varchar(32) NULL, -- 小微批量项目名称
	financebailoutdelay varchar(20) NULL, -- 是否金融纾困延期
	financebailoutdelaymonths numeric NULL, -- 金融纾困延期月数
	creditpromise varchar(20) NULL, -- 授信承诺 CodeNo:CreditPromise
	iscultureindustry varchar(2) NULL, -- 是否文化产业
	isfirstloan varchar(2) NULL, -- 是否首次贷款
	exposuresumauto numeric NULL, -- EXPOSURESUMAUTO
	businesssumauto numeric NULL, -- BUSINESSSUMAUTO
	transno varchar(100) NULL, -- TRANSNO
	isregroup varchar(2) NULL, -- 是否重组贷款
	farmingindicator varchar(20) NULL, -- 涉农附报指标
	observedate varchar(10) NULL, -- 观察期
	czclassifyresult varchar(18) NULL, -- 重组贷款五级分类
	isenforce varchar(2) NULL, -- 是否赋强公证
	myareacode varchar(10) NULL, -- 绵阳一手房按揭区域代码
	isbatchguaranty varchar(2) NULL, -- 是否批量担保业务
	issueforms varchar(2) NULL, -- 开证方式
	gjspprj varchar(3) NULL, -- 个金专案项目
	intpaymode varchar(2) NULL, -- 利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)
	isspzy varchar(2) NULL, -- 是否商票质押 1=是 2=否
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_business_contract PRIMARY KEY (serialno)
);
CREATE INDEX idx11_business_contract ON crmdm.cms_business_contract USING btree (basebusinesstype);
CREATE INDEX idx12_business_contract ON crmdm.cms_business_contract USING btree (operateuserid1);
CREATE INDEX idx1_business_contract ON crmdm.cms_business_contract USING btree (customerid);
CREATE INDEX idx3_business_contract ON crmdm.cms_business_contract USING btree (relativeserialno);
CREATE INDEX idx4_business_contract ON crmdm.cms_business_contract USING btree (businesstype);
CREATE INDEX idx6_business_contract ON crmdm.cms_business_contract USING btree (manageorgid, manageuserid);
CREATE INDEX idx7_business_contract ON crmdm.cms_business_contract USING btree (creditaggreement);
CREATE INDEX idx8_business_contract ON crmdm.cms_business_contract USING btree (operateuserid, operateorgid);
CREATE INDEX idx9_business_contract ON crmdm.cms_business_contract USING btree (recoveryorgid, recoveryuserid);
COMMENT ON TABLE crmdm.cms_business_contract IS '业务合同信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_contract.serialno IS '合同编号';
COMMENT ON COLUMN crmdm.cms_business_contract.relativeserialno IS '关联流水号字段';
COMMENT ON COLUMN crmdm.cms_business_contract.artificialno IS '文本合同编号';
COMMENT ON COLUMN crmdm.cms_business_contract.occurdate IS '发生日期';
COMMENT ON COLUMN crmdm.cms_business_contract.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_business_contract.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_business_contract.businesstype IS '业务品种';
COMMENT ON COLUMN crmdm.cms_business_contract.oldbusinesstype IS '老业务品种';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssubtype IS '信用证类型';
COMMENT ON COLUMN crmdm.cms_business_contract.occurtype IS '发生类型';
COMMENT ON COLUMN crmdm.cms_business_contract.creditdigest IS '额度是否融通';
COMMENT ON COLUMN crmdm.cms_business_contract.creditcycle IS '是否循环';
COMMENT ON COLUMN crmdm.cms_business_contract.credittype IS '额度品种';
COMMENT ON COLUMN crmdm.cms_business_contract.currenylist IS '其他可融通币种表';
COMMENT ON COLUMN crmdm.cms_business_contract.currencymode IS '汇率计算模式';
COMMENT ON COLUMN crmdm.cms_business_contract.businesstypelist IS '可混用品种表';
COMMENT ON COLUMN crmdm.cms_business_contract.calculatemode IS '金额占用计算模式';
COMMENT ON COLUMN crmdm.cms_business_contract.useorglist IS '额度可使用机构范围';
COMMENT ON COLUMN crmdm.cms_business_contract.flowreduceflag IS '额度是否简化审批流程';
COMMENT ON COLUMN crmdm.cms_business_contract.contractflag IS '是否使用额度';
COMMENT ON COLUMN crmdm.cms_business_contract.subcontractflag IS '项下业务是否签署合同';
COMMENT ON COLUMN crmdm.cms_business_contract.selfuseflag IS '自用额度';
COMMENT ON COLUMN crmdm.cms_business_contract.creditindex IS '额度占用系数';
COMMENT ON COLUMN crmdm.cms_business_contract.creditreducesum IS '额度扣减金额';
COMMENT ON COLUMN crmdm.cms_business_contract.limitationterm IS '额度使用最迟日期';
COMMENT ON COLUMN crmdm.cms_business_contract.useterm IS '到期日期';
COMMENT ON COLUMN crmdm.cms_business_contract.creditaggreement IS '额度协议流水号字段';
COMMENT ON COLUMN crmdm.cms_business_contract.relativeagreement IS '额度品种';
COMMENT ON COLUMN crmdm.cms_business_contract.loanflag IS '是否可直接申请出账';
COMMENT ON COLUMN crmdm.cms_business_contract.totalsum IS '总金额';
COMMENT ON COLUMN crmdm.cms_business_contract.ourrole IS '额度控制类型';
COMMENT ON COLUMN crmdm.cms_business_contract.reversibility IS '有无追索权';
COMMENT ON COLUMN crmdm.cms_business_contract.billnum IS '票据数量';
COMMENT ON COLUMN crmdm.cms_business_contract.housetype IS '房产类型';
COMMENT ON COLUMN crmdm.cms_business_contract.lctermtype IS '信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_contract.riskattribute IS '风险类型';
COMMENT ON COLUMN crmdm.cms_business_contract.suretype IS '运单种类';
COMMENT ON COLUMN crmdm.cms_business_contract.safeguardtype IS '保函类型';
COMMENT ON COLUMN crmdm.cms_business_contract.creditbusiness IS '单项额度指定品种';
COMMENT ON COLUMN crmdm.cms_business_contract.businesscurrency IS '币种';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssum IS '合同金额';
COMMENT ON COLUMN crmdm.cms_business_contract.businessprop IS '贷款成数';
COMMENT ON COLUMN crmdm.cms_business_contract.termyear IS '期限（年）';
COMMENT ON COLUMN crmdm.cms_business_contract.termmonth IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.termday IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.lgterm IS '远期天数';
COMMENT ON COLUMN crmdm.cms_business_contract.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_contract.baserate IS '基准年利率';
COMMENT ON COLUMN crmdm.cms_business_contract.ratefloattype IS '利率浮动方式';
COMMENT ON COLUMN crmdm.cms_business_contract.ratefloat IS '利率浮动值';
COMMENT ON COLUMN crmdm.cms_business_contract.businessrate IS '执行月利率';
COMMENT ON COLUMN crmdm.cms_business_contract.ictype IS '收费方式';
COMMENT ON COLUMN crmdm.cms_business_contract.iccyc IS '计息周期';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgratio IS '费率';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgsum IS '手续费金额';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgpaymethod IS '手续费支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgpayperiod IS '收费周期';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeeratio IS '承诺费率';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeesum IS '承诺费';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeeperiod IS '承诺费计收期';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeebegin IS '承诺费计收起始日';
COMMENT ON COLUMN crmdm.cms_business_contract.mfeeratio IS '管理费率';
COMMENT ON COLUMN crmdm.cms_business_contract.mfeesum IS '管理费金额';
COMMENT ON COLUMN crmdm.cms_business_contract.mfeepaymethod IS '管理费支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.agentfee IS '代理费';
COMMENT ON COLUMN crmdm.cms_business_contract.dealfee IS '银行费用';
COMMENT ON COLUMN crmdm.cms_business_contract.totalcast IS '总成本';
COMMENT ON COLUMN crmdm.cms_business_contract.discountinterest IS '贴现利息';
COMMENT ON COLUMN crmdm.cms_business_contract.purchaserinterest IS '买方应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_contract.bargainorinterest IS '卖方应付贴现利息';
COMMENT ON COLUMN crmdm.cms_business_contract.discountsum IS '贴现金额';
COMMENT ON COLUMN crmdm.cms_business_contract.bailratio IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_contract.bailcurrency IS '保证金币种';
COMMENT ON COLUMN crmdm.cms_business_contract.bailsum IS '保证金金额';
COMMENT ON COLUMN crmdm.cms_business_contract.bailaccount IS '保证金账号';
COMMENT ON COLUMN crmdm.cms_business_contract.fineratetype IS '罚息利率类型';
COMMENT ON COLUMN crmdm.cms_business_contract.finerate IS '垫款利率';
COMMENT ON COLUMN crmdm.cms_business_contract.drawingtype IS '提款方式';
COMMENT ON COLUMN crmdm.cms_business_contract.firstdrawingdate IS '首次提款日';
COMMENT ON COLUMN crmdm.cms_business_contract.drawingperiod IS '提款期限';
COMMENT ON COLUMN crmdm.cms_business_contract.paytimes IS '还款期数';
COMMENT ON COLUMN crmdm.cms_business_contract.paycyc IS '还本付息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.graceperiod IS '贷款宽限期';
COMMENT ON COLUMN crmdm.cms_business_contract.overdraftperiod IS '连续透支期';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcno IS '信用证编号';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlctermtype IS '原信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_contract.remitmode IS '汇款方式';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcsum IS '原信用证金额"';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcloadingdate IS '装运日期';
COMMENT ON COLUMN crmdm.cms_business_contract.oldlcvaliddate IS '信用证效期';
COMMENT ON COLUMN crmdm.cms_business_contract.direction IS '行业投向';
COMMENT ON COLUMN crmdm.cms_business_contract.purpose IS '用途';
COMMENT ON COLUMN crmdm.cms_business_contract.planallocation IS '用款计划';
COMMENT ON COLUMN crmdm.cms_business_contract.immediacypaysource IS '直接还款来源';
COMMENT ON COLUMN crmdm.cms_business_contract.paysource IS '还款说明';
COMMENT ON COLUMN crmdm.cms_business_contract.corpuspaymethod IS '还款方式';
COMMENT ON COLUMN crmdm.cms_business_contract.interestpaymethod IS '利息支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.putoutdate IS '起始日期';
COMMENT ON COLUMN crmdm.cms_business_contract.maturity IS '到期日期';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdparty1 IS '承兑人名称';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyid1 IS '房屋详址';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdparty2 IS '开发商资质等级';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyid2 IS '受益人所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdparty3 IS '议付行/寄单行';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyid3 IS '最高成数';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyregion IS '所在国家或地区';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyaccounts IS '委托单位账号';
COMMENT ON COLUMN crmdm.cms_business_contract.cargoinfo IS '进口货物名称';
COMMENT ON COLUMN crmdm.cms_business_contract.projectname IS '项目编号';
COMMENT ON COLUMN crmdm.cms_business_contract.operationinfo IS '参与行情况';
COMMENT ON COLUMN crmdm.cms_business_contract.contextinfo IS '提款说明';
COMMENT ON COLUMN crmdm.cms_business_contract.securitiestype IS '有价证券类型';
COMMENT ON COLUMN crmdm.cms_business_contract.securitiesregion IS '有价证券发行地';
COMMENT ON COLUMN crmdm.cms_business_contract.constructionarea IS '建筑面积';
COMMENT ON COLUMN crmdm.cms_business_contract.usearea IS '使用面积';
COMMENT ON COLUMN crmdm.cms_business_contract.flag1 IS 'FLAG1';
COMMENT ON COLUMN crmdm.cms_business_contract.flag2 IS 'FLAG2';
COMMENT ON COLUMN crmdm.cms_business_contract.flag3 IS 'FLAG3';
COMMENT ON COLUMN crmdm.cms_business_contract.tradecontractno IS '贸易合同号';
COMMENT ON COLUMN crmdm.cms_business_contract.invoiceno IS '增值税发票';
COMMENT ON COLUMN crmdm.cms_business_contract.tradecurrency IS '贸易合同币种';
COMMENT ON COLUMN crmdm.cms_business_contract.tradesum IS '贸易金额';
COMMENT ON COLUMN crmdm.cms_business_contract.lcno IS '信用证编号';
COMMENT ON COLUMN crmdm.cms_business_contract.paymentdate IS '票据查询、回复日期';
COMMENT ON COLUMN crmdm.cms_business_contract.operationmode IS '业务处理方式';
COMMENT ON COLUMN crmdm.cms_business_contract.begindate IS '额度生效日';
COMMENT ON COLUMN crmdm.cms_business_contract.enddate IS '拆借到期日';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchclass IS '担保形式';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchtype IS '主要担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchtype1 IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchtype2 IS '担保方式2';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchflag IS '有无其他担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.warrantor IS '主要担保人';
COMMENT ON COLUMN crmdm.cms_business_contract.warrantorid IS '主要担保人ID';
COMMENT ON COLUMN crmdm.cms_business_contract.othercondition IS '其他条件和要求';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyvalue IS '担保总价值';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyrate IS '抵质押率';
COMMENT ON COLUMN crmdm.cms_business_contract.baseevaluateresult IS '基期信用等级';
COMMENT ON COLUMN crmdm.cms_business_contract.riskrate IS '综合风险度';
COMMENT ON COLUMN crmdm.cms_business_contract.lowrisk IS '是否低风险业务';
COMMENT ON COLUMN crmdm.cms_business_contract.otherarealoan IS '是否异地业务';
COMMENT ON COLUMN crmdm.cms_business_contract.lowriskbailsum IS '低风险担保金额';
COMMENT ON COLUMN crmdm.cms_business_contract.applytype IS '申请类型';
COMMENT ON COLUMN crmdm.cms_business_contract.originalputoutdate IS '首次放款日期';
COMMENT ON COLUMN crmdm.cms_business_contract.extendtimes IS '展期次数';
COMMENT ON COLUMN crmdm.cms_business_contract.lngotimes IS '借新还旧次数';
COMMENT ON COLUMN crmdm.cms_business_contract.golntimes IS '还旧借新次数';
COMMENT ON COLUMN crmdm.cms_business_contract.drtimes IS '债务重组次数';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyno IS '抵质押编号';
COMMENT ON COLUMN crmdm.cms_business_contract.putoutsum IS '放款金额(原币)';
COMMENT ON COLUMN crmdm.cms_business_contract.actualputoutsum IS '实际出账金额';
COMMENT ON COLUMN crmdm.cms_business_contract.balance IS '总余额';
COMMENT ON COLUMN crmdm.cms_business_contract.normalbalance IS '正常余额';
COMMENT ON COLUMN crmdm.cms_business_contract.overduebalance IS '逾期/垫款金额';
COMMENT ON COLUMN crmdm.cms_business_contract.dullbalance IS '呆滞余额';
COMMENT ON COLUMN crmdm.cms_business_contract.badbalance IS '呆账余额';
COMMENT ON COLUMN crmdm.cms_business_contract.interestbalance1 IS '表内欠息';
COMMENT ON COLUMN crmdm.cms_business_contract.interestbalance2 IS '表外欠息余额';
COMMENT ON COLUMN crmdm.cms_business_contract.finebalance1 IS '本金罚息';
COMMENT ON COLUMN crmdm.cms_business_contract.finebalance2 IS '利息罚息';
COMMENT ON COLUMN crmdm.cms_business_contract.overduedays IS '逾期天数';
COMMENT ON COLUMN crmdm.cms_business_contract.oweinterestdays IS '欠息天数';
COMMENT ON COLUMN crmdm.cms_business_contract.tabalance IS '分期业务欠本金';
COMMENT ON COLUMN crmdm.cms_business_contract.tainterestbalance IS '分期业务欠利息';
COMMENT ON COLUMN crmdm.cms_business_contract.tatimes IS '累计欠款期数';
COMMENT ON COLUMN crmdm.cms_business_contract.lcatimes IS '连续欠款期数';
COMMENT ON COLUMN crmdm.cms_business_contract.pbinterestsum IS '累计收回利息';
COMMENT ON COLUMN crmdm.cms_business_contract.pbmfeesum IS '累计收回管理费';
COMMENT ON COLUMN crmdm.cms_business_contract.pbpdgsum IS '累计收回手续费';
COMMENT ON COLUMN crmdm.cms_business_contract.pblegalcostsum IS '累计收回诉讼费';
COMMENT ON COLUMN crmdm.cms_business_contract.polegalcostsum IS '累计付出诉讼费';
COMMENT ON COLUMN crmdm.cms_business_contract.originalbaddate IS '首次认定不良日期';
COMMENT ON COLUMN crmdm.cms_business_contract.baseclassifyresult IS '基期风险分类结果';
COMMENT ON COLUMN crmdm.cms_business_contract.classifyresult IS '当前风险分类结果';
COMMENT ON COLUMN crmdm.cms_business_contract.classifytype IS '最新风险分类方式';
COMMENT ON COLUMN crmdm.cms_business_contract.classifydate IS '风险分类日期';
COMMENT ON COLUMN crmdm.cms_business_contract.classifyorgid IS '分类认定机构';
COMMENT ON COLUMN crmdm.cms_business_contract.reservesum IS '计提准备金额';
COMMENT ON COLUMN crmdm.cms_business_contract.expectlosssum IS '预测损失金额';
COMMENT ON COLUMN crmdm.cms_business_contract.bailrate IS '保证金比率';
COMMENT ON COLUMN crmdm.cms_business_contract.finishorg IS '批复机构';
COMMENT ON COLUMN crmdm.cms_business_contract.finishtype IS '终结类型';
COMMENT ON COLUMN crmdm.cms_business_contract.finishdate IS '终结日期';
COMMENT ON COLUMN crmdm.cms_business_contract.describe1 IS '宽限期期数';
COMMENT ON COLUMN crmdm.cms_business_contract.reinforceflag IS '补登标志';
COMMENT ON COLUMN crmdm.cms_business_contract.manageorgid IS '贷后管理机构';
COMMENT ON COLUMN crmdm.cms_business_contract.manageuserid IS '贷后管理人员';
COMMENT ON COLUMN crmdm.cms_business_contract.recoveryorgid IS '保全管理机构';
COMMENT ON COLUMN crmdm.cms_business_contract.recoveryuserid IS '保全管理人';
COMMENT ON COLUMN crmdm.cms_business_contract.statorgid IS '成本中心机构名称';
COMMENT ON COLUMN crmdm.cms_business_contract.statuserid IS '当前统计人';
COMMENT ON COLUMN crmdm.cms_business_contract.operateorgid IS '经办机构';
COMMENT ON COLUMN crmdm.cms_business_contract.operateuserid IS '经办人';
COMMENT ON COLUMN crmdm.cms_business_contract.operatedate IS '经办时间';
COMMENT ON COLUMN crmdm.cms_business_contract.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_business_contract.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_business_contract.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_business_contract.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_business_contract.pigeonholedate IS '归档日期';
COMMENT ON COLUMN crmdm.cms_business_contract.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_business_contract.flag4 IS '交单方式';
COMMENT ON COLUMN crmdm.cms_business_contract.paycurrency IS '单据币种';
COMMENT ON COLUMN crmdm.cms_business_contract.paydate IS '装期';
COMMENT ON COLUMN crmdm.cms_business_contract.flag5 IS '转建行标志';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum1 IS '最新分类正常金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum2 IS '最新分类关注金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum3 IS '最新分类次级金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum4 IS '最新分类可疑金额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifysum5 IS '最新分类损失金额';
COMMENT ON COLUMN crmdm.cms_business_contract.shifttype IS '移交类型';
COMMENT ON COLUMN crmdm.cms_business_contract.operatetype IS '操作方式';
COMMENT ON COLUMN crmdm.cms_business_contract.fundsource IS '资金来源';
COMMENT ON COLUMN crmdm.cms_business_contract.cycleflag IS '循环标志';
COMMENT ON COLUMN crmdm.cms_business_contract.creditfreezeflag IS '额度是否冻结';
COMMENT ON COLUMN crmdm.cms_business_contract.shiftbalance IS '移交余额';
COMMENT ON COLUMN crmdm.cms_business_contract.classifyfrequency IS '检查频率';
COMMENT ON COLUMN crmdm.cms_business_contract.classifylevel IS '当前认定人员角色';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchnewflag IS '是否新增担保';
COMMENT ON COLUMN crmdm.cms_business_contract.actualartificialno IS '实际合同号';
COMMENT ON COLUMN crmdm.cms_business_contract.deleteflag IS '合并标志';
COMMENT ON COLUMN crmdm.cms_business_contract.accountno IS '结算账号';
COMMENT ON COLUMN crmdm.cms_business_contract.loanaccountno IS '贷款入账账号';
COMMENT ON COLUMN crmdm.cms_business_contract.secondpayaccount IS '第二还款账号';
COMMENT ON COLUMN crmdm.cms_business_contract.adjustratetype IS '利率调整方式';
COMMENT ON COLUMN crmdm.cms_business_contract.adjustrateterm IS '利率调整日月数';
COMMENT ON COLUMN crmdm.cms_business_contract.overinttype IS '逾期计息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.rateadjustcyc IS '利率调整周期';
COMMENT ON COLUMN crmdm.cms_business_contract.pdgaccountno IS '手续费支出帐号';
COMMENT ON COLUMN crmdm.cms_business_contract.deductdate IS '扣款日期';
COMMENT ON COLUMN crmdm.cms_business_contract.fzanbalance IS '到单金额';
COMMENT ON COLUMN crmdm.cms_business_contract.acceptinttype IS '贴现付息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.ratio IS '比例';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyadd1 IS '首付金额';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyzip1 IS '首付比例';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyadd2 IS '首付款来源';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyzip2 IS '按揭贷款成数';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyadd3 IS '发运地';
COMMENT ON COLUMN crmdm.cms_business_contract.thirdpartyzip3 IS '进口许可证(批文)编号';
COMMENT ON COLUMN crmdm.cms_business_contract.effectarea IS '交货地';
COMMENT ON COLUMN crmdm.cms_business_contract.termdate1 IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.termdate2 IS '交单期';
COMMENT ON COLUMN crmdm.cms_business_contract.termdate3 IS '申请开证日期';
COMMENT ON COLUMN crmdm.cms_business_contract.fixcyc IS '固定周期';
COMMENT ON COLUMN crmdm.cms_business_contract.describe2 IS '宽限期付息方法';
COMMENT ON COLUMN crmdm.cms_business_contract.cancelsum IS '核销本金';
COMMENT ON COLUMN crmdm.cms_business_contract.cancelinterest IS '核销利息';
COMMENT ON COLUMN crmdm.cms_business_contract.loanterm IS '期限';
COMMENT ON COLUMN crmdm.cms_business_contract.putoutorgid IS '放贷机构';
COMMENT ON COLUMN crmdm.cms_business_contract.tempsaveflag IS '暂存标志';
COMMENT ON COLUMN crmdm.cms_business_contract.overduedate IS '逾期日期';
COMMENT ON COLUMN crmdm.cms_business_contract.oweinterestdate IS '欠息日期';
COMMENT ON COLUMN crmdm.cms_business_contract.freezeflag IS '冻结标志';
COMMENT ON COLUMN crmdm.cms_business_contract.approvedate IS '批复日期';
COMMENT ON COLUMN crmdm.cms_business_contract.shiftstatus IS '不良资产移交状态';
COMMENT ON COLUMN crmdm.cms_business_contract.recoverycognorgid IS '不良资产认定机构';
COMMENT ON COLUMN crmdm.cms_business_contract.recoverycognuserid IS '不良资产认定人员';
COMMENT ON COLUMN crmdm.cms_business_contract.shiftdocdescribe IS '不良资产移交文档清单';
COMMENT ON COLUMN crmdm.cms_business_contract.guarantyflag IS '征信担保标志';
COMMENT ON COLUMN crmdm.cms_business_contract.totalbalance IS '剩余额度';
COMMENT ON COLUMN crmdm.cms_business_contract.grouplineid IS '集团授信额度合同编号';
COMMENT ON COLUMN crmdm.cms_business_contract.transformtimes IS '变更次数';
COMMENT ON COLUMN crmdm.cms_business_contract.transformflag IS '担保合同变更标志';
COMMENT ON COLUMN crmdm.cms_business_contract.fundbackaccount IS '还款准备金账户';
COMMENT ON COLUMN crmdm.cms_business_contract.requitalaccount IS '资金回笼账户';
COMMENT ON COLUMN crmdm.cms_business_contract.paymentmode IS '支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.executeyearrate IS '执行年利率';
COMMENT ON COLUMN crmdm.cms_business_contract.offsheetflag IS '表内外标志';
COMMENT ON COLUMN crmdm.cms_business_contract.paysourcen IS '还款来源';
COMMENT ON COLUMN crmdm.cms_business_contract.returnfrequency IS '还款频率';
COMMENT ON COLUMN crmdm.cms_business_contract.backfrequency IS '还息频率';
COMMENT ON COLUMN crmdm.cms_business_contract.paysourcedetail IS '还款来源说明';
COMMENT ON COLUMN crmdm.cms_business_contract.ishostbank IS '银团贷款我行是否主办行';
COMMENT ON COLUMN crmdm.cms_business_contract.lendaccountno IS '放款账号';
COMMENT ON COLUMN crmdm.cms_business_contract.payaccountno IS '还款账号';
COMMENT ON COLUMN crmdm.cms_business_contract.breachratio IS '提前还款违约金比例（还款一年内）';
COMMENT ON COLUMN crmdm.cms_business_contract.breachratio1 IS '提前还款违约金比例（还款一年以上）';
COMMENT ON COLUMN crmdm.cms_business_contract.havepayplan IS '是否设定还款计划表';
COMMENT ON COLUMN crmdm.cms_business_contract.ipcode IS '还息频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_contract.frcode IS '还款频率（日或月）';
COMMENT ON COLUMN crmdm.cms_business_contract.breachfinetype IS '违约罚息方式';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssource IS '业务渠道';
COMMENT ON COLUMN crmdm.cms_business_contract.barcode IS '条形码';
COMMENT ON COLUMN crmdm.cms_business_contract.status IS '合同状态';
COMMENT ON COLUMN crmdm.cms_business_contract.creditmethod IS '授信模式';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum1 IS '名义金额1';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum2 IS '名义金额2';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum3 IS '名义金额3';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum4 IS '名义金额4';
COMMENT ON COLUMN crmdm.cms_business_contract.titularsum5 IS '名义金额5';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum1 IS '敞口金额1';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum2 IS '敞口金额2';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum3 IS '敞口金额3';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum4 IS '敞口金额4';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum5 IS '敞口金额5';
COMMENT ON COLUMN crmdm.cms_business_contract.overagesum1 IS '敞口余额1';
COMMENT ON COLUMN crmdm.cms_business_contract.overagesum2 IS '敞口余额2';
COMMENT ON COLUMN crmdm.cms_business_contract.overagesum3 IS '敞口余额3';
COMMENT ON COLUMN crmdm.cms_business_contract.operateuserid1 IS '辅办客户经理';
COMMENT ON COLUMN crmdm.cms_business_contract.reapply IS '复议标志(Code:ReApply)';
COMMENT ON COLUMN crmdm.cms_business_contract.usedepositpile IS '存款积数';
COMMENT ON COLUMN crmdm.cms_business_contract.depositpilesum IS '本次所使用存款积数';
COMMENT ON COLUMN crmdm.cms_business_contract.preappno IS '预审号';
COMMENT ON COLUMN crmdm.cms_business_contract.direction1 IS '本行行业分类';
COMMENT ON COLUMN crmdm.cms_business_contract.billtype IS '票据类型';
COMMENT ON COLUMN crmdm.cms_business_contract.basebusinesstype IS '基础产品';
COMMENT ON COLUMN crmdm.cms_business_contract.investedcapital IS '项目总投资额';
COMMENT ON COLUMN crmdm.cms_business_contract.promisesfeetype IS '承诺费支付方式';
COMMENT ON COLUMN crmdm.cms_business_contract.issuetype IS '签发类型';
COMMENT ON COLUMN crmdm.cms_business_contract.issuebankname IS '代签银行名称';
COMMENT ON COLUMN crmdm.cms_business_contract.isinsurance IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.extend IS '单价（元/平米）';
COMMENT ON COLUMN crmdm.cms_business_contract.extend1 IS '购房合同号';
COMMENT ON COLUMN crmdm.cms_business_contract.businessloantype IS '贷款类型';
COMMENT ON COLUMN crmdm.cms_business_contract.extend3 IS '目前客户名下房屋数量';
COMMENT ON COLUMN crmdm.cms_business_contract.extend4 IS '借款人月收入';
COMMENT ON COLUMN crmdm.cms_business_contract.isfarming IS '是否涉农';
COMMENT ON COLUMN crmdm.cms_business_contract.xwbz IS '小微备注';
COMMENT ON COLUMN crmdm.cms_business_contract.farmorg IS '所属专合组织名称';
COMMENT ON COLUMN crmdm.cms_business_contract.industrialadjust IS '产业结构调整类型';
COMMENT ON COLUMN crmdm.cms_business_contract.industrialupgrading IS '是否工业转型升级行业';
COMMENT ON COLUMN crmdm.cms_business_contract.newindustry IS '战略新兴产业类型';
COMMENT ON COLUMN crmdm.cms_business_contract.firstdrawingterm IS '首笔提款期';
COMMENT ON COLUMN crmdm.cms_business_contract.enddrawingterm IS '最晚提款期';
COMMENT ON COLUMN crmdm.cms_business_contract.enddrawingdate IS '最晚提款日';
COMMENT ON COLUMN crmdm.cms_business_contract.reauditterm IS '额度下次重审期限';
COMMENT ON COLUMN crmdm.cms_business_contract.reauditdate IS '额度下次重审日';
COMMENT ON COLUMN crmdm.cms_business_contract.yz IS '是否移植数据';
COMMENT ON COLUMN crmdm.cms_business_contract.isliquidity IS '流动资金贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.isfixed IS '固定资产贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.isproject IS '项目融资';
COMMENT ON COLUMN crmdm.cms_business_contract.redeclare IS '是否重新申报额度';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssum1 IS '个人住宅按揭额度';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssum2 IS '个人营业用房按揭额度';
COMMENT ON COLUMN crmdm.cms_business_contract.businessproduct IS '微贷业务产品';
COMMENT ON COLUMN crmdm.cms_business_contract.relaserialno IS '关联流水号';
COMMENT ON COLUMN crmdm.cms_business_contract.bridlemark IS '审贷约束条件';
COMMENT ON COLUMN crmdm.cms_business_contract.linetype IS '授信条线';
COMMENT ON COLUMN crmdm.cms_business_contract.policynumber IS '保单号';
COMMENT ON COLUMN crmdm.cms_business_contract.ispolicyloan IS '是否保险贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.bankvouchtype IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_contract.isdiscount IS '属性5';
COMMENT ON COLUMN crmdm.cms_business_contract.productid IS '产品编号';
COMMENT ON COLUMN crmdm.cms_business_contract.vouchcompanybailaccount IS '属性3';
COMMENT ON COLUMN crmdm.cms_business_contract.oldputoutdate IS '原始发放时间';
COMMENT ON COLUMN crmdm.cms_business_contract.dealloan IS '是否经营类贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.approveuser IS '复核人';
COMMENT ON COLUMN crmdm.cms_business_contract.paytype IS '转账标识';
COMMENT ON COLUMN crmdm.cms_business_contract.imagebatchno IS '影像批次号';
COMMENT ON COLUMN crmdm.cms_business_contract.oldoccurtype IS '原发生方式';
COMMENT ON COLUMN crmdm.cms_business_contract.oldapplytype IS '原申请类型';
COMMENT ON COLUMN crmdm.cms_business_contract.dutyfreecode IS '免税标识';
COMMENT ON COLUMN crmdm.cms_business_contract.finishuser IS '终批人';
COMMENT ON COLUMN crmdm.cms_business_contract.channel IS '渠道号';
COMMENT ON COLUMN crmdm.cms_business_contract.oldmaturity IS '原始到期日';
COMMENT ON COLUMN crmdm.cms_business_contract.loanpersontype IS '借款人主体CodeNo:LoanPersonType';
COMMENT ON COLUMN crmdm.cms_business_contract.graduatetype IS '高校毕业生类型CodeNo:GraduateType';
COMMENT ON COLUMN crmdm.cms_business_contract.disabletype IS '是否残疾人';
COMMENT ON COLUMN crmdm.cms_business_contract.femaleflag IS '是否女性人员';
COMMENT ON COLUMN crmdm.cms_business_contract.greencredit IS '是否绿色贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.firstloanflag IS '是否为首套住房贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresum IS 'EXPOSURESUM';
COMMENT ON COLUMN crmdm.cms_business_contract.ismicropro IS '是否属于小微批量项目贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.microproname IS '小微批量项目名称';
COMMENT ON COLUMN crmdm.cms_business_contract.financebailoutdelay IS '是否金融纾困延期';
COMMENT ON COLUMN crmdm.cms_business_contract.financebailoutdelaymonths IS '金融纾困延期月数';
COMMENT ON COLUMN crmdm.cms_business_contract.creditpromise IS '授信承诺 CodeNo:CreditPromise';
COMMENT ON COLUMN crmdm.cms_business_contract.iscultureindustry IS '是否文化产业';
COMMENT ON COLUMN crmdm.cms_business_contract.isfirstloan IS '是否首次贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.exposuresumauto IS 'EXPOSURESUMAUTO';
COMMENT ON COLUMN crmdm.cms_business_contract.businesssumauto IS 'BUSINESSSUMAUTO';
COMMENT ON COLUMN crmdm.cms_business_contract.transno IS 'TRANSNO';
COMMENT ON COLUMN crmdm.cms_business_contract.isregroup IS '是否重组贷款';
COMMENT ON COLUMN crmdm.cms_business_contract.farmingindicator IS '涉农附报指标';
COMMENT ON COLUMN crmdm.cms_business_contract.observedate IS '观察期';
COMMENT ON COLUMN crmdm.cms_business_contract.czclassifyresult IS '重组贷款五级分类';
COMMENT ON COLUMN crmdm.cms_business_contract.isenforce IS '是否赋强公证';
COMMENT ON COLUMN crmdm.cms_business_contract.myareacode IS '绵阳一手房按揭区域代码';
COMMENT ON COLUMN crmdm.cms_business_contract.isbatchguaranty IS '是否批量担保业务';
COMMENT ON COLUMN crmdm.cms_business_contract.issueforms IS '开证方式';
COMMENT ON COLUMN crmdm.cms_business_contract.gjspprj IS '个金专案项目';
COMMENT ON COLUMN crmdm.cms_business_contract.intpaymode IS '利息支付方式(码值IntPayMode: 1-核心企业付息; 2-融资申请人付息)';
COMMENT ON COLUMN crmdm.cms_business_contract.isspzy IS '是否商票质押 1=是 2=否';
COMMENT ON COLUMN crmdm.cms_business_contract.ryzd IS '冗余字段';


-- crmdm.cms_business_duebill 定义

-- Drop table

-- DROP TABLE crmdm.cms_business_duebill;

CREATE TABLE crmdm.cms_business_duebill (
	serialno varchar(40) NOT NULL, -- 流水号
	relativeserialno1 varchar(40) NULL, -- 相关出账流水号
	relativeserialno2 varchar(40) NULL, -- 相关合同流水号
	subjectno varchar(20) NULL, -- 会计科目
	mfcustomerid varchar(40) NULL, -- 主机客户号
	customerid varchar(40) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	businesstype varchar(18) NULL, -- 业务品种代码
	businesssubtype varchar(20) NULL, -- 业务品种子类型
	businessstatus varchar(20) NULL, -- 业务形态
	businesscurrency varchar(20) NULL, -- 币种
	businesssum numeric(24, 6) NULL, -- 借据金额
	putoutdate varchar(10) NULL, -- 发放日期
	maturity varchar(10) NULL, -- 到期日
	actualmaturity varchar(10) NULL, -- 实际到期日
	businessrate numeric(24, 10) NULL, -- 发放利率
	actualbusinessrate numeric(10, 6) NULL, -- 月利率
	ictype varchar(20) NULL, -- 计息方式
	iccyc varchar(20) NULL, -- 计息周期
	paytimes numeric NULL, -- 信用证付款期限
	paycyc varchar(20) NULL, -- 还款周期
	corpuspaymethod varchar(20) NULL, -- 还本方式
	extendtimes numeric NULL, -- 展期次数
	reorgtimes numeric NULL, -- 债务重组次数
	renewtimes numeric NULL, -- 借新还旧次数
	golntimes numeric NULL, -- 还旧借新次数
	balance numeric(24, 6) NULL, -- 借据余额
	normalbalance numeric(24, 6) NULL, -- 正常余额
	overduebalance numeric(24, 6) NULL, -- 逾期余额
	dullbalance numeric(24, 6) NULL, -- 呆滞余额
	badbalance numeric(24, 6) NULL, -- 呆账余额
	interestbalance1 numeric(24, 6) NULL, -- 表内欠息余额
	interestbalance2 numeric(24, 6) NULL, -- 表外欠息余额
	finebalance1 numeric(24, 6) NULL, -- 逾期罚息余额
	finebalance2 numeric(24, 6) NULL, -- 复息余额
	receivebalance numeric(24, 6) NULL, -- 到单金额
	payedbalance numeric(24, 6) NULL, -- 付款金额
	overduedays numeric NULL, -- 逾期天数
	payaccount varchar(40) NULL, -- 存款账号
	putoutaccount varchar(40) NULL, -- 保证金帐号
	paybackaccount varchar(40) NULL, -- 还款帐号
	payinterestaccount varchar(40) NULL, -- 还息帐号
	oweinterestdays numeric NULL, -- 欠息天数
	tabalance numeric(24, 6) NULL, -- 分期业务欠本金
	tainterestbalance numeric(24, 6) NULL, -- 分期业务欠利息
	tatimes numeric(24, 6) NULL, -- 累计欠款期数
	lcatimes numeric(24, 6) NULL, -- 连续欠款期数
	saledate varchar(10) NULL, -- 售出日期
	finishtype varchar(20) NULL, -- 终结类型
	finishdate varchar(10) NULL, -- 终结日期
	mfareaid varchar(20) NULL, -- 主机地区号
	mforgid varchar(20) NULL, -- 主机机构号
	mfuserid varchar(20) NULL, -- 主机柜员号
	operateorgid varchar(20) NULL, -- 经办机构
	operateuserid varchar(20) NULL, -- 经办人
	inputorgid varchar(20) NULL, -- 登记机构
	inputuserid varchar(20) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	inoutflag varchar(40) NULL, -- 表内表外标志
	dealflag varchar(1) NULL, -- 处理标志
	occurdate varchar(10) NULL, -- 发生日期
	businessprop numeric(10, 6) NULL, -- 贷款成数
	benefitcorp varchar(40) NULL, -- 受益人
	actualtermmonth numeric NULL, -- 期限
	actualtermday numeric NULL, -- 期限
	baseratetype varchar(20) NULL, -- 基准利率类型
	baserate numeric(24, 6) NULL, -- 基准利率类型
	ratefloattype varchar(20) NULL, -- 利率浮动类型
	ratefloat numeric(24, 6) NULL, -- 利率浮动类型
	timsflag varchar(40) NULL, -- 分期业务标志
	bailratio numeric(10, 6) NULL, -- 保证金比例
	logoutdate varchar(10) NULL, -- 注销日期
	cancellogoutdate varchar(10) NULL, -- 解除注销日期
	bailsum numeric(24, 6) NULL, -- 保证金金额
	bailaccount varchar(40) NULL, -- 保证金账号
	purpose varchar(200) NULL, -- 用途
	advanceflag varchar(20) NULL, -- 垫款标志
	relativeduebillno varchar(40) NULL, -- 相关借据流水号
	actualartificialno varchar(40) NULL, -- 实际合同号
	accountno varchar(40) NULL, -- 结算帐号
	loanaccountno varchar(40) NULL, -- 贷款入账帐号
	secondpayaccount varchar(40) NULL, -- 第二还款帐号
	adjustratetype varchar(20) NULL, -- 利率调整方式
	adjustrateterm varchar(20) NULL, -- 利息调整月数
	overinttype varchar(20) NULL, -- 逾期计息方式
	rateadjustcyc varchar(20) NULL, -- 利率调整日期
	pdgaccountno varchar(40) NULL, -- 手续费支出帐号
	deductdate varchar(10) NULL, -- 扣款日期
	fzanbalance numeric(24, 6) NULL, -- 发展商入账净额
	acceptinttype varchar(20) NULL, -- 收息类型
	ratio numeric(24, 6) NULL, -- 比率
	thirdpartyadd1 varchar(80) NULL, -- 涉及第三方地址1
	thirdpartyzip1 varchar(40) NULL, -- 第三方法人邮编1
	thirdpartyadd2 varchar(80) NULL, -- 涉及第三方地址2
	thirdpartyzip2 varchar(40) NULL, -- 第三方法人邮编2
	termdate1 varchar(10) NULL, -- 最晚装运期
	termdate2 varchar(10) NULL, -- 交单期
	termdate3 varchar(10) NULL, -- 付款期限
	describe2 varchar(200) NULL, -- 描述2
	fixcyc numeric NULL, -- 固定周期
	thirdparty1 varchar(200) NULL, -- 涉及第三方1
	thirdpartyid1 varchar(40) NULL, -- 第三方法人代表1
	thirdparty2 varchar(200) NULL, -- 涉及第三方2
	thirdparty3 varchar(200) NULL, -- 涉及第三方3
	type1 varchar(20) NULL, -- 通知行类型
	type2 varchar(20) NULL, -- 收益行类型
	type3 varchar(20) NULL, -- 议付行类型
	billno varchar(64) NULL, -- 票据号
	flag1 varchar(20) NULL, -- 是否1
	flag2 varchar(20) NULL, -- 是否2
	flag3 varchar(20) NULL, -- 是否3
	thirdpartyregion varchar(20) NULL, -- 涉及第三方所在地区和国家
	thirdpartyaccounts varchar(40) NULL, -- 第三方帐号
	cargoinfo varchar(80) NULL, -- 货物名称
	securitiestype varchar(20) NULL, -- 有价证券类型
	securitiesregion varchar(20) NULL, -- 有价证券发行地
	aboutbankid2 varchar(40) NULL, -- 收益行行号
	aboutbankname2 varchar(80) NULL, -- 收益行行名
	aboutbankid3 varchar(40) NULL, -- 议付行行号
	aboutbankname varchar(80) NULL, -- 收款行行名
	aboutbankid varchar(40) NULL, -- 收款行行号
	oldlctermtype varchar(20) NULL, -- 原信用证期限类型
	negotiateno varchar(40) NULL, -- 押汇编号
	creditkind varchar(20) NULL, -- 货款形式
	gatheringname varchar(80) NULL, -- 收款人户名
	preinttype varchar(20) NULL, -- 预收息标志
	resumeinttype varchar(20) NULL, -- 计复息标志
	guarantyno varchar(40) NULL, -- 抵质押物编号
	pztype varchar(20) NULL, -- 凭证种类
	graceperiod numeric NULL, -- 还款宽限期
	oldlcvaliddate varchar(10) NULL, -- 原信用证有效期
	mfeepaymethod varchar(20) NULL, -- 管理费支付方式
	describe1 varchar(200) NULL, -- 描述1
	tradecontractno varchar(40) NULL, -- 相关贸易合同号
	loantype varchar(20) NULL, -- 贷款类型
	fixterm numeric(24, 6) NULL, -- 周期
	cancelsum numeric(24, 6) NULL, -- 核销金额
	cancelinterest numeric(24, 6) NULL, -- 核销利息
	bailacount varchar(40) NULL, -- 保证金帐号
	classify4 varchar(18) NULL, -- 4级分类
	classifyresult varchar(18) NULL, -- 五级分类结果
	returntype varchar(18) NULL, -- 终结方式
	bailpercent numeric(10, 6) NULL, -- 保证金比例
	paymenttype varchar(18) NULL, -- 信用证付款方式
	termsfreq varchar(18) NULL, -- 还款频率
	overduedate varchar(10) NULL, -- 逾期日期
	oweinterestdate varchar(10) NULL, -- 欠息日期
	lcstatus varchar(18) NULL, -- 信用证状态
	ichangedate varchar(10) NULL, -- 待扩展字段
	vouchtype varchar(10) NULL, -- 担保方式
	executeyearrate numeric(10, 6) NULL, -- 执行年里率
	offsheetflag varchar(6) NULL, -- 表内外标志
	basebusinesstype varchar(18) NULL, -- 基础产品
	interestoverduedate varchar(18) NULL, -- 计算复利日期
	currentrpttermid varchar(32) NULL, -- 当前时点还款方式
	lctermtype varchar(18) NULL, -- 信用证期限类型
	paytype varchar(12) NULL, -- 支付方式 codeNo=PaymentType
	lastclassifyresult varchar(18) NULL, -- 上月五级分类
	sysclassifyresult varchar(10) NULL, -- 系统五级分类结果
	putoutorgid varchar(100) NULL, -- 业务入账机构
	balanceoverduedate varchar(18) NULL, -- 本金逾期日期
	guaranteeway varchar(18) NULL, -- 担保方式(映射科目条件用)
	gjflag varchar(18) NULL, -- 国结标识
	lcno varchar(32) NULL, -- 信用证/保函编号(国结)
	cancleinterestsum2 numeric(24, 6) NULL, -- 核销表外利息
	canclefinesum1 numeric(24, 6) NULL, -- 核销罚息
	canclefinesum2 numeric(24, 6) NULL, -- 核销复利
	canclebalance numeric(24, 6) NULL, -- 核销后本金余额
	cancleinterestbalance2 numeric(24, 6) NULL, -- 核销后表外利息余额
	canclefinebalance1 numeric(24, 6) NULL, -- 核销后罚息余额
	canclefinebalance2 numeric(24, 6) NULL, -- 核销后复利余额
	unacceptbalance numeric(24, 2) NULL, -- 待承兑余额
	dongjbho varchar(40) NULL, -- 保证金冻结编号
	taskflag varchar(2) NULL, -- 五级分类人工调低标识(五级分类批量用)
	yzflag varchar(5) NULL, -- 是否移植数据(1：是)
	ratetermid varchar(20) NULL, -- 利率模式：固定，浮动
	bpratetermid varchar(20) NULL, -- 原利率模式：固定，浮动
	bprateadjustcyc varchar(20) NULL, -- 原利率调整周期
	bpadjustratetype varchar(20) NULL, -- 原利率调整方式
	bpratefloat numeric(10, 6) NULL, -- 原浮动幅度
	bpratefloattype varchar(20) NULL, -- 原利率浮动类型
	bpbaserate numeric(10, 6) NULL, -- 原基准利率
	bpbaseratetype varchar(20) NULL, -- 原基准利率类型
	financebailoutdelay varchar(20) NULL, -- 是否金融纾困延期
	financebailoutdelaymonths numeric NULL, -- 金融纾困延期月数
	iswriteoffaccrualflag varchar(2) NULL, -- 核销后是否计息标志(YesNo)
	loanwriteofftype varchar(10) NULL, -- 核销类型（01-核销（继续清收）；02-核销结清（清收完成））
	observedate varchar(10) NULL, -- 观察期
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_business_duebill PRIMARY KEY (serialno)
);
CREATE INDEX idx1_business_duebill ON crmdm.cms_business_duebill USING btree (relativeserialno2);
CREATE INDEX idx2_business_duebill ON crmdm.cms_business_duebill USING btree (customerid);
CREATE INDEX idx3_business_duebill ON crmdm.cms_business_duebill USING btree (relativeserialno1);
CREATE INDEX idx4_business_duebill ON crmdm.cms_business_duebill USING btree (subjectno, mforgid, businesscurrency);
CREATE INDEX idx5_business_duebill ON crmdm.cms_business_duebill USING btree (actualmaturity, finishdate, balance);
CREATE INDEX idx6_business_duebill ON crmdm.cms_business_duebill USING btree (operateuserid, finishdate, maturity);
CREATE INDEX idx8_business_duebill ON crmdm.cms_business_duebill USING btree (operateorgid);
COMMENT ON TABLE crmdm.cms_business_duebill IS '业务借据(账户)信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_business_duebill.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.relativeserialno1 IS '相关出账流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.relativeserialno2 IS '相关合同流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.subjectno IS '会计科目';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfcustomerid IS '主机客户号';
COMMENT ON COLUMN crmdm.cms_business_duebill.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesstype IS '业务品种代码';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesssubtype IS '业务品种子类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.businessstatus IS '业务形态';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesscurrency IS '币种';
COMMENT ON COLUMN crmdm.cms_business_duebill.businesssum IS '借据金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.putoutdate IS '发放日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.maturity IS '到期日';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualmaturity IS '实际到期日';
COMMENT ON COLUMN crmdm.cms_business_duebill.businessrate IS '发放利率';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualbusinessrate IS '月利率';
COMMENT ON COLUMN crmdm.cms_business_duebill.ictype IS '计息方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.iccyc IS '计息周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.paytimes IS '信用证付款期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.paycyc IS '还款周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.corpuspaymethod IS '还本方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.extendtimes IS '展期次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.reorgtimes IS '债务重组次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.renewtimes IS '借新还旧次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.golntimes IS '还旧借新次数';
COMMENT ON COLUMN crmdm.cms_business_duebill.balance IS '借据余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.normalbalance IS '正常余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.overduebalance IS '逾期余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.dullbalance IS '呆滞余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.badbalance IS '呆账余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.interestbalance1 IS '表内欠息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.interestbalance2 IS '表外欠息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.finebalance1 IS '逾期罚息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.finebalance2 IS '复息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.receivebalance IS '到单金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.payedbalance IS '付款金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.overduedays IS '逾期天数';
COMMENT ON COLUMN crmdm.cms_business_duebill.payaccount IS '存款账号';
COMMENT ON COLUMN crmdm.cms_business_duebill.putoutaccount IS '保证金帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.paybackaccount IS '还款帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.payinterestaccount IS '还息帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.oweinterestdays IS '欠息天数';
COMMENT ON COLUMN crmdm.cms_business_duebill.tabalance IS '分期业务欠本金';
COMMENT ON COLUMN crmdm.cms_business_duebill.tainterestbalance IS '分期业务欠利息';
COMMENT ON COLUMN crmdm.cms_business_duebill.tatimes IS '累计欠款期数';
COMMENT ON COLUMN crmdm.cms_business_duebill.lcatimes IS '连续欠款期数';
COMMENT ON COLUMN crmdm.cms_business_duebill.saledate IS '售出日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.finishtype IS '终结类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.finishdate IS '终结日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfareaid IS '主机地区号';
COMMENT ON COLUMN crmdm.cms_business_duebill.mforgid IS '主机机构号';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfuserid IS '主机柜员号';
COMMENT ON COLUMN crmdm.cms_business_duebill.operateorgid IS '经办机构';
COMMENT ON COLUMN crmdm.cms_business_duebill.operateuserid IS '经办人';
COMMENT ON COLUMN crmdm.cms_business_duebill.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_business_duebill.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_business_duebill.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.inoutflag IS '表内表外标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.dealflag IS '处理标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.occurdate IS '发生日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.businessprop IS '贷款成数';
COMMENT ON COLUMN crmdm.cms_business_duebill.benefitcorp IS '受益人';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualtermmonth IS '期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualtermday IS '期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.baseratetype IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.baserate IS '基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratefloattype IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratefloat IS '利率浮动类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.timsflag IS '分期业务标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailratio IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_duebill.logoutdate IS '注销日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancellogoutdate IS '解除注销日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailsum IS '保证金金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailaccount IS '保证金账号';
COMMENT ON COLUMN crmdm.cms_business_duebill.purpose IS '用途';
COMMENT ON COLUMN crmdm.cms_business_duebill.advanceflag IS '垫款标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.relativeduebillno IS '相关借据流水号';
COMMENT ON COLUMN crmdm.cms_business_duebill.actualartificialno IS '实际合同号';
COMMENT ON COLUMN crmdm.cms_business_duebill.accountno IS '结算帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.loanaccountno IS '贷款入账帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.secondpayaccount IS '第二还款帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.adjustratetype IS '利率调整方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.adjustrateterm IS '利息调整月数';
COMMENT ON COLUMN crmdm.cms_business_duebill.overinttype IS '逾期计息方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.rateadjustcyc IS '利率调整日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.pdgaccountno IS '手续费支出帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.deductdate IS '扣款日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.fzanbalance IS '发展商入账净额';
COMMENT ON COLUMN crmdm.cms_business_duebill.acceptinttype IS '收息类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratio IS '比率';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyadd1 IS '涉及第三方地址1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyzip1 IS '第三方法人邮编1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyadd2 IS '涉及第三方地址2';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyzip2 IS '第三方法人邮编2';
COMMENT ON COLUMN crmdm.cms_business_duebill.termdate1 IS '最晚装运期';
COMMENT ON COLUMN crmdm.cms_business_duebill.termdate2 IS '交单期';
COMMENT ON COLUMN crmdm.cms_business_duebill.termdate3 IS '付款期限';
COMMENT ON COLUMN crmdm.cms_business_duebill.describe2 IS '描述2';
COMMENT ON COLUMN crmdm.cms_business_duebill.fixcyc IS '固定周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdparty1 IS '涉及第三方1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyid1 IS '第三方法人代表1';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdparty2 IS '涉及第三方2';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdparty3 IS '涉及第三方3';
COMMENT ON COLUMN crmdm.cms_business_duebill.type1 IS '通知行类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.type2 IS '收益行类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.type3 IS '议付行类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.billno IS '票据号';
COMMENT ON COLUMN crmdm.cms_business_duebill.flag1 IS '是否1';
COMMENT ON COLUMN crmdm.cms_business_duebill.flag2 IS '是否2';
COMMENT ON COLUMN crmdm.cms_business_duebill.flag3 IS '是否3';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyregion IS '涉及第三方所在地区和国家';
COMMENT ON COLUMN crmdm.cms_business_duebill.thirdpartyaccounts IS '第三方帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.cargoinfo IS '货物名称';
COMMENT ON COLUMN crmdm.cms_business_duebill.securitiestype IS '有价证券类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.securitiesregion IS '有价证券发行地';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankid2 IS '收益行行号';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankname2 IS '收益行行名';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankid3 IS '议付行行号';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankname IS '收款行行名';
COMMENT ON COLUMN crmdm.cms_business_duebill.aboutbankid IS '收款行行号';
COMMENT ON COLUMN crmdm.cms_business_duebill.oldlctermtype IS '原信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.negotiateno IS '押汇编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.creditkind IS '货款形式';
COMMENT ON COLUMN crmdm.cms_business_duebill.gatheringname IS '收款人户名';
COMMENT ON COLUMN crmdm.cms_business_duebill.preinttype IS '预收息标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.resumeinttype IS '计复息标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.guarantyno IS '抵质押物编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.pztype IS '凭证种类';
COMMENT ON COLUMN crmdm.cms_business_duebill.graceperiod IS '还款宽限期';
COMMENT ON COLUMN crmdm.cms_business_duebill.oldlcvaliddate IS '原信用证有效期';
COMMENT ON COLUMN crmdm.cms_business_duebill.mfeepaymethod IS '管理费支付方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.describe1 IS '描述1';
COMMENT ON COLUMN crmdm.cms_business_duebill.tradecontractno IS '相关贸易合同号';
COMMENT ON COLUMN crmdm.cms_business_duebill.loantype IS '贷款类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.fixterm IS '周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancelsum IS '核销金额';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancelinterest IS '核销利息';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailacount IS '保证金帐号';
COMMENT ON COLUMN crmdm.cms_business_duebill.classify4 IS '4级分类';
COMMENT ON COLUMN crmdm.cms_business_duebill.classifyresult IS '五级分类结果';
COMMENT ON COLUMN crmdm.cms_business_duebill.returntype IS '终结方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.bailpercent IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_business_duebill.paymenttype IS '信用证付款方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.termsfreq IS '还款频率';
COMMENT ON COLUMN crmdm.cms_business_duebill.overduedate IS '逾期日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.oweinterestdate IS '欠息日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.lcstatus IS '信用证状态';
COMMENT ON COLUMN crmdm.cms_business_duebill.ichangedate IS '待扩展字段';
COMMENT ON COLUMN crmdm.cms_business_duebill.vouchtype IS '担保方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.executeyearrate IS '执行年里率';
COMMENT ON COLUMN crmdm.cms_business_duebill.offsheetflag IS '表内外标志';
COMMENT ON COLUMN crmdm.cms_business_duebill.basebusinesstype IS '基础产品';
COMMENT ON COLUMN crmdm.cms_business_duebill.interestoverduedate IS '计算复利日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.currentrpttermid IS '当前时点还款方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.lctermtype IS '信用证期限类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.paytype IS '支付方式 codeNo=PaymentType';
COMMENT ON COLUMN crmdm.cms_business_duebill.lastclassifyresult IS '上月五级分类';
COMMENT ON COLUMN crmdm.cms_business_duebill.sysclassifyresult IS '系统五级分类结果';
COMMENT ON COLUMN crmdm.cms_business_duebill.putoutorgid IS '业务入账机构';
COMMENT ON COLUMN crmdm.cms_business_duebill.balanceoverduedate IS '本金逾期日期';
COMMENT ON COLUMN crmdm.cms_business_duebill.guaranteeway IS '担保方式(映射科目条件用)';
COMMENT ON COLUMN crmdm.cms_business_duebill.gjflag IS '国结标识';
COMMENT ON COLUMN crmdm.cms_business_duebill.lcno IS '信用证/保函编号(国结)';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancleinterestsum2 IS '核销表外利息';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinesum1 IS '核销罚息';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinesum2 IS '核销复利';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclebalance IS '核销后本金余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.cancleinterestbalance2 IS '核销后表外利息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinebalance1 IS '核销后罚息余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.canclefinebalance2 IS '核销后复利余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.unacceptbalance IS '待承兑余额';
COMMENT ON COLUMN crmdm.cms_business_duebill.dongjbho IS '保证金冻结编号';
COMMENT ON COLUMN crmdm.cms_business_duebill.taskflag IS '五级分类人工调低标识(五级分类批量用)';
COMMENT ON COLUMN crmdm.cms_business_duebill.yzflag IS '是否移植数据(1：是)';
COMMENT ON COLUMN crmdm.cms_business_duebill.ratetermid IS '利率模式：固定，浮动';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpratetermid IS '原利率模式：固定，浮动';
COMMENT ON COLUMN crmdm.cms_business_duebill.bprateadjustcyc IS '原利率调整周期';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpadjustratetype IS '原利率调整方式';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpratefloat IS '原浮动幅度';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpratefloattype IS '原利率浮动类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpbaserate IS '原基准利率';
COMMENT ON COLUMN crmdm.cms_business_duebill.bpbaseratetype IS '原基准利率类型';
COMMENT ON COLUMN crmdm.cms_business_duebill.financebailoutdelay IS '是否金融纾困延期';
COMMENT ON COLUMN crmdm.cms_business_duebill.financebailoutdelaymonths IS '金融纾困延期月数';
COMMENT ON COLUMN crmdm.cms_business_duebill.iswriteoffaccrualflag IS '核销后是否计息标志(YesNo)';
COMMENT ON COLUMN crmdm.cms_business_duebill.loanwriteofftype IS '核销类型（01-核销（继续清收）；02-核销结清（清收完成））';
COMMENT ON COLUMN crmdm.cms_business_duebill.observedate IS '观察期';
COMMENT ON COLUMN crmdm.cms_business_duebill.ryzd IS '冗余字段';


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


-- crmdm.cms_cl_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_cl_info;

CREATE TABLE crmdm.cms_cl_info (
	lineid varchar(32) NULL, -- 额度编号
	cltypeid varchar(32) NULL, -- 额度类型编号
	cltypename varchar(80) NULL, -- 额度类型名称
	applyserialno varchar(32) NULL, -- 申请流水号
	approveserialno varchar(32) NULL, -- 最终审批意见流水号
	bcserialno varchar(32) NULL, -- 合同流水号
	linecontractno varchar(32) NULL, -- 合同编号
	customerid varchar(32) NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	linesum1 numeric(24, 6) NULL, -- 额度金额
	linesum2 numeric(24, 6) NULL, -- 额度名义金额
	linesum3 numeric(24, 6) NULL, -- 额度敞口金额
	currency varchar(18) NULL, -- 币种
	lineeffdate varchar(10) NULL, -- 生效日
	lineeffflag varchar(1) NULL, -- 是否有效
	putoutdeadline varchar(10) NULL, -- 最后期限
	maturitydeadline varchar(10) NULL, -- 到期日
	rotative varchar(18) NULL, -- 是否循环
	approvalpolicy varchar(18) NULL, -- 审批政策
	freezeflag varchar(1) NULL, -- 是否冻结
	recentcheck varchar(32) NULL, -- 最近检查
	recentcheckstatus varchar(1) NULL, -- 最近检查状态
	checkresult varchar(1) NULL, -- 检查结果
	overflowtype varchar(200) NULL, -- 溢出类型
	inputuser varchar(32) NULL, -- 登记人
	inputorg varchar(32) NULL, -- 登记机构
	inputtime varchar(20) NULL, -- 登记时间
	updatetime varchar(20) NULL, -- 更新时间
	begindate varchar(10) NULL, -- 开始日期
	enddate varchar(10) NULL, -- 结束日期
	parentlineid varchar(32) NULL, -- 父额度编号
	useorgid varchar(32) NULL, -- 使用机构
	useorgname varchar(80) NULL, -- 使用机构名称
	bailratio numeric(10, 6) NULL, -- 保证金比例
	businesstype varchar(32) NULL, -- 业务品种
	usedsum numeric(24, 6) NULL, -- 已用金额
	usablesum numeric(24, 6) NULL, -- 可用金额
	calculatetime varchar(20) NULL -- 计算时间
);
COMMENT ON TABLE crmdm.cms_cl_info IS '额度信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_cl_info.lineid IS '额度编号';
COMMENT ON COLUMN crmdm.cms_cl_info.cltypeid IS '额度类型编号';
COMMENT ON COLUMN crmdm.cms_cl_info.cltypename IS '额度类型名称';
COMMENT ON COLUMN crmdm.cms_cl_info.applyserialno IS '申请流水号';
COMMENT ON COLUMN crmdm.cms_cl_info.approveserialno IS '最终审批意见流水号';
COMMENT ON COLUMN crmdm.cms_cl_info.bcserialno IS '合同流水号';
COMMENT ON COLUMN crmdm.cms_cl_info.linecontractno IS '合同编号';
COMMENT ON COLUMN crmdm.cms_cl_info.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_cl_info.customername IS '客户名称';
COMMENT ON COLUMN crmdm.cms_cl_info.linesum1 IS '额度金额';
COMMENT ON COLUMN crmdm.cms_cl_info.linesum2 IS '额度名义金额';
COMMENT ON COLUMN crmdm.cms_cl_info.linesum3 IS '额度敞口金额';
COMMENT ON COLUMN crmdm.cms_cl_info.currency IS '币种';
COMMENT ON COLUMN crmdm.cms_cl_info.lineeffdate IS '生效日';
COMMENT ON COLUMN crmdm.cms_cl_info.lineeffflag IS '是否有效';
COMMENT ON COLUMN crmdm.cms_cl_info.putoutdeadline IS '最后期限';
COMMENT ON COLUMN crmdm.cms_cl_info.maturitydeadline IS '到期日';
COMMENT ON COLUMN crmdm.cms_cl_info.rotative IS '是否循环';
COMMENT ON COLUMN crmdm.cms_cl_info.approvalpolicy IS '审批政策';
COMMENT ON COLUMN crmdm.cms_cl_info.freezeflag IS '是否冻结';
COMMENT ON COLUMN crmdm.cms_cl_info.recentcheck IS '最近检查';
COMMENT ON COLUMN crmdm.cms_cl_info.recentcheckstatus IS '最近检查状态';
COMMENT ON COLUMN crmdm.cms_cl_info.checkresult IS '检查结果';
COMMENT ON COLUMN crmdm.cms_cl_info.overflowtype IS '溢出类型';
COMMENT ON COLUMN crmdm.cms_cl_info.inputuser IS '登记人';
COMMENT ON COLUMN crmdm.cms_cl_info.inputorg IS '登记机构';
COMMENT ON COLUMN crmdm.cms_cl_info.inputtime IS '登记时间';
COMMENT ON COLUMN crmdm.cms_cl_info.updatetime IS '更新时间';
COMMENT ON COLUMN crmdm.cms_cl_info.begindate IS '开始日期';
COMMENT ON COLUMN crmdm.cms_cl_info.enddate IS '结束日期';
COMMENT ON COLUMN crmdm.cms_cl_info.parentlineid IS '父额度编号';
COMMENT ON COLUMN crmdm.cms_cl_info.useorgid IS '使用机构';
COMMENT ON COLUMN crmdm.cms_cl_info.useorgname IS '使用机构名称';
COMMENT ON COLUMN crmdm.cms_cl_info.bailratio IS '保证金比例';
COMMENT ON COLUMN crmdm.cms_cl_info.businesstype IS '业务品种';
COMMENT ON COLUMN crmdm.cms_cl_info.usedsum IS '已用金额';
COMMENT ON COLUMN crmdm.cms_cl_info.usablesum IS '可用金额';
COMMENT ON COLUMN crmdm.cms_cl_info.calculatetime IS '计算时间';


-- crmdm.cms_code_library 定义

-- Drop table

-- DROP TABLE crmdm.cms_code_library;

CREATE TABLE crmdm.cms_code_library (
	codeno varchar(32) NOT NULL, -- 代码编号
	itemno varchar(32) NOT NULL, -- 代码项编号
	itemname varchar(250) NULL, -- 项目名称
	bankno varchar(32) NULL, -- 征信代码
	sortno varchar(32) NULL, -- 排序号
	isinuse varchar(18) NULL, -- 是否使用
	itemdescribe varchar(800) NULL, -- 项目描述
	itemattribute varchar(800) NULL, -- 项目属性
	relativecode varchar(4000) NULL, -- 关联代码
	attribute1 varchar(800) NULL, -- 属性1
	attribute2 varchar(800) NULL, -- 属性2
	attribute3 varchar(800) NULL, -- 属性3
	attribute4 varchar(4000) NULL, -- 属性4
	attribute5 varchar(250) NULL, -- 属性5
	attribute6 varchar(250) NULL, -- 属性6
	attribute7 varchar(250) NULL, -- 属性7
	attribute8 varchar(250) NULL, -- 属性8
	inputuser varchar(32) NULL, -- 录入人
	inputorg varchar(32) NULL, -- 录入机构
	inputtime varchar(20) NULL, -- 录入时间
	updateuser varchar(32) NULL, -- 更新人
	updatetime varchar(20) NULL, -- 更新时间
	remark varchar(250) NULL, -- 备注
	helptext varchar(250) NULL, -- 帮助
	relativeno varchar(32) NULL, -- ECIF代码
	hxcode varchar(32) NULL, -- 核心代码
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_code_library PRIMARY KEY (codeno, itemno)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_code_library.codeno IS '代码编号';
COMMENT ON COLUMN crmdm.cms_code_library.itemno IS '代码项编号';
COMMENT ON COLUMN crmdm.cms_code_library.itemname IS '项目名称';
COMMENT ON COLUMN crmdm.cms_code_library.bankno IS '征信代码';
COMMENT ON COLUMN crmdm.cms_code_library.sortno IS '排序号';
COMMENT ON COLUMN crmdm.cms_code_library.isinuse IS '是否使用';
COMMENT ON COLUMN crmdm.cms_code_library.itemdescribe IS '项目描述';
COMMENT ON COLUMN crmdm.cms_code_library.itemattribute IS '项目属性';
COMMENT ON COLUMN crmdm.cms_code_library.relativecode IS '关联代码';
COMMENT ON COLUMN crmdm.cms_code_library.attribute1 IS '属性1';
COMMENT ON COLUMN crmdm.cms_code_library.attribute2 IS '属性2';
COMMENT ON COLUMN crmdm.cms_code_library.attribute3 IS '属性3';
COMMENT ON COLUMN crmdm.cms_code_library.attribute4 IS '属性4';
COMMENT ON COLUMN crmdm.cms_code_library.attribute5 IS '属性5';
COMMENT ON COLUMN crmdm.cms_code_library.attribute6 IS '属性6';
COMMENT ON COLUMN crmdm.cms_code_library.attribute7 IS '属性7';
COMMENT ON COLUMN crmdm.cms_code_library.attribute8 IS '属性8';
COMMENT ON COLUMN crmdm.cms_code_library.inputuser IS '录入人';
COMMENT ON COLUMN crmdm.cms_code_library.inputorg IS '录入机构';
COMMENT ON COLUMN crmdm.cms_code_library.inputtime IS '录入时间';
COMMENT ON COLUMN crmdm.cms_code_library.updateuser IS '更新人';
COMMENT ON COLUMN crmdm.cms_code_library.updatetime IS '更新时间';
COMMENT ON COLUMN crmdm.cms_code_library.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_code_library.helptext IS '帮助';
COMMENT ON COLUMN crmdm.cms_code_library.relativeno IS 'ECIF代码';
COMMENT ON COLUMN crmdm.cms_code_library.hxcode IS '核心代码';
COMMENT ON COLUMN crmdm.cms_code_library.ryzd IS '冗余字段';


-- crmdm.cms_contract_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_contract_relative;

CREATE TABLE crmdm.cms_contract_relative (
	serialno varchar(40) NOT NULL, -- 合同流水号字段
	objecttype varchar(18) NOT NULL, -- 合同关联对象类型
	objectno varchar(40) NOT NULL, -- 合同关联对象编号
	relativesum numeric(24, 6) NULL, -- 关联金额
	relationstatus varchar(3) NULL, -- 关联状态
	addtype varchar(30) NULL -- 增加标志
);
CREATE INDEX idx1_cms_contract_relative ON crmdm.cms_contract_relative USING btree (objectno, objecttype);
COMMENT ON TABLE crmdm.cms_contract_relative IS '合同关联表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_contract_relative.serialno IS '合同流水号字段';
COMMENT ON COLUMN crmdm.cms_contract_relative.objecttype IS '合同关联对象类型';
COMMENT ON COLUMN crmdm.cms_contract_relative.objectno IS '合同关联对象编号';
COMMENT ON COLUMN crmdm.cms_contract_relative.relativesum IS '关联金额';
COMMENT ON COLUMN crmdm.cms_contract_relative.relationstatus IS '关联状态';
COMMENT ON COLUMN crmdm.cms_contract_relative.addtype IS '增加标志';


-- crmdm.cms_customer_belong 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_belong;

CREATE TABLE crmdm.cms_customer_belong (
	customerid varchar(40) NOT NULL, -- 客户编号
	orgid varchar(40) NOT NULL, -- 所属机构
	userid varchar(40) NOT NULL, -- 用户编号
	belongattribute varchar(80) NULL, -- 客户主办权
	belongattribute1 varchar(80) NULL, -- 信息查看权
	belongattribute2 varchar(80) NULL, -- 信息维护权
	belongattribute3 varchar(80) NULL, -- 业务申办权
	belongattribute4 varchar(80) NULL, -- 低风险业务办理权
	inputuserid varchar(80) NULL, -- 输入用户编号
	inputorgid varchar(80) NULL, -- 输入机构编号
	inputdate varchar(80) NULL, -- 输入日期
	updatedate varchar(10) NULL, -- 更新日期
	applyattribute varchar(80) NULL, -- 是否申请信息主办权
	applyattribute1 varchar(80) NULL, -- 是否申请信息查看权
	applyattribute2 varchar(80) NULL, -- 是否申请信息维护权
	applyattribute3 varchar(80) NULL, -- 是否申请业务申办权
	applyattribute4 varchar(80) NULL, -- 申请属性4
	remark varchar(250) NULL, -- 备注
	applystatus varchar(20) NULL, -- 权限申请状态
	applyreason varchar(500) NULL, -- 申请理由
	applyright varchar(20) NULL, -- 审批机构号
	applytype varchar(20) NULL, -- 申请类型
	ryzd varchar(1) NULL
);
CREATE UNIQUE INDEX index_crmdm_cms_customer_belong_index_1 ON crmdm.cms_customer_belong USING btree (customerid, orgid, userid);

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_belong.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.orgid IS '所属机构';
COMMENT ON COLUMN crmdm.cms_customer_belong.userid IS '用户编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute IS '客户主办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute1 IS '信息查看权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute2 IS '信息维护权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute3 IS '业务申办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.belongattribute4 IS '低风险业务办理权';
COMMENT ON COLUMN crmdm.cms_customer_belong.inputuserid IS '输入用户编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.inputorgid IS '输入机构编号';
COMMENT ON COLUMN crmdm.cms_customer_belong.inputdate IS '输入日期';
COMMENT ON COLUMN crmdm.cms_customer_belong.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute IS '是否申请信息主办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute1 IS '是否申请信息查看权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute2 IS '是否申请信息维护权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute3 IS '是否申请业务申办权';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyattribute4 IS '申请属性4';
COMMENT ON COLUMN crmdm.cms_customer_belong.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_customer_belong.applystatus IS '权限申请状态';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyreason IS '申请理由';
COMMENT ON COLUMN crmdm.cms_customer_belong.applyright IS '审批机构号';
COMMENT ON COLUMN crmdm.cms_customer_belong.applytype IS '申请类型';


-- crmdm.cms_customer_crm_core 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_crm_core;

CREATE TABLE crmdm.cms_customer_crm_core (
	customerid varchar(32) NULL, -- 客户编号
	customeridcore varchar(32) NULL, -- 核心客户号
	linktime varchar(20) NULL, -- 关联时间
	linkuserid varchar(32) NULL -- 关联操作人
);
CREATE UNIQUE INDEX pk_customer_crm_core ON crmdm.cms_customer_crm_core USING btree (customerid, customeridcore);

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_crm_core.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_customer_crm_core.customeridcore IS '核心客户号';
COMMENT ON COLUMN crmdm.cms_customer_crm_core.linktime IS '关联时间';
COMMENT ON COLUMN crmdm.cms_customer_crm_core.linkuserid IS '关联操作人';


-- crmdm.cms_customer_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_info;

CREATE TABLE crmdm.cms_customer_info (
	customerid varchar(40) NOT NULL, -- 客户编号
	customername varchar(80) NULL, -- 客户名称
	customertype varchar(20) NULL, -- 客户类型
	certtype varchar(20) NULL, -- 证件类型
	certid varchar(40) NULL, -- 证据号
	customerpassword varchar(20) NULL, -- 客户口令
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	remark varchar(250) NULL, -- 备注
	mfcustomerid varchar(40) NULL, -- 核心客户号
	status varchar(20) NULL, -- 认定状态
	belonggroupid varchar(40) NULL, -- 所属集团编号
	channel varchar(18) NULL, -- 来源渠道
	loancardno varchar(32) NULL, -- 贷款卡编号
	customerscale varchar(20) NULL, -- 客户规模（区分中小企业）
	nationcode varchar(40) NULL, -- 证件国别
	forbidstatus varchar(12) NULL, -- 状态
	counterpartytype varchar(10) NULL, -- 交易对手类型
	taxpayertype varchar(10) NULL, -- 纳税人类型
	mystocker varchar(10) NULL, -- 是否我行股东
	oldmfcustomerid varchar(40) NULL, -- 老核心客户号
	isrelacustomer varchar(10) NULL, -- 是否我行关联方
	custriskleve varchar(10) NULL, -- 客户预警等级
	checkbasedate varchar(10) NULL, -- 定期检查基准日
	creditsum numeric(24, 4) NULL, -- 授信金额
	classifyresult varchar(200) NULL, -- 客户风险分类
	linetype varchar(32) NULL, -- 客户条线
	titularsum2 numeric(24, 4) NULL, -- 非传统授信金额
	titularsum1 numeric(24, 4) NULL, -- 传统授信金额
	nominalcreditsum numeric(24, 4) NULL, -- 客户名义授信总额
	nominalcreditbalance numeric(24, 4) NULL, -- 客户名义授信余额
	exposurecreditsum numeric(24, 4) NULL, -- 客户敞口授信总额
	exposurecreditbalance numeric(24, 4) NULL, -- 客户敞口授信余额
	smesystemflag varchar(4) NULL, -- 系统认定条线Codeno：SMESystemFlag
	finalsmeflag varchar(4) NULL, -- 最终认定条线Codeno：SMESystemFlag
	checkbaseriskdate varchar(20) NULL, -- CHECKBASERISKDATE
	onemtotenmflag varchar(10) NULL, -- 单户名义金额在百万至千万间标志
	onemtotenmtime varchar(40) NULL, -- 单户名义金额在百万至千万间判断的时间
	morethantenmflag varchar(10) NULL, -- 单户名义金额大于千万标志
	morethantenmtime varchar(40) NULL, -- 单户名义金额大于千万判断的时间
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_customer_info PRIMARY KEY (customerid)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_info.customerid IS '客户编号                ';
COMMENT ON COLUMN crmdm.cms_customer_info.customername IS '客户名称                ';
COMMENT ON COLUMN crmdm.cms_customer_info.customertype IS '客户类型                ';
COMMENT ON COLUMN crmdm.cms_customer_info.certtype IS '证件类型                ';
COMMENT ON COLUMN crmdm.cms_customer_info.certid IS '证据号                  ';
COMMENT ON COLUMN crmdm.cms_customer_info.customerpassword IS '客户口令                ';
COMMENT ON COLUMN crmdm.cms_customer_info.inputorgid IS '登记机构                ';
COMMENT ON COLUMN crmdm.cms_customer_info.inputuserid IS '登记人                  ';
COMMENT ON COLUMN crmdm.cms_customer_info.inputdate IS '登记日期                ';
COMMENT ON COLUMN crmdm.cms_customer_info.remark IS '备注                    ';
COMMENT ON COLUMN crmdm.cms_customer_info.mfcustomerid IS '核心客户号              ';
COMMENT ON COLUMN crmdm.cms_customer_info.status IS '认定状态                ';
COMMENT ON COLUMN crmdm.cms_customer_info.belonggroupid IS '所属集团编号            ';
COMMENT ON COLUMN crmdm.cms_customer_info.channel IS '来源渠道                ';
COMMENT ON COLUMN crmdm.cms_customer_info.loancardno IS '贷款卡编号              ';
COMMENT ON COLUMN crmdm.cms_customer_info.customerscale IS '客户规模（区分中小企业）';
COMMENT ON COLUMN crmdm.cms_customer_info.nationcode IS '证件国别                ';
COMMENT ON COLUMN crmdm.cms_customer_info.forbidstatus IS '状态                    ';
COMMENT ON COLUMN crmdm.cms_customer_info.counterpartytype IS '交易对手类型            ';
COMMENT ON COLUMN crmdm.cms_customer_info.taxpayertype IS '纳税人类型              ';
COMMENT ON COLUMN crmdm.cms_customer_info.mystocker IS '是否我行股东            ';
COMMENT ON COLUMN crmdm.cms_customer_info.oldmfcustomerid IS '老核心客户号            ';
COMMENT ON COLUMN crmdm.cms_customer_info.isrelacustomer IS '是否我行关联方          ';
COMMENT ON COLUMN crmdm.cms_customer_info.custriskleve IS '客户预警等级            ';
COMMENT ON COLUMN crmdm.cms_customer_info.checkbasedate IS '定期检查基准日          ';
COMMENT ON COLUMN crmdm.cms_customer_info.creditsum IS '授信金额                ';
COMMENT ON COLUMN crmdm.cms_customer_info.classifyresult IS '客户风险分类            ';
COMMENT ON COLUMN crmdm.cms_customer_info.linetype IS '客户条线                ';
COMMENT ON COLUMN crmdm.cms_customer_info.titularsum2 IS '非传统授信金额          ';
COMMENT ON COLUMN crmdm.cms_customer_info.titularsum1 IS '传统授信金额            ';
COMMENT ON COLUMN crmdm.cms_customer_info.nominalcreditsum IS '客户名义授信总额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.nominalcreditbalance IS '客户名义授信余额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.exposurecreditsum IS '客户敞口授信总额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.exposurecreditbalance IS '客户敞口授信余额        ';
COMMENT ON COLUMN crmdm.cms_customer_info.smesystemflag IS '系统认定条线Codeno：SMESystemFlag';
COMMENT ON COLUMN crmdm.cms_customer_info.finalsmeflag IS '最终认定条线Codeno：SMESystemFlag';
COMMENT ON COLUMN crmdm.cms_customer_info.checkbaseriskdate IS 'CHECKBASERISKDATE';
COMMENT ON COLUMN crmdm.cms_customer_info.onemtotenmflag IS '单户名义金额在百万至千万间标志';
COMMENT ON COLUMN crmdm.cms_customer_info.onemtotenmtime IS '单户名义金额在百万至千万间判断的时间';
COMMENT ON COLUMN crmdm.cms_customer_info.morethantenmflag IS '单户名义金额大于千万标志';
COMMENT ON COLUMN crmdm.cms_customer_info.morethantenmtime IS '单户名义金额大于千万判断的时间';
COMMENT ON COLUMN crmdm.cms_customer_info.ryzd IS '冗余字段';


-- crmdm.cms_customer_realty 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_realty;

CREATE TABLE crmdm.cms_customer_realty (
	customerid varchar(40) NOT NULL, -- 客户编号
	serialno varchar(32) NOT NULL, -- 流水号
	certificateno varchar(50) NULL, -- 产权证号
	realtyname varchar(100) NULL, -- 房屋名称
	realtyattribute varchar(18) NULL, -- 房屋性质
	realtyarea numeric(24, 6) NULL, -- 房屋面积
	realtyadd varchar(120) NULL, -- 房屋地址
	buildprice numeric(24, 6) NULL, -- 建购价格
	evaluateprice numeric(24, 6) NULL, -- 评估价格
	shareprop numeric(10, 6) NULL, -- 所占份额
	purchasedate varchar(10) NULL, -- 买入日期
	saledate varchar(10) NULL, -- 卖出日期
	mortagage varchar(18) NULL, -- 房产抵押情况
	uptodate varchar(10) NULL, -- 统计截止日期
	inputorgid varchar(32) NULL, -- 登记机构编号
	inputuserid varchar(32) NULL, -- 登记人编号
	inputdate varchar(10) NULL, -- 登记日期
	updatedate varchar(10) NULL, -- 更新日期
	remark varchar(300) NULL, -- 备注
	realtycontractno varchar(20) NULL, -- 购房合同号
	realtyformat varchar(32) NULL, -- 房屋形式
	realtyrank varchar(32) NULL, -- 购家庭第几套房
	realtyunitprice numeric(24, 6) NULL, -- 单价
	completedate varchar(10) NULL, -- 建成时间
	downpayment numeric(24, 6) NULL, -- 首付金额
	downpaymentrate numeric(10, 6) NULL, -- 首付比例
	downpaymentsource varchar(32) NULL, -- 首付款来源
	realtyprovider varchar(60) NULL, -- 开发商名称
	buildstructure varchar(80) NULL -- 建构架构
);
COMMENT ON TABLE crmdm.cms_customer_realty IS '客户房产资产信息';

-- Column comments

COMMENT ON COLUMN crmdm.cms_customer_realty.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_customer_realty.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_customer_realty.certificateno IS '产权证号';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyname IS '房屋名称';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyattribute IS '房屋性质';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyarea IS '房屋面积';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyadd IS '房屋地址';
COMMENT ON COLUMN crmdm.cms_customer_realty.buildprice IS '建购价格';
COMMENT ON COLUMN crmdm.cms_customer_realty.evaluateprice IS '评估价格';
COMMENT ON COLUMN crmdm.cms_customer_realty.shareprop IS '所占份额';
COMMENT ON COLUMN crmdm.cms_customer_realty.purchasedate IS '买入日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.saledate IS '卖出日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.mortagage IS '房产抵押情况';
COMMENT ON COLUMN crmdm.cms_customer_realty.uptodate IS '统计截止日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.inputorgid IS '登记机构编号';
COMMENT ON COLUMN crmdm.cms_customer_realty.inputuserid IS '登记人编号';
COMMENT ON COLUMN crmdm.cms_customer_realty.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_customer_realty.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtycontractno IS '购房合同号';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyformat IS '房屋形式';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyrank IS '购家庭第几套房';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyunitprice IS '单价';
COMMENT ON COLUMN crmdm.cms_customer_realty.completedate IS '建成时间';
COMMENT ON COLUMN crmdm.cms_customer_realty.downpayment IS '首付金额';
COMMENT ON COLUMN crmdm.cms_customer_realty.downpaymentrate IS '首付比例';
COMMENT ON COLUMN crmdm.cms_customer_realty.downpaymentsource IS '首付款来源';
COMMENT ON COLUMN crmdm.cms_customer_realty.realtyprovider IS '开发商名称';
COMMENT ON COLUMN crmdm.cms_customer_realty.buildstructure IS '建构架构';


-- crmdm.cms_customer_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_customer_relative;

CREATE TABLE crmdm.cms_customer_relative (
	customerid varchar(40) NULL,
	relativeid varchar(32) NULL,
	relationship varchar(18) NULL,
	customername varchar(80) NULL,
	certtype varchar(18) NULL,
	certid varchar(40) NULL,
	fictitiousperson varchar(80) NULL,
	currencytype varchar(18) NULL,
	investmentsum numeric(24, 6) NULL,
	oughtsum numeric(24, 6) NULL,
	investmentprop numeric(10, 6) NULL,
	investdate varchar(10) NULL,
	duty varchar(18) NULL,
	telephone varchar(32) NULL,
	inputorgid varchar(80) NULL,
	inputuserid varchar(80) NULL,
	inputdate varchar(10) NULL,
	updatedate varchar(10) NULL,
	remark varchar(200) NULL,
	sex varchar(18) NULL,
	birthday varchar(10) NULL,
	sino varchar(32) NULL,
	familyadd varchar(200) NULL,
	familyzip varchar(32) NULL,
	eduexperience varchar(18) NULL,
	investyield numeric(24, 6) NULL,
	holddate varchar(10) NULL,
	engageterm numeric(22) NULL,
	holdstock varchar(200) NULL,
	loancardno varchar(32) NULL,
	effstatus varchar(1) NULL,
	customertype varchar(10) NULL,
	describea varchar(350) NULL,
	actualcontroller varchar(10) NULL,
	ecifid varchar(20) NULL
);


-- crmdm.cms_ent_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_ent_info;

CREATE TABLE crmdm.cms_ent_info (
	customerid varchar(40) NOT NULL, -- 客户编号
	corpid varchar(32) NULL, -- 证件号码
	enterprisename varchar(80) NULL, -- 客户名称
	englishname varchar(80) NULL, -- 客户英文名
	fictitiousperson varchar(80) NULL, -- 法定代表人
	orgnature varchar(18) NULL, -- 机构类型
	financetype varchar(18) NULL, -- 金融机构类型
	enterprisebelong varchar(18) NULL, -- 企业隶属
	industrytype varchar(18) NULL, -- 国标行业分类
	industrytype1 varchar(18) NULL, -- 行业类型一
	industrytype2 varchar(18) NULL, -- 行业类型二
	private varchar(18) NULL, -- 民营标志
	economytype varchar(18) NULL, -- 经济类型
	orgtype varchar(18) NULL, -- 企业类型
	mostbusiness varchar(1600) NULL, -- 经营范围
	budgettype varchar(18) NULL, -- 预算管理类型
	rccurrency varchar(18) NULL, -- 注册资本币种
	registercapital numeric(24, 6) NULL, -- 注册资本
	pccurrency varchar(18) NULL, -- 实收资本币种
	paiclupcapital numeric(24, 6) NULL, -- 实收资本
	fundsource varchar(200) NULL, -- 经费来源
	totalassets numeric(24, 6) NULL, -- 总资产
	netassets numeric(24, 6) NULL, -- 净资产
	annualincome numeric(24, 6) NULL, -- 年收入
	"scope" varchar(18) NULL, -- 企业规模
	creditdate varchar(10) NULL, -- 与我行建立信贷关系时间
	licenseno varchar(32) NULL, -- 工商营业执照号码
	licensedate varchar(10) NULL, -- 营业执照登记日
	licensematurity varchar(10) NULL, -- 营业执照到期日
	setupdate varchar(10) NULL, -- 企业成立日期
	inspectionyear varchar(10) NULL, -- 工商执照最新年检年份
	locksituation varchar(200) NULL, -- 工商局锁定情况
	taxno varchar(32) NULL, -- 税务登记证号(国税)
	banklicense varchar(32) NULL, -- 金融机构许可证代码
	managearea varchar(200) NULL, -- 金融机构经营区域范围
	banchamount numeric NULL, -- 金融机构一级分支机构数量
	exchangeid varchar(32) NULL, -- 交换号
	registeradd varchar(160) NULL, -- 注册地址
	chargedepartment varchar(80) NULL, -- 上级主管单位
	officeadd varchar(160) NULL, -- 办公地址
	officezip varchar(32) NULL, -- 注册地址邮政编码
	countrycode varchar(18) NULL, -- 所在国家(地区)
	regioncode varchar(18) NULL, -- 省份、直辖市、自治区
	villagecode varchar(18) NULL, -- 所属乡镇代码
	villagename varchar(80) NULL, -- 所属乡镇名称
	relativetype varchar(200) NULL, -- 机构电话
	officetel varchar(32) NULL, -- 联系电话
	officefax varchar(32) NULL, -- 传真电话
	webadd varchar(80) NULL, -- 公司网址
	emailadd varchar(80) NULL, -- 公司E－Mail
	employeenumber numeric NULL, -- 职工人数
	mainproduction varchar(800) NULL, -- 主要产品情况
	newtechcorpornot varchar(18) NULL, -- 是否高新技术企业
	listingcorpornot varchar(18) NULL, -- 上市公司类型
	hasieright varchar(18) NULL, -- 有无进出口经营权
	hasdirectorate varchar(18) NULL, -- 有无董事会
	basicbank varchar(80) NULL, -- 基本帐户行
	basicaccount varchar(32) NULL, -- 基本帐户号
	manageinfo varchar(800) NULL, -- 合法经营情况
	customerhistory varchar(800) NULL, -- 客户历史沿革、管理水平简介
	projectflag varchar(18) NULL, -- 企业目前是否有项目
	realtyflag varchar(18) NULL, -- 是否从事房地产开发
	workfieldarea numeric NULL, -- 经营场地面积
	workfieldfee varchar(18) NULL, -- 经营场地所有权
	accountdate varchar(10) NULL, -- 在我行首次开立账户时间
	loancardno varchar(32) NULL, -- 贷款卡号
	loancardpassword varchar(32) NULL, -- 贷款卡密码
	loancardinsyear varchar(10) NULL, -- 贷款卡最新年审年份
	loancardinsresult varchar(200) NULL, -- 贷款卡最新年审结果
	loanflag varchar(18) NULL, -- 贷款卡是否有效
	financeornot varchar(18) NULL, -- 是否无需提供财报
	financebelong varchar(18) NULL, -- 财务报表类型
	creditbelong varchar(18) NULL, -- 信用等级评估模板名称
	creditlevel varchar(80) NULL, -- 本行即期信用等级
	evaluatedate varchar(10) NULL, -- 评估日期
	othercreditlevel varchar(80) NULL, -- 外部机构评级结果
	otherevaluatedate varchar(10) NULL, -- 外部机构评级日期
	otherorgname varchar(80) NULL, -- 外部评级机构名称
	inputorgid varchar(32) NULL, -- 登记机构
	inputuserid varchar(32) NULL, -- 登记人
	inputdate varchar(10) NULL, -- 登记日期
	updateorgid varchar(32) NULL, -- 更新机构
	updateuserid varchar(32) NULL, -- 更新人员
	updatedate varchar(10) NULL, -- 更新日期
	remark varchar(200) NULL, -- 备注
	taxno1 varchar(32) NULL, -- 税务登记证号(地税)
	fictitiouspersonid varchar(32) NULL, -- 法定代表人身份证号码
	groupflag varchar(18) NULL, -- 集团客户标志
	evaluatelevel varchar(18) NULL, -- 评估级别
	mybank varchar(80) NULL, -- 我行开户行
	mybankaccount varchar(32) NULL, -- 我行开户帐号
	otherbank varchar(80) NULL, -- 他行开户行
	otherbankaccount varchar(32) NULL, -- 他行开户帐号
	tempsaveflag varchar(18) NULL, -- 暂存标志
	financedepttel varchar(32) NULL, -- 财务部联系电话
	ecgroupflag varchar(18) NULL, -- 是否征信标准集团客户
	supercorpname varchar(80) NULL, -- 上级公司名称
	superloancardno varchar(32) NULL, -- 上级公司贷款卡编号
	supercerttype varchar(18) NULL, -- 上级公司证件类型
	smeindustrytype varchar(10) NULL, -- 中小企业行业类型
	sellsum numeric(24, 6) NULL, -- 年销售额
	supercertid varchar(32) NULL, -- 上级公司组织机构代码
	officecountrycode varchar(18) NULL, -- 办公地址所在国家
	officeregioncode varchar(18) NULL, -- 办公地址所在省市区
	registerzip varchar(32) NULL, -- 注册地邮编
	limitck numeric(24, 6) NULL, -- 最高限额参考
	sillerent varchar(2) NULL, -- 资金公司
	industrialadjust varchar(10) NULL, -- 工业调整
	industrialupgrading varchar(10) NULL, -- 是否企业调整
	newindustry varchar(10) NULL, -- 新企业
	czcountryent varchar(10) NULL, -- 所处国家
	isfarming varchar(10) NULL, -- 是否产业
	czareaname varchar(50) NULL, -- 区域的名称
	registeraddecifid varchar(20) NULL, -- 注册地址ECIFID
	officeaddecifid varchar(20) NULL, -- 办公地址ECIFID
	officetelecifid varchar(20) NULL, -- 联系电话ECIFID
	officefaxecifid varchar(20) NULL, -- 传真电话ECIFID
	relativetypeecifid varchar(20) NULL, -- 机构电话ECIFID
	emailaddecifid varchar(20) NULL, -- 公司E－MailECIFID
	webaddecifid varchar(20) NULL, -- 公司网址ECIFID
	unitycreditcode varchar(32) NULL, -- 社会统一信用代码
	entnature varchar(32) NULL, -- 企业性质
	otherreceivables numeric(24, 6) NULL, -- 关联证书
	czarea varchar(18) NULL, -- 所处区域
	listingtype varchar(10) NULL, -- 上市类型
	listingcountry varchar(10) NULL, -- 上市国家
	listingcorpnumber varchar(10) NULL, -- 上市机构
	financedate varchar(18) NULL, -- 上市时间
	totaldebt numeric(24, 6) NULL, -- 总资产
	officeaddcode varchar(10) NULL, -- 办公地址所在国家
	jxscope varchar(18) NULL, -- 公司领域
	openaccontlicense varchar(32) NULL, -- 开户许可证号
	regulatoryrating varchar(10) NULL, -- 监管评级结果
	ratingfirmriting varchar(10) NULL, -- 评级公司评级结果
	bankshareholder varchar(10) NULL, -- 是否本行股东
	listingplace varchar(50) NULL, -- 上市地点
	interbankquota numeric(24, 6) NULL, -- 人民银行同意开办同业拆借的额度
	taxpayerid varchar(50) NULL, -- 纳税人识别号
	standardevlaresult varchar(10) NULL, -- 标普评级结果
	moodyevlaresult varchar(10) NULL, -- 穆迪评级结果
	otherevlaresult varchar(10) NULL, -- 其他可参考评级结果
	bankid varchar(32) NULL, -- 金融机构代码
	regdate varchar(10) NULL, -- 金融机构代码
	fitchratresult varchar(10) NULL, -- 惠誉评级结果
	hightechent varchar(10) NULL, -- 是否高科技企业
	accountbussdate varchar(10) NULL, -- 首次发起业务的时间
	otherreceive numeric(24, 6) NULL, -- 其他应收款项
	department varchar(80) NULL, -- 主管单位
	interregion varchar(18) NULL, -- 所在国内地区
	countryrisk varchar(18) NULL, -- 国别风险
	certificatenum varchar(32) NULL, -- 法人证书编号
	isfirstloanuser varchar(2) NULL, -- 是否首贷户
	firstloandate varchar(10) NULL, -- 首贷年月
	lastyearemployees numeric(24, 6) NULL, -- 上年末从业人数（个）
	lastyearbusinessincome numeric(24, 6) NULL, -- 上年度营业收入（元）
	lastyeartotalassets numeric(24, 6) NULL, -- 上年末资产总额（元）
	systemscope varchar(10) NULL, -- 系统企业规模
	isspecialandnew varchar(2) NULL, -- 是否专精特新
	belonggroupname varchar(80) NULL, -- 客户所属集团名称
	isnewagriculture varchar(2) NULL, -- 是否新型农业经营主体
	tjaddrcode varchar(20) NULL, -- 注册地址统计用行政区划代码
	isfarmer varchar(8) NULL, -- 个体工商户是否农户(2-否 1-是)
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_cms_ent_info PRIMARY KEY (customerid)
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_ent_info.customerid IS '客户编号';
COMMENT ON COLUMN crmdm.cms_ent_info.corpid IS '证件号码';
COMMENT ON COLUMN crmdm.cms_ent_info.enterprisename IS '客户名称';
COMMENT ON COLUMN crmdm.cms_ent_info.englishname IS '客户英文名';
COMMENT ON COLUMN crmdm.cms_ent_info.fictitiousperson IS '法定代表人';
COMMENT ON COLUMN crmdm.cms_ent_info.orgnature IS '机构类型';
COMMENT ON COLUMN crmdm.cms_ent_info.financetype IS '金融机构类型';
COMMENT ON COLUMN crmdm.cms_ent_info.enterprisebelong IS '企业隶属';
COMMENT ON COLUMN crmdm.cms_ent_info.industrytype IS '国标行业分类';
COMMENT ON COLUMN crmdm.cms_ent_info.industrytype1 IS '行业类型一';
COMMENT ON COLUMN crmdm.cms_ent_info.industrytype2 IS '行业类型二';
COMMENT ON COLUMN crmdm.cms_ent_info.private IS '民营标志';
COMMENT ON COLUMN crmdm.cms_ent_info.economytype IS '经济类型';
COMMENT ON COLUMN crmdm.cms_ent_info.orgtype IS '企业类型';
COMMENT ON COLUMN crmdm.cms_ent_info.mostbusiness IS '经营范围';
COMMENT ON COLUMN crmdm.cms_ent_info.budgettype IS '预算管理类型';
COMMENT ON COLUMN crmdm.cms_ent_info.rccurrency IS '注册资本币种';
COMMENT ON COLUMN crmdm.cms_ent_info.registercapital IS '注册资本';
COMMENT ON COLUMN crmdm.cms_ent_info.pccurrency IS '实收资本币种';
COMMENT ON COLUMN crmdm.cms_ent_info.paiclupcapital IS '实收资本';
COMMENT ON COLUMN crmdm.cms_ent_info.fundsource IS '经费来源';
COMMENT ON COLUMN crmdm.cms_ent_info.totalassets IS '总资产';
COMMENT ON COLUMN crmdm.cms_ent_info.netassets IS '净资产';
COMMENT ON COLUMN crmdm.cms_ent_info.annualincome IS '年收入';
COMMENT ON COLUMN crmdm.cms_ent_info."scope" IS '企业规模';
COMMENT ON COLUMN crmdm.cms_ent_info.creditdate IS '与我行建立信贷关系时间';
COMMENT ON COLUMN crmdm.cms_ent_info.licenseno IS '工商营业执照号码';
COMMENT ON COLUMN crmdm.cms_ent_info.licensedate IS '营业执照登记日';
COMMENT ON COLUMN crmdm.cms_ent_info.licensematurity IS '营业执照到期日';
COMMENT ON COLUMN crmdm.cms_ent_info.setupdate IS '企业成立日期';
COMMENT ON COLUMN crmdm.cms_ent_info.inspectionyear IS '工商执照最新年检年份';
COMMENT ON COLUMN crmdm.cms_ent_info.locksituation IS '工商局锁定情况';
COMMENT ON COLUMN crmdm.cms_ent_info.taxno IS '税务登记证号(国税)';
COMMENT ON COLUMN crmdm.cms_ent_info.banklicense IS '金融机构许可证代码';
COMMENT ON COLUMN crmdm.cms_ent_info.managearea IS '金融机构经营区域范围';
COMMENT ON COLUMN crmdm.cms_ent_info.banchamount IS '金融机构一级分支机构数量';
COMMENT ON COLUMN crmdm.cms_ent_info.exchangeid IS '交换号';
COMMENT ON COLUMN crmdm.cms_ent_info.registeradd IS '注册地址';
COMMENT ON COLUMN crmdm.cms_ent_info.chargedepartment IS '上级主管单位';
COMMENT ON COLUMN crmdm.cms_ent_info.officeadd IS '办公地址';
COMMENT ON COLUMN crmdm.cms_ent_info.officezip IS '注册地址邮政编码';
COMMENT ON COLUMN crmdm.cms_ent_info.countrycode IS '所在国家(地区)';
COMMENT ON COLUMN crmdm.cms_ent_info.regioncode IS '省份、直辖市、自治区';
COMMENT ON COLUMN crmdm.cms_ent_info.villagecode IS '所属乡镇代码';
COMMENT ON COLUMN crmdm.cms_ent_info.villagename IS '所属乡镇名称';
COMMENT ON COLUMN crmdm.cms_ent_info.relativetype IS '机构电话';
COMMENT ON COLUMN crmdm.cms_ent_info.officetel IS '联系电话';
COMMENT ON COLUMN crmdm.cms_ent_info.officefax IS '传真电话';
COMMENT ON COLUMN crmdm.cms_ent_info.webadd IS '公司网址';
COMMENT ON COLUMN crmdm.cms_ent_info.emailadd IS '公司E－Mail';
COMMENT ON COLUMN crmdm.cms_ent_info.employeenumber IS '职工人数';
COMMENT ON COLUMN crmdm.cms_ent_info.mainproduction IS '主要产品情况';
COMMENT ON COLUMN crmdm.cms_ent_info.newtechcorpornot IS '是否高新技术企业';
COMMENT ON COLUMN crmdm.cms_ent_info.listingcorpornot IS '上市公司类型';
COMMENT ON COLUMN crmdm.cms_ent_info.hasieright IS '有无进出口经营权';
COMMENT ON COLUMN crmdm.cms_ent_info.hasdirectorate IS '有无董事会';
COMMENT ON COLUMN crmdm.cms_ent_info.basicbank IS '基本帐户行';
COMMENT ON COLUMN crmdm.cms_ent_info.basicaccount IS '基本帐户号';
COMMENT ON COLUMN crmdm.cms_ent_info.manageinfo IS '合法经营情况';
COMMENT ON COLUMN crmdm.cms_ent_info.customerhistory IS '客户历史沿革、管理水平简介';
COMMENT ON COLUMN crmdm.cms_ent_info.projectflag IS '企业目前是否有项目';
COMMENT ON COLUMN crmdm.cms_ent_info.realtyflag IS '是否从事房地产开发';
COMMENT ON COLUMN crmdm.cms_ent_info.workfieldarea IS '经营场地面积';
COMMENT ON COLUMN crmdm.cms_ent_info.workfieldfee IS '经营场地所有权';
COMMENT ON COLUMN crmdm.cms_ent_info.accountdate IS '在我行首次开立账户时间';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardno IS '贷款卡号';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardpassword IS '贷款卡密码';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardinsyear IS '贷款卡最新年审年份';
COMMENT ON COLUMN crmdm.cms_ent_info.loancardinsresult IS '贷款卡最新年审结果';
COMMENT ON COLUMN crmdm.cms_ent_info.loanflag IS '贷款卡是否有效';
COMMENT ON COLUMN crmdm.cms_ent_info.financeornot IS '是否无需提供财报';
COMMENT ON COLUMN crmdm.cms_ent_info.financebelong IS '财务报表类型';
COMMENT ON COLUMN crmdm.cms_ent_info.creditbelong IS '信用等级评估模板名称';
COMMENT ON COLUMN crmdm.cms_ent_info.creditlevel IS '本行即期信用等级';
COMMENT ON COLUMN crmdm.cms_ent_info.evaluatedate IS '评估日期';
COMMENT ON COLUMN crmdm.cms_ent_info.othercreditlevel IS '外部机构评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.otherevaluatedate IS '外部机构评级日期';
COMMENT ON COLUMN crmdm.cms_ent_info.otherorgname IS '外部评级机构名称';
COMMENT ON COLUMN crmdm.cms_ent_info.inputorgid IS '登记机构';
COMMENT ON COLUMN crmdm.cms_ent_info.inputuserid IS '登记人';
COMMENT ON COLUMN crmdm.cms_ent_info.inputdate IS '登记日期';
COMMENT ON COLUMN crmdm.cms_ent_info.updateorgid IS '更新机构';
COMMENT ON COLUMN crmdm.cms_ent_info.updateuserid IS '更新人员';
COMMENT ON COLUMN crmdm.cms_ent_info.updatedate IS '更新日期';
COMMENT ON COLUMN crmdm.cms_ent_info.remark IS '备注';
COMMENT ON COLUMN crmdm.cms_ent_info.taxno1 IS '税务登记证号(地税)';
COMMENT ON COLUMN crmdm.cms_ent_info.fictitiouspersonid IS '法定代表人身份证号码';
COMMENT ON COLUMN crmdm.cms_ent_info.groupflag IS '集团客户标志';
COMMENT ON COLUMN crmdm.cms_ent_info.evaluatelevel IS '评估级别';
COMMENT ON COLUMN crmdm.cms_ent_info.mybank IS '我行开户行';
COMMENT ON COLUMN crmdm.cms_ent_info.mybankaccount IS '我行开户帐号';
COMMENT ON COLUMN crmdm.cms_ent_info.otherbank IS '他行开户行';
COMMENT ON COLUMN crmdm.cms_ent_info.otherbankaccount IS '他行开户帐号';
COMMENT ON COLUMN crmdm.cms_ent_info.tempsaveflag IS '暂存标志';
COMMENT ON COLUMN crmdm.cms_ent_info.financedepttel IS '财务部联系电话';
COMMENT ON COLUMN crmdm.cms_ent_info.ecgroupflag IS '是否征信标准集团客户';
COMMENT ON COLUMN crmdm.cms_ent_info.supercorpname IS '上级公司名称';
COMMENT ON COLUMN crmdm.cms_ent_info.superloancardno IS '上级公司贷款卡编号';
COMMENT ON COLUMN crmdm.cms_ent_info.supercerttype IS '上级公司证件类型';
COMMENT ON COLUMN crmdm.cms_ent_info.smeindustrytype IS '中小企业行业类型';
COMMENT ON COLUMN crmdm.cms_ent_info.sellsum IS '年销售额';
COMMENT ON COLUMN crmdm.cms_ent_info.supercertid IS '上级公司组织机构代码';
COMMENT ON COLUMN crmdm.cms_ent_info.officecountrycode IS '办公地址所在国家';
COMMENT ON COLUMN crmdm.cms_ent_info.officeregioncode IS '办公地址所在省市区';
COMMENT ON COLUMN crmdm.cms_ent_info.registerzip IS '注册地邮编';
COMMENT ON COLUMN crmdm.cms_ent_info.limitck IS '最高限额参考';
COMMENT ON COLUMN crmdm.cms_ent_info.sillerent IS '资金公司';
COMMENT ON COLUMN crmdm.cms_ent_info.industrialadjust IS '工业调整';
COMMENT ON COLUMN crmdm.cms_ent_info.industrialupgrading IS '是否企业调整';
COMMENT ON COLUMN crmdm.cms_ent_info.newindustry IS '新企业';
COMMENT ON COLUMN crmdm.cms_ent_info.czcountryent IS '所处国家';
COMMENT ON COLUMN crmdm.cms_ent_info.isfarming IS '是否产业';
COMMENT ON COLUMN crmdm.cms_ent_info.czareaname IS '区域的名称';
COMMENT ON COLUMN crmdm.cms_ent_info.registeraddecifid IS '注册地址ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.officeaddecifid IS '办公地址ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.officetelecifid IS '联系电话ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.officefaxecifid IS '传真电话ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.relativetypeecifid IS '机构电话ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.emailaddecifid IS '公司E－MailECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.webaddecifid IS '公司网址ECIFID';
COMMENT ON COLUMN crmdm.cms_ent_info.unitycreditcode IS '社会统一信用代码';
COMMENT ON COLUMN crmdm.cms_ent_info.entnature IS '企业性质';
COMMENT ON COLUMN crmdm.cms_ent_info.otherreceivables IS '关联证书';
COMMENT ON COLUMN crmdm.cms_ent_info.czarea IS '所处区域';
COMMENT ON COLUMN crmdm.cms_ent_info.listingtype IS '上市类型';
COMMENT ON COLUMN crmdm.cms_ent_info.listingcountry IS '上市国家';
COMMENT ON COLUMN crmdm.cms_ent_info.listingcorpnumber IS '上市机构';
COMMENT ON COLUMN crmdm.cms_ent_info.financedate IS '上市时间';
COMMENT ON COLUMN crmdm.cms_ent_info.totaldebt IS '总资产';
COMMENT ON COLUMN crmdm.cms_ent_info.officeaddcode IS '办公地址所在国家';
COMMENT ON COLUMN crmdm.cms_ent_info.jxscope IS '公司领域';
COMMENT ON COLUMN crmdm.cms_ent_info.openaccontlicense IS '开户许可证号';
COMMENT ON COLUMN crmdm.cms_ent_info.regulatoryrating IS '监管评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.ratingfirmriting IS '评级公司评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.bankshareholder IS '是否本行股东';
COMMENT ON COLUMN crmdm.cms_ent_info.listingplace IS '上市地点';
COMMENT ON COLUMN crmdm.cms_ent_info.interbankquota IS '人民银行同意开办同业拆借的额度';
COMMENT ON COLUMN crmdm.cms_ent_info.taxpayerid IS '纳税人识别号';
COMMENT ON COLUMN crmdm.cms_ent_info.standardevlaresult IS '标普评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.moodyevlaresult IS '穆迪评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.otherevlaresult IS '其他可参考评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.bankid IS '金融机构代码';
COMMENT ON COLUMN crmdm.cms_ent_info.regdate IS '金融机构代码';
COMMENT ON COLUMN crmdm.cms_ent_info.fitchratresult IS '惠誉评级结果';
COMMENT ON COLUMN crmdm.cms_ent_info.hightechent IS '是否高科技企业';
COMMENT ON COLUMN crmdm.cms_ent_info.accountbussdate IS '首次发起业务的时间';
COMMENT ON COLUMN crmdm.cms_ent_info.otherreceive IS '其他应收款项';
COMMENT ON COLUMN crmdm.cms_ent_info.department IS '主管单位';
COMMENT ON COLUMN crmdm.cms_ent_info.interregion IS '所在国内地区';
COMMENT ON COLUMN crmdm.cms_ent_info.countryrisk IS '国别风险';
COMMENT ON COLUMN crmdm.cms_ent_info.certificatenum IS '法人证书编号';
COMMENT ON COLUMN crmdm.cms_ent_info.isfirstloanuser IS '是否首贷户';
COMMENT ON COLUMN crmdm.cms_ent_info.firstloandate IS '首贷年月';
COMMENT ON COLUMN crmdm.cms_ent_info.lastyearemployees IS '上年末从业人数（个）';
COMMENT ON COLUMN crmdm.cms_ent_info.lastyearbusinessincome IS '上年度营业收入（元）';
COMMENT ON COLUMN crmdm.cms_ent_info.lastyeartotalassets IS '上年末资产总额（元）';
COMMENT ON COLUMN crmdm.cms_ent_info.systemscope IS '系统企业规模';
COMMENT ON COLUMN crmdm.cms_ent_info.isspecialandnew IS '是否专精特新';
COMMENT ON COLUMN crmdm.cms_ent_info.belonggroupname IS '客户所属集团名称';
COMMENT ON COLUMN crmdm.cms_ent_info.isnewagriculture IS '是否新型农业经营主体';
COMMENT ON COLUMN crmdm.cms_ent_info.tjaddrcode IS '注册地址统计用行政区划代码';
COMMENT ON COLUMN crmdm.cms_ent_info.isfarmer IS '个体工商户是否农户(2-否 1-是)';
COMMENT ON COLUMN crmdm.cms_ent_info.ryzd IS '冗余字段';


-- crmdm.cms_funds_data 定义

-- Drop table

-- DROP TABLE crmdm.cms_funds_data;

CREATE TABLE crmdm.cms_funds_data (
	serialno varchar(32) NOT NULL, -- 流水号
	xingming varchar(120) NULL, -- 客户姓名
	zjlx varchar(2) NULL, -- 证件类型
	zjhm varchar(18) NULL, -- 证件号码
	dwmc varchar(255) NULL, -- 单位名称
	dwzh varchar(100) NULL, -- 单位账号
	khrq varchar(30) NULL, -- 账户的开户日期
	grzhzt varchar(2) NULL, -- 个人帐户状态
	grjcjs numeric(18, 2) NULL, -- 个人缴存基数
	grjcbl numeric(4, 2) NULL, -- 个人缴存比例
	yje numeric(18, 2) NULL, -- 公积金月缴存
	jzny varchar(10) NULL, -- 缴至年月
	grzhye numeric(18, 2) NULL, -- 个人账户余额
	fwzj numeric(18, 2) NULL, -- 公积金贷款房屋总额
	htdkje numeric(18, 2) NULL, -- 公积金贷款金额
	dkqs int4 NULL, -- 贷款期数
	zxll numeric(8, 7) NULL, -- 利率
	yhke numeric(18, 2) NULL, -- 月还款额
	yqzt varchar(6) NULL, -- 当期逾期状态
	dkye numeric(18, 2) NULL, -- 公积金贷款余额
	inputdate varchar(10) NULL -- 录入日期
);
COMMENT ON TABLE crmdm.cms_funds_data IS '公积金数据表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_funds_data.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_funds_data.xingming IS '客户姓名';
COMMENT ON COLUMN crmdm.cms_funds_data.zjlx IS '证件类型';
COMMENT ON COLUMN crmdm.cms_funds_data.zjhm IS '证件号码';
COMMENT ON COLUMN crmdm.cms_funds_data.dwmc IS '单位名称';
COMMENT ON COLUMN crmdm.cms_funds_data.dwzh IS '单位账号';
COMMENT ON COLUMN crmdm.cms_funds_data.khrq IS '账户的开户日期';
COMMENT ON COLUMN crmdm.cms_funds_data.grzhzt IS '个人帐户状态';
COMMENT ON COLUMN crmdm.cms_funds_data.grjcjs IS '个人缴存基数';
COMMENT ON COLUMN crmdm.cms_funds_data.grjcbl IS '个人缴存比例';
COMMENT ON COLUMN crmdm.cms_funds_data.yje IS '公积金月缴存';
COMMENT ON COLUMN crmdm.cms_funds_data.jzny IS '缴至年月';
COMMENT ON COLUMN crmdm.cms_funds_data.grzhye IS '个人账户余额';
COMMENT ON COLUMN crmdm.cms_funds_data.fwzj IS '公积金贷款房屋总额';
COMMENT ON COLUMN crmdm.cms_funds_data.htdkje IS '公积金贷款金额';
COMMENT ON COLUMN crmdm.cms_funds_data.dkqs IS '贷款期数';
COMMENT ON COLUMN crmdm.cms_funds_data.zxll IS '利率';
COMMENT ON COLUMN crmdm.cms_funds_data.yhke IS '月还款额';
COMMENT ON COLUMN crmdm.cms_funds_data.yqzt IS '当期逾期状态';
COMMENT ON COLUMN crmdm.cms_funds_data.dkye IS '公积金贷款余额';
COMMENT ON COLUMN crmdm.cms_funds_data.inputdate IS '录入日期';


-- crmdm.cms_funds_data_detail 定义

-- Drop table

-- DROP TABLE crmdm.cms_funds_data_detail;

CREATE TABLE crmdm.cms_funds_data_detail (
	serialno varchar(32) NOT NULL, -- 流水号
	relativeserialno varchar(32) NOT NULL, -- 关联流水号
	zhaiyao varchar(50) NULL, -- 最近12期汇缴明细(账户流水信息表中备注)
	jkfse numeric(24, 6) NULL -- 最近12期缴存明细
);
COMMENT ON TABLE crmdm.cms_funds_data_detail IS '公积金汇缴详情信息表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_funds_data_detail.serialno IS '流水号';
COMMENT ON COLUMN crmdm.cms_funds_data_detail.relativeserialno IS '关联流水号';
COMMENT ON COLUMN crmdm.cms_funds_data_detail.zhaiyao IS '最近12期汇缴明细(账户流水信息表中备注)';
COMMENT ON COLUMN crmdm.cms_funds_data_detail.jkfse IS '最近12期缴存明细';


-- crmdm.cms_gjjaccount_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_gjjaccount_info;

CREATE TABLE crmdm.cms_gjjaccount_info (
	relativeno varchar(40) NULL, -- 编号
	certtype varchar(8) NULL, -- CERTTYPE
	authpersonid varchar(18) NULL, -- AUTHPERSONID
	etpscode varchar(32) NULL, -- 单位客户号
	etpsname varchar(128) NULL, -- 单位客户名称
	depmonth varchar(12) NULL, -- 缴存至年月
	depamt varchar(18) NULL, -- 个人缴存基数
	etpsdepamt varchar(18) NULL, -- 单位月缴存额
	indvdepamt varchar(18) NULL, -- 个人月缴存额
	etpsdeprat varchar(6) NULL, -- 单位缴存比例
	indvdeprat varchar(6) NULL, -- 个人缴存比例
	opendate varchar(12) NULL, -- 开户日期
	lastyearbal varchar(18) NULL, -- 上年度余额
	thisyearbal varchar(18) NULL, -- 个人账户余额
	acctflag varchar(8) NULL, -- 缴存状态
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.cms_gjjaccount_info.relativeno IS '编号';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.certtype IS 'CERTTYPE';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.authpersonid IS 'AUTHPERSONID';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpscode IS '单位客户号';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpsname IS '单位客户名称';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.depmonth IS '缴存至年月';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.depamt IS '个人缴存基数';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpsdepamt IS '单位月缴存额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.indvdepamt IS '个人月缴存额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.etpsdeprat IS '单位缴存比例';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.indvdeprat IS '个人缴存比例';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.opendate IS '开户日期';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.lastyearbal IS '上年度余额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.thisyearbal IS '个人账户余额';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.acctflag IS '缴存状态';
COMMENT ON COLUMN crmdm.cms_gjjaccount_info.ryzd IS '冗余字段';


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


-- crmdm.cms_guaranty_relative 定义

-- Drop table

-- DROP TABLE crmdm.cms_guaranty_relative;

CREATE TABLE crmdm.cms_guaranty_relative (
	objecttype varchar(30) NOT NULL, -- 担保关联对象类型
	objectno varchar(40) NOT NULL, -- 担保关联对象编号
	contractno varchar(40) NOT NULL, -- 担保合同流水号字段
	guarantyid varchar(40) NOT NULL, -- 抵质押物编号
	channel varchar(18) NULL, -- 关联关系来源渠道
	status varchar(18) NULL, -- 有效标志
	othersrightid varchar(32) NULL, -- 他项权证号
	guarantysum varchar(32) NULL, -- 担保债权金额
	payorder varchar(18) NULL, -- 受偿次序
	"type" varchar(18) NULL, -- 数据来源类型
	relationstatus varchar(3) NULL, -- 关联有效标志
	describea varchar(250) NULL -- 描述
);
CREATE INDEX idx1_cms_guaranty_relative ON crmdm.cms_guaranty_relative USING btree (objectno, objecttype);
CREATE INDEX idx2_cms_guaranty_relative ON crmdm.cms_guaranty_relative USING btree (contractno);
COMMENT ON TABLE crmdm.cms_guaranty_relative IS '业务合同、担保合同与担保物关联表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_guaranty_relative.objecttype IS '担保关联对象类型';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.objectno IS '担保关联对象编号';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.contractno IS '担保合同流水号字段';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.guarantyid IS '抵质押物编号';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.channel IS '关联关系来源渠道';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.status IS '有效标志';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.othersrightid IS '他项权证号';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.guarantysum IS '担保债权金额';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.payorder IS '受偿次序';
COMMENT ON COLUMN crmdm.cms_guaranty_relative."type" IS '数据来源类型';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.relationstatus IS '关联有效标志';
COMMENT ON COLUMN crmdm.cms_guaranty_relative.describea IS '描述';


-- crmdm.cms_org_info 定义

-- Drop table

-- DROP TABLE crmdm.cms_org_info;

CREATE TABLE crmdm.cms_org_info (
	orgid varchar(32) NULL, -- 机构编号
	sortno varchar(32) NULL, -- 排序号
	orgname varchar(80) NULL, -- 机构名称
	orglevel varchar(32) NULL, -- 级别
	orgproperty varchar(250) NULL, -- 属性集
	relativeorgid varchar(32) NULL, -- 相关机构代码
	bankid varchar(32) NULL, -- 人行金融机构代码
	banklicense varchar(32) NULL, -- 金融机构许可证
	businesslicense varchar(32) NULL, -- 营业执照
	belongarea varchar(18) NULL, -- 机构辖区
	orgclass varchar(18) NULL, -- 机构类别
	zipcode varchar(18) NULL, -- 邮政编码
	mainframeorgid varchar(32) NULL, -- 网点号
	mainframeexgid varchar(32) NULL, -- 交换号
	orgcode varchar(32) NULL, -- 机构编码
	status varchar(80) NULL, -- 状态
	orgoldname varchar(80) NULL, -- 机构曾用名
	setupdate varchar(10) NULL, -- 成立时间
	orgadd varchar(80) NULL, -- 机构地址
	principal varchar(10) NULL, -- 负责人
	orgtel varchar(80) NULL, -- 联系电话
	branchnum numeric(22) NULL, -- 管辖网点数
	cmnum numeric(22) NULL, -- 客户经理数
	businesshours varchar(80) NULL, -- 营业时间
	inputorg varchar(32) NULL, -- 登记单位
	inputuser varchar(32) NULL, -- 登记人
	inputdate varchar(20) NULL, -- 登记日期
	inputtime varchar(20) NULL, -- 登记时间
	updateuser varchar(32) NULL, -- 更新人
	updatetime varchar(20) NULL, -- 更新时间
	updatedate varchar(20) NULL, -- 更新日期
	remark varchar(250) NULL, -- 备注
	belongorgid varchar(32) NULL, -- 权属机构
	hostno varchar(10) NULL, -- 主机号
	vitualserialno numeric(22) NULL, -- 虚拟流水号
	vitualid varchar(32) NULL, -- 虚拟柜员号
	corporgid varchar(20) NULL, -- 法人机构编号
	corporgname varchar(32) NULL, -- 法人机构名称
	orgfax varchar(32) NULL, -- 机构传真
	clearbankno varchar(32) NULL, -- 大额行号
	accountingorgflag varchar(1) NULL, -- 是否账务机构
	spesubbranchflag varchar(1) NULL, -- 是否特色支行
	corporateorgname varchar(60) NULL, -- 核心机构名称
	ryzd varchar(1) NULL
);
CREATE INDEX index_crmdm_cms_org_info_index_1 ON crmdm.cms_org_info USING btree (orgid);
COMMENT ON TABLE crmdm.cms_org_info IS '信贷机构信息表';

-- Column comments

COMMENT ON COLUMN crmdm.cms_org_info.orgid IS '机构编号        ';
COMMENT ON COLUMN crmdm.cms_org_info.sortno IS '排序号          ';
COMMENT ON COLUMN crmdm.cms_org_info.orgname IS '机构名称        ';
COMMENT ON COLUMN crmdm.cms_org_info.orglevel IS '级别            ';
COMMENT ON COLUMN crmdm.cms_org_info.orgproperty IS '属性集          ';
COMMENT ON COLUMN crmdm.cms_org_info.relativeorgid IS '相关机构代码    ';
COMMENT ON COLUMN crmdm.cms_org_info.bankid IS '人行金融机构代码';
COMMENT ON COLUMN crmdm.cms_org_info.banklicense IS '金融机构许可证  ';
COMMENT ON COLUMN crmdm.cms_org_info.businesslicense IS '营业执照        ';
COMMENT ON COLUMN crmdm.cms_org_info.belongarea IS '机构辖区        ';
COMMENT ON COLUMN crmdm.cms_org_info.orgclass IS '机构类别        ';
COMMENT ON COLUMN crmdm.cms_org_info.zipcode IS '邮政编码        ';
COMMENT ON COLUMN crmdm.cms_org_info.mainframeorgid IS '网点号          ';
COMMENT ON COLUMN crmdm.cms_org_info.mainframeexgid IS '交换号          ';
COMMENT ON COLUMN crmdm.cms_org_info.orgcode IS '机构编码        ';
COMMENT ON COLUMN crmdm.cms_org_info.status IS '状态            ';
COMMENT ON COLUMN crmdm.cms_org_info.orgoldname IS '机构曾用名      ';
COMMENT ON COLUMN crmdm.cms_org_info.setupdate IS '成立时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.orgadd IS '机构地址        ';
COMMENT ON COLUMN crmdm.cms_org_info.principal IS '负责人          ';
COMMENT ON COLUMN crmdm.cms_org_info.orgtel IS '联系电话        ';
COMMENT ON COLUMN crmdm.cms_org_info.branchnum IS '管辖网点数      ';
COMMENT ON COLUMN crmdm.cms_org_info.cmnum IS '客户经理数      ';
COMMENT ON COLUMN crmdm.cms_org_info.businesshours IS '营业时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.inputorg IS '登记单位        ';
COMMENT ON COLUMN crmdm.cms_org_info.inputuser IS '登记人          ';
COMMENT ON COLUMN crmdm.cms_org_info.inputdate IS '登记日期        ';
COMMENT ON COLUMN crmdm.cms_org_info.inputtime IS '登记时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.updateuser IS '更新人          ';
COMMENT ON COLUMN crmdm.cms_org_info.updatetime IS '更新时间        ';
COMMENT ON COLUMN crmdm.cms_org_info.updatedate IS '更新日期        ';
COMMENT ON COLUMN crmdm.cms_org_info.remark IS '备注            ';
COMMENT ON COLUMN crmdm.cms_org_info.belongorgid IS '权属机构        ';
COMMENT ON COLUMN crmdm.cms_org_info.hostno IS '主机号          ';
COMMENT ON COLUMN crmdm.cms_org_info.vitualserialno IS '虚拟流水号      ';
COMMENT ON COLUMN crmdm.cms_org_info.vitualid IS '虚拟柜员号      ';
COMMENT ON COLUMN crmdm.cms_org_info.corporgid IS '法人机构编号    ';
COMMENT ON COLUMN crmdm.cms_org_info.corporgname IS '法人机构名称    ';
COMMENT ON COLUMN crmdm.cms_org_info.orgfax IS '机构传真        ';
COMMENT ON COLUMN crmdm.cms_org_info.clearbankno IS '大额行号        ';
COMMENT ON COLUMN crmdm.cms_org_info.accountingorgflag IS '是否账务机构    ';
COMMENT ON COLUMN crmdm.cms_org_info.spesubbranchflag IS '是否特色支行    ';
COMMENT ON COLUMN crmdm.cms_org_info.corporateorgname IS '核心机构名称    ';


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


-- crmdm.crm_sys_post 定义

-- Drop table

-- DROP TABLE crmdm.crm_sys_post;

CREATE TABLE crmdm.crm_sys_post (
	post_id varchar(40) NOT NULL, -- 职位ID(员工号-条线-岗位分类-机构)
	emp_id varchar(40) NULL, -- 工号
	post_name varchar(64) NULL, -- 职位名称
	job_name varchar(64) NULL, -- 岗位名称
	job_cls varchar(6) NULL, -- 岗位分类(C客户经理岗/M管理岗)
	post_state varchar(6) NULL, -- 职位状态
	biz_line varchar(6) NULL, -- 条线
	org_id varchar(30) NULL, -- 机构ID
	org_cate varchar(6) NULL, -- 机构类别
	stat_org_id varchar(30) NULL, -- 统计机构ID
	direct_under_org varchar(40) NULL, -- 直属机构
	sup_post_id varchar(40) NULL, -- 上级职位编号
	del_flg varchar(1) NULL, -- 是否删除
	usr_name varchar(64) NULL, -- 用户名称
	creatr varchar(64) NULL, -- 创建人
	creat_time varchar(20) NULL, -- 创建时间
	creat_org varchar(20) NULL, -- 创建机构
	updatr varchar(64) NULL, -- 更新人
	upd_time varchar(20) NULL, -- 更新时间
	main_pos_flag varchar(1) NULL, -- 是否主职位
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	CONSTRAINT sys_c0013323 CHECK ((post_id IS NOT NULL))
);
COMMENT ON TABLE crmdm.crm_sys_post IS '职位表';

-- Column comments

COMMENT ON COLUMN crmdm.crm_sys_post.post_id IS '职位ID(员工号-条线-岗位分类-机构)';
COMMENT ON COLUMN crmdm.crm_sys_post.emp_id IS '工号';
COMMENT ON COLUMN crmdm.crm_sys_post.post_name IS '职位名称';
COMMENT ON COLUMN crmdm.crm_sys_post.job_name IS '岗位名称';
COMMENT ON COLUMN crmdm.crm_sys_post.job_cls IS '岗位分类(C客户经理岗/M管理岗)';
COMMENT ON COLUMN crmdm.crm_sys_post.post_state IS '职位状态';
COMMENT ON COLUMN crmdm.crm_sys_post.biz_line IS '条线';
COMMENT ON COLUMN crmdm.crm_sys_post.org_id IS '机构ID';
COMMENT ON COLUMN crmdm.crm_sys_post.org_cate IS '机构类别';
COMMENT ON COLUMN crmdm.crm_sys_post.stat_org_id IS '统计机构ID';
COMMENT ON COLUMN crmdm.crm_sys_post.direct_under_org IS '直属机构';
COMMENT ON COLUMN crmdm.crm_sys_post.sup_post_id IS '上级职位编号';
COMMENT ON COLUMN crmdm.crm_sys_post.del_flg IS '是否删除';
COMMENT ON COLUMN crmdm.crm_sys_post.usr_name IS '用户名称';
COMMENT ON COLUMN crmdm.crm_sys_post.creatr IS '创建人';
COMMENT ON COLUMN crmdm.crm_sys_post.creat_time IS '创建时间';
COMMENT ON COLUMN crmdm.crm_sys_post.creat_org IS '创建机构';
COMMENT ON COLUMN crmdm.crm_sys_post.updatr IS '更新人';
COMMENT ON COLUMN crmdm.crm_sys_post.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.crm_sys_post.main_pos_flag IS '是否主职位';
COMMENT ON COLUMN crmdm.crm_sys_post.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_acct_depo 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_depo;

CREATE TABLE crmdm.dwd_acct_depo (
	cust_id varchar(20) NOT NULL, -- 客户编号
	cust_typ varchar(2) NULL, -- 客户类型
	acct_id varchar(40) NOT NULL, -- 账户
	card_no varchar(40) NOT NULL, -- 卡/折号
	prdkt_id varchar(30) NULL, -- 产品编号
	prdkt_name varchar(200) NULL, -- 产品名称
	prdkt_cate_big varchar(64) NULL, -- 产品大类
	acct_typ varchar(10) NULL, -- 账户类型
	ccy_cd varchar(4) NULL, -- 币种
	bal numeric(20, 2) NULL, -- 余额
	rmb_bal numeric(20, 2) NULL, -- 折人民币余额
	open_acct_org varchar(6) NULL, -- 归属机构
	open_date varchar(10) NULL, -- 开户日期
	rate_intri numeric(20, 2) NULL, -- 利率
	intri_bgn_date varchar(10) NULL, -- 起息日期
	expr_date varchar(10) NULL, -- 到期日期
	acct_cloz_date varchar(10) NULL, -- 销户日期
	acct_state varchar(10) NULL, -- 账户状态
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	vchr_typ varchar(10) NULL, -- 凭证类型
	cunq varchar(10) NULL, -- 存期
	fix_curnt_flg varchar(1) NULL, -- 定活标志
	CONSTRAINT pk_dwd_acct_depo PRIMARY KEY (cust_id, acct_id, card_no)
);
COMMENT ON TABLE crmdm.dwd_acct_depo IS '存款账户信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_acct_depo.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_acct_depo.cust_typ IS '客户类型';
COMMENT ON COLUMN crmdm.dwd_acct_depo.acct_id IS '账户';
COMMENT ON COLUMN crmdm.dwd_acct_depo.card_no IS '卡/折号';
COMMENT ON COLUMN crmdm.dwd_acct_depo.prdkt_id IS '产品编号';
COMMENT ON COLUMN crmdm.dwd_acct_depo.prdkt_name IS '产品名称';
COMMENT ON COLUMN crmdm.dwd_acct_depo.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dwd_acct_depo.acct_typ IS '账户类型';
COMMENT ON COLUMN crmdm.dwd_acct_depo.ccy_cd IS '币种';
COMMENT ON COLUMN crmdm.dwd_acct_depo.bal IS '余额';
COMMENT ON COLUMN crmdm.dwd_acct_depo.rmb_bal IS '折人民币余额';
COMMENT ON COLUMN crmdm.dwd_acct_depo.open_acct_org IS '归属机构';
COMMENT ON COLUMN crmdm.dwd_acct_depo.open_date IS '开户日期';
COMMENT ON COLUMN crmdm.dwd_acct_depo.rate_intri IS '利率';
COMMENT ON COLUMN crmdm.dwd_acct_depo.intri_bgn_date IS '起息日期';
COMMENT ON COLUMN crmdm.dwd_acct_depo.expr_date IS '到期日期';
COMMENT ON COLUMN crmdm.dwd_acct_depo.acct_cloz_date IS '销户日期';
COMMENT ON COLUMN crmdm.dwd_acct_depo.acct_state IS '账户状态';
COMMENT ON COLUMN crmdm.dwd_acct_depo.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_acct_depo.vchr_typ IS '凭证类型';
COMMENT ON COLUMN crmdm.dwd_acct_depo.cunq IS '存期';
COMMENT ON COLUMN crmdm.dwd_acct_depo.fix_curnt_flg IS '定活标志';


-- crmdm.dwd_acct_depo_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_depo_his;

CREATE TABLE crmdm.dwd_acct_depo_his (
	cust_id varchar(20) NULL,
	cust_typ varchar(2) NULL,
	acct_id varchar(40) NULL,
	card_no varchar(40) NULL,
	prdkt_id varchar(30) NULL,
	prdkt_name varchar(200) NULL,
	prdkt_cate_big varchar(64) NULL,
	acct_typ varchar(10) NULL,
	ccy_cd varchar(4) NULL,
	bal numeric(20, 2) NULL,
	rmb_bal numeric(20, 2) NULL,
	open_acct_org varchar(6) NULL,
	open_date varchar(10) NULL,
	rate_intri numeric(20, 2) NULL,
	intri_bgn_date varchar(10) NULL,
	expr_date varchar(10) NULL,
	acct_cloz_date varchar(10) NULL,
	acct_state varchar(10) NULL,
	persn_legal_bk_code varchar(4) NULL,
	vchr_typ varchar(10) NULL,
	cunq varchar(10) NULL,
	fix_curnt_flg varchar(1) NULL
);


-- crmdm.dwd_acct_fin 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_fin;

CREATE TABLE crmdm.dwd_acct_fin (
	cust_id varchar(21) NOT NULL, -- 客户编号
	cust_typ varchar(4) NOT NULL, -- 客户类型
	acct_id varchar(40) NOT NULL, -- 账户
	card_no varchar(30) NOT NULL, -- 卡/折号
	prdkt_id varchar(40) NOT NULL, -- 产品ID
	prdkt_name varchar(100) NULL, -- 产品名称
	prdkt_cate_big varchar(64) NULL, -- 产品大类
	estab_date varchar(10) NULL, -- 成立日期
	fin_amt numeric(18, 4) NULL, -- 理财余额
	rate_intri numeric(18, 4) NULL, -- 收益率
	acct_state varchar(10) NULL, -- 账户状态
	intri_bgn_date varchar(10) NULL, -- 起息日期
	expr_date varchar(10) NULL, -- 到期日期
	oprt_org varchar(40) NULL, -- 经办机构
	chnl_no varchar(10) NULL, -- 办理渠道
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	issu_org varchar(30) NULL, -- 发行机构
	issu_date varchar(10) NULL, -- 办理日期
	risk_lvl varchar(10) NULL -- 风险等级
);
COMMENT ON TABLE crmdm.dwd_acct_fin IS '理财账户';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_acct_fin.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_acct_fin.cust_typ IS '客户类型';
COMMENT ON COLUMN crmdm.dwd_acct_fin.acct_id IS '账户';
COMMENT ON COLUMN crmdm.dwd_acct_fin.card_no IS '卡/折号';
COMMENT ON COLUMN crmdm.dwd_acct_fin.prdkt_id IS '产品ID';
COMMENT ON COLUMN crmdm.dwd_acct_fin.prdkt_name IS '产品名称';
COMMENT ON COLUMN crmdm.dwd_acct_fin.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dwd_acct_fin.estab_date IS '成立日期';
COMMENT ON COLUMN crmdm.dwd_acct_fin.fin_amt IS '理财余额';
COMMENT ON COLUMN crmdm.dwd_acct_fin.rate_intri IS '收益率';
COMMENT ON COLUMN crmdm.dwd_acct_fin.acct_state IS '账户状态';
COMMENT ON COLUMN crmdm.dwd_acct_fin.intri_bgn_date IS '起息日期';
COMMENT ON COLUMN crmdm.dwd_acct_fin.expr_date IS '到期日期';
COMMENT ON COLUMN crmdm.dwd_acct_fin.oprt_org IS '经办机构';
COMMENT ON COLUMN crmdm.dwd_acct_fin.chnl_no IS '办理渠道';
COMMENT ON COLUMN crmdm.dwd_acct_fin.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_acct_fin.issu_org IS '发行机构';
COMMENT ON COLUMN crmdm.dwd_acct_fin.issu_date IS '办理日期';
COMMENT ON COLUMN crmdm.dwd_acct_fin.risk_lvl IS '风险等级';


-- crmdm.dwd_acct_fin_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_fin_his;

CREATE TABLE crmdm.dwd_acct_fin_his (
	cust_id varchar(21) NULL,
	cust_typ varchar(4) NULL,
	acct_id varchar(40) NULL,
	card_no varchar(30) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(64) NULL,
	estab_date varchar(10) NULL,
	fin_amt numeric(18, 4) NULL,
	rate_intri numeric(18, 4) NULL,
	acct_state varchar(10) NULL,
	intri_bgn_date varchar(10) NULL,
	expr_date varchar(10) NULL,
	oprt_org varchar(40) NULL,
	chnl_no varchar(10) NULL,
	persn_legal_bk_code varchar(30) NULL,
	issu_org varchar(30) NULL,
	issu_date varchar(10) NULL,
	risk_lvl varchar(10) NULL
);


-- crmdm.dwd_acct_insur 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_insur;

CREATE TABLE crmdm.dwd_acct_insur (
	cust_id varchar(20) NOT NULL, -- 客户编号
	cust_typ varchar(4) NULL, -- 客户类型
	acct_id varchar(40) NOT NULL, -- 账户
	prdkt_id varchar(40) NULL, -- 产品ID
	prdkt_name varchar(100) NULL, -- 产品名称
	prdkt_cate_big varchar(64) NULL, -- 产品大类
	insur_bid_form_no varchar(40) NULL, -- 投保单号
	tx_date varchar(10) NULL, -- 交易日期
	tx_org varchar(7) NULL, -- 交易机构
	tx_chnl varchar(10) NULL, -- 交易渠道
	mkt_org varchar(7) NULL, -- 归属机构
	bgn_insur_date varchar(10) NULL, -- 起保日期
	cancl_insur_date varchar(10) NULL, -- 退保日期
	pay_upto_date varchar(8) NULL, -- 缴费截止日期
	insur_period_typ varchar(2) NULL, -- 保险期间类型
	insur_period varchar(6) NULL, -- 保险期间值
	pay_period_typ varchar(2) NULL, -- 缴费期间类型
	pay_period varchar(6) NULL, -- 缴费期间值
	pay_patrn varchar(2) NULL, -- 缴费方式
	insur_amt numeric(20, 2) NULL, -- 保费金额
	policy_state varchar(10) NULL, -- 保单状态
	tx_typ varchar(1) NULL, -- 交易类型
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.dwd_acct_insur IS '保险账户信息';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_acct_insur.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_acct_insur.cust_typ IS '客户类型';
COMMENT ON COLUMN crmdm.dwd_acct_insur.acct_id IS '账户';
COMMENT ON COLUMN crmdm.dwd_acct_insur.prdkt_id IS '产品ID';
COMMENT ON COLUMN crmdm.dwd_acct_insur.prdkt_name IS '产品名称';
COMMENT ON COLUMN crmdm.dwd_acct_insur.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dwd_acct_insur.insur_bid_form_no IS '投保单号';
COMMENT ON COLUMN crmdm.dwd_acct_insur.tx_date IS '交易日期';
COMMENT ON COLUMN crmdm.dwd_acct_insur.tx_org IS '交易机构';
COMMENT ON COLUMN crmdm.dwd_acct_insur.tx_chnl IS '交易渠道';
COMMENT ON COLUMN crmdm.dwd_acct_insur.mkt_org IS '归属机构';
COMMENT ON COLUMN crmdm.dwd_acct_insur.bgn_insur_date IS '起保日期';
COMMENT ON COLUMN crmdm.dwd_acct_insur.cancl_insur_date IS '退保日期';
COMMENT ON COLUMN crmdm.dwd_acct_insur.pay_upto_date IS '缴费截止日期';
COMMENT ON COLUMN crmdm.dwd_acct_insur.insur_period_typ IS '保险期间类型';
COMMENT ON COLUMN crmdm.dwd_acct_insur.insur_period IS '保险期间值';
COMMENT ON COLUMN crmdm.dwd_acct_insur.pay_period_typ IS '缴费期间类型';
COMMENT ON COLUMN crmdm.dwd_acct_insur.pay_period IS '缴费期间值';
COMMENT ON COLUMN crmdm.dwd_acct_insur.pay_patrn IS '缴费方式';
COMMENT ON COLUMN crmdm.dwd_acct_insur.insur_amt IS '保费金额';
COMMENT ON COLUMN crmdm.dwd_acct_insur.policy_state IS '保单状态';
COMMENT ON COLUMN crmdm.dwd_acct_insur.tx_typ IS '交易类型';
COMMENT ON COLUMN crmdm.dwd_acct_insur.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_acct_insur_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_insur_his;

CREATE TABLE crmdm.dwd_acct_insur_his (
	data_date varchar(10) NULL,
	cust_id varchar(20) NULL,
	cust_typ varchar(4) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(64) NULL,
	insur_bid_form_no varchar(40) NULL,
	tx_date varchar(10) NULL,
	tx_org varchar(6) NULL,
	tx_chnl varchar(10) NULL,
	mkt_org varchar(6) NULL,
	bgn_insur_date varchar(10) NULL,
	cancl_insur_date varchar(10) NULL,
	pay_upto_date varchar(10) NULL,
	insur_period_typ varchar(2) NULL,
	insur_period varchar(6) NULL,
	pay_period_typ varchar(2) NULL,
	pay_period varchar(6) NULL,
	pay_patrn varchar(2) NULL,
	insur_amt numeric(20, 2) NULL,
	policy_state varchar(10) NULL,
	tx_typ varchar(6) NULL,
	persn_legal_bk_code varchar(4) NULL
);


-- crmdm.dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_loan;

CREATE TABLE crmdm.dwd_acct_loan (
	cust_id varchar(20) NOT NULL, -- 客户编号
	cust_typ varchar(6) NULL, -- 客户类型
	acct_id varchar(40) NOT NULL, -- 账户
	prdkt_id varchar(40) NOT NULL, -- 产品编号
	prdkt_name varchar(100) NULL, -- 产品名称
	prdkt_cate_big varchar(60) NULL, -- 产品大类
	loan_issu_amt numeric(20, 2) NULL, -- 借据金额
	loan_issu_date varchar(10) NULL, -- 贷款发放日期
	bal numeric(20, 2) NULL, -- 余额
	rate_intri numeric(10, 4) NULL, -- 利率
	expr_date varchar(10) NULL, -- 到期日期
	acct_state varchar(10) NULL, -- 账户状态
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	oprt_org varchar(6) NULL, -- 经办机构
	iou_no varchar(100) NULL, -- 借据号
	int_arrears_ttl numeric(20, 2) NULL, -- 欠息(合计)
	repay_typ varchar(6) NULL, -- 还款方式
	repay_acct_no varchar(30) NULL, -- 还款账号
	cate_5lvl varchar(2) NULL -- 五级分类
);
COMMENT ON TABLE crmdm.dwd_acct_loan IS '贷款账户';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_acct_loan.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_acct_loan.cust_typ IS '客户类型';
COMMENT ON COLUMN crmdm.dwd_acct_loan.acct_id IS '账户';
COMMENT ON COLUMN crmdm.dwd_acct_loan.prdkt_id IS '产品编号';
COMMENT ON COLUMN crmdm.dwd_acct_loan.prdkt_name IS '产品名称';
COMMENT ON COLUMN crmdm.dwd_acct_loan.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dwd_acct_loan.loan_issu_amt IS '借据金额';
COMMENT ON COLUMN crmdm.dwd_acct_loan.loan_issu_date IS '贷款发放日期';
COMMENT ON COLUMN crmdm.dwd_acct_loan.bal IS '余额';
COMMENT ON COLUMN crmdm.dwd_acct_loan.rate_intri IS '利率';
COMMENT ON COLUMN crmdm.dwd_acct_loan.expr_date IS '到期日期';
COMMENT ON COLUMN crmdm.dwd_acct_loan.acct_state IS '账户状态';
COMMENT ON COLUMN crmdm.dwd_acct_loan.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_acct_loan.oprt_org IS '经办机构';
COMMENT ON COLUMN crmdm.dwd_acct_loan.iou_no IS '借据号';
COMMENT ON COLUMN crmdm.dwd_acct_loan.int_arrears_ttl IS '欠息(合计)';
COMMENT ON COLUMN crmdm.dwd_acct_loan.repay_typ IS '还款方式';
COMMENT ON COLUMN crmdm.dwd_acct_loan.repay_acct_no IS '还款账号';
COMMENT ON COLUMN crmdm.dwd_acct_loan.cate_5lvl IS '五级分类';


-- crmdm.dwd_acct_loan_his 定义

-- Drop table

-- DROP TABLE crmdm.dwd_acct_loan_his;

CREATE TABLE crmdm.dwd_acct_loan_his (
	cust_id varchar(20) NULL,
	cust_typ varchar(6) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_name varchar(100) NULL,
	prdkt_cate_big varchar(60) NULL,
	loan_issu_amt numeric(20, 2) NULL,
	loan_issu_date varchar(10) NULL,
	bal numeric(20, 2) NULL,
	rate_intri numeric(10, 4) NULL,
	expr_date varchar(10) NULL,
	acct_state varchar(10) NULL,
	persn_legal_bk_code varchar(4) NULL,
	oprt_org varchar(6) NULL,
	iou_no varchar(100) NULL,
	int_arrears_ttl numeric(20, 2) NULL,
	repay_typ varchar(6) NULL,
	repay_acct_no varchar(30) NULL,
	cate_5lvl varchar(2) NULL
);


-- crmdm.dwd_crm_sys_xthlcs 定义

-- Drop table

-- DROP TABLE crmdm.dwd_crm_sys_xthlcs;

CREATE TABLE crmdm.dwd_crm_sys_xthlcs (
	huobdaih varchar(6) NOT NULL, -- 货币代号
	pjdanwei numeric(20, 7) NOT NULL, -- 牌价单位
	huobfhao varchar(8) NULL, -- 货币符号
	zhngjjia numeric(20, 7) NULL, -- 中间价
	hl numeric(20, 7) NULL -- 汇率
);
COMMENT ON TABLE crmdm.dwd_crm_sys_xthlcs IS '货币汇率表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_crm_sys_xthlcs.huobdaih IS '货币代号';
COMMENT ON COLUMN crmdm.dwd_crm_sys_xthlcs.pjdanwei IS '牌价单位';
COMMENT ON COLUMN crmdm.dwd_crm_sys_xthlcs.huobfhao IS '货币符号';
COMMENT ON COLUMN crmdm.dwd_crm_sys_xthlcs.zhngjjia IS '中间价';
COMMENT ON COLUMN crmdm.dwd_crm_sys_xthlcs.hl IS '汇率';


-- crmdm.dwd_cust_dormant_accout 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_dormant_accout;

CREATE TABLE crmdm.dwd_cust_dormant_accout (
	persn_legal_bk_code varchar(4) NOT NULL, -- 法人行号
	data_date varchar(8) NOT NULL, -- 数据日期
	cust_id varchar(20) NOT NULL -- 客户编号
);
CREATE UNIQUE INDEX index_crmdm_dwd_cust_dormant_accout_index_1 ON crmdm.dwd_cust_dormant_accout USING btree (cust_id, data_date, persn_legal_bk_code);
COMMENT ON TABLE crmdm.dwd_cust_dormant_accout IS '睡眠户信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_dormant_accout.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_cust_dormant_accout.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dwd_cust_dormant_accout.cust_id IS '客户编号';


-- crmdm.dwd_cust_enter_rela 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_enter_rela;

CREATE TABLE crmdm.dwd_cust_enter_rela (
	cust_id varchar(20) NULL, -- 客户编号
	rel_typ varchar(1) NULL, -- 关系类型
	rel_cust_id varchar(20) NULL, -- 关联人客户编号
	rel_cust_name varchar(100) NULL, -- 关联人客户名称
	rel_val numeric NULL, -- 关联值
	bk_self_cust_flg varchar(1) NULL, -- 是否我行客户
	rel_inf varchar(800) NULL, -- 关系内容
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.dwd_cust_enter_rela IS '客户关联关系表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.rel_typ IS '关系类型';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.rel_cust_id IS '关联人客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.rel_cust_name IS '关联人客户名称';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.rel_val IS '关联值';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.bk_self_cust_flg IS '是否我行客户';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.rel_inf IS '关系内容';
COMMENT ON COLUMN crmdm.dwd_cust_enter_rela.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_cust_indiv_crdt 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_indiv_crdt;

CREATE TABLE crmdm.dwd_cust_indiv_crdt (
	cust_id varchar(100) NOT NULL, -- 客户编号
	cust_name varchar(100) NULL, -- 客户名称
	crdt_agre_no varchar(100) NULL, -- 授信协议号
	crdt_agre_typ varchar(100) NULL, -- 授信协议类型
	crdt_ttl_lmt varchar(100) NULL, -- 授信额度
	bgn_date varchar(100) NULL, -- 开始日期
	expr_date varchar(100) NULL, -- 到期日期
	crdt_status varchar(100) NULL, -- 授信状态
	persn_legal_bk_code varchar(100) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.dwd_cust_indiv_crdt IS '个人客户授信信息';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.crdt_agre_no IS '授信协议号';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.crdt_agre_typ IS '授信协议类型';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.crdt_ttl_lmt IS '授信额度';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.bgn_date IS '开始日期';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.expr_date IS '到期日期';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.crdt_status IS '授信状态';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_crdt.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_cust_indiv_mner 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_indiv_mner;

CREATE TABLE crmdm.dwd_cust_indiv_mner (
	cust_id varchar(20) NULL, -- 客户编号
	mber_name varchar(200) NULL, -- 成员姓名
	mber_rel varchar(6) NULL, -- 成员关系
	gend varchar(6) NULL, -- 性别
	tel_no varchar(32) NULL, -- 联系电话
	bk_self_cust_flg varchar(1) NULL, -- 是否本行客户
	inner_bk_cust_id varchar(20) NULL, -- 行内客户编号
	bth_date varchar(10) NULL, -- 出生日期
	mari_day_mem varchar(10) NULL, -- 结婚纪念日
	cert_id varchar(40) NULL, -- 证件号码
	cert_typ varchar(10) NULL, -- 证件类型
	sys_src varchar(500) NULL, -- 系统来源
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	post_id varchar(20) NULL, -- 维护人
	remark varchar(200) NULL -- 备注
);
COMMENT ON TABLE crmdm.dwd_cust_indiv_mner IS '家庭成员信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.mber_name IS '成员姓名';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.mber_rel IS '成员关系';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.gend IS '性别';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.tel_no IS '联系电话';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.bk_self_cust_flg IS '是否本行客户';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.inner_bk_cust_id IS '行内客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.bth_date IS '出生日期';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.mari_day_mem IS '结婚纪念日';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.cert_id IS '证件号码';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.cert_typ IS '证件类型';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.sys_src IS '系统来源';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.post_id IS '维护人';
COMMENT ON COLUMN crmdm.dwd_cust_indiv_mner.remark IS '备注';


-- crmdm.dwd_cust_indiv_risk_invst 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_indiv_risk_invst;

CREATE TABLE crmdm.dwd_cust_indiv_risk_invst (
	cust_id varchar(100) NOT NULL,
	invest_typ varchar(100) NULL,
	estim_rslt varchar(100) NULL,
	score varchar(100) NULL,
	risk_lvl varchar(100) NULL,
	estim_date varchar(100) NULL,
	expr_date varchar(100) NULL,
	persn_legal_bk_code varchar(100) NULL
);


-- crmdm.dwd_cust_indv_info 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_indv_info;

CREATE TABLE crmdm.dwd_cust_indv_info (
	cust_id varchar(20) NULL, -- 客户编号
	cust_name varchar(100) NULL, -- 客户名称
	cert_typ varchar(6) NULL, -- 证件类型
	cert_id varchar(32) NULL, -- 证件号码
	cert_prd_vlid varchar(10) NULL, -- 证件有效期起
	cert_prd_vlid_end varchar(10) NULL, -- 证件有效期止
	cert_issuing_authority varchar(100) NULL, -- 签发机关所在地
	cust_typ varchar(2) NULL, -- 客户类型
	open_date varchar(10) NULL, -- 开户日期
	open_org varchar(20) NULL, -- 开户机构
	nationality varchar(6) NULL, -- 国籍
	nation varchar(6) NULL, -- 民族
	mari_situ varchar(6) NULL, -- 婚姻状况
	max_deg_edu varchar(6) NULL, -- 最高学历
	now_enter varchar(120) NULL, -- 现工作单位
	occu_cls varchar(6) NULL, -- 职业分类
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	gend varchar(2) NULL, -- 性别
	phone_no varchar(20) NULL, -- 手机号码
	contact_address varchar(254) NULL, -- 联系地址
	contact_address_detail varchar(254) NULL, -- 联系地址详细地址
	id_address varchar(254) NULL, -- 证件地址
	id_address_detail varchar(254) NULL, -- 证件地址详细地址
	home_address varchar(254) NULL, -- 家庭地址
	home_address_detail varchar(254) NULL, -- 家庭地址详细地址
	residence_address varchar(254) NULL, -- 住宅地址
	residence_address_detail varchar(254) NULL, -- 住宅地址详细地址
	office_address varchar(254) NULL, -- 办公地址
	office_address_detail varchar(254) NULL -- 办公地址详细地址
);
COMMENT ON TABLE crmdm.dwd_cust_indv_info IS '客户基本信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cert_typ IS '证件类型';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cert_id IS '证件号码';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cert_prd_vlid IS '证件有效期起';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cert_prd_vlid_end IS '证件有效期止';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cert_issuing_authority IS '签发机关所在地';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.cust_typ IS '客户类型';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.open_date IS '开户日期';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.open_org IS '开户机构';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.nationality IS '国籍';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.nation IS '民族';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.mari_situ IS '婚姻状况';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.max_deg_edu IS '最高学历';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.now_enter IS '现工作单位';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.occu_cls IS '职业分类';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.gend IS '性别';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.phone_no IS '手机号码';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.contact_address IS '联系地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.contact_address_detail IS '联系地址详细地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.id_address IS '证件地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.id_address_detail IS '证件地址详细地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.home_address IS '家庭地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.home_address_detail IS '家庭地址详细地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.residence_address IS '住宅地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.residence_address_detail IS '住宅地址详细地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.office_address IS '办公地址';
COMMENT ON COLUMN crmdm.dwd_cust_indv_info.office_address_detail IS '办公地址详细地址';


-- crmdm.dwd_cust_man 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_man;

CREATE TABLE crmdm.dwd_cust_man (
	cust_id varchar(20) NOT NULL, -- 客户编号
	mngr_post_id varchar(20) NOT NULL, -- 客户经理编号
	org_id varchar(7) NOT NULL, -- 机构编号
	mng_typ varchar(1) NOT NULL, -- 管理类型(1-理财管户 2-信贷管户)
	modf_time varchar(20) NOT NULL, -- 变更时间
	modf_typ varchar(1) NULL, -- 变更类型 0-分配 1- 回收 2-认领 3-移交 4- 主办变更 5-调配
	data_src varchar(10) NULL, -- 数据来源 CRM CMS
	valid_date varchar(8) NULL, -- 有效日期
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.dwd_cust_man IS '信贷管户关系表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_man.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_man.mngr_post_id IS '客户经理编号';
COMMENT ON COLUMN crmdm.dwd_cust_man.org_id IS '机构编号';
COMMENT ON COLUMN crmdm.dwd_cust_man.mng_typ IS '管理类型(1-理财管户 2-信贷管户)';
COMMENT ON COLUMN crmdm.dwd_cust_man.modf_time IS '变更时间';
COMMENT ON COLUMN crmdm.dwd_cust_man.modf_typ IS '变更类型 0-分配 1-	回收 2-认领 3-移交 4-	主办变更 5-调配';
COMMENT ON COLUMN crmdm.dwd_cust_man.data_src IS '数据来源 CRM CMS';
COMMENT ON COLUMN crmdm.dwd_cust_man.valid_date IS '有效日期';
COMMENT ON COLUMN crmdm.dwd_cust_man.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_cust_sign_ctrakt 定义

-- Drop table

-- DROP TABLE crmdm.dwd_cust_sign_ctrakt;

CREATE TABLE crmdm.dwd_cust_sign_ctrakt (
	cust_id varchar(21) NULL, -- 客户编号
	ctrakt_acct varchar(40) NULL, -- 签约账户
	ctrakt_typ varchar(6) NULL, -- 签约类型
	ctrakt_date varchar(10) NULL, -- 签约日期
	phone_no varchar(32) NULL, -- 手机号
	ctrakt_org varchar(30) NULL, -- 签约机构
	ctrakt_oprtr varchar(64) NULL, -- 签约经办人
	ctrakt_state varchar(6) NULL, -- 签约状态
	persn_legal_bk_code varchar(30) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.dwd_cust_sign_ctrakt IS '客户签约信息';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.ctrakt_acct IS '签约账户';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.ctrakt_typ IS '签约类型';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.ctrakt_date IS '签约日期';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.phone_no IS '手机号';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.ctrakt_org IS '签约机构';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.ctrakt_oprtr IS '签约经办人';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.ctrakt_state IS '签约状态';
COMMENT ON COLUMN crmdm.dwd_cust_sign_ctrakt.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_prdkt_catlog 定义

-- Drop table

-- DROP TABLE crmdm.dwd_prdkt_catlog;

CREATE TABLE crmdm.dwd_prdkt_catlog (
	prdkt_catlog_id varchar(40) NOT NULL, -- 产品目录编号
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	prdkt_cls_id varchar(40) NULL, -- 产品分类编号
	prdkt_cls_name varchar(100) NULL, -- 产品分类名称
	prdkt_catlog_path varchar(200) NOT NULL, -- 产品目录路径
	prdkt_line varchar(6) NULL, -- 产品条线
	sup_prdkt_cls_id varchar(40) NULL, -- 上级产品分类编号
	prdkt_id varchar(40) NULL, -- 产品编号
	curnt_hraky_seq_id numeric NULL, -- 当前层级序号
	curnt_calib_statis_flg varchar(1) NULL, -- 当前口径是否统计
	statis_calib varchar(6) NULL, -- 统计口径(客户、客户经理、团队、机构)
	prdkt_state varchar(6) NULL, -- 产品状态(1上架 2下架)
	send_chnl varchar(20) NULL, -- 推送渠道(PAD/移动CRM)
	obj_typ varchar(2) NULL, -- 对象类型(1目录 2产品)
	is_rcmd varchar(20) NULL, -- 01
	water_print_addrs varchar(20) NULL,
	hot_date varchar(20) NULL,
	rcmd_date varchar(20) NULL,
	is_hot varchar(2) NULL, -- 01
	mdl_biz_rate_fee numeric(18, 5) NULL,
	prdkt_state1 varchar(10) NULL,
	CONSTRAINT pk_dwd_prdkt_catlog PRIMARY KEY (prdkt_catlog_id)
);
COMMENT ON TABLE crmdm.dwd_prdkt_catlog IS '产品目录表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_catlog_id IS '产品目录编号';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_cls_id IS '产品分类编号';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_cls_name IS '产品分类名称';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_catlog_path IS '产品目录路径';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_line IS '产品条线';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.sup_prdkt_cls_id IS '上级产品分类编号';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_id IS '产品编号';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.curnt_hraky_seq_id IS '当前层级序号';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.curnt_calib_statis_flg IS '当前口径是否统计';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.statis_calib IS '统计口径(客户、客户经理、团队、机构)';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.prdkt_state IS '产品状态(1上架 2下架)';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.send_chnl IS '推送渠道(PAD/移动CRM)';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.obj_typ IS '对象类型(1目录 2产品)';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.is_rcmd IS '01';
COMMENT ON COLUMN crmdm.dwd_prdkt_catlog.is_hot IS '01';


-- crmdm.dwd_prdkt_info 定义

-- Drop table

-- DROP TABLE crmdm.dwd_prdkt_info;

CREATE TABLE crmdm.dwd_prdkt_info (
	prdkt_id varchar(40) NOT NULL, -- 产品编号
	prdkt_name varchar(100) NULL, -- 产品名称
	prdkt_cate_big varchar(10) NULL, -- 产品大类
	bgn_date varchar(10) NULL, -- 开始日期
	end_date varchar(10) NULL, -- 结束日期
	prdkt_line varchar(10) NULL, -- 产品条线
	sup_prdkt_id varchar(30) NULL, -- 上级产品编号
	mdl_biz_rate_fee numeric(18, 4) NULL, -- 中间业务费率
	prdkt_rate numeric(18, 4) NULL, -- 产品利率
	sys_src varchar(6) NULL, -- 系统来源
	prdkt_state varchar(10) NULL, -- 产品状态(在售/停售)
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	CONSTRAINT sys_c0012861 CHECK ((prdkt_id IS NOT NULL))
);
CREATE UNIQUE INDEX index_crmdm_dwd_prdkt_info_index_1 ON crmdm.dwd_prdkt_info USING btree (prdkt_id, sys_src);
COMMENT ON TABLE crmdm.dwd_prdkt_info IS '产品信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_prdkt_info.prdkt_id IS '产品编号';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.prdkt_name IS '产品名称';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.bgn_date IS '开始日期';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.end_date IS '结束日期';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.prdkt_line IS '产品条线';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.sup_prdkt_id IS '上级产品编号';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.mdl_biz_rate_fee IS '中间业务费率';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.prdkt_rate IS '产品利率';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.sys_src IS '系统来源';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.prdkt_state IS '产品状态(在售/停售)';
COMMENT ON COLUMN crmdm.dwd_prdkt_info.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_prdkt_info_detail 定义

-- Drop table

-- DROP TABLE crmdm.dwd_prdkt_info_detail;

CREATE TABLE crmdm.dwd_prdkt_info_detail (
	pk_id varchar(40) NOT NULL, -- 主键
	prdkt_catlog_path varchar(200) NULL, -- 产品目录
	col_code varchar(40) NULL, -- 属性ID
	col_name varchar(100) NULL, -- 属性名称
	col_value varchar(200) NULL, -- 属性值
	org_id varchar(8) NULL, -- 机构号
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.dwd_prdkt_info_detail IS '产品属性信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.pk_id IS '主键';
COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.prdkt_catlog_path IS '产品目录';
COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.col_code IS '属性ID';
COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.col_name IS '属性名称';
COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.col_value IS '属性值';
COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.org_id IS '机构号';
COMMENT ON COLUMN crmdm.dwd_prdkt_info_detail.persn_legal_bk_code IS '法人行号';


-- crmdm.dwd_sys_org 定义

-- Drop table

-- DROP TABLE crmdm.dwd_sys_org;

CREATE TABLE crmdm.dwd_sys_org (
	org_id varchar(7) NOT NULL, -- 机构编号
	sup_org_id varchar(7) NULL, -- 上级机构编号
	org_path varchar(200) NULL, -- 机构路径
	org_name varchar(100) NULL, -- 机构名称
	sup_org_name varchar(100) NULL, -- 上级机构名称
	direct_under_org varchar(7) NULL, -- 直属机构
	org_typ varchar(10) NULL, -- 机构类型
	org_harcy varchar(10) NULL, -- 机构层级
	org_addrs varchar(800) NULL, -- 机构地址
	org_state varchar(1) NULL, -- 机构状态
	dsply_seq numeric NULL, -- 显示顺序
	creatr varchar(64) NULL, -- 创建人
	creat_time varchar(20) NULL, -- 创建时间
	creat_org varchar(20) NULL, -- 创建机构
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	hr_ms_org_id varchar(80) NULL, -- 人力资源系统机构号
	org_lgtud varchar(30) NULL, -- 机构经度
	org_lattud varchar(30) NULL, -- 机构纬度
	org_rsponr varchar(40) NULL, -- 机构负责人
	org_tel varchar(30) NULL -- 机构电话
);
COMMENT ON TABLE crmdm.dwd_sys_org IS '机构表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_sys_org.org_id IS '机构编号';
COMMENT ON COLUMN crmdm.dwd_sys_org.sup_org_id IS '上级机构编号';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_path IS '机构路径';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_name IS '机构名称';
COMMENT ON COLUMN crmdm.dwd_sys_org.sup_org_name IS '上级机构名称';
COMMENT ON COLUMN crmdm.dwd_sys_org.direct_under_org IS '直属机构';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_typ IS '机构类型';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_harcy IS '机构层级';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_addrs IS '机构地址';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_state IS '机构状态';
COMMENT ON COLUMN crmdm.dwd_sys_org.dsply_seq IS '显示顺序';
COMMENT ON COLUMN crmdm.dwd_sys_org.creatr IS '创建人';
COMMENT ON COLUMN crmdm.dwd_sys_org.creat_time IS '创建时间';
COMMENT ON COLUMN crmdm.dwd_sys_org.creat_org IS '创建机构';
COMMENT ON COLUMN crmdm.dwd_sys_org.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_sys_org.hr_ms_org_id IS '人力资源系统机构号';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_lgtud IS '机构经度';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_lattud IS '机构纬度';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_rsponr IS '机构负责人';
COMMENT ON COLUMN crmdm.dwd_sys_org.org_tel IS '机构电话';


-- crmdm.dwd_tmp_jigou_base 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tmp_jigou_base;

CREATE TABLE crmdm.dwd_tmp_jigou_base (
	jigouhao varchar(10) NOT NULL, -- 营业机构号
	farendma varchar(4) NOT NULL, -- 法人代码
	fenhdaim varchar(30) NOT NULL, -- 分行代码
	jigoleix varchar(30) NOT NULL, -- 机构类型
	jigouzwm varchar(500) NULL, -- 机构中文名称
	dizhiiii varchar(500) NULL, -- 地址
	youzhnbm varchar(10) NULL, -- 邮政编码
	dianhhma varchar(20) NULL, -- 电话号码
	weihriqi varchar(8) NULL, -- 维护日期
	weihshij varchar(9) NULL, -- 维护时间
	jingduxx varchar(30) NULL, -- 经度
	weiduxxz varchar(30) NULL, -- 纬度
	yewugxjg varchar(30) NULL, -- 业务关系机构
	yewugxjb numeric(3) NULL -- 业务关系级别
);
COMMENT ON TABLE crmdm.dwd_tmp_jigou_base IS '机构处理临时表-基础数据';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.jigouhao IS '营业机构号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.farendma IS '法人代码';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.fenhdaim IS '分行代码';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.jigoleix IS '机构类型';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.jigouzwm IS '机构中文名称';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.dizhiiii IS '地址';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.youzhnbm IS '邮政编码';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.dianhhma IS '电话号码';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.weihriqi IS '维护日期';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.weihshij IS '维护时间';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.jingduxx IS '经度';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.weiduxxz IS '纬度';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.yewugxjg IS '业务关系机构';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_base.yewugxjb IS '业务关系级别';


-- crmdm.dwd_tmp_jigou_code 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tmp_jigou_code;

CREATE TABLE crmdm.dwd_tmp_jigou_code (
	org_id varchar(7) NULL, -- 机构编号
	sup_org_id varchar(7) NULL, -- 上级机构编号
	org_name varchar(500) NULL, -- 机构名称
	direct_under_org varchar(7) NULL, -- 直属机构
	org_typ varchar(2) NULL, -- 机构类型
	org_addrs varchar(800) NULL, -- 机构地址
	org_state varchar(1) NULL, -- 机构状态
	dsply_seq numeric(19) NULL, -- 显示顺序
	creatr varchar(64) NULL, -- 创建人
	creat_time varchar(20) NULL, -- 创建时间
	creat_org varchar(20) NULL, -- 创建机构
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	hr_ms_org_id varchar(80) NULL, -- 人力资源系统机构号
	org_lgtud varchar(30) NULL, -- 机构经度
	org_lattud varchar(30) NULL, -- 机构纬度
	org_rsponr varchar(40) NULL, -- 机构负责人
	org_tel varchar(30) NULL -- 机构电话
);
COMMENT ON TABLE crmdm.dwd_tmp_jigou_code IS '机构处理临时表-机构编码与分类';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_id IS '机构编号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.sup_org_id IS '上级机构编号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_name IS '机构名称';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.direct_under_org IS '直属机构';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_typ IS '机构类型';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_addrs IS '机构地址';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_state IS '机构状态';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.dsply_seq IS '显示顺序';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.creatr IS '创建人';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.creat_time IS '创建时间';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.creat_org IS '创建机构';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.hr_ms_org_id IS '人力资源系统机构号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_lgtud IS '机构经度';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_lattud IS '机构纬度';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_rsponr IS '机构负责人';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_code.org_tel IS '机构电话';


-- crmdm.dwd_tmp_jigou_path 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tmp_jigou_path;

CREATE TABLE crmdm.dwd_tmp_jigou_path (
	org_id varchar(7) NULL, -- 机构编号
	sup_org_id varchar(7) NULL, -- 上级机构编号
	org_path varchar(200) NULL, -- 机构路径
	org_harcy varchar(10) NULL -- 机构层级
);
COMMENT ON TABLE crmdm.dwd_tmp_jigou_path IS '机构处理临时表-机构路径';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_tmp_jigou_path.org_id IS '机构编号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_path.sup_org_id IS '上级机构编号';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_path.org_path IS '机构路径';
COMMENT ON COLUMN crmdm.dwd_tmp_jigou_path.org_harcy IS '机构层级';


-- crmdm.dwd_tx_aset 定义

-- Drop table

-- DROP TABLE crmdm.dwd_tx_aset;

CREATE TABLE crmdm.dwd_tx_aset (
	seq_id varchar(40) NOT NULL, -- 流水号
	cust_id varchar(21) NULL, -- 客户编号
	cust_typ varchar(4) NULL, -- 客户类型
	acct_id varchar(40) NULL, -- 账户
	prdkt_id varchar(40) NULL, -- 产品ID
	tx_chnl varchar(10) NULL, -- 交易渠道
	tx_date varchar(10) NULL, -- 交易日期
	tx_time varchar(20) NULL, -- 交易时间
	ccy_cd varchar(6) NULL, -- 币种
	amt numeric(18, 4) NULL, -- 发生额
	tx_org varchar(20) NULL, -- 交易机构
	oprtr varchar(20) NULL, -- 经办人
	loan_flg varchar(3) NULL, -- 借贷标识
	acct_bal numeric(18, 4) NULL, -- 账户余额
	tx_dsc varchar(200) NULL, -- 交易说明
	opnt_acct varchar(32) NULL, -- 对方账户
	opnt_acct_name_fst varchar(200) NULL, -- 对方户名
	opnt_bk_keep varchar(20) NULL, -- 对方行
	opnt_name_bk varchar(200) NULL, -- 对方行名
	acct_blng_org varchar(20) NULL, -- 账户归属机构
	card_no varchar(30) NULL, -- 卡/折号
	persn_legal_bk_code varchar(30) NULL, -- 法人行号
	CONSTRAINT pk_dwd_tx_aset PRIMARY KEY (seq_id)
);
COMMENT ON TABLE crmdm.dwd_tx_aset IS '资产交易信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dwd_tx_aset.seq_id IS '流水号';
COMMENT ON COLUMN crmdm.dwd_tx_aset.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dwd_tx_aset.cust_typ IS '客户类型';
COMMENT ON COLUMN crmdm.dwd_tx_aset.acct_id IS '账户';
COMMENT ON COLUMN crmdm.dwd_tx_aset.prdkt_id IS '产品ID';
COMMENT ON COLUMN crmdm.dwd_tx_aset.tx_chnl IS '交易渠道';
COMMENT ON COLUMN crmdm.dwd_tx_aset.tx_date IS '交易日期';
COMMENT ON COLUMN crmdm.dwd_tx_aset.tx_time IS '交易时间';
COMMENT ON COLUMN crmdm.dwd_tx_aset.ccy_cd IS '币种';
COMMENT ON COLUMN crmdm.dwd_tx_aset.amt IS '发生额';
COMMENT ON COLUMN crmdm.dwd_tx_aset.tx_org IS '交易机构';
COMMENT ON COLUMN crmdm.dwd_tx_aset.oprtr IS '经办人';
COMMENT ON COLUMN crmdm.dwd_tx_aset.loan_flg IS '借贷标识';
COMMENT ON COLUMN crmdm.dwd_tx_aset.acct_bal IS '账户余额';
COMMENT ON COLUMN crmdm.dwd_tx_aset.tx_dsc IS '交易说明';
COMMENT ON COLUMN crmdm.dwd_tx_aset.opnt_acct IS '对方账户';
COMMENT ON COLUMN crmdm.dwd_tx_aset.opnt_acct_name_fst IS '对方户名';
COMMENT ON COLUMN crmdm.dwd_tx_aset.opnt_bk_keep IS '对方行';
COMMENT ON COLUMN crmdm.dwd_tx_aset.opnt_name_bk IS '对方行名';
COMMENT ON COLUMN crmdm.dwd_tx_aset.acct_blng_org IS '账户归属机构';
COMMENT ON COLUMN crmdm.dwd_tx_aset.card_no IS '卡/折号';
COMMENT ON COLUMN crmdm.dwd_tx_aset.persn_legal_bk_code IS '法人行号';


-- crmdm.dws_cust_asse_liab 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_asse_liab;

CREATE TABLE crmdm.dws_cust_asse_liab (
	data_date varchar(8) NOT NULL, -- 数据日期
	cust_id varchar(20) NOT NULL, -- 客户编号
	org_id varchar(7) NOT NULL, -- 归属机构
	org_id_loan varchar(7) NULL, -- 信贷归属机构
	bal_type varchar(1) NOT NULL, -- 类型 1-余额 2-月日均 3-季日均 4-年日均
	aum_bal numeric(20, 2) NULL, -- AUM余额
	depo_bal numeric(20, 2) NULL, -- 存款余额
	depo_curnt_depo_bal numeric(20, 2) NULL, -- 活期存款余额
	fixd_depo_bal numeric(20, 2) NULL, -- 普通定期存款余额
	lehui_bal numeric(20, 2) NULL, -- 乐惠存余额
	largedp_bal numeric(20, 2) NULL, -- 大额存单余额
	fin_bal numeric(20, 2) NULL, -- 理财余额
	close_agen_fin_bal numeric(20, 2) NULL, -- 代销封闭式理财余额
	open_agen_fin_bal numeric(20, 2) NULL, -- 代销开放式理财余额
	close_self_fin_bal numeric(20, 2) NULL, -- 自营封闭式理财余额
	open_self_fin_bal numeric(20, 2) NULL, -- 自营开放式理财余额
	insur_bal numeric(20, 2) NULL, -- 保险余额
	loan_bal numeric(20, 2) NULL, -- 贷款余额
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
CREATE INDEX index_crmdm_dwd_cust_asse_liab_index_1 ON crmdm.dws_cust_asse_liab USING btree (cust_id, bal_type);
CREATE INDEX index_crmdm_dwd_cust_asse_liab_index_2 ON crmdm.dws_cust_asse_liab USING btree (data_date, bal_type);
CREATE INDEX index_crmdm_dws_cust_asse_liab_index_1 ON crmdm.dws_cust_asse_liab USING btree (data_date, cust_id, bal_type, persn_legal_bk_code);
COMMENT ON TABLE crmdm.dws_cust_asse_liab IS '客户资产负债表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_asse_liab.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.org_id IS '归属机构';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.org_id_loan IS '信贷归属机构';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.bal_type IS '类型 1-余额 2-月日均 3-季日均 4-年日均';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.aum_bal IS 'AUM余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.depo_bal IS '存款余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.depo_curnt_depo_bal IS '活期存款余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.fixd_depo_bal IS '普通定期存款余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.lehui_bal IS '乐惠存余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.largedp_bal IS '大额存单余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.fin_bal IS '理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.close_agen_fin_bal IS '代销封闭式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.open_agen_fin_bal IS '代销开放式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.close_self_fin_bal IS '自营封闭式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.open_self_fin_bal IS '自营开放式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.insur_bal IS '保险余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.loan_bal IS '贷款余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab.persn_legal_bk_code IS '法人行号';


-- crmdm.dws_cust_asse_liab_cumu 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_asse_liab_cumu;

CREATE TABLE crmdm.dws_cust_asse_liab_cumu (
	data_date varchar(8) NOT NULL, -- 数据日期
	persn_legal_bk_code varchar(7) NULL, -- 法人行号
	oprt_org varchar(7) NULL, -- 归属机构
	cust_id varchar(20) NULL, -- 客户号
	acct_id varchar(40) NULL, -- 账号
	prdkt_id varchar(40) NULL, -- 产品编号
	prdkt_cate_big varchar(40) NULL, -- 产品大类
	prdkt_typ varchar(1) NULL, -- 产品类型
	bal numeric(20, 2) NULL, -- 日余额
	mth_bal numeric(20, 2) NULL, -- 月余额
	qrt_bal numeric(20, 2) NULL, -- 季余额
	yar_bal numeric(20, 2) NULL, -- 年余额
	mth_days numeric(20, 2) NULL, -- 月天数
	qrt_days numeric(20, 2) NULL, -- 季天数
	yar_days numeric(20, 2) NULL -- 年天数
);
COMMENT ON TABLE crmdm.dws_cust_asse_liab_cumu IS '客户资产负债基数表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.oprt_org IS '归属机构';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.cust_id IS '客户号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.acct_id IS '账号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.prdkt_id IS '产品编号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.prdkt_typ IS '产品类型';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.bal IS '日余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.mth_bal IS '月余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.qrt_bal IS '季余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.yar_bal IS '年余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.mth_days IS '月天数';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.qrt_days IS '季天数';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu.yar_days IS '年天数';


-- crmdm.dws_cust_asse_liab_cumu_his 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_asse_liab_cumu_his;

CREATE TABLE crmdm.dws_cust_asse_liab_cumu_his (
	data_date varchar(8) NOT NULL, -- 数据日期
	persn_legal_bk_code varchar(7) NULL, -- 法人行号
	oprt_org varchar(7) NULL, -- 归属机构
	cust_id varchar(20) NOT NULL, -- 客户号
	acct_id varchar(40) NOT NULL, -- 账号
	prdkt_id varchar(40) NOT NULL, -- 产品编号
	prdkt_cate_big varchar(40) NULL, -- 产品大类
	prdkt_typ varchar(1) NULL, -- 产品类型
	bal numeric(20, 2) NULL, -- 日余额
	mth_bal numeric(20, 2) NULL, -- 月余额
	qrt_bal numeric(20, 2) NULL, -- 季余额
	yar_bal numeric(20, 2) NULL, -- 年余额
	mth_days numeric(20, 2) NULL, -- 月天数
	qrt_days numeric(20, 2) NULL, -- 季天数
	yar_days numeric(20, 2) NULL -- 年天数
);
COMMENT ON TABLE crmdm.dws_cust_asse_liab_cumu_his IS '客户资产负债基数历史表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.oprt_org IS '归属机构';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.cust_id IS '客户号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.acct_id IS '账号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.prdkt_id IS '产品编号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.prdkt_cate_big IS '产品大类';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.prdkt_typ IS '产品类型';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.bal IS '日余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.mth_bal IS '月余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.qrt_bal IS '季余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.yar_bal IS '年余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.mth_days IS '月天数';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.qrt_days IS '季天数';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_cumu_his.yar_days IS '年天数';


-- crmdm.dws_cust_asse_liab_his 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_asse_liab_his;

CREATE TABLE crmdm.dws_cust_asse_liab_his (
	data_date varchar(8) NOT NULL, -- 数据日期
	cust_id varchar(20) NOT NULL, -- 客户编号
	org_id varchar(7) NOT NULL, -- 机构号
	org_id_loan varchar(7) NULL, -- 信贷归属机构号
	bal_type varchar(1) NOT NULL, -- 类型1-余额 2-月日均 3-季日均 4-年日均
	aum_bal numeric(20, 2) NULL, -- AUM余额
	depo_bal numeric(20, 2) NULL, -- 存款余额
	depo_curnt_depo_bal numeric(20, 2) NULL, -- 活期余额
	fixd_depo_bal numeric(20, 2) NULL, -- 普通定期余额
	lehui_bal numeric(20, 2) NULL, -- 乐慧存余额
	largedp_bal numeric(20, 2) NULL, -- 大额存单余额
	fin_bal numeric(20, 2) NULL, -- 理财余额
	close_agen_fin_bal numeric(20, 2) NULL, -- 代销封闭式理财余额
	open_agen_fin_bal numeric(20, 2) NULL, -- 代销开放式理财余额
	close_self_fin_bal numeric(20, 2) NULL, -- 自营封闭式理财余额
	open_self_fin_bal numeric(20, 2) NULL, -- 自营开放式理财余额
	insur_bal numeric(20, 2) NULL, -- 保险余额
	loan_bal numeric(20, 2) NULL, -- 贷款余额
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
CREATE INDEX index_crmdm_dwd_cust_asse_liab_his_index_1 ON crmdm.dws_cust_asse_liab_his USING btree (data_date, cust_id, bal_type, persn_legal_bk_code);
CREATE INDEX index_crmdm_dwd_cust_asse_liab_his_index_2 ON crmdm.dws_cust_asse_liab_his USING btree (data_date, bal_type);
COMMENT ON TABLE crmdm.dws_cust_asse_liab_his IS '客户资产负债历史表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.org_id IS '机构号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.org_id_loan IS '信贷归属机构号';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.bal_type IS '类型1-余额 2-月日均 3-季日均 4-年日均';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.aum_bal IS 'AUM余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.depo_bal IS '存款余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.depo_curnt_depo_bal IS '活期余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.fixd_depo_bal IS '普通定期余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.lehui_bal IS '乐慧存余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.largedp_bal IS '大额存单余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.fin_bal IS '理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.close_agen_fin_bal IS '代销封闭式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.open_agen_fin_bal IS '代销开放式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.close_self_fin_bal IS '自营封闭式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.open_self_fin_bal IS '自营开放式理财余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.insur_bal IS '保险余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.loan_bal IS '贷款余额';
COMMENT ON COLUMN crmdm.dws_cust_asse_liab_his.persn_legal_bk_code IS '法人行号';


-- crmdm.dws_cust_chnl_use 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_chnl_use;

CREATE TABLE crmdm.dws_cust_chnl_use (
	pk_id varchar(40) NOT NULL, -- 主键
	cust_id varchar(20) NOT NULL, -- 客户编号
	statis_typ varchar(1) NOT NULL, -- 统计口径
	chnl_cate varchar(10) NOT NULL, -- 渠道种类
	chnl_name varchar(100) NULL, -- 渠道名称
	use_cnt numeric(8) NULL, -- 使用次数
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	CONSTRAINT pk_dws_cust_chnl_use PRIMARY KEY (cust_id, statis_typ, chnl_cate)
);
COMMENT ON TABLE crmdm.dws_cust_chnl_use IS '客户渠道使用表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_chnl_use.pk_id IS '主键';
COMMENT ON COLUMN crmdm.dws_cust_chnl_use.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_chnl_use.statis_typ IS '统计口径';
COMMENT ON COLUMN crmdm.dws_cust_chnl_use.chnl_cate IS '渠道种类';
COMMENT ON COLUMN crmdm.dws_cust_chnl_use.chnl_name IS '渠道名称';
COMMENT ON COLUMN crmdm.dws_cust_chnl_use.use_cnt IS '使用次数';
COMMENT ON COLUMN crmdm.dws_cust_chnl_use.persn_legal_bk_code IS '法人行号';


-- crmdm.dws_cust_indv_poten 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_indv_poten;

CREATE TABLE crmdm.dws_cust_indv_poten (
	poten_cust_id varchar(40) NOT NULL, -- 潜在客户号(自增键)
	poten_cust_name varchar(40) NULL, -- 潜在客户名称
	poten_typ varchar(100) NULL, -- 潜客类型
	poten_cust_typ varchar(6) NULL, -- 潜在客户类型
	gender varchar(6) NULL, -- 性别
	cert_typ varchar(6) NULL, -- 证件类型
	cert_id varchar(32) NULL, -- 证件号码
	tel_no varchar(32) NULL, -- 联系电话
	intent_dsc varchar(400) NULL, -- 备注说明
	dtl_addrs varchar(400) NULL, -- 居住地址
	creatr varchar(20) NULL, -- 创建人
	creat_time varchar(20) NULL, -- 创建时间
	poten_cust_state varchar(6) NULL, -- 潜在客户状态
	lpr_id varchar(6) NULL, -- 法人行号
	src_typ varchar(20) NULL, -- 来源类型
	mkt_persn varchar(6) NULL, -- 客户经理
	mkt_org varchar(200) NULL, -- 归属机构
	serv_enter varchar(6) NULL, -- 工作单位
	post numeric(20) NULL, -- 职位
	mth_incom numeric(20) NULL, -- 月收入
	yr_incom varchar(400) NULL, -- 年收入
	rmark varchar(10) NULL, -- 备注
	inf_klkt_date varchar(200) NULL, -- 潜客转化日期
	unit_addrs varchar(60) NULL, -- 工作单位地址
	intn_prdkt varchar(40) NULL, -- 意向产品
	no_bat varchar(21) NULL, -- 批次号
	cust_id varchar(60) NULL, -- 转化后核心客户号
	pot_cnvrt_prdkt varchar(6) NULL, -- 潜客转化产品
	pot_cnvrt_org varchar(8) NULL, -- 潜客转化机构
	allo_date numeric(4) NULL, -- 分配日期
	CONSTRAINT pk_dws_cust_indv_poten PRIMARY KEY (poten_cust_id)
);
COMMENT ON TABLE crmdm.dws_cust_indv_poten IS '零售潜在客户信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_indv_poten.poten_cust_id IS '潜在客户号(自增键)';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.poten_cust_name IS '潜在客户名称';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.poten_typ IS '潜客类型';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.poten_cust_typ IS '潜在客户类型';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.gender IS '性别';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.cert_typ IS '证件类型';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.cert_id IS '证件号码';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.tel_no IS '联系电话';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.intent_dsc IS '备注说明';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.dtl_addrs IS '居住地址';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.creatr IS '创建人';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.creat_time IS '创建时间';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.poten_cust_state IS '潜在客户状态';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.lpr_id IS '法人行号';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.src_typ IS '来源类型';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.mkt_persn IS '客户经理';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.mkt_org IS '归属机构';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.serv_enter IS '工作单位';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.post IS '职位';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.mth_incom IS '月收入';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.yr_incom IS '年收入';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.rmark IS '备注';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.inf_klkt_date IS '潜客转化日期';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.unit_addrs IS '工作单位地址';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.intn_prdkt IS '意向产品';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.no_bat IS '批次号';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.cust_id IS '转化后核心客户号';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.pot_cnvrt_prdkt IS '潜客转化产品';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.pot_cnvrt_org IS '潜客转化机构';
COMMENT ON COLUMN crmdm.dws_cust_indv_poten.allo_date IS '分配日期';


-- crmdm.dws_cust_indx_data 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_indx_data;

CREATE TABLE crmdm.dws_cust_indx_data (
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	data_date varchar(8) NULL, -- 数据日期
	cust_id varchar(20) NOT NULL, -- 客户编号
	org_id varchar(8) NOT NULL, -- 客户归属机构
	indx_typ varchar(20) NULL, -- 指标类别
	indx_value varchar(20) NOT NULL, -- 指标值
	indx_last_val varchar(20) NOT NULL, -- 指标上日值
	indx_mth_val varchar(20) NOT NULL, -- 指标上月值
	indx_qrt_val varchar(20) NULL, -- 指标上季值
	indx_yr_val varchar(20) NULL -- 指标上年值
);
COMMENT ON TABLE crmdm.dws_cust_indx_data IS '客户指标表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_indx_data.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.org_id IS '客户归属机构';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.indx_typ IS '指标类别';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.indx_value IS '指标值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.indx_last_val IS '指标上日值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.indx_mth_val IS '指标上月值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.indx_qrt_val IS '指标上季值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data.indx_yr_val IS '指标上年值';


-- crmdm.dws_cust_indx_data_his 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_indx_data_his;

CREATE TABLE crmdm.dws_cust_indx_data_his (
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	data_date varchar(8) NULL, -- 数据日期
	cust_id varchar(20) NOT NULL, -- 客户编号
	org_id varchar(8) NOT NULL, -- 客户归属机构
	indx_typ varchar(20) NULL, -- 指标类别
	indx_value varchar(20) NOT NULL, -- 指标值
	indx_last_val varchar(20) NOT NULL, -- 指标上日值
	indx_mth_val varchar(20) NOT NULL, -- 指标上月值
	indx_qrt_val varchar(20) NULL, -- 指标上季值
	indx_yr_val varchar(20) NULL -- 指标上年值
);
COMMENT ON TABLE crmdm.dws_cust_indx_data_his IS '客户指标历史表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.org_id IS '客户归属机构';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.indx_typ IS '指标类别';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.indx_value IS '指标值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.indx_last_val IS '指标上日值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.indx_mth_val IS '指标上月值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.indx_qrt_val IS '指标上季值';
COMMENT ON COLUMN crmdm.dws_cust_indx_data_his.indx_yr_val IS '指标上年值';


-- crmdm.dws_cust_lvl_info 定义

-- Drop table

-- DROP TABLE crmdm.dws_cust_lvl_info;

CREATE TABLE crmdm.dws_cust_lvl_info (
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	data_date varchar(8) NOT NULL, -- 数据日期
	cust_id varchar(20) NOT NULL, -- 客户编号
	cust_lvl varchar(2) NOT NULL -- 客户等级
);
CREATE UNIQUE INDEX index_crmdm_dws_cust_lvl_info_index_1 ON crmdm.dws_cust_lvl_info USING btree (cust_id, cust_lvl, persn_legal_bk_code);
COMMENT ON TABLE crmdm.dws_cust_lvl_info IS '客户等级信息表';

-- Column comments

COMMENT ON COLUMN crmdm.dws_cust_lvl_info.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.dws_cust_lvl_info.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_lvl_info.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_lvl_info.cust_lvl IS '客户等级';


-- crmdm.ecif_t01_c_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_c_cust_info;

CREATE TABLE crmdm.ecif_t01_c_cust_info (
	party_id bpchar(20) NULL, -- PARTY_ID
	ecif_cust_no varchar(20) NULL, -- ECIF_CUST_NO
	cust_type varchar(30) NULL, -- CUST_TYPE
	party_name varchar(200) NULL, -- PARTY_NAME
	cust_shtname varchar(100) NULL, -- CUST_SHTNAME
	cust_enname varchar(200) NULL, -- CUST_ENNAME
	cust_spname varchar(200) NULL, -- CUST_SPNAME
	govn_cert_no varchar(30) NULL, -- GOVN_CERT_NO
	govn_efft_date sys."date" NULL, -- GOVN_EFFT_DATE
	govn_expd_date sys."date" NULL, -- GOVN_EXPD_DATE
	govn_review_year varchar(10) NULL, -- GOVN_REVIEW_YEAR
	org_code varchar(20) NULL, -- ORG_CODE
	org_code_issu varchar(60) NULL, -- ORG_CODE_ISSU
	org_code_iss_date sys."date" NULL, -- ORG_CODE_ISS_DATE
	org_code_due_date sys."date" NULL, -- ORG_CODE_DUE_DATE
	reg_org varchar(60) NULL, -- REG_ORG
	reg_country varchar(30) NULL, -- REG_COUNTRY
	reg_province varchar(30) NULL, -- REG_PROVINCE
	reg_area_code varchar(30) NULL, -- REG_AREA_CODE
	reg_date sys."date" NULL, -- REG_DATE
	reg_cptl numeric(20, 2) NULL, -- REG_CPTL
	reg_cptl_curr varchar(30) NULL, -- REG_CPTL_CURR
	paid_cptl numeric(20, 2) NULL, -- PAID_CPTL
	paid_cptl_curr varchar(30) NULL, -- PAID_CPTL_CURR
	org_type varchar(30) NULL, -- ORG_TYPE
	corp_attr varchar(30) NULL, -- CORP_ATTR
	comp_attr varchar(30) NULL, -- COMP_ATTR
	pay_no varchar(30) NULL, -- PAY_NO
	spe_inst_code varchar(20) NULL, -- SPE_INST_CODE
	tax_reg_no varchar(30) NULL, -- TAX_REG_NO
	reg_expd_date sys."date" NULL, -- REG_EXPD_DATE
	tax_area_no varchar(30) NULL, -- TAX_AREA_NO
	area_expd_date sys."date" NULL, -- AREA_EXPD_DATE
	tax_org varchar(60) NULL, -- TAX_ORG
	loan_card_flag bpchar(1) NULL, -- LOAN_CARD_FLAG
	loan_card_no varchar(20) NULL, -- LOAN_CARD_NO
	loan_card_due_date sys."date" NULL, -- LOAN_CARD_DUE_DATE
	loan_card_chk_date sys."date" NULL, -- LOAN_CARD_CHK_DATE
	unit_credit_code varchar(30) NULL, -- UNIT_CREDIT_CODE
	mang_dept varchar(30) NULL, -- MANG_DEPT
	corp_subj varchar(30) NULL, -- CORP_SUBJ
	industry_type varchar(30) NULL, -- INDUSTRY_TYPE
	econ_kind varchar(30) NULL, -- ECON_KIND
	basic_acc_lic_no varchar(30) NULL, -- BASIC_ACC_LIC_NO
	basic_acc_permit_no varchar(30) NULL, -- BASIC_ACC_PERMIT_NO
	basic_acc_bank_no varchar(30) NULL, -- BASIC_ACC_BANK_NO
	basic_acc_open_bank varchar(80) NULL, -- BASIC_ACC_OPEN_BANK
	basic_acc_no varchar(30) NULL, -- BASIC_ACC_NO
	busi_lic_no varchar(30) NULL, -- BUSI_LIC_NO
	admn_type varchar(1600) NULL, -- ADMN_TYPE
	side_type varchar(200) NULL, -- SIDE_TYPE
	country_mng varchar(30) NULL, -- COUNTRY_MNG
	province_mng varchar(30) NULL, -- PROVINCE_MNG
	mng_situation varchar(30) NULL, -- MNG_SITUATION
	mng_operate_area numeric(10) NULL, -- MNG_OPERATE_AREA
	mng_operate_ownership varchar(30) NULL, -- MNG_OPERATE_OWNERSHIP
	comp_size varchar(30) NULL, -- COMP_SIZE
	emp_num numeric(10) NULL, -- EMP_NUM
	total_assets numeric(20, 2) NULL, -- TOTAL_ASSETS
	net_assets numeric(20, 2) NULL, -- NET_ASSETS
	sell_sum numeric(20, 2) NULL, -- SELL_SUM
	annual_income numeric(20, 2) NULL, -- ANNUAL_INCOME
	free_tax_flag bpchar(1) NULL, -- FREE_TAX_FLAG
	free_tax_limit varchar(10) NULL, -- FREE_TAX_LIMIT
	private_flag bpchar(1) NULL, -- PRIVATE_FLAG
	listed_flag bpchar(1) NULL, -- LISTED_FLAG
	listed_on varchar(30) NULL, -- LISTED_ON
	stock_code varchar(30) NULL, -- STOCK_CODE
	holding_type varchar(30) NULL, -- HOLDING_TYPE
	actual_controller varchar(200) NULL, -- ACTUAL_CONTROLLER
	new_tech_corpornot bpchar(1) NULL, -- NEW_TECH_CORPORNOT
	spe_industry_flag bpchar(1) NULL, -- SPE_INDUSTRY_FLAG
	spe_industry_lic varchar(30) NULL, -- SPE_INDUSTRY_LIC
	imex_mana_ind bpchar(1) NULL, -- IMEX_MANA_IND
	fin_cust_type varchar(30) NULL, -- FIN_CUST_TYPE
	fin_org_type varchar(30) NULL, -- FIN_ORG_TYPE
	swift_no varchar(20) NULL, -- SWIFT_NO
	fin_lic_no varchar(30) NULL, -- FIN_LIC_NO
	fin_org_cd varchar(30) NULL, -- FIN_ORG_CD
	fin_manage_area varchar(200) NULL, -- FIN_MANAGE_AREA
	busi_area_code varchar(30) NULL, -- BUSI_AREA_CODE
	cust_fore_exch_attr bpchar(1) NULL, -- CUST_FORE_EXCH_ATTR
	nra_flag bpchar(1) NULL, -- NRA_FLAG
	fore_cust_type varchar(30) NULL, -- FORE_CUST_TYPE
	fore_exch_lic_no varchar(30) NULL, -- FORE_EXCH_LIC_NO
	busi_site_code varchar(30) NULL, -- BUSI_SITE_CODE
	res_country varchar(30) NULL, -- RES_COUNTRY
	fore_basic_acc_bank varchar(60) NULL, -- FORE_BASIC_ACC_BANK
	fore_basic_acc varchar(30) NULL, -- FORE_BASIC_ACC
	fore_inv_country varchar(30) NULL, -- FORE_INV_COUNTRY
	spe_econ_inst_flag bpchar(1) NULL, -- SPE_ECON_INST_FLAG
	spe_econ_inst_type varchar(30) NULL, -- SPE_ECON_INST_TYPE
	pay_lis_flag bpchar(1) NULL, -- PAY_LIS_FLAG
	fore_safe_no varchar(30) NULL, -- FORE_SAFE_NO
	fore_industry_type varchar(30) NULL, -- FORE_INDUSTRY_TYPE
	fore_econ_type varchar(30) NULL, -- FORE_ECON_TYPE
	fore_first_name varchar(200) NULL, -- FORE_FIRST_NAME
	fore_second_name varchar(200) NULL, -- FORE_SECOND_NAME
	bank_rel_flag varchar(30) NULL, -- BANK_REL_FLAG
	shareholder_flag bpchar(1) NULL, -- SHAREHOLDER_FLAG
	bank_svr_grade varchar(30) NULL, -- BANK_SVR_GRADE
	cust_eval_level varchar(30) NULL, -- CUST_EVAL_LEVEL
	credit_level varchar(30) NULL, -- CREDIT_LEVEL
	evaluate_date sys."date" NULL, -- EVALUATE_DATE
	other_credit_level varchar(30) NULL, -- OTHER_CREDIT_LEVEL
	other_evaluate_date sys."date" NULL, -- OTHER_EVALUATE_DATE
	other_org_name varchar(100) NULL, -- OTHER_ORG_NAME
	evaluate_level varchar(30) NULL, -- EVALUATE_LEVEL
	cust_level varchar(30) NULL, -- CUST_LEVEL
	cust_manager_no varchar(20) NULL, -- CUST_MANAGER_NO
	cust_mng_name varchar(100) NULL, -- CUST_MNG_NAME
	own_org varchar(20) NULL, -- OWN_ORG
	open_org varchar(20) NULL, -- OPEN_ORG
	open_teller varchar(20) NULL, -- OPEN_TELLER
	open_date varchar(50) NULL, -- OPEN_DATE
	cust_status bpchar(1) NULL, -- CUST_STATUS
	last_updated_te varchar(20) NULL, -- LAST_UPDATED_TE
	last_updated_org varchar(20) NULL, -- LAST_UPDATED_ORG
	created_ts timestamp(6) NULL, -- CREATED_TS
	updated_ts timestamp(6) NULL, -- UPDATED_TS
	init_system_id varchar(30) NULL, -- INIT_SYSTEM_ID
	init_created_ts timestamp(6) NULL, -- INIT_CREATED_TS
	last_system_id varchar(30) NULL, -- LAST_SYSTEM_ID
	last_updated_ts timestamp(6) NULL, -- LAST_UPDATED_TS
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.party_id IS 'PARTY_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.ecif_cust_no IS 'ECIF_CUST_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_type IS 'CUST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.party_name IS 'PARTY_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_shtname IS 'CUST_SHTNAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_enname IS 'CUST_ENNAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_spname IS 'CUST_SPNAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_cert_no IS 'GOVN_CERT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_efft_date IS 'GOVN_EFFT_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_expd_date IS 'GOVN_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.govn_review_year IS 'GOVN_REVIEW_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code IS 'ORG_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code_issu IS 'ORG_CODE_ISSU';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code_iss_date IS 'ORG_CODE_ISS_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_code_due_date IS 'ORG_CODE_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_org IS 'REG_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_country IS 'REG_COUNTRY';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_province IS 'REG_PROVINCE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_area_code IS 'REG_AREA_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_date IS 'REG_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_cptl IS 'REG_CPTL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_cptl_curr IS 'REG_CPTL_CURR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.paid_cptl IS 'PAID_CPTL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.paid_cptl_curr IS 'PAID_CPTL_CURR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.org_type IS 'ORG_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.corp_attr IS 'CORP_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.comp_attr IS 'COMP_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.pay_no IS 'PAY_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_inst_code IS 'SPE_INST_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.tax_reg_no IS 'TAX_REG_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.reg_expd_date IS 'REG_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.tax_area_no IS 'TAX_AREA_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.area_expd_date IS 'AREA_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.tax_org IS 'TAX_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_flag IS 'LOAN_CARD_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_no IS 'LOAN_CARD_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_due_date IS 'LOAN_CARD_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.loan_card_chk_date IS 'LOAN_CARD_CHK_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.unit_credit_code IS 'UNIT_CREDIT_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mang_dept IS 'MANG_DEPT';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.corp_subj IS 'CORP_SUBJ';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.industry_type IS 'INDUSTRY_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.econ_kind IS 'ECON_KIND';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_lic_no IS 'BASIC_ACC_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_permit_no IS 'BASIC_ACC_PERMIT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_bank_no IS 'BASIC_ACC_BANK_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_open_bank IS 'BASIC_ACC_OPEN_BANK';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.basic_acc_no IS 'BASIC_ACC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.busi_lic_no IS 'BUSI_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.admn_type IS 'ADMN_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.side_type IS 'SIDE_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.country_mng IS 'COUNTRY_MNG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.province_mng IS 'PROVINCE_MNG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mng_situation IS 'MNG_SITUATION';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mng_operate_area IS 'MNG_OPERATE_AREA';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.mng_operate_ownership IS 'MNG_OPERATE_OWNERSHIP';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.comp_size IS 'COMP_SIZE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.emp_num IS 'EMP_NUM';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.total_assets IS 'TOTAL_ASSETS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.net_assets IS 'NET_ASSETS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.sell_sum IS 'SELL_SUM';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.annual_income IS 'ANNUAL_INCOME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.free_tax_flag IS 'FREE_TAX_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.free_tax_limit IS 'FREE_TAX_LIMIT';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.private_flag IS 'PRIVATE_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.listed_flag IS 'LISTED_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.listed_on IS 'LISTED_ON';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.stock_code IS 'STOCK_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.holding_type IS 'HOLDING_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.actual_controller IS 'ACTUAL_CONTROLLER';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.new_tech_corpornot IS 'NEW_TECH_CORPORNOT';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_industry_flag IS 'SPE_INDUSTRY_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_industry_lic IS 'SPE_INDUSTRY_LIC';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.imex_mana_ind IS 'IMEX_MANA_IND';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_cust_type IS 'FIN_CUST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_org_type IS 'FIN_ORG_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.swift_no IS 'SWIFT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_lic_no IS 'FIN_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_org_cd IS 'FIN_ORG_CD';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fin_manage_area IS 'FIN_MANAGE_AREA';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.busi_area_code IS 'BUSI_AREA_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_fore_exch_attr IS 'CUST_FORE_EXCH_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.nra_flag IS 'NRA_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_cust_type IS 'FORE_CUST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_exch_lic_no IS 'FORE_EXCH_LIC_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.busi_site_code IS 'BUSI_SITE_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.res_country IS 'RES_COUNTRY';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_basic_acc_bank IS 'FORE_BASIC_ACC_BANK';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_basic_acc IS 'FORE_BASIC_ACC';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_inv_country IS 'FORE_INV_COUNTRY';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_econ_inst_flag IS 'SPE_ECON_INST_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.spe_econ_inst_type IS 'SPE_ECON_INST_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.pay_lis_flag IS 'PAY_LIS_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_safe_no IS 'FORE_SAFE_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_industry_type IS 'FORE_INDUSTRY_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_econ_type IS 'FORE_ECON_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_first_name IS 'FORE_FIRST_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.fore_second_name IS 'FORE_SECOND_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.bank_rel_flag IS 'BANK_REL_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.shareholder_flag IS 'SHAREHOLDER_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.bank_svr_grade IS 'BANK_SVR_GRADE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_eval_level IS 'CUST_EVAL_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.credit_level IS 'CREDIT_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.evaluate_date IS 'EVALUATE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.other_credit_level IS 'OTHER_CREDIT_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.other_evaluate_date IS 'OTHER_EVALUATE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.other_org_name IS 'OTHER_ORG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.evaluate_level IS 'EVALUATE_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_level IS 'CUST_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_manager_no IS 'CUST_MANAGER_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_mng_name IS 'CUST_MNG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.own_org IS 'OWN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.open_org IS 'OPEN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.open_teller IS 'OPEN_TELLER';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.open_date IS 'OPEN_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.cust_status IS 'CUST_STATUS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_cust_info.ryzd IS '冗余字段';


-- crmdm.ecif_t01_c_party_resolve 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_c_party_resolve;

CREATE TABLE crmdm.ecif_t01_c_party_resolve (
	party_resolve_id bpchar(20) NULL, -- PARTY_RESOLVE_ID
	party_id bpchar(20) NULL, -- PARTY_ID
	cert_type varchar(30) NULL, -- CERT_TYPE
	cert_no varchar(30) NULL, -- CERT_NO
	cert_issue_org varchar(60) NULL, -- CERT_ISSUE_ORG
	cert_issue_date sys."date" NULL, -- CERT_ISSUE_DATE
	cert_expd_date sys."date" NULL, -- CERT_EXPD_DATE
	main_cert_flag bpchar(1) NULL, -- MAIN_CERT_FLAG
	cust_flag varchar(30) NULL, -- CUST_FLAG
	last_updated_te varchar(20) NULL, -- LAST_UPDATED_TE
	last_updated_org varchar(20) NULL, -- LAST_UPDATED_ORG
	created_ts timestamp(6) NULL, -- CREATED_TS
	updated_ts timestamp(6) NULL, -- UPDATED_TS
	init_system_id varchar(30) NULL, -- INIT_SYSTEM_ID
	init_created_ts timestamp(6) NULL, -- INIT_CREATED_TS
	last_system_id varchar(30) NULL, -- LAST_SYSTEM_ID
	last_updated_ts timestamp(6) NULL, -- LAST_UPDATED_TS
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.party_resolve_id IS 'PARTY_RESOLVE_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.party_id IS 'PARTY_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_type IS 'CERT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_no IS 'CERT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_issue_org IS 'CERT_ISSUE_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_issue_date IS 'CERT_ISSUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cert_expd_date IS 'CERT_EXPD_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.main_cert_flag IS 'MAIN_CERT_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.cust_flag IS 'CUST_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_c_party_resolve.ryzd IS '冗余字段';


-- crmdm.ecif_t01_p_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_cust_info;

CREATE TABLE crmdm.ecif_t01_p_cust_info (
	party_id bpchar(20) NULL, -- PARTY_ID
	ecif_cust_no varchar(20) NULL, -- ECIF_CUST_NO
	party_name varchar(100) NULL, -- PARTY_NAME
	cert_type varchar(30) NULL, -- CERT_TYPE
	cert_no varchar(30) NULL, -- CERT_NO
	cert_org_area varchar(30) NULL, -- CERT_ORG_AREA
	cert_org_name varchar(100) NULL, -- CERT_ORG_NAME
	cert_issue_date sys."date" NULL, -- CERT_ISSUE_DATE
	cert_due_date sys."date" NULL, -- CERT_DUE_DATE
	cust_enname varchar(100) NULL, -- CUST_ENNAME
	cust_spname varchar(100) NULL, -- CUST_SPNAME
	cust_call varchar(100) NULL, -- CUST_CALL
	gender varchar(30) NULL, -- GENDER
	people varchar(30) NULL, -- PEOPLE
	birth_date sys."date" NULL, -- BIRTH_DATE
	birth_place varchar(60) NULL, -- BIRTH_PLACE
	health_state varchar(30) NULL, -- HEALTH_STATE
	marital_stat varchar(30) NULL, -- MARITAL_STAT
	nat_code varchar(30) NULL, -- NAT_CODE
	native varchar(60) NULL, -- NATIVE
	rgster varchar(100) NULL, -- RGSTER
	"language" varchar(30) NULL, -- LANGUAGE
	hobb_intrst varchar(200) NULL, -- HOBB_INTRST
	relig_code varchar(30) NULL, -- RELIG_CODE
	polit_stat varchar(30) NULL, -- POLIT_STAT
	edu_state varchar(30) NULL, -- EDU_STATE
	highest_degree varchar(30) NULL, -- HIGHEST_DEGREE
	grad_year varchar(30) NULL, -- GRAD_YEAR
	rsdt_type varchar(30) NULL, -- RSDT_TYPE
	pmt_rsdt_flag bpchar(1) NULL, -- PMT_RSDT_FLAG
	country_code varchar(30) NULL, -- COUNTRY_CODE
	area_code varchar(30) NULL, -- AREA_CODE
	reside_start_time sys."date" NULL, -- RESIDE_START_TIME
	livg_condit varchar(30) NULL, -- LIVG_CONDIT
	resdt_type varchar(30) NULL, -- RESDT_TYPE
	idvu_scl_insurs_no varchar(30) NULL, -- IDVU_SCL_INSURS_NO
	idvu_tx_no varchar(30) NULL, -- IDVU_TX_NO
	month_income numeric(20, 2) NULL, -- MONTH_INCOME
	year_salary numeric(20, 2) NULL, -- YEAR_SALARY
	econ_resur varchar(30) NULL, -- ECON_RESUR
	psn_asset_type varchar(30) NULL, -- PSN_ASSET_TYPE
	num_depend varchar(30) NULL, -- NUM_DEPEND
	fam_month numeric(20, 2) NULL, -- FAM_MONTH
	fam_year numeric(20, 2) NULL, -- FAM_YEAR
	fam_assets numeric(20, 2) NULL, -- FAM_ASSETS
	fam_memb_total varchar(30) NULL, -- FAM_MEMB_TOTAL
	unit_name varchar(120) NULL, -- UNIT_NAME
	unit_type varchar(30) NULL, -- UNIT_TYPE
	industry_type varchar(30) NULL, -- INDUSTRY_TYPE
	profession varchar(30) NULL, -- PROFESSION
	job_level varchar(30) NULL, -- JOB_LEVEL
	unit_position varchar(30) NULL, -- UNIT_POSITION
	tech_title varchar(30) NULL, -- TECH_TITLE
	work_stat bpchar(1) NULL, -- WORK_STAT
	qualft_stat varchar(30) NULL, -- QUALFT_STAT
	work_start_date sys."date" NULL, -- WORK_START_DATE
	unit_start_year varchar(10) NULL, -- UNIT_START_YEAR
	bank_rel_code varchar(30) NULL, -- BANK_REL_CODE
	shareholder_flag bpchar(1) NULL, -- SHAREHOLDER_FLAG
	cust_fore_exch_attr bpchar(1) NULL, -- CUST_FORE_EXCH_ATTR
	credit_level varchar(30) NULL, -- CREDIT_LEVEL
	grade_date sys."date" NULL, -- GRADE_DATE
	grade_due_date sys."date" NULL, -- GRADE_DUE_DATE
	bank_svr_grade varchar(30) NULL, -- BANK_SVR_GRADE
	cust_eval_level varchar(30) NULL, -- CUST_EVAL_LEVEL
	best_call_time varchar(30) NULL, -- BEST_CALL_TIME
	cust_level varchar(30) NULL, -- CUST_LEVEL
	cust_manager_no varchar(20) NULL, -- CUST_MANAGER_NO
	cust_mng_name varchar(100) NULL, -- CUST_MNG_NAME
	ide_check_result varchar(30) NULL, -- IDE_CHECK_RESULT
	ide_false_reason varchar(30) NULL, -- IDE_FALSE_REASON
	own_org varchar(20) NULL, -- OWN_ORG
	open_org varchar(20) NULL, -- OPEN_ORG
	open_teller varchar(20) NULL, -- OPEN_TELLER
	open_date sys."date" NULL, -- OPEN_DATE
	real_full_flag bpchar(1) NULL, -- REAL_FULL_FLAG
	cust_status bpchar(1) NULL, -- CUST_STATUS
	last_updated_te varchar(20) NULL, -- LAST_UPDATED_TE
	last_updated_org varchar(20) NULL, -- LAST_UPDATED_ORG
	created_ts timestamp(6) NULL, -- CREATED_TS
	updated_ts timestamp(6) NULL, -- UPDATED_TS
	init_system_id varchar(30) NULL, -- INIT_SYSTEM_ID
	init_created_ts timestamp(6) NULL, -- INIT_CREATED_TS
	last_system_id varchar(30) NULL, -- LAST_SYSTEM_ID
	last_updated_ts timestamp(6) NULL, -- LAST_UPDATED_TS
	ryzd varchar(1) NULL -- 冗余字段
);
CREATE INDEX index_crmdm_ecif_t01_p_cust_info_index_1 ON crmdm.ecif_t01_p_cust_info USING btree (party_id);
CREATE INDEX index_crmdm_ecif_t01_p_cust_info_index_2 ON crmdm.ecif_t01_p_cust_info USING btree (ecif_cust_no);
CREATE INDEX index_crmdm_ecif_t01_p_cust_info_index_3 ON crmdm.ecif_t01_p_cust_info USING btree (last_updated_ts);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.party_id IS 'PARTY_ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ecif_cust_no IS 'ECIF_CUST_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.party_name IS 'PARTY_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_type IS 'CERT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_no IS 'CERT_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_org_area IS 'CERT_ORG_AREA';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_org_name IS 'CERT_ORG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_issue_date IS 'CERT_ISSUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cert_due_date IS 'CERT_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_enname IS 'CUST_ENNAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_spname IS 'CUST_SPNAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_call IS 'CUST_CALL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.gender IS 'GENDER';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.people IS 'PEOPLE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.birth_date IS 'BIRTH_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.birth_place IS 'BIRTH_PLACE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.health_state IS 'HEALTH_STATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.marital_stat IS 'MARITAL_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.nat_code IS 'NAT_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.native IS 'NATIVE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.rgster IS 'RGSTER';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info."language" IS 'LANGUAGE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.hobb_intrst IS 'HOBB_INTRST';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.relig_code IS 'RELIG_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.polit_stat IS 'POLIT_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.edu_state IS 'EDU_STATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.highest_degree IS 'HIGHEST_DEGREE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.grad_year IS 'GRAD_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.rsdt_type IS 'RSDT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.pmt_rsdt_flag IS 'PMT_RSDT_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.country_code IS 'COUNTRY_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.area_code IS 'AREA_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.reside_start_time IS 'RESIDE_START_TIME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.livg_condit IS 'LIVG_CONDIT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.resdt_type IS 'RESDT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.idvu_scl_insurs_no IS 'IDVU_SCL_INSURS_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.idvu_tx_no IS 'IDVU_TX_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.month_income IS 'MONTH_INCOME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.year_salary IS 'YEAR_SALARY';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.econ_resur IS 'ECON_RESUR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.psn_asset_type IS 'PSN_ASSET_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.num_depend IS 'NUM_DEPEND';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_month IS 'FAM_MONTH';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_year IS 'FAM_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_assets IS 'FAM_ASSETS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.fam_memb_total IS 'FAM_MEMB_TOTAL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_name IS 'UNIT_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_type IS 'UNIT_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.industry_type IS 'INDUSTRY_TYPE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.profession IS 'PROFESSION';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.job_level IS 'JOB_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_position IS 'UNIT_POSITION';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.tech_title IS 'TECH_TITLE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.work_stat IS 'WORK_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.qualft_stat IS 'QUALFT_STAT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.work_start_date IS 'WORK_START_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.unit_start_year IS 'UNIT_START_YEAR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.bank_rel_code IS 'BANK_REL_CODE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.shareholder_flag IS 'SHAREHOLDER_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_fore_exch_attr IS 'CUST_FORE_EXCH_ATTR';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.credit_level IS 'CREDIT_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.grade_date IS 'GRADE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.grade_due_date IS 'GRADE_DUE_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.bank_svr_grade IS 'BANK_SVR_GRADE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_eval_level IS 'CUST_EVAL_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.best_call_time IS 'BEST_CALL_TIME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_level IS 'CUST_LEVEL';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_manager_no IS 'CUST_MANAGER_NO';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_mng_name IS 'CUST_MNG_NAME';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ide_check_result IS 'IDE_CHECK_RESULT';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ide_false_reason IS 'IDE_FALSE_REASON';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.own_org IS 'OWN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.open_org IS 'OPEN_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.open_teller IS 'OPEN_TELLER';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.open_date IS 'OPEN_DATE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.real_full_flag IS 'REAL_FULL_FLAG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.cust_status IS 'CUST_STATUS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t01_p_cust_info.ryzd IS '冗余字段';


-- crmdm.ecif_t01_p_rel_com_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_rel_com_info;

CREATE TABLE crmdm.ecif_t01_p_rel_com_info (
	relation_id bpchar(20) NOT NULL, -- 关系人ID
	cert_expd_date sys."date" NULL, -- 证件到期日期
	govn_cert_no varchar(30) NULL, -- 营业执照号码
	govn_efft_date sys."date" NULL, -- 营业执照生效日期
	govn_expd_date sys."date" NULL, -- 营业执照有效日期
	acct_lic_no varchar(30) NULL, -- 开户许可证编号
	loan_card_no varchar(30) NULL, -- 贷款卡号
	org_code varchar(20) NULL, -- 组织机构代码
	unit_credit_code varchar(30) NULL, -- 机构信用代码
	reg_date sys."date" NULL, -- 注册日期(企业成立日期)
	reg_cptl numeric(20, 2) NULL, -- 注册资本(元)
	reg_cptl_curr varchar(30) NULL, -- 注册资本币别 C008
	paid_cptl numeric(20, 2) NULL, -- 实收资本(元)
	paid_cptl_curr varchar(30) NULL, -- 实收资本币别 C008
	comp_size varchar(30) NULL, -- 企业规模 C204
	register_add varchar(160) NULL, -- 注册地址
	comp_type varchar(30) NULL, -- 企业类型 C202
	industry_type varchar(30) NULL, -- 行业类别 C004
	econ_kind varchar(30) NULL, -- 经济性质 C203
	admn_type varchar(1600) NULL, -- 经营范围
	tax_reg_no varchar(30) NULL, -- 税务登记编号(国税)
	tax_area_no varchar(30) NULL, -- 税务登记编号(地税)
	legal_name varchar(100) NULL, -- 法定代表人姓名
	legal_cert_type varchar(30) NULL, -- 法人证件种类 C001
	legal_cert_no varchar(30) NULL, -- 法人证件号码
	legal_cert_expd_date sys."date" NULL, -- 法人证件到期日
	post_cd varchar(6) NULL, -- 邮政编码
	region_code varchar(30) NULL, -- 所在行政区域 C007
	office_tel varchar(36) NULL, -- 联系电话
	office_fax varchar(36) NULL, -- 传真号码
	web_add varchar(160) NULL, -- 公司网址
	email_add varchar(160) NULL, -- 公司邮件地址
	com_add varchar(160) NULL, -- 公司地址
	eff_status bpchar(1) NULL, -- 有效标志
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.relation_id IS '关系人ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.cert_expd_date IS '证件到期日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.govn_cert_no IS '营业执照号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.govn_efft_date IS '营业执照生效日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.govn_expd_date IS '营业执照有效日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.acct_lic_no IS '开户许可证编号';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.loan_card_no IS '贷款卡号';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.org_code IS '组织机构代码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.unit_credit_code IS '机构信用代码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.reg_date IS '注册日期(企业成立日期)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.reg_cptl IS '注册资本(元)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.reg_cptl_curr IS '注册资本币别 C008';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.paid_cptl IS '实收资本(元)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.paid_cptl_curr IS '实收资本币别 C008';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.comp_size IS '企业规模 C204';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.register_add IS '注册地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.comp_type IS '企业类型 C202';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.industry_type IS '行业类别 C004';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.econ_kind IS '经济性质 C203';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.admn_type IS '经营范围';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.tax_reg_no IS '税务登记编号(国税)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.tax_area_no IS '税务登记编号(地税)';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_name IS '法定代表人姓名';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_cert_type IS '法人证件种类 C001';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_cert_no IS '法人证件号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.legal_cert_expd_date IS '法人证件到期日';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.post_cd IS '邮政编码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.region_code IS '所在行政区域 C007';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.office_tel IS '联系电话';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.office_fax IS '传真号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.web_add IS '公司网址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.email_add IS '公司邮件地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.com_add IS '公司地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.eff_status IS '有效标志';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_rel_com_info.ryzd IS '冗余字段';


-- crmdm.ecif_t01_p_relationer_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t01_p_relationer_info;

CREATE TABLE crmdm.ecif_t01_p_relationer_info (
	relation_id bpchar(20) NOT NULL, -- 关系人ID
	cert_issue_date sys."date" NULL, -- 证件核发日期
	cert_expd_date sys."date" NULL, -- 证件有效日期
	cert_org_area varchar(30) NULL, -- 发证机关所在地
	nat_code varchar(30) NULL, -- 国籍 C003
	gender varchar(30) NULL, -- 性别 C101
	birth_date sys."date" NULL, -- 出生日期
	educ_sign varchar(30) NULL, -- 最高学历 C106
	econ_resur varchar(30) NULL, -- 主要经济来源 C124
	work_corp varchar(120) NULL, -- 工作单位
	work_addr varchar(160) NULL, -- 单位地址
	unit_type varchar(30) NULL, -- 单位分类 C117
	industry_type varchar(30) NULL, -- 从事行业类型 C004
	profession varchar(30) NULL, -- 职业 C111
	poston varchar(30) NULL, -- 职务 C113
	tech_title varchar(30) NULL, -- 职称 C114
	year_salary numeric(20, 2) NULL, -- 个人年收入
	home_addr varchar(160) NULL, -- 家庭地址
	post_cd varchar(6) NULL, -- 邮政编码
	find_addr varchar(160) NULL, -- 联系地址
	findtel_no varchar(36) NULL, -- 联系电话
	mobile_no varchar(36) NULL, -- 手机号码
	contact_dept varchar(100) NULL, -- 联系部门
	fax_no varchar(36) NULL, -- 传真号码
	email varchar(160) NULL, -- 电子邮件
	url_addr varchar(160) NULL, -- 网址
	oicq_no varchar(20) NULL, -- QQ号码
	msg_addr varchar(80) NULL, -- 微信号码
	fancy_desc varchar(200) NULL, -- 个人爱好
	eff_status bpchar(1) NULL, -- 有效标志
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.relation_id IS '关系人ID';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.cert_issue_date IS '证件核发日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.cert_expd_date IS '证件有效日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.cert_org_area IS '发证机关所在地';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.nat_code IS '国籍 C003';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.gender IS '性别 C101';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.birth_date IS '出生日期';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.educ_sign IS '最高学历 C106';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.econ_resur IS '主要经济来源 C124';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.work_corp IS '工作单位';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.work_addr IS '单位地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.unit_type IS '单位分类 C117';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.industry_type IS '从事行业类型 C004';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.profession IS '职业 C111';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.poston IS '职务 C113';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.tech_title IS '职称 C114';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.year_salary IS '个人年收入';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.home_addr IS '家庭地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.post_cd IS '邮政编码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.find_addr IS '联系地址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.findtel_no IS '联系电话';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.mobile_no IS '手机号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.contact_dept IS '联系部门';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.fax_no IS '传真号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.email IS '电子邮件';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.url_addr IS '网址';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.oicq_no IS 'QQ号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.msg_addr IS '微信号码';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.fancy_desc IS '个人爱好';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.eff_status IS '有效标志';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t01_p_relationer_info.ryzd IS '冗余字段';


-- crmdm.ecif_t02_a_cust_addr_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_addr_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_addr_rel (
	addr_seq_id bpchar(20) NOT NULL, -- 地址关系记录编号
	party_id bpchar(20) NOT NULL, -- 参与人ID
	addr_type varchar(30) NOT NULL, -- 地址类型 C023
	addr_id bpchar(20) NULL, -- 联系地址ID
	addr_tab_id bpchar(8) NULL, -- 地址表ID
	role_id bpchar(20) NULL, -- 地址角色ID
	role_tab_id bpchar(8) NULL, -- 地址角色表ID
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_seq_id IS '地址关系记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_type IS '地址类型 C023';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_id IS '联系地址ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.addr_tab_id IS '地址表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.role_id IS '地址角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.role_tab_id IS '地址角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_addr_rel.ryzd IS '冗余字段';


-- crmdm.ecif_t02_a_cust_sign_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_sign_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_sign_rel (
	sign_seq_id bpchar(20) NULL, -- 签约记录编号
	party_id bpchar(20) NULL, -- 参与人ID
	sign_sys_no varchar(30) NULL, -- 签约系统编号 C019
	acc_sign_no varchar(20) NULL, -- 签约编号
	sign_type varchar(30) NULL, -- 签约类型 C029
	sign_edit varchar(30) NULL, -- 签约版本 C034
	sign_acc_type varchar(30) NULL, -- 签约账户类型 C027
	sign_acc_no varchar(40) NULL, -- 签约客户账号
	old_sign_acc varchar(40) NULL, -- 原签约账号
	init_sign_acc varchar(40) NULL, -- 初始签约账号
	sign_prd_no varchar(200) NULL, -- 签约主产品
	sign_prd_desc varchar(200) NULL, -- 签约主产品描述
	sign_main_prd_flg bpchar(1) NULL, -- 签约主产品标志 C009
	sign_arr_no varchar(100) NULL, -- 签约协议号
	sign_state bpchar(1) NULL, -- 签约状态
	acc_sign_id bpchar(20) NULL, -- 账户签约ID
	sign_tab_id bpchar(8) NULL, -- 签约表ID
	role_id bpchar(20) NULL, -- 签约角色ID
	role_tab_id bpchar(8) NULL, -- 签约角色表ID
	acc_name varchar(200) NULL, -- 签约账户名称
	expd_date sys."date" NULL, -- 过期日期
	sign_info_ext_1 varchar(30) NULL, -- 签约信息扩展1
	sign_info_ext_2 varchar(30) NULL, -- 签约信息扩展2
	sign_info_ext_3 varchar(30) NULL, -- 签约信息扩展3
	sign_info_ext_4 varchar(512) NULL, -- 签约信息扩展4
	sign_info_ext_5 varchar(512) NULL, -- 签约信息扩展5
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_seq_id IS '签约记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_sys_no IS '签约系统编号 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.acc_sign_no IS '签约编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_type IS '签约类型 C029';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_edit IS '签约版本 C034';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_acc_type IS '签约账户类型 C027';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_acc_no IS '签约客户账号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.old_sign_acc IS '原签约账号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.init_sign_acc IS '初始签约账号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_prd_no IS '签约主产品';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_prd_desc IS '签约主产品描述';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_main_prd_flg IS '签约主产品标志 C009';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_arr_no IS '签约协议号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_state IS '签约状态';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.acc_sign_id IS '账户签约ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_tab_id IS '签约表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.role_id IS '签约角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.role_tab_id IS '签约角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.acc_name IS '签约账户名称';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.expd_date IS '过期日期';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_1 IS '签约信息扩展1';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_2 IS '签约信息扩展2';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_3 IS '签约信息扩展3';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_4 IS '签约信息扩展4';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.sign_info_ext_5 IS '签约信息扩展5';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_sign_rel.ryzd IS '冗余字段';


-- crmdm.ecif_t02_a_cust_tele_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_a_cust_tele_rel;

CREATE TABLE crmdm.ecif_t02_a_cust_tele_rel (
	tele_seq_id bpchar(20) NOT NULL, -- 电话关系记录编号
	party_id bpchar(20) NOT NULL, -- 参与人ID
	tele_type varchar(30) NOT NULL, -- 电话类型 C024
	tele_id bpchar(20) NULL, -- 联系电话ID
	tele_tab_id bpchar(8) NULL, -- 联系电话表ID
	role_id bpchar(20) NULL, -- 电话角色ID
	role_tab_id bpchar(8) NULL, -- 电话角色表ID
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);
CREATE INDEX index_crmdm_ecif_t02_a_cust_tele_rel_index_1 ON crmdm.ecif_t02_a_cust_tele_rel USING btree (party_id);
CREATE INDEX index_crmdm_ecif_t02_a_cust_tele_rel_index_2 ON crmdm.ecif_t02_a_cust_tele_rel USING btree (tele_id);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.tele_seq_id IS '电话关系记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.tele_type IS '电话类型 C024';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.tele_id IS '联系电话ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.tele_tab_id IS '联系电话表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.role_id IS '电话角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.role_tab_id IS '电话角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_a_cust_tele_rel.ryzd IS '冗余字段';


-- crmdm.ecif_t02_p_par_to_par_rel 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t02_p_par_to_par_rel;

CREATE TABLE crmdm.ecif_t02_p_par_to_par_rel (
	par_seq_id bpchar(20) NULL, -- 关联关系记录编号
	party_id bpchar(20) NULL, -- 参与人ID
	relation_type varchar(30) NULL, -- 关联关系类型 C022
	relation_id bpchar(20) NULL, -- 关系人ID
	relation_tab_id bpchar(8) NULL, -- 关系人信息表ID
	role_type varchar(30) NULL, -- 参与人角色类型
	role_id bpchar(20) NULL, -- 参与人角色ID
	role_tab_id bpchar(8) NULL, -- 参与人角色表ID
	rel_name varchar(200) NULL, -- 关系人名称
	rel_cert_type varchar(30) NULL, -- 关系人证件类型 C001
	rel_cert_no varchar(30) NULL, -- 关系人证件号码
	other_desc varchar(200) NULL, -- 其它说明
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);
CREATE INDEX index_crmdm_ecif_t02_p_par_to_par_rel_index_1 ON crmdm.ecif_t02_p_par_to_par_rel USING btree (party_id);
CREATE INDEX index_crmdm_ecif_t02_p_par_to_par_rel_index_2 ON crmdm.ecif_t02_p_par_to_par_rel USING btree (relation_id);
CREATE INDEX index_crmdm_ecif_t02_p_par_to_par_rel_index_3 ON crmdm.ecif_t02_p_par_to_par_rel USING btree (relation_type);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.par_seq_id IS '关联关系记录编号';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.party_id IS '参与人ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.relation_type IS '关联关系类型 C022';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.relation_id IS '关系人ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.relation_tab_id IS '关系人信息表ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.role_type IS '参与人角色类型';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.role_id IS '参与人角色ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.role_tab_id IS '参与人角色表ID';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.rel_name IS '关系人名称';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.rel_cert_type IS '关系人证件类型 C001';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.rel_cert_no IS '关系人证件号码';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.other_desc IS '其它说明';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t02_p_par_to_par_rel.ryzd IS '冗余字段';


-- crmdm.ecif_t03_a_addr_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t03_a_addr_info;

CREATE TABLE crmdm.ecif_t03_a_addr_info (
	addr_id bpchar(20) NULL, -- 联系地址ID
	post_cd varchar(6) NULL, -- 邮政编码
	nation varchar(30) NULL, -- 国家 C003
	province varchar(30) NULL, -- 省、直辖市、自治区 C005
	city varchar(30) NULL, -- 城市 C006
	county varchar(30) NULL, -- 县、区 C007
	street varchar(80) NULL, -- 街道
	addr_line varchar(160) NULL, -- 详细地址
	addr_desc varchar(200) NULL, -- 地址描述
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.addr_id IS '联系地址ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.post_cd IS '邮政编码';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.nation IS '国家 C003';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.province IS '省、直辖市、自治区 C005';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.city IS '城市 C006';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.county IS '县、区 C007';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.street IS '街道';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.addr_line IS '详细地址';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.addr_desc IS '地址描述';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t03_a_addr_info.ryzd IS '冗余字段';


-- crmdm.ecif_t03_a_tele_info 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t03_a_tele_info;

CREATE TABLE crmdm.ecif_t03_a_tele_info (
	tele_id bpchar(20) NULL, -- TELE_ID
	country_no varchar(6) NULL, -- COUNTRY_NO
	area_no varchar(6) NULL, -- AREA_NO
	phone_no varchar(36) NULL, -- PHONE_NO
	ext_no varchar(6) NULL, -- EXT_NO
	addr_desc varchar(200) NULL, -- ADDR_DESC
	last_updated_te varchar(20) NULL, -- LAST_UPDATED_TE
	last_updated_org varchar(20) NULL, -- LAST_UPDATED_ORG
	created_ts timestamp(6) NULL, -- CREATED_TS
	updated_ts timestamp(6) NULL, -- UPDATED_TS
	init_system_id varchar(30) NULL, -- INIT_SYSTEM_ID
	init_created_ts timestamp(6) NULL, -- INIT_CREATED_TS
	last_system_id varchar(30) NULL, -- LAST_SYSTEM_ID
	last_updated_ts timestamp(6) NULL, -- LAST_UPDATED_TS
	ryzd varchar(1) NULL -- 冗余字段
);
CREATE INDEX index_crmdm_ecif_t03_a_tele_info_index_1 ON crmdm.ecif_t03_a_tele_info USING btree (tele_id);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.tele_id IS 'TELE_ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.country_no IS 'COUNTRY_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.area_no IS 'AREA_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.phone_no IS 'PHONE_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.ext_no IS 'EXT_NO';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.addr_desc IS 'ADDR_DESC';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_updated_te IS 'LAST_UPDATED_TE';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_updated_org IS 'LAST_UPDATED_ORG';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.created_ts IS 'CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.updated_ts IS 'UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.init_system_id IS 'INIT_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.init_created_ts IS 'INIT_CREATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_system_id IS 'LAST_SYSTEM_ID';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.last_updated_ts IS 'LAST_UPDATED_TS';
COMMENT ON COLUMN crmdm.ecif_t03_a_tele_info.ryzd IS '冗余字段';


-- crmdm.ecif_t05_a_acc_sign 定义

-- Drop table

-- DROP TABLE crmdm.ecif_t05_a_acc_sign;

CREATE TABLE crmdm.ecif_t05_a_acc_sign (
	acc_sign_id bpchar(20) NOT NULL, -- 账户签约ID
	sign_prd_2 varchar(200) NULL, -- 签约产品2
	sign_prd_3 varchar(200) NULL, -- 签约产品3
	balance_dis_flag bpchar(1) NULL, -- 账户余额显示标志 C009
	sign_org varchar(20) NULL, -- 签约机构
	sign_oper varchar(30) NULL, -- 签约柜员
	sign_date sys."date" NULL, -- 签约日期
	close_org varchar(20) NULL, -- 解约机构
	close_oper varchar(30) NULL, -- 解约柜员
	close_date sys."date" NULL, -- 解约日期
	sign_rel_addr varchar(160) NULL, -- 联系地址
	sign_rel_phone varchar(36) NULL, -- 联系电话
	sign_rel_name varchar(120) NULL, -- 联系人名称
	attn_name varchar(120) NULL, -- 经办人名称
	attn_cert_type varchar(30) NULL, -- 经办人证件类型 C001
	attn_cert_no varchar(30) NULL, -- 经办人证件号码
	last_updated_te varchar(20) NULL, -- 更新柜员
	last_updated_org varchar(20) NULL, -- 更新机构号
	created_ts timestamp(6) NULL, -- 进入ECIF的时间
	updated_ts timestamp(6) NULL, -- 在ECIF中更新的时间
	init_system_id varchar(30) NOT NULL, -- 创建渠道 C019
	init_created_ts timestamp(6) NULL, -- 源系统创建时间
	last_system_id varchar(30) NOT NULL, -- 最新更新渠道 C019
	last_updated_ts timestamp(6) NULL, -- 最新更新时间
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.acc_sign_id IS '账户签约ID';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_prd_2 IS '签约产品2';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_prd_3 IS '签约产品3';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.balance_dis_flag IS '账户余额显示标志 C009';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_org IS '签约机构';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_oper IS '签约柜员';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_date IS '签约日期';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.close_org IS '解约机构';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.close_oper IS '解约柜员';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.close_date IS '解约日期';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_rel_addr IS '联系地址';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_rel_phone IS '联系电话';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.sign_rel_name IS '联系人名称';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.attn_name IS '经办人名称';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.attn_cert_type IS '经办人证件类型 C001';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.attn_cert_no IS '经办人证件号码';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_updated_te IS '更新柜员';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_updated_org IS '更新机构号';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.created_ts IS '进入ECIF的时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.updated_ts IS '在ECIF中更新的时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.init_system_id IS '创建渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.init_created_ts IS '源系统创建时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_system_id IS '最新更新渠道 C019';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.last_updated_ts IS '最新更新时间';
COMMENT ON COLUMN crmdm.ecif_t05_a_acc_sign.ryzd IS '冗余字段';


-- crmdm.fms_t1_cust_fnc_acct 定义

-- Drop table

-- DROP TABLE crmdm.fms_t1_cust_fnc_acct;

CREATE TABLE crmdm.fms_t1_cust_fnc_acct (
	fnc_trans_acct_no varchar(17) NULL, -- 理财交易账号
	cust_no varchar(20) NULL, -- 客户号
	card_type varchar(8) NULL, -- 卡类型
	card_no varchar(32) NULL, -- 介质号
	acct_no varchar(32) NULL, -- 银行账号
	acct_nm varchar(128) NULL, -- 银行账号名称
	sub_acct_no varchar(32) NULL, -- 子银行账号
	trans_pwd varchar(64) NULL, -- 交易密码
	cur varchar(8) NULL, -- 币种
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型
	acct_status bpchar(1) NULL, -- 账户状态
	bank_code varchar(20) NULL, -- 银行代码-登记总行
	branch_code varchar(20) NULL, -- 分行代码-登记分行
	sub_branch_code varchar(20) NULL, -- 网点代码-登记网点
	inputuser varchar(20) NULL, -- 录入柜员
	iss_bank_code varchar(20) NULL, -- 发卡银行
	iss_branch_code varchar(20) NULL, -- 发卡分行
	iss_sub_branch_code varchar(20) NULL, -- 发卡网点
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	inv_date bpchar(8) NULL, -- 注销日期
	inv_time bpchar(6) NULL, -- 注销时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	tradingmethod varchar(3) NULL, -- 签约/登记渠道
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.fms_t1_cust_fnc_acct IS '客户理财交易账号表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.card_type IS '卡类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.card_no IS '介质号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.acct_nm IS '银行账号名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.sub_acct_no IS '子银行账号';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.trans_pwd IS '交易密码';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cur IS '币种';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.cust_card_type IS '客户卡类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.acct_status IS '账户状态';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.bank_code IS '银行代码-登记总行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.branch_code IS '分行代码-登记分行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.sub_branch_code IS '网点代码-登记网点';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.iss_bank_code IS '发卡银行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.iss_branch_code IS '发卡分行';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.iss_sub_branch_code IS '发卡网点';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.inv_date IS '注销日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.inv_time IS '注销时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.tradingmethod IS '签约/登记渠道';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_t1_cust_fnc_acct.ryzd IS '冗余字段';


-- crmdm.fms_t1_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t1_cust_info;

CREATE TABLE crmdm.fms_t1_cust_info (
	cust_no varchar(20) NULL, -- 客户号
	host_cust_no varchar(32) NULL, -- 主机客户号
	id_type varchar(8) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	host_id_type varchar(8) NULL, -- 主机证件类型
	cust_name varchar(128) NULL, -- 客户名称
	cust_type varchar(8) NULL, -- 客户类型
	cust_level varchar(8) NULL, -- 客户级别
	cust_card_type varchar(8) NULL, -- 客户卡类型
	instrepr_name varchar(128) NULL, -- 法人名称
	instrepr_id_type varchar(8) NULL, -- 法人证件类型
	instrepr_id_code varchar(32) NULL, -- 法人证件号码
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(8) NULL, -- 经办(代理)人证件类型
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	birthday bpchar(8) NULL, -- 出生日期
	sex bpchar(1) NULL, -- 性别
	education bpchar(1) NULL, -- 学历
	mobile varchar(20) NULL, -- 手机号码
	home_tel varchar(20) NULL, -- 家庭电话
	office_tel varchar(20) NULL, -- 办公电话
	fax varchar(20) NULL, -- 传真号码
	postcode bpchar(6) NULL, -- 邮政编码
	addr varchar(128) NULL, -- 通信地址
	email varchar(64) NULL, -- 邮箱地址
	cust_manager varchar(20) NULL, -- 客户经理代码
	fnc_manager varchar(20) NULL, -- 理财经理代码
	protocol_serno varchar(32) NULL, -- 协议单号（纸质上显示的编号）
	protocol_status bpchar(1) NULL, -- 协议状态
	bank_code varchar(20) NULL, -- 银行代码-签约总行
	branch_code varchar(20) NULL, -- 分行代码-签约分行
	sub_branch_code varchar(20) NULL, -- 网点代码-签约网点
	inputuser varchar(20) NULL, -- 录入柜员
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	inv_date bpchar(8) NULL, -- 注销日期
	inv_time bpchar(6) NULL, -- 注销时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	investor_type bpchar(2) NULL, -- 投资者类型
	cust_ename varchar(100) NULL, -- 客户英文名
	cust_cname varchar(100) NULL, -- 客户中文名
	agent_ename varchar(100) NULL, -- 代办人英文名
	agent_cname varchar(100) NULL, -- 代办人中文名
	is_new_cust bpchar(1) NULL, -- 是否新客
	investor_class bpchar(1) NULL, -- 投资者类别
	investor_invalid_date bpchar(8) NULL, -- 合格投资者失效日
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	certvaliddate bpchar(8) NULL, -- 证件有效日期（长期有效填写 99991231）
	annualincome numeric(16) NULL, -- 投资人年收入(单位：元)
	nationality varchar(3) NULL, -- 国籍(GB/T 2659-2000中两位英文字母)
	vocationcode varchar(5) NULL, -- 职业代码(01-党政机关、事业单位 02-企业单位 03-自由业主 04-学生 05-军人 06-其他；按人行要求，分类不能有“其它”。)
	specialpersonflag bpchar(1) NULL, -- 特定自然人标识
	fir_investor_type bpchar(1) NULL, -- 个人投资类型
	family_name varchar(100) NULL, -- 英文姓
	first_name varchar(100) NULL, -- 英文名
	living_country varchar(3) NULL, -- 现居国家
	living_province varchar(6) NULL, -- 现居地址-省份
	living_city varchar(6) NULL, -- 现居地址-城市
	living_district varchar(6) NULL, -- 现居地址-县/行政区
	living_address varchar(300) NULL, -- 现居地址-详细地址
	corp_name varchar(40) NULL, -- 工作单位名称
	non_resi_flag varchar(1) NULL, -- 非居民标识
	tax_country varchar(3) NULL, -- 税收居民国 0：仅为中国税收居民 1：仅为非居民 2：同为中国和其它国税收居民 3:不配合客户'
	tax_id varchar(200) NULL -- 纳税人识别号,
	is_dx_new_cust bpchar(1) NULL, -- 是否代销新客;0-否;1-是
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.fms_t1_cust_info IS '客户信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.host_cust_no IS '主机客户号';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.host_id_type IS '主机证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_card_type IS '客户卡类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.instrepr_name IS '法人名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.instrepr_id_type IS '法人证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.instrepr_id_code IS '法人证件号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_id_type IS '经办(代理)人证件类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.birthday IS '出生日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.sex IS '性别';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.education IS '学历';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.mobile IS '手机号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.home_tel IS '家庭电话';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.office_tel IS '办公电话';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.fax IS '传真号码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.postcode IS '邮政编码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.addr IS '通信地址';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.email IS '邮箱地址';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.fnc_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.protocol_serno IS '协议单号（纸质上显示的编号）';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.protocol_status IS '协议状态';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.bank_code IS '银行代码-签约总行';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.branch_code IS '分行代码-签约分行';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.sub_branch_code IS '网点代码-签约网点';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.inv_date IS '注销日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.inv_time IS '注销时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.investor_type IS '投资者类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_ename IS '客户英文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.cust_cname IS '客户中文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_ename IS '代办人英文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.agent_cname IS '代办人中文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.is_new_cust IS '是否新客';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.investor_class IS '投资者类别';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.investor_invalid_date IS '合格投资者失效日';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.certvaliddate IS '证件有效日期（长期有效填写 99991231）';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.annualincome IS '投资人年收入(单位：元)';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.nationality IS '国籍(GB/T 2659-2000中两位英文字母)';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.vocationcode IS '职业代码(01-党政机关、事业单位 02-企业单位 03-自由业主 04-学生 05-军人 06-其他；按人行要求，分类不能有“其它”。)';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.specialpersonflag IS '特定自然人标识';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.fir_investor_type IS '个人投资类型';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.family_name IS '英文姓';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.first_name IS '英文名';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_country IS '现居国家';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_province IS '现居地址-省份';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_city IS '现居地址-城市';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_district IS '现居地址-县/行政区';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.living_address IS '现居地址-详细地址';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.corp_name IS '工作单位名称';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.non_resi_flag IS '非居民标识';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.tax_country IS '税收居民国 0：仅为中国税收居民 1：仅为非居民 2：同为中国和其它国税收居民 3:不配合客户''';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.tax_id IS '纳税人识别号';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.is_dx_new_cust IS '是否代销新客;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t1_cust_info.ryzd IS '冗余字段';


-- crmdm.fms_t4_cust_risk_assess_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t4_cust_risk_assess_info;

CREATE TABLE crmdm.fms_t4_cust_risk_assess_info (
	host_cust_no varchar(32) NULL, -- 主机客户号
	cust_no varchar(20) NULL, -- 客户号
	cust_type varchar(8) NULL, -- 客户类型
	cust_risk_level bpchar(1) NULL, -- 风险承受等级
	assess_date bpchar(8) NULL, -- 评估日期
	trans_serno varchar(32) NULL, -- 风险评估交易流水号
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	id_type varchar(8) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	invalid_date bpchar(8) NULL, -- 失效日期
	publish_code varchar(8) NULL, -- 管理人代码
	print_no varchar(8) NULL, -- 打印次数
	counter_assed bpchar(1) NULL, -- 是否已在柜台做过风险评估
	inputuser varchar(20) NULL, -- 录入柜员
	cust_name varchar(128) NULL, -- 客户名称
	sub_branch_code varchar(20) NULL, -- 网点代码
	risk_channeled varchar(32) NULL, -- 已评估渠道
	ryzd varchar(1) NULL -- 冗余字段
);
COMMENT ON TABLE crmdm.fms_t4_cust_risk_assess_info IS '客户风险承受能力评估信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.host_cust_no IS '主机客户号';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_risk_level IS '风险承受等级';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.assess_date IS '评估日期';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.trans_serno IS '风险评估交易流水号';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.invalid_date IS '失效日期';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.publish_code IS '管理人代码';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.print_no IS '打印次数';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.counter_assed IS '是否已在柜台做过风险评估';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.sub_branch_code IS '网点代码';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.risk_channeled IS '已评估渠道';
COMMENT ON COLUMN crmdm.fms_t4_cust_risk_assess_info.ryzd IS '冗余字段';


-- crmdm.fms_t5_cust_trans_log 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_cust_trans_log;

CREATE TABLE crmdm.fms_t5_cust_trans_log (
	trans_serno varchar(32) NOT NULL, -- 交易流水号
	sys_mbt varchar(6) NULL, -- 交易编码
	busi_code varchar(6) NOT NULL, -- 业务代码
	channel_flag varchar(3) NOT NULL, -- 渠道标识
	channel_date bpchar(8) NULL, -- 渠道日期
	channel_time bpchar(6) NULL, -- 渠道时间
	channel_serno varchar(32) NULL, -- 渠道流水号
	macdate bpchar(8) NOT NULL, -- 机器日期
	mactime bpchar(6) NOT NULL, -- 机器时间
	bank_code varchar(20) NOT NULL, -- 交易总行代码
	branch_code varchar(20) NOT NULL, -- 交易分行代码
	sub_branch_code varchar(20) NOT NULL, -- 支行网点代码
	inputuser varchar(20) NOT NULL, -- 录入柜员
	checkuser varchar(20) NULL, -- 复核用户
	grantuser varchar(20) NULL, -- 授权用户
	distributor_code varchar(14) NULL, -- 销售商代码
	acct_no varchar(32) NULL, -- 银行账号
	sub_acct_no varchar(32) NULL, -- 子银行账号
	match_acct_no varchar(32) NULL, -- 对手银行账号
	cust_no varchar(20) NULL, -- 客户号
	fnc_trans_acct_no varchar(17) NULL, -- 理财交易账号
	self_fnc_acct_no varchar(12) NULL, -- 自有理财业务账号
	cust_name varchar(128) NULL, -- 客户名称
	id_type varchar(8) NULL, -- 证件类型
	id_code varchar(32) NULL, -- 证件号码
	host_id_type varchar(8) NULL, -- 主机证件类型;（;0：身份证 1：护照 2：军官证 3：士兵证 4：回乡证 5：户口本 6：外国护照 7：其它 8：无 A：技术监督局代码 B：营业执照 C：行政机关 D：社会团体 E；军队 F：武警 G：下属机构（具有主管单位批文号） H：基金会 ）
	cust_type varchar(8) NULL, -- 客户类型
	cust_level varchar(8) NULL, -- 客户级别
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(8) NULL, -- 经办(代理)人证件类型
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	risk_match_flag varchar(1) NULL, -- 是否匹配风险评估;（;Y：是 N：否 ）
	cust_risk_level varchar(1) NULL, -- 客户风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）
	prod_risk_level varchar(1) NULL, -- 产品风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）
	prod_code varchar(32) NOT NULL, -- 产品代码
	prod_child_no numeric(8) NULL, -- 产品子序号;（新建产品信息一律填0;滚存型自动增加）
	nav numeric(12, 6) NULL, -- 净值
	cur varchar(8) NULL, -- 币种
	app_amt numeric(16, 2) NULL, -- 申请金额
	app_vol numeric(16, 2) NULL, -- 申请份额
	ack_amt numeric(16, 2) NULL, -- 确认金额
	ack_vol numeric(16, 2) NULL, -- 确认份额
	discount numeric(7, 4) NULL, -- 折扣率
	feeamt numeric(16, 2) NULL, -- 手续费金额
	back_fee numeric(16, 2) NULL, -- 后收手续费
	redeem_fee numeric(16, 2) NULL, -- 赎回费
	interest numeric(16, 2) NULL, -- 利息
	interest_tax numeric(16, 2) NULL, -- 利息税;(扣款模式下由本系统计息时使用)
	cust_manager varchar(20) NULL, -- 客户经理代码
	fm_manager varchar(20) NULL, -- 理财经理代码
	ori_trans_serno varchar(32) NULL, -- 原交易流水号
	frozen_cause varchar(1) NULL, -- 冻结原因;（0：司法冻结1：质押）
	contract_no varchar(32) NULL, -- 文案号
	elisor_name varchar(128) NULL, -- 司法名称
	frozen_enddate bpchar(8) NULL, -- 冻结截止日期
	ori_div_method varchar(1) NULL, -- 原分红方式
	div_method varchar(1) NULL, -- 分红方式
	haeres_deposit_acct varchar(32) NULL, -- 承接方银行结算账号
	buyplan_no varchar(16) NULL, -- 自动理财协议号
	should_exec_date bpchar(8) NULL, -- 应执行日期
	ack_date bpchar(8) NULL, -- 确认日期
	trans_date bpchar(8) NOT NULL, -- 业务日期
	capital_status varchar(1) NOT NULL, -- 资金状态;（0、未处理1、已冻结2、冻结失败3、扣款成功4、扣款失败5、已冲正6、还款成功7、还款失败8、已解冻9、解冻失败A、冲正失败）
	trans_status varchar(1) NOT NULL, -- 交易状态;（U-未处理;B-核心超时;0-申请成功;1-申请失败;2-已撤单;3-确认成功;4-确认失败）
	rtn_code varchar(12) NULL, -- 返回编码
	rtn_desc varchar(255) NULL, -- 返回信息
	host_code varchar(12) NULL, -- 主机返回码
	host_desc varchar(255) NULL, -- 主机返回信息
	host_trans_serno varchar(32) NULL, -- 主机流水号
	freeze_serno varchar(32) NULL, -- 冻结编号（主机）
	chk_status varchar(1) NOT NULL, -- 对账状态;(0-未对账；1-对账相符；2-对账不符；3-已调账；N-不需要对账)
	chk_date bpchar(8) NULL, -- 对账日期
	cert_serno bpchar(8) NULL, -- 凭证序号
	print_no numeric(8) NOT NULL, -- 打印次数;（0表示未打印）
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	card_type varchar(8) NULL, -- 介质类型
	card_no varchar(32) NULL, -- 介质号码
	in_card_type varchar(8) NULL, -- 转入方介质类型
	in_card_no varchar(32) NULL, -- 转入方介质号
	in_acct_no varchar(32) NULL, -- 转入方账号
	in_agent_name varchar(128) NULL, -- 转入方经办人名称
	in_agent_id_type varchar(8) NULL, -- 转入方经办人证件类型
	in_agent_id_code varchar(32) NULL, -- 转入方经办人证件号码
	in_cust_name varchar(128) NULL, -- 转入方客户名称
	in_id_type varchar(8) NULL, -- 输入方证件类型
	in_id_code varchar(32) NULL, -- 输入方证件号码
	trans_deal_ip varchar(128) NULL, -- 交易处理ip
	channel_ip varchar(128) NULL, -- 渠道IP
	channel_mac varchar(64) NULL, -- 渠道mac
	new_cust_flag varchar(1) NULL, -- 新客标识;（0：新客;1：老客）
	recomm_ppl varchar(15) NULL, -- 直销推荐人
	special_code varchar(8) NULL, -- 尊享码标识;（0..无;1..尊享码客户）
	fund_mode varchar(1) NULL, -- 资金处理模式
	hugeredeemflag varchar(1) NULL, -- 巨额赎回处理标志;:0-取消;1-顺延
	host_date bpchar(8) NULL, -- 主机交易日期
	busi_type varchar(1) NULL, -- 业务类型;:0-还款;1-扣款;2-冻结;3-解冻;4-解冻并扣款;5-冲正
	backup_date bpchar(8) NULL, -- 备份日期
	income numeric(16, 2) NULL, -- 收益
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_cust_trans_log PRIMARY KEY (trans_serno)
);
CREATE INDEX fms_t5_cust_trans_log_idx01 ON crmdm.fms_t5_cust_trans_log USING btree (cust_no);
CREATE INDEX fms_t5_cust_trans_log_idx02 ON crmdm.fms_t5_cust_trans_log USING btree (macdate);
CREATE INDEX fms_t5_cust_trans_log_idx03 ON crmdm.fms_t5_cust_trans_log USING btree (prod_code);
COMMENT ON TABLE crmdm.fms_t5_cust_trans_log IS '客户交易流水表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_serno IS '交易流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.sys_mbt IS '交易编码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.busi_code IS '业务代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_flag IS '渠道标识';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_serno IS '渠道流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.macdate IS '机器日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.mactime IS '机器时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.bank_code IS '交易总行代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.branch_code IS '交易分行代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.sub_branch_code IS '支行网点代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.inputuser IS '录入柜员';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.checkuser IS '复核用户';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.grantuser IS '授权用户';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.distributor_code IS '销售商代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.sub_acct_no IS '子银行账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.match_acct_no IS '对手银行账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.self_fnc_acct_no IS '自有理财业务账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.id_code IS '证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_id_type IS '主机证件类型;（;0：身份证 1：护照 2：军官证 3：士兵证 4：回乡证 5：户口本 6：外国护照 7：其它 8：无 A：技术监督局代码 B：营业执照 C：行政机关 D：社会团体 E；军队 F：武警 G：下属机构（具有主管单位批文号） H：基金会 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_level IS '客户级别';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.agent_id_type IS '经办(代理)人证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.risk_match_flag IS '是否匹配风险评估;（;Y：是 N：否 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_risk_level IS '客户风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.prod_risk_level IS '产品风险等级;（;0：极低 1：低 2：中 3：高 4：极高 ）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.prod_child_no IS '产品子序号;（新建产品信息一律填0;滚存型自动增加）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cur IS '币种';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.app_amt IS '申请金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.app_vol IS '申请份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ack_amt IS '确认金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ack_vol IS '确认份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.discount IS '折扣率';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.feeamt IS '手续费金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.back_fee IS '后收手续费';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.redeem_fee IS '赎回费';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.interest IS '利息';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.interest_tax IS '利息税;(扣款模式下由本系统计息时使用)';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.fm_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ori_trans_serno IS '原交易流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.frozen_cause IS '冻结原因;（0：司法冻结1：质押）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.contract_no IS '文案号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.elisor_name IS '司法名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.frozen_enddate IS '冻结截止日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ori_div_method IS '原分红方式';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.div_method IS '分红方式';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.haeres_deposit_acct IS '承接方银行结算账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.buyplan_no IS '自动理财协议号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.should_exec_date IS '应执行日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.ack_date IS '确认日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_date IS '业务日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.capital_status IS '资金状态;（0、未处理1、已冻结2、冻结失败3、扣款成功4、扣款失败5、已冲正6、还款成功7、还款失败8、已解冻9、解冻失败A、冲正失败）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_status IS '交易状态;（U-未处理;B-核心超时;0-申请成功;1-申请失败;2-已撤单;3-确认成功;4-确认失败）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.rtn_code IS '返回编码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.rtn_desc IS '返回信息';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_code IS '主机返回码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_desc IS '主机返回信息';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_trans_serno IS '主机流水号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.freeze_serno IS '冻结编号（主机）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.chk_status IS '对账状态;(0-未对账；1-对账相符；2-对账不符；3-已调账；N-不需要对账)';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.chk_date IS '对账日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.cert_serno IS '凭证序号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.print_no IS '打印次数;（0表示未打印）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.card_type IS '介质类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.card_no IS '介质号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_card_type IS '转入方介质类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_card_no IS '转入方介质号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_acct_no IS '转入方账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_agent_name IS '转入方经办人名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_agent_id_type IS '转入方经办人证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_agent_id_code IS '转入方经办人证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_cust_name IS '转入方客户名称';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_id_type IS '输入方证件类型';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.in_id_code IS '输入方证件号码';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.trans_deal_ip IS '交易处理ip';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_ip IS '渠道IP';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.channel_mac IS '渠道mac';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.new_cust_flag IS '新客标识;（0：新客;1：老客）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.recomm_ppl IS '直销推荐人';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.special_code IS '尊享码标识;（0..无;1..尊享码客户）';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.fund_mode IS '资金处理模式';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.hugeredeemflag IS '巨额赎回处理标志;:0-取消;1-顺延';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.host_date IS '主机交易日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.busi_type IS '业务类型;:0-还款;1-扣款;2-冻结;3-解冻;4-解冻并扣款;5-冲正';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.backup_date IS '备份日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_trans_log.income IS '收益';


-- crmdm.fms_t5_cust_vol 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_cust_vol;

CREATE TABLE crmdm.fms_t5_cust_vol (
	cust_no varchar(20) NOT NULL, -- 客户号
	fnc_trans_acct_no varchar(17) NOT NULL, -- 理财交易账号
	prod_code varchar(32) NOT NULL, -- 产品代码
	distributor_code varchar(14) DEFAULT '0 '::varchar NOT NULL, -- 销售商代码（本行销售填0）
	self_fnc_acct_no bpchar(12) NULL, -- 自有理财业务账号;老理财系统保留
	total_vol numeric(16, 2) NOT NULL, -- 总份额
	buy_amt numeric(16, 2) NOT NULL, -- 购买金额
	trans_frozen_vol numeric(16, 2) NULL, -- 赎回冻结
	abnm_frozen_vol numeric(16, 2) NULL, -- 异常冻结份额
	redeem_amt numeric(16, 2) NOT NULL, -- 累计赎回金额
	unconvert_income numeric(20, 6) NULL, -- 未结转收益
	convert_income numeric(20, 6) NOT NULL, -- 已结转收益;累计值
	crt_date bpchar(8) NOT NULL, -- 创建日期
	crt_time bpchar(6) NOT NULL, -- 创建时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NOT NULL, -- 更新日期
	upd_time bpchar(6) NOT NULL, -- 更新时间
	cust_manager varchar(20) NULL, -- 客户经理代码
	fm_manager varchar(20) NULL, -- 理财经理代码
	last_vol_change_date bpchar(8) NOT NULL, -- 份额最后变动日
	elisor_frozen_vol numeric(16, 2) NULL, -- 司法冻结份额
	frozen_vol numeric(16, 2) NULL, -- 质押冻结份额
	acc_income numeric(16, 2) NULL, -- 累计收益
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_cust_vol PRIMARY KEY (cust_no, fnc_trans_acct_no, prod_code, distributor_code)
);
CREATE INDEX fms_t5_cust_vol_idx01 ON crmdm.fms_t5_cust_vol USING btree (fnc_trans_acct_no, prod_code);
COMMENT ON TABLE crmdm.fms_t5_cust_vol IS '客户份额汇总表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_cust_vol.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.distributor_code IS '销售商代码（本行销售填0）';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.self_fnc_acct_no IS '自有理财业务账号;老理财系统保留';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.total_vol IS '总份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.buy_amt IS '购买金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.trans_frozen_vol IS '赎回冻结';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.abnm_frozen_vol IS '异常冻结份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.redeem_amt IS '累计赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.unconvert_income IS '未结转收益';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.convert_income IS '已结转收益;累计值';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.fm_manager IS '理财经理代码';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.last_vol_change_date IS '份额最后变动日';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.elisor_frozen_vol IS '司法冻结份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.frozen_vol IS '质押冻结份额';
COMMENT ON COLUMN crmdm.fms_t5_cust_vol.acc_income IS '累计收益';


-- crmdm.fms_t5_prod_comp_limit 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_comp_limit;

CREATE TABLE crmdm.fms_t5_prod_comp_limit (
	prod_code varchar(32) NOT NULL, -- 产品代码
	max_person_no numeric(8) NULL, -- 人数上限
	curr_person_no numeric(8) NULL, -- 当前人数
	min_size numeric(16, 2) NULL, -- 发行规模下限
	cust_max_booking numeric(16, 2) NULL, -- 单客户自助渠道预约上限;-1为不限
	min_subs_p numeric(16, 2) NULL, -- 个人购买起点;必填
	max_subs_p numeric(16, 2) NULL, -- 个人购买最高;-1为不限
	step_subs_p numeric(16, 2) NULL, -- 个人购买递增;必填
	min_subs_m numeric(16, 2) NULL, -- 公司购买起点;必填
	max_subs_m numeric(16, 2) NULL, -- 公司购买最高;-1为不限
	step_subs_m numeric(16, 2) NULL, -- 公司购买递增;必填
	min_pchs_p numeric(16, 2) NULL, -- 单笔申购起点金额（个人）
	max_pchs_p numeric(16, 2) NULL, -- 单笔申购最高金额（个人）
	step_pchs_p numeric(16, 2) NULL, -- 单笔申购递增金额（个人）追加时为最低金额
	min_pchs_m numeric(16, 2) NULL, -- 单笔申购起点金额（机构）
	max_pchs_m numeric(16, 2) NULL, -- 单笔申购最高金额（机构）
	step_pchs_m numeric(16, 2) NULL, -- 单笔申购递增金额（机构）追加时为最低金额
	min_hold_p numeric(16, 2) NULL, -- 个人最低持有;必填
	min_redeem_p numeric(16, 2) NULL, -- 个人单笔最低赎回额;-1为不限
	min_hold_m numeric(16, 2) NULL, -- 公司最低持有;必填
	min_redeem_m numeric(16, 2) NULL, -- 公司最低赎回额;：-1为不限
	redeem_ratio numeric(7, 2) NULL, -- 巨额赎回比例;-1为不限
	min_pchs_fixed numeric(16, 2) NULL, -- 定投申购最低限额
	max_buy_p numeric(16, 2) NULL, -- 累积购买金额上限（个人）
	max_buy_m numeric(16, 2) NULL, -- 累积购买金额上限（机构）
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	remark varchar(255) NULL, -- 备注
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	min_hold_days numeric(8) NULL, -- 最低持有天数
	p_redeem_ratio numeric(7, 4) NULL, -- 单客户最高赎回比例
	p_redeem_amt numeric(16, 2) NULL, -- 单客户最高赎回金额
	ncount_max_buy numeric(16, 2) NULL, -- 非柜台购买上限
	ncount_cancel_flag bpchar(1) NULL, -- 购买是否可在非柜台撤单;（1-可以；0-不可以）
	ncount_booking_flag bpchar(1) NULL, -- 非柜台是否可预约;（1-可以；0-不可以）
	min_append_m numeric(16, 2) NULL, -- 机构追加起点
	min_append_p numeric(16, 2) NULL, -- 个人追加起点
	step_redeem_p numeric(16, 2) NULL, -- 个人赎回递增;-1为不限
	max_daily_subs_p numeric(16, 2) NULL, -- 个人单日累计购买上限;-1为不限
	max_daily_redeem_p numeric(16, 2) NULL, -- 个人单日累计赎回上限;-1为不限
	step_redeem_m numeric(16, 2) NULL, -- 公司赎回递增;-1为不限
	max_daily_subs_m numeric(16, 2) NULL, -- 公司单日累计购买上限;-1为不限
	max_daily_redeem_m numeric(16, 2) NULL, -- 机构单日累计赎回上限;-1为不限
	redeem_amt numeric(16, 2) NULL, -- 巨额赎回金额;根据上日产品规模和巨额赎回比例计算出来的当前工作日可赎回金额
	apply_ratio numeric(7, 2) NULL, -- 巨额申购比例;-1为不限
	apply_amt numeric(16, 2) NULL, -- 巨额申购金额;根据上日产品规模和巨额申购比例计算出来的当前工作日可申购金额
	three_days_redeem numeric(7, 2) NULL, -- 近3日累计赎回比例;-1为不限
	three_days_redeem_amt numeric(16, 2) NULL, -- 近3日累计巨额赎回金额
	max_hold_peoples numeric(16) NULL, -- 最高持有人数:;-1为不限
	min_hold_peoples numeric(16) NULL, -- 最低持有人数:;-1为不限
	max_daily_subs_amt numeric(16, 2) NULL, -- 产品单日累计购买上限:;-1为不限
	max_daily_redeem_amt numeric(16, 2) NULL, -- 产品单日累计赎回上限:;-1为不限
	low_asset_jud_type bpchar(1) NULL, -- 资产过低判断类型;(0-份额;1-金额)
	min_asset_limit numeric(16, 2) NULL, -- 最低资产限额:;-1为不限
	max_hold_amt numeric(16, 2) NULL, -- 单客户最高持有金额:;-1为不限
	max_hold_ratio numeric(7, 2) NULL, -- 单客户最高持有比例;-1为不限
	max_total_subs_p numeric(16, 2) NULL, -- 个人累计购买金额上限
	max_total_subs_m numeric(16, 2) NULL, -- 机构累计购买金额上限
	max_hold_p numeric(16, 2) NULL, -- 个人最高持有份额
	max_hold_m numeric(16, 2) NULL, -- 机构最高持有份额
	max_age numeric NULL, -- 年龄段最大值;-1为不限
	min_age numeric NULL, -- 年龄段最小值;-1为不限
	ncounter_max_booking numeric(16, 2) NULL, -- 单客户自助渠道预约上限;-1为不限
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_comp_limit PRIMARY KEY (prod_code)
);
COMMENT ON TABLE crmdm.fms_t5_prod_comp_limit IS '产品组件-产品限制信息';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_person_no IS '人数上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.curr_person_no IS '当前人数';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_size IS '发行规模下限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.cust_max_booking IS '单客户自助渠道预约上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_subs_p IS '个人购买起点;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_subs_p IS '个人购买最高;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_subs_p IS '个人购买递增;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_subs_m IS '公司购买起点;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_subs_m IS '公司购买最高;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_subs_m IS '公司购买递增;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_pchs_p IS '单笔申购起点金额（个人）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_pchs_p IS '单笔申购最高金额（个人）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_pchs_p IS '单笔申购递增金额（个人）追加时为最低金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_pchs_m IS '单笔申购起点金额（机构）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_pchs_m IS '单笔申购最高金额（机构）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_pchs_m IS '单笔申购递增金额（机构）追加时为最低金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_p IS '个人最低持有;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_redeem_p IS '个人单笔最低赎回额;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_m IS '公司最低持有;必填';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_redeem_m IS '公司最低赎回额;：-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.redeem_ratio IS '巨额赎回比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_pchs_fixed IS '定投申购最低限额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_buy_p IS '累积购买金额上限（个人）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_buy_m IS '累积购买金额上限（机构）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_days IS '最低持有天数';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.p_redeem_ratio IS '单客户最高赎回比例';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.p_redeem_amt IS '单客户最高赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncount_max_buy IS '非柜台购买上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncount_cancel_flag IS '购买是否可在非柜台撤单;（1-可以；0-不可以）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncount_booking_flag IS '非柜台是否可预约;（1-可以；0-不可以）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_append_m IS '机构追加起点';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_append_p IS '个人追加起点';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_redeem_p IS '个人赎回递增;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_subs_p IS '个人单日累计购买上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_redeem_p IS '个人单日累计赎回上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.step_redeem_m IS '公司赎回递增;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_subs_m IS '公司单日累计购买上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_redeem_m IS '机构单日累计赎回上限;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.redeem_amt IS '巨额赎回金额;根据上日产品规模和巨额赎回比例计算出来的当前工作日可赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.apply_ratio IS '巨额申购比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.apply_amt IS '巨额申购金额;根据上日产品规模和巨额申购比例计算出来的当前工作日可申购金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.three_days_redeem IS '近3日累计赎回比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.three_days_redeem_amt IS '近3日累计巨额赎回金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_peoples IS '最高持有人数:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_hold_peoples IS '最低持有人数:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_subs_amt IS '产品单日累计购买上限:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_daily_redeem_amt IS '产品单日累计赎回上限:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.low_asset_jud_type IS '资产过低判断类型;(0-份额;1-金额)';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_asset_limit IS '最低资产限额:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_amt IS '单客户最高持有金额:;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_ratio IS '单客户最高持有比例;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_total_subs_p IS '个人累计购买金额上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_total_subs_m IS '机构累计购买金额上限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_p IS '个人最高持有份额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_hold_m IS '机构最高持有份额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.max_age IS '年龄段最大值;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.min_age IS '年龄段最小值;-1为不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_limit.ncounter_max_booking IS '单客户自助渠道预约上限;-1为不限';


-- crmdm.fms_t5_prod_comp_profit_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_comp_profit_nav;

CREATE TABLE crmdm.fms_t5_prod_comp_profit_nav (
	prod_code varchar(32) NOT NULL, -- 产品代码
	benchmarks numeric(7, 4) NULL, -- 业绩比较基准
	float_manage_rate numeric(7, 4) NULL, -- 浮动管理费率
	windup_type bpchar(1) NULL, -- 清盘方式;（0-净值清盘;1-总金额清盘）
	windup_amt numeric(16, 2) NULL, -- 清盘总金额
	div_delivery_days numeric NULL, -- 分红交收天数
	div_chg_flag bpchar(1) NULL, -- 分红方式是否可修改;（0-否1-是）
	def_div_method bpchar(1) DEFAULT '1'::bpchar NULL, -- 默认分红方式;（0-红利再投1-现金分红）
	pay_nav_day numeric NULL, -- 兑付净值取值日
	min_benchmarks numeric(7, 4) NULL, -- 最小业绩比较基准
	max_benchmarks numeric(7, 4) NULL, -- 最大业绩比较基准
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_comp_profit_nav PRIMARY KEY (prod_code)
);
COMMENT ON TABLE crmdm.fms_t5_prod_comp_profit_nav IS '产品净值组件信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.benchmarks IS '业绩比较基准';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.float_manage_rate IS '浮动管理费率';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.windup_type IS '清盘方式;（0-净值清盘;1-总金额清盘）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.windup_amt IS '清盘总金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.div_delivery_days IS '分红交收天数';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.div_chg_flag IS '分红方式是否可修改;（0-否1-是）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.def_div_method IS '默认分红方式;（0-红利再投1-现金分红）';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.pay_nav_day IS '兑付净值取值日';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.min_benchmarks IS '最小业绩比较基准';
COMMENT ON COLUMN crmdm.fms_t5_prod_comp_profit_nav.max_benchmarks IS '最大业绩比较基准';


-- crmdm.fms_t5_prod_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_info;

CREATE TABLE crmdm.fms_t5_prod_info (
	prod_code varchar(32) NOT NULL, -- 产品代码
	prod_name varchar(256) NOT NULL, -- 产品名称
	prod_name_short varchar(68) NULL, -- 产品简称
	parent_prod_code varchar(32) NULL, -- 父产品代码
	prod_type bpchar(1) NULL, -- 产品类型;(0-自营，;1-代销，2-分销，3-自营+分销)
	prod_mode bpchar(2) NOT NULL, -- 产品模式;(1-产品模式一;2-产品模式二)
	period_type bpchar(1) NOT NULL, -- 周期类型;; 0-开放型；1-封闭型 2-周期型 3-净值归一
	prod_cur varchar(3) NOT NULL, -- 产品币种;（01-人民币；02-港元；03-美元）
	prod_risk_level bpchar(1) NOT NULL, -- 风险等级;（01-极低；02-低；03-中；04-高；05-极高）
	orgno varchar(10) NOT NULL, -- 发行机构
	legal_code varchar(32) NULL, -- 法人代码;多法人模式下的发行机构的法人代码
	def_div_method bpchar(1) NULL, -- 默认分红方式;：0-红利再投；1-现金分红（目前只能使用现金）
	div_chg_flag bpchar(1) NULL, -- 分红方式是否可修改;：0-不可;1-可，默认不可修改
	min_div_amt numeric(16, 2) NULL, -- 最小现金分红
	max_size numeric(16, 2) NULL, -- 规模上限;产品总额度
	min_size numeric(16, 2) NULL, -- 规模下限;最低规模条件;如果赎回导致底于下限则拒绝赎回
	hold_quota numeric(16, 2) NULL, -- 保留额度
	quota_dime varchar(20) NULL, -- 额度维度;(1-客户类型、2-客户级别、;3-机构、 4-渠道、5-金额),多维组合如 "123"
	sale_status bpchar(1) NOT NULL, -- 销售状态;0-不可;1-可销售
	can_booking bpchar(1) NULL, -- 是否可预留额度;0-否;1-是
	can_order bpchar(1) NULL, -- 是否可预约认购;0-否;1-是
	can_subs bpchar(1) NULL, -- 是否可认购;0-否;1-是
	can_apply bpchar(1) NULL, -- 是否可申购;0-否;1-是
	can_redeem bpchar(1) NULL, -- 是否可赎回;0-否;1-是
	can_frozen bpchar(1) NOT NULL, -- 是否可质押;0-否;1-是
	start_buy_time bpchar(6) NULL, -- 允许购买开始时间;：9999为不限如果不限;则结束时间也必须不限
	end_buy_time bpchar(6) NULL, -- 允许购买结束时间;：9999为不限如果不限;则开始时间也必须不限
	publish_code varchar(10) NOT NULL, -- 管理人代码;代销产品使用;非代销产品填‘0’
	income_characteristic bpchar(1) NOT NULL, -- 收益特点
	prod_lifecycle bpchar(1) NOT NULL, -- 产品状态;（0：设计1：发行前2：发行3：发行失败4：成立5：封闭6：开放7：清盘8：终止）
	regist_code varchar(32) NULL, -- 中登编号（中债登记编号）
	pay_check_acct_no varchar(32) NULL, -- 还款检查余额账号
	cust_type varchar(16) NULL, -- 客户类型;：0-同业；1-个人；2-机构
	subs_capital_model bpchar(1) NULL, -- 认购资金处理模式;：0-冻结；1-扣款;-1-不限
	subs_income_deal_type bpchar(1) NULL, -- 认购利息处理方式
	series_code varchar(32) NULL, -- 系列代码
	series_num numeric NULL, -- 期数
	profit_type bpchar(1) NOT NULL, -- 计价类型;（0-净值；1-收益）
	nav numeric(12, 6) NULL, -- 净值
	nav_date bpchar(8) NULL, -- 净值日期
	auto_winding_flag bpchar(1) NULL, -- 清盘日是否到期自动清盘;（1-是;0-否）
	rasie_type bpchar(1) NULL, -- 募集类型;（0-公募;1-私募）
	subs_quota numeric(16, 2) NULL, -- 认购额度
	apply_quota numeric(16, 2) NULL, -- 申购额度
	redeem_quota numeric(16, 2) NULL, -- 赎回额度
	recover_apply_quota bpchar(1) NULL, -- 恢复申购额度方式;（0-自动恢复1-手工恢复）
	recover_redeem_quota bpchar(1) NULL, -- 恢复赎回额度方式;（0-自动恢复1-手工恢复）
	cust_group bpchar(1) NULL, -- 客户组别
	prod_quota numeric(16, 2) NULL, -- 产品额度
	subs_redeem_flag bpchar(1) NULL, -- 认购可撤单标识;（0-否1-是）
	winding_pay_date bpchar(8) NULL, -- 到期实际兑付日期
	winding_pay_days varchar(32) NULL, -- 到期兑付交收天数
	specification_status bpchar(1) NULL, -- 说明书状态
	protocol_status bpchar(1) NULL, -- 协议说明书状态
	rasie_quota numeric(16, 2) NULL, -- 募集额度
	money_pay_day varchar(1) NULL, -- 资金兑付标准日
	has_waver_period bpchar(1) NULL, -- 是否有冷静期
	prod_comp_type varchar(1) NULL, -- 产品组合类型
	update_prod_date varchar(8) NULL, -- 产品信息更新日期
	update_prod_time varchar(6) NULL, -- 产品信息更新时间
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_t5_prod_info IS '产品信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_name IS '产品名称';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_name_short IS '产品简称';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.parent_prod_code IS '父产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_type IS '产品类型;(0-自营，;1-代销，2-分销，3-自营+分销)';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_mode IS '产品模式;(1-产品模式一;2-产品模式二)';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.period_type IS '周期类型;; 0-开放型；1-封闭型 2-周期型 3-净值归一';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_cur IS '产品币种;（01-人民币；02-港元；03-美元）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_risk_level IS '风险等级;（01-极低；02-低；03-中；04-高；05-极高）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.orgno IS '发行机构';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.legal_code IS '法人代码;多法人模式下的发行机构的法人代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.def_div_method IS '默认分红方式;：0-红利再投；1-现金分红（目前只能使用现金）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.div_chg_flag IS '分红方式是否可修改;：0-不可;1-可，默认不可修改';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.min_div_amt IS '最小现金分红';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.max_size IS '规模上限;产品总额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.min_size IS '规模下限;最低规模条件;如果赎回导致底于下限则拒绝赎回';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.hold_quota IS '保留额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.quota_dime IS '额度维度;(1-客户类型、2-客户级别、;3-机构、 4-渠道、5-金额),多维组合如 "123"';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.sale_status IS '销售状态;0-不可;1-可销售';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_booking IS '是否可预留额度;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_order IS '是否可预约认购;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_subs IS '是否可认购;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_apply IS '是否可申购;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_redeem IS '是否可赎回;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.can_frozen IS '是否可质押;0-否;1-是';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.start_buy_time IS '允许购买开始时间;：9999为不限如果不限;则结束时间也必须不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.end_buy_time IS '允许购买结束时间;：9999为不限如果不限;则开始时间也必须不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.publish_code IS '管理人代码;代销产品使用;非代销产品填‘0’';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.income_characteristic IS '收益特点';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_lifecycle IS '产品状态;（0：设计1：发行前2：发行3：发行失败4：成立5：封闭6：开放7：清盘8：终止）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.regist_code IS '中登编号（中债登记编号）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.pay_check_acct_no IS '还款检查余额账号';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.cust_type IS '客户类型;：0-同业；1-个人；2-机构';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_capital_model IS '认购资金处理模式;：0-冻结；1-扣款;-1-不限';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_income_deal_type IS '认购利息处理方式';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.series_code IS '系列代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.series_num IS '期数';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.profit_type IS '计价类型;（0-净值；1-收益）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.auto_winding_flag IS '清盘日是否到期自动清盘;（1-是;0-否）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.rasie_type IS '募集类型;（0-公募;1-私募）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_quota IS '认购额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.apply_quota IS '申购额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.redeem_quota IS '赎回额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.recover_apply_quota IS '恢复申购额度方式;（0-自动恢复1-手工恢复）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.recover_redeem_quota IS '恢复赎回额度方式;（0-自动恢复1-手工恢复）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.cust_group IS '客户组别';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_quota IS '产品额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.subs_redeem_flag IS '认购可撤单标识;（0-否1-是）';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.winding_pay_date IS '到期实际兑付日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.winding_pay_days IS '到期兑付交收天数';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.specification_status IS '说明书状态';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.protocol_status IS '协议说明书状态';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.rasie_quota IS '募集额度';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.money_pay_day IS '资金兑付标准日';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.has_waver_period IS '是否有冷静期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.prod_comp_type IS '产品组合类型';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.update_prod_date IS '产品信息更新日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_info.update_prod_time IS '产品信息更新时间';


-- crmdm.fms_t5_prod_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_nav;

CREATE TABLE crmdm.fms_t5_prod_nav (
	prod_code varchar(32) NOT NULL, -- 产品代码
	nav_date bpchar(8) NOT NULL, -- 净值日期
	nav numeric(12, 6) NOT NULL, -- 单位净值
	total_nav numeric(12, 6) NULL, -- 累计净值
	seven_days_income numeric(7, 4) NULL, -- 7日年化收益率
	ten_thousand_income_amt numeric(7, 4) NULL, -- 万份收益
	expire_cash_amt numeric(16, 2) NULL, -- 到期总金额
	remark varchar(255) NULL, -- 备注
	crt_date bpchar(8) NULL, -- 创建日期
	crt_time bpchar(6) NULL, -- 创建时间
	upd_date bpchar(8) NULL, -- 更新日期
	upd_time bpchar(6) NULL, -- 更新时间
	income_status bpchar(1) NULL, -- 收益状态;（0未处理，1;处理中，2 已分配）
	total_income_amt numeric(16, 4) NULL, -- 收益总额
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_t5_prod_nav IS '产品净值信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_nav.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.nav IS '单位净值';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.total_nav IS '累计净值';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.seven_days_income IS '7日年化收益率';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.ten_thousand_income_amt IS '万份收益';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.expire_cash_amt IS '到期总金额';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.crt_date IS '创建日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.crt_time IS '创建时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.income_status IS '收益状态;（0未处理，1;处理中，2 已分配）';
COMMENT ON COLUMN crmdm.fms_t5_prod_nav.total_income_amt IS '收益总额';


-- crmdm.fms_t5_prod_period 定义

-- Drop table

-- DROP TABLE crmdm.fms_t5_prod_period;

CREATE TABLE crmdm.fms_t5_prod_period (
	prod_code varchar(32) NOT NULL, -- 产品代码
	booking_begin_date bpchar(8) NULL, -- 预留开始日
	booking_invalid_date bpchar(8) NULL, -- 预留失效日
	order_begin_date bpchar(8) NULL, -- 预约开始日
	subs_begin_date bpchar(8) NOT NULL, -- 认购开始日
	subs_end_date bpchar(8) NOT NULL, -- 认购结束日
	value_date bpchar(8) NOT NULL, -- 收益起始日
	establish_date bpchar(8) NOT NULL, -- 成立日;（滚动产品成清算时将该值更新为下一个周期成立日）
	first_establish_date bpchar(8) NOT NULL, -- 首次成立日
	open_begin_date bpchar(8) NULL, -- 开放起始日
	open_end_date bpchar(8) NULL, -- 开放结束日
	winding_date bpchar(8) NOT NULL, -- 到期日;（到期日期滚动产品到期清算时将该值更新）
	next_winding_date bpchar(8) NULL, -- 下一个到期日;（滚动产品到期清算时将该值更新）
	advance_winding_date bpchar(8) NULL, -- 提前到期日;：可以为空有设置的话;清算的时候会在这一天将产品到期，而不需要等到【到期日】
	pay_date bpchar(8) NOT NULL, -- 还款日期
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_t5_prod_period PRIMARY KEY (prod_code, establish_date)
);
COMMENT ON TABLE crmdm.fms_t5_prod_period IS '产品周期信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_t5_prod_period.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.booking_begin_date IS '预留开始日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.booking_invalid_date IS '预留失效日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.order_begin_date IS '预约开始日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.subs_begin_date IS '认购开始日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.subs_end_date IS '认购结束日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.value_date IS '收益起始日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.establish_date IS '成立日;（滚动产品成清算时将该值更新为下一个周期成立日）';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.first_establish_date IS '首次成立日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.open_begin_date IS '开放起始日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.open_end_date IS '开放结束日';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.winding_date IS '到期日;（到期日期滚动产品到期清算时将该值更新）';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.next_winding_date IS '下一个到期日;（滚动产品到期清算时将该值更新）';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.advance_winding_date IS '提前到期日;：可以为空有设置的话;清算的时候会在这一天将产品到期，而不需要等到【到期日】';
COMMENT ON COLUMN crmdm.fms_t5_prod_period.pay_date IS '还款日期';


-- crmdm.fms_td_cust_trans_cfm_log_h 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_trans_cfm_log_h;

CREATE TABLE crmdm.fms_td_cust_trans_cfm_log_h (
	back_date varchar(8) NULL, -- 备份历史表日期
	app_serno varchar(32) NULL, -- 交易申请流水号
	cfm_date varchar(8) NULL, -- 交易确认业务日期
	ccy varchar(3) NULL, -- 币种
	app_amt numeric(32, 2) NULL, -- 交易申请金额
	app_vol numeric(32, 2) NULL, -- 交易申请份额
	cfm_amt numeric(32, 2) NULL, -- 交易确认金额
	cfm_vol numeric(32, 2) NULL, -- 交易确认份额
	tano varchar(16) NULL, -- TA代码
	prod_code varchar(32) NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	lrdm_flag bpchar(1) NULL, -- 巨额赎回标识
	app_date varchar(8) NULL, -- 交易申请业务日期
	fnc_trans_acct_no varchar(24) NULL, -- 理财交易账号
	busi_code varchar(3) NULL, -- 业务代码
	ta_acct_no varchar(32) NULL, -- TA账号
	ta_cfm_serno varchar(32) NULL, -- TA确认流水
	busi_finish_flag bpchar(1) NULL, -- 业务过程完全结束标识
	cmms_disct numeric(8, 5) NULL, -- 销售佣金折扣率
	charge numeric(32, 2) NULL, -- 手续费
	agen_fee numeric(32, 2) NULL, -- 代理费
	nav numeric(16, 8) NULL, -- 净值
	ori_app_serno varchar(32) NULL, -- 交易申请流水号原
	ori_cfm_serno varchar(32) NULL, -- TA的原确认流水号
	fee_rate numeric(17, 2) NULL, -- 费率
	bcfee_amt numeric(32, 2) NULL, -- 交易后端收费总额
	distributor_code varchar(32) NULL, -- 销售人代码
	tag_distributor_code varchar(32) NULL, -- 销售人代码对方
	tag_trans_acct_no varchar(24) NULL, -- 对方理财交易账号
	def_div_method bpchar(1) NULL, -- 默认分红方式
	sbcp_intrst numeric(17, 2) NULL, -- 认购利息金额
	tax numeric(17, 2) NULL, -- 税金
	tagt_prod_code varchar(32) NULL, -- 对方产品代码
	tagt_share_class bpchar(1) NULL, -- 对方产品份额类别
	tagt_nav numeric(16, 8) NULL, -- 对方产品净值
	trans_status bpchar(1) NULL, -- 交易状态
	ta_flag bpchar(1) NULL, -- TA发起业务标识
	frozen_cause bpchar(1) NULL, -- 冻结原因
	frozen_ddl varchar(8) NULL, -- 冻结截止日期
	rdm_rsn varchar(32) NULL, -- 强行赎回原因
	rtn_code varchar(30) NULL, -- 返回码
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	cust_manager varchar(20) NULL, -- 客户经理代码
	windup_frozen_amt numeric(32, 2) NULL, -- 清盘冻结金额
	tag_ta_acct_no varchar(32) NULL, -- 对方理财账号（TA账号）
	rtn_desc varchar(256) NULL, -- 返回信息（成功或出错详细信息）
	ta_app_serno varchar(32) NULL, -- TA记录的申请流水号（确认流水中记录的申请流水号）
	originalcfmamount numeric(16, 2) NULL, -- 原确认本金
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_cust_trans_cfm_log_h IS '理财客户交易确认流水表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.back_date IS '备份历史表日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_serno IS '交易申请流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cfm_date IS '交易确认业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ccy IS '币种';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_amt IS '交易申请金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_vol IS '交易申请份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cfm_amt IS '交易确认金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cfm_vol IS '交易确认份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.lrdm_flag IS '巨额赎回标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.app_date IS '交易申请业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.busi_code IS '业务代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_acct_no IS 'TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_cfm_serno IS 'TA确认流水';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.busi_finish_flag IS '业务过程完全结束标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cmms_disct IS '销售佣金折扣率';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.charge IS '手续费';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.agen_fee IS '代理费';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ori_app_serno IS '交易申请流水号原';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ori_cfm_serno IS 'TA的原确认流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.fee_rate IS '费率';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.bcfee_amt IS '交易后端收费总额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.distributor_code IS '销售人代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tag_distributor_code IS '销售人代码对方';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tag_trans_acct_no IS '对方理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.def_div_method IS '默认分红方式';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.sbcp_intrst IS '认购利息金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tax IS '税金';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tagt_prod_code IS '对方产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tagt_share_class IS '对方产品份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tagt_nav IS '对方产品净值';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.trans_status IS '交易状态';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_flag IS 'TA发起业务标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.frozen_cause IS '冻结原因';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.frozen_ddl IS '冻结截止日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.rdm_rsn IS '强行赎回原因';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.rtn_code IS '返回码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.windup_frozen_amt IS '清盘冻结金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.tag_ta_acct_no IS '对方理财账号（TA账号）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.rtn_desc IS '返回信息（成功或出错详细信息）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.ta_app_serno IS 'TA记录的申请流水号（确认流水中记录的申请流水号）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_cfm_log_h.originalcfmamount IS '原确认本金';


-- crmdm.fms_td_cust_trans_req_log 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_trans_req_log;

CREATE TABLE crmdm.fms_td_cust_trans_req_log (
	app_serno varchar(32) NOT NULL, -- 交易申请流水号
	busi_code varchar(3) NOT NULL, -- 业务代码
	trans_code varchar(8) NULL, -- 交易代码
	fnc_trans_acct_no varchar(24) NOT NULL, -- 理财交易账号
	tano varchar(16) NOT NULL, -- TA代码
	prod_code varchar(32) NOT NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	cust_no varchar(32) NOT NULL, -- 客户号
	cust_type varchar(3) NOT NULL, -- 客户类型
	ta_acct_no varchar(32) NULL, -- TA账号
	ta_cfm_serno varchar(32) NULL, -- TA确认流水
	card_no varchar(32) NULL, -- 凭证号
	card_type varchar(2) NULL, -- 凭证类型
	acct_no varchar(32) NOT NULL, -- 银行账号
	app_date varchar(8) NOT NULL, -- 交易申请业务日期
	cfm_date varchar(8) NULL, -- 交易确认业务日期
	ccy varchar(3) NULL, -- 币种
	app_amt numeric(32, 2) NULL, -- 交易申请金额
	app_vol numeric(32, 2) NULL, -- 交易申请份额
	cfm_amt numeric(32, 2) NULL, -- 交易确认金额
	cfm_vol numeric(32, 2) NULL, -- 交易确认份额
	charge numeric(32, 2) NULL, -- 手续费
	cmms_disct numeric(8, 5) NULL, -- 销售佣金折扣率
	ta_flag bpchar(1) NULL, -- TA发起业务标识
	lrdm_flag bpchar(1) NULL, -- 巨额赎回标识
	channel varchar(8) NULL, -- 渠道
	channel_serno varchar(32) NULL, -- 渠道流水号
	channel_date varchar(8) NULL, -- 渠道日期
	channel_time varchar(8) NULL, -- 渠道时间
	bank_code varchar(16) NULL, -- 交易总行代码
	branch_code varchar(16) NULL, -- 交易分行代码
	trans_orgno varchar(16) NULL, -- 交易机构
	inputuser varchar(10) NULL, -- 交易柜员
	grantuser varchar(8) NULL, -- 授权柜员
	agent_name varchar(128) NULL, -- 经办(代理)人姓名
	agent_id_type varchar(8) NULL, -- 经办(代理)人证件类型
	agent_id_code varchar(32) NULL, -- 经办(代理)人证件号码
	nav numeric(16, 8) NULL, -- 净值
	nav_date varchar(8) NULL, -- 净值日期
	tag_trans_acct_no varchar(24) NULL, -- 对方理财交易账号
	tag_distributorcode varchar(9) NULL, -- 对方销售人代码
	tag_ta_acct_no varchar(16) NULL, -- 对方TA账号
	tag_prod_code varchar(32) NULL, -- 对方产品代码
	tag_share_class bpchar(1) NULL, -- 对方份额类别
	frozen_cause bpchar(1) NULL, -- 冻结原因
	frozen_ddl varchar(8) NULL, -- 冻结截止日期
	ori_app_serno varchar(32) NULL, -- 交易申请流水号原
	def_div_method bpchar(1) NULL, -- 默认分红方式
	trans_status bpchar(1) NULL, -- 交易状态(U-未处理; B-核心超时; C-TA超时; 0-申请成功; 1-申请失败; 2-已撤单; 3-确认成功; 4-确认失败; D-TA成功核心失败; E-TA失败核心成功;F-挂单成功;G部分确认（确认中）)';
	capital_status varchar(1) NULL -- 资金状态(0-未处理;1-已冻结;2-冻结失败;3-冻结超时;4-已扣款;5-扣款失败;6-扣款超时;7-已解冻;8-解冻失败;9-解冻超时;A-已冲正;B-冲正失败;C-冲正超时;D-已还款;E-还款失败;F-还款超时;H-解冻扣款成功;I-解冻扣款失败;J-解冻扣款失败但解冻成功;),
	capital_type varchar(1) NULL, -- 资金处理类型（0-冻结;1-扣款;2-解冻;3-还款;4-冲正;5-解冻并扣款;）
	rtn_code varchar(30) NULL, -- 返回码
	rtn_desc varchar(512) NULL, -- 返回描述
	mac_date varchar(8) NOT NULL, -- 机器日期
	mac_time varchar(8) NOT NULL, -- 机器时间
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	host_trans_serno varchar(32) NULL, -- 核心流水号
	update_date varchar(8) NULL, -- 更新日期
	update_time varchar(8) NULL, -- 更新时间
	sys_date varchar(8) NULL, -- 系统日期(系统工作日)
	cust_manager varchar(20) NULL, -- 客户经理代码
	ext_sub_branch_code varchar(16) NULL, -- 推广机构
	frozen_no varchar(32) NULL, -- 理财份额冻结编号
	deposit_acct varchar(32) NULL, -- 保证金账户
	cust_risk_level bpchar(1) NULL, -- 客户风险承受等级
	prod_risk_level bpchar(1) NULL, -- 产品风险等级
	tag_acct_no varchar(32) NULL, -- 对方银行账号
	tag_card_no varchar(32) NULL, -- 对方凭证号
	tag_card_type varchar(1) NULL, -- 对方凭证类型
	tag_agent_name varchar(128) NULL, -- 转入方经办人名称
	tag_agent_id_type varchar(8) NULL, -- 转入方经办人证件类型
	tag_agent_id_code varchar(32) NULL, -- 转入方经办人证件号码
	tag_cust_name varchar(128) NULL, -- 转入方客户名称
	tag_id_type varchar(8) NULL, -- 输入方证件类型
	tag_id_code varchar(32) NULL, -- 输入方证件号码
	is_first bpchar(1) NULL, -- 是否首次购买（1-是 0-否）
	ta_batch varchar(16) NULL, -- TA文件批次号（即文件名尾部的001、002，中登2.2接口允许发送多批次文件）
	ta_app_serno varchar(32) NULL, -- TA确认记录的申请流水号（非TA发起交易的交易时应该与app_serno一致）
	ori_ta_cfm_serno varchar(32) NULL, -- 原TA确认编号（032解冻时需要上送031冻结成功的确认流水号）
	src_serno varchar(32) NULL, -- 全局流水号
	print_count varchar(2) NULL, -- 补打次数
	account_date varchar(8) NULL, -- 预计到账日期
	trans_deal_ip varchar(128) NULL, -- 交易处理ip
	channel_ip varchar(128) NULL, -- 渠道IP
	channel_mac varchar(64) NULL, -- 渠道mac
	recomm_ppl varchar(32) NULL, -- 推荐人
	session_id varchar(32) NULL, -- 回溯码
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_cust_trans_req_log IS '理财交易申请流水表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_serno IS '交易申请流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.busi_code IS '业务代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_code IS '交易代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_acct_no IS 'TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_cfm_serno IS 'TA确认流水';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.card_no IS '凭证号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.card_type IS '凭证类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_date IS '交易申请业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cfm_date IS '交易确认业务日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ccy IS '币种';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_amt IS '交易申请金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.app_vol IS '交易申请份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cfm_amt IS '交易确认金额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cfm_vol IS '交易确认份额';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.charge IS '手续费';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cmms_disct IS '销售佣金折扣率';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_flag IS 'TA发起业务标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.lrdm_flag IS '巨额赎回标识';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel IS '渠道';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_serno IS '渠道流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.bank_code IS '交易总行代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.branch_code IS '交易分行代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_orgno IS '交易机构';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.inputuser IS '交易柜员';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.grantuser IS '授权柜员';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.agent_name IS '经办(代理)人姓名';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.agent_id_type IS '经办(代理)人证件类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.agent_id_code IS '经办(代理)人证件号码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.nav IS '净值';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_trans_acct_no IS '对方理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_distributorcode IS '对方销售人代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_ta_acct_no IS '对方TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_prod_code IS '对方产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_share_class IS '对方份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.frozen_cause IS '冻结原因';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.frozen_ddl IS '冻结截止日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ori_app_serno IS '交易申请流水号原';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.def_div_method IS '默认分红方式';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_status IS '交易状态(U-未处理; B-核心超时; C-TA超时; 0-申请成功; 1-申请失败; 2-已撤单; 3-确认成功; 4-确认失败; D-TA成功核心失败; E-TA失败核心成功;F-挂单成功;G部分确认（确认中）)'';';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.capital_status IS '资金状态(0-未处理;1-已冻结;2-冻结失败;3-冻结超时;4-已扣款;5-扣款失败;6-扣款超时;7-已解冻;8-解冻失败;9-解冻超时;A-已冲正;B-冲正失败;C-冲正超时;D-已还款;E-还款失败;F-还款超时;H-解冻扣款成功;I-解冻扣款失败;J-解冻扣款失败但解冻成功;)';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.capital_type IS '资金处理类型（0-冻结;1-扣款;2-解冻;3-还款;4-冲正;5-解冻并扣款;）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.rtn_code IS '返回码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.rtn_desc IS '返回描述';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.mac_date IS '机器日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.mac_time IS '机器时间';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.host_trans_serno IS '核心流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.update_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.update_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.sys_date IS '系统日期(系统工作日)';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_manager IS '客户经理代码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ext_sub_branch_code IS '推广机构';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.frozen_no IS '理财份额冻结编号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.deposit_acct IS '保证金账户';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.cust_risk_level IS '客户风险承受等级';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.prod_risk_level IS '产品风险等级';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_acct_no IS '对方银行账号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_card_no IS '对方凭证号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_card_type IS '对方凭证类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_agent_name IS '转入方经办人名称';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_agent_id_type IS '转入方经办人证件类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_agent_id_code IS '转入方经办人证件号码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_cust_name IS '转入方客户名称';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_id_type IS '输入方证件类型';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.tag_id_code IS '输入方证件号码';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.is_first IS '是否首次购买（1-是 0-否）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_batch IS 'TA文件批次号（即文件名尾部的001、002，中登2.2接口允许发送多批次文件）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ta_app_serno IS 'TA确认记录的申请流水号（非TA发起交易的交易时应该与app_serno一致）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.ori_ta_cfm_serno IS '原TA确认编号（032解冻时需要上送031冻结成功的确认流水号）';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.src_serno IS '全局流水号';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.print_count IS '补打次数';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.account_date IS '预计到账日期';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.trans_deal_ip IS '交易处理ip';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_ip IS '渠道IP';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.channel_mac IS '渠道mac';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.recomm_ppl IS '推荐人';
COMMENT ON COLUMN crmdm.fms_td_cust_trans_req_log.session_id IS '回溯码';


-- crmdm.fms_td_cust_vol 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_cust_vol;

CREATE TABLE crmdm.fms_td_cust_vol (
	fnc_trans_acct_no varchar(24) NULL, -- 理财交易账号
	ta_acct_no varchar(32) NULL, -- TA账号
	tano varchar(16) NULL, -- TA代码
	prod_code varchar(32) NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	cust_no varchar(32) NULL, -- 客户号
	total_amt numeric(32, 2) NULL, -- 总金额
	total_vol numeric(32, 2) NULL, -- 总份额
	trans_frozen_vol numeric(32, 2) NULL, -- 交易冻结份额
	elisor_frozen_vol numeric(32, 2) NULL, -- 司法冻结份额
	abn_frozen_vol numeric(32, 2) NULL, -- 质押冻结份额
	ta_frozen_vol numeric(32, 2) NULL, -- TA冻结份额
	undistribute_monetary_income numeric(32, 2) NULL, -- 货币式理财未付收益金额
	hold_cost numeric(32, 2) NULL, -- 持仓成本
	upd_date varchar(8) NULL, -- 更新日期
	upd_time varchar(6) NULL, -- 更新时间
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	attorn_out_vol numeric(32, 2) NULL, -- 转让转出份额
	attorn_into_vol numeric(32, 2) NULL, -- 转让转入份额
	attorn_into_frozen_vol numeric(32, 2) NULL, -- 转如冻结份额
	trans_redem_vol numeric(32, 2) NULL, -- 实时赎回待TA确认份额
	total_buy_amt numeric(32, 2) NULL, -- 累计购买金额（确认金额）
	total_buy_vol numeric(32, 2) NULL, -- 累计购买份额（确认份额）
	total_redeem_amt numeric(32, 2) NULL, -- 累计赎回金额（确认金额）
	total_redeem_vol numeric(32, 2) NULL, -- 累计赎回份额（确认份额）
	total_income_amt numeric(32, 2) NULL, -- 累计收益金额（即143总确认金额，不区分分红方式）
	total_income_cash numeric(32, 2) NULL, -- 累积现金分红总金额
	total_income_reinvestment numeric(32, 2) NULL, -- 累积红利再投总份额
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_cust_vol IS '理财客户份额表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_cust_vol.fnc_trans_acct_no IS '理财交易账号';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.ta_acct_no IS 'TA账号';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_amt IS '总金额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_vol IS '总份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.trans_frozen_vol IS '交易冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.elisor_frozen_vol IS '司法冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.abn_frozen_vol IS '质押冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.ta_frozen_vol IS 'TA冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.undistribute_monetary_income IS '货币式理财未付收益金额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.hold_cost IS '持仓成本';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.upd_date IS '更新日期';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.upd_time IS '更新时间';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.attorn_out_vol IS '转让转出份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.attorn_into_vol IS '转让转入份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.attorn_into_frozen_vol IS '转如冻结份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.trans_redem_vol IS '实时赎回待TA确认份额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_buy_amt IS '累计购买金额（确认金额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_buy_vol IS '累计购买份额（确认份额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_redeem_amt IS '累计赎回金额（确认金额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_redeem_vol IS '累计赎回份额（确认份额）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_income_amt IS '累计收益金额（即143总确认金额，不区分分红方式）';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_income_cash IS '累积现金分红总金额';
COMMENT ON COLUMN crmdm.fms_td_cust_vol.total_income_reinvestment IS '累积红利再投总份额';


-- crmdm.fms_td_prod_info 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_info;

CREATE TABLE crmdm.fms_td_prod_info (
	tano varchar(16) NULL, -- TA代码
	prod_code varchar(32) NULL, -- 产品代码
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	prod_name varchar(400) NULL, -- 产品名称
	prod_name_short varchar(120) NULL, -- 产品简称
	prod_type varchar(2) NULL, -- 产品形态
	share_class bpchar(1) NULL, -- 份额类别
	prod_status bpchar(1) NULL, -- 产品状态
	sale_status bpchar(1) NULL, -- 销售状态
	prod_risk_level bpchar(1) NULL, -- 产品风险等级
	prod_manager varchar(32) NULL, -- 产品管理人
	prod_mandator varchar(32) NULL, -- 托管人
	rasie_type varchar(32) NULL, -- 募集方式
	regist_code varchar(32) NULL, -- 产品登记编码
	benchmarks numeric(11, 8) NULL, -- 业绩基准
	prod_cur varchar(3) NULL, -- 产品币种
	collect_feetype bpchar(1) NULL, -- 交易费计算方式(0-价内费1-价外费)
	redeemfee_backratio numeric(9, 5) NULL, -- 赎回费归理财资产比例
	redeem_feerate numeric(9, 5) NULL, -- 违约赎回费率
	def_div_method bpchar(1) NULL, -- 默认分红方式
	div_chg_flag bpchar(1) NULL, -- 分红方式是否可修改
	price numeric(16, 8) NULL, -- 产品面值（发行价格）
	nav numeric(16, 8) NULL, -- 产品净值
	nav_date varchar(8) NULL, -- 净值日期
	proxy_fee_flag varchar(1) NULL, -- 代理费是否留存
	prod_size numeric(32, 2) NULL, -- 产品发行规模
	quota_ctrl_flag bpchar(1) NULL, -- 是否进行额度限制
	subs_capital_mode bpchar(1) NULL, -- 认购资金处理模式
	subs_capital_type bpchar(1) NULL, -- 认购款到账方式，其中N为认购交收天数
	sub_payback_period numeric(38) NULL, -- 认购退款交收天数
	subs_nextday_cancel bpchar(1) NULL, -- 认购是否支持隔日撤单
	apply_capital_mode bpchar(1) NULL, -- 申购资金处理模式
	apply_pay_period numeric(38) NULL, -- 申购资金交收天数
	first_buy_flag varchar(32) NULL, -- 首次购买判断标准
	convert_status varchar(1) NULL, -- 产品转换状态
	periodic_status varchar(1) NULL, -- 定期定额状态
	transfer_agency_status varchar(1) NULL, -- 转托管状态
	divident_date varchar(8) NULL, -- 分红日/发放日
	registration_date varchar(8) NULL, -- 权益登记日期
	booking_begin_date varchar(8) NULL, -- 预留开始日
	booking_invalid_date varchar(8) NULL, -- 预留失效日
	subs_begin_date varchar(8) NULL, -- 募集开始日
	subs_end_date varchar(8) NULL, -- 募集结束日
	subs_end_time varchar(6) NULL, -- 募集结束时间
	subs_cancel_end_date varchar(8) NULL, -- 认购撤单截止日期
	establish_date varchar(8) NULL, -- 成立日（滚动产品成清算时，将该值更新为下一个周期成立日）
	value_date varchar(8) NULL, -- 收益起始日
	open_begin_date varchar(8) NULL, -- 开放起始日
	open_end_date varchar(8) NULL, -- 开放结束日
	winding_date varchar(8) NULL, -- 到期日（到期日期，滚动产品到期清算时将该值更新）
	close_time varchar(6) NULL, -- 收市时间
	trans_start_time varchar(6) NULL, -- 每日交易允许起始时间
	trans_end_time varchar(6) NULL, -- 每日交易允许结束时间
	period_type bpchar(1) NULL, -- 产品模式
	profit_type varchar(32) NULL, -- 计价类型
	prod_lifecycle bpchar(1) NULL, -- 产品生命周期状态
	redeem_pay_period numeric(38) NULL, -- 赎回资金交收天数
	divide_pay_period numeric(38) NULL, -- 分红资金交收天数
	end_pay_period numeric(38) NULL, -- 产品终止资金交收天数
	apply_cfm_n numeric(38) NULL, -- 申购确认日 (0-T+0、1-T+1、2-T+2)
	redeem_cfm_n numeric(38) NULL, -- 赎回确认日 (0-T+0、1-T+1、2-T+2)
	is_discount varchar(1) NULL, -- 是否允许打折
	can_booking varchar(1) NULL, -- 是否可进行额度预留
	redeem_type bpchar(1) NULL, -- 赎回方式
	can_realtime_redeem varchar(1) NULL, -- 是否允许实时赎回
	realtime_repay_flag bpchar(1) NULL, -- 收市后是否允许实时赎回
	realtime_repay_method bpchar(1) NULL, -- 收市后实时赎回回款方式
	windup_type bpchar(1) NULL, -- 清盘方式
	prod_order numeric(38) NULL, -- 产品序号
	can_frozen varchar(1) NULL, -- 是否允许质押冻结
	can_conv_flag varchar(1) NULL, -- 是否支持份额转让
	recom_flg varchar(1) NULL, -- 推荐标识
	pgmno varchar(32) NULL, -- 产品工作日方案代码
	pre_workday varchar(8) NULL, -- 产品上一工作日
	current_workday varchar(8) NULL, -- 产品当前工作日
	next_workday varchar(8) NULL, -- 产品下一工作日
	min_subs_amt numeric(32, 2) NULL, -- 最低募集额
	max_subs_amt numeric(32, 2) NULL, -- 最高募集金额
	online_date varchar(8) NULL, -- 上线日期
	invest_target bpchar(1) NULL, -- 投资性质
	cash_flag bpchar(1) NULL, -- 钞汇标识
	is_hot_sale bpchar(1) NULL, -- 是否热销产品
	operation_period_day numeric NULL, -- 运作期天数
	max_lock_days numeric(32) NULL, -- 最大持有天数
	benchmarks_text varchar(1536) NULL, -- 预期收益率说明/业绩比较基准
	prod_rate numeric NULL, -- 收益率
	min_hold numeric(38) NULL, -- 最低持有（天）
	prod_days numeric(38) NULL, -- 期限
	channel_show_flag bpchar(1) NULL, -- 渠道端展示标志
	sort_no numeric(8, 4) NULL, -- 排序编号
	apply_begin_date varchar(8) NULL, -- 本期申购开始日
	redeem_begin_date varchar(8) NULL, -- 本期赎回开始日
	prod_template_code varchar(8) NULL, -- 冗余字段
	cycle_days numeric NULL,
	is_dx_new_cust_prod varchar(1) NULL,
	cust_cycle_redeem_type varchar(1) NULL,
	open_notify_flag varchar(1) NULL,
	achievement_show_type varchar(1) NULL,
	show_short_flag varchar(1) NULL,
	workdaytype varchar(1) NULL,
	benchmarkexpiredate varchar(8) NULL,
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_prod_info IS '理财产品信息表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_prod_info.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_name IS '产品名称';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_name_short IS '产品简称';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_type IS '产品形态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_status IS '产品状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.sale_status IS '销售状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_risk_level IS '产品风险等级';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_manager IS '产品管理人';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_mandator IS '托管人';
COMMENT ON COLUMN crmdm.fms_td_prod_info.rasie_type IS '募集方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.regist_code IS '产品登记编码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.benchmarks IS '业绩基准';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_cur IS '产品币种';
COMMENT ON COLUMN crmdm.fms_td_prod_info.collect_feetype IS '交易费计算方式(0-价内费1-价外费)';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeemfee_backratio IS '赎回费归理财资产比例';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_feerate IS '违约赎回费率';
COMMENT ON COLUMN crmdm.fms_td_prod_info.def_div_method IS '默认分红方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.div_chg_flag IS '分红方式是否可修改';
COMMENT ON COLUMN crmdm.fms_td_prod_info.price IS '产品面值（发行价格）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.nav IS '产品净值';
COMMENT ON COLUMN crmdm.fms_td_prod_info.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.proxy_fee_flag IS '代理费是否留存';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_size IS '产品发行规模';
COMMENT ON COLUMN crmdm.fms_td_prod_info.quota_ctrl_flag IS '是否进行额度限制';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_capital_mode IS '认购资金处理模式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_capital_type IS '认购款到账方式，其中N为认购交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.sub_payback_period IS '认购退款交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_nextday_cancel IS '认购是否支持隔日撤单';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_capital_mode IS '申购资金处理模式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_pay_period IS '申购资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.first_buy_flag IS '首次购买判断标准';
COMMENT ON COLUMN crmdm.fms_td_prod_info.convert_status IS '产品转换状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.periodic_status IS '定期定额状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.transfer_agency_status IS '转托管状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.divident_date IS '分红日/发放日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.registration_date IS '权益登记日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.booking_begin_date IS '预留开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.booking_invalid_date IS '预留失效日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_begin_date IS '募集开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_end_date IS '募集结束日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_end_time IS '募集结束时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.subs_cancel_end_date IS '认购撤单截止日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.establish_date IS '成立日（滚动产品成清算时，将该值更新为下一个周期成立日）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.value_date IS '收益起始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.open_begin_date IS '开放起始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.open_end_date IS '开放结束日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.winding_date IS '到期日（到期日期，滚动产品到期清算时将该值更新）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.close_time IS '收市时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.trans_start_time IS '每日交易允许起始时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.trans_end_time IS '每日交易允许结束时间';
COMMENT ON COLUMN crmdm.fms_td_prod_info.period_type IS '产品模式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.profit_type IS '计价类型';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_lifecycle IS '产品生命周期状态';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_pay_period IS '赎回资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.divide_pay_period IS '分红资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.end_pay_period IS '产品终止资金交收天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_cfm_n IS '申购确认日 (0-T+0、1-T+1、2-T+2)';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_cfm_n IS '赎回确认日 (0-T+0、1-T+1、2-T+2)';
COMMENT ON COLUMN crmdm.fms_td_prod_info.is_discount IS '是否允许打折';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_booking IS '是否可进行额度预留';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_type IS '赎回方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_realtime_redeem IS '是否允许实时赎回';
COMMENT ON COLUMN crmdm.fms_td_prod_info.realtime_repay_flag IS '收市后是否允许实时赎回';
COMMENT ON COLUMN crmdm.fms_td_prod_info.realtime_repay_method IS '收市后实时赎回回款方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.windup_type IS '清盘方式';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_order IS '产品序号';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_frozen IS '是否允许质押冻结';
COMMENT ON COLUMN crmdm.fms_td_prod_info.can_conv_flag IS '是否支持份额转让';
COMMENT ON COLUMN crmdm.fms_td_prod_info.recom_flg IS '推荐标识';
COMMENT ON COLUMN crmdm.fms_td_prod_info.pgmno IS '产品工作日方案代码';
COMMENT ON COLUMN crmdm.fms_td_prod_info.pre_workday IS '产品上一工作日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.current_workday IS '产品当前工作日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.next_workday IS '产品下一工作日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.min_subs_amt IS '最低募集额';
COMMENT ON COLUMN crmdm.fms_td_prod_info.max_subs_amt IS '最高募集金额';
COMMENT ON COLUMN crmdm.fms_td_prod_info.online_date IS '上线日期';
COMMENT ON COLUMN crmdm.fms_td_prod_info.invest_target IS '投资性质';
COMMENT ON COLUMN crmdm.fms_td_prod_info.cash_flag IS '钞汇标识';
COMMENT ON COLUMN crmdm.fms_td_prod_info.is_hot_sale IS '是否热销产品';
COMMENT ON COLUMN crmdm.fms_td_prod_info.operation_period_day IS '运作期天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.max_lock_days IS '最大持有天数';
COMMENT ON COLUMN crmdm.fms_td_prod_info.benchmarks_text IS '预期收益率说明/业绩比较基准';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_rate IS '收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_info.min_hold IS '最低持有（天）';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_days IS '期限';
COMMENT ON COLUMN crmdm.fms_td_prod_info.channel_show_flag IS '渠道端展示标志';
COMMENT ON COLUMN crmdm.fms_td_prod_info.sort_no IS '排序编号';
COMMENT ON COLUMN crmdm.fms_td_prod_info.apply_begin_date IS '本期申购开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.redeem_begin_date IS '本期赎回开始日';
COMMENT ON COLUMN crmdm.fms_td_prod_info.prod_template_code IS '冗余字段';


-- crmdm.fms_td_prod_limit 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_limit;

CREATE TABLE crmdm.fms_td_prod_limit (
	tano varchar(16) NOT NULL, -- TA代码
	prod_code varchar(32) NOT NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	prod_sale_custom bpchar(2) NULL, -- 销售对象
	first_invest bpchar(1) NULL, -- 首次投资认定标准（-0-零购买：，1-零份额）
	min_asset_limit numeric(32, 2) NULL, -- 最低资产限额: -1为不限
	max_hold_peoples int4 NULL, -- 最高持有人数: -1为不限
	min_hold_peoples int4 NULL, -- 最低持有人数: -1为不限
	max_daily_subs_amt numeric(32, 2) NULL, -- 产品单日累计申购上限: -1为不限
	max_daily_redeem_amt numeric(32, 2) NULL, -- 产品单日累计赎回上限: -1为不限
	max_hold_days int4 NULL, -- 最高持有天数: -1为不限
	min_hold_days int4 NULL, -- 最低持有天数: -1为不限
	min_age int4 NULL, -- 年龄段最大值，-1为不限
	max_age int4 NULL, -- 年龄段最大值，-1为不限
	redeem_mode bpchar(1) NULL, -- 巨额赎回处理方式（0-取消，1-顺延，2-按投资这意愿）
	redeem_ratio numeric(32, 2) NULL, -- 巨额赎回比例，-1为不限
	min_subs_p numeric(32, 2) NULL, -- 个人首次认购最低金额
	step_subs_p numeric(32, 2) NULL, -- 个人认购递增金额
	min_subsend_p numeric(32, 2) NULL, -- 个人追加认购金额
	min_apply_p numeric(32, 2) NULL, -- 个人首次申购最低金额
	step_apply_p numeric(32, 2) NULL, -- 个人申购递增金额
	min_append_p numeric(32, 2) NULL, -- 个人追加申购最低金额
	max_subs_p numeric(32, 2) NULL, -- 个人单笔最大认购金额
	max_apply_p numeric(32, 2) NULL, -- 个人单笔最大申购金额
	max_daily_subs_p numeric(32, 2) NULL, -- 个人单日累计购买上限
	min_hold_p numeric(32, 2) NULL, -- 个人最低持有份额
	min_redeem_p numeric(32, 2) NULL, -- 个人最低赎回份额
	max_redeem_p numeric(32, 2) NULL, -- 个人单笔最大赎回份额
	max_daily_redeem_p numeric(32, 2) NULL, -- 个人单日累计赎回上限
	min_timeing_buy_p numeric(32, 2) NULL, -- 个人定期定额最低金额
	max_timeing_buy_p numeric(32, 2) NULL, -- 个人定期定额最高金额
	max_timeing_redem_p numeric(32, 2) NULL, -- 个人定期定额最低赎回份额
	max_convert_p numeric(32, 2) NULL, -- 个人最低产品转换份额
	max_holdamt_p numeric(32, 2) NULL, -- 个人最高持有金额
	max_holdrate_p numeric(32, 2) NULL, -- 个人最高持有比例
	min_subs_m numeric(32, 2) NULL, -- 机构首次认购最低金额
	step_subs_m numeric(32, 2) NULL, -- 机构认购递增金额
	min_subsend_m numeric(32, 2) NULL, -- 机构追加认购金额
	min_apply_m numeric(32, 2) NULL, -- 机构首次申购最低金额
	step_apply_m numeric(32, 2) NULL, -- 机构申购递增金额
	min_append_m numeric(32, 2) NULL, -- 机构追加申购最低金额
	max_subs_m numeric(32, 2) NULL, -- 机构单笔最大认购金额
	max_apply_m numeric(32, 2) NULL, -- 机构单笔最大申购金额
	max_daily_subs_m numeric(32, 2) NULL, -- 机构单日累计购买上限
	min_hold_m numeric(32, 2) NULL, -- 机构最低持有份额
	min_redeem_m numeric(32, 2) NULL, -- 机构最低赎回份额
	max_redeem_m numeric(32, 2) NULL, -- 机构单笔最大赎回份额
	max_daily_redeem_m numeric(32, 2) NULL, -- 机构单日累计赎回上限
	min_timeing_buy_m numeric(32, 2) NULL, -- 机构定期定额最低金额
	max_timeing_buy_m numeric(32, 2) NULL, -- 机构定期定额最高金额
	max_timeing_redem_m numeric(32, 2) NULL, -- 机构定期定额最低赎回份额
	max_convert_m numeric(32, 2) NULL, -- 机构最低产品转换份额
	max_holdamt_m numeric(32, 2) NULL, -- 机构最高持有金额
	max_holdrate_m numeric(32, 2) NULL, -- 机构最高持有比例
	list_code varchar(8) NULL, -- 名单编号(黑白名单)
	max_cust_offday_redeem_amt numeric(16, 2) NULL, -- 收市后单客户赎回上限
	max_prod_offday_redeem_amt numeric(16, 2) NULL, -- 收市后产品赎回上限
	max_hold_vol_p numeric(32, 2) NULL, -- 个人最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率
	max_hold_vol_m numeric(32, 2) NULL, -- 机构最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率
	ryzd varchar(1) NULL,
	CONSTRAINT pk_fms_td_prod_limit PRIMARY KEY (tano, prod_code)
);
COMMENT ON TABLE crmdm.fms_td_prod_limit IS '产品限额表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_prod_limit.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.prod_sale_custom IS '销售对象';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.first_invest IS '首次投资认定标准（-0-零购买：，1-零份额）';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_asset_limit IS '最低资产限额: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_peoples IS '最高持有人数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_peoples IS '最低持有人数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_subs_amt IS '产品单日累计申购上限: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_redeem_amt IS '产品单日累计赎回上限: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_days IS '最高持有天数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_days IS '最低持有天数: -1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_age IS '年龄段最大值，-1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_age IS '年龄段最大值，-1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.redeem_mode IS '巨额赎回处理方式（0-取消，1-顺延，2-按投资这意愿）';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.redeem_ratio IS '巨额赎回比例，-1为不限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subs_p IS '个人首次认购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_subs_p IS '个人认购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subsend_p IS '个人追加认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_apply_p IS '个人首次申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_apply_p IS '个人申购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_append_p IS '个人追加申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_subs_p IS '个人单笔最大认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_apply_p IS '个人单笔最大申购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_subs_p IS '个人单日累计购买上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_p IS '个人最低持有份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_redeem_p IS '个人最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_redeem_p IS '个人单笔最大赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_redeem_p IS '个人单日累计赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_timeing_buy_p IS '个人定期定额最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_buy_p IS '个人定期定额最高金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_redem_p IS '个人定期定额最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_convert_p IS '个人最低产品转换份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdamt_p IS '个人最高持有金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdrate_p IS '个人最高持有比例';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subs_m IS '机构首次认购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_subs_m IS '机构认购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_subsend_m IS '机构追加认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_apply_m IS '机构首次申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.step_apply_m IS '机构申购递增金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_append_m IS '机构追加申购最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_subs_m IS '机构单笔最大认购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_apply_m IS '机构单笔最大申购金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_subs_m IS '机构单日累计购买上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_hold_m IS '机构最低持有份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_redeem_m IS '机构最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_redeem_m IS '机构单笔最大赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_daily_redeem_m IS '机构单日累计赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.min_timeing_buy_m IS '机构定期定额最低金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_buy_m IS '机构定期定额最高金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_timeing_redem_m IS '机构定期定额最低赎回份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_convert_m IS '机构最低产品转换份额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdamt_m IS '机构最高持有金额';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_holdrate_m IS '机构最高持有比例';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.list_code IS '名单编号(黑白名单)';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_cust_offday_redeem_amt IS '收市后单客户赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_prod_offday_redeem_amt IS '收市后产品赎回上限';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_vol_p IS '个人最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率';
COMMENT ON COLUMN crmdm.fms_td_prod_limit.max_hold_vol_m IS '机构最高持有限额（客户持有份额+当日申购金额），粗略值，为了增加分销确认成功率';


-- crmdm.fms_td_prod_nav 定义

-- Drop table

-- DROP TABLE crmdm.fms_td_prod_nav;

CREATE TABLE crmdm.fms_td_prod_nav (
	tano varchar(16) NOT NULL, -- TA代码
	prod_code varchar(32) NOT NULL, -- 产品代码
	share_class bpchar(1) NULL, -- 份额类别
	net_value_type varchar(1) NOT NULL, -- 净值类型
	nav_date varchar(8) NOT NULL, -- 净值日期
	nav numeric(16, 8) NULL, -- 单位净值
	total_nav numeric(16, 8) NULL, -- 累计净值
	ten_thousand_income_amt numeric(16, 8) NULL, -- 万份收益
	seven_days_income_rate numeric(17, 8) NULL, -- 近七日年化收益率
	import_date varchar(8) NULL, -- 导入日期
	legal_code varchar(32) NULL, -- 法人代码（多法人模式）
	dayclientratio numeric(16, 8) NULL, -- 日年化收益率
	monthclientratio numeric(16, 8) NULL, -- 近一月年化收益率
	quarterclientratio numeric(16, 8) NULL, -- 近一季年化收益率
	semiannualclientratio numeric(16, 8) NULL, -- 近半年以来年化收益率
	yearclientratio numeric(16, 8) NULL, -- 近一年年化收益率
	cycleclientratio numeric(16, 8) NULL, -- 上周期化收益率
	twoyearclientratio numeric(16, 8) NULL, -- 近二年以来年化收益率
	threeyearclientratio numeric(16, 8) NULL, -- 近三年以来年化收益率
	tonowclientratio numeric(16, 8) NULL, -- 成立以来参考年化收益率
	remark varchar(200) NULL, -- 备注
	adjustednav numeric(16, 2) NULL, -- 复权净值
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.fms_td_prod_nav IS '理财产品行情表';

-- Column comments

COMMENT ON COLUMN crmdm.fms_td_prod_nav.tano IS 'TA代码';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.prod_code IS '产品代码';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.share_class IS '份额类别';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.net_value_type IS '净值类型';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.nav_date IS '净值日期';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.nav IS '单位净值';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.total_nav IS '累计净值';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.ten_thousand_income_amt IS '万份收益';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.seven_days_income_rate IS '近七日年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.import_date IS '导入日期';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.legal_code IS '法人代码（多法人模式）';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.dayclientratio IS '日年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.monthclientratio IS '近一月年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.quarterclientratio IS '近一季年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.semiannualclientratio IS '近半年以来年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.yearclientratio IS '近一年年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.cycleclientratio IS '上周期化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.twoyearclientratio IS '近二年以来年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.threeyearclientratio IS '近三年以来年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.tonowclientratio IS '成立以来参考年化收益率';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.remark IS '备注';
COMMENT ON COLUMN crmdm.fms_td_prod_nav.adjustednav IS '复权净值';


-- crmdm.ibp_czdf_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ibp_czdf_bat_detail;

CREATE TABLE crmdm.ibp_czdf_bat_detail (
	batch_no varchar(30) NOT NULL, -- 批次号
	serial_id varchar(12) NOT NULL, -- 流水号
	bank_name varchar(400) NULL, -- 开户行名称
	payee_id varchar(32) NULL, -- 收款人身份证件号码
	payee_name varchar(128) NULL, -- 收款人名称
	coll_account varchar(20) NULL, -- 收款账号
	amt numeric(20, 2) NOT NULL, -- 金额
	remark varchar(240) NULL, -- 附言
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	status varchar(1) NOT NULL, -- "处理状态：0:未处理 1:处理中 2:处理成功 3:处理失败 4:处理超时"
	rst_memo varchar(400) NULL, -- 交易结果描述
	tran_channel varchar(32) NULL, -- 交易渠道号
	bank_acct_no varchar(80) NULL, -- 开户行号
	third_batch varchar(30) NULL, -- 第三方批次号
	is_other_bank varchar(1) NULL, -- 是否跨行：1 否     2 是
	tel varchar(50) NULL, -- 联系电话
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_czdf_bat_detail PRIMARY KEY (serial_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.serial_id IS '流水号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.bank_name IS '开户行名称';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.payee_id IS '收款人身份证件号码';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.payee_name IS '收款人名称';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.coll_account IS '收款账号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.amt IS '金额';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.remark IS '附言';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.status IS '"处理状态：0:未处理 1:处理中 2:处理成功 3:处理失败 4:处理超时"';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.tran_channel IS '交易渠道号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.bank_acct_no IS '开户行号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.third_batch IS '第三方批次号';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.is_other_bank IS '是否跨行：1 否     2 是';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.tel IS '联系电话';
COMMENT ON COLUMN crmdm.ibp_czdf_bat_detail.ryzd IS '冗余字段';


-- crmdm.ibp_ib_list_plat 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ib_list_plat;

CREATE TABLE crmdm.ibp_ib_list_plat (
	plat_serial varchar(35) NOT NULL, -- 平台流水
	plat_date varchar(8) NOT NULL, -- 交易日期
	plat_time varchar(6) NOT NULL, -- 交易时间
	reverse_flag varchar(1) NOT NULL, -- 是否冲正交易 0:否 1:是
	ori_serial varchar(35) NULL, -- 原交易流水号
	channel_id varchar(4) NOT NULL, -- 渠道号
	service_id varchar(8) NOT NULL, -- 交易码
	channel_serial varchar(40) NOT NULL, -- 渠道流水号
	channel_date varchar(8) NULL, -- 渠道日期
	channel_time varchar(6) NULL, -- 渠道时间
	trans_device_no varchar(40) NULL, -- 交易设备ID
	area_id varchar(4) NULL, -- 交易区域
	branch_code varchar(20) NULL, -- 交易机构
	teller_id varchar(20) NULL, -- 柜员号
	auther_id varchar(20) NULL, -- 授权柜员号
	auther_password varchar(64) NULL, -- 授权密码
	busi_id varchar(24) NOT NULL, -- 业务分类编号
	acct_no varchar(32) NULL, -- 交易账号
	acct_name varchar(1020) NULL, -- 交易账号名称
	trad_type varchar(1) NOT NULL, -- 交易类别 0:现金 1:转账 2:其他
	cry_id varchar(3) NOT NULL, -- 交易币种(CNY，基于ISO 4217)
	amt numeric(16, 2) NOT NULL, -- 交易金额
	amt1 numeric(16, 2) NULL, -- 辅助金额1
	amt2 numeric(16, 2) NULL, -- 辅助金额2
	amt3 numeric(16, 2) NULL, -- 辅助金额3
	trad_abs varchar(800) NULL, -- 交易摘要
	voucher_type varchar(3) NULL, -- 凭证类型
	voucher_no varchar(40) NULL, -- 凭证号码
	opp_acct_no varchar(32) NULL, -- 对手账户
	opp_acct_name varchar(1020) NULL, -- 对手账户名称
	user_id varchar(80) NULL, -- 客户编号
	user_name varchar(800) NULL, -- 客户姓名
	tran_memo varchar(1020) NULL, -- 交易备注信息
	plat_trad_status varchar(1) NOT NULL, -- 平台处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	plat_resp_code varchar(12) NULL, -- 平台响应码
	plat_resp_msg varchar(800) NULL, -- 平台响应信息
	core_status varchar(1) NULL, -- 核心处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	core_serial_no varchar(40) NULL, -- 核心请求流水号
	core_resp_serial varchar(40) NULL, -- 核心响应流水号
	core_resp_code varchar(20) NULL, -- 核心响应码
	core_resp_msg varchar(800) NULL, -- 核心响应信息
	third_party_status varchar(1) NULL, -- 第三方处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	third_party_serial_no varchar(40) NULL, -- 第三方请求流水号
	third_party_resp_serial varchar(40) NULL, -- 第三方响应流水号
	third_party_resp_code varchar(20) NULL, -- 第三方响应码
	third_party_resp_msg varchar(800) NULL, -- 第三方响应信息
	request_add_info varchar(4000) NULL, -- 请求附加域
	resp_add_info varchar(4000) NULL, -- 响应附加域
	chk_flag varchar(1) NOT NULL, -- N 无需对账，0:未对账，1:已对账，2:已生成第三方对账文件，3:处理中
	core_date varchar(8) NULL, -- 核心日期
	third_party_date varchar(8) NULL, -- 第三方日期
	core_time varchar(6) NULL, -- 核心时间
	settle_date varchar(8) NULL, -- 清算日期
	tran_date varchar(8) NOT NULL, -- 交易日期
	item_id varchar(40) NULL, -- 项目分类编号
	rem_amt numeric(16, 2) NULL, -- 剩余可退款金额
	third_party_time varchar(6) NULL, -- 第三方时间
	third_chk_flag varchar(2) NULL, -- 三方对账 N:无需对账 0:未对账 1:已对账 2:对账有差错
	settle_cd_flag varchar(2) NULL, -- 过渡户清算借贷标识 D:借记 C:贷记
	settle_flag varchar(2) NULL, -- 清算标识 N:无需清算 0:未清算 1:已清算 2:清算失败
	settle_amt numeric(16, 2) NULL, -- 清算金额
	d_amt_sum numeric(17, 2) NOT NULL, -- 借方累计金额
	c_amt_sum numeric(17, 2) NOT NULL, -- 贷方累计金额
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_serial IS '平台流水';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_date IS '交易日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_time IS '交易时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.reverse_flag IS '是否冲正交易 0:否 1:是';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.ori_serial IS '原交易流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_id IS '渠道号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.service_id IS '交易码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_serial IS '渠道流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.trans_device_no IS '交易设备ID';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.area_id IS '交易区域';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.branch_code IS '交易机构';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.teller_id IS '柜员号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.auther_id IS '授权柜员号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.auther_password IS '授权密码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.busi_id IS '业务分类编号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.acct_no IS '交易账号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.acct_name IS '交易账号名称';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.trad_type IS '交易类别 0:现金 1:转账 2:其他';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.cry_id IS '交易币种(CNY，基于ISO 4217)';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt IS '交易金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt1 IS '辅助金额1';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt2 IS '辅助金额2';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.amt3 IS '辅助金额3';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.trad_abs IS '交易摘要';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.voucher_type IS '凭证类型';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.voucher_no IS '凭证号码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.opp_acct_no IS '对手账户';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.opp_acct_name IS '对手账户名称';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.user_id IS '客户编号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.user_name IS '客户姓名';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.tran_memo IS '交易备注信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_trad_status IS '平台处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_resp_code IS '平台响应码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.plat_resp_msg IS '平台响应信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_status IS '核心处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_serial_no IS '核心请求流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_resp_serial IS '核心响应流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_resp_code IS '核心响应码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_resp_msg IS '核心响应信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_status IS '第三方处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_serial_no IS '第三方请求流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_resp_serial IS '第三方响应流水号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_resp_code IS '第三方响应码';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_resp_msg IS '第三方响应信息';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.request_add_info IS '请求附加域';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.resp_add_info IS '响应附加域';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.chk_flag IS 'N 无需对账，0:未对账，1:已对账，2:已生成第三方对账文件，3:处理中';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_date IS '核心日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_date IS '第三方日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.core_time IS '核心时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_date IS '清算日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.tran_date IS '交易日期';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.item_id IS '项目分类编号';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.rem_amt IS '剩余可退款金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_party_time IS '第三方时间';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.third_chk_flag IS '三方对账 N:无需对账 0:未对账 1:已对账 2:对账有差错';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_cd_flag IS '过渡户清算借贷标识 D:借记 C:贷记';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_flag IS '清算标识 N:无需清算 0:未清算 1:已清算 2:清算失败';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.settle_amt IS '清算金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.d_amt_sum IS '借方累计金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.c_amt_sum IS '贷方累计金额';
COMMENT ON COLUMN crmdm.ibp_ib_list_plat.ryzd IS '冗余字段';


-- crmdm.ibp_lssb_trans_detail 定义

-- Drop table

-- DROP TABLE crmdm.ibp_lssb_trans_detail;

CREATE TABLE crmdm.ibp_lssb_trans_detail (
	plat_serial varchar(20) NOT NULL, -- 平台流水号
	tran_code varchar(8) NULL, -- 交易码
	batch_no varchar(18) NULL, -- 批次号
	id varchar(32) NULL, -- 社保流水号
	batch_message varchar(128) NULL, -- 批次描述
	"type" varchar(3) NULL, -- 险种
	branch_code varchar(8) NULL, -- 经办机构编码
	soc_no varchar(20) NULL, -- 个人编码/单位编码
	idno varchar(20) NOT NULL, -- 身份证号
	"name" varchar(100) NULL, -- 姓名/单位名称
	billno varchar(32) NOT NULL, -- 社保单据号
	bank_code varchar(8) NULL, -- 交易银行
	pboc_code varchar(16) NULL, -- 人行网点编号
	pboc_name varchar(128) NULL, -- 人行网点名称
	acct_name varchar(100) NULL, -- 户名
	acct_no varchar(32) NULL, -- 银行账号
	socs_branch_code varchar(8) NULL, -- 社保经办银行
	socs_acct_name varchar(100) NULL, -- 社保经办户名
	socs_acct_no varchar(32) NULL, -- 社保经办银行账号
	date_no varchar(10) NULL, -- 期号
	tran_amt numeric(12, 2) NULL, -- 交易金额
	remark varchar(100) NULL, -- 摘要说明
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	rst_memo varchar(500) NULL, -- 交易结果描述
	status varchar(1) NULL, -- 交易状态0:未处理 1:处理中 2:处理成功 3:处理失败败 4:处理超时
	tran_channel varchar(32) NULL, -- 交易渠道号
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.plat_serial IS '平台流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.tran_code IS '交易码';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.id IS '社保流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.batch_message IS '批次描述';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail."type" IS '险种';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.branch_code IS '经办机构编码';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.soc_no IS '个人编码/单位编码';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.idno IS '身份证号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail."name" IS '姓名/单位名称';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.billno IS '社保单据号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.bank_code IS '交易银行';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.pboc_code IS '人行网点编号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.pboc_name IS '人行网点名称';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.acct_name IS '户名';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.socs_branch_code IS '社保经办银行';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.socs_acct_name IS '社保经办户名';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.socs_acct_no IS '社保经办银行账号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.date_no IS '期号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.tran_amt IS '交易金额';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.remark IS '摘要说明';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.status IS '交易状态0:未处理 1:处理中 2:处理成功 3:处理失败败 4:处理超时';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.tran_channel IS '交易渠道号';
COMMENT ON COLUMN crmdm.ibp_lssb_trans_detail.ryzd IS '冗余字段';


-- crmdm.ibp_scsb_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ibp_scsb_bat_detail;

CREATE TABLE crmdm.ibp_scsb_bat_detail (
	bat_no varchar(18) NOT NULL, -- 社保代发批次号
	det_no varchar(10) NOT NULL, -- 序号
	sb_no varchar(20) NOT NULL, -- 个人编号
	"name" varchar(400) NULL, -- 银行户名
	acct varchar(30) NOT NULL, -- 银行账号
	id_no varchar(18) NULL, -- 证件号码
	id_type varchar(2) NULL, -- 证件类型
	amt numeric(17, 2) NOT NULL, -- 拨付金额
	memo varchar(200) NULL, -- 备注
	bank_no varchar(20) NULL, -- 银行联行号
	sb_serial varchar(20) NULL, -- 业务财务流水号
	payee_type varchar(2) NOT NULL, -- 支付对象类型 1:单位 2:个人
	is_other_bank varchar(2) NOT NULL, -- 支付类型 1:本行 2:他行
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	pay_send_serial varchar(32) NULL, -- 支付系统渠道流水号
	pay_ref_serial varchar(32) NULL, -- 支付系统结果账参考流水号
	rst_memo varchar(512) NULL, -- 交易结果描述
	status varchar(1) NOT NULL, -- 交易状态
	re_status varchar(1) NOT NULL, -- 回盘状态
	remark varchar(128) NULL, -- 摘要
	addtional varchar(128) NULL, -- 附言
	tran_channel varchar(10) NULL, -- 交易渠道
	back_status varchar(1) NULL, -- 是否退汇处理  1.有做退汇处理
	bank_name varchar(400) NULL, -- 姓名
	ignore_limit varchar(1) NULL, -- 是否忽略最高限额  1 是   0 否
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_scsb_bat_detail PRIMARY KEY (bat_no, det_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.bat_no IS '社保代发批次号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.det_no IS '序号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.sb_no IS '个人编号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail."name" IS '银行户名';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.acct IS '银行账号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.id_no IS '证件号码';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.amt IS '拨付金额';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.memo IS '备注';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.bank_no IS '银行联行号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.sb_serial IS '业务财务流水号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.payee_type IS '支付对象类型 1:单位 2:个人';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.is_other_bank IS '支付类型 1:本行 2:他行';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.pay_send_serial IS '支付系统渠道流水号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.pay_ref_serial IS '支付系统结果账参考流水号';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.status IS '交易状态';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.re_status IS '回盘状态';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.remark IS '摘要';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.addtional IS '附言';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.tran_channel IS '交易渠道';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.back_status IS '是否退汇处理  1.有做退汇处理';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.bank_name IS '姓名';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.ignore_limit IS '是否忽略最高限额  1 是   0 否';
COMMENT ON COLUMN crmdm.ibp_scsb_bat_detail.ryzd IS '冗余字段';


-- crmdm.ibp_sys_dict_data 定义

-- Drop table

-- DROP TABLE crmdm.ibp_sys_dict_data;

CREATE TABLE crmdm.ibp_sys_dict_data (
	dict_code numeric(20) NOT NULL, -- 字典主键seq_sys_dict_data.nextval
	dict_sort numeric(4) NULL, -- 字典排序
	dict_label varchar(100) NULL, -- 字典标签
	dict_value varchar(100) NULL, -- 字典键值
	dict_type varchar(100) NULL, -- 字典类型
	css_class varchar(100) NULL, -- 样式属性（其他样式扩展）
	list_class varchar(100) NULL, -- 表格回显样式
	is_default bpchar(1) NULL, -- 是否默认（Y是 N否）
	status bpchar(1) NULL, -- 状态（0正常 1停用）
	create_by varchar(64) NULL, -- 创建者
	create_time sys."date" NULL, -- 创建时间
	update_by varchar(64) NULL, -- 更新者
	update_time sys."date" NULL, -- 更新时间
	remark varchar(500) NULL, -- 备注
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_sys_dict_data PRIMARY KEY (dict_code)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_code IS '字典主键seq_sys_dict_data.nextval';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_sort IS '字典排序';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_label IS '字典标签';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_value IS '字典键值';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.dict_type IS '字典类型';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.css_class IS '样式属性（其他样式扩展）';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.list_class IS '表格回显样式';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.is_default IS '是否默认（Y是 N否）';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.create_by IS '创建者';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.create_time IS '创建时间';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.update_by IS '更新者';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.update_time IS '更新时间';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.remark IS '备注';
COMMENT ON COLUMN crmdm.ibp_sys_dict_data.ryzd IS '冗余字段';


-- crmdm.ibp_sysb_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ibp_sysb_fee_list;

CREATE TABLE crmdm.ibp_sysb_fee_list (
	query_serial varchar(120) NOT NULL, -- 查询流水
	pay_serial varchar(120) NULL, -- 缴费流水
	service_id varchar(20) NOT NULL, -- 服务ID
	batch_no varchar(32) NULL, -- 批次号
	item_id varchar(40) NOT NULL, -- 项目编号
	id_type varchar(3) NOT NULL, -- 证件类型
	id_no varchar(88) NOT NULL, -- 证件号码
	user_name varchar(200) NULL, -- 姓名
	user_id varchar(120) NULL, -- 人员编码
	user_type varchar(1) NULL, -- 缴费人员类型  0：城乡居民  1：灵活就业人员
	user_insurance_type varchar(5) NULL, -- 险种： 00000 代表全部险种 10210 城乡居民养老保险 10212 城乡居民医疗保险 10201养老保险 10203医疗保险
	pay_type varchar(1) NULL, -- 缴费类型：0现金；1转账
	pay_acct_no varchar(200) NULL, -- 付款账号
	pay_acct_name varchar(400) NULL, -- 付款账号名称
	total_amt numeric(18, 2) NOT NULL, -- 总金额
	pay_date varchar(4) NULL, -- 缴费年份
	start_date varchar(6) NULL, -- 费款所属期起
	end_date varchar(6) NULL, -- 费款所属期止
	base_amt numeric(18, 2) NULL, -- 缴费基数
	amt numeric(18, 2) NULL, -- 缴费档次金额
	tax_serial varchar(80) NULL, -- 税务交易流水
	bank_serial varchar(160) NULL, -- 银行缴费流水号
	print_count varchar(50) NULL, -- 打印次数
	vor_type varchar(1) NULL, -- 凭证类型
	det_count numeric NULL, -- 总数量
	ac_bank_type varchar(4) NULL, -- 经办银行种类代码
	ac_bank_code varchar(12) NULL, -- 经办银行代码
	ac_bank_name varchar(320) NULL, -- 经办银行名称
	sett_date varchar(8) NULL, -- 日切日期
	sett_bank_type varchar(4) NULL, -- 结算银行种类代码
	sett_bank_code varchar(12) NULL, -- 结算银行代码
	sett_bank_name varchar(320) NULL, -- 结算银行名称
	sett_bank_account varchar(50) NULL, -- 结算银行帐号
	tax_no varchar(30) NULL, -- 税票号码
	ret_code varchar(12) NULL, -- 返回结果
	ret_msg varchar(500) NULL, -- 返回信息
	ac_branch varchar(8) NULL, -- 经办机构
	sett_branch varchar(8) NULL, -- 结算机构
	zhaiyoms varchar(1200) NULL, -- 短信摘要描述
	ori_acct_no varchar(200) NULL, -- 原付款账号
	swjgmc varchar(400) NULL, -- 税务机关名称
	swjgdm varchar(20) NULL, -- 税务机关代码
	dcmc varchar(120) NULL, -- 档次名称
	chk_status varchar(1) NULL, -- 核对状态
	trans_type varchar(10) NULL, -- "交易类型：01：个人税务批扣缴费； 02：个人税务实时缴费； 03：个人银行查询缴费 "
	chk_amt numeric(18, 2) NULL, -- 核对金额
	chk_date varchar(8) NULL, -- 扣款日期
	chk_memo varchar(800) NULL, -- 失败原因
	phone varchar(60) NULL, -- 手机号码
	address varchar(300) NULL, -- 联系地址
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_sysb_fee_list PRIMARY KEY (query_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.query_serial IS '查询流水';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_serial IS '缴费流水';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.service_id IS '服务ID';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.item_id IS '项目编号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.id_no IS '证件号码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_name IS '姓名';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_id IS '人员编码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_type IS '缴费人员类型  0：城乡居民  1：灵活就业人员';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.user_insurance_type IS '险种： 00000 代表全部险种 10210 城乡居民养老保险 10212 城乡居民医疗保险 10201养老保险 10203医疗保险';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_type IS '缴费类型：0现金；1转账';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_acct_no IS '付款账号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_acct_name IS '付款账号名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.total_amt IS '总金额';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.pay_date IS '缴费年份';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.start_date IS '费款所属期起';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.end_date IS '费款所属期止';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.base_amt IS '缴费基数';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.amt IS '缴费档次金额';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.tax_serial IS '税务交易流水';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.bank_serial IS '银行缴费流水号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.print_count IS '打印次数';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.vor_type IS '凭证类型';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.det_count IS '总数量';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_bank_type IS '经办银行种类代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_bank_code IS '经办银行代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_bank_name IS '经办银行名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_date IS '日切日期';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_type IS '结算银行种类代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_code IS '结算银行代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_name IS '结算银行名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_bank_account IS '结算银行帐号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.tax_no IS '税票号码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ret_code IS '返回结果';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ret_msg IS '返回信息';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ac_branch IS '经办机构';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.sett_branch IS '结算机构';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.zhaiyoms IS '短信摘要描述';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ori_acct_no IS '原付款账号';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.swjgmc IS '税务机关名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.swjgdm IS '税务机关代码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.dcmc IS '档次名称';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_status IS '核对状态';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.trans_type IS '"交易类型：01：个人税务批扣缴费； 02：个人税务实时缴费； 03：个人银行查询缴费 "';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_amt IS '核对金额';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_date IS '扣款日期';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.chk_memo IS '失败原因';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.phone IS '手机号码';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.address IS '联系地址';
COMMENT ON COLUMN crmdm.ibp_sysb_fee_list.ryzd IS '冗余字段';


-- crmdm.ibp_ybt_insurance_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_insurance_base_info;

CREATE TABLE crmdm.ibp_ybt_insurance_base_info (
	insurance_id varchar(200) NOT NULL, -- 险种ID
	item_id varchar(40) NOT NULL, -- 保险公司编号（项目编号 )
	item_name varchar(800) NOT NULL, -- 保险公司名称（项目名称 )
	insurance_code varchar(200) NOT NULL, -- 险种代码
	main_insurance_code varchar(200) NOT NULL, -- 险种对应的主险种编码
	insurance_name varchar(800) NOT NULL, -- 险种名称
	insurance_type varchar(8) NOT NULL, -- 主附险标志（0：主险，1附加险 )
	insurance_classify varchar(40) NOT NULL, -- 险种分类:详见SYS_DICT_DATA表DICT_VALUE,DICT_LABEL字段,条件DICT_TYPE= sys_bankInsurance_insuranceType
	is_can_payall varchar(8) NOT NULL, -- 是否支持趸交（0：支持，1：不支持 )
	is_can_pay_part varchar(8) NOT NULL, -- 是否支持期交（0：支持，1：不支持 )
	is_part_buy varchar(8) NOT NULL, -- 是否按份购买（0：是，1：不是 )
	lowest_part numeric(10) NOT NULL, -- 最低购买份数
	trial_method varchar(8) NOT NULL, -- 保费试算方式(0：按保费算，1 按保额算  )
	trial_type varchar(8) NOT NULL, -- 保额/保费类型 (0：固定保额/保费,1：最低保额/保费 )
	trialamt numeric(17, 2) NOT NULL, -- 保额/保费
	insurance_status varchar(8) NOT NULL, -- 险种状态（0：正常 ，1 失效 )
	insurance_remark varchar(2000) NULL, -- 险种描述
	create_time sys."date" NULL, -- 新增时间（yyyyMMdd HH:mm:ss )
	create_user varchar(200) NULL, -- 新增用户编号
	create_user_name varchar(800) NULL, -- 新增用户名
	update_time sys."date" NULL, -- 最近一次修改时间（yyyyMMdd HH:mm:ss )
	update_user varchar(200) NULL, -- 最近一次修改用户编号
	update_user_name varchar(800) NULL, -- 最近一次修改用户名
	accumulation_amt numeric(17, 2) NULL, -- 保额/保费单次累加金额
	sttlmnt_pymnt_age varchar(40) NULL, -- 年金起领年龄
	auto_pay_show_flag varchar(40) NULL, -- 垫交方式选择标识
	sttlmnt_pymnt_freq varchar(40) NULL, -- 年金领取频率(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)
	sttlmnt_pymnt_type varchar(40) NULL, -- 年金领取方式(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)
	sttlmnt_pymnt_end_age varchar(40) NULL, -- 年金止领年龄
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_id IS '险种ID';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.item_id IS '保险公司编号（项目编号 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.item_name IS '保险公司名称（项目名称 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_code IS '险种代码';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.main_insurance_code IS '险种对应的主险种编码';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_name IS '险种名称';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_type IS '主附险标志（0：主险，1附加险 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_classify IS '险种分类:详见SYS_DICT_DATA表DICT_VALUE,DICT_LABEL字段,条件DICT_TYPE= sys_bankInsurance_insuranceType';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.is_can_payall IS '是否支持趸交（0：支持，1：不支持 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.is_can_pay_part IS '是否支持期交（0：支持，1：不支持 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.is_part_buy IS '是否按份购买（0：是，1：不是 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.lowest_part IS '最低购买份数';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.trial_method IS '保费试算方式(0：按保费算，1 按保额算  )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.trial_type IS '保额/保费类型 (0：固定保额/保费,1：最低保额/保费 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.trialamt IS '保额/保费';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_status IS '险种状态（0：正常 ，1 失效 )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.insurance_remark IS '险种描述';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.create_time IS '新增时间（yyyyMMdd HH:mm:ss )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.create_user IS '新增用户编号';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.create_user_name IS '新增用户名';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.update_time IS '最近一次修改时间（yyyyMMdd HH:mm:ss )';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.update_user IS '最近一次修改用户编号';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.update_user_name IS '最近一次修改用户名';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.accumulation_amt IS '保额/保费单次累加金额';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.sttlmnt_pymnt_age IS '年金起领年龄';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.auto_pay_show_flag IS '垫交方式选择标识';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.sttlmnt_pymnt_freq IS '年金领取频率(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.sttlmnt_pymnt_type IS '年金领取方式(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.sttlmnt_pymnt_end_age IS '年金止领年龄';
COMMENT ON COLUMN crmdm.ibp_ybt_insurance_base_info.ryzd IS '冗余字段';


-- crmdm.ibp_ybt_policy_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_policy_base_info;

CREATE TABLE crmdm.ibp_ybt_policy_base_info (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号
	is_real varchar(8) NOT NULL, -- 是否是非实时出单:0：是 1：否
	cont_no varchar(200) NULL, -- 保险单号
	proposal_prt_no varchar(200) NOT NULL, -- 投保单号
	cont_prt_no varchar(200) NULL, -- 保单合同印刷号
	accept_date varchar(32) NOT NULL, -- 投保日期(yyyyMMdd )
	appointvali_date varchar(32) NULL, -- 保单预约生效日期(yyyyMMdd )
	vali_date varchar(32) NULL, -- 保单实际生效日期(yyyyMMdd )
	insuend_date varchar(32) NULL, -- 保单满期日期(yyyyMMdd )
	pay_start_date varchar(32) NULL, -- 保单首期缴费日期(yyyyMMdd )
	payend_date varchar(32) NULL, -- 保单缴费满期日期(yyyyMMdd )
	product_id varchar(200) NOT NULL, -- 投保产品Id
	product_name varchar(800) NOT NULL, -- 投保产品名称
	cont_status varchar(8) NOT NULL, -- 保单状态:0：未生效 1：正常（新单承保、正常续期中） 2：失效（当日撤单，犹豫期退保、犹豫期外退保、满期给付、理赔终止、其他终止）
	cont_source varchar(8) NOT NULL, -- 保单来源 :0：柜面 1：手机银行
	risk_grade varchar(8) NOT NULL, -- 最高可承受风险等级：1：极低 2：低 3：中 4：高 5：极高
	commission_type varchar(8) NOT NULL, -- 承保手续费收取方式：0:不涉及 1:按保额收取 2:按保费收取
	commission_ratio numeric(6, 3) NULL, -- 手续费比例(% )
	commissionamt numeric(17, 2) NULL, -- 保单承保手续费
	acc_name varchar(200) NOT NULL, -- 账户姓名
	acc_no varchar(200) NOT NULL, -- 银行账户
	get_pol_mode varchar(8) NULL, -- 保单递送方式：1:邮寄 2:柜面领取 3:上门递送 4:电子保单（针对电子渠道：网银、手机银行、自助终端等） 5:部门发送
	throw_com varchar(200) NOT NULL, -- 投保网点代码
	throw_com_name varchar(800) NULL, -- 投保网点名称
	throw_com_certi_code varchar(200) NULL, -- 投保网点许可证
	teller_name varchar(800) NULL, -- 投保销售人员姓名
	teller_id varchar(80) NULL, -- 投保销售人员工号
	teller_certi_code varchar(200) NULL, -- 投保销售人员资格证
	teller_email varchar(200) NULL, -- 投保销售人员电子邮箱
	manager_no varchar(200) NULL, -- 投保网点分管代理保险负责人工号
	manager_name varchar(800) NULL, -- 投保网点分管代理保险负责人姓名
	agent_code varchar(200) NULL, -- 代理人编码
	agent_name varchar(800) NULL, -- 代理人姓名
	agent_grp_code varchar(200) NULL, -- 代理人组别编码
	agent_grp_name varchar(200) NULL, -- 代理人组别
	agent_com varchar(200) NULL, -- 代理网点编码
	agent_com_name varchar(800) NULL, -- 代理网点名称
	com_code varchar(200) NULL, -- 代理机构编码
	com_location varchar(800) NULL, -- 承保公司地址
	com_name varchar(800) NULL, -- 承保公司名称
	com_zip_code varchar(200) NULL, -- 承保公司邮编
	com_phone varchar(80) NULL, -- 保险公司热线
	job_notice varchar(8) NULL, -- 职业告知(是否从事风险置业): Y-是,N-否
	health_notice varchar(8) NULL, -- 健康告知(是否存在健康风险): Y-是,N-否
	policy_indicator varchar(8) NULL, -- 未成年被保险人在其他保险公司是否有投保Y-有，N-无
	total_faceamount numeric(17, 2) NULL, -- 未成年被保险人在其他保险公司累计投保身故保额
	hesitate_end_date varchar(32) NULL, -- 保单犹豫期结束日期
	acc_transfer_num varchar(200) NULL, -- 客户转账授权码
	acc_eff_date varchar(8) NULL, -- 客户银行卡有效日期
	quality_status varchar(2) NULL, -- 双录状态 0-未检查，1-合规，2-待整改，3-已整改待确认，4-已整改确认，99-新建，1-作废
	session_id varchar(800) NULL, -- 保单可回溯SessionId值
	plat_date varchar(8) NULL, -- 平台日期(yyyyMMdd)
	plat_time varchar(6) NULL, -- 平台时间(HHmmss)
	record_no varchar(256) NULL, -- 双录系统流水号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_ybt_policy_base_info PRIMARY KEY (plat_policy_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.item_id IS '中间业务缴费项目编号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.is_real IS '是否是非实时出单:0：是 1：否';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.proposal_prt_no IS '投保单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.cont_prt_no IS '保单合同印刷号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.accept_date IS '投保日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.appointvali_date IS '保单预约生效日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.vali_date IS '保单实际生效日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.insuend_date IS '保单满期日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.pay_start_date IS '保单首期缴费日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.payend_date IS '保单缴费满期日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.product_id IS '投保产品Id';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.product_name IS '投保产品名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.cont_status IS '保单状态:0：未生效 1：正常（新单承保、正常续期中） 2：失效（当日撤单，犹豫期退保、犹豫期外退保、满期给付、理赔终止、其他终止）';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.cont_source IS '保单来源 :0：柜面 1：手机银行';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.risk_grade IS '最高可承受风险等级：1：极低 2：低 3：中 4：高 5：极高';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.commission_type IS '承保手续费收取方式：0:不涉及 1:按保额收取 2:按保费收取';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.commission_ratio IS '手续费比例(% )';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.commissionamt IS '保单承保手续费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.acc_name IS '账户姓名';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.acc_no IS '银行账户';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.get_pol_mode IS '保单递送方式：1:邮寄 2:柜面领取 3:上门递送 4:电子保单（针对电子渠道：网银、手机银行、自助终端等） 5:部门发送';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.throw_com IS '投保网点代码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.throw_com_name IS '投保网点名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.throw_com_certi_code IS '投保网点许可证';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.teller_name IS '投保销售人员姓名';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.teller_id IS '投保销售人员工号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.teller_certi_code IS '投保销售人员资格证';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.teller_email IS '投保销售人员电子邮箱';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.manager_no IS '投保网点分管代理保险负责人工号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.manager_name IS '投保网点分管代理保险负责人姓名';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.agent_code IS '代理人编码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.agent_name IS '代理人姓名';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.agent_grp_code IS '代理人组别编码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.agent_grp_name IS '代理人组别';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.agent_com IS '代理网点编码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.agent_com_name IS '代理网点名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.com_code IS '代理机构编码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.com_location IS '承保公司地址';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.com_name IS '承保公司名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.com_zip_code IS '承保公司邮编';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.com_phone IS '保险公司热线';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.job_notice IS '职业告知(是否从事风险置业): Y-是,N-否';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.health_notice IS '健康告知(是否存在健康风险): Y-是,N-否';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.policy_indicator IS '未成年被保险人在其他保险公司是否有投保Y-有，N-无';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.total_faceamount IS '未成年被保险人在其他保险公司累计投保身故保额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.hesitate_end_date IS '保单犹豫期结束日期';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.acc_transfer_num IS '客户转账授权码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.acc_eff_date IS '客户银行卡有效日期';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.quality_status IS '双录状态 0-未检查，1-合规，2-待整改，3-已整改待确认，4-已整改确认，99-新建，1-作废';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.session_id IS '保单可回溯SessionId值';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.plat_date IS '平台日期(yyyyMMdd)';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.plat_time IS '平台时间(HHmmss)';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.record_no IS '双录系统流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_base_info.ryzd IS '冗余字段';


-- crmdm.ibp_ybt_policy_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_policy_fee_list;

CREATE TABLE crmdm.ibp_ybt_policy_fee_list (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	cont_no varchar(200) NULL, -- 保险单号
	ord_item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号：104001：大家  104002：和谐 104003：太平洋 104004：中国人寿
	ord_type varchar(16) NOT NULL, -- 中间业务订单类型:PY-消费,RE-退款
	ord_id varchar(200) NOT NULL, -- 中间业务订单号
	ord_ori_id varchar(200) NULL, -- 中间业务原订单号
	ord_memo varchar(2000) NULL, -- 中间业务订单描述
	ord_amt numeric(17, 2) NULL, -- 订单总保费
	pre_amt numeric(17, 2) NULL, -- 中间业务订单总保额
	ord_create_date varchar(32) NULL, -- 中间业务订单创建日期
	ord_create_time varchar(24) NULL, -- 中间业务订单创建时间
	ord_expires_date varchar(32) NULL, -- 中间业务订单过期日期
	ord_expires_time varchar(24) NULL, -- 中间业务订单过期时间
	ord_pay_serial varchar(200) NULL, -- 中间业务订单支付/退款流水号
	ord_link_user_name varchar(800) NULL, -- 中间业务订单用户名称
	ord_link_user_phone varchar(200) NULL, -- 中间业务订单用户联系方式
	ordpayeracc_no varchar(200) NULL, -- 付款账户
	ordpayeracc_name varchar(800) NULL, -- 付款账户名称
	ordpayer_bank_no varchar(200) NULL, -- 付款银行行号
	ordpayer_bank_name varchar(800) NULL, -- 付款银行名称
	ord_payee_acct_no varchar(200) NULL, -- 中间业务订单收款账户
	ord_payee_acct_name varchar(800) NULL, -- 中间业务订单收款账户名称
	ord_payee_bank_no varchar(200) NULL, -- 付款银行行号
	ord_payee_bank_name varchar(800) NULL, -- 付款银行名称
	ord_part_pay_flag varchar(8) NULL, -- 中间业务订单允许部分支付标识:0-不允许,1-允许
	ord_thr_sum_amt numeric(17, 2) NULL, -- 中间业务订单关联的第三方订单/缴费号的总金额
	ord_thr_payed_amt numeric(17, 2) NOT NULL, -- 中间业务订单关联的第三方订单/缴费号的已支付金额
	ord_tran_status varchar(8) NULL, -- 交易状态：0:未缴费 1:缴费处理中 2:缴费成功 3:缴费失败
	tran_type varchar(8) NULL, -- 交易类型：0:新单承保 1:续期缴费 2:已当日撤单 3:犹豫期退保 4:犹豫期外退保 5:满期给付 6:理赔终止 7保险公司其他保全 8：终止撤销 9：复效
	tran_soure varchar(8) NOT NULL, -- 交易渠道：1：柜面 2：手机银行 3：保险公司
	prem_text varchar(200) NULL, -- 交易金额大写
	trans_no varchar(200) NULL, -- 保险公司交易流水号
	hole_memo1 varchar(800) NULL, -- 备用字段1
	hole_memo2 varchar(800) NULL, -- 备用字段2
	hole_memo3 varchar(800) NULL, -- 备用字段3
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ibp_ybt_policy_fee_list PRIMARY KEY (plat_policy_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_item_id IS '中间业务缴费项目编号：104001：大家  104002：和谐 104003：太平洋 104004：中国人寿';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_type IS '中间业务订单类型:PY-消费,RE-退款';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_id IS '中间业务订单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_ori_id IS '中间业务原订单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_memo IS '中间业务订单描述';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_amt IS '订单总保费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.pre_amt IS '中间业务订单总保额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_create_date IS '中间业务订单创建日期';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_create_time IS '中间业务订单创建时间';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_expires_date IS '中间业务订单过期日期';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_expires_time IS '中间业务订单过期时间';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_pay_serial IS '中间业务订单支付/退款流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_link_user_name IS '中间业务订单用户名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_link_user_phone IS '中间业务订单用户联系方式';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayeracc_no IS '付款账户';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayeracc_name IS '付款账户名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayer_bank_no IS '付款银行行号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ordpayer_bank_name IS '付款银行名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_acct_no IS '中间业务订单收款账户';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_acct_name IS '中间业务订单收款账户名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_bank_no IS '付款银行行号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_payee_bank_name IS '付款银行名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_part_pay_flag IS '中间业务订单允许部分支付标识:0-不允许,1-允许';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_thr_sum_amt IS '中间业务订单关联的第三方订单/缴费号的总金额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_thr_payed_amt IS '中间业务订单关联的第三方订单/缴费号的已支付金额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ord_tran_status IS '交易状态：0:未缴费 1:缴费处理中 2:缴费成功 3:缴费失败';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.tran_type IS '交易类型：0:新单承保 1:续期缴费 2:已当日撤单 3:犹豫期退保 4:犹豫期外退保 5:满期给付 6:理赔终止 7保险公司其他保全 8：终止撤销 9：复效';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.tran_soure IS '交易渠道：1：柜面 2：手机银行 3：保险公司';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.prem_text IS '交易金额大写';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.trans_no IS '保险公司交易流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.hole_memo1 IS '备用字段1';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.hole_memo2 IS '备用字段2';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.hole_memo3 IS '备用字段3';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_fee_list.ryzd IS '冗余字段';


-- crmdm.ibp_ybt_policy_insurance_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_policy_insurance_info;

CREATE TABLE crmdm.ibp_ybt_policy_insurance_info (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号
	cont_no varchar(200) NULL, -- 保险单号
	insurance_id varchar(200) NOT NULL, -- 险种ID
	insurance_code varchar(200) NOT NULL, -- 险种代码
	main_insurance_code varchar(200) NOT NULL, -- 险种对应的主险种编码
	insurance_name varchar(800) NOT NULL, -- 险种名称
	insurance_type varchar(8) NOT NULL, -- 主附险标志
	sum_buy_part numeric(10) NOT NULL, -- 投保份数
	sum_pre numeric(17, 2) NOT NULL, -- 险种总保额
	sum_cov numeric(17, 2) NOT NULL, -- 险种总保费
	pay_type varchar(8) NOT NULL, -- 缴费类型:0-趸交,1-期缴
	pay_freq varchar(16) NULL, -- 期缴缴费频次(缴费类型为趸交时无值):12-年交,6-半年交,3-季交,1-月交,-1-不定期交
	pay_per_unit varchar(16) NULL, -- 期缴缴费周期计算单位(缴费类型为趸交时无值):12-按年计算,1-按月计算,2-按日计算,0-交至某确定年龄,-1-终生交费
	pay_per_num numeric(10) NULL, -- 期缴缴费周期计算数量
	valid_per_unit varchar(16) NOT NULL, -- 保险周期计算单位:12-按年计算,1-按月保计算,2-按日计算,0-保至某确定年龄,-1-保终身
	valid_per_num numeric(10) NOT NULL, -- 保险周期计算数量
	bonus_get_mode varchar(8) NULL, -- 红利领取方式:1-累计生息,3-抵交保费,4-现金领取,5-增额交清
	auto_pay_flag varchar(8) NULL, -- 自动垫交标志:0-否,1-是
	lxgetintv varchar(16) NULL, -- 万能险领取方式:0-趸领,1-月领,12-年领
	sttlmnt_pymnt_age varchar(40) NULL, -- 年金起领年龄
	sttlmnt_pymnt_freq varchar(40) NULL, -- 年金领取频率:使用YBT_INSURANCE_STTLMNT_INFO表存储
	sttlmnt_pymnt_type varchar(40) NULL, -- 年金领取方式:使用YBT_INSURANCE_STTLMNT_INFO表存储
	sttlmnt_pymnt_end_age varchar(40) NULL, -- 年金止领年龄
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.item_id IS '中间业务缴费项目编号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_id IS '险种ID';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_code IS '险种代码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.main_insurance_code IS '险种对应的主险种编码';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_name IS '险种名称';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.insurance_type IS '主附险标志';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sum_buy_part IS '投保份数';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sum_pre IS '险种总保额';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sum_cov IS '险种总保费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_type IS '缴费类型:0-趸交,1-期缴';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_freq IS '期缴缴费频次(缴费类型为趸交时无值):12-年交,6-半年交,3-季交,1-月交,-1-不定期交';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_per_unit IS '期缴缴费周期计算单位(缴费类型为趸交时无值):12-按年计算,1-按月计算,2-按日计算,0-交至某确定年龄,-1-终生交费';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.pay_per_num IS '期缴缴费周期计算数量';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.valid_per_unit IS '保险周期计算单位:12-按年计算,1-按月保计算,2-按日计算,0-保至某确定年龄,-1-保终身';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.valid_per_num IS '保险周期计算数量';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.bonus_get_mode IS '红利领取方式:1-累计生息,3-抵交保费,4-现金领取,5-增额交清';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.auto_pay_flag IS '自动垫交标志:0-否,1-是';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.lxgetintv IS '万能险领取方式:0-趸领,1-月领,12-年领';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_age IS '年金起领年龄';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_freq IS '年金领取频率:使用YBT_INSURANCE_STTLMNT_INFO表存储';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_type IS '年金领取方式:使用YBT_INSURANCE_STTLMNT_INFO表存储';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.sttlmnt_pymnt_end_age IS '年金止领年龄';
COMMENT ON COLUMN crmdm.ibp_ybt_policy_insurance_info.ryzd IS '冗余字段';


-- crmdm.ibp_ybt_product_branch 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_product_branch;

CREATE TABLE crmdm.ibp_ybt_product_branch (
	product_id varchar(200) NOT NULL, -- 产品ID
	branch_no varchar(200) NOT NULL, -- 网点编码
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_product_branch.product_id IS '产品ID';
COMMENT ON COLUMN crmdm.ibp_ybt_product_branch.branch_no IS '网点编码';
COMMENT ON COLUMN crmdm.ibp_ybt_product_branch.ryzd IS '冗余字段';


-- crmdm.ibp_ybt_product_info 定义

-- Drop table

-- DROP TABLE crmdm.ibp_ybt_product_info;

CREATE TABLE crmdm.ibp_ybt_product_info (
	product_id varchar(200) NOT NULL, -- 产品ID
	item_id varchar(40) NOT NULL, -- 保险公司编号(项目编号）
	item_name varchar(800) NOT NULL, -- 保险公司名称(项目名称）
	product_name varchar(800) NOT NULL, -- 产品名称
	commission_type varchar(8) NOT NULL, -- 收取类型：0-不涉及,1-按保额收取,2-按保费收取
	commission_ratio numeric(6, 3) NOT NULL, -- 手续费比例(%）
	risk_grade varchar(8) NOT NULL, -- 产品风险等级
	product_big_type varchar(40) NOT NULL, -- 产品监管大分类编码
	product_lit_type varchar(40) NOT NULL, -- 产品监管小分类编码
	product_remark varchar(2000) NULL, -- 产品描述
	product_status varchar(8) NOT NULL, -- 产品状态:0-正常,1-失效
	create_time sys."date" NULL, -- 新增时间(yyyyMMdd HH:mm:ss）
	create_user varchar(200) NOT NULL, -- 新增用户编号
	create_user_name varchar(800) NULL, -- 新增用户名
	update_time sys."date" NULL, -- 最近一次修改时间(yyyyMMdd HH:mm:ss）
	update_user varchar(200) NULL, -- 最近一次修改用户编号
	update_user_name varchar(800) NULL, -- 最近一次修改用户名
	is_recommend varchar(2) NULL, -- 是否主推产品: 1:是 0:否
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_id IS '产品ID';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.item_id IS '保险公司编号(项目编号）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.item_name IS '保险公司名称(项目名称）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_name IS '产品名称';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.commission_type IS '收取类型：0-不涉及,1-按保额收取,2-按保费收取';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.commission_ratio IS '手续费比例(%）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.risk_grade IS '产品风险等级';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_big_type IS '产品监管大分类编码';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_lit_type IS '产品监管小分类编码';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_remark IS '产品描述';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.product_status IS '产品状态:0-正常,1-失效';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.create_time IS '新增时间(yyyyMMdd HH:mm:ss）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.create_user IS '新增用户编号';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.create_user_name IS '新增用户名';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.update_time IS '最近一次修改时间(yyyyMMdd HH:mm:ss）';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.update_user IS '最近一次修改用户编号';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.update_user_name IS '最近一次修改用户名';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.is_recommend IS '是否主推产品: 1:是 0:否';
COMMENT ON COLUMN crmdm.ibp_ybt_product_info.ryzd IS '冗余字段';


-- crmdm.mbk_cust_acct 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_acct;

CREATE TABLE crmdm.mbk_cust_acct (
	cust_no varchar(32) NOT NULL, -- 电子银行客户号
	acct varchar(32) NOT NULL, -- 卡号
	acct_lvl varchar(2) NOT NULL, -- 账户等级 1：一类户（电子账户），借记卡默认为一类户 2：二类户（电子账户） 3：三类户（电子账户）
	acct_open_org varchar(16) NULL, -- 账户开户机构
	acct_type bpchar(1) NOT NULL, -- 账户类型(卡折标识) 1：借记卡 2：电子账户 3：信用卡 4：账户（可能有些行支持存折加挂）
	acct_alias varchar(64) NULL, -- 账户别名
	is_deft_acct bpchar(1) NOT NULL, -- 是否默认账户 N：非默认账户 Y：默认账号
	acct_sort numeric NOT NULL, -- 账户显示排序
	sub_acct varchar(32) NULL, -- 活期主账号（有些系统可能会需要存储卡号对应的活期账户）
	acct_open_way bpchar(1) NOT NULL, -- 开通方式：1借记卡验密绑定（借记卡）  2-柜面 3-线上人脸识别（电子账户）、4-线上VTM（电子账户）
	acct_add_chnl varchar(3) NOT NULL, -- 下挂渠道:MB手机银行TB柜面
	acct_add_date varchar(10) NOT NULL, -- 下挂日期
	acct_add_time varchar(8) NOT NULL, -- 下挂时间
	is_town bpchar(1) NULL, -- 村镇银行标识 0:非村镇银行1:村镇银行
	is_sign bpchar(1) NOT NULL, -- 是否签约短信通1-签约 0-没签约
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_acct PRIMARY KEY (cust_no, acct)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_acct.cust_no IS '电子银行客户号';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct IS '卡号';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_lvl IS '账户等级 1：一类户（电子账户），借记卡默认为一类户 2：二类户（电子账户） 3：三类户（电子账户）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_open_org IS '账户开户机构';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_type IS '账户类型(卡折标识) 1：借记卡 2：电子账户 3：信用卡 4：账户（可能有些行支持存折加挂）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_alias IS '账户别名';
COMMENT ON COLUMN crmdm.mbk_cust_acct.is_deft_acct IS '是否默认账户 N：非默认账户 Y：默认账号';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_sort IS '账户显示排序';
COMMENT ON COLUMN crmdm.mbk_cust_acct.sub_acct IS '活期主账号（有些系统可能会需要存储卡号对应的活期账户）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_open_way IS '开通方式：1借记卡验密绑定（借记卡）  2-柜面 3-线上人脸识别（电子账户）、4-线上VTM（电子账户）';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_add_chnl IS '下挂渠道:MB手机银行TB柜面';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_add_date IS '下挂日期';
COMMENT ON COLUMN crmdm.mbk_cust_acct.acct_add_time IS '下挂时间';
COMMENT ON COLUMN crmdm.mbk_cust_acct.is_town IS '村镇银行标识 0:非村镇银行1:村镇银行';
COMMENT ON COLUMN crmdm.mbk_cust_acct.is_sign IS '是否签约短信通1-签约 0-没签约';
COMMENT ON COLUMN crmdm.mbk_cust_acct.ryzd IS '冗余字段';


-- crmdm.mbk_cust_detail_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_detail_info;

CREATE TABLE crmdm.mbk_cust_detail_info (
	cust_no varchar(32) NULL, -- 电子银行客户号
	ecif_no varchar(32) NULL, -- ECIF客户号
	ecif_mobile varchar(11) NULL, -- ECIF手机号
	idt_end_date varchar(10) NULL, -- 证件到期日
	cust_eng_name varchar(60) NULL, -- 英文名
	cust_sex bpchar(1) NULL, -- 性别
	cust_birth varchar(20) NULL, -- 出生日期
	cust_contact_tel varchar(20) NULL, -- 联系电话
	cust_addr varchar(200) NULL, -- 联系地址
	cust_zip_code varchar(6) NULL, -- 邮编
	cust_email varchar(50) NULL, -- 电子邮箱
	cust_is_emp bpchar(1) NULL, -- 员工标识
	portrait_url varchar(200) NULL, -- 上传头像URL
	cust_manager varchar(32) NULL, -- 客户经理编号
	cust_mem_lvl varchar(2) NULL, -- 客户会员等级
	cust_growth int4 NULL, -- 客户成长值
	cust_credit int4 NULL, -- 客户信用度
	cust_mkt_org_no varchar(16) NULL, -- 客户营销机构
	ryzd varchar(1) NULL
);
COMMENT ON TABLE crmdm.mbk_cust_detail_info IS '客户详细信息';

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_no IS '电子银行客户号';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.ecif_no IS 'ECIF客户号    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.ecif_mobile IS 'ECIF手机号    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.idt_end_date IS '证件到期日    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_eng_name IS '英文名        ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_sex IS '性别          ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_birth IS '出生日期      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_contact_tel IS '联系电话      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_addr IS '联系地址      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_zip_code IS '邮编          ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_email IS '电子邮箱      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_is_emp IS '员工标识      ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.portrait_url IS '上传头像URL   ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_manager IS '客户经理编号  ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_mem_lvl IS '客户会员等级  ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_growth IS '客户成长值    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_credit IS '客户信用度    ';
COMMENT ON COLUMN crmdm.mbk_cust_detail_info.cust_mkt_org_no IS '客户营销机构  ';


-- crmdm.mbk_cust_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_info;

CREATE TABLE crmdm.mbk_cust_info (
	cust_no varchar(32) NOT NULL, -- 客户号
	cert_id varchar(64) NULL, -- 证书ID
	incorp_no varchar(16) NULL, -- 法人编号
	cust_core_no varchar(16) NULL, -- 核心客户号
	cust_name varchar(64) NULL, -- 客户姓名
	cust_cert_type varchar(6) NULL, -- 证件类型（建议按照核心或ECIF证件类型规则）
	cust_cert_no varchar(80) NULL, -- 证件号码
	cust_mobile varchar(11) NOT NULL, -- 签约手机号(交易认证使用)
	cust_lgn_name varchar(32) NULL, -- 登录用户名
	cust_cap_lvl varchar(2) NOT NULL, -- 客户等级 01-1级 02-2级 03-3级
	cust_is_idtfy_verify bpchar(1) NOT NULL, -- 是否实名认证/是否开通网银(Y-是;N-否)
	cust_org_no varchar(16) NULL, -- 客户归属机构
	cust_open_date varchar(10) NOT NULL, -- 客户开通日期
	cust_open_time varchar(8) NOT NULL, -- 客户开通时间
	cust_open_chnl varchar(3) NOT NULL, -- 首次开通渠道MB:手机 NB:网银 TB:柜面 DB:直销银行
	cust_status bpchar(1) NOT NULL, -- 客户状态(0:注销1: 正常2: 累计密码错误冻结3： 柜面冻结4: 被占用（手机号被重复注册时用）)
	cust_freeze_date varchar(10) NULL, -- 冻结日期
	cust_freeze_time varchar(8) NULL, -- 冻结时间
	cust_close_date varchar(10) NULL, -- 注销日期
	cust_close_time varchar(8) NULL, -- 注销时间
	cust_idtfy_verify_num varchar(10) NULL, -- 实名认证错误次数
	cust_is_old bpchar(1) NULL, -- 是否为老用户(0:是 1:否 2:柜面)
	cust_old_password bpchar(1) NULL, -- 旧密码是否更新(0:是 1:否)
	encrypt_type bpchar(1) NULL, -- 加密方式1:SM3 2:MD5 3:INIT
	is_first varchar(1) NULL, -- 第一次使用互转Y:是N:否
	user_last_login_date varchar(10) NULL, -- 最近登录日期
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_info PRIMARY KEY (cust_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_cust_info.cert_id IS '证书ID';
COMMENT ON COLUMN crmdm.mbk_cust_info.incorp_no IS '法人编号';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_core_no IS '核心客户号';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_name IS '客户姓名';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_cert_type IS '证件类型（建议按照核心或ECIF证件类型规则）';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_cert_no IS '证件号码';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_mobile IS '签约手机号(交易认证使用)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_lgn_name IS '登录用户名';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_cap_lvl IS '客户等级 01-1级 02-2级 03-3级';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_is_idtfy_verify IS '是否实名认证/是否开通网银(Y-是;N-否)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_org_no IS '客户归属机构';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_open_date IS '客户开通日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_open_time IS '客户开通时间';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_open_chnl IS '首次开通渠道MB:手机 NB:网银 TB:柜面 DB:直销银行';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_status IS '客户状态(0:注销1: 正常2: 累计密码错误冻结3： 柜面冻结4: 被占用（手机号被重复注册时用）)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_freeze_date IS '冻结日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_freeze_time IS '冻结时间';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_close_date IS '注销日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_close_time IS '注销时间';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_idtfy_verify_num IS '实名认证错误次数';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_is_old IS '是否为老用户(0:是 1:否 2:柜面)';
COMMENT ON COLUMN crmdm.mbk_cust_info.cust_old_password IS '旧密码是否更新(0:是 1:否)';
COMMENT ON COLUMN crmdm.mbk_cust_info.encrypt_type IS '加密方式1:SM3 2:MD5 3:INIT';
COMMENT ON COLUMN crmdm.mbk_cust_info.is_first IS '第一次使用互转Y:是N:否';
COMMENT ON COLUMN crmdm.mbk_cust_info.user_last_login_date IS '最近登录日期';
COMMENT ON COLUMN crmdm.mbk_cust_info.ryzd IS '冗余字段';


-- crmdm.mbk_cust_log_fee 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_log_fee;

CREATE TABLE crmdm.mbk_cust_log_fee (
	tran_sn varchar(32) NOT NULL, -- 交易流水号
	cust_name varchar(64) NULL, -- 客户名称
	item_id varchar(100) NULL, -- 项目编号
	tran_type varchar(5) NULL, -- 0:水电气1:校园缴费2:小程序3:社保 4:党员缴费5:非税6:校园一卡通7:资金维修11:非税
	ccy varchar(30) NOT NULL, -- 币种
	tran_date varchar(10) NULL, -- 交易日期
	tran_time varchar(8) NULL, -- 交易时间
	acct varchar(32) NULL, -- 卡号
	tran_amt varchar(20) NULL, -- 金额
	tran_method bpchar(1) NULL, -- 充值方式,0:现金1:转账
	discount_num varchar(50) NULL, -- 优惠号码
	tran_status varchar(2) NULL, -- 交易状态 1-成功2-失败3-状态未知
	discount_type varchar(20) NULL, -- 优惠类型
	discount_amt varchar(20) NULL, -- 优惠金额
	discount_remark varchar(100) NULL, -- 优惠描述
	cust_no varchar(32) NULL, -- 客户号
	dept_id varchar(50) NULL, -- 机构ID
	order_no varchar(50) NULL, -- 订单号
	prod_id varchar(60) NULL, -- 商品ID
	prod_name varchar(60) NULL, -- 商品名称
	student_name varchar(20) NULL, -- 学生姓名（校园缴费）
	pay_name varchar(20) NULL, -- 缴费户名
	pay_no varchar(40) NULL, -- 缴费户号
	pay_sub varchar(5) NULL, -- 党费缴费记录版本区别标识：1-新版本记录
	pay_term varchar(20) NULL, -- 缴费期次
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_log_fee PRIMARY KEY (tran_sn)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_sn IS '交易流水号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.item_id IS '项目编号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_type IS '0:水电气1:校园缴费2:小程序3:社保 4:党员缴费5:非税6:校园一卡通7:资金维修11:非税';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.ccy IS '币种';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_date IS '交易日期';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_time IS '交易时间';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.acct IS '卡号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_amt IS '金额';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_method IS '充值方式,0:现金1:转账';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_num IS '优惠号码';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.tran_status IS '交易状态 1-成功2-失败3-状态未知';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_type IS '优惠类型';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_amt IS '优惠金额';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.discount_remark IS '优惠描述';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.dept_id IS '机构ID';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.order_no IS '订单号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.prod_id IS '商品ID';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.prod_name IS '商品名称';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.student_name IS '学生姓名（校园缴费）';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_name IS '缴费户名';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_no IS '缴费户号';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_sub IS '党费缴费记录版本区别标识：1-新版本记录';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.pay_term IS '缴费期次';
COMMENT ON COLUMN crmdm.mbk_cust_log_fee.ryzd IS '冗余字段';


-- crmdm.mbk_cust_log_login 定义

-- Drop table

-- DROP TABLE crmdm.mbk_cust_log_login;

CREATE TABLE crmdm.mbk_cust_log_login (
	tran_sn varchar(32) NOT NULL, -- 流水号
	cust_no varchar(32) NOT NULL, -- 电子银行客户号
	lgn_date varchar(10) NOT NULL, -- 登录日期（YYYY-MM-DD）
	lgn_time varchar(8) NOT NULL, -- 登录时间(HH:MM:SS)
	lgt_date_time varchar(20) NULL, -- 退出时间(YYYY-MM-DD HH:MM:SS)
	lgt_type varchar(6) NULL, -- 登录方式( GS:手势  FG:指纹 FC:人脸 PW：密码)
	lgn_status varchar(2) NOT NULL, -- 登录状态(1:成功 0：失败)
	lgn_err_code varchar(32) NULL, -- 登录失败错误码
	lgn_err_msg varchar(150) NULL, -- 登录失败原因
	lgn_chnl varchar(3) NULL, -- 登录渠道
	lgn_addr varchar(64) NULL, -- 登录城市
	lgn_ip varchar(15) NULL, -- 登录的IP
	lgn_mac varchar(128) NULL, -- 登录MAC地址
	lgn_client_id varchar(128) NULL, -- 登录设备唯一编号
	lgn_sess_id varchar(64) NULL, -- 登录会话编号
	lgn_os varchar(64) NULL, -- 登录操作系统
	lgn_client_type bpchar(1) NULL, -- 登录客户端类型(A:安卓 ,I:苹果)
	lgn_client_ver varchar(10) NULL, -- 登录客户端版本号
	lgn_x_line varchar(10) NULL, -- 经度
	lgn_y_line varchar(10) NULL, -- 纬度
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_cust_log_login PRIMARY KEY (tran_sn, cust_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_cust_log_login.tran_sn IS '流水号';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.cust_no IS '电子银行客户号';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_date IS '登录日期（YYYY-MM-DD）';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_time IS '登录时间(HH:MM:SS)';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgt_date_time IS '退出时间(YYYY-MM-DD HH:MM:SS)';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgt_type IS '登录方式( GS:手势  FG:指纹 FC:人脸 PW：密码)';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_status IS '登录状态(1:成功 0：失败)';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_err_code IS '登录失败错误码';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_err_msg IS '登录失败原因';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_chnl IS '登录渠道';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_addr IS '登录城市';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_ip IS '登录的IP';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_mac IS '登录MAC地址';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_client_id IS '登录设备唯一编号';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_sess_id IS '登录会话编号';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_os IS '登录操作系统';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_client_type IS '登录客户端类型(A:安卓 ,I:苹果)';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_client_ver IS '登录客户端版本号';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_x_line IS '经度';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.lgn_y_line IS '纬度';
COMMENT ON COLUMN crmdm.mbk_cust_log_login.ryzd IS '冗余字段';


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


-- crmdm.mbk_mkp_jl_cust 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_jl_cust;

CREATE TABLE crmdm.mbk_mkp_jl_cust (
	ecif_no varchar(16) NOT NULL, -- 核心客户号
	user_id varchar(64) NOT NULL, -- 权益用户号
	tran_date varchar(10) NULL, -- 获取日期
	tran_time varchar(10) NULL, -- 获取时间
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_jl_cust PRIMARY KEY (ecif_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.ecif_no IS '核心客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.user_id IS '权益用户号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.tran_date IS '获取日期';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.tran_time IS '获取时间';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_cust.ryzd IS '冗余字段';


-- crmdm.mbk_mkp_jl_join_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_jl_join_info;

CREATE TABLE crmdm.mbk_mkp_jl_join_info (
	tran_no varchar(32) NOT NULL, -- 记录流水号
	order_id varchar(64) NOT NULL, -- 订单号
	user_id varchar(64) NULL, -- 用户id
	tran_date varchar(10) NULL, -- 日期
	tran_time varchar(10) NULL, -- 时间
	acti_no varchar(64) NULL, -- 活动编号
	chnl varchar(6) NULL, -- 渠道
	crm_lvl varchar(20) NULL, -- CRM等级
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_jl_join_info PRIMARY KEY (order_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.tran_no IS '记录流水号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.order_id IS '订单号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.user_id IS '用户id';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.tran_date IS '日期';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.tran_time IS '时间';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.acti_no IS '活动编号';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.chnl IS '渠道';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.crm_lvl IS 'CRM等级';
COMMENT ON COLUMN crmdm.mbk_mkp_jl_join_info.ryzd IS '冗余字段';


-- crmdm.mbk_mkp_process_info 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_process_info;

CREATE TABLE crmdm.mbk_mkp_process_info (
	trans_sn varchar(128) NOT NULL, -- 交易流水号
	sence_status varchar(1) NULL, -- 场景状态
	sence_code varchar(10) NULL, -- 场景码
	sence_value varchar(10) NULL, -- 场景值
	sence_time varchar(20) NULL, -- 场景时间
	cust_no varchar(32) NULL, -- 客户号
	cust_lvl varchar(6) NULL, -- 客户等级
	cust_org varchar(20) NULL, -- 客户归属机构
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_process_info PRIMARY KEY (trans_sn)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_process_info.trans_sn IS '交易流水号';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_status IS '场景状态';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_code IS '场景码';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_value IS '场景值';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.sence_time IS '场景时间';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.cust_lvl IS '客户等级';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.cust_org IS '客户归属机构';
COMMENT ON COLUMN crmdm.mbk_mkp_process_info.ryzd IS '冗余字段';


-- crmdm.mbk_mkp_rebat_recode 定义

-- Drop table

-- DROP TABLE crmdm.mbk_mkp_rebat_recode;

CREATE TABLE crmdm.mbk_mkp_rebat_recode (
	acti_no varchar(32) NOT NULL, -- 折扣活动编号
	cust_no varchar(32) NULL, -- 客户号
	user_time varchar(32) NULL, -- 使用时间
	sence_code varchar(16) NULL, -- 使用场景码
	rebat_value numeric(22, 2) NULL, -- 折扣金额
	status bpchar(1) NULL, -- 记录状态(0-未使用  1-已使用  2-已对账  3-已失效)
	recode_no varchar(32) NOT NULL, -- 记录编号
	trans_amt numeric(22, 2) NULL, -- 交易金额
	payed_value numeric(22, 2) NULL, -- 客户实际支付金额
	refund_remark varchar(3000) NULL, -- 退款备注
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_mbk_mkp_rebat_recode PRIMARY KEY (recode_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.acti_no IS '折扣活动编号';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.cust_no IS '客户号';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.user_time IS '使用时间';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.sence_code IS '使用场景码';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.rebat_value IS '折扣金额';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.status IS '记录状态(0-未使用  1-已使用  2-已对账  3-已失效)';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.recode_no IS '记录编号';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.trans_amt IS '交易金额';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.payed_value IS '客户实际支付金额';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.refund_remark IS '退款备注';
COMMENT ON COLUMN crmdm.mbk_mkp_rebat_recode.ryzd IS '冗余字段';


-- crmdm.prc_logs 定义

-- Drop table

-- DROP TABLE crmdm.prc_logs;

CREATE TABLE crmdm.prc_logs (
	logid numeric(20) NOT NULL, -- 日志主键
	prc_name varchar(80) NULL, -- 存储过程名称
	prc_desc varchar(300) NULL, -- 存储过程描述
	logdate varchar(8) NULL, -- 日志日期
	no_id varchar(10) NULL, -- 步骤编号
	bgn_date sys."date" NULL, -- 开始时间
	end_date sys."date" NULL, -- 结束时间
	dura_date numeric(10) NULL, -- 耗时
	logmsg varchar(1000) NULL, -- 日志内容
	log_flg numeric(10) NULL, -- 日志标志
	CONSTRAINT pk_prc_logs PRIMARY KEY (logid)
);
COMMENT ON TABLE crmdm.prc_logs IS '单步调试日志表';

-- Column comments

COMMENT ON COLUMN crmdm.prc_logs.logid IS '日志主键';
COMMENT ON COLUMN crmdm.prc_logs.prc_name IS '存储过程名称';
COMMENT ON COLUMN crmdm.prc_logs.prc_desc IS '存储过程描述';
COMMENT ON COLUMN crmdm.prc_logs.logdate IS '日志日期';
COMMENT ON COLUMN crmdm.prc_logs.no_id IS '步骤编号';
COMMENT ON COLUMN crmdm.prc_logs.bgn_date IS '开始时间';
COMMENT ON COLUMN crmdm.prc_logs.end_date IS '结束时间';
COMMENT ON COLUMN crmdm.prc_logs.dura_date IS '耗时';
COMMENT ON COLUMN crmdm.prc_logs.logmsg IS '日志内容';
COMMENT ON COLUMN crmdm.prc_logs.log_flg IS '日志标志';


-- crmdm.tmp1_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp1_dwd_acct_loan;

CREATE TABLE crmdm.tmp1_dwd_acct_loan (
	iou_no varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	loan_issu_amt numeric(24, 2) NULL,
	loan_issu_date varchar(10) NULL,
	bal numeric NULL,
	expr_date varchar(10) NULL,
	acct_state varchar(10) NULL,
	persn_legal_bk_code text NULL,
	repay_typ varchar(32) NULL,
	cate_5lvl varchar(10) NULL,
	int_arrears_ttl numeric NULL,
	customerid varchar(40) NULL,
	productid varchar(40) NULL,
	contractserialno varchar(40) NULL
);


-- crmdm.tmp1_dwd_cust_asse_liab 定义

-- Drop table

-- DROP TABLE crmdm.tmp1_dwd_cust_asse_liab;

CREATE TABLE crmdm.tmp1_dwd_cust_asse_liab (
	data_date varchar(8) NULL,
	cust_id varchar(20) NULL,
	org_id varchar(7) NULL,
	persn_legal_bk_code varchar(7) NULL,
	aum_bal_1 numeric NULL,
	depo_bal_1 numeric NULL,
	depo_curnt_depo_bal_1 numeric NULL,
	fixd_depo_bal_1 numeric NULL,
	lehui_bal_1 numeric NULL,
	largedp_bal_1 numeric NULL,
	fin_bal_1 numeric NULL,
	close_agen_fin_bal_1 numeric NULL,
	open_agen_fin_bal_1 numeric NULL,
	close_self_fin_bal_1 numeric NULL,
	open_self_fin_bal_1 numeric NULL,
	insur_bal_1 numeric NULL,
	loan_bal_1 numeric NULL,
	aum_bal_2 numeric NULL,
	depo_bal_2 numeric NULL,
	depo_curnt_depo_bal_2 numeric NULL,
	fixd_depo_bal_2 numeric NULL,
	lehui_bal_2 numeric NULL,
	largedp_bal_2 numeric NULL,
	fin_bal_2 numeric NULL,
	close_agen_fin_bal_2 numeric NULL,
	open_agen_fin_bal_2 numeric NULL,
	close_self_fin_bal_2 numeric NULL,
	open_self_fin_bal_2 numeric NULL,
	insur_bal_2 numeric NULL,
	loan_bal_2 numeric NULL,
	aum_bal_3 numeric NULL,
	depo_bal_3 numeric NULL,
	depo_curnt_depo_bal_3 numeric NULL,
	fixd_depo_bal_3 numeric NULL,
	lehui_bal_3 numeric NULL,
	largedp_bal_3 numeric NULL,
	fin_bal_3 numeric NULL,
	close_agen_fin_bal_3 numeric NULL,
	open_agen_fin_bal_3 numeric NULL,
	close_self_fin_bal_3 numeric NULL,
	open_self_fin_bal_3 numeric NULL,
	insur_bal_3 numeric NULL,
	loan_bal_3 numeric NULL,
	aum_bal_4 numeric NULL,
	depo_bal_4 numeric NULL,
	depo_curnt_depo_bal_4 numeric NULL,
	fixd_depo_bal_4 numeric NULL,
	lehui_bal_4 numeric NULL,
	largedp_bal_4 numeric NULL,
	fin_bal_4 numeric NULL,
	close_agen_fin_bal_4 numeric NULL,
	open_agen_fin_bal_4 numeric NULL,
	close_self_fin_bal_4 numeric NULL,
	open_self_fin_bal_4 numeric NULL,
	insur_bal_4 numeric NULL,
	loan_bal_4 numeric NULL
);


-- crmdm.tmp1_dws_cust_asse_liab 定义

-- Drop table

-- DROP TABLE crmdm.tmp1_dws_cust_asse_liab;

CREATE TABLE crmdm.tmp1_dws_cust_asse_liab (
	data_date varchar(8) NULL,
	cust_id varchar(20) NULL,
	org_id varchar(7) NULL,
	persn_legal_bk_code varchar(7) NULL,
	aum_bal_1 numeric NULL,
	depo_bal_1 numeric NULL,
	depo_curnt_depo_bal_1 numeric NULL,
	fixd_depo_bal_1 numeric NULL,
	lehui_bal_1 numeric NULL,
	largedp_bal_1 numeric NULL,
	fin_bal_1 numeric NULL,
	close_agen_fin_bal_1 numeric NULL,
	open_agen_fin_bal_1 numeric NULL,
	close_self_fin_bal_1 numeric NULL,
	open_self_fin_bal_1 numeric NULL,
	insur_bal_1 numeric NULL,
	loan_bal_1 numeric NULL,
	aum_bal_2 numeric NULL,
	depo_bal_2 numeric NULL,
	depo_curnt_depo_bal_2 numeric NULL,
	fixd_depo_bal_2 numeric NULL,
	lehui_bal_2 numeric NULL,
	largedp_bal_2 numeric NULL,
	fin_bal_2 numeric NULL,
	close_agen_fin_bal_2 numeric NULL,
	open_agen_fin_bal_2 numeric NULL,
	close_self_fin_bal_2 numeric NULL,
	open_self_fin_bal_2 numeric NULL,
	insur_bal_2 numeric NULL,
	loan_bal_2 numeric NULL,
	aum_bal_3 numeric NULL,
	depo_bal_3 numeric NULL,
	depo_curnt_depo_bal_3 numeric NULL,
	fixd_depo_bal_3 numeric NULL,
	lehui_bal_3 numeric NULL,
	largedp_bal_3 numeric NULL,
	fin_bal_3 numeric NULL,
	close_agen_fin_bal_3 numeric NULL,
	open_agen_fin_bal_3 numeric NULL,
	close_self_fin_bal_3 numeric NULL,
	open_self_fin_bal_3 numeric NULL,
	insur_bal_3 numeric NULL,
	loan_bal_3 numeric NULL,
	aum_bal_4 numeric NULL,
	depo_bal_4 numeric NULL,
	depo_curnt_depo_bal_4 numeric NULL,
	fixd_depo_bal_4 numeric NULL,
	lehui_bal_4 numeric NULL,
	largedp_bal_4 numeric NULL,
	fin_bal_4 numeric NULL,
	close_agen_fin_bal_4 numeric NULL,
	open_agen_fin_bal_4 numeric NULL,
	close_self_fin_bal_4 numeric NULL,
	open_self_fin_bal_4 numeric NULL,
	insur_bal_4 numeric NULL,
	loan_bal_4 numeric NULL
);


-- crmdm.tmp1_dws_cust_chnl_use 定义

-- Drop table

-- DROP TABLE crmdm.tmp1_dws_cust_chnl_use;

CREATE TABLE crmdm.tmp1_dws_cust_chnl_use (
	pk_id varchar(40) NOT NULL, -- 主键
	cust_id varchar(20) NOT NULL, -- 客户编号
	statis_typ varchar(1) NOT NULL, -- 统计口径
	chnl_cate varchar(10) NOT NULL, -- 渠道种类
	chnl_name varchar(100) NULL, -- 渠道名称
	use_cnt numeric(8) NULL, -- 使用次数
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	CONSTRAINT pk_tmp1_dws_cust_chnl_use PRIMARY KEY (cust_id, statis_typ, chnl_cate)
);
COMMENT ON TABLE crmdm.tmp1_dws_cust_chnl_use IS '客户渠道使用非动账临时表';

-- Column comments

COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.pk_id IS '主键';
COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.statis_typ IS '统计口径';
COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.chnl_cate IS '渠道种类';
COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.chnl_name IS '渠道名称';
COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.use_cnt IS '使用次数';
COMMENT ON COLUMN crmdm.tmp1_dws_cust_chnl_use.persn_legal_bk_code IS '法人行号';


-- crmdm.tmp2_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp2_dwd_acct_loan;

CREATE TABLE crmdm.tmp2_dwd_acct_loan (
	iou_no varchar(40) NULL,
	cust_id varchar(40) NULL,
	cust_typ text NULL
);


-- crmdm.tmp2_dws_cust_asse_liab 定义

-- Drop table

-- DROP TABLE crmdm.tmp2_dws_cust_asse_liab;

CREATE TABLE crmdm.tmp2_dws_cust_asse_liab (
	data_date varchar(8) NULL,
	cust_id varchar(20) NULL,
	persn_legal_bk_code varchar(7) NULL,
	org_id varchar NULL,
	org_id_loan varchar NULL
);


-- crmdm.tmp3_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp3_dwd_acct_loan;

CREATE TABLE crmdm.tmp3_dwd_acct_loan (
	iou_no varchar(40) NULL,
	acct_id varchar(40) NULL,
	repay_acct_no varchar(40) NULL
);


-- crmdm.tmp4_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp4_dwd_acct_loan;

CREATE TABLE crmdm.tmp4_dwd_acct_loan (
	iou_no varchar(40) NULL,
	prdkt_name varchar(80) NULL,
	prdkt_cate_big varchar(32) NULL
);


-- crmdm.tmp5_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp5_dwd_acct_loan;

CREATE TABLE crmdm.tmp5_dwd_acct_loan (
	iou_no varchar(40) NULL,
	rate_intri numeric(12, 8) NULL
);


-- crmdm.tmp6_dwd_acct_loan 定义

-- Drop table

-- DROP TABLE crmdm.tmp6_dwd_acct_loan;

CREATE TABLE crmdm.tmp6_dwd_acct_loan (
	iou_no varchar(40) NULL,
	oprt_org varchar(32) NULL
);


-- crmdm.tmp_cdr_dtl_aum_bal 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_aum_bal;

CREATE TABLE crmdm.tmp_cdr_dtl_aum_bal (
	stat_perd varchar(1) NULL,
	cust_id varchar(64) NULL,
	statis_typ varchar(1) NULL,
	aum_typ varchar(10) NULL,
	data_date varchar(8) NULL,
	aum_bal numeric(20, 2) NULL,
	persn_legal_bk_code varchar(32) NULL,
	org_id varchar(64) NULL
);


-- crmdm.tmp_cdr_dtl_cust_base 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_cust_base;

CREATE TABLE crmdm.tmp_cdr_dtl_cust_base (
	cust_id varchar(64) NULL,
	cust_name varchar(200) NULL,
	cust_lvl varchar(20) NULL,
	post_id varchar(64) NULL,
	persn_legal_bk_code varchar(64) NULL, -- 法人行号
	depo_curnt_depo_bal numeric(20, 2) NULL,
	fixd_depo_bal numeric(20, 2) NULL,
	fin_amt numeric(20, 2) NULL
);

-- Column comments

COMMENT ON COLUMN crmdm.tmp_cdr_dtl_cust_base.persn_legal_bk_code IS '法人行号';


-- crmdm.tmp_cdr_dtl_due_win 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_due_win;

CREATE TABLE crmdm.tmp_cdr_dtl_due_win (
	stat_perd varchar(1) NULL,
	bgn_dt sys."date" NULL,
	end_dt sys."date" NULL,
	cust_id varchar(64) NULL,
	statis_typ varchar(1) NULL,
	first_expr_dt sys."date" NULL,
	last_expr_dt sys."date" NULL,
	expr_amt numeric(20, 2) NULL,
	mature_ttl_amt numeric(20, 2) NULL,
	take_end_dt_30d sys."date" NULL,
	persn_legal_bk_code varchar(32) NULL,
	org_id varchar(64) NULL
);


-- crmdm.tmp_cdr_dtl_mature_src 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_mature_src;

CREATE TABLE crmdm.tmp_cdr_dtl_mature_src (
	cust_id varchar(64) NULL,
	statis_typ varchar(1) NULL,
	acct_id varchar(64) NULL,
	prdkt_id varchar(64) NULL,
	prdkt_name varchar(200) NULL,
	expr_amt numeric(20, 2) NULL,
	expr_dt sys."date" NULL,
	persn_legal_bk_code varchar(32) NULL,
	org_id varchar(64) NULL
);


-- crmdm.tmp_cdr_dtl_period 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_period;

CREATE TABLE crmdm.tmp_cdr_dtl_period (
	stat_perd varchar(1) NULL,
	bgn_dt sys."date" NULL,
	end_dt sys."date" NULL
);


-- crmdm.tmp_cdr_dtl_purchase_src 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_purchase_src;

CREATE TABLE crmdm.tmp_cdr_dtl_purchase_src (
	cust_id varchar(64) NULL,
	prdkt_typ varchar(10) NULL,
	buy_amt numeric(20, 2) NULL,
	buy_dt sys."date" NULL,
	persn_legal_bk_code varchar(32) NULL,
	org_id varchar(64) NULL
);


-- crmdm.tmp_cdr_dtl_take_amt 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_dtl_take_amt;

CREATE TABLE crmdm.tmp_cdr_dtl_take_amt (
	stat_perd varchar(1) NULL,
	cust_id varchar(64) NULL,
	statis_typ varchar(1) NULL,
	take_amt_30d numeric(20, 2) NULL,
	buy_depo_amt_30d numeric(20, 2) NULL,
	buy_fin_amt_30d numeric(20, 2) NULL,
	buy_insur_amt_30d numeric(20, 2) NULL,
	first_buy_dt_30d sys."date" NULL,
	persn_legal_bk_code varchar(32) NULL,
	org_id varchar(64) NULL
);


-- crmdm.tmp_cdr_stat_base 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_stat_base;

CREATE TABLE crmdm.tmp_cdr_stat_base (
	persn_legal_bk_code varchar(32) NULL,
	data_date varchar(8) NULL,
	stat_perd varchar(1) NULL,
	statis_typ varchar(1) NULL,
	cust_id varchar(64) NULL,
	org_id varchar(64) NULL,
	post_id varchar(64) NULL,
	expr_amt numeric(20, 2) NULL,
	mature_ttl_amt numeric(20, 2) NULL,
	take_rate_30d numeric(10, 4) NULL,
	cust_take_flg varchar(1) NULL,
	fixed_mature_tran_fin_amt numeric(20, 2) NULL,
	fixed_fin_mature_tran_insur_amt numeric(20, 2) NULL,
	fin_mature_tran_fixed_amt numeric(20, 2) NULL,
	frst_mature_pk_bf_day_aum_bal numeric(20, 2) NULL,
	curr_aum_bal numeric(20, 2) NULL
);


-- crmdm.tmp_cdr_stat_src 定义

-- Drop table

-- DROP TABLE crmdm.tmp_cdr_stat_src;

CREATE TABLE crmdm.tmp_cdr_stat_src (
	persn_legal_bk_code varchar(32) NULL,
	statis_obj varchar(64) NULL,
	data_date varchar(8) NULL,
	stat_perd varchar(1) NULL,
	statis_typ varchar(1) NULL,
	cust_id varchar(64) NULL,
	org_id varchar(64) NULL,
	post_id varchar(64) NULL,
	expr_amt numeric(20, 2) NULL,
	mature_ttl_amt numeric(20, 2) NULL,
	take_rate_30d numeric(10, 4) NULL,
	cust_take_flg varchar(1) NULL,
	fixed_mature_tran_fin_amt numeric(20, 2) NULL,
	fixed_fin_mature_tran_insur_amt numeric(20, 2) NULL,
	fin_mature_tran_fixed_amt numeric(20, 2) NULL,
	frst_mature_pk_bf_day_aum_bal numeric(20, 2) NULL,
	curr_aum_bal numeric(20, 2) NULL
);


-- crmdm.tmp_dwd_cust_enter_rela 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dwd_cust_enter_rela;

CREATE TABLE crmdm.tmp_dwd_cust_enter_rela (
	cust_id varchar(20) NULL, -- 客户编号
	rel_typ varchar(1) NULL, -- 关系类型
	rel_cust_id varchar(20) NULL, -- 关联人客户编号
	rel_cust_name varchar(100) NULL, -- 关联人客户名称
	rel_val numeric NULL, -- 关联值
	bk_self_cust_flg varchar(1) NULL, -- 是否我行客户
	rel_inf varchar(800) NULL, -- 关系内容
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	data_date varchar(8) NULL -- 数据日期
);
COMMENT ON TABLE crmdm.tmp_dwd_cust_enter_rela IS '客户关联关系表临时表';

-- Column comments

COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.rel_typ IS '关系类型';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.rel_cust_id IS '关联人客户编号';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.rel_cust_name IS '关联人客户名称';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.rel_val IS '关联值';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.bk_self_cust_flg IS '是否我行客户';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.rel_inf IS '关系内容';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.persn_legal_bk_code IS '法人行号';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_enter_rela.data_date IS '数据日期';


-- crmdm.tmp_dwd_cust_indv_info 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dwd_cust_indv_info;

CREATE TABLE crmdm.tmp_dwd_cust_indv_info (
	cust_id varchar(20) NULL, -- 客户编号
	persn_legal_bk_code varchar(4) NULL -- 法人行号
);
COMMENT ON TABLE crmdm.tmp_dwd_cust_indv_info IS '客户基本信息表-客户编号';

-- Column comments

COMMENT ON COLUMN crmdm.tmp_dwd_cust_indv_info.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.tmp_dwd_cust_indv_info.persn_legal_bk_code IS '法人行号';


-- crmdm.tmp_dws_cust_asse_liab_curr_period 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_curr_period;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_curr_period (
	policy_key varchar(200) NULL,
	insur_bid_form_no varchar(40) NULL,
	period_no numeric NULL,
	due_dt sys."date" NULL,
	pay_tx_key varchar(200) NULL,
	paid_dt sys."date" NULL,
	paid_amt numeric(20, 2) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_his_agg 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_his_agg;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_his_agg (
	persn_legal_bk_code varchar(4) NULL,
	oprt_org varchar(7) NULL,
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	prdkt_typ varchar(1) NULL,
	his_mth_bal numeric(20, 2) NULL,
	his_qrt_bal numeric(20, 2) NULL,
	his_yar_bal numeric(20, 2) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_insur_bal 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_insur_bal;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_insur_bal (
	data_date varchar(8) NULL,
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	bal numeric(20, 2) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_insur_tx 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_insur_tx;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_insur_tx (
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	insur_bid_form_no varchar(40) NULL,
	tx_typ varchar(2) NULL,
	tx_dt sys."date" NULL,
	bgn_dt sys."date" NULL,
	cancl_dt sys."date" NULL,
	pay_upto_dt sys."date" NULL,
	pay_patrn varchar(2) NULL,
	pay_period_typ varchar(2) NULL,
	pay_period numeric NULL,
	insur_amt numeric(20, 2) NULL,
	policy_key varchar(200) NULL,
	tx_seq numeric NULL,
	tx_key varchar(200) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_key_set 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_key_set;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_key_set (
	persn_legal_bk_code varchar(4) NULL,
	oprt_org varchar(7) NULL,
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	prdkt_typ varchar(1) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_last_paid 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_last_paid;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_last_paid (
	policy_key varchar(200) NULL,
	last_paid_amt numeric(20, 2) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_last_status 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_last_status;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_last_status (
	policy_key varchar(200) NULL,
	last_status_tx_typ varchar(2) NULL,
	last_status_dt sys."date" NULL
);


-- crmdm.tmp_dws_cust_asse_liab_pay_plan 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_pay_plan;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_pay_plan (
	policy_key varchar(200) NULL,
	insur_bid_form_no varchar(40) NULL,
	period_no numeric NULL,
	due_dt sys."date" NULL
);


-- crmdm.tmp_dws_cust_asse_liab_pay_tx 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_pay_tx;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_pay_tx (
	policy_key varchar(200) NULL,
	pay_tx_key varchar(200) NULL,
	tx_dt sys."date" NULL,
	insur_amt numeric(20, 2) NULL,
	pay_seq numeric NULL
);


-- crmdm.tmp_dws_cust_asse_liab_plan_match 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_plan_match;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_plan_match (
	policy_key varchar(200) NULL,
	insur_bid_form_no varchar(40) NULL,
	period_no numeric NULL,
	due_dt sys."date" NULL,
	pay_tx_key varchar(200) NULL,
	paid_dt sys."date" NULL,
	paid_amt numeric(20, 2) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_policy_base 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_policy_base;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_policy_base (
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	insur_bid_form_no varchar(40) NULL,
	policy_key varchar(200) NULL,
	first_tx_dt sys."date" NULL,
	bgn_dt sys."date" NULL,
	cancl_dt sys."date" NULL,
	pay_upto_dt sys."date" NULL,
	pay_patrn varchar(2) NULL,
	pay_period_typ varchar(2) NULL,
	pay_period numeric NULL,
	first_insur_amt numeric(20, 2) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_today_agg 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_today_agg;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_today_agg (
	data_date varchar(8) NULL,
	persn_legal_bk_code varchar(4) NULL,
	oprt_org varchar(7) NULL,
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	bal numeric(20, 2) NULL,
	prdkt_typ varchar(1) NULL
);


-- crmdm.tmp_dws_cust_asse_liab_today_bal 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_asse_liab_today_bal;

CREATE TABLE crmdm.tmp_dws_cust_asse_liab_today_bal (
	data_date varchar(8) NULL,
	persn_legal_bk_code varchar(4) NULL,
	oprt_org varchar(7) NULL,
	cust_id varchar(20) NULL,
	acct_id varchar(40) NULL,
	prdkt_id varchar(40) NULL,
	prdkt_cate_big varchar(40) NULL,
	bal numeric(20, 2) NULL,
	prdkt_typ varchar(1) NULL
);


-- crmdm.tmp_dws_cust_chnl_use 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_chnl_use;

CREATE TABLE crmdm.tmp_dws_cust_chnl_use (
	pk_id varchar(40) NOT NULL, -- 主键
	cust_id varchar(20) NOT NULL, -- 客户编号
	statis_typ varchar(1) NOT NULL, -- 统计口径
	chnl_cate varchar(10) NOT NULL, -- 渠道种类
	chnl_name varchar(100) NULL, -- 渠道名称
	use_cnt numeric(8) NULL, -- 使用次数
	persn_legal_bk_code varchar(4) NULL, -- 法人行号
	CONSTRAINT pk_tmp_dws_cust_chnl_use PRIMARY KEY (cust_id, statis_typ, chnl_cate)
);
COMMENT ON TABLE crmdm.tmp_dws_cust_chnl_use IS '客户渠道使用临时表';

-- Column comments

COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.pk_id IS '主键';
COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.statis_typ IS '统计口径';
COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.chnl_cate IS '渠道种类';
COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.chnl_name IS '渠道名称';
COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.use_cnt IS '使用次数';
COMMENT ON COLUMN crmdm.tmp_dws_cust_chnl_use.persn_legal_bk_code IS '法人行号';


-- crmdm.tmp_dws_cust_indv_poten 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_indv_poten;

CREATE TABLE crmdm.tmp_dws_cust_indv_poten (
	poten_cust_id varchar(40) NOT NULL, -- 潜在客户号(自增键)
	poten_cust_name varchar(40) NULL, -- 潜在客户名称
	poten_typ varchar(100) NULL, -- 潜客类型
	poten_cust_typ varchar(6) NULL, -- 潜在客户类型
	gender varchar(6) NULL, -- 性别
	cert_typ varchar(6) NULL, -- 证件类型
	cert_id varchar(32) NULL, -- 证件号码
	tel_no varchar(32) NULL, -- 联系电话
	intent_dsc varchar(400) NULL, -- 备注说明
	dtl_addrs varchar(400) NULL, -- 居住地址
	creatr varchar(20) NULL, -- 创建人
	creat_time varchar(20) NULL, -- 创建时间
	poten_cust_state varchar(6) NULL, -- 潜在客户状态
	lpr_id varchar(6) NULL, -- 法人行号
	src_typ varchar(20) NULL, -- 来源类型
	mkt_persn varchar(6) NULL, -- 客户经理
	mkt_org varchar(200) NULL, -- 归属机构
	serv_enter varchar(6) NULL, -- 工作单位
	post numeric(20) NULL, -- 职位
	mth_incom numeric(20) NULL, -- 月收入
	yr_incom varchar(400) NULL, -- 年收入
	rmark varchar(10) NULL, -- 备注
	inf_klkt_date varchar(200) NULL, -- 潜客转化日期
	unit_addrs varchar(60) NULL, -- 工作单位地址
	intn_prdkt varchar(40) NULL, -- 意向产品
	no_bat varchar(21) NULL, -- 批次号
	cust_id varchar(60) NULL, -- 转化后核心客户号
	pot_cnvrt_prdkt varchar(6) NULL, -- 潜客转化产品
	pot_cnvrt_org varchar(8) NULL, -- 潜客转化机构
	allo_date numeric(4) NULL, -- 分配日期
	CONSTRAINT pk_tmp_dws_cust_indv_poten PRIMARY KEY (poten_cust_id)
);
COMMENT ON TABLE crmdm.tmp_dws_cust_indv_poten IS '零售潜在客户信息表';

-- Column comments

COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.poten_cust_id IS '潜在客户号(自增键)';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.poten_cust_name IS '潜在客户名称';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.poten_typ IS '潜客类型';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.poten_cust_typ IS '潜在客户类型';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.gender IS '性别';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.cert_typ IS '证件类型';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.cert_id IS '证件号码';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.tel_no IS '联系电话';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.intent_dsc IS '备注说明';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.dtl_addrs IS '居住地址';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.creatr IS '创建人';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.creat_time IS '创建时间';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.poten_cust_state IS '潜在客户状态';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.lpr_id IS '法人行号';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.src_typ IS '来源类型';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.mkt_persn IS '客户经理';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.mkt_org IS '归属机构';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.serv_enter IS '工作单位';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.post IS '职位';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.mth_incom IS '月收入';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.yr_incom IS '年收入';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.rmark IS '备注';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.inf_klkt_date IS '潜客转化日期';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.unit_addrs IS '工作单位地址';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.intn_prdkt IS '意向产品';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.no_bat IS '批次号';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.cust_id IS '转化后核心客户号';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.pot_cnvrt_prdkt IS '潜客转化产品';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.pot_cnvrt_org IS '潜客转化机构';
COMMENT ON COLUMN crmdm.tmp_dws_cust_indv_poten.allo_date IS '分配日期';


-- crmdm.tmp_dws_cust_indx_data_aum 定义

-- Drop table

-- DROP TABLE crmdm.tmp_dws_cust_indx_data_aum;

CREATE TABLE crmdm.tmp_dws_cust_indx_data_aum (
	persn_legal_bk_code varchar(4) NULL,
	data_date varchar(8) NULL,
	cust_id varchar(20) NOT NULL,
	org_id varchar(8) NOT NULL,
	indx_typ varchar(20) NULL,
	indx_value varchar(20) NOT NULL,
	indx_last_val varchar(20) NOT NULL,
	indx_mth_val varchar(20) NOT NULL,
	indx_qrt_val varchar(20) NULL,
	indx_yr_val varchar(20) NULL
);


-- crmdm.tmp_ss 定义

-- Drop table

-- DROP TABLE crmdm.tmp_ss;

CREATE TABLE crmdm.tmp_ss (
	post_id text NULL,
	emp_id varchar(32) NULL,
	org_id varchar(32) NULL,
	persn_legal_bk_code text NULL
);


-- crmdm.uepp_pay_aml_mer_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_aml_mer_info;

CREATE TABLE crmdm.uepp_pay_aml_mer_info (
	merch_id varchar(20) NOT NULL, -- 商户编号
	merch_name varchar(200) NULL, -- 商户名称
	merch_tel varchar(32) NULL, -- 营业电话号码（客服电话）
	merch_addr varchar(200) NULL, -- 商户地址
	merch_org_id varchar(20) NULL, -- 签约机构代码
	in_bank varchar(1) NULL, -- 结算账号是否本行开户
	acct_id varchar(64) NULL, -- 结算账号
	is_cust varchar(1) NULL, -- 是否本行商户
	cust_id varchar(32) NULL, -- 本行客户号
	merch_mcc varchar(4) NULL, -- 商户类型
	linkman varchar(96) NULL, -- 联系人姓名
	link_cert_type varchar(48) NULL, -- 联系人证件类型
	link_cert_no varchar(60) NULL, -- 联系人证件号码
	link_tel varchar(32) NULL, -- 联系人电话号码
	link_cell varchar(32) NULL, -- 联系人移动电话号码
	rsrv_01 varchar(32) NULL, -- 备用字段1
	rsrv_02 varchar(32) NULL, -- 备用字段2
	rsrv_03 varchar(32) NULL, -- 备用字段3
	rsrv_04 varchar(32) NULL, -- 备用字段4
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_aml_mer_info PRIMARY KEY (merch_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_id IS '商户编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_name IS '商户名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_tel IS '营业电话号码（客服电话）';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_addr IS '商户地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_org_id IS '签约机构代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.in_bank IS '结算账号是否本行开户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.acct_id IS '结算账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.is_cust IS '是否本行商户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.cust_id IS '本行客户号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.merch_mcc IS '商户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.linkman IS '联系人姓名';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_cert_type IS '联系人证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_cert_no IS '联系人证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_tel IS '联系人电话号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.link_cell IS '联系人移动电话号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_01 IS '备用字段1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_02 IS '备用字段2';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_03 IS '备用字段3';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.rsrv_04 IS '备用字段4';
COMMENT ON COLUMN crmdm.uepp_pay_aml_mer_info.ryzd IS '冗余字段';


-- crmdm.uepp_pay_aml_order_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_aml_order_info;

CREATE TABLE crmdm.uepp_pay_aml_order_info (
	tr_id varchar(256) NOT NULL, -- 业务识别号（平台订单号）
	tr_dt varchar(48) NULL, -- 交易日期
	tr_tm varchar(48) NULL, -- 交易日期和时间
	tr_no varchar(50) NULL, -- 交易流水号
	rcv_pay_type varchar(2) NULL, -- 收付款方匹配号类型
	rcv_pay_no varchar(200) NULL, -- 收付款方匹配号
	tr_org_id varchar(16) NULL, -- 交易机构编号
	cust_id varchar(32) NULL, -- 客户编号
	cust_name varchar(512) NULL, -- 客户名称
	cust_type varchar(1) NULL, -- 客户类型
	acct_id varchar(64) NULL, -- 账号
	card_no varchar(64) NULL, -- 卡号/折号
	card_style varchar(2) NULL, -- 卡片类型
	oth_card_style varchar(128) NULL, -- 其他卡片类型
	subject_id varchar(20) NULL, -- 科目编号
	prd_id varchar(20) NULL, -- 产品编号
	tr_chnl varchar(32) NULL, -- AML交易渠道
	s_tr_chnl varchar(10) NULL, -- 源系统交易渠道
	tr_cd varchar(4) NULL, -- AML交易代码
	s_tr_cd varchar(10) NULL, -- 源系统交易代码
	biz_type varchar(2) NULL, -- PBC业务类型
	is_cash varchar(2) NULL, -- 现转标志
	pay_type varchar(4) NULL, -- 支付工具及结算方式
	debit_credit varchar(1) NULL, -- 借贷标志
	rcv_pay varchar(2) NULL, -- 收付标志
	curr_cd varchar(3) NULL, -- 币种
	is_local_curr varchar(1) NULL, -- 本外币标志
	tr_amt numeric(30, 4) NULL, -- 原币种交易金额
	tr_cny_amt numeric(30, 4) NULL, -- 折人民币交易金额
	tr_usd_amt numeric(30, 4) NULL, -- 折美元交易金额
	tr_bal_amt numeric(30, 4) NULL, -- 交易余额
	tr_country varchar(3) NULL, -- 交易发生国家
	tr_area varchar(6) NULL, -- 交易发生地区
	fund_use varchar(256) NULL, -- 资金用途和来源
	agent_name varchar(128) NULL, -- 代办人姓名
	agent_nat varchar(3) NULL, -- 代办人国籍
	agent_cert_type varchar(6) NULL, -- 代办人证件种类
	oth_agent_cert_type varchar(128) NULL, -- 代办人其他证件种类
	agent_cert_no varchar(128) NULL, -- 代办人证件号码
	opp_name varchar(128) NULL, -- 对方名称
	opp_acct_id varchar(64) NULL, -- 对方账号
	opp_acct_type varchar(6) NULL, -- 对手PBC账户类型
	opp_is_cust varchar(1) NULL, -- 对方是否我行客户
	opp_cust_id varchar(64) NULL, -- 对方客户编号
	opp_cust_type varchar(1) NULL, -- 对方客户类型
	opp_off_shore varchar(1) NULL, -- 对方是否离岸账户
	opp_card_no varchar(64) NULL, -- 对方卡号/折号
	opp_card_style varchar(2) NULL, -- 对方卡片类型
	oth_opp_card_style varchar(128) NULL, -- 对方其他卡片类型
	opp_cert_type varchar(6) NULL, -- 对方证件类型
	oth_opp_cert_type varchar(128) NULL, -- 对方其他证件类型
	opp_cert_no varchar(128) NULL, -- 对方证件号码
	opp_org_id varchar(16) NULL, -- 对方金融机构编号
	opp_org_name varchar(128) NULL, -- 对方金融机构名称
	opp_org_type varchar(2) NULL, -- 对方金融机构类型
	opp_org_country varchar(3) NULL, -- 对方金融机构网点国家
	opp_org_area varchar(6) NULL, -- 对方金融机构网点地区
	tr_go_country varchar(3) NULL, -- 交易去向国家
	tr_go_area varchar(6) NULL, -- 交易去向地区
	is_cross varchar(1) NULL, -- 是否跨境
	opr_id varchar(32) NULL, -- 交易操作员
	re_opr_id varchar(32) NULL, -- 交易复核员
	rev_cd varchar(1) NULL, -- 冲正标志
	pbc_rltp varchar(15) NULL, -- 金融机构与客户的关系
	pbc_tsct varchar(16) NULL, -- 涉外收支交易代码
	sys_id varchar(32) NULL, -- 发起系统编码
	ip varchar(15) NULL, -- 交易IPv4地址
	tr_ipv6 varchar(32) NULL, -- 交易IPv6地址
	tr_mac varchar(32) NULL, -- 交易MAC地址
	tr_note1 varchar(256) NULL, -- 交易信息备注1
	tr_note2 varchar(256) NULL, -- 交易信息备注2
	bank_pay_cd varchar(128) NULL, -- 银行与支付机构之间的业务交易编码
	eqpt_cd varchar(500) NULL, -- 非柜台交易介质的设备代码
	merch_id varchar(20) NULL, -- 收单商户编码
	merch_type varchar(4) NULL, -- 收单商户类型
	is_3rd_pay varchar(1) NULL, -- 是否第三方支付
	tr_crt_type varchar(1) NULL, -- 交易创建方式
	bh_exec varchar(1) NULL, -- 参与大额计算
	bs_exec varchar(1) NULL, -- 参与可疑计算
	clct_sts varchar(1) NULL, -- 筛查前补录状态
	bh_valid varchar(1) NULL, -- 大额验证
	bs_valid varchar(1) NULL, -- 可疑验证
	due_dt sys."date" NULL, -- 处理期限
	rsrv_01 varchar(48) NULL, -- 备用字段1
	rsrv_02 varchar(48) NULL, -- 备用字段2
	rsrv_03 varchar(48) NULL, -- 备用字段3
	rsrv_04 varchar(48) NULL, -- 备用字段4
	pbc_chnl varchar(50) NULL, -- PBC交易渠道
	non_dept_type varchar(2) NULL, -- 非柜台交易方式
	oth_non_dept_type varchar(64) NULL, -- 非柜台交易方式
	pbc_orgkey varchar(16) NULL, -- 金融机构网点代码
	main_acct_id varchar(64) NULL, -- 主账号
	agent_tel varchar(60) NULL, -- 代理人联系方式
	opp_acct_type1 varchar(6) NULL, -- 对手账户类型1
	pos_owner varchar(40) NULL, -- 信用卡消费商户名称
	is_cadr_trans varchar(2) NULL, -- 是否有卡交易
	cert_no varchar(128) NULL, -- 客户证件号码
	cert_type varchar(6) NULL, -- 客户证件类型
	oth_cert_type varchar(128) NULL, -- 客户其他证件类型
	atm_bank_code varchar(20) NULL, -- atm机具所属行行号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_aml_order_info PRIMARY KEY (tr_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_id IS '业务识别号（平台订单号）';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_dt IS '交易日期';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_tm IS '交易日期和时间';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_no IS '交易流水号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rcv_pay_type IS '收付款方匹配号类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rcv_pay_no IS '收付款方匹配号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_org_id IS '交易机构编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cust_name IS '客户名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cust_type IS '客户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.acct_id IS '账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.card_no IS '卡号/折号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.card_style IS '卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_card_style IS '其他卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.subject_id IS '科目编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.prd_id IS '产品编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_chnl IS 'AML交易渠道';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.s_tr_chnl IS '源系统交易渠道';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_cd IS 'AML交易代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.s_tr_cd IS '源系统交易代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.biz_type IS 'PBC业务类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_cash IS '现转标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pay_type IS '支付工具及结算方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.debit_credit IS '借贷标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rcv_pay IS '收付标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.curr_cd IS '币种';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_local_curr IS '本外币标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_amt IS '原币种交易金额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_cny_amt IS '折人民币交易金额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_usd_amt IS '折美元交易金额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_bal_amt IS '交易余额';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_country IS '交易发生国家';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_area IS '交易发生地区';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.fund_use IS '资金用途和来源';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_name IS '代办人姓名';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_nat IS '代办人国籍';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_cert_type IS '代办人证件种类';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_agent_cert_type IS '代办人其他证件种类';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_cert_no IS '代办人证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_name IS '对方名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_acct_id IS '对方账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_acct_type IS '对手PBC账户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_is_cust IS '对方是否我行客户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cust_id IS '对方客户编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cust_type IS '对方客户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_off_shore IS '对方是否离岸账户';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_card_no IS '对方卡号/折号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_card_style IS '对方卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_opp_card_style IS '对方其他卡片类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cert_type IS '对方证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_opp_cert_type IS '对方其他证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_cert_no IS '对方证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_id IS '对方金融机构编号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_name IS '对方金融机构名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_type IS '对方金融机构类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_country IS '对方金融机构网点国家';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_org_area IS '对方金融机构网点地区';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_go_country IS '交易去向国家';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_go_area IS '交易去向地区';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_cross IS '是否跨境';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opr_id IS '交易操作员';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.re_opr_id IS '交易复核员';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rev_cd IS '冲正标志';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_rltp IS '金融机构与客户的关系';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_tsct IS '涉外收支交易代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.sys_id IS '发起系统编码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.ip IS '交易IPv4地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_ipv6 IS '交易IPv6地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_mac IS '交易MAC地址';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_note1 IS '交易信息备注1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_note2 IS '交易信息备注2';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bank_pay_cd IS '银行与支付机构之间的业务交易编码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.eqpt_cd IS '非柜台交易介质的设备代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.merch_id IS '收单商户编码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.merch_type IS '收单商户类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_3rd_pay IS '是否第三方支付';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.tr_crt_type IS '交易创建方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bh_exec IS '参与大额计算';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bs_exec IS '参与可疑计算';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.clct_sts IS '筛查前补录状态';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bh_valid IS '大额验证';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.bs_valid IS '可疑验证';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.due_dt IS '处理期限';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_01 IS '备用字段1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_02 IS '备用字段2';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_03 IS '备用字段3';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.rsrv_04 IS '备用字段4';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_chnl IS 'PBC交易渠道';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.non_dept_type IS '非柜台交易方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_non_dept_type IS '非柜台交易方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pbc_orgkey IS '金融机构网点代码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.main_acct_id IS '主账号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.agent_tel IS '代理人联系方式';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.opp_acct_type1 IS '对手账户类型1';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.pos_owner IS '信用卡消费商户名称';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.is_cadr_trans IS '是否有卡交易';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cert_no IS '客户证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.cert_type IS '客户证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.oth_cert_type IS '客户其他证件类型';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.atm_bank_code IS 'atm机具所属行行号';
COMMENT ON COLUMN crmdm.uepp_pay_aml_order_info.ryzd IS '冗余字段';


-- crmdm.uepp_pay_mct_channel_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_channel_info;

CREATE TABLE crmdm.uepp_pay_mct_channel_info (
	channel varchar(40) NOT NULL, -- 支付通道
	pay_type varchar(40) NOT NULL, -- 支付类型
	mct_id varchar(40) NOT NULL, -- 商户ID
	fee_rate numeric(16, 4) NULL, -- 费率 单位：‰
	server_id varchar(40) NULL, -- 服务商资质ID
	amt_limit_min numeric(16, 2) NULL, -- 单笔最小
	amt_limit_max numeric(16, 2) NULL, -- 单笔最大
	pay_submct_id varchar(40) NULL, -- 第三方支付子商户号
	remark varchar(300) NULL, -- 备注
	limit_pay varchar(40) NULL -- no_limit-不限   no_credit, --指定不能使用信用卡支付
	status varchar(2) NULL, -- 状态 0-正常（可交易） 1-未生效 2-禁用 9-注销 商户注销时才改成该状态
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	feetype varchar(2) NULL, -- 费率类型   01-单一费率  02-多费率  目前只有银联支持多费率 ；微信、支付宝仅支持单一费率
	fee_rate_credit_smallamt numeric(16, 4) NULL, -- 贷记卡小金额费率  交易金额<=1000的贷记卡费率  单位：‰
	fee_rate_credit_largeamt numeric(16, 4) NULL, -- 贷记卡大金额费率  交易金额>1000的贷记卡费率  单位：‰
	fee_rate_debit_smallamt numeric(16, 4) NULL, -- 借记卡小金额费率  交易金额<=1000的借记卡费率  单位：‰
	fee_rate_debit_largeamt numeric(16, 4) NULL, -- 借记卡大金额费率  交易金额>1000的借记卡费率  单位：‰
	check_status varchar(2) NULL, -- 审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过
	line_type varchar(10) NOT NULL, -- 渠道类型 offline-线下渠道  online-线上渠道
	check_task_id varchar(40) NULL, -- 当前审核任务ID
	nu_submct_id varchar(40) NULL, -- 网联子商户号
	pay_submct_id_netunion varchar(40) NULL, -- 第三方支付子商户号（网联）
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_channel_info PRIMARY KEY (pay_type, mct_id, line_type)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.channel IS '支付通道';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.pay_type IS '支付类型';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.mct_id IS '商户ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate IS '费率 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.server_id IS '服务商资质ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.amt_limit_min IS '单笔最小';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.amt_limit_max IS '单笔最大';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.pay_submct_id IS '第三方支付子商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.remark IS '备注';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.limit_pay IS 'no_limit-不限   no_credit --指定不能使用信用卡支付';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.status IS '状态 0-正常（可交易） 1-未生效 2-禁用 9-注销 商户注销时才改成该状态';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.feetype IS '费率类型   01-单一费率  02-多费率  目前只有银联支持多费率 ；微信、支付宝仅支持单一费率';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_credit_smallamt IS '贷记卡小金额费率  交易金额<=1000的贷记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_credit_largeamt IS '贷记卡大金额费率  交易金额>1000的贷记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_debit_smallamt IS '借记卡小金额费率  交易金额<=1000的借记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.fee_rate_debit_largeamt IS '借记卡大金额费率  交易金额>1000的借记卡费率  单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.check_status IS '审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.line_type IS '渠道类型 offline-线下渠道  online-线上渠道';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.check_task_id IS '当前审核任务ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.nu_submct_id IS '网联子商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.pay_submct_id_netunion IS '第三方支付子商户号（网联）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_channel_info.ryzd IS '冗余字段';


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


-- crmdm.uepp_pay_mct_platform 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_platform;

CREATE TABLE crmdm.uepp_pay_mct_platform (
	r_id varchar(40) NOT NULL, -- 平台商户二级商户关联ID
	platform_mct_id varchar(40) NULL, -- 平台商户id
	secondary_mct_id varchar(40) NULL, -- 二级商户id
	secondary_fre_rate numeric(16, 4) NULL, -- 平台分润比例‰
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_platform PRIMARY KEY (r_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.r_id IS '平台商户二级商户关联ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.platform_mct_id IS '平台商户id';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.secondary_mct_id IS '二级商户id';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.secondary_fre_rate IS '平台分润比例‰';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_platform.ryzd IS '冗余字段';


-- crmdm.uepp_pay_mct_settle_account 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_mct_settle_account;

CREATE TABLE crmdm.uepp_pay_mct_settle_account (
	mct_id varchar(40) NOT NULL, -- 商户号
	acct_type varchar(2) NULL, -- 账户类型0：对公户1：对私户2：存折
	bank_account varchar(50) NULL, -- 结算账号
	bank_acct_name varchar(100) NULL, -- 开户户名
	provice varchar(10) NULL, -- 开户省分  非本行卡时填写
	city varchar(10) NULL, -- 开户城市 非本行卡时填写
	open_bankno varchar(20) NULL, -- 开户支行行号 非本行卡时填写
	open_bankname varchar(60) NULL, -- 开户支行名称 非本行卡时填写
	is_self varchar(1) NULL, -- 是否本行户0:本行账户1:非本行账户
	cert_phone varchar(11) NULL, -- 银行预留电话
	cert_type varchar(2) NULL, -- 开户证件类型01-身份证；02-港澳通行证；03-台湾通行证；04-护照；05-其他
	cert_no varchar(50) NULL, -- 证件号码
	status varchar(1) NULL, -- 状态 0-正常（可交易） 1-未生效 2-冻结 3-冻结(涉案账户) 9-作废
	remark varchar(100) NULL, -- 摘要
	channel varchar(40) NOT NULL, -- 支付通道（统一一个账户，默认all）
	create_user varchar(40) NULL, -- 创建创建操作人
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	check_status varchar(2) NULL, -- 审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过
	check_task_id varchar(40) NULL, -- 当前审核任务ID
	is_default varchar(1) NULL, -- 类型：1-共用默认的清算账户 0-独有清算账号  （后台不需要给前台转码）
	cust_no varchar(32) NULL, -- 核心客户号
	cust_cn_name varchar(500) NULL, -- 客户中文名
	acc_bal varchar(40) NULL, -- 清算账号余额
	old_cust_no varchar(40) NULL, -- 原客户号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_mct_settle_account PRIMARY KEY (mct_id, channel)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.mct_id IS '商户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.acct_type IS '账户类型0：对公户1：对私户2：存折';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.bank_account IS '结算账号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.bank_acct_name IS '开户户名';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.provice IS '开户省分  非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.city IS '开户城市 非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.open_bankno IS '开户支行行号 非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.open_bankname IS '开户支行名称 非本行卡时填写';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.is_self IS '是否本行户0:本行账户1:非本行账户';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cert_phone IS '银行预留电话';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cert_type IS '开户证件类型01-身份证；02-港澳通行证；03-台湾通行证；04-护照；05-其他';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cert_no IS '证件号码';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.status IS '状态 0-正常（可交易） 1-未生效 2-冻结 3-冻结(涉案账户) 9-作废';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.remark IS '摘要';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.channel IS '支付通道（统一一个账户，默认all）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.create_user IS '创建创建操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.check_status IS '审核状态 00：待审核 01:审核中 02：审核不通过 03：审核通过';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.check_task_id IS '当前审核任务ID';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.is_default IS '类型：1-共用默认的清算账户 0-独有清算账号  （后台不需要给前台转码）';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cust_no IS '核心客户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.cust_cn_name IS '客户中文名';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.acc_bal IS '清算账号余额';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.old_cust_no IS '原客户号';
COMMENT ON COLUMN crmdm.uepp_pay_mct_settle_account.ryzd IS '冗余字段';


-- crmdm.uepp_pay_order_info 定义

-- Drop table

-- DROP TABLE crmdm.uepp_pay_order_info;

CREATE TABLE crmdm.uepp_pay_order_info (
	order_id varchar(40) NOT NULL, -- 平台订单号
	order_type varchar(10) NULL, -- 订单类型 00-支付交易  01-退款交易
	channel varchar(40) NULL, -- 支付通道
	pay_type varchar(40) NULL, -- 支付类型
	mct_id varchar(40) NOT NULL, -- 平台商户号  如果是门店则是门店的商户号
	dit_id varchar(40) NOT NULL, -- 平台渠道商ID
	order_amt numeric(16, 2) NOT NULL, -- 订单金额（给商户清算金额 支付交易的支付金额   退款交易的退款金额）
	pay_amt numeric(16, 2) NULL, -- 平台实际支付金额（传给第三方支付平台的金额=订单金额-优惠金额）
	dis_amt numeric(16, 2) NULL, -- 优惠金额
	dis_auth_id varchar(40) NULL, -- 优惠凭证
	pay_time varchar(20) NULL, -- 支付时间(调用支付接口的时间)
	jungle_type varchar(2) NULL, -- 分润方式 见 PAY_DIT_INFO 表 JUNGLE_TYPE
	jungle_amt numeric(16, 2) NULL, -- 分润金额
	server_id varchar(40) NULL, -- 服务商资质ID
	mct_fee numeric(16, 2) NULL, -- 应收商户手续费
	dit_fee numeric(16, 2) NULL, -- 收渠道商手续费 收渠道商的钱
	buyer_pay_amt numeric(16, 2) NULL, -- 买家实际支付金额(第三方支付平台返回)
	buyer_user_id varchar(200) NULL, -- 买家用户ID(第三方支付平台返回  也是微信的openid)
	third_mch_id varchar(40) NULL, -- 第三方商户号（银行服务商在第三方支付系统商户号或机构号）
	third_sub_mch_id varchar(40) NULL, -- 第三方子商户号（该商户在第三方支付系统的商户号）
	third_pay_fee numeric(16, 2) NULL, -- 成本手续费
	third_trade_no varchar(40) NULL, -- 第三方支付平台支付订单号
	third_end_time varchar(20) NULL, -- 交易完成时间/退款完成时间(支付完成时间、退款完成时间 第三方支付平台返回)
	settle_date varchar(8) NULL, -- 账单日期  第三方返回（属于哪天对账的日期）
	timeout_express varchar(20) NULL, -- 该笔订单允许的最晚付款时间，逾期将关闭交易，从生成二维码开始计时。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。
	limit_pay varchar(20) NULL, -- 是否限制不让使用信用卡  只有微信
	out_trade_no varchar(40) NULL, -- 商户订单号（外部系统接入时的订单号）
	or_order_id varchar(40) NULL, -- 原平台订单号（退款交易时有）
	web_notify_url varchar(256) NULL, -- 前端跳转地址
	notify_url varchar(500) NULL, -- 交易结果通知地址
	order_body varchar(200) NULL, -- 商品描述/名称
	order_detail varchar(1000) NULL, -- 商品详细描述
	term_id varchar(100) NULL, -- 终端标识
	dev_info varchar(500) NULL, -- 主扫支付时二维码信息  被扫支付时设备信息
	auth_code varchar(200) NULL, -- 被扫支付授权码
	qr_code varchar(300) NULL, -- 平台订单号
	"attach" varchar(500) NULL, -- 附加信息
	remark varchar(300) NULL, -- 备注  可以填写错误返回信息
	status varchar(2) NULL, -- 订单状态  00：待付款  01：处理中 02：交易成功 03：交易失败  04：已关闭  05：已撤销  90:超时 91:异常  98：预下单  99：日终失效
	create_user varchar(40) NULL, -- 创建创建操作人  操作员  默认商户号 如果是店员则是店员编号
	create_time varchar(20) NULL, -- 创建时间  yyyyMMDDHHmmssSSS
	update_user varchar(40) NULL, -- 更新操作人
	update_time varchar(20) NULL, -- 更新时间 yyyyMMDDHHmmssSSS
	buyer_user_name varchar(200) NULL, -- 买家用户名称
	pay_card_type varchar(2) NULL, -- 支付卡类型 01-借记卡  02-贷记卡
	client_id varchar(40) NULL, -- 客户端ID（系统内部APP_ID）
	client_info varchar(300) NULL, -- 终端信息（如手机型号、客户端浏览器信息等）
	cost_rate numeric(16, 4) NULL, -- 成本费率(第三方收服务商的费率) 单位：‰
	dit_fee_rate numeric(16, 4) NULL, -- 渠道商费率（服务商收渠道商的纯利润费率，纯利润费率即扣除成本费率之后的费率） 单位：‰
	mct_fee_rate numeric(16, 4) NULL, -- 商户费率（渠道商收商户费率） 单位：‰
	settle_flag varchar(2) NULL, -- 清算标识  1-商户清算成功 0-商户未清算  2-商户清算中  9-门店清算失败 11-门店清算成功 10-门店未清算  12-门店清算中  19-门店清算失败
	bala_flag varchar(1) NULL, -- 对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符
	settle_serial_no varchar(40) NULL, -- 清算时的流水号
	settle_update_date varchar(8) NULL, -- 清算更新日期
	bala_update_date varchar(8) NULL, -- 实际更新日期
	settle_type varchar(2) NULL, -- 清算类型 T0：T+0当日清算  T1：T+1下日清算
	activity_rate numeric(16, 4) NULL, -- 活动费率:商户参加活动的最低活动费率，若商户参加活动则有值，单位：‰
	activity_fee numeric(16, 2) NULL, -- 活动手续费:商户参加活动的最低手续费，若商户参加活动则有值
	mct_real_fee numeric(16, 2) NULL, -- 实收商户手续费:为【应收商户手续费】和【活动手续费】较小值
	activity_id varchar(32) NULL, -- 活动ID:该笔订单参加的活动ID
	isscode varchar(11) NULL, -- 发卡机构代码
	ip varchar(16) NULL, -- 交易IPv4地址
	tr_mac varchar(32) NULL, -- 交易MAC地址
	core_id varchar(40) NULL, -- 快捷支付核心流水号
	mct_related_id varchar(32) NULL, -- 商户活动编号
	consumer_id varchar(40) NULL, -- 客户ID
	idc_flag varchar(10) NULL, -- 网联idc标识
	device_ip varchar(64) NULL, -- 绑卡设备（付款APP）所在的公网ip，可用于定位所属地区，不是wifi连接时的局域网ip。
	device_location varchar(32) NULL, -- (付款APP)设备GPS位置，格式为纬度/经度，+表示北纬、东经，-表示南纬西经。
	user_id varchar(128) NULL, -- 微信用户唯一标识码
	is_next_refund varchar(10) NULL, -- 是否是隔日退款 0 - 不是  1 - 是
	store_id varchar(40) NULL, -- 门店号
	wal_acct_amt numeric(16, 2) NULL, -- 电子钱包支付金额
	wal_acct_status varchar(2) NULL, -- 电子钱包支付状态 00-待支付 , 01-支付成功 , 03-支付失败 , 04-冲正处理中 , 05-冲正成功 , 06-冲正失败
	wal_acct_no varchar(40) NULL, -- 所使用电子钱包账户
	refund_mode varchar(2) NULL, -- 退款模式  00-余额模式 01-待清算模式
	pay_zh varchar(2) NULL, -- 组合支付判断标识 1 - 支付宝钱包组合 2 - 本行卡钱包组合
	wal_trade_no varchar(40) NULL, -- 电子钱包支付订单号
	wal_end_time varchar(20) NULL, -- 交易完成时间/退款完成时间(支付完成时间、退款完成时间 钱包支付平台返回)
	wal_bala_flag varchar(1) NULL, -- 电子钱包对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符
	calc_fee_flag varchar(2) NULL, -- 计算手续费标识 0待计算 1计算中 2计算完成
	mct_real_fee_type varchar(2) NULL, -- 0:旧费率,1:白名单0费率,2:免收期费率,3:起征点内费率,4:白名单非0费率,5:额度内费率,6:额度外费率
	app_refundable_flag varchar(1) NULL, -- 1:不允许app退款
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_uepp_pay_order_info PRIMARY KEY (order_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_id IS '平台订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_type IS '订单类型 00-支付交易  01-退款交易';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.channel IS '支付通道';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_type IS '支付类型';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_id IS '平台商户号  如果是门店则是门店的商户号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dit_id IS '平台渠道商ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_amt IS '订单金额（给商户清算金额 支付交易的支付金额   退款交易的退款金额）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_amt IS '平台实际支付金额（传给第三方支付平台的金额=订单金额-优惠金额）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dis_amt IS '优惠金额';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dis_auth_id IS '优惠凭证';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_time IS '支付时间(调用支付接口的时间)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.jungle_type IS '分润方式 见 PAY_DIT_INFO 表 JUNGLE_TYPE';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.jungle_amt IS '分润金额';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.server_id IS '服务商资质ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_fee IS '应收商户手续费';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dit_fee IS '收渠道商手续费 收渠道商的钱';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.buyer_pay_amt IS '买家实际支付金额(第三方支付平台返回)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.buyer_user_id IS '买家用户ID(第三方支付平台返回  也是微信的openid)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_mch_id IS '第三方商户号（银行服务商在第三方支付系统商户号或机构号）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_sub_mch_id IS '第三方子商户号（该商户在第三方支付系统的商户号）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_pay_fee IS '成本手续费';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_trade_no IS '第三方支付平台支付订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.third_end_time IS '交易完成时间/退款完成时间(支付完成时间、退款完成时间 第三方支付平台返回)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_date IS '账单日期  第三方返回（属于哪天对账的日期）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.timeout_express IS '该笔订单允许的最晚付款时间，逾期将关闭交易，从生成二维码开始计时。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.limit_pay IS '是否限制不让使用信用卡  只有微信';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.out_trade_no IS '商户订单号（外部系统接入时的订单号）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.or_order_id IS '原平台订单号（退款交易时有）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.web_notify_url IS '前端跳转地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.notify_url IS '交易结果通知地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_body IS '商品描述/名称';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.order_detail IS '商品详细描述';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.term_id IS '终端标识';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dev_info IS '主扫支付时二维码信息  被扫支付时设备信息';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.auth_code IS '被扫支付授权码';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.qr_code IS '平台订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info."attach" IS '附加信息';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.remark IS '备注  可以填写错误返回信息';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.status IS '订单状态  00：待付款  01：处理中 02：交易成功 03：交易失败  04：已关闭  05：已撤销  90:超时 91:异常  98：预下单  99：日终失效';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.create_user IS '创建创建操作人  操作员  默认商户号 如果是店员则是店员编号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.create_time IS '创建时间  yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.update_user IS '更新操作人';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.update_time IS '更新时间 yyyyMMDDHHmmssSSS';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.buyer_user_name IS '买家用户名称';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_card_type IS '支付卡类型 01-借记卡  02-贷记卡';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.client_id IS '客户端ID（系统内部APP_ID）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.client_info IS '终端信息（如手机型号、客户端浏览器信息等）';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.cost_rate IS '成本费率(第三方收服务商的费率) 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.dit_fee_rate IS '渠道商费率（服务商收渠道商的纯利润费率，纯利润费率即扣除成本费率之后的费率） 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_fee_rate IS '商户费率（渠道商收商户费率） 单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_flag IS '清算标识  1-商户清算成功 0-商户未清算  2-商户清算中  9-门店清算失败 11-门店清算成功 10-门店未清算  12-门店清算中  19-门店清算失败';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.bala_flag IS '对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_serial_no IS '清算时的流水号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_update_date IS '清算更新日期';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.bala_update_date IS '实际更新日期';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.settle_type IS '清算类型 T0：T+0当日清算  T1：T+1下日清算';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.activity_rate IS '活动费率:商户参加活动的最低活动费率，若商户参加活动则有值，单位：‰';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.activity_fee IS '活动手续费:商户参加活动的最低手续费，若商户参加活动则有值';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_real_fee IS '实收商户手续费:为【应收商户手续费】和【活动手续费】较小值';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.activity_id IS '活动ID:该笔订单参加的活动ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.isscode IS '发卡机构代码';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.ip IS '交易IPv4地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.tr_mac IS '交易MAC地址';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.core_id IS '快捷支付核心流水号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_related_id IS '商户活动编号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.consumer_id IS '客户ID';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.idc_flag IS '网联idc标识';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.device_ip IS '绑卡设备（付款APP）所在的公网ip，可用于定位所属地区，不是wifi连接时的局域网ip。';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.device_location IS '(付款APP)设备GPS位置，格式为纬度/经度，+表示北纬、东经，-表示南纬西经。';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.user_id IS '微信用户唯一标识码';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.is_next_refund IS '是否是隔日退款 0 - 不是  1 - 是';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.store_id IS '门店号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_acct_amt IS '电子钱包支付金额';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_acct_status IS '电子钱包支付状态 00-待支付 , 01-支付成功 , 03-支付失败 , 04-冲正处理中 , 05-冲正成功 , 06-冲正失败';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_acct_no IS '所使用电子钱包账户';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.refund_mode IS '退款模式  00-余额模式 01-待清算模式';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.pay_zh IS '组合支付判断标识 1 - 支付宝钱包组合 2 - 本行卡钱包组合';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_trade_no IS '电子钱包支付订单号';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_end_time IS '交易完成时间/退款完成时间(支付完成时间、退款完成时间 钱包支付平台返回)';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.wal_bala_flag IS '电子钱包对账标识 0:未对账1:对账成功2:平台少账3:平台多张4:金额不符';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.calc_fee_flag IS '计算手续费标识 0待计算 1计算中 2计算完成';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.mct_real_fee_type IS '0:旧费率,1:白名单0费率,2:免收期费率,3:起征点内费率,4:白名单非0费率,5:额度内费率,6:额度外费率';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.app_refundable_flag IS '1:不允许app退款';
COMMENT ON COLUMN crmdm.uepp_pay_order_info.ryzd IS '冗余字段';


-- crmdm.ybt_czdf_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ybt_czdf_bat_detail;

CREATE TABLE crmdm.ybt_czdf_bat_detail (
	batch_no varchar(30) NOT NULL, -- 批次号
	serial_id varchar(12) NOT NULL, -- 流水号
	bank_name varchar(400) NULL, -- 开户行名称
	payee_id varchar(32) NULL, -- 收款人身份证件号码
	payee_name varchar(128) NULL, -- 收款人名称
	coll_account varchar(20) NULL, -- 收款账号
	amt numeric(20, 2) NOT NULL, -- 金额
	remark varchar(240) NULL, -- 附言
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	status varchar(1) NOT NULL, -- "处理状态：0:未处理 1:处理中 2:处理成功 3:处理失败 4:处理超时"
	rst_memo varchar(400) NULL, -- 交易结果描述
	tran_channel varchar(32) NULL, -- 交易渠道号
	bank_acct_no varchar(80) NULL, -- 开户行号
	third_batch varchar(30) NULL, -- 第三方批次号
	is_other_bank varchar(1) NULL, -- 是否跨行：1 否     2 是
	tel varchar(50) NULL, -- 联系电话
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_czdf_bat_detail PRIMARY KEY (serial_id)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.serial_id IS '流水号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.bank_name IS '开户行名称';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.payee_id IS '收款人身份证件号码';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.payee_name IS '收款人名称';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.coll_account IS '收款账号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.amt IS '金额';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.remark IS '附言';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.status IS '"处理状态：0:未处理 1:处理中 2:处理成功 3:处理失败 4:处理超时"';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.tran_channel IS '交易渠道号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.bank_acct_no IS '开户行号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.third_batch IS '第三方批次号';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.is_other_bank IS '是否跨行：1 否     2 是';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.tel IS '联系电话';
COMMENT ON COLUMN crmdm.ybt_czdf_bat_detail.ryzd IS '冗余字段';


-- crmdm.ybt_ib_list_plat 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ib_list_plat;

CREATE TABLE crmdm.ybt_ib_list_plat (
	plat_serial varchar(35) NOT NULL, -- 平台流水
	plat_date varchar(8) NOT NULL, -- 交易日期
	plat_time varchar(6) NOT NULL, -- 交易时间
	reverse_flag varchar(1) NOT NULL, -- 是否冲正交易 0:否 1:是
	ori_serial varchar(35) NULL, -- 原交易流水号
	channel_id varchar(4) NOT NULL, -- 渠道号
	service_id varchar(8) NOT NULL, -- 交易码
	channel_serial varchar(40) NOT NULL, -- 渠道流水号
	channel_date varchar(8) NULL, -- 渠道日期
	channel_time varchar(6) NULL, -- 渠道时间
	trans_device_no varchar(40) NULL, -- 交易设备ID
	area_id varchar(4) NULL, -- 交易区域
	branch_code varchar(20) NULL, -- 交易机构
	teller_id varchar(20) NULL, -- 柜员号
	auther_id varchar(20) NULL, -- 授权柜员号
	auther_password varchar(64) NULL, -- 授权密码
	busi_id varchar(24) NOT NULL, -- 业务分类编号
	acct_no varchar(32) NULL, -- 交易账号
	acct_name varchar(1020) NULL, -- 交易账号名称
	trad_type varchar(1) NOT NULL, -- 交易类别 0:现金 1:转账 2:其他
	cry_id varchar(3) NOT NULL, -- 交易币种(CNY，基于ISO 4217)
	amt numeric(16, 2) NOT NULL, -- 交易金额
	amt1 numeric(16, 2) NULL, -- 辅助金额1
	amt2 numeric(16, 2) NULL, -- 辅助金额2
	amt3 numeric(16, 2) NULL, -- 辅助金额3
	trad_abs varchar(800) NULL, -- 交易摘要
	voucher_type varchar(3) NULL, -- 凭证类型
	voucher_no varchar(40) NULL, -- 凭证号码
	opp_acct_no varchar(32) NULL, -- 对手账户
	opp_acct_name varchar(1020) NULL, -- 对手账户名称
	user_id varchar(80) NULL, -- 客户编号
	user_name varchar(800) NULL, -- 客户姓名
	tran_memo varchar(1020) NULL, -- 交易备注信息
	plat_trad_status varchar(1) NOT NULL, -- 平台处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	plat_resp_code varchar(12) NULL, -- 平台响应码
	plat_resp_msg varchar(800) NULL, -- 平台响应信息
	core_status varchar(1) NULL, -- 核心处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	core_serial_no varchar(40) NULL, -- 核心请求流水号
	core_resp_serial varchar(40) NULL, -- 核心响应流水号
	core_resp_code varchar(20) NULL, -- 核心响应码
	core_resp_msg varchar(800) NULL, -- 核心响应信息
	third_party_status varchar(1) NULL, -- 第三方处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正
	third_party_serial_no varchar(40) NULL, -- 第三方请求流水号
	third_party_resp_serial varchar(40) NULL, -- 第三方响应流水号
	third_party_resp_code varchar(20) NULL, -- 第三方响应码
	third_party_resp_msg varchar(800) NULL, -- 第三方响应信息
	request_add_info varchar(4000) NULL, -- 请求附加域
	resp_add_info varchar(4000) NULL, -- 响应附加域
	chk_flag varchar(1) NOT NULL, -- N 无需对账，0:未对账，1:已对账，2:已生成第三方对账文件，3:处理中
	core_date varchar(8) NULL, -- 核心日期
	third_party_date varchar(8) NULL, -- 第三方日期
	core_time varchar(6) NULL, -- 核心时间
	settle_date varchar(8) NULL, -- 清算日期
	tran_date varchar(8) NOT NULL, -- 交易日期
	item_id varchar(40) NULL, -- 项目分类编号
	rem_amt numeric(16, 2) NULL, -- 剩余可退款金额
	third_party_time varchar(6) NULL, -- 第三方时间
	third_chk_flag varchar(2) NULL, -- 三方对账 N:无需对账 0:未对账 1:已对账 2:对账有差错
	settle_cd_flag varchar(2) NULL, -- 过渡户清算借贷标识 D:借记 C:贷记
	settle_flag varchar(2) NULL, -- 清算标识 N:无需清算 0:未清算 1:已清算 2:清算失败
	settle_amt numeric(16, 2) NULL, -- 清算金额
	d_amt_sum numeric(17, 2) NOT NULL, -- 借方累计金额
	c_amt_sum numeric(17, 2) NOT NULL, -- 贷方累计金额
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ib_list_plat.plat_serial IS '平台流水';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.plat_date IS '交易日期';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.plat_time IS '交易时间';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.reverse_flag IS '是否冲正交易 0:否 1:是';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.ori_serial IS '原交易流水号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.channel_id IS '渠道号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.service_id IS '交易码';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.channel_serial IS '渠道流水号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.channel_date IS '渠道日期';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.channel_time IS '渠道时间';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.trans_device_no IS '交易设备ID';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.area_id IS '交易区域';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.branch_code IS '交易机构';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.teller_id IS '柜员号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.auther_id IS '授权柜员号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.auther_password IS '授权密码';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.busi_id IS '业务分类编号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.acct_no IS '交易账号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.acct_name IS '交易账号名称';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.trad_type IS '交易类别 0:现金 1:转账 2:其他';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.cry_id IS '交易币种(CNY，基于ISO 4217)';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.amt IS '交易金额';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.amt1 IS '辅助金额1';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.amt2 IS '辅助金额2';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.amt3 IS '辅助金额3';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.trad_abs IS '交易摘要';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.voucher_type IS '凭证类型';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.voucher_no IS '凭证号码';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.opp_acct_no IS '对手账户';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.opp_acct_name IS '对手账户名称';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.user_id IS '客户编号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.user_name IS '客户姓名';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.tran_memo IS '交易备注信息';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.plat_trad_status IS '平台处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.plat_resp_code IS '平台响应码';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.plat_resp_msg IS '平台响应信息';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_status IS '核心处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_serial_no IS '核心请求流水号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_resp_serial IS '核心响应流水号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_resp_code IS '核心响应码';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_resp_msg IS '核心响应信息';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_status IS '第三方处理状态 0预计1处理中 2处理成功 3处理失败 4已冲正';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_serial_no IS '第三方请求流水号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_resp_serial IS '第三方响应流水号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_resp_code IS '第三方响应码';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_resp_msg IS '第三方响应信息';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.request_add_info IS '请求附加域';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.resp_add_info IS '响应附加域';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.chk_flag IS 'N 无需对账，0:未对账，1:已对账，2:已生成第三方对账文件，3:处理中';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_date IS '核心日期';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_date IS '第三方日期';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.core_time IS '核心时间';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.settle_date IS '清算日期';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.tran_date IS '交易日期';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.item_id IS '项目分类编号';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.rem_amt IS '剩余可退款金额';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_party_time IS '第三方时间';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.third_chk_flag IS '三方对账 N:无需对账 0:未对账 1:已对账 2:对账有差错';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.settle_cd_flag IS '过渡户清算借贷标识 D:借记 C:贷记';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.settle_flag IS '清算标识 N:无需清算 0:未清算 1:已清算 2:清算失败';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.settle_amt IS '清算金额';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.d_amt_sum IS '借方累计金额';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.c_amt_sum IS '贷方累计金额';
COMMENT ON COLUMN crmdm.ybt_ib_list_plat.ryzd IS '冗余字段';


-- crmdm.ybt_lssb_trans_detail 定义

-- Drop table

-- DROP TABLE crmdm.ybt_lssb_trans_detail;

CREATE TABLE crmdm.ybt_lssb_trans_detail (
	plat_serial varchar(20) NOT NULL, -- 平台流水号
	tran_code varchar(8) NULL, -- 交易码
	batch_no varchar(18) NULL, -- 批次号
	id varchar(32) NULL, -- 社保流水号
	batch_message varchar(128) NULL, -- 批次描述
	"type" varchar(3) NULL, -- 险种
	branch_code varchar(8) NULL, -- 经办机构编码
	soc_no varchar(20) NULL, -- 个人编码/单位编码
	idno varchar(20) NOT NULL, -- 身份证号
	"name" varchar(100) NULL, -- 姓名/单位名称
	billno varchar(32) NOT NULL, -- 社保单据号
	bank_code varchar(8) NULL, -- 交易银行
	pboc_code varchar(16) NULL, -- 人行网点编号
	pboc_name varchar(128) NULL, -- 人行网点名称
	acct_name varchar(100) NULL, -- 户名
	acct_no varchar(32) NULL, -- 银行账号
	socs_branch_code varchar(8) NULL, -- 社保经办银行
	socs_acct_name varchar(100) NULL, -- 社保经办户名
	socs_acct_no varchar(32) NULL, -- 社保经办银行账号
	date_no varchar(10) NULL, -- 期号
	tran_amt numeric(12, 2) NULL, -- 交易金额
	remark varchar(100) NULL, -- 摘要说明
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	rst_memo varchar(500) NULL, -- 交易结果描述
	status varchar(1) NULL, -- 交易状态0:未处理 1:处理中 2:处理成功 3:处理失败败 4:处理超时
	tran_channel varchar(32) NULL, -- 交易渠道号
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.plat_serial IS '平台流水号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.tran_code IS '交易码';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.id IS '社保流水号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.batch_message IS '批次描述';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail."type" IS '险种';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.branch_code IS '经办机构编码';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.soc_no IS '个人编码/单位编码';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.idno IS '身份证号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail."name" IS '姓名/单位名称';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.billno IS '社保单据号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.bank_code IS '交易银行';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.pboc_code IS '人行网点编号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.pboc_name IS '人行网点名称';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.acct_name IS '户名';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.acct_no IS '银行账号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.socs_branch_code IS '社保经办银行';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.socs_acct_name IS '社保经办户名';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.socs_acct_no IS '社保经办银行账号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.date_no IS '期号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.tran_amt IS '交易金额';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.remark IS '摘要说明';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.status IS '交易状态0:未处理 1:处理中 2:处理成功 3:处理失败败 4:处理超时';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.tran_channel IS '交易渠道号';
COMMENT ON COLUMN crmdm.ybt_lssb_trans_detail.ryzd IS '冗余字段';


-- crmdm.ybt_scsb_bat_detail 定义

-- Drop table

-- DROP TABLE crmdm.ybt_scsb_bat_detail;

CREATE TABLE crmdm.ybt_scsb_bat_detail (
	bat_no varchar(18) NOT NULL, -- 社保代发批次号
	det_no varchar(10) NOT NULL, -- 序号
	sb_no varchar(20) NOT NULL, -- 个人编号
	"name" varchar(400) NULL, -- 银行户名
	acct varchar(30) NOT NULL, -- 银行账号
	id_no varchar(18) NULL, -- 证件号码
	id_type varchar(2) NULL, -- 证件类型
	amt numeric(17, 2) NOT NULL, -- 拨付金额
	memo varchar(200) NULL, -- 备注
	bank_no varchar(20) NULL, -- 银行联行号
	sb_serial varchar(20) NULL, -- 业务财务流水号
	payee_type varchar(2) NOT NULL, -- 支付对象类型 1:单位 2:个人
	is_other_bank varchar(2) NOT NULL, -- 支付类型 1:本行 2:他行
	core_send_serial varchar(32) NULL, -- 核心渠道流水号
	core_ref_serial varchar(32) NULL, -- 核心结果参考流水号
	pay_send_serial varchar(32) NULL, -- 支付系统渠道流水号
	pay_ref_serial varchar(32) NULL, -- 支付系统结果账参考流水号
	rst_memo varchar(512) NULL, -- 交易结果描述
	status varchar(1) NOT NULL, -- 交易状态
	re_status varchar(1) NOT NULL, -- 回盘状态
	remark varchar(128) NULL, -- 摘要
	addtional varchar(128) NULL, -- 附言
	tran_channel varchar(10) NULL, -- 交易渠道
	back_status varchar(1) NULL, -- 是否退汇处理  1.有做退汇处理
	bank_name varchar(400) NULL, -- 姓名
	ignore_limit varchar(1) NULL, -- 是否忽略最高限额  1 是   0 否
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_scsb_bat_detail PRIMARY KEY (bat_no, det_no)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.bat_no IS '社保代发批次号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.det_no IS '序号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.sb_no IS '个人编号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail."name" IS '银行户名';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.acct IS '银行账号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.id_no IS '证件号码';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.amt IS '拨付金额';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.memo IS '备注';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.bank_no IS '银行联行号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.sb_serial IS '业务财务流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.payee_type IS '支付对象类型 1:单位 2:个人';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.is_other_bank IS '支付类型 1:本行 2:他行';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.core_send_serial IS '核心渠道流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.core_ref_serial IS '核心结果参考流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.pay_send_serial IS '支付系统渠道流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.pay_ref_serial IS '支付系统结果账参考流水号';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.rst_memo IS '交易结果描述';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.status IS '交易状态';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.re_status IS '回盘状态';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.remark IS '摘要';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.addtional IS '附言';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.tran_channel IS '交易渠道';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.back_status IS '是否退汇处理  1.有做退汇处理';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.bank_name IS '姓名';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.ignore_limit IS '是否忽略最高限额  1 是   0 否';
COMMENT ON COLUMN crmdm.ybt_scsb_bat_detail.ryzd IS '冗余字段';


-- crmdm.ybt_sys_dict_data 定义

-- Drop table

-- DROP TABLE crmdm.ybt_sys_dict_data;

CREATE TABLE crmdm.ybt_sys_dict_data (
	dict_code numeric(20) NOT NULL, -- 字典主键seq_sys_dict_data.nextval
	dict_sort numeric(4) NULL, -- 字典排序
	dict_label varchar(100) NULL, -- 字典标签
	dict_value varchar(100) NULL, -- 字典键值
	dict_type varchar(100) NULL, -- 字典类型
	css_class varchar(100) NULL, -- 样式属性（其他样式扩展）
	list_class varchar(100) NULL, -- 表格回显样式
	is_default bpchar(1) NULL, -- 是否默认（Y是 N否）
	status bpchar(1) NULL, -- 状态（0正常 1停用）
	create_by varchar(64) NULL, -- 创建者
	create_time sys."date" NULL, -- 创建时间
	update_by varchar(64) NULL, -- 更新者
	update_time sys."date" NULL, -- 更新时间
	remark varchar(500) NULL, -- 备注
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_sys_dict_data PRIMARY KEY (dict_code)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_sys_dict_data.dict_code IS '字典主键seq_sys_dict_data.nextval';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.dict_sort IS '字典排序';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.dict_label IS '字典标签';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.dict_value IS '字典键值';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.dict_type IS '字典类型';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.css_class IS '样式属性（其他样式扩展）';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.list_class IS '表格回显样式';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.is_default IS '是否默认（Y是 N否）';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.create_by IS '创建者';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.create_time IS '创建时间';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.update_by IS '更新者';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.update_time IS '更新时间';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.remark IS '备注';
COMMENT ON COLUMN crmdm.ybt_sys_dict_data.ryzd IS '冗余字段';


-- crmdm.ybt_sysb_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ybt_sysb_fee_list;

CREATE TABLE crmdm.ybt_sysb_fee_list (
	query_serial varchar(120) NOT NULL, -- 查询流水
	pay_serial varchar(120) NULL, -- 缴费流水
	service_id varchar(20) NOT NULL, -- 服务ID
	batch_no varchar(32) NULL, -- 批次号
	item_id varchar(40) NOT NULL, -- 项目编号
	id_type varchar(3) NOT NULL, -- 证件类型
	id_no varchar(88) NOT NULL, -- 证件号码
	user_name varchar(200) NULL, -- 姓名
	user_id varchar(120) NULL, -- 人员编码
	user_type varchar(1) NULL, -- 缴费人员类型  0：城乡居民  1：灵活就业人员
	user_insurance_type varchar(5) NULL, -- 险种： 00000 代表全部险种 10210 城乡居民养老保险 10212 城乡居民医疗保险 10201养老保险 10203医疗保险
	pay_type varchar(1) NULL, -- 缴费类型：0现金；1转账
	pay_acct_no varchar(200) NULL, -- 付款账号
	pay_acct_name varchar(400) NULL, -- 付款账号名称
	total_amt numeric(18, 2) NOT NULL, -- 总金额
	pay_date varchar(4) NULL, -- 缴费年份
	start_date varchar(6) NULL, -- 费款所属期起
	end_date varchar(6) NULL, -- 费款所属期止
	base_amt numeric(18, 2) NULL, -- 缴费基数
	amt numeric(18, 2) NULL, -- 缴费档次金额
	tax_serial varchar(80) NULL, -- 税务交易流水
	bank_serial varchar(160) NULL, -- 银行缴费流水号
	print_count varchar(50) NULL, -- 打印次数
	vor_type varchar(1) NULL, -- 凭证类型
	det_count numeric NULL, -- 总数量
	ac_bank_type varchar(4) NULL, -- 经办银行种类代码
	ac_bank_code varchar(12) NULL, -- 经办银行代码
	ac_bank_name varchar(320) NULL, -- 经办银行名称
	sett_date varchar(8) NULL, -- 日切日期
	sett_bank_type varchar(4) NULL, -- 结算银行种类代码
	sett_bank_code varchar(12) NULL, -- 结算银行代码
	sett_bank_name varchar(320) NULL, -- 结算银行名称
	sett_bank_account varchar(50) NULL, -- 结算银行帐号
	tax_no varchar(30) NULL, -- 税票号码
	ret_code varchar(12) NULL, -- 返回结果
	ret_msg varchar(500) NULL, -- 返回信息
	ac_branch varchar(8) NULL, -- 经办机构
	sett_branch varchar(8) NULL, -- 结算机构
	zhaiyoms varchar(1200) NULL, -- 短信摘要描述
	ori_acct_no varchar(200) NULL, -- 原付款账号
	swjgmc varchar(400) NULL, -- 税务机关名称
	swjgdm varchar(20) NULL, -- 税务机关代码
	dcmc varchar(120) NULL, -- 档次名称
	chk_status varchar(1) NULL, -- 核对状态
	trans_type varchar(10) NULL, -- "交易类型：01：个人税务批扣缴费； 02：个人税务实时缴费； 03：个人银行查询缴费 "
	chk_amt numeric(18, 2) NULL, -- 核对金额
	chk_date varchar(8) NULL, -- 扣款日期
	chk_memo varchar(800) NULL, -- 失败原因
	phone varchar(60) NULL, -- 手机号码
	address varchar(300) NULL, -- 联系地址
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_sysb_fee_list PRIMARY KEY (query_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.query_serial IS '查询流水';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.pay_serial IS '缴费流水';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.service_id IS '服务ID';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.batch_no IS '批次号';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.item_id IS '项目编号';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.id_type IS '证件类型';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.id_no IS '证件号码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.user_name IS '姓名';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.user_id IS '人员编码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.user_type IS '缴费人员类型  0：城乡居民  1：灵活就业人员';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.user_insurance_type IS '险种： 00000 代表全部险种 10210 城乡居民养老保险 10212 城乡居民医疗保险 10201养老保险 10203医疗保险';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.pay_type IS '缴费类型：0现金；1转账';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.pay_acct_no IS '付款账号';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.pay_acct_name IS '付款账号名称';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.total_amt IS '总金额';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.pay_date IS '缴费年份';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.start_date IS '费款所属期起';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.end_date IS '费款所属期止';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.base_amt IS '缴费基数';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.amt IS '缴费档次金额';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.tax_serial IS '税务交易流水';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.bank_serial IS '银行缴费流水号';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.print_count IS '打印次数';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.vor_type IS '凭证类型';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.det_count IS '总数量';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ac_bank_type IS '经办银行种类代码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ac_bank_code IS '经办银行代码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ac_bank_name IS '经办银行名称';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.sett_date IS '日切日期';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.sett_bank_type IS '结算银行种类代码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.sett_bank_code IS '结算银行代码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.sett_bank_name IS '结算银行名称';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.sett_bank_account IS '结算银行帐号';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.tax_no IS '税票号码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ret_code IS '返回结果';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ret_msg IS '返回信息';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ac_branch IS '经办机构';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.sett_branch IS '结算机构';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.zhaiyoms IS '短信摘要描述';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ori_acct_no IS '原付款账号';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.swjgmc IS '税务机关名称';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.swjgdm IS '税务机关代码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.dcmc IS '档次名称';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.chk_status IS '核对状态';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.trans_type IS '"交易类型：01：个人税务批扣缴费； 02：个人税务实时缴费； 03：个人银行查询缴费 "';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.chk_amt IS '核对金额';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.chk_date IS '扣款日期';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.chk_memo IS '失败原因';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.phone IS '手机号码';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.address IS '联系地址';
COMMENT ON COLUMN crmdm.ybt_sysb_fee_list.ryzd IS '冗余字段';


-- crmdm.ybt_ybt_insurance_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_insurance_base_info;

CREATE TABLE crmdm.ybt_ybt_insurance_base_info (
	insurance_id varchar(200) NOT NULL, -- 险种ID
	item_id varchar(40) NOT NULL, -- 保险公司编号（项目编号 )
	item_name varchar(800) NOT NULL, -- 保险公司名称（项目名称 )
	insurance_code varchar(200) NOT NULL, -- 险种代码
	main_insurance_code varchar(200) NOT NULL, -- 险种对应的主险种编码
	insurance_name varchar(800) NOT NULL, -- 险种名称
	insurance_type varchar(8) NOT NULL, -- 主附险标志（0：主险，1附加险 )
	insurance_classify varchar(40) NOT NULL, -- 险种分类:详见SYS_DICT_DATA表DICT_VALUE,DICT_LABEL字段,条件DICT_TYPE= sys_bankInsurance_insuranceType
	is_can_payall varchar(8) NOT NULL, -- 是否支持趸交（0：支持，1：不支持 )
	is_can_pay_part varchar(8) NOT NULL, -- 是否支持期交（0：支持，1：不支持 )
	is_part_buy varchar(8) NOT NULL, -- 是否按份购买（0：是，1：不是 )
	lowest_part numeric(10) NOT NULL, -- 最低购买份数
	trial_method varchar(8) NOT NULL, -- 保费试算方式(0：按保费算，1 按保额算  )
	trial_type varchar(8) NOT NULL, -- 保额/保费类型 (0：固定保额/保费,1：最低保额/保费 )
	trialamt numeric(17, 2) NOT NULL, -- 保额/保费
	insurance_status varchar(8) NOT NULL, -- 险种状态（0：正常 ，1 失效 )
	insurance_remark varchar(2000) NULL, -- 险种描述
	create_time sys."date" NULL, -- 新增时间（yyyyMMdd HH:mm:ss )
	create_user varchar(200) NULL, -- 新增用户编号
	create_user_name varchar(800) NULL, -- 新增用户名
	update_time sys."date" NULL, -- 最近一次修改时间（yyyyMMdd HH:mm:ss )
	update_user varchar(200) NULL, -- 最近一次修改用户编号
	update_user_name varchar(800) NULL, -- 最近一次修改用户名
	accumulation_amt numeric(17, 2) NULL, -- 保额/保费单次累加金额
	sttlmnt_pymnt_age varchar(40) NULL, -- 年金起领年龄
	auto_pay_show_flag varchar(40) NULL, -- 垫交方式选择标识
	sttlmnt_pymnt_freq varchar(40) NULL, -- 年金领取频率(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)
	sttlmnt_pymnt_type varchar(40) NULL, -- 年金领取方式(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)
	sttlmnt_pymnt_end_age varchar(40) NULL, -- 年金止领年龄
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_id IS '险种ID';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.item_id IS '保险公司编号（项目编号 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.item_name IS '保险公司名称（项目名称 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_code IS '险种代码';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.main_insurance_code IS '险种对应的主险种编码';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_name IS '险种名称';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_type IS '主附险标志（0：主险，1附加险 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_classify IS '险种分类:详见SYS_DICT_DATA表DICT_VALUE,DICT_LABEL字段,条件DICT_TYPE= sys_bankInsurance_insuranceType';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.is_can_payall IS '是否支持趸交（0：支持，1：不支持 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.is_can_pay_part IS '是否支持期交（0：支持，1：不支持 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.is_part_buy IS '是否按份购买（0：是，1：不是 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.lowest_part IS '最低购买份数';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.trial_method IS '保费试算方式(0：按保费算，1 按保额算  )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.trial_type IS '保额/保费类型 (0：固定保额/保费,1：最低保额/保费 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.trialamt IS '保额/保费';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_status IS '险种状态（0：正常 ，1 失效 )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.insurance_remark IS '险种描述';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.create_time IS '新增时间（yyyyMMdd HH:mm:ss )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.create_user IS '新增用户编号';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.create_user_name IS '新增用户名';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.update_time IS '最近一次修改时间（yyyyMMdd HH:mm:ss )';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.update_user IS '最近一次修改用户编号';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.update_user_name IS '最近一次修改用户名';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.accumulation_amt IS '保额/保费单次累加金额';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_age IS '年金起领年龄';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.auto_pay_show_flag IS '垫交方式选择标识';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_freq IS '年金领取频率(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_type IS '年金领取方式(弃用,年金信息使用YBT_INSURANCE_STTLMNT_INFO表存储)';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.sttlmnt_pymnt_end_age IS '年金止领年龄';
COMMENT ON COLUMN crmdm.ybt_ybt_insurance_base_info.ryzd IS '冗余字段';


-- crmdm.ybt_ybt_policy_base_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_policy_base_info;

CREATE TABLE crmdm.ybt_ybt_policy_base_info (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号
	is_real varchar(8) NOT NULL, -- 是否是非实时出单:0：是 1：否
	cont_no varchar(200) NULL, -- 保险单号
	proposal_prt_no varchar(200) NOT NULL, -- 投保单号
	cont_prt_no varchar(200) NULL, -- 保单合同印刷号
	accept_date varchar(32) NOT NULL, -- 投保日期(yyyyMMdd )
	appointvali_date varchar(32) NULL, -- 保单预约生效日期(yyyyMMdd )
	vali_date varchar(32) NULL, -- 保单实际生效日期(yyyyMMdd )
	insuend_date varchar(32) NULL, -- 保单满期日期(yyyyMMdd )
	pay_start_date varchar(32) NULL, -- 保单首期缴费日期(yyyyMMdd )
	payend_date varchar(32) NULL, -- 保单缴费满期日期(yyyyMMdd )
	product_id varchar(200) NOT NULL, -- 投保产品Id
	product_name varchar(800) NOT NULL, -- 投保产品名称
	cont_status varchar(8) NOT NULL, -- 保单状态:0：未生效 1：正常（新单承保、正常续期中） 2：失效（当日撤单，犹豫期退保、犹豫期外退保、满期给付、理赔终止、其他终止）
	cont_source varchar(8) NOT NULL, -- 保单来源 :0：柜面 1：手机银行
	risk_grade varchar(8) NOT NULL, -- 最高可承受风险等级：1：极低 2：低 3：中 4：高 5：极高
	commission_type varchar(8) NOT NULL, -- 承保手续费收取方式：0:不涉及 1:按保额收取 2:按保费收取
	commission_ratio numeric(6, 3) NULL, -- 手续费比例(% )
	commissionamt numeric(17, 2) NULL, -- 保单承保手续费
	acc_name varchar(200) NOT NULL, -- 账户姓名
	acc_no varchar(200) NOT NULL, -- 银行账户
	get_pol_mode varchar(8) NULL, -- 保单递送方式：1:邮寄 2:柜面领取 3:上门递送 4:电子保单（针对电子渠道：网银、手机银行、自助终端等） 5:部门发送
	throw_com varchar(200) NOT NULL, -- 投保网点代码
	throw_com_name varchar(800) NULL, -- 投保网点名称
	throw_com_certi_code varchar(200) NULL, -- 投保网点许可证
	teller_name varchar(800) NULL, -- 投保销售人员姓名
	teller_id varchar(80) NULL, -- 投保销售人员工号
	teller_certi_code varchar(200) NULL, -- 投保销售人员资格证
	teller_email varchar(200) NULL, -- 投保销售人员电子邮箱
	manager_no varchar(200) NULL, -- 投保网点分管代理保险负责人工号
	manager_name varchar(800) NULL, -- 投保网点分管代理保险负责人姓名
	agent_code varchar(200) NULL, -- 代理人编码
	agent_name varchar(800) NULL, -- 代理人姓名
	agent_grp_code varchar(200) NULL, -- 代理人组别编码
	agent_grp_name varchar(200) NULL, -- 代理人组别
	agent_com varchar(200) NULL, -- 代理网点编码
	agent_com_name varchar(800) NULL, -- 代理网点名称
	com_code varchar(200) NULL, -- 代理机构编码
	com_location varchar(800) NULL, -- 承保公司地址
	com_name varchar(800) NULL, -- 承保公司名称
	com_zip_code varchar(200) NULL, -- 承保公司邮编
	com_phone varchar(80) NULL, -- 保险公司热线
	job_notice varchar(8) NULL, -- 职业告知(是否从事风险置业): Y-是,N-否
	health_notice varchar(8) NULL, -- 健康告知(是否存在健康风险): Y-是,N-否
	policy_indicator varchar(8) NULL, -- 未成年被保险人在其他保险公司是否有投保Y-有，N-无
	total_faceamount numeric(17, 2) NULL, -- 未成年被保险人在其他保险公司累计投保身故保额
	hesitate_end_date varchar(32) NULL, -- 保单犹豫期结束日期
	acc_transfer_num varchar(200) NULL, -- 客户转账授权码
	acc_eff_date varchar(8) NULL, -- 客户银行卡有效日期
	quality_status varchar(2) NULL, -- 双录状态 0-未检查，1-合规，2-待整改，3-已整改待确认，4-已整改确认，99-新建，1-作废
	session_id varchar(800) NULL, -- 保单可回溯SessionId值
	plat_date varchar(8) NULL, -- 平台日期(yyyyMMdd)
	plat_time varchar(6) NULL, -- 平台时间(HHmmss)
	record_no varchar(256) NULL, -- 双录系统流水号
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_ybt_policy_base_info PRIMARY KEY (plat_policy_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.item_id IS '中间业务缴费项目编号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.is_real IS '是否是非实时出单:0：是 1：否';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.proposal_prt_no IS '投保单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_prt_no IS '保单合同印刷号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.accept_date IS '投保日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.appointvali_date IS '保单预约生效日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.vali_date IS '保单实际生效日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.insuend_date IS '保单满期日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.pay_start_date IS '保单首期缴费日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.payend_date IS '保单缴费满期日期(yyyyMMdd )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.product_id IS '投保产品Id';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.product_name IS '投保产品名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_status IS '保单状态:0：未生效 1：正常（新单承保、正常续期中） 2：失效（当日撤单，犹豫期退保、犹豫期外退保、满期给付、理赔终止、其他终止）';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.cont_source IS '保单来源 :0：柜面 1：手机银行';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.risk_grade IS '最高可承受风险等级：1：极低 2：低 3：中 4：高 5：极高';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.commission_type IS '承保手续费收取方式：0:不涉及 1:按保额收取 2:按保费收取';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.commission_ratio IS '手续费比例(% )';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.commissionamt IS '保单承保手续费';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_name IS '账户姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_no IS '银行账户';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.get_pol_mode IS '保单递送方式：1:邮寄 2:柜面领取 3:上门递送 4:电子保单（针对电子渠道：网银、手机银行、自助终端等） 5:部门发送';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.throw_com IS '投保网点代码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.throw_com_name IS '投保网点名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.throw_com_certi_code IS '投保网点许可证';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_name IS '投保销售人员姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_id IS '投保销售人员工号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_certi_code IS '投保销售人员资格证';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.teller_email IS '投保销售人员电子邮箱';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.manager_no IS '投保网点分管代理保险负责人工号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.manager_name IS '投保网点分管代理保险负责人姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_code IS '代理人编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_name IS '代理人姓名';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_grp_code IS '代理人组别编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_grp_name IS '代理人组别';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_com IS '代理网点编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.agent_com_name IS '代理网点名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_code IS '代理机构编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_location IS '承保公司地址';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_name IS '承保公司名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_zip_code IS '承保公司邮编';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.com_phone IS '保险公司热线';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.job_notice IS '职业告知(是否从事风险置业): Y-是,N-否';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.health_notice IS '健康告知(是否存在健康风险): Y-是,N-否';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.policy_indicator IS '未成年被保险人在其他保险公司是否有投保Y-有，N-无';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.total_faceamount IS '未成年被保险人在其他保险公司累计投保身故保额';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.hesitate_end_date IS '保单犹豫期结束日期';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_transfer_num IS '客户转账授权码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.acc_eff_date IS '客户银行卡有效日期';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.quality_status IS '双录状态 0-未检查，1-合规，2-待整改，3-已整改待确认，4-已整改确认，99-新建，1-作废';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.session_id IS '保单可回溯SessionId值';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.plat_date IS '平台日期(yyyyMMdd)';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.plat_time IS '平台时间(HHmmss)';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.record_no IS '双录系统流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_base_info.ryzd IS '冗余字段';


-- crmdm.ybt_ybt_policy_fee_list 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_policy_fee_list;

CREATE TABLE crmdm.ybt_ybt_policy_fee_list (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	cont_no varchar(200) NULL, -- 保险单号
	ord_item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号：104001：大家  104002：和谐 104003：太平洋 104004：中国人寿
	ord_type varchar(16) NOT NULL, -- 中间业务订单类型:PY-消费,RE-退款
	ord_id varchar(200) NOT NULL, -- 中间业务订单号
	ord_ori_id varchar(200) NULL, -- 中间业务原订单号
	ord_memo varchar(2000) NULL, -- 中间业务订单描述
	ord_amt numeric(17, 2) NULL, -- 订单总保费
	pre_amt numeric(17, 2) NULL, -- 中间业务订单总保额
	ord_create_date varchar(32) NULL, -- 中间业务订单创建日期
	ord_create_time varchar(24) NULL, -- 中间业务订单创建时间
	ord_expires_date varchar(32) NULL, -- 中间业务订单过期日期
	ord_expires_time varchar(24) NULL, -- 中间业务订单过期时间
	ord_pay_serial varchar(200) NULL, -- 中间业务订单支付/退款流水号
	ord_link_user_name varchar(800) NULL, -- 中间业务订单用户名称
	ord_link_user_phone varchar(200) NULL, -- 中间业务订单用户联系方式
	ordpayeracc_no varchar(200) NULL, -- 付款账户
	ordpayeracc_name varchar(800) NULL, -- 付款账户名称
	ordpayer_bank_no varchar(200) NULL, -- 付款银行行号
	ordpayer_bank_name varchar(800) NULL, -- 付款银行名称
	ord_payee_acct_no varchar(200) NULL, -- 中间业务订单收款账户
	ord_payee_acct_name varchar(800) NULL, -- 中间业务订单收款账户名称
	ord_payee_bank_no varchar(200) NULL, -- 付款银行行号
	ord_payee_bank_name varchar(800) NULL, -- 付款银行名称
	ord_part_pay_flag varchar(8) NULL, -- 中间业务订单允许部分支付标识:0-不允许,1-允许
	ord_thr_sum_amt numeric(17, 2) NULL, -- 中间业务订单关联的第三方订单/缴费号的总金额
	ord_thr_payed_amt numeric(17, 2) NOT NULL, -- 中间业务订单关联的第三方订单/缴费号的已支付金额
	ord_tran_status varchar(8) NULL, -- 交易状态：0:未缴费 1:缴费处理中 2:缴费成功 3:缴费失败
	tran_type varchar(8) NULL, -- 交易类型：0:新单承保 1:续期缴费 2:已当日撤单 3:犹豫期退保 4:犹豫期外退保 5:满期给付 6:理赔终止 7保险公司其他保全 8：终止撤销 9：复效
	tran_soure varchar(8) NOT NULL, -- 交易渠道：1：柜面 2：手机银行 3：保险公司
	prem_text varchar(200) NULL, -- 交易金额大写
	trans_no varchar(200) NULL, -- 保险公司交易流水号
	hole_memo1 varchar(800) NULL, -- 备用字段1
	hole_memo2 varchar(800) NULL, -- 备用字段2
	hole_memo3 varchar(800) NULL, -- 备用字段3
	ryzd varchar(1) NULL, -- 冗余字段
	CONSTRAINT pk_ybt_ybt_policy_fee_list PRIMARY KEY (plat_policy_serial)
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_item_id IS '中间业务缴费项目编号：104001：大家  104002：和谐 104003：太平洋 104004：中国人寿';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_type IS '中间业务订单类型:PY-消费,RE-退款';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_id IS '中间业务订单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_ori_id IS '中间业务原订单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_memo IS '中间业务订单描述';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_amt IS '订单总保费';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.pre_amt IS '中间业务订单总保额';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_create_date IS '中间业务订单创建日期';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_create_time IS '中间业务订单创建时间';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_expires_date IS '中间业务订单过期日期';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_expires_time IS '中间业务订单过期时间';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_pay_serial IS '中间业务订单支付/退款流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_link_user_name IS '中间业务订单用户名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_link_user_phone IS '中间业务订单用户联系方式';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ordpayeracc_no IS '付款账户';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ordpayeracc_name IS '付款账户名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ordpayer_bank_no IS '付款银行行号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ordpayer_bank_name IS '付款银行名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_payee_acct_no IS '中间业务订单收款账户';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_payee_acct_name IS '中间业务订单收款账户名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_payee_bank_no IS '付款银行行号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_payee_bank_name IS '付款银行名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_part_pay_flag IS '中间业务订单允许部分支付标识:0-不允许,1-允许';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_thr_sum_amt IS '中间业务订单关联的第三方订单/缴费号的总金额';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_thr_payed_amt IS '中间业务订单关联的第三方订单/缴费号的已支付金额';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ord_tran_status IS '交易状态：0:未缴费 1:缴费处理中 2:缴费成功 3:缴费失败';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.tran_type IS '交易类型：0:新单承保 1:续期缴费 2:已当日撤单 3:犹豫期退保 4:犹豫期外退保 5:满期给付 6:理赔终止 7保险公司其他保全 8：终止撤销 9：复效';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.tran_soure IS '交易渠道：1：柜面 2：手机银行 3：保险公司';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.prem_text IS '交易金额大写';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.trans_no IS '保险公司交易流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.hole_memo1 IS '备用字段1';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.hole_memo2 IS '备用字段2';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.hole_memo3 IS '备用字段3';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_fee_list.ryzd IS '冗余字段';


-- crmdm.ybt_ybt_policy_insurance_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_policy_insurance_info;

CREATE TABLE crmdm.ybt_ybt_policy_insurance_info (
	plat_policy_serial varchar(200) NOT NULL, -- 保单平台流水号
	item_id varchar(40) NOT NULL, -- 中间业务缴费项目编号
	cont_no varchar(200) NULL, -- 保险单号
	insurance_id varchar(200) NOT NULL, -- 险种ID
	insurance_code varchar(200) NOT NULL, -- 险种代码
	main_insurance_code varchar(200) NOT NULL, -- 险种对应的主险种编码
	insurance_name varchar(800) NOT NULL, -- 险种名称
	insurance_type varchar(8) NOT NULL, -- 主附险标志
	sum_buy_part numeric(10) NOT NULL, -- 投保份数
	sum_pre numeric(17, 2) NOT NULL, -- 险种总保额
	sum_cov numeric(17, 2) NOT NULL, -- 险种总保费
	pay_type varchar(8) NOT NULL, -- 缴费类型:0-趸交,1-期缴
	pay_freq varchar(16) NULL, -- 期缴缴费频次(缴费类型为趸交时无值):12-年交,6-半年交,3-季交,1-月交,-1-不定期交
	pay_per_unit varchar(16) NULL, -- 期缴缴费周期计算单位(缴费类型为趸交时无值):12-按年计算,1-按月计算,2-按日计算,0-交至某确定年龄,-1-终生交费
	pay_per_num numeric(10) NULL, -- 期缴缴费周期计算数量
	valid_per_unit varchar(16) NOT NULL, -- 保险周期计算单位:12-按年计算,1-按月保计算,2-按日计算,0-保至某确定年龄,-1-保终身
	valid_per_num numeric(10) NOT NULL, -- 保险周期计算数量
	bonus_get_mode varchar(8) NULL, -- 红利领取方式:1-累计生息,3-抵交保费,4-现金领取,5-增额交清
	auto_pay_flag varchar(8) NULL, -- 自动垫交标志:0-否,1-是
	lxgetintv varchar(16) NULL, -- 万能险领取方式:0-趸领,1-月领,12-年领
	sttlmnt_pymnt_age varchar(40) NULL, -- 年金起领年龄
	sttlmnt_pymnt_freq varchar(40) NULL, -- 年金领取频率:使用YBT_INSURANCE_STTLMNT_INFO表存储
	sttlmnt_pymnt_type varchar(40) NULL, -- 年金领取方式:使用YBT_INSURANCE_STTLMNT_INFO表存储
	sttlmnt_pymnt_end_age varchar(40) NULL, -- 年金止领年龄
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.plat_policy_serial IS '保单平台流水号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.item_id IS '中间业务缴费项目编号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.cont_no IS '保险单号';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.insurance_id IS '险种ID';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.insurance_code IS '险种代码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.main_insurance_code IS '险种对应的主险种编码';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.insurance_name IS '险种名称';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.insurance_type IS '主附险标志';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sum_buy_part IS '投保份数';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sum_pre IS '险种总保额';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sum_cov IS '险种总保费';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.pay_type IS '缴费类型:0-趸交,1-期缴';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.pay_freq IS '期缴缴费频次(缴费类型为趸交时无值):12-年交,6-半年交,3-季交,1-月交,-1-不定期交';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.pay_per_unit IS '期缴缴费周期计算单位(缴费类型为趸交时无值):12-按年计算,1-按月计算,2-按日计算,0-交至某确定年龄,-1-终生交费';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.pay_per_num IS '期缴缴费周期计算数量';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.valid_per_unit IS '保险周期计算单位:12-按年计算,1-按月保计算,2-按日计算,0-保至某确定年龄,-1-保终身';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.valid_per_num IS '保险周期计算数量';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.bonus_get_mode IS '红利领取方式:1-累计生息,3-抵交保费,4-现金领取,5-增额交清';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.auto_pay_flag IS '自动垫交标志:0-否,1-是';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.lxgetintv IS '万能险领取方式:0-趸领,1-月领,12-年领';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sttlmnt_pymnt_age IS '年金起领年龄';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sttlmnt_pymnt_freq IS '年金领取频率:使用YBT_INSURANCE_STTLMNT_INFO表存储';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sttlmnt_pymnt_type IS '年金领取方式:使用YBT_INSURANCE_STTLMNT_INFO表存储';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.sttlmnt_pymnt_end_age IS '年金止领年龄';
COMMENT ON COLUMN crmdm.ybt_ybt_policy_insurance_info.ryzd IS '冗余字段';


-- crmdm.ybt_ybt_product_branch 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_product_branch;

CREATE TABLE crmdm.ybt_ybt_product_branch (
	product_id varchar(200) NOT NULL, -- 产品ID
	branch_no varchar(200) NOT NULL, -- 网点编码
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_product_branch.product_id IS '产品ID';
COMMENT ON COLUMN crmdm.ybt_ybt_product_branch.branch_no IS '网点编码';
COMMENT ON COLUMN crmdm.ybt_ybt_product_branch.ryzd IS '冗余字段';


-- crmdm.ybt_ybt_product_info 定义

-- Drop table

-- DROP TABLE crmdm.ybt_ybt_product_info;

CREATE TABLE crmdm.ybt_ybt_product_info (
	product_id varchar(200) NOT NULL, -- 产品ID
	item_id varchar(40) NOT NULL, -- 保险公司编号(项目编号）
	item_name varchar(800) NOT NULL, -- 保险公司名称(项目名称）
	product_name varchar(800) NOT NULL, -- 产品名称
	commission_type varchar(8) NOT NULL, -- 收取类型：0-不涉及,1-按保额收取,2-按保费收取
	commission_ratio numeric(6, 3) NOT NULL, -- 手续费比例(%）
	risk_grade varchar(8) NOT NULL, -- 产品风险等级
	product_big_type varchar(40) NOT NULL, -- 产品监管大分类编码
	product_lit_type varchar(40) NOT NULL, -- 产品监管小分类编码
	product_remark varchar(2000) NULL, -- 产品描述
	product_status varchar(8) NOT NULL, -- 产品状态:0-正常,1-失效
	create_time sys."date" NULL, -- 新增时间(yyyyMMdd HH:mm:ss）
	create_user varchar(200) NOT NULL, -- 新增用户编号
	create_user_name varchar(800) NULL, -- 新增用户名
	update_time sys."date" NULL, -- 最近一次修改时间(yyyyMMdd HH:mm:ss）
	update_user varchar(200) NULL, -- 最近一次修改用户编号
	update_user_name varchar(800) NULL, -- 最近一次修改用户名
	is_recommend varchar(2) NULL, -- 是否主推产品: 1:是 0:否
	ryzd varchar(1) NULL -- 冗余字段
);

-- Column comments

COMMENT ON COLUMN crmdm.ybt_ybt_product_info.product_id IS '产品ID';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.item_id IS '保险公司编号(项目编号）';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.item_name IS '保险公司名称(项目名称）';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.product_name IS '产品名称';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.commission_type IS '收取类型：0-不涉及,1-按保额收取,2-按保费收取';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.commission_ratio IS '手续费比例(%）';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.risk_grade IS '产品风险等级';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.product_big_type IS '产品监管大分类编码';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.product_lit_type IS '产品监管小分类编码';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.product_remark IS '产品描述';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.product_status IS '产品状态:0-正常,1-失效';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.create_time IS '新增时间(yyyyMMdd HH:mm:ss）';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.create_user IS '新增用户编号';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.create_user_name IS '新增用户名';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.update_time IS '最近一次修改时间(yyyyMMdd HH:mm:ss）';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.update_user IS '最近一次修改用户编号';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.update_user_name IS '最近一次修改用户名';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.is_recommend IS '是否主推产品: 1:是 0:否';
COMMENT ON COLUMN crmdm.ybt_ybt_product_info.ryzd IS '冗余字段';
