
SET VERIFY OFF

ACCEPT pUsername PROMPT "Type username: "

SELECT DISTINCT tablespace_name, 'TABLES' AS type
  FROM dba_tables 
 WHERE owner = UPPER('&pUsername')
 UNION
SELECT DISTINCT tablespace_name, 'INDEXES' AS type
  FROM dba_indexes 
 WHERE owner = UPPER('&pUsername')
 ORDER BY 1, 2
/

SET VERIFY ON
 