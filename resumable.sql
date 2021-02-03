
COL name      FOR A50
COL error_msg FOR A40
SELECT status
,      start_time
,      suspend_time
,      resume_time
,      name
--,      sql_text
,      error_msg 
  FROM dba_resumable
 WHERE status <> 'NORMAL'
 ORDER BY suspend_time
/

SELECT 'Sessions on resumable: ' || COUNT(1)  RESUMABLE
  FROM dba_resumable
 WHERE status <> 'NORMAL'
/