create or replace package pkg_email_sub_entidade
is

procedure prc_ins_email
(
  p_sub_entidade_id    in  midiaclip.email_sub_entidade.sub_entidade_id%type,
  p_contato            in  midiaclip.email_sub_entidade.contato_email%type,
  p_email              in  midiaclip.email_sub_entidade.email%type,
  p_status             in  midiaclip.email_sub_entidade.status%type
);

procedure prc_upd_email
(
  p_email_sub_entidade_id    in  midiaclip.email_sub_entidade.email_sub_entidade_id%type,
  p_sub_entidade_id          in  midiaclip.email_sub_entidade.sub_entidade_id%type,
  p_contato                  in  midiaclip.email_sub_entidade.contato_email%type,
  p_email                    in  midiaclip.email_sub_entidade.email%type,
  p_status                   in  midiaclip.email_sub_entidade.status%type
);

procedure prc_get_email_sub_entidade
(
  p_sub_entidade_id    in   midiaclip.email_sub_entidade.sub_entidade_id%type,
  p_query              out  midiaclip.pkg_refcursor.c_cursor
);

procedure prc_del_email_sub_entidade
(
  p_email_sub_entidade_id in midiaclip.email_sub_entidade.email_sub_entidade_id%type
);

end pkg_email_sub_entidade;
/
create or replace package body pkg_email_sub_entidade
is

/**************************************
 nome       : Prc_Ins_Email
 proposito  : cadastra Emails da Sub_Entidade
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_ins_email
(
  p_sub_entidade_id    in  midiaclip.email_sub_entidade.sub_entidade_id%type,
  p_contato            in  midiaclip.email_sub_entidade.contato_email%type,
  p_email              in  midiaclip.email_sub_entidade.email%type,
  p_status             in  midiaclip.email_sub_entidade.status%type
)
is
begin

  begin
    insert into midiaclip.email_sub_entidade
    (
      email_sub_entidade_id, sub_entidade_id, email, contato_email, status
    )
    values
    (
      seq_email_sub_entidade.nextval,
      p_sub_entidade_id,
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
  p_email_sub_entidade_id    in  midiaclip.email_sub_entidade.email_sub_entidade_id%type,
  p_sub_entidade_id          in  midiaclip.email_sub_entidade.sub_entidade_id%type,
  p_contato                  in  midiaclip.email_sub_entidade.contato_email%type,
  p_email                    in  midiaclip.email_sub_entidade.email%type,
  p_status                   in  midiaclip.email_sub_entidade.status%type
)
is
begin
 update midiaclip.email_sub_entidade
               set sub_entidade_id    =  p_sub_entidade_id,
                   email              =  trim(lower(p_email)),
                   contato_email      =  trim(p_contato),
                   status             =  p_status
          where email_sub_entidade_id =  p_email_sub_entidade_id;
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
 nome       : prc_get_email_sub_entidade
 proposito  : Lista de Emails
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_get_email_sub_entidade
(
  p_sub_entidade_id    in   midiaclip.email_sub_entidade.sub_entidade_id%type,
  p_query              out  midiaclip.pkg_refcursor.c_cursor
)
is
 vSql   midiaclip.pkg_refcursor.v_sql%type;
begin

  vSql := vSql ||
                  ' select email_sub_entidade_id, sub_entidade_id, email, contato_email, 
                       case 
                         when status = 0 then ''BLOQUEADO''
                         when status = 1 then ''ATIVO''
                       end as status       
                      from  midiaclip.email_sub_entidade
                       where  sub_entidade_id = '||p_sub_entidade_id||' order by fnc_remove_acento(email)';
  open p_query for vsql;
end prc_get_email_sub_entidade;

/**************************************
 nome       : prc_del_email_sub_entidade
 proposito  : Apaga Email da sub_entidade
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
procedure prc_del_email_sub_entidade
(
  p_email_sub_entidade_id in midiaclip.email_sub_entidade.email_sub_entidade_id%type
)
is
begin

 delete from midiaclip.email_sub_entidade
  where email_sub_entidade_id = p_email_sub_entidade_id;

 exception
   when others then
    if substr(sqlerrm,1,9) = 'ORA-02292' then
     raise_application_error(-20000, 'O email não pode ser excluido, pois o mesmo está sendo usado');
    else
     raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
    end if;
end prc_del_email_sub_entidade;


---------------------------- Fim Package ---------------->
end pkg_email_sub_entidade;
/
