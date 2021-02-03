
SET verify OFF

COL gb HEAD "Arc Size (GB)" 

PROMPT
ACCEPT pBegin   PROMPT "Type begin date (ddmmyyyy) [01012015]: "
ACCEPT pEnd     PROMPT "Type end date (ddmmyyyy) [SYSDATE]:   "
ACCEPT pMinutes PROMPT "Type minutes interval: "


SELECT TRUNC(first_time,'hh24') + (TRUNC(TO_CHAR(first_time,'mi')/&&pMinutes)*&&pMinutes)/24/60 AS DateTime
,      ROUND(SUM(blocks*block_size)/1024/1024/1024,2) AS GB
  FROM v$archived_log
 WHERE first_time BETWEEN NVL(TO_DATE('&&pBegin','DDMMYYYY'),TO_DATE('01/01/2015','DD/MM/YYYY')) 
                      AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
 GROUP BY TRUNC(first_time,'hh24') + (TRUNC(TO_CHAR(first_time,'mi')/&&pMinutes)*&&pMinutes)/24/60
 ORDER BY 1
/

COL max HEAD "Max Size per &&pMinutes minutes (GB)"
COL avg HEAD "Average Size per &&pMinutes minutes (GB)"

SELECT ROUND(MAX(GB),2) AS max
,      ROUND(AVG(GB),2) AS avg 
FROM 
(
SELECT TRUNC(first_time,'hh24') + (TRUNC(TO_CHAR(first_time,'mi')/&&pMinutes)*&&pMinutes)/24/60 AS DateTime
,      SUM(blocks*block_size)/1024/1024/1024 AS GB
  FROM v$archived_log
 WHERE first_time BETWEEN NVL(TO_DATE('&&pBegin','DDMMYYYY'),TO_DATE('01/01/2015','DD/MM/YYYY'))  
                      AND NVL(TRUNC(TO_DATE('&&pEnd','DDMMYYYY'))+1,SYSDATE)
 GROUP BY TRUNC(first_time,'hh24') + (TRUNC(TO_CHAR(first_time,'mi')/&&pMinutes)*&&pMinutes)/24/60
)
/

/*
SELECT a.first_time date_time,
       ROUND((a.first_time - LAG(a.first_time,1) OVER (PARTITION BY a.thread# ORDER BY a.sequence#))*24*60) interval_min
  FROM v$loghist a
 WHERE a.thread# = &inst_id
   --AND a.first_time BETWEEN :date_start AND :date_end + 1
 ORDER BY a.sequence#
*/

SELECT ROUND(MIN(interval)) minutos
  FROM (
SELECT thread#
,      AVG(interval_min) interval
  FROM 
(
SELECT a.thread#
,      ROUND((a.first_time - LAG(a.first_time,1) OVER (PARTITION BY a.thread# ORDER BY a.sequence#))*24*60) interval_min
  FROM v$loghist a
) 
 GROUP BY thread#
 ORDER BY thread#
)
/

select count(*) || ' groups, with ' || members || ' members (' || round(bytes/1024/1024) || ' MB each)' redo_info
  from gv$log
 where inst_id = &&inst_id
   and thread# = &&inst_id
 group by members, round(bytes/1024/1024)
union all
select 'per node, stored in the path(s) below:' from dual
union all
select distinct substr(member,1,instr(replace(member,'\','/'),'/',-1)) redo_path
  from gv$logfile
 where inst_id = &&inst_id