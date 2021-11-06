create or replace package pkg_sub_entidade is

function fnc_get_subentidade_id
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type
) return number;

procedure prc_get_subentidade
(
  p_sub_entidade         in  midiaclip.sub_entidade.sub_entidade%type,
  p_retorno              out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_subentidade
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_status              in  midiaclip.sub_entidade.status%type,
  p_template            in  midiaclip.sub_entidade.template_html%type
);

procedure prc_upd_subentidade
(
  p_sub_entidade_id      in  midiaclip.sub_entidade.sub_entidade_id%type,
  p_sub_entidade         in  midiaclip.sub_entidade.sub_entidade%type,
  p_status               in  midiaclip.sub_entidade.status%type,
  p_template             in  midiaclip.sub_entidade.template_html%type
);

procedure prc_del_subentidade
(
  p_sub_entidade_id     in midiaclip.sub_entidade.sub_entidade_id%type
);

-------------------- Fim da Package ------------->

end pkg_sub_entidade;
/
create or replace package body pkg_sub_entidade
is

/**************************************
 nome       : fnc_get_SubEntidade_id
 proposito  : Retorna o SubEntidade_id da tabela SubEntidade
 author     : jicelmo andrade
 criado     : 12/05/2009
***************************************/
function fnc_get_subentidade_id
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type
) return number
is
 v_subentidade_id       number;
begin
 begin
   select sub_entidade_id
    into v_subentidade_id
    from midiaclip.sub_entidade
     where sub_entidade = trim(upper(p_sub_entidade));
   return (v_subentidade_id);
 end;
 exception
   when no_data_found then
    raise_application_error(-20000, 'Sub Entidade : '||p_sub_entidade||' não encontrada');
end fnc_get_subentidade_id;

/**************************************
 nome       : prc_get_subentidade
 proposito  : Retorna o Lista de SubEntidades
 author     : jicelmo andrade
 criado     : 12/05/2009
***************************************/
procedure prc_get_subentidade
(
  p_sub_entidade         in  midiaclip.sub_entidade.sub_entidade%type,
  p_retorno              out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                 midiaclip.pkg_refcursor.v_sql%type;
begin
    vSql := vSql||
                   ' select sub_entidade_id, sub_entidade,
                      case
                       when status = 0 then '''||'BLOQUEADO'''||'
                       when status = 1 then '''||'ATIVO'''||'
                      end as status, template_html
                     from midiaclip.sub_entidade
                       where sub_entidade like trim(upper('''||'%'||p_sub_entidade||'%'||'''))
                     order by fnc_remove_acento(sub_entidade)';
 --------- Cursor -------->
 open p_retorno for vsql;
end prc_get_subentidade;

/**************************************
 nome       : prc_ins_sub_entidade
 proposito  : Cadastra Sub Entidade
 author     : jicelmo andrade
 criado     : 12/05/2009
***************************************/
procedure prc_ins_subentidade
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_status              in  midiaclip.sub_entidade.status%type,
  p_template            in  midiaclip.sub_entidade.template_html%type
)
is
begin
  ----------- Cadastra SubEntidade ------>
    insert into midiaclip.sub_entidade
    (
      sub_entidade_id,  sub_entidade, status, template_html
    )
    values
    (
       seq_sub_entidade.nextval, trim(upper(p_sub_entidade)), p_status, trim(p_template)
    );
 ----------- Exception --------->
 exception
    when others then
     if substr(sqlerrm,1,9) = 'ORA-00001' then
      raise_application_error(-20000, 'SubEntidade : '||p_sub_entidade||' já existe, operação abortada');
     else
      raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
     end if;
end prc_ins_subentidade;

/**************************************
 nome       : prc_upd_SubEntidade
 proposito  : Atualiza Apresentador
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_upd_subentidade
(
  p_sub_entidade_id     in  midiaclip.sub_entidade.sub_entidade_id%type,
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_status              in  midiaclip.sub_entidade.status%type,
  p_template            in  midiaclip.sub_entidade.template_html%type
)
is
begin
 begin
  update midiaclip.sub_entidade
    set sub_entidade    = trim(upper(p_sub_entidade)),
        status          = p_status,
        template_html   = trim(p_template)
  where sub_entidade_id = p_sub_entidade_id;
 end;
exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Sub Entidade : '||p_sub_entidade||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_subentidade;

/**************************************
 nome       : prc_del_subentidade
 proposito  : Excluir SubEntidade
 author     : jicelmo andrade
 criado     : 12/05/2009
***************************************/
procedure prc_del_subentidade
(
  p_sub_entidade_id     in midiaclip.sub_entidade.sub_entidade_id%type
)
is
begin
  delete from midiaclip.sub_entidade
   where sub_entidade_id = p_sub_entidade_id;
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'A Sub Entidade não pode ser excluida, pois a mesma está sendo usada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_subentidade;
---------------------------------------------------- Fim da Package ------------------------------>
end pkg_sub_entidade;
/
