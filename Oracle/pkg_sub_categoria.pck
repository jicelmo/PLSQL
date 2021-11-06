create or replace package pkg_sub_categoria
is
 
function fnc_get_sub_categoria_id
(
  p_sub_categoria           in midiaclip.sub_categoria.sub_categoria%type  
) return number;

procedure prc_get_sub_categoria
(
  p_sub_categoria           in  midiaclip.sub_categoria.sub_categoria%type,
  p_categoria               in  midiaclip.categoria.categoria%type,
  p_retorno                 out pkg_refcursor.c_cursor
);

procedure prc_ins_sub_categoria
(
  p_categoria              in  midiaclip.categoria.categoria%type,
  p_sub_categoria          in  midiaclip.sub_categoria.sub_categoria%type 
);

procedure prc_upd_sub_categoria
(
  p_sub_categoria_id       in midiaclip.sub_categoria.sub_categoria_id%type,
  p_sub_categoria          in midiaclip.sub_categoria.sub_categoria%type,
  p_categoria              in midiaclip.categoria.categoria%type
);

procedure prc_del_sub_categoria
(
  p_sub_categoria_id       in midiaclip.sub_categoria.sub_categoria_id%type
);
---------------------- Fim Package ----------------->
end pkg_sub_categoria;
/
create or replace package body pkg_sub_categoria
is

/**************************************
 nome       : fnc_get_sub_categoria_id
 proposito  : Retorna Sub_Categoria_id
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
function fnc_get_sub_categoria_id
(
  p_sub_categoria           in midiaclip.sub_categoria.sub_categoria%type  
) return number
is
 v_sub_categoria_id         number;
begin
  begin
    select sub_categoria_id
     into v_sub_categoria_id
     from midiaclip.sub_categoria
      where sub_categoria = trim(upper(p_sub_categoria));
   return (v_sub_categoria_id);   
  end;
-------- Exception -------------->
 exception
  when no_data_found then
   raise_application_error (-20000, 'Sub Categoria :'||p_sub_categoria||' não cadastrada');
end fnc_get_sub_categoria_id;

/**************************************
 nome       : prc_get_sub_categoria
 proposito  : Retorna Lista de Sub Categoria
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_get_sub_categoria
(
  p_sub_categoria           in  midiaclip.sub_categoria.sub_categoria%type,
  p_categoria               in  midiaclip.categoria.categoria%type,
  p_retorno                 out pkg_refcursor.c_cursor
)
is
 vSql                       pkg_refcursor.v_sql%type; 
begin
    vSql := vSql ||
                    ' select sub_categoria_id, sub_categoria 
                       from midiaclip.sub_categoria 
                        where sub_categoria like trim(upper('''||'%'||p_sub_categoria||'%'||'''))';
   
  if p_sub_categoria is not null then
    vSql := vSql || ' and categoria_id = '||pkg_categoria.fnc_get_categoria_id(p_categoria);
  end if; 
  
----------- Cursor --------------->
 open p_retorno for vSql;                      
end prc_get_sub_categoria;

/**************************************
 nome       : prc_ins_sub_categoria
 proposito  : Cadastra Sub_Categoria
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_ins_sub_categoria
(
  p_categoria              in  midiaclip.categoria.categoria%type,
  p_sub_categoria          in  midiaclip.sub_categoria.sub_categoria%type 
)
is
begin
  begin
    insert into midiaclip.sub_categoria
    (
      sub_categoria_id, sub_categoria, categoria_id
    )
    values
    (
      seq_sub_categoria.nextval, trim(upper(p_sub_categoria)), pkg_categoria.fnc_get_categoria_id(p_categoria)
    );    
  end;
------------- Exception ------------>
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Sub Categoria : '||p_sub_categoria||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_sub_categoria;

/**************************************
 nome       : prc_upd_sub_categoria
 proposito  : Atualiza Sub Categoria
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_upd_sub_categoria
(
  p_sub_categoria_id       in midiaclip.sub_categoria.sub_categoria_id%type,
  p_sub_categoria          in midiaclip.sub_categoria.sub_categoria%type,
  p_categoria              in midiaclip.categoria.categoria%type
)
is
begin
 update midiaclip.sub_categoria
                    set sub_categoria    = trim((p_categoria)),
                        categoria_id     = pkg_categoria.fnc_get_categoria_id(p_categoria)
                  where sub_categoria_id = p_sub_categoria_id;         
--------------- Exception ---------->
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Sub Categoria : '||p_sub_categoria||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if; 
end prc_upd_sub_categoria;

/**************************************
 nome       : prc_del_sub_categoria
 proposito  : Deleta Sub Categoria
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_del_sub_categoria
(
  p_sub_categoria_id       in midiaclip.sub_categoria.sub_categoria_id%type
)
is
begin
  delete from midiaclip.sub_categoria
   where sub_categoria_id = p_sub_categoria_id;
 ----------- Exception -------->
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'A Sub Categoria não pode ser excluida, pois a mesma está sendo usada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if; 
end;
---------------------------- Fim Package ---------------->
end pkg_sub_categoria;
/
