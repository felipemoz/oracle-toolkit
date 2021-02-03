
BREAK ON REPORT
COMPUTE SUM OF GB ON REPORT

COL owner FOR a20
COL gb    FOR 99999.99

SELECT * FROM 
(
SELECT owner
,      segment_name
,      ROUND(SUM(bytes)/1024/1024/1024,2) as GB
  FROM dba_segments
 WHERE owner NOT IN ('SYSTEM','SYS','SYSMAN')
 GROUP BY owner
,         segment_name
 ORDER BY 3 DESC
)
WHERE ROWNUM < 11
/




