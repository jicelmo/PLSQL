create or replace package pkg_setor_programa
is

procedure prc_get_associados
(
  p_setor               in  midiaclip.setor.setor%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_disponiveis
(
  p_setor               in  midiaclip.setor.setor%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa
(
  p_setor               in  midiaclip.setor.setor%type,
  p_programa            in  midiaclip.programa.programa%type
);

procedure prc_desassocia
(
  p_setor               in  midiaclip.setor.setor%type
);

end pkg_setor_programa;
/
create or replace package body pkg_setor_programa
is

/**************************************
 nome       : prc_get_associados
 proposito  : Listagem de Programas Associados
 author     : jicelmo andrade
 criado     : 05/06/2009
***************************************/
procedure prc_get_associados
(
  p_setor               in  midiaclip.setor.setor%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                   midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql := vSql ||
                  ' select p.programa_id, p.programa
                     from midiaclip.setor s
                       inner join midiaclip.setor_programa  sp  on  s.setor_id       = sp.setor_id
                       inner join midiaclip.programa        p   on  sp.programa_id   = p.programa_id
                        where sp.setor_id = '|| pkg_setor.fnc_get_setor_id(p_setor)||
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
  p_setor               in  midiaclip.setor.setor%type,
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
                                                     from midiaclip.setor s
                                                       inner join midiaclip.setor_programa sp  on  s.setor_id = sp.setor_id
                                                        and sp.setor_id ='||pkg_setor.fnc_get_setor_id(p_setor)||
                                               ' )
                       order by midiaclip.fnc_remove_acento(programa) ';

 open p_retorno for vsql;
----------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_disponiveis;

/**************************************
 nome       : prc_associa
 proposito  : Associa Programa a Setor
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_associa
(
  p_setor               in  midiaclip.setor.setor%type,
  p_programa            in  midiaclip.programa.programa%type
)
is
begin
 ------------ Associa SubEntidade ao Programa --------->
 begin
   insert into midiaclip.setor_programa
   (
     setor_id, programa_id
   )
   values
   (
     pkg_setor.fnc_get_setor_id(p_setor),
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
  p_setor               in  midiaclip.setor.setor%type
)
is
begin

 begin
   delete from midiaclip.setor_programa
    where setor_id = pkg_setor.fnc_get_setor_id(p_setor);
 end;

 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia;

------------------------------- Fim da Package ---------------------->
end pkg_setor_programa;
/
