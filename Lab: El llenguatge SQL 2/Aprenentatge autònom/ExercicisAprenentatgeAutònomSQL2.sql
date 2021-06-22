-- Exercici 1

/*
Doneu una sentència SQL per obtenir els números i els noms dels projectes que tenen assignats dos o més empleats.
Cal ordenar el resultat descendement per número de projecte.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_PROJ		NOM_PROJ
1		IBDTEL
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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',2,'PAU CLARIS','BARCELONA');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,1);

INSERT INTO  EMPLEATS VALUES (5,'PERE',25000,'MATARO',3,1);

--Solució
select p.num_proj, p.nom_proj
from projectes p natural inner join empleats e
group by p.num_proj 
having 2 <= count(e.num_empl) 
order by p.num_proj desc

--------------------------------------------------------------------------------

-- Exercici 2

/*
Doneu una sentència SQL per obtenir el nom dels empleats que guanyen el sou més alt. Cal ordenar el resultat descendenment per nom de l'empleat.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NOM_EMPL
JOAN
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



INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',2,'PAU CLARIS','BARCELONA');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,null);
INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

--Solució
select distinct nom_empl
from empleats
where sou >= (select max(sou) from empleats)
order by nom_empl desc

--------------------------------------------------------------------------------

-- Exercici 3

/*
Doneu una sentència SQL per incrementar en 500000 el pressupost dels projectes que tenen algun empleat que treballa a BARCELONA.
Pel joc de proves que trobareu al fitxer adjunt, el pressupost del projecte que hi ha d'haver després de l'execució de la sentència és 1100000
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
	
INSERT INTO  PROJECTES VALUES (3,'PR1123','TELEVISIO',600000);

INSERT INTO  DEPARTAMENTS VALUES (4,'MARKETING',3,'RIOS ROSAS','BARCELONA');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MATARO',4,3);

--Solució
update projectes
set pressupost = pressupost + 500000
where exists (select * 
		      from departaments d natural inner join empleats e
	              where e.num_proj = projectes.num_proj and d.ciutat_dpt = 'BARCELONA')
                
