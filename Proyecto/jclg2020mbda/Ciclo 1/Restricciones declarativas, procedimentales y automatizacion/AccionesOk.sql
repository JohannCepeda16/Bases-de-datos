---BORRAR UN ASESOR QUE ESTE ASIGNADO A UN USUARIO---
SELECT * FROM ASESORES;
SELECT * FROM USUARIOS;
DELETE FROM ASESORES WHERE CODIGO = 0001;
SELECT * FROM ASESORES;
SELECT * FROM USUARIOS;
---SI SE BORRA UN USUARIO QUE TENGA UNA OFERTA REGISTRADA ESTA OFERTA SE BORRA TAMBIEN---
SELECT * FROM USUARIOS;
SELECT * FROM OFERTAS;
DELETE FROM USUARIOS WHERE ID = 1;
SELECT * FROM USUARIOS;
SELECT * FROM OFERTAS;
---SI SE BORRA UN USUARIO QUE ESTE EN UN CONTRATO SE BORRA DE LA TABLA DE CONTRATOS TAMBIEN--
SELECT * FROM USUARIOS;
SELECT * FROM CONTRATOS;
DELETE FROM USUARIOS WHERE ID = 5;
SELECT * FROM USUARIOS;
SELECT * FROM CONTRATOS;
--SI SE BORRA UNA CONVOCATORIA SE BORRAN LOS CONTRATOS RELACIONADOS A ESTA--
SELECT * FROM CONVOCATORIAS;
SELECT * FROM CONTRATOS;
DELETE FROM CONVOCATORIA WHERE CODIGO = 2;
SELECT * FROM CONVOCATORIAS;
SELECT * FROM CONTRATOS;
--SI SE BORRA UNA OFERTA SE BORRAN LAS CONVOCATORIAS RELACIONADAS A ESTA--
SELECT * FROM CONVOCATORIAS;
SELECT * FROM OFERTAS;
DELETE FROM OFERTAS WHERE CODIGO = 3;
SELECT * FROM CONVOCATORIAS;
SELECT * FROM OFERTAS;