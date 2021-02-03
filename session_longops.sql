
/* EXIBE AS OPERACOES LONGAS EM EXECUCAO */

COL #      FOR 9
COL sid    FOR 99999
COL target FOR a33;
COL opname FOR a21;
COL secs   FOR 9999999;

SELECT 
       a.inst_id AS "#"
,      a.sid
,      a.serial#
,      a.opname
,      a.target
,      a.start_time
,      SYSDATE + a.time_remaining/(24*60*60) AS end_time
,      TRUNC((a.sofar*100)/DECODE(a.totalwork,0,1,a.totalwork),2) AS perc
,      a.time_remaining AS secs
,      a.sql_id
--,      b.osuser
  FROM gv$session_longops a
,      gv$session b      
 WHERE a.inst_id = b.inst_id
   AND a.sid     = b.sid
   AND a.serial# = b.serial#
   AND a.sofar <> a.totalwork   
 ORDER BY secs
/

COL elapsed FOR a7
COL remain  FOR a7
COL message FOR a80
COL machine FOR a25


SELECT s.sid,
      s.serial#,
     s.username,
     s.osuser,
      s.machine,
      s.logon_time,
      TRUNC(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,
      TRUNC(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remain,
      TRUNC(sl.sofar/sl.totalwork*100, 2) pct
--      sl.message
FROM   v$session s,
      v$session_longops sl
WHERE  s.sid     = sl.sid
AND    s.serial# = sl.serial#
AND    sl.totalwork <> sl.sofar
ORDER BY sl.time_remaining
/

