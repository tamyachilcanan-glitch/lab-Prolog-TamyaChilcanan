%==============================================
%% PARTE A: Australia
%==============================================

:- use_module(library(clpfd)).

%% 1) Lista ordenada de regiones (wa, nt, sa, q, nsw, v, t)
regions_au([wa, nt, sa, q, nsw, v, t]).

%% 2) Aristas no dirigidas; se registra cada par una sola vez.
edges_au([
  wa-nt,
  wa-sa,
  nt-sa,
  nt-q,
  sa-q,
  sa-nsw,
  sa-v,
  q-nsw,
  nsw-v
  % t (Tasmania) no comparte frontera terrestre aquí.
]).

%% 3) Color names.
color_names([red, green, blue, yellow]).

/* =========================================================
   4) Modelo genérico de coloración de mapas
   map_color(+Vars, +Edges, +K)
   - Vars: lista de variables enteras (una por región)
   - Edges: lista de pares A-B (índices o posiciones ya resueltas)
   - K: número de colores disponibles (1..K)
   ========================================================= */
map_color(Vars, Edges, K) :-
    Vars ins 1..K,
    % Para cada arista A-B: color(A) #\= color(B)
    maplist(diff_edge(Vars), Edges),
    labeling([], Vars).


diff_edge(Vars, A-B) :-
    nth1(A, Vars, CA),
    nth1(B, Vars, CB),
    CA #\= CB.

/* =========================================================
   5) colorize_au(+K, -Vars)
   Une regiones, aristas, y corre map_color con K colores.
   Vars queda en el mismo orden que regions_au/1.
   ========================================================= */
colorize_au(K, Vars) :-
    regions_au(Regions),
    edges_au(Edges),
    % Convertimos edges a pares de índices (1..N)
    pairs_to_index_pairs(Regions, Edges, EdgesIdx),
    length(Regions, N),
    length(Vars, N),
    map_color(Vars, EdgesIdx, K).

% Convierte wa-nt a I-J según la posición en Regions
pairs_to_index_pairs(Regions, Edges, EdgesIdx) :-
    maplist(edge_atom_to_index(Regions), Edges, EdgesIdx).

edge_atom_to_index(Regions, A-B, I-J) :-
    nth1(I, Regions, A),
    nth1(J, Regions, B).

/* =========================================================
   6) Print
   ========================================================= */
pretty_color_by_region(Regions, Vars) :-
    color_names(Names),
    maplist(show_pair(Names), Regions, Vars).

show_pair(Names, Region, ColorIdx) :-
    nth1(ColorIdx, Names, ColorName),
    format('~w = ~w~n', [Region, ColorName]).


%% RUNING
%colorize_au(3,	Vars),	writeln(Vars).	
%colorize_au(3,	Vars),	regions_au(Rs),	pretty_color_by_region(Rs,	Vars).
%regions_au(Rs),	edges_au(Es),	map_color(Vs,	Es,	3),	labeling([ffc],	Vs), pretty_color_by_region(Rs,	Vs).	


%========================================
%% PARTE B: South America
%========================================


% 1) Lista de regiones
%    ar=Argentina, bo=Bolivia, br=Brasil, cl=Chile, co=Colombia,
%    ec=Ecuador, gy=Guyana, py=Paraguay, pe=Perú, sr=Surinam,
%    uy=Uruguay, ve=Venezuela, gf=Guayana Francesa

regions_sa([ar, bo, br, cl, co, ec, gy, py, pe, sr, uy, ve, gf]).

% 2) Aristas (adyacencias) NO dirigidas, cada par solo una vez
edges_sa([
   % Argentina
   ar-cl, ar-bo, ar-py, ar-br, ar-uy,
   % Bolivia
   bo-pe, bo-br, bo-py, bo-ar, bo-cl,
   % Brasil
   br-uy, br-ar, br-py, br-bo, br-pe, br-co, br-ve, br-gy, br-sr, br-gf,
   % Chile
   cl-pe, cl-bo, cl-ar,
   % Colombia
   co-ve, co-br, co-pe, co-ec,
   % Ecuador
   ec-co, ec-pe,
   % Guyana
   gy-ve, gy-br, gy-sr,
   % Paraguay
   py-bo, py-br, py-ar,
   % Perú
   pe-ec, pe-co, pe-br, pe-bo, pe-cl,
   % Surinam
   sr-gy, sr-br, sr-gf,
   % Uruguay
   uy-br, uy-ar,
   % Venezuela
   ve-co, ve-br, ve-gy,
   % Guayana Francesa
   gf-br, gf-sr
]).

% 3) Color names
color_names([red, green, blue, yellow]).

%----------------------------------------------------------
% 4) 
%    - Regions: lista de átomos de países (para ubicar índices)
%    - Vars:    lista de variables (una por país)
%    - Edges:   pares A-B (átomos)
%    - K:       cantidad de colores (1..K)
%    - LabOpts: opciones de labeling ([] , [ffc], [min], etc.)
%----------------------------------------------------------
map_color_basic(Regions, Vars, Edges, K, LabOpts) :-
    length(Regions, N),
    length(Vars, N),
    Vars ins 1..K,
    maplist(diff_constraint(Regions, Vars), Edges),
    labeling(LabOpts, Vars).

% Para cada arista A-B: colores distintos
diff_constraint(Regions, Vars, A-B) :-
    nth0(IdxA, Regions, A),
    nth0(IdxB, Regions, B),
    nth0(IdxA, Vars, CA),
    nth0(IdxB, Vars, CB),
    CA #\= CB.

%----------------------------------------------------------
% 5) Atajos para Sudamérica (K=3 y K=4) con distintas estrategias
%----------------------------------------------------------
colorize_sa(K, Vars) :-
    regions_sa(R), edges_sa(E),
    map_color_basic(R, Vars, E, K, []).        

colorize_sa_ffc(K, Vars) :-
    regions_sa(R), edges_sa(E),
    map_color_basic(R, Vars, E, K, [ffc]).      

colorize_sa_min(K, Vars) :-
    regions_sa(R), edges_sa(E),
    map_color_basic(R, Vars, E, K, [min]).      

%----------------------------------------------------------
% 6) Print
%----------------------------------------------------------
pretty_color_by_region([], []).
pretty_color_by_region([R|Rs], [C|Cs]) :-
    color_names(Names),
    nth1(C, Names, Name),
    format("~w = ~w~n", [R, Name]),
    pretty_color_by_region(Rs, Cs).


% PROBAMOS
% With k=3
%   ?- colorize_sa(3, Vars), regions_sa(R), pretty_color_by_region(R, Vars).

% Si falla, significa que no es factible con 3, pues normalmente Sudamérica necesita 4

% With k=4
%   ?- colorize_sa(4, Vars), regions_sa(R), pretty_color_by_region(R, Vars).

% Funciona con k=4 pues con k=3 resulta False.
