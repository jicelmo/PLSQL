create or replace package pkg_municipio
is

function fnc_get_municipio_id
(
  p_municipio  in  midiaclip.municipio.municipio%type
)return number;

procedure prc_get_municipio
(
  p_municipio   in   midiaclip.municipio.municipio%type,
  p_estado      in   midiaclip.estado.uf%type,
  p_query       out  midiaclip.pkg_refcursor.c_cursor
);

end pkg_municipio;
/
create or replace package body pkg_municipio
is

/**************************************
 nome       : fnc_get_municipio_id
 proposito  : Retorna o municipio_id ta tabela de municipio
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
function fnc_get_municipio_id
(
  p_municipio  in  midiaclip.municipio.municipio%type
)return number
is
 v_municipio_id   number;
begin
 begin
  select municipio_id
   into v_municipio_id
   from midiaclip.municipio
    where municipio = p_municipio;
  return (v_municipio_id);
 end; 
 exception
  when no_data_found then
    raise_application_error(-20000, 'Municipio : '||p_municipio||' não encontrado');
end fnc_get_municipio_id;


/**************************************
 nome       : fnc_get_municipio_id
 proposito  : Retorna lista de municipios
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_get_municipio
(
  p_municipio   in   midiaclip.municipio.municipio%type,
  p_estado      in   midiaclip.estado.uf%type,
  p_query       out  midiaclip.pkg_refcursor.c_cursor
)
is
 vsql            midiaclip.pkg_refcursor.v_sql%type;
begin
  vsql  := vsql||
                  ' select m.municipio_id, m.municipio, e.uf
                      from midiaclip.estado e
                       inner join  midiaclip.municipio m  on  e.estado_id = m.estado_id
                        where m.municipio like upper('''||'%'||''||p_municipio||''||'%'')'; 
                  
   if p_estado is not null then
     vsql := vsql || ' and e.uf = upper('''||p_estado||''')';
   end if;
   
   ------ Ordenação ---------->
   vsql := vsql || ' order by fnc_remove_acento(m.municipio) ';
   
   open p_query for vsql;                
end;

end pkg_municipio;
/
