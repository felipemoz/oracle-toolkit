
SET VERIFY OFF

ACCEPT pTable_owner PROMPT "Type OWNER: "
ACCEPT pTable_name PROMPT "Type VIEW_NAME: "


SELECT DBMS_METADATA.GET_DDL('VIEW',UPPER('&pTable_name'),UPPER('&pTable_owner')) 
  FROM DUAL
/

SET VERIFY ON