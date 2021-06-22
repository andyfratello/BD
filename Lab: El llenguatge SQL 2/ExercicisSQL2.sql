-- Exercici 1

/*
Doneu una sentència SQL per obtenir el número i el nom dels departaments que no tenen cap empleat que visqui a MADRID.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT		NOM_DPT
3		MARKETING
*/

--Fitxer adjunt
-- Sent�ncies de preparaci� de la base de dades:
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

-- Sent�ncies d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- Sent�ncies d'inicialitzaci�:
INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

-- Sent�ncies de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;


--Solució
select d.num_dpt, d.nom_dpt
from departaments d
where not exists (select *
                  from empleats e
                  where e.ciutat_empl = 'MADRID' and e.num_dpt = d.num_dpt)

--------------------------------------------------------------------------------------

-- Exercici 2

/*
Doneu una sentència SQL per obtenir les ciutats on hi viuen empleats però no hi ha cap departament.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

CIUTAT_EMPL
GIRONA
*/

--Fitxer adjunt
-- SentËncies de preparaciÛ de la base de dades:
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

-- SentËncies d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE projectes;
DROP TABLE departaments;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
INSERT INTO  DEPARTAMENTS VALUES (
5,'VENDES',3,'CASTELLANA','MADRID');

INSERT INTO  EMPLEATS VALUES (1,'MANEL',250000,'MADRID',5,null);

INSERT INTO  EMPLEATS VALUES (3,'JOAN',25000,'GIRONA',5,null);

-- SentËncies de neteja de les taules:
DELETE FROM empleats;
DELETE FROM Projectes;
DELETE FROM departaments;


--Solució
select distinct e.ciutat_empl
from empleats e
where not exists (select *
				  from departaments d
				  where e.ciutat_empl = d.ciutat_dpt)
          
--------------------------------------------------------------------------------------

-- Exercici 3

/*
Doneu una sentència SQL per obtenir el número i nom dels departaments que tenen dos o més empleats que viuen a ciutats diferents.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT		NOM_DPT
3		MARKETING
*/

--Fitxer adjunt
-- SentËncies de preparaciÛ de la base de dades:
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

-- SentËncies d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
INSERT INTO DEPARTAMENTS VALUES(3,'MARKETING',1,'EDIFICI1','SABADELL');

INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

INSERT INTO  EMPLEATS VALUES (5,'PERE',25000,'MATARO',3,null);

-- SentËncies de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;


--Solució
select d.num_dpt, d.nom_dpt
from departaments d natural join empleats e
group by d.num_dpt
having 2 <= count(distinct e.ciutat_empl)

--------------------------------------------------------------------------------------

-- Exercici 4

/*
Tenint en compte l'esquema de la BD que s'adjunta, proposeu una sentència de creació de les taules següents:
comandes(numComanda, instantComanda, client, encarregat, supervisor)
productesComprats(numComanda, producte, quantitat, preu)

La taula comandes conté les comandes fetes.
La taula productesComprats conté la informació dels productes comprats a les comandes de la taula comandes.

En la creació de les taules cal que tingueu en compte que:
- No hi poden haver dues comandes amb un mateix número de comanda.
- Un client no pot fer dues comandes en una mateix instant.
- L'encarregat és un empleat que ha d'existir necessariament a la base de dades, i que té sempre tota comanda.
- El supervisor és també un empleat de la base de dades i que s'assigna a algunes comandes en certes circumstàncies.
- No hi pot haver dues vegades un mateix producte en una mateixa comanda. Ja que en cas de el client compri més d'una unitat d'un producte en una mateixa comanda s'indica en l'atribut quantitat.
- Un producte sempre s'ha comprat en una comanda que ha d'existir necessariament a la base de dades.
- La quantitat de producte comprat en una comanda no pot ser nul, i té com a valor per defecte 1.
- Els atributs numComanda, instantComanda, quantitat i preu són de tipus integer.
- Els atributs client, producte són char(30), i char(20) respectivament.
- L'atribut instantComanda no pot tenir valors nuls.
Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui definir). Tots els noms s'han de posar en majúscues com surt a l'enunciat.
*/

--Fitxer adjunt
-- SentËncies de preparaciÛ de la base de dades:
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


--Solució
CREATE TABLE comandes
        (numComanda INTEGER,
        instantComanda INTEGER not null,
        client CHAR(30),
        encarregat INTEGER not null,
        supervisor INTEGER,
        unique (instantComanda, client),
    	PRIMARY KEY (numComanda),
    	FOREIGN KEY (encarregat) REFERENCES empleats(num_empl),
    	FOREIGN KEY (supervisor) REFERENCES empleats(num_empl));

CREATE TABLE productesComprats
	    (numComanda INTEGER,
	    producte CHAR(20),
	    quantitat INTEGER default 1 not null,
	    preu INTEGER,
	    PRIMARY KEY (numComanda,producte),
	    FOREIGN KEY (numComanda) REFERENCES comandes(numComanda));
      
