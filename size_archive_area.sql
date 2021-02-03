
COL name FOR a15

SELECT *
  FROM 
(
SELECT name
,    (space_limit-space_used)/1024/1024 free_mb 
,    space_limit/1024/1024 total_mb
,    DECODE( NVL( space_used, 0), 0, 0, ceil ( ( space_used / space_limit) * 100) ) PCT_USED
FROM v$recovery_file_dest
ORDER BY name
)
WHERE name IS NOT NULL
UNION ALL
SELECT *
  FROM 
(
SELECT a.name
,      a.free_mb
,      a.total_mb
,      CEIL(100-((a.free_mb)/a.total_mb*100)) PCT_USED
  FROM v$asm_diskgroup a
,      (SELECT TRIM(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTR(UPPER(value),1,INSTR(value||' ',' ')),','),'"'),'+'),'LOCATION=')) name
          FROM v$parameter 
         WHERE name = 'log_archive_dest_1') b
WHERE a.name = b.name
)
/