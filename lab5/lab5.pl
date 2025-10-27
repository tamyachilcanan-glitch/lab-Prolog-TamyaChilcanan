%% Solving Sudoku with Constraint Logic Programming (CLPFD) 

%%========================
%% PARTE 1 – Setup. Dejamos como comentario esta parte pues en la PARTE 2 volvemos a esribirlo.
%%========================

:- use_module(library(clpfd)).

%% Add the sudoku/1 predicate and the blocks definitions.	

% sudoku(Rows) :-
%    append(Rows, Vars),
%    Vars ins 1..9,
%    maplist(all_different, Rows),
%    transpose(Rows, Columns),
%    maplist(all_different, Columns),
%    blocks(Rows),
%    maplist(label, Rows).

% blocks([]).
% blocks([A,B,C|Rest]) :-
%    blocks3(A,B,C),
%    blocks(Rest).

% blocks3([], [], []).
% blocks3([A1,A2,A3|R1],
%       [B1,B2,B3|R2],
%        [C1,C2,C3|R3]) :-
%    all_different([A1,A2,A3,B1,B2,B3,C1,C2,C3]),
%    blocks3(R1,R2,R3).


%% Test the module loading with:
        % ?- use_module(library(clpfd)).
        %  True



%%================================
%% PARTE 2 – Implement the Solver
%%================================

% Definimos las restricciones de dominio (Vars ins 1..9).
sudoku(Rows) :-   % Ese es el predicado principal
append(Rows, Vars),  % Restricciones
Vars ins 1..9,

% Agregamos la restricción all_different/1 a las filas y a las columnas.
    % Para filas.
maplist(all_different, Rows),

    % Para las columnas.
transpose(Rows, Columns),
maplist(all_different, Columns),

 % Aplicamos la restricción a cada subcuadro 3x3.
blocks(Rows),

% Forzamos a Prolog a asignar valores concretos.
maplist(label, Rows).

% Implementamos blocks/1 y blocks3/3 para manejar los subcuadros 3x3.
% Recorremos el tablero en grupos de 3 filas.
blocks([]).
blocks([A,B,C|Rest]) :-
    blocks3(A,B,C),
    blocks(Rest).

% Recorremos cada bloque 3x3 dentro de esas 3 filas.
blocks3([], [], []).
blocks3([A1,A2,A3|R1],
        [B1,B2,B3|R2],
        [C1,C2,C3|R3]) :-
    % Restringimos que las 9 celdas del bloque 3x3 sean distintas.
    all_different([A1,A2,A3,B1,B2,B3,C1,C2,C3]),
    blocks3(R1, R2, R3).


%%  Probamos el programa con un Sudoku parcial:
%%    ?- Puzzle = [
%%           [5,3,_,_,7,_,_,_,_],
%%           [6,_,_,1,9,5,_,_,_],
%%           [_,9,8,_,_,_,_,6,_],
%%           [8,_,_,_,6,_,_,_,3],
%%           [4,_,_,8,_,3,_,_,1],
%%           [7,_,_,_,2,_,_,_,6],
%%           [_,6,_,_,_,_,2,8,_],
%%           [_,_,_,4,1,9,_,_,5],
%%           [_,_,_,_,8,_,_,7,9]
%%       ],
%%       sudoku(Puzzle),
%%       maplist(writeln, Puzzle).



%%========================
%% PARTE 3 – Test and Extend
%%========================

% 1. Probar el programa con diferentes sudokus.

puzzle1([
    [5,3,_,_,7,_,_,_,_],
    [6,_,_,1,9,5,_,_,_],
    [_,9,8,_,_,_,_,6,_],
    [8,_,_,_,6,_,_,_,3],
    [4,_,_,8,_,3,_,_,1],
    [7,_,_,_,2,_,_,_,6],
    [_,6,_,_,_,_,2,8,_],
    [_,_,_,4,1,9,_,_,5],
    [_,_,_,_,8,_,_,7,9]
]).

puzzle2([
    [_,2,_,6,_,8,_,_,_],
    [5,8,_,_,_,9,7,_,_],
    [_,_,_,_,4,_,_,_,_],
    [3,7,_,_,_,_,5,_,_],
    [6,_,_,_,_,_,_,_,4],
    [_,_,8,_,_,_,_,1,3],
    [_,_,_,_,2,_,_,_,_],
    [_,_,9,8,_,_,_,3,6],
    [_,_,_,3,_,6,_,9,_]
]).

% Mostrar el Sudoku resuelto 
% maplist/2 imprimirá cada fila ya resuelta.

test_sudoku(Puzzle) :-
    sudoku(Puzzle),
    maplist(writeln, Puzzle).

% Imprimir el Sudoku fila por fila en formato más limpio.
print_row([]).
print_row([A,B,C,D,E,F,G,H,I]) :-
    write(A), write(' '),
    write(B), write(' '),
    write(C), write(' | '),
    write(D), write(' '),
    write(E), write(' '),
    write(F), write(' | '),
    write(G), write(' '),
    write(H), write(' '),
    write(I), nl.

print_grid([R1,R2,R3,R4,R5,R6,R7,R8,R9]) :-
    print_row(R1),
    print_row(R2),
    print_row(R3),
    writeln('------+-------+------'),
    print_row(R4),
    print_row(R5),
    print_row(R6),
    writeln('------+-------+------'),
    print_row(R7),
    print_row(R8),
    print_row(R9).


% 3. Ejemplos de ejecución:
% ?- puzzle1(P), test_sudoku(P).
% ?- puzzle2(P), test_sudoku(P).



%% Optional: Add validation for uniqueness.
%% unique_solution/1 intenta forzar que solo exista una solución distinta.

unique_solution(Puzzle) :-
    sudoku(Puzzle),
    \+ ( another_solution(Puzzle) ).

another_solution(Puzzle) :-
    sudoku(Puzzle),
    fail.
