SET ECHO OFF

COL data      FOR A30
COL usuario   FOR A30
COL instancia FOR A30
COL maquina   FOR A30
COL ip        FOR A30

SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')                    AS DATA
,      (SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL)  AS USUARIO
,      (SELECT SYS_CONTEXT ('USERENV', 'INSTANCE_NAME') FROM DUAL) AS INSTANCIA
,      (SELECT SYS_CONTEXT ('USERENV', 'HOST') FROM DUAL)          AS MAQUINA
,      (SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS') FROM DUAL)    AS IP
  FROM dual;
    
/*

CREATE USER gsb_dba IDENTIFIED BY Natura3214#;
GRANT CONNECT, RESOURCE TO gsb_dba;

CREATE OR REPLACE VIEW gsb_dba.banner AS
SELECT (SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') FROM DUAL)  AS USUARIO
,      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')                    AS DATA
,      (SELECT SYS_CONTEXT ('USERENV', 'INSTANCE_NAME') FROM DUAL) AS INSTANCIA
,      (SELECT SYS_CONTEXT ('USERENV', 'HOST') FROM DUAL)          AS MAQUINA
,      (SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS') FROM DUAL)    AS IP
  FROM dual;

GRANT SELECT ON gsb_dba.banner TO PUBLIC;
CREATE PUBLIC SYNONYM banner FOR gsb_dba.BANNER;

*/