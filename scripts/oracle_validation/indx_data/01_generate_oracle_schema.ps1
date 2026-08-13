$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$out = Join-Path $PSScriptRoot '01_setup_tables.sql'

$sourceNames = @(
  'dwd_sys_org.sql', 'dwd_mkt_act_info.sql', 'dwd_mkt_act_targt.sql',
  'dwd_mkt_tsk_info.sql', 'dwd_mkt_indx_tsk.sql', 'dwd_mkt_tsk_indx_sub.sql',
  'dws_cust_lvl_info.sql', 'dwd_cust_man.sql', 'dws_cust_asse_liab.sql',
  'dwd_cust_indv_info.sql', 'dwd_acct_insur.sql', 'dwd_acct_depo.sql',
  'mbk_cust_info.sql', 'mbk_cust_log_login.sql', 'crm_sys_post.sql',
  'uepp_pay_mct_info.sql', 'uepp_pay_order_info.sql',
  'uepp_pay_mct_settle_account.sql'
)

function Convert-CreateTable([string]$text) {
  $table = [regex]::Match($text, '(?i)CREATE TABLE(?:\s+IF NOT EXISTS)?\s+(?:\w+\.)?(\w+)')
  if (-not $table.Success) { throw "未找到 CREATE TABLE 定义" }

  # Parse column tokens rather than executing the source text verbatim. Several
  # generated DDL files put a later column after a -- comment on the same line.
  # The token stream remains authoritative and contains every field/type pair.
  $pattern = '(?i)(?<![A-Z0-9_])([A-Z][A-Z0-9_]*)\s+(VARCHAR(?:\s*\(\s*\d+\s*\))?|CHAR(?:\s*\(\s*\d+\s*\))?|BPCHAR(?:\s*\(\s*\d+\s*\))?|NUMBER(?:\s*\(\s*\d+(?:\s*,\s*\d+)?\s*\))?|NUMERIC(?:\s*\(\s*\d+(?:\s*,\s*\d+)?\s*\))?|DATE|TIMESTAMP)\s*(NOT\s+NULL|NULL)?'
  $columns = [regex]::Matches($text, $pattern)
  if ($columns.Count -eq 0) { throw "未找到字段定义: $($table.Groups[1].Value)" }

  $defs = [System.Collections.Generic.List[string]]::new()
  foreach ($column in $columns) {
    $name = $column.Groups[1].Value.ToUpper()
    $type = $column.Groups[2].Value.ToUpper() -replace '^NUMERIC', 'NUMBER'
    if ($type -eq 'VARCHAR') { $type = 'VARCHAR2(4000)' }
    elseif ($type -match '^VARCHAR\s*\(') { $type = $type -replace '^VARCHAR', 'VARCHAR2' }
    elseif ($type -eq 'BPCHAR') { $type = 'CHAR(1)' }
    elseif ($type -match '^BPCHAR\s*\(') { $type = $type -replace '^BPCHAR', 'CHAR' }
    $nullability = $column.Groups[3].Value.ToUpper() -replace '\s+', ' '
    $defs.Add("    $name $type $nullability".TrimEnd())
  }

  $pk = [regex]::Match($text, '(?i)(?:CONSTRAINT\s+\w+\s+)?PRIMARY\s+KEY\s*\(([^\)]+)\)')
  if ($pk.Success) { $defs.Add('    PRIMARY KEY (' + $pk.Groups[1].Value.ToUpper() + ')') }
  return 'CREATE TABLE ' + $table.Groups[1].Value.ToUpper() + " (`n" + ($defs -join ",`n") + "`n);`n/`n"
}

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK")
$lines.Add("SET DEFINE OFF")
$lines.Add("SET SERVEROUTPUT ON")
$lines.Add("BEGIN")
$lines.Add("  FOR x IN (SELECT object_name, object_type FROM user_objects WHERE object_name IN (")
$dropNames = @('ADS_STAT_INDX_RULE','ADS_STAT_INDX_DATA','ADS_STAT_INDX_BASELINE_MEMBER','ADS_STAT_INDX_BASELINE_DTL','ADS_STAT_INDX_BASELINE_SUM','TMP_STAT_INDX_SCOPE','TMP_STAT_INDX_BAL_AGGR','TMP_STAT_INDX_CUST_STATE','TMP_STAT_INDX_AGGR','TMP_STAT_INDX_AGGR_A','TMP_STAT_INDX_AGGR_B') + ($sourceNames | Where-Object { $_ -ne 'dwd_sys_org.sql' } | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_).ToUpper() }) + @('DEPO_VALUE_INIT','CRM_SYS_POST','SYS_PRC_STEP_LOGS_DUMMY')
$lines.Add("    '" + ($dropNames -join "','") + "')) LOOP")
$lines.Add("    BEGIN EXECUTE IMMEDIATE 'DROP ' || x.object_type || ' ' || x.object_name; EXCEPTION WHEN OTHERS THEN NULL; END;")
$lines.Add("  END LOOP;")
$lines.Add("END;")
$lines.Add("/")

$lines.Add('CREATE TABLE TMP_STAT_INDX_SCOPE (path_code VARCHAR2(1), statis_dim VARCHAR2(100), indx_code VARCHAR2(100), data_blng VARCHAR2(100), blng_type VARCHAR2(1), blng_id VARCHAR2(40), term_begin_date VARCHAR2(8), persn_legal_bk_code VARCHAR2(30));')
$lines.Add('CREATE TABLE TMP_STAT_INDX_BAL_AGGR (path_code VARCHAR2(1), statis_dim VARCHAR2(100), data_blng VARCHAR2(100), persn_legal_bk_code VARCHAR2(30), curnt_aum NUMBER, yr_begin_aum NUMBER, mth_end_aum NUMBER, qrt_end_aum NUMBER, curnt_yr_avg_aum NUMBER, prev_yr_avg_aum NUMBER, curnt_mth_avg_aum NUMBER, prev_mth_avg_aum NUMBER);')
$lines.Add('CREATE TABLE TMP_STAT_INDX_CUST_STATE (path_code VARCHAR2(1), statis_dim VARCHAR2(100), indx_code VARCHAR2(100), data_blng VARCHAR2(100), cust_id VARCHAR2(20), persn_legal_bk_code VARCHAR2(30), base_cust_lvl VARCHAR2(2), curnt_cust_lvl VARCHAR2(2), base_mth_avg_aum NUMBER, curnt_mth_avg_aum NUMBER);')
$lines.Add('CREATE TABLE TMP_STAT_INDX_AGGR (path_code VARCHAR2(1), data_date VARCHAR2(8), data_blng VARCHAR2(100), statis_dim VARCHAR2(100), statis_calib VARCHAR2(100), indx_code VARCHAR2(100), curnt_val NUMBER, term_last_val NUMBER, persn_legal_bk_code VARCHAR2(30));')
$lines.Add('CREATE TABLE ADS_STAT_INDX_DATA (data_date VARCHAR2(8), data_blng VARCHAR2(100), statis_dim VARCHAR2(100), statis_calib VARCHAR2(100), indx_code VARCHAR2(100), curnt_val NUMBER, term_last_val NUMBER, persn_legal_bk_code VARCHAR2(30));')
$lines.Add('CREATE TABLE ADS_STAT_INDX_BASELINE_MEMBER (statis_calib VARCHAR2(100), statis_dim VARCHAR2(100), data_blng VARCHAR2(100), cust_id VARCHAR2(20), persn_legal_bk_code VARCHAR2(30), base_data_date VARCHAR2(8), base_run_date VARCHAR2(8));')
$lines.Add('CREATE TABLE ADS_STAT_INDX_BASELINE_DTL (statis_calib VARCHAR2(100), statis_dim VARCHAR2(100), indx_code VARCHAR2(100), data_blng VARCHAR2(100), cust_id VARCHAR2(20), persn_legal_bk_code VARCHAR2(30), base_data_date VARCHAR2(8), base_run_date VARCHAR2(8), base_cust_lvl VARCHAR2(2), base_mth_avg_aum NUMBER);')
$lines.Add('CREATE TABLE ADS_STAT_INDX_BASELINE_SUM (statis_calib VARCHAR2(100), statis_dim VARCHAR2(100), indx_code VARCHAR2(100), data_blng VARCHAR2(100), persn_legal_bk_code VARCHAR2(30), base_data_date VARCHAR2(8), base_run_date VARCHAR2(8), base_loan_bal NUMBER, base_yr_avg_fin NUMBER, base_mth_avg_fin NUMBER, base_yr_avg_agen_fin NUMBER, base_mth_avg_agen_fin NUMBER);')
$lines.Add('CREATE TABLE ADS_STAT_INDX_RULE (indx_code VARCHAR2(100) PRIMARY KEY, indx_name VARCHAR2(200), calc_class VARCHAR2(30), is_enabled CHAR(1), effective_bgn_date VARCHAR2(8), effective_end_date VARCHAR2(8), stat_unit VARCHAR2(20), sort_no NUMBER, remark VARCHAR2(1000));')

foreach ($name in $sourceNames) {
  if ($name -eq 'dwd_sys_org.sql') { continue }
  $path = Get-ChildItem -LiteralPath (Join-Path $root 'data_assets\ddl') -Recurse -File -Filter $name | Select-Object -First 1 -ExpandProperty FullName
  if (-not $path) { throw "缺少真实 DDL: $name" }
  $lines.Add("-- SOURCE DDL: $path")
  $lines.Add((Convert-CreateTable (Get-Content -LiteralPath $path -Raw)))
}

$lines.Add("-- DEPO_VALUE_INIT: four columns confirmed by the indicator requirements card.")
$lines.Add("CREATE TABLE DEPO_VALUE_INIT (ORG_ID VARCHAR2(7), PERSN_LEGAL_BK_CODE VARCHAR2(4), MNGR_POST_ID VARCHAR2(20), VALUE_INIT NUMBER(20,2));")
$lines.Add('-- PRC_ADS_STAT_INDX_DATA, SYS_FUN_DEAL_DATE, SYS_PRC_STEP_LOGS are preserved: test the objects already deployed in SCOTT.')
$lines.Add('-- DWD_SYS_ORG was already verified against the real DDL; it is preserved and truncated by the loader.')
[IO.File]::WriteAllLines($out, $lines, [Text.UTF8Encoding]::new($false))
Write-Output $out
