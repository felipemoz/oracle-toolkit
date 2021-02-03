
SELECT *
  FROM
(
SELECT NVL(event,'CPU') event
,      COUNT(1)
  FROM gv$active_session_history
 WHERE sample_time > SYSDATE - 1/24/60*30 -- 30 minutos
 GROUP BY event
 ORDER BY 2 DESC
)
 WHERE rownum < 6
/

BREAK ON INST_ID SKIP 1
SELECT *
  FROM
(
SELECT inst_id
,      NVL(event,'CPU') event
,      COUNT(1)
,      RANK () OVER (PARTITION BY inst_id ORDER BY COUNT(1) DESC) rank
  FROM gv$active_session_history
 WHERE sample_time > SYSDATE - 1/24/60*30 -- 30 minutos
 GROUP BY inst_id, event
 ORDER BY 1,3 DESC
)
 WHERE rank < 6
 ORDER BY inst_id
,         rank
/