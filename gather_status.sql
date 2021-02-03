
PROMPT
PROMPT EXECUTE DBMS_STATS.GATHER_TABLE_STATS(  
PROMPT ownname => 'SISCTMSA', 
PROMPT tabname => 'T_SA_PEDIDO_END_ENTREGA_BIO', 
PROMPT method_opt => 'FOR ALL INDEXED COLUMNS SIZE 100', 
PROMPT granularity => 'ALL', 
PROMPT cascade => TRUE, 
PROMPT degree => DBMS_STATS.DEFAULT_DEGREE); 
PROMPT
PROMPT EXEC dbms_stats.gather_schema_stats(ownname=>NULL, cascade=>TRUE);
PROMPT
PROMPT EXEC dbms_stats.gather_database_stats;
PROMPT
PROMPT DBMS_STAT.set_table_prefs('SH','SALES','STALE_PERCENT',5);
PROMPT


SELECT client_name, status FROM dba_autotask_operation;

COL client_name    FOR a31
COL job_start_time FOR a45
COL job_duration   FOR a35

SELECT client_name
--,JOB_NAME
,JOB_STATUS
,JOB_START_TIME
,JOB_DURATION 
from DBA_AUTOTASK_JOB_HISTORY 
where JOB_START_TIME >systimestamp -7
and client_name = 'auto optimizer stats collection'
order by job_start_time
/

COL operation form a80
COL start_time FOR a30
COL end_time FOR a30
COL target form a1
SELECT OPERATION||DECODE(TARGET,NULL,NULL,'-'||TARGET) OPERATION
,      TO_CHAR(START_TIME,'DD/MM/YYYY HH24:MI:SS.FF4') START_TIME
,      TO_CHAR(  END_TIME,'DD/MM/YYYY HH24:MI:SS.FF4') END_TIME
  FROM DBA_OPTSTAT_OPERATIONS
 ORDER BY DBA_OPTSTAT_OPERATIONS.START_TIME
/

COL window_name FOR A50
COL start_time  FOR A50
COL duration    FOR A50
SELECT window_name
,      start_time
,      duration 
  FROM dba_autotask_schedule
 ORDER BY start_time;
 
 

/*

SELECT table_name
,      last_analyzed
,      num_rows
,      sample_size
,      sample_size*100/num_rows Sample_Perc
  FROM dba_tables
 WHERE table_name IN ('BSC_NF_CAPA','BSC_NF_ITEM','BSC_NF_IMPOSTO');
 
 
SELECT table_name
,      partition_name
,      last_analyzed
,      num_rows
,      sample_size
,      sample_size*100/num_rows Sample_Perc
  FROM dba_tab_partitions
 WHERE table_name IN ('BSC_NF_CAPA','BSC_NF_ITEM','BSC_NF_IMPOSTO')
 ORDER BY 1,2;
 
 */