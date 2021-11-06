create or replace package pkg_dvd_backup
is

procedure prc_get_dvdbackup
(
  p_tipo               in  midiaclip.dvd_backup.tipo%type,
  p_canal              in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_midia              in  midiaclip.dvd_backup.midia%type,
  p_data_inicio        in  midiaclip.dvd_backup.data_inicio%type,
  p_data_fim           in  midiaclip.dvd_backup.data_fim%type,
  p_retorno            out pkg_refcursor.c_cursor
);

procedure prc_ins_dvdbackup
(
  p_tipo                in midiaclip.dvd_backup.tipo%type,
  p_emissora            in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_midia               in midiaclip.dvd_backup.midia%type,
  p_formato             in midiaclip.dvd_backup.formato%type,
  p_data_inicio         in midiaclip.dvd_backup.data_inicio%type,
  p_data_fim            in midiaclip.dvd_backup.data_fim%type,
  p_conteudo            in midiaclip.dvd_backup.conteudo%type,
  p_qualidade           in midiaclip.dvd_backup.qualidade%type,
  p_obs                 in midiaclip.dvd_backup.obs%type
);

procedure prc_upd_dvdbackup
(
  p_dvd_backup_id       in midiaclip.dvd_backup.dvd_backup_id%type,
  p_tipo                in midiaclip.dvd_backup.tipo%type,
  p_emissora            in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_midia               in midiaclip.dvd_backup.midia%type,
  p_formato             in midiaclip.dvd_backup.formato%type,
  p_data_inicio         in midiaclip.dvd_backup.data_inicio%type,
  p_data_fim            in midiaclip.dvd_backup.data_fim%type,
  p_conteudo            in midiaclip.dvd_backup.conteudo%type,
  p_qualidade           in midiaclip.dvd_backup.qualidade%type,
  p_obs                 in midiaclip.dvd_backup.obs%type
);

procedure prc_del_dvdbackup
(
  p_dvd_backup_id       in midiaclip.dvd_backup.dvd_backup_id%type
);

end pkg_dvd_backup;
/
create or replace package body pkg_dvd_backup
is

/**************************************
 NOME       : prc_get_dvdbackup
 PROPOSITO  : Retornar Listagem de DVD_Backup -------->
 AUTHOR     : Jicelmo Andrade
 CRIADO     : 19/09/2009
 HISTORICO  :
***************************************/

procedure prc_get_dvdbackup
(
  p_tipo               in  midiaclip.dvd_backup.tipo%type,
  p_canal              in  midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_midia              in  midiaclip.dvd_backup.midia%type,
  p_data_inicio        in  midiaclip.dvd_backup.data_inicio%type,
  p_data_fim           in  midiaclip.dvd_backup.data_fim%type,
  p_retorno            out pkg_refcursor.c_cursor
)
is
 vSql                  midiaclip.pkg_refcursor.v_sql%type;
 vData_inicio             boolean;
 vData_Fim                boolean;

begin

 ---------------- Periodo Entre Datas ------------------>

  vData_inicio :=  midiaclip.fnc_verifica_data(p_data_inicio);
  vData_Fim    :=  midiaclip.fnc_verifica_data(p_data_fim);
 ----------------------------------------------->

    vSql := vSql||
                   ' select dvd_backup_id,
                       case
                        when tipo = 1  then '||'''DVD'''||'
                        when tipo = 2  then '||'''BACKUP'''||'
                       end as tipo,
                       case
                        when midia = 1 then '||'''TV'''||'
                        when midia = 2 then '||'''RADIO'''||'
                       end as midia,
                       case
                        when formato = 1 then '||'''BRUTO'''||'
                        when formato = 2 then '||'''EDITADO'''||'
                       end as formato,
                       case
                        when qualidade = 1 then '||'''BOA'''||'
                        when qualidade = 2 then '||'''NORMAL'''||'
                        when qualidade = 3 then '||'''BAIXA'''||'
                        when qualidade = 4 then '||'''RUIM'''||'
                       end as qualidade, c.canal_comunicacao, data_inicio, data_fim, conteudo,
                       obs, data_cadastro, alias_id
                     from midiaclip.dvd_backup db
                       inner join midiaclip.canal_comunicacao c on db.canal_comunicacao_id = c.canal_comunicacao_id
                        where dvd_backup_id <> 0';
------ Tipo -------->
 if p_tipo is not null then
  vSql := vSql||
                ' and tipo = '||p_tipo;
 end if;
--------- Canal Comunicação ---------->
if p_canal is not null then
  vSql := vSql||
                ' and db.canal_comunicacao_id = '||pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_canal);
end if;
--------- Midia ----------------->
if p_midia is not null then
  vSql := vSql||
                ' and midia = '||p_midia;
end if;
------------------- Periodo Datas ----------------->
    if ( vData_inicio > vData_Fim ) then
      raise_application_error(-20000, 'Data Inicial não pode ser maior que data final verifique... ');
    end if;
--------- verifiapca parametros datas
    if ((vData_inicio = true ) and ( vData_Fim = true)) then
     vSql := vSql||
 --                  ' and to_date(data_inicio,''dd/mm/yyyy'') >= '||p_data_inicio||' and to_date(data_fim,''dd/mm/yyyy'') <= '||p_data_fim;
                     ' and data_inicio between to_date('''||p_data_inicio||''','''||'dd/mm/yyyy'') and to_date('''||p_data_fim||''','''||'dd/mm/yyyy'')';
    end if;
------------------< Ordenação >------------------>
 vSql := vSql ||
                 ' order by to_date(data_inicio,'''||'dd/mm/yyyy'') desc';   
------------------ listagem ------------->
open p_retorno for Vsql;
end prc_get_dvdbackup;

procedure prc_ins_dvdbackup
(
  p_tipo                in midiaclip.dvd_backup.tipo%type,
  p_emissora            in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_midia               in midiaclip.dvd_backup.midia%type,
  p_formato             in midiaclip.dvd_backup.formato%type,
  p_data_inicio         in midiaclip.dvd_backup.data_inicio%type,
  p_data_fim            in midiaclip.dvd_backup.data_fim%type,
  p_conteudo            in midiaclip.dvd_backup.conteudo%type,
  p_qualidade           in midiaclip.dvd_backup.qualidade%type,
  p_obs                 in midiaclip.dvd_backup.obs%type
)
is
begin

  begin
    insert into midiaclip.dvd_backup
    (
      dvd_backup_id, tipo, canal_comunicacao_id, midia, formato, data_inicio, data_fim,
      conteudo, qualidade, obs, data_cadastro, alias_id
    )
    values
    (
      seq_dvd_backup.nextval, p_tipo,
      pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_emissora),
      p_midia, p_formato, p_data_inicio, p_data_fim, p_conteudo, p_qualidade, p_obs,
      sysdate, to_char(sysdate, 'yyyy')||'.'||seq_dvd_backup.currval
    );
  end;

 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'DVD / Backup : '||p_tipo||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;

end prc_ins_dvdbackup;

procedure prc_upd_dvdbackup
(
  p_dvd_backup_id       in midiaclip.dvd_backup.dvd_backup_id%type,
  p_tipo                in midiaclip.dvd_backup.tipo%type,
  p_emissora            in midiaclip.canal_comunicacao.canal_comunicacao%type,
  p_midia               in midiaclip.dvd_backup.midia%type,
  p_formato             in midiaclip.dvd_backup.formato%type,
  p_data_inicio         in midiaclip.dvd_backup.data_inicio%type,
  p_data_fim            in midiaclip.dvd_backup.data_fim%type,
  p_conteudo            in midiaclip.dvd_backup.conteudo%type,
  p_qualidade           in midiaclip.dvd_backup.qualidade%type,
  p_obs                 in midiaclip.dvd_backup.obs%type
)
is
begin
  begin
    update midiaclip.dvd_backup
                            set tipo                    = p_tipo,
                                canal_comunicacao_id    = pkg_canal_comunicacao.fnc_canal_comunicacao_id(p_emissora),
                                midia                   = p_midia,
                                formato                 = p_formato,
                                data_inicio             = p_data_inicio,
                                data_fim                = p_data_fim,
                                conteudo                = p_conteudo,
                                qualidade               = p_qualidade,
                                obs                     = p_obs
                         where  dvd_backup_id           = p_dvd_backup_id;
  end;
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'DVD / Backup : '||p_tipo||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;

end prc_upd_dvdbackup;

procedure prc_del_dvdbackup
(
  p_dvd_backup_id       in midiaclip.dvd_backup.dvd_backup_id%type
)
is
begin
 delete from midiaclip.dvd_backup
  where dvd_backup_id = p_dvd_backup_id;

-------------- Exception ---------->
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);

end prc_del_dvdbackup;
--------------------------- Fim Pakage ---------------------->
end pkg_dvd_backup;
/
