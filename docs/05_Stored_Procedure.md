# 05 存储过程规范

## 5.1 概述

本规范定义了 Kingbase 数据库存储过程的统一开发标准，确保存储过程的可维护性、可追溯性和安全性。

### 模板优先原则

开发存储过程时，**必须优先使用 `templates/` 目录下的存储过程模板文件**，模板文件优先级高于本规范文档中的示例代码。

| 模板文件 | 路径 | 适用场景 |
|----------|------|----------|
| `procedure_template.sql` | [templates/procedure_template.sql](file:///d:/AI/AI-Workspace/Kingbase-CRM-AI-Development-Guide/templates/procedure_template.sql) | Kingbase/PostgreSQL 风格存储过程 |
| `PRC_模板.sql` | [templates/PRC_模板.sql](file:///d:/AI/AI-Workspace/Kingbase-CRM-AI-Development-Guide/templates/PRC_模板.sql) | Oracle 兼容模式存储过程 |

当 `templates/` 目录下存在存储过程模板时，必须基于模板文件进行开发，本规范文档仅作为规则约束和参考说明。

## 5.2 存储过程统一流程

开发或修改存储过程前，必须先检索 `data_assets/reference_logic/` 中的参考逻辑文件，并检查 `data_assets/stored_procedure/` 中已有的相似过程。详细规则见 `governance/stored_procedure_reference_logic_rules.md`。

当使用 `data_assets/reference_logic/MTS_OBJECT.sql` 作为逻辑口径或筛选条件依据时，必须在 SQL 注释或配套需求文档中逐项标注来源文件、MTS 对象/字段、具体条件和定位依据；不得只标记“参考 MTS”。

```
参数检查
    │
    ▼
日志开始
    │
    ▼
业务处理
    │
    ▼
异常处理
    │
    ▼
事务提交
    │
    ▼
日志结束
```

## 5.3 存储过程模板

### 5.3.1 模板选择规则

开发存储过程时，**必须按照以下优先级选择模板**：

1. **优先使用 `templates/` 目录下的模板文件**：
   - Kingbase/PostgreSQL 风格：使用 [templates/procedure_template.sql](file:///d:/AI/AI-Workspace/Kingbase-CRM-AI-Development-Guide/templates/procedure_template.sql)
   - Oracle 兼容模式：使用 [templates/PRC_模板.sql](file:///d:/AI/AI-Workspace/Kingbase-CRM-AI-Development-Guide/templates/PRC_模板.sql)

2. **模板文件不存在时**：可参考本规范文档中的示例代码结构进行开发

### 5.3.2 基本结构

```sql
CREATE OR REPLACE PROCEDURE proc_crm_customer_update(
    p_customer_id IN VARCHAR(50),
    p_customer_name IN VARCHAR(200),
    p_customer_status IN VARCHAR(20),
    p_result_code OUT INT,
    p_result_msg OUT VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
DECLARE
    -- 变量声明
    v_start_time TIMESTAMP := NOW();
    v_end_time TIMESTAMP;
    v_duration INTERVAL;
BEGIN
    -- ====================
    -- 步骤 1: 参数检查
    -- ====================
    IF p_customer_id IS NULL OR p_customer_id = '' THEN
        p_result_code := -1;
        p_result_msg := '客户ID不能为空';
        RAISE NOTICE '参数检查失败: 客户ID为空';
        RETURN;
    END IF;

    IF p_customer_name IS NULL OR p_customer_name = '' THEN
        p_result_code := -2;
        p_result_msg := '客户名称不能为空';
        RAISE NOTICE '参数检查失败: 客户名称为空';
        RETURN;
    END IF;

    -- ====================
    -- 步骤 2: 日志开始
    -- ====================
    RAISE NOTICE '存储过程 proc_crm_customer_update 开始执行';
    RAISE NOTICE '输入参数: customer_id=%, customer_name=%', p_customer_id, p_customer_name;

    -- ====================
    -- 步骤 3: 业务处理
    -- ====================
    BEGIN
        UPDATE crm_customer 
        SET 
            customer_name = p_customer_name,
            customer_status = p_customer_status,
            update_time = NOW()
        WHERE customer_id = p_customer_id;

        IF NOT FOUND THEN
            p_result_code := -3;
            p_result_msg := '客户不存在';
            RAISE NOTICE '客户不存在: customer_id=%', p_customer_id;
            RETURN;
        END IF;

        -- 记录更新日志
        INSERT INTO crm_customer_log (
            customer_id,
            operation_type,
            operation_time,
            operator
        ) VALUES (
            p_customer_id,
            'UPDATE',
            NOW(),
            CURRENT_USER
        );

        -- ====================
        -- 步骤 4: 事务提交
        -- ====================
        COMMIT;

        p_result_code := 0;
        p_result_msg := '更新成功';

    EXCEPTION
        -- ====================
        -- 步骤 5: 异常处理
        -- ====================
        WHEN OTHERS THEN
            ROLLBACK;
            p_result_code := SQLSTATE;
            p_result_msg := SQLERRM;
            RAISE NOTICE '异常发生: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;
            RETURN;
    END;

    -- ====================
    -- 步骤 6: 日志结束
    -- ====================
    v_end_time := NOW();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE '存储过程 proc_crm_customer_update 执行完成';
    RAISE NOTICE '执行时间: %', v_duration;
    RAISE NOTICE '输出结果: result_code=%, result_msg=%', p_result_code, p_result_msg;

END $$;
```

### 5.3.3 调用方式

```sql
-- 调用存储过程
CALL proc_crm_customer_update(
    p_customer_id => 'C001',
    p_customer_name => '新客户名称',
    p_customer_status => 'ACTIVE',
    p_result_code => :result_code,
    p_result_msg => :result_msg
);

-- 查看结果
SELECT :result_code, :result_msg;
```

## 5.4 参数规范

### 5.4.1 参数命名

| 类型 | 前缀 | 示例 |
|------|------|------|
| 输入参数 | `p_` | `p_customer_id`, `p_customer_name` |
| 输出参数 | `p_out_` 或 `p_result_` | `p_result_code`, `p_result_msg` |
| 内部变量 | `v_` | `v_start_time`, `v_end_time` |

### 5.4.2 参数检查

```sql
-- 非空检查
IF p_param IS NULL OR p_param = '' THEN
    p_result_code := -1;
    p_result_msg := '参数不能为空';
    RETURN;
END IF;

-- 格式检查
IF NOT p_email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
    p_result_code := -2;
    p_result_msg := '邮箱格式不正确';
    RETURN;
END IF;

-- 范围检查
IF p_amount < 0 THEN
    p_result_code := -3;
    p_result_msg := '金额不能为负数';
    RETURN;
END IF;
```

## 5.5 事务管理

```sql
BEGIN
    -- 开启事务（可选，Kingbase 默认自动开启）
    BEGIN TRANSACTION;

    -- 业务操作
    UPDATE crm_order SET order_status = 'PAID' WHERE order_id = p_order_id;

    INSERT INTO crm_payment (order_id, payment_amount)
    VALUES (p_order_id, p_amount);

    -- 提交事务
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- 回滚事务
        ROLLBACK;
        RAISE;
END;
```

## 5.6 异常处理

### 5.6.1 统一异常码

| 异常码 | 说明 | 处理方式 |
|--------|------|----------|
| 0 | 成功 | 返回成功信息 |
| -1 | 参数错误 | 返回参数错误信息 |
| -2 | 业务规则校验失败 | 返回业务错误信息 |
| -3 | 数据不存在 | 返回数据不存在信息 |
| -4 | 数据已存在 | 返回数据已存在信息 |
| -100 | 系统错误 | 返回系统错误信息 |
| SQLSTATE | 数据库错误 | 返回数据库错误码和信息 |

### 5.6.2 异常捕获

```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_result_code := -3;
        p_result_msg := '数据不存在';
    
    WHEN UNIQUE_VIOLATION THEN
        ROLLBACK;
        p_result_code := -4;
        p_result_msg := '数据已存在';
    
    WHEN OTHERS THEN
        ROLLBACK;
        p_result_code := SQLSTATE;
        p_result_msg := SQLERRM;
```

## 5.7 日志规范

### 5.7.1 日志内容

| 阶段 | 日志内容 |
|------|----------|
| 开始 | 存储过程名称、开始时间、输入参数 |
| 参数检查 | 参数检查结果 |
| 业务处理 | 关键步骤、处理数据量 |
| 异常 | 异常代码、异常信息 |
| 结束 | 结束时间、执行时长、输出结果 |

### 5.7.2 日志输出

```sql
-- 开始日志
RAISE NOTICE '存储过程 % 开始执行，时间: %', 'proc_name', NOW();
RAISE NOTICE '输入参数: param1=%, param2=%', p_param1, p_param2;

-- 业务日志
RAISE NOTICE '处理记录数: %', FOUND;

-- 异常日志
RAISE NOTICE '异常: SQLSTATE=%, SQLERRM=%', SQLSTATE, SQLERRM;

-- 结束日志
RAISE NOTICE '存储过程 % 执行完成，时长: %', 'proc_name', v_duration;
RAISE NOTICE '输出: code=%, msg=%', p_result_code, p_result_msg;
```

## 5.8 临时表使用

### 5.8.1 命名与目录规范

存储过程中使用的临时表统一采用 `TMP_` 前缀的物理表，命名格式为 `TMP_{结果表}_{用途}`。

**临时表 DDL 必须同步生成为独立文件**，存放于 `data_assets/ddl/tmp/` 目录，每个存储过程对应一个 `.ddl` 文件，包含该过程使用的所有 TMP 表。文件命名格式为 `tmp_pro_{过程名小写}.ddl`。

> 仅实际使用物理临时表的过程才需要对应的临时表 DDL。`PRC_DWD_ACCT_INSUR` 已改为使用 SQL CTE 完成中间计算，不再维护物理 TMP 表。

```sql
CREATE OR REPLACE PROCEDURE proc_crm_order_sync()
LANGUAGE plpgsql
AS $$
DECLARE
    v_batch_size INT := 1000;
BEGIN
    -- 步骤 1: 创建临时表存储待同步数据
    CREATE TABLE IF NOT EXISTS TMP_CRM_ORDER_PENDING AS
    SELECT order_id, customer_id, order_amount
    FROM crm_order
    WHERE sync_status = 'PENDING';

    RAISE NOTICE '待同步订单数量: %', (SELECT COUNT(*) FROM TMP_CRM_ORDER_PENDING);

    -- 步骤 2: 分批处理
    LOOP
        EXIT WHEN NOT EXISTS (SELECT 1 FROM TMP_CRM_ORDER_PENDING);

        -- 处理一批数据
        UPDATE crm_order 
        SET sync_status = 'SYNCING'
        WHERE order_id IN (
            SELECT order_id FROM TMP_CRM_ORDER_PENDING LIMIT v_batch_size
        );

        -- 模拟同步操作
        PERFORM pg_sleep(0.1);

        -- 更新状态
        UPDATE crm_order 
        SET sync_status = 'SYNCED', sync_time = NOW()
        WHERE sync_status = 'SYNCING';

        -- 删除已处理数据
        DELETE FROM TMP_CRM_ORDER_PENDING 
        WHERE order_id IN (
            SELECT order_id FROM crm_order WHERE sync_status = 'SYNCED'
        );

        RAISE NOTICE '已同步批次，剩余: %', (SELECT COUNT(*) FROM TMP_CRM_ORDER_PENDING);
    END LOOP;

    -- 步骤 3: 清理临时表（物理表需手动清理）
    DROP TABLE IF EXISTS TMP_CRM_ORDER_PENDING;

END $$;
```

### 5.8.2 冗余校验简化

编写存储过程逻辑时，**只保留必要的业务逻辑，去除所有冗余校验和转换**：

- ❌ 禁止对已是正确类型的字段做冗余类型转换（如对 NUMBER 字段调用 `TO_NUMBER`）
- ❌ 禁止对源数据已保证格式的字段做重复格式校验
- ❌ 禁止在注释中嵌入可被代码直接表达的逻辑说明
- ✅ 参数校验仅保留 `IS NULL` + `LENGTH` 检查，不写正则
- ✅ 日期转换直接使用 `TO_DATE`，不预校验格式

### 5.8.3 行内注释规范

所有行内字段注释必须予以保留，并遵循以下格式规范：

1. **简单字段**（无函数调用、无复杂表达式）：注释放在字段之后，与字段在同一行内，使用 `--` 对齐。
2. **复杂字段**（包含函数调用、CASE 表达式、条件判断）：注释另起一行书写，置于表达式之前，确保与对应字段在视觉上保持清晰的关联性。
3. **CASE 各分支**：行内简短注释，标注分支含义。

```sql
-- 正确示例
SELECT
    D.cust_id,                                                        -- 客户编号
    D.cust_typ,                                                       -- 客户类型
    TO_CHAR(MIN(D.accept_date_parsed), 'YYYYMMDD'),                   -- 交易日期，取最小投保日期
    -- 最近交易日期：COALESCE(最近缴费成功日期, 投保日期回退)
    COALESCE(TO_CHAR(MAX(AG.last_success_tx_date), 'YYYYMMDD'),
             TO_CHAR(MIN(D.accept_date_parsed), 'YYYYMMDD')),
    CASE
        WHEN MIN(D.valid_per_unit) = '-1' THEN '9999-12-31'           -- 永久有效
        WHEN MIN(D.valid_per_unit) = '12' THEN TO_CHAR(...)           -- 年单位
    END
```

### 5.8.4 临时表字段命名规范

临时表的**字段名称必须与源表或目标表保持严格一致**，禁止随意修改字段名称，以保证字段血缘可追溯、下游口径不漂移。

**仅以下两种特殊情况允许使用新字段名**：

| 特殊情况 | 说明 | 示例 |
|----------|------|------|
| a) 字段含义与源表/目标表存在显著差异 | 临时表字段承载的业务含义已与源字段不同，需新命名以表达真实语义 | 源表 `AMT`（发生额）在临时表中聚合为 `SUM_AMT`（累计金额） |
| b) 该字段不存在于源表或目标表中 | 临时表为中间计算新增的字段（如处理标记、派生日期、序号），源表/目标表无对应字段 | `ROW_NO`、`PROC_FLAG`、`DATA_DATE` 快照列 |

```sql
-- 正确示例：与源表字段名严格一致
INSERT INTO TMP_CRM_ORDER_PENDING
    (cust_id, acct_no, insur_prdt_id, valid_per_unit)
SELECT
    cust_id, acct_no, insur_prdt_id, valid_per_unit   -- 字段名与源表一致
FROM FMS_T1_CUST_FNC_ACCT;

-- 反例：随意修改字段名，禁止
INSERT INTO TMP_CRM_ORDER_PENDING
    (cust_no, acct_code, prdt_id, valid_unit)         -- ✗ 字段名与源表不一致
```

### 5.8.5 代码注释要求

存储过程的**每一段逻辑中**，所有**字段定义、条件判断及参数声明之后**必须添加清晰、准确的中文注释，说明其**用途、取值范围及业务逻辑依据**：

1. **参数声明**：注释说明参数用途与合法取值（如 `-- 数据日期 (格式: YYYYMMDD)`）。
2. **字段定义**：`SELECT` 列表与临时表字段定义之后逐列注释，说明业务含义；复杂表达式（函数调用、CASE、条件判断）注释另起一行置于表达式之前，保持视觉关联。
3. **条件判断**：`WHERE`、`CASE WHEN`、`IF` 等条件之后注释说明筛选/分支的业务逻辑依据。
4. **取值说明**：有取值范围或枚举含义的字段，注释中标注取值范围（如 `-- 状态: 0-未处理, 1-已处理`）。

```sql
-- 正确示例
CREATE OR REPLACE PROCEDURE crmdm.proc_demo(
  v_sysdat  VARCHAR,        -- 数据日期 (格式: YYYYMMDD)
  outcde    OUT INTEGER     -- 执行结果状态码 (0: 成功, -1: 失败)
)
...
SELECT
    D.cust_id,                                                    -- 客户编号
    D.acct_state,                                                 -- 账户状态 (1-正常, 2-冻结, 3-销户)
    -- 最近交易日期：取投保日期与缴费成功日期中的较大值
    COALESCE(MAX(D.accept_date), MAX(AG.last_success_tx_date))
FROM DWD_ACCT_INSUR D
WHERE D.acct_state IN ('1', '2')                                  -- 仅统计正常与冻结账户
  AND D.data_date = v_sysdat                                      -- 仅取当日数据
```

### 5.8.6 字段映射一致性验证

扫描存储过程时，必须**检查临时表与源表/目标表的字段映射关系**，确保**字段名称、数据类型及长度的一致性**：

1. **字段名称**：临时表字段名与源表/目标表字段名严格一致（见 5.8.4 的两类例外）。
2. **数据类型**：临时表字段类型与源表/目标表字段类型一致，禁止隐式类型转换（如源表 NUMBER 在临时表声明为 VARCHAR）。
3. **长度**：临时表字段长度不得小于源表/目标表字段长度，防止截断。
4. **修正要求**：对不符合规范的字段命名、类型或长度进行修正，并同步更新对应的 `data_assets/ddl/tmp/` 临时表 DDL 文件与存储过程 INSERT 语句。

校验依据 `data_assets/ddl/tmp/tmp_pro_*.ddl` 与源表/目标表 DDL（`data_assets/ddl/ods/`、`data_assets/ddl/dwd/`、`data_assets/ddl/dws/`、`data_assets/ddl/ads/`）交叉比对。

## 5.9 存储过程命名规范

命名格式：`pro_{结果表}`

| 层 | 示例 |
|----|------|
| DWD层 | `PRC_dwd_cust_indv_info` |
| DWS层 | `PRC_dws_cust_deadline_rmnd` |
| ADS层 | `PRC_ads_cust_deadline_rmnd_dtl` |

文件命名格式：`pro_{结果表}.sql`

| 目录 | 示例文件 |
|------|----------|
| ods_to_dwd | `PRC_dwd_cust_indv_info.sql` |
| dwd_to_dws | `PRC_dws_cust_deadline_rmnd.sql` |
| dws_to_ads | `PRC_ads_cust_deadline_rmnd_dtl.sql` |

## 5.10 禁止事项

- ❌ 禁止存储过程中不进行参数检查
- ❌ 禁止存储过程中不处理异常
- ❌ 禁止存储过程中不记录日志
- ❌ 禁止存储过程中使用隐式事务
- ❌ 禁止存储过程中包含过多业务逻辑（建议拆分为多个小存储过程）
