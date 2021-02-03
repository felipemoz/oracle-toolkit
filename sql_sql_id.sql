
/* EXIBE SQL DADO UM SQL_ID */

SET verify OFF

COL sql_fulltext FOLD_AFTER

SELECT sql_fulltext
,      inst_id
,      sql_id
--,      sql_fulltext
  FROM gv$sql
 WHERE sql_id = '&SQL_ID'
 ORDER BY inst_id
/

SET verify ON