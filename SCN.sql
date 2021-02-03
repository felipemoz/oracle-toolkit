

WITH T1 AS(
SELECT time_dp 
,      24*60*60*(time_dp - lag(time_dp) OVER (ORDER BY time_dp)) timediff
,      scn - LAG(scn) OVER(ORDER BY time_dp) scndiff
  FROM SYS.smon_scn_time
)
SELECT time_dp 
,      timediff
,      scndiff
,      trunc(scndiff/timediff) rate_per_sec
  FROM t1
 ORDER BY 1
/

COL first_change# FORMAT 99999999999999999999
COL next_change#  FORMAT 99999999999999999999
SELECT thread#
,      first_time
,      next_time
,      first_change#
,      next_change#
,      sequence#
,      next_change#-first_change# diff
,      ROUND ((next_change#-first_change#)/(next_time-first_time)/24/60/60) rt
  from ( SELECT thread#
         ,      first_time
         ,      first_change#
         ,      next_time
         ,      next_change#
         ,      sequence#
         ,      dest_id 
           FROM v$archived_log
          WHERE next_time > sysdate-30 
            AND ((next_time-first_time)/24/60/60) > 0
            AND dest_id=1
          ORDER BY next_time
       )
 ORDER BY first_time
,         thread#
/

col current_scn format 99999999999999999999999
col maxscn format  9999999999999999999999
 select 
   dbms_flashback.get_system_change_number current_scn,
   ((
    ((to_number(to_char(sysdate,'YYYY'))-1988)*12*31*24*60*60) +
    ((to_number(to_char(sysdate,'MM'))-1)*31*24*60*60) +
    (((to_number(to_char(sysdate,'DD'))-1))*24*60*60) +
    (to_number(to_char(sysdate,'HH24'))*60*60) +
    (to_number(to_char(sysdate,'MI'))*60) +
    (to_number(to_char(sysdate,'SS')))
    ) * (16*1024)) maxscn 
 from v$instance
/




WITH limits AS (
  SELECT 
      current_scn
  --, dbms_flashback.get_system_change_number as current_scn -- Oracle 9i
    , (SYSDATE - TO_DATE('1988-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) * 24*60*60 * 16384 
        AS SCN_soft_limit
    , 281474976710656 AS SCN_hard_limit
  FROM V$DATABASE
)
SELECT
    current_scn
  , current_scn/scn_soft_limit*100 AS pct_soft_limit_exhausted
  , scn_soft_limit
  , current_scn/scn_hard_limit*100 AS pct_hard_limit_exhausted
  , scn_hard_limit
FROM limits;


WITH limits AS (
  SELECT 
      current_scn
  --, dbms_flashback.get_system_change_number as current_scn -- Oracle 9i
    , (SYSDATE - TO_DATE('1988-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) * 24*60*60 * 16384 
        AS SCN_soft_limit
    , 281474976710656 AS SCN_hard_limit
  FROM V$DATABASE
)
SELECT current_scn/scn_soft_limit*100 AS pct_soft_limit_exhausted
--  , current_scn/scn_hard_limit*100 AS pct_hard_limit_exhausted
FROM limits;