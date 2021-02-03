
PROMPT
PROMPT Bloquear estatísticas de uma determinada tabela
PROMPT EXEC dbms_stats.lock_table_stats('OWNER', 'TABLE');
PROMPT
PROMPT Desbloquear estatísticas de uma determinada tabela
PROMPT EXEC dbms_stats.unlock_table_stats('OWNER', 'TABLE');
PROMPT 
PROMPT Bloquear estatísticas de um determinado schema
PROMPT EXEC dbms_stats.lock_schema_stats('OWNER');
PROMPT
PROMPT Desbloquear estatísticas de um determinado schema
PROMPT EXEC dbms_stats.unlock_schema_stats('OWNER');
PROMPT



SELECT owner, table_name, stattype_locked 
  FROM dba_tab_statistics 
 WHERE stattype_locked IS NOT NULL
   AND owner NOT IN ('SYS','SYSTEM','SYSMAN','WMSYS')
 ORDER BY 1,2
/