
SET VERIFY OFF

BREAK ON REPORT
COMPUTE SUM OF MB ON REPORT

SELECT occupant_name
,      occupant_desc
,      ROUND(space_usage_kbytes/1024) AS MB
  FROM v$sysaux_occupants
 ORDER by space_usage_kbytes DESC;

PROMPT
PROMPT --alter session set "_swrf_test_action" = 72;
PROMPT

SELECT table_name
,      COUNT(*) 
  FROM dba_tab_partitions 
 WHERE table_name LIKE 'WR%' 
   AND table_owner = 'SYS'
 GROUP BY table_name 
 ORDER BY 1;
  
SELECT *
  FROM
(
SELECT owner
,      segment_name
,      round(sum(bytes/1024/1024)) MB
  FROM dba_segments 
 WHERE tablespace_name = 'SYSAUX'
 GROUP BY owner
,      segment_name
 ORDER BY 3 DESC
)
WHERE ROWNUM < 11
/


SELECT COUNT(1) orphaned_rows 
  FROM sys.&table_name a
 WHERE NOT EXISTS
(SELECT 1
   FROM sys.wrm$_snapshot
  WHERE snap_id       = a.snap_id
    AND dbid            = a.dbid);
    --AND instance_number = a.instance_number);
    
COMPUTE SUM OF wasted ON REPORT
COL wasted HEAD "wasted space(MB)"
    
SELECT table_name 
,      ROUND((blocks*8)/1024) AS MB 
,      ROUND((num_rows*avg_row_len/1024/1024)) "actual_data (mb)"
,      (ROUND((blocks*8)/1024) - ROUND((num_rows*avg_row_len/1024/1024))) AS wasted 
  FROM dba_tables
 WHERE (ROUND((blocks*8)/1024) > ROUND((num_rows*avg_row_len/1024/1024)))
   AND table_name LIKE 'WR%'
 ORDER BY 4
/    
    
COL ash       FOR a25
COL snap      FOR a25
COL retention FOR a25

SELECT sysdate - a.sample_time ash
,      sysdate - s.begin_interval_time snap
,      c.retention
  FROM sys.wrm$_wr_control c,
(
SELECT db.dbid
,      MIN(w.sample_time) sample_time
  FROM sys.v_$database db
,      sys.wrh$_active_session_history w
 WHERE w.dbid = db.dbid 
 GROUP BY db.dbid
) a,
(
SELECT db.dbid
,      MIN(r.begin_interval_time) begin_interval_time
  FROM sys.v_$database db
,      sys.wrm$_snapshot r
 WHERE r.dbid = db.dbid
 GROUP BY db.dbid
) s
 WHERE a.dbid = s.dbid
   AND c.dbid = a.dbid;
   
select max(snap_id) max_snap_necessary
  from sys.wrm$_snapshot 
 where begin_interval_time < (sysdate - (select retention from sys.wrm$_wr_control where dbid = (select dbid from v$database)));
 
--select baseline_name,creation_time
--  from dba_hist_baseline;

PROMPT 
PROMPT EXEC dbms_workload_repository.drop_snapshot_range(low_snap_id=>0, high_snap_id=>X);
--select dbms_stats.get_stats_history_retention from dual;


/*
select 'alter table '||segment_name||'  move tablespace SYSAUX;' 
  from dba_segments 
 where tablespace_name = 'SYSAUX'
   and segment_name like 'WR%' 
   and segment_type='TABLE'
 order by bytes;

select 'alter index '||segment_name||' rebuild online parallel (degree 4);' 
  from dba_segments 
 where tablespace_name= 'SYSAUX' 
   and segment_name like '%WR%' 
   and segment_type='INDEX' 
 order by segment_name;

select 'alter index '||s.segment_name||' rebuild online parallel (degree 4);' 
from dba_segments s,  dba_indexes i where s.tablespace_name= 'SYSAUX' 
and s.segment_name like 'WR%' 
and s.segment_type='INDEX' 
and i.status = 'UNUSABLE' 
and i.index_name = s.segment_name order by s.segment_name;
*/


set serveroutput on 
declare 
CURSOR cur_part IS 
SELECT partition_name from dba_tab_partitions 
WHERE table_name = 'WRH$_SQL_PLAN'; 

query1 varchar2(200); 
query2 varchar2(200); 

TYPE partrec IS RECORD (snapid number, dbid number); 
TYPE partlist IS TABLE OF partrec; 

Outlist partlist; 
begin 
dbms_output.put_line('PARTITION NAME SNAP_ID DBID'); 
dbms_output.put_line('--------------------------- ------- ----------'); 

for part in cur_part loop 
query1 := 'select min(snap_id), dbid from 
sys.WRH$_ACTIVE_SESSION_HISTORY partition ('||part.partition_name||') group by dbid'; 
execute immediate query1 bulk collect into OutList; 

if OutList.count > 0 then 
for i in OutList.first..OutList.last loop 
dbms_output.put_line(part.partition_name||' Min '||OutList(i).snapid||' '||OutList(i).dbid); 
end loop; 
end if; 

query2 := 'select max(snap_id), dbid 
from sys.WRH$_ACTIVE_SESSION_HISTORY partition ('||part.partition_name||') group by dbid'; 
execute immediate query2 bulk collect into OutList; 

if OutList.count > 0 then 
for i in OutList.first..OutList.last loop 
dbms_output.put_line(part.partition_name||' Max '||OutList(i).snapid||' '||OutList(i).dbid); 
dbms_output.put_line('---'); 
end loop; 
end if; 

end loop; 
end; 
/



set serveroutput on 
declare 
CURSOR cur_part IS 
SELECT partition_name from dba_tab_partitions 
WHERE table_name = 'WRH$_ACTIVE_SESSION_HISTORY'; 

query1 varchar2(200); 
query2 varchar2(200); 

TYPE partrec IS RECORD (snapid number, dbid number); 
TYPE partlist IS TABLE OF partrec; 

Outlist partlist; 
begin 
dbms_output.put_line('PARTITION NAME SNAP_ID DBID'); 
dbms_output.put_line('--------------------------- ------- ----------'); 

for part in cur_part loop 
query1 := 'select min(snap_id), dbid from 
sys.WRH$_ACTIVE_SESSION_HISTORY partition ('||part.partition_name||') group by dbid'; 
execute immediate query1 bulk collect into OutList; 

if OutList.count > 0 then 
for i in OutList.first..OutList.last loop 
dbms_output.put_line(part.partition_name||' Min '||OutList(i).snapid||' '||OutList(i).dbid); 
end loop; 
end if; 

query2 := 'select max(snap_id), dbid 
from sys.WRH$_ACTIVE_SESSION_HISTORY partition ('||part.partition_name||') group by dbid'; 
execute immediate query2 bulk collect into OutList; 

if OutList.count > 0 then 
for i in OutList.first..OutList.last loop 
dbms_output.put_line(part.partition_name||' Max '||OutList(i).snapid||' '||OutList(i).dbid); 
dbms_output.put_line('---'); 
end loop; 
end if; 

end loop; 
end; 
/


set serveroutput on 
declare 
CURSOR cur_part IS 
SELECT partition_name from dba_tab_partitions 
WHERE table_name = 'WRH$_SQLSTAT'; 

query1 varchar2(200); 
query2 varchar2(200); 

TYPE partrec IS RECORD (snapid number, dbid number); 
TYPE partlist IS TABLE OF partrec; 

Outlist partlist; 
begin 
dbms_output.put_line('PARTITION NAME SNAP_ID DBID'); 
dbms_output.put_line('--------------------------- ------- ----------'); 

for part in cur_part loop 
query1 := 'select min(snap_id), dbid from 
sys.WRH$_SQLSTAT partition ('||part.partition_name||') group by dbid'; 
execute immediate query1 bulk collect into OutList; 

if OutList.count > 0 then 
for i in OutList.first..OutList.last loop 
dbms_output.put_line(part.partition_name||' Min '||OutList(i).snapid||' '||OutList(i).dbid); 
end loop; 
end if; 

query2 := 'select max(snap_id), dbid 
from sys.WRH$_SQLSTAT partition ('||part.partition_name||') group by dbid'; 
execute immediate query2 bulk collect into OutList; 

if OutList.count > 0 then 
for i in OutList.first..OutList.last loop 
dbms_output.put_line(part.partition_name||' Max '||OutList(i).snapid||' '||OutList(i).dbid); 
dbms_output.put_line('---'); 
end loop; 
end if; 

end loop; 
end; 
/

select segment_name, partition_name, bytes/1024/1024 as MB from dba_segments where segment_name = 'WRH$_SQLSTAT';