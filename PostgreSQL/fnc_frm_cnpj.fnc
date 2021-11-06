create or replace function fnc_frm_cnpj
(
  p_cnpj   in  midiaclip.entidades.cnpj_cpf%type
)return varchar2 
is
 v_cnpj  varchar2(18) := null;
begin
 begin
   ------------ CNPJ ---------------->
   if  length(p_cnpj) = 14 then 
    select substr(p_cnpj,1,2)||'.'||substr(p_cnpj,3,3)||'.'||substr(p_cnpj,6,3)||'/'||substr(p_cnpj,9,4)||'-'||substr(p_cnpj,13,2) as cnpj 
     into v_cnpj
      from dual;
   end if;
   --------------- CPF -------------->
   if  length(p_cnpj) = 11 then
    select substr(p_cnpj,1,3)||'.'||substr(p_cnpj,4,3)||'.'||substr(p_cnpj,7,3)||'-'||substr(p_cnpj,10,2)as cnpj 
     into v_cnpj
      from dual;
   end if;     
 end; 
 --------------- Retorno -------------->
return (v_cnpj);
end fnc_frm_cnpj;
/
