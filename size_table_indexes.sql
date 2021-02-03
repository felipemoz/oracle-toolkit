
SET VERIFY OFF

COL segment_name FOR a30
COL mb           FOR 99999999

BREAK ON report SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF mb ON report

PROMPT
ACCEPT owner      PROMPT "OWNER: "
ACCEPT table_name PROMPT "TABLE_NAME: "


WITH 
tables AS 
(
SELECT owner
,      table_name
  FROM dba_tables
 WHERE owner      = UPPER('&&owner')
   AND table_name = UPPER('&&table_name')
),
indexes AS
(
SELECT owner
,      index_name 
  FROM dba_indexes
 WHERE owner      = UPPER('&&owner')
   AND table_name = UPPER('&&table_name')
),
lobs AS
(
SELECT owner
,      segment_name 
  FROM dba_lobs
 WHERE owner      = UPPER('&&owner')
   AND table_name = UPPER('&&table_name')
)
SELECT b.segment_type
,      b.segment_name 
,      ROUND(SUM(b.bytes)/1024/1024) mb
  FROM tables a
,      dba_segments b
 WHERE a.owner      = b.owner
   AND a.table_name = b.segment_name
   AND b.segment_type LIKE 'T%'
 GROUP BY b.segment_type
,         b.segment_name
UNION ALL
SELECT b.segment_type
,      b.segment_name
,      ROUND(SUM(b.bytes)/1024/1024) mb
  FROM indexes a
,      dba_segments b
 WHERE a.owner      = b.owner
   AND a.index_name = b.segment_name
   AND b.segment_type LIKE 'I%'
 GROUP BY b.segment_type
,         b.segment_name
UNION ALL
SELECT b.segment_type
,      b.segment_name
,      ROUND(SUM(b.bytes)/1024/1024) mb
  FROM lobs a
,      dba_segments b
 WHERE a.owner        = b.owner
   AND a.segment_name = b.segment_name
   AND b.segment_type LIKE 'L%'
 GROUP BY b.segment_type
,         b.segment_name
ORDER BY 3 DESC
/

UNDEF table_name
UNDEF owner