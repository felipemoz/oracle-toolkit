SET SPACE 1 LINESIZE 80 PAGES 1000
SELECT * FROM (
       SELECT TO_CHAR(originating_timestamp,'YYYY/MM/DD HH24:MI:SS TZH:TZM')--, message_text
         FROM v$diag_alert_ext 
        WHERE TRIM(component_id)='rdbms' 
          AND message_text LIKE ('PMON started with%') 
ORDER BY originating_timestamp DESC ) 
WHERE rownum < 20;
