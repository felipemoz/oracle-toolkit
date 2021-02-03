
SET VERIFY OFF
SET FEEDBACK OFF

COL dummy NOPRINT
COL module                              FOR a50
COL rank_et     HEAD "MODULE RANK"      FOR 999
COL rank_sql_id HEAD "RANK SQL_ID"      FOR 999
COL percentage  HEAD "%"                FOR 990d00
COL et          HEAD "Elapsed Time (s)" FOR 99999999990d000
COL et_total    HEAD "Total Time (s)"   FOR 99999999990d000
COL et_per_exec HEAD "ET/EXEC"          FOR 99990d999

COMPUTE SUM OF et ON dummy
COMPUTE SUM OF percentage ON dummy
BREAK ON dummy SKIP PAGE
  
ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy): "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy) [NULL]:   "

PROMPT &&pBegin


REPHEADER LEFT COL 9 '*************************************' SKIP 1 -
               COL 9 '* TOP 5 MODULES PER ELAPSED TIME -  *' SKIP 1 -
               COL 9 '*************************************' SKIP 2

SELECT module
,      rank
,      ROUND(RATIO_TO_REPORT (et) OVER (PARTITION BY et_total) * 100,2) percentage
,      ROUND(et/1000000,3) ET 
,      ROUND(et_total/1000000,3) ET_TOTAL
  FROM (
SELECT module
,      RANK() OVER (ORDER BY SUM(elapsed_time_delta) DESC) RANK
,      SUM(elapsed_time_delta) ET
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
 WHERE a.dbid           = b.dbid
   AND a.snap_id        = b.snap_id
   --AND a.module LIKE '%&&pLike%'
   --AND a.module NOT IN ('DBMS_SCHEDULER','SQL*Plus','PL/SQL Developer','oracle@gauss008a (TNS V1-V3)','emagent_SQL_oracle_database','WIReportServer.exe','busobj.exe')
   AND b.end_interval_time BETWEEN TO_DATE('&pBegin','DDMMYYYY') 
                               AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
 GROUP BY module
),
(
SELECT SUM(elapsed_time_delta) ET_TOTAL
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
 WHERE a.dbid           = b.dbid
   AND a.snap_id        = b.snap_id
   --AND a.module LIKE '%&&pLike%'
   --AND a.module NOT IN ('DBMS_SCHEDULER','SQL*Plus','PL/SQL Developer','oracle@gauss008a (TNS V1-V3)','emagent_SQL_oracle_database','WIReportServer.exe','busobj.exe')
   AND b.end_interval_time BETWEEN TO_DATE('&pBegin','DDMMYYYY') 
                               AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
)
 GROUP BY module, rank, et, et_total
 HAVING rank < 6
 ORDER BY 2
/
 

REPHEADER LEFT COL 9 '********************************************' SKIP 1 -
               COL 9 '* TOP SQL_ID / MODULES PER ELAPSED_TIME -  *' SKIP 1 -
               COL 9 '********************************************' SKIP 2

SELECT a.module DUMMY
,      a.module
,      c.rank_et 
,      sql_id
,      RANK() OVER (PARTITION BY a.module ORDER BY SUM(elapsed_time_delta) DESC) rank_sql_id
,      ROUND(RATIO_TO_REPORT (SUM(elapsed_time_delta)) OVER (PARTITION BY a.module) * 100,2) percentage
,      ROUND(SUM(elapsed_time_delta)/1000000,3) ET
,      ROUND((SUM(elapsed_time_delta)/1000000)/SUM(executions_delta),3) ET_PER_EXEC 
,      SUM(executions_delta) EXECS
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
,      ( SELECT module
         ,      rank() over (order by (SUM(elapsed_time_delta)) desc) rank_et
           FROM dba_hist_sqlstat a
         ,      dba_hist_snapshot b
          WHERE a.dbid           = b.dbid
            AND a.snap_id        = b.snap_id
            AND a.executions_delta   > 0
            --AND a.module LIKE '%&&pLike%'
            --AND a.module NOT IN ('DBMS_SCHEDULER','SQL*Plus','PL/SQL Developer','oracle@gauss008a (TNS V1-V3)','emagent_SQL_oracle_database','WIReportServer.exe','busobj.exe')
            AND b.end_interval_time BETWEEN TO_DATE('&pBegin','DDMMYYYY') 
                                        AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
          GROUP BY module
       ) c
 WHERE a.dbid           = b.dbid
   AND a.snap_id        = b.snap_id
   AND a.executions_delta   > 0
   --AND a.module LIKE '%&&pLike%'
   --AND a.module NOT IN ('DBMS_SCHEDULER','SQL*Plus','PL/SQL Developer','oracle@gauss008a (TNS V1-V3)','emagent_SQL_oracle_database','WIReportServer.exe','busobj.exe')
   AND a.module = c.module
   AND b.end_interval_time BETWEEN TO_DATE('&pBegin','DDMMYYYY') 
                               AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
 GROUP BY a.module, c.rank_et, sql_id
 HAVING rank_et < 6
 ORDER BY 3, 2, 5
/

SET VERIFY ON 
 
 /*
 
 COL teste FOR 990d00
 
 CLEAR BREAK
 
 SELECT module
 ,      RANK() OVER (ORDER BY SUM(buffer_gets_delta) DESC) RANK
 ,      SUM(buffer_gets_delta) BG
   FROM dba_hist_sqlstat a
 ,      dba_hist_snapshot b
  WHERE a.dbid           = b.dbid
    AND a.snap_id        = b.snap_id
    AND a.executions_delta   > 0
    AND a.module LIKE '%R'
    AND a.module NOT IN ('DBMS_SCHEDULER')
    AND b.end_interval_time BETWEEN TO_DATE('01/04/2012 00:00','DD/MM/YYYY HH24:MI') 
                                AND TO_DATE('15/04/2012 00:00','DD/MM/YYYY HH24:MI') 
  GROUP BY module
  ORDER BY 2
 /
 
 SELECT module
 ,      RANK() OVER (ORDER BY SUM(buffer_gets_delta) DESC) RANK
 ,      SUM(buffer_gets_delta) BG
   FROM dba_hist_sqlstat a
 ,      dba_hist_snapshot b
  WHERE a.dbid           = b.dbid
    AND a.snap_id        = b.snap_id
    AND a.executions_delta   > 0
    AND a.module LIKE '%F'
    AND a.module NOT IN ('DBMS_SCHEDULER')
    AND b.end_interval_time BETWEEN TO_DATE('01/04/2012 00:00','DD/MM/YYYY HH24:MI') 
                                AND TO_DATE('15/04/2012 00:00','DD/MM/YYYY HH24:MI') 
  GROUP BY module
  ORDER BY 2
 /
 
 
 BREAK ON module SKIP PAGE
 
 SELECT module
 ,      sql_id
 ,      RANK() OVER (PARTITION BY module ORDER BY SUM(buffer_gets_delta) DESC) RANK
 ,      ROUND(RATIO_TO_REPORT (SUM(buffer_gets_delta)) OVER (PARTITION BY module) * 100,2) "%"
 ,      SUM(buffer_gets_delta) BG
 ,      ROUND(SUM(buffer_gets_delta)/SUM(executions_delta)) "BG/EXEC"
 ,      SUM(executions_delta) EXECS
   FROM dba_hist_sqlstat a
 ,      dba_hist_snapshot b
  WHERE a.dbid           = b.dbid
    AND a.snap_id        = b.snap_id
    AND a.executions_delta   > 0
    AND a.module LIKE '%R'
    AND a.module NOT IN ('DBMS_SCHEDULER')
    AND b.end_interval_time BETWEEN TO_DATE('01/04/2012 00:00','DD/MM/YYYY HH24:MI') 
                                AND TO_DATE('15/04/2012 00:00','DD/MM/YYYY HH24:MI') 
  GROUP BY module, sql_id
  ORDER BY 1, 3
 /
 
 SELECT module
 ,      sql_id
 ,      RANK() OVER (PARTITION BY module ORDER BY SUM(buffer_gets_delta) DESC) RANK
 ,      ROUND(RATIO_TO_REPORT (SUM(buffer_gets_delta)) OVER (PARTITION BY module) * 100,2) TESTE
 ,      SUM(buffer_gets_delta) BG
 ,      ROUND(SUM(buffer_gets_delta)/SUM(executions_delta)) "BG/EXEC"
 ,      SUM(executions_delta) EXECS
   FROM dba_hist_sqlstat a
 ,      dba_hist_snapshot b
  WHERE a.dbid           = b.dbid
    AND a.snap_id        = b.snap_id
    AND a.executions_delta   > 0
    AND a.module LIKE '%F'
    AND b.end_interval_time BETWEEN TO_DATE('01/04/2012 00:00','DD/MM/YYYY HH24:MI') 
                                AND TO_DATE('15/04/2012 00:00','DD/MM/YYYY HH24:MI') 
  GROUP BY module, sql_id
  ORDER BY 1, 3
 /
 
REPHEADER OFF

*/