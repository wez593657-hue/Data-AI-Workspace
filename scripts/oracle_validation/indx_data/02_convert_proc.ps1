# Convert PRC_ADS_STAT_INDX_DATA to an Oracle 11g SCOTT-only test copy.
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$source = Join-Path $repoRoot 'data_assets\stored_procedure\dws_to_ads\PRC_ADS_STAT_INDX_DATA.sql'
$target = Join-Path $PSScriptRoot 'oracle_PRC_ADS_STAT_INDX_DATA.sql'

if (-not (Test-Path -LiteralPath $source)) {
    throw "Source procedure does not exist: $source"
}

$convertedText = [System.IO.File]::ReadAllText($source, [System.Text.Encoding]::UTF8)
$convertedText = $convertedText -replace 'crmdm\.', ''

# Oracle uses EXCLUSIVE where Kingbase uses ACCESS EXCLUSIVE for the shared TMP-table lock.
$convertedText = $convertedText -replace '(?i)IN\s+ACCESS\s+EXCLUSIVE\s+MODE\s+NOWAIT', 'IN EXCLUSIVE MODE NOWAIT'

# Keep Chinese diagnostic literals out of the legacy local SQL*Plus client output.
$convertedText = [regex]::Replace($convertedText, "LOG_STEP\('(?:[^']|'')*'\);", "LOG_STEP('STEP');")
$convertedText = $convertedText -replace 'END\s*;\s*$', "END;`r`n/"

if ($convertedText -notmatch '(?i)CREATE\s+OR\s+REPLACE\s+PROCEDURE' -or $convertedText.Length -lt 10000) {
    throw "Oracle conversion produced an incomplete procedure copy (length=$($convertedText.Length))."
}

[System.IO.File]::WriteAllText($target, $convertedText, [System.Text.UTF8Encoding]::new($false))
Write-Output "WROTE $target"
