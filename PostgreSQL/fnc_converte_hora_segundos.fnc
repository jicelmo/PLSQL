create or replace function fnc_converte_hora_segundos
(
  p_duracao   in  varchar2
)
return number
is
 Horas     integer := 0;
 Minutos   integer := 0;
 Segundos  integer := 0;
 Total     integer := 0;
begin
  begin
    select to_number(extract(hour    from cast(p_duracao as time)))as hora,
           to_number(extract(minute  from cast(p_duracao as time)))as minuto,
           to_number(extract(second  from cast(p_duracao as time)))as segundo
      into Horas, Minutos, Segundos
     from dual;
  end;
 total := (Horas * 3600)+(Minutos * 60 )+Segundos;
 return (total);
end fnc_converte_hora_segundos;
/
