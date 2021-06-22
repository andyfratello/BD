-- Exercici 1

/*
Implementar mitjançant disparadors la restricció d'integritat següent:
No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__; (el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;
La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que l'atribut corresponent de l'esquema de la base de dades.

Pel joc de proves que trobareu al fitxer adjunt i la instrucció:
DELETE FROM empleats WHERE nempl=123;
La sortida ha de ser:

No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat
*/

-- Fitxer adjunt
-- SentËncies de preparaciÛ de la base de dades:
create table empleats(
                 nempl integer primary key,
                 salari integer);

create table missatgesExcepcions(
	num integer, 
	texte varchar(100));

insert into missatgesExcepcions values(1,'No es pot esborrar l''empleat 123 ni modificar el seu n˙mero d''empleat');

-- SentËncies d'esborrat de la base de dades:
drop table empleats;
drop table missatgesExcepcions;

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies d'inicialitzaciÛ:
insert into empleats values(1,1000);
insert into empleats values(2,2000);
insert into empleats values(123,3000);

-- Dades d'entrada o sentËncies d'execuciÛ:
delete from empleats where nempl=123;


-- Solució
CREATE FUNCTION disp() 
RETURNS trigger AS $$

DECLARE missatge varchar(100);
BEGIN
	IF tg_op= 'UPDATE' THEN
		if old.nempl = 123 THEN 
			SELECT texte INTO missatge 
			FROM missatgesExcepcions WHERE num=1;
			RAISE EXCEPTION '%', missatge;

		else RETURN NEW;
		end if;

	ELSIF tg_op = 'DELETE' THEN
		if old.nempl = 123 THEN
			select texte INTO missatge 
			FROM missatgesExcepcions WHERE num=1;
			RAISE EXCEPTION '%', missatge;

		else RETURN OLD;
		end if;
	END if;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger1
BEFORE delete or UPDATE OF nempl ON empleats
FOR EACH ROW
EXECUTE PROCEDURE disp()

------------------------------------------------------------------------------------------------

-- Exercici 2

/*
Implementar mitjançant disparadors la restricció d'integritat següent:
No es poden esborrar empleats el dijous
Tigueu en compte que:
- Les restriccions d'integritat definides a la BD (primary key, foreign key,...) es violen amb menys freqüència que la restricció comprovada per aquests disparadors.
- El dia de la setmana serà el que indiqui la única fila que hi ha d'haver sempre insertada a la taula "dia". Com podreu veure en el joc de proves que trobareu al fitxer adjunt, el dia de la setmana és el 'dijous'. Per fer altres proves podeu modificar la fila de la taula amb el nom d'un altre dia de la setmana. IMPORTANT: Tant en el programa com en la base de dades poseu el nom del dia de la setmana en MINÚSCULES.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__;(el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;
La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que l'atribut corresponent de l'esquema de la base de dades.

Pel joc de proves que trobareu al fitxer adjunt i la instrucció:
DELETE FROM empleats WHERE salari<=1000
la sortida ha de ser:

No es poden esborrar empleats el dijous
*/

-- Fitxer adjunt
CREATE TABLE empleats(
  nempl integer primary key,
  salari integer);

insert into empleats values(1,1000);

insert into empleats values(2,2000);

insert into empleats values(123,3000);

CREATE TABLE dia(
dia char(10));

insert into dia values('dijous');

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'No es poden esborrar empleats el dijous');

--Solució
CREATE FUNCTION disp1() 
RETURNS trigger AS $$

DECLARE missatge varchar(100);
BEGIN
	IF (SELECT dia FROM dia) = 'dijous' THEN
		SELECT texte INTO missatge 
		FROM missatgesExcepcions WHERE num=1;
		RAISE EXCEPTION '%', missatge;
         else return old;
         
	END if;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger1
BEFORE delete ON empleats
FOR EACH STATEMENT
EXECUTE PROCEDURE disp1()

------------------------------------------------------------------------------------------------

-- Exercici 3

/*
En aquest exercici es tracta de mantenir de manera automàtica, mitjançant triggers, l'atribut derivat import de la taula comandes.

En concret, l'import d'una comanda és igual a la suma dels resultats de multiplicar per cada línia de comanda, la quantitat del producte de la línia pel preu del producte .

Només heu de considerar les operacions de tipus INSERT sobre la taula línies de comandes.

Pel joc de proves que trobareu al fitxer adjunt, i la sentència: INSERT INTO liniesComandes VALUES (110, 'p111', 2);
La sentència s'executarà sense cap problema, i l'estat de la taula de comandes després de la seva execució ha de ser:

numcomanda		instantfeta		instantservida		numtelf		import
110		1091		1101		null		30
*/

--Fitxer adjunt
create table productes
(idProducte char(9),
nom char(20),
mida char(20),
preu integer check(preu>0),
primary key (idProducte),
unique (nom,mida));

create table domicilis
(numTelf char(9),
nomCarrer char(20),
numCarrer integer check(numCarrer>0),
pis char(2),
porta char(2),
primary key (numTelf));

create table comandes
(numComanda integer check(numComanda>0),
instantFeta integer not null check(instantFeta>0),
instantServida integer check(instantServida>0),
numTelf char(9),
import integer ,
primary key (numComanda),
foreign key (numTelf) references domicilis,
check (instantServida>instantFeta));
-- numTelf es el numero de telefon del domicili des don sha 
-- fet la comanda. Pot tenir valor nul en cas que la comanda 
-- sigui de les de recollir a la botiga. 

create table liniesComandes
(numComanda integer,
idProducte char(9),
quantitat integer check(quantitat>0),
primary key(numComanda,idProducte),
foreign key (idProducte) references productes,
foreign key (numComanda) references comandes
);
-- quantitat es el numero d'unitats del producte que sha demanat 
-- a la comanda

insert into productes values ('p111', '4 formatges', 'gran', 10);   

insert into productes values ('p222', 'margarita', 'gran', 5);  
 
insert into comandes(numComanda,instantfeta,instantservida,numtelf, import) values (110, 1091, 1101, null, 10);

insert into liniesComandes values (110, 'p222', 2);


--Solució
create or replace function func()
returns trigger as $$
declare PREU integer;
begin 
        select p.preu INTO PREU
        from productes p 
	where p.idproducte = new.idproducte;

	update comandes
	set import = import + new.quantitat * PREU
	where new.numcomanda = numcomanda;
return new;
end; 
$$LANGUAGE plpgsql;

create trigger insert_comanda
after insert on liniesComandes
for each row execute procedure func()
