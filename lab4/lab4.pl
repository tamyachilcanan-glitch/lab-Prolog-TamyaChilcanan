
% ================================
% PARTE 1: Representación del laberinto
% ================================

% 1) Definición de nodos (rooms)
% Cada "room" representa un punto o lugar del laberinto.
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
room(r).

% 2) Definición de conexiones directas (doors)
% Cada "door" representa un pasillo entre dos nodos.
door(entry, a).
door(entry, e).
door(e, f).
door(a, b).
door(b, c).
door(c, exit).
door(b, h).
door(a, d).
door(d, c).
door(d, g).
door(d, r).

% 3) Conexión no dirigida: se puede pasar en ambos sentidos
connected(X, Y) :- door(X, Y).
connected(X, Y) :- door(Y, X).

% 4) Alias edge/2: usamos las mismas aristas del laberinto (lab3) antes presentado.
% Hacemos esto para seguir las instrucciones del Lab04.
edge(X, Y) :- door(X, Y).

% 5) Caminos bloqueados (blocked/2)
% Algunos pasillos están cerrados temporalmente.
blocked(a, b).
blocked(b, c).     
blocked(d, r).    


% ================================
% PARTE 2: Reglas de razonamiento
% ================================

% 1) can_move/2: se puede mover si existe la arista y NO está bloqueada
can_move(X, Y) :- edge(X, Y), \+ blocked(X, Y).

% 2) reason/3: explica por qué (o por qué no) se puede mover.

% Caso especial: ya estamos en la salida
reason(_, Y, 'Lograste salir!!') :-
    Y == exit.                        %% "_" ponemos guion bajo porque puede ser cualquiera.

% Hay arista y no está bloqueada
reason(X, Y, 'Movimiento permitido: arista/pasillo sin bloquear') :-
    edge(X, Y),
    \+ blocked(X, Y).   %% Ponemos poner directamente can_move(X, Y). Pero vamos a dejarlo asi para ver realmente que hace.

% Hay arista pero está bloqueada
reason(X, Y, 'Movimiento bloqueado: arista/pasillo bloqueada') :- edge(X, Y), blocked(X, Y).

% No existe arista directa
reason(X, Y, 'Sin movimiento: no existe una arista directa') :- 
    \+ edge(X, Y).


% ================================
% PARTE 3: Recorrido recursivo
% ================================

% move/4: move(Actual, Destino, Visitados, Camino)
% - Evita bucles con la lista Visitados y usa can_move/2


% 1) Paso final: si hay movimiento directo a Y, cerramos el camino
move(X, Y, Visited, [Y | Visited]) :-
    can_move(X, Y),
    format('Moviendose desde ~w hasta ~w.~n', [X, Y]).

% 2) Paso recursivo: exploramos un vecino Z no visitado y seguimos
move(X, Y, Visited, Path) :-
    can_move(X, Z),
    \+ member(Z, Visited),
    format('Explorando desde ~w hasta ~w...~n', [X, Z]),
    move(Z, Y, [Z | Visited], Path).


% ================================
% PARTE 4 — Main Predicate (Putting It All Together)
% ================================

find_path(X, Y, Path) :-
    move(X, Y, [X], RevPath),
    reverse(RevPath, Path).

% ================================
% PARTE 5 (OPCIONAL) — Extensión opcional
% Predicado why/2: explica la razón del movimiento entre dos nodos
% ================================

why(X, Y) :-
    reason(X, Y, R),
    format('Razonamiento entre ~w y ~w: ~w~n', [X, Y, R]).



