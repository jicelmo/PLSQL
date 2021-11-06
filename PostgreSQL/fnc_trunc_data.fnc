create or replace function fnc_trunc_data
(
  p_data  in  varchar2
)
return varchar2
is
 v_data_extenso  varchar2(10) := null;
begin
   select substr(to_char(to_date(p_data,'dd/mm/yyyy'),'dd/Month','NLS_DATE_LANGUAGE=PORTUGUESE'),1,6)
    into v_data_extenso
    from dual;
 return (v_data_extenso);
end fnc_trunc_data;
/
