create or replace function fnc_custo_pub
(
  p_duracao    in  varchar2,
  p_custopub   in  number
)
return number
is
 vCusto     number(10,2) := 0;
 vSegundos  number       := 0;
begin
  begin
   vSegundos := fnc_converte_hora_segundos(p_duracao);
   vCusto := ( p_custopub * vSegundos);
  end;
 return (vCusto);
end fnc_custo_pub;
/
