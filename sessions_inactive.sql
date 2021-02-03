
/* EXIBE INFORMACOES DAS SESSOES INATIVAS DADA UM PERIODO */

SET verify OFF;

COL inst     FOR 9
COL spid     FOR A5
COL sid      FOR 99999
COL serial#  FOR 99999
COL username FOR A20
COL osuser   FOR A20
COL program  FOR A20
COL period   FOR A20

TTITLE left _date center 'Table Extended Parameter Report' skip 2

PROMPT
ACCEPT j PROMPT "Digite o tempo de inatividade (M minutos, H horas, D dias): "
	
SELECT p.spid
,      s.inst_id AS inst
,      s.sid
,      s.serial#
,      s.username
,      s.osuser
,      s.program
,      s.logon_time
,      s.last_call_et 
,      s.status
,      TRUNC(last_call_et/(60*60*24)) || 'D ' 
    || TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24) || 'H '
    || TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60) || 'M '
    || TRUNC(MOD((MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60  )   ,( TRUNC(MOD((MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24),TRUNC(MOD(last_call_et/(60*60*24),TRUNC(last_call_et/(60*60*24))) * 24)) * 60)))  * 60) || 'S '    AS Period
  FROM gv$session s
,      gv$process p
 WHERE last_call_et       > DECODE(UPPER(SUBSTR('&&j',LENGTH('&&j'),1)), 'M', TO_NUMBER(SUBSTR('&&j',1,LENGTH('&&j')-1)) * 60
                                                                       , 'H', TO_NUMBER(SUBSTR('&&j',1,LENGTH('&&j')-1)) * 60 * 60
                                                                       , 'D', TO_NUMBER(SUBSTR('&&j',1,LENGTH('&&j')-1)) * 60 * 60 * 24)
   AND s.username IS NOT NULL
   AND s.STATUS IN ('SNIPED','INACTIVE')
   AND s.paddr = p.addr
   AND s.inst_id = p.inst_id
ORDER BY s.status, s.last_call_et DESC;
 
UNDEFINE j

SET verify ON;