-- Exercici 1

/*
En aquest exercici es tracta definir els disparadors necessaris sobre empleats2 (veure definició de la base de dades al fitxer adjunt) per mantenir la restricció següent:
Els valors de l'atribut ciutat1 de la taula empleats1 han d'estar inclosos en els valors de ciutat2 de la taula empleats2
Per mantenir la restricció, la idea és que:

En lloc de treure un missatge d'error en cas que s'intenti executar una sentència sobre empleats2 que pugui violar la restricció,
cal executar operacions compensatories per assegurar el compliment de l'asserció. En concret aquestes operacions compensatories ÚNICAMENT podran ser operacions DELETE.

Pel joc de proves que trobareu al fitxer adjunt, i la sentència:
DELETE FROM empleats2 WHERE nemp2=1;
La sentència s'executarà sense cap problema,i l'estat de la base de dades just després ha de ser:

Taula empleats1
nemp1	nom1	ciutat1
1	joan	bcn
2	maria	mad

Taula empleats2
nemp2	nom2	ciutat2
2	pere	mad
3	enric	bcn
*/

--Fitxer adjunt
create table empleats1 (nemp1 integer primary key, nom1 char(25), ciutat1 char(10) not null);

create table empleats2 (nemp2 integer primary key, nom2 char(25), ciutat2 char(10) not null);

insert into empleats2 values(1,'joan','bcn');
insert into empleats2 values(2,'pere','mad');
insert into empleats2 values(3,'enric','bcn');
insert into empleats1 values(1,'joan','bcn');
insert into empleats1 values(2,'maria','mad');


--Solució 
Create or replace function disp() 
returns trigger as $$

BEGIN

	DELETE from empleats1
		   where ciutat1 = old.ciutat2 and not exists (select * 
	         				 					   	   from empleats2 
	         									   	   where ciutat2 = old.ciutat2);
	RETURN NULL;

END;
$$LANGUAGE plpgsql;

CREATE TRIGGER trigger1
AFTER DELETE OR UPDATE OF ciutat2 ON empleats2
FOR EACH ROW
EXECUTE PROCEDURE disp()

---------------------------------------------------------------

-- Exercici 2

/*
Disposem de la base de dades del fitxer adjunt que gestiona clubs esportius i socis d'aquests clubs.
Cal implementar un procediment emmagatzemat "assignar_individual(nomSoci,nomClub)".

El procediment ha de:
- Enregistrar l'assignació del soci nomSoci al club nomClub, inserint la fila corresponent a la taula Socisclubs.
- Si el club nomClub passa a tenir més de 5 socis, inserir el club a la taula Clubs_amb_mes_de_5_socis.
- El procediment no retorna cap resultat.

Les situacions d'error que cal identificar són les tipificades a la taula missatgesExcepcions.
Quan s'identifiqui una d'aquestes situacions cal generar una excepció:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 .. 5, depenent de l'error)
RAISE EXCEPTION '%',missatge; (missatge ha de ser una variable definida al vostre procediment)

Suposem el joc de proves que trobareu al fitxer adjunt i la sentència
select * from assignar_individual('anna','escacs');
La sentència s'executarà sense cap problema, i l'estat de la base de dades just després ha de ser:

Taula Socisclubs
anna	escacs
joanna	petanca
josefa	petanca
pere	petanca
Taula clubs_amb_mes_de_5_soci
sense cap fila
*/

--Fitxer adjunt
create table socis ( nsoci char(10) primary key, sexe char(1) not null);

create table clubs ( nclub char(10) primary key);

create table socisclubs (nsoci char(10) not null references socis, 
  nclub char(10) not null references clubs, 
  primary key(nsoci, nclub));

create table clubs_amb_mes_de_5_socis (nclub char(10) primary key references clubs);

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
	
insert into missatgesExcepcions values(1, 'Club amb mes de 10 socis');
insert into missatgesExcepcions values(2, 'Club amb mes homes que dones');
insert into missatgesExcepcions values(3, 'Soci ja assignat a aquest club');
insert into missatgesExcepcions values(4, 'O el soci o el club no existeixen');
insert into missatgesExcepcions values(5, 'Error intern');

insert into clubs values ('escacs');
insert into clubs values ('petanca');

insert into socis values ('anna','F');

insert into socis values ('joanna','F');
insert into socis values ('josefa','F');
insert into socis values ('pere','M');

insert into socisclubs values('joanna','petanca');
insert into socisclubs values('josefa','petanca');
insert into socisclubs values('pere','petanca');


--Solució 
create or replace function assignar_individual(nomSoci char(10),nomClub char(10))
returns void as $$
declare 
	missatge varchar(50);
	num_homes integer;
	num_dones integer;
begin
	insert into socisclubs values(nomSoci, nomClub);

	num_homes = (select count(*) 
	from socis s natural inner join socisclubs sc
	where s.sexe = 'M' and sc.nclub = nomClub);

	num_dones = (select count(*) 
	from socis s natural inner join socisclubs sc
	where s.sexe = 'F'  and sc.nclub = nomClub);

	if ((select count(*) from socisclubs s where s.nclub = nomClub) > 5 and not exists (select * from clubs_amb_mes_de_5_socis where nclub = nomClub)) then 
		insert into clubs_amb_mes_de_5_socis values(nomClub);
	end if;

	if ((select count(*) from socisclubs s where s.nclub = nomClub) > 10) then 
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
		RAISE EXCEPTION '%',missatge;
	end if;

	if (num_homes > num_dones) then 
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=2;
		RAISE EXCEPTION '%',missatge;
	end if;

exception 
	when raise_exception then 
		RAISE EXCEPTION '%',missatge;
	
	when unique_violation THEN
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=3;
		RAISE EXCEPTION '%',missatge;
	
	when foreign_key_violation THEN 
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=4;
		RAISE EXCEPTION '%',missatge;
	
	when not_null_violation THEN
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=4;
		RAISE EXCEPTION '%',missatge;
	when others THEN 
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=5;
		RAISE EXCEPTION '%',missatge;
end;
$$ LANGUAGE plpgsql;
