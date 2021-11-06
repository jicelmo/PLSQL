create or replace package pkg_canal_comunicacao
is

function fnc_canal_comunicacao_id
(
  p_canal_comunicacao        in midiaclip.canal_comunicacao.canal_comunicacao%type
) return number;

procedure prc_get_canal_comunicacao
(
  p_canal_comunicacao        in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal               in  midiaclip.tipo_canal.tipo_canal%type,
  p_praca                    in  midiaclip.praca.praca%type,
  p_retorno                  out pkg_refcursor.c_cursor
);

procedure prc_ins_canal_comunicacao
(
  p_canal_comunicacao        in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal               in midiaclip.tipo_canal.tipo_canal%type,
  p_praca                    in midiaclip.praca.praca%type,
  p_sigla                    in midiaclip.canal_comunicacao.sigla%type
);

procedure prc_upd_canal_comunicacao
(
  p_canal_comunicacao_id     in midiaclip.canal_comunicacao.canal_comunicacao_id%type,
  p_canal_comunicacao        in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal               in midiaclip.tipo_canal.tipo_canal%type,
  p_praca                    in midiaclip.praca.praca%type,
  p_sigla                    in midiaclip.canal_comunicacao.sigla%type
);

procedure prc_del_canal_comunicacao
(
  p_canal_comunicacao_id     in midiaclip.canal_comunicacao.canal_comunicacao_id%type
);

---------------------------------- Fim da Package --------------------->
end pkg_canal_comunicacao;
/
create or replace package body pkg_canal_comunicacao
is

/**************************************
 nome       : fnc_canal_comunicacao_id
 proposito  : Retorna o canal_comunicacao_id
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
function fnc_canal_comunicacao_id
(
  p_canal_comunicacao        in midiaclip.canal_comunicacao.canal_comunicacao%type
) return number
is
 v_canal_comunicaco_id      number;
begin
 begin
   select canal_comunicacao_id
    into v_canal_comunicaco_id
     from midiaclip.canal_comunicacao
      where canal_comunicacao = trim(upper(p_canal_comunicacao));
  return (v_canal_comunicaco_id);
 end;
 -------- Exception ------------>
exception
 when no_data_found then
  raise_application_error (-20000, 'Canal de Comunicação: '||p_canal_comunicacao||' não encontrado ');
end fnc_canal_comunicacao_id;

/**************************************
 nome       : prc_get_canal_comunicacao
 proposito  : Retorna lista do canal_comunicacao
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
procedure prc_get_canal_comunicacao
(
  p_canal_comunicacao        in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal               in  midiaclip.tipo_canal.tipo_canal%type,
  p_praca                    in  midiaclip.praca.praca%type,
  p_retorno                  out pkg_refcursor.c_cursor
)
is
  vSql          pkg_refcursor.v_sql%type;
  vParametro    pkg_refcursor.v_parametros%type;
begin
  vSql := vSql||
                 ' select cm.canal_comunicacao_id, tc.tipo_canal, p.praca, cm.canal_comunicacao, cm.sigla
                    from midiaclip.praca p
                     inner join midiaclip.canal_comunicacao cm    on p.praca_id        = cm.praca_id
                     inner join midiaclip.tipo_canal        tc    on cm.tipo_canal_id  = tc.tipo_canal_id
                      where cm.canal_comunicacao like trim(upper('''||'%'||p_canal_comunicacao||'%'||'''))';

----------- Tipo Canal ------------>
 if p_tipo_canal is not null then
   vParametro := vParametro ||
                              ' and tc.tipo_canal_id = '|| pkg_tipo_canal.fnc_get_tipo_canal_id(p_tipo_canal);
 end if;
----------- Praça ------------>
 if p_praca is not null then
   vParametro := vParametro ||
                              ' and p.praca_id = '||pkg_praca.fnc_get_praca_id(p_praca);
 end if;
   vParametro := vParametro ||' order by fnc_remove_acento(cm.canal_comunicacao)';
------------- Cursor --------------------->
 if vParametro is not null then
  vSql := vSql || vParametro;
 end if;

 open p_retorno for vSql;
end prc_get_canal_comunicacao;


/**************************************
 nome       : prc_ins_canal_comunicacao
 proposito  : Cadastra o canal_comunicacao
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
procedure prc_ins_canal_comunicacao
(
  p_canal_comunicacao        in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal               in midiaclip.tipo_canal.tipo_canal%type,
  p_praca                    in midiaclip.praca.praca%type,
  p_sigla                    in midiaclip.canal_comunicacao.sigla%type
)
is
begin
 begin
   insert into midiaclip.canal_comunicacao
   (
     canal_comunicacao_id, tipo_canal_id, praca_id, canal_comunicacao, sigla
   )
   values
   (
     seq_canal_comunicacao.nextval,
     pkg_tipo_canal.fnc_get_tipo_canal_id(p_tipo_canal),
     pkg_praca.fnc_get_praca_id(p_praca),
     trim(upper(p_canal_comunicacao)),
     trim(upper(p_sigla))
   );
 end;
------------ Exception ----------->
exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Canal de Comunicação : '||p_canal_comunicacao||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_canal_comunicacao;


/**************************************
 nome       : prc_upd_canal_comunicacao
 proposito  : Atualiza os dados canal de comunicação
 author     : jicelmo andrade
 criado     : 24/12/2008
***************************************/
procedure prc_upd_canal_comunicacao
(
  p_canal_comunicacao_id     in midiaclip.canal_comunicacao.canal_comunicacao_id%type,
  p_canal_comunicacao        in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_tipo_canal               in midiaclip.tipo_canal.tipo_canal%type,
  p_praca                    in midiaclip.praca.praca%type,
  p_sigla                    in midiaclip.canal_comunicacao.sigla%type
)
is
begin
  update midiaclip.canal_comunicacao
               set canal_comunicacao     = trim(upper(p_canal_comunicacao)),
                   tipo_canal_id         = pkg_tipo_canal.fnc_get_tipo_canal_id(p_tipo_canal),
                   praca_id              = pkg_praca.fnc_get_praca_id(p_praca),
                   sigla                 = trim(upper(p_sigla))
             where canal_comunicacao_id  = p_canal_comunicacao_id;

---------------- Exception ----------->
exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Canal de Comunicação : '||p_canal_comunicacao||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_canal_comunicacao;


/**************************************
 nome       : prc_del_canal_comunicacao
 proposito  : Excluir Canal de Cpmunicação
 author     : jicelmo andrade
 criado     : 24/12/2008
***************************************/
procedure prc_del_canal_comunicacao
(
  p_canal_comunicacao_id     in midiaclip.canal_comunicacao.canal_comunicacao_id%type
)
is
begin
  delete from midiaclip.canal_comunicacao
   where canal_comunicacao_id = p_canal_comunicacao_id;
 -------------Exception ----------------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O Canal Comunicação não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end;
------------------------------ Fim da Package --------------------->
end pkg_canal_comunicacao;
/
