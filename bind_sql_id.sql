/********************************************************/
/* EXIBE AS VARIAVEIS BIND DE UM COMANDO DADO UM SQL_ID */
/********************************************************/

SET TIME OFF TIMI OFF FEEDBACK OFF
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI:SS';
SET TIME ON TIMI ON FEEDBACK ON

SET VERIFY OFF


PROMPT 
ACCEPT sql_id PROMPT "Type the SQL_ID: "


REPHEADER LEFT COL 2 '****************************************************************' SKIP 1 -
               COL 2 '* ' _date ' BIND VARIABLES FOR SQL_ID: ' &sql_id ' *' SKIP 1 -
               COL 2 '****************************************************************' SKIP 2
               

COL name FOR a15
COL value_string FOR a50

BREAK ON child_number SKIP 1

SELECT inst_id
,      child_number
,      name
,      position
,      last_captured
,      value_string
  FROM gv$sql_bind_capture
 WHERE sql_id = '&sql_id'
 ORDER BY inst_id, child_number, last_captured, position
/

REPHEADER OFF
SET VERIFY ON