create or replace package pkg_categoria 
is

function fnc_get_categoria_id
(
  p_categoria           in midiaclip.categoria.categoria%type
)return number;

procedure prc_get_categoria
(
  p_categoria           in  midiaclip.categoria.categoria%type,
  p_retorno             out pkg_refcursor.c_cursor
);

procedure prc_ins_categoria
(
  p_categoria           in  midiaclip.categoria.categoria%type
);

procedure prc_upd_categoria
(
  p_categoria_id        in  midiaclip.categoria.categoria_id%type,
  p_categoria           in  midiaclip.categoria.categoria%type
);

procedure prc_del_categoria
(
  p_categoria_id       in  midiaclip.categoria.categoria_id%type
);
-------------------------- Fim package ------------>   
end pkg_categoria;
/
create or replace package body pkg_categoria 
is

/**************************************
 nome       : fnc_get_categoria_id
 proposito  : Retorna Categoria_id
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
function fnc_get_categoria_id
(
  p_categoria           in midiaclip.categoria.categoria%type
)return number
is
 v_categoria_id         number; 
begin
  begin
    select categoria_id
     into v_categoria_id
     from midiaclip.categoria
      where categoria = trim(upper(p_categoria));
   return (v_categoria_id);   
  end;
----------- Exception ------------>
 exception
  when no_data_found then
   raise_application_error (-20000, 'Categoria :'||p_categoria||' não cadastrado');
end fnc_get_categoria_id;

/**************************************
 nome       : prc_get_categoria
 proposito  : Retorna Lista de categoria
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_get_categoria
(
  p_categoria           in  midiaclip.categoria.categoria%type,
  p_retorno             out pkg_refcursor.c_cursor
)
is
  vSql                 pkg_refcursor.v_sql%type;
begin
 begin
  vSql := vSql ||
                 ' select categoria_id, categoria 
                    from midiaclip.categoria 
                     where categoria like trim(upper('''||'%'||p_categoria||'%'||'''))
                 order by fnc_remove_acento(categoria)'; 
  end;
---------- Cursor ----------->
 open p_retorno for vSql;                    
end prc_get_categoria;

/**************************************
 nome       : prc_ins_categoria
 proposito  : Cadastra Categoria
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_ins_categoria
(
  p_categoria           in  midiaclip.categoria.categoria%type
)
is 
begin
  begin
    insert into midiaclip.categoria
    (
      categoria_id, categoria
    )
    values
    (
      seq_categoria.nextval, trim(upper(p_categoria))
    );
  end;
------------- Exception ------------>  
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Categoria : '||p_categoria||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;  
end prc_ins_categoria;

/**************************************
 nome       : fnc_get_categoria_id
 proposito  : Retorna Categoria_id
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_upd_categoria
(
  p_categoria_id        in  midiaclip.categoria.categoria_id%type,
  p_categoria           in  midiaclip.categoria.categoria%type
)
is
begin
  update midiaclip.categoria
                   set categoria    =  trim(upper(p_categoria))
                 where categoria_id =  p_categoria_id;

-------- Exception ------------>
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Categoria : '||p_categoria||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;                
end prc_upd_categoria;

/**************************************
 nome       : fnc_get_categoria_id
 proposito  : Retorna Categoria_id
 author     : jicelmo andrade
 criado     : 02/01/2009
***************************************/
procedure prc_del_categoria
(
  p_categoria_id        in  midiaclip.categoria.categoria_id%type
)
is
begin
 delete from midiaclip.categoria
  where categoria_id = p_categoria_id;

----- Exception ----------->
 exception 
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O Categoria não pode ser excluida, pois a mesma está sendo usada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if; 
end prc_del_categoria;   
-------------------- Fim Pacote ------------>
end pkg_categoria;
/
