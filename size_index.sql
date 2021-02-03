
/************************************************/
/* EXIBE O ESPACO, EM MB, OCUPADO POR UM INDICE */
/************************************************/

SET TIME OFF TIMI OFF FEEDBACK OFF
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI:SS';
ALTER SESSION SET NLS_NUMERIC_CHARACTERS ='.,';
SET TIME ON TIMI ON FEEDBACK ON

SET VERIFY OFF


PROMPT 
ACCEPT index_name  PROMPT "Type the INDEX_NAME: "
ACCEPT index_owner PROMPT "Type the INDEX_OWNER: "


REPHEADER LEFT COL 2 '*************************************************************************' SKIP 1 -
               COL 2 '* ' _date ' SIZE FOR INDEX ' &index_owner '.' &index_name ' *' SKIP 1 -
               COL 2 '*************************************************************************' SKIP 2

COL megabytes FOR 999,999,999.00

SELECT a.tablespace_name
,      b.extents
,      ROUND(SUM (b.bytes) / 1024 / 1024) megabytes
  FROM dba_indexes a
,      dba_segments b
 WHERE a.index_name      = b.segment_name
   AND a.tablespace_name = b.tablespace_name
   AND a.index_name      = UPPER('&INDEX_NAME')
 GROUP BY a.tablespace_name, b.extents
/

PROMPT

UNDEFINE 1

SET verify ON