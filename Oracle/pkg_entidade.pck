create or replace package pkg_entidade
is

function fnc_get_entidade_id
(
   p_entidade     in   midiaclip.entidades.entidade%type
) return number;

procedure prc_get_entidade
(
   p_entidade     in   midiaclip.entidades.entidade%type,
   p_municipio    in   midiaclip.municipio.municipio%type,
   p_uf           in   midiaclip.estado.uf%type,
   p_status       in   midiaclip.entidades.status%type,
   p_query        out  midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_entidade
(
   p_municipio        in midiaclip.municipio.municipio%type,
   p_entidade         in midiaclip.entidades.entidade%type,
   p_fantasia         in midiaclip.entidades.fantasia%type,
   p_cnpj_cpf         in midiaclip.entidades.cnpj_cpf%type,
   p_telefone         in midiaclip.entidades.telefone%type,
   p_fax              in midiaclip.entidades.fax%type,
   p_site             in midiaclip.entidades.site%type,
   p_status           in midiaclip.entidades.status%type,
   p_endereco         in midiaclip.endereco.endereco%type,
   p_complemento      in midiaclip.endereco.complemento%type,
   p_bairro           in midiaclip.endereco.bairro%type,
   p_cep              in midiaclip.endereco.cep%type,
   p_template         in midiaclip.entidades.template_html%type 
);

procedure prc_upd_entidade
(
   p_entidade_id      in midiaclip.entidades.entidade_id%type,
   p_endereco_id      in midiaclip.endereco.endereco_id%type,
   p_municipio        in midiaclip.municipio.municipio%type,
   p_entidade         in midiaclip.entidades.entidade%type,
   p_fantasia         in midiaclip.entidades.fantasia%type,
   p_cnpj_cpf         in midiaclip.entidades.cnpj_cpf%type,
   p_telefone         in midiaclip.entidades.telefone%type,
   p_fax              in midiaclip.entidades.fax%type,
   p_site             in midiaclip.entidades.site%type,
   p_status           in midiaclip.entidades.status%type,
   p_endereco         in midiaclip.endereco.endereco%type,
   p_complemento      in midiaclip.endereco.complemento%type,
   p_bairro           in midiaclip.endereco.bairro%type,
   p_cep              in midiaclip.endereco.cep%type,
   p_template         in midiaclip.entidades.template_html%type
);

procedure prc_del_entidade
(
  p_entidade_id      in midiaclip.entidades.entidade_id%type
);

procedure prc_ins_endereco
(
   p_municipio_id       in midiaclip.endereco.municipio_id%type,
   p_entidade_id        in midiaclip.endereco.endereco_id%type,
   p_endereco           in midiaclip.endereco.endereco%type,
   p_complemento        in midiaclip.endereco.complemento%type,
   p_bairro             in midiaclip.endereco.bairro%type,
   p_cep                in midiaclip.endereco.cep%type
);

procedure prc_upd_endereco
(
   p_municipio_id       in midiaclip.endereco.municipio_id%type,
   p_endereco_id        in midiaclip.endereco.endereco_id%type,
   p_entidade_id        in midiaclip.endereco.endereco_id%type,
   p_endereco           in midiaclip.endereco.endereco%type,
   p_complemento        in midiaclip.endereco.complemento%type,
   p_bairro             in midiaclip.endereco.bairro%type,
   p_cep                in midiaclip.endereco.cep%type
);

procedure prc_del_endereco
(
  p_endereco_id       in midiaclip.endereco.endereco_id%type
);

end pkg_entidade;
/
create or replace package body pkg_entidade
is

/**************************************
 nome       : fnc_get_entidade_id
 proposito  : Retorna o entidade_id ta tabela de entidade
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
function fnc_get_entidade_id
(
   p_entidade     in   midiaclip.entidades.entidade%type
) return number
is
 v_entidade_id   number;
begin

 begin
   select entidade_id
    into v_entidade_id
     from midiaclip.entidades
      where entidade = trim(upper(p_entidade));
   return (v_entidade_id);
 end;
 ------------------ Exception ------------->
 exception
   when no_data_found then
    raise_application_error(-20000, 'Entidade : '||p_entidade||' não encontrada');
end fnc_get_entidade_id;

/**************************************
 nome       : prc_get_entidade
 proposito  : Retorna lista de entidades
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_get_entidade
(
   p_entidade     in   midiaclip.entidades.entidade%type,
   p_municipio    in   midiaclip.municipio.municipio%type,
   p_uf           in   midiaclip.estado.uf%type,
   p_status       in   midiaclip.entidades.status%type,
   p_query        out  midiaclip.pkg_refcursor.c_cursor
)
is
 vsql            midiaclip.pkg_refcursor.v_sql%type;
begin
  vsql := vsql ||
      ' select /*+ no_cpu_costing */ e.entidade_id, e.municipio_id, e.entidade, e.fantasia, fnc_frm_cnpj(e.cnpj_cpf) as cnpj_cpf,
          e.telefone, e.fax, e.site, m.municipio, es.uf, en.endereco, en.complemento, fnc_frm_cep(en.cep) as cep,
          en.bairro, en.tp_endereco, case
                                       when e.status = 0 then '''||'BLOQUEADO'''||'

                                       when e.status = 1 then '''||'ATIVO'''||'
                                     end as status, en.endereco_id, e.template_html
        from midiaclip.estado es
         inner join midiaclip.municipio  m  on  es.estado_id    =  m.estado_id
         inner join midiaclip.entidades  e  on  m.municipio_id  =  e.municipio_id
         inner join midiaclip.endereco   en on  e.entidade_id   =  en.entidade_id
          where e.entidade like fnc_remove_acento(upper('''||'%'''''||p_entidade||'''''%'||'''))
      ';

   if p_municipio is not null then
     vsql := vsql || ' and m.municipio = upper('''||p_municipio||''')';
   end if;

   if p_uf is not null then
     vsql := vsql || ' and es.uf = upper('''||p_uf||''')';
   end if;

   if p_status is not null then
     vsql := vsql || ' and e.status = '||p_status;
   end if;

    vsql :=  vsql || ' order by fnc_remove_acento (e.entidade)';

  open p_query for vsql;
end prc_get_entidade;

/**************************************
 nome       : prc_ins_endereco
 proposito  : Cadastra Entidades
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_ins_endereco
(
   p_municipio_id       in midiaclip.endereco.municipio_id%type,
   p_entidade_id        in midiaclip.endereco.endereco_id%type,
   p_endereco           in midiaclip.endereco.endereco%type,
   p_complemento        in midiaclip.endereco.complemento%type,
   p_bairro             in midiaclip.endereco.bairro%type,
   p_cep                in midiaclip.endereco.cep%type
)
is
begin

 begin
   insert into midiaclip.endereco
   (
     endereco_id, entidade_id, municipio_id, cep, endereco, complemento,
     bairro, tp_endereco
   )
   values
   (
     seq_endereco.nextval,
     p_entidade_id,
     p_municipio_id,
     p_cep,
     trim(p_endereco),
     trim(p_complemento),
     trim(upper(p_bairro)),
     0
   );
 end;

exception
 when others then
  if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Endereco : '||p_endereco||' já existe, operação abortada');
  else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
  end if;
end prc_ins_endereco;

/**************************************
 nome       : prc_upd_endereco
 proposito  : Atualiza Endereco
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_upd_endereco
(
   p_municipio_id       in midiaclip.endereco.municipio_id%type,
   p_endereco_id        in midiaclip.endereco.endereco_id%type,
   p_entidade_id        in midiaclip.endereco.endereco_id%type,
   p_endereco           in midiaclip.endereco.endereco%type,
   p_complemento        in midiaclip.endereco.complemento%type,
   p_bairro             in midiaclip.endereco.bairro%type,
   p_cep                in midiaclip.endereco.cep%type
)
is
begin
  update midiaclip.endereco
      set   entidade_id     =  p_entidade_id,
            municipio_id    =  p_municipio_id,
            endereco        =  trim(p_endereco),
            complemento     =  trim(p_complemento),
            bairro          =  trim(p_bairro),
            cep             =  trim(p_cep)
     where  endereco_id     =  p_endereco_id;
end prc_upd_endereco;

procedure prc_del_endereco
(
  p_endereco_id       in midiaclip.endereco.endereco_id%type
)
is
begin
  delete from midiaclip.endereco
   where endereco_id = p_endereco_id;
 exception
  when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_del_endereco;

/**************************************
 nome       : prc_ins_entidade
 proposito  : Cadastra Entidades
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_ins_entidade
(
   p_municipio        in midiaclip.municipio.municipio%type,
   p_entidade         in midiaclip.entidades.entidade%type,
   p_fantasia         in midiaclip.entidades.fantasia%type,
   p_cnpj_cpf         in midiaclip.entidades.cnpj_cpf%type,
   p_telefone         in midiaclip.entidades.telefone%type,
   p_fax              in midiaclip.entidades.fax%type,
   p_site             in midiaclip.entidades.site%type,
   p_status           in midiaclip.entidades.status%type,
   p_endereco         in midiaclip.endereco.endereco%type,
   p_complemento      in midiaclip.endereco.complemento%type,
   p_bairro           in midiaclip.endereco.bairro%type,
   p_cep              in midiaclip.endereco.cep%type,
   p_template         in midiaclip.entidades.template_html%type
)
is
 cod_entidade  number;
begin
  begin
  ------ Gravando Entidade ------------->
    insert into midiaclip.entidades
    (
      entidade_id, municipio_id, entidade, fantasia, cnpj_cpf,
      telefone, fax, site, status, template_html
    )
    values
    (
      midiaclip.seq_entidade.nextval,
      pkg_municipio.fnc_get_municipio_id(p_municipio),
      trim(upper(p_entidade)), trim(upper(p_fantasia)),
      p_cnpj_cpf, trim(p_telefone), trim(p_fax), trim(lower(p_site)), p_status, trim(p_template)
    );
  end;
  ---- Gravando Endereco ------------->
  begin
    --- Pegando ID da Entidade
     select midiaclip.seq_entidade.currval
      into cod_entidade
       from dual;

    --- Cadastro Endereco ---------->
    prc_ins_endereco
                    (
                      pkg_municipio.fnc_get_municipio_id(p_municipio),
                      cod_entidade,
                      p_endereco,
                      p_complemento,
                      p_bairro,
                      p_cep
                    );
 end;

exception
 when others then
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
end prc_ins_entidade;

/**************************************
 nome       : prc_upd_entidade
 proposito  : Atualiza Entidades
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_upd_entidade
(
   p_entidade_id      in midiaclip.entidades.entidade_id%type,
   p_endereco_id      in midiaclip.endereco.endereco_id%type,
   p_municipio        in midiaclip.municipio.municipio%type,
   p_entidade         in midiaclip.entidades.entidade%type,
   p_fantasia         in midiaclip.entidades.fantasia%type,
   p_cnpj_cpf         in midiaclip.entidades.cnpj_cpf%type,
   p_telefone         in midiaclip.entidades.telefone%type,
   p_fax              in midiaclip.entidades.fax%type,
   p_site             in midiaclip.entidades.site%type,
   p_status           in midiaclip.entidades.status%type,
   p_endereco         in midiaclip.endereco.endereco%type,
   p_complemento      in midiaclip.endereco.complemento%type,
   p_bairro           in midiaclip.endereco.bairro%type,
   p_cep              in midiaclip.endereco.cep%type,
   p_template         in midiaclip.entidades.template_html%type
)
is
begin
  --------- Atualiza Entidade ---------->
  update midiaclip.entidades
    set    municipio_id   =  pkg_municipio.fnc_get_municipio_id(p_municipio),
           entidade       =  trim(p_entidade),
           fantasia       =  trim(p_fantasia),
           cnpj_cpf       =  trim(p_cnpj_cpf),
           telefone       =  trim(p_telefone),
           fax            =  trim(p_fax),
           site           =  trim(lower(p_site)),
           status         =  p_status,
           template_html  =  trim(p_template)
    where  entidade_id    =  p_entidade_id;

  ----------- Atualiza Endereco ----------->
   prc_upd_endereco
                   (
                     pkg_municipio.fnc_get_municipio_id(p_municipio),
                     p_endereco_id,
                     p_entidade_id,
                     p_endereco,
                     p_complemento,
                     p_bairro,
                     p_cep
                   );

end prc_upd_entidade;

/**************************************
 nome       : prc_upd_entidade
 proposito  : Atualiza Entidades
 author     : jicelmo andrade
 criado     : 17/12/2008
***************************************/
procedure prc_del_entidade
(
  p_entidade_id     in midiaclip.entidades.entidade_id%type
)
is
begin
  delete from midiaclip.entidades
   where entidade_id = p_entidade_id;

exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'a entidade não pode ser excluida, pois existe registros filhos amarrado a ela');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_entidade;

end pkg_entidade;
/
