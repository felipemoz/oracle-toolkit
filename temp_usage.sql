

COL tablespace FOR A10
COL username   FOR A20
COL osuser     FOR A15
COL module     FOR A40
COL program    FOR A45



/*
SELECT ROUND(temp_usage/1024/1024) as "Temp Usage (MB)"
,      ROUND(temp_size/1024/1024)  as "Temp Total Size (MB)"
,      ROUND((temp_usage/temp_size)*100) as "% Used"
  FROM (SELECT SUM(GREATEST(bytes, maxbytes)) temp_size
          FROM dba_temp_files
         WHERE tablespace_name IN (SELECT tablespace_name 
                                     FROM dba_tablespaces 
                                    WHERE contents = 'TEMPORARY')) tbs_tmp
,      (SELECT NVL(SUM(a.blocks*b.value),0) temp_usage
          FROM gv$sort_usage a
        ,      v$parameter b
         WHERE b.name    = 'db_block_size') sort_usage
*/

WITH tbs_tmp
AS
(SELECT tablespace_name
,       SUM(GREATEST(bytes, maxbytes)) temp_size
   FROM dba_temp_files
  WHERE tablespace_name IN (SELECT tablespace_name 
                              FROM dba_tablespaces 
                             WHERE contents = 'TEMPORARY')
  GROUP BY tablespace_name
),
sort_usage
AS 
(SELECT a.tablespace
,       NVL(SUM(a.blocks*b.value),0) temp_usage
   FROM gv$sort_usage a
,       v$parameter b
  WHERE b.name    = 'db_block_size'
  GROUP BY a.tablespace)
 SELECT ROUND(temp_usage/1024/1024) as "Temp Usage (MB)"
,      ROUND(temp_size/1024/1024)  as "Temp Total Size (MB)"
,      ROUND((temp_usage/temp_size)*100) as "% Used"
  FROM tbs_tmp
,      sort_usage
/




WITH tbs_tmp
AS
(SELECT SUM(GREATEST(bytes, maxbytes)) temp_size
          FROM dba_temp_files
         WHERE tablespace_name IN (SELECT tablespace_name 
                                     FROM dba_tablespaces 
                                    WHERE contents = 'TEMPORARY')
),
sort_usage
AS 
(SELECT NVL(SUM(a.blocks*b.value),0) temp_usage
  FROM gv$sort_usage a
,      v$parameter b
 WHERE b.name    = 'db_block_size')
SELECT ROUND(temp_usage/1024/1024) as "Temp Usage (MB)"
,      ROUND(temp_size/1024/1024)  as "Temp Total Size (MB)"
,      ROUND((temp_usage/temp_size)*100) as "% Used"
  FROM tbs_tmp
,      sort_usage
/

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
 ORDER BY b.tablespace
,         MB;
      

CLEAR BREAKS
BREAK ON REPORT
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
,      SUM(b.blocks*c.value)/1024/1024 as MB
  FROM gv$session a
,      gv$sort_usage b
,      v$parameter c
 WHERE a.inst_id = b.inst_id
   AND a.saddr   = b.session_addr
   AND c.name    = 'db_block_size'
 GROUP BY a.sid
,         a.serial#
,         a.sql_id
,         a.osuser
,         a.username
,         a.module
,         a.status
 ORDER BY mb DESC, sql_id;