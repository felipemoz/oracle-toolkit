
column sum  for 9999999999 head 'Total #| Rows'
column cnt  for 9999999999 head 'Total #| Dist Values'
column min  for 9999999999 head 'Min #| of Rows'
column avg  for 9999999999 head 'Avg #| of Rows'
column max  for 9999999999 head 'Max #| of Rows'
column bsel for 9999999999.99999 head 'Best|Selectivity [%]'
column asel for 9999999999.99999 head 'Avg|Selectivity [%]'
column wsel for 9999999999.99999 head 'Worst|Selectivity [%]'

SET VERIFY OFF

ACCEPT table_name PROMPT "Type owner.table_name: "
ACCEPT column_name PROMPT "Type column_name[,column_name]: "

SELECT SUM(a)                     sum
,      COUNT(a)                   cnt
,      MIN(a)                     min
,      ROUND(AVG(a),1)            avg
,      MAX(a)                     max
,      ROUND(MIN(a)/SUM(a)*100,5) bsel
,      ROUND(AVG(a)/SUM(a)*100,5) asel
,      ROUND(MAX(a)/SUM(a)*100,5) wsel
  FROM (SELECT /*+ PARALLEL(tab,4) */ COUNT(1) a 
          FROM &table_name tab 
         --WHERE &&column_name IS NOT NULL  
         GROUP BY &column_name);

SET VERIFY ON         
UNDEFINE column_name
UNDEFINE table_name