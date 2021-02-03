
SET VERIFY OFF

COL tablespace_name FOR a30
COL mb_alloc      FOR 999999990
COL mb_used       FOR 999999990
COL mb_free_alloc FOR 999999990
COL mb_total_free FOR 999999990
COL pct_free      FOR 990.00
COL gb_total      FOR 99999990.00

PROMPT 
ACCEPT pTablespace PROMPT "Type TABLESPACE_NAME: "

BREAK ON REPORT
COMPUTE SUM OF mb_alloc        ON REPORT
COMPUTE SUM OF mb_used         ON REPORT
COMPUTE SUM OF pct_used        ON REPORT
COMPUTE SUM OF mb_total        ON REPORT
COMPUTE SUM OF mb_free_alloc   ON REPORT
COMPUTE SUM OF mb_free_unalloc ON REPORT
COMPUTE SUM OF mb_total_free   ON REPORT


SELECT tablespace_name
,      ROUND(mb_alloc+mb_free_unalloc)                                AS mb_total
,      ROUND(mb_alloc)                                                AS mb_alloc
,      ROUND(mb_used)                                                 AS mb_used
,      ROUND(RATIO_TO_REPORT (mb_used) OVER () * 100,1)               AS pct_used
,      ROUND(mb_free_alloc)                                           AS mb_free_alloc      
,      ROUND(mb_free_unalloc)                                         AS mb_free_unalloc
,      ROUND(mb_total_free)                                           AS mb_total_free
,      ROUND((mb_total_free/mb_total)*100,2)                          AS pct_free
--,      CASE
--          WHEN ((mb_free_alloc+mb_free_unalloc)/mb_alloc) < 0.3
--          THEN mb_alloc
--          ELSE 0
--       END AS percentil_30
  FROM (
SELECT a.tablespace_name
,      (SUM(a.bytes)-SUM(NVL(b.bytes,0)))/1024/1024                               AS mb_used
,      SUM(a.bytes)/1024/1024                                                     AS mb_alloc
,      SUM(NVL(b.bytes,0))/1024/1024                                              AS mb_free_alloc
,      SUM(GREATEST(a.bytes, a.maxbytes)-a.bytes)/1024/1024                       AS mb_free_unalloc
,      (SUM(NVL(b.bytes,0))+SUM(GREATEST(a.bytes, a.maxbytes)-a.bytes))/1024/1024 AS mb_total_free
,      SUM(GREATEST(a.bytes, a.maxbytes))/1024/1024                               AS mb_total
  FROM dba_data_files a
,      (SELECT file_id, SUM(bytes) bytes
          FROM dba_free_space
       GROUP BY file_id) b
 WHERE a.file_id = b.file_id(+)
   AND a.tablespace_name LIKE UPPER('%&pTablespace%')
GROUP BY a.tablespace_name
UNION ALL
SELECT a.tablespace_name
,      SUM(bytes_used)/1024/1024                                                                AS mb_used
,      (SUM(bytes_used)+SUM(bytes_free))/1024/1024                                              AS mb_alloc
,      SUM(bytes_free)/1024/1024                                                                AS mb_free_alloc
,      SUM(GREATEST(b.bytes, b.maxbytes)-b.bytes)/1024/1024                                     AS mb_free_unalloc
,      (SUM(bytes_free)/1024/1024)+SUM(GREATEST(b.bytes, b.maxbytes)-b.bytes)/1024/1024         AS mb_total_free
,      ((SUM(bytes_used)+SUM(bytes_free))+SUM(GREATEST(b.bytes, b.maxbytes)-b.bytes))/1024/1024 AS mb_total
  FROM v$temp_space_header a
,      dba_temp_files b
 WHERE a.file_id (+) = b.file_id
   AND a.tablespace_name LIKE UPPER('%&pTablespace%')
 GROUP BY a.tablespace_name
)
ORDER BY 9
;


SELECT name
,      type
,      ROUND(usable_file_mb/1024,2) AS gb_free
,      ROUND(total_mb/1024,2)       AS gb_total       
,      CASE type 
          WHEN 'EXTERN' THEN ROUND(USABLE_FILE_MB/((Total_MB-REQUIRED_MIRROR_FREE_MB)/1)*100,2)
          WHEN 'NORMAL' THEN ROUND(USABLE_FILE_MB/((Total_MB-REQUIRED_MIRROR_FREE_MB)/2)*100,2)
          WHEN 'HIGH'   THEN ROUND(USABLE_FILE_MB/((Total_MB-REQUIRED_MIRROR_FREE_MB)/3)*100,2)
       END pct_free
,      ROUND(((total_mb*0.3)-usable_file_mb)/1024,2) gb_30_perc
  FROM v$asm_diskgroup
 WHERE group_number IN (SELECT group_number FROM v$asm_client);
 
 
SET VERIFY ON