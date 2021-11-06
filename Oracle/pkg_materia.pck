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
  p_arquivo_midia         in  varchar2, -- Anexo do arquivo
  p_indicar               in  midiaclip.materia.indicar%type
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
  p_arquivo_midia         in  varchar2, -- Anexo do arquivo
  p_indicar               in  midiaclip.materia.indicar%type
);

procedure prc_del_materia
(
  p_materia_id            in  midiaclip.materia.materia_id%type
);

procedure prc_ins_materia_entidade
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_entidade_id           in midiaclip.entidades.entidade_id%type
);

procedure prc_ins_materia_subentidade
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_subentidade_id        in midiaclip.sub_entidade.sub_entidade_id%type
);

procedure prc_ins_materia_setor
(
  p_materia_id            in midiaclip.materia.materia_id%type,
  p_setor_id              in midiaclip.setor.setor_id%type
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
  p_cliente_id           in  number
);

procedure prc_del_listagem
(
  p_materia_id           in midiaclip.materia.materia_id%type,
  p_indice_combo         in number
);

procedure prc_get_materias_clientes
(
  p_materia_id            in  midiaclip.materia.alias_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_materia_indexada      in  midiaclip.materia.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_data_inicio           in  midiaclip.materia.data_hora%type,
  p_data_fim              in  midiaclip.materia.data_hora%type,
  p_hora_inicio           in  midiaclip.materia.hora_inicio%type,
  p_hora_fim              in  midiaclip.materia.hora_inicio%type,
  p_praca                 in  midiaclip.praca.praca%type,
  p_tipo_canal            in  midiaclip.tipo_canal.tipo_canal%type,
  p_indice_cliente        in  number,
  p_cliente               in  varchar2,
  p_indicar               in  midiaclip.materia.indicar%type,
  p_retorno               out midiaclip.pkg_refcursor.c_cursor
);

function fnc_get_sub_cliente
(
  p_lista_setor    in varchar2
) return pkg_refcursor.c_cursor;

function fnc_get_cliente
(
  p_lista_sub_cliente  in varchar2
) return pkg_refcursor.c_cursor;

procedure prc_grava_cliente_materia
(
  p_materia_id   in  number,
  p_cliente_id   in  varchar2,
  p_nivel        in  number
);

procedure prc_get_materias_jornal
(
  p_materia_id            in  midiaclip.materia_jornal.alias_id%type,
  p_manchete              in  midiaclip.materia_jornal.titulo_materia%type,
  p_jornalista            in  midiaclip.jornalista.jornalista_id%type,
  p_coluna                in  midiaclip.coluna.coluna_id%type,
  p_editoria              in  midiaclip.editoria.editoria_id%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao_id%type,
  p_categoria             in  midiaclip.categoria.categoria_id%type,
  p_impacto               in  midiaclip.impacto.impacto_id%type,
  p_materia_indexada      in  midiaclip.materia_jornal.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario_id%type,
  p_data_inicio           in  midiaclip.materia_jornal.data_materia%type,
  p_data_fim              in  midiaclip.materia_jornal.data_materia%type,
  p_praca                 in  midiaclip.praca.praca_id%type,
  p_indice_cliente        in  number,
  p_cliente               in  varchar2,
  p_retorno               out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_grava_cliente_mat_jornal
(
  p_materia_jornal_id   in  number,
  p_cliente_id   in  varchar2,
  p_nivel        in  number
);

function fnc_get_materias_jornal_envio
(
  p_data_inicio           in  midiaclip.materia_jornal.data_materia%type,
  p_data_fim              in  midiaclip.materia_jornal.data_materia%type,
  p_indice_cliente        in  number,
  p_cliente_id            in  number
) return pkg_refcursor.c_cursor;

function prc_ins_materia_jornal
(
  p_titulo_materia        in  midiaclip.materia_jornal.titulo_materia%type,
  p_data_materia          in  midiaclip.materia_jornal.data_materia%type,
  p_canal_comunicacao_id  in  midiaclip.materia_jornal.canal_comunicacao_id%type,
  p_usuario_id            in  midiaclip.materia_jornal.usuario_id%type,
  p_editoria_id           in  midiaclip.materia_jornal.editoria_id%type,
  p_coluna_id             in  midiaclip.materia_jornal.coluna_id%type,
  p_jornalista_id         in  midiaclip.materia_jornal.jornalista_id%type,
  p_categoria_id          in  midiaclip.materia_jornal.categoria_id%type,
  p_impacto_id            in  midiaclip.materia_jornal.impacto_id%type,
  p_pagina                in  midiaclip.materia_jornal.pagina%type,
  p_qtde_coluna           in  midiaclip.materia_jornal.qtde_coluna%type,
  p_centimetragem         in  midiaclip.materia_jornal.centimetragem%type,
  p_total                 in  midiaclip.materia_jornal.total%type,
  p_noticia               in  midiaclip.materia_jornal.noticia%type,
  p_sinopse               in  midiaclip.materia_jornal.sinopse%type,
  p_custo_pub             in  midiaclip.materia_jornal.custo_pub%type
) return integer;

procedure prc_upd_materia_jornal
(
  p_materia_jornal_id     in  midiaclip.materia_jornal.materia_jornal_id%type,
  p_titulo_materia        in  midiaclip.materia_jornal.titulo_materia%type,
  p_data_materia          in  midiaclip.materia_jornal.data_materia%type,
  p_canal_comunicacao_id  in  midiaclip.materia_jornal.canal_comunicacao_id%type,
  p_usuario_id            in  midiaclip.materia_jornal.usuario_id%type,
  p_editoria_id           in  midiaclip.materia_jornal.editoria_id%type,
  p_coluna_id             in  midiaclip.materia_jornal.coluna_id%type,
  p_jornalista_id         in  midiaclip.materia_jornal.jornalista_id%type,
  p_categoria_id          in  midiaclip.materia_jornal.categoria_id%type,
  p_impacto_id            in  midiaclip.materia_jornal.impacto_id%type,
  p_pagina                in  midiaclip.materia_jornal.pagina%type,
  p_qtde_coluna           in  midiaclip.materia_jornal.qtde_coluna%type,
  p_centimetragem         in  midiaclip.materia_jornal.centimetragem%type,
  p_total                 in  midiaclip.materia_jornal.total%type,
  p_noticia               in  midiaclip.materia_jornal.noticia%type,
  p_sinopse               in  midiaclip.materia_jornal.sinopse%type,
  p_custo_pub             in  midiaclip.materia_jornal.custo_pub%type
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
                    m.data_insert_materia, m.materia_enviada, m.alias_id, pr.custo_pub, m.indicar
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
  vSql := vSql || ' order by to_date(data_hora, '||'''dd/mm/yyyy'''||') desc';

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
  p_arquivo_midia         in  varchar2, -- Anexo do arquivo
  p_indicar               in  midiaclip.materia.indicar%type
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
     obs, materia_indexada, usuario_id, alias_id, indicar
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
     to_char(sysdate, 'yyyy')||'.'||seq_materia.currval,
     p_indicar
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
    raise_application_error(-20000, 'Titulo da Matéria : '||p_titulo||' já existe, operação abortada');
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
  p_arquivo_midia         in  varchar2, -- Anexo do arquivo
  p_indicar               in  midiaclip.materia.indicar%type
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
                           usuario_id                =   pkg_usuario.fnc_get_usuario_id(p_usuario),
                           indicar                   =   p_indicar
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
  p_entidade_id           in midiaclip.entidades.entidade_id%type
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
     p_materia_id, p_entidade_id
   );
 end;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia Entidade : '||p_entidade_id||' já existe, operação abortada');
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
  p_subentidade_id        in midiaclip.sub_entidade.sub_entidade_id%type
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
     p_materia_id, p_subentidade_id
   );
 end;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia SubEntidade : '||p_subentidade_id||' já existe, operação abortada');
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
  p_setor_id              in midiaclip.setor.setor_id%type
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
     p_materia_id, p_setor_id
   );
 end;

-------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Materia Setor : '||p_setor_id||' já existe, operação abortada');
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
  p_cliente_id           in  number
)
is
begin

  if p_indice_combo = 0 then

    prc_ins_materia_entidade
                           (
                             p_materia_id, p_cliente_id
                           );
  elsif p_indice_combo = 1 then

    prc_ins_materia_subentidade
                              (
                                p_materia_id, p_cliente_id
                              );
  elsif p_indice_combo = 2 then

   prc_ins_materia_setor
                       (
                         p_materia_id, p_cliente_id
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
  p_materia_id            in  midiaclip.materia.alias_id%type,
  p_titulo                in  midiaclip.materia.titulo_materia%type,
  p_apresentador          in  midiaclip.apresentador.apresentador%type,
  p_programa              in  midiaclip.programa.programa%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_categoria             in  midiaclip.categoria.categoria%type,
  p_impacto               in  midiaclip.impacto.impacto%type,
  p_materia_indexada      in  midiaclip.materia.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario%type,
  p_data_inicio           in  midiaclip.materia.data_hora%type,
  p_data_fim              in  midiaclip.materia.data_hora%type,
  p_hora_inicio           in  midiaclip.materia.hora_inicio%type,
  p_hora_fim              in  midiaclip.materia.hora_inicio%type,
  p_praca                 in  midiaclip.praca.praca%type,
  p_tipo_canal            in  midiaclip.tipo_canal.tipo_canal%type,
  p_indice_cliente        in  number,
  p_cliente               in  varchar2,
  p_indicar               in  midiaclip.materia.indicar%type,
  p_retorno               out midiaclip.pkg_refcursor.c_cursor
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
  vSql := vSql ||
                ' select m.materia_id, m.titulo_materia, ap.apresentador, pr.programa, cm.canal_comunicacao,
                         ct.categoria, ip.impacto, m.data_hora, m.hora_inicio, m.duracao, m.obs,
                    case
                     when m.materia_indexada = 1 then '||'''Não Indexada'''||'
                     when m.materia_indexada = 0 then '||'''Indexada'''||'
                    end as materia_indexada, u.usuario, ma.arquivo,
                    m.data_insert_materia, m.materia_enviada, m.alias_id, pr.custo_pub,
                    case
                     when m.indicar = 1 then '||'''Indicada'''||'
                     when m.indicar = 0 then '||'''Sem Indicação'''||'
                    end as inidcar
                  from midiaclip.materia m
                    inner join midiaclip.apresentador          ap    on  m.apresentador_id       =  ap.apresentador_id
                    inner join midiaclip.programa              pr    on  m.programa_id           =  pr.programa_id
                    inner join midiaclip.canal_comunicacao     cm    on  m.canal_comunicacao_id  =  cm.canal_comunicacao_id
                    inner join midiaclip.categoria             ct    on  m.categoria_id          =  ct.categoria_id
                    inner join midiaclip.impacto               ip    on  m.impacto_id            =  ip.impacto_id
                    inner join midiaclip.usuario               u     on  m.usuario_id            =  u.usuario_id
                    inner join midiaclip.tipo_canal            tpc   on  cm.tipo_canal_id        =  tpc.tipo_canal_id
                    inner join midiaclip.praca                 pr    on  cm.praca_id             =  pr.praca_id
                    left  join midiaclip.materia_arquivo       ma    on  m.materia_id            =  ma.materia_id ';

  if p_indice_cliente != 3 then
    vParametros := vParametros ||
      ' inner join midiaclip.v$_listagem_materia_clientes   mc   on   m.materia_id  = mc.materia_id
          and mc.cliente_indice_id ='||p_indice_cliente||'
        inner join midiaclip.v$_listagem_clientes           c    on   mc.cliente_id = c.cliente_id
          and c.cliente_indice_id  ='||p_indice_cliente;
  end if;

   vParametros := vParametros || ' where m.materia_id <> 0 ';
   --' where lower(fnc_remove_acento(m.obs)) like  lower(fnc_remove_acento('''||'%'||p_titulo||'%'||'''))';
 ------ Materia ID -------->
 if p_materia_id  is not null then
   vParametros := vParametros ||
                                ' and (m.alias_id = '''||p_materia_id ||''') or (m.materia_id = '||p_materia_id||')';
 end if;
 ------- Titulo ou Sinopse ------------>
 if p_titulo is not null then
  if Length(trim(p_titulo)) > 0 then
    vParametros  := vParametros ||
    '  and ((lower(fnc_remove_acento(obs)) like  lower(fnc_remove_acento('''||'%'||p_titulo||'%'||''')))
       or (lower(fnc_remove_acento(titulo_materia)) like lower(fnc_remove_acento('''||'%'||p_titulo||'%'||'''))))';
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

 ----------- Tipo Canal ----------------------->
  if p_tipo_canal is not null then
   vParametros  := vParametros || ' and tpc.tipo_canal = '''||p_tipo_canal||'''';
  end if;
 ----------- Praca ----------------------->
  if p_praca is not null then
   vParametros  := vParametros || ' and pr.praca = '''||p_praca||'''';
  end if;
 ----------- Cliente ------------------>
  if p_indice_cliente != 3 then
   vParametros  := vParametros || ' and c.cliente = '''||p_cliente||'''';
  end if;
 ----------- Periodo Horas --------------------->
   if (length(trim(p_hora_inicio)) != 0  and length(trim(p_hora_fim)) != 0) then
    vParametros  := vParametros ||
                     ' and hora_inicio between ('''||p_hora_inicio||''') and ('''||p_hora_fim||''')';
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
    if ((vData_inicio = true ) and ( vData_Fim = true)) and (p_materia_id is null) then
      vParametros  := vParametros ||
                     ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;

 ------------------ Inidcação ------------------>
  if p_indicar is not null then
    vParametros := vParametros ||
                     ' and m.indicar ='||p_indicar;
  end if;

 ----------- Vsql x VParametros ---------->
  if vParametros is not null then
   vSql := vSql || vParametros;
  end if;
 ----------- Ordenação -------->
  vSql := vSql || ' order by to_date(data_hora, '||'''dd/mm/yyyy'''||') desc';
 ---------- Cursor ------------>
 open p_retorno for vSql;
end prc_get_materias_clientes;

/**************************************
 nome       : fnc_get_sub_cliente
 proposito  : Retorna Listagem de SubCliente
 author     : jicelmo andrade
 criado     : 23/07/2009
***************************************/
function fnc_get_sub_cliente
(
  p_lista_setor    in varchar2
) return pkg_refcursor.c_cursor
is
  vDataSet     pkg_refcursor.c_cursor;
  vSql         pkg_refcursor.v_sql%type;
begin
  vSql := vSql ||
                  ' select sb.sub_entidade_id, sb.sub_entidade
                      from midiaclip.sub_entidade_setor sc
                       inner join midiaclip.sub_entidade sb  on  sc.sub_entidade_id  = sb.sub_entidade_id
                       inner join midiaclip.setor        s   on  sc.setor_id         = s.setor_id
                     where s.setor_id in ('||p_lista_setor||')'||
                  '  group by sb.sub_entidade_id, sb.sub_entidade
                     order by fnc_remove_acento(sub_entidade) ';

 open vDataSet for vSql;
 return vDataSet;
end fnc_get_sub_cliente;

/**************************************
 nome       : fnc_get_cliente
 proposito  : Retorna Listagem de Cliente
 author     : jicelmo andrade
 criado     : 17/10/2009
***************************************/
function fnc_get_cliente
(
  p_lista_sub_cliente  in varchar2
) return pkg_refcursor.c_cursor
is
  vDataSet     pkg_refcursor.c_cursor;
  vSql         pkg_refcursor.v_sql%type;
begin
  vSql := vSql ||
                  ' select e.entidade_id, e.entidade
                      from midiaclip.entidade_sub_entidade es
                       inner join midiaclip.entidades    e    on  es.entidade_id      = e.entidade_id
                       inner join midiaclip.sub_entidade sb   on  es.sub_entidade_id  = sb.sub_entidade_id
                     where sb.sub_entidade_id in ('||p_lista_sub_cliente||')'||
                  '  group by e.entidade_id, e.entidade
                     order by fnc_remove_acento(e.entidade) ';

 open vDataSet for vSql;
 return vDataSet;
end fnc_get_cliente;

/**************************************
 nome       : prc_grava_cliente_materia
 proposito  : Grava os Clientes Materias
 author     : jicelmo andrade
 criado     : 20/10/2009
***************************************/

procedure prc_grava_cliente_materia
(
  p_materia_id   in  number,
  p_cliente_id   in  varchar2,
  p_nivel        in  number
)
is
 vSql          pkg_refcursor.v_sql%type;
begin
  -- Nivel 0 Cliente ---------------->
   if p_nivel = 0 then
     ---------- Removendo Materias de Entidades --------->
     prc_del_materia_entidade
     (
       p_materia_id
     );
     ------------ Inserindo Matérias de Entidades ------->
     vSql := vSql ||
                    ' insert into materia_entidade
                     (
                       materia_id, entidade_id
                     )
                       select '||p_materia_id||', entidade_id
                        from midiaclip.entidades
                         where entidade_id in ('||p_cliente_id||')';
   end if;

  -- Nivel 1 SubCliente ---------------->
   if p_nivel = 1 then
     ---------- Removendo Materias de Sub_Entidades --------->
     prc_del_materia_subentidade
     (
       p_materia_id
     );
     ------------ Inserindo Matérias de Sub_Entidades ------->
     vSql := vSql ||
                    'insert into materia_subentidade
                     (
                       materia_id, sub_entidade_id
                     )
                      select '||p_materia_id||', sub_entidade_id
      from midiaclip.sub_entidade
       where sub_entidade_id in ('||p_cliente_id||')';
   end if;

  -- Nivel 2 Setor ---------------->
   if p_nivel = 2 then
     ---------- Removendo Materias de Setor --------->
     prc_del_materia_setor
     (
       p_materia_id
     );
     ------------ Inserindo Matérias de Setor ------->
     vSql := vSql ||
                   ' insert into materia_setor
                     (
                       materia_id, setor_id
                     )
                      select '||p_materia_id||', setor_id
                        from midiaclip.setor
                         where setor_id in ('||p_cliente_id||')';
   end if;
-------------- Executando SQL Dinâmica --------->
 execute immediate vSql;
-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_grava_cliente_materia;


/**************************************
 nome       : prc_get_materias_jornal_clientes
 proposito  : Retorna Lista de Materias e Clientes
 author     : jicelmo andrade
 criado     : 14/07/2009
***************************************/

procedure prc_get_materias_jornal
(
  p_materia_id            in  midiaclip.materia_jornal.alias_id%type,
  p_manchete              in  midiaclip.materia_jornal.titulo_materia%type,
  p_jornalista            in  midiaclip.jornalista.jornalista_id%type,
  p_coluna                in  midiaclip.coluna.coluna_id%type,
  p_editoria              in  midiaclip.editoria.editoria_id%type,
  p_canal_comunicacao     in  midiaclip.canal_comunicacao.canal_comunicacao_id%type,
  p_categoria             in  midiaclip.categoria.categoria_id%type,
  p_impacto               in  midiaclip.impacto.impacto_id%type,
  p_materia_indexada      in  midiaclip.materia_jornal.materia_indexada%type,
  p_usuario               in  midiaclip.usuario.usuario_id%type,
  p_data_inicio           in  midiaclip.materia_jornal.data_materia%type,
  p_data_fim              in  midiaclip.materia_jornal.data_materia%type,
  p_praca                 in  midiaclip.praca.praca_id%type,
  p_indice_cliente        in  number,
  p_cliente               in  varchar2,
  p_retorno               out midiaclip.pkg_refcursor.c_cursor
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
  vSql := vSql ||
               '  select m.materia_jornal_id, m.titulo_materia, jr.jornalista, ed.editoria, cm.canal_comunicacao,
                         ct.categoria, ip.impacto, m.data_materia, m.noticia,
                    case
                     when m.materia_indexada = 1 then '||'''Não Indexada'''||'
                     when m.materia_indexada = 0 then '||'''Indexada'''||'
                    end as materia_indexada, u.usuario, sinopse,
                    m.data_insert_materia, m.materia_enviada, m.alias_id, m.pagina, m.qtde_coluna, m.centimetragem,
                    m.total, cc.coluna
                  from midiaclip.materia_jornal  m
                    inner join midiaclip.jornalista            jr    on  m.jornalista_id         =  jr.jornalista_id
                    inner join midiaclip.editoria              ed    on  m.editoria_id           =  ed.editoria_id
                    inner join midiaclip.canal_comunicacao     cm    on  m.canal_comunicacao_id  =  cm.canal_comunicacao_id
                    inner join midiaclip.categoria             ct    on  m.categoria_id          =  ct.categoria_id
                    inner join midiaclip.impacto               ip    on  m.impacto_id            =  ip.impacto_id
                    inner join midiaclip.usuario               u     on  m.usuario_id            =  u.usuario_id
                    inner join midiaclip.praca                 pr    on  cm.praca_id             =  pr.praca_id
                    left  join midiaclip.coluna                cc    on  m.coluna_id             =  cc.coluna_id ';

  if p_indice_cliente != 3 then
    vParametros := vParametros ||
      ' inner join v$_listagem_clientes_jornal   mc   on   m.materia_jornal_id  = mc.materia_jornal_id
          and mc.cliente_indice_id ='||p_indice_cliente||'
        inner join midiaclip.v$_listagem_clientes     c    on   mc.cliente_id = c.cliente_id
          and c.cliente_indice_id  ='||p_indice_cliente;
  end if;

   vParametros := vParametros || ' where m.materia_jornal_id <> 0 ';
 ------ Materia ID -------->
 if p_materia_id  is not null then
   vParametros := vParametros ||
                                ' and (m.alias_id = '''||p_materia_id ||''') or (m.materia_jornal_id = '||p_materia_id||')';
 end if;
 ------- Titulo ou Sinopse ------------>
 if p_manchete is not null then
  if Length(trim(p_manchete)) > 0 then
    vParametros  := vParametros ||
    '  and ((lower(fnc_remove_acento(noticia)) like  lower(fnc_remove_acento('''||'%'||p_manchete||'%'||''')))
       or (lower(fnc_remove_acento(titulo_materia)) like lower(fnc_remove_acento('''||'%'||p_manchete||'%'||'''))))';
  end if;
 end if;
 ------ Apresentador ------>
  if p_jornalista is not null then
   vParametros  := vParametros || ' and m.jornalista_id = '||p_jornalista;
  end if;
 ------ Coluna ------>
  if p_coluna is not null then
   vParametros  := vParametros || ' and m.coluna_id = '||p_coluna;
  end if;
 ----- Programa ----------->
  if p_editoria is not null then
   vParametros  := vParametros || ' and m.editoria_id = '||p_editoria;
  end if;
 -------- Canal de Comunicacao ----------->
  if p_canal_comunicacao is not null then
   vParametros  := vParametros || ' and m.canal_comunicacao_id = '|| p_canal_comunicacao;
  end if;
 --------- Categoria ---------->
  if p_categoria is not null then
   vParametros  := vParametros || ' and m.categoria_id = '|| p_categoria;
  end if;
 ----------- Impacto ---------->
  if p_impacto is not null then
   vParametros  := vParametros || ' and m.impacto_id = '|| p_impacto;
  end if;
 ------------ Materia Indexada ---------->
  if p_materia_indexada is not null then
   vParametros  := vParametros || ' and m.materia_indexada = '||p_materia_indexada;
  end if;
 ------------ Usuário ---------->
  if p_usuario is not null then
   vParametros  := vParametros || ' and u.usuario_id = '||p_usuario;
  end if;

 ----------- Praca ----------------------->
  if p_praca is not null then
   vParametros  := vParametros || ' and pr.praca_id = '||p_praca;
  end if;
 ----------- Cliente ------------------>
  if p_indice_cliente != 3 then
   vParametros  := vParametros || ' and c.cliente = '''||p_cliente||'''';
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
    if ((vData_inicio = true ) and ( vData_Fim = true)) and (p_materia_id is null) then
      vParametros  := vParametros ||
                     ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;

/*
 ------------------ Inidcação ------------------>
  if p_indicar is not null then
    vParametros := vParametros ||
                     ' and m.indicar ='||p_indicar;
  end if;
*/
 ----------- Vsql x VParametros ---------->
  if vParametros is not null then
   vSql := vSql || vParametros;
  end if;
 ----------- Ordenação -------->
  vSql := vSql || ' order by to_date(data_materia, '||'''dd/mm/yyyy'''||') desc';
 ---------- Cursor ------------>
 open p_retorno for vSql;
end prc_get_materias_jornal;

/**************************************
 nome       : prc_grava_cliente_materia_jornal
 proposito  : Grava os Clientes Materias
 author     : jicelmo andrade
 criado     : 20/10/2009
***************************************/

procedure prc_grava_cliente_mat_jornal
(
  p_materia_jornal_id   in  number,
  p_cliente_id          in  varchar2,
  p_nivel               in  number
)
is
 vSql          pkg_refcursor.v_sql%type;
begin
  -- Nivel 0 Cliente ---------------->
   if p_nivel = 0 then
     ------------ Inserindo Matérias de Entidades ------->
     vSql := vSql ||
                    ' insert into materia_jornal_entidade
                     (
                       materia_jornal_id, entidade_id
                     )
                       select '||p_materia_jornal_id||', entidade_id
                        from midiaclip.entidades
                         where entidade_id in ('||p_cliente_id||')';
   end if;

  -- Nivel 1 SubCliente ---------------->
   if p_nivel = 1 then
     ------------ Inserindo Matérias de Sub_Entidades ------->
     vSql := vSql ||
                    'insert into materia_jornal_sub_entidade
                     (
                       materia_jornal_id, sub_entidade_id
                     )
                      select '||p_materia_jornal_id||', sub_entidade_id
                        from midiaclip.sub_entidade
                          where sub_entidade_id in ('||p_cliente_id||')';
   end if;

  -- Nivel 2 Setor ---------------->
   if p_nivel = 2 then
     ------------ Inserindo Matérias de Setor ------->
     vSql := vSql ||
                   ' insert into materia_jornal_setor
                     (
                       materia_jornal_id, setor_id
                     )
                      select '||p_materia_jornal_id||', setor_id
                        from midiaclip.setor
                         where setor_id in ('||p_cliente_id||')';
   end if;
-------------- Executando SQL Dinâmica --------->
 execute immediate vSql;
-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_grava_cliente_mat_jornal;


/**************************************
 nome       : fnc_get_materias_jornal_envio
 proposito  : Relação das Matérias a serem enviadas
 author     : jicelmo andrade
 criado     : 16/01/2010
***************************************/

function fnc_get_materias_jornal_envio
(
  p_data_inicio           in  midiaclip.materia_jornal.data_materia%type,
  p_data_fim              in  midiaclip.materia_jornal.data_materia%type,
  p_indice_cliente        in  number,
  p_cliente_id            in  number
) return pkg_refcursor.c_cursor
is
  vDataSet     pkg_refcursor.c_cursor;
  vSql         pkg_refcursor.v_sql%type;
  vData_inicio             boolean;
  vData_Fim                boolean;
begin
 ---------------- Periodo Entre Datas ------------------>
  vData_inicio :=  midiaclip.fnc_verifica_data(p_data_inicio);
  vData_Fim    :=  midiaclip.fnc_verifica_data(p_data_fim);
 ----------------------------------------------->
  vSql := vSql ||
               '  select m.materia_jornal_id, m.titulo_materia, jr.jornalista, ed.editoria, cm.canal_comunicacao,
                         ct.categoria, ip.impacto, m.data_materia, m.noticia, sinopse,  m.data_insert_materia,
                         m.materia_enviada, m.alias_id, m.pagina, m.qtde_coluna, m.centimetragem, m.total, cc.coluna, m.custo_pub
                  from midiaclip.materia_jornal  m
                    inner join midiaclip.jornalista            jr    on  m.jornalista_id         =  jr.jornalista_id
                    inner join midiaclip.editoria              ed    on  m.editoria_id           =  ed.editoria_id
                    inner join midiaclip.canal_comunicacao     cm    on  m.canal_comunicacao_id  =  cm.canal_comunicacao_id
                    inner join midiaclip.categoria             ct    on  m.categoria_id          =  ct.categoria_id
                    inner join midiaclip.impacto               ip    on  m.impacto_id            =  ip.impacto_id
                    inner join midiaclip.praca                 pr    on  cm.praca_id             =  pr.praca_id
                    left  join midiaclip.coluna                cc    on  m.coluna_id             =  cc.coluna_id
                 ';
   if p_indice_cliente != -1 then
     vSql := vSql ||
                    ' inner join v$_listagem_clientes_jornal     mc    on  m.materia_jornal_id     = mc.materia_jornal_id
                       and mc.cliente_indice_id ='||p_indice_cliente||'
                      inner join midiaclip.v$_listagem_clientes  c     on  mc.cliente_id           = c.cliente_id
                       and c.cliente_indice_id  ='||p_indice_cliente||
                    '  and c.cliente_id = '||p_cliente_id;
   end if;

     vSql := vSql ||
                    ' where m.materia_jornal_id <> 0';


--- Data Periodos ------------>
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
      vSql  := vSql ||
                     ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;

  vSql := vSql || ' order by to_date(data_materia, '||'''dd/mm/yyyy'''||') desc';

 open vDataSet for vSql;
 return vDataSet;

end fnc_get_materias_jornal_envio;

/**************************************
 nome       : prc_ins_materia_jornal
 proposito  : cadastro de materia jornal
 author     : jicelmo andrade
 criado     : 15/08/2010
***************************************/ 
function prc_ins_materia_jornal
(
  p_titulo_materia        in  midiaclip.materia_jornal.titulo_materia%type,
  p_data_materia          in  midiaclip.materia_jornal.data_materia%type,
  p_canal_comunicacao_id  in  midiaclip.materia_jornal.canal_comunicacao_id%type,
  p_usuario_id            in  midiaclip.materia_jornal.usuario_id%type,
  p_editoria_id           in  midiaclip.materia_jornal.editoria_id%type,
  p_coluna_id             in  midiaclip.materia_jornal.coluna_id%type,
  p_jornalista_id         in  midiaclip.materia_jornal.jornalista_id%type,
  p_categoria_id          in  midiaclip.materia_jornal.categoria_id%type,
  p_impacto_id            in  midiaclip.materia_jornal.impacto_id%type,
  p_pagina                in  midiaclip.materia_jornal.pagina%type,
  p_qtde_coluna           in  midiaclip.materia_jornal.qtde_coluna%type,
  p_centimetragem         in  midiaclip.materia_jornal.centimetragem%type,
  p_total                 in  midiaclip.materia_jornal.total%type,
  p_noticia               in  midiaclip.materia_jornal.noticia%type,
  p_sinopse               in  midiaclip.materia_jornal.sinopse%type,
  p_custo_pub             in  midiaclip.materia_jornal.custo_pub%type
) return integer
is
 materia_id   integer;
begin
  begin
    insert into midiaclip.materia_jornal
    (
      materia_jornal_id, canal_comunicacao_id, usuario_id, titulo_materia, data_materia,
      editoria_id, coluna_id, jornalista_id, categoria_id, impacto_id, data_insert_materia,
      pagina, qtde_coluna, centimetragem, total, sinopse, noticia, alias_id, custo_pub  
    )
    values
    (
      seq_materia_jornal.nextval, p_canal_comunicacao_id, p_usuario_id, p_titulo_materia, p_data_materia, 
      p_editoria_id, p_coluna_id, p_jornalista_id, p_categoria_id, p_impacto_id, sysdate, p_pagina,
      p_qtde_coluna, p_centimetragem, p_total, p_sinopse,  trim(p_noticia), to_char(sysdate,'yyyy')||'.'||seq_materia_jornal.currval,
      p_custo_pub 
    );
    
     select seq_materia_jornal.currval 
        into materia_id 
      from dual;
  end;
return materia_id;  
end prc_ins_materia_jornal;

/**************************************
 nome       : prc_upd_materia_jornal
 proposito  : Atualiza Materia Jornal 
 author     : jicelmo andrade
 criado     : 15/08/2010
***************************************/ 
procedure prc_upd_materia_jornal
(
  p_materia_jornal_id     in  midiaclip.materia_jornal.materia_jornal_id%type,
  p_titulo_materia        in  midiaclip.materia_jornal.titulo_materia%type,
  p_data_materia          in  midiaclip.materia_jornal.data_materia%type,
  p_canal_comunicacao_id  in  midiaclip.materia_jornal.canal_comunicacao_id%type,
  p_usuario_id            in  midiaclip.materia_jornal.usuario_id%type,
  p_editoria_id           in  midiaclip.materia_jornal.editoria_id%type,
  p_coluna_id             in  midiaclip.materia_jornal.coluna_id%type,
  p_jornalista_id         in  midiaclip.materia_jornal.jornalista_id%type,
  p_categoria_id          in  midiaclip.materia_jornal.categoria_id%type,
  p_impacto_id            in  midiaclip.materia_jornal.impacto_id%type,
  p_pagina                in  midiaclip.materia_jornal.pagina%type,
  p_qtde_coluna           in  midiaclip.materia_jornal.qtde_coluna%type,
  p_centimetragem         in  midiaclip.materia_jornal.centimetragem%type,
  p_total                 in  midiaclip.materia_jornal.total%type,
  p_noticia               in  midiaclip.materia_jornal.noticia%type,
  p_sinopse               in  midiaclip.materia_jornal.sinopse%type,
  p_custo_pub             in  midiaclip.materia_jornal.custo_pub%type
)
as
  vNoticias  clob;
  vNoticiasSize  binary_integer;
begin
  begin
    update midiaclip.materia_jornal
                              set titulo_materia           = trim(p_titulo_materia),
                                  data_materia             = p_data_materia,
                                  canal_comunicacao_id     = p_canal_comunicacao_id,
                                  usuario_id               = p_usuario_id,
                                  editoria_id              = p_editoria_id,
                                  coluna_id                = p_coluna_id, 
                                  jornalista_id            = p_jornalista_id,
                                  categoria_id             = p_categoria_id,
                                  impacto_id               = p_impacto_id,
                                  pagina                   = p_pagina,
                                  qtde_coluna              = p_qtde_coluna,
                                  centimetragem            = p_centimetragem,
                                  total                    = p_total,
                                  noticia                  = empty_clob(),
                                  sinopse                  = trim(p_sinopse),
                                  custo_pub                = p_custo_pub
                      where materia_jornal_id              = p_materia_jornal_id;
                      
     select noticia 
       into vNoticias
        from midiaclip.materia_jornal
         where  materia_jornal_id = p_materia_jornal_id;
    
     
	 vNoticiasSize := length(trim(p_noticia));
    
    dbms_lob.write(vNoticias, vNoticiasSize, 1, p_noticia);  
  end; 
end prc_upd_materia_jornal;  
 
-------------------------- Fim Package -------------------->
end pkg_materia;
/
