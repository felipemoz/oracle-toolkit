
SET verify OFF
SET feedback OFF
ALTER SESSION SET nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
SET feedback ON

COL date FOR a15

COMPUTE SUM OF gb ON report
BREAK ON report SKIP PAGE

ACCEPT pBegin PROMPT "Type begin date (ddmmyyyy) [01012016]: "

ACCEPT pEnd   PROMPT "Type end date (ddmmyyyy) [SYSDATE]: "

--REPHEADER LEFT COL 2 '*****************************************' SKIP 1 -
--               COL 2 '* ' _date ' ARCHIVES PER DATE *' SKIP 1 -
--               COL 2 '*****************************************' SKIP 2

SET PAGES 0 EMBEDDED ON
SET FEED OFF
SET TIMI OFF

PROMPT

VAR pSid VARCHAR2(30)
SELECT name INTO :pSid 
  FROM v$database;

PROMPT

SELECT TO_CHAR(TRUNC(completion_time),'DY DD/MM/YYYY') AS "DATE"
,      ROUND(SUM(blocks * block_size)/1024/1024/1024) AS GB
  FROM gv$archived_log 
 WHERE completion_time BETWEEN NVL('&pBegin',TO_DATE('01/01/2016','DD/MM/YYYY')) AND NVL('&pEnd',TO_DATE('01/01/2050','DD/MM/YYYY')+1)
 GROUP BY TRUNC(completion_time) 
 ORDER BY TRUNC(completion_time);

PROMPT 
 
SET verify ON
REPHEADER OFF