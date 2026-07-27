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
