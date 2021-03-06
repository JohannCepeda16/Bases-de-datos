CREATE OR REPLACE PACKAGE BODY PC_OFERTAS IS
    PROCEDURE AD_OFERTAS(XUSUARIO IN NUMBER, XTITULO IN VARCHAR2, XDESCRIPCION IN VARCHAR2, XREQUISITOS IN VARCHAR2, XVACANTES IN NUMBER, XUBICACION IN VARCHAR2, XSALARIO IN NUMBER, XMODO_TRABAJO IN VARCHAR2) IS
    BEGIN
        INSERT INTO OFERTAS VALUES(SEQ_OFERTAS.NEXTVAL, XUSUARIO, XTITULO, XDESCRIPCION, XREQUISITOS, XVACANTES, XUBICACION, XSALARIO, XMODO_TRABAJO);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO ');
    END;
    
    PROCEDURE MOD_OFERTAS(XCODIGO IN NUMBER, XTITULO IN VARCHAR2,  XDESCRIPCION IN VARCHAR2, XREQUISITOS IN VARCHAR2, XVACANTES IN NUMBER, XUBICACION IN VARCHAR2, XMODO_TRABAJO IN VARCHAR2) IS
    BEGIN
        UPDATE OFERTAS SET TITULO = XTITULO, DESCRIPCION = XDESCRIPCION, REQUISITOS = XREQUISITOS, VACANTES = XVACANTES, UBICACION = XUBICACION, MODO_TRABAJO = XMODO_TRABAJO WHERE USUARIO = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ACTUALIZAR EL DATO ');
    END;
    PROCEDURE DEL_OFERTAS(XCODIGO IN NUMBER) IS
    BEGIN
        DELETE FROM OFERTAS WHERE USUARIO = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ELIMINAR EL DATO ');
    END;
    FUNCTION CO_OFERTAS_ABIERTAS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
        BEGIN
            OPEN CO_RE FOR
                SELECT *
                FROM
                OFERTAS_ABIERTAS;
            RETURN CO_RE;
        END;
    FUNCTION CO_OFERTAS_VACANTES RETURN SYS_REFCURSOR IS OF_VA SYS_REFCURSOR;
        BEGIN
            OPEN OF_VA FOR
                SELECT *
                FROM
                OFERTAS_VACANTES;
            RETURN OF_VA;
        END;
END PC_OFERTAS;
/
CREATE OR REPLACE PACKAGE BODY PC_ASESORES IS
    PROCEDURE AD_ASESORES(XIDENTIFICACION IN NUMBER, XCELULAR IN NUMBER, XCORREO IN VARCHAR2, XPRIMER_NOMBRE IN VARCHAR2, XPRIMER_APELLIDO IN VARCHAR2, XDIRECCION IN VARCHAR2) IS
    BEGIN
        INSERT INTO ASESORES VALUES(SEQ_ASESORES.NEXTVAL,XIDENTIFICACION, XCELULAR, XCORREO, XPRIMER_NOMBRE, XPRIMER_APELLIDO, XDIRECCION);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    PROCEDURE MOD_ASESORES(XCODIGO IN NUMBER, XCELULAR IN NUMBER, XCORREO IN VARCHAR2, XPRIMER_NOMBRE IN VARCHAR2, XPRIMER_APELLIDO IN VARCHAR2, XDIRECCION IN VARCHAR2) is
    BEGIN
        UPDATE ASESORES SET CELULAR = XCELULAR, CORREO = XCORREO, PRIMER_NOMBRE = XPRIMER_NOMBRE, PRIMER_APELLIDO = XPRIMER_APELLIDO, DIRECCION = XDIRECCION WHERE CODIGO = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ATUALIZAR EL DATO');
    END;
    PROCEDURE DEL_ASESORES(XCODIGO IN NUMBER) IS
    BEGIN
        DELETE FROM ASESORES WHERE CODIGO = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ELIMINAR EL DATO');
    END;
END PC_ASESORES;
/
CREATE OR REPLACE PACKAGE BODY PC_PREFERENCIAS IS
    PROCEDURE AD_PREFERENCIAS(XUSUARIO IN NUMBER, XSALARIO_ESPERADO IN NUMBER, XMODO_TRABAJO IN VARCHAR2, XDIRECCION IN VARCHAR2, XJORNADA IN VARCHAR2) IS
     BEGIN
        INSERT INTO PREFERENCIAS VALUES(XUSUARIO, XSALARIO_ESPERADO, XMODO_TRABAJO, XDIRECCION, XJORNADA);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    
    PROCEDURE MOD_PREFERENCIAS_USUARIO(XUSUARIO IN NUMBER, XSALARIO_ESPERADO IN NUMBER, XMODO_TRABAJO IN VARCHAR2, XDIRECCION IN VARCHAR2, XJORNADA IN VARCHAR2) IS
     BEGIN
        UPDATE PREFERENCIAS SET SALARIO_ESPERADO = XSALARIO_ESPERADO, MODO_TRABAJO = XMODO_TRABAJO, DIRECCION = XDIRECCION, JORNADA = XJORNADA WHERE USUARIO = XUSUARIO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    PROCEDURE DEL_PREFERENCIAS(XUSUARIO IN NUMBER) IS
    BEGIN
        DELETE FROM PREFERENCIAS WHERE USUARIO = XUSUARIO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    FUNCTION CO_MODO_TRABAJO(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
        BEGIN
            OPEN CO_RE FOR
            SELECT *
            FROM
            PREFERENCIAS_USUARIOS_MODO_TRABAJO;
            RETURN CO_RE;
        END;
END PC_PREFERENCIAS;
/
CREATE OR REPLACE PACKAGE BODY PC_CONTRATOS IS
    PROCEDURE AD_CONTRATOS(XUSUARIO IN NUMBER, XCONVOCATORIA IN NUMBER, XOBSERVACIONES IN VARCHAR2, XCONTRATADO IN VARCHAR2) IS
    BEGIN
        INSERT INTO CONTRATOS(USUARIO, CONVOCATORIA, OBSERVACIONES, CONTRATADO) VALUES(XUSUARIO, XCONVOCATORIA, XOBSERVACIONES, XCONTRATADO);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    
    PROCEDURE MOD_CONTRATOS_CONTRATADO(XUSUARIO IN NUMBER, XCONVOCATORIA IN NUMBER, XCONTRATADO IN VARCHAR2) IS
    BEGIN
        UPDATE CONTRATOS SET CONTRATADO = XCONTRATADO WHERE USUARIO = XUSUARIO AND CONVOCATORIA = XCONVOCATORIA;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ACTUALIZAR EL DATO');
    END;
    
    FUNCTION CO_DETALLES_CONTRATOS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
        BEGIN
            OPEN CO_RE FOR
                SELECT *
                FROM
                DETALLES_CONTRATOS;
            RETURN CO_RE;
        END;
        
    FUNCTION CO_USUARIOS_CONTRATADOS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
        BEGIN
            OPEN CO_RE FOR
                SELECT *
                FROM
                USUARIOS_CONTRATADOS;
            RETURN CO_RE;
        END;
END PC_CONTRATOS;
/
CREATE OR REPLACE PACKAGE BODY PC_CONVOCATORIAS IS
    PROCEDURE AD_CONVOCATORIAS(XOFERTA IN NUMBER, XFECHA_FIN IN DATE) IS
    BEGIN
        INSERT INTO CONVOCATORIAS(OFERTA, FECHA_FIN) VALUES(XOFERTA, XFECHA_FIN);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    
    PROCEDURE MOD_CONVOCATORIAS_FECHA_FIN(XCODIGO IN NUMBER, XFECHA_FIN IN DATE) IS
    BEGIN
        UPDATE CONVOCATORIAS SET FECHA_FIN = XFECHA_FIN WHERE CODIGO = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ACTUALIZAR EL DATO');
    END;
    
    PROCEDURE DEL_CONVOCATORIAS(XCODIGO IN NUMBER) IS
    BEGIN
        DELETE FROM CONVOCATORIAS WHERE CODIGO = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    
    FUNCTION CO_FECHAS_CONVOCATORIAS RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
        BEGIN
            OPEN CO_RE FOR
            SELECT *
            FROM 
            FECHAS_CONVOCATORIA;
            RETURN CO_RE;
        END;
        
    FUNCTION CO_OFERTAS_ABIERTAS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
        BEGIN
            OPEN CO_RE FOR
            SELECT *
            FROM 
            OFERTAS_ABIERTAS;
            RETURN CO_RE;
        END;
END PC_CONVOCATORIAS;
/
CREATE OR REPLACE PACKAGE BODY PC_USUARIOS IS
    PROCEDURE AD_USUARIO(XTIPO_USUARIO IN VARCHAR2, XASESOR IN NUMBER) IS
    BEGIN
        INSERT INTO USUARIOS VALUES(SEQ_USUARIOS.NEXTVAL, XTIPO_USUARIO, XASESOR);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO INGRESAR EL DATO');
    END;
    
    PROCEDURE MOD_USUARIO(XCODIGO IN NUMBER, XTIPO_USUARIO IN VARCHAR2, XASESOR IN NUMBER) IS
    BEGIN
        UPDATE USUARIOS SET TIPO_USUARIO = XTIPO_USUARIO, ASESOR = XASESOR WHERE ID = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ACTUALIZAR LA TABLA');
    END;
    
    PROCEDURE DEL_USUARIO(XCODIGO IN NUMBER) IS
    BEGIN
        DELETE FROM USUARIOS WHERE ID = XCODIGO;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO ELIMINAR EL DATO');
    END;

END PC_USUARIOS;
/