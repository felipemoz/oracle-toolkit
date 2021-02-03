
SET VERIFY OFF
SET FEEDBACK OFF

COL dummy NOPRINT
COL module FOR a50
COL rank_bg HEAD "RANK MODULE" FOR 999
COL percentage HEAD "%" FOR 990d00
COMPUTE SUM OF bg ON dummy
COMPUTE SUM OF percentage ON dummy
BREAK ON dummy SKIP PAGE


ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy) [01012015]: "
ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy) [NULL]:   "


REPHEADER LEFT COL 9 '**********************************' SKIP 1 -
               COL 9 '* TOP 5 MODULOS POR BUFFER GETS  *' SKIP 1 -
               COL 9 '**********************************' SKIP 2

SELECT module
,      rank
,      ROUND(RATIO_TO_REPORT (BG) OVER (PARTITION BY bg_total) * 100,2) percentage
,      bg
,      bg_total
  FROM (
SELECT module
,      RANK() OVER (ORDER BY SUM(buffer_gets_delta) DESC) RANK
,      SUM(buffer_gets_delta) BG
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
 WHERE a.dbid           = b.dbid
   AND a.snap_id        = b.snap_id
   AND a.executions_delta   > 0
   --AND a.module LIKE '%MAP_Q_TRANSACOES%'
   --AND a.module NOT IN ('DBMS_SCHEDULER')
   AND b.end_interval_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE) 
 GROUP BY module
),
(
SELECT SUM(buffer_gets_delta) BG_TOTAL
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
 WHERE a.dbid           = b.dbid
   AND a.snap_id        = b.snap_id
   AND a.executions_delta   > 0
   --AND a.module LIKE '%MAP_Q_TRANSACOES%'
   --AND a.module NOT IN ('DBMS_SCHEDULER')
   AND b.end_interval_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY')) 
                               AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
)
 GROUP BY module, rank, bg, bg_total
 HAVING rank < 6
 ORDER BY 2
/
 

REPHEADER LEFT COL 9 '******************************************' SKIP 1 -
               COL 9 '* TOP SQL_ID DOS MODULOS POR BUFFER GETS *' SKIP 1 -
               COL 9 '******************************************' SKIP 2

SELECT a.module DUMMY
,      a.module
,      c.rank_bg 
,      sql_id
,      RANK() OVER (PARTITION BY a.module ORDER BY SUM(buffer_gets_delta) DESC) "RANK SQL_ID"
,      ROUND(RATIO_TO_REPORT (SUM(buffer_gets_delta)) OVER (PARTITION BY a.module) * 100,2) percentage
,      SUM(buffer_gets_delta) BG
,      ROUND(SUM(buffer_gets_delta)/SUM(executions_delta)) "BG/EXEC"
,      SUM(executions_delta) EXECS
  FROM dba_hist_sqlstat a
,      dba_hist_snapshot b
,      ( SELECT module
         ,      rank() over (order by (SUM(buffer_gets_delta)) desc) rank_bg
           FROM dba_hist_sqlstat a
         ,      dba_hist_snapshot b
          WHERE a.dbid           = b.dbid
            AND a.snap_id        = b.snap_id
            AND a.executions_delta   > 0
            --AND a.module LIKE '%MAP_Q_TRANSACOES%'
            --AND a.module NOT IN ('DBMS_SCHEDULER')
            AND b.end_interval_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                                        AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
          GROUP BY module
       ) c
 WHERE a.dbid           = b.dbid
   AND a.snap_id        = b.snap_id
   AND a.executions_delta   > 0
   --AND a.module LIKE '%MAP_Q_TRANSACOES%'
   --AND a.module NOT IN ('DBMS_SCHEDULER')
   AND a.module = c.module
   AND b.end_interval_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE) 
 GROUP BY a.module, c.rank_bg, sql_id
 HAVING rank_bg < 6
 ORDER BY 3, 2, 5


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
 
*/