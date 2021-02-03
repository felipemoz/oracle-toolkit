/* ************************************************************* */
/* Index Fragmentation Status (idsfrag.sql):                     */
/*                                                               */
/* This script will report the index fragmentation status        */
/*   for a schema.                                               */
/*                                                               */
/* Note: - Do not run this scrip during peak processing hours!!! */
/*       - This script will fail for locked tables.              */
/*                                                               */
/* ************************************************************* */

prompt -- Drop and create temporary table to hold stats...
drop table my_index_stats
/
create table my_index_stats (
        index_name              varchar2(30),
        height                  number(8),
        del_lf_rows             number(8),
        distinct_keys           number(8),
        rows_per_key            number(10,2),
        blks_gets_per_access    number(10,2),
        lf_rows                 number(10)
)
/

prompt -- Save script which we will later use to populate the above table...
insert into my_index_stats
select NAME, HEIGHT, DEL_LF_ROWS, DISTINCT_KEYS, ROWS_PER_KEY,
       BLKS_GETS_PER_ACCESS, LF_ROWS
from   INDEX_STATS
-- Note this open line...

save /tmp/save_index_stats.sql replace

prompt
prompt -- Spool listing with validate commands...
col line1 newline
col line2 newline
col line3 newline
set pagesize 0
set echo off
set termout off
set trimspool on
set feed off
set linesize 200
spool /tmp/validate_indexes.sql
select 'prompt Process table '||owner||'.'||table_name||
       ', index '||index_name||'...' line1,
       'validate index '||owner||'.'||index_name||';' line2,
       '@/tmp/save_index_stats.sql' line3
from   sys.dba_indexes 
where owner NOT IN (SELECT user_name FROM sys.default_pwd$)
  and owner NOT IN ('APEX_030200','WCSWWWDLV01')
  and owner = 'BPMHML01_SOAINFRA'
order  by owner, table_name, index_name
/
spool off
set termout on
set feed on

prompt
prompt -- Run script to validate indexes...
@/tmp/validate_indexes.sql

prompt -- Print nice report...
set pagesize 50000
set trimspool on
col height format 99999
col del_rows format 9999999
col rows/key format 999999.9
spool idxfrag.lst
select INDEX_NAME, HEIGHT, DEL_LF_ROWS "DEL_ROWS", DISTINCT_KEYS "DIST KEYS",
       ROWS_PER_KEY "ROWS/KEY",
       BLKS_GETS_PER_ACCESS "BLKS/ACCESS",
       DEL_LF_ROWS / LF_ROWS "PERC"
from   MY_INDEX_STATS
where (DEL_LF_ROWS / LF_ROWS > 0.2 OR HEIGHT >= 4)
  and lf_rows > 0
/
spool off

-- Cleanup
drop table my_index_stats
/
! rm /tmp/validate_indexes.sql
! rm /tmp/save_index_stats.sql

prompt
prompt Report is in idxfrag.lst
prompt Done!!!

                          
                          
                          