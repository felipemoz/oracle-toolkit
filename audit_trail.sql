CLEAR BREAKS
SET VERIFY OFF

COL action_name FOR a30
COL os_username FOR a15
COL username    FOR a15
COL userhost    FOR a30
COL terminal    FOR a15
COL owner       FOR a15
COL obj_name    FOR a25


PROMPT
ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy)[01012015]: "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy)[SYSDATE]: "
PROMPT
SELECT timestamp DATA
,      action_name
,      os_username
,      username
,      userhost
--,      terminal
,      owner
,      obj_name
  FROM dba_audit_trail
 WHERE timestamp BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE) 
   AND action NOT IN (100, -- LOGON
                      101, -- LOGOFF
                      102) -- LOGOFF BY CLEANUP
--   AND os_username = 'Ulysses'
 ORDER BY 1;