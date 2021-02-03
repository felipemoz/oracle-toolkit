
SET verify OFF

COL OSUSER   FOR A20 
COL username FOR A20 

SELECT s.inst_id
,      s.sid      SID
,      s.serial#  SERIAL#
,      s.osuser   OSUSER
,      s.username USERNAME
,      p.spid     SPID
,      s.sql_id   SQL_ID
FROM   gv$session s
,      gv$process p
 WHERE s.inst_id = p.inst_id
   AND p.addr=s.paddr
   AND p.spid = &SPID;
   
UNDEFINE SPID

SET verify ON