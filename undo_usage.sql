
COL sid      FOR 99999
COL username FOR a15
COL GB       FOR 999990.00

SELECT s.inst_id
,      s.username
,      s.SID
,      s.serial#
,      s.logon_time
,      t.xidusn
,      t.ubafil
,      t.ubablk
,      t.used_ublk
,      t.start_date
,      t.status
,      (t.used_ublk * 8)/1024/1025 GB
  FROM gv$session s
,      gv$transaction t
 WHERE s.inst_id = t.inst_id
   AND s.saddr   = t.ses_addr;
   
select state,usn,undoblocksdone,undoblockstotal,undoblocksdone / undoblockstotal * 100  from v$fast_start_transactions;