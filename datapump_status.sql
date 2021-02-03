

SELECT sid
,      serial#
,      sql_id
,      event
,      seconds_in_wait
,      last_call_et
  FROM v$session s
,      dba_datapump_sessions d
 WHERE s.saddr = d.saddr;