
/* EXIBE O ESPACO OCUPADO POR UM DATABASE */

--ta errada a maneira de calcular os redos, se tiver numero diferente de membros.

SET verify OFF

COLUMN "Total Gb" FORMAT 99,999.0
COLUMN "Redo Gb"  FORMAT 99,999.0
COLUMN "Temp Gb"  FORMAT 99,999.0
COLUMN "Data Gb"  FORMAT 99,999.0

Prompt
Prompt "Database Size"

SELECT (SELECT SUM(bytes/1048576/1024) 
          FROM dba_data_files) "Data Gb",
       (SELECT NVL(SUM(bytes/1048576/1024),0) 
          FROM dba_temp_files) "Temp Gb",
       (SELECT SUM(bytes/1048576/1024)*MAX(members) 
          FROM v$log) "Redo Gb",
       (SELECT SUM(bytes/1048576/1024) 
          FROM dba_data_files) + (SELECT NVL(SUM(bytes/1048576/1024),0) 
                                    FROM dba_temp_files) + (SELECT SUM(bytes/1048576/1024)*MAX(members) 
                                                              FROM v$log) "Total Gb"
  FROM dual;

SET verify ON