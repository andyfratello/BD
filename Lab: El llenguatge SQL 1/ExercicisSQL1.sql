-- Exercici 1

/*
Doneu una sentència SQL per obtenir els números i els noms dels departament situats a MADRID, que tenen empleats que guanyen més de 200000.
Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

NUM_DPT		NOM_DPT
5		VENDES
*/

-- Fitxer adjunt
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

INSERT INTO  DEPARTAMENTS VALUES (5,'VENDES',3,'MUNTANER','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'MANEL',250000,'MADRID',5,null);

-- Solució
SELECT DISTINCT d.num_dpt, d.nom_dpt
FROM empleats e NATURAL INNER JOIN departaments d
WHERE d.ciutat_dpt = 'MADRID' and e.sou > 200000

------------------------------------------------------------------------------------------------

-- Exercici 2

/*
Doneu una sentència SQL per obtenir el nom del departament on treballa i el nom del projecte on està assignat l'empleat número 2
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Nom_dpt		Nom_proj
MARKETING		IBDVID
*/

-- Fitxer adjunt
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER PRIMARY KEY,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20));

CREATE TABLE PROJECTES(
    NUM_PROJ INTEGER PRIMARY KEY,
    NOM_PROJ CHAR(10),
    PRODUCTE CHAR(20),
    PRESSUPOST INTEGER
);

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER PRIMARY KEY,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER REFERENCES DEPARTAMENTS,
	NUM_PROJ INTEGER REFERENCES PROJECTES);

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','BARCELONA');

INSERT INTO PROJECTES VALUEs (
2,'IBDVID','VIDEO',500000);

INSERT INTO  EMPLEATS VALUES (2,'ROBERTO',25000,'BARCELONA',3,2);

--Solució
SELECT d.nom_dpt, p.nom_proj
FROM departaments d NATURAL INNER JOIN projectes p NATURAL INNER JOIN empleats e
WHERE e.num_empl = 2

------------------------------------------------------------------------------------------------

-- Exercici 3

/*
Obtenir per cada departament situat a MADRID la mitjana dels sous dels seus empleats. Concretament, cal donar el número de departament, el nom de departament i la mitjana del sou.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

NUM_DPT		NOM_DPT		SOU
5		VENDES		250000
*/

--Fitxer adjunt
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

INSERT INTO  DEPARTAMENTS VALUES (5,'VENDES',3,'MUNTANER','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'MANEL',250000,'MADRID',5,null);

--Solució
SELECT d.num_dpt, d.nom_dpt, AVG(e.sou) as SOU
FROM departaments d NATURAL JOIN empleats e
WHERE d.ciutat_dpt = 'MADRID'
GROUP BY d.num_dpt;
