
PROMPT
PROMPT -- ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
PROMPT 

SELECT profile
,      resource_name 
,      limit
  FROM dba_profiles 
 ORDER BY 1,2;