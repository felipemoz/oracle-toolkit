
ACCEPT pOwnerTable  PROMPT "Type [OWNER].table: "
 
REPHEADER LEFT COL 9 '************************************************* ' SKIP 1 -
               COL 9 '* STATISTICS FOR TABLE: ' &&pOwnerTable   SKIP 1 -
               COL 9 '************************************************* ' SKIP 2

SELECT owner
,      table_name
,      last_analyzed
,      num_rows
  FROM dba_tables
 WHERE table_name = UPPER('&pOwnerTable');