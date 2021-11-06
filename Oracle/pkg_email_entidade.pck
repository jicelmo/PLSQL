create or replace package pkg_email_entidade
is

procedure prc_ins_email
(
  p_entidade_id    in  midiaclip.emial_entidade.entidade_id%type,
  p_contato        in  midiaclip.emial_entidade.contato_email%type,
  p_email          in  midiaclip.emial_entidade.email%type,
  p_status         in  midiaclip.emial_entidade.status%type
);

procedure prc_upd_email
(
  p_email_entidade_id    in  midiaclip.emial_entidade.email_entidade_id%type,
  p_entidade_id          in  midiaclip.emial_entidade.entidade_id%type,
  p_contato              in  midiaclip.emial_entidade.contato_email%type,
  p_email                in  midiaclip.emial_entidade.email%type,
  p_status               in  midiaclip.emial_entidade.status%type
);

procedure prc_get_email_entidade
(
  p_entidade_id    in   midiaclip.emial_entidade.entidade_id%type,
  p_query          out  midiaclip.pkg_refcursor.c_cursor
);

procedure prc_del_email_entidade
(
  p_email_entidade_id in midiaclip.emial_entidade.email_entidade_id%type
);

end pkg_email_entidade;
/
create or replace package body pkg_email_entidade
is

/**************************************
 nome       : Prc_Ins_Email
 proposito  : cadastra Emails da Entidade
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_ins_email
(
  p_entidade_id    in  midiaclip.emial_entidade.entidade_id%type,
  p_contato        in  midiaclip.emial_entidade.contato_email%type,
  p_email          in  midiaclip.emial_entidade.email%type,
  p_status         in  midiaclip.emial_entidade.status%type
)
is
begin

  begin
    insert into midiaclip.emial_entidade
    (
      email_entidade_id, entidade_id, email, contato_email, status
    )
    values
    (
      seq_email_entidade.nextval,
      p_entidade_id,
      trim(lower(p_email)),
      trim(p_contato),
      p_status
    );
  end;
----------------- Exception ---------------->
exception
 when others then
  if substr(sqlerrm,1,9) = 'ORA-00001' then
   raise_application_error(-20000, 'Email : '||p_email||' já existe, operação abortada');
  else
   raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
  end if;

end prc_ins_email;

/**************************************
 nome       : Prc_upd_email
 proposito  : Atualizar Emails
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_upd_email
(
  p_email_entidade_id    in  midiaclip.emial_entidade.email_entidade_id%type,
  p_entidade_id          in  midiaclip.emial_entidade.entidade_id%type,
  p_contato              in  midiaclip.emial_entidade.contato_email%type,
  p_email                in  midiaclip.emial_entidade.email%type,
  p_status               in  midiaclip.emial_entidade.status%type
)
is
begin
 update midiaclip.emial_entidade
               set entidade_id    =  p_entidade_id,
                   email          =  trim(lower(p_email)),
                   contato_email  =  trim(p_contato),
                   status         =  p_status
          where email_entidade_id =  p_email_entidade_id;
----------------------- Exception ----------->
exception
 when others then
  if substr(sqlerrm,1,9) = 'ORA-00001' then
   raise_application_error(-20000, 'Email : '||p_email||' já existe, operação abortada');
  else
   raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
  end if;
end prc_upd_email;

/**************************************
 nome       : prc_get_email_entidade
 proposito  : Lista de Emails
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_get_email_entidade
(
  p_entidade_id    in   midiaclip.emial_entidade.entidade_id%type,
  p_query          out  midiaclip.pkg_refcursor.c_cursor
)
is
 vSql   midiaclip.pkg_refcursor.v_sql%type;
begin

  vSql := vSql ||
                  ' select email_entidade_id, entidade_id, email, contato_email, 
                       case
                         when status = 0 then ''BLOQUEADO''
                         when status = 1 then ''ATIVO''
                       end as status        
                      from  midiaclip.emial_entidade
                       where entidade_id = '||p_entidade_id||' order by fnc_remove_acento(email)';
  open p_query for vsql;
end prc_get_email_entidade;

/**************************************
 nome       : prc_del_email_entidade
 proposito  : Apaga Email Entidade
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_del_email_entidade
(
  p_email_entidade_id in midiaclip.emial_entidade.email_entidade_id%type
)
is
begin

 delete from midiaclip.emial_entidade
  where email_entidade_id = p_email_entidade_id;

 exception
   when others then
    if substr(sqlerrm,1,9) = 'ORA-02292' then
     raise_application_error(-20000, 'O email não pode ser excluido, pois o mesmo está sendo usado');
    else
     raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
    end if;
end prc_del_email_entidade;

--------------------------- Fim Package ---------------->
end pkg_email_entidade;
/
