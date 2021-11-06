create or replace function fnc_custo_pub_jornal
(
  p_area       in  number,
  p_custopub   in  number
)
return number
is
 vCusto     number(10,2) := 0;
begin
  begin
   vCusto := ( p_custopub * p_area);
  end;
 return (vCusto);
end fnc_custo_pub_jornal;
/
