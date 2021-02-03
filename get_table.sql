
SET VERIFY OFF

ACCEPT pTable_owner PROMPT "Type OWNER: "
ACCEPT pTable_name PROMPT "Type TABLE_NAME: "


SELECT DBMS_METADATA.GET_DDL('TABLE',UPPER('&pTable_name'),UPPER('&pTable_owner')) 
  FROM DUAL
/

SET VERIFY ON