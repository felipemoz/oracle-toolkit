
COL "Username"  FOR a15
COL "QC/Slave"  FOR a10
COL "Slave Set" FOR a10
COL SID         FOR a10
COL QC_SID      FOR a10 HEAD "QC SID"
COL QC          FOR a10 HEAD "QC/Slave"


/* ALTERAR PARA CONNECT BY */

SELECT s.inst_id "Inst_id"
,      DECODE(px.qcinst_id,NULL,s.username,' - '||LOWER(SUBSTR(s.program,LENGTH(s.program)-4,4) ) ) "Username"
,      s.sql_id
,      DECODE(px.qcinst_id,NULL, 'QC', '(Slave)') QC 
,      TO_CHAR( px.server_set) "Slave Set"
,      TO_CHAR(s.sid) "SID"
,      DECODE(px.qcinst_id, NULL ,TO_CHAR(s.sid) ,px.qcsid) QC_SID
,      px.req_degree "Requested DOP"
,      px.degree "Actual DOP"
,      p.spid
  FROM gv$px_session px
,      gv$session    s
,      gv$process    p
 WHERE px.sid     = s.sid (+) 
   AND px.serial# = s.serial# 
   AND px.inst_id = s.inst_id
   AND p.inst_id  = s.inst_id
   AND p.addr     = s.paddr
 ORDER BY 3, 4, 5, 2
-- ORDER BY 3, 4, 5, 2
/ 

show parameter parallel_max_servers
show parameter parallel_min_servers

SELECT status, COUNT(1)
  FROM v$px_process
 GROUP BY status
/

SET verify OFF

COL sql_fulltext FOLD_AFTER

SELECT inst_id
,      sql_id
,      sql_fulltext
  FROM gv$sql
 WHERE sql_id = '&SQL_ID'
 ORDER BY inst_id
/

SET verify ON