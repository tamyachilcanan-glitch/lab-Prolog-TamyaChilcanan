
%==========================
% SCHEDULER
%==========================


:- use_module(library(clpfd)).

% ----------------------------
% Tareas
% task(Name, Duration, Resource)
% ----------------------------
task(a, 2, 1).
task(b, 4, 1).
task(c, 3, 2).
task(d, 2, 3).
task(e, 5, 2).
task(f, 1, 1).
task(g, 4, 3).
task(h, 2, 2).

% --------------------------------------------------------
% schedule(+Tasks, -Starts, -Ends, -Makespan)
% --------------------------------------------------------
schedule(Tasks, Starts, Ends, Makespan) :-
    % 1. Lista de tareas que vamos a usar:
    Tasks = [task(a,2,1), task(b,4,1), task(c,3,2), task(d,2,3),
             task(e,5,2), task(f,1,1), task(g,4,3), task(h,2,2)],

    % 2. Variables de inicio (una por tarea)
    Starts = [Sa, Sb, Sc, Sd, Se, Sf, Sg, Sh],

    % 3. Variables de fin (una por tarea)
    Ends   = [Ea, Eb, Ec, Ed, Ee, Ef, Eg, Eh],

    % 4. Dominios: pueden empezar entre 0 y 20
    Sa in 0..10, Sb in 0..10, Sc in 0..10, Sd in 0..10,
    Se in 0..10, Sf in 0..10, Sg in 0..10, Sh in 0..10,

    % 5. Duraciones
    Ea #= Sa + 2,   % a dura 2
    Eb #= Sb + 4,   % b dura 4
    Ec #= Sc + 3,   % c dura 3
    Ed #= Sd + 2,   % d dura 2
    Ee #= Se + 5,   % e dura 5
    Ef #= Sf + 1,   % f dura 1
    Eg #= Sg + 4,   % g dura 4
    Eh #= Sh + 2,   % h dura 2

    % =====================================================
    % 6. Restricciones para que No se solapen porque usan el mismo recurso.
    % =====================================================

    % ----- Recurso 1: a, b, f
    (Ea #=< Sb) #\/ (Eb #=< Sa),
    (Ea #=< Sf) #\/ (Ef #=< Sa),
    (Eb #=< Sf) #\/ (Ef #=< Sb),

    % ----- Recurso 2: c, e, h
    (Ec #=< Se) #\/ (Ee #=< Sc),
    (Ec #=< Sh) #\/ (Eh #=< Sc),
    (Ee #=< Sh) #\/ (Eh #=< Se),

    % ----- Recurso 3: d, g
    (Ed #=< Sg) #\/ (Eg #=< Sd),

    % =====================================================
    % 7. Makespan = máximo de todos los tiempos de fin
    % =====================================================
    Makespan #= max( max(max(Ea, Eb), max(Ec, Ed)), max(max(Ee, Ef), max(Eg, Eh)) ),

    % =====================================================
    % 8. Buscar la solución que minimiza el makespan
    % =====================================================
    labeling([min(Makespan)],[Sa, Sb, Sc, Sd, Se, Sf, Sg, Sh, Makespan]),

    % =====================================================
    % 9. Print
    % =====================================================
    print_schedule3(Sa,Sb,Sc,Sd,Se,Sf,Sg,Sh,
                    Ea,Eb,Ec,Ed,Ee,Ef,Eg,Eh,
                    Makespan),
    !.

print_schedule3(Sa,Sb,Sc,Sd,Se,Sf,Sg,Sh,
                Ea,Eb,Ec,Ed,Ee,Ef,Eg,Eh,
                Makespan) :-
    nl,

    writeln('===== HORARIO DE TAREAS ====='),
    writeln(''),
    writeln('> Recurso 1:'),
    format('  - Tarea a: duracion 2 | inicio = ~w | fin = ~w~n', [Sa, Ea]),
    format('  - Tarea b: duracion 4 | inicio = ~w | fin = ~w~n', [Sb, Eb]),
    format('  - Tarea f: duracion 1 | inicio = ~w | fin = ~w~n', [Sf, Ef]),
    writeln(''),
    writeln('> Recurso 2:'),
    format('  - Tarea c: duracion 3 | inicio = ~w | fin = ~w~n', [Sc, Ec]),
    format('  - Tarea e: duracion 5 | inicio = ~w | fin = ~w~n', [Se, Ee]),
    format('  - Tarea h: duracion 2 | inicio = ~w | fin = ~w~n', [Sh, Eh]),
    writeln(''),
    writeln('> Recurso 3:'),
    format('  - Tarea d: duracion 2 | inicio = ~w | fin = ~w~n', [Sd, Ed]),
    format('  - Tarea g: duracion 4 | inicio = ~w | fin = ~w~n', [Sg, Eg]),
    writeln(''),
    format('Tiempo total (makespan): ~w~n', [Makespan]),
    nl.

%==============================
% Resultado en la terminal:
%==============================

% ?- schedule(Tasks, Starts, Ends, Makespan).

%===== HORARIO DE TAREAS =====

%> Recurso 1:
 % - Tarea a: duracion 2 | inicio = 0 | fin = 2
 % - Tarea b: duracion 4 | inicio = 2 | fin = 6
 % - Tarea f: duracion 1 | inicio = 6 | fin = 7

%> Recurso 2:
 % - Tarea c: duracion 3 | inicio = 0 | fin = 3
 % - Tarea e: duracion 5 | inicio = 3 | fin = 8
 % - Tarea h: duracion 2 | inicio = 8 | fin = 10

%> Recurso 3:
 % - Tarea d: duracion 2 | inicio = 0 | fin = 2
 %- Tarea g: duracion 4 | inicio = 2 | fin = 6

%Tiempo total (makespan): 10


    
