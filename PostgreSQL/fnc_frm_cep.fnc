create or replace function midiaclip.fnc_frm_cep
(
  p_cep      in  midiaclip.endereco.cep%type
) return varchar2
is
  v_cep  varchar2(10) := null;
begin

 select substr(p_cep,1,2)||'.'||substr(p_cep,3,3)||'-'||substr(p_cep,6,3) as cep
  into v_cep
 from dual;
return (v_cep);
end fnc_frm_cep;
/
