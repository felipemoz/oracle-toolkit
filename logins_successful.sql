SELECT 'Informacoes para o periodo de ' || MIN(timestamp) || ' a ' || MAX(timestamp) AUDIT_RETENTION
  FROM dba_audit_trail;

PROMPT
PROMPT Logins successful total:
PROMPT

SELECT COUNT(1) logins_successful
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode = 0;   

BREAK ON DATA SKIP 1

PROMPT
PROMPT Logins successful break on DATA
PROMPT
SELECT TRUNC(timestamp) DATA
,      COUNT(1) logins_successful
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode = 0
 GROUP BY TRUNC(timestamp)
 ORDER BY 1;

/*
PROMPT
PROMPT Logins successful break on DATE, OS_USERNAME
PROMPT

COL os_username FOR A30
SELECT TRUNC(timestamp) DATA
,      os_username
,      COUNT(1) logins_successful
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode = 0
   AND TRUNC(timestamp) = TRUNC(SYSDATE)
 GROUP BY TRUNC(timestamp)
,         os_username
 ORDER BY 1,2;
*/


PROMPT
PROMPT Logins successful break on DATE, OS_USERNAME, USERNAME, USERHOST
PROMPT

/*

SELECT TRUNC(timestamp) DATA
,      os_username
,      username
,      userhost
,      COUNT(1) logins_successful
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode = 0
   --AND username = 'USERPRD'
 GROUP BY TRUNC(timestamp)
,         os_username
,         username
,         userhost
 ORDER BY 1,2,3,4;
*/


COL os_username FOR A30
COL userhost    FOR A30
COL return_code FOR A30

CLEAR BREAKS
ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy)[01012015]: "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy)[SYSDATE]: "

SELECT timestamp DATA
,      os_username
,      username
,      userhost
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode = 0
   AND timestamp BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE) 
 ORDER BY 1;



 
