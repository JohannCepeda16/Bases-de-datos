--Creando--


--Tablas--
CREATE TABLE PERSONAS(CODIGO NUMBER NOT NULL, OPINION NUMBER NOT NULL, NOMBRE VARCHAR2(50) NOT NULL, GENERO VARCHAR2(1) NOT NULL, TALLA VARCHAR2(3) NOT NULL, NACIMIENTO DATE NOT NULL, FAMILIA NUMBER(5));
CREATE TABLE ASIGNACIONES(NUMERO NUMBER(9) NOT NULL, FECHA DATE NOT NULL, ACEPTADO NUMBER(1), FAMILIA INTEGER NOT NULL);
CREATE TABLE DETALLES(ORDEN NUMBER(4) NOT NULL, BIEN VARCHAR2(5) NOT NULL, ASIGNACION NUMBER(9) NOT NULL);
CREATE TABLE BIENES(CODIGO VARCHAR2(5) NOT NULL,NOMBRE VARCHAR2(30) NOT NULL,TIPO VARCHAR2(1) NOT NULL,MEDIDA VARCHAR2(2) NOT NULL,UNITARIO NUMBER(5) NOT NULL,RETIRADO NUMBER(1) NOT NULL);
CREATE TABLE OPINIONES(NUMERO NUMBER(5) NOT NULL,FECHA DATE NOT NULL,OPINION VARCHAR2(1) NOT NULL,JUSTIFICACION VARCHAR2(20) NOT NULL,BIEN INTEGER NOT NULL);
CREATE TABLE FAMILIAS(NUMERO NUMBER(5) NOT NULL);

--XTablas--
DROP TABLE PERSONAS;
DROP TABLE ASIGNACIONES;
DROP TABLE DETALLES;
DROP TABLE BIENES;
DROP TABLE OPINIONES;
DROP TABLE FAMILIAS;


--Poblando--


--PoblarOK--
INSERT INTO PERSONAS VALUES (1, 1, 'Jorgito', 'M', 'XL', to_date('1 01 2000', 'DD MM YYYY'), 10);
INSERT INTO PERSONAS VALUES (2, 2, 'Laura', 'F', 'S', to_date('2 06 2001', 'DD MM YYYY'), 6);
INSERT INTO PERSONAS VALUES (3, 3, 'Martina', 'F', 'M', to_date('3 06 2002', 'DD MM YYYY'), 0);

INSERT INTO ASIGNACIONES VALUES(1, to_date('1 06 2020', 'DD MM YYYY'), 1, 6);
INSERT INTO ASIGNACIONES VALUES(3, to_date('2 06 2020', 'DD MM YYYY'), 0, 0);
INSERT INTO ASIGNACIONES VALUES(2, to_date('3 06 2020', 'DD MM YYYY'), 1, 10);

INSERT INTO DETALLES VALUES(152,'AA010', 3);
INSERT INTO DETALLES VALUES(120,'AA010', 1);
INSERT INTO DETALLES VALUES(15,'AA011', 3);

INSERT INTO BIENES VALUES('AA010', 'Casa campestre', 'A', 'M', 12500, 0);
INSERT INTO BIENES VALUES('AA020', 'Carro deportivo', 'G', 'XS', 1500, 0);
INSERT INTO BIENES VALUES('AA011', 'Mansion', 'G', 'BG', 99999, 1);

INSERT INTO OPINIONES VALUES(1, to_date('12 11 2020', 'DD MM YYYY'), 'E', 'Me encanto', 1);
INSERT INTO OPINIONES VALUES(2, to_date('13 11 2020', 'DD MM YYYY'), 'M', 'No me gusto', 1);
INSERT INTO OPINIONES VALUES(3, to_date('14 11 2020', 'DD MM YYYY'), 'B', 'Esta bueno', 3);

INSERT INTO FAMILIAS VALUES(10);
INSERT INTO FAMILIAS VALUES(6);
INSERT INTO FAMILIAS VALUES(0);

--PoblarNoOK--
--INGRESAR UNA PERSONA CON UN NUMERO COMO VARCHAR--
INSERT INTO PERSONAS VALUES ('1', 'E', 'Jorgito', 1, 'XL', to_date('12 06 2000', 'DD MM YYYY'), 10);
--INGRESAR UNA ASIGNACION CON # FAMILIA COMO STRING--
INSERT INTO ASIGNACIONES VALUES(3, to_date('12 06 2020', 'DD MM YYYY'), 1, 'SEIS');
--INGRESAR DETALLES COMO VARCHARS--
INSERT INTO DETALLES VALUES('15 2', 'AA010', ' 3');
--INGRESAR BIENES CON MAS DIGITOS DE LOS PERMITIDOS--
INSERT INTO BIENES VALUES(3, 'Mansion', 'G', 'BG', 9999999, 1);
--INGRESAR MAL LA FECHA--
INSERT INTO OPINIONES VALUES(3,'12 06 2021', 'B', 'Ta bueno', );
-----------
--INGRESAR UNA PERSONA CON UN GENERO QUE NO EXISTE--
INSERT INTO PERSONAS VALUES (1, 3, 'FABIO', 'P', 'XL', to_date('12 07 2019', 'DD MM YYYY'), 10);
--INGRESAR UNA ASIGNACION CON UN VALOR DIFERENTE DE UNO O DE CERO EN ACEPTADO--
INSERT INTO ASIGNACIONES VALUES(3, to_date('12 06 2019', 'DD MM YYYY'), 8, 6);
--INGRESAR BIENES CON TALLAS QUE NO PERTENECEN--
INSERT INTO BIENES VALUES(3, 'Mansion', 'G', 'TA', 99999, 1);
--INGRESAR OPINIONES CON UNA OPINION QUE NO EXISTE--
INSERT INTO OPINIONES VALUES(3, to_date('12 06 2022', 'DD MM YYYY'), 'X', 'Justificacion', 1);
INSERT INTO OPINIONES VALUES(3, to_date('12 06 2023', 'DD MM YYYY'), 'R', 'Justificacion', 1);

--XPoblar--
TRUNCATE TABLE PERSONAS;
TRUNCATE TABLE ASIGNACIONES;
TRUNCATE TABLE DETALLES;
TRUNCATE TABLE BIENES;
TRUNCATE TABLE OPINIONES;


--Protegiendo--


--Atributos--
ALTER TABLE PERSONAS ADD CONSTRAINT CK_GENERO
	CHECK(GENERO IN ('M','F','O'));
ALTER TABLE PERSONAS ADD CONSTRAINT CK_TALLA
	CHECK(TALLA IN ('XS','S','M','L','XL'));
ALTER TABLE ASIGNACIONES ADD CONSTRAINT CK_ACEPTADO
	CHECK(ACEPTADO IN (0,1));
ALTER TABLE DETALLES ADD CONSTRAINT CK_ORDEN
	CHECK(ORDEN > 0);
ALTER TABLE BIENES ADD CONSTRAINT CK_TIPO
	CHECK(TIPO IN ('G','P','V','A'));
ALTER TABLE BIENES ADD CONSTRAINT CK_UNITARIO
	CHECK(UNITARIO >= 0);
ALTER TABLE BIENES ADD CONSTRAINT CK_RETIRADO
	CHECK(RETIRADO IN (0,1));
ALTER TABLE OPINIONES ADD CONSTRAINT CK_OPINION
	CHECK(OPINION IN ('E','B','R','M'));

--Primarias--
ALTER TABLE PERSONAS ADD CONSTRAINT PK_PERSONAS PRIMARY KEY(CODIGO);
ALTER TABLE ASIGNACIONES ADD CONSTRAINT PK_ASIGNACIONES PRIMARY KEY(NUMERO);
ALTER TABLE BIENES ADD CONSTRAINT PK_BIENES PRIMARY KEY(CODIGO);
ALTER TABLE OPINIONES ADD CONSTRAINT PK_OPINIONES PRIMARY KEY(NUMERO);
ALTER TABLE FAMILIAS ADD CONSTRAINT PK_FAMILIAS PRIMARY KEY(NUMERO);

--Unicas--
ALTER TABLE OPINIONES ADD CONSTRAINT UK_OPINIONES UNIQUE(JUSTIFICACION);

--Foraneas--
ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS1 FOREIGN KEY(OPINION) REFERENCES OPINIONES(NUMERO) ON DELETE CASCADE;
ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS2 FOREIGN KEY(FAMILIA) REFERENCES FAMILIAS(NUMERO) ON DELETE CASCADE;
ALTER TABLE ASIGNACIONES ADD CONSTRAINT FK_ASIGNACIONES FOREIGN KEY(FAMILIA) REFERENCES FAMILIAS(NUMERO) ON DELETE CASCADE;
ALTER TABLE DETALLES ADD CONSTRAINT FK_DETALLES1 FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO) ON DELETE CASCADE;
ALTER TABLE DETALLES ADD CONSTRAINT FK_DETALLES2 FOREIGN KEY(ASIGNACION) REFERENCES ASIGNACIONES(NUMERO) ON DELETE CASCADE;

--PoblarNoOK--
--CK_GENERO--
INSERT INTO PERSONAS VALUES ('1', 'E', 'FABIO', 'P', 'XL', '9/24/2017', 10);
--CK_ACEPTADO--
INSERT INTO ASIGNACIONES VALUES(3, '12/02/2020', 8, 6);
--CK_TALLA--
INSERT INTO BIENES VALUES(3, 'Mansion', 'G', 'TA', 9999999, 1);
--CK_OPINION--
INSERT INTO OPINIONES VALUES(3, to_date('12 06 2000', 'DD MM YYYY'), 'X', 'Xublime', 1);
INSERT INTO OPINIONES VALUES(3, to_date('12 06 2000', 'DD MM YYYY'), 'R', 'Recio', 1);

--Consultando--
SELECT * FROM OPINIONES
	WHERE (OPINION = 'E');

--Bienes con mala opinion--
SELECT * FROM OPINIONES
	WHERE (OPINION = 'M');
    