
COL tablespace_name FOR a30
COL file_name       FOR a30

SELECT a.tablespace_name
,      a.file_name
,      b.time 
  FROM dba_data_files a
,      v$backup b
 WHERE a.file_id = b.file# 
   AND b.status = 'ACTIVE'; 