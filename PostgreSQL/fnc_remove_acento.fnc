create or replace function midiaclip.fnc_remove_acento
( p_string      in varchar2
) return varchar2 is
begin
  return( upper ( replace( replace( translate( p_string, 'áàäâãÂÄÁÀÃéèêëÉÈÊËíìïîÍÌÎÏóòõôöÓÒÕÔÖúùüûÚÙÜÛçÇñÑ', 'aaaaaAAAAAeeeeEEEEiiiiIIIIoooooOOOOOuuuuUUUUcCnN'), '-',''),'''','') ) );
end fnc_remove_acento;
