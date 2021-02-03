
PROMPT
PROMPT Enable audit cleanup
PROMPT
PROMPT BEGIN
PROMPT  SYS.DBMS_AUDIT_MGMT.INIT_CLEANUP(
PROMPT  AUDIT_TRAIL_TYPE            => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
PROMPT  DEFAULT_CLEANUP_INTERVAL    => 24 );
PROMPT END;
PROMPT
PROMPT Configure archive ts
PROMPT
PROMPT BEGIN
PROMPT  SYS.DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
PROMPT   audit_trail_type => SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
PROMPT   last_archive_time => SYSDATE-1);
PROMPT END;
PROMPT
PROMPT Purge audit trail
PROMPT
PROMPT BEGIN
PROMPT  SYS.DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
PROMPT   audit_trail_type           =>  SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
PROMPT   use_last_arch_timestamp    =>  TRUE );
PROMPT END;
PROMPT

SELECT MIN(timestamp)
  FROM dba_audit_trail
/

SELECT COUNT(1)
  FROM dba_audit_trail
/

SET SERVEROUTPUT ON
BEGIN
 IF
   SYS.DBMS_AUDIT_MGMT.IS_CLEANUP_INITIALIZED(SYS.DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL)
 THEN
   DBMS_OUTPUT.PUT_LINE('Database and OS audit are initialized for cleanup');
 ELSE
   DBMS_OUTPUT.PUT_LINE('Database and OS audit are not initialized for cleanup.');
 END IF;
END;
/

SELECT *
  FROM 
(
SELECT *
  FROM dba_audit_mgmt_clean_events
 ORDER BY cleanup_time DESC
)
 WHERE rownum < 11
/


SELECT *
  FROM dba_audit_mgmt_last_arch_ts
/




