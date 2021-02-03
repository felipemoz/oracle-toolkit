
PROMPT
PROMPT Habilitar archive
PROMPT
PROMPT ALTER SYSTEM SET log_archive_dest_1 ="LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=o02pr" sid='*';
PROMPT srvctl stop database -d o02pr
PROMPT startup mount;
PROMPT alter database archivelog;
PROMPT alter database open;
PROMPT archive log list;
PROMPT srvctl start database -d o02pr