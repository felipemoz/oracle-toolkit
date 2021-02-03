
/* EXIBE O ESPACO OCUPADO DADO UM USERNAME */

SET verify OFF

COL GB HEAD "SIZE(GB)" FOR 999990D00

SELECT tablespace_name
,      SUM(bytes)/1024/1024/1024 AS GB 
  FROM dba_segments
 WHERE owner = UPPER('&owner')
 GROUP BY rollup(tablespace_name)
 ORDER BY 1;

UNDEFINE owner

SET verify ON