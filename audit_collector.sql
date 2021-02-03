

START COLLECTION FOR SECURED TARGET o10hm USING HOST dbix25hp.natura.com.br FROM TABLE 'SYS.AUD$';

select 'start collection for secured target "'||st.secured_target_name||'" using host "'||at.host_name||'" from '||at.audit_trail_type||' "'||at.location||'";' 
  from avsys.audit_trail at
,      avsys.secured_target st 
 where (at.collection_status=0 or (at.collection_status=5 and sysdate-at.status_timestamp > interval '30' minute))
   and at.audit_trail_type = 'TABLE'
   and st.active='Y' 
   and at.source_id=st.secured_target_id



COL audit_trail_type    FOR a10
COL secured_target_name FOR a10
COL host_name           FOR a25

SELECT st.SECURED_TARGET_NAME
,      at.host_name
,      at.COLLECTION_STATUS
,      at.audit_trail_type
  FROM avsys.audit_trail at
,      avsys.secured_target st 
 WHERE st.active='Y' 
   AND at.source_id=st.secured_target_id
 ORDER BY 1  

COL secured_target_name FOR a12   
SELECT st.secured_target_id
,      st.secured_target_name
,      st.active 
  FROM avsys.audit_trail at
,      avsys.secured_target st     
 WHERE at.source_id=st.secured_target_id
 ORDER BY 1