
SET VERIFY OFF
SET FEEDBACK OFF

COL dummy NOPRINT
COL module                          FOR a20
COL command_type                    FOR a20
COL dr HEAD "DR"                    FOR 99999999990
COL adr HEAD "AVG DR"               FOR 99999999990
COL rank_sql_id HEAD "RANK"         FOR 999
COL percentage HEAD "% DR TOTAL"    FOR 990d00
COMPUTE SUM OF DR ON REPORT         FOR 999999
COMPUTE SUM OF percentage ON REPORT
BREAK ON REPORT SKIP PAGE

ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy): "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy) [SYSDATE]: "
ACCEPT pModule  PROMPT "Type module: "

REPHEADER LEFT COL 9 '************************************************* ' SKIP 1 -
               COL 9 '* TOP 10 AVERAGE DISK READS SQL_IDS FROM MODULE : ' &&pModule SKIP 1 -
               COL 9 '************************************************* ' SKIP 2

SELECT * FROM
(
SELECT 'no_label' DUMMY
,      a.module
,      a.sql_id
,      DECODE (c.command_type,
                          1, 'Create Table',
                          2, 'Insert',
                          3, 'Select',
                          6, 'Update',
                          7, 'Delete',
                          26, 'Lock Table',
                          35, 'Alter Database',
                          42, 'Alter Session',
                          44, 'Commit',
                          45, 'Rollback',
                          46, 'Savepoint',
                          47, 'Begin/Declare',
                          170, 'call',
                          c.command_type) command_type
,      RANK() OVER (PARTITION BY a.module ORDER BY (SUM(disk_reads_delta)/DECODE( SUM(a.executions_delta),0,1,SUM(a.executions_delta) ) ) DESC) rank_sql_id
,      ROUND((SUM(disk_reads_delta)/DECODE(SUM(a.executions_delta),0,1,SUM(a.executions_delta)))) adr
--,      ROUND((SUM(disk_reads_delta)/SUM(executions_delta))) at0 -- with zero executions
,      ROUND(RATIO_TO_REPORT (SUM(disk_reads_delta)) OVER (PARTITION BY a.module) * 100, 2) percentage
,      ROUND(SUM(disk_reads_delta)) dr
,      SUM(executions_delta) EXECS
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
,      dba_hist_sqltext c
 WHERE a.dbid            = b.dbid
   AND a.snap_id         = b.snap_id
   AND a.instance_number = b.instance_number
   AND a.executions_delta   > 0
   AND b.begin_interval_time BETWEEN TO_DATE('&pBegin','DDMMYYYY') 
                                 AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE)
   AND a.dbid               = c.dbid(+)
   AND a.sql_id             = c.sql_id(+)
   --AND NVL(c.command_type,0) < 10
   AND a.module = '&pModule'
 GROUP BY a.module
,         a.sql_id
,         DECODE (c.command_type,
                          1, 'Create Table',
                          2, 'Insert',
                          3, 'Select',
                          6, 'Update',
                          7, 'Delete',
                          26, 'Lock Table',
                          35, 'Alter Database',
                          42, 'Alter Session',
                          44, 'Commit',
                          45, 'Rollback',
                          46, 'Savepoint',
                          47, 'Begin/Declare',
                          170, 'call',
                          c.command_type)
 ORDER BY 5
)
WHERE rank_sql_id < 1199999
/

SET VERIFY ON 
SET FEEDBACK ON
REPHEADER OFF
