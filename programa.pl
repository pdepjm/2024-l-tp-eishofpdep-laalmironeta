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

% Segunda Entrega: Unidades

% Definición de los jugadores y sus unidades
% La sintaxis es: jugador(Nombre, [ListaDeUnidades])

jugador(ana, jinete(caballo)).
jugador(ana,piquero(1, escudo)).
jugador(ana,piquero(2, sinEscudo)).
jugador(beto, campeon(100)).
jugador(beto,campeon(80)).
jugador(beto,piquero(1, escudo)).
jugador(beto,jinete(camello)).

jugador(carola,piquero(3, sinEscudo)).
juegador(carola,piquero(2, escudo)).

%Punto 7:
vidaDeJinete(camello,80).
vidaDeJinete(caballo,90).

vidaDePiquero(1, sinEscudo, 50).
vidaDePiquero(2, sinEscudo, 65).
vidaDePiquero(3, sinEscudo, 70).

vidaDePiquero(Nivel,escudo,Vida):-
    vidaDePiquero(Nivel,sinEscudo,VidaSinEscudo),
    Vida is VidaSinEscudo *1.10.

% Calcular la vida de una unidad
vidaDeUnidad(campeon(Vida), Vida).

vidaDeUnidad(jinete(Tipo), Vida) :- 
    vidaDeJinete(Tipo, Vida).

vidaDeUnidad(piquero(Nivel, Tipo), Vida) :- 
    vidaDePiquero(Nivel, Tipo, Vida).

% Encontrar la vida máxima entre las unidades de un jugador

%% están pensando en funcional, o también procedural. Va con cuantificadores
maximaVidaDeUnidad(Jugador, Unidad) :-
    jugador(Jugador, Unidad),
    forall(jugador(Jugador,Unidad2),tieneMasVida(Unidad,Unidad2)).

%Punto 8
% Definir las ventajas de tipo entre unidades
%ventaja(UnidadVentajosa,UnidadPerdida).
ventaja(jinete(_), campeon(_)).
ventaja(campeon(_), piquero(_, _)).
ventaja(piquero(_, _), jinete(_)).

% Los jinetes a camello le ganan a los jinetes a caballo
ventaja(jinete(camello), jinete(caballo)).

% Comparar vidas si no hay ventaja por tipo
tieneMasVida(UnidadMayor, Unidad2) :-
    vidaDeUnidad(UnidadMayor, Vida1),
    vidaDeUnidad(Unidad2, Vida2),
    Vida1 >= Vida2.

%Saber si una unidad le gana a la otra

leGana(Unidad1, Unidad2) :-
    ventaja(Unidad1, Unidad2).
    
leGana(Unidad1, Unidad2) :-
    not(ventaja(Unidad2, Unidad1)),
    tieneMasVida(Unidad1, Unidad2).
%Punto 9:

% Contar piqueros con y sin escudo para un jugador
contarPiqueroEscudo(Jugador, ConEscudo, SinEscudo) :-
    jugador(Jugador, Unidades),
    contarPiquero(Unidades, escudo, ConEscudo),
    contarPiquero(Unidades, sinEscudo, SinEscudo).

% Contar piqueros de un tipo específico en una lista de unidades
contarPiquero(Unidades, Tipo, CantidadDeUnidades) :-
    findall(1, (member(piquero(_, Tipo), Unidades)), Lista),
    length(Lista, CantidadDeUnidades).

% Verificar si el jugador puede sobrevivir al asedio
puedeSupervivirAunAsido(Jugador) :-
    contarPiqueroEscudo(Jugador, ConEscudo, SinEscudo),
    ConEscudo > SinEscudo.

% Punto 10:
% Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas.
% Hasta no desarrollar una, no se puede desarrollar la siguiente. Modelar el siguiente árbol de ejemplo: 

% Definición de dependencias entre tecnologías
%dependencia(tecnologia,Depende)

dependencia(collera,molino).
dependencia(arado,collera).
dependencia(laminas,herreria).
dependencia(forja,herreria).
dependencia(emplumado,herreria).
dependencia(punzon,emplumado).
dependencia(fundicion,forja).
dependencia(malla,laminas).
dependencia(horno,fundicion).
dependencia(placas,malla).

sinPrecedencia(Tecnologia):-
    dependencia(_,Tecnologia),
    not(dependencia(Tecnologia,_)).

dependeDe(Dependiente,DependeDe):-
    dependencia(Dependiente,DependeDe).

dependeDe(Dependiente,DependeDe):-
    dependencia(DependeDirecto,DependeDe),
    dependeDe(Dependiente,DependeDirecto).

puedeDesarrollar(Jugador,Tecnologia):-
    jugador(Jugador,_),
    desarrollo(_,Tecnologia),
    not(desarrollo(Jugador,Tecnologia)),
    forall(dependeDe(Tecnologia,Depende),desarrollo(Jugador,Depende)).

puedeDesarrollar(Jugador,Tecnologia):-
    jugador(Jugador,_),
    sinPrecedencia(Tecnologia),
    not(desarrollo(Jugador,Tecnologia)).
