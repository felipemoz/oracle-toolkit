



SELECT 'Informacoes para o periodo de ' || MIN(timestamp) || ' a ' || MAX(timestamp) AUDIT_RETENTION
  FROM dba_audit_trail;

PROMPT
PROMPT Logins failed total:
PROMPT

SELECT DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000'))) return_code
,      COUNT(1) logins_failed
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode <> 0
 GROUP BY DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000')))
 ORDER BY 2;
   

BREAK ON DATA SKIP 1

PROMPT
PROMPT Logins Failed break on DATA
PROMPT
SELECT TRUNC(timestamp) DATA
,      DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000'))) return_code
,      COUNT(1) logins_failed
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode <> 0
 GROUP BY TRUNC(timestamp)
,         DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000')))
 ORDER BY 1,2;

PROMPT
PROMPT Logins Failed break on DATE, OS_USERNAME
PROMPT

COL os_username FOR A30
SELECT TRUNC(timestamp) DATA
,      os_username
,      DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000'))) return_code
,      COUNT(1) logins_failed
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode <> 0
 GROUP BY TRUNC(timestamp)
,         os_username
,         DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000')))
 ORDER BY 1,3,4;



PROMPT
PROMPT Logins Failed break on DATE, OS_USERNAME, USERNAME, USERHOST
PROMPT

COL os_username FOR A30
COL userhost    FOR A30
COL return_code FOR A30
SELECT TRUNC(timestamp) DATA
,      os_username
,      username
,      userhost
,      DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000'))) return_code
,      COUNT(1) logins_failed
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode <> 0
 GROUP BY TRUNC(timestamp)
,         os_username
,         username
,         userhost
,         DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000')))
 ORDER BY 1,6,5,2,3,4;


CLEAR BREAKS
ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy)[01012015]: "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy)[SYSDATE]: "

SELECT timestamp DATA
,      os_username
,      username
,      userhost
,      DECODE( returncode
, 00911, 'Invalid Character'
, 00988, 'Missing or invalid password(s).'
, 01004, 'Logon denied.'
, 01005, 'Null Password'
, 01017, 'Invalid username/password.'
, 01031, 'No Privilege'
, 01045, 'User string lacks CREATE SESSION privilege; logon denied.'
, 01918, 'No Such UserID'
, 01920, 'No Such Role'
, 02248, 'Invalid option for ALTER SESSION'
, 09911, 'Incorrect user password.'
, 28000, 'The account is locked.'
, 28001, 'Your password has expired.'
, 28002, 'Your account will expire soon; change your password now.'
, 28003, 'The password is not complex enough.'
, 28007, 'Password cannot be reused.'
, 28008, 'Invalid old password.'
, 28009, 'Connection to sys should be as sysdba or sysoper.'
, 28011, 'Your account will expire soon; change your password now.'
, 28221, 'The original password was not supplied.'
, 'ORA-'||ltrim(to_char(RETURNCODE,'00000'))) return_code
  FROM dba_audit_trail
 WHERE action = 100 --LOGON
   AND returncode <> 0
   AND timestamp BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE) 
 ORDER BY 1;



 
/*
SELECT os_username
,      username
,      userhost
,      terminal
,      timestamp
,      action_name
,      returncode 
  FROM dba_audit_trail 
 WHERE action = 100 --LOGON
   AND returncode <> 0;
*/