
PROMPT ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
PROMPT ALTER DATABASE OPEN READ ONLY;
PROMPT ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

COL LOG_GAP FORMAT 9999
COL APPLIED_TIME FORMAT A20

SELECT archived.thread#
  ,      APPLIED_TIME
  ,      log_archived-log_applied LOG_GAP
    FROM 
( 
  SELECT thread#
  ,      MAX(sequence#) LOG_ARCHIVED
    FROM gv$archived_log
   WHERE dest_id=1
     AND archived='YES'
     AND resetlogs_time IN (SELECT MAX(RESETLOGS_TIME) FROM gv$archived_log) 
   GROUP BY thread#
) archived,   
(   
 SELECT thread#
   ,      MAX(sequence#) LOG_APPLIED
   ,      MAX(COMPLETION_TIME) APPLIED_TIME
     FROM gv$archived_log
    WHERE dest_id=2
      AND applied='YES'
      AND resetlogs_time IN (SELECT MAX(RESETLOGS_TIME) FROM gv$archived_log) 
   GROUP BY thread#
) applied
 WHERE archived.thread# = applied.thread#
 ORDER BY 1
/



SELECT MAX(LOG_GAP) 
FROM (
  SELECT archived.thread#
  ,      APPLIED_TIME
  ,      log_archived-log_applied LOG_GAP
    FROM 
( 
  SELECT thread#
  ,      MAX(sequence#) LOG_ARCHIVED
    FROM gv$archived_log
   WHERE dest_id=1
     AND archived='YES'
     AND resetlogs_time IN (SELECT MAX(RESETLOGS_TIME) FROM gv$archived_log) 
   GROUP BY thread#
) archived,   
(   
 SELECT thread#
   ,      MAX(sequence#) LOG_APPLIED
   ,      MAX(COMPLETION_TIME) APPLIED_TIME
     FROM gv$archived_log
    WHERE dest_id=2
      AND applied='YES'
      AND resetlogs_time IN (SELECT MAX(RESETLOGS_TIME) FROM gv$archived_log) 
   GROUP BY thread#
) applied
 WHERE archived.thread# = applied.thread#
 ORDER BY 1
);