

COL tablespace FOR A10
COL username   FOR A20
COL osuser     FOR A15
COL module     FOR A40
COL program    FOR A45

BREAK ON REPORT
COMPUTE SUM OF MB ON TABLESPACE, REPORT

SELECT b.tablespace
--,      b.segfile#
--,      b.segblk#
,      b.segtype
,      b.extents
,      b.blocks
,      a.SID
,      a.serial#
,      a.username
,      a.osuser
,      a.program
,      ROUND (((b.blocks * d.value)/ 1024 / 1024 ), 2 ) AS MB
  FROM gv$session a
,      gv$sort_usage b
,      gv$process c
,      v$parameter d
 WHERE a.inst_id = b.inst_id
   AND a.saddr   = b.session_addr
   AND a.inst_id = c.inst_id
   AND a.paddr   = c.addr
   AND d.name    = 'db_block_size'
-- ORDER BY b.tablespace
--,         MB;
      

CLEAR BREAKS
--BREAK ON SQL_ID SKIP 1
COMPUTE SUM OF MB ON SQL_ID SKIP 1

SELECT --a.inst_id
       a.sid
,      a.serial#
,      a.sql_id
,      a.osuser
,      a.username
,      a.module
,      a.status
--,      u.tablespace
--,      u.contents
,      (b.blocks*c.value)/1024/1024 as MB
  FROM gv$session a
,      gv$sort_usage b
,      v$parameter c
 WHERE a.inst_id = b.inst_id
   AND a.saddr   = b.session_addr
   AND c.name    = 'db_block_size'
-- ORDER BY MB, SQL_ID;