create or replace package pkg_entidade_subentidade
is

procedure prc_get_associados
(
  p_entidade       in   midiaclip.entidades.entidade%type,
  p_retorno        out  midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_disponiveis 
(
  p_entidade       in   midiaclip.entidades.entidade%type,
  p_retorno        out  midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa
(
  p_entidade       in   midiaclip.entidades.entidade%type,
  p_subentidade    in   midiaclip.sub_entidade.sub_entidade%type
);

procedure prc_desassocia
(
  p_entidade       in   midiaclip.entidades.entidade%type
); 

----------------------------- Fim ----------------------> 
end pkg_entidade_subentidade;
/
create or replace package body pkg_entidade_subentidade
is

/**************************************
 nome       : prc_get_associados
 proposito  : Listagem de SubEntidades Associadas
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_get_associados
(
  p_entidade       in   midiaclip.entidades.entidade%type,
  p_retorno        out  midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                   midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql  := vSql||
                 ' select sb.sub_entidade_id, sb.sub_entidade
                    from midiaclip.entidades e
                      inner join midiaclip.entidade_sub_entidade es  on  e.entidade_id      = es.entidade_id
                      inner join midiaclip.sub_entidade          sb  on  es.sub_entidade_id = sb.sub_entidade_id     
                       where e.entidade_id = pkg_entidade.fnc_get_entidade_id('''||p_entidade||''') 
                    group by sb.sub_entidade_id, sb.sub_entidade    
                    order by midiaclip.fnc_remove_acento(sub_entidade)';
 
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
  p_entidade       in   midiaclip.entidades.entidade%type,
  p_retorno        out  midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                   midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql  := vSql||
        ' select sub_entidade_id, sub_entidade
             from midiaclip.sub_entidade
               where sub_entidade_id not in (
                                               select sb.sub_entidade_id
                                                 from midiaclip.entidades e
                                                   inner join midiaclip.entidade_sub_entidade es  on  e.entidade_id      = es.entidade_id
                                                   inner join midiaclip.sub_entidade          sb  on  es.sub_entidade_id = sb.sub_entidade_id     
                                                    where e.entidade_id = pkg_entidade.fnc_get_entidade_id('''||p_entidade||''') 
                                            )
              group by sub_entidade_id, sub_entidade
              order by midiaclip.fnc_remove_acento(sub_entidade)';
                 
 open p_retorno for vSql;

 --------- Exception ------------>
 exception
  when no_data_found then null; 
                 
end prc_get_disponiveis;

/**************************************
 nome       : prc_associa
 proposito  : Associa SubEntidade x Entidade 
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_associa
(
  p_entidade       in   midiaclip.entidades.entidade%type,
  p_subentidade    in   midiaclip.sub_entidade.sub_entidade%type
)
is
begin
 begin
   insert into midiaclip.entidade_sub_entidade
   (
     entidade_id, sub_entidade_id
   )
   values
   (
     pkg_entidade.fnc_get_entidade_id(p_entidade),
     pkg_sub_entidade.fnc_get_subentidade_id(p_subentidade) 
   );
 end;
 exception
  when others then
   raise_application_error(-20000, 'Erro SQL : '||sqlerrm);
end prc_associa;

/**************************************
 nome       : prc_desassocia
 proposito  : Desassocia SubEntidade x Entidade 
 author     : jicelmo andrade
 criado     : 04/06/2009
***************************************/
procedure prc_desassocia
(
  p_entidade       in   midiaclip.entidades.entidade%type
)
is
begin
 
 begin
   delete from midiaclip.entidade_sub_entidade
    where entidade_id = pkg_entidade.fnc_get_entidade_id(p_entidade);
 end;
 
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desassocia; 

------------------------- Fim Package ----------------->  
end pkg_entidade_subentidade;
/
