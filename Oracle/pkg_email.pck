create or replace package pkg_email 
is

 procedure prc_envia_email
 (
   p_smtp           in  varchar2(40),
   p_menssagem      in  varchar2(500),
   p_remetente      in  varchar2(40),
   p_enviar_email   in  varchar2(40), 
 );
 
 function prc_autentica_smtp
 (
   p_conexao
 )return boolean;
end pkg_email;
/
create or replace package body pkg_email 
is
end pkg_email;
/
