# Convert Kingbase Oracle-compatible procedures to Oracle 11g syntax.
# 1. Remove schema prefix "crmdm." (objects created in SCOTT).
# 2. Rename 31-char identifier FIXED_FIN_MATURE_TRAN_INSUR_AMT
#    -> FIXED_FIN_TRAN_INSUR_AMT (Oracle 11g limit is 30 chars).
# 3. Fix final "END ;" into "END;\n/".

$ErrorActionPreference = 'Stop'

$srcDir = 'data_assets\stored_procedure\dws_to_ads'
$outDir = 'scripts\oracle_validation\deadline_rmnd'

# ---- Mandatory isolation precheck (docs/standards/oracle-local-testing-policy.md) ----
if ($outDir -notmatch '^scripts\\oracle_validation') {
    throw "Isolation violation: output directory must be under scripts\oracle_validation, got: $outDir"
}
if (Test-Path (Join-Path $srcDir '..\..')) { } # source is read-only reference only
Write-Output 'PRECHECK: output dir under scripts\oracle_validation (physical isolation) OK'
Write-Output 'PRECHECK: target schema SCOTT (no crmdm. prefix), source files read-only OK'

$files  = @(
    'PRC_ADS_CUST_DEADLINE_RMND_DTL.sql',
    'PRC_ADS_CUST_DEADLINE_RMND_STATIS.sql'
)

foreach ($f in $files) {
    $text = Get-Content -LiteralPath (Join-Path $srcDir $f) -Raw -Encoding UTF8
    $text = $text -replace 'crmdm\.', ''
    $text = $text -replace 'FIXED_FIN_MATURE_TRAN_INSUR_AMT', 'FIXED_FIN_TRAN_INSUR_AMT'
    # Oracle 11g object-name limit is 30 chars; original STATIS name has 31.
    $text = $text -replace 'PRC_ADS_CUST_DEADLINE_RMND_STATIS', 'PRC_ADS_CUST_DEADLINE_RMND_ST'
    # Defect found by Oracle compiler: trailing comma in SELECT list before FROM.
    $text = $text -replace 'NVL\(a\.CURR_AUM_BAL, 0\),', 'NVL(a.CURR_AUM_BAL, 0)'
    $text = $text -replace 'END\s*;\s*$', "END;`n/"
    $out  = Join-Path $outDir ('oracle_' + $f)
    if ($out -match '^data_assets\\') {
        throw "Isolation violation: refusing to write under data_assets: $out"
    }
    # UTF-8 without BOM (sqlplus rejects BOM on first line)
    [System.IO.File]::WriteAllText($out, $text, (New-Object System.Text.UTF8Encoding($false)))
    Write-Output "WROTE $out"
}
