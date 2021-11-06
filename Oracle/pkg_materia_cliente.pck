create or replace package pkg_materia
is

function fnc_get_materia_id
(
  p_titulo          in midiaclip.materia.titulo_materia%type
) return number;

procedure prc_get_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_sub_categoria         in  midiaclip.sub_categoria.sub_categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_materia_indexada      in  midiaclip.materia.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_data_inicio           in  midiaclip.materia.data_hora%type,
  p_data_fim              in  midiaclip.materia.data_hora%type,
  p_retorno               out pkg_refcursor.c_cursor
);

procedure prc_ins_materia
(
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_data                  in  varchar2,
  p_hora_inicial          in  varchar2,
  p_duracao               in  midiaclip.materia.duracao%type,
  p_obs                   in  midiaclip.materia.obs%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_arquivo_midia         in  varchar2 -- Anexo do arquivo
);

procedure prc_upd_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_data                  in  varchar2,
  p_hora_inicial          in  varchar2,
  p_duracao               in  midiaclip.materia.duracao%type,
  p_obs                   in  midiaclip.materia.obs%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_arquivo_midia         in  varchar2 -- Anexo do arquivo
);

procedure prc_del_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type
);

procedure prc_ins_materia_entidade
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_entidade              in midiaclip.entidades.entidade%type
);

procedure prc_ins_materia_subentidade
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_subentidade           in midiaclip.sub_entidade.sub_entidade%type
);

procedure prc_ins_materia_setor
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_setor                 in midiaclip.setor.setor%type
);

procedure prc_ins_materia_arquivo
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_arquivo               in midiaclip.materia_arquivo.arquivo%type
);

procedure prc_del_materia_arquivo
(
  p_materia_id            in midiaclip.materia.materia_id%type
);

procedure prc_del_materia_subentidade
(
  p_materia_id            in midiaclip.materia.materia_id%type
);

procedure prc_del_materia_entidade
(
  p_materia_id            in midiaclip.materia.materia_id%type
);

procedure prc_del_materia_setor
(
  p_materia_id            in midiaclip.materia.materia_id%type
);

procedure prc_ins_listagem
(
  p_materia_id           in  midiaclip.materia.materia_id%type,
  p_indice_combo         in  number,
  p_cliente              in  varchar2
);

procedure prc_del_listagem
(
  p_materia_id           in midiaclip.materia.materia_id%type,
  p_indice_combo         in number
);

procedure prc_get_materias_clientes
(
  p_materia_id            in  midiaclip.materia.materia_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_sub_categoria         in  midiaclip.sub_categoria.sub_categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_materia_indexada      in  midiaclip.materia.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_data_inicio           in  midiaclip.materia.data_hora%type,
  p_data_fim              in  midiaclip.materia.data_hora%type,
  p_hora_inicio           in  midiaclip.materia.hora_inicio%type,
  p_hora_fim              in  midiaclip.materia.hora_inicio%type,
  p_tipo_canal            in  midiaclip.tipo_canal.tipo_canal%type,
  p_indice_cliente        in  number,
  p_cliente               in  varchar2,
  p_retorno               out midiaclip.pkg_refcursor.c_cursor
);


end pkg_materia;
/
create or replace package body pkg_materia
is

/**************************************
 nome       : fnc_get_materia_id
 proposito  : Retorna Materia_id
 author     : jicelmo andrade
 criado     : 03/01/2009
***************************************/
function fnc_get_materia_id
(
  p_titulo          in midiaclip.materia.titulo_materia%type
) return number
is
  v_materia_id          number;
begin
  begin
    select materia_id
     into v_materia_id
     from midiaclip.materia
      where titulo_materia = fnc_remove_acento(trim(lower(p_titulo)));
    return (v_materia_id);
  end;
----------- Exception --------->
 exception
  when no_data_found then
   raise_application_error (-20000, 'Titulo Matéria :'||p_titulo||' não cadastrado');
end fnc_get_materia_id;


/**************************************
 nome       : prc_get_materia
 proposito  : Retorna Lista Materia
 author     : jicelmo andrade
 criado     : 03/01/2009
***************************************/
procedure prc_get_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_sub_categoria         in  midiaclip.sub_categoria.sub_categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_materia_indexada      in  midiaclip.materia.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_data_inicio           in  midiaclip.materia.data_hora%type,
  p_data_fim              in  midiaclip.materia.data_hora%type,
  p_retorno               out pkg_refcursor.c_cursor
)
is
 vSql                     pkg_refcursor.v_sql%type;
 vParametros              pkg_refcursor.v_parametros%type;
 vData_inicio             boolean;
 vData_Fim                boolean;
begin
 ---------------- Periodo Entre Datas ------------------>

  vData_inicio :=  midiaclip.fnc_verifica_data(p_data_inicio);
  vData_Fim    :=  midiaclip.fnc_verifica_data(p_data_fim);
 ----------------------------------------------->

 vSql  := vSql||
                ' select m.materia_id, m.titulo_materia, ap.apresentador, pr.programa, cm.canal_comunicacao,
                         ct.categoria, ip.impacto, m.data_hora, m.hora_inicio, m.duracao, m.obs,
                    case
                     when m.materia_indexada = 1 then '||'''Não Indexada'''||'
                     when m.materia_indexada = 0 then '||'''Indexada'''||'
                    end as materia_indexada, u.usuario, ma.arquivo,
                    m.data_insert_materia, m.materia_enviada, m.alias_id, pr.custo_pub
                  from midiaclip.materia m
                    inner join midiaclip.apresentador          ap    on  m.apresentador_id       =  ap.apresentador_id
                    inner join midiaclip.programa              pr    on  m.programa_id           =  pr.programa_id
                    inner join midiaclip.canal_comunicacao     cm    on  m.canal_comunicacao_id  =  cm.canal_comunicacao_id
                    inner join midiaclip.categoria             ct    on  m.categoria_id          =  ct.categoria_id
                    inner join midiaclip.impacto               ip    on  m.impacto_id            =  ip.impacto_id
                    inner join midiaclip.usuario               u     on  m.usuario_id            =  u.usuario_id
                    left  join midiaclip.materia_arquivo       ma    on  m.materia_id            =  ma.materia_id
                     where lower(fnc_remove_acento(titulo_materia)) like  lower(fnc_remove_acento('''||'%'||p_titulo||'%'||'''))';
 ------ Materia ID -------->
 if p_materia_id  is not null then
   vSql := vSql ||
                  ' and m.materia_id = '||p_materia_id;
 end if;
 ------ Apresentador ------>
  if p_apresentador is not null then
   vParametros  := vParametros || ' and m.apresentador_id = '||pkg_apresentador.fnc_get_apresentador_id(p_apresentador);
  end if;
 ----- Programa ----------->
  if p_programa is not null then
   vParametros  := vParametros || ' and m.programa_id = '|| pkg_programa.fnc_get_programa_id(p_programa);
  end if;
 -------- Canal de Comunicacao ----------->
  if p_canal_comunicacao is not null then
   vParametros  := vParametros || ' and m.canal_comunicacao_id = '|| pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao);
  end if;
 --------- Categoria ---------->
  if p_categoria is not null then
   vParametros  := vParametros || ' and m.categoria_id = '|| pkg_categoria.fnc_get_categoria_id(p_categoria);
  end if;
 ---------- Sub Categoria ------->
  if p_sub_categoria is not null then
   vParametros  := vParametros || ' and m.sub_categoria_id = '|| pkg_sub_categoria.fnc_get_sub_categoria_id(p_sub_categoria);
  end if;
 ----------- Impacto ---------->
  if p_impacto is not null then
   vParametros  := vParametros || ' and m.impacto_id = '|| pkg_impacto.fnc_get_impacto_id(p_impacto);
  end if;
 ------------ Materia Indexada ---------->
  if p_materia_indexada is not null then
   vParametros  := vParametros || ' and m.materia_indexada = '||p_materia_indexada;
  end if;
 ------------ Usuário ---------->
  if p_usuario is not null then
   vParametros  := vParametros || ' and u.usuario_id = '||pkg_usuario.fnc_get_usuario_id(p_usuario);
  end if;

 ----------- Periodo Entre Datas ----------------->
    if (length(trim(p_data_inicio)) != 0 and length(trim(p_data_fim)) = 0) then
      raise_application_error(-20000, 'Informe a data Final, operação abortada');
    end if;
    --
    if (length(trim(p_data_fim)) != 0 and length(trim(p_data_inicio)) = 0) then
      raise_application_error(-20000, 'Informe a data Inicial, operação abortada');
    end if;
    -----

    if ( vData_inicio > vData_Fim ) then
      raise_application_error(-20000, 'Data Inicial não pode ser maior que data final verifique... ');
    end if;

   ----- verifica parametros datas
    if ((vData_inicio = true ) and ( vData_Fim = true)) then
      vParametros  := vParametros ||
                     ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;


 ----------- Vsql x VParametros ---------->
  if vParametros is not null then
   vSql := vSql || vParametros;
  end if;
 ----------- Ordenação -------->
  vSql := vSql || ' order by data_insert_materia desc, fnc_remove_acento(trim(lower(titulo_materia)))';

 ---------- Cursor ------------>
  open p_retorno for vSql;
end prc_get_materia;


/**************************************
 nome       : prc_ins_materia
 proposito  : Cadastra Materia
 author     : jicelmo andrade
 criado     : 03/01/2009
***************************************/
procedure prc_ins_materia
(
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_data                  in  varchar2,
  p_hora_inicial          in  varchar2,
  p_duracao               in  midiaclip.materia.duracao%type,
  p_obs                   in  midiaclip.materia.obs%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_arquivo_midia         in  varchar2 -- Anexo do arquivo
)
is
 v_materia_indexada       number;
 v_materia_id             number;
 v_duracao                varchar2(10);
begin

  --------------- Verificando Duracão -------------->
  if length(trim(p_duracao)) != 0 then
   v_duracao :=  p_duracao;
  else
   v_duracao := '00:00:00';
  end if;
  --------------- Verificando Materia indexada ------------>
   if length(trim(p_arquivo_midia)) != 0 then
     v_materia_indexada := 1;
   else
     v_materia_indexada := 0;
   end if;
  --------------- Cadastra --------->
  begin
   insert into midiaclip.materia
   (
     materia_id, titulo_materia, apresentador_id, programa_id, canal_comunicacao_id,
     categoria_id, impacto_id, data_hora, hora_inicio, duracao, data_insert_materia,
     obs, materia_indexada, usuario_id, alias_id
   )
   values
   (
     seq_materia.nextval, trim(p_titulo),
     pkg_apresentador.fnc_get_apresentador_id(p_apresentador),
     pkg_programa.fnc_get_programa_id(p_programa),
     pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao),
     pkg_categoria.fnc_get_categoria_id(p_categoria),
     pkg_impacto.fnc_get_impacto_id(p_impacto),
     trim(p_data),
     trim(p_hora_inicial),
     trim(v_duracao),
     sysdate,
     trim(p_obs),
     v_materia_indexada,
     pkg_usuario.fnc_get_usuario_id(p_usuario),
     to_char(sysdate, 'yyyy')||'.'||seq_materia.currval
   );
  end;
  ------------------- Arquivo ---------->
  begin
   if length(trim(p_arquivo_midia)) != 0 then
    select seq_materia.currval
     into v_materia_id
      from dual;

    prc_ins_materia_arquivo(
                             v_materia_id, trim(p_arquivo_midia)
                           );
   end if;
  end;
--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Programa : '||p_programa||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_materia;


/**************************************
 nome       : prc_upd_materia
 proposito  : Atualiza Matéria
 author     : jicelmo andrade
 criado     : 03/01/2009
***************************************/
procedure prc_upd_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_data                  in  varchar2,
  p_hora_inicial          in  varchar2,
  p_duracao               in  midiaclip.materia.duracao%type,
  p_obs                   in  midiaclip.materia.obs%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_arquivo_midia         in  varchar2 -- Anexo do arquivo
)
is
  v_materia_indexada      number;
  v_duracao               varchar2(10);
begin

  --------------- Verificando Duracão -------------->
  if length(trim(p_duracao)) != 0 then
   v_duracao :=  p_duracao;
  else
   v_duracao := '00:00:00';
  end if;
  --------------- Verificando Materia indexada ------------>
   if length(trim(p_arquivo_midia)) != 0 then
     v_materia_indexada := 1;
   else
     v_materia_indexada := 0;
   end if;
  -------------------- Atualiza -------->
  update midiaclip.materia
                       set titulo_materia            =   trim(p_titulo),
                           apresentador_id           =   pkg_apresentador.fnc_get_apresentador_id(p_apresentador),
                           programa_id               =   pkg_programa.fnc_get_programa_id(p_programa),
                           canal_comunicacao_id      =   pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao),
                           categoria_id              =   pkg_categoria.fnc_get_categoria_id(p_categoria),
                           impacto_id                =   pkg_impacto.fnc_get_impacto_id(p_impacto),
                           data_hora                 =   trim(p_data),
                           hora_inicio               =   trim(p_hora_inicial),
                           duracao                   =   trim(v_duracao),
                           obs                       =   trim(p_obs),
                           materia_indexada          =   v_materia_indexada,
                           usuario_id                =   pkg_usuario.fnc_get_usuario_id(p_usuario)
                   where   materia_id                =   p_materia_id;
  ------------------- Arquivo ---------->
  begin
    if length(trim(p_arquivo_midia)) != 0 then
      prc_del_materia_arquivo(p_materia_id);
      prc_ins_materia_arquivo(p_materia_id, p_arquivo_midia);
    else
      prc_del_materia_arquivo(p_materia_id);
      prc_del_materia_entidade(p_materia_id);
      prc_del_materia_subentidade(p_materia_id);
      prc_del_materia_setor(p_materia_id);
    end if;
  end;
--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Matéria : '||p_titulo||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_materia;

/**************************************
 nome       : prc_del_materia
 proposito  : Excluir Matéria
 author     : jicelmo andrade
 criado     : 03/01/2009
***************************************/
procedure prc_del_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type
)
is
begin
  delete from midiaclip.materia
   where materia_id = p_materia_id;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'A Materia não pode ser excluido, pois a mesma está sendo usada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_materia;

/**************************************
 nome       : prc_ins_materia_entidade
 proposito  : Inserir Matéria Entidade
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_ins_materia_entidade
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_entidade              in midiaclip.entidades.entidade%type
)
is
begin

 begin
   insert into midiaclip.materia_entidade
   (
     materia_id, entidade_id
   )
   values
   (
     p_materia_id, pkg_entidade.fnc_get_entidade_id(p_entidade)
   );
 end;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia Entidade : '||p_entidade||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_materia_entidade;

/**************************************
 nome       : prc_ins_materia_subentidade
 proposito  : Inserir Matéria SubEntidade
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_ins_materia_subentidade
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_subentidade           in midiaclip.sub_entidade.sub_entidade%type
)
is
begin

 begin
   insert into midiaclip.materia_subentidade
   (
     materia_id, sub_entidade_id
   )
   values
   (
     p_materia_id, pkg_sub_entidade.fnc_get_subentidade_id(p_subentidade)
   );
 end;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia SubEntidade : '||p_subentidade||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_materia_subentidade;

/**************************************
 nome       : prc_ins_materia_setor
 proposito  : Inserir Matéria Setor
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_ins_materia_setor
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_setor                 in midiaclip.setor.setor%type
)
is
begin

 begin
   insert into midiaclip.materia_setor
   (
     materia_id, setor_id
   )
   values
   (
     p_materia_id, pkg_setor.fnc_get_setor_id(p_setor)
   );
 end;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia Setor : '||p_setor||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_materia_setor;

/**************************************
 nome       : prc_ins_materia_arquivo
 proposito  : Inserir Matéria Arquivo
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_ins_materia_arquivo
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_arquivo               in midiaclip.materia_arquivo.arquivo%type
)
is
begin

 begin
   insert into midiaclip.materia_arquivo
   (
     materia_id, arquivo
   )
   values
   (
     p_materia_id, trim(p_arquivo)
   );
 end;
-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia Arquivo : '||p_arquivo||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;

end prc_ins_materia_arquivo;

/**************************************
 nome       : prc_del_materia_arquivo
 proposito  : Delete Matéria Arquivo
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_del_materia_arquivo
(
  p_materia_id            in midiaclip.materia.materia_id%type
)
is
begin
 delete from midiaclip.materia_arquivo
  where materia_id = p_materia_id;

-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_del_materia_arquivo;

/**************************************
 nome       : prc_del_materia_subentidade
 proposito  : Delete Matéria SubEntidade
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_del_materia_subentidade
(
  p_materia_id            in midiaclip.materia.materia_id%type
)
is
begin
 delete from midiaclip.materia_subentidade
  where materia_id = p_materia_id;
-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_del_materia_subentidade;

/**************************************
 nome       : prc_del_materia_entidade
 proposito  : Delete Matéria Entidade
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_del_materia_entidade
(
  p_materia_id            in midiaclip.materia.materia_id%type
)
is
begin

 delete from midiaclip.materia_entidade
  where materia_id = p_materia_id;
-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_del_materia_entidade;

/**************************************
 nome       : prc_del_materia_Setor
 proposito  : Delete Matéria Setor
 author     : jicelmo andrade
 criado     : 17/06/2009
***************************************/
procedure prc_del_materia_setor
(
  p_materia_id            in midiaclip.materia.materia_id%type
)
is
begin

 delete from midiaclip.materia_setor
  where materia_id = p_materia_id;
-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_del_materia_setor;

/**************************************
 nome       : prc_ins_listagem
 proposito  : Cadastra Entidade, SubEntidade, Setor as materias enviadas
 author     : jicelmo andrade
 criado     : 24/06/2009
***************************************/
procedure prc_ins_listagem
(
  p_materia_id           in  midiaclip.materia.materia_id%type,
  p_indice_combo         in  number,
  p_cliente              in  varchar2
)
is
begin

  if p_indice_combo = 0 then

    prc_ins_materia_entidade
                           (
                             p_materia_id, trim(p_cliente)
                           );
  elsif p_indice_combo = 1 then

    prc_ins_materia_subentidade
                              (
                                p_materia_id, trim(p_cliente)
                              );
  elsif p_indice_combo = 2 then

   prc_ins_materia_setor
                       (
                         p_materia_id, trim(p_cliente)
                       );
  end if;
end prc_ins_listagem;

/**************************************
 nome       : prc_del_listagem
 proposito  : Deleta Entidade, SubEntidade, Setor as materias enviadas
 author     : jicelmo andrade
 criado     : 24/06/2009
***************************************/
procedure prc_del_listagem
(
  p_materia_id           in midiaclip.materia.materia_id%type,
  p_indice_combo         in number
)
is
begin
  if p_indice_combo = 0 then

    prc_del_materia_entidade
                           (
                             p_materia_id
                           );
  elsif p_indice_combo = 1 then

    prc_del_materia_subentidade
                              (
                                p_materia_id
                              );
  elsif p_indice_combo = 2 then

   prc_del_materia_setor
                       (
                         p_materia_id
                       );
  end if;
end prc_del_listagem;

/**************************************
 nome       : prc_get_materias_clientes
 proposito  : Retorna Lista de Materias e Clientes
 author     : jicelmo andrade
 criado     : 14/07/2009
***************************************/
procedure prc_get_materias_clientes
(
  p_materia_id            in  midiaclip.materia.materia_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_sub_categoria         in  midiaclip.sub_categoria.sub_categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_materia_indexada      in  midiaclip.materia.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_data_inicio           in  midiaclip.materia.data_hora%type,
  p_data_fim              in  midiaclip.materia.data_hora%type,
  p_hora_inicio           in  midiaclip.materia.hora_inicio%type,
  p_hora_fim              in  midiaclip.materia.hora_inicio%type,
  p_tipo_canal            in  midiaclip.tipo_canal.tipo_canal%type,
  p_indice_cliente        in  number,
  p_cliente   in  varchar2,
  p_retorno   out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql                     pkg_refcursor.v_sql%type;
 vParametros              pkg_refcursor.v_parametros%type;
 vData_inicio             boolean;
 vData_Fim                boolean;
begin
 ---------------- Periodo Entre Datas ------------------>

  vData_inicio :=  midiaclip.fnc_verifica_data(p_data_inicio);
  vData_Fim    :=  midiaclip.fnc_verifica_data(p_data_fim);
 ----------------------------------------------->
begin
  vSql := vSql ||
                ' select m.materia_id, m.titulo_materia, ap.apresentador, pr.programa, cm.canal_comunicacao,
                         ct.categoria, ip.impacto, m.data_hora, m.hora_inicio, m.duracao, m.obs,
                         m.data_insert_materia, m.materia_enviada, m.alias_id, pr.custo_pub
                  from midiaclip.materia m
                    inner join midiaclip.apresentador          ap    on  m.apresentador_id       =  ap.apresentador_id
                    inner join midiaclip.programa              pr    on  m.programa_id           =  pr.programa_id
                    inner join midiaclip.canal_comunicacao     cm    on  m.canal_comunicacao_id  =  cm.canal_comunicacao_id
                    inner join midiaclip.categoria             ct    on  m.categoria_id          =  ct.categoria_id
                    inner join midiaclip.impacto               ip    on  m.impacto_id            =  ip.impacto_id
                    inner join midiaclip.materia_entidade      me    on  m.materia_id            =  me.materia_id 
                    inner join midiaclip.tipo_canal            tpc   on  cm.tipo_canal_id        =  tpc.tipo_midia 
                    inner join midiaclip.praca                 pr    on  cm.praca_id             =  pr.praca_id  
                     where materia_id > 0 ';
                     
 ------ Materia ID -------->
 if p_materia_id  is not null then
   vSql := vSql ||
                  ' and m.materia_id = '||p_materia_id;
 end if;
 ------- Titulo ou Sinopse ------------>
 if p_titulo is not null then
  if Length(trim(p_titulo)) > 0 then
    vParametros  := vParametros || '  and (lower(fnc_remove_acento(titulo_materia)) like  lower(fnc_remove_acento('''||'%'||p_titulo||'%'||''')))'|| or
                                   '  (lower(fnc_remove_acento(obs)) like  lower(fnc_remove_acento('''||'%'||p_titulo||'%'||''')))'; 
  end if; 
 end if;
 ------ Apresentador ------>
  if p_apresentador is not null then
   vParametros  := vParametros || ' and m.apresentador_id = '||pkg_apresentador.fnc_get_apresentador_id(p_apresentador);
  end if;
 ----- Programa ----------->
  if p_programa is not null then
   vParametros  := vParametros || ' and m.programa_id = '|| pkg_programa.fnc_get_programa_id(p_programa);
  end if;
 -------- Canal de Comunicacao ----------->
  if p_canal_comunicacao is not null then
   vParametros  := vParametros || ' and m.canal_comunicacao_id = '|| pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal_comunicacao);
  end if;
 --------- Categoria ---------->
  if p_categoria is not null then
   vParametros  := vParametros || ' and m.categoria_id = '|| pkg_categoria.fnc_get_categoria_id(p_categoria);
  end if;
 ----------- Impacto ---------->
  if p_impacto is not null then
   vParametros  := vParametros || ' and m.impacto_id = '|| pkg_impacto.fnc_get_impacto_id(p_impacto);
  end if;
 ------------ Materia Indexada ---------->
  if p_materia_indexada is not null then
   vParametros  := vParametros || ' and m.materia_indexada = '||p_materia_indexada;
  end if;
 ------------ Usuário ---------->
  if p_usuario is not null then
   vParametros  := vParametros || ' and u.usuario_id = '||pkg_usuario.fnc_get_usuario_id(p_usuario);
  end if;

 ----------- Periodo Entre Datas ----------------->
    if (length(trim(p_data_inicio)) != 0 and length(trim(p_data_fim)) = 0) then
      raise_application_error(-20000, 'Informe a data Final, operação abortada');
    end if;
    --
    if (length(trim(p_data_fim)) != 0 and length(trim(p_data_inicio)) = 0) then
      raise_application_error(-20000, 'Informe a data Inicial, operação abortada');
    end if;
    -----

    if ( vData_inicio > vData_Fim ) then
      raise_application_error(-20000, 'Data Inicial não pode ser maior que data final verifique... ');
    end if;

   ----- verifica parametros datas
    if ((vData_inicio = true ) and ( vData_Fim = true)) then
      vParametros  := vParametros ||
                     ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;


 ----------- Vsql x VParametros ---------->
  if vParametros is not null then
   vSql := vSql || vParametros;
  end if;
 ----------- Ordenação -------->
  vSql := vSql || ' order by data_insert_materia desc, fnc_remove_acento(trim(lower(titulo_materia)))';

 ---------- Cursor ------------>

 open p_retorno for vsql;
end;

-------------------------- Fim Package -------------------->
end pkg_materia;
/
