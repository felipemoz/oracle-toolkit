
COL object_name FOR a30
col owner_name for a20
col job_name for a20
col operation for a20
col job_mode for a20
col state for a20

------------
-- STATUS --
------------

SELECT * 
  FROM dba_datapump_jobs;

COL object_type FOR a15
COL object_name FOR a30
SELECT a.owner, a.object_id, a.object_type, a.object_name, a.status
  FROM dba_objects a, dba_datapump_jobs j
 WHERE a.owner       = j.owner_name 
   AND a.object_name = j.job_name
   AND j.job_name    ='IMPDP-SISDMPM-9695-3';

SELECT owner,object_name,subobject_name, object_type,last_ddl_time 
  FROM dba_objects 
 WHERE object_id=&OBJECT_ID




/*
------------------------------
-- CHANGING PARALLEL DEGREE --
------------------------------

Answering the original question :
- identify job name (select owner_name, job_name, state from dba_datapump_jobs);
- connect to it : impdp attach=schema.job_name
- change parallelism : parallel=n (n - number of parallel workers)
- wait a bit for change to aplly
- confirm change : status



--------------------
-- ROW PER MINUTE --
--------------------

select 
substr(sql_text,instr(sql_text,'into "'),30) table_name, 
rows_processed, round((sysdate-to_date(first_load_time,'yyyy-mm-dd hh24:mi:ss'))*24*60,1) minutes,
trunc(rows_processed/((sysdate-to_date(first_load_time,'yyyy-mm-dd hh24:mi:ss'))*24*60)) rows_per_minute 
from 
sys.v_$sqlarea 
where 
LOWER(sql_text) like 'insert %into "%' and command_type = 2 and open_versions > 0; 

-------------
-- RESTART --
-------------

impdp \"/ as sysdba\" attach=IMPDP-SISDMPM-9695-3
STOP_JOB=immediate
START_JOB
*/