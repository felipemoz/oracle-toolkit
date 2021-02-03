


SELECT s.sid, s.serial#, s.username, s.program,
 i.block_changes
 FROM v$session s, v$sess_io i
 WHERE s.sid = i.sid
 ORDER BY 5 desc, 1, 2, 3, 4;