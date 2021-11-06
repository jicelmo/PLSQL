create or replace package pkg_programa_canal 
is

procedure prc_ins_programa_canal
(
  p_programa            in  midiaclip.programa.programa%type,
  p_canal_comunicacao   in  midiaclip.canal_comunicacao.canal_comunicacao_id%type
);   

procedure prc_upd_programa_canal
(
  p_programa            in  midiaclip.programa.programa%type,
  p_canal_comunicacao   in  midiaclip.canal_comunicacao.canal_comunicacao_id%type
);   


end pkg_programa_canal;
/
create or replace package body pkg_programa_canal 
is
begin

end pkg_programa_canal;
/
