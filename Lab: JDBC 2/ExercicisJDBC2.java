// Exercici 1

/*
AQUEST EXERCICI NO ES CORREGIRÀ DE MANERA AUTOMÀTICA

PASSOS A SEGUIR
Importeu el projecte Eclipse que podeu trobar al zip adjunt
Prepareu el projecte per a ser executat (driver, dades de connexió dins del programa,...)
Prepareu la base de dades des de DBeaver (fitxers crea.txt, carrega.txt).

Apartat 1
Editeu el programa gestioProfes per tal d'implementar el bloc IMPLEMENTAR CONSULTA
En aquest bloc cal implemenar en jdbc:
Una consulta per obtenir el dni i el nom dels professors que tenen els telèfons que hi ha al array telfsProf.
En cas que hi hagi un telèfon que no sigui de cap professor caldrà que surti el número de telèfon i el text "NO TROBAT"
Cal mostrar amb System.out.println el resultat de la consulta.
Executeu el programa
Indiqueu quin és el resultat del select.

Apartat 2
Editeu el programa gestioProfes per tal d'implementar el bloc IMPLEMENTAR CANVI BD
En aquest bloc cal implemenar en jdbc:
Per cada despatx del mòdul 'omega' que no té cap assignació amb instant fi null, incrementar la superfície del despatx en 3 metres quadrats.
Cal mostrar amb System.out.println la quantitat de files modificades.
En cas que la superfície d'algun dels despatxos passi a ser més gran o igual a 25, cal mostrar un missatge "Algun despatx passaria a tenir superfície superior o igual a 25".
Indiqueu quina/es sentències SQL us ha/n fet falta per implementar el canvi, quin és el resultat de l'execució del programa, i com ho heu fet per identificar si es produeix l'excepció.

Escriviu la resposta a les preguntes anteriors, i el codi del programa que heu editat per a la implementació dels apartats 1 i 2, en el formulari del qüestionari i premeu "Envia".
*/

// Solució
//Apartat 1:

String[] telfsProf = {"3111", "3222", "3333", "4444"};
PreparedStatement ps = c.prepareStatement("select dni,nomprof "+
					 				 "from professors "+
					 			         "where telefon = ? ;");
ResultSet r = null;
for (int i = 0; i < telfsProf.length; ++i) {
	String buscaTelf=telfsProf[i];    
	ps.setString(1, buscaTelf);
	r = ps.executeQuery();       
	if (r.next()) {
    		System.out.println(r.getString("dni") + " " + r.getString("nomprof"));
	} else System.out.println("NO TROBAT");
}; 

Resultat select:
Canvi d'esquema realitzat correctament.

111                                                ruth
222                                                ona
333                                                anna
NO TROBAT
Commit i desconnexio realitzats correctament.



//Apartat 2:

Statement st = c.createStatement();
int filesModificades = st.executeUpdate("update despatxos d "+
		   				                "set superficie = superficie + 3 "+
    		   				                "where not exists(select * from assignacions a where a.instantfi is null and a.modul = d.modul)");
System.out.println(filesModificades);

Dins de catch (SQLException se) hem afegit el següent:
if (se.getSQLState().equals("23514")) {
	System.out.println ("Algun despatx passaria a tenir superfície superior o igual a 25");
}

Resultat execució del programa:
El getSQLState es: 23514

El getMessage es: ERROR: new row for relation "despatxos" violates check constraint "despatxos_superficie_check"
  Detail: Failing row contains (c6   , 109  , 26).
Algun despatx passaria a tenir superfície superior o igual a 25
