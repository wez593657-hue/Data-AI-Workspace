# Convert new-customer procedures to Oracle 11g syntax (SCOTT schema).
# Names fit 30 chars; fixes trailing "END ;" and writes UTF-8 without BOM.

$ErrorActionPreference = 'Stop'

$srcDir = 'data_assets\stored_procedure\dws_to_ads'
$outDir = 'scripts\oracle_validation\new_cust'

if ($outDir -notmatch '^scripts\\oracle_validation') {
    throw "Isolation violation: output directory must be under scripts\oracle_validation"
}

$files = @(
    'PRC_ADS_CUST_NEW_CUST_DTL.sql',
    'PRC_ADS_CUST_NEW_CUST_STATIS.sql'
)

foreach ($f in $files) {
    $text = Get-Content -LiteralPath (Join-Path $srcDir $f) -Raw -Encoding UTF8
    $text = $text -replace 'END\s*;\s*$', "END;`n/"
    $out  = Join-Path $outDir ('oracle_' + $f)
    if ($out -match '^data_assets\\') {
        throw "Isolation violation: refusing to write under data_assets: $out"
    }
    [System.IO.File]::WriteAllText($out, $text, (New-Object System.Text.UTF8Encoding($false)))
    Write-Output "WROTE $out"
}
