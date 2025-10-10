
%============================
% PARTE1: BASICS
%============================
edge(a,b).
edge(b,c).
edge(a,d).
edge(d,c).
edge(c,a).  % Añadido para la parte 2

%% CAMINO/ARISTA DIRECTO
path(X, Y) :- edge(X, Y). 

%% CAMINOS/ARISTAS INTERMEDIAS (recursivo)
path(X, Y) :- edge(X, Z), path(Z, Y).

%% ¿Existe una ruta de a a c? ¿De b a a?
% ?- path(a,c). True
% ?- path(b,a). False

%============================
%% PARTE 2: CYCLES
%============================

    %% Despues de añadir edge(c,a)
    % ?- path(a,c). Recuersion infinita

%% Esto se arregla marcando la lista visitada.

% Empezamos con X como visitado y en la lista
path_nodes(X, Y, Path) :-         % Path es la lista
    path_nodes(X, Y, [X], Path).

% Caso base: X->Y directo y Y no visitado.
path_nodes(X, Y, Visited, [X, Y]) :-
    edge(X, Y),
    \+ member(Y, Visited).

% Caso recursivo: X->Z, Z no visitado; seguimos desde Z y vamos construyendo la lista
path_nodes(X, Y, Visited, [X | Rest]) :-
    edge(X, Z),
    \+ member(Z, Visited),
    path_nodes(Z, Y, [Z | Visited], Rest).

%============================
%% PARTE 3
%============================
%% Use findall/3
    % ?- findall(P, path_nodes(a, c, P), Paths). 
    % Paths = [[a, b, c], [a, d, c]].
    
    
%============================
%% PARTE 4: LABERINTO
%============================

% ============================
% Definición de nodos (rooms): Cada "room" representa un lugar o punto del laberinto.

room(entry).
room(a).
room(b).
room(c).
room(d).
room(exit).
room(e).
room(f).
room(h).
room(g).

% ============================
% Definición de aristas/conexion directa (doors)
% Cada "door" representa una arista, es decir, un pasillo que conecta dos nodos

door(entry, a).
door(entry, e).
door(e,f). 
door(a, b).
door(b, c).
door(b,h).
door(c, exit).
door(a, d).
door(d, c).
door(d, g).

% Conexión no dirigida: Se puede pasar en ambos sentidos.
connected(X, Y) :- door(X, Y).
connected(X, Y) :- door(Y, X).

% Envoltorio: inicializa visitados con X
path(X, Y, Path) :-
    path(X, Y, [X], Path).

% Caso base: conexión directa X -> Y
path(X, Y, Visited, [X, Y]) :-
    connected(X, Y),
    \+ member(Y, Visited).

% Caso recursivo.
path(X, Y, Visited, [X | Rest]) :-
    connected(X, Z),
    \+ member(Z, Visited),
    path(Z, Y, [Z | Visited], Rest).


% Imprimir el camino (lista de nodos) de X a Y
print_path(X, Y) :-
    path(X, Y, P),
    writeln(P).

% Encontrar todos los caminos posibles de X a Y

all_paths(X, Y, Paths) :-
    findall(Path, path(X, Y, Path), Paths).


