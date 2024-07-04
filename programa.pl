% Aquí va el código.

%jugador(Nombre,Civilizacion,Tecnologia) Punto 1

%%% hay que sdeparar cómo modelamos la info
juega(ana,romanos).
juega(beto,incas).
juega(carola,romanos).
juega(dimitri,romanos).

desarrollo(ana, herreria).
desarrollo(ana,forja).
desarrollo(ana,emplumado).
desarrollo(ana,laminas).
desarrollo(beto,herreria).
desarrollo(beto,forja).
desarrollo(beto,fundicion).
desarrollo(carola,herreria).
desarrollo(dimitri,herreria).
desarrollo(dimitri,fundicion).

tieneTecno(Civilizacion,Tecnologia):-
    juega(Jugador,Civilizacion),
    desarrollo(Jugador,Tecnologia).

%esExpertoEnMetales(Jugador) Punto 2

% repiten lógica
%esExpertoEnMetales(....):-
       


esExpertoEnMetales(Jugador):-
    desarrollo(Jugador,herreria),
    desarrollo(Jugador,forja),
    cumpleAlguna(Jugador).

cumpleAlguna(Jugador):-
    desarrollo(Jugador,fundicion).

cumpleAlguna(Jugador):-
    juega(Jugador,romanos).

%esCivilizacionPopular(Civilizacion) Punto 3
esCivilizacionPopular(Civilizacion):-
    juega(Jugador1,Civilizacion),
    juega(Jugador2,Civilizacion),
    Jugador1 \= Jugador2.

%tieneAlcanceGlobal(Tecnologia) Punto 4
tieneAlcanceGlobal(Tecnologia):-
    desarrollo(_,Tecnologia),
    forall(desarrollo(Jugador,_),desarrollo(Jugador,Tecnologia)).


%esCivilizacionLider(Civilizacion) Punto 5
esCivilizacionLider(Civilizacion):-
    juega(_,Civilizacion),
    forall(tieneTecno(_,Tecnologia),tieneTecno(Civilizacion,Tecnologia)).
