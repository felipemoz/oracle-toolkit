
COL gb HEAD "alloc (GB)"         FOR 99999990.00
COL used_gb HEAD "used (GB)"     FOR 99999990.00
COL wasted_gb HEAD "wasted (GB)" FOR 99999990.00
COL wasted_perc HEAD "% wasted"  FOR 99999990.00

BREAK ON REPORT
COMPUTE SUM OF wasted_gb ON REPORT


SELECT * FROM 
(
SELECT table_name
,      ROUND((blocks*8)/1024/1024,2) AS gb 
,      ROUND((num_rows*avg_row_len/1024/1024/1024),2) AS used_gb 
,      ROUND(((blocks*8)/1024/1024) - (num_rows*avg_row_len/1024/1024/1024),2) AS wasted_gb
,      (((blocks*8)/1024/1024 - (num_rows*avg_row_len/1024/1024/1024)) / (num_rows*avg_row_len/1024/1024/1024)) * 100 AS wasted_perc
  FROM dba_tables
 WHERE (ROUND((blocks*8)/1024/1024) > ROUND((num_rows*avg_row_len/1024/1024/1024)))
   AND num_rows > 0
 ORDER BY 4 DESC
)
WHERE ROWNUM < 11
/
