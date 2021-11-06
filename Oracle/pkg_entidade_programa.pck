create or replace package pkg_entidade_programa
is

procedure prc_get_associados
(
  p_entidade            in  midiaclip.entidades.entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_disponiveis
(
  p_entidade            in  midiaclip.entidades.entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa
(
  p_entidade            in  midiaclip.entidades.entidade%type,
  p_programa            in  midiaclip.programa.programa%type
);

procedure prc_desassocia
(
  p_entidade            in  midiaclip.entidades.entidade%type
);

end pkg_entidade_programa;
/
create or replace package body pkg_entidade_programa
is

/**************************************
 nome       : prc_get_associados
 proposito  : Listagem de Programas Associados
 author     : jicelmo andrade
 criado     : 05/06/2009
***************************************/
procedure prc_get_associados
(
  p_entidade            in  midiaclip.entidades.entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                   midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql := vSql ||
                  ' select p.programa_id, p.programa
                     from midiaclip.entidades e
                       inner join midiaclip.entidade_programa    ep  on  e.entidade_id      = ep.entidade_id
                       inner join midiaclip.programa             p   on  ep.programa_id     = p.programa_id
                        where ep.entidade_id = '|| pkg_entidade.fnc_get_entidade_id(p_entidade)||
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
  p_entidade            in  midiaclip.entidades.entidade%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                  midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql := vSql ||
                  ' select programa_id, programa
                     from midiaclip.programa
                       where programa_id not in (
                                                   select programa_id
                                                     from midiaclip.entidades e
                                                       inner join midiaclip.entidade_programa ep  on  e.entidade_id = ep.entidade_id
                                                        and ep.entidade_id ='||pkg_entidade.fnc_get_entidade_id(p_entidade)||
                                               ' )
                       order by midiaclip.fnc_remove_acento(programa) ';

 open p_retorno for vsql;
----------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_disponiveis;

/**************************************
 nome       : prc_associa
 proposito  : Associa Programa a Entidade
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_associa
(
  p_entidade            in  midiaclip.entidades.entidade%type,
  p_programa            in  midiaclip.programa.programa%type
)
is
begin
 ------------ Associa SubEntidade ao Programa --------->
 begin
   insert into midiaclip.entidade_programa
   (
     entidade_id, programa_id
   )
   values
   (
     pkg_entidade.fnc_get_entidade_id(p_entidade),
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
  p_entidade            in  midiaclip.entidades.entidade%type
)
is
begin

 begin
   delete from midiaclip.entidade_programa
    where entidade_id = pkg_entidade.fnc_get_entidade_id(p_entidade);
 end;

 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia;

------------------------------- Fim da Package ---------------------->
end pkg_entidade_programa;
/
