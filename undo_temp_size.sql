/*
WITH 
TBS_DADOS AS
(SELECT SUM(GREATEST(bytes, maxbytes)) AS DADOS
   FROM dba_data_files
  WHERE tablespace_name IN (SELECT tablespace_name 
                             FROM dba_tablespaces 
                            WHERE contents = 'PERMANENT')
),
TBS_UNDO AS 
(
SELECT SUM(GREATEST(bytes, maxbytes)) AS UNDO
  FROM dba_data_files
 WHERE tablespace_name IN (SELECT tablespace_name 
                             FROM dba_tablespaces 
                            WHERE contents = 'UNDO')
)
SELECT (undo/dados) * 100 UNDO_PERC
--,      undo/1024/1024/1024 GB_UNDO
--,      dados/1024/1024/1024 GB_DADOS
  FROM tbs_dados
,      tbs_undo
*/

COL undo_perc HEAD "UNDO %" FOR 99990.00

SELECT (undo/dados) * 100 UNDO_PERC
,      ROUND(undo/1024/1024/1024,2) GB_UNDO
,      ROUND(dados/1024/1024/1024,2) GB_DADOS
,      ROUND((((dados)*0.1))/1024/1024/1024,2) UNDO_SIZE
  FROM (SELECT (SUM(a.bytes)-SUM(NVL(b.bytes,0))) AS DADOS
          FROM dba_data_files a
        ,      (SELECT file_id, SUM(bytes) bytes
                  FROM dba_free_space
                 GROUP BY file_id) b
         WHERE a.file_id = b.file_id(+)
           AND a.tablespace_name IN (SELECT tablespace_name 
                                       FROM dba_tablespaces 
                                      WHERE contents = 'PERMANENT'
                                        AND tablespace_name NOT IN ('SYSTEM','SYSAUX'))                                      
) tbs_dados
,      (SELECT SUM(GREATEST(bytes, maxbytes)) AS UNDO
          FROM dba_data_files
         WHERE tablespace_name IN (SELECT tablespace_name 
                                     FROM dba_tablespaces 
                                    WHERE contents = 'UNDO')
) tbs_undo
/

COL temp_perc HEAD "TEMP %" FOR 99990.00

SELECT (temp/dados) * 100 TEMP_PERC
,      ROUND(temp/1024/1024/1024,2) GB_TEMP
,      ROUND(dados/1024/1024/1024,2) GB_DADOS
,      ROUND((((dados)*0.1))/1024/1024/1024,2) TEMP_SIZE
  FROM (SELECT (SUM(a.bytes)-SUM(NVL(b.bytes,0))) AS DADOS
          FROM dba_data_files a
        ,      (SELECT file_id, SUM(bytes) bytes
                  FROM dba_free_space
                 GROUP BY file_id) b
         WHERE a.file_id = b.file_id(+)
           AND a.tablespace_name IN (SELECT tablespace_name 
                                       FROM dba_tablespaces 
                                      WHERE contents = 'PERMANENT'
                                        AND tablespace_name NOT IN ('SYSTEM','SYSAUX'))
) tbs_dados
,      (SELECT SUM(GREATEST(bytes, maxbytes)) AS TEMP
          FROM dba_temp_files
         WHERE tablespace_name IN (SELECT tablespace_name 
                                     FROM dba_tablespaces 
                                    WHERE contents = 'TEMPORARY')
) tbs_temp
/


SELECT contents
,      tablespace_name
  FROM dba_tablespaces
 WHERE contents IN ('TEMPORARY','UNDO')
 ORDER BY 1,2
/


