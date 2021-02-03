
/* EXIBE INFORMACOES DOS TEMPFILES */

PROMPT
PROMPT --ALTER TABLESPACE temp SHRINK SPACE KEEP 5120M;
PROMPT --ALTER TABLESPACE temp SHRINK TEMPFILE '+O68PR_DATA/o68pr/tempfile/temp.263.826751861' KEEP 30M;
PROMPT

SET verify OFF

COL tablespace_name FOR A30
COL file_name       FOR A80
COL MBytes          FOR 999990

BREAK ON REPORT
COMPUTE SUM OF MBytes    ON REPORT
COMPUTE SUM OF MaxMBytes ON REPORT

SELECT tablespace_name
,      file_name
,      ROUND(bytes / 1024 / 1024) AS MBytes
,      ROUND(maxbytes / 1024 / 1024) AS MaxMBytes
,      status
,      autoextensible
  FROM dba_temp_files
 ORDER BY 1
/
 
SET verify ON