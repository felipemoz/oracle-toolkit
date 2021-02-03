
COL group FOR 999
COL group_name HEAD "Group Name" FOR a10
COL disk_name  HEAD "Disk Name"  FOR a15
COL disk_number HEAD "Disk" FOR 999
COL path FOR a54

SELECT group_number  AS "Group"
,      name          AS group_name
,      state         AS "State"
,      type          AS "Type"
,      total_mb/1024 AS "Total GB"
,      free_mb/1024  AS "Free GB"
  FROM v$asm_diskgroup
/

SELECT c.group_number  AS "group"
,      g.name          AS group_name
,      c.instance_name AS "Instance"
  FROM v$asm_client c
,      v$asm_diskgroup g
 WHERE g.group_number=c.group_number
/

SELECT b.group_number   AS "group"
,      b.name           AS group_name
,      a.name           AS disk_name
,      a.disk_number    
,      a.header_status  AS "Header"
,      a.mode_status    AS "Mode"
,      a.state          AS "State"
,      a.redundancy     AS "Redundancy"
,      a.total_mb       AS "Total MB"
,      a.free_mb        AS "Free MB"
--,      failgroup      AS "Failure Group"
,      a.path           AS "Path"
  FROM v$asm_disk a
,      v$asm_diskgroup b
 WHERE a.group_number = b.group_number
 ORDER BY b.group_number
,         a.disk_number
/

SELECT header_status
,      COUNT(1)
  FROM v$asm_disk
 GROUP BY header_status
/

SELECT header_status
,      mode_status
,      path 
  FROM v$asm_disk
 WHERE header_status IN ('FORMER','CANDIDATE')
/