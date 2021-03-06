CREATE OR REPLACE PACKAGE BODY PA_PERSONA IS
    PROCEDURE AD_PREFERENCIAS(XUSUARIO IN NUMBER, XSALARIO_ESPERADO IN NUMBER, XMODO_TRABAJO IN VARCHAR2, XDIRECCION IN VARCHAR2, XJORNADA IN VARCHAR2) IS
        BEGIN
            PC_PREFERENCIAS.AD_PREFERENCIAS(XUSUARIO, XSALARIO_ESPERADO, XMODO_TRABAJO, XDIRECCION, XJORNADA);
        END;
    PROCEDURE MOD_PREFERENCIAS (XUSUARIO IN NUMBER, XSALARIO_ESPERADO IN NUMBER, XMODO_TRABAJO IN VARCHAR2, XDIRECCION IN VARCHAR2, XJORNADA IN VARCHAR2) IS
        BEGIN
            PC_PREFERENCIAS.MOD_PREFERENCIAS_USUARIO (XUSUARIO, XSALARIO_ESPERADO, XMODO_TRABAJO, XDIRECCION, XJORNADA);
        END;
    PROCEDURE DEL_PREFERENCIAS (XUSUARIO IN NUMBER) IS
        BEGIN
            PC_PREFERENCIAS.DEL_PREFERENCIAS (XUSUARIO);
        END;
    /*CONSULTAS*/
    FUNCTION CO_FECHAS_CONVOCATORIAS RETURN SYS_REFCURSOR IS CO_FE SYS_REFCURSOR;
        BEGIN
            CO_FE := PC_CONVOCATORIAS.CO_FECHAS_CONVOCATORIAS;
        RETURN CO_FE;
        END;
    FUNCTION CO_OFERTAS_VACANTES RETURN SYS_REFCURSOR IS CO_OF SYS_REFCURSOR;
        BEGIN
            CO_OF := PC_OFERTAS.CO_OFERTAS_VACANTES;
        RETURN CO_OF;
        END;
END PA_PERSONA;
/
CREATE OR REPLACE PACKAGE BODY PA_RH IS
    PROCEDURE AD_ASESORES (XIDENTIFICACION IN NUMBER, XCELULAR IN NUMBER, XCORREO IN VARCHAR2, XPRIMER_NOMBRE IN VARCHAR2, XPRIMER_APELLIDO IN VARCHAR2, XDIRECCION IN VARCHAR2) IS
        BEGIN
            PC_ASESORES.AD_ASESORES(XIDENTIFICACION, XCELULAR, XCORREO, XPRIMER_NOMBRE, XPRIMER_APELLIDO, XDIRECCION);
        END;
    PROCEDURE AD_USUARIO (XTIPO_USUARIO IN VARCHAR2, XASESOR IN NUMBER) IS
        BEGIN
            PC_USUARIOS.AD_USUARIO(XTIPO_USUARIO,XASESOR);
        END;
    PROCEDURE MOD_USUARIO (XID IN NUMBER, XTIPO_USUARIO IN VARCHAR2, XASESOR IN NUMBER) IS
        BEGIN
            PC_USUARIOS.MOD_USUARIO(XID, XTIPO_USUARIO, XASESOR);
        END;
    PROCEDURE MOD_ASESORES (XCODIGO IN NUMBER, XCELULAR IN NUMBER, XCORREO IN VARCHAR2, XPRIMER_NOMBRE IN VARCHAR2, XPRIMER_APELLIDO IN VARCHAR2, XDIRECCION IN VARCHAR2) IS
        BEGIN
            PC_ASESORES.MOD_ASESORES(XCODIGO, XCELULAR, XCORREO, XPRIMER_NOMBRE, XPRIMER_APELLIDO, XDIRECCION);
        END;
    PROCEDURE DEL_USUARIO (XCODIGO IN NUMBER) IS
        BEGIN
            PC_USUARIOS.DEL_USUARIO (XCODIGO);
        END;
    PROCEDURE DEL_ASESORES (XCODIGO IN NUMBER) IS
        BEGIN
            PC_ASESORES.DEL_ASESORES (XCODIGO);
        END;
    FUNCTION CO_USUARIOS_CONTRATADOS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_OF SYS_REFCURSOR;
        BEGIN
            CO_OF := PC_CONTRATOS.CO_USUARIOS_CONTRATADOS(XNUMERO);
        RETURN CO_OF;
        END;
    FUNCTION CO_OFERTAS_ABIERTAS (XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_OF SYS_REFCURSOR;
        BEGIN
            CO_OF := PC_OFERTAS.CO_OFERTAS_ABIERTAS(XNUMERO);
        RETURN CO_OF;
        END;
END PA_RH;
/
CREATE OR REPLACE PACKAGE BODY PA_EMPLEADOR IS
    PROCEDURE AD_CONVOCATORIAs (XOFERTA IN NUMBER, XFECHA_FIN IN DATE) IS
        BEGIN
            PC_CONVOCATORIAS.AD_CONVOCATORIAS(XOFERTA,XFECHA_FIN);
        END;
    PROCEDURE AD_CONTRATOS (XUSUARIO IN NUMBER, XCONVOCATORIA IN NUMBER, XOBSERVACIONES IN VARCHAR2, XCONTRATADO IN NUMBER) IS
        BEGIN
            PC_CONTRATOS.AD_CONTRATOS (XUSUARIO, XCONVOCATORIA, XOBSERVACIONES, XCONTRATADO);
        END;
    PROCEDURE AD_OFERTAS (XCODIGO IN NUMBER, XTITULO IN VARCHAR2, XDESCRIPCION IN VARCHAR2, XREQUISITOS IN VARCHAR2, XVACANTES IN NUMBER, XUBICACION IN VARCHAR2, XSALARIO IN NUMBER, XMODO_TRABAJO IN VARCHAR2) IS
        BEGIN
            PC_OFERTAS.AD_OFERTAS (XCODIGO, XTITULO,XDESCRIPCION,XREQUISITOS,XVACANTES,XUBICACION,XSALARIO,XMODO_TRABAJO);
        END;
    PROCEDURE MOD_OFERTAS (XUSUARIO IN NUMBER, XTITULO IN VARCHAR2, XDESCRIPCION IN VARCHAR2, XREQUISITOS IN VARCHAR2, XVACANTES IN NUMBER, XUBICACION IN VARCHAR2, XMODO_TRABAJO IN VARCHAR2) IS
        BEGIN
            PC_OFERTAS.MOD_OFERTAS (XUSUARIO, XTITULO, XDESCRIPCION, XREQUISITOS, XVACANTES, XUBICACION, XMODO_TRABAJO);
        END;
    PROCEDURE MOD_CONTRATOS_CONTRATADO (XUSUARIO IN NUMBER, XCONVOCATORIA IN NUMBER, XCONTRATADO IN NUMBER) IS
        BEGIN
            PC_CONTRATOS.MOD_CONTRATOS_CONTRATADO (XUSUARIO, XCONVOCATORIA, XCONTRATADO);
        END;
    PROCEDURE DEL_OFERTAS(XCODIGO IN NUMBER) IS
        BEGIN
            PC_OFERTAS.DEL_OFERTAS(XCODIGO);
        END;
    FUNCTION CO_DETALLES_CONTRATOS (XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_OF SYS_REFCURSOR;
        BEGIN
            CO_OF := PC_CONTRATOS.CO_DETALLES_CONTRATOS(XNUMERO);
        RETURN CO_OF;
        END;
    FUNCTION CO_MODO_TRABAJO (XNUMERO IN NUMBER) RETURN SYS_REFCURSOR IS CO_OF SYS_REFCURSOR;
        BEGIN
            CO_OF := PC_PREFERENCIAS.CO_MODO_TRABAJO (XNUMERO);
        RETURN CO_OF;
        END;
END PA_EMPLEADOR;