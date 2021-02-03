SET VERIFY OFF
COL SQL_TEXT FORMAT A41

SELECT sql_id
,      length(sql_text) length
,      sql_text
  FROM dba_hist_sqltext j
 WHERE DBMS_LOB.INSTR(UPPER(sql_text), UPPER('&sql_text'), 1, 1) <> 0
   AND sql_text NOT LIKE '%FROM dba_hist_sqltext j%'
   AND sql_id LIKE NVL('&sql_id',sql_id)
/