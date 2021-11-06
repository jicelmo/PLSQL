create or replace package pkg_impacto
is

function fnc_get_impacto_id
(
  p_impacto       in midiaclip.impacto.impacto%type
) return number;

procedure prc_get_impacto
(
  p_impacto      in  midiaclip.impacto.impacto%type,
  p_retorno      out pkg_refcursor.c_cursor
);

procedure prc_ins_impacto
(
  p_impacto      in midiaclip.impacto.impacto%type
);

procedure prc_upd_impacto
(
  p_impacto_id   in midiaclip.impacto.impacto_id%type,
  p_impacto      in midiaclip.impacto.impacto%type
);

procedure prc_del_impacto
(
  p_impacto_id   in midiaclip.impacto.impacto_id%type
);

end pkg_impacto;
/
create or replace package body pkg_impacto
is

/**************************************
 nome       : fnc_get_impacto_id
 proposito  : Retorna Impacto_id
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/

function fnc_get_impacto_id
(
  p_impacto       in midiaclip.impacto.impacto%type
) return number
is
  v_impacto_id    number;
begin
  begin
    select impacto_id
     into v_impacto_id
     from midiaclip.impacto
      where impacto = trim(upper(p_impacto));
    return (v_impacto_id);
  end;
 ----------- Exception --------->
 exception
  when no_data_found then
   raise_application_error (-20000, 'Impacto :'||p_impacto||' não cadastrado');
end fnc_get_impacto_id;

/**************************************
 nome       : prc_get_impacto
 proposito  : Retorna Lista Impacto
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_get_impacto
(
  p_impacto      in  midiaclip.impacto.impacto%type,
  p_retorno      out pkg_refcursor.c_cursor
)
is
  vSql           pkg_refcursor.v_sql%type;
begin
 begin
  vSql := vSql||
                 ' select impacto_id, impacto
                    from midiaclip.impacto
                     where impacto like trim(upper('''||'%'||p_impacto||'%'||'''))
                 order by fnc_remove_acento(impacto)';
  end;
 ------- Cursor ---------->
 open p_retorno for vSql;
end prc_get_impacto;

/**************************************
 nome       : prc_ins_impacto
 proposito  : Cadastra Impacto
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_ins_impacto
(
  p_impacto      in midiaclip.impacto.impacto%type
)
is
begin
  begin
    insert into midiaclip.impacto
    (
      impacto_id, impacto
    )
    values
    (
      seq_impacto.nextval, trim(upper(p_impacto))
    );
  end;
--------- Exception --------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Impacto : '||p_impacto||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_impacto;

/**************************************
 nome       : prc_upd_impacto
 proposito  : Atualiza Impacto
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_upd_impacto
(
  p_impacto_id   in midiaclip.impacto.impacto_id%type,
  p_impacto      in midiaclip.impacto.impacto%type
)
is
begin
   update midiaclip.impacto
                      set impacto    = trim(upper(p_impacto))
                   where  impacto_id = p_impacto_id;

 ----------- Exception -------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Programa : '||p_impacto||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_impacto;

/**************************************
 nome       : prc_del_impacto
 proposito  : Excluir Impacto
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_del_impacto
(
  p_impacto_id   in midiaclip.impacto.impacto_id%type
)
is
begin
  delete from midiaclip.impacto
   where impacto_id = p_impacto_id;
 ----------- Exception -------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O Impacto não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_impacto;
------------------------ Fim Package ---------------->
end pkg_impacto;
/
