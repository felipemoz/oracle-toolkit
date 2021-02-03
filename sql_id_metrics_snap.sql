
SET VERIFY   OFF
SET FEEDBACK OFF

COL time FOR a18
COL et     HEAD "AVG ET(s)" FOR 999990d000
COL bg     HEAD "AVG BG"    FOR 999999999990
COL avg_dr HEAD "AVG DR"    FOR 999999999990
COL module FOR a25
COL action FOR a25

BREAK ON REPORT
COMPUTE AVG OF AVG_SECS ON REPORT
COMPUTE AVG OF AVG_BG   ON REPORT


PROMPT
ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy): "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy) [SYSDATE]:   "
ACCEPT sql_id PROMPT "SQL_ID: "

SELECT a.snap_id
--,      a.instance_number AS inst_id
,      b.sql_id
,      b.module
--,      b.action
,      b.plan_hash_value
,      TO_CHAR(a.end_interval_time,'DD/MM/YYYY HH24:MI') AS time
,      SUM(ROUND((b.elapsed_time_delta/1000000)/DECODE((b.executions_delta),0,1,(b.executions_delta)),3)) as AVG_SECS
,      SUM(ROUND((b.buffer_gets_delta)/         DECODE((b.executions_delta),0,1,(b.executions_delta)))) as AVG_BG
,      SUM(ROUND((b.disk_reads_delta)/          DECODE((b.executions_delta),0,1,(b.executions_delta)),4)) as AVG_DR
,      SUM(ROUND((b.rows_processed_delta)/      DECODE((b.executions_delta),0,1,(b.executions_delta)))) as "AVG ROWS"
,      SUM(TRUNC(b.executions_delta)) as "EXECS"
  FROM dba_hist_snapshot a
,      dba_hist_sqlstat b
 WHERE a.snap_id         = b.snap_id
   AND a.dbid            = b.dbid
   AND a.instance_number = b.instance_number
   AND b.sql_id          = '&&SQL_ID'
   AND a.begin_interval_time BETWEEN TO_DATE('&&pBegin','DD-MM-YYYY') 
                                 AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
 GROUP BY a.snap_id
--,      a.instance_number
,      b.sql_id
,      b.module
--,      b.action
,      b.plan_hash_value
,      TO_CHAR(a.end_interval_time,'DD/MM/YYYY HH24:MI')
 ORDER BY 1,2,3,4
/

UNDEF sql_id

SET VERIFY   ON
SET FEEDBACK ON