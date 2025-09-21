%---Family Tree Knowledge Base---
%---parent(A,B)----

parent(maria,   martha).
parent(maria,   luis).
parent(carlos,   martha).
parent(carlos,  luis).

parent(martha, anibal).
parent(martha, sofia).
parent(hector, anibal).
parent(hector, sofia).

parent(luis,   jose).
parent(luis,   alicia).
parent(paula,  jose).
parent(paula,  alicia).

parent(anibal, ana).
parent(laura,  ana).

%---Add rules---

% 2.1 abuelo/abuela: X es abuelo/a de Y si X es padre/madre de Z y Z es padre/madre de Y.

grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% 2.2 hermanos: X y Y son hermanos si comparten al menos un progenitor y no son la misma persona.

sibling(X, Y) :- parent(P, X), parent(P, Y), X \= Y.

% 2.3 ancestro: base + recursión (ancestor/2 (recursive) 
% Base: X es ancestro de Y si X es padre/madre de Y.

ancestor(X, Y) :- parent(X, Y).

% Recursiva: X es ancestro de Y si X es progenitor de Z y X es ancestro de Z, o si algún descendiente intermedio Z conecta X con Y.

ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

%---Food Preferences---

likes(martha, pizza).
likes(martha, pasta).
likes(hector, pizza).
likes(luis,   sushi).
likes(paula,  sushi).
likes(anibal, tacos).
likes(laura,  tacos).
likes(alicia, pizza).
likes(jose,  ramen).
likes(ana,   pasta).

% 3.1 food_friend(X,Y): X y Y son “amigos” si les gusta la misma comida y no son la misma persona.

food_friend(X, Y) :- likes(X, F), likes(Y, F), X \= Y.


% --- UTILIDADES MATEMÁTICAS ---

% 4.1 factorial(N, F): F = N!  (definición estándar)
factorial(0, 1).                                 % Base: 0! = 1
factorial(N, F) :-
    N > 0,                                       % Solo para N positivo
    N1 is N - 1,                                 % N1 = N - 1   
    factorial(N1, F1),                           % calcula (N-1)! (RECURSIVIDAD)
    F is N * F1.                                 % F = N * (N-1)!

% 4.2 sum_list(Lista, Suma): suma de los elementos de la lista
sum_list([], 0).                                  % Base: la suma de lista vacía es 0
sum_list([H|T], S) :-
    sum_list(T, ST),                              % ST = suma de la cola
    S is H + ST.                                  % S = cabeza + suma de la cola

% --- PROCESAMIENTO DE LISTAS ---

% 5.1 length_list(Lista, Longitud)
length_list([], 0).                               % Base: lista vacía mide 0
length_list([_|T], L) :-
    length_list(T, LT),                           % LT = longitud de la cola
    L is LT + 1.                                  % suma 1 por la cabeza ignorada con '_'

% 5.2 append_list(L1, L2, R): R es L1 concatenada con L2
append_list([], L, L).                            % Base: [] ++ L = L
append_list([H|T], L2, [H|R]) :-
    append_list(T, L2, R).                        % mueve cabeza de L1 a R, sigue con la cola


%---Queries to Run---
%---¿Quiénes son los ancestros de una persona?---
ancestor(maria, Quien).

%¿Quiénes son hermanos?
?- sibling(carlos, Quien).

%¿Quiénes son “food friends”?
?- food_friend(martha, Quien).
?- food_friend(Quien1, Quien2).

%Factorial de 6
?- factorial(6, F).
    % Resultado: F = 720.


%Suma de [2,4,6,8]
?- sum_list([2,4,6,8], S).
    % Resultado: S = 20.


%Longitud de [a,b,c,d]
?- length_list([a,b,c,d], L).
    % Resultado: L = 4.


% Concatenar [1,2] y [3,4]
?- append_list([1,2], [3,4], R).
    % Esperado: R = [1,2,3,4].

