-- Exercici 1

/*
AQUEST EXERCICI NO ES CORREGIRÀ DE MANERA AUTOMÀTICA

PASSOS A SEGUIR
Apartat 1
Obriu Guia de Programació en JDBC. Repasseu la informació que se us ofereix en aquesta guia.
Executeu el programa Eclipse
Importeu el projecte Eclipse que podeu trobar al zip adjunt
Descarregueu el driver JDBC de la pàgina del curs a una carpeta de l'ordinador.
Copieu el driver de JDBC a la carpeta "libraries" del projecte Eclipse (es pot fer simplement arrossegant des d'una carpeta on el tingueu).
Repasseu el contingut de les carpetes i fitxers que es poden trobar dins del projecte Eclipse.
Prepareu la base de dades des de DBeaver Executeu les sentències SQL de creació de taules (fitxer crea.txt) i càrrega de files a les taules (fitxer carrega.txt).
Editeu codi del programa gestioProfes.java (carpeta "src")
Poseu el nom de la vostra base de dades (LaVostraBD)
Poseu l'esquema on estan les taules (ElVostreEsquema).
Poseu el vostre username de connexió a la base de dades (ElVostreUsername, ElVostrePassword).
Comproveu que el programa no té errors

Apartat 2
Execució 1
Abans d'executar el programa, des del DBeaver feu select * from Professors
Mireu el codi del programa gestioProfes per veure què fa sobre la taula Professors.
Compileu el programa.
Executeu el programa.
Des del DBeaver torneu a fer select * from Professors
Quin ha estat l'efecte de l'execució del programa sobre la taula Professors? Perquè?
Execució 2
Editeu el programa. Substituiu la sentència "rollback" per una sentència "commit".
Compileu el programa.
Executeu el programa.
Des del DBeaver feu torneu a fer select * from Professors
Quin ha estat l'efecte de l'execució del programa sobre la taula Professors? Perquè?
Execució 3
Executeu una altra vegada el programa.
Quina excepció es produeix?
Quin ha estat l'efecte de l'execució del programa sobre la taula Professors? Perquè?
Com podrieu fer (sense afegir accessos a la base de dades des del programa) que quan es dongui aquesta excepció en lloc del missatge obtingut surti "El professor ja existeix"?
Editeu el programa i afegiu la implementació d'aquesta excepció.
Execució 4
Esborreu la fila que el programa insereix, des del DBeaver.
Editeu el programa per tal d'implementar el bloc IMPLEMENTAR
En aquest bloc cal implemenar en jdbc:
Una consulta per obtenir el dni i el nom dels professors que tenen el telèfon amb un número inferior al número de la variable buscaTelf
En cas que no hi hagi cap professor que tingui el telèfon indicar "NO TROBAT"
Cal mostrar amb System.out.println el resultat de la consulta.
Executeu una altra vegada el programa
Indiqueu quin és el resultat del select.
Doneu el codi dela part del programa des del bloc IMPLEMENTAR fins al final.

Escriviu la resposta a les preguntes anteriors en el formulari del qüestionari i premeu "Envia".
*/

--Solució
Exec1: No hi ha cap canvi al fer l’execució ja que després d’afegir el professor amb nom “nina” es fa un rollback i, per tant, no s’acaba insertant.

Exec2: A l’executar la sentència al DBeaver veiem que s’afegeix el professor “nina” a la taula juntament amb tots els seus atributs corresponents. Això és degut a que ara s’executa un commit que confirma el nostre insert.

Exec3: L’excepció que es produeix és una unique_violation, ja que ens retorna el codi SQLSTATE 23505.
Sobre la taula professors no hi haurà cap canvi respecte abans ja que ens ha saltat l’error i això no tindrà cap efecte sobre la taula en sí. Salta l’error ja que estem intentant afegir una tupla amb una primary key repetida a la taula.
Per tal que ens surti el missatge “El professor ja existeix” caldrà afegir dins de catch (SQLException se) la següent sentència:
if (se.getSQLState().equals("23505")) System.out.println ("El professor ja existeix”);

Exec4: A l’executar el programa Java ens dóna com a resultat els dni i noms de tots aquells professors que tenen un número inferior a buscaTelf. Ens mostra el següent:
Canvi d'esquema realitzat correctament.

111                                                ruth                                              
222                                                ona                                               
333                                                anna 

El codi del bloc IMPLEMENTAR és:

String buscaTelf="3334";    
ResultSet r = s.executeQuery ("select dni,nomprof "+
    		   			         "from professors "+
    		   				 "where telefon < '"+buscaTelf+"';"); 
boolean found = false;
while (r.next()) {
    System.out.println(r.getString("dni") + " " + r.getString("nomprof"));
    found = true;
}
if (!found) System.out.println("NO TROBAT");
