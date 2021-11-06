create or replace procedure prc_mensuracao_pub
(
  p_duracao  in   varchar2,
  p_custo    in   number,
  p_retorno  out  midiaclip.pkg_refcursor.c_cursor 
)
is
  vSql  pkg_refcursor.v_sql%type;
begin
  begin
    vSql := vSql ||
                    ' select midiaclip.fnc_custo_pub ('''||p_duracao||''','||p_custo||') 
                       from dual';
  end;
 open p_retorno for vSql;
  
end prc_mensuracao_pub;
/
