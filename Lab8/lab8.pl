%==============================================
%% MAP COLORING + OPTIMIZACIÓN (AUSTRALIA)
%==============================================

:- use_module(library(clpfd)).

%----------------------------------
% Colores disponibles
%----------------------------------
color_names([red, green, blue, yellow]).

%----------------------------------
% Regiones de Australia
%----------------------------------
regions_au([wa, nt, sa, q, nsw, v, t]).

%----------------------------------
% Aristas (adyacencias)
%----------------------------------
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
]).

%=====================================================
% CORE PREDICATE
%=====================================================

same_length(Regions, Vars) :-
    length(Regions, N),
    length(Vars, N).

diff_constraint(Regions, Vars, A-B) :-
    nth0(IdxA, Regions, A),
    nth0(IdxB, Regions, B),
    nth0(IdxA, Vars, CA),
    nth0(IdxB, Vars, CB),
    CA #\= CB.

apply_edges(Regions, Vars, Edges) :-
    maplist(diff_constraint(Regions, Vars), Edges).

color_map(Regions, Edges, K, Vars) :-
    same_length(Regions, Vars),
    Vars ins 1..K,
    apply_edges(Regions, Vars, Edges),
    labeling([], Vars).   % Para Task C cambia [] por [ffc] o [min]

%=====================================================
% ===== TASK A – min_colors/5 y helpers AU ===========
%=====================================================

% Task A.1 — min_colors/5
min_colors(Regions, Edges, MaxK, MinK, Vars) :-
    between(1, MaxK, K),
    color_map(Regions, Edges, K, Vars),
    MinK = K,
    !.

% Task A.2 — helper para Australia
min_colors_au(MaxK, MinK, Vars) :-
    regions_au(Rs),
    edges_au(Es),
    min_colors(Rs, Es, MaxK, MinK, Vars).

%=====================================================
% ===== TASK B – Pretty Printing =====================
%=====================================================

pretty_color_by_region([], []).
pretty_color_by_region([R|Rs], [C|Cs]) :-
    color_names(Names),
    nth1(C, Names, Name),
    format("~w = ~w~n", [R, Name]),
    pretty_color_by_region(Rs, Cs).

%=====================================================
% ===== TASK C  ============
%=====================================================

% Australia:
% ?- min_colors_au(4, MinK, Vars),
%    regions_au(Rs),
%    pretty_color_by_region(Rs, Vars).

% Experimentar con labeling:
% Cambiar en color_map: labeling([ffc], Vars).
% Cambiar en color_map: labeling([min], Vars).


%==============================================
%% MAP COLORING + OPTIMIZACIÓN (SUDAMÉRICA)
%==============================================

:- use_module(library(clpfd)).

%----------------------------------
% Colores disponibles
%----------------------------------
color_names([red, green, blue, yellow]).

%----------------------------------
% Regiones de Sudamérica
%----------------------------------
regions_sa([ar, bo, br, cl, co, ec, gy, py, pe, sr, uy, ve, gf]).

%----------------------------------
% Aristas (adyacencias)
%----------------------------------
edges_sa([
   ar-cl, ar-bo, ar-py, ar-br, ar-uy,
   bo-pe, bo-br, bo-py, bo-ar, bo-cl,
   br-uy, br-ar, br-py, br-bo, br-pe, br-co, br-ve, br-gy, br-sr, br-gf,
   cl-pe, cl-bo, cl-ar,
   co-ve, co-br, co-pe, co-ec,
   ec-co, ec-pe,
   gy-ve, gy-br, gy-sr,
   py-bo, py-br, py-ar,
   pe-ec, pe-co, pe-br, pe-bo, pe-cl,
   sr-gy, sr-br, sr-gf,
   uy-br, uy-ar,
   ve-co, ve-br, ve-gy,
   gf-br, gf-sr
]).

%=====================================================
% CORE PREDICATE
%=====================================================

same_length(Regions, Vars) :-
    length(Regions, N),
    length(Vars, N).

diff_constraint(Regions, Vars, A-B) :-
    nth0(IdxA, Regions, A),
    nth0(IdxB, Regions, B),
    nth0(IdxA, Vars, CA),
    nth0(IdxB, Vars, CB),
    CA #\= CB.

apply_edges(Regions, Vars, Edges) :-
    maplist(diff_constraint(Regions, Vars), Edges).

color_map(Regions, Edges, K, Vars) :-
    same_length(Regions, Vars),
    Vars ins 1..K,
    apply_edges(Regions, Vars, Edges),
    labeling([], Vars).  % Para Task C cambiar [] por [ffc] o [min]

%=====================================================
% ===== TASK A – min_colors/5 y helpers SA ===========
%=====================================================

% Task A.1 — min_colors/5
min_colors(Regions, Edges, MaxK, MinK, Vars) :-
    between(1, MaxK, K),
    color_map(Regions, Edges, K, Vars),
    MinK = K,
    !.

% Task A.2 — helper para Sudamérica
min_colors_sa(MaxK, MinK, Vars) :-
    regions_sa(Rs),
    edges_sa(Es),
    min_colors(Rs, Es, MaxK, MinK, Vars).

%=====================================================
% ===== TASK B – Pretty Printing =====================
%=====================================================

pretty_color_by_region([], []).
pretty_color_by_region([R|Rs], [C|Cs]) :-
    color_names(Names),
    nth1(C, Names, Name),
    format("~w = ~w~n", [R, Name]),
    pretty_color_by_region(Rs, Cs).

%=====================================================
% ===== TASK C ========
%=====================================================

% Sudamérica:
% ?- min_colors_sa(6, MinK, Vars),
%    regions_sa(Rs),
%    pretty_color_by_region(Rs, Vars).

% Experimentar con labeling:
% Cambiar: labeling([ffc], Vars).
% Cambiar: labeling([min], Vars).
