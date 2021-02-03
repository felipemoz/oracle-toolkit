
SET VERIFY OFF

PROMPT
ACCEPT pDate PROMPT "Type date [ALL] (ddmmyyyy): "

COL begin_interval_time FOR a25
COL end_interval_time   FOR a25

SELECT DISTINCT
       snap_id
,      TRUNC(begin_interval_time,'MI') begin_interval_time
,      TRUNC(end_interval_time,'MI')   end_interval_time
,      dbid
  FROM dba_hist_snapshot
 WHERE begin_interval_time BETWEEN NVL(TRUNC(TO_DATE('&&pDate','DDMMYYYY')),TO_DATE('01011900','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&&pDate','DDMMYYYY'))+1,TO_DATE('01012100','DDMMYYYY'))
 ORDER BY 1
/