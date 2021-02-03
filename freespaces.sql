
/* EXIBE INFORMACOES DE ESPACO LIVRE DADO UM TABLESPACE */

SET verify OFF

COL tablespace_name  HEAD "Tablespace"   FOR A25
COL mb_used          HEAD "Used"         FOR 99999999
COL mb_free_alloc    HEAD "Free Alloc"   FOR 99999999
COL mb_free_unalloc  HEAD "Free Unalloc" FOR 99999999
COL mb_total_free    HEAD "Total Free"   FOR 99999999
COL percentage_free  HEAD "% Free"       FOR 990.99
COL percentage_total HEAD "% Total"      FOR 990.99

PROMPT
ACCEPT j PROMPT "Digite o TABLESPACE(LIKE): "

SELECT tablespace_name
,      mb_alloc
,      ROUND(RATIO_TO_REPORT (mb_alloc) OVER () * 100,2) percentage_total
,      mb_free_alloc
,      mb_free_unalloc
,      mb_total_free
,      percentage_free
,      CASE
          WHEN (mb_total_free/mb_alloc) < 0.3
          THEN mb_alloc
          ELSE 0
       END AS percentil_30
  FROM (
SELECT a.tablespace_name
,      SUM(a.bytes / 1024 / 1024) AS mb_alloc
,      SUM(NVL(b.bytes/1024/1024,0)) AS mb_free_alloc
,      SUM(DECODE(a.autoextensible,'YES', CASE WHEN a.bytes > a.maxbytes THEN a.bytes 
                                          ELSE a.maxbytes
                                          END
                            ,      'NO' , a.bytes) / 1024 / 1024 - a.bytes / 1024 / 1024) AS mb_free_unalloc
,      SUM(NVL(NVL(b.bytes/1024/1024,0) + DECODE(a.autoextensible,'YES', CASE WHEN a.bytes > a.maxbytes THEN a.bytes 
                                                                         ELSE a.maxbytes
                                                                         END
                                                           ,      'NO' , a.bytes) / 1024 / 1024 - a.bytes / 1024 / 1024,0)) AS mb_total_free
,      (SUM(NVL(NVL(b.bytes/1024/1024,0) + DECODE(a.autoextensible,'YES', CASE WHEN a.bytes > a.maxbytes THEN a.bytes 
                                                                         ELSE a.maxbytes
                                                                         END
                                                           ,      'NO' , a.bytes) / 1024 / 1024 - a.bytes / 1024 / 1024,0)) /
        SUM(a.bytes / 1024 / 1024) ) * 100 AS percentage_free
  FROM dba_data_files a
,      (SELECT file_id, SUM(bytes) bytes
          FROM dba_free_space
       GROUP BY file_id) b
 WHERE a.file_id = b.file_id(+)
   AND a.tablespace_name LIKE UPPER('%&j%')
GROUP BY a.tablespace_name
UNION ALL
SELECT tablespace_name
,      SUM(bytes_used) / 1024 / 1024   AS mb_alloc
,      SUM(bytes_free) / 1024 / 1024   AS mb_free_alloc
,      0                               AS mb_free_unalloc
,      SUM(bytes_free) / 1024 / 1024   AS mb_total_free
,      SUM(bytes_free)/SUM(bytes_used) AS percentage_free
  FROM v$temp_space_header
 GROUP BY tablespace_name
 ORDER BY 6
);

SELECT name
,      ROUND(usable_file_mb/1024) AS gb_free
,      ROUND(total_mb/1024)       AS gb_total       
,      CASE type 
          WHEN 'EXTERN' THEN TRUNC(USABLE_FILE_MB/((Total_MB-REQUIRED_MIRROR_FREE_MB)/1)*100)
          WHEN 'NORMAL' THEN TRUNC(USABLE_FILE_MB/((Total_MB-REQUIRED_MIRROR_FREE_MB)/2)*100)
          WHEN 'HIGH'   THEN TRUNC(USABLE_FILE_MB/((Total_MB-REQUIRED_MIRROR_FREE_MB)/3)*100)
       END pct_free
  FROM v$asm_diskgroup
 WHERE group_number IN (SELECT group_number FROM v$asm_client);

/*
set lines 170  
col path for a35  
col Diskgroup for a15  
col DiskName for a20  
col disk# for 999  
col total_mb for 999,999,999  
col free_mb for 999,999,999  
compute sum of total_mb on DiskGroup  
compute sum of free_mb on DiskGroup  
break on DiskGroup skip 1 on report -  
  
  
select a.name DiskGroup, b.disk_number Disk#, b.name DiskName, b.total_mb, b.free_mb, b.path, b.header_status  
from v$asm_disk b, v$asm_diskgroup a  
where a.group_number (+) =b.group_number  
order by b.group_number, b.disk_number, b.name  
/  
  
select name, type, total_mb, free_mb, required_mirror_free_mb,
usable_file_mb from v$asm_diskgroup
/

*/  

--SELECT a.tablespace_name
--,      a.file_name
--,      a.bytes / 1024 / 1024 AS "Used"
--,      NVL(b.bytes/1024/1024,0) AS "Free Alloc"
--,      DECODE(a.autoextensible,'YES', CASE WHEN a.bytes > a.maxbytes THEN a.bytes 
--                                          ELSE a.maxbytes
--                                          END
--                            ,      'NO' , a.bytes) / 1024 / 1024 - a.bytes / 1024 / 1024 AS "Free Unalloc"
--,      NVL(NVL(b.bytes/1024/1024,0) + DECODE(a.autoextensible,'YES', CASE WHEN a.bytes > a.maxbytes THEN a.bytes 
--                                                              ELSE a.maxbytes
--                                                              END
--                            ,      'NO' , a.bytes) / 1024 / 1024 - a.bytes / 1024 / 1024,0) AS "Total Free"          
--  FROM dba_data_files a
--,      (SELECT file_id, SUM(bytes) bytes
--          FROM dba_free_space
--       GROUP BY file_id) b
-- WHERE a.file_id = b.file_id(+)
--ORDER BY 1;

UNDEFINE j