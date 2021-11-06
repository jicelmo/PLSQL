create or replace package pkg_programa
is
function fnc_get_programa_id
(
  p_programa                    in midiaclip.programa.programa%type
)return number;

procedure prc_get_programa
(
  p_programa                    in  midiaclip.programa.programa%type,
  p_canal_comunicacao           in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal                  in  midiaclip.tipo_canal.tipo_canal%type,
  p_retorno                     out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_programa
(
  p_programa                    in  midiaclip.programa.programa%type,
  p_hora_inicio                 in  varchar2,
  p_hora_fim                    in  varchar2,
  p_usuario                     in  midiaclip.usuario.usuario%type,
  p_canal_comunicacao           in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_custo_pub                   in  midiaclip.programa.custo_pub%type
);

procedure prc_upd_programa
(
  p_programa_id                 in midiaclip.programa.programa_id%type,
  p_programa                    in  midiaclip.programa.programa%type,
  p_hora_inicio                 in  varchar2,
  p_hora_fim                    in  varchar2,
  p_usuario                     in  midiaclip.usuario.usuario%type,
  p_canal_comunicacao           in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_custo_pub                   in  midiaclip.programa.custo_pub%type
);

procedure prc_del_programa
(
  p_programa_id                 in midiaclip.programa.programa_id%type
);

end pkg_programa;
/
create or replace package body pkg_programa
is

/**************************************
 nome       : fnc_get_programa_id
 proposito  : Retorna Programa_id
 author     : jicelmo andrade
 criado     : 29/12/2008
***************************************/
function fnc_get_programa_id
(
  p_programa                    in midiaclip.programa.programa%type
)return number
is
  v_programa_id                 number := null;
begin
  begin
    select programa_id
     into v_programa_id
     from midiaclip.programa
      where programa = trim(upper(p_programa));
   return (v_programa_id);
  end;
----------- Exception --------->
 exception
  when no_data_found then
   raise_application_error (-20000, 'Programa :'||p_programa||' não cadastrado');
end fnc_get_programa_id;


/**************************************
 nome       : prc_get_programa
 proposito  : Retorna Lista de Programa
 author     : jicelmo andrade
 criado     : 30/12/2008
***************************************/
procedure prc_get_programa
(
  p_programa                    in  midiaclip.programa.programa%type,
  p_canal_comunicacao           in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal                  in  midiaclip.tipo_canal.tipo_canal%type,
  p_retorno                     out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                           pkg_refcursor.v_sql%type;
 vParametros                    pkg_refcursor.v_parametros%type;
begin
  vSql     := vSql ||
                     ' select p.programa_id, p.programa, p.hora_inicio, p.hora_fim, c.canal_comunicacao, p.custo_pub
                        from midiaclip.programa p
                         inner join midiaclip.programa_canal_comunicacao pc   on  p.programa_id           = pc.programa_id
                         inner join midiaclip.canal_comunicacao          c    on  pc.canal_comunicacao_id = c.canal_comunicacao_id
                          where programa like trim(upper('''||'%'||p_programa||'%'||'''))';
  -- Canal
  if p_canal_comunicacao is not null then
    vParametros := vParametros ||
                        ' and p.canal_comunicacao_id = '|| pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao);
  end if;

  ----- Tipo Canal ---------->

  if p_tipo_canal is not null then
    vParametros := vParametros ||
                        ' and c.tipo_canal = '||pkg_tipo_canal.fnc_get_tipo_canal_id(p_tipo_canal);
  end if;

/*
 -- Hora Inicio ---
 if p_hora_inicio is not null then
   vParametros  := vParametros ||
                        ' and hora_inicio between to_date() and to_date()';
 end if;

 -- Hora Fim -----------
 if p_hora_fim is not null then
  vParametros  := vParametros ||
                       '  and hora_fim between to_date() and to_date()';
 end if;
*/

  ---------- Ordenação -------->
  vParametros := vParametros || ' order by midiaclip.fnc_remove_acento(programa)';

 if vParametros is not null then
   vSql := vSql || vParametros;
 end if;
----------- Cursor ------>
 open p_retorno for vSql;
end prc_get_programa;

/**************************************
 nome       : prc_ins_programa
 proposito  : Cadastra Programa
 author     : jicelmo andrade
 criado     : 30/12/2008
***************************************/
procedure prc_ins_programa
(
  p_programa                    in  midiaclip.programa.programa%type,
  p_hora_inicio                 in  varchar2,
  p_hora_fim                    in  varchar2,
  p_usuario                     in  midiaclip.usuario.usuario%type,
  p_canal_comunicacao           in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_custo_pub                   in  midiaclip.programa.custo_pub%type
)
is
begin
  ------------------ Cadastrando Programa --------------------->
  begin
    insert into midiaclip.programa
     (
       programa_id, programa, hora_inicio, hora_fim, usuario_id, custo_pub
     )
     values
     (
       seq_programa.nextval, 
       trim(upper(p_programa)),
       p_hora_inicio, p_hora_fim,
       pkg_usuario.fnc_get_usuario_id(p_usuario), 
       p_custo_pub
     );
     -------------- Associação Programa x Canal de Comunicação --------------->


    insert into midiaclip.programa_canal_comunicacao
     (
       programa_id, canal_comunicacao_id
     )
     values
     (
       seq_programa.currval, pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao)
     );

  end;

--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Programa : '||p_programa||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_programa;

/**************************************
 nome       : prc_upd_programa
 proposito  : Atualiza Programa
 author     : jicelmo andrade
 criado     : 30/12/2008
***************************************/
procedure prc_upd_programa
(
  p_programa_id                 in midiaclip.programa.programa_id%type,
  p_programa                    in  midiaclip.programa.programa%type,
  p_hora_inicio                 in  varchar2,
  p_hora_fim                    in  varchar2,
  p_usuario                     in  midiaclip.usuario.usuario%type,
  p_canal_comunicacao           in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_custo_pub                   in  midiaclip.programa.custo_pub%type
)
is
begin
  ------------ Excluir Canal Comunicação ------------------->
   delete from midiaclip.programa_canal_comunicacao
    where programa_id = p_programa_id;

  ----- Atualizando Dados ---------------------------->
  update midiaclip.programa
                      set programa             =  trim(upper(p_programa)),
                          hora_inicio          =  p_hora_inicio,
                          hora_fim             =  p_hora_fim,
                          usuario_id           =  pkg_usuario.fnc_get_usuario_id(p_usuario),
                          custo_pub            =  p_custo_pub
                   where  programa_id          =  p_programa_id;

  ----------- Canal de Comunicação Cadastro ------------->
     insert into midiaclip.programa_canal_comunicacao
     (
       programa_id, canal_comunicacao_id
     )
     values
     (
       p_programa_id, pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao)
     );

--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Programa : '||p_programa||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_programa;

/**************************************
 nome       : prc_del_programa
 proposito  : Excluir Programa
 author     : jicelmo andrade
 criado     : 30/12/2008
***************************************/
procedure prc_del_programa
(
  p_programa_id                 in midiaclip.programa.programa_id%type
)
is
begin

  delete from midiaclip.programa
   where programa_id = p_programa_id;
 ----------------- Exception -------------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O Programa não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;

end prc_del_programa;

-------------------------- Fim da Package ------------------------>
end pkg_programa;
/
