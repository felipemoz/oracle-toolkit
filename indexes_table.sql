/************************************************************************/
/* EXIBE INFORMACOES DOS INDEXES EXISTENTES PARA UMA DETERMINADA TABELA */
/************************************************************************/

SET TIME OFF TIMI OFF FEEDBACK OFF
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI:SS';
SET TIME ON TIMI ON FEEDBACK ON

SET VERIFY OFF


PROMPT 
ACCEPT table_owner PROMPT "Type the TABLE_OWNER: "
ACCEPT table_name  PROMPT "Type the TABLE_NAME: "


REPHEADER LEFT COL 2 '*************************************************************************' SKIP 1 -
               COL 2 '* ' _date ' INDEXES FOR ' &table_owner '.' &table_name ' *' SKIP 1 -
               COL 2 '*************************************************************************' SKIP 2                              


/*
SELECT 'DEGREE:  ' || degree
,      'LOGGING: ' || logging
  FROM dba_indexes
 WHERE owner       = UPPER('&TABLE_OWNER')
   AND table_name  = UPPER('&TABLE_NAME')
*/


COL owner             FOR a20        HEAD 'INDEX_OWNER'
COL column_name       FOR A30        HEAD 'COLUMN|NAME'
COL uniqueness        FOR A6         HEAD 'UNIQUE'
COL num_buckets       FOR 999        HEAD 'BUCKETS'
COL clustering_factor FOR 9999999999 HEAD 'CLUSTERING|FACTOR'

BREAK ON index_name SKIP 1
 
SELECT a.owner
,      a.index_name
,      b.column_name
,      a.index_type
,      DECODE(a.uniqueness,'UNIQUE','YES','NO') uniqueness
,      a.partitioned
,      a.clustering_factor
,      c.num_buckets
  FROM dba_indexes a
,      dba_ind_columns b
,      dba_tab_columns c
 WHERE a.table_name  = UPPER('&TABLE_NAME')
   AND a.table_owner = UPPER('&TABLE_OWNER')
   AND a.index_name  = b.index_name
   AND a.owner       = b.index_owner
   AND b.index_owner = c.owner       (+) -- Outer Join necessário pois FBI não aparece na dba_tab_columns!
   AND b.table_name  = c.table_name  (+)
   AND b.column_name = c.column_name (+)
 ORDER BY a.owner, a.index_name, b.column_position
/

PROMPT 

UNDEFINE TABLE_NAME

SET verify ON

REPHEADER OFF