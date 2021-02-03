set serveroutput on
declare
  val varchar2(32767);
begin
  sys.dbms_system.get_env('&VARIABLE',val);
  sys.dbms_output.put_line('&VARIABLE='||val);
end;
/