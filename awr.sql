PROMPT 
PROMPT
PROMPT CONFIGURAR 
PROMPT EXEC DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS ( INTERVAL => 60, RETENTION => 129600); -- parametros em minutos (90d=129600,60d=86400,30d=43200)
PROMPT
PROMPT
PROMPT EXPURGAR AWR
PROMPT EXEC DBMS_WORKLOAD_REPOSITORY.DROP_SNAPSHOT_RANGE (LOW_SNAP_ID => start_id, HIGH_SNAP_ID => end_id, DBID => dbid);
PROMPT EXEC DBMS_WORKLOAD_REPOSITORY.DROP_BASELINE ( BASELINE_NAME => 'baseline', CASCADE => true, DBID => dbid );
PROMPT
PROMPT
PROMPT EXPORTAR AWR
PROMPT
PROMPT @?/rdbms/admin/awrextr.sql
PROMPT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PROMPT ~  This script will extract the AWR data for a range of snapshots  ~
PROMPT ~  into a dump file.  The script will prompt users for the         ~
PROMPT ~  following information:                                          ~
PROMPT ~     (1) database id                                              ~
PROMPT ~     (2) snapshot range to extract                                ~
PROMPT ~     (3) name of directory object                                 ~
PROMPT ~     (4) name of dump file                                        ~
PROMPT 
PROMPT 
PROMPT IMPORTAR AWR
PROMPT @?/rdbms/admin/awrload.sql
PROMPT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PROMPT ~  This script will load the AWR data from a dump file. The   ~
PROMPT ~  script will prompt users for the following information:    ~
PROMPT ~     (1) name of directory object                            ~
PROMPT ~     (2) name of dump file                                   ~
PROMPT ~     (3) staging schema name to load AWR data into           ~
PROMPT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PROMPT
PROMPT
PROMPT HABILITAR AWR
PROMPT ALTER SYSTEM SET CONTROL_MANAGEMENT_PACK_ACCESS='DIAGNOSTIC+TUNING' SCOPE=BOTH;
PROMPT 
PROMPT
PROMPT Gerar AWR
PROMPT @?/rdbms/admin/awrrpt.sql
PROMPT @?/rdbms/admin/addmrpt.sql
PROMPT

show parameter pack
 
-- LISTAR CONFIGURACAO
COL snap_interval FOR a30
COL retention     FOR a30

SELECT dbid
,      snap_interval
,      retention
  FROM dba_hist_wr_control
/

SELECT dbid FROM v$database
/
SELECT baseline_name, dbid FROM sys.wrm$_baseline
/
SELECT MIN(snap_id), MAX(snap_id), dbid FROM dba_hist_snapshot GROUP BY dbid
/

select extract( day from snap_interval) *24*60+
       extract( hour from snap_interval) *60+
       extract( minute from snap_interval ) "Snapshot Interval",
       extract( day from retention) *24*60+
       extract( hour from retention) *60+
       extract( minute from retention ) "Retention Interval"
from dba_hist_wr_control
/

