
SET VERIFY OFF

COL day                     FOR a10
COL et     HEAD "AVG ET(s)" FOR 999990d000
COL bg     HEAD "AVG BG"    FOR 999999999990
COL avg_dr HEAD "AVG DR"    FOR 999999999990

BREAK ON REPORT SKIP PAGE
COMPUTE AVG OF et     ON REPORT
COMPUTE AVG OF bg     ON REPORT
COMPUTE AVG OF avg_dr ON REPORT


ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy)[01012015]: "

ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy)[SYSDATE]:"

ACCEPT pSql  PROMPT "Type sql_id: "

SELECT 
--a.instance_number AS inst_id,
      b.sql_id
,      TO_CHAR(TRUNC(a.end_interval_time),'DD/MM/YYYY') AS DAY
,      b.plan_hash_value
,      ROUND(SUM(b.elapsed_time_delta/1000000)/DECODE(SUM(b.executions_delta),0,1,SUM(b.executions_delta)),3) as ET
,      ROUND(SUM(b.buffer_gets_delta)/DECODE(SUM(b.executions_delta),0,1,SUM(b.executions_delta))) as AVG_BG
,      ROUND(SUM(b.disk_reads_delta)/DECODE(SUM(b.executions_delta),0,1,SUM(b.executions_delta))) as AVG_DR
,      ROUND(SUM(b.rows_processed_delta)/DECODE(SUM(b.executions_delta),0,1,SUM(b.executions_delta))) as "AVG ROWS"
,      TRUNC(SUM(b.executions_delta)) as "EXECS"
  FROM dba_hist_snapshot a
,      dba_hist_sqlstat b
 WHERE a.snap_id = b.snap_id
   AND a.dbid = b.dbid
   AND a.instance_number = b.instance_number
   AND b.sql_id = '&pSql'
   AND a.end_interval_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE)
 GROUP BY 
-- a.instance_number,
         b.sql_id
,         TRUNC(a.end_interval_time)
,         b.plan_hash_value
 ORDER BY TRUNC(a.end_interval_time), 1
/

SET VERIFY ON