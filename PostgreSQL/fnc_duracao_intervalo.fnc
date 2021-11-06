create or replace function midiaclip.fnc_duracao_intervalo
(
  p_data_inicio  date,
  p_data_fim     date
 ) return varchar2 as

v_resultado varchar2(8);

begin
   select trim(to_char(horas,'00')) ||':'|| trim(to_char(minutos,'00')) ||':'||  trim(to_char(segundos,'00'))
     into v_resultado
     from ( SELECT floor((p_data_fim-p_data_inicio)*24) horas,
                   mod(floor((p_data_fim-p_data_inicio)*24*60),60) minutos,
                   mod(floor((p_data_fim-p_data_inicio)*24*60*60),60) segundos
              FROM dual);

  return v_resultado;
exception
     when no_data_found then return '00:00:00';
     when others        then return '00:00:00';
end fnc_duracao_intervalo;
/
