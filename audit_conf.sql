

COL parameter_name FOR a30
COL parameter_value FOR a30

show parameter audit

SELECT audit_trail
,      parameter_name
,      parameter_value
  FROM dba_audit_mgmt_config_params
 ORDER BY 1,2;
 
select * from all_def_audit_opts;
select * from dba_obj_audit_opts;
select * from dba_priv_audit_opts order by PRIVILEGE; 
select * from dba_stmt_audit_opts order by AUDIT_OPTION;

/*
SELECT username
,      priv_used
,      ses_actions 
  FROM dba_audit_object 
 GROUP BY username
,      priv_used
,      ses_actions
 ORDER BY 1,2
*/


--SELECT * FROM dba_audit_trail WHERE username = 'BR94257' order by timestamp;
--SELECT * FROM dba_audit_object WHERE username = 'BR94257' order by timestamp;
--SELECT * FROM dba_audit_statement WHERE username = 'BR94257' order by timestamp;



PROMPT Habilita auditoria
PROMPT 
PROMPT Audit alter any table by access;
PROMPT Audit create any table by access;
PROMPT Audit drop any table by access;
PROMPT Audit Create any procedure by access;
PROMPT Audit Drop any procedure by access;
PROMPT Audit Alter any procedure by access;
PROMPT Audit Grant any privilege by access;
PROMPT Audit grant any object privilege by access;
PROMPT Audit grant any role by access;
PROMPT Audit audit system by access;
PROMPT Audit create external job by access;
PROMPT Audit create any job by access;
PROMPT Audit create any library by access;
PROMPT Audit create public database link by access;
PROMPT Audit exempt access policy by access;
PROMPT Audit alter user by access;
PROMPT Audit create user by access;
PROMPT Audit role by access;
PROMPT Audit create session by access;
PROMPT Audit drop user by access;
PROMPT Audit alter database by access;
PROMPT Audit alter system by access;
PROMPT Audit alter profile by access;
PROMPT Audit drop profile by access;
PROMPT Audit database link by access;
PROMPT Audit system audit by access;
PROMPT Audit profile by access;
PROMPT Audit public synonym by access;
PROMPT Audit system grant by access;


