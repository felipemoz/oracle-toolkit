
/* EXIBE INFORMACOES DE TABLESPACE */

PROMPT 
PROMPT -- DROP TABLESPACE tbs INCLUDING CONTENTS AND DATAFILES;
PROMPT -- CREATE BIGFILE TABLESPACE tbs DATAFILE SIZE 1M AUTOEXTEND ON MAXSIZE 500G BLOCKSIZE 8192/16384;
PROMPT -- ALTER TABLESPACE tbs1 RENAME TO tbs2;
PROMPT

SET verify OFF

COL tablespace_name FOR A30

PROMPT
ACCEPT pTablespace PROMPT "Type TABLESPACE_NAME(LIKE): "

SELECT tablespace_name
,      block_size
,      next_extent/1024/1024 "NEXT EXTENT(MB)"
,      pct_increase
,      status
,      extent_management
,      segment_space_management
  FROM dba_tablespaces
 WHERE tablespace_name LIKE UPPER('%&pTablespace%')
 ORDER BY 1;
  
SET verify ON