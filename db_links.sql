
PROMPT 
PROMPT CREATE DB LINK IN ANOTHER USERS SCHEMA
PROMPT 
PROMPT CREATE PROCEDURE otheruser.cre_db_lnk AS
PROMPT BEGIN
PROMPT     EXECUTE IMMEDIATE 'CREATE DATABASE LINK newlink '
PROMPT             ||'CONNECT TO remoteuser IDENTIFIED BY pw '
PROMPT             ||'USING ''remotetns''';
PROMPT END cre_db_lnk;
PROMPT /
PROMPT 
PROMPT GRANT create database link TO otheruser;
PROMPT exec otheruser.cre_db_lnk 
PROMPT REVOKE create database link FROM otheruser; 
PROMPT DROP PROCEDURE otheruser.cre_db_lnk;
PROMPT SELECT owner,db_link FROM dba_db_links;
PROMPT 
PROMPT
PROMPT CREATE DB LINK WITH NO PASSWORD
PROMPT
PROMPT SELECT 'ALTER USER '||name||' IDENTIFIED BY VALUES '''||password||''';'
PROMPT   FROM sys.user$ 
PEOMPT  WHERE name IN (SELECT DISTINCT owner FROM dba_db_links);
PROMPT
PROMPT SELECT 'CREATE DATABASE LINK "'||A.NAME||'" CONNECT TO "'||A.USERID||'" IDENTIFIED BY VALUES '''||A.PASSWORDX||''' USING '''||A.HOST||''';'
PROMPT   FROM sys.link$ a, dba_db_links b 
PROMPT  WHERE a.name=b.db_link
PROMPT    AND b.owner='username';
PROMPT



/* EXIBE INFORMACOES DOS DB_LINKS */

SET verify OFF

COL owner    FOR A20
COL username FOR A20;
COL host     FOR A20;
COL db_link  FOR A50;

SELECT *
  FROM dba_db_links;

SET verify ON