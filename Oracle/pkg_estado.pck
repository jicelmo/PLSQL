create or replace package midiaclip.pkg_estado 
is
 
function fnc_get_estado_id
(
  p_uf      in  midiaclip.estado.uf%type
) return number;

procedure prc_get_estado
(
  p_query    out midiaclip.pkg_refcursor.c_cursor
);

end pkg_estado;
/
create or replace package body midiaclip.pkg_estado 
is
 
/**************************************
 nome       : fnc_get_estado_id
 proposito  : Retorna o estado_id ta tabela de municipio
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
function fnc_get_estado_id
(
  p_uf      in  midiaclip.estado.uf%type
) return number
is
 v_estado_id   number;
begin

  begin
    select estado_id
     into v_estado_id
      from midiaclip.estado
       where uf = upper(p_uf);
    return(v_estado_id);   
  end;
  
exception 
  when no_data_found then
    raise_application_error(-20000, 'UF : '||p_uf||' não encontrado');   
end fnc_get_estado_id;

/**************************************
 nome       : fnc_get_estado
 proposito  : Retorna Lista de Estados
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/

procedure prc_get_estado
(
  p_query    out midiaclip.pkg_refcursor.c_cursor
)
is
  vsql       midiaclip.pkg_refcursor.v_sql%type;
begin
  
   vsql := vsql ||
                   ' select estado_id, estado, uf
                      from midiaclip.estado order by uf ';

 open p_query for vsql;                    
end prc_get_estado;
                    
end pkg_estado;
/
