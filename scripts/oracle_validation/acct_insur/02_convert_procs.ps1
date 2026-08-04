# Convert PRC_DWD_ACCT_INSUR to Oracle 11g syntax (SCOTT).
# Removes crmdm. schema prefix, writes UTF-8 without BOM.

$ErrorActionPreference = 'Stop'

$srcDir = 'data_assets\stored_procedure\ods_to_dwd'
$outDir = 'scripts\oracle_validation\acct_insur'

if ($outDir -notmatch '^scripts\\oracle_validation') {
    throw "Isolation violation: output directory must be under scripts\oracle_validation"
}

$text = Get-Content -LiteralPath (Join-Path $srcDir 'PRC_DWD_ACCT_INSUR.sql') -Raw -Encoding UTF8
$text = $text -replace 'crmdm\.', ''
$text = $text -replace 'END\s*;\s*$', "END;`n/"
$out  = Join-Path $outDir 'oracle_PRC_DWD_ACCT_INSUR.sql'
[System.IO.File]::WriteAllText($out, $text, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "WROTE $out"
