# Convert sleep-wake procedures to Oracle 11g syntax (SCOTT schema).

$ErrorActionPreference = 'Stop'

$srcDir = 'data_assets\stored_procedure\dws_to_ads'
$outDir = 'scripts\oracle_validation\sleep_wake'

if ($outDir -notmatch '^scripts\\oracle_validation') {
    throw "Isolation violation: output directory must be under scripts\oracle_validation"
}

$files = @(
    'PRC_ADS_CUST_SLEEP_WAKE_DTL.sql',
    'PRC_ADS_CUST_SLEEP_WAKE_STATIS.sql'
)

foreach ($f in $files) {
    $text = Get-Content -LiteralPath (Join-Path $srcDir $f) -Raw -Encoding UTF8
    # DEFECT-SLEEP-001 (test copy only): [D] UPDATE subquery references alias "a"
    # which does not exist; derived table alias is "sw". Source file not modified.
    $text = $text -replace 'NVL\(a\.DEPO_CURNT_DEPO_BAL, b\.DEPO_CURNT_DEPO_BAL\)', 'NVL(sw.DEPO_CURNT_DEPO_BAL, b.DEPO_CURNT_DEPO_BAL)'
    $text = $text -replace 'NVL\(a\.FIXD_DEPO_BAL, b\.FIXD_DEPO_BAL\)', 'NVL(sw.FIXD_DEPO_BAL, b.FIXD_DEPO_BAL)'
    $text = $text -replace 'NVL\(a\.FIN_BAL, b\.FIN_AMT\)', 'NVL(sw.FIN_BAL, b.FIN_AMT)'
    $text = $text -replace 'NVL\(a\.INSUR_BAL, b\.INSUR_AMT\)', 'NVL(sw.INSUR_BAL, b.INSUR_AMT)'
    $text = $text -replace 'END\s*;\s*$', "END;`n/"
    $out  = Join-Path $outDir ('oracle_' + $f)
    if ($out -match '^data_assets\\') {
        throw "Isolation violation: refusing to write under data_assets: $out"
    }
    [System.IO.File]::WriteAllText($out, $text, (New-Object System.Text.UTF8Encoding($false)))
    Write-Output "WROTE $out"
}
