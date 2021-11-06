create or replace function fnc_total_duracao
(
  p_segundos in number
) return varchar2 as

v_resultado varchar2(50);

begin
 select trim(to_char(ROUND(p_segundos/60/60))||':'||
    trim(to_char(trunc(mod(p_segundos,3600)/60),'00'))||':'||
    trim(to_char(mod(mod(p_segundos,3600),60),'00'))) as horas
   into v_resultado
   from dual;
 return v_resultado;
exception
     when no_data_found then return '00:00:00';
     when others        then return '00:00:00';
end fnc_total_duracao;
/
