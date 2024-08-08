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

% Definición de campeones con vida entre 1 y 100
campeon(Vida) :- 
    between(1, 100, Vida).

jinete(caballo).
jinete(camello).

piquero(Nivel, escudo) :- 
    member(Nivel, [1, 2, 3]).
piquero(Nivel, sinEscudo) :- 
    member(Nivel, [1, 2, 3]).

% Definición de los jugadores y sus unidades
% La sintaxis es: jugador(Nombre, [ListaDeUnidades])

jugador(ana, [jinete(caballo),piquero(1, escudo),piquero(2, sinEscudo)]).
jugador(beto, [campeon(100),campeon(80),piquero(1, escudo),jinete(camello)]).
jugador(carola, [piquero(3, sinEscudo),piquero(2, escudo)]).
jugador(dimitri, []).

%Punto 7:
vidaDeJinete(camello,80).
vidaDeJinete(caballo,90).

vidaDePiquero(Nivel, sinEscudo, Vida) :-
    Nivel = 1,
    Vida = 50.
vidaDePiquero(Nivel, sinEscudo, Vida) :-
    Nivel = 2,
    Vida = 65.
vidaDePiquero(Nivel, sinEscudo, Vida) :-
    Nivel = 3,
    Vida = 70.

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

maximaVidaDeUnidad(Jugador, MaxVida) :-
    jugador(Jugador, Unidades),
    findall(Vida, (member(Unidad, Unidades), vidaDeUnidad(Unidad, Vida)), Vidas),
    max_member(MaxVida, Vidas).

%Punto 8
% Definir las ventajas de tipo entre unidades
%ventaja(UnidadVentajosa,UnidadPerdida).
ventaja(jinete(_), campeon(_)).
ventaja(campeon(_), piquero(_, _)).
ventaja(piquero(_, _), jinete(_)).

% Los jinetes a camello le ganan a los jinetes a caballo
ventaja(jinete(camello), jinete(caballo)).

% Comparar vidas si no hay ventaja por tipo
compararVidaDeUnidades(Unidad1, Unidad2) :-
    vidaDeUnidad(Unidad1, Vida1),
    vidaDeUnidad(Unidad2, Vida2),
    Vida1 > Vida2.

%Saber si una unidad le gana a la otra
%En caso que se necesite para la inversibilidad.
%esUnidad(Unidad):- 
%member(Unidad, [campeon, piquero,jinete]).

leGana(Unidad1, Unidad2) :-
    ventaja(Unidad1, Unidad2).
    
leGana(Unidad1, Unidad2) :-
    not(ventaja(Unidad2, Unidad1)),
    compararVidaDeUnidades(Unidad1, Unidad2).
%Punto 9:

% Contar piqueros con y sin escudo para un jugador
contarPiqueroEscudo(Jugador, ConEscudo, SinEscudo) :-
    jugador(Jugador, Unidades),
    contarPiquero(Unidades, escudo, ConEscudo),
    contarPiquero(Unidades, sin_escudo, SinEscudo).

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

dependencia(molino, []).
dependencia(collera, [molino]).
dependencia(arado, [collera,molino]).

dependencia(herreria, []).
dependencia(emplumado,[herreria]).
dependencia(punzon,[emplumado,herreria]).

dependencia(laminas,[herreria]).
dependencia(malla,[laminas,herreria]).
dependencia(placas,[laminas,malla,herreria]).
