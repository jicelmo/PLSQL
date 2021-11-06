create or replace package pkg_subentidade_programa
is

procedure prc_get_associados
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_disponiveis
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_programa            in  midiaclip.programa.programa%type
);

procedure prc_desassocia
(
  p_sub_entidade       in   midiaclip.sub_entidade.sub_entidade%type
);

end pkg_subentidade_programa;
/
create or replace package body pkg_subentidade_programa
is

/**************************************
 nome       : prc_get_associados
 proposito  : Listagem de Programas Associados
 author     : jicelmo andrade
 criado     : 05/06/2009
***************************************/
procedure prc_get_associados
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                   midiaclip.pkg_refcursor.v_sql%type; 
begin
  vSql := vSql ||
                  ' select p.programa_id, p.programa 
                     from midiaclip.sub_entidade sb 
                       inner join midiaclip.subentidade_programa sp  on  sb.sub_entidade_id = sp.sub_entidade_id 
                       inner join midiaclip.programa             p   on  sp.programa_id     = p.programa_id 
                        where sb.sub_entidade_id = '|| pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade)||
                   '  order by midiaclip.fnc_remove_acento(programa)';
                   
  open p_retorno for vsql;
 --------- Exception ------------>
 exception
  when no_data_found then null; 
end prc_get_associados; 

/**************************************
 nome       : prc_get_disponiveis
 proposito  : Listagem de Programas Disponiveis
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_get_disponiveis
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                  midiaclip.pkg_refcursor.v_sql%type;                                 
begin
  vSql := vSql ||
                  ' select programa_id, programa 
                     from midiaclip.programa 
                       where programa_id not in (
                                                   select p.programa_id 
                                                     from midiaclip.sub_entidade sb 
                                                       inner join midiaclip.subentidade_programa sp  on  sb.sub_entidade_id = sp.sub_entidade_id 
                                                       inner join midiaclip.programa             p   on  sp.programa_id     = p.programa_id 
                                                         where sb.sub_entidade_id = '|| pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade)||
                                               ' )  
                       order by midiaclip.fnc_remove_acento(programa) ';

 open p_retorno for vsql;
----------- Exception ------------>
 exception
  when no_data_found then null; 
end prc_get_disponiveis;

/**************************************
 nome       : prc_associa
 proposito  : Associa Programa a SubEntidade 
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_associa
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_programa            in  midiaclip.programa.programa%type
)
is
begin
 ------------ Associa SubEntidade ao Programa --------->
 begin
   insert into midiaclip.subentidade_programa
   (
     sub_entidade_id, programa_id
   )
   values
   (
     pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade),
     pkg_programa.fnc_get_programa_id(p_programa) 
   );
 end;
 ---------------- Exception -------------->
 exception
  when others then
   raise_application_error(-20000, 'Erro SQL : '||sqlerrm);
end prc_associa;

/**************************************
 nome       : prc_desassocia
 proposito  : Desassocia SubEntidade x Programa
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_desassocia
(
  p_sub_entidade       in   midiaclip.sub_entidade.sub_entidade%type
)
is
begin
 
 begin
   delete from midiaclip.subentidade_programa
    where sub_entidade_id = pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade);
 end;
 
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia; 

------------------------------- Fim da Package ---------------------->
end pkg_subentidade_programa;
/
