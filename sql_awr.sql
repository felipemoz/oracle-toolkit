
SELECT sql_id
,      sql_text
  FROM dba_hist_sqltext
 WHERE sql_id ='&sql_id' 
/