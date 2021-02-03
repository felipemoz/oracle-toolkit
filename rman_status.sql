
COL filename FOR a100

PROMPT 
PROMPT  Block Change Tracking
PROMPT 

SELECT * 
  FROM v$block_change_tracking;

COL operation    FOR a32
COL elapsed_time FOR a30

SELECT start_time
,      end_time 
,      operation
,      status
,      mbytes_processed      
,      object_type
  FROM v$rman_status
 ORDER BY 1
/

PROMPT 
PROMPT Running...
PROMPT

SELECT start_time
,      end_time 
,      operation
,      status
,      mbytes_processed
,      object_type
  FROM v$rman_status
 WHERE status LIKE 'RUNNING%'
 ORDER BY 1
/

PROMPT 
PROMPT DB INCR...
PROMPT

COL operation    FOR a30
COL elapsed_time FOR a30
COL status       FOR a21
 
SELECT start_time
,      end_time 
,      numtodsinterval(end_time - start_time,'DAY') AS elapsed_time
,      operation
,      status
,      mbytes_processed
,      object_type
  FROM v$rman_status
 WHERE object_type = 'DB INCR'
 ORDER BY 1
/



/*
SELECT p.spid
,      sw.event
,      sw.seconds_in_wait as sec_wait
,      sw.state, client_info
FROM   gv$session_wait sw
,      gv$session s
,      gv$process p
WHERE  sw.event like '%MML%'
   OR  sw.event like '%RMAN%'
AND    s.sid=sw.sid
AND    s.paddr=p.addr
*/


/*
select ctime "Date"
     , decode(backup_type, 'L', 'Archive Log', 'D', 'Full', 'Incremental') backup_type
     , bsize "Size MB"
from (select trunc(bp.completion_time) ctime
          , backup_type
          , round(sum(bp.bytes/1024/1024),2) bsize
   from v$backup_set bs, v$backup_piece bp
   where bs.set_stamp = bp.set_stamp
   and bs.set_count  = bp.set_count
   and bp.status = 'A'
   group by trunc(bp.completion_time), backup_type)
order by 1, 2;

set lines 220
set pages 1000
col cf for 999
col df for 999
col elapsed_seconds heading "ELAPSED|SECONDS"
col i0 for 999
col i1 for 999
col l for 999
col output_mbytes for 9,999,999 heading "OUTPUT|MBYTES"
col session_recid for 999999 heading "SESSION|RECID"
col session_stamp for 99999999999 heading "SESSION|STAMP"
col status for a10 trunc
col time_taken_display for a10 heading "TIME|TAKEN"
col output_instance for 9999 heading "OUT|INST"
select
  j.session_recid, j.session_stamp,
  to_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
  to_char(j.end_time, 'yyyy-mm-dd hh24:mi:ss') end_time,
  (j.output_bytes/1024/1024) output_mbytes, j.status, j.input_type,
  decode(to_char(j.start_time, 'd'), 1, 'Sunday', 2, 'Monday',
                                     3, 'Tuesday', 4, 'Wednesday',
                                     5, 'Thursday', 6, 'Friday',
                                     7, 'Saturday') dow,
  j.elapsed_seconds, j.time_taken_display,
  x.cf, x.df, x.i0, x.i1, x.l,
  ro.inst_id output_instance
from V$RMAN_BACKUP_JOB_DETAILS j
  left outer join (select
                     d.session_recid, d.session_stamp,
                     sum(case when d.controlfile_included = 'YES' then d.pieces else 0 end) CF,
                     sum(case when d.controlfile_included = 'NO'
                               and d.backup_type||d.incremental_level = 'D' then d.pieces else 0 end) DF,
                     sum(case when d.backup_type||d.incremental_level = 'D0' then d.pieces else 0 end) I0,
                     sum(case when d.backup_type||d.incremental_level = 'I1' then d.pieces else 0 end) I1,
                     sum(case when d.backup_type = 'L' then d.pieces else 0 end) L
                   from
                     V$BACKUP_SET_DETAILS d
                     join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count
                   where s.input_file_scan_only = 'NO'
                   group by d.session_recid, d.session_stamp) x
    on x.session_recid = j.session_recid and x.session_stamp = j.session_stamp
  left outer join (select o.session_recid, o.session_stamp, min(inst_id) inst_id
                   from GV$RMAN_OUTPUT o
                   group by o.session_recid, o.session_stamp)
    ro on ro.session_recid = j.session_recid and ro.session_stamp = j.session_stamp
where j.start_time > trunc(sysdate)-&NUMBER_OF_DAYS
order by j.start_time;

*/