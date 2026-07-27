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
