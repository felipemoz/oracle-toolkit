
COL parameter_name  FOR A30
COL parameter_value FOR A15
COL audit_trail     FOR A20

SELECT parameter_name
,      parameter_value
,      audit_trail 
  FROM dba_audit_mgmt_config_params;

COL value FOR A30
  
SELECT value
  FROM v$parameter
 WHERE name = 'audit_trail';