SET LINESIZE 240
SET PAGESIZE 500
SELECT object_name, object_type, status
  FROM user_objects
 WHERE object_name IN ('DWD_SYS_ORG', 'DWD_MKT_ACT_INFO', 'DWD_MKT_ACT_TARGT', 'DWD_MKT_TSK_INFO', 'PRC_ADS_STAT_INDX_DATA', 'SYS_FUN_DEAL_DATE')
 ORDER BY object_name, object_type;

SELECT synonym_name, table_owner, table_name
  FROM user_synonyms
 WHERE synonym_name = 'DWD_SYS_ORG';

SELECT table_name, column_id, column_name, data_type, data_length, nullable
  FROM user_tab_columns
WHERE table_name IN ('DWD_SYS_ORG', 'DWD_MKT_ACT_INFO', 'DWD_MKT_ACT_TARGT', 'DWD_MKT_TSK_INFO')
 ORDER BY column_id;

SELECT name, type, referenced_name, referenced_type
  FROM user_dependencies
 WHERE referenced_name = 'DWD_SYS_ORG'
 ORDER BY name, type;

EXIT SUCCESS
