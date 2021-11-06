create or replace package pkg_subentidade_setor
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
  p_setor               in  midiaclip.setor.setor%type
);

procedure prc_desassocia
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type
);

end pkg_subentidade_setor;
/
create or replace package body pkg_subentidade_setor
is
/**************************************
 nome       : prc_get_associados
 proposito  : Listagem de Setor Associadas
 author     : jicelmo andrade
 criado     : 15/06/2009
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
                  ' select s.setor_id, s.setor
                     from midiaclip.sub_entidade sb
                       inner join midiaclip.sub_entidade_setor   ss  on  sb.sub_entidade_id = ss.sub_entidade_id
                       inner join midiaclip.setor                s   on  ss.setor_id        = s.setor_id
                        where sb.sub_entidade_id = '|| pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade)||
                   '  order by midiaclip.fnc_remove_acento(setor)';

  open p_retorno for vsql;
 --------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_associados;

/**************************************
 nome       : prc_get_disponiveis
 proposito  : Listagem de Setor Disponiveis
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
                  ' select setor_id, setor
                     from midiaclip.setor
                       where setor_id not in (
                                               select setor_id
                                                from midiaclip.sub_entidade sb
                                                 inner join midiaclip.sub_entidade_setor ss  on  sb.sub_entidade_id = ss.sub_entidade_id
                                                  and sb.sub_entidade_id = '||pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade)||
                                             ' )
                       order by midiaclip.fnc_remove_acento(setor) ';

 open p_retorno for vsql;
----------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_disponiveis;

/**************************************
 nome       : prc_associa
 proposito  : Associa SubEntidade x Setor
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_associa
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_setor               in  midiaclip.setor.setor%type
)
is
begin
 ------------ Associa SubEntidade ao Setor --------->
 begin
   insert into midiaclip.sub_entidade_setor
   (
     sub_entidade_id, setor_id
   )
   values
   (
     pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade),
     pkg_setor.fnc_get_setor_id(p_setor)
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
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type
)
is
begin

 begin
   delete from midiaclip.sub_entidade_setor
    where sub_entidade_id = pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade);
 end;

 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia;
-------------------------- Fim Package --------------------->
end pkg_subentidade_setor;
/
