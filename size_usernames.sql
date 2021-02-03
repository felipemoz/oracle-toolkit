
/* EXIBE O ESPACO OCUPADO DADO UM USERNAME */

SET verify OFF

COL GB HEAD "SIZE(GB)" FOR 999990D00

SELECT owner
,      SUM(bytes)/1024/1024/1024 AS GB 
  FROM dba_segments
 GROUP BY rollup(owner)
 ORDER BY 2;

UNDEFINE owner

SET verify ON