% Aquí va el código.

%jugador(Nombre,Civilizacion,Tecnologia) Punto 1
jugador(ana,romanos,herreria).
jugador(ana,romanos,forja).
jugador(ana,romanos,emplumado).
jugador(ana,romanos,laminas).
jugador(beto,incas,herreria).
jugador(beto,incas,forja).
jugador(beto,incas,fundicion).
jugador(carola,romanos,herreria).
jugador(dimitri,romanos,herreria).
jugador(dimitri,romanos,fundicion).

nombre(Nombre):-
    jugador(Nombre,_,_).

civilizacion(Civilizacion):-
    jugador(_,Civilizacion,_).

tecnologia(Tecnologia):-
    jugador(_,_,Tecnologia).

%esExpertoEnMetales(Jugador) Punto 2
esExpertoEnMetales(Jugador):-
    jugador(Jugador,_,herreria),
    jugador(Jugador,_,forja),
    jugador(Jugador,_,fundicion).

esExpertoEnMetales(Jugador):-
    jugador(Jugador,_,herreria),
    jugador(Jugador,_,forja),
    jugador(Jugador,romanos,_).

%esCivilizacionPopular(Civilizacion) Punto 3
esCivilizacionPopular(Civilizacion):-
    jugador(Jugador1,Civilizacion,_),
    jugador(Jugador2,Civilizacion,_),
    Jugador1\=Jugador2.

%tieneAlcanceGlobal(Tecnologia) Punto 4
tieneAlcanceGlobal(Tecnologia):-
    tecnologia(Tecnologia),
    forall(jugador(Jugador,_,_),jugador(Jugador,_,Tecnologia)).


%esCivilizacionLider(Civilizacion) Punto 5
esCivilizacionLider(Civilizacion):-
    civilizacion(Civilizacion),
    forall(tecnologia(Tecnologia),jugador(_,Civilizacion,Tecnologia)).
