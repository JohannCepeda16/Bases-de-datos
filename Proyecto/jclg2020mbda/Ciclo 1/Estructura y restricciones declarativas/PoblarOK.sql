INSERT INTO ASESORES VALUES(1, 1000713816, 3105555555, 'panamiguel03@yahoo.com', 'josue', 'irion', 'CLL 55 NO 13 14' );
INSERT INTO ASESORES VALUES(2, 1000435645, 3104444444, 'masterchieff@yahoo.com', 'jhon', 'doe', 'CLL 3 no 44 55' );
INSERT INTO ASESORES VALUES(3, 5123123231, null , null , 'pepito', 'perez', 'CLL 55 NO 13 14' );

INSERT INTO USUARIOS VALUES(1, 'E', 0001);
INSERT INTO USUARIOS VALUES(2, 'PN', 0002);
INSERT INTO USUARIOS VALUES(3, 'E', 0002);
INSERT INTO USUARIOS VALUES(4, 'PN', 0003);
INSERT INTO USUARIOS VALUES(5, 'PN', 0003);

INSERT INTO PREFERENCIAS VALUES(2, 9000000, 'R', '<DIRECCION dato="Carrera 9 #168 - 30"><DEPARTAMENTO dep = "Bogotá"/><CITY Nombre="Bogota"><Localidad nombre="Usaquen"/><CodigoPostal codigo="110131"/></CITY></DIRECCION>', 'D');
INSERT INTO PREFERENCIAS VALUES(5, 3000000, 'P', '<DIRECCION dato="CLL REY PEPINITO NO 12 5"><DEPARTAMENTO dep = "Bogotá"/><CITY Nombre="Bogota"><Localidad nombre="Teusaquillo"/><CodigoPostal codigo="111321"/></CITY></DIRECCION>', 'D');
INSERT INTO PREFERENCIAS VALUES(4, 1200000, 'SP', '<DIRECCION dato="CLL WALLABY P.SHERMAN"><DEPARTAMENTO dep = "Bogotá"/><CITY Nombre="Bogota"><Localidad nombre="Teusaquillo"/><CodigoPostal codigo="111321"/></CITY></DIRECCION>', 'N');

INSERT INTO OFERTAS VALUES(1,1,'Programadores front python empresa de alimentos', 'Se requieren programadores de python para disenar el aplicativo de una empresa de alimentos','6 meses de experiencia en front', 13, 'cll 170 no 12 13', 2000000, 'D');
INSERT INTO OFERTAS VALUES(2,1,'Programadores backen python empresa de alimentos', 'Se requieren programadores de python para construir el aplicativo de una empresa de alimentos','12 meses de experiencia en baken', 5, 'cll 170 no 12 13', 3714507, 'D');
INSERT INTO OFERTAS VALUES(3,1,'Publicista con experiencia en redes sociales', 'Se necesita publicista para promover empresa de alimentos en redes sociales','8 anos de experiencia y un titulo de harvard, ademas de recien egresado', 1, 'cll 170 no 12 13', 1000000, 'D');

INSERT INTO CONVOCATORIAS VALUES(1, 1, to_date('12 06 2020', 'DD MM YYYY'),CURRENT_DATE);
INSERT INTO CONVOCATORIAS VALUES(2, 1, CURRENT_DATE ,to_date('12 06 2021', 'DD MM YYYY'));
INSERT INTO CONVOCATORIAS VALUES(3, 3, CURRENT_DATE ,to_date('12 12 2020', 'DD MM YYYY'));

INSERT INTO CONTRATOS VALUES(2, 2, 'Le vamos a pagar menos que a otros profesionales que hacen lo mismo solo porque no tiene experiencia y si se queja lo echamos', 1);
INSERT INTO CONTRATOS VALUES(4,1, 'Lo vamos a contratar de todas maneras porque es una empresa de mentiras y lo vamos a ahcer firmar los papeles para usarlo como chivo expiatorio', 0);
INSERT INTO CONTRATOS VALUES(4,3, 'TIENE DISLEXIA GRADO 2', 0);
