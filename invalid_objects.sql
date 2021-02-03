col owner for a30
col object_type for a30
col object_name for a30

SELECT owner, COUNT(1) AS INVALIDS
  FROM dba_objects
 WHERE status = 'INVALID'
 GROUP BY owner
 ORDER BY 1
/

SELECT owner, object_type, COUNT(1)
  FROM dba_objects
 WHERE status = 'INVALID'
 GROUP BY owner, object_type
 ORDER BY 1, 2
/

SELECT owner, object_type, object_name
  FROM dba_objects
 WHERE status = 'INVALID'
 ORDER BY 1, 2, 3
/
  