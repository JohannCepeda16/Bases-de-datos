--XTablas
DROP TABLE Miembros;
DROP TABLE Conductores;
DROP TABLE Clientes;
DROP TABLE Posiciones;
DROP TABLE Viajes;
DROP TABLE Vehiculos;
DROP TABLE PosicionesViajes;
DROP TABLE Solicitudes;
DROP TABLE Precios;
DROP TABLE Descripciones;
DROP TABLE Requerimientos;

--Tablas
CREATE TABLE Miembros (
	id NUMBER NOT NULL,
	tdni CHAR(3) NOT NULL,
	dni VARCHAR(20) NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	apellido VARCHAR(30) NOT NULL
);

CREATE TABLE Conductores (
	id NUMBER NOT NULL,
    fechaNacimiento DATE NOT NULL,
    estrellas NUMBER NOT NULL,
    estado VARCHAR(20)
);

CREATE TABLE Clientes (
	id NUMBER NOT NULL,
    idioma VARCHAR(50)
);

CREATE TABLE Posiciones (
	id NUMBER NOT NULL,
	longitud NUMBER NOT NULL,
	latitud NUMBER NOT NULL
);

CREATE TABLE Viajes (
	id NUMBER NOT NULL,
	fechaInicio DATE NOT NULL,
    fechaFin DATE,
    estado VARCHAR(20) NOT NULL,
    idVehiculo NUMBER NOT NULL,
    idConductor NUMBER NOT NULL
);

CREATE TABLE PosicionesViajes(
    idViaje NUMBER NOT NULL,
    idPosicion NUMBER NOT NULL
);

CREATE TABLE Vehiculos (
	id NUMBER NOT NULL,
	placa VARCHAR(30) NOT NULL,
	estado VARCHAR(8) NOT NULL,
    idConductor NUMBER NOT NULL
);

/*CREANDO*/

/*Dise�e la estructura y las restricciones declarativas del CRUD Registrar Solicitud de Viaje
(modelo f�sico de datos). Implemente las restricciones definidas. Construya tambi�n las
restricciones adicionales necesarias para la ejecuci�n.*/
CREATE TABLE Solicitudes(
    codigo NUMBER NOT NULL,
    cliente NUMBER NOT NULL,
    viaje NUMBER NOT NULL,
    posicion NUMBER NOT NULL,
    fechaCreacion DATE NOT NULL,
    fechaViaje DATE NOT NULL,
    plataforma VARCHAR2(10),
    precio NUMBER,
    estado VARCHAR2(15) NOT NULL,
    descripcion XMLTYPE
);

CREATE TABLE Precios(
    solicitud NUMBER NOT NULL,
    valor REAL NOT NULL,
    moneda VARCHAR2(5)
);

----------------------RESTRICCIONES DECLARATIVAS------------------------
/*Primarias*/
ALTER TABLE Solicitudes ADD CONSTRAINT PK_SOLICITUDES 
  PRIMARY KEY(codigo);
ALTER TABLE Precios ADD CONSTRAINT PK_PRECIOS
  PRIMARY KEY(solicitud);

/*Foraneas*/
ALTER TABLE Solicitudes ADD CONSTRAINT FK_SOLICITUDES_VIAJES, 
  FOREIGN KEY(viaje) REFERENCES Viajes(id);
ALTER TABLE Solicitudes ADD CONSTRAINT FK_SOLICITUDES_CLIENTES, 
  FOREIGN KEY(cliente) REFERENCES Clientes(id);
ALTER TABLE Precios ADD CONSTRAINT FK_PRECIOS_SOLICITUDES, 
  FOREIGN KEY(solicitud) REFERENCES Solicitudes(codigo);

/*Atributos*/    
ALTER TABLE Solicitudes ADD CONSTRAINT CK_SOLICITUDES_ESTADO
  CHECK(estado IN ('Pendiente','Asignada','Cancelada','Finalizada');
ALTER TABLE Solicitudes ADD CONSTRAINT CK_SOLICITUDES_PLATAFORMA
  CHECK(plataforma IN ('Web','Mobile');
ALTER TABLE Precios ADD CONSTRAINT CK_PRECIOS_VALOR
  CHECK(valor > 0);
ALTER TABLE Precios ADD CONSTRAINT CK_PRECIOS_MONEDA
  CHECK(moneda IN ('USD','COP','AUD','EUR');


------------------------POBLANCO Y CONSULTANDO----------------------

/*POBLAR OK*/ /*INGRESAR POSICIONES PRIMERO !*/
--primera
insert into Solicitudes(seq_solicitudes.nextval, 100, 1, 1, to_date('12 05 2020', 'DD MM YYYY'), to_date('12 06 2020', 'DD MM YYYY'), 'Web', 1, 'Pendiente', null);
insert into Precios(1, 20000, 'COP');

--segunda
insert into Solicitudes(seq_solicitudes.nextval, 100, 2, 3, current_date, to_date('01 01 2021', 'DD MM YYYY'), 'Mobile', null, 'Pendiente', null);

--tercera
insert into Solicitudes(seq_solicitudes.nextval, 100, 3, 5, current_date, to_date('01 07 2021', 'DD MM YYYY'), 'Mobile', 3, 'Pendiente', null);
insert into Precios(3, 12500, 'COP');

--cuarta
insert into Solicitudes(seq_solicitudes.nextval, 100, 4, 3, current_date, to_date('01 08 2021', 'DD MM YYYY'), 'Web', null, 'Pendiente', null);
insert into Precios(4, 35, 'USD');

/*POBLAR NO OK*/
--CASO FALLIDO CHECK PLATAFORMA
insert into Solicitudes(seq_solicitudes.nextval, 100, 5, 3, current_date, to_date('12 11 2021', 'DD MM YYYY'), 'Ordenador Web', null, 'Pendiente', null);

-------------------VISTAS Y INDICES-----------------
/*INDICES*/
CREATE INDEX IMONTOS ON PRECIOS(valor);

/*VISTAS*/
CREATE OR REPLACE VIEW ANALISTA_CLIENTES AS(
    SELECT IMONTOS
    FROM PRECIOS
    WHERE valor > 0
);


--------------------REGLAS DE NEGOCIO - DISPARADORES ----------------

/*LA FECHA DE CREACION DE LA SOLICITUD SE ASIGNA AUTOMATICAMENTE*/
CREATE OR REPLACE TRIGGER T_FECHA_CREACION_SOLICITUD
BEFORE INSERT ON SOLICITUDES
FOR EACH ROW
BEGIN
    :NEW.fechaCreacion := CURRENT_DATE;
END;
/
/*LA FECHA DE VIAJE DEBE SER MAYOR A LA FECHA ACTUAL*/
CREATE OR REPLACE TRIGGER T_FECHA_CREACION_SOLICITUD
BEFORE INSERT ON SOLICITUDES
FOR EACH ROW
BEGIN
    IF(:NEW.fechaCreacion < CURRENT_DATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'LA FECHA DE VIAJE DEBE SER SUPERIOR A LA ACTUAL');
    END IF;
END;
/
/*EL ESTADO INICIAL DE LA SOLICITUD ES PENDIENTE*/
CREATE OR REPLACE TRIGGER T_ESTADO_SOLICITUD
BEFORE INSERT ON SOLICITUDES
FOR EACH ROW
BEGIN
    :NEW.estado := 'Pendiente';
END;

/*SOLO SE PUEDEN ACTUALIZAR LOS CAMPOS: FECHA VIAJE, PRECIO, ESTADO*/
CREATE OR REPLACE TRIGGER MOD_SOLICITUD
BEFORE UPDATE OF CODIGO, CLIENTE, VIAJE, FECHACREACION, DESCRIPCION ON SOLICITUDES
BEGIN 
    RAISE_APPLICATION_ERROR(-20001, 'SOLO SE PUEDEN ACTUALIZAR LOS CAMPOS: FECHA VIAJE, PRECIO, ESTADO');
END;

/*LAS SOLICITUDES NO SE PUEDEN ELIMINAR*/
CREATE OR REPLACE TRIGGER T_FECHA_CREACION_SOLICITUD
BEFORE DELETE ON SOLICITUDES
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'LAS SOLICITUDES NO SE PUEDEN ELIMINAR');
END;

----------------AUTO GENERADOS--------------
/*EL CODIGO DE LA SOLICITUD SE GENERA AUTOMATICAMENTE*/
declare
    c_new_seq INTEGER;
begin
   select max(CODIGO) + 1
   into   c_new_seq
   from   SOLICITUDES;

    execute immediate 'Create sequence SEQ_SOLICITUDES
                       start with ' || c_new_seq ||
                       ' increment by 1';
                       
    c_new_seq:=0;
end;
-------------------PAQUETES-----------------

/*CRUDE*/
CREATE OR REPLACE PACKAGE PC_TRIP_REQUEST IS
    PROCEDURE AD_SOLICITUD(XCLIENTE IN NUMBER, XVIAJE IN NUMBER, XFECHAVIAJE IN DATE, XPLATAFORMA IN VARCHAR2, XPRECIO IN NUMBER, XDESCRIPCION IN XMLTYPE);
    FUNCTION CO_SOLICITUD(XCLIENTE IN NUMBER, XVIAJE IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION CO_CLIENTES_MAYORES_MONTOS() RETURN SYS_REFCURSOR;
    FUNCTION CO_VIAJES_MUSICA() RETURN SYS_REFCURSOR;
END PC_TRIP_REQUEST;

/*CRUDI*/
CREATE OR REPLACE PACKAGE BODY PC_TRIP_REQUEST IS
    PROCEDURE AD_SOLICITUD(XCLIENTE IN NUMBER, XVIAJE IN NUMBER, XFECHAVIAJE IN DATE, XPLATAFORMA IN VARCHAR2, XPRECIO IN NUMBER, XDESCRIPCION IN XMLTYPE) IS
    BEGIN 
        INSERT INTO SOLICITUDES(SEQ_SOLICITUDES.NEXTVAL, XCLIENTE, XVIAJE, CURRENT_DATE, XFECHAVIAJE, XPLATAFORMA, XPRECIO, null, XDESCRIPCION);
        COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'NO SE PUDO CREAR LA SOLICITUD');
    END;
    
    FUNCTION CO_SOLICITUD(XCLIENTE IN NUMBER, XVIAJE IN NUMBER) RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
    BEGIN 
        OPEN CO_RE FOR
            SELECT *
            FROM SOLICITUDES
            WHERE CLIENTE = XCLIENTE AND VIAJE = XVIAJE;
        RETURN CO_RE;
    END;
    
    FUNCTION CO_VIAJES_MUSICA() RETURN SYS_REFCURSOR IS CO_RE SYS_REFCURSOR;
    BEGIN 
        OPEN CO_RE FOR
            SELECT *
            FROM VIAJES_MUSICA
        RETURN CO_RE;
    END;

END PC_TRIP_REQUEST;

/*SEGURIDAD*/
CREATE ROLE ANALISTA;
GRANT EXECUTE ON PC_TRIP_REQUEST TO ANALISTA;


----------------------------------------INCLUIDOS PROFESOR---------------------------

--PoblarOK
insert into Miembros (id, tdni, dni, nombre, apellido) values (1, 'CE', '779-87-8413', 'Tedda', 'Mocker');
insert into Miembros (id, tdni, dni, nombre, apellido) values (2, 'CC', '603-95-0889', 'Julieta', 'Halversen');
insert into Miembros (id, tdni, dni, nombre, apellido) values (3, 'CC', '577-93-2417', 'Toma', 'Blooman');
insert into Miembros (id, tdni, dni, nombre, apellido) values (4, 'NIP', '764-86-5234', 'Chery', 'Fleckney');
insert into Miembros (id, tdni, dni, nombre, apellido) values (5, 'PAP', '280-69-1153', 'Faythe', 'Nock');
insert into Miembros (id, tdni, dni, nombre, apellido) values (6, 'CC', '820-83-2310', 'Fionnula', 'MacConnell');
insert into Miembros (id, tdni, dni, nombre, apellido) values (7, 'PAP', '867-62-9628', 'Dud', 'Hamber');
insert into Miembros (id, tdni, dni, nombre, apellido) values (8, 'CE', '610-24-5072', 'Livvie', 'Domenici');
insert into Miembros (id, tdni, dni, nombre, apellido) values (9, 'CC', '187-90-7419', 'Even', 'Bickmore');
insert into Miembros (id, tdni, dni, nombre, apellido) values (10, 'NIP', '114-48-9816', 'Egan', 'Feeley');
insert into Miembros (id, tdni, dni, nombre, apellido) values (11, 'NIP', '840-53-4190', 'Vivianna', 'Vondrys');
insert into Miembros (id, tdni, dni, nombre, apellido) values (12, 'CC', '287-38-6373', 'Zerk', 'Garlett');
insert into Miembros (id, tdni, dni, nombre, apellido) values (13, 'CC', '329-49-4070', 'Lorri', 'Kydde');
insert into Miembros (id, tdni, dni, nombre, apellido) values (14, 'NIP', '747-25-1616', 'Rosaline', 'Redmond');
insert into Miembros (id, tdni, dni, nombre, apellido) values (15, 'PAP', '451-70-4630', 'Dalenna', 'Whapples');
insert into Miembros (id, tdni, dni, nombre, apellido) values (16, 'NIP', '572-22-1724', 'Keslie', 'Greed');
insert into Miembros (id, tdni, dni, nombre, apellido) values (17, 'PAP', '864-68-9693', 'Giacobo', 'Finlayson');
insert into Miembros (id, tdni, dni, nombre, apellido) values (18, 'CE', '442-54-0050', 'Ema', 'Matchell');
insert into Miembros (id, tdni, dni, nombre, apellido) values (19, 'NIP', '588-44-7829', 'Sheffield', 'Giacobazzi');
insert into Miembros (id, tdni, dni, nombre, apellido) values (20, 'CE', '835-70-1578', 'Kathy', 'Richarz');
insert into Miembros (id, tdni, dni, nombre, apellido) values (21, 'CE', '193-17-4716', 'Hagen', 'Rarity');
insert into Miembros (id, tdni, dni, nombre, apellido) values (22, 'PAP', '492-88-6208', 'Stanislaw', 'Harpin');
insert into Miembros (id, tdni, dni, nombre, apellido) values (23, 'CE', '257-12-9833', 'Codee', 'Beamand');
insert into Miembros (id, tdni, dni, nombre, apellido) values (24, 'CE', '572-47-0883', 'Noelyn', 'Dalloway');
insert into Miembros (id, tdni, dni, nombre, apellido) values (25, 'CE', '350-39-9816', 'Northrop', 'Tolefree');
insert into Miembros (id, tdni, dni, nombre, apellido) values (26, 'NIP', '294-84-4666', 'Abelard', 'Riding');
insert into Miembros (id, tdni, dni, nombre, apellido) values (27, 'CC', '379-71-4318', 'Emilia', 'Whenham');
insert into Miembros (id, tdni, dni, nombre, apellido) values (28, 'NIP', '626-68-5856', 'Shanon', 'Itzchaky');
insert into Miembros (id, tdni, dni, nombre, apellido) values (29, 'NIP', '647-15-1061', 'Heda', 'Lomond');
insert into Miembros (id, tdni, dni, nombre, apellido) values (30, 'PAP', '691-21-4278', 'Jephthah', 'Poxson');
insert into Miembros (id, tdni, dni, nombre, apellido) values (31, 'NIP', '156-70-9145', 'Ileana', 'Lewson');
insert into Miembros (id, tdni, dni, nombre, apellido) values (32, 'CC', '564-04-3996', 'Elmo', 'Schlag');
insert into Miembros (id, tdni, dni, nombre, apellido) values (33, 'CC', '694-21-2090', 'Albie', 'Spadaro');
insert into Miembros (id, tdni, dni, nombre, apellido) values (34, 'CE', '397-33-6048', 'Fayina', 'Devil');
insert into Miembros (id, tdni, dni, nombre, apellido) values (35, 'CE', '549-28-9203', 'Marten', 'Riseam');
insert into Miembros (id, tdni, dni, nombre, apellido) values (36, 'PAP', '453-39-0889', 'Rois', 'Revington');
insert into Miembros (id, tdni, dni, nombre, apellido) values (37, 'PAP', '503-97-0206', 'Haily', 'Davydzenko');
insert into Miembros (id, tdni, dni, nombre, apellido) values (38, 'CC', '727-94-3069', 'Agustin', 'Ceschelli');
insert into Miembros (id, tdni, dni, nombre, apellido) values (39, 'PAP', '840-13-6711', 'Gothart', 'Tiebe');
insert into Miembros (id, tdni, dni, nombre, apellido) values (40, 'PAP', '853-08-6423', 'Kata', 'Wenden');
insert into Miembros (id, tdni, dni, nombre, apellido) values (41, 'CC', '443-27-7417', 'Sanford', 'Brumble');
insert into Miembros (id, tdni, dni, nombre, apellido) values (42, 'PAP', '164-90-8079', 'Ennis', 'Carswell');
insert into Miembros (id, tdni, dni, nombre, apellido) values (43, 'PAP', '623-70-2095', 'Eadie', 'Iglesia');
insert into Miembros (id, tdni, dni, nombre, apellido) values (44, 'PAP', '325-77-5766', 'Rosette', 'Ouldcott');
insert into Miembros (id, tdni, dni, nombre, apellido) values (45, 'PAP', '203-60-0653', 'Ferguson', 'Hindsberg');
insert into Miembros (id, tdni, dni, nombre, apellido) values (46, 'CC', '530-81-5315', 'Jsandye', 'Jozefczak');
insert into Miembros (id, tdni, dni, nombre, apellido) values (47, 'CE', '805-67-0198', 'Rubina', 'Tibbits');
insert into Miembros (id, tdni, dni, nombre, apellido) values (48, 'CE', '860-12-5467', 'Homer', 'Coathup');
insert into Miembros (id, tdni, dni, nombre, apellido) values (49, 'CC', '642-59-9100', 'Sandy', 'De La Haye');
insert into Miembros (id, tdni, dni, nombre, apellido) values (50, 'CC', '206-21-0986', 'Molli', 'Galland');
insert into Miembros (id, tdni, dni, nombre, apellido) values (51, 'CE', '200-07-7001', 'Lev', 'Page');
insert into Miembros (id, tdni, dni, nombre, apellido) values (52, 'CE', '233-61-0699', 'Riannon', 'McNeachtain');
insert into Miembros (id, tdni, dni, nombre, apellido) values (53, 'NIP', '738-77-1900', 'Rab', 'Oakwood');
insert into Miembros (id, tdni, dni, nombre, apellido) values (54, 'NIP', '505-18-4634', 'Herman', 'Cansdell');
insert into Miembros (id, tdni, dni, nombre, apellido) values (55, 'CC', '401-59-9165', 'Binny', 'Yeskin');
insert into Miembros (id, tdni, dni, nombre, apellido) values (56, 'NIP', '720-66-0373', 'Isabelita', 'Chatan');
insert into Miembros (id, tdni, dni, nombre, apellido) values (57, 'PAP', '726-93-3216', 'Aldous', 'Rubinek');
insert into Miembros (id, tdni, dni, nombre, apellido) values (58, 'PAP', '499-05-3851', 'Karissa', 'Snalom');
insert into Miembros (id, tdni, dni, nombre, apellido) values (59, 'CE', '687-79-1759', 'Ernesta', 'Pollard');
insert into Miembros (id, tdni, dni, nombre, apellido) values (60, 'CC', '492-72-4389', 'Virgie', 'Petrovykh');
insert into Miembros (id, tdni, dni, nombre, apellido) values (61, 'CE', '204-92-3578', 'Patrick', 'Hatzar');
insert into Miembros (id, tdni, dni, nombre, apellido) values (62, 'NIP', '387-70-0723', 'Mattie', 'Mateus');
insert into Miembros (id, tdni, dni, nombre, apellido) values (63, 'CC', '728-21-3455', 'Vaughan', 'MacAvaddy');
insert into Miembros (id, tdni, dni, nombre, apellido) values (64, 'CE', '553-14-5711', 'Forrest', 'Stranahan');
insert into Miembros (id, tdni, dni, nombre, apellido) values (65, 'PAP', '728-01-3051', 'Hayward', 'Moffat');
insert into Miembros (id, tdni, dni, nombre, apellido) values (66, 'PAP', '213-09-8565', 'Dyane', 'Serotsky');
insert into Miembros (id, tdni, dni, nombre, apellido) values (67, 'NIP', '895-69-7903', 'Morgen', 'Andriolli');
insert into Miembros (id, tdni, dni, nombre, apellido) values (68, 'PAP', '657-33-8197', 'Miles', 'Pettendrich');
insert into Miembros (id, tdni, dni, nombre, apellido) values (69, 'CE', '889-62-9463', 'Alfie', 'Whinray');
insert into Miembros (id, tdni, dni, nombre, apellido) values (70, 'CC', '305-96-2675', 'Tamar', 'Garrard');
insert into Miembros (id, tdni, dni, nombre, apellido) values (71, 'CC', '458-92-5592', 'Katha', 'Cristoferi');
insert into Miembros (id, tdni, dni, nombre, apellido) values (72, 'CE', '822-27-5705', 'Dulsea', 'Kingsworth');
insert into Miembros (id, tdni, dni, nombre, apellido) values (73, 'CE', '300-48-1652', 'Marchall', 'Leeson');
insert into Miembros (id, tdni, dni, nombre, apellido) values (74, 'PAP', '765-40-3883', 'Karalee', 'Keeler');
insert into Miembros (id, tdni, dni, nombre, apellido) values (75, 'CE', '147-05-6202', 'Loralyn', 'Liversidge');
insert into Miembros (id, tdni, dni, nombre, apellido) values (76, 'CC', '439-05-6622', 'Gerladina', 'Hutchason');
insert into Miembros (id, tdni, dni, nombre, apellido) values (77, 'PAP', '766-45-9578', 'Milty', 'Yurmanovev');
insert into Miembros (id, tdni, dni, nombre, apellido) values (78, 'CC', '693-89-2428', 'Ikey', 'Philippson');
insert into Miembros (id, tdni, dni, nombre, apellido) values (79, 'PAP', '827-37-9465', 'Mariejeanne', 'Hummerston');
insert into Miembros (id, tdni, dni, nombre, apellido) values (80, 'PAP', '858-55-1607', 'Deedee', 'Brende');
insert into Miembros (id, tdni, dni, nombre, apellido) values (81, 'NIP', '478-83-1217', 'Rosalinde', 'Freyne');
insert into Miembros (id, tdni, dni, nombre, apellido) values (82, 'PAP', '331-41-1628', 'Alexis', 'Calverd');
insert into Miembros (id, tdni, dni, nombre, apellido) values (83, 'CC', '551-78-8897', 'Dorrie', 'Slaney');
insert into Miembros (id, tdni, dni, nombre, apellido) values (84, 'PAP', '432-38-6099', 'Daisi', 'Maud');
insert into Miembros (id, tdni, dni, nombre, apellido) values (85, 'PAP', '302-97-7470', 'Kent', 'Le Pruvost');
insert into Miembros (id, tdni, dni, nombre, apellido) values (86, 'PAP', '386-84-3088', 'Lida', 'Dubs');
insert into Miembros (id, tdni, dni, nombre, apellido) values (87, 'CC', '821-60-7389', 'Ludovika', 'Shwalbe');
insert into Miembros (id, tdni, dni, nombre, apellido) values (88, 'NIP', '171-79-1607', 'Elke', 'Wason');
insert into Miembros (id, tdni, dni, nombre, apellido) values (89, 'CC', '483-91-0418', 'Thibaut', 'O''Longain');
insert into Miembros (id, tdni, dni, nombre, apellido) values (90, 'CE', '442-95-6886', 'Germayne', 'Macoun');
insert into Miembros (id, tdni, dni, nombre, apellido) values (91, 'PAP', '531-19-7593', 'Jennie', 'Deeprose');
insert into Miembros (id, tdni, dni, nombre, apellido) values (92, 'NIP', '234-20-4050', 'Blanche', 'Mulran');
insert into Miembros (id, tdni, dni, nombre, apellido) values (93, 'CC', '300-03-4133', 'Carola', 'Danslow');
insert into Miembros (id, tdni, dni, nombre, apellido) values (94, 'CE', '277-99-9609', 'Blanca', 'Tierney');
insert into Miembros (id, tdni, dni, nombre, apellido) values (95, 'CE', '633-47-8266', 'Malissa', 'Giorgioni');
insert into Miembros (id, tdni, dni, nombre, apellido) values (96, 'PAP', '818-31-8182', 'Decca', 'McCome');
insert into Miembros (id, tdni, dni, nombre, apellido) values (97, 'CE', '517-53-2902', 'Franchot', 'Eitter');
insert into Miembros (id, tdni, dni, nombre, apellido) values (98, 'CE', '160-09-0832', 'Leesa', 'Goodinge');
insert into Miembros (id, tdni, dni, nombre, apellido) values (99, 'CE', '200-89-9845', 'Terrye', 'Blomefield');
insert into Miembros (id, tdni, dni, nombre, apellido) values (100, 'PAP', '654-32-8889', 'Gates', 'Spirritt');

insert into Conductores (id, fechaNacimiento, estrellas, estado) values (1, TO_DATE('27/05/1963', 'DD/MM/YYYY'), 4.02, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (2, TO_DATE('23/10/1969', 'DD/MM/YYYY'), 0.33, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (3, TO_DATE('05/07/1981', 'DD/MM/YYYY'), 3.56, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (4, TO_DATE('24/07/1985', 'DD/MM/YYYY'), 3.51, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (5, TO_DATE('18/11/1971', 'DD/MM/YYYY'), 2.97, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (6, TO_DATE('06/01/1984', 'DD/MM/YYYY'), 1.15, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (7, TO_DATE('16/10/1964', 'DD/MM/YYYY'), 1.24, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (8, TO_DATE('20/01/1961', 'DD/MM/YYYY'), 0.21, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (9, TO_DATE('11/02/1981', 'DD/MM/YYYY'), 4.65, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (10, TO_DATE('14/06/1967', 'DD/MM/YYYY'), 1.96, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (11, TO_DATE('03/01/1977', 'DD/MM/YYYY'), 0.18, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (12, TO_DATE('02/09/1968', 'DD/MM/YYYY'), 3.77, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (13, TO_DATE('10/06/1974', 'DD/MM/YYYY'), 4.39, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (14, TO_DATE('16/01/1965', 'DD/MM/YYYY'), 0.91, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (15, TO_DATE('02/06/1975', 'DD/MM/YYYY'), 3.56, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (16, TO_DATE('17/03/1975', 'DD/MM/YYYY'), 0.68, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (17, TO_DATE('28/05/1966', 'DD/MM/YYYY'), 2.96, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (18, TO_DATE('23/11/1970', 'DD/MM/YYYY'), 1.87, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (19, TO_DATE('09/09/1968', 'DD/MM/YYYY'), 0.66, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (20, TO_DATE('06/06/1984', 'DD/MM/YYYY'), 4.67, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (21, TO_DATE('17/06/1978', 'DD/MM/YYYY'), 3.65, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (22, TO_DATE('02/10/1963', 'DD/MM/YYYY'), 2.1, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (23, TO_DATE('08/12/1974', 'DD/MM/YYYY'), 2.74, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (24, TO_DATE('19/12/1964', 'DD/MM/YYYY'), 3.14, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (25, TO_DATE('24/03/1962', 'DD/MM/YYYY'), 3.05, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (26, TO_DATE('30/03/1981', 'DD/MM/YYYY'), 2.65, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (27, TO_DATE('30/08/1988', 'DD/MM/YYYY'), 0.62, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (28, TO_DATE('21/02/1963', 'DD/MM/YYYY'), 1.15, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (29, TO_DATE('09/02/1977', 'DD/MM/YYYY'), 4.29, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (30, TO_DATE('24/04/1982', 'DD/MM/YYYY'), 0.23, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (31, TO_DATE('09/03/1979', 'DD/MM/YYYY'), 2.75, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (32, TO_DATE('10/02/1990', 'DD/MM/YYYY'), 4.29, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (33, TO_DATE('21/02/1967', 'DD/MM/YYYY'), 0.55, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (34, TO_DATE('05/09/1988', 'DD/MM/YYYY'), 2.1, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (35, TO_DATE('17/12/1985', 'DD/MM/YYYY'), 4.25, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (36, TO_DATE('14/04/1979', 'DD/MM/YYYY'), 0.14, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (37, TO_DATE('24/10/1963', 'DD/MM/YYYY'), 4.92, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (38, TO_DATE('21/12/1969', 'DD/MM/YYYY'), 4.76, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (39, TO_DATE('11/11/1964', 'DD/MM/YYYY'), 0.6, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (40, TO_DATE('06/06/1973', 'DD/MM/YYYY'), 2.43, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (41, TO_DATE('26/05/1990', 'DD/MM/YYYY'), 1.73, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (42, TO_DATE('09/01/1975', 'DD/MM/YYYY'), 3.74, 'Retirado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (43, TO_DATE('08/10/1973', 'DD/MM/YYYY'), 4.71, 'Inactivo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (44, TO_DATE('04/06/1979', 'DD/MM/YYYY'), 3.8, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (45, TO_DATE('21/01/1972', 'DD/MM/YYYY'), 1.33, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (46, TO_DATE('05/09/1967', 'DD/MM/YYYY'), 1.67, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (47, TO_DATE('08/04/1967', 'DD/MM/YYYY'), 2.43, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (48, TO_DATE('25/01/1970', 'DD/MM/YYYY'), 2.0, 'Ocupado');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (49, TO_DATE('15/01/1967', 'DD/MM/YYYY'), 1.35, 'Activo');
insert into Conductores (id, fechaNacimiento, estrellas, estado) values (50, TO_DATE('24/02/1984', 'DD/MM/YYYY'), 4.87, 'Retirado');

insert into Clientes (id, idioma) values (80, 'Armenian');
insert into Clientes (id, idioma) values (91, 'Spanish');
insert into Clientes (id, idioma) values (72, 'Tetum');
insert into Clientes (id, idioma) values (79, 'Malayalam');
insert into Clientes (id, idioma) values (33, 'Quechua');
insert into Clientes (id, idioma) values (73, 'Portuguese');
insert into Clientes (id, idioma) values (46, 'West Frisian');
insert into Clientes (id, idioma) values (78, 'Sotho');
insert into Clientes (id, idioma) values (74, 'Kazakh');
insert into Clientes (id, idioma) values (47, 'Hiri Motu');
insert into Clientes (id, idioma) values (22, 'Nepali');
insert into Clientes (id, idioma) values (34, 'Afrikaans');
insert into Clientes (id, idioma) values (74, 'Quechua');
insert into Clientes (id, idioma) values (65, 'Swedish');
insert into Clientes (id, idioma) values (33, 'Papiamento');
insert into Clientes (id, idioma) values (95, 'Amharic');
insert into Clientes (id, idioma) values (20, 'Finnish');
insert into Clientes (id, idioma) values (100, 'Dutch');
insert into Clientes (id, idioma) values (21, 'Catalan');
insert into Clientes (id, idioma) values (7, 'Filipino');
insert into Clientes (id, idioma) values (55, 'Irish Gaelic');
insert into Clientes (id, idioma) values (39, 'Haitian Creole');
insert into Clientes (id, idioma) values (12, 'Moldovan');
insert into Clientes (id, idioma) values (36, 'Assamese');
insert into Clientes (id, idioma) values (50, 'Nepali');
insert into Clientes (id, idioma) values (19, 'West Frisian');
insert into Clientes (id, idioma) values (73, 'Northern Sotho');
insert into Clientes (id, idioma) values (78, 'Lithuanian');
insert into Clientes (id, idioma) values (10, 'New Zealand Sign Language');
insert into Clientes (id, idioma) values (94, 'Malayalam');
insert into Clientes (id, idioma) values (32, 'Hiri Motu');
insert into Clientes (id, idioma) values (65, 'Kazakh');
insert into Clientes (id, idioma) values (49, 'Croatian');
insert into Clientes (id, idioma) values (13, 'New Zealand Sign Language');
insert into Clientes (id, idioma) values (77, 'Yiddish');
insert into Clientes (id, idioma) values (76, 'Norwegian');
insert into Clientes (id, idioma) values (51, 'Zulu');
insert into Clientes (id, idioma) values (15, 'Chinese');
insert into Clientes (id, idioma) values (53, 'Guaran?');
insert into Clientes (id, idioma) values (35, 'Bengali');
insert into Clientes (id, idioma) values (71, 'Nepali');
insert into Clientes (id, idioma) values (58, 'Tswana');
insert into Clientes (id, idioma) values (54, 'Croatian');
insert into Clientes (id, idioma) values (56, 'Northern Sotho');
insert into Clientes (id, idioma) values (69, 'Dzongkha');
insert into Clientes (id, idioma) values (64, 'Aymara');
insert into Clientes (id, idioma) values (26, 'Dzongkha');
insert into Clientes (id, idioma) values (50, 'Dutch');
insert into Clientes (id, idioma) values (56, 'Bislama');
insert into Clientes (id, idioma) values (2, 'Dhivehi');

insert into Posiciones (id, longitud, latitud) values (1, 5.764182, 45.203406);
insert into Posiciones (id, longitud, latitud) values (2, 24.16667, 54.6);
insert into Posiciones (id, longitud, latitud) values (3, 124.9202302, 11.1856085);
insert into Posiciones (id, longitud, latitud) values (4, 17.6475071, 59.1965287);
insert into Posiciones (id, longitud, latitud) values (5, -9.1580682, 39.2682645);
insert into Posiciones (id, longitud, latitud) values (6, -77.8267218, 21.241735);
insert into Posiciones (id, longitud, latitud) values (7, 103.982523, 34.470812);
insert into Posiciones (id, longitud, latitud) values (8, 75.8098141, 41.1694718);
insert into Posiciones (id, longitud, latitud) values (9, -8.2760021, 40.9937134);
insert into Posiciones (id, longitud, latitud) values (10, 121.0390378, 14.3758164);
insert into Posiciones (id, longitud, latitud) values (11, 47.6541468, 39.7291573);
insert into Posiciones (id, longitud, latitud) values (12, -47.058302, -1.7437356);
insert into Posiciones (id, longitud, latitud) values (13, 82.3454181, 53.0852774);
insert into Posiciones (id, longitud, latitud) values (14, 111.4350413, -6.9704825);
insert into Posiciones (id, longitud, latitud) values (15, 34.40988, 57.6194);
insert into Posiciones (id, longitud, latitud) values (16, 36.1328132, 35.3772103);
insert into Posiciones (id, longitud, latitud) values (17, -78.9344814, 42.9038743);
insert into Posiciones (id, longitud, latitud) values (18, 14.367531, 46.259991);
insert into Posiciones (id, longitud, latitud) values (19, 120.4355906, 15.9275907);
insert into Posiciones (id, longitud, latitud) values (20, 37.1152943, 54.886529);
insert into Posiciones (id, longitud, latitud) values (21, 98.9797467, 2.0121688);
insert into Posiciones (id, longitud, latitud) values (22, 13.9368114, 56.8134441);
insert into Posiciones (id, longitud, latitud) values (23, 19.0731949, 47.4997688);
insert into Posiciones (id, longitud, latitud) values (24, 123.345085, 7.516342);
insert into Posiciones (id, longitud, latitud) values (25, 97.3580243, 57.4492483);
insert into Posiciones (id, longitud, latitud) values (26, 101.5361726, 12.8603014);
insert into Posiciones (id, longitud, latitud) values (27, 109.1642208, 13.8565034);
insert into Posiciones (id, longitud, latitud) values (28, 117.470597, 44.889488);
insert into Posiciones (id, longitud, latitud) values (29, 112.67271, 30.864884);
insert into Posiciones (id, longitud, latitud) values (30, 35.382433, 45.031933);
insert into Posiciones (id, longitud, latitud) values (31, 120.7961471, 18.5344284);
insert into Posiciones (id, longitud, latitud) values (32, 125.374217, 43.865595);
insert into Posiciones (id, longitud, latitud) values (33, 27.4380189, -28.6880903);
insert into Posiciones (id, longitud, latitud) values (34, -8.5808436, 40.0039328);
insert into Posiciones (id, longitud, latitud) values (35, -1.0514312, 5.2023106);
insert into Posiciones (id, longitud, latitud) values (36, 59.106389, 54.000556);
insert into Posiciones (id, longitud, latitud) values (37, 7.8776023, 8.8471213);
insert into Posiciones (id, longitud, latitud) values (38, 37.5884971, 55.7742636);
insert into Posiciones (id, longitud, latitud) values (39, -8.5171384, 51.876873);
insert into Posiciones (id, longitud, latitud) values (40, 21.1594809, 56.1636909);
insert into Posiciones (id, longitud, latitud) values (41, -117.5950841, 33.6419542);
insert into Posiciones (id, longitud, latitud) values (42, 11.9388513, 57.6893251);
insert into Posiciones (id, longitud, latitud) values (43, -44.8721875, -3.4603809);
insert into Posiciones (id, longitud, latitud) values (44, 58.7326317, 57.2567489);
insert into Posiciones (id, longitud, latitud) values (45, 35.28638, 32.161522);
insert into Posiciones (id, longitud, latitud) values (46, 12.8148182, 56.6810923);
insert into Posiciones (id, longitud, latitud) values (47, -9.0355159, 39.1285479);
insert into Posiciones (id, longitud, latitud) values (48, 10.29195, 36.67931);
insert into Posiciones (id, longitud, latitud) values (49, -9.3240249, 38.7178621);
insert into Posiciones (id, longitud, latitud) values (50, 120.556005, 31.875572);
insert into Posiciones (id, longitud, latitud) values (51, 24.6800199, 48.9582445);
insert into Posiciones (id, longitud, latitud) values (52, -39.940155, -13.5362103);
insert into Posiciones (id, longitud, latitud) values (53, 106.6914555, -6.2287891);
insert into Posiciones (id, longitud, latitud) values (54, 110.1576731, -7.823074);
insert into Posiciones (id, longitud, latitud) values (55, -1.1457859, 46.5993244);
insert into Posiciones (id, longitud, latitud) values (56, 122.5655726, 10.6936663);
insert into Posiciones (id, longitud, latitud) values (57, -49.6503106, -17.9659326);
insert into Posiciones (id, longitud, latitud) values (58, 65.5887379, 44.8147261);
insert into Posiciones (id, longitud, latitud) values (59, -122.2982224, 47.6849444);
insert into Posiciones (id, longitud, latitud) values (60, 123.981229, 41.837693);
insert into Posiciones (id, longitud, latitud) values (61, 18.4458999, 50.0072402);
insert into Posiciones (id, longitud, latitud) values (62, 43.22637, 14.18356);
insert into Posiciones (id, longitud, latitud) values (63, 16.4856013, 51.8677116);
insert into Posiciones (id, longitud, latitud) values (64, -70.6565151, -34.179452);
insert into Posiciones (id, longitud, latitud) values (65, 113.733313, 30.93908);
insert into Posiciones (id, longitud, latitud) values (66, -76.1551866, 3.7733312);
insert into Posiciones (id, longitud, latitud) values (67, 101.7178316, 3.1523104);
insert into Posiciones (id, longitud, latitud) values (68, 20.3049868, 63.8436672);
insert into Posiciones (id, longitud, latitud) values (69, -106.78, 32.31);
insert into Posiciones (id, longitud, latitud) values (70, 10.8112885, 35.7642515);
insert into Posiciones (id, longitud, latitud) values (71, -54.398656, 5.6080848);
insert into Posiciones (id, longitud, latitud) values (72, 19.4883692, 51.167963);
insert into Posiciones (id, longitud, latitud) values (73, 33.129529, 34.7188616);
insert into Posiciones (id, longitud, latitud) values (74, 126.582834, 43.87437);
insert into Posiciones (id, longitud, latitud) values (75, 122.1700081, 40.1919977);
insert into Posiciones (id, longitud, latitud) values (76, 30.41667, 19.63333);
insert into Posiciones (id, longitud, latitud) values (77, -119.5937077, 49.4991381);
insert into Posiciones (id, longitud, latitud) values (78, 129.508945, 42.891255);
insert into Posiciones (id, longitud, latitud) values (79, 38.7577605, 8.9806034);
insert into Posiciones (id, longitud, latitud) values (80, -55.2590707, -25.4302418);
insert into Posiciones (id, longitud, latitud) values (81, 113.604417, 22.34414);
insert into Posiciones (id, longitud, latitud) values (82, 138.8095665, -3.7099248);
insert into Posiciones (id, longitud, latitud) values (83, -88.0876336, 14.7121689);
insert into Posiciones (id, longitud, latitud) values (84, 120.3660634, 16.3274859);
insert into Posiciones (id, longitud, latitud) values (85, -99.1497664, 19.4458447);
insert into Posiciones (id, longitud, latitud) values (86, 117.470597, 44.889488);
insert into Posiciones (id, longitud, latitud) values (87, 30.635, 12.72486);
insert into Posiciones (id, longitud, latitud) values (88, -100.3926054, 25.7988666);
insert into Posiciones (id, longitud, latitud) values (89, 58.7030326, 34.339552);
insert into Posiciones (id, longitud, latitud) values (90, 108.400024, 32.023273);
insert into Posiciones (id, longitud, latitud) values (91, 106.5878723, -6.9918507);
insert into Posiciones (id, longitud, latitud) values (92, -49.8956943, -24.4748345);
insert into Posiciones (id, longitud, latitud) values (93, -70.719444, 18.907778);
insert into Posiciones (id, longitud, latitud) values (94, 134.1872425, 45.9735653);
insert into Posiciones (id, longitud, latitud) values (95, 110.584168, 23.681533);
insert into Posiciones (id, longitud, latitud) values (96, 106.9329091, 14.8165996);
insert into Posiciones (id, longitud, latitud) values (97, 122.7314472, 11.4672917);
insert into Posiciones (id, longitud, latitud) values (98, 67.7914041, 38.0099999);
insert into Posiciones (id, longitud, latitud) values (99, -75.632447, 8.8105088);
insert into Posiciones (id, longitud, latitud) values (100, 42.3111341, 41.6460816);
insert into Posiciones (id, longitud, latitud) values (101, 44.1103116, 40.8328514);
insert into Posiciones (id, longitud, latitud) values (102, 47.1571241, 41.1974753);
insert into Posiciones (id, longitud, latitud) values (103, -39.465738, -13.7968333);
insert into Posiciones (id, longitud, latitud) values (104, 33.9164563, -2.7529366);
insert into Posiciones (id, longitud, latitud) values (105, 17.3087111, 50.2895924);
insert into Posiciones (id, longitud, latitud) values (106, 23.041894, 48.3117809);
insert into Posiciones (id, longitud, latitud) values (107, 101.5957199, 3.205886);
insert into Posiciones (id, longitud, latitud) values (108, -7.0552218, 32.0860889);
insert into Posiciones (id, longitud, latitud) values (109, 14.6929755, 50.1249419);
insert into Posiciones (id, longitud, latitud) values (110, 108.317902, 22.775792);
insert into Posiciones (id, longitud, latitud) values (111, 98.9797467, 3.6275746);
insert into Posiciones (id, longitud, latitud) values (112, -94.4452233, 18.1436128);
insert into Posiciones (id, longitud, latitud) values (113, 1.7283341, 10.5685138);
insert into Posiciones (id, longitud, latitud) values (114, 121.154634, 30.037192);
insert into Posiciones (id, longitud, latitud) values (115, 98.480195, 36.929749);
insert into Posiciones (id, longitud, latitud) values (116, 115.416027, 31.800137);
insert into Posiciones (id, longitud, latitud) values (117, -9.4574506, 38.751115);
insert into Posiciones (id, longitud, latitud) values (118, 108.033333, -7.45);
insert into Posiciones (id, longitud, latitud) values (119, -99.1097687, 19.379122);
insert into Posiciones (id, longitud, latitud) values (120, 10.6771005, 59.9428184);
insert into Posiciones (id, longitud, latitud) values (121, -39.1482174, -3.4383637);
insert into Posiciones (id, longitud, latitud) values (122, 112.257788, 31.719806);
insert into Posiciones (id, longitud, latitud) values (123, -84.5511177, 42.7282811);
insert into Posiciones (id, longitud, latitud) values (124, 120.31191, 31.491169);
insert into Posiciones (id, longitud, latitud) values (125, 113.6293916, -7.0271791);
insert into Posiciones (id, longitud, latitud) values (126, -4.3667907, 5.3262083);
insert into Posiciones (id, longitud, latitud) values (127, 120.26121, 28.80901);
insert into Posiciones (id, longitud, latitud) values (128, 22.2871234, 49.8964958);
insert into Posiciones (id, longitud, latitud) values (129, 2.2889821, 48.732568);
insert into Posiciones (id, longitud, latitud) values (130, 126.3795987, -8.6417702);
insert into Posiciones (id, longitud, latitud) values (131, 120.9888316, 14.657758);
insert into Posiciones (id, longitud, latitud) values (132, 112.1758089, -8.0716019);
insert into Posiciones (id, longitud, latitud) values (133, 101.664881, 3.116134);
insert into Posiciones (id, longitud, latitud) values (134, 24.0846652, 42.6995393);
insert into Posiciones (id, longitud, latitud) values (135, 121.0493442, 14.7035936);
insert into Posiciones (id, longitud, latitud) values (136, -73.840258, 8.588397);
insert into Posiciones (id, longitud, latitud) values (137, 9.9101915, 2.9405941);
insert into Posiciones (id, longitud, latitud) values (138, 112.5633485, -8.2317168);
insert into Posiciones (id, longitud, latitud) values (139, -43.4607419, -22.7561319);
insert into Posiciones (id, longitud, latitud) values (140, 100.962601, -0.670315);
insert into Posiciones (id, longitud, latitud) values (141, 106.1536828, 22.7370366);
insert into Posiciones (id, longitud, latitud) values (142, 125.3297787, 7.9187344);
insert into Posiciones (id, longitud, latitud) values (143, -8.5116191, 41.400351);
insert into Posiciones (id, longitud, latitud) values (144, 102.5527505, 17.8064459);
insert into Posiciones (id, longitud, latitud) values (145, 130.3331069, 33.5050373);
insert into Posiciones (id, longitud, latitud) values (146, 120.3637277, -8.6746707);
insert into Posiciones (id, longitud, latitud) values (147, 174.7763921, -41.277848);
insert into Posiciones (id, longitud, latitud) values (148, 16.5850718, 46.3277049);
insert into Posiciones (id, longitud, latitud) values (149, 113.9960031, 62.5412431);
insert into Posiciones (id, longitud, latitud) values (150, 4.2552114, 45.521777);
insert into Posiciones (id, longitud, latitud) values (151, 5.2893597, 47.9318074);
insert into Posiciones (id, longitud, latitud) values (152, -9.3053201, 38.6969299);
insert into Posiciones (id, longitud, latitud) values (153, -114.0979947, 52.3076201);
insert into Posiciones (id, longitud, latitud) values (154, 27.3914185, -26.3517681);
insert into Posiciones (id, longitud, latitud) values (155, 116.809657, 39.944315);
insert into Posiciones (id, longitud, latitud) values (156, 18.0785342, 49.7234162);
insert into Posiciones (id, longitud, latitud) values (157, 100.4358552, 14.7147473);
insert into Posiciones (id, longitud, latitud) values (158, 117.6852235, 39.0063718);
insert into Posiciones (id, longitud, latitud) values (159, 17.8961823, 60.1960972);
insert into Posiciones (id, longitud, latitud) values (160, 116.0625588, 36.448127);
insert into Posiciones (id, longitud, latitud) values (161, -48.4812248, -20.9400441);
insert into Posiciones (id, longitud, latitud) values (162, -58.4654718, -34.6107923);
insert into Posiciones (id, longitud, latitud) values (163, -71.1448516, 8.1601168);
insert into Posiciones (id, longitud, latitud) values (164, -51.736543, -19.1097385);
insert into Posiciones (id, longitud, latitud) values (165, 120.056029, 30.131784);
insert into Posiciones (id, longitud, latitud) values (166, 43.7911745, 56.1465144);
insert into Posiciones (id, longitud, latitud) values (167, 18.055922, 59.320622);
insert into Posiciones (id, longitud, latitud) values (168, 107.3956619, 50.1601386);
insert into Posiciones (id, longitud, latitud) values (169, -41.3803558, -11.4346353);
insert into Posiciones (id, longitud, latitud) values (170, 112.377361, 24.780966);
insert into Posiciones (id, longitud, latitud) values (171, 31.75, -19.066667);
insert into Posiciones (id, longitud, latitud) values (172, 103.686294, 30.304377);
insert into Posiciones (id, longitud, latitud) values (173, 121.435569, 28.679282);
insert into Posiciones (id, longitud, latitud) values (174, 113.38492, 22.585397);
insert into Posiciones (id, longitud, latitud) values (175, -65.7905325, -28.4481029);
insert into Posiciones (id, longitud, latitud) values (176, 119.03867, -8.50246);
insert into Posiciones (id, longitud, latitud) values (177, 112.225334, 22.69569);
insert into Posiciones (id, longitud, latitud) values (178, 89.108299, 30.073805);
insert into Posiciones (id, longitud, latitud) values (179, 67.5882847, 24.4506879);
insert into Posiciones (id, longitud, latitud) values (180, 36.4726, 35.78668);
insert into Posiciones (id, longitud, latitud) values (181, -118.38606, 56.06675);
insert into Posiciones (id, longitud, latitud) values (182, -34.8277651, -7.8815605);
insert into Posiciones (id, longitud, latitud) values (183, 121.023574, 14.53348);
insert into Posiciones (id, longitud, latitud) values (184, 44.4160763, 46.0675028);
insert into Posiciones (id, longitud, latitud) values (185, -76.9970692, -11.9417972);
insert into Posiciones (id, longitud, latitud) values (186, 73.4361761, 54.9173747);
insert into Posiciones (id, longitud, latitud) values (187, 112.673499, -8.2497955);
insert into Posiciones (id, longitud, latitud) values (188, 49.3957836, -18.1442811);
insert into Posiciones (id, longitud, latitud) values (189, 26.8687946, 59.4520561);
insert into Posiciones (id, longitud, latitud) values (190, 111.00746, 35.026516);
insert into Posiciones (id, longitud, latitud) values (191, -58.5146668, -34.6824081);
insert into Posiciones (id, longitud, latitud) values (192, 119.837124, 40.824367);
insert into Posiciones (id, longitud, latitud) values (193, -8.1366948, 41.5212778);
insert into Posiciones (id, longitud, latitud) values (194, 14.9688466, 50.8169272);
insert into Posiciones (id, longitud, latitud) values (195, 107.9887402, -7.4399956);
insert into Posiciones (id, longitud, latitud) values (196, 6.4641645, 49.7514502);
insert into Posiciones (id, longitud, latitud) values (197, 97.0686677, 5.2052959);
insert into Posiciones (id, longitud, latitud) values (198, 116.8097817, -0.6209357);
insert into Posiciones (id, longitud, latitud) values (199, 110.224358, 30.289195);
insert into Posiciones (id, longitud, latitud) values (200, 111.5655, -6.6641);
insert into Posiciones (id, longitud, latitud) values (201, 110.6794676, -7.8136774);
insert into Posiciones (id, longitud, latitud) values (202, 114.089617, 22.545902);
insert into Posiciones (id, longitud, latitud) values (203, 2.234305, 48.9101028);
insert into Posiciones (id, longitud, latitud) values (204, 52.6546785, 36.7048972);
insert into Posiciones (id, longitud, latitud) values (205, 100.6473542, 14.0654264);
insert into Posiciones (id, longitud, latitud) values (206, 34.911731, 32.305011);
insert into Posiciones (id, longitud, latitud) values (207, 37.5470072, 55.6686);
insert into Posiciones (id, longitud, latitud) values (208, 113.3612, 23.12468);
insert into Posiciones (id, longitud, latitud) values (209, 4.2552114, 45.521777);
insert into Posiciones (id, longitud, latitud) values (210, -56.0305724, -34.7328945);
insert into Posiciones (id, longitud, latitud) values (211, 2.4549884, 48.7803815);
insert into Posiciones (id, longitud, latitud) values (212, 100.3984148, -0.4660955);
insert into Posiciones (id, longitud, latitud) values (213, 21.331051, 43.5757545);
insert into Posiciones (id, longitud, latitud) values (214, 94.9302073, 45.7716857);
insert into Posiciones (id, longitud, latitud) values (215, 120.7990105, 15.5754812);
insert into Posiciones (id, longitud, latitud) values (216, 2.3501981, 48.8693156);
insert into Posiciones (id, longitud, latitud) values (217, -96.6038258, 32.8565219);
insert into Posiciones (id, longitud, latitud) values (218, 124.7833328, 6.6999998);
insert into Posiciones (id, longitud, latitud) values (219, -9.4174646, 38.9021066);
insert into Posiciones (id, longitud, latitud) values (220, 123.9023, -9.8076);
insert into Posiciones (id, longitud, latitud) values (221, 112.814502, 22.122658);
insert into Posiciones (id, longitud, latitud) values (222, 122.476035, 11.055153);
insert into Posiciones (id, longitud, latitud) values (223, 31.4620967, 30.6183919);
insert into Posiciones (id, longitud, latitud) values (224, -75.698571, 8.797145);
insert into Posiciones (id, longitud, latitud) values (225, 35.6955945, 31.067952);
insert into Posiciones (id, longitud, latitud) values (226, -0.3907558, 49.1931313);
insert into Posiciones (id, longitud, latitud) values (227, 35.13077, 32.20427);
insert into Posiciones (id, longitud, latitud) values (228, 10.997658, 35.4175712);
insert into Posiciones (id, longitud, latitud) values (229, -40.5940565, -11.7088712);
insert into Posiciones (id, longitud, latitud) values (230, -71.8121012, 45.1306898);
insert into Posiciones (id, longitud, latitud) values (231, 122.2662848, 10.7162361);
insert into Posiciones (id, longitud, latitud) values (232, 121.7508912, -8.7334983);
insert into Posiciones (id, longitud, latitud) values (233, 110.3592495, -7.8100327);
insert into Posiciones (id, longitud, latitud) values (234, 117.472253, 31.192206);
insert into Posiciones (id, longitud, latitud) values (235, 121.749495, 31.04808);
insert into Posiciones (id, longitud, latitud) values (236, -88.6639228, 15.3047612);
insert into Posiciones (id, longitud, latitud) values (237, 122.9666672, 10.8833332);
insert into Posiciones (id, longitud, latitud) values (238, -58.5764959, -34.6230015);
insert into Posiciones (id, longitud, latitud) values (239, 18.0551861, 59.330173);
insert into Posiciones (id, longitud, latitud) values (240, 21.2734409, 43.1405124);
insert into Posiciones (id, longitud, latitud) values (241, 130.6358305, 32.968121);
insert into Posiciones (id, longitud, latitud) values (242, 112.124865, 28.148729);
insert into Posiciones (id, longitud, latitud) values (243, 107.6047939, -6.904068);
insert into Posiciones (id, longitud, latitud) values (244, 111.7018452, -8.1264039);
insert into Posiciones (id, longitud, latitud) values (245, 36.21564, 33.54832);
insert into Posiciones (id, longitud, latitud) values (246, 34.6690605, -1.8413007);
insert into Posiciones (id, longitud, latitud) values (247, 45.176077, -12.836985);
insert into Posiciones (id, longitud, latitud) values (248, 87.2817272, 26.7943861);
insert into Posiciones (id, longitud, latitud) values (249, 117.441505, 39.405075);
insert into Posiciones (id, longitud, latitud) values (250, -15.7732633, 13.74372);
insert into Posiciones (id, longitud, latitud) values (251, 119.7389051, 49.2282881);
insert into Posiciones (id, longitud, latitud) values (252, 69.636351, 37.6254329);
insert into Posiciones (id, longitud, latitud) values (253, 4.3603508, 49.2958555);
insert into Posiciones (id, longitud, latitud) values (254, 25.5080144, 64.9099021);
insert into Posiciones (id, longitud, latitud) values (255, 125.0036133, 11.1802962);
insert into Posiciones (id, longitud, latitud) values (256, 19.65083, 40.64278);
insert into Posiciones (id, longitud, latitud) values (257, 121.1136216, 14.6074523);
insert into Posiciones (id, longitud, latitud) values (258, -71.4432943, 8.7130746);
insert into Posiciones (id, longitud, latitud) values (259, 42.344717, 52.0016128);
insert into Posiciones (id, longitud, latitud) values (260, 105.8804085, 22.2724243);
insert into Posiciones (id, longitud, latitud) values (261, 13.1018168, 55.9129296);
insert into Posiciones (id, longitud, latitud) values (262, 0.5235927, 13.4441631);
insert into Posiciones (id, longitud, latitud) values (263, 109.629628, 34.814591);
insert into Posiciones (id, longitud, latitud) values (264, 16.9717754, 49.9778407);
insert into Posiciones (id, longitud, latitud) values (265, -8.5917806, 41.4198927);
insert into Posiciones (id, longitud, latitud) values (266, 106.9168787, -6.1873861);
insert into Posiciones (id, longitud, latitud) values (267, -80.9041817, 22.7238445);
insert into Posiciones (id, longitud, latitud) values (268, 101.6259842, 2.9329721);
insert into Posiciones (id, longitud, latitud) values (269, 18.4682284, 50.1076329);
insert into Posiciones (id, longitud, latitud) values (270, 123.3991028, -8.5697306);
insert into Posiciones (id, longitud, latitud) values (271, 26.2103909, 54.1440921);
insert into Posiciones (id, longitud, latitud) values (272, 106.7617984, -6.6063841);
insert into Posiciones (id, longitud, latitud) values (273, 107.6047939, -6.904068);
insert into Posiciones (id, longitud, latitud) values (274, -64.1847851, -31.4505323);
insert into Posiciones (id, longitud, latitud) values (275, 44.8234696, 54.6464526);
insert into Posiciones (id, longitud, latitud) values (276, 43.2464427, 55.0375016);
insert into Posiciones (id, longitud, latitud) values (277, -40.37156, -7.0743223);
insert into Posiciones (id, longitud, latitud) values (278, 106.1719, -6.5294);
insert into Posiciones (id, longitud, latitud) values (279, 100.267638, 25.606486);
insert into Posiciones (id, longitud, latitud) values (280, 39.5632497, 50.1987725);
insert into Posiciones (id, longitud, latitud) values (281, 136.524372, 34.6330462);
insert into Posiciones (id, longitud, latitud) values (282, 112.5781478, -8.2247589);
insert into Posiciones (id, longitud, latitud) values (283, 110.792856, 22.058407);
insert into Posiciones (id, longitud, latitud) values (284, 125.9334539, 9.3296921);
insert into Posiciones (id, longitud, latitud) values (285, 121.0299296, 14.4400324);
insert into Posiciones (id, longitud, latitud) values (286, 119.320063, 31.784791);
insert into Posiciones (id, longitud, latitud) values (287, 117.164388, 39.174484);
insert into Posiciones (id, longitud, latitud) values (288, 19.7483781, 44.5209494);
insert into Posiciones (id, longitud, latitud) values (289, 23.2517507, 42.6687933);
insert into Posiciones (id, longitud, latitud) values (290, 120.6256806, 31.3106446);
insert into Posiciones (id, longitud, latitud) values (291, -57.5430848, -38.0033365);
insert into Posiciones (id, longitud, latitud) values (292, 2.6780176, 48.5129473);
insert into Posiciones (id, longitud, latitud) values (293, 123.2861901, 41.000673);
insert into Posiciones (id, longitud, latitud) values (294, 101.738528, 26.497765);
insert into Posiciones (id, longitud, latitud) values (295, -8.5349198, 41.2378592);
insert into Posiciones (id, longitud, latitud) values (296, 20.9739484, 52.423387);
insert into Posiciones (id, longitud, latitud) values (297, 34.5830034, 58.5083791);
insert into Posiciones (id, longitud, latitud) values (298, -75.8475853, 20.1871897);
insert into Posiciones (id, longitud, latitud) values (299, 1.1161166, 9.7437515);
insert into Posiciones (id, longitud, latitud) values (300, 108.842622, 34.527114);
insert into Posiciones (id, longitud, latitud) values (301, 55.8855974, 58.999782);
insert into Posiciones (id, longitud, latitud) values (302, 28.3570946, 57.3397034);
insert into Posiciones (id, longitud, latitud) values (303, 14.2657584, 40.8782107);
insert into Posiciones (id, longitud, latitud) values (304, -8.5541453, 41.3270528);
insert into Posiciones (id, longitud, latitud) values (305, 4.1638985, 50.0109884);
insert into Posiciones (id, longitud, latitud) values (306, 112.2771485, -8.1578871);
insert into Posiciones (id, longitud, latitud) values (307, 111.4812472, -8.298138);
insert into Posiciones (id, longitud, latitud) values (308, 1.967221, 48.8179158);
insert into Posiciones (id, longitud, latitud) values (309, 7.1036396, 13.5009779);
insert into Posiciones (id, longitud, latitud) values (310, -45.1904004, -22.8140057);
insert into Posiciones (id, longitud, latitud) values (311, 121.0227579, 14.592558);
insert into Posiciones (id, longitud, latitud) values (312, 110.7880536, -6.8243672);
insert into Posiciones (id, longitud, latitud) values (313, 124.6248039, -9.9097428);
insert into Posiciones (id, longitud, latitud) values (314, 22.8753674, 40.9937071);
insert into Posiciones (id, longitud, latitud) values (315, 121.2238236, 16.6500928);
insert into Posiciones (id, longitud, latitud) values (316, 66.9140468, 50.2496386);
insert into Posiciones (id, longitud, latitud) values (317, 104.0663422, 30.7016468);
insert into Posiciones (id, longitud, latitud) values (318, -70.6516913, -33.4408815);
insert into Posiciones (id, longitud, latitud) values (319, 122.6943665, 11.2088156);
insert into Posiciones (id, longitud, latitud) values (320, 106.5701927, -7.1221059);
insert into Posiciones (id, longitud, latitud) values (321, -76.1116997, -8.928324);
insert into Posiciones (id, longitud, latitud) values (322, -60.7301511, 11.1869803);
insert into Posiciones (id, longitud, latitud) values (323, 100.222545, 26.641315);
insert into Posiciones (id, longitud, latitud) values (324, 46.8239786, 40.5075632);
insert into Posiciones (id, longitud, latitud) values (325, 101.21667, 38.5);
insert into Posiciones (id, longitud, latitud) values (326, 121.918866, -8.7394711);
insert into Posiciones (id, longitud, latitud) values (327, 118.460176, 24.660711);
insert into Posiciones (id, longitud, latitud) values (328, -6.4649964, 32.2066153);
insert into Posiciones (id, longitud, latitud) values (329, 114.503339, 36.854929);
insert into Posiciones (id, longitud, latitud) values (330, 23.5454126, 50.5372538);
insert into Posiciones (id, longitud, latitud) values (331, 36.8519377, 32.5067042);
insert into Posiciones (id, longitud, latitud) values (332, 54.3033879, 60.3278292);
insert into Posiciones (id, longitud, latitud) values (333, -87.8537478, 15.8874377);
insert into Posiciones (id, longitud, latitud) values (334, 124.3365882, -9.6666989);
insert into Posiciones (id, longitud, latitud) values (335, -102.0662939, 19.4137276);
insert into Posiciones (id, longitud, latitud) values (336, 106.8306951, -6.4901067);
insert into Posiciones (id, longitud, latitud) values (337, 106.8209006, -6.192143);
insert into Posiciones (id, longitud, latitud) values (338, -73.4797036, -15.5030873);
insert into Posiciones (id, longitud, latitud) values (339, -92.08, 32.53);
insert into Posiciones (id, longitud, latitud) values (340, 35.0978385, 0.202957);
insert into Posiciones (id, longitud, latitud) values (341, 42.5779182, 1.2540403);
insert into Posiciones (id, longitud, latitud) values (342, 108.916255, 19.015744);
insert into Posiciones (id, longitud, latitud) values (343, 112.858217, -2.3769393);
insert into Posiciones (id, longitud, latitud) values (344, 131.0103712, 34.0319016);
insert into Posiciones (id, longitud, latitud) values (345, 37.2249417, 54.9790861);
insert into Posiciones (id, longitud, latitud) values (346, 23.2154337, 42.8130176);
insert into Posiciones (id, longitud, latitud) values (347, 111.8002195, -8.0568365);
insert into Posiciones (id, longitud, latitud) values (348, 111.997915, -8.1491211);
insert into Posiciones (id, longitud, latitud) values (349, 109.23577, -7.62385);
insert into Posiciones (id, longitud, latitud) values (350, -47.952747, -16.2513167);
insert into Posiciones (id, longitud, latitud) values (351, -8.6325611, 42.4556093);
insert into Posiciones (id, longitud, latitud) values (352, 24.6653537, 48.9240653);
insert into Posiciones (id, longitud, latitud) values (353, 30.4222341, 50.338999);
insert into Posiciones (id, longitud, latitud) values (354, 120.3637277, -8.6746707);
insert into Posiciones (id, longitud, latitud) values (355, 119.4015739, 41.245445);
insert into Posiciones (id, longitud, latitud) values (356, 16.955476, 51.9034509);
insert into Posiciones (id, longitud, latitud) values (357, 107.253334, 26.443249);
insert into Posiciones (id, longitud, latitud) values (358, 114.364875, 34.800458);
insert into Posiciones (id, longitud, latitud) values (359, 83.0470827, 54.9850214);
insert into Posiciones (id, longitud, latitud) values (360, -8.5070436, 54.2109904);
insert into Posiciones (id, longitud, latitud) values (361, 28.3466834, 57.7977392);
insert into Posiciones (id, longitud, latitud) values (362, 140.6689995, -2.5916025);
insert into Posiciones (id, longitud, latitud) values (363, -42.3336313, -22.8636192);
insert into Posiciones (id, longitud, latitud) values (364, 121.2502, 38.853468);
insert into Posiciones (id, longitud, latitud) values (365, 119.382381, 31.717564);
insert into Posiciones (id, longitud, latitud) values (366, 115.899262, 28.685085);
insert into Posiciones (id, longitud, latitud) values (367, -5.8406587, 30.3458998);
insert into Posiciones (id, longitud, latitud) values (368, 20.3755648, 41.9238499);
insert into Posiciones (id, longitud, latitud) values (369, 116.342934, 22.980665);
insert into Posiciones (id, longitud, latitud) values (370, 24.0942729, 53.0358086);
insert into Posiciones (id, longitud, latitud) values (371, 114.3213706, 29.8282551);
insert into Posiciones (id, longitud, latitud) values (372, -75.958017, 4.9497479);
insert into Posiciones (id, longitud, latitud) values (373, 21.668453, 47.491705);
insert into Posiciones (id, longitud, latitud) values (374, -48.1255698, -22.279958);
insert into Posiciones (id, longitud, latitud) values (375, 38.7095805, 55.3226595);
insert into Posiciones (id, longitud, latitud) values (376, 44.3803921, 35.4655761);
insert into Posiciones (id, longitud, latitud) values (377, 121.1293312, 14.5643857);
insert into Posiciones (id, longitud, latitud) values (378, 38.7015857, 44.3264928);
insert into Posiciones (id, longitud, latitud) values (379, 18.4207352, 59.4871523);
insert into Posiciones (id, longitud, latitud) values (380, 115.027634, 23.067896);
insert into Posiciones (id, longitud, latitud) values (381, -15.802612, 16.5163413);
insert into Posiciones (id, longitud, latitud) values (382, 39.7408362, 52.0391192);
insert into Posiciones (id, longitud, latitud) values (383, 121.436539, 31.188637);
insert into Posiciones (id, longitud, latitud) values (384, 107.6896073, -6.9586416);
insert into Posiciones (id, longitud, latitud) values (385, 106.6527099, -6.2023936);
insert into Posiciones (id, longitud, latitud) values (386, 2.4259452, 48.6379813);
insert into Posiciones (id, longitud, latitud) values (387, 16.5787482, 49.2914367);
insert into Posiciones (id, longitud, latitud) values (388, 65.8835448, 56.8881364);
insert into Posiciones (id, longitud, latitud) values (389, 103.7983752, 1.5484759);
insert into Posiciones (id, longitud, latitud) values (390, 25.3346543, 52.7085795);
insert into Posiciones (id, longitud, latitud) values (391, 117.3028803, -8.9670697);
insert into Posiciones (id, longitud, latitud) values (392, 103.1048449, -3.8246952);
insert into Posiciones (id, longitud, latitud) values (393, 114.482606, 29.605376);
insert into Posiciones (id, longitud, latitud) values (394, 72.1297653, 40.2487413);
insert into Posiciones (id, longitud, latitud) values (395, -8.598522, 41.1846313);
insert into Posiciones (id, longitud, latitud) values (396, 100.2992789, 16.5909145);
insert into Posiciones (id, longitud, latitud) values (397, 46.0897124, -25.1720132);
insert into Posiciones (id, longitud, latitud) values (398, 16.2979279, 49.9257105);
insert into Posiciones (id, longitud, latitud) values (399, -72.9833, -36.7333);
insert into Posiciones (id, longitud, latitud) values (400, 110.363649, -7.783297);
insert into Posiciones (id, longitud, latitud) values (401, 100.3976471, 13.657613);
insert into Posiciones (id, longitud, latitud) values (402, -7.3848547, 33.6835086);
insert into Posiciones (id, longitud, latitud) values (403, -66.8603112, 10.4816837);
insert into Posiciones (id, longitud, latitud) values (404, 13.4349336, 57.8004642);
insert into Posiciones (id, longitud, latitud) values (405, -106.5573172, 49.8756758);
insert into Posiciones (id, longitud, latitud) values (406, 47.6811837, 42.7249013);
insert into Posiciones (id, longitud, latitud) values (407, 140.4308159, -7.3162208);
insert into Posiciones (id, longitud, latitud) values (408, 115.4562114, -8.5614257);
insert into Posiciones (id, longitud, latitud) values (409, 21.3321974, 29.090585);
insert into Posiciones (id, longitud, latitud) values (410, 112.6285385, -8.0604636);
insert into Posiciones (id, longitud, latitud) values (411, 21.3812867, 38.0532887);
insert into Posiciones (id, longitud, latitud) values (412, 44.6207633, 34.8809639);
insert into Posiciones (id, longitud, latitud) values (413, 105.5005483, 11.3802442);
insert into Posiciones (id, longitud, latitud) values (414, 51.0782323, 56.2208485);
insert into Posiciones (id, longitud, latitud) values (415, 118.43196, 24.705643);
insert into Posiciones (id, longitud, latitud) values (416, 28.5797981, -15.712819);
insert into Posiciones (id, longitud, latitud) values (417, 15.1845475, 50.0705922);
insert into Posiciones (id, longitud, latitud) values (418, -86.355797, 14.11684);
insert into Posiciones (id, longitud, latitud) values (419, 117.509921, 37.489877);
insert into Posiciones (id, longitud, latitud) values (420, 21.1235461, 51.5144022);
insert into Posiciones (id, longitud, latitud) values (421, -68.1042424, -38.9467974);
insert into Posiciones (id, longitud, latitud) values (422, -75.281155, 8.853929);
insert into Posiciones (id, longitud, latitud) values (423, 71.6080009, 42.7197486);
insert into Posiciones (id, longitud, latitud) values (424, 118.909159, 32.096344);
insert into Posiciones (id, longitud, latitud) values (425, 0.6251541, 41.6543565);
insert into Posiciones (id, longitud, latitud) values (426, 124.7568082, 8.5131518);
insert into Posiciones (id, longitud, latitud) values (427, 30.8896701, 59.5403823);
insert into Posiciones (id, longitud, latitud) values (428, 117.731346, 27.372513);
insert into Posiciones (id, longitud, latitud) values (429, 14.908438, 50.4134249);
insert into Posiciones (id, longitud, latitud) values (430, 121.449972, 29.978387);
insert into Posiciones (id, longitud, latitud) values (431, 50.28319, 53.86668);
insert into Posiciones (id, longitud, latitud) values (432, 6.5319506, 53.2231057);
insert into Posiciones (id, longitud, latitud) values (433, 50.3334447, 40.4746848);
insert into Posiciones (id, longitud, latitud) values (434, 15.8196702, 50.6398985);
insert into Posiciones (id, longitud, latitud) values (435, 18.1022068, 59.4518841);
insert into Posiciones (id, longitud, latitud) values (436, 5.8978018, 43.4945737);
insert into Posiciones (id, longitud, latitud) values (437, 33.3565, 16.7095);
insert into Posiciones (id, longitud, latitud) values (438, -77.2864879, 3.2572094);
insert into Posiciones (id, longitud, latitud) values (439, -7.9783991, 40.6043141);
insert into Posiciones (id, longitud, latitud) values (440, 111.4469654, -7.5557614);
insert into Posiciones (id, longitud, latitud) values (441, -70.1158113, 8.7603327);
insert into Posiciones (id, longitud, latitud) values (442, 108.5522531, -6.7533085);
insert into Posiciones (id, longitud, latitud) values (443, 110.876154, -6.8308443);
insert into Posiciones (id, longitud, latitud) values (444, 111.865917, 22.550092);
insert into Posiciones (id, longitud, latitud) values (445, -46.0489795, -19.3107686);
insert into Posiciones (id, longitud, latitud) values (446, 54.3568562, 31.8974232);
insert into Posiciones (id, longitud, latitud) values (447, 120.564983, 28.438851);
insert into Posiciones (id, longitud, latitud) values (448, 123.0043968, 7.6703363);
insert into Posiciones (id, longitud, latitud) values (449, 179.20094, -8.51758);
insert into Posiciones (id, longitud, latitud) values (450, 115.402367, -8.5388252);
insert into Posiciones (id, longitud, latitud) values (451, 113.063143, 25.280547);
insert into Posiciones (id, longitud, latitud) values (452, 20.6364509, 51.5344639);
insert into Posiciones (id, longitud, latitud) values (453, 37.8989689, 13.1509414);
insert into Posiciones (id, longitud, latitud) values (454, 137.9224387, 34.7465855);
insert into Posiciones (id, longitud, latitud) values (455, -67.5018975, -45.8732238);
insert into Posiciones (id, longitud, latitud) values (456, 21.6020199, 50.0558922);
insert into Posiciones (id, longitud, latitud) values (457, 171.256569, -44.394663);
insert into Posiciones (id, longitud, latitud) values (458, 107.4780383, -6.4698758);
insert into Posiciones (id, longitud, latitud) values (459, 114.678669, -8.1913524);
insert into Posiciones (id, longitud, latitud) values (460, 107.0997164, -6.82482);
insert into Posiciones (id, longitud, latitud) values (461, 9.245302, 4.1481842);
insert into Posiciones (id, longitud, latitud) values (462, -8.4193536, 41.8457984);
insert into Posiciones (id, longitud, latitud) values (463, -8.6664683, 39.6080157);
insert into Posiciones (id, longitud, latitud) values (464, -106.6873356, 35.0880511);
insert into Posiciones (id, longitud, latitud) values (465, -66.7248247, 10.1794092);
insert into Posiciones (id, longitud, latitud) values (466, 121.1138058, 14.6688068);
insert into Posiciones (id, longitud, latitud) values (467, 117.531622, 32.874735);
insert into Posiciones (id, longitud, latitud) values (468, 103.0472164, 15.7734482);
insert into Posiciones (id, longitud, latitud) values (469, 119.3831026, -5.3383734);
insert into Posiciones (id, longitud, latitud) values (470, 113.625328, 34.746611);
insert into Posiciones (id, longitud, latitud) values (471, -58.6876178, -34.588234);
insert into Posiciones (id, longitud, latitud) values (472, 14.5391653, 46.2052815);
insert into Posiciones (id, longitud, latitud) values (473, 112.859759, 26.422277);
insert into Posiciones (id, longitud, latitud) values (474, 39.2583293, 8.5263486);
insert into Posiciones (id, longitud, latitud) values (475, 125.792864, 49.806882);
insert into Posiciones (id, longitud, latitud) values (476, 98.385029, 7.8851351);
insert into Posiciones (id, longitud, latitud) values (477, 23.5454126, 50.5372538);
insert into Posiciones (id, longitud, latitud) values (478, -4.1974627, 14.4874284);
insert into Posiciones (id, longitud, latitud) values (479, -76.5, 37.07);
insert into Posiciones (id, longitud, latitud) values (480, -14.108845, 16.2488504);
insert into Posiciones (id, longitud, latitud) values (481, 2.4381665, 48.6277459);
insert into Posiciones (id, longitud, latitud) values (482, -11.1166667, 9.1666667);
insert into Posiciones (id, longitud, latitud) values (483, 25.9063474, -27.8341089);
insert into Posiciones (id, longitud, latitud) values (484, -89.8909572, 16.9296881);
insert into Posiciones (id, longitud, latitud) values (485, 110.4914674, -7.7520206);
insert into Posiciones (id, longitud, latitud) values (486, -0.2338473, 5.6562651);
insert into Posiciones (id, longitud, latitud) values (487, 37.542155, 55.430827);
insert into Posiciones (id, longitud, latitud) values (488, 134.0620421, -0.8614531);
insert into Posiciones (id, longitud, latitud) values (489, 106.057816, 35.067361);
insert into Posiciones (id, longitud, latitud) values (490, 47.9368725, 57.6067536);
insert into Posiciones (id, longitud, latitud) values (491, 100.226423, 19.716697);
insert into Posiciones (id, longitud, latitud) values (492, 2.513543, 48.989038);
insert into Posiciones (id, longitud, latitud) values (493, 108.3534306, -7.365205);
insert into Posiciones (id, longitud, latitud) values (494, 28.1678543, -25.8664184);
insert into Posiciones (id, longitud, latitud) values (495, 28.7309501, 60.6302526);
insert into Posiciones (id, longitud, latitud) values (496, 15.28454, 53.5659675);
insert into Posiciones (id, longitud, latitud) values (497, 37.5438564, 54.7288441);
insert into Posiciones (id, longitud, latitud) values (498, 21.2374124, 37.9209684);
insert into Posiciones (id, longitud, latitud) values (499, 43.9553461, 40.6690083);
insert into Posiciones (id, longitud, latitud) values (500, -88.8190971, 13.7232155);

insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (1, TO_DATE('2020-11-10 03:07:10', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-08-05 01:24:16', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 82, 13);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (2, TO_DATE('2020-05-18 22:27:51', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-05-02 05:38:15', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 67, 23);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (3, TO_DATE('2020-07-03 12:39:07', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-16 01:42:01', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 8, 36);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (4, TO_DATE('2020-08-18 20:21:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-05-17 12:54:39', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 42, 46);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (5, TO_DATE('2020-11-24 04:16:51', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-12 02:36:09', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 72, 47);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (6, TO_DATE('2020-04-30 02:50:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-10 00:00:34', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 32, 4);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (7, TO_DATE('2020-03-15 14:47:15', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-18 16:39:24', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 74, 48);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (8, TO_DATE('2020-10-16 16:29:02', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-12 09:10:11', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 46, 4);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (9, TO_DATE('2020-01-26 22:21:36', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-03-28 09:56:35', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 15, 24);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (10, TO_DATE('2020-03-02 11:59:06', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-04 20:00:44', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 69, 43);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (11, TO_DATE('2020-04-21 10:59:18', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-14 19:26:19', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 69, 1);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (12, TO_DATE('2020-04-15 05:15:58', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-06 03:42:23', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 5, 36);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (13, TO_DATE('2020-10-08 23:42:17', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-23 11:48:23', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 9, 7);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (14, TO_DATE('2020-08-13 01:05:46', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-03-07 23:44:31', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 24, 16);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (15, TO_DATE('2020-03-19 19:32:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-23 23:51:26', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 5, 25);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (16, TO_DATE('2020-09-25 10:42:32', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-02 18:41:22', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 14, 18);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (17, TO_DATE('2020-05-15 14:19:03', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-05-25 00:53:29', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 45, 22);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (18, TO_DATE('2020-01-10 23:21:17', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-22 23:26:20', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 84, 6);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (19, TO_DATE('2020-03-17 10:45:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-05-12 12:48:34', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 36, 17);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (20, TO_DATE('2020-01-17 23:55:26', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-03 05:20:03', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 9, 9);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (21, TO_DATE('2020-05-10 23:50:33', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-11 14:17:56', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 47, 18);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (22, TO_DATE('2020-05-30 17:48:32', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-16 19:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 36, 9);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (23, TO_DATE('2020-09-25 16:18:31', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-08-05 18:47:26', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 53, 8);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (24, TO_DATE('2020-01-21 14:43:46', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-03-26 02:50:01', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 76, 34);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (25, TO_DATE('2020-04-27 16:23:17', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-10-21 02:37:13', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 45, 38);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (26, TO_DATE('2020-10-18 13:01:43', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-10-28 23:21:25', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 12, 44);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (27, TO_DATE('2020-09-05 10:27:32', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-03 01:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 78, 12);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (28, TO_DATE('2020-02-08 18:23:25', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-28 19:10:17', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 30, 7);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (29, TO_DATE('2020-02-07 12:35:48', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-13 09:15:35', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 68, 19);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (30, TO_DATE('2020-05-18 21:58:40', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-03 01:16:56', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 17, 48);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (31, TO_DATE('2020-08-02 13:23:07', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-10-20 10:51:58', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 74, 6);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (32, TO_DATE('2020-02-29 05:01:31', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-06 21:29:43', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 74, 33);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (33, TO_DATE('2019-12-14 02:06:14', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-15 20:17:39', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 10, 12);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (34, TO_DATE('2019-12-29 09:02:58', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-26 15:51:40', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 32, 9);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (35, TO_DATE('2020-01-08 16:36:03', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-23 01:32:40', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 26, 15);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (36, TO_DATE('2019-12-07 09:18:18', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-07-07 14:39:17', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 71, 25);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (37, TO_DATE('2020-10-24 14:05:18', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-07 05:57:13', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 30, 15);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (38, TO_DATE('2020-11-11 22:40:34', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-10 21:58:14', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 25, 48);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (39, TO_DATE('2020-02-15 15:17:16', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-23 03:10:08', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 17, 46);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (40, TO_DATE('2019-12-28 11:24:38', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-08-22 16:21:20', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 39, 48);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (41, TO_DATE('2020-04-27 04:29:28', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-11 10:00:13', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 15, 27);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (42, TO_DATE('2020-08-12 11:47:38', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-05-19 14:20:07', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 16, 10);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (43, TO_DATE('2020-11-23 12:39:40', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-03-15 08:58:58', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 43, 4);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (44, TO_DATE('2020-07-11 05:18:55', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-04 08:14:14', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 53, 9);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (45, TO_DATE('2019-12-27 10:57:59', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-21 08:50:44', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 76, 49);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (46, TO_DATE('2020-09-30 17:41:26', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-07 04:39:38', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 68, 49);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (47, TO_DATE('2020-04-10 09:22:18', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-02 12:10:07', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 55, 5);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (48, TO_DATE('2019-12-05 14:03:17', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-21 16:49:38', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 14, 20);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (49, TO_DATE('2020-07-19 14:51:27', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-20 20:33:13', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 85, 40);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (50, TO_DATE('2020-02-19 10:32:53', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-21 03:16:30', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 57, 14);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (51, TO_DATE('2020-03-30 08:20:59', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-02 08:09:40', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 58, 40);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (52, TO_DATE('2020-05-12 06:29:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-10-08 20:59:20', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 83, 17);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (53, TO_DATE('2020-05-21 06:33:12', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-10 07:49:37', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 17, 8);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (54, TO_DATE('2020-01-20 14:59:39', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-04 02:58:34', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 22, 14);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (55, TO_DATE('2020-01-06 22:48:35', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-05 00:57:00', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 54, 37);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (56, TO_DATE('2019-12-21 13:43:42', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-16 08:08:57', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 49, 2);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (57, TO_DATE('2020-06-12 12:16:36', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-24 22:30:09', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 32, 46);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (58, TO_DATE('2020-05-15 17:58:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-23 00:37:41', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 64, 39);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (59, TO_DATE('2020-05-26 17:29:42', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-03-03 12:40:26', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 36, 23);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (60, TO_DATE('2020-04-16 02:53:12', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-21 05:10:07', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 26, 14);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (61, TO_DATE('2019-12-25 01:23:15', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-31 07:21:14', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 44, 14);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (62, TO_DATE('2020-05-28 07:51:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-07-17 13:01:45', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 85, 32);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (63, TO_DATE('2020-10-06 05:53:07', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-01 23:52:42', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 37, 20);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (64, TO_DATE('2020-02-15 12:35:44', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-18 08:53:34', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 32, 18);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (65, TO_DATE('2020-01-10 00:24:38', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-04 00:14:03', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 18, 16);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (66, TO_DATE('2020-11-08 04:58:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-26 17:27:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 81, 3);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (67, TO_DATE('2020-07-08 00:35:38', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-19 20:04:15', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 51, 3);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (68, TO_DATE('2019-12-19 03:10:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-16 01:52:05', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 20, 12);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (69, TO_DATE('2020-09-02 22:55:12', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-18 10:53:40', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 62, 6);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (70, TO_DATE('2020-05-25 08:42:52', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-07-05 22:59:53', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 19, 12);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (71, TO_DATE('2020-07-06 08:05:54', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-07-20 01:08:32', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 37, 41);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (72, TO_DATE('2020-04-25 15:01:44', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-08-01 04:45:36', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 29, 42);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (73, TO_DATE('2020-07-01 05:58:53', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-25 09:46:41', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 24, 50);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (74, TO_DATE('2020-07-23 05:50:43', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-05 06:38:46', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 96, 41);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (75, TO_DATE('2020-03-05 06:58:42', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-10-30 23:08:38', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 26, 4);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (76, TO_DATE('2020-06-06 21:21:35', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-05-06 22:40:08', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 33, 27);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (77, TO_DATE('2020-07-17 22:37:28', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-02 18:46:59', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 83, 33);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (78, TO_DATE('2020-10-03 03:38:03', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-03-03 16:06:02', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 75, 33);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (79, TO_DATE('2020-06-27 09:12:23', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-19 14:15:55', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 43, 28);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (80, TO_DATE('2020-04-16 08:19:17', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-15 10:06:39', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 31, 27);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (81, TO_DATE('2020-04-20 13:58:54', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-12 21:59:40', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 6, 46);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (82, TO_DATE('2020-06-20 12:10:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-07-29 02:42:14', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 56, 25);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (83, TO_DATE('2020-03-23 09:34:18', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-08-16 04:15:33', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 16, 44);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (84, TO_DATE('2020-02-14 09:40:10', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-25 22:01:32', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 69, 3);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (85, TO_DATE('2020-10-08 11:49:23', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-19 15:03:34', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 5, 47);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (86, TO_DATE('2020-05-14 12:03:14', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-16 15:36:32', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 89, 21);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (87, TO_DATE('2020-10-03 15:22:40', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-07-06 23:25:01', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 47, 15);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (88, TO_DATE('2020-11-15 03:46:48', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-24 02:54:37', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 68, 16);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (89, TO_DATE('2020-03-22 14:32:04', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-06 12:55:58', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 7, 20);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (90, TO_DATE('2020-06-06 11:18:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-03 04:22:10', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 65, 11);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (91, TO_DATE('2020-04-05 13:56:02', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-12-22 11:37:58', 'YYYY-MM-DD HH24:MI:SS'), 'Pendiente', 62, 46);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (92, TO_DATE('2020-08-22 21:52:59', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-21 01:03:04', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 92, 44);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (93, TO_DATE('2020-02-21 03:32:11', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-07 16:27:02', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 62, 43);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (94, TO_DATE('2020-02-28 19:38:56', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-09-24 01:28:12', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 43, 50);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (95, TO_DATE('2020-09-27 02:04:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-08-12 11:54:21', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 69, 21);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (96, TO_DATE('2019-12-12 11:37:50', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-10-23 13:24:39', 'YYYY-MM-DD HH24:MI:SS'), 'Asignado', 34, 11);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (97, TO_DATE('2020-11-17 11:30:32', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-04-22 19:29:00', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 24, 27);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (98, TO_DATE('2020-04-01 21:04:14', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-01-21 11:59:24', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 3, 34);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (99, TO_DATE('2020-11-13 14:14:58', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-11-30 18:53:14', 'YYYY-MM-DD HH24:MI:SS'), 'Finalizado', 11, 15);
insert into Viajes (id, fechaInicio, fechaFin, estado, idVehiculo, idConductor) values (100, TO_DATE('2020-01-08 19:03:37', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-06-06 01:42:59', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelado', 19, 16);

insert into PosicionesViajes (idViaje, idPosicion) values (77, 175);
insert into PosicionesViajes (idViaje, idPosicion) values (77, 97);
insert into PosicionesViajes (idViaje, idPosicion) values (50, 235);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 176);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 404);
insert into PosicionesViajes (idViaje, idPosicion) values (67, 183);
insert into PosicionesViajes (idViaje, idPosicion) values (61, 234);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 437);
insert into PosicionesViajes (idViaje, idPosicion) values (8, 126);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 257);
insert into PosicionesViajes (idViaje, idPosicion) values (40, 336);
insert into PosicionesViajes (idViaje, idPosicion) values (44, 150);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 297);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 129);
insert into PosicionesViajes (idViaje, idPosicion) values (58, 202);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 373);
insert into PosicionesViajes (idViaje, idPosicion) values (60, 97);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 438);
insert into PosicionesViajes (idViaje, idPosicion) values (71, 394);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 324);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 325);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 241);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 481);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 404);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 488);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 351);
insert into PosicionesViajes (idViaje, idPosicion) values (64, 100);
insert into PosicionesViajes (idViaje, idPosicion) values (93, 44);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 432);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 146);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 124);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 89);
insert into PosicionesViajes (idViaje, idPosicion) values (83, 311);
insert into PosicionesViajes (idViaje, idPosicion) values (47, 136);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 499);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 445);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 234);
insert into PosicionesViajes (idViaje, idPosicion) values (83, 7);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 329);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 258);
insert into PosicionesViajes (idViaje, idPosicion) values (83, 120);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 187);
insert into PosicionesViajes (idViaje, idPosicion) values (85, 244);
insert into PosicionesViajes (idViaje, idPosicion) values (64, 130);
insert into PosicionesViajes (idViaje, idPosicion) values (52, 77);
insert into PosicionesViajes (idViaje, idPosicion) values (55, 286);
insert into PosicionesViajes (idViaje, idPosicion) values (23, 184);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 219);
insert into PosicionesViajes (idViaje, idPosicion) values (9, 425);
insert into PosicionesViajes (idViaje, idPosicion) values (43, 402);
insert into PosicionesViajes (idViaje, idPosicion) values (59, 239);
insert into PosicionesViajes (idViaje, idPosicion) values (63, 360);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 203);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 247);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 177);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 208);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 18);
insert into PosicionesViajes (idViaje, idPosicion) values (62, 188);
insert into PosicionesViajes (idViaje, idPosicion) values (32, 476);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 364);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 494);
insert into PosicionesViajes (idViaje, idPosicion) values (70, 249);
insert into PosicionesViajes (idViaje, idPosicion) values (23, 462);
insert into PosicionesViajes (idViaje, idPosicion) values (58, 448);
insert into PosicionesViajes (idViaje, idPosicion) values (62, 19);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 298);
insert into PosicionesViajes (idViaje, idPosicion) values (46, 290);
insert into PosicionesViajes (idViaje, idPosicion) values (81, 323);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 74);
insert into PosicionesViajes (idViaje, idPosicion) values (6, 393);
insert into PosicionesViajes (idViaje, idPosicion) values (46, 52);
insert into PosicionesViajes (idViaje, idPosicion) values (18, 187);
insert into PosicionesViajes (idViaje, idPosicion) values (22, 474);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 82);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 405);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 252);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 443);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 153);
insert into PosicionesViajes (idViaje, idPosicion) values (33, 219);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 118);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 242);
insert into PosicionesViajes (idViaje, idPosicion) values (70, 430);
insert into PosicionesViajes (idViaje, idPosicion) values (54, 73);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 195);
insert into PosicionesViajes (idViaje, idPosicion) values (67, 327);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 147);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 454);
insert into PosicionesViajes (idViaje, idPosicion) values (35, 3);
insert into PosicionesViajes (idViaje, idPosicion) values (59, 80);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 102);
insert into PosicionesViajes (idViaje, idPosicion) values (9, 442);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 157);
insert into PosicionesViajes (idViaje, idPosicion) values (35, 323);
insert into PosicionesViajes (idViaje, idPosicion) values (51, 416);
insert into PosicionesViajes (idViaje, idPosicion) values (82, 499);
insert into PosicionesViajes (idViaje, idPosicion) values (29, 132);
insert into PosicionesViajes (idViaje, idPosicion) values (6, 330);
insert into PosicionesViajes (idViaje, idPosicion) values (82, 21);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 434);
insert into PosicionesViajes (idViaje, idPosicion) values (6, 474);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 343);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 358);
insert into PosicionesViajes (idViaje, idPosicion) values (14, 472);
insert into PosicionesViajes (idViaje, idPosicion) values (62, 326);
insert into PosicionesViajes (idViaje, idPosicion) values (27, 171);
insert into PosicionesViajes (idViaje, idPosicion) values (81, 432);
insert into PosicionesViajes (idViaje, idPosicion) values (49, 55);
insert into PosicionesViajes (idViaje, idPosicion) values (17, 311);
insert into PosicionesViajes (idViaje, idPosicion) values (85, 4);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 386);
insert into PosicionesViajes (idViaje, idPosicion) values (46, 182);
insert into PosicionesViajes (idViaje, idPosicion) values (1, 210);
insert into PosicionesViajes (idViaje, idPosicion) values (65, 343);
insert into PosicionesViajes (idViaje, idPosicion) values (25, 367);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 97);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 29);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 196);
insert into PosicionesViajes (idViaje, idPosicion) values (80, 137);
insert into PosicionesViajes (idViaje, idPosicion) values (67, 62);
insert into PosicionesViajes (idViaje, idPosicion) values (32, 53);
insert into PosicionesViajes (idViaje, idPosicion) values (85, 345);
insert into PosicionesViajes (idViaje, idPosicion) values (38, 234);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 52);
insert into PosicionesViajes (idViaje, idPosicion) values (81, 150);
insert into PosicionesViajes (idViaje, idPosicion) values (75, 468);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 422);
insert into PosicionesViajes (idViaje, idPosicion) values (82, 278);
insert into PosicionesViajes (idViaje, idPosicion) values (63, 349);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 229);
insert into PosicionesViajes (idViaje, idPosicion) values (24, 49);
insert into PosicionesViajes (idViaje, idPosicion) values (36, 240);
insert into PosicionesViajes (idViaje, idPosicion) values (47, 1);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 344);
insert into PosicionesViajes (idViaje, idPosicion) values (35, 330);
insert into PosicionesViajes (idViaje, idPosicion) values (54, 138);
insert into PosicionesViajes (idViaje, idPosicion) values (32, 28);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 491);
insert into PosicionesViajes (idViaje, idPosicion) values (26, 298);
insert into PosicionesViajes (idViaje, idPosicion) values (55, 215);
insert into PosicionesViajes (idViaje, idPosicion) values (52, 126);
insert into PosicionesViajes (idViaje, idPosicion) values (47, 224);
insert into PosicionesViajes (idViaje, idPosicion) values (76, 232);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 336);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 130);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 147);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 58);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 104);
insert into PosicionesViajes (idViaje, idPosicion) values (98, 409);
insert into PosicionesViajes (idViaje, idPosicion) values (46, 74);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 60);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 58);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 99);
insert into PosicionesViajes (idViaje, idPosicion) values (93, 369);
insert into PosicionesViajes (idViaje, idPosicion) values (80, 168);
insert into PosicionesViajes (idViaje, idPosicion) values (45, 409);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 59);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 264);
insert into PosicionesViajes (idViaje, idPosicion) values (45, 85);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 284);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 370);
insert into PosicionesViajes (idViaje, idPosicion) values (45, 244);
insert into PosicionesViajes (idViaje, idPosicion) values (40, 36);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 104);
insert into PosicionesViajes (idViaje, idPosicion) values (47, 227);
insert into PosicionesViajes (idViaje, idPosicion) values (55, 70);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 275);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 499);
insert into PosicionesViajes (idViaje, idPosicion) values (42, 36);
insert into PosicionesViajes (idViaje, idPosicion) values (17, 273);
insert into PosicionesViajes (idViaje, idPosicion) values (13, 446);
insert into PosicionesViajes (idViaje, idPosicion) values (25, 10);
insert into PosicionesViajes (idViaje, idPosicion) values (29, 359);
insert into PosicionesViajes (idViaje, idPosicion) values (1, 138);
insert into PosicionesViajes (idViaje, idPosicion) values (24, 111);
insert into PosicionesViajes (idViaje, idPosicion) values (8, 43);
insert into PosicionesViajes (idViaje, idPosicion) values (41, 276);
insert into PosicionesViajes (idViaje, idPosicion) values (65, 21);
insert into PosicionesViajes (idViaje, idPosicion) values (26, 468);
insert into PosicionesViajes (idViaje, idPosicion) values (20, 184);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 494);
insert into PosicionesViajes (idViaje, idPosicion) values (27, 438);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 192);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 420);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 115);
insert into PosicionesViajes (idViaje, idPosicion) values (13, 183);
insert into PosicionesViajes (idViaje, idPosicion) values (36, 203);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 112);
insert into PosicionesViajes (idViaje, idPosicion) values (52, 396);
insert into PosicionesViajes (idViaje, idPosicion) values (10, 17);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 12);
insert into PosicionesViajes (idViaje, idPosicion) values (49, 303);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 327);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 61);
insert into PosicionesViajes (idViaje, idPosicion) values (38, 470);
insert into PosicionesViajes (idViaje, idPosicion) values (20, 93);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 206);
insert into PosicionesViajes (idViaje, idPosicion) values (64, 90);
insert into PosicionesViajes (idViaje, idPosicion) values (55, 19);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 159);
insert into PosicionesViajes (idViaje, idPosicion) values (56, 346);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 325);
insert into PosicionesViajes (idViaje, idPosicion) values (33, 205);
insert into PosicionesViajes (idViaje, idPosicion) values (29, 308);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 494);
insert into PosicionesViajes (idViaje, idPosicion) values (99, 468);
insert into PosicionesViajes (idViaje, idPosicion) values (63, 463);
insert into PosicionesViajes (idViaje, idPosicion) values (6, 98);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 150);
insert into PosicionesViajes (idViaje, idPosicion) values (38, 88);
insert into PosicionesViajes (idViaje, idPosicion) values (8, 225);
insert into PosicionesViajes (idViaje, idPosicion) values (64, 99);
insert into PosicionesViajes (idViaje, idPosicion) values (9, 27);
insert into PosicionesViajes (idViaje, idPosicion) values (19, 387);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 321);
insert into PosicionesViajes (idViaje, idPosicion) values (56, 340);
insert into PosicionesViajes (idViaje, idPosicion) values (85, 436);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 380);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 364);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 228);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 236);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 248);
insert into PosicionesViajes (idViaje, idPosicion) values (43, 276);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 142);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 427);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 200);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 420);
insert into PosicionesViajes (idViaje, idPosicion) values (25, 475);
insert into PosicionesViajes (idViaje, idPosicion) values (75, 40);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 193);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 170);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 422);
insert into PosicionesViajes (idViaje, idPosicion) values (49, 493);
insert into PosicionesViajes (idViaje, idPosicion) values (49, 52);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 216);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 485);
insert into PosicionesViajes (idViaje, idPosicion) values (81, 114);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 5);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 21);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 339);
insert into PosicionesViajes (idViaje, idPosicion) values (24, 196);
insert into PosicionesViajes (idViaje, idPosicion) values (87, 148);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 490);
insert into PosicionesViajes (idViaje, idPosicion) values (54, 279);
insert into PosicionesViajes (idViaje, idPosicion) values (47, 157);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 240);
insert into PosicionesViajes (idViaje, idPosicion) values (8, 42);
insert into PosicionesViajes (idViaje, idPosicion) values (36, 87);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 201);
insert into PosicionesViajes (idViaje, idPosicion) values (17, 138);
insert into PosicionesViajes (idViaje, idPosicion) values (49, 57);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 463);
insert into PosicionesViajes (idViaje, idPosicion) values (82, 339);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 309);
insert into PosicionesViajes (idViaje, idPosicion) values (99, 1);
insert into PosicionesViajes (idViaje, idPosicion) values (40, 202);
insert into PosicionesViajes (idViaje, idPosicion) values (86, 164);
insert into PosicionesViajes (idViaje, idPosicion) values (9, 292);
insert into PosicionesViajes (idViaje, idPosicion) values (26, 489);
insert into PosicionesViajes (idViaje, idPosicion) values (10, 124);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 180);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 200);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 6);
insert into PosicionesViajes (idViaje, idPosicion) values (59, 144);
insert into PosicionesViajes (idViaje, idPosicion) values (20, 317);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 333);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 148);
insert into PosicionesViajes (idViaje, idPosicion) values (60, 357);
insert into PosicionesViajes (idViaje, idPosicion) values (23, 472);
insert into PosicionesViajes (idViaje, idPosicion) values (7, 287);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 15);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 152);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 205);
insert into PosicionesViajes (idViaje, idPosicion) values (44, 102);
insert into PosicionesViajes (idViaje, idPosicion) values (40, 7);
insert into PosicionesViajes (idViaje, idPosicion) values (32, 131);
insert into PosicionesViajes (idViaje, idPosicion) values (94, 50);
insert into PosicionesViajes (idViaje, idPosicion) values (25, 183);
insert into PosicionesViajes (idViaje, idPosicion) values (94, 393);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 427);
insert into PosicionesViajes (idViaje, idPosicion) values (83, 405);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 79);
insert into PosicionesViajes (idViaje, idPosicion) values (18, 300);
insert into PosicionesViajes (idViaje, idPosicion) values (99, 175);
insert into PosicionesViajes (idViaje, idPosicion) values (85, 475);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 96);
insert into PosicionesViajes (idViaje, idPosicion) values (15, 425);
insert into PosicionesViajes (idViaje, idPosicion) values (99, 11);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 317);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 278);
insert into PosicionesViajes (idViaje, idPosicion) values (14, 417);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 94);
insert into PosicionesViajes (idViaje, idPosicion) values (56, 368);
insert into PosicionesViajes (idViaje, idPosicion) values (85, 313);
insert into PosicionesViajes (idViaje, idPosicion) values (50, 288);
insert into PosicionesViajes (idViaje, idPosicion) values (14, 92);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 188);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 70);
insert into PosicionesViajes (idViaje, idPosicion) values (17, 302);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 316);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 302);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 356);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 360);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 88);
insert into PosicionesViajes (idViaje, idPosicion) values (94, 172);
insert into PosicionesViajes (idViaje, idPosicion) values (91, 71);
insert into PosicionesViajes (idViaje, idPosicion) values (41, 78);
insert into PosicionesViajes (idViaje, idPosicion) values (65, 378);
insert into PosicionesViajes (idViaje, idPosicion) values (71, 123);
insert into PosicionesViajes (idViaje, idPosicion) values (16, 211);
insert into PosicionesViajes (idViaje, idPosicion) values (20, 187);
insert into PosicionesViajes (idViaje, idPosicion) values (62, 45);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 315);
insert into PosicionesViajes (idViaje, idPosicion) values (70, 126);
insert into PosicionesViajes (idViaje, idPosicion) values (10, 404);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 474);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 206);
insert into PosicionesViajes (idViaje, idPosicion) values (71, 386);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 27);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 412);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 190);
insert into PosicionesViajes (idViaje, idPosicion) values (44, 496);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 110);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 391);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 65);
insert into PosicionesViajes (idViaje, idPosicion) values (19, 79);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 6);
insert into PosicionesViajes (idViaje, idPosicion) values (7, 341);
insert into PosicionesViajes (idViaje, idPosicion) values (59, 226);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 447);
insert into PosicionesViajes (idViaje, idPosicion) values (29, 113);
insert into PosicionesViajes (idViaje, idPosicion) values (16, 352);
insert into PosicionesViajes (idViaje, idPosicion) values (95, 349);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 107);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 404);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 125);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 47);
insert into PosicionesViajes (idViaje, idPosicion) values (41, 163);
insert into PosicionesViajes (idViaje, idPosicion) values (83, 176);
insert into PosicionesViajes (idViaje, idPosicion) values (42, 431);
insert into PosicionesViajes (idViaje, idPosicion) values (98, 282);
insert into PosicionesViajes (idViaje, idPosicion) values (84, 127);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 399);
insert into PosicionesViajes (idViaje, idPosicion) values (24, 444);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 86);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 206);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 27);
insert into PosicionesViajes (idViaje, idPosicion) values (43, 430);
insert into PosicionesViajes (idViaje, idPosicion) values (59, 351);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 27);
insert into PosicionesViajes (idViaje, idPosicion) values (6, 155);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 113);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 172);
insert into PosicionesViajes (idViaje, idPosicion) values (32, 243);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 259);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 32);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 16);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 272);
insert into PosicionesViajes (idViaje, idPosicion) values (24, 358);
insert into PosicionesViajes (idViaje, idPosicion) values (95, 10);
insert into PosicionesViajes (idViaje, idPosicion) values (72, 434);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 290);
insert into PosicionesViajes (idViaje, idPosicion) values (13, 102);
insert into PosicionesViajes (idViaje, idPosicion) values (42, 293);
insert into PosicionesViajes (idViaje, idPosicion) values (35, 397);
insert into PosicionesViajes (idViaje, idPosicion) values (87, 114);
insert into PosicionesViajes (idViaje, idPosicion) values (61, 227);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 405);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 246);
insert into PosicionesViajes (idViaje, idPosicion) values (72, 204);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 229);
insert into PosicionesViajes (idViaje, idPosicion) values (7, 309);
insert into PosicionesViajes (idViaje, idPosicion) values (71, 202);
insert into PosicionesViajes (idViaje, idPosicion) values (52, 300);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 486);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 314);
insert into PosicionesViajes (idViaje, idPosicion) values (10, 302);
insert into PosicionesViajes (idViaje, idPosicion) values (17, 56);
insert into PosicionesViajes (idViaje, idPosicion) values (10, 214);
insert into PosicionesViajes (idViaje, idPosicion) values (25, 467);
insert into PosicionesViajes (idViaje, idPosicion) values (77, 399);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 150);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 89);
insert into PosicionesViajes (idViaje, idPosicion) values (58, 378);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 271);
insert into PosicionesViajes (idViaje, idPosicion) values (65, 44);
insert into PosicionesViajes (idViaje, idPosicion) values (65, 162);
insert into PosicionesViajes (idViaje, idPosicion) values (70, 70);
insert into PosicionesViajes (idViaje, idPosicion) values (58, 269);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 146);
insert into PosicionesViajes (idViaje, idPosicion) values (46, 352);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 225);
insert into PosicionesViajes (idViaje, idPosicion) values (19, 431);
insert into PosicionesViajes (idViaje, idPosicion) values (35, 6);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 141);
insert into PosicionesViajes (idViaje, idPosicion) values (30, 83);
insert into PosicionesViajes (idViaje, idPosicion) values (17, 467);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 245);
insert into PosicionesViajes (idViaje, idPosicion) values (54, 63);
insert into PosicionesViajes (idViaje, idPosicion) values (75, 13);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 407);
insert into PosicionesViajes (idViaje, idPosicion) values (15, 2);
insert into PosicionesViajes (idViaje, idPosicion) values (61, 475);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 2);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 131);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 22);
insert into PosicionesViajes (idViaje, idPosicion) values (79, 309);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 248);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 308);
insert into PosicionesViajes (idViaje, idPosicion) values (45, 230);
insert into PosicionesViajes (idViaje, idPosicion) values (40, 209);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 259);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 309);
insert into PosicionesViajes (idViaje, idPosicion) values (24, 481);
insert into PosicionesViajes (idViaje, idPosicion) values (60, 137);
insert into PosicionesViajes (idViaje, idPosicion) values (78, 379);
insert into PosicionesViajes (idViaje, idPosicion) values (36, 403);
insert into PosicionesViajes (idViaje, idPosicion) values (45, 491);
insert into PosicionesViajes (idViaje, idPosicion) values (95, 388);
insert into PosicionesViajes (idViaje, idPosicion) values (51, 200);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 1);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 136);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 122);
insert into PosicionesViajes (idViaje, idPosicion) values (57, 57);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 51);
insert into PosicionesViajes (idViaje, idPosicion) values (100, 383);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 124);
insert into PosicionesViajes (idViaje, idPosicion) values (37, 220);
insert into PosicionesViajes (idViaje, idPosicion) values (6, 113);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 483);
insert into PosicionesViajes (idViaje, idPosicion) values (82, 302);
insert into PosicionesViajes (idViaje, idPosicion) values (55, 54);
insert into PosicionesViajes (idViaje, idPosicion) values (96, 453);
insert into PosicionesViajes (idViaje, idPosicion) values (70, 24);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 374);
insert into PosicionesViajes (idViaje, idPosicion) values (2, 393);
insert into PosicionesViajes (idViaje, idPosicion) values (18, 238);
insert into PosicionesViajes (idViaje, idPosicion) values (23, 254);
insert into PosicionesViajes (idViaje, idPosicion) values (10, 96);
insert into PosicionesViajes (idViaje, idPosicion) values (60, 304);
insert into PosicionesViajes (idViaje, idPosicion) values (74, 438);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 125);
insert into PosicionesViajes (idViaje, idPosicion) values (22, 445);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 81);
insert into PosicionesViajes (idViaje, idPosicion) values (7, 473);
insert into PosicionesViajes (idViaje, idPosicion) values (31, 26);
insert into PosicionesViajes (idViaje, idPosicion) values (97, 85);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 30);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 64);
insert into PosicionesViajes (idViaje, idPosicion) values (29, 64);
insert into PosicionesViajes (idViaje, idPosicion) values (65, 393);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 396);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 428);
insert into PosicionesViajes (idViaje, idPosicion) values (89, 397);
insert into PosicionesViajes (idViaje, idPosicion) values (21, 75);
insert into PosicionesViajes (idViaje, idPosicion) values (53, 39);
insert into PosicionesViajes (idViaje, idPosicion) values (23, 475);
insert into PosicionesViajes (idViaje, idPosicion) values (11, 197);
insert into PosicionesViajes (idViaje, idPosicion) values (14, 70);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 173);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 423);
insert into PosicionesViajes (idViaje, idPosicion) values (9, 314);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 413);
insert into PosicionesViajes (idViaje, idPosicion) values (77, 425);
insert into PosicionesViajes (idViaje, idPosicion) values (34, 197);
insert into PosicionesViajes (idViaje, idPosicion) values (72, 382);
insert into PosicionesViajes (idViaje, idPosicion) values (27, 373);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 182);
insert into PosicionesViajes (idViaje, idPosicion) values (22, 116);
insert into PosicionesViajes (idViaje, idPosicion) values (20, 362);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 23);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 175);
insert into PosicionesViajes (idViaje, idPosicion) values (64, 230);
insert into PosicionesViajes (idViaje, idPosicion) values (22, 89);
insert into PosicionesViajes (idViaje, idPosicion) values (90, 19);
insert into PosicionesViajes (idViaje, idPosicion) values (8, 276);
insert into PosicionesViajes (idViaje, idPosicion) values (69, 46);
insert into PosicionesViajes (idViaje, idPosicion) values (40, 58);
insert into PosicionesViajes (idViaje, idPosicion) values (18, 65);
insert into PosicionesViajes (idViaje, idPosicion) values (48, 167);
insert into PosicionesViajes (idViaje, idPosicion) values (66, 171);
insert into PosicionesViajes (idViaje, idPosicion) values (80, 197);
insert into PosicionesViajes (idViaje, idPosicion) values (1, 259);
insert into PosicionesViajes (idViaje, idPosicion) values (76, 150);
insert into PosicionesViajes (idViaje, idPosicion) values (73, 391);
insert into PosicionesViajes (idViaje, idPosicion) values (68, 140);
insert into PosicionesViajes (idViaje, idPosicion) values (80, 112);
insert into PosicionesViajes (idViaje, idPosicion) values (22, 314);
insert into PosicionesViajes (idViaje, idPosicion) values (93, 436);
insert into PosicionesViajes (idViaje, idPosicion) values (39, 186);
insert into PosicionesViajes (idViaje, idPosicion) values (59, 466);
insert into PosicionesViajes (idViaje, idPosicion) values (54, 425);
insert into PosicionesViajes (idViaje, idPosicion) values (4, 56);
insert into PosicionesViajes (idViaje, idPosicion) values (88, 424);
insert into PosicionesViajes (idViaje, idPosicion) values (91, 259);
insert into PosicionesViajes (idViaje, idPosicion) values (38, 500);
insert into PosicionesViajes (idViaje, idPosicion) values (92, 339);
insert into PosicionesViajes (idViaje, idPosicion) values (15, 413);
insert into PosicionesViajes (idViaje, idPosicion) values (28, 143);
insert into PosicionesViajes (idViaje, idPosicion) values (12, 291);
insert into PosicionesViajes (idViaje, idPosicion) values (3, 214);

insert into Vehiculos (id, placa, estado, idConductor) values (1, 'ttm-770', 'Inactivo', 3);
insert into Vehiculos (id, placa, estado, idConductor) values (2, 'ctd-337', 'Retirado', 7);
insert into Vehiculos (id, placa, estado, idConductor) values (3, 'bbi-424', 'Retirado', 32);
insert into Vehiculos (id, placa, estado, idConductor) values (4, 'vnd-045', 'Activo', 12);
insert into Vehiculos (id, placa, estado, idConductor) values (5, 'hxc-412', 'Activo', 16);
insert into Vehiculos (id, placa, estado, idConductor) values (6, 'mki-535', 'Activo', 15);
insert into Vehiculos (id, placa, estado, idConductor) values (7, 'hmq-957', 'Activo', 24);
insert into Vehiculos (id, placa, estado, idConductor) values (8, 'vub-169', 'Retirado', 26);
insert into Vehiculos (id, placa, estado, idConductor) values (9, 'ngp-888', 'Retirado', 42);
insert into Vehiculos (id, placa, estado, idConductor) values (10, 'tjx-186', 'Activo', 34);
insert into Vehiculos (id, placa, estado, idConductor) values (11, 'hdd-021', 'Retirado', 48);
insert into Vehiculos (id, placa, estado, idConductor) values (12, 'ssc-429', 'Inactivo', 20);
insert into Vehiculos (id, placa, estado, idConductor) values (13, 'lwj-741', 'Activo', 39);
insert into Vehiculos (id, placa, estado, idConductor) values (14, 'dju-461', 'Retirado', 1);
insert into Vehiculos (id, placa, estado, idConductor) values (15, 'fci-412', 'Inactivo', 14);
insert into Vehiculos (id, placa, estado, idConductor) values (16, 'wdc-689', 'Retirado', 6);
insert into Vehiculos (id, placa, estado, idConductor) values (17, 'dsc-419', 'Inactivo', 2);
insert into Vehiculos (id, placa, estado, idConductor) values (18, 'kih-539', 'Inactivo', 3);
insert into Vehiculos (id, placa, estado, idConductor) values (19, 'fta-250', 'Activo', 39);
insert into Vehiculos (id, placa, estado, idConductor) values (20, 'dcu-707', 'Inactivo', 42);
insert into Vehiculos (id, placa, estado, idConductor) values (21, 'oqr-602', 'Activo', 36);
insert into Vehiculos (id, placa, estado, idConductor) values (22, 'loi-409', 'Inactivo', 48);
insert into Vehiculos (id, placa, estado, idConductor) values (23, 'wuj-671', 'Inactivo', 8);
insert into Vehiculos (id, placa, estado, idConductor) values (24, 'yih-977', 'Inactivo', 40);
insert into Vehiculos (id, placa, estado, idConductor) values (25, 'zxg-086', 'Retirado', 4);
insert into Vehiculos (id, placa, estado, idConductor) values (26, 'sjv-560', 'Retirado', 46);
insert into Vehiculos (id, placa, estado, idConductor) values (27, 'iyy-764', 'Activo', 10);
insert into Vehiculos (id, placa, estado, idConductor) values (28, 'igw-206', 'Inactivo', 37);
insert into Vehiculos (id, placa, estado, idConductor) values (29, 'lby-499', 'Activo', 4);
insert into Vehiculos (id, placa, estado, idConductor) values (30, 'rru-053', 'Retirado', 2);
insert into Vehiculos (id, placa, estado, idConductor) values (31, 'mlz-171', 'Inactivo', 44);
insert into Vehiculos (id, placa, estado, idConductor) values (32, 'epj-350', 'Inactivo', 3);
insert into Vehiculos (id, placa, estado, idConductor) values (33, 'evw-703', 'Activo', 49);
insert into Vehiculos (id, placa, estado, idConductor) values (34, 'ofg-179', 'Retirado', 4);
insert into Vehiculos (id, placa, estado, idConductor) values (35, 'dow-778', 'Activo', 34);
insert into Vehiculos (id, placa, estado, idConductor) values (36, 'rnq-620', 'Activo', 34);
insert into Vehiculos (id, placa, estado, idConductor) values (37, 'cpt-741', 'Activo', 27);
insert into Vehiculos (id, placa, estado, idConductor) values (38, 'zet-297', 'Retirado', 27);
insert into Vehiculos (id, placa, estado, idConductor) values (39, 'gbp-116', 'Activo', 45);
insert into Vehiculos (id, placa, estado, idConductor) values (40, 'feh-687', 'Inactivo', 31);
insert into Vehiculos (id, placa, estado, idConductor) values (41, 'ksq-750', 'Retirado', 49);
insert into Vehiculos (id, placa, estado, idConductor) values (42, 'ysb-614', 'Inactivo', 46);
insert into Vehiculos (id, placa, estado, idConductor) values (43, 'ozf-296', 'Activo', 30);
insert into Vehiculos (id, placa, estado, idConductor) values (44, 'eyz-014', 'Activo', 33);
insert into Vehiculos (id, placa, estado, idConductor) values (45, 'mkz-145', 'Retirado', 12);
insert into Vehiculos (id, placa, estado, idConductor) values (46, 'yvt-359', 'Retirado', 7);
insert into Vehiculos (id, placa, estado, idConductor) values (47, 'cju-880', 'Activo', 26);
insert into Vehiculos (id, placa, estado, idConductor) values (48, 'nfd-083', 'Activo', 16);
insert into Vehiculos (id, placa, estado, idConductor) values (49, 'sbx-054', 'Inactivo', 19);
insert into Vehiculos (id, placa, estado, idConductor) values (50, 'zcx-929', 'Inactivo', 39);
insert into Vehiculos (id, placa, estado, idConductor) values (51, 'kqv-307', 'Activo', 28);
insert into Vehiculos (id, placa, estado, idConductor) values (52, 'lpj-202', 'Inactivo', 21);
insert into Vehiculos (id, placa, estado, idConductor) values (53, 'llz-947', 'Inactivo', 17);
insert into Vehiculos (id, placa, estado, idConductor) values (54, 'xft-337', 'Retirado', 46);
insert into Vehiculos (id, placa, estado, idConductor) values (55, 'gys-748', 'Activo', 29);
insert into Vehiculos (id, placa, estado, idConductor) values (56, 'dvy-519', 'Inactivo', 19);
insert into Vehiculos (id, placa, estado, idConductor) values (57, 'fkd-976', 'Inactivo', 28);
insert into Vehiculos (id, placa, estado, idConductor) values (58, 'ucs-117', 'Retirado', 30);
insert into Vehiculos (id, placa, estado, idConductor) values (59, 'dqo-547', 'Retirado', 36);
insert into Vehiculos (id, placa, estado, idConductor) values (60, 'vlt-980', 'Retirado', 46);
insert into Vehiculos (id, placa, estado, idConductor) values (61, 'iph-619', 'Inactivo', 31);
insert into Vehiculos (id, placa, estado, idConductor) values (62, 'lpv-623', 'Activo', 25);
insert into Vehiculos (id, placa, estado, idConductor) values (63, 'fog-213', 'Inactivo', 1);
insert into Vehiculos (id, placa, estado, idConductor) values (64, 'huf-198', 'Activo', 47);
insert into Vehiculos (id, placa, estado, idConductor) values (65, 'ybd-078', 'Inactivo', 48);
insert into Vehiculos (id, placa, estado, idConductor) values (66, 'izi-920', 'Activo', 35);
insert into Vehiculos (id, placa, estado, idConductor) values (67, 'pno-295', 'Retirado', 7);
insert into Vehiculos (id, placa, estado, idConductor) values (68, 'ads-123', 'Inactivo', 39);
insert into Vehiculos (id, placa, estado, idConductor) values (69, 'mgw-223', 'Activo', 21);
insert into Vehiculos (id, placa, estado, idConductor) values (70, 'yqn-276', 'Activo', 13);
insert into Vehiculos (id, placa, estado, idConductor) values (71, 'brd-973', 'Activo', 13);
insert into Vehiculos (id, placa, estado, idConductor) values (72, 'zmx-514', 'Activo', 15);
insert into Vehiculos (id, placa, estado, idConductor) values (73, 'drf-598', 'Inactivo', 4);
insert into Vehiculos (id, placa, estado, idConductor) values (74, 'esb-867', 'Retirado', 30);
insert into Vehiculos (id, placa, estado, idConductor) values (75, 'pex-202', 'Activo', 44);
insert into Vehiculos (id, placa, estado, idConductor) values (76, 'kpv-976', 'Activo', 49);
insert into Vehiculos (id, placa, estado, idConductor) values (77, 'oyt-737', 'Retirado', 24);
insert into Vehiculos (id, placa, estado, idConductor) values (78, 'jgg-770', 'Activo', 39);
insert into Vehiculos (id, placa, estado, idConductor) values (79, 'cdp-735', 'Retirado', 32);
insert into Vehiculos (id, placa, estado, idConductor) values (80, 'ltc-896', 'Inactivo', 28);
insert into Vehiculos (id, placa, estado, idConductor) values (81, 'ehd-841', 'Activo', 20);
insert into Vehiculos (id, placa, estado, idConductor) values (82, 'ads-836', 'Activo', 13);
insert into Vehiculos (id, placa, estado, idConductor) values (83, 'vis-976', 'Activo', 36);
insert into Vehiculos (id, placa, estado, idConductor) values (84, 'apa-128', 'Retirado', 26);
insert into Vehiculos (id, placa, estado, idConductor) values (85, 'vdf-762', 'Activo', 32);
insert into Vehiculos (id, placa, estado, idConductor) values (86, 'iga-487', 'Activo', 9);
insert into Vehiculos (id, placa, estado, idConductor) values (87, 'ajl-771', 'Inactivo', 24);
insert into Vehiculos (id, placa, estado, idConductor) values (88, 'kpc-802', 'Inactivo', 3);
insert into Vehiculos (id, placa, estado, idConductor) values (89, 'kup-253', 'Inactivo', 45);
insert into Vehiculos (id, placa, estado, idConductor) values (90, 'zag-736', 'Inactivo', 44);
insert into Vehiculos (id, placa, estado, idConductor) values (91, 'sqr-403', 'Retirado', 20);
insert into Vehiculos (id, placa, estado, idConductor) values (92, 'zrw-606', 'Activo', 25);
insert into Vehiculos (id, placa, estado, idConductor) values (93, 'fsd-817', 'Inactivo', 12);
insert into Vehiculos (id, placa, estado, idConductor) values (94, 'dbk-438', 'Retirado', 41);
insert into Vehiculos (id, placa, estado, idConductor) values (95, 'agj-891', 'Inactivo', 35);
insert into Vehiculos (id, placa, estado, idConductor) values (96, 'aja-312', 'Inactivo', 6);
insert into Vehiculos (id, placa, estado, idConductor) values (97, 'uwe-780', 'Inactivo', 29);
insert into Vehiculos (id, placa, estado, idConductor) values (98, 'rzc-694', 'Activo', 49);
insert into Vehiculos (id, placa, estado, idConductor) values (99, 'lgj-764', 'Retirado', 25);
insert into Vehiculos (id, placa, estado, idConductor) values (100, 'gwn-717', 'Retirado', 16);


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

create or replace
procedure reset_seq( p_seq_name in varchar2 )
is
    l_val number;
begin
    execute immediate
    'select ' || p_seq_name || '.nextval from dual' INTO l_val;

    execute immediate
    'alter sequence ' || p_seq_name || ' increment by -' || l_val || 
                                                          ' minvalue 0';

    execute immediate
    'select ' || p_seq_name || '.nextval from dual' INTO l_val;

    execute immediate
    'alter sequence ' || p_seq_name || ' increment by 1 minvalue 0';
end;