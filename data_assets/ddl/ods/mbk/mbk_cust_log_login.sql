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
