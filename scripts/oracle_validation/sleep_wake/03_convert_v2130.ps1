$ErrorActionPreference = 'Stop'

$src = Get-Content -LiteralPath 'data_assets\stored_procedure\dws_to_ads\PRC_ADS_CUST_SLEEP_WAKE_DTL.sql' -Raw -Encoding UTF8

# Fix Chinese in declaration: replace V_PRC_DESC entirely
$src = $src -replace "V_PRC_DESC\s+VARCHAR2?\(\d+\)\s+:=\s*'.*';", "V_PRC_DESC             VARCHAR2(100) := 'sleep wake detail';"

# Fix log messages
$src = $src -replace "V_LOG_MSG\s+:=\s*'TMP1 .+';", "V_LOG_MSG := 'TMP1: cleanup; mon_begin=' || V_IS_MONTH_BEGIN;"
$src = $src -replace "V_LOG_MSG\s+:=\s*'TMP2 .+';", "V_LOG_MSG := 'TMP2: v2.13.0 opt; mon_begin=' || V_IS_MONTH_BEGIN;"
$src = $src -replace "V_LOG_MSG\s+:=\s*'第3段完成.+';", "V_LOG_MSG := 'Step3: write DTL v2.13.0; mon_begin=' || V_IS_MONTH_BEGIN || ')';"
$src = $src -replace "'V_SYSDAT必须为YYYYMMDD格式'", "'V_SYSDAT invalid'"

$src = $src -replace "END;\s*$", "END;`n/"

$out = 'scripts\oracle_validation\sleep_wake\oracle_PRC_ADS_CUST_SLEEP_WAKE_DTL.sql'
[System.IO.File]::WriteAllText($out, $src, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "WROTE oracle DTL"
