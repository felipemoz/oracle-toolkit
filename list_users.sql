
COL username             FOR A25
COL account_status       FOR A16 HEAD 'ACCOUNT|STATUS'
COL lock_date            HEAD 'LOCK|DATE'
COL expiry_date          HEAD 'EXPIRY|DATE'
COL default_tablespace   FOR A21 HEAD 'DEFAULT|TABLESPACE'
COL temporary_tablespace FOR A16 HEAD 'TEMPORARY|TABLESPACE'
COL profile              FOR A18

PROMPT
PROMPT ALL USERS
PROMPT

SELECT username
,      created
,      account_status
,      lock_date
,      expiry_date
,      profile
,      default_tablespace
,      temporary_tablespace
  FROM dba_users
 ORDER BY 1
/

PROMPT
PROMPT NON DEFAULT USERS
PROMPT

SELECT username
,      created
,      account_status
,      lock_date
,      expiry_date
,      default_tablespace
,      temporary_tablespace
  FROM dba_users 
 WHERE username NOT IN (SELECT user_name 
                          FROM sys.default_pwd$)
 ORDER BY 1
/

PROMPT
PROMPT ROLE DBA
PROMPT

select a.grantee
,      a.granted_role 
,      b.account_status
  from dba_role_privs a
,      dba_users b
 where a.granted_role = 'DBA' 
   and a.grantee = b.username
 order by a.grantee
/

