create or replace package pkg_subentidade_tipomidia
is
procedure prc_get_associados
(
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_disponiveis
(
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type
);

procedure prc_desassocia
(
  p_tipo_midia     in   midiaclip.tipo_midia.tipo_midia%type
);

end pkg_subentidade_tipomidia;
/
create or replace package body pkg_subentidade_tipomidia
is


/**************************************
 nome       : prc_get_associados
 proposito  : Listagem de SubEntidade Associadas
 author     : jicelmo andrade
 criado     : 05/06/2009
***************************************/
procedure prc_get_associados
(
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                   midiaclip.pkg_refcursor.v_sql%type; 
begin
  vSql := vSql ||
                  ' select s.sub_entidade_id, s.sub_entidade 
                     from midiaclip.tipo_midia tm 
                       inner join midiaclip.sub_entidade_tipo_midia st  on  tm.tipo_midia_id    = st.tipo_midia_id 
                       inner join midiaclip.sub_entidade            s   on  st.sub_entidade_id  = s.sub_entidade_id 
                        where tm.tipo_midia_id = '|| pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia)||
                   '  order by midiaclip.fnc_remove_acento(sub_entidade)';
                   
  open p_retorno for vsql;
 --------- Exception ------------>
 exception
  when no_data_found then null; 
end prc_get_associados; 

/**************************************
 nome       : prc_get_disponiveis
 proposito  : Listagem de SubEntidades Disponiveis
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_get_disponiveis
(
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                  midiaclip.pkg_refcursor.v_sql%type;                                 
begin
  vSql := vSql ||
                  ' select sub_entidade_id, sub_entidade 
                     from midiaclip.sub_entidade 
                       where sub_entidade_id not in (
                                                  select s.sub_entidade_id  
                                                    from midiaclip.tipo_midia tm 
                                                      inner join midiaclip.sub_entidade_tipo_midia st  on  tm.tipo_midia_id    = st.tipo_midia_id 
                                                      inner join midiaclip.sub_entidade            s   on  st.sub_entidade_id  = s.sub_entidade_id 
                                                       where tm.tipo_midia_id = '|| pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia)||
                                               ' )  
                       order by midiaclip.fnc_remove_acento(sub_entidade) ';

 open p_retorno for vsql;
----------- Exception ------------>
 exception
  when no_data_found then null; 
end prc_get_disponiveis;

/**************************************
 nome       : prc_associa
 proposito  : Associa Tipo de Midia a SubEntidade 
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_associa
(
  p_sub_entidade        in  midiaclip.sub_entidade.sub_entidade%type,
  p_tipo_midia          in  midiaclip.tipo_midia.tipo_midia%type
)
is
begin
 ------------- Deleta Tipo de Midia da SubEntidade --------->
 begin
   delete from midiaclip.sub_entidade_tipo_midia
    where tipo_midia_id = pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia);
 end;
 ------------ Associa Tipo de Mídia a SubEntidade --------->
 begin
   insert into midiaclip.sub_entidade_tipo_midia
   (
     sub_entidade_id, tipo_midia_id
   )
   values
   (
     pkg_sub_entidade.fnc_get_subentidade_id(p_sub_entidade),
     pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia) 
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
  p_tipo_midia     in   midiaclip.tipo_midia.tipo_midia%type
)
is
begin
 
 begin
   delete from midiaclip.sub_entidade_tipo_midia
    where tipo_midia_id = pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia);
 end;
 
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia; 
-------------------------- Fim Package --------------------->
end pkg_subentidade_tipomidia;
/
