/*TABLAS*/
CREATE TABLE SHIFT(
SHIFT_DATE DATE NOT NULL,
SHIFT_TYPE VARCHAR2(7) NOT NULL,
MANAGER VARCHAR2(7) NOT NULL,
OPERATOR VARCHAR2(7) NOT NULL,
ENGINEER1 VARCHAR2(7) NOT NULL,
ENGINEER2 VARCHAR2(7)
);

CREATE TABLE SHIFT_TYPE(
SHIFT_TYPE VARCHAR2(7) NOT NULL,
START_TIME VARCHAR2(5),
END_TIME VARCHAR2(5)
);

CREATE TABLE STAFF(
STAFF_CODE VARCHAR2(6) NOT NULL,
FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
LEVEL_CODE NUMBER(11)
);

CREATE TABLE LEVEL_(
LEVEL_CODE NUMBER(11) NOT NULL,
OPERATOR VARCHAR2(1),
MANAGER VARCHAR2(1),
ENGINEER VARCHAR2(1)
);

CREATE TABLE ISSUE(
CALL_DATE DATE NOT NULL,
CALL_REF NUMBER(11) NOT NULL,
CALLER_ID NUMBER(11) NOT NULL,
DETAIL VARCHAR2(255),
TAKEN_BY VARCHAR2(6) NOT NULL,
ASSIGNED_TO VARCHAR2(6) NOT NULL,
STATUS VARCHAR2(10)
);

CREATE TABLE CALLER(
CALLER_ID NUMBER(11) NOT NULL,
COMPANY_REF NUMBER(11),
FIRTS_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50)
);

CREATE TABLE CUSTOMER(
COMPANY_REF NUMBER(11) NOT NULL,
COMPANY_NAME VARCHAR2(50),
CONTACT_ID NUMBER(11),
ADRESS_1 VARCHAR2(50),
ADRESS_2 VARCHAR2(50),
TOWN VARCHAR2(50),
POSTCODE VARCHAR2(50),
TELEPHONE VARCHAR2(50)
);

/*PRIMARY*/
ALTER TABLE SHIFT ADD CONSTRAINT PK_SHIFT PRIMARY KEY(SHIFT_DATE, SHIFT_TYPE);
ALTER TABLE SHIFT_TYPE ADD CONSTRAINT PK_SHIFT_TYPE PRIMARY KEY(SHIFT_TYPE);
ALTER TABLE LEVEL_ ADD CONSTRAINT PK_LEVEL PRIMARY KEY(LEVEL_CODE);
ALTER TABLE STAFF ADD CONSTRAINT PK_STAFF PRIMARY KEY(STAFF_CODE);
ALTER TABLE CUSTOMER ADD CONSTRAINT PK_CUSTOMER PRIMARY KEY(COMPANY_REF);
ALTER TABLE ISSUE ADD CONSTRAINT PK_ISSUE PRIMARY KEY(CALL_REF);
ALTER TABLE CALLER ADD CONSTRAINT PK_CALLER PRIMARY KEY(CALLER_ID);

/*FOREIGN*/
ALTER TABLE SHIFT ADD CONSTRAINT FK_SHIFT_1 FOREIGN KEY(OPERATOR) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;
ALTER TABLE SHIFT ADD CONSTRAINT FK_SHIFT_2 FOREIGN KEY(MANAGER) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;
ALTER TABLE SHIFT ADD CONSTRAINT FK_SHIFT_3 FOREIGN KEY(ENGINEER1) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;
ALTER TABLE SHIFT ADD CONSTRAINT FK_SHIFT_4 FOREIGN KEY(ENGINEER2) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;
ALTER TABLE STAFF ADD CONSTRAINT FK_STAFF FOREIGN KEY(LEVEL_CODE) REFERENCES LEVEL_(LEVEL_CODE) ON DELETE CASCADE;
ALTER TABLE CALLER ADD CONSTRAINT FK_CALLER FOREIGN KEY(COMPANY_REF) REFERENCES CUSTOMER(COMPANY_REF) ON DELETE CASCADE;
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_1 FOREIGN KEY(CALLER_ID) REFERENCES CALLER(CALLER_ID) ON DELETE CASCADE;
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_2 FOREIGN KEY(ASSIGNED_TO) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;
ALTER TABLE ISSUE ADD CONSTRAINT FK_ISSUE_3 FOREIGN KEY(TAKEN_BY) REFERENCES STAFF(STAFF_CODE) ON DELETE CASCADE;

/*POBLANDO OK*/

--LEVEL--
INSERT INTO LEVEL_ VALUES(1, null, 'Y', null);
INSERT INTO LEVEL_ VALUES(2, null, null, 'Y');
INSERT INTO LEVEL_ VALUES(3, null, 'Y', 'Y');
INSERT INTO LEVEL_ VALUES(4, 'Y', null, null);
INSERT INTO LEVEL_ VALUES(5, 'Y', 'Y', null);
INSERT INTO LEVEL_ VALUES(7, 'Y', 'Y', 'Y');

--SHIFT_TYPE--
INSERT INTO SHIFT_TYPE VALUES('Early', '08:00', '14:00');
INSERT INTO SHIFT_TYPE VALUES('Late', '14:00', '20:00');

--STAFF--
INSERT INTO STAFF VALUES('AB1', 'Anthony', 'Butler', 1);
INSERT INTO STAFF VALUES('AB2', 'Alexis', 'Butler', 3);
INSERT INTO STAFF VALUES('AE1', 'Ava', 'Ellis', 7);
INSERT INTO STAFF VALUES('AL1', 'Alexander', 'Lawson', 3);
INSERT INTO STAFF VALUES('AW1', 'Alyssa', 'White', 1);
INSERT INTO STAFF VALUES('BJ1', 'Briony', 'Jones', 2);
INSERT INTO STAFF VALUES('DJ1', 'David', 'Jones', 2);
INSERT INTO STAFF VALUES('EB1', 'Emily', 'Butler', 3);
INSERT INTO STAFF VALUES('EB2', 'Emily', 'Best', 5);
INSERT INTO STAFF VALUES('EH1', 'Ethan', 'Hopgood', 3);
INSERT INTO STAFF VALUES('HP1', 'Hannah', 'Penrice', 3);
INSERT INTO STAFF VALUES('IL1', 'Isabella', 'Lawson', 1);
INSERT INTO STAFF VALUES('IM1', 'Isabella', 'McConnell', 1);
INSERT INTO STAFF VALUES('JE1', 'Joseph', 'Elrick', 3);
INSERT INTO STAFF VALUES('JL1', 'Joshua', 'Lawson', 2);
INSERT INTO STAFF VALUES('JP1', 'James', 'Penrice', 3);
INSERT INTO STAFF VALUES('LB1', 'Logan', 'Butler', 4);
INSERT INTO STAFF VALUES('MB1', 'Michael', 'Best', 3);
INSERT INTO STAFF VALUES('ME1', 'Mia', 'Ellis', 3);
INSERT INTO STAFF VALUES('ME2', 'Mia', 'Edmond', 1);
INSERT INTO STAFF VALUES('MM1', 'Madison', 'McConnell', 3);
INSERT INTO STAFF VALUES('MW1', 'Michael', 'White', 3);
INSERT INTO STAFF VALUES('NL1', 'Natalie', 'Lodge', 3);
INSERT INTO STAFF VALUES('NS1', 'Noah', 'Smith', 1);

--SHIFT--
INSERT INTO SHIFT VALUES(to_date('Sat, 12 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Early', 'LB1', 'AW1', 'AE1', 'JE1');
INSERT INTO SHIFT VALUES(to_date('Sat, 12 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Late', 'AE1', 'IM1', 'AL1', 'BJ1');
INSERT INTO SHIFT VALUES(to_date('Sun, 13 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Early', 'AE1', 'MM1', 'MW1', null);
INSERT INTO SHIFT VALUES(to_date('Sun, 13 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Late', 'AE1', 'AE1', 'EB1', null);
INSERT INTO SHIFT VALUES(to_date('Mon, 14 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Early', 'LB1', 'AB1', 'DJ1', 'JP1');
INSERT INTO SHIFT VALUES(to_date('Mon, 14 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Late', 'LB1', 'JE1', 'AB2', 'BJ1');
INSERT INTO SHIFT VALUES(to_date('Tue, 15 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Early', 'LB1', 'NS1', 'AE1', 'MB1');
INSERT INTO SHIFT VALUES(to_date('Tue, 15 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Late', 'LB1', 'HP1', 'EH1', 'AL1');
INSERT INTO SHIFT VALUES(to_date('Wed, 16 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Early', 'LB1', 'EB2', 'ME1', 'MM1');
INSERT INTO SHIFT VALUES(to_date('Wed, 16 Aug 2017 00:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 'Late', 'LB1', 'ME2', 'AB2', 'DJ1');

--CUSTOMER--
INSERT INTO CUSTOMER VALUES(100, 'Haunt Services', 112, '53 Finger Gate', null, 'Dartford', 'DA48 5WU', '01001722832');
INSERT INTO CUSTOMER VALUES(101, 'Genus Ltd.', 33, '34 Pyorrhea Green', null, 'Guildford', 'GY34 4ZH', '01004256920');
INSERT INTO CUSTOMER VALUES(102, 'Corps Ltd.', 111, '67 Napery Green', null, 'Harrow', 'HA32 6PP', '01012384042');
INSERT INTO CUSTOMER VALUES(103, 'Train Services', 115, '30 Crizzel Parkway', null, 'Hemel Hempstead', 'HP38 6DU', '01012979358');
INSERT INTO CUSTOMER VALUES(104, 'Somebody Logistics', 127, '93 Calculated Oval', null, 'Hull', 'HX16 1IF', '01013707879');
INSERT INTO CUSTOMER VALUES(105, 'Immemorial Shipping', 103, '38 Bull Circle', null, 'Harrow', 'HA38 4QQ', '01018421989');
INSERT INTO CUSTOMER VALUES(106, 'Mock Group', 125, '85 Civic Green', null, 'Isle of Man', 'IV23 6XJ', '01022482900');
INSERT INTO CUSTOMER VALUES(107, 'Juan and Co.', 113, '68 Quicky Green', null, 'Reading', 'RG17 9KQ', '01030703414');
INSERT INTO CUSTOMER VALUES(108, 'Logis Shipping', 4, '47 Invader Gardens', null, 'Warrington', 'WA42 4XU', '01032611339');
INSERT INTO CUSTOMER VALUES(109, 'Packman Shipping', 142, '75 Speech Causeway', null, 'Belfast', 'AB20 7GW', '01038105677');
INSERT INTO CUSTOMER VALUES(110, 'Jesting Services', 104, '12 Faults Highlands', null, 'Lancaster', 'KY12 2LW', '01061248265');
INSERT INTO CUSTOMER VALUES(111, 'Medusa Shipping', 114, '71 Contradict Grade', null, 'Colchester', 'CO47 2TH', '01064625959');
INSERT INTO CUSTOMER VALUES(112, 'Cell Group', 45, '48 Donut Rise', null, 'Portsmouth', 'PO35 5DD', '01075188464');
INSERT INTO CUSTOMER VALUES(113, 'Tetraneuris Shipping', 86, '47 Judge Green', null, 'Derby', 'DE15 2FY', '01076912545');
INSERT INTO CUSTOMER VALUES(114, 'Hydrophobic Inc.', 47, '86 Old Avenue', null, 'Jersey', 'JE26 5IF', '01100989120');
INSERT INTO CUSTOMER VALUES(115, 'Whale Shipping', 17, '88 Demotic Row', null, 'Newport', 'NE41 6ZY', '01106754312');
INSERT INTO CUSTOMER VALUES(116, 'Corncob Shipping', 123, '97 Triumvir Grade', null, 'Liverpool', 'L07 5TQ', '01112575119');
INSERT INTO CUSTOMER VALUES(117, 'Confusion Services', 32, '93 Meristically Mount', null, 'Fylde Coast', 'FY04 2ZW', '01133455062');
INSERT INTO CUSTOMER VALUES(118, 'Parade and Co.', 148, '89 Quicky Way', null, 'Zetland', 'ZE12 6VN', '01152353680');
INSERT INTO CUSTOMER VALUES(119, 'Crepusculous Inc.', 57, '11 Away Drive', null, 'Exeter', 'EX34 5AZ', '01157516706');
INSERT INTO CUSTOMER VALUES(120, 'Variform Traders', 16, '100 Poetize Dell', null, 'Tonbridge', 'TN49 4YR', '01162621897');
INSERT INTO CUSTOMER VALUES(121, 'Sprightlier Logistics', 128, '16 Basso Hill', null, 'Blackburn', 'BB40 4PK', '01167376116');
INSERT INTO CUSTOMER VALUES(122, 'Snowless Traders', 60, '99 Ting Oval', null, 'Telford', 'TF47 5BS', '01174403286');
INSERT INTO CUSTOMER VALUES(123, 'Hamming Services', 34, '32 Fish Passage', null, 'Bolton', 'BB22 5CH', '01181877930');
INSERT INTO CUSTOMER VALUES(124, 'Pharyngeal Services', 105, '55 Away Circle', null, 'North London', 'NE19 2VM', '01184718264');
INSERT INTO CUSTOMER VALUES(125, 'Nightshade Group', 49, '67 Portrait Place', null, 'Bolton', 'BB48 2DE', '01184937755');
INSERT INTO CUSTOMER VALUES(126, 'Oxbridge Shipping', 97, '21 Intent Passage', null, 'Falkirk', 'FK06 9BA', '01187899790');
INSERT INTO CUSTOMER VALUES(127, 'Sylvite Group', 14, '73 Shift Avenue', null, 'Norwich', 'NR24 8RL', '01189708942');
INSERT INTO CUSTOMER VALUES(128, 'Pitiable Shipping', 35, '61 Pitiable Street', null, 'Lancaster', 'KY13 5CU', '01193980854');
INSERT INTO CUSTOMER VALUES(129, 'Jesting and Co.', 3, '48 Keynote Avenue', null, 'Dumfries and Galloway', 'DY06 2SS', '01201368693');
INSERT INTO CUSTOMER VALUES(130, 'Affright Retail', 55, '18 Redingote Dell', null, 'Tonbridge', 'TN46 7JF', '01208830667');
INSERT INTO CUSTOMER VALUES(131, 'Gimmick Inc.', 73, '85 Motherly Mount', null, 'Motherwell', 'ML24 5YV', '01211392468');
INSERT INTO CUSTOMER VALUES(132, 'Fawe Group', 12, '64 Oryx Manor', null, 'Llandudno', 'LS07 8HM', '01214251676');
INSERT INTO CUSTOMER VALUES(133, 'Bai Services', 31, '3 Wish Canyon', null, 'Motherwell', 'ML01 7GD', '01214717135');
INSERT INTO CUSTOMER VALUES(134, 'Cupulate Ltd.', 2, '46 Desert Dell', null, 'Llandudno', 'LS28 5BG', '01215101189');
INSERT INTO CUSTOMER VALUES(135, 'Dasher Services', 58, '62 Fatback Hill', null, 'Canterbury', 'BT28 8AE', '01215210671');
INSERT INTO CUSTOMER VALUES(136, 'Askew Shipping', 72, '71 Creature Grade', null, 'Croydon', 'CR28 9WA', '01221993420');
INSERT INTO CUSTOMER VALUES(137, 'Take Group', 15, '45 Prejudicial Square', null, 'Warrington', 'WA17 9RW', '01222475899');
INSERT INTO CUSTOMER VALUES(138, 'Miraculously Shipping', 96, '45 Winter Causeway', null, 'Canterbury', 'BT21 8JE', '01224961986');
INSERT INTO CUSTOMER VALUES(139, 'Stoker Traders', 129, '101 Peridiastole Pathway', null, 'Canterbury', 'BT30 1RQ', '01239424132');
INSERT INTO CUSTOMER VALUES(140, 'Lady Retail', 59, '4 Oryx Trail', null, 'Oldham', 'OL27 5AK', '01239513404');
INSERT INTO CUSTOMER VALUES(141, 'Guttata Shipping', 102, '80 Flop Road', null, 'Falkirk', 'FK33 9SM', '01248008671');
INSERT INTO CUSTOMER VALUES(142, 'Diaphonic Shipping', 10, '93 Rajab Vale', null, 'Shrewsbury', 'S03 8IT', '01250487837');
INSERT INTO CUSTOMER VALUES(143, 'Rajab Group', 13, '96 Prejudicial Garth', null, 'Norwich', 'NR11 5YY', '01251104649');
INSERT INTO CUSTOMER VALUES(144, 'Snowless Logistics', 51, '85 Shun Drive', null, 'Derby', 'DE19 3UT', '01291288810');
INSERT INTO CUSTOMER VALUES(145, 'Comfiture Traders', 85, '23 Talaria Hill', null, 'Telford', 'TF17 7CW', '01291585639');
INSERT INTO CUSTOMER VALUES(146, 'High and Co.', 46, '93 Choicely Circle', null, 'Llandrindod Wells', 'LD29 3DO', '01294771012');
INSERT INTO CUSTOMER VALUES(147, 'Shaped Logistics', 126, '34 Confusion Mews', null, 'Plymouth', 'PL14 1FY', '01297122202');
INSERT INTO CUSTOMER VALUES(148, 'Desert Inc.', 124, '85 Rajab Trail', null, 'Derby', 'DE46 7IX', '01297608632');
INSERT INTO CUSTOMER VALUES(149, 'Askew Inc.', 56, '37 Unmediated Parkway', null, 'Walsall', 'UB20 5SQ', '01299818072');

--CALLER--
INSERT INTO CALLER VALUES (1,111,'Ava','Clarke');
INSERT INTO CALLER VALUES (2,134,'Ava','Edwards');
INSERT INTO CALLER VALUES (3,129,'John','Green');
INSERT INTO CALLER VALUES (4,108,'Ryan','White');
INSERT INTO CALLER VALUES (5,114,'Noah','Evans');
INSERT INTO CALLER VALUES (6,130,'Adam','Green');
INSERT INTO CALLER VALUES (7,136,'Alex','Davis');
INSERT INTO CALLER VALUES (8,134,'Alfie','Lee');
INSERT INTO CALLER VALUES (9,120,'Evie','Patel');
INSERT INTO CALLER VALUES (10,142,'Alfie','Butler');
INSERT INTO CALLER VALUES (11,142,'David','Jackson');
INSERT INTO CALLER VALUES (12,132,'Conor','Lawson');
INSERT INTO CALLER VALUES (13,143,'Emily','Cooper');
INSERT INTO CALLER VALUES (14,127,'Ashley','Hill');
INSERT INTO CALLER VALUES (15,137,'David','Davies');
INSERT INTO CALLER VALUES (16,120,'Ryan','oConnor');
INSERT INTO CALLER VALUES (17,115,'Alexis','Best');
INSERT INTO CALLER VALUES (18,135,'Grace','Wright');
INSERT INTO CALLER VALUES (19,140,'Joshua','Wood');
INSERT INTO CALLER VALUES (20,100,'Noah','Anderson');
INSERT INTO CALLER VALUES (21,105,'Noah','Williams');
INSERT INTO CALLER VALUES (22,149,'Adam','Harrison');
INSERT INTO CALLER VALUES (23,116,'Alfie','Elrick');
INSERT INTO CALLER VALUES (24,135,'Alfie','Turner');
INSERT INTO CALLER VALUES (25,132,'Alyssa','King');
INSERT INTO CALLER VALUES (26,123,'Amelia','Best');
INSERT INTO CALLER VALUES (27,110,'Ashley','Best');
INSERT INTO CALLER VALUES (28,109,'Chloe','Harris');
INSERT INTO CALLER VALUES (29,128,'Chloe','Walker');
INSERT INTO CALLER VALUES (30,113,'Emily','Wright');
INSERT INTO CALLER VALUES (31,133,'Alexis','Gritten');
INSERT INTO CALLER VALUES (32,117,'Amelia','Roberts');
INSERT INTO CALLER VALUES (33,101,'Sophie','Johnson');
INSERT INTO CALLER VALUES (34,123,'Madison','Young');
INSERT INTO CALLER VALUES (35,128,'Ethan','McConnell');
INSERT INTO CALLER VALUES (36,148,'Hannah','Brandom');
INSERT INTO CALLER VALUES (37,123,'James','McConnell');
INSERT INTO CALLER VALUES (38,146,'Jessica','Young');
INSERT INTO CALLER VALUES (39,110,'Joshua','Brandom');
INSERT INTO CALLER VALUES (40,109,'Madison','Brown');
INSERT INTO CALLER VALUES (41,118,'Madison','Lodge');
INSERT INTO CALLER VALUES (42,100,'Amelia','Penrice');
INSERT INTO CALLER VALUES (43,114,'Anthony','Lodge');
INSERT INTO CALLER VALUES (44,140,'Ashley','Penrice');
INSERT INTO CALLER VALUES (45,112,'Nicholas','Wilson');
INSERT INTO CALLER VALUES (46,146,'Elizabeth','Hall');
INSERT INTO CALLER VALUES (47,114,'Alexander','Bell');
INSERT INTO CALLER VALUES (48,131,'Isabella','Elrick');
INSERT INTO CALLER VALUES (49,125,'Christopher','Martin');
INSERT INTO CALLER VALUES (50,108,'Ava','Best');

--ISSUE-
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 08:16:00', 'DY, DD MON YYYY HH24:MI:SS'), 1237, 9, 'How can I guarantee a digital communication in Oracle ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 08:24:00', 'DY, DD MON YYYY HH24:MI:SS'), 1238, 10, 'How can I vanish a task-based documentation in Adobe Acrobat ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 08:29:00', 'DY, DD MON YYYY HH24:MI:SS'), 1239, 12, 'How can I request a usability in Microsoft Powerpoint ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 08:43:00', 'DY, DD MON YYYY HH24:MI:SS'), 1240, 13, 'How can I skip a aspect ratio in Oracle ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 08:48:00', 'DY, DD MON YYYY HH24:MI:SS'), 1241, 14, 'I am trying to train a locator in SQL Server but the Information Mapping is too wacky', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 08:49:00', 'DY, DD MON YYYY HH24:MI:SS'), 1242, 15, 'I am trying to wobble a access key in SQL Server but the XML schema is too reflective', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:01:00', 'DY, DD MON YYYY HH24:MI:SS'), 1243, 16, 'I am trying to scatter a tacit knowledge in Adobe PhotoShop but the CSS is too tawdry', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:01:00', 'DY, DD MON YYYY HH24:MI:SS'), 1244, 17, 'How can I remind a vocabulary list in Microsoft Excel ?', 'AW1', 'JE1', 'Open');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:03:00', 'DY, DD MON YYYY HH24:MI:SS'), 1245, 18, 'How can I prevent a authoring memory in Adobe Acrobat ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:03:00', 'DY, DD MON YYYY HH24:MI:SS'), 1246, 19, 'How can I match a audience analysis in Microsoft Word ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:03:00', 'DY, DD MON YYYY HH24:MI:SS'), 1247, 20, 'How can I trust a reference manual in Adobe PhotoShop ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:05:00', 'DY, DD MON YYYY HH24:MI:SS'), 1248, 21, 'How can I haunt a reference manual in Microsoft Excel ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:05:00', 'DY, DD MON YYYY HH24:MI:SS'), 1249, 22, 'How can I mine a Extensible Markup Language in Microsoft Powerpoint ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:06:00', 'DY, DD MON YYYY HH24:MI:SS'), 1250, 23, 'I am trying to look a documentation in Adobe PhotoShop but the standard operating procedure is too abiding', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:18:00', 'DY, DD MON YYYY HH24:MI:SS'), 1251, 24, 'How can I ignore a technical author in Microsoft Word ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:22:00', 'DY, DD MON YYYY HH24:MI:SS'), 1252, 25, 'I am trying to damage a technical writing in Oracle but the controlled language is too lying', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:26:00', 'DY, DD MON YYYY HH24:MI:SS'), 1253, 26, 'How can I hammer a marketing communications in Microsoft Powerpoint ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:35:00', 'DY, DD MON YYYY HH24:MI:SS'), 1254, 27, 'I am trying to scrub a bulleted list in Microsoft Excel but the usability is too wide', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:36:00', 'DY, DD MON YYYY HH24:MI:SS'), 1255, 28, 'How can I amuse a embedded index in SQL Server ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:38:00', 'DY, DD MON YYYY HH24:MI:SS'), 1256, 29, 'I am trying to like a rule-based writing in Microsoft Word but the end matter is too typical', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:42:00', 'DY, DD MON YYYY HH24:MI:SS'), 1257, 30, 'I am trying to interfere a embedded help in Adobe PhotoShop but the running foot is too glib', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 09:48:00', 'DY, DD MON YYYY HH24:MI:SS'), 1258, 31, 'How can I scare a training needs analysis in Camtasia Studio ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:00:00', 'DY, DD MON YYYY HH24:MI:SS'), 1259, 32, 'I am trying to excite a FlashHelp in Microsoft Powerpoint but the QuikScan is too bad', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:03:00', 'DY, DD MON YYYY HH24:MI:SS'), 1260, 33, 'I am trying to weigh a domain expert in Oracle but the single-source publishing is too ruddy', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:14:00', 'DY, DD MON YYYY HH24:MI:SS'), 1262, 35, 'Can you tell me how to make the information architecture in Camtasia Studio more understood', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:14:00', 'DY, DD MON YYYY HH24:MI:SS'), 1263, 36, 'Can you tell me how to make the knowledge management in SQL Server more royal', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:18:00', 'DY, DD MON YYYY HH24:MI:SS'), 1264, 37, 'Can you tell me how to make the litho printing in Oracle more watchful', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:22:00', 'DY, DD MON YYYY HH24:MI:SS'), 1265, 45, 'Can you tell me how to make the print on demand in Camtasia Studio more cagey', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:23:00', 'DY, DD MON YYYY HH24:MI:SS'), 1266, 46, 'Can you tell me how to make the style sheet in Camtasia Studio more adjoining', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:31:00', 'DY, DD MON YYYY HH24:MI:SS'), 1267, 47, 'Can you tell me how to make the structured authoring in MySQL more acceptable', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:34:00', 'DY, DD MON YYYY HH24:MI:SS'), 1268, 48, 'Can you tell me how to make the technical writer in MySQL more abiding', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 10:51:00', 'DY, DD MON YYYY HH24:MI:SS'), 1269, 49, 'I am trying to try a back-of-the-book index in Camtasia Studio but the user guide is too understood', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES(to_date('Sat, 12 Aug 2017 11:01:00', 'DY, DD MON YYYY HH24:MI:SS'), 1270, 50, 'I am trying to touch a online help in MySQL but the house style is too furtive', 'AW1', 'AE1', 'Closed');

/*Consultas*/
SELECT DISTINCT COMPANY_NAME
FROM CUSTOMER
INNER JOIN CALLER ON(CUSTOMER.COMPANY_REF = CALLER.COMPANY_REF);

SELECT DISTINCT FIRST_NAME
FROM STAFF
INNER JOIN LEVEL_ ON(STAFF.LEVEL_CODE = LEVEL_.LEVEL_CODE);

SELECT STAFF.FIRST_NAME, LEVEL_.ENGINEER1
FROM STAFF
FULL OUTER JOIN LEVEL_
ON(STAFF.LEVEL_CODE = LEVEL_.LEVEL_CODE)
ORDER BY FIRST_NAME;

/*POBLANDO NO OK*/

--ISSUE-
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 08:16:00',  1237, 9, 'How can I guarantee a digital communication in Oracle ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 08:24:00',  1238, 10, 'How can I vanish a task-based documentation in Adobe Acrobat ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 08:29:00',  1239, 12, 'How can I request a usability in Microsoft Powerpoint ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 08:43:00',  1240, 13, 'How can I skip a aspect ratio in Oracle ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 08:48:00',  1241, 14, 'I am trying to train a locator in SQL Server but the Information Mapping is too wacky', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 08:49:00',  1242, 15, 'I am trying to wobble a access key in SQL Server but the XML schema is too reflective', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:01:00',  1243, 16, 'I am trying to scatter a tacit knowledge in Adobe PhotoShop but the CSS is too tawdry', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:01:00',  1244, 17, 'How can I remind a vocabulary list in Microsoft Excel ?', 'AW1', 'JE1', 'Open');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:03:00',  1245, 18, 'How can I prevent a authoring memory in Adobe Acrobat ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:03:00',  1246, 19, 'How can I match a audience analysis in Microsoft Word ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:03:00',  1247, 20, 'How can I trust a reference manual in Adobe PhotoShop ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:05:00',  1248, 21, 'How can I haunt a reference manual in Microsoft Excel ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:05:00',  1249, 22, 'How can I mine a Extensible Markup Language in Microsoft Powerpoint ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:06:00',  1250, 23, 'I am trying to look a documentation in Adobe PhotoShop but the standard operating procedure is too abiding', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:18:00',  1251, 24, 'How can I ignore a technical author in Microsoft Word ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:22:00',  1252, 25, 'I am trying to damage a technical writing in Oracle but the controlled language is too lying', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:26:00',  1253, 26, 'How can I hammer a marketing communications in Microsoft Powerpoint ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:35:00',  1254, 27, 'I am trying to scrub a bulleted list in Microsoft Excel but the usability is too wide', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:36:00',  1255, 28, 'How can I amuse a embedded index in SQL Server ?', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:38:00',  1256, 29, 'I am trying to like a rule-based writing in Microsoft Word but the end matter is too typical', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:42:00',  1257, 30, 'I am trying to interfere a embedded help in Adobe PhotoShop but the running foot is too glib', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 09:48:00',  1258, 31, 'How can I scare a training needs analysis in Camtasia Studio ?', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:00:00',  1259, 32, 'I am trying to excite a FlashHelp in Microsoft Powerpoint but the QuikScan is too bad', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:03:00',  1260, 33, 'I am trying to weigh a domain expert in Oracle but the single-source publishing is too ruddy', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:14:00',  1262, 35, 'Can you tell me how to make the information architecture in Camtasia Studio more understood', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:14:00',  1263, 36, 'Can you tell me how to make the knowledge management in SQL Server more royal', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:18:00',  1264, 37, 'Can you tell me how to make the litho printing in Oracle more watchful', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:22:00',  1265, 45, 'Can you tell me how to make the print on demand in Camtasia Studio more cagey', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:23:00',  1266, 46, 'Can you tell me how to make the style sheet in Camtasia Studio more adjoining', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:31:00',  1267, 47, 'Can you tell me how to make the structured authoring in MySQL more acceptable', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:34:00',  1268, 48, 'Can you tell me how to make the technical writer in MySQL more abiding', 'AW1', 'JE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 10:51:00',  1269, 49, 'I am trying to try a back-of-the-book index in Camtasia Studio but the user guide is too understood', 'AW1', 'AE1', 'Closed');
INSERT INTO ISSUE VALUES('Sat, 12 Aug 2017 11:01:00',  1270, 50, 'I am trying to touch a online help in MySQL but the house style is too furtive', 'AW1', 'AE1', 'Closed');

--SHIFT--
INSERT INTO SHIFT VALUES('Sat, 12 Aug 2017 00:00:00',  'Early', 'LB1', 'AW1', 'AE1', 'JE1');
INSERT INTO SHIFT VALUES('Sat, 12 Aug 2017 00:00:00',  'Late', 'AE1', 'IM1', 'AL1', 'BJ1');
INSERT INTO SHIFT VALUES('Sun, 13 Aug 2017 00:00:00',  'Early', 'AE1', 'MM1', 'MW1', 'null');
INSERT INTO SHIFT VALUES('Sun, 13 Aug 2017 00:00:00',  'Late', 'AE1', 'AE1', 'EB1', 'null');
INSERT INTO SHIFT VALUES('Mon, 14 Aug 2017 00:00:00',  'Early', 'LB1', 'AB1', 'DJ1', 'JP1');
INSERT INTO SHIFT VALUES('Mon, 14 Aug 2017 00:00:00',  'Late', 'LB1', 'JE1', 'AB2', 'BJ1');
INSERT INTO SHIFT VALUES('Tue, 15 Aug 2017 00:00:00',  'Early', 'LB1', 'NS1', 'AE1', 'MB1');
INSERT INTO SHIFT VALUES('Tue, 15 Aug 2017 00:00:00',  'Late', 'LB1', 'HP1', 'EH1', 'AL1');
INSERT INTO SHIFT VALUES('Wed, 16 Aug 2017 00:00:00',  'Early', 'LB1', 'EB2', 'ME1', 'MM1');
INSERT INTO SHIFT VALUES('Wed, 16 Aug 2017 00:00:00',  'Late', 'LB1', 'ME2', 'AB2', 'DJ1');

--STAFF--
INSERT INTO STAFF VALUES('AB1', 'Anthony', 'Butler', 1);
INSERT INTO STAFF VALUES('AB2', 'Alexis', 'Butler', 3);
INSERT INTO STAFF VALUES('AE1', 'Ava', 'Ellis', 7);
INSERT INTO STAFF VALUES('AL1', 'Alexander', 'Lawson', 3);
INSERT INTO STAFF VALUES('AW1', 'Alyssa', 'White', 1);
INSERT INTO STAFF VALUES('BJ1', 'Briony', 'Jones', 2);
INSERT INTO STAFF VALUES('DJ1', 'David', 'Jones', 2);
INSERT INTO STAFF VALUES('EB1', 'Emily', 'Butler', 3);
INSERT INTO STAFF VALUES('EB2', 'Emily', 'Best', 5);
INSERT INTO STAFF VALUES('EH1', 'Ethan', 'Hopgood', 3);
INSERT INTO STAFF VALUES('HP1', 'Hannah', 'Penrice', 3);
INSERT INTO STAFF VALUES('IL1', 'Isabella', 'Lawson', 1);
INSERT INTO STAFF VALUES('IM1', 'Isabella', 'McConnell', 1);
INSERT INTO STAFF VALUES('JE1', 'Joseph', 'Elrick', 3);
INSERT INTO STAFF VALUES('JL1', 'Joshua', 'Lawson', 2);
INSERT INTO STAFF VALUES('JP1', 'James', 'Penrice', 3);
INSERT INTO STAFF VALUES('LB1', 'Logan', 'Butler', 4);
INSERT INTO STAFF VALUES('MB1', 'Michael', 'Best', 3);
INSERT INTO STAFF VALUES('ME1', 'Mia', 'Ellis', 3);
INSERT INTO STAFF VALUES('ME2', 'Mia', 'Edmond', 1);
INSERT INTO STAFF VALUES('MM1', 'Madison', 'McConnell', 3);
INSERT INTO STAFF VALUES('MW1', 'Michael', 'White', 3);
INSERT INTO STAFF VALUES('NL1', 'Natalie', 'Lodge', 3);
INSERT INTO STAFF VALUES('NS1', 'Noah', 'Smith', 1);

--LEVEL--
INSERT INTO LEVEL_ VALUES(1, 'null', 'Y', 'null');
INSERT INTO LEVEL_ VALUES(2, 'null', 'null', 'Y');
INSERT INTO LEVEL_ VALUES(3, 'null', 'Y', 'Y');
INSERT INTO LEVEL_ VALUES(4, 'Y', 'null', 'null');
INSERT INTO LEVEL_ VALUES(5, 'Y', 'Y', 'null');
INSERT INTO LEVEL_ VALUES(7, 'Y', 'Y', 'Y');

--SHIFT_TYPE--
INSERT INTO SHIFT_TYPE VALUES('Early', '08:00', '14:00');
INSERT INTO SHIFT_TYPE VALUES('Late', '14:00', '20:00');

--CUSTOMER--
INSERT INTO CUSTOMER VALUES(100, 'Haunt Services', 112, '53 Finger Gate', 'null', 'Dartford', 'DA48 5WU', '01001722832');
INSERT INTO CUSTOMER VALUES(101, 'Genus Ltd.', 33, '34 Pyorrhea Green', 'null', 'Guildford', 'GY34 4ZH', '01004256920');
INSERT INTO CUSTOMER VALUES(102, 'Corps Ltd.', 111, '67 Napery Green', 'null', 'Harrow', 'HA32 6PP', '01012384042');
INSERT INTO CUSTOMER VALUES(103, 'Train Services', 115, '30 Crizzel Parkway', 'null', 'Hemel Hempstead', 'HP38 6DU', '01012979358');
INSERT INTO CUSTOMER VALUES(104, 'Somebody Logistics', 127, '93 Calculated Oval', 'null', 'Hull', 'HX16 1IF', '01013707879');
INSERT INTO CUSTOMER VALUES(105, 'Immemorial Shipping', 103, '38 Bull Circle', 'null', 'Harrow', 'HA38 4QQ', '01018421989');
INSERT INTO CUSTOMER VALUES(106, 'Mock Group', 125, '85 Civic Green', 'null', 'Isle of Man', 'IV23 6XJ', '01022482900');
INSERT INTO CUSTOMER VALUES(107, 'Juan and Co.', 113, '68 Quicky Green', 'null', 'Reading', 'RG17 9KQ', '01030703414');
INSERT INTO CUSTOMER VALUES(108, 'Logis Shipping', 4, '47 Invader Gardens', 'null', 'Warrington', 'WA42 4XU', '01032611339');
INSERT INTO CUSTOMER VALUES(109, 'Packman Shipping', 142, '75 Speech Causeway', 'null', 'Belfast', 'AB20 7GW', '01038105677');
INSERT INTO CUSTOMER VALUES(110, 'Jesting Services', 104, '12 Faults Highlands', 'null', 'Lancaster', 'KY12 2LW', '01061248265');
INSERT INTO CUSTOMER VALUES(111, 'Medusa Shipping', 114, '71 Contradict Grade', 'null', 'Colchester', 'CO47 2TH', '01064625959');
INSERT INTO CUSTOMER VALUES(112, 'Cell Group', 45, '48 Donut Rise', 'null', 'Portsmouth', 'PO35 5DD', '01075188464');
INSERT INTO CUSTOMER VALUES(113, 'Tetraneuris Shipping', 86, '47 Judge Green', 'null', 'Derby', 'DE15 2FY', '01076912545');
INSERT INTO CUSTOMER VALUES(114, 'Hydrophobic Inc.', 47, '86 Old Avenue', 'null', 'Jersey', 'JE26 5IF', '01100989120');
INSERT INTO CUSTOMER VALUES(115, 'Whale Shipping', 17, '88 Demotic Row', 'null', 'Newport', 'NE41 6ZY', '01106754312');
INSERT INTO CUSTOMER VALUES(116, 'Corncob Shipping', 123, '97 Triumvir Grade', 'null', 'Liverpool', 'L07 5TQ', '01112575119');
INSERT INTO CUSTOMER VALUES(117, 'Confusion Services', 32, '93 Meristically Mount', 'null', 'Fylde Coast', 'FY04 2ZW', '01133455062');
INSERT INTO CUSTOMER VALUES(118, 'Parade and Co.', 148, '89 Quicky Way', 'null', 'Zetland', 'ZE12 6VN', '01152353680');
INSERT INTO CUSTOMER VALUES(119, 'Crepusculous Inc.', 57, '11 Away Drive', 'null', 'Exeter', 'EX34 5AZ', '01157516706');
INSERT INTO CUSTOMER VALUES(120, 'Variform Traders', 16, '100 Poetize Dell', 'null', 'Tonbridge', 'TN49 4YR', '01162621897');
INSERT INTO CUSTOMER VALUES(121, 'Sprightlier Logistics', 128, '16 Basso Hill', 'null', 'Blackburn', 'BB40 4PK', '01167376116');
INSERT INTO CUSTOMER VALUES(122, 'Snowless Traders', 60, '99 Ting Oval', 'null', 'Telford', 'TF47 5BS', '01174403286');
INSERT INTO CUSTOMER VALUES(123, 'Hamming Services', 34, '32 Fish Passage', 'null', 'Bolton', 'BB22 5CH', '01181877930');
INSERT INTO CUSTOMER VALUES(124, 'Pharyngeal Services', 105, '55 Away Circle', 'null', 'North London', 'NE19 2VM', '01184718264');
INSERT INTO CUSTOMER VALUES(125, 'Nightshade Group', 49, '67 Portrait Place', 'null', 'Bolton', 'BB48 2DE', '01184937755');
INSERT INTO CUSTOMER VALUES(126, 'Oxbridge Shipping', 97, '21 Intent Passage', 'null', 'Falkirk', 'FK06 9BA', '01187899790');
INSERT INTO CUSTOMER VALUES(127, 'Sylvite Group', 14, '73 Shift Avenue', 'null', 'Norwich', 'NR24 8RL', '01189708942');
INSERT INTO CUSTOMER VALUES(128, 'Pitiable Shipping', 35, '61 Pitiable Street', 'null', 'Lancaster', 'KY13 5CU', '01193980854');
INSERT INTO CUSTOMER VALUES(129, 'Jesting and Co.', 3, '48 Keynote Avenue', 'null', 'Dumfries and Galloway', 'DY06 2SS', '01201368693');
INSERT INTO CUSTOMER VALUES(130, 'Affright Retail', 55, '18 Redingote Dell', 'null', 'Tonbridge', 'TN46 7JF', '01208830667');
INSERT INTO CUSTOMER VALUES(131, 'Gimmick Inc.', 73, '85 Motherly Mount', 'null', 'Motherwell', 'ML24 5YV', '01211392468');
INSERT INTO CUSTOMER VALUES(132, 'Fawe Group', 12, '64 Oryx Manor', 'null', 'Llandudno', 'LS07 8HM', '01214251676');
INSERT INTO CUSTOMER VALUES(133, 'Bai Services', 31, '3 Wish Canyon', 'null', 'Motherwell', 'ML01 7GD', '01214717135');
INSERT INTO CUSTOMER VALUES(134, 'Cupulate Ltd.', 2, '46 Desert Dell', 'null', 'Llandudno', 'LS28 5BG', '01215101189');
INSERT INTO CUSTOMER VALUES(135, 'Dasher Services', 58, '62 Fatback Hill', 'null', 'Canterbury', 'BT28 8AE', '01215210671');
INSERT INTO CUSTOMER VALUES(136, 'Askew Shipping', 72, '71 Creature Grade', 'null', 'Croydon', 'CR28 9WA', '01221993420');
INSERT INTO CUSTOMER VALUES(137, 'Take Group', 15, '45 Prejudicial Square', 'null', 'Warrington', 'WA17 9RW', '01222475899');
INSERT INTO CUSTOMER VALUES(138, 'Miraculously Shipping', 96, '45 Winter Causeway', 'null', 'Canterbury', 'BT21 8JE', '01224961986');
INSERT INTO CUSTOMER VALUES(139, 'Stoker Traders', 129, '101 Peridiastole Pathway', 'null', 'Canterbury', 'BT30 1RQ', '01239424132');
INSERT INTO CUSTOMER VALUES(140, 'Lady Retail', 59, '4 Oryx Trail', 'null', 'Oldham', 'OL27 5AK', '01239513404');
INSERT INTO CUSTOMER VALUES(141, 'Guttata Shipping', 102, '80 Flop Road', 'null', 'Falkirk', 'FK33 9SM', '01248008671');
INSERT INTO CUSTOMER VALUES(142, 'Diaphonic Shipping', 10, '93 Rajab Vale', 'null', 'Shrewsbury', 'S03 8IT', '01250487837');
INSERT INTO CUSTOMER VALUES(143, 'Rajab Group', 13, '96 Prejudicial Garth', 'null', 'Norwich', 'NR11 5YY', '01251104649');
INSERT INTO CUSTOMER VALUES(144, 'Snowless Logistics', 51, '85 Shun Drive', 'null', 'Derby', 'DE19 3UT', '01291288810');
INSERT INTO CUSTOMER VALUES(145, 'Comfiture Traders', 85, '23 Talaria Hill', 'null', 'Telford', 'TF17 7CW', '01291585639');
INSERT INTO CUSTOMER VALUES(146, 'High and Co.', 46, '93 Choicely Circle', 'null', 'Llandrindod Wells', 'LD29 3DO', '01294771012');
INSERT INTO CUSTOMER VALUES(147, 'Shaped Logistics', 126, '34 Confusion Mews', 'null', 'Plymouth', 'PL14 1FY', '01297122202');
INSERT INTO CUSTOMER VALUES(148, 'Desert Inc.', 124, '85 Rajab Trail', 'null', 'Derby', 'DE46 7IX', '01297608632');
INSERT INTO CUSTOMER VALUES(149, 'Askew Inc.', 56, '37 Unmediated Parkway', 'null', 'Walsall', 'UB20 5SQ', '01299818072');

--CALLER--
INSERT INTO CALLER VALUES (1,111,'Ava','Clarke');
INSERT INTO CALLER VALUES (2,134,'Ava','Edwards');
INSERT INTO CALLER VALUES (3,129,'John','Green');
INSERT INTO CALLER VALUES (4,108,'Ryan','White');
INSERT INTO CALLER VALUES (5,114,'Noah','Evans');
INSERT INTO CALLER VALUES (6,130,'Adam','Green');
INSERT INTO CALLER VALUES (7,136,'Alex','Davis');
INSERT INTO CALLER VALUES (8,134,'Alfie','Lee');
INSERT INTO CALLER VALUES (9,120,'Evie','Patel');
INSERT INTO CALLER VALUES (10,142,'Alfie','Butler');
INSERT INTO CALLER VALUES (11,142,'David','Jackson');
INSERT INTO CALLER VALUES (12,132,'Conor','Lawson');
INSERT INTO CALLER VALUES (13,143,'Emily','Cooper');
INSERT INTO CALLER VALUES (14,127,'Ashley','Hill');
INSERT INTO CALLER VALUES (15,137,'David','Davies');
INSERT INTO CALLER VALUES (16,120,'Ryan','oConnor');
INSERT INTO CALLER VALUES (17,115,'Alexis','Best');
INSERT INTO CALLER VALUES (18,135,'Grace','Wright');
INSERT INTO CALLER VALUES (19,140,'Joshua','Wood');
INSERT INTO CALLER VALUES (20,100,'Noah','Anderson');
INSERT INTO CALLER VALUES (21,105,'Noah','Williams');
INSERT INTO CALLER VALUES (22,149,'Adam','Harrison');
INSERT INTO CALLER VALUES (23,116,'Alfie','Elrick');
INSERT INTO CALLER VALUES (24,135,'Alfie','Turner');
INSERT INTO CALLER VALUES (25,132,'Alyssa','King');
INSERT INTO CALLER VALUES (26,123,'Amelia','Best');
INSERT INTO CALLER VALUES (27,110,'Ashley','Best');
INSERT INTO CALLER VALUES (28,109,'Chloe','Harris');
INSERT INTO CALLER VALUES (29,128,'Chloe','Walker');
INSERT INTO CALLER VALUES (30,113,'Emily','Wright');
INSERT INTO CALLER VALUES (31,133,'Alexis','Gritten');
INSERT INTO CALLER VALUES (32,117,'Amelia','Roberts');
INSERT INTO CALLER VALUES (33,101,'Sophie','Johnson');
INSERT INTO CALLER VALUES (34,123,'Madison','Young');
INSERT INTO CALLER VALUES (35,128,'Ethan','McConnell');
INSERT INTO CALLER VALUES (36,148,'Hannah','Brandom');
INSERT INTO CALLER VALUES (37,123,'James','McConnell');
INSERT INTO CALLER VALUES (38,146,'Jessica','Young');
INSERT INTO CALLER VALUES (39,110,'Joshua','Brandom');
INSERT INTO CALLER VALUES (40,109,'Madison','Brown');
INSERT INTO CALLER VALUES (41,118,'Madison','Lodge');
INSERT INTO CALLER VALUES (42,100,'Amelia','Penrice');
INSERT INTO CALLER VALUES (43,114,'Anthony','Lodge');
INSERT INTO CALLER VALUES (44,140,'Ashley','Penrice');
INSERT INTO CALLER VALUES (45,112,'Nicholas','Wilson');
INSERT INTO CALLER VALUES (46,146,'Elizabeth','Hall');
INSERT INTO CALLER VALUES (47,114,'Alexander','Bell');
INSERT INTO CALLER VALUES (48,131,'Isabella','Elrick');
INSERT INTO CALLER VALUES (49,125,'Christopher','Martin');
INSERT INTO CALLER VALUES (50,108,'Ava','Best');

/*XPoblar*/
TRUNCATE TABLE ISSUE;
TRUNCATE TABLE CALLER;
TRUNCATE TABLE CUSTOMER;
TRUNCATE TABLE LEVEL_;
TRUNCATE TABLE SHIFT;
TRUNCATE TABLE SHIFT_TYPE;
TRUNCATE TABLE STAFF;

/*XTablas*/
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



