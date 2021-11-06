create or replace package pkg_grupo
is
 
function fnc_get_grupo_id
(
  p_grupo         in midiaclip.grupo.grupo%type
) return number;

procedure prc_get_grupo
(
  p_grupo         in  midiaclip.grupo.grupo%type,
  p_retorno       out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_grupo
(
  p_grupo         in  midiaclip.grupo.grupo%type
);

procedure prc_upd_grupo
(
  p_grupo_id      in midiaclip.grupo.grupo_id%type,
  p_grupo         in midiaclip.grupo.grupo%type
);

procedure prc_del_grupo
(
  p_grupo_id     in midiaclip.grupo.grupo_id%type
);  
------------------------- Fim da Package ------------------>
end pkg_grupo;
/
create or replace package body pkg_grupo
is

/**************************************
 nome       : fnc_get_grupo_id
 proposito  : Retorna o grupo_id ta tabela de grupo
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
function fnc_get_grupo_id
(
  p_grupo         in midiaclip.grupo.grupo%type
) return number
is
  v_grupo_id     number;
begin
  select grupo_id
   into v_grupo_id
   from midiaclip.grupo
    where grupo = trim(upper(p_grupo));
 return (v_grupo_id);

 exception 
   when no_data_found then
    raise_application_error(-20000, 'Grupo : '||p_grupo||' não encontrado');     
end fnc_get_grupo_id;

/**************************************
 nome       : prc_get_grupo
 proposito  : Retorna lista de Grupo
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_get_grupo
(
  p_grupo         in  midiaclip.grupo.grupo%type,
  p_retorno       out midiaclip.pkg_refcursor.c_cursor
)
is
  vsql            midiaclip.pkg_refcursor.v_sql%type;
begin
  vsql := vsql||
                ' select /*+ no_cpu_costing */ grupo_id, grupo 
                   from midiaclip.grupo
                    where grupo like trim(upper('''||'%'||p_grupo||'%'||'''))
                  order by fnc_remove_acento(grupo)';  
 open p_retorno for vsql;                   
end prc_get_grupo;

/**************************************
 nome       : prc_get_grupo
 proposito  : Retorna lista de Grupo
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_ins_grupo
(
  p_grupo         in  midiaclip.grupo.grupo%type
)
is
begin
 begin
    insert into midiaclip.grupo
    (
      grupo_id, grupo
    )
    values 
    (
      midiaclip.seq_grupo.nextval, trim(upper(p_grupo))
    );
  exception 
    when others then
     if substr(sqlerrm,1,9) = 'ORA-00001' then
      raise_application_error(-20000, 'Grupo : '||p_grupo||' já existe, operação abortada');
     else
      raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
     end if;
 end;
end prc_ins_grupo ;

procedure prc_upd_grupo
(
  p_grupo_id      in midiaclip.grupo.grupo_id%type,
  p_grupo         in midiaclip.grupo.grupo%type
)
is
begin
  ---------------- Atualizando Grupo --------->
  begin
    update midiaclip.grupo
      set grupo    = trim(upper(p_grupo))
    where grupo_id = p_grupo_id;
  end;
 -------------- Exception ----------> 
 exception
 when others then
  if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Grupo : '||p_grupo||' já existe, operação abortada');
  else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
  end if;
end;

/**************************************
 nome       : prc_del_grupo
 proposito  : Excluir Grupo
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_del_grupo
(
  p_grupo_id     in midiaclip.grupo.grupo_id%type
)
is
begin
  delete from midiaclip.grupo
   where grupo_id = p_grupo_id;
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O grupo não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if; 
end prc_del_grupo;   

--------------------- Fim da Package ------------>
end pkg_grupo;
/
