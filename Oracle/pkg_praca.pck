create or replace package pkg_praca
is

function fnc_get_praca_id
(
  p_praca         in midiaclip.praca.praca%type
) return number;

procedure prc_get_praca
(
  p_praca         in  midiaclip.praca.praca%type,
  p_retorno       out midiaclip.pkg_refcursor.c_cursor
);

procedure prc_ins_praca
(
  p_praca         in midiaclip.praca.praca%type
);

procedure prc_upd_praca
(
  p_praca_id      in midiaclip.praca.praca_id%type,
  p_praca         in midiaclip.praca.praca%type
);

procedure prc_del_praca
(
  p_praca_id      in midiaclip.praca.praca_id%type
);
----------------------- Fim da Package ---------------->
end pkg_praca;
/
create or replace package body pkg_praca
is

/**************************************
 nome       : fnc_get_praca_id
 proposito  : Retorna praca_id
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
function fnc_get_praca_id
(
  p_praca         in midiaclip.praca.praca%type
) return number
is
 v_praca        number;
begin
 begin
   select praca_id
     into v_praca
     from midiaclip.praca
      where praca = trim(upper(p_praca));
  return (v_praca);
 end;
 exception
  when no_data_found then
   raise_application_error (-20000, 'Praça :'||p_praca||' não cadastrada');
end fnc_get_praca_id;

/**************************************
 nome       : prc_get_praca
 proposito  : Retorna listagem de Praça
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_get_praca
(
  p_praca         in  midiaclip.praca.praca%type,
  p_retorno       out midiaclip.pkg_refcursor.c_cursor
)
is
  vSql            midiaclip.pkg_refcursor.v_sql%type;
begin
  vSql := vSql||
                 ' select praca_id, praca
                    from midiaclip.praca
                     where praca like trim(upper('''||'%'||p_praca||'%'||'''))
                      order by fnc_remove_acento(praca)';

-------------- Cursor ---------->
 open p_retorno for vSql;
end prc_get_praca;


/**************************************
 nome       : prc_ins_praca
 proposito  : Cadastra Praça
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_ins_praca
(
  p_praca         in midiaclip.praca.praca%type
)
is
begin
 begin
   insert into midiaclip.praca
   (
     praca_id, praca
   )
   values
   (
     seq_praca.nextval, trim(upper(p_praca))
   );
 end;
--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Praça : '||p_praca||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_ins_praca;

/**************************************
 nome       : prc_upd_praca
 proposito  : Atualiza praça
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_upd_praca
(
  p_praca_id      in midiaclip.praca.praca_id%type,
  p_praca         in midiaclip.praca.praca%type
)
is
begin
 begin
  update midiaclip.praca
      set praca     = trim(upper(praca))
  where   praca_id  = p_praca_id;
 end;
--------------- Exception ---------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-00001' then
    raise_application_error(-20000, 'Praça : '||p_praca||' já existe, operação abortada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_upd_praca;

/**************************************
 nome       : prc_del_praca
 proposito  : Excluir praça
 author     : jicelmo andrade
 criado     : 18/12/2008
***************************************/
procedure prc_del_praca
(
  p_praca_id      in midiaclip.praca.praca_id%type
)
is
begin
  delete from midiaclip.praca
   where praca_id = p_praca_id;
 ----------------- Exception -------------->
 exception
  when others then
   if substr(sqlerrm,1,9) = 'ORA-02292' then
    raise_application_error(-20000, 'A praça não pode ser excluida, pois a mesma está sendo usada');
   else
    raise_application_error(-20000, 'Erro não esperado pelo sistema : '||sqlerrm);
   end if;
end prc_del_praca;

------------------------- Fim da Package -------------------->
end pkg_praca;
/
