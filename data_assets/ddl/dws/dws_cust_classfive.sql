CREATE TABLE crmdm.dws_cust_classfive (
    persn_legal_bk_code varchar(30) NULL, -- 法人行号
    data_date varchar(8), --数据日期
    cust_id varchar(21) NOT NULL, -- 客户编号
    class_five varchar(2)   --五级分类
);
COMMENT ON TABLE crmdm.dws_cust_classfive IS '客户五级分类';
COMMENT ON COLUMN crmdm.dws_cust_classfive.cust_id IS '客户编号';
COMMENT ON COLUMN crmdm.dws_cust_classfive.data_date IS '数据日期';
COMMENT ON COLUMN crmdm.dws_cust_classfive.class_five IS '五级分类';
COMMENT ON COLUMN crmdm.dws_cust_classfive.persn_legal_bk_code IS '法人行号';