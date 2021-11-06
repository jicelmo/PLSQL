create or replace package pkg_setor
is

function fnc_get_setor_id
(
  p_setor    in  midiaclip.setor.setor%type
) return number;

procedure prc_get_setor
(
  p_setor    in  midiaclip.setor.setor%type,
  p_retorno  out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_setor
(
  p_setor    in midiaclip.setor.setor%type,
  p_template in midiaclip.setor.template_html%type
);

procedure prc_upd_setor
(
  p_setor_id   in  midiaclip.setor.setor_id%type,
  p_setor      in  midiaclip.setor.setor%type,
  p_template   in  midiaclip.setor.template_html%type
);

procedure prc_del_setor
(
  p_setor_id   in  midiaclip.setor.setor_id%type
);

end pkg_setor;
/
create or replace package body pkg_setor
is

/**************************************
 nome       : fnc_get_setor_id
 proposito  : Retorna o setor_id da tabela midiaclip.setor
 author     : jicelmo andrade
 criado     : 12/12/2008
***************************************/
function fnc_get_setor_id
(
  p_setor    in  midiaclip.setor.setor%type
) return number
is
 v_setor_id   number := null;
begin
 -------- Localizando Setor_ID ---------->
 begin
   select setor_id
    into v_setor_id
     from midiaclip.setor
      where setor = trim(upper(p_setor));
   return (v_setor_id);
 end;
------------ Exceptions --------------->
  exception
   when no_data_found then
    raise_application_error(-20000, 'Setor : '||p_setor||' não encontrado');
end fnc_get_setor_id;

/**************************************
 nome       : prc_get_setor
 proposito  : Retorna Lista de Setor
 author     : jicelmo andrade
 criado     : 12/12/2008
***************************************/
procedure prc_get_setor
(
  p_setor    in  midiaclip.setor.setor%type,
  p_retorno  out midiaclip.pkg_refcursor.c_cursor
)
is
 vSql            midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql := vSql||
                ' select setor_id, setor, template_html
                   from midiaclip.setor
                    where setor like trim(upper('''||'%'||p_setor||'%'||'''))';

  open p_retorno for vsql;
end prc_get_setor;

/**************************************
 nome       : prc_ins_setor
 proposito  : Cadastra Setor
 author     : jicelmo andrade
 criado     : 12/12/2008
***************************************/
procedure prc_ins_setor
(
  p_setor    in midiaclip.setor.setor%type,
  p_template in midiaclip.setor.template_html%type
)
is
begin
----------- Insert Setor --------->
 begin

   insert into midiaclip.setor
   (
     setor_id, setor, template_html
   )
   values
   (
     seq_setor.nextval, trim(upper(p_setor)), trim(p_template) 
   );

 end;
--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Setor : '||p_setor||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_setor;

/**************************************
 nome       : prc_upd_setor
 proposito  : Atualiza Setor
 author     : jicelmo andrade
 criado     : 12/12/2008
***************************************/
procedure prc_upd_setor
(
  p_setor_id   in  midiaclip.setor.setor_id%type,
  p_setor      in  midiaclip.setor.setor%type,
  p_template   in  midiaclip.setor.template_html%type
)
is
begin

------------- Atualiza Setor ----------->
  update midiaclip.setor
           set setor         = trim(upper(p_setor)),
               template_html = trim(p_template)
            where setor_id   = p_setor_id;

--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Praça : '||p_setor||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;

end prc_upd_setor;

/**************************************
 nome       : prc_del_setor
 proposito  : Deleta Setor Setor
 author     : jicelmo andrade
 criado     : 12/12/2008
***************************************/
procedure prc_del_setor
(
  p_setor_id   in  midiaclip.setor.setor_id%type
)
is
begin

 -------------- Deleta Setor ------->
   delete from midiaclip.setor
      where setor_id = p_setor_id;
 -------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O setor não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_setor;
--------------------------------- Fim da Package --------------->
end pkg_setor;
/
