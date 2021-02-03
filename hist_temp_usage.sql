
SET VERIFY OFF

ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy)[01012015]: "

ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy)[SYSDATE]:"

SELECT sample_time
,      sql_id
,      temp_space_allocated/1024/1024/1024 as "TEMP(GB)"
  FROM dba_hist_active_sess_history 
 WHERE temp_space_allocated IS NOT NULL
   AND sample_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012015','DDMMYYYY'))
                       AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE)
 ORDER BY 3,1;