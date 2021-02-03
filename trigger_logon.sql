create or replace TRIGGER SYSTEM.USER_LOGON_TRG AFTER logon ON DATABASE
DECLARE
  p_module varchar2(64);
  p_user   varchar2(64);
  p_host   varchar2(64);
  p_osuser varchar2(64);

-- 05/05/2014 - Fabricio Rucci ASM 10662
-- 07/05/2014 - Ivan Machado ASM 11330
-- 04/06/2014 - Fabricio (Adicionado JORGE SANFELICE DESKTOP)
-- 04/06/2014 - Fabricio (Adicionado TELEMETRIA_PROCESSOR_PROD)
-- 04/06/2014 - Fabricio (Adicionado ORACLE2BINARIO)
-- 04/06/2014 - Fabricio (retirado acessos ASM 11330)
-- 16/07/2014 - Ivan (adicionado acessos Carlos Augusto Machado ASM 19543)
-- 30/07/2014 - Ivan (adicionado acessos Carlos Augusto Machado ASM 21809)



BEGIN
  SELECT UPPER(SYS_CONTEXT('USERENV', 'SESSION_USER'))
    INTO p_user
    FROM DUAL;
  SELECT UPPER(SYS_CONTEXT('USERENV', 'MODULE')) INTO p_module FROM DUAL;
  SELECT UPPER(SYS_CONTEXT('USERENV', 'HOST')) INTO p_host FROM DUAL;
  SELECT UPPER(SYS_CONTEXT('USERENV', 'OS_USER')) INTO p_osuser FROM DUAL;

  IF p_user NOT IN ('MONIT',
                    'SYS',
                    'PORTAL_SASCAR',
                    'SASCARSUPORTE',
                    'DBSNMP',
                    'VPXADMIN',
                    'SASWEB_PROD',
                    'PROD_ODI_REPO',
                    'SASWEB_ODI',
                    'SASCAR_PROCESSOR_PROD',
                    'SASWEB_PROCESSOR_PROD',
                    'SOAPRD_MDS',
                    'SOAPRD_ORASDPM',
                    'SOAPRD_SOAINFRA',
                    'SASWEB',
                    'RSA_USER',
                    'IPHONE',
                    'AVL',
                    'SASLOG',
                    'PESA',
                    'SASCAR_URA',
                    'DADPOSICAO_PROD',
                    'PRD_MDS',
                    'PRD_ACTIVITIES',
                    'SOA_GOVERNANCE_PROD',
                    'PRDPI_MDS',
                    'PRDPI_PORTLET',
                    'PRDPI_WEBCENTER',
                    'SOAPRD_SOAINFRA',
                    'SOAPRD_MDS',
                    'SOAPRD_ORASDPM',
                    'PRD_MDS',
                    'PRD_ACTIVITIES',
                    'SASCAR_PROD',
                    'PRDPS_MDS',
                    'PRDPS_ACTIVITIES',
                    'REL_SASGC_EXADATA',
                    'SOB_MEDIDA',
                    'TELEMETRIA_PROCESSOR_PROD',
                    'ORACLE2BINARIO',
                    'SASWEB_MOTOID') THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'Y');
      commit;
    end;
  END IF;
  
  --############################################
  -- REGRA BLOQUEIO SERVIDORES DESENV E HOMOLOG
  --############################################
  IF p_host IN ('STIKADINHO.SASCAR.BR', -- HOMOLOG. JAVA E C#
                'LABIRINTO-DC.SASCAR-DC.BR', -- DESENV. PHP
               -- 'DEVEL-WEBCENTER.SASCAR-DC.BR', -- DESENV. JAVA E C#
                'SISTEMAWEB-01', -- DESENV. SASWEB
                'SISTEMAWEB-02', -- DESENV. SASWEB
                'SISTEMAWEB-04', -- DESENV. SASWEB
                'SISTEMAWEB-05'--, -- DESENV. SASWEB
                --'SJPSVDX-SR01.SASCAR.BR' -- DESENV SOB_MEDIDA SULAMERICA
                ) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Servidor não autorizado para conexões nas bases de producao.');
  END IF;
  --###################################
  -- REGRA OWNER SASWEB
  --###################################
  IF (p_user = 'SASWEB' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR',
                     'SVCPR00582')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER PORTAL_PORTAL
  --###################################
  IF (p_user = 'PORTAL_SASCAR' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'WEBCENTER-PROD.SASCAR-DC.BR',
                     'WEBCENTER-PROD.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR',
                     'SJPSVPX-WEB01.SASCAR.COM.BR',
                     'GVTSVPX-WSP01.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER SASWEB_PROD
  --###################################
  IF (p_user = 'SASWEB_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'EL01CN01.SASCAR-DC.BR',
                     'EL01CN02.SASCAR-DC.BR',
                     'EL01CN03.SASCAR-DC.BR',
                     'EL01CN04.SASCAR-DC.BR',
                     'EL01CN05.SASCAR-DC.BR',
                     'EL01CN06.SASCAR-DC.BR',
                     'EL01CN07.SASCAR-DC.BR',
                     'EL01CN08.SASCAR-DC.BR',
                     'SASWEBSTANDALONE01',
                     'SASWEBSTANDALONE02',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR',
                     'DEVEL-WEBCENTER.SASCAR-DC.BR',
                     'SASWEBSTANDALONE01.SASCAR-DC.BR',
                     'SASWEBSTANDALONE02.SASCAR-DC.BR',
                     'SVCPR00582',
                     'SVCPR00416')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER SASCAR_PROCESSOR_PROD
  --###################################
  IF (p_user = 'SASCAR_PROCESSOR_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'EL01CN01.SASCAR-DC.BR',
                     'EL01CN02.SASCAR-DC.BR',
                     'EL01CN03.SASCAR-DC.BR',
                     'EL01CN04.SASCAR-DC.BR',
                     'EL01CN05.SASCAR-DC.BR',
                     'EL01CN06.SASCAR-DC.BR',
                     'EL01CN07.SASCAR-DC.BR',
                     'EL01CN08.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SJPSVCX-WEB03.SASCAR.LOCAL',
                     'SJPSVCX-WEB04.SASCAR.LOCAL',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER SASWEB_PROCESSOR_PROD
  --###################################
  IF (p_user = 'SASWEB_PROCESSOR_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'EL01CN01.SASCAR-DC.BR',
                     'EL01CN02.SASCAR-DC.BR',
                     'EL01CN03.SASCAR-DC.BR',
                     'EL01CN04.SASCAR-DC.BR',
                     'EL01CN05.SASCAR-DC.BR',
                     'EL01CN06.SASCAR-DC.BR',
                     'EL01CN07.SASCAR-DC.BR',
                     'EL01CN08.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SJPSVCX-WEB03.SASCAR.LOCAL',
                     'SJPSVCX-WEB04.SASCAR.LOCAL',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER DADPOSICAO_PROD
  --###################################
  IF (p_user = 'DADPOSICAO_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'EL01CN01.SASCAR-DC.BR',
                     'EL01CN02.SASCAR-DC.BR',
                     'EL01CN03.SASCAR-DC.BR',
                     'EL01CN04.SASCAR-DC.BR',
                     'EL01CN05.SASCAR-DC.BR',
                     'EL01CN06.SASCAR-DC.BR',
                     'EL01CN07.SASCAR-DC.BR',
                     'EL01CN08.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
  --###################################
  -- REGRA OWNER SOA_GOVERNANCE_PROD
  --###################################
  IF (p_user = 'SOA_GOVERNANCE_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'EL01CN01.SASCAR-DC.BR',
                     'EL01CN02.SASCAR-DC.BR',
                     'EL01CN03.SASCAR-DC.BR',
                     'EL01CN04.SASCAR-DC.BR',
                     'EL01CN05.SASCAR-DC.BR',
                     'EL01CN06.SASCAR-DC.BR',
                     'EL01CN07.SASCAR-DC.BR',
                     'EL01CN08.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
  --###################################
  -- REGRA WEBLOGIC
  --###################################
  IF (p_user IN ('PRDPI_MDS',
                 'PRDPI_PORTLET',
                 'PRDPI_WEBCENTER',
                 'SOAPRD_SOAINFRA',
                 'SOAPRD_MDS',
                 'SOAPRD_ORASDPM',
                 'PRD_MDS',
                 'PRD_ACTIVITIES',
                 'PRDPS_MDS',
                 'PRDPS_ACTIVITIES') AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'EL01CN01.SASCAR-DC.BR',
                     'EL01CN01',
                     'EL01CN02.SASCAR-DC.BR',
                     'EL01CN02',
                     'EL01CN03.SASCAR-DC.BR',
                     'EL01CN03',
                     'EL01CN04.SASCAR-DC.BR',
                     'EL01CN04',
                     'EL01CN05.SASCAR-DC.BR',
                     'EL01CN05',
                     'EL01CN06.SASCAR-DC.BR',
                     'EL01CN06',
                     'EL01CN07.SASCAR-DC.BR',
                     'EL01CN07',
                     'EL01CN08.SASCAR-DC.BR',
                     'EL01CN08',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR',
                     'WEBCENTER-PROD.SASCAR-DC.BR',
                     'WEBCENTER-PROD2.SASCAR-DC.BR',
                     'WEBCENTER-PROD-2.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA ODI
  --###################################
  IF (p_user IN ('SASWEB_ODI', 'PROD_ODI_REPO') AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR',
                     'SJP-5004823-N', -- PABLO PANDA
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SASCAR\SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SASCAR\SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-6222908-N', -- CHARLES STEIN
                     'SJP-138542-N', -- ANDRE SENTONE
                     'SJPSVCX-ORA01', -- CONTINGENCIA
                     'SJPSVCX-ORA02' -- CONTINGENCIA
                     )) THEN 
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA VMWARE
  --###################################
  IF (p_user IN ('RSA_USER', 'VPXADMIN') AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SASCAR\VCENTER02',
                     'VCENTER02',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER IPHONE
  --###################################
  IF (p_user = 'IPHONE' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'JAVA-APLICACOES-01.SASCAR-DC.BR',
                     'JAVA-APLICACOES-02.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER AVL
  --###################################
  IF (p_user = 'AVL' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'JAVA-APLICACOES-01.SASCAR-DC.BR',
                     'JAVA-APLICACOES-02.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER SASLOG
  --###################################
  IF (p_user = 'SASLOG' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'JAVA-APLICACOES-01.SASCAR-DC.BR',
                     'JAVA-APLICACOES-02.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER PESA, CONCREBRAS
  --###################################
  IF (p_user in ('PESA','CONCREBRAS') AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SERVICE\SVCPR00416', -- RICARDO GODOI
                     'SERVICE\SVCPR00419', -- MARIO JORGE
                     'JAVA-APLICACOES-01.SASCAR-DC.BR',
                     'JAVA-APLICACOES-02.SASCAR-DC.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  --###################################
  -- REGRA OWNER SASCAR_URA
  --###################################
  IF (p_user = 'SASCAR_URA' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SJPSVPX-WEB01.SASCAR.COM.BR',
                     'SAS1DB01.SASCAR-DC.BR',
                     'SAS1DB02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
  --###################################
  -- REGRA OWNER SASCAR_PROD
  --###################################
  IF (p_user = 'SASCAR_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'PROCESSOC.SASCAR-DC.BR',
                     'SASWEBSTANDALONE01',
                     'SASWEBSTANDALONE01.SASCAR-DC.BR',
                     'SASWEBSTANDALONE02.SASCAR-DC.BR',
                     'SASWEBSTANDALONE02')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
 --###################################
 -- REGRA OWNER REL_SASGC_EXADATA
 --################################### 
  
 IF (p_user = 'REL_SASGC_EXADATA' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'BINARIOS.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  ELSE                          
     execute immediate 'alter session set optimizer_dynamic_sampling=0';                       
  END IF;
 
 
--   IF (p_user = 'REL_SASGC_EXADATA') THEN
--   execute immediate 'alter session set optimizer_dynamic_sampling=0';
--   begin
--     insert into SYSTEM.AUDITORIA_LOGON values (p_user, p_module, sysdate, p_host, p_osuser, 'Y');
--     commit;
--   end;
--  END IF;
   
 --###################################
 -- REGRA OWNER SOB_MEDIDA
 --################################### 
  
 IF (p_user = 'SOB_MEDIDA' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'BINARIOS.SASCAR-DC.BR'
                   --  'SJPSVDX-SR01.SASCAR.BR',
                    -- 'SJPSVHX-APP02.SASCAR.BR' -- MAQUINA DE HOMOLOGAÇAO SUL AMERICA SOB MEDIDA
                    )) THEN 
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  ELSE                          
     execute immediate 'alter session set optimizer_dynamic_sampling=0';                       
  END IF;

  --#######################################
  -- REGRA OWNER TELEMETRIA_PROCESSOR_PROD
  --#######################################
  IF (p_user = 'TELEMETRIA_PROCESSOR_PROD' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SASWEBSTANDALONE01.SASCAR-DC.BR',
                     'SASWEBSTANDALONE02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
  --#######################################
  -- REGRA OWNER ORACLE2BINARIO - (BACKUP POSIÇÕES PARA BINARIO)
  --#######################################
  IF (p_user = 'ORACLE2BINARIO' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'PROCESSOC.SASCAR-DC.BR', -- ASM 21809
                     'JDBCCLIENT', -- ASM 21809
                     'SJPSVCX-ACTMQ01')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
  --#######################################
  -- REGRA OWNER SASWEB_MOTOID
  --#######################################
  IF (p_user = 'SASWEB_MOTOID' AND
     p_host NOT IN ('SERVICE\SVCRS00417', -- FABRICIO RUCCI
                     'SJP-5004821-N', -- JORGE SANFELICE NOTEBOOK
                     'SJP-5004751-D', -- JORGE SANFELICE DESKTOP
                     'SJP-5006256-D', -- CARLOS AUGUSTO MACHADO
                     'SASWEBSTANDALONE01.SASCAR-DC.BR',
                     'SASWEBSTANDALONE02.SASCAR-DC.BR')) THEN
    begin
      insert into SYSTEM.AUDITORIA_LOGON
      values
        (p_user, p_module, sysdate, p_host, p_osuser, 'N');
      commit;
    end;
    DBMS_SESSION.SET_IDENTIFIER('about to raise app_error..');
    RAISE_APPLICATION_ERROR(-20003,
                            'Voce nao esta autorizado a se conectar neste banco de dados com esse uruário');
  END IF;
  
 --###################################
END;
