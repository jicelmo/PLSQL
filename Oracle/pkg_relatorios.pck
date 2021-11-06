create or replace package pkg_relatorios
is
/**************************************
  Package para gerar os Relatórios do sistema
   MDClip
***************************************/

function fnc_graf_categoria
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_impacto_id           in  number,
  p_canal_comunicacao_id in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_graf_impacto
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_graf_materia_emissora
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_graf_clip_data
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_canal_comunicacao_id in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_graf_impacto_duracao
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_graf_midia_geral
(
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_categoria_id         in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_rel_mensuracao_rtv
(
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

function fnc_rel_mensuracao_jornal
(
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
) return pkg_refcursor.c_cursor;

end pkg_relatorios;
/
create or replace package body pkg_relatorios
is

/**************************************
 nome       : fnc_graf_categoria
 proposito  : Relatorio de Radio / TV / Jornal por Categoria
 author     : Jicelmo Andrade
 criado     : 01/12/2009
***************************************/
function fnc_graf_categoria
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_impacto_id           in  number,
  p_canal_comunicacao_id in number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
  vSql := vSql ||
                  ' select c.categoria, count(*) as total
                      from midiaclip.categoria c
                  ';
----------------- Tipo Veiculo ------------->
     if p_tipo_veiculo = 2 then
      vSql := vSql ||
                   ' inner join midiaclip.materia_jornal    mj     on c.categoria_id          = mj.categoria_id
                     inner join midiaclip.canal_comunicacao cm     on mj.canal_comunicacao_id = cm.canal_comunicacao_id
                       and cm.tipo_canal_id = 8
                   ';
     else
      vSql := vSql ||
                   ' inner join midiaclip.materia           m      on c.categoria_id         = m.categoria_id
                     inner join midiaclip.canal_comunicacao cm     on m.canal_comunicacao_id = cm.canal_comunicacao_id
                   ';
       ---- Tipo de Canall -------->
        if p_tipo_veiculo = 0 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 9 ';
        elsif p_tipo_veiculo = 1 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 6 ';
        end if;
     end if;
  ------------------------ Filtros -------------------->
   ----------- Cliente ------------->
   if p_cliente_id  != 0 then
     if p_tipo_veiculo = 2 then
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_clientes_jornal cj on  mj.materia_jornal_id = cj.materia_jornal_id
                          and cj.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and cj.cliente_indice_id = '||p_tipo_cliente;
          end if;

     else
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_materia_clientes  mc  on m.materia_id = mc.materia_id
                          and mc.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and mc.cliente_indice_id = '||p_tipo_cliente;
          end if;
     end if;
   end if;

 if p_tipo_veiculo = 2 then
   vSql := vSql ||
                  ' where materia_jornal_id > 0 ';
 else
   vSql := vSql ||
                  ' where materia_id > 0 ';
 end if;

   ------ Programa -------->
   if p_programa_id != 0 then
     vSql := vSql ||
                     ' and programa_id = '||p_programa_id;
   end if;
   ---------- Canal de Comunicacao ------->
   if p_canal_comunicacao_id  != 0 then
     vSql := vSql ||
                     ' and cm.canal_comunicacao_id = '||p_canal_comunicacao_id;
   end if;

   ----------------- Impacto ------------->
   if p_impacto_id != 0 then
       vSql := vSql ||
                      ' and impacto_id = '||p_impacto_id;
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
     if p_tipo_veiculo = 2 then
          vSql  := vSql ||
                          ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     else
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     end if;
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' group by categoria
                     order by fnc_remove_acento(categoria) ';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;
end fnc_graf_categoria;

/**************************************
 nome       : fnc_graf_Impacto
 proposito  : Relatorio de Radio / TV / Jornal por Impacto
 author     : Jicelmo Andrade
 criado     : 01/12/2009
***************************************/

function fnc_graf_impacto
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
  vSql := vSql ||
                  ' select c.impacto, count(*) as total
                      from midiaclip.impacto c
                  ';
----------------- Tipo Veiculo ------------->
     if p_tipo_veiculo = 2 then
      vSql := vSql ||
                   ' inner join midiaclip.materia_jornal    mj     on c.impacto_id          = mj.impacto_id
                     inner join midiaclip.canal_comunicacao cm     on mj.canal_comunicacao_id = cm.canal_comunicacao_id
                       and cm.tipo_canal_id = 8
                   ';
     else
      vSql := vSql ||
                   ' inner join midiaclip.materia           m      on c.impacto_id         = m.impacto_id
                     inner join midiaclip.canal_comunicacao cm     on m.canal_comunicacao_id = cm.canal_comunicacao_id
                   ';
       ---- Tipo de Canall -------->
        if p_tipo_veiculo = 0 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 9 ';
        elsif p_tipo_veiculo = 1 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 6 ';
        end if;
     end if;
  ------------------------ Filtros -------------------->
   ----------- Cliente ------------->
   if p_cliente_id  != 0 then
     if p_tipo_veiculo = 2 then
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_clientes_jornal cj on  mj.materia_jornal_id = cj.materia_jornal_id
                          and cj.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and cj.cliente_indice_id = '||p_tipo_cliente;
          end if;

     else
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_materia_clientes  mc  on m.materia_id = mc.materia_id
                          and mc.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and mc.cliente_indice_id = '||p_tipo_cliente;
          end if;
     end if;
   end if;

 if p_tipo_veiculo = 2 then
   vSql := vSql ||
                  ' where materia_jornal_id > 0 ';
 else
   vSql := vSql ||
                  ' where materia_id > 0 ';
 end if;

   ------ Programa -------->
   if p_programa_id != 0 then
     vSql := vSql ||
                     ' and programa_id = '||p_programa_id;
   end if;
   ---------- Canal de Comunicacao ------->
   if p_canal_comunicacao_id  != 0 then
     vSql := vSql ||
                     ' and cm.canal_comunicacao_id = '||p_canal_comunicacao_id;
   end if;
   ----------------- Impacto ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
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
     if p_tipo_veiculo = 2 then
          vSql  := vSql ||
                          ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     else
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     end if;
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' group by impacto
                     order by fnc_remove_acento(impacto) ';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;
end fnc_graf_impacto;

/**************************************
 nome       : fnc_graf_materia_emissora
 proposito  : Relatorio de Radio / TV / Jornal Materis x Emissora
 author     : Jicelmo Andrade
 criado     : 01/12/2009
***************************************/
function fnc_graf_materia_emissora
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
  vSql := vSql ||
                  ' select c.canal_comunicacao, count(*) as total
                      from midiaclip.canal_comunicacao c
                  ';
----------------- Tipo Veiculo ------------->
     if p_tipo_veiculo = 2 then
      vSql := vSql ||
                   ' inner join midiaclip.materia_jornal    mj     on c.canal_comunicacao_id   = mj.canal_comunicacao_id
                       and c.tipo_canal_id = 8
                   ';
     else
      vSql := vSql ||
                   ' inner join midiaclip.materia           m      on c.canal_comunicacao_id   = m.canal_comunicacao_id ';

       ---- Tipo de Canall -------->
        if p_tipo_veiculo = 0 then
          vSql := vSql ||
                         ' and c.tipo_canal_id = 9 ';
        elsif p_tipo_veiculo = 1 then
          vSql := vSql ||
                         ' and c.tipo_canal_id = 6 ';
        end if;
     end if;
  ------------------------ Filtros -------------------->
   ----------- Cliente ------------->
   if p_cliente_id  != 0 then
     if p_tipo_veiculo = 2 then
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_clientes_jornal cj on  mj.materia_jornal_id = cj.materia_jornal_id
                          and cj.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and cj.cliente_indice_id = '||p_tipo_cliente;
          end if;

     else
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_materia_clientes  mc  on m.materia_id = mc.materia_id
                          and mc.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and mc.cliente_indice_id = '||p_tipo_cliente;
          end if;
     end if;
   end if;

 if p_tipo_veiculo = 2 then
   vSql := vSql ||
                  ' where materia_jornal_id > 0 ';
 else
   vSql := vSql ||
                  ' where materia_id > 0 ';
 end if;

   ------ Programa -------->
   if p_programa_id != 0 then
     vSql := vSql ||
                     ' and programa_id = '||p_programa_id;
   end if;
   ---------- Impacto ------->
   if p_impacto_id  != 0 then
     vSql := vSql ||
                     ' and impacto_id = '||p_impacto_id;
   end if;

   ----------------- categoria ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
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
     if p_tipo_veiculo = 2 then
          vSql  := vSql ||
                          ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     else
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     end if;
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' group by canal_comunicacao
                     order by fnc_remove_acento(canal_comunicacao) ';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;
end fnc_graf_materia_emissora;

/**************************************
 nome       : fnc_graf_clip_dataa
 proposito  : Relatorio de Radio / TV / Jornal Materias x Dia
 author     : Jicelmo Andrade
 criado     : 01/12/2009
***************************************/
function fnc_graf_clip_data
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_canal_comunicacao_id in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------- Tipo Veiculo ------------->
     if p_tipo_veiculo = 2 then
      vSql := vSql ||
                    ' select fnc_trunc_data(mj.data_materia) as data, count(*) as total
                       from midiaclip.materia_jornal mj
                        inner join midiaclip.canal_comunicacao cm     on mj.canal_comunicacao_id = cm.canal_comunicacao_id
                          and cm.tipo_canal_id = 8
                   ';
     else
      vSql := vSql ||
                    ' select fnc_trunc_data(m.data_hora) as data, count(*) as total
                       from midiaclip.materia m
                         inner join midiaclip.canal_comunicacao cm on m.canal_comunicacao_id = cm.canal_comunicacao_id
                   ';
       ---- Tipo de Canall -------->
        if p_tipo_veiculo = 0 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 9 ';
        elsif p_tipo_veiculo = 1 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 6 ';
        end if;
     end if;
  ------------------------ Filtros -------------------->
   ----------- Cliente ------------->
   if p_cliente_id  != 0 then
     if p_tipo_veiculo = 2 then
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_clientes_jornal cj on  mj.materia_jornal_id = cj.materia_jornal_id
                          and cj.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and cj.cliente_indice_id = '||p_tipo_cliente;
          end if;

     else
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_materia_clientes  mc  on m.materia_id = mc.materia_id
                          and mc.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and mc.cliente_indice_id = '||p_tipo_cliente;
          end if;
     end if;
   end if;

 if p_tipo_veiculo = 2 then
   vSql := vSql ||
                  ' where materia_jornal_id > 0 ';
 else
   vSql := vSql ||
                  ' where materia_id > 0 ';
 end if;
   ------ Programa -------->
   if p_programa_id != 0 then
     vSql := vSql ||
                     ' and programa_id = '||p_programa_id;
   end if;
   ---------- Canal de Comunicacao ------->
   if p_canal_comunicacao_id  != 0 then
     vSql := vSql ||
                     ' and cm.canal_comunicacao_id = '||p_canal_comunicacao_id;
   end if;

   ----------------- Categoria ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
   end if;
   --------------- Impacto ---------->
   if p_impacto_id != 0 then
       vSql := vSql ||
                      ' and impacto_id = '||p_impacto_id;
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
     if p_tipo_veiculo = 2 then
          vSql  := vSql ||
                          ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     else
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     end if;
    end if;
------------------- Agrupando ---------->
  if p_tipo_veiculo = 2 then
   vSql := vSql ||
                   ' group by data_materia
                     order by to_date (data_materia,''dd/mm/yyyy'') ';
  else
   vSql := vSql ||
                   ' group by data_hora
                     order by to_date(data_hora,''dd/mm/yyyy'')';
  end if;
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;
end fnc_graf_clip_data;

/**************************************
 nome       : fnc_graf_impacto_duracao
 proposito  : Relatorio de Radio / TV / Jornal Materias x Duração
 author     : Jicelmo Andrade
 criado     : 01/12/2009
***************************************/
function fnc_graf_impacto_duracao
(
  p_tipo_veiculo         in  number,
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
  vSql := vSql ||
               '  select impacto, fnc_total_duracao(duracao) as duracao, duracao as segundos, total
                    from
                        (
                           select c.impacto, sum(fnc_converte_hora_segundos(m.duracao)) as duracao, count(*) as total
                              from midiaclip.impacto c
                        ';
----------------- Tipo Veiculo ------------->
     if p_tipo_veiculo = 2 then
      vSql := vSql ||
                   ' inner join midiaclip.materia_jornal    mj     on c.impacto_id          = mj.impacto_id
                     inner join midiaclip.canal_comunicacao cm     on mj.canal_comunicacao_id = cm.canal_comunicacao_id
                       and cm.tipo_canal_id = 8
                   ';
     else
      vSql := vSql ||
                   ' inner join midiaclip.materia           m      on c.impacto_id         = m.impacto_id
                     inner join midiaclip.canal_comunicacao cm     on m.canal_comunicacao_id = cm.canal_comunicacao_id
                   ';
       ---- Tipo de Canall -------->
        if p_tipo_veiculo = 0 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 9 ';
        elsif p_tipo_veiculo = 1 then
          vSql := vSql ||
                         ' and cm.tipo_canal_id = 6 ';
        end if;
     end if;
  ------------------------ Filtros -------------------->
   ----------- Cliente ------------->
   if p_cliente_id  != 0 then
     if p_tipo_veiculo = 2 then
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_clientes_jornal cj on  mj.materia_jornal_id = cj.materia_jornal_id
                          and cj.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and cj.cliente_indice_id = '||p_tipo_cliente;
          end if;

     else
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_materia_clientes  mc  on m.materia_id = mc.materia_id
                          and mc.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and mc.cliente_indice_id = '||p_tipo_cliente;
          end if;
     end if;
   end if;

 if p_tipo_veiculo = 2 then
   vSql := vSql ||
                  ' where materia_jornal_id > 0 ';
 else
   vSql := vSql ||
                  ' where materia_id > 0 ';
 end if;

   ------ Programa -------->
   if p_programa_id != 0 then
     vSql := vSql ||
                     ' and programa_id = '||p_programa_id;
   end if;
   ---------- Canal de Comunicacao ------->
   if p_canal_comunicacao_id  != 0 then
     vSql := vSql ||
                     ' and cm.canal_comunicacao_id = '||p_canal_comunicacao_id;
   end if;
   ----------------- Impacto ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
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
     if p_tipo_veiculo = 2 then
          vSql  := vSql ||
                          ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     else
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
     end if;
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' group by impacto
                     order by fnc_remove_acento(impacto)
                   )';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;
end fnc_graf_impacto_duracao;

/**************************************
 nome       : fnc_graf_midia_geral
 proposito  : Grafico todas as midias ( radio, tv, jornal )
 author     : Jicelmo Andrade
 criado     : 01/12/2009
***************************************/
function fnc_graf_midia_geral
(
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_categoria_id         in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
  vSql := vSql ||
                  '  select tc.tipo_canal, count(*) as total
                       from midiaclip.v$_listagem_materia_rtv_jornal m
                         inner join midiaclip.canal_comunicacao  c  on m.canal_comunicacao_id = c.canal_comunicacao_id
                         inner join midiaclip.tipo_canal         tc on c.tipo_canal_id        = tc.tipo_canal_id
                  ';
   ----------- Cliente ------------->
   if p_cliente_id  != 0 then
       vSql := vSql ||
                      ' inner join midiaclip.v$_listagem_clientes_jornal cj on  mj.materia_jornal_id = cj.materia_jornal_id
                          and cj.cliente_id = '||p_cliente_id||
                      ' inner join midiaclip.v$_listagem_materia_clientes  mc  on m.materia_id = mc.materia_id
                          and mc.cliente_id = '||p_cliente_id;

          if p_tipo_cliente != 3 then
           vSql := vSql ||
                          ' and cj.cliente_indice_id = '||p_tipo_cliente;
          end if;
   end if;

   vSql := vSql ||
                  ' where materia_id > 0 ';
   ---------- Impacto ------->
   if p_impacto_id  != 0 then
     vSql := vSql ||
                     ' and impacto_id = '||p_impacto_id;
   end if;

   ----------------- categoria ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
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
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' group by tc.tipo_canal';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;

end fnc_graf_midia_geral;

/**************************************
 nome       : fnc_rel_mensuracao
 proposito  : relatorio menusração midias ( radio, tv, jornal )
 author     : Jicelmo Andrade
 criado     : 17/01/2010
***************************************/

function fnc_rel_mensuracao_rtv
(
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
   vSql := vSql ||
    ' select m.data_hora, lc.cliente, cc.canal_comunicacao as emissora, p.programa, m.duracao, 
             midiaclip.fnc_custo_pub(m.duracao, p.custo_pub) as custo_pub
       from midiaclip.materia m 
         inner join midiaclip.canal_comunicacao            cc  on m.canal_comunicacao_id = cc.canal_comunicacao_id
         inner join midiaclip.programa                     p   on m.programa_id          = p.programa_id
         inner join midiaclip.v$_listagem_materia_clientes mc  on m.materia_id           = mc.materia_id
           and mc.cliente_indice_id = '||p_tipo_cliente|| 
   '     inner join midiaclip.v$_listagem_clientes         lc  on mc.cliente_id          = lc.cliente_id
           and lc.cliente_indice_id = '||p_tipo_cliente||
   '      where materia_id > 0 
          and  mc.cliente_id = '||p_cliente_id||
   '      and  lc.cliente_id = '||p_cliente_id; 

   ---------- Impacto ------->
   if p_impacto_id  != 0 then
     vSql := vSql ||
                     ' and impacto_id = '||p_impacto_id;
   end if;

   ----------------- categoria ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
   end if;
   
   ---------------- programa -----------
   if p_programa_id != 0 then
       vSql := vSql ||
                      ' and m.programa_id = '||p_programa_id;
   end if;  

   ---------------- Emissora -----------
   if p_canal_comunicacao_id != 0 then
       vSql := vSql ||
                      ' and m.canal_comunicacao_id = '||p_canal_comunicacao_id;
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
          vSql  := vSql ||
                          ' and data_hora between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' order by to_date(data_hora, ''dd/mm/yyyy'') desc ';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;

end fnc_rel_mensuracao_rtv;

/**************************************
 nome       : fnc_rel_mensuracao_jornal
 proposito  : relatorio menusração midias ( radio, tv, jornal )
 author     : Jicelmo Andrade
 criado     : 17/01/2010
***************************************/

function fnc_rel_mensuracao_jornal
(
  p_tipo_cliente         in  number,
  p_cliente_id           in  number,
  p_programa_id          in  number,
  p_categoria_id         in  number,
  p_canal_comunicacao_id in  number,
  p_impacto_id           in  number,
  p_data_inicio          in  varchar2,
  p_data_fim             in  varchar2
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
----------------------------------->
   vSql := vSql ||
    ' select m.data_materia, lc.cliente, cc.canal_comunicacao as emissora, e.editoria, m.total as area, 
             midiaclip.fnc_custo_pub_jornal(m.total, e.custo_pub) as custo_pub
       from midiaclip.materia_jornal m 
         inner join midiaclip.canal_comunicacao            cc  on m.canal_comunicacao_id = cc.canal_comunicacao_id
         inner join midiaclip.editoria                     e   on m.editoria_id          = e.editoria_id
         inner join midiaclip.v$_listagem_clientes_jornal  mc  on m.materia_jornal_id    = mc.materia_jornal_id
           and mc.cliente_indice_id = '||p_tipo_cliente|| 
   '     inner join midiaclip.v$_listagem_clientes         lc  on mc.cliente_id          = lc.cliente_id
           and lc.cliente_indice_id = '||p_tipo_cliente||
   '      where materia_jornal_id > 0 
          and  mc.cliente_id = '||p_cliente_id||
   '      and  lc.cliente_id = '||p_cliente_id; 

   ---------- Impacto ------->
   if p_impacto_id  != 0 then
     vSql := vSql ||
                     ' and impacto_id = '||p_impacto_id;
   end if;

   ----------------- categoria ------------->
   if p_categoria_id != 0 then
       vSql := vSql ||
                      ' and categoria_id = '||p_categoria_id;
   end if;
   
   ---------------- programa -----------
   if p_programa_id != 0 then
       vSql := vSql ||
                      ' and m.editoria_id = '||p_programa_id;
   end if;  

   ---------------- Emissora -----------
   if p_canal_comunicacao_id != 0 then
       vSql := vSql ||
                      ' and m.canal_comunicacao_id = '||p_canal_comunicacao_id;
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
          vSql  := vSql ||
                          ' and data_materia between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;
------------------- Agrupando ---------->
   vSql := vSql ||
                   ' order by to_date(data_materia, ''dd/mm/yyyy'') desc ';
------------------- Retorna Dados ------------>
 open vDataSet for vsql;
 return vDataSet;

end fnc_rel_mensuracao_jornal;

end pkg_relatorios;
/
