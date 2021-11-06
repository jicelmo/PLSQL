create or replace function fnc_verifica_data
(
  p_data  in  varchar
) return boolean 
is
 v_data  date;
begin
 if length(trim(p_data)) != 0 then 
  select cast(p_data as date) as data
    into v_data
     from dual;
  return true;  
 else
  return false;
 end if;
--------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Data Inválida Verifique : '||sqlerrm);
end fnc_verifica_data;
/
