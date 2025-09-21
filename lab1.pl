% ---Family Tree Knowledge Base---
% ---parent(A,B)----

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

% 3) ---Add rules---

% 3.1 abuelo/abuela: X es abuelo/a de Y si X es padre/madre de Z y Z es padre/madre de Y.

grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% 3.2 hermanos: X y Y son hermanos si comparten al menos un progenitor y no son la misma persona.

sibling(X, Y) :- parent(P, X), parent(P, Y), X \= Y.

% 3.4 ancestro: base + recursión (ancestor/2 (recursive) 
% Base: X es ancestro de Y si X es padre/madre de Y.

ancestor(X, Y) :- parent(X, Y).

% 3.5 Recursiva: X es ancestro de Y si X es progenitor de Z y X es ancestro de Z, o si algún descendiente intermedio Z conecta X con Y.

ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% 4) ---Food Preferences---

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

% 6) food_friend(X,Y): X y Y son “amigos” si les gusta la misma comida y no son la misma persona.

food_friend(X, Y) :- likes(X, F), likes(Y, F), X \= Y.


% 7) --- UTILIDADES MATEMÁTICAS ---

% 8) factorial(N, F): F = N!  (definición estándar)
factorial(0, 1).                                 % Base: 0! = 1
factorial(N, F) :-
    N > 0,                                       % Solo para N positivo
    N1 is N - 1,                                 % N1 = N - 1   
    factorial(N1, F1),                           % calcula (N-1)! (RECURSIVIDAD)
    F is N * F1.                                 % F = N * (N-1)!

% 9) sum_list(Lista, Suma): suma de los elementos de la lista
sum_list([], 0).                                  % Base: la suma de lista vacía es 0
sum_list([H|T], S) :-
    sum_list(T, ST),                              % ST = suma de la cola
    S is H + ST.                                  % S = cabeza + suma de la cola

% 10) --- PROCESAMIENTO DE LISTAS ---

% 11) length_list(Lista, Longitud)
length_list([], 0).                               % Base: lista vacía mide 0
length_list([_|T], L) :-
    length_list(T, LT),                           % LT = longitud de la cola
    L is LT + 1.                                  % suma 1 por la cabeza ignorada con '_'

% 12) append_list(L1, L2, R): R es L1 concatenada con L2
append_list([], L, L).                            % Base: [] ++ L = L
append_list([H|T], L2, [H|R]) :-
    append_list(T, L2, R).                        % mueve cabeza de L1 a R, sigue con la cola


% 13) ---Queries to Run---
% 14) ---¿Quiénes son los ancestros de una persona?---
ancestor(maria, Quien).

% 15) ¿Quiénes son hermanos?
?- sibling(carlos, Quien).

% 16) ¿Quiénes son “food friends”?
?- food_friend(martha, Quien).
?- food_friend(Quien1, Quien2).

% 17) Factorial de 6
?- factorial(6, F).
    % Resultado: F = 720.


% 18) Suma de [2,4,6,8]
?- sum_list([2,4,6,8], S).
    % Resultado: S = 20.


% 19) Longitud de [a,b,c,d]
?- length_list([a,b,c,d], L).
    % Resultado: L = 4.


% 20) Concatenar [1,2] y [3,4]
?- append_list([1,2], [3,4], R).
    % Esperado: R = [1,2,3,4].


