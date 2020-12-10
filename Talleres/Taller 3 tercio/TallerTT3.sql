CREATE TABLE MATERIAS(
 sigla CHAR(4) NOT NULL,
 nombre VARCHAR(30) NOT NULL);
 
ALTER TABLE MATERIAS ADD CONSTRAINT PK_MATERIAS
 PRIMARY KEY(sigla);
 
CREATE TABLE GRUPOS(
 materia CHAR(4) NOT NULL,
 numero NUMBER(2) NOT NULL,
 capacidad NUMBER(2) NOT NULL,
 inscritos NUMBER(2) NOT NULL);
 
ALTER TABLE GRUPOS ADD CONSTRAINT PK_GRUPOS
 PRIMARY KEY (materia,numero);
 
ALTER TABLE GRUPOS ADD CONSTRAINT FK_GRUPOS_MATERIAS
 FOREIGN KEY(materia) REFERENCES MATERIAS(sigla);
 
 CREATE TABLE ESTUDIANTES(
 codigo NUMBER(7) NOT NULL,
 nombres VARCHAR(50) NOT NULL);
 
ALTER TABLE ESTUDIANTES ADD CONSTRAINT PK_ESTUDIANTES
 PRIMARY KEY(codigo);
 
CREATE TABLE INSCRIPCIONES(
 materia CHAR(4) NOT NULL,
 numero NUMBER(2) NOT NULL,
 estudiante NUMBER(7) NOT NULL);
 
ALTER TABLE INSCRIPCIONES ADD CONSTRAINT PK_INSCRIPCIONES
 PRIMARY KEY(materia,estudiante);
 
ALTER TABLE INSCRIPCIONES ADD CONSTRAINT FK_INSCRIPCIONES_ESTUDIANTES
 FOREIGN KEY(estudiante) REFERENCES ESTUDIANTES(codigo);
 
ALTER TABLE INSCRIPCIONES ADD CONSTRAINT FK_INSCRIPCIONES_GRUPOS
 FOREIGN KEY(materia,numero) REFERENCES GRUPOS(materia, numero);
 
 
CREATE OR REPLACE PROCEDURE INSCRIBIR(xEstudiante IN NUMBER, xMateria IN CHAR, xNumero IN NUMBER) IS
 xInscritos NUMBER(2);
 xCapacidad NUMBER(2);
BEGIN
SELECT inscritos, capacidad INTO xInscritos, xCapacidad
 FROM GRUPOS
 WHERE materia=xMateria AND numero=xNumero;
 IF (xInscritos < xCapacidad) THEN
	INSERT INTO INSCRIPCIONES(materia,numero,estudiante)
	VALUES (xMateria,xNumero,xEstudiante);
	UPDATE GRUPOS SET inscritos=inscritos+1
	WHERE materia=xMateria AND numero=xNumero;
 ELSE THEN 
 	ROLLBACK;
	RAISE_APPLICATION_ERROR(-20001, 'EL NUMERO DE INSCRITOS SUPERA LA CAPACIDAD');
 END IF;
 COMMIT;
END INSCRIBIR;

