create or replace package pkg_grupo_usuario
is

procedure prc_get_us_gr_associado
(
  p_grupo          in  midiaclip.grupo.grupo%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_us_gr_disponiveis
(
  p_grupo          in  midiaclip.grupo.grupo%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa_user_grupo
(
  p_usuario        in  midiaclip.usuario.usuario%type,
  p_grupo          in  midiaclip.grupo.grupo%type
);

procedure prc_desassocia
(
  p_grupo       in   midiaclip.grupo.grupo%type
);
---------------------- Fim da Package -------------->
end pkg_grupo_usuario;
/
create or replace package body pkg_grupo_usuario
is

/**************************************
 nome       : prc_get_us_gr_associado
 proposito  : Listagem de Usuarios por grupo Associados
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_get_us_gr_associado
(
  p_grupo          in  midiaclip.grupo.grupo%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql              midiaclip.pkg_refcursor.v_sql%type;
begin
  begin
    vSql := vSql ||
                    ' select u.usuario_id, u.usuario
                       from midiaclip.grupo g
                        inner join midiaclip.usuario_grupo ug   on  g.grupo_id    = ug.grupo_id
                        inner join midiaclip.usuario       u    on  ug.usuario_id = u.usuario_id
                         where g.grupo_id = pkg_grupo.fnc_get_grupo_id('''||p_grupo||''')
                         and ativo = 1
                     group by u.usuario_id, u.usuario
                     order by midiaclip.fnc_remove_acento(usuario)';
  end;
 ------------- Cursor ----------->
  open p_retorno for vSql;

--------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_us_gr_associado;

/**************************************
 nome       : prc_get_us_gr_disponiveis
 proposito  : Listagem de Usuarios por grupo Disponiveis
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_get_us_gr_disponiveis
(
  p_grupo          in  midiaclip.grupo.grupo%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql              midiaclip.pkg_refcursor.v_sql%type;
begin
  begin
    vSql := vSql ||
                    ' select usuario_id, usuario
                       from midiaclip.usuario
                        where usuario_id not in (
                                                  select usuario_id
                                                   from midiaclip.usuario_grupo
                                                )
                        and ativo = 1
                     group by usuario_id, usuario
                     order by midiaclip.fnc_remove_acento(usuario)';
  end;
 ------------- Cursor ----------->
  open p_retorno for vSql;

--------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_us_gr_disponiveis;

/**************************************
 nome       : prc_associa_user_grupo
 proposito  : Associar Usuário ao Grupo
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_associa_user_grupo
(
  p_usuario        in  midiaclip.usuario.usuario%type,
  p_grupo          in  midiaclip.grupo.grupo%type
)
is
begin
 ------------ Associa Usuario ao Grupo --------->
 begin
   insert into midiaclip.usuario_grupo
   (
     usuario_id, grupo_id
   )
   values
   (
     pkg_usuario.fnc_get_usuario_id(p_usuario),
     pkg_grupo.fnc_get_grupo_id(p_grupo)
   );
 end;
 ---------------- Exception -------------->
 exception
  when others then
   raise_application_error(-20000, 'Erro SQL : '||sqlerrm);
end prc_associa_user_grupo;

/**************************************
 nome       : prc_desassocia
 proposito  : Desassocia Usuário x Grupo
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_desassocia
(
  p_grupo       in   midiaclip.grupo.grupo%type
)
is
begin

 begin
   delete from midiaclip.usuario_grupo
    where grupo_id =  pkg_grupo.fnc_get_grupo_id(p_grupo);
 end;

 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia;


----------------------------------------- Fim da package ---------------------->
end pkg_grupo_usuario;
/
