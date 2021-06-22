-- Exercici 1

/*
Donat un intèrval de DNIs, programar un procediment emmagatzemat "llistat_treb(dniIni,dniFi)" per obtenir la informació de cadascun dels treballadors amb un DNI d'aquest interval.

Per cada treballador de l'interval cal obtenir:
- Les seves dades personals: dni, nom, sou_base i plus

- En cas que el treballador tingui 5 o més lloguers actius, al llistat hi ha de sortir una fila per cadascun dels cotxes que té llogats.
- En qualsevol altre cas, al llistat hi ha de sortir una única fila amb les dades del treballador, i nul a la matrícula.

Tingueu en compte que:
- Es vol que retorneu els treballadors ordenats per dni i matricula de forma ascendent.
- El tipus de les dades que s'han de retornar han de ser els mateixos que hi ha a la taula on estan definits els atributs corresponents.

El procediment ha d'informar dels errors a través d'excepcions. Les situacions d'error que heu d'identificar són les tipificades a la taula missatgesExcepcions, que podeu trobar definida i amb els inserts corresponents al fitxer adjunt. En el vostre procediment heu d'incloure, on s'identifiquin aquestes situacions, les sentències:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 o 2, depenent de l'error)
RAISE EXCEPTION '%',missatge;
On la variable missatge ha de ser una variable definida al vostre procediment.

Pel joc de proves que trobareu al fitxer adjunt i la crida següent,
SELECT * FROM llistat_treb('11111111','33333333');
el resultat ha de ser:

DNI		Nom		Sou		Plus		Matricula
22222222		Joan		1700		150		1111111111
22222222		Joan		1700		150		2222222222
22222222		Joan		1700		150		3333333333
22222222		Joan		1700		150		4444444444
22222222		Joan		1700		150		5555555555
*/

--Fitxer adjunt
-- SentËncies d'esborrat de la base de dades:
drop table lloguers_actius;
drop table treballadors;
drop table cotxes;
drop table missatgesExcepcions;
drop function  llistat_treb(char(8), char(8));

-- SentËncies de preparaciÛ de la base de dades:
create table cotxes(
	matricula char(10) primary key,
	marca char(20) not null,
	model char(20) not null,
	categoria integer not null,
	color char(10),
	any_fab integer
	);
create table treballadors(
	dni char(8) primary key,
	nom char(30) not null,
	sou_base real not null,
	plus real not null
	);
create table lloguers_actius(
	matricula char(10) primary key    references cotxes,
	dni char(8) not null constraint fk_treb  references treballadors,
	num_dies integer not null,
	preu_total real not null
	);

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'No hi ha cap tupla dins del interval demanat');
insert into missatgesExcepcions values(2, 'Error intern');

--------------------------
-- Joc de proves Public
--------------------------

-- SentËncies de neteja de les taules:
delete from lloguers_actius;
delete from treballadors;
delete from cotxes;

-- SentËncies d'inicialitzaciÛ:
insert into cotxes values ('1111111111','Audi','A4',1,'Vermell',1998);
insert into cotxes values ('2222222222','Audi','A3',2,'Blanc',1998);
insert into cotxes values ('3333333333','Volskwagen','Golf',2,'Blau',1990);
insert into cotxes values ('4444444444','Toyota','Corola',3,'groc',1999);
insert into cotxes values ('5555555555','Honda','Civic',3,'Vermell',2000);
insert into cotxes values ('6666666666','BMW','Mini',2,'Vermell',2000);

insert into treballadors values ('22222222','Joan',1700,150);

insert into lloguers_actius values ('1111111111','22222222',7,750);
insert into lloguers_actius values ('2222222222','22222222',5,550);
insert into lloguers_actius values ('3333333333','22222222',4,450);
insert into lloguers_actius values ('4444444444','22222222',8,850);
insert into lloguers_actius values ('5555555555','22222222',2,250);


--Solució
create type worker as (
	dni char(8),
	nom varchar(30),
	sou_base real,
	plus real,
	matricula char(10)
	);
	
create function llistat_treb(dni_min char(8), dni_max char(8)) returns setof worker as $$
	declare
	w worker;
	missatge varchar(50);
	
	begin
		for w in select * from TREBALLADORS where (dni >=dni_min and dni <= dni_max) order by DNI asc 
		loop 
		if ((select count(*) from lloguers_actius where dni = w.dni) >= 5) then 
			for w.matricula in select matricula from lloguers_actius where w.dni = dni order by matricula asc 
		loop 
		return next w;
		end loop;
		else
			w.matricula := null;
			return next w;
		end if;
		end loop;
		
		if not found then
			select texte into missatge from missatgesExcepcions where num = 1;
			raise exception '%', missatge;
			
		end if;
		
		exception
			when raise_exception then
				raise exception '%', sqlerrm;
			when others then
				select texte into missatge from missatgesExcepcions where num =2;
				raise exception '%', missatge;
			return;	
end
$$LANGUAGE plpgsql;
