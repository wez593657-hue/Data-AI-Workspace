# Convert potn-upgrade procedures to Oracle 11g syntax (SCOTT schema).
# Oracle 11g object-name limit is 30 chars; both original names exceed it:
#   PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL (34) -> PRC_ADS_CUST_POTN_UPGRADE_DTL (29)
#   PRC_ADS_CUST_POTN_UPGRADE_STATIS   (33) -> PRC_ADS_CUST_POTN_UPGRADE_STAT (28)

$ErrorActionPreference = 'Stop'

$srcDir = 'data_assets\stored_procedure\dws_to_ads'
$outDir = 'scripts\oracle_validation\potn_upgrade'

if ($outDir -notmatch '^scripts\\oracle_validation') {
    throw "Isolation violation: output directory must be under scripts\oracle_validation"
}

$files = @(
    'PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL.sql',
    'PRC_ADS_CUST_POTN_UPGRADE_STATIS.sql'
)

foreach ($f in $files) {
    $text = Get-Content -LiteralPath (Join-Path $srcDir $f) -Raw -Encoding UTF8
    $text = $text -replace 'PRC_ADS_CUST_POTN_UPGRADE_CUST_DTL', 'PRC_ADS_CUST_POTN_UPGRADE_DTL'
    $text = $text -replace 'PRC_ADS_CUST_POTN_UPGRADE_STATIS', 'PRC_ADS_CUST_POTN_UPGRADE_STAT'
    $text = $text -replace 'END\s*;\s*$', "END;`n/"
    $out  = Join-Path $outDir ('oracle_' + $f)
    if ($out -match '^data_assets\\') {
        throw "Isolation violation: refusing to write under data_assets: $out"
    }
    # UTF-8 without BOM (sqlplus rejects BOM on first line)
    [System.IO.File]::WriteAllText($out, $text, (New-Object System.Text.UTF8Encoding($false)))
    Write-Output "WROTE $out"
}
