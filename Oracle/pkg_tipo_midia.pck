create or replace package pkg_tipo_midia
is
 
function fnc_get_tipo_midia_id
(
   p_tipo_midia         in midiaclip.tipo_midia.tipo_midia%type 
) return number;

procedure prc_get_tipo_midia
(
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_tipo_midia
(
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type
);

procedure prc_upd_tipo_midia
(
  p_tipo_midia_id       in midiaclip.tipo_midia.tipo_midia_id%type,
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type  
);

procedure prc_del_tipo_midia
(
  p_tipo_midia_id       in midiaclip.tipo_midia.tipo_midia_id%type 
);

------------------------ Fim da package -------------->
end pkg_tipo_midia;
/
create or replace package body pkg_tipo_midia
is

/**************************************
 nome       : fnc_get_tipo_midia
 proposito  : Retorna o tipo_midia_id
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
function fnc_get_tipo_midia_id
(
   p_tipo_midia         in midiaclip.tipo_midia.tipo_midia%type 
) return number
is
  v_tipo_midia       number;
begin
  begin
    select tipo_midia_id
     into v_tipo_midia
     from midiaclip.tipo_midia
      where tipo_midia = trim(upper(p_tipo_midia));
   return (v_tipo_midia);   
  end;
------------ Exception ------------>
 exception 
   when no_data_found then
    raise_application_error(-20000, 'Tipo de Midia : '||p_tipo_midia||' não encontrada');   
end fnc_get_tipo_midia_id;

/**************************************
 nome       : prc_get_tipo_midia
 proposito  : Listagem de Tipo de Midia
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_get_tipo_midia
(
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                 midiaclip.pkg_refcursor.v_sql%type;
begin
   vSql := vSql||
                 ' select tipo_midia_id, tipo_midia 
                    from midiaclip.tipo_midia 
                     where tipo_midia like trim(upper('''||'%'||p_tipo_midia||'%'||'''))
                   order by fnc_remove_acento(tipo_midia)';

---------- Cursor -------------->
 open p_retorno for vSql;                    
end prc_get_tipo_midia;

/**************************************
 nome       : prc_ins_tipo_midia
 proposito  : Cadastro de Tipo de Midia
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_ins_tipo_midia
(
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type
)
is
begin
  begin
    insert into midiaclip.tipo_midia
    (
      tipo_midia_id, tipo_midia
    )
    values 
    (
      seq_tipo_midia.nextval, trim(upper(p_tipo_midia)) 
    );
  end;
----------------- Exception ---------------->
exception 
 when others then
  if substr(sqlerrm,1,9) = 'ORA-00001' then
   raise_application_error(-20000, 'Tipo de Midia : '||p_tipo_midia||' já existe, operação abortada');
  else
   raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
  end if;
end prc_ins_tipo_midia; 

/**************************************
 nome       : prc_upd_tipo_midia
 proposito  : Atualiza Tipo de Midia
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_upd_tipo_midia
(
  p_tipo_midia_id       in midiaclip.tipo_midia.tipo_midia_id%type,
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type  
)
is 
begin
 update midiaclip.tipo_midia
   set tipo_midia     = trim(upper(p_tipo_midia))
 where tipo_midia_id  = p_tipo_midia_id;

----------------------- Exception ----------->
exception
 when others then
  if substr(sqlerrm,1,9) = 'ORA-00001' then
   raise_application_error(-20000, 'Tipo de Midia : '||p_tipo_midia||' já existe, operação abortada');
  else
   raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
  end if;
end prc_upd_tipo_midia;

/**************************************
 nome       : prc_del_tipo_midia
 proposito  : Retorna o apresentador_id da tabela apresentador
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_del_tipo_midia
(
  p_tipo_midia_id       in midiaclip.tipo_midia.tipo_midia_id%type 
)
is
begin
 delete from midiaclip.tipo_midia
  where tipo_midia_id = p_tipo_midia_id;
 --------------- Exception -------------->
exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O Tipo de Midia não pode ser excluida, pois a mesma está sendo usada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if; 
end prc_del_tipo_midia;
--------------------------------- Fim package -------------------->
end pkg_tipo_midia;
/
