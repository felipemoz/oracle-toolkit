PROMPT
PROMPT OPEN STANDBY DATABASE
PROMPT 
PROMPT SELECT OPEN_MODE,PROTECTION_MODE,DATABASE_ROLE FROM V$DATABASE;
PROMPT ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
PROMPT RECOVER STANDBY DATABASE;
PROMPT ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH;
PROMPT ALTER DATABASE OPEN;
PROMPT SELECT OPEN_MODE,PROTECTION_MODE,DATABASE_ROLE FROM V$DATABASE;
PROMPT