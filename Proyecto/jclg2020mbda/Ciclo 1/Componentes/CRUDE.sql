CREATE OR REPLACE PACKAGE PC_OFERTAS IS
    PROCEDURE AD_OFERTAS(XUSUARIO IN NUMBER, XTITULO IN VARCHAR2, XDESCRIPCION IN VARCHAR2, XREQUISITOS IN VARCHAR2, XVACANTES IN NUMBER, XUBICACION IN VARCHAR2, XSALARIO IN NUMBER, XMODO_TRABAJO IN VARCHAR2);
    PROCEDURE MOD_OFERTAS(XCODIGO IN NUMBER, XTITULO IN VARCHAR2,  XDESCRIPCION IN VARCHAR2, XREQUISITOS IN VARCHAR2, XVACANTES IN NUMBER, XUBICACION IN VARCHAR2, XMODO_TRABAJO IN VARCHAR2);
    PROCEDURE DEL_OFERTAS(XCODIGO IN NUMBER);
    FUNCTION CO_OFERTAS_ABIERTAS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION CO_OFERTAS_VACANTES RETURN SYS_REFCURSOR;
END PC_OFERTAS;
/
CREATE OR REPLACE PACKAGE PC_ASESORES IS
    PROCEDURE AD_ASESORES(XIDENTIFICACION IN NUMBER, XCELULAR IN NUMBER, XCORREO IN VARCHAR2, XPRIMER_NOMBRE IN VARCHAR2, XPRIMER_APELLIDO IN VARCHAR2, XDIRECCION IN VARCHAR2);
    PROCEDURE MOD_ASESORES(XCODIGO IN NUMBER, XCELULAR IN NUMBER, XCORREO IN VARCHAR2, XPRIMER_NOMBRE IN VARCHAR2, XPRIMER_APELLIDO IN VARCHAR2, XDIRECCION IN VARCHAR2);
    PROCEDURE DEL_ASESORES(XCODIGO IN NUMBER);
END PC_ASESORES;
/
CREATE OR REPLACE PACKAGE PC_PREFERENCIAS IS
    PROCEDURE AD_PREFERENCIAS(XUSUARIO IN NUMBER, XSALARIO_ESPERADO IN NUMBER, XMODO_TRABAJO IN VARCHAR2, XDIRECCION IN VARCHAR2, XJORNADA IN VARCHAR2);
    PROCEDURE MOD_PREFERENCIAS_USUARIO(XUSUARIO IN NUMBER, XSALARIO_ESPERADO IN NUMBER, XMODO_TRABAJO IN VARCHAR2, XDIRECCION IN VARCHAR2, XJORNADA IN VARCHAR2);
    PROCEDURE DEL_PREFERENCIAS(XUSUARIO IN NUMBER);
    FUNCTION CO_MODO_TRABAJO(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR;
END PC_PREFERENCIAS;
/
CREATE OR REPLACE PACKAGE PC_CONTRATOS IS
    PROCEDURE AD_CONTRATOS(XUSUARIO IN NUMBER, XCONVOCATORIA IN NUMBER, XOBSERVACIONES IN VARCHAR2, XCONTRATADO IN VARCHAR2);
    PROCEDURE MOD_CONTRATOS_CONTRATADO(XUSUARIO IN NUMBER, XCONVOCATORIA IN NUMBER, XCONTRATADO IN VARCHAR2);
    FUNCTION CO_DETALLES_CONTRATOS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION CO_USUARIOS_CONTRATADOS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR;
END PC_CONTRATOS;
/
CREATE OR REPLACE PACKAGE PC_CONVOCATORIAS IS
    PROCEDURE AD_CONVOCATORIAS(XOFERTA IN NUMBER, XFECHA_FIN IN DATE);
    PROCEDURE MOD_CONVOCATORIAS_FECHA_FIN(XCODIGO IN NUMBER, XFECHA_FIN IN DATE);
    PROCEDURE DEL_CONVOCATORIAS(XCODIGO IN NUMBER);
    FUNCTION CO_FECHAS_CONVOCATORIAS RETURN SYS_REFCURSOR;
    FUNCTION CO_OFERTAS_ABIERTAS(XNUMERO IN NUMBER) RETURN SYS_REFCURSOR;
END PC_CONVOCATORIAS;
/
CREATE OR REPLACE PACKAGE PC_USUARIOS IS
    PROCEDURE AD_USUARIO(XTIPO_USUARIO IN VARCHAR2, XASESOR IN NUMBER);
    PROCEDURE MOD_USUARIO(XCODIGO IN NUMBER, XTIPO_USUARIO IN VARCHAR2, XASESOR IN NUMBER);
    PROCEDURE DEL_USUARIO(XCODIGO IN NUMBER);
END PC_USUARIOS;
/