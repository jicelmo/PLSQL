create or replace package pkg_tipo_canal
is

function fnc_get_tipo_canal_id
(
   p_tipo_canal         in midiaclip.tipo_canal.tipo_canal%type
) return number;

procedure prc_get_tipo_canal
(
  p_tipo_canal          in  midiaclip.tipo_canal.tipo_canal%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_tipo_canal
(
  p_tipo_canal          in midiaclip.tipo_canal.tipo_canal%type,
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type
);

procedure prc_upd_tipo_canal
(
  p_tipo_canal_id       in midiaclip.tipo_canal.tipo_canal_id%type,
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type,
  p_tipo_canal          in midiaclip.tipo_canal.tipo_canal%type
);

procedure prc_del_tipo_canal
(
  p_tipo_canal_id       in midiaclip.tipo_canal.tipo_canal_id%type
);
end pkg_tipo_canal;
/
create or replace package body pkg_tipo_canal
is

/**************************************
 nome       : fnc_get_tipo_canal
 proposito  : Retorna o tipo_midia_id
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
function fnc_get_tipo_canal_id
(
   p_tipo_canal         in midiaclip.tipo_canal.tipo_canal%type
) return number
is
 v_tipo_canal          number;
begin
 begin
   select tipo_canal_id
    into v_tipo_canal
    from midiaclip.tipo_canal
     where tipo_canal = trim(upper(p_tipo_canal));
  return (v_tipo_canal);
 end;
-------------------Exception ---------------->
exception
 when no_data_found then
  raise_application_error (-20000, 'Tipo Canal : '||p_tipo_canal||' não encontrado ');
end fnc_get_tipo_canal_id;

/**************************************
 nome       : prc_get_tipo_canal
 proposito  : Retorna lista tipo_canal
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
procedure prc_get_tipo_canal
(
  p_tipo_canal          in  midiaclip.tipo_canal.tipo_canal%type,
  p_retorno             out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql                  pkg_refcursor.v_sql%type;
begin
  vSql := vSql||
                 ' select c.tipo_canal_id, m.tipo_midia_id, c.tipo_canal, m.tipo_midia
                    from midiaclip.tipo_midia m
                     inner join midiaclip.tipo_canal  c  on   m.tipo_midia_id = c.tipo_midia_id
                      where tipo_canal like trim(upper('''||'%'||p_tipo_canal||'%'||'''))
                   order by fnc_remove_acento(c.tipo_canal) ';
 ------------- Cursor ----------->
  open p_retorno for vSql;
end prc_get_tipo_canal;


/**************************************
 nome       : prc_ins_tipo_canal
 proposito  : Cadastra tipo_canal
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
procedure prc_ins_tipo_canal
(
  p_tipo_canal          in midiaclip.tipo_canal.tipo_canal%type,
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type
)
is
begin
 begin
  insert into midiaclip.tipo_canal
  (
    tipo_canal_id, tipo_midia_id, tipo_canal
  )
  values
  (
    seq_tipo_canal.nextval, pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia), trim(upper(p_tipo_canal))
  );
 end;
 ------------- exception ---------->
exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Tipo Canal : '||p_tipo_canal||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_tipo_canal;

/**************************************
 nome       : prc_upd_tipo_canal
 proposito  : Atualiza tipo_canal
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
procedure prc_upd_tipo_canal
(
  p_tipo_canal_id       in midiaclip.tipo_canal.tipo_canal_id%type,
  p_tipo_midia          in midiaclip.tipo_midia.tipo_midia%type,
  p_tipo_canal          in midiaclip.tipo_canal.tipo_canal%type
)
is
begin
  update midiaclip.tipo_canal
              set tipo_canal     =  trim(upper(p_tipo_canal)),
                  tipo_midia_id  =  pkg_tipo_midia.fnc_get_tipo_midia_id(p_tipo_midia)
            where tipo_canal_id  =  p_tipo_canal_id;
 --------- Exception ----------->
exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Tipo Canal : '||p_tipo_canal||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_tipo_canal;

/**************************************
 nome       : prc_del_tipo_canal
 proposito  : Excluir tipo_canal
 author     : jicelmo andrade
 criado     : 19/12/2008
***************************************/
procedure prc_del_tipo_canal
(
  p_tipo_canal_id       in midiaclip.tipo_canal.tipo_canal_id%type
)
is
begin
  delete from midiaclip.tipo_canal
   where tipo_canal_id = p_tipo_canal_id;
------------ Exception ------------>
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'O Tipo Canal não pode ser excluido, pois o mesmo está sendo usado');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_tipo_canal;
---------------------------------- Fim da package --------------------->
end pkg_tipo_canal;
/
