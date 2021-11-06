CREATE OR REPLACE PACKAGE pkg_email_setor
IS

PROCEDURE prc_ins_email
(
  p_setor_id             IN   midiaclip.setor_email.setor_id%TYPE,
  p_contato              IN   midiaclip.setor_email.contato_email%TYPE,
  p_email                IN   midiaclip.setor_email.email%TYPE,
  p_status               IN   midiaclip.setor_email.status%type
);

PROCEDURE prc_upd_email
(
  p_setor_email_id       IN   midiaclip.setor_email.setor_email_id%TYPE,
  p_setor_id             IN   midiaclip.setor.setor_id%TYPE,
  p_contato              IN   midiaclip.setor_email.contato_email%TYPE,
  p_email                IN   midiaclip.setor_email.email%TYPE,
  p_status               IN   midiaclip.setor_email.status%type
);

PROCEDURE prc_get_email_setor
(
  p_setor_id             IN   midiaclip.setor_email.setor_id%TYPE,
  p_query                OUT  midiaclip.pkg_refcursor.c_cursor
);

PROCEDURE prc_del_email_setor
(
  p_setor_email_id       IN   midiaclip.setor_email.setor_email_id%TYPE
);

END pkg_email_setor;
/
CREATE OR REPLACE PACKAGE BODY pkg_email_setor
IS

/**************************************
 nome       : Prc_Ins_Email
 proposito  : Cadastra Emaildo Setor
 author     : Jicelmo Andrade
 criado     : 14/06/2009
***************************************/
PROCEDURE prc_ins_email
(
  p_setor_id             IN   midiaclip.setor_email.setor_id%TYPE,
  p_contato              IN   midiaclip.setor_email.contato_email%TYPE,
  p_email                IN   midiaclip.setor_email.email%TYPE,
  p_status               IN   midiaclip.setor_email.status%type
)
IS
BEGIN

  BEGIN
    INSERT INTO midiaclip.setor_email
    (
      setor_email_id, setor_id, email, contato_email, status
    )
    VALUES
    (
      seq_setor_email.NEXTVAL,
      p_setor_id,
      TRIM(LOWER(p_email)),
      TRIM(p_contato),
      p_status
    );
  END;
----------------- Exception ---------------->
EXCEPTION
 WHEN OTHERS THEN
  IF SUBSTR(SQLERRM,1,9) = 'ORA-00001' THEN
   raise_application_error(-20000, 'Email : '||p_email||' já existe, operação abortada');
  ELSE
   raise_application_error(-20000, 'Erro não esperado pelo sistema : '||SQLERRM);
  END IF;

END prc_ins_email;

/**************************************
 nome       : Prc_upd_email
 proposito  : Atualizar Emails
 author     : Jicelmo andrade
 criado     : 14/06/2009
***************************************/
PROCEDURE prc_upd_email
(
  p_setor_email_id       IN   midiaclip.setor_email.setor_email_id%TYPE,
  p_setor_id             IN   midiaclip.setor.setor_id%TYPE,
  p_contato              IN   midiaclip.setor_email.contato_email%TYPE,
  p_email                IN   midiaclip.setor_email.email%TYPE,
  p_status               IN   midiaclip.setor_email.status%type
)
IS
BEGIN
 UPDATE midiaclip.setor_email
               SET setor_id       =  p_setor_id,
                   email          =  TRIM(LOWER(p_email)),
                   contato_email  =  TRIM(p_contato),
                   status         =  p_status
          WHERE setor_email_id    =  p_setor_email_id;
----------------------- Exception ----------->
EXCEPTION
 WHEN OTHERS THEN
  IF SUBSTR(SQLERRM,1,9) = 'ORA-00001' THEN
   raise_application_error(-20000, 'Email : '||p_email||' já existe, operação abortada');
  ELSE
   raise_application_error(-20000, 'Erro não esperado pelo sistema : '||SQLERRM);
  END IF;
END prc_upd_email;

/**************************************
 nome       : prc_get_email_entidade
 proposito  : Lista de Emails
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
PROCEDURE prc_get_email_setor
(
  p_setor_id             IN   midiaclip.setor_email.setor_id%TYPE,
  p_query                OUT  midiaclip.pkg_refcursor.c_cursor
)
IS
 vSql   midiaclip.pkg_refcursor.v_sql%TYPE;
BEGIN

  vSql := vSql ||
                  ' select setor_email_id, setor_id, email, contato_email,
                      case
                        when status = 0 then ''BLOQUEADO''
                        when status = 1 then ''ATIVO''
                      end as status        
                      from  midiaclip.setor_email
                       where setor_id = '||p_setor_id||' order by fnc_remove_acento(email)';
  OPEN p_query FOR vsql;
END prc_get_email_setor;

/**************************************
 nome       : prc_del_email_entidade
 proposito  : Apaga Email Entidade
 author     : jicelmo andrade
 criado     : 20/05/2009
***************************************/
PROCEDURE prc_del_email_setor
(
  p_setor_email_id    IN   midiaclip.setor_email.setor_email_id%TYPE
)
IS
BEGIN

 DELETE FROM midiaclip.setor_email
  WHERE setor_email_id = p_setor_email_id;

 EXCEPTION
   WHEN OTHERS THEN
    IF SUBSTR(SQLERRM,1,9) = 'ORA-02292' THEN
     raise_application_error(-20000, 'O email não pode ser excluido, pois o mesmo está sendo usado');
    ELSE
     raise_application_error(-20000, 'Erro não esperado pelo sistema : '||SQLERRM);
    END IF;
END prc_del_email_setor;

--------------------------- Fim Package ---------------->
END pkg_email_setor;
/
