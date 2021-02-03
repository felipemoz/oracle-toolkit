
SET VERIFY OFF

SELECT tablespace_name
FROM (
SELECT DISTINCT tablespace_name
  FROM dba_tables
 WHERE owner = UPPER('&&username')
UNION
SELECT DISTINCT tablespace_name
  FROM dba_tab_partitions
 WHERE table_owner = UPPER('&&username')
UNION
SELECT DISTINCT tablespace_name
  FROM dba_indexes
 WHERE owner = UPPER('&&username')
UNION
SELECT DISTINCT tablespace_name
  FROM dba_ind_partitions
 WHERE index_owner = UPPER('&&username')
)
ORDER BY 1
/

UNDEF username