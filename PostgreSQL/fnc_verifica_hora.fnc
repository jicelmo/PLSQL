create or replace function midiaclip.fnc_verifica_hora
(
  p_hora  in  varchar
) return boolean
is
 v_hora  time;
begin
 if length(trim(p_hora)) != 0 then
  select cast(p_hora as time) as hora
    into v_hora
     from dual;
  return true;
 else
  return false;
 end if;
--------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Hora Inválida Verifique : '||sqlerrm);
end fnc_verifica_hora;
