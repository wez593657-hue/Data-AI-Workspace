# 05 存储过程规范

## 5.1 概述

本规范定义了 Kingbase 数据库存储过程的统一开发标准，确保存储过程的可维护性、可追溯性和安全性。

## 5.2 存储过程统一流程

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

### 5.3.1 基本结构

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

### 5.3.2 调用方式

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

存储过程中使用的临时表统一采用 `TMP_` 前缀的物理表，命名格式为 `TMP_{结果表}_{用途}`。

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

## 5.9 存储过程命名规范

命名格式：`pro_{结果表}`

| 层 | 示例 |
|----|------|
| DWD层 | `pro_dwd_cust_indv_info` |
| DWS层 | `pro_dws_cust_deadline_rmnd` |
| ADS层 | `pro_ads_cust_deadline_rmnd_dtl` |

文件命名格式：`pro_{结果表}.sql`

| 目录 | 示例文件 |
|------|----------|
| ods_to_dwd | `pro_dwd_cust_indv_info.sql` |
| dwd_to_dws | `pro_dws_cust_deadline_rmnd.sql` |
| dws_to_ads | `pro_ads_cust_deadline_rmnd_dtl.sql` |

## 5.10 禁止事项

- ❌ 禁止存储过程中不进行参数检查
- ❌ 禁止存储过程中不处理异常
- ❌ 禁止存储过程中不记录日志
- ❌ 禁止存储过程中使用隐式事务
- ❌ 禁止存储过程中包含过多业务逻辑（建议拆分为多个小存储过程）
