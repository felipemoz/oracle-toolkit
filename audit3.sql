


COL parameter_name  FOR A30
COL parameter_value FOR A15
COL audit_trail     FOR A20

SELECT audit_trail
,      parameter_name
,      parameter_value
  FROM dba_audit_mgmt_config_params
 ORDER BY 1,2
/

SELECT * 
  FROM DBA_STMT_AUDIT_OPTS
 ORDER BY 1,3;
 
SELECT * 
  FROM DBA_PRIV_AUDIT_OPTS
 ORDER BY 1,3;
 
SELECT * FROM DBA_OBJ_AUDIT_OPTS;

SELECT * FROM ALL_DEF_AUDIT_OPTS;

/*

audit ALTER any TABLE BY access;
audit CREATE any TABLE BY access;
audit DROP any TABLE BY access;
audit CREATE any PROCEDURE BY access;
audit DROP any PROCEDURE BY access;
audit ALTER any PROCEDURE BY access;
audit GRANT any privilege BY access;
audit GRANT any object privilege BY access;
audit GRANT any ROLE BY access;
audit audit system BY access;
audit CREATE external job BY access;
audit CREATE any job BY access;
audit CREATE any library BY access;
audit CREATE public DATABASE link BY access;
audit exempt access policy BY access;
audit ALTER USER BY access;
audit CREATE USER BY access;
audit ROLE BY access;
audit CREATE SESSION BY access;
audit DROP USER BY access;
audit ALTER DATABASE BY access;
audit ALTER system BY access;
audit ALTER profile BY access;
audit DROP profile BY access;
audit DATABASE link BY access;
audit system audit BY access;
audit profile BY access;
audit public synonym BY access;
audit system GRANT BY access;

audit DELETE ON sys.aud$;
audit ALTER ON DEFAULT;
audit GRANT ON DEFAULT;

*/