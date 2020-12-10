/*AUTO 04*/
DROP TABLE ISSUE;
CREATE TABLE ISSUE(
CALL_REF NUMBER(11) NOT NULL,
CALL_DATE DATE NOT NULL,
CALLER_ID NUMBER(11) NOT NULL,
DETAIL VARCHAR2(255),
TAKEN_BY VARCHAR2(6) NOT NULL,
ASSIGNED_TO VARCHAR2(6),
STATUS VARCHAR2(10)
);

/*PRIMARY KEY*/
ALTER TABLE ISSUE ADD CONSTRAINT PK_ISSUE PRIMARY KEY(CALL_REF);

/*FOREIGN KEY*/
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_CALLER FOREIGN KEY(CALLER_ID) REFERENCES CALLER(CALLER_ID);
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_STAFF FOREIGN KEY(ASSIGNED_TO) REFERENCES STAFF(STAFF_CODE);

/*ADICIONANDO RESTRICCIONES DECLARATIVAS*/
ALTER TABLE ISSUE ADD CONSTRAINT CK_STATUS
	CHECK(STATUS IN ('Open', 'Closed'));

ALTER TABLE ISSUE ADD CONSTRAINT CK_DETAIL
	CHECK(LENGTH(DETAIL) > 34);

/*ATRIBUTOS OK*/
--Validamos que se pueda ingresar un estado abierto
INSERT INTO ISSUE VALUES(1, CURRENT_DATE, 9, 'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta)', 'AW1', 'AE1', 'Open');
--Validamos que se pueda ingresar un estado cerrado
INSERT INTO ISSUE VALUES(2, CURRENT_DATE, 10, 'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta)', 'AW1', 'JE1', 'Open');
--Validamos que reciba una falla con detalles igual a 35 caracteres
INSERT INTO ISSUE VALUES(3, CURRENT_DATE, 11, 'Lorem Ipsum es simplemente el texto', 'AW1', 'JE1', 'Open');

/*ATRIBUTOS NO OK*/
--Validamos que no se viole la integridad de las llaves primarias
INSERT INTO ISSUE VALUES(1, CURRENT_DATE, 9, 'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta)', 'AW1', 'AE1', 'Open');
INSERT INTO ISSUE VALUES(2, CURRENT_DATE, 10, 'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta)', 'AW1', 'JE1', 'Open');
INSERT INTO ISSUE VALUES(3, CURRENT_DATE, 11, 'Lorem Ipsum es simplemente el texto', 'AW1', 'JE1', 'Open');

--Validamos que no ingrese valores nulos
INSERT INTO ISSUE VALUES(null, null, null, null, null, null,null);
--Validamos que sea una fecha valida
INSERT INTO ISSUE VALUES(4, '22 de noviembre de 2011', 12, 'Lorem Ipsum es simplemente el texto', 'AW1', 'JE1', 'Open');
--Validamos que no acepte longitud de caracteres de detalles < a 35
INSERT INTO ISSUE VALUES(5, CURRENT_DATE, 13, 'Lorem Ipsum', 'AW1', 'JE1', 'Open');
--Validamos que no acepte longitud de caracteres de detalles > 255
INSERT INTO ISSUE VALUES(6, CURRENT_DATE, 14, 'Es un hecho establecido hace demasiado tiempo que un lector se distraerá con el contenido del texto de un sitio mientras que mira su diseño. El punto de usar Lorem Ipsum es que tiene una distribución más o menos normal de las letras, al contrario de usar textos como por ejemplo "Contenido aquí, contenido aquí". Estos textos hacen parecerlo un español que se puede leer. Muchos paquetes de autoedición y editores de páginas web usan el Lorem Ipsum como su texto por defecto, y al hacer una búsqueda de "Lorem Ipsum" va a dar por resultado muchos sitios web que usan este texto si se encuentran en estado de desarrollo. Muchas versiones han evolucionado a través de los años, algunas veces por accidente, otras veces a propósito (por ejemplo insertándole humor y cosas por el estilo).', 'AW1', 'JE1', 'Open');
--Validamos que los estados que ingresan sean correctos
INSERT INTO ISSUE VALUES(7, CURRENT_DATE, 15, 'Lorem Ipsum es simplemente el texto', 'AW1', 'JE1', 'Medio');

/*ACCIONES*/

--ELIMINAR
ALTER TABLE ISSUE DROP CONSTRAINT FK_ISSUE_CALLER; 
ALTER TABLE ISSUE DROP CONSTRAINT FK_ISSUE_STAFF;

--CREAR
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_CALLER FOREIGN KEY(CALLER_ID) REFERENCES CALLER(CALLER_ID) ON DELETE CASCADE;
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_STAFF FOREIGN KEY(ASSIGNED_TO) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;

/*ACCIONES OK*/
SELECT FIRTS_NAME
FROM CALLER
JOIN ISSUE ON(CALLER.CALLER_ID = ISSUE.CALLER_ID);

/*ADICIONANDO DISPARADORES*/
--EL NUMERO DE REFERENCIA SE GENERA AUTOMATICAMENTE
CREATE TRIGGER C_ISSUE_REF
AFTER INSERT ON ISSUE
BEGIN
    UPDATE ISSUE SET CALL_REF = (SELECT CALL_REF FROM (
    SELECT CALL_REF FROM ISSUE ORDER BY CALL_REF DESC
    ) WHERE ROWNUM = 1) + 1;
END;

--LA FECHA SE GENERA AUTOMATICAMENTE
CREATE TRIGGER C_ISSUE_DATE
AFTER INSERT ON ISSUE
BEGIN
    UPDATE ISSUE SET CALL_DATE = CURRENT_DATE;
END;

/*TODOS LOS CASOS ENTRAN CON ESTADO ABIERTO*/
CREATE TRIGGER C_ISSUE_STATUS
AFTER INSERT ON ISSUE
BEGIN
    UPDATE ISSUE SET STATUS = 'Open';
END;

/*EL UNICO DATO QUE SE DEBE DEJAR MODIFICAR ES EL ESTADO*/
CREATE TRIGGER U_ISSUE_STATUS
BEFORE UPDATE OF STATUS ON ISSUE
FOR EACH ROW
BEGIN
    :NEW.STATUS := :OLD.STATUS;
END;

--X DISPARADORES
DROP TRIGGER U_ISSUE_STATUS;
DROP TRIGGER C_ISSUE_DATE;
DROP TRIGGER C_ISSUE_REF;

/*DISPARADORES OK*/
SELECT * FROM ISSUE;
INSERT INTO ISSUE VALUES (6,to_date('Sat, 12 Aug 2017 08:16:00', 'DY, DD MON YYYY HH24:MI:SS'), 9, 'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta)', 'AW1', 'AE1', 'Open');
INSERT INTO ISSUE VALUES (100,to_date('Sat, 12 Aug 2017 08:16:00', 'DY, DD MON YYYY HH24:MI:SS'), 9, 'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta)', 'AW1', 'AE1', 'Closed');

/*DISPARADORES NO OK*/
UPDATE ISSUE SET STATUS = 'MAMS';
UPDATE ISSUE SET STATUS = 'KARA';
UPDATE ISSUE SET STATUS = 'ASFD';
UPDATE ISSUE SET STATUS = 'NOTI';
UPDATE ISSUE SET STATUS = 'PAPA';




