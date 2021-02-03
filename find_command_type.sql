SET VERIFY OFF

ACCEPT pBegin     PROMPT "Type begin date (ddmmyyyy)[01012016]: "

ACCEPT pEnd       PROMPT "Type end date (ddmmyyyy)[SYSDATE]:"

ACCEPT pTableName PROMPT "Type table_name LIKE:"

SELECT DISTINCT DECODE(c.command_type,1,'CREATE TABLE'
                            ,2,'INSERT'
                            ,3,'SELECT'
                            ,6,'UPDATE'
                            ,7,'DELETE'
                            ,9,'CREATE INDEX'
                            ,11,'ALTER INDEX'
                            ,26,'LOCK TABLE'
                            ,42,'ALTER_SESSION'
                            ,44,'COMMIT'
                            ,45,'ROLLBACK'
                            ,46,'SAVEPOINT'
                            ,47,'PL/SQL BLOCK'
                            ,48,'SET TRANSACTION'
                            ,50,'EXPLAIN'
                            ,62,'ANALYZE TABLE'
                            ,90,'SET CONSTRAINTS'
                            ,170,'CALL'
                            ,189,'MERGE','UNKNOWN') command_type
	   , b.sql_id
  FROM dba_hist_snapshot a
,      dba_hist_sqlstat b
,      dba_hist_sqltext c
 WHERE a.dbid              = b.dbid
   AND a.instance_number   = b.instance_number
   AND a.snap_id           = b.snap_id
   AND b.sql_id            = c.sql_id
   AND command_type        = 2
   AND a.end_interval_time BETWEEN NVL(TO_DATE('&pBegin','DDMMYYYY'),TO_DATE('01012016','DDMMYYYY'))
                               AND NVL(TRUNC(TO_DATE('&pEnd','DDMMYYYY'))+1,SYSDATE)
   AND UPPER(c.sql_text) LIKE UPPER('%&pTableName%')
 ORDER BY 1
/