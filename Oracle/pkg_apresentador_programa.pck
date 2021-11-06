create or replace package pkg_apresentador_programa is

procedure prc_get_apre_prog_associado
(
  p_programa       in  midiaclip.programa.programa%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_get_apre_prog_disponiveis
(
  p_programa       in  midiaclip.programa.programa%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_associa_apresen_programa
(
  p_apresentador   in  midiaclip.apresentador.apresentador%type,
  p_programa       in  midiaclip.programa.programa%type
);

procedure prc_desasso_apresen_programa
(
  p_programa       in  midiaclip.programa.programa%type
);

end pkg_apresentador_programa;
/
create or replace package body pkg_apresentador_programa is

/**************************************
 nome       : prc_get_apre_prog_associado
 proposito  : Listagem de Apresentador por Programa Associado
 author     : jicelmo andrade
 criado     : 01/01/2009
***************************************/
procedure prc_get_apre_prog_associado
(
  p_programa       in  midiaclip.programa.programa%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql              midiaclip.pkg_refcursor.v_sql%type;
begin
  begin
    vSql := vSql||

                  ' select a.apresentador_id, a.apresentador
                     from midiaclip.apresentador_programa ap
                      inner join midiaclip.apresentador          a    on  ap.apresentador_id = a.apresentador_id
                      inner join midiaclip.programa              pr   on  ap.programa_id     = pr.programa_id
                        where pr.programa_id = pkg_programa.fnc_get_programa_id ('''||p_programa||''')
                  group by a.apresentador_id, a.apresentador
                  order by midiaclip.fnc_remove_acento(apresentador)';
  end;
---------- Cursor --------------->
 open p_retorno for vSql;

--------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_apre_prog_associado;

/**************************************
 nome       : prc_get_apre_prog_disponiveis
 proposito  : Listagem de Apresentador por Programa Disponiveis 
 author     : jicelmo andrade
 criado     : 01/01/2009
***************************************/
procedure prc_get_apre_prog_disponiveis
(
  p_programa       in  midiaclip.programa.programa%type,
  p_retorno        out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql             midiaclip.pkg_refcursor.v_sql%type;
begin
  begin
    vSql := vSql||
                ' select apresentador_id, apresentador
                   from midiaclip.apresentador
                    where apresentador_id not in (
                                                    select a.apresentador_id
                                                      from midiaclip.apresentador_programa ap
                                                        inner join midiaclip.apresentador          a    on  ap.apresentador_id = a.apresentador_id
                                                        inner join midiaclip.programa              pr   on  ap.programa_id     = pr.programa_id
                                                         where pr.programa_id = pkg_programa.fnc_get_programa_id ('''||p_programa||''')
                                                 )
                 group by apresentador_id, apresentador
                 order by midiaclip.fnc_remove_acento(apresentador)';
  end;

 ------------- Cursor ------------->
  open p_retorno for vSql;

--------- Exception ------------>
 exception
  when no_data_found then null;
end prc_get_apre_prog_disponiveis;

/**************************************
 nome       : prc_associa_apresen_programa
 proposito  : Associa Apresentador ao Programa 
 author     : jicelmo andrade
 criado     : 01/01/2009
***************************************/
procedure prc_associa_apresen_programa
(
  p_apresentador   in  midiaclip.apresentador.apresentador%type,
  p_programa       in  midiaclip.programa.programa%type
)
is
begin
------------------- Associa Apresentador ao Programa ---------->
  begin
    insert into midiaclip.apresentador_programa
     (
      apresentador_id, programa_id
     )
    values
     (
       pkg_apresentador.fnc_get_apresentador_id(p_apresentador), pkg_programa.fnc_get_programa_id(p_programa)
     );
  end;
 ---------------- Exception -------------->
 exception
  when others then
   raise_application_error(-20000, 'Erro SQL : '||sqlerrm);

end prc_associa_apresen_programa;

/**************************************
 nome       : prc_desassocia_apresentador_programa
 proposito  : Desassocia Apresentador ao Programa
 author     : jicelmo andrade
 criado     : 01/01/2009
***************************************/
procedure prc_desasso_apresen_programa
(
  p_programa       in  midiaclip.programa.programa%type
)
is
begin

  delete from midiaclip.apresentador_programa
   where programa_id = pkg_programa.fnc_get_programa_id(p_programa);

exception 
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_desasso_apresen_programa;

-------------------------------------- Fim da Package ---------------->
end pkg_apresentador_programa;
/
