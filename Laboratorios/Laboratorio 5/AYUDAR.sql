/*CICLO 1: CRUD: BENEFICIARIOS*/

/*ESTRUCTURA Y RESTRICCIONES DECLARATIVAS*/

/*PERSISTENCIA*/

--TABLAS--
CREATE TABLE PERSONAS(
	CODIGO NUMBER NOT NULL,
	OPINION NUMBER NOT NULL, 
	NOMBRE VARCHAR2(50) NOT NULL, 
	GENERO VARCHAR2(1) NOT NULL, 
	TALLA VARCHAR2(3) NOT NULL, 
	NACIMIENTO DATE NOT NULL, 
	FAMILIA NUMBER(5)
);

----------------LAB 05----------------	
CREATE TABLE PRODUCTOS(
	BIEN VARCHAR2(10) NOT NULL,
	NOMBRE VARCHAR(100) NOT NULL,
	PRECIO_VENTA NUMBER(9) NOT NULL, 
	EXISTENCIAS NUMBER(10), 
	PRECIO_COMPRA NUMBER(6),
	DESCRIPCION VARCHAR2(250),
	RECOMENDACIONES VARCHAR2(250)
);

CREATE TABLE COMPONENTES(
	PRODUCTO VARCHAR2(10) NOT NULL,
	COMPONENTE VARCHAR(250) NOT NULL
);

CREATE TABLE SERVICIOS(
	BIEN VARCHAR2(10) NOT NULL,
	NOMBRE VARCHAR2(100) NOT NULL,
	PRECIO_VENTA NUMBER(9) NOT NULL,
	MANO_OBRA NUMBER (9) NOT NULL,
	RECOMENDACIONES VARCHAR2(250)
);

CREATE TABLE INSUMOS(
	SERVICIO VARCHAR2(10) NOT NULL,
	PRODUCTO VARCHAR2(10) NOT NULL,
	UNIDADES NUMBER(2) NOT NULL
);

----------------LAB 05----------------

CREATE TABLE ASIGNACIONES(
	NUMERO NUMBER(9) NOT NULL, 
	FECHA DATE NOT NULL, 
	ACEPTADO NUMBER(1)
	);
CREATE TABLE DETALLES(
	ORDEN NUMBER(4) NOT NULL, 
	BIEN VARCHAR2(5) NOT NULL, 
	ASIGNACION NUMBER(9) NOT NULL
	);
CREATE TABLE BIENES(
	CODIGO VARCHAR2(10) NOT NULL,
	NOMBRE VARCHAR2(30) NOT NULL,
	TIPO VARCHAR2(1) NOT NULL,
	MEDIDA VARCHAR2(2) NOT NULL,
	UNITARIO NUMBER(5) NOT NULL,
	RETIRADO NUMBER(1) NOT NULL
	);
CREATE TABLE OPINIONES(
	NUMERO NUMBER(5) NOT NULL,
	FECHA DATE NOT NULL,
	OPINION VARCHAR2(1) NOT NULL,
	JUSTIFICACION VARCHAR2(20) NOT NULL,
	BIEN VARCHAR2(5) NOT NULL
	);
CREATE TABLE FAMILIAS(
	NUMERO NUMBER(5) NOT NULL, 
	REPRESENTANTE NUMBER NOT NULL, 
	ASIGNACION NUMBER(9),
	LOCALIDAD VARCHAR2(15) NOT NULL
	);
CREATE TABLE ALOJAMIENTOS(
	ID INTEGER NOT NULL, 
	ORDEN NUMBER(4) NOT NULL, 
	PERSONAS NUMBER(4) NOT NULL, 
	INICIO DATE NOT NULL, 
	FIN DATE NOT NULL,
    LOCALIDAD VARCHAR2(15) NOT NULL
	);
CREATE TABLE VESTUARIOS(
	ID INTEGER NOT NULL, 
	ORDEN NUMBER(4) NOT NULL, 
	CANTIDAD NUMBER(4) NOT NULL, 
	TALLA VARCHAR2(3) NOT NULL
	);
CREATE TABLE PERECEDEROS(
	ID INTEGER NOT NULL, 
	ORDEN NUMBER(4) NOT NULL, 
	CANTIDAD NUMBER(4) NOT NULL, 
	VENCIMIENTO DATE NOT NULL
	);
CREATE TABLE GENERICOS(
	ID INTEGER NOT NULL, 
	ORDEN NUMBER(4) NOT NULL, 
	CANTIDAD NUMBER(4) NOT NULL
	);
CREATE TABLE ADULTOS(
	CODIGO NUMBER NOT NULL, 
	CEDULA NUMBER(12) NOT NULL, 
	CORREO VARCHAR2(40) NOT NULL
	);
CREATE TABLE TELEFONOS(
	ADULTO NUMBER(12) NOT NULL, 
	TELEFONO NUMBER(11) NOT NULL);
	
CREATE TABLE OPINIONES_GRUPALES(
	NUMERO NUMBER(5) NOT NULL, 
	RAZON XMLTYPE,
	ESTRELLAS NUMBER(1) NOT NULL
	);
CREATE TABLE LOCALIDADES(
	NOMBRE VARCHAR2(15) NOT NULL, 
	PRIORIDAD NUMBER(1) NOT NULL, 
	DEPARTAMENTO VARCHAR2(15) NOT NULL
	);

--ATRIBUTOS--
ALTER TABLE PERSONAS ADD CONSTRAINT CK_PERSONAS_GENERO
	CHECK(GENERO IN ('M','F','O'));
ALTER TABLE PERSONAS ADD CONSTRAINT CK_PERSONAS_TALLA
	CHECK(TALLA IN ('XS','S','M','L','XL'));
ALTER TABLE ASIGNACIONES ADD CONSTRAINT CK_ASIGNACIONES_ACEPTADO
	CHECK(ACEPTADO IN (0,1));
ALTER TABLE DETALLES ADD CONSTRAINT CK_DETALLES_ORDEN
	CHECK(ORDEN > 0);
ALTER TABLE BIENES ADD CONSTRAINT CK_BIENES_TIPO
	CHECK(TIPO IN ('G','P','V','A'));
ALTER TABLE BIENES ADD CONSTRAINT CK_BIENES_UNITARIO
	CHECK(UNITARIO >= 0);
ALTER TABLE BIENES ADD CONSTRAINT CK_BIENES_RETIRADO
	CHECK(RETIRADO IN (0,1));
ALTER TABLE OPINIONES ADD CONSTRAINT CK_OPINIONES_OPINION
	CHECK(OPINION IN ('E','B','R','M'));
ALTER TABLE TELEFONOS ADD CONSTRAINT CK_TELEFONOS_TELEFONO
	CHECK(LENGTH(TELEFONO) >= 7);

--PRIMARIAS--
----------------LAB 05----------------
ALTER TABLE PRODUCTOS ADD CONSTRAINT PK_PRODUCTOS
	PRIMARY KEY(BIEN);
ALTER TABLE SERVICIOS ADD CONSTRAINT PK_SERVICIOS
	PRIMARY KEY(BIEN);
ALTER TABLE COMPONENTES ADD CONSTRAINT PK_COMPONENTES
	PRIMARY KEY(PRODUCTO, COMPONENTE);
ALTER TABLE INSUMOS ADD CONSTRAINT PK_INSUMOS
	PRIMARY KEY(SERVICIO, PRODUCTO);
----------------LAB 05----------------

ALTER TABLE PERSONAS ADD CONSTRAINT PK_PERSONAS 
	PRIMARY KEY(CODIGO);
ALTER TABLE ASIGNACIONES ADD CONSTRAINT PK_ASIGNACIONES 
	PRIMARY KEY(NUMERO);
ALTER TABLE BIENES ADD CONSTRAINT PK_BIENES 
	PRIMARY KEY(CODIGO);
ALTER TABLE OPINIONES ADD CONSTRAINT PK_OPINIONES 
	PRIMARY KEY(NUMERO);
ALTER TABLE FAMILIAS ADD CONSTRAINT PK_FAMILIAS 
	PRIMARY KEY(NUMERO);
ALTER TABLE ADULTOS ADD CONSTRAINT PK_ADULTOS 
	PRIMARY KEY(CEDULA); 
ALTER TABLE ALOJAMIENTOS ADD CONSTRAINT PK_ALOJAMIENTOS 
	PRIMARY KEY(ID);
ALTER TABLE PERECEDEROS ADD CONSTRAINT PK_PERECEDEROS 
	PRIMARY KEY(ID);
ALTER TABLE VESTUARIOS ADD CONSTRAINT PK_VESTUARIOS 
	PRIMARY KEY(ID);
ALTER TABLE GENERICOS ADD CONSTRAINT PK_GENERICOS 
	PRIMARY KEY(ID);
ALTER TABLE TELEFONOS ADD CONSTRAINT PK_TELEFONOS 
	PRIMARY KEY(ADULTO, TELEFONO);
ALTER TABLE OPINIONES_GRUPALES ADD CONSTRAINT PK_OPINIONES_GRUPALES 
	PRIMARY KEY(NUMERO);
ALTER TABLE DETALLES ADD CONSTRAINT PK_DETALLES
    PRIMARY KEY(ORDEN);
ALTER TABLE LOCALIDADES ADD CONSTRAINT PK_LOCALIDADES
    PRIMARY KEY(NOMBRE);

--UNICAS--
ALTER TABLE OPINIONES ADD CONSTRAINT UK_OPINIONES 
	UNIQUE(JUSTIFICACION);

--FORANEAS--
----------------LAB 05----------------
ALTER TABLE PRODUCTOS ADD CONSTRAINT FK_PRODUCTOS_BIEN
	FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO);
ALTER TABLE SERVICIOS ADD CONSTRAINT FK_SERVICIOS_BIEN
	FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO);
ALTER TABLE COMPONENTES ADD CONSTRAINT FK_COMPONENTES_PRODUCTOS
	FOREIGN KEY(PRODUCTO) REFERENCES PRODUCTOS(BIEN);
ALTER TABLE INSUMOS ADD CONSTRAINT FK_INSUMOS_SERVICIOS
	FOREIGN KEY(SERVICIO) REFERENCES SERVICIOS(BIEN);
ALTER TABLE INSUMOS ADD CONSTRAINT FK_INSUMOS_PRODUCTO
    FOREIGN KEY(PRODUCTO) REFERENCES PRODUCTOS(BIEN);
----------------LAB 05----------------
ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS1 
	FOREIGN KEY(OPINION) REFERENCES OPINIONES(NUMERO) ON DELETE CASCADE;
ALTER TABLE DETALLES ADD CONSTRAINT FK_DETALLES1 
	FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO) ON DELETE CASCADE;
ALTER TABLE DETALLES ADD CONSTRAINT FK_DETALLES2 
	FOREIGN KEY(ASIGNACION) REFERENCES ASIGNACIONES(NUMERO) ON DELETE CASCADE;
ALTER TABLE PERECEDEROS ADD CONSTRAINT FK_PERECEDEROS_DETALLES 
	FOREIGN KEY(ORDEN) REFERENCES DETALLES(ORDEN) ON DELETE CASCADE;
ALTER TABLE GENERICOS ADD CONSTRAINT FK_GENERICOS_DETALLES 
	FOREIGN KEY(ORDEN) REFERENCES DETALLES(ORDEN) ON DELETE CASCADE;
ALTER TABLE ALOJAMIENTOS ADD CONSTRAINT FK_ALOJAMIENTOS_DETALLES 
	FOREIGN KEY(ORDEN) REFERENCES DETALLES(ORDEN) ON DELETE CASCADE;
ALTER TABLE VESTUARIOS ADD CONSTRAINT FK_VESTUARIOS_ORDEN 
	FOREIGN KEY(ORDEN) REFERENCES DETALLES(ORDEN) ON DELETE CASCADE;
ALTER TABLE TELEFONOS ADD CONSTRAINT FK_TELEFONOS_ADULTOS 
	FOREIGN KEY(ADULTO) REFERENCES ADULTOS(CEDULA) ON DELETE CASCADE;
ALTER TABLE ADULTOS ADD CONSTRAINT FK_ADULTOS_CODIGO 
	FOREIGN KEY(CODIGO) REFERENCES PERSONAS(CODIGO) ON DELETE CASCADE;
ALTER TABLE OPINIONES ADD CONSTRAINT FK_OPINIONES_BIEN 
	FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO) ON DELETE CASCADE;
ALTER TABLE FAMILIAS ADD CONSTRAINT FK_FAMILIAS_LOCALIDAD 
	FOREIGN KEY(LOCALIDAD) REFERENCES LOCALIDADES(NOMBRE) ON DELETE CASCADE;
ALTER TABLE FAMILIAS ADD CONSTRAINT FK_FAMILIAS_REPRESENTANTE
	FOREIGN KEY(REPRESENTANTE) REFERENCES PERSONAS(CODIGO) ON DELETE CASCADE;
ALTER TABLE FAMILIAS ADD CONSTRAINT FK_FAMILIAS_ASIGNACION
	FOREIGN KEY(ASIGNACION) REFERENCES ASIGNACIONES(NUMERO) ON DELETE CASCADE;
ALTER TABLE ALOJAMIENTOS ADD CONSTRAINT FK_ALOJAMIENTOS_LOCALIDAD
	FOREIGN KEY(LOCALIDAD) REFERENCES LOCALIDADES(NOMBRE) ON DELETE CASCADE;
ALTER TABLE OPINIONES_GRUPALES ADD CONSTRAINT FK_OPINIONES_GRUPALES_CODIGO
	FOREIGN KEY(NUMERO) REFERENCES OPINIONES(NUMERO);

--XTABLAS--
DROP TABLE PERSONAS;
DROP TABLE ASIGNACIONES;
DROP TABLE DETALLES;
DROP TABLE BIENES;
DROP TABLE OPINIONES;
DROP TABLE FAMILIAS;
DROP TABLE ALOJAMIENTO;
DROP TABLE VESTUARIO;
DROP TABLE PERECEDEROS;
DROP TABLE GENERICO;
DROP TABLE TELEFONOS;
DROP TABLE ADULTOS;
DROP TABLE OPINIONES_GRUPALES;
DROP TABLE LOCALIDAD;

/*PRUEBAS*/

--PoblarOK--
INSERT INTO BIENES VALUES('C25369', 'Liquido para vidrio', 'G', 'A', 18000, 0);
INSERT INTO BIENES VALUES('C493256', 'Jabon en polvo', 'G', 'A', 18000, 0);
INSERT INTO BIENES VALUES('C32014', 'Limpiador con caucho y esponja', 'G', 'A', 50000, 0);
INSERT INTO BIENES VALUES('LVEDA', 'Lavado de vidrios en edificios', 'G', 'A', 50000, 0);
INSERT INTO BIENES VALUES('LPISO', 'Limpieza acrilicos', 'G', 'A', 50000, 0);

----------------LAB 05----------------
--PRODUCTOS
INSERT INTO PRODUCTOS VALUES('C25369', 'Líquido para vidrios', '20000', '10', '18000', 'La esponja esta cubierta en nylon. Largo de esponja y escurridor de caucho: 8 pulgadas. En Unidad.', null);
INSERT INTO PRODUCTOS VALUES('C493256', 'Jabón en polvo', '2000', '100', '18000', null, 'No dejar al alcance de los niños');
INSERT INTO PRODUCTOS VALUES('C32014', 'Limpiador con caucho y esponja', '50000', null, null, null, null);

--COMPONENTES DE ULTIMO PRODUCTO ^^
INSERT INTO COMPONENTES VALUES('C32014', 'AGUA 930 c.c.');
INSERT INTO COMPONENTES VALUES('C32014', 'COLOR - ANILINA (VEGETAL) 1 Gramo');
INSERT INTO COMPONENTES VALUES('C32014', 'GENAPOL LRO 1 c.c. EDTA 1 c.c.');
INSERT INTO COMPONENTES VALUES('C32014', 'MERGAL 1 c.c.');
INSERT INTO COMPONENTES VALUES('C32014', 'BUTIL CELLOSOLVE 50 c.c.');
INSERT INTO COMPONENTES VALUES('C32014', 'ALCOHOL ISOPROPILICO 20 c.c');

--SERVICIOS
INSERT INTO SERVICIOS VALUES('LVEDA', 'Lavado vidrios edificios', '500000', '100000', 'En edificios de más de cinco pisos usar andamios tipo B');
INSERT INTO SERVICIOS VALUES('LPISO', 'Limpieza pisos acrilicos', '40000', '5000', 'En edificios de más de cinco pisos usar andamios tipo B');

--INSUMOS
INSERT INTO INSUMOS VALUES('LVEDA', 'C25369', '10');
INSERT INTO INSUMOS VALUES('LVEDA', 'C32014', '2');

INSERT INTO INSUMOS VALUES('LPISO', 'C25369', '10');
INSERT INTO INSUMOS VALUES('LPISO', 'C493256', '1');

----------------LAB 05----------------
INSERT INTO LOCALIDADES VALUES('Tunjuelito', 3, 'Bogota');
INSERT INTO LOCALIDADES VALUES('Barrios unidos', 5, 'Bogota');
INSERT INTO LOCALIDADES VALUES('Kenedy', 1, 'Bogota');

INSERT INTO ASIGNACIONES VALUES(1, to_date('1 06 2020', 'DD MM YYYY'), 1);
INSERT INTO ASIGNACIONES VALUES(3, to_date('2 06 2020', 'DD MM YYYY'), 0);
INSERT INTO ASIGNACIONES VALUES(2, to_date('3 06 2020', 'DD MM YYYY'), 1);

INSERT INTO BIENES VALUES('AA010', 'Casa campestre', 'A', 'A', 12500, 0);
INSERT INTO BIENES VALUES('AA020', 'Carro deportivo', 'G', 'A', 1500, 0);
INSERT INTO BIENES VALUES('AA011', 'Cacerola', 'G', 'A', 99999, 1);

INSERT INTO DETALLES VALUES(1,'AA010', 1);
INSERT INTO DETALLES VALUES(2,'AA020', 3);
INSERT INTO DETALLES VALUES(3,'AA011', 2);

INSERT INTO OPINIONES VALUES(1, to_date('12 11 2020', 'DD MM YYYY'), 'E', 'Me encanto', 'AA010');
INSERT INTO OPINIONES VALUES(2, to_date('13 11 2020', 'DD MM YYYY'), 'M', 'No me gusto', 'AA020');
INSERT INTO OPINIONES VALUES(3, to_date('14 11 2020', 'DD MM YYYY'), 'B', 'Esta bueno', 'AA011');

INSERT INTO OPINIONES_GRUPALES VALUES(1, 'TA BUENO', 5);

INSERT INTO PERSONAS VALUES (1, 1, 'Jorgito', 'M', 'XL', to_date('1 01 2000', 'DD MM YYYY'), 10);
INSERT INTO PERSONAS VALUES (2, 2, 'Laura', 'F', 'S', to_date('2 06 2001', 'DD MM YYYY'), 6);
INSERT INTO PERSONAS VALUES (3, 3, 'Martina', 'F', 'M', to_date('3 06 2002', 'DD MM YYYY'), 0);

INSERT INTO ADULTOS VALUES(1, 1000712829, 'jorgod@amsda.com');
INSERT INTO ADULTOS VALUES(2, 1222712829, 'laurel@amsdx.com');
INSERT INTO ADULTOS VALUES(3, 1333712829, 'martiprox@amsaa.com');

INSERT INTO ALOJAMIENTOS VALUES(1,1,2, to_date('12 11 2020', 'DD MM YYYY'), to_date('12 11 2021', 'DD MM YYYY') , 'Kenedy');

INSERT INTO VESTUARIOS VALUES(1,1, 15, 'XL');

INSERT INTO PERECEDEROS VALUES(1,1,2, to_date('12 11 2022', 'DD MM YYYY'));

INSERT INTO GENERICOS VALUES(1, 2, 1);
INSERT INTO GENERICOS VALUES(2, 3, 1);

INSERT INTO TELEFONOS VALUES(1000712829, 3105555556);
INSERT INTO TELEFONOS VALUES(1000712829, 3006646566);
INSERT INTO TELEFONOS VALUES(1333712829, 3155153443);

INSERT INTO FAMILIAS VALUES(10, 1, 1, 'Tunjuelito');
INSERT INTO FAMILIAS VALUES(0, 3, 2, 'Kenedy');
INSERT INTO FAMILIAS VALUES(6, 2, 3, 'Barrios unidos');

--PoblarNoOk--

----------------LAB 05----------------
--PRODUCTOS
/*INSERTAR PRODUCTOS CON CODIGO DE BIEN INEXISTENTE*/
INSERT INTO PRODUCTOS VALUES('C253', 'Líquido para vidrios', '20000', '10', '18000', 'La esponja esta cubierta en nylon. Largo de esponja y escurridor de caucho: 8 pulgadas. En Unidad.', null);
/*INSERTAR PRODUCTOS CON CODIGO REPETIDO*/
INSERT INTO PRODUCTOS VALUES('C32014', 'Jabón en polvo', '2000', '100', '18000', null, 'No dejar al alcance de los niños');
/*INSERTAR PRODUCTOS CON LONGITUD MAYOR A LA DEFINIDA*/
INSERT INTO PRODUCTOS VALUES('C32014', 'Limpiador con caucho y esponja', '5054546548463486465168416000', null, null, null, null);

--COMPONENTES DE ULTIMO PRODUCTO ^^
/*INSERTAR VALORES NULOS*/
INSERT INTO COMPONENTES VALUES(null,null);
/*INSERTAR CODIGO QUE NO EXISTE*/
INSERT INTO COMPONENTES VALUES('X014', 'COLOR - ANILINA (VEGETAL) 1 Gramo');
/*INSERTAR UN TIPO DE DATO INCORRECTO*/
INSERT INTO COMPONENTES VALUES(014, 'COLOR - ANILINA (VEGETAL) 1 Gramo');

--SERVICIOS
/*INSERTAR VALORES NULOS*/
INSERT INTO SERVICIOS VALUES(null, 'Lavado vidrios edificios', '500000', '100000', 'En edificios de más de cinco pisos usar andamios tipo B');
/*INSERTAR TIDO DE DATO INCORRECTO*/
INSERT INTO SERVICIOS VALUES(1XXS5, 'Limpieza pisos acrilicos', '40000', '5000', 'En edificios de más de cinco pisos usar andamios tipo B');

--INSUMOS
/*INSERTAR VALORES NULOS*/
INSERT INTO INSUMOS VALUES(null, 'C25369', '10');
/*INSERTAR VALORES INCORRECTOS*/
INSERT INTO INSUMOS VALUES('LVEDA', 'C32014', 2);

/*INSERTAR CODIGOS INEXISTENTES*/
INSERT INTO INSUMOS VALUES('LPERREO', 'C25369', '10');
/*INSERTAR VALORES FUERA DEL TAMAÑO DEFINIDO*/
INSERT INTO INSUMOS VALUES('LPISO', 'C493256', '1ASDFADF21312312SFASDFASDFASDFASDF123413241341234DFSA');
----------------LAB 05----------------

--INGRESAR UNA PERSONA CON UN NUMERO COMO VARCHAR--
INSERT INTO PERSONAS VALUES ('1', 'E', 'Jorgito', 1, 'XL', to_date('12 06 2000', 'DD MM YYYY'), 10);
--INGRESAR UNA ASIGNACION CON # FAMILIA COMO STRING--
INSERT INTO ASIGNACIONES VALUES(3, to_date('12 06 2020', 'DD MM YYYY'), 1, 'SEIS');
--INGRESAR DETALLES COMO VARCHARS--
INSERT INTO DETALLES VALUES('15 2', 'AA010', ' 3');
--INGRESAR BIENES CON MAS DIGITOS DE LOS PERMITIDOS--
INSERT INTO BIENES VALUES(3, 'Mansion', 'G', 'BG', 9999999, 1);
--INGRESAR MAL LA FECHA--
INSERT INTO OPINIONES VALUES(3,'12 06 2021', 'B', 'Ta bueno', 9999);
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
TRUNCATE TABLE FAMILIAS;
TRUNCATE TABLE ALOJAMIENTO;
TRUNCATE TABLE VESTUARIO;
TRUNCATE TABLE PERECEDEROS;
TRUNCATE TABLE GENERICO;
TRUNCATE TABLE TELEFONOS;
TRUNCATE TABLE ADULTOS;
TRUNCATE TABLE OPINIONES_GRUPALES;
TRUNCATE TABLE LOCALIDAD;

/*Restricciones Declarativas, Procedimentales y Automatización*/

--TUPLAS--

--Tuplas ok no hay
--Tuplas no ok no hay

--ACCIONES--
--ESTAN DEFINIDAS EN LAS LLAVES FORANEAS

--ACCIONES OK--	
SELECT * FROM PERSONAS;
DELETE FROM PERSONAS WHERE NOMBRE = 'Jorgito';

--DISPARADORES--

/*REGISTRAR OPINION*/

--EL NUMERO, LA FECHA SE ASIGNAN AUTOMATICAMENTE--
CREATE OR REPLACE TRIGGER C_OPINION_NUMERO
AFTER INSERT ON OPINIONES
BEGIN
	--NUMERO--
    UPDATE OPINIONES SET NUMERO = (SELECT NUMERO FROM (
    SELECT NUMERO FROM OPINIONES ORDER BY NUMERO DESC
    ) WHERE ROWNUM = 1) + 1;
	
	--FECHA--
	UPDATE OPINIONES SET FECHA = CURRENT_DATE;
END;

--NO SE PUEDE REGISTRAR UNA OPINION DE UN BIEN RETIRADO--
CREATE OR REPLACE TRIGGER C_REGITRAR_RETIRADO
BEFORE INSERT ON OPINIONES
FOR EACH ROW
BEGIN
	IF :NEW.BIEN IN (SELECT CODIGO FROM(
		SELECT CODIGO
		FROM BIENES
		WHERE RETIRADO = 1
	))THEN 
	  RAISE_APPLICATION_ERROR( -20001, 'NO SE PUEDE REGISTRAR UNA OPINION DE UN BIEN RETIRADO');
    END IF;
END;

--LA PERSONA QUE REGISTRA LA OPINION DEBE PERTENECER A LA FAMILIA QUE ACEPTO EL BIEN HACE MENOS DE 3 MESES--
CREATE OR REPLACE TRIGGER C_FAMILY_OPINION
BEFORE INSERT ON OPINIONES
FOR EACH ROW
BEGIN
	IF :NEW.NUMERO NOT IN (
		SELECT FAMILIA
		FROM ASIGNACIONES
		JOIN PERSONAS ON (ASGINACIONES.FAMILIA = PERSONAS.FAMILIA)
		--La opinion existe ? revisar
		JOIN OPINIONES ON (:NEW.NUMERO = PERSONAS.OPINION)
		WHERE ESTADO = 1 AND :NEW.FECHA > ASIGNACIONES.FECHA)
	 THEN	RAISE_APPLICATION_ERROR(-20001, 'LA PERSONA QUE REGISTRA LA OPINION DEBE PERTENECER A LA FAMILIA QUE ACEPTO EL BIEN HACE MENOS DE 3 MESES');
    END IF;
END;

--Si la opinión es M: alo, la justificación debe contener la palabra MALO y tener una longitud mayor a 10--
CREATE OR REPLACE TRIGGER C_OPINION_JUSTIF
BEFORE INSERT ON OPINIONES
FOR EACH ROW
WHEN(:NEW.OPINION = 'M')
BEGIN
	IF :NEW.JUSTIFICACION NOT LIKE '%MALO%' AND LENGTH(:NEW.JUSTIFICACION) < 10
        THEN RAISE_APPLICATION_ERROR(-20001, 'La justificacion debe contener la palabra MALO y tener una longitud mayor a 10');
	END IF;
END;

-- Las opiniones grupales sólo las puede dar el representante familiar.
CREATE OR REPLACE TRIGGER C_OPINION_REPRESENTANTE
BEFORE INSERT ON OPINIONES_GRUPALES
DECLARE
COD NUMBER;
BEGIN
	COD := :NEW.CODIGO;
	IF COD NOT IN(
		SELECT REPRESENTANTE
		FROM FAMILIAS 
		JOIN PERSONAS ON (COD = PERSONAS.OPINION)
		) THEN RAISE_APPLICATION_ERROR(-20001, 'Las opiniones grupales solo las puede dar el representante familiar');
	END IF;
END;

--EL UNICO DATO QUE SE PUEDE MODIFICAR ES Justificacion--
CREATE OR REPLACE TRIGGER C_JISTIF_MODF
AFTER UPDATE ON OPINIONES
BEGIN
	--Es mejor tirar una excepcion al modificar justificacion
	:NEW.NUMERO := :OLD.NUMERO;
	:NEW.FECHA := :OLD.FECHA;
	:NEW.OPINION := :OLD.OPINION;
	:NEW.BIEN := :OLD.BIEN;
END;

--Sólo es posible eliminar la opinión si es la última registrada.--
CREATE OR REPLACE TRIGGER C_DELETE_OPINION
BEFORE DELETE ON OPINIONES
BEGIN
	IF :OLD.NUMERO NOT IN (SELECT NUMERO FROM (
    SELECT NUMERO FROM OPINIONES ORDER BY NUMERO DESC
    ) WHERE ROWNUM = 1) 
		THEN  RAISE_APPLICATION_ERROR(-20001, 'Sólo es posible eliminar la opinión si es la última registrada');
	END IF;
END;


/*REGISTRAR ASIGNACION*/
--EL NUMERO, LA FECHA SE ASIGNAN AUTOMATICAMENTE--
CREATE OR REPLACE TRIGGER C_ASIGNACION_NUMERO
AFTER INSERT ON ASIGNACIONES
BEGIN
	--NUMERO--
    UPDATE ASGINACIONES SET NUMERO = (SELECT NUMERO FROM (
    SELECT NUMERO FROM ASIGNACIONES ORDER BY NUMERO DESC
    ) WHERE ROWNUM = 1) + 1;
	
	--FECHA--
	UPDATE ASIGNACIONES SET FECHA = CURRENT_DATE;
END;

/*REGISTRAR BIENES*/
--LOS VALORES DE RETIRADO SE ASIGNAN AUTOMATICAMENTE--
CREATE OR REPLACE TRIGGER C_ASIGNACION_BIEN
AFTER INSERT ON BIENES
BEGIN
	UPDATE BIENES SET RETIRADO = 0;
END;


-- CREATE ASSERTION CK_NUMERO_PERSONAS
	-- /*ESTA DIFICIL*/
	-- CHECK(
		-- IF (SELECT PERSONAS FROM ALOJAMIENTOS
				-- JOIN DETALLES ON (ALOJAMIENTOS.ORDEN = DETALLES.ORDEN)
					-- JOIN ASIGNACIONES ON (DETALLES.ASIGNACION = ASIGNACIONES.NUMERO)
						-- JOIN FAMILIA AS FAM ON (FAMILIA.ASIGNACION = ASIGNACION.NUMERO))
						-- >= 
						-- (
							-- SELECT COUNT(*) FROM PERSONAS
							-- WHERE PERSONAS.FAMILIA = FAM.NUMERO
						-- )
			
		-- END IF;
	-- )

--ASSERTION NO ESTA EN ORACLE, PERO EXISTE EN SQL--
-- CREATE ASSERTION CK_TALLA_PERSONA 
    -- CHECK(
		-- EXISTS(
			-- SELECT TALLA FROM PERSONAS
				-- JOIN FAMILIAS ON(PERSONAS.FAMILIA = FAMILIAS.NUMERO)
					-- JOIN ASIGNACIONES ON(FAMILIAS.ASIGNACION = ASIGNACIONES.NUMERO)
						-- JOIN DETALLES ON (DETALLES.ASIGNACION = ASIGNACIONES.NUMERO)
			-- WHERE DETALLES.ORDEN = VESTUARIOS.ORDEN AND VESTUARIOS.TALLA = PERSONAS.TALLA
		-- )
	-- );
	
	
--CONSULTA LAB05--
SELECT RAZON FROM OPINIONES_GRUPALES
JOIN OPINIONES ON (OPINIONES.NUMERO = OPINIONES_GRUPALES.NUMERO)
JOIN PERSONAS ON (PERSONAS.OPINION = OPINIONES.NUMERO)
JOIN FAMILIAS ON (PERSONAS.FAMILIA = FAMILIAS.NUMERO)
JOIN ASIGNACIONES ON (FAMILIAS.ASIGNACION = ASIGNACIONES.NUMERO)
JOIN DETALLES ON (ASIGNACIONES.NUMERO = DETALLES.ASIGNACION)
JOIN BIENES ON (DETALLES.BIEN = BIENES.CODIGO)
WHERE ASIGNACIONES.NUMERO = 1;


--Disparadores OK--
--EL NUMERO, LA FECHA SE ASIGNAN AUTOMATICAMENTE--
SELECT * FROM OPINIONES;
INSERT INTO OPINIONES VALUES(10, to_date('12 01 2000', 'DD MM YYYY'), 'E', 'Me encanto', 'AA010');
SELECT * FROM OPINIONES;

SELECT * FROM ASIGNACIONES;
INSERT INTO ASIGNACIONES VALUES(11, to_date('3 06 2020', 'DD MM YYYY'), 0);
SELECT * FROM ASIGNACIONES;

--LOS VALORES DE RETIRADO SE ASIGNAN AUTOMATICAMENTE--
SELECT * FROM BIENES;
INSERT INTO BIENES VALUES('AA012', 'NEVERA', 'G', '', 99999, 1);
SELECT * FROM BIENES;
 

--Disparadores no Ok--
--NO SE PUEDE REGISTRAR UNA OPINION DE UN BIEN RETIRADO--
SELECT * FROM OPINIONES;
INSERT INTO OPINIONES VALUES(15, to_date('14 11 2020', 'DD MM YYYY'), 'B', 'Esta bueno', 'AA011');
SELECT * FROM OPINIONES;

--Si la opinión es M: alo, la justificación debe contener la palabra MALO y tener una longitud mayor a 10--
SELECT * FROM OPINIONES;
INSERT INTO OPINIONES VALUES(17, to_date('14 11 2020', 'DD MM YYYY'), 'M', 'Esta bueno', 'AA010');
SELECT * FROM OPINIONES;

--EL UNICO DATO QUE SE PUEDE MODIFICAR ES Justificacion--
SELECT * FROM OPINIONES;
UPDATE OPINIONES
SET OPINION = 'B'
WHERE OPINION = 'M';
SELECT * FROM OPINIONES;

--Sólo es posible eliminar la opinión si es la última registrada.--
SELECT * FROM OPINIONES;
DELETE OPINIONES
WHERE NUMERO = 1;
SELECT * FROM OPINIONES;

--xDisparadores--
DROP TRIGGER C_OPINION_NUMERO;
DROP TRIGGER C_REGITRAR_RETIRADO;
DROP TRIGGER C_FAMILY_OPINION;
DROP TRIGGER C_OPINION_JUSTIF;
DROP TRIGGER C_OPINION_REPRESENTANTE;
DROP TRIGGER C_JISTIF_MODF;
DROP TRIGGER C_DELETE_OPINION;

--------------------------------------------------------
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;