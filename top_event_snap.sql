
PROMPT
ACCEPT pBegin PROMPT "Type begin snap: "
ACCEPT pEnd   PROMPT "Type end snap: "

PROMPT
PROMPT TOP CLASSE DE EVENTOS POR TEMPO DE ESPERA (30 MINUTOS)
PROMPT

SELECT wait_class_id
,      NVL(wait_class,'CPU') wait_class
,      COUNT(*) cnt 
,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
  FROM dba_hist_active_sess_history
 WHERE snap_id BETWEEN &&pBegin AND &&pEnd
 GROUP BY wait_class_id
,         wait_class
 ORDER BY 3 DESC
/

PROMPT
PROMPT TOP CLASSE DE EVENTOS POR TEMPO DE ESPERA (30 MINUTOS) POR INSTANCE
PROMPT

BREAK ON instance_number SKIP 1
SELECT instance_number
,      wait_class_id
,      NVL(wait_class,'CPU') wait_class
,      COUNT(*) cnt 
,      RANK() OVER (PARTITION BY instance_number ORDER BY COUNT(*) DESC) rank
  FROM dba_hist_active_sess_history
 WHERE snap_id BETWEEN &&pBegin AND &&pEnd
 GROUP BY instance_number
,         wait_class_id
,         wait_class
 ORDER BY 1,4 DESC
/




PROMPT
PROMPT TOP EVENTOS DA TOP CLASSE DE EVENTOS (SEM CONSIDERAR CPU)
PROMPT

SELECT event_id
,      event
,      COUNT(*) cnt 
,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
  FROM dba_hist_active_sess_history
 WHERE snap_id BETWEEN &&pBegin AND &&pEnd
   AND wait_class_id IN (
                          SELECT wait_class_id
                            FROM ( 
                                  SELECT wait_class_id
                                  ,      NVL(wait_class,'CPU')
                                  ,      COUNT(*) cnt 
                                  ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
                                    FROM dba_hist_active_sess_history
				   WHERE snap_id BETWEEN &&pBegin AND &&pEnd
                                     AND wait_class IS NOT NULL
                                   GROUP BY wait_class_id
                                  ,         wait_class
                                 )
                           WHERE rank = 1
                        ) 
 GROUP BY event_id, event
 ORDER BY 3 DESC
/

PROMPT
PROMPT TOP SQL_ID DO TOP EVENTO (SEM CONSIDERAR CPU)
PROMPT

SELECT sql_id
,      event_id
,      COUNT(*) cnt 
,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
  FROM dba_hist_active_sess_history
 WHERE snap_id BETWEEN &&pBegin AND &&pEnd
   AND event_id in (
                     SELECT event_id
                       FROM (
                             SELECT event_id
		             ,      event
		             ,      COUNT(*) cnt 
		             ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
		               FROM dba_hist_active_sess_history
			      WHERE snap_id BETWEEN &&pBegin AND &&pEnd
		                AND wait_class_id IN (
		                                       SELECT wait_class_id
		                                         FROM ( 
		                                               SELECT wait_class_id
		                                               ,      NVL(wait_class,'CPU')
		                                               ,      COUNT(*) cnt 
		                                               ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
		                                                 FROM dba_hist_active_sess_history
							        WHERE snap_id BETWEEN &&pBegin AND &&pEnd
		                                                  AND wait_class IS NOT NULL
		                                                GROUP BY wait_class_id
		                                               ,         wait_class
		                                              )
		                                        WHERE rank = 1
		                                     ) 
                              GROUP BY event_id, event
                            )
                      WHERE rank = 1
                   )
 GROUP BY sql_id
,         event_id 
--HAVING COUNT(*)>1000
 ORDER BY 3 DESC;


PROMPT
PROMPT TOP OBJETOS DO TOP SQL_ID DO TOP EVENTO
PROMPT

SELECT current_obj# object_id
,      COUNT(*) cnt 
,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
  FROM dba_hist_active_sess_history
 WHERE snap_id BETWEEN &&pBegin AND &&pEnd
   AND (sql_id,event_id) IN (
                             SELECT sql_id
                             ,      event_id
                               FROM (
                                     SELECT sql_id
                                     ,      event_id
                                     ,      COUNT(*) cnt 
                                     ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
                                       FROM dba_hist_active_sess_history
				      WHERE snap_id BETWEEN &&pBegin AND &&pEnd
                                        AND event_id in (
                                                          SELECT event_id
                                                            FROM (
                                                                  SELECT event_id
                                     		                  ,      event
                                     		                  ,      COUNT(*) cnt 
		                     		                  ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
		                     		                    FROM dba_hist_active_sess_history
								   WHERE snap_id BETWEEN &&pBegin AND &&pEnd
		                     		                     AND wait_class_id IN (
		                     		                                           SELECT wait_class_id
		                     		                                             FROM ( 
		                     		                                                   SELECT wait_class_id
		                     		                                                   ,      NVL(wait_class,'CPU')
		                     		                                                   ,      COUNT(*) cnt 
		                     		                                                   ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
		                     		                                                     FROM dba_hist_active_sess_history
												    WHERE snap_id BETWEEN &&pBegin AND &&pEnd
		                     		                                                      AND wait_class IS NOT NULL
		                     		                                                    GROUP BY wait_class_id
		                     		                                                   ,         wait_class
		                     		                                                  )
		                     		                                            WHERE rank = 1
		                     		                                          ) 
                                     		                   GROUP BY event_id, event
                                    		                 )
                                                           WHERE rank = 1
                                                        )
                                     GROUP BY sql_id
                                     ,         event_id    
                                    )
                              WHERE rank = 1
                            )
 GROUP BY current_obj#
 ORDER BY 2;



COL object_name FOR a30

SELECT object_id
,      owner
,      object_name
,      subobject_name
,      object_type 
  FROM dba_objects
 WHERE object_id IN (
 SELECT object_id
FROM (
SELECT current_obj# object_id
,      COUNT(*) cnt 
,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
  FROM dba_hist_active_sess_history
 WHERE snap_id BETWEEN &&pBegin AND &&pEnd
   AND (sql_id,event_id) IN (
                             SELECT sql_id
                             ,      event_id
                               FROM (
                                     SELECT sql_id
                                     ,      event_id
                                     ,      COUNT(*) cnt 
                                     ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
                                       FROM dba_hist_active_sess_history
				      WHERE snap_id BETWEEN &&pBegin AND &&pEnd
                                        AND event_id in (
                                                          SELECT event_id
                                                            FROM (
                                                                  SELECT event_id
                                     		                  ,      event
                                     		                  ,      COUNT(*) cnt 
		                     		                  ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
		                     		                    FROM dba_hist_active_sess_history
								   WHERE snap_id BETWEEN &&pBegin AND &&pEnd
		                     		                     AND wait_class_id IN (
		                     		                                           SELECT wait_class_id
		                     		                                             FROM ( 
		                     		                                                   SELECT wait_class_id
		                     		                                                   ,      NVL(wait_class,'CPU')
		                     		                                                   ,      COUNT(*) cnt 
		                     		                                                   ,      RANK() OVER (ORDER BY COUNT(*) DESC) rank
		                     		                                                     FROM dba_hist_active_sess_history
												    WHERE snap_id BETWEEN &&pBegin AND &&pEnd
		                     		                                                      AND wait_class IS NOT NULL
		                     		                                                    GROUP BY wait_class_id
		                     		                                                   ,         wait_class
		                     		                                                  )
		                     		                                            WHERE rank = 1
		                     		                                          ) 
                                     		                   GROUP BY event_id, event
                                    		                 )
                                                           WHERE rank = 1
                                                        )
                                     GROUP BY sql_id
                                     ,         event_id    
                                    )
                              WHERE rank = 1
                            )
 GROUP BY current_obj#
 ORDER BY 2)
WHERE rank = 1
);
