
/* EXIBE INFORMACOES DOS JOBS */


COL job         FOR 99999
COL schema_user FOR A30
COL interval    FOR A60

SELECT job
,      schema_user
,      broken
,      failures
,      last_date
,      next_date
,      interval 
--,      what
  FROM dba_jobs
-- WHERE broken <> 'Y'
 ORDER BY next_date DESC
/
 
