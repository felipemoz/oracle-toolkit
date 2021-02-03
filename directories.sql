
PROMPT
PROMPT
PROMPT CREATE OR REPLACE DIRECTORY directory_name AS '/path';
PROMPT GRANT read, write ON directory_name TO username;
PROMPT
PROMPT

COL directory_path FOR a100
SELECT * FROM dba_directories
/

