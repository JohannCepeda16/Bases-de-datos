INSERT INTO ASESORES VALUES(-0001, 1000713816, 3105555555, 'panamiguel03@yahoo.com', 'josue', 'irion', 'CLL 55 NO 13 14' );
INSERT INTO ASESORES VALUES(0002, null, 3104444444, 'asdda', 'jhon', 'doe', 'CLL 3 no 44 55' );
INSERT INTO ASESORES VALUES(0003, 5123123231, null , null , 'pepito', 'perez', 'CLL 55 NO 13 14' );

INSERT INTO USUARIOS VALUES(1, 'ASDSA', 0001);
INSERT INTO USUARIOS VALUES(1, 'PSDA', 0002);
INSERT INTO USUARIOS VALUES(-1, 'PNO', 0002);
INSERT INTO USUARIOS VALUES(-3, 'SAD', 0003);

INSERT INTO PREFERENCIAS VALUES(2, -900000, 'R', 'CLL 44D NO 45 30');
INSERT INTO PREFERENCIAS VALUES(3, 3000000, 'asdsa', 'CLL REY PEPINITO NO 12 5');
INSERT INTO PREFERENCIAS VALUES(14, 1200000, 'sdddds', 'CLL WALLABY P.SHERMAN');

INSERT INTO OFERTAS VALUES(24,8,'Programadores front python empresa de alimentos', 'Se requieren programadores de python para disenar el aplicativo de una empresa de alimentos','6 meses de experiencia en front', 6, 'cll 170 no 12 13', 2000000);
INSERT INTO OFERTAS VALUES(2,1,'Programadores backen python empresa de alimentos', 'Se requieren programadores de python para construir el aplicativo de una empresa de alimentos','12 meses de experiencia en baken', -5, 'cll 170 no 12 13', 3714507);
INSERT INTO OFERTAS VALUES(3,1,'Publicista con experiencia en redes sociales', 'Se necesita publicista para promover empresa de alimentos en redes sociales','8 anos de experiencia y un titulo de harvard, ademas de recien egresado', 1, 'cll 170 no 12 13', -1000000);

INSERT INTO CONVOCATORIAS VALUES(1, 1, 'sda',CURRENT_DATE, 'D' );
INSERT INTO CONVOCATORIAS VALUES(2, 1, CURRENT_DATE ,to_date('12 06 2021', 'DD MM YYYY'), 'O' );
INSERT INTO CONVOCATORIAS VALUES(2, 1, CURRENT_DATE ,to_date('12 12 2020', 'DD MM YYYY'), 'N' );

INSERT INTO CONTRATOS VALUES(5, 2, 'Le vamos a pagar menos que a otros profesionales que hacen lo mismo solo porque no tiene experiencia y si se queja lo echamos');
INSERT INTO CONTRATOS VALUES(2, 2, 'Lo vamos a contratar de todas maneras porque es una empresa de mentiras y lo vamos a ahcer firmar los papeles para usarlo como chivo expiatorio');
