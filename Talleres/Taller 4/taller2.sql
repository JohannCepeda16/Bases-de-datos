--CREATE--
CREATE TABLE CLIENTES(TID VARCHAR2(2) NOT NULL, NID NUMBER(15) NOT NULL, NOMBRE VARCHAR2(20) NOT NULL, CORREO VARCHAR2(10));
CREATE TABLE TELEFONOS(CLIENTE NUMBER(15) NOT NULL, TELEFONO VARCHAR2(10) NOT NULL);
CREATE TABLE CLIENTES_RECOMIENDAN(CLIENTE1 NUMBER(15) NOT NULL,CLIENTE2 NUMBER(15) NOT NULL);
CREATE TABLE FACTURAS(CLIENTE NUMBER(15) NOT NULL, NUMERO INTEGER NOT NULL, FECHA DATE NOT NULL);
CREATE TABLE LINEA_FACTURAS(FACTURA INTEGER NOT NULL,BIEN VARCHAR2(5) NOT NULL, CANTIDAD INTEGER NOT NULL,PRECIOVENTA NUMBER(8,2) NOT NULL);
CREATE TABLE BIENES(CODIGO VARCHAR2(5), NOMBRE VARCHAR2(10) NOT NULL, PRECIOVENTA INTEGER NOT NULL);
CREATE TABLE SERVICIOS(BIEN VARCHAR2(5) NOT NULL,MANODEOBRA INTEGER NOT NULL);
CREATE TABLE PRODUCTOS(BIEN VARCHAR2(5) NOT NULL, EXISTENCIAS INTEGER NOT NULL,PRECIOCOMPRA INTEGER NOT NULL);
CREATE TABLE PRODUCTOS_REMPLAZAN_PRODUCTOS(PRODUCTO1 VARCHAR(5) NOT NULL,PRODUCTO2 VARCHAR(5) NOT NULL);
CREATE TABLE UTILIZAN(SERVICIO VARCHAR(5) NOT NULL,PRODUCTO VARCHAR(5) NOT NULL,UNIDADES INTEGER NOT NULL);

--ESTRUCTURA DECLARATIVA--

--PRIMARIAS--

ALTER TABLE CLIENTES ADD CONSTRAINT PK_CLIENTES 
	PRIMARY KEY(TID, NID);
ALTER TABLE TELEFONOS ADD CONSTRAINT PK_TELEFONOS 
	PRIMARY KEY(CLIENTE,TELEFONO);
ALTER TABLE CLIENTES_RECOMIENDAN ADD CONSTRAINT PK_CLIENTES_RECOMIENDAN 
	PRIMARY KEY(CLIENTE1,CLIENTE2);
ALTER TABLE FACTURAS ADD CONSTRAINT PK_FACTURAS 
	PRIMARY KEY(NUMERO);
ALTER TABLE LINEA_FACTURAS ADD CONSTRAINT PK_LINEA_FACTURAS 
	PRIMARY KEY(FACTURA);
ALTER TABLE BIENES ADD CONSTRAINT PK_BIENES
	PRIMARY KEY(CODIGO);
ALTER TABLE SERVICIOS ADD CONSTRAINT PK_SERVICIOS 
	PRIMARY KEY(BIEN);
ALTER TABLE PRODUCTOS ADD CONSTRAINT PK_PRODUCTOS 
	PRIMARY KEY(BIEN);
ALTER TABLE PRODUCTOS_REMPLAZAN_PRODUCTOS ADD CONSTRAINT PK_PRODUCTOS_REMPLAZAN_PRODUCTOS
	PRIMARY KEY(PRODUCTO1,PRODUCTO2);
ALTER TABLE UTILIZAN ADD CONSTRAINT PK_UTILIZAN 
	PRIMARY KEY(SERVICIO,PRODUCTO);

--UNICAS--

ALTER TABLE CLIENTES ADD CONSTRAINT UK_CLIENTES UNIQUE(CORREO);

--FORANEAS--

ALTER TABLE TELEFONOS ADD CONSTRAINT FK_TELEFONOS 
	FOREIGN KEY(CLIENTE) REFERENCES CLIENTES(NID);
ALTER TABLE CLIENTES_RECOMIENDAN ADD CONSTRAINT FK_CLIENTES_RECOMIENDAN_1 
	FOREIGN KEY(CLIENTE1) REFERENCES CLIENTES(NID);
ALTER TABLE CLIENTES_RECOMIENDAN ADD CONSTRAINT FK_CLIENTES_RECOMIENDAN_2 
	FOREIGN KEY(CLIENTE2) REFERENCES CLIENTES(NID);
ALTER TABLE FACTURAS ADD CONSTRAINT FK_FACTURAS 
	FOREIGN KEY(CLIENTE) REFERENCES CLIENTES(NID);
ALTER TABLE LINEA_FACTURAS ADD CONSTRAINT FK_LINEA_FACTURAS_1 
	FOREIGN KEY(FACTURA) REFERENCES FACTURAS(NUMERO);
ALTER TABLE LINEA_FACTURAS ADD CONSTRAINT FK_LINEA_FACTURAS_2 
	FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO);
ALTER TABLE SERVICIOS ADD CONSTRAINT FK_SERVICIOS 
	FOREIGN KEY(BIEN) REFERENCES BIENES(CODIGO);
ALTER TABLE UTILIZAN ADD CONSTRAINT FK_UTILIZAN_1 
	FOREIGN KEY(SERVICIO) REFERENCES SERVICIOS(BIEN);
ALTER TABLE UTILIZAN ADD CONSTRAINT FK_UTILIZAN_2 
	FOREIGN KEY(PRODUCTO) REFERENCES PRODUCTOS(BIEN);
ALTER TABLE PRODUCTOS_REMPLAZAN_PRODUCTOS ADD CONSTRAINT FK_PRODUCTOS_REMPLAZAN_PRODUCTOS_1 
	FOREIGN KEY(PRODUCTO1) REFERENCES PRODUCTOS(BIEN);
ALTER TABLE PRODUCTOS_REMPLAZAN_PRODUCTOS ADD CONSTRAINT FK_PRODUCTOS_REMPLAZAN_PRODUCTOS_2 
	FOREIGN KEY(PRODUCTO2) REFERENCES PRODUCTOS(BIEN);

--ATRIBUTOS--

ALTER TABLE SERVICIO ADD CONSTRAINT CK_UNIQUE_HERENCY
	CHECK(SERVICIOS.BIEN != PRODUCTOS.BIEN);
CREATE ASERTION SELL_PRICE_GREATER_BUY_PRICE
	CHECK(
            EXIST( 
				SELECT 
				BIEN,PRECIOCOMPRA 
				FROM 
				PRODUCTOS 
				INNER JOIN(
					SELECT 
					CODIGO, PRECIOVENTA 
					FROM 
					BIENES
					)
				ON BIENES.CODIGO = PRODUCTOS.BIEN AND BIENES.PRECIOVENTA = PRODUCTOS.PRECIOCOMPRA + (PRODUCTOS.PRECIOCOMPRA * 0.10)
			)
		);
ALTER TABLE CLIENTE ADD CONSTRAINT CK_TID
	CHECK(TID IN ('CC','CE','NT'));
ALTER TABLE CLIENTES_RECOMIENDAN ADD CONSTRAINT CK_NOT_AUTO_COMMEND
	CHECK(CLIENTE1 != CLIENTE2);
CREATE ASERTION SELL_PRICE_CANT_DECREASE
	CHECK(
		NOT EXIST(
			SELECT
			*
			FROM LINEA_FACTURAS AS P1

			INNER JOIN LINEA_FACTURAS AS P2
			ON P1.BIEN = P2.BIEN AND P1.CANTIDAD > P2.CANTIDAD AND P1.PRECIOVENTA < P2.PRECIOVENTA
			)
		);

/*NO ENTENDIMOS EL 5 DE FACTURA DE DECLARATIVAS*/

--ESTRUCTURA PROCEDIMENTAL--
--MANTENER BIEN
/*En caso que no se asigne código a un bien, se genera automáticamente tomando las primeras letras
de su nombre, si no está asignado*/
CREATE OR REPLACE TRIGGER T_CODIGO_BIEN
AFTER INSERT ON BIENES
WHEN (BIENES.CODIGO = null)
BEGIN
	UPDATE BIENES SET CODIGO = (SELECT SUBSTR(BIENES.NOMBRE, 1,5) 
								FROM BIENES
								WHERE BIENES.CODIGO = CODIGO
								)
END

--MANTENER CLIENTE
/*En el momento de creación, si un cliente no indica correo se le trata de asignar uno ofrecido por
vendemos: nid@vendemos.com.co, si no está asignado */
CREATE OR REPLACE TRIGGER T_CORREO_CLIENTE
BEFORE INSERT ON CLIENTES
/*SE EJECUTA PARA CADA UNO DE LOS INSERT*/
FOR EACH ROW
DECLARE
	CORREO VARCHAR2(10);
BEGIN
	IF(:NEW.CORREO IS NULL) THEN
		CORREO := CONCAT(:NEW.NID, '@vendemos.com.co')
		/*VALIDAR CORREO NO EXISTE*/
		:NEW.CORREO := CORREO
	END IF;
END

/*No está permitido modificar los datos de identificación de los clientes.*/
CREATE OR REPLACE TRIGGER T_ID_NO_MODF
BEFORE UPDATE OF TID OR NID ON CLIENTES
FOR EACH ROW
BEGIN
    :NEW.TID := :OLD.TID;
	:NEW.NID := :OLD.NID;
END;

--REGISTRAR FACTURA
/*¿Cuáles son los datos mínimos para adicionar una línea de factura? ¿Cómo se definen los otros? ¿Qué
se debe hacer para mantener todo consistente? Implemente la automatización.*/
CREATE OR REPLACE TRIGGER T_AUTO_FACT
AFTER INSERT ON FACTURAS
BEGIN
    UPDATE FACTURAS SET NUMERO = (SELECT NUMERO FROM (
    SELECT NUMERO FROM FACTURAS ORDER BY NUMERO DESC
    ) WHERE ROWNUM = 1) + 1;
END;

/*Ni las facturas, ni sus detalles, se deben poder eliminar ni modificar. Es un registrar. Lance una
excepción de aplicación indicando que no es posible hacerlo.*/
CREATE OR REPLACE TRIGGER T_FACT_NO_MODF
BEFORE UPDATE OF CLIENTE OR NUMERO OR FECHA FACTURAS
BEGIN
	RAISE_APPLICATION_ERROR(-20001, 'NO ES POSIBLE MODIFICAR O ELMINAR FACTURAS Y SUS DETALLES');
END

--CONSULTAS
SELECT MANODEOBRA, PRECIOCOMPRA, COSTO, PRECIOVENTA, (PRECIOVENTA - PRECIOCOMPRA) AS UTILIDAD_ESPERADA
FROM BIENES
JOIN SERVICIOS ON (BIENES.CODIGO = SERVICIOS.CODIGO)
JOIN PRODUCTOS ON (BIENES.CODIGO = PRODUCTOS.CODIGO)
JOIN FACTURAS ON (FACTURAS.NUMERO = LINEA_FACTURAS.FACTURA AND LINEA_FACTURAS.BIEN = BIENES.CODIGO)
WHERE BIENES.NOMBRE = 'CSERVICIO';

SELECT CODIGO, NOMBRE, PRECIOVENTA, PRECIOCOMPRA, (PRECIOVENTA - PRECIOCOMPRA) AS UTILIDAD
FROM BIENES
JOIN PRODUCTOS ON (BIENES.CODIGO = PRODUCTOS.CODIGO)
ORDER BY (PRECIOVENTA - PRECIOCOMPRA) ASC