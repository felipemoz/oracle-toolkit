
/* EXIBE INFORMACOES DAS SESSOES ATIVAS */

COL inst     FOR 9
COL spid     FOR A8
COL sid      FOR 99999
COL serial#  FOR 99999
COL username FOR A15
COL osuser   FOR A15
COL program  FOR A40
COL period   FOR A16
COL secs     FOR 99999
COL event    FOR A45
COL machine  FOR A25

SELECT p.spid
,      s.inst_id AS inst
,      s.sid
,      s.serial#
,      s.sql_id
,      s.username
,      s.osuser
,      s.program
,      s.logon_time
--,      s.last_call_et AS SECS
--,      s.status
,      TRUNC(last_call_et/(60*60*24)) || 'D ' 
    || TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24) || 'H '
    || TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60) || 'M '
    || TRUNC(MOD( (MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60  )   ,( TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60)))  * 60) || 'S '    AS Period
  FROM gv$session s
,      gv$process p
 WHERE s.type <> 'BACKGROUND'
   AND s.STATUS IN ('ACTIVE')
   AND s.paddr = p.addr
   AND s.inst_id = p.inst_id
ORDER BY s.status, s.last_call_et ASC
/

/*
SELECT p.spid
,      s.inst_id AS inst
,      s.sid
,      s.serial#
,      s.sql_id
,      s.username
,      s.osuser
,      s.program
,      s.logon_time
--,      s.last_call_et AS SECS
--,      s.status
,      TRUNC(last_call_et/(60*60*24)) || 'D ' 
    || TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24) || 'H '
    || TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60) || 'M '
    || TRUNC(MOD( (MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60  )   ,( TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60)))  * 60) || 'S '    AS Period
  FROM gv$session s
,      gv$process p
 WHERE s.type <> 'BACKGROUND'
   AND s.STATUS IN ('ACTIVE')
   AND s.paddr = p.addr
   AND s.inst_id = p.inst_id
ORDER BY s.status, s.last_call_et ASC
*/

SELECT p.spid
,      s.inst_id AS inst
,      s.sid
,      s.serial#
,      s.sql_id
,      s.username
,      s.osuser
,      s.machine
,      s.logon_time
--,      s.last_call_et AS SECS
--,      s.status
,      TRUNC(last_call_et/(60*60*24)) || 'D ' 
    || TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24) || 'H '
    || TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60) || 'M '
    || TRUNC(MOD( (MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60  )   ,( TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60)))  * 60) || 'S '    AS Period
  FROM gv$session s
,      gv$process p
 WHERE s.type <> 'BACKGROUND'
   AND s.STATUS IN ('ACTIVE')
   AND s.paddr = p.addr
   AND s.inst_id = p.inst_id
ORDER BY s.status, s.last_call_et ASC
/

SELECT s.inst_id AS inst
,      s.sid
,      s.serial#
,      s.sql_id
,      event
--,      module
--,      action
,      seconds_in_wait
,      last_call_et
  FROM gv$session s
 WHERE s.type <> 'BACKGROUND'
   AND s.STATUS IN ('ACTIVE')
ORDER BY seconds_in_wait
/

BREAK ON REPORT
COMPUTE SUM OF executions ON REPORT

SELECT sql_id
,      COUNT(1) executions
  FROM gv$session
 WHERE type <> 'BACKGROUND'
   AND STATUS IN ('ACTIVE')
 GROUP BY sql_id
 ORDER BY 2
/

SELECT username
,      COUNT(1) executions
  FROM gv$session
 WHERE type <> 'BACKGROUND'
   AND STATUS IN ('ACTIVE')
 GROUP BY username
 ORDER BY 2
/

SELECT osuser
,      COUNT(1) executions
  FROM gv$session
 WHERE type <> 'BACKGROUND'
   AND STATUS IN ('ACTIVE')
 GROUP BY osuser
 ORDER BY 2
/

SELECT inst_id
,      COUNT(1) executions
  FROM gv$session
 WHERE type <> 'BACKGROUND'
   AND STATUS IN ('ACTIVE')
 GROUP BY inst_id
 ORDER BY 1
/