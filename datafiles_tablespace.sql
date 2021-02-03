
/* EXIBE INFORMACOES DOS DATAFILES DADO UM TABLESPACE */

SET VERIFY OFF

ACCEPT pTablespace PROMPT "Type TABLESPACE_NAME: "

COL "File Name"  FOR A65
COL "MBytes"     FOR 9999999
COL "Max MBytes" FOR 9999999
COL "Rank"       NOPRINT 

BREAK ON REPORT
COMPUTE SUM OF "Free MBytes" ON REPORT

SELECT a.file_name                              AS "File Name"
,      c.bigfile                                AS "BigFile"
,      ROUND(a.bytes / 1024 / 1024)             AS "MBytes"
,      ROUND(NVL(SUM(b.bytes),0) / 1024 / 1024) AS "Free MBytes"
,      ROUND(a.maxbytes / 1024 / 1024)          AS "Max MBytes"
,      a.status                                 AS "Status"
,      a.autoextensible                         AS "Auto Extensible"
,      SUBSTR(a.file_name, DECODE(INSTR(a.file_name,'/',-1), 0, INSTR(a.file_name,'\',-1),INSTR(a.file_name,'/',-1)), LENGTH(a.file_name)) AS "Rank"
  FROM dba_data_files a
,      dba_free_space b
,      dba_tablespaces c
 WHERE a.file_id         = b.file_id(+)
   AND a.tablespace_name = c.tablespace_name
   AND UPPER(a.tablespace_name) = UPPER('&pTablespace')
 GROUP BY a.file_name, c.bigfile, a.bytes, a.maxbytes, a.status, a.autoextensible
 ORDER BY 6, 2;
 
CL COL
SET VERIFY ON
