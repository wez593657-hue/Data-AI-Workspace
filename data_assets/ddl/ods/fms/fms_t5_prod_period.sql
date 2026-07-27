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
