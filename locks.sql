

--SELECT c.inst_id
--,      session_id "sid"
--,      serial#  "Serial"
--,      SUBSTR(object_name,1,30) "Object"
--,      SUBSTR(os_user_name,1,10) "Terminal"
--,      SUBSTR(oracle_username,1,10) "Locker"
--,      NVL(lockwait,'active') "Wait"
--,      decode(locked_mode,    2, 'row share',
--                              3, 'row exclusive',
--                              4, 'share',
--                              5, 'share row exclusive',
--                              6, 'exclusive',  'unknown') "Lockmode"
--,      object_type "Type"
--  FROM gv$locked_object a
--,      dba_objects b
--,      gv$session c
-- WHERE a.object_id = b.object_id
--   AND c.sid = a.session_id
--   AND c.inst_id = a.inst_id
--   --AND c.machine in ('cssmp11','cssmp12')
-- ORDER BY 1 ASC, 2 ASC, 5 Desc
--/

COL sess FOR A15


SELECT DECODE(request,0, 'Holder: ','Waiter: ')||sid sess
,      inst_id
,      id1
,      id2
,      lmode
,      request
,      type
,      ctime
  FROM gv$lock
 WHERE (id1, id2, type) IN (SELECT id1
                            ,      id2
                            ,      type
                              FROM gv$lock 
                             WHERE request>0)
 ORDER BY id1, request
/


COL sid_serial FOR A18
COL object_name FOR A15
COL secs       FOR 99999999
COL inst       FOR 9
COL username   FOR A10
COL machine    FOR A10
COL program    FOR A10
COL lmode      FOR 9
COL request    FOR 9
COL event      FOR A10
COL m          FOR 9
COL r          FOR 9

SELECT DECODE(a.request,0, 'Holder: ','Waiter: ')||a.sid || ' ' || b.serial# as sid_serial
,      c.object_name
,      b.row_wait_obj#
,      b.last_call_et secs
,      a.inst_id as "INST"
,      b.username
,      osuser
,      b.sql_id
,      b.prev_sql_id
--,      b.sql_hash_value
,      b.machine
,      b.program
--,      a.id1
--,      a.id2
,      a.lmode AS M
,      a.request AS R
,      a.type
,      b.event
  FROM gv$lock a
,      gv$session b
,      dba_objects c
 WHERE (a.id1, a.id2, a.type) IN (SELECT id1
                                  ,      id2
                                  ,      type
                                    FROM gv$lock 
                                   WHERE request>0)
   AND a.inst_id = b.inst_id
   AND a.sid = b.sid
   AND c.object_id(+) = b.row_wait_obj#
   --AND c.data_object_id = b.row_wait_obj#(+)
 ORDER BY id1, a.request
/

COL program  FOR a30
COL machine  FOR a15
COL username FOR a10
COL secs     FOR 999999
SELECT DECODE(a.request,0, 'Holder: ','Waiter: ')||a.sid || ' ' || b.serial# as sid_serial
,      c.object_name
,      b.row_wait_obj#
,      b.last_call_et secs
,      a.inst_id as "INST"
,      b.username
,      b.sql_id
,      b.sql_hash_value
--,      b.prev_sql_id
--,      b.sql_hash_value
,      b.machine
,      b.program
--,      a.id1
--,      a.id2
,      a.lmode AS M
,      a.request AS R
,      a.type
--,      b.event
  FROM gv$lock a
,      gv$session b
,      dba_objects c
 WHERE (a.id1, a.id2, a.type) IN (SELECT id1
                                  ,      id2
                                  ,      type
                                    FROM gv$lock 
                                   WHERE request>0)
   AND a.inst_id = b.inst_id
   AND a.sid = b.sid
   AND c.object_id(+) = b.row_wait_obj#
   --AND c.data_object_id = b.row_wait_obj#(+)
 ORDER BY id1, a.request
/

/*
SELECT 
  s.serial# AS serial, 
  s.sid, 
  s.username, 
  s.osuser, 
  e.event, 
  e.total_waits, 
  e.time_waited/100 AS total_time_waited 
FROM 
  v$session_event e, 
  v$session s 
WHERE 
  e.sid = s.sid 
AND e.event LIKE 'enq:%' 
AND s.user# <> 0
*/