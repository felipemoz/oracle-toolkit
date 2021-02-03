
COL d_name FOR a20
COL p_name FOR a20

SELECT do.obj# d_obj
,      do.name d_name
,      do.type# d_type
,      po.obj# p_obj
,      po.name p_name
,      to_char(p_timestamp,'DD-MON-YYYY HH24:MI:SS') "P_Timestamp"
,      to_char(po.stime ,'DD-MON-YYYY HH24:MI:SS') "STIME", 
decode(sign(po.stime-p_timestamp),0,'SAME','*DIFFER*') X 
from sys.obj$ do, sys.dependency$ d, sys.obj$ po
where P_OBJ#=po.obj#(+) and D_OBJ#=do.obj# 
and do.status=1 /*dependent is valid*/ 
and po.status=1 /*parent is valid*/ 
and po.stime!=p_timestamp /*parent timestamp not match*/ 
order by 2,1; 