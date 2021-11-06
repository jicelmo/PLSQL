create or replace package pkg_apresentador
is

function fnc_get_apresentador_id
(
  p_apresentador        in  midiaclip.apresentador.apresentador%type
) return number;

procedure prc_get_apresentador
(
  p_apresentador        in  midiaclip.apresentador.apresentador%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_apresentador
(
  p_apresentador        in  midiaclip.apresentador.apresentador%type
);

procedure prc_upd_apresentador
(
  p_apresentador_id     in  midiaclip.apresentador.apresentador_id%type,
  p_apresentador        in  midiaclip.apresentador.apresentador%type
);

procedure prc_del_apresentador
(
  p_apresentador_id     in midiaclip.apresentador.apresentador_id%type
);

-------------------- Fim da Package ------------->
end pkg_apresentador;
/
create or replace package body pkg_apresentador
is

/**************************************
 nome       : fnc_get_apresentador_id
 proposito  : Retorna o apresentador_id da tabela apresentador
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
function fnc_get_apresentador_id
(
  p_apresentador        in  midiaclip.apresentador.apresentador%type
) return number
is
 v_apresentador_id       number;
begin
 begin
   select apresentador_id 
    into v_apresentador_id
    from midiaclip.apresentador
     where apresentador = trim(upper(p_apresentador));
   return (v_apresentador_id);  
 end;
 exception 
   when no_data_found then
    raise_application_error(-20000, 'Apresentador : '||p_apresentador||' não encontrado');   
end fnc_get_apresentador_id;

/**************************************
 nome       : prc_get_apresentador
 proposito  : Retorna o apresentador_id da tabela apresentador
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_get_apresentador
(
  p_apresentador        in  midiaclip.apresentador.apresentador%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                 midiaclip.pkg_refcursor.v_sql%type;
begin
    vSql := vSql||
                   ' select apresentador_id, apresentador 
                      from midiaclip.apresentador 
                       where apresentador like trim(upper('''||'%'||p_apresentador||'%'||'''))
                     order by fnc_remove_acento(apresentador)';
 --------- Cursor -------->
 open p_retorno for vsql;                       
end prc_get_apresentador; 

/**************************************
 nome       : prc_ins_apresentador
 proposito  : Cadastra Apresentador
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_ins_apresentador
(
  p_apresentador        in midiaclip.apresentador.apresentador%type
)
is
begin
  ----------- Cadastra Apresentador ------>
    insert into midiaclip.apresentador
    (
      apresentador_id, apresentador
    )
    values
    (
      seq_apresentador.nextval, trim(upper(p_apresentador))
    );
 ----------- Exception --------->
 exception 
    when others then
     if substr(sqlerrm,1,9) = 'ORA-00001' then
      raise_application_error(-20000, 'Apresentador : '||p_apresentador||' já existe, operação abortada');
     else
      raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
     end if;
end prc_ins_apresentador;

/**************************************
 nome       : prc_upd_apresentador
 proposito  : Atualiza Apresentador 
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_upd_apresentador
(
  p_apresentador_id     in  midiaclip.apresentador.apresentador_id%type,
  p_apresentador        in  midiaclip.apresentador.apresentador%type
)
is
begin
 begin 
  update midiaclip.apresentador
    set apresentador    = trim(upper(p_apresentador))
  where apresentador_id = p_apresentador_id;
 end;
exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Apresentador : '||p_apresentador||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_apresentador; 

/**************************************
 nome       : prc_del_apresentador
 proposito  : Excluir Apresentador
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_del_apresentador
(
  p_apresentador_id     in midiaclip.apresentador.apresentador_id%type
)
is 
begin
  delete from midiaclip.apresentador
   where apresentador_id = p_apresentador_id;
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O apresentador não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if; 
end prc_del_apresentador; 

end pkg_apresentador;
/
