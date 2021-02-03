
/* EXIBE INFORMACOES DE UM JOB DADO UM JOB */

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
,      what
  FROM dba_jobs
 WHERE job = &1
/

UNDEFINE 1