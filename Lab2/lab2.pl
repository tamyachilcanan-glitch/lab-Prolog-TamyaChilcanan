
%% EXERCISES y DELIVERABLES - TEMA: COMIDA


%% step 1: Hechos (>=10 comidas y sus propiedades)
food(apple).
food(banana).
food(orange).
food(carrot).
food(broccoli).
food(rice).
food(bread).
food(chicken).
food(salmon).
food(tofu).
food(cheese).
food(yogurt).
food(chili).

% propiedades
is_fruit(apple).
is_fruit(banana).
is_fruit(orange).

is_vegetable(carrot).
is_vegetable(broccoli).

is_grain(rice).
is_grain(bread).

is_protein(chicken).
is_protein(salmon).
is_protein(tofu).

is_dairy(cheese).
is_dairy(yogurt).

sweet(apple).
sweet(banana).
sweet(orange).
sweet(yogurt).

spicy(chili).

vegan(apple).
vegan(banana).
vegan(orange).
vegan(carrot).
vegan(broccoli).
vegan(rice).
vegan(bread).
vegan(tofu).
vegan(chili).

contains_gluten(bread).
from_sea(salmon).

eaten_raw(apple).
eaten_raw(banana).
eaten_raw(orange).
eaten_raw(carrot).
eaten_raw(broccoli).
eaten_raw(tofu).
eaten_raw(cheese).
eaten_raw(yogurt).
eaten_raw(chili).

must_be_cooked(chicken).
must_be_cooked(rice).
must_be_cooked(bread).
must_be_cooked(salmon).

%% step 2: Reglas de clasificación

    %% X es plant_based (basado en plantas) si X es vegano y no es lácteo.
is_plant_based(X) :- vegan(X), \+ is_dairy(X).   %% operador negacion (/+)

    %% X es de origen animal si es un lácteo, o si es pollo, o si es salmón.
is_animal_based(X) :- is_dairy(X) ; X = chicken ; X = salmon.

can_eat_raw(X) :- eaten_raw(X).
can_be_spicy(X) :- spicy(X).
is_sweet(X) :- sweet(X).

%% step 3: Rutina de preguntas (E/S simple)
ask(Question, Answer) :-
    write(Question), write(' (yes/no): '), nl,
    read(Answer).

%% step 4a: Procedimiento interactivo (identify_food/1)
identify_food(Food) :-
    ask('Is it sweet?', Sweet),
    ( Sweet == yes ->
        ask('Is it a fruit?', FruitQ),
        ( FruitQ == yes ->
            Food = apple
        ;
            Food = yogurt
        )
    ;
        ask('Is it spicy?', SpicyQ),
        ( SpicyQ == yes ->
            Food = chili
        ;
            ask('Is it dairy?', DairyQ),
            ( DairyQ == yes ->
                Food = cheese
            ;
                ask('Is it a grain product?', GrainQ),
                ( GrainQ == yes -> Food = bread ; Food = rice )
            )
        )
    ),
    write('I think the food is: '), write(Food), nl.

%% step 4b: Manejo de ambigüedad (possible_foods/1)
matches(Food) :-
    ask('Is it sweet?', Sweet),
    ( Sweet == yes  -> sweet(Food) ; true ),
    ask('Is it spicy?', Spicy),
    ( Spicy == yes  -> spicy(Food) ; true ),
    ask('Is it dairy?', Dairy),
    ( Dairy == yes  -> is_dairy(Food) ; true ),
    ask('Is it vegan?', Vegan),
    ( Vegan == yes  -> vegan(Food) ; true ),
    food(Food).

possible_foods(List) :-
    findall(A, matches(A), Raw),
    sort(Raw, List),
    write('Possible foods: '), write(List), nl.

%% step 5: "Ancestor" classification
ancestor(food, fruit).
ancestor(food, vegetable).
ancestor(food, grain).
ancestor(food, protein).
ancestor(food, dairy).

ancestor(protein, animal_protein).
ancestor(protein, plant_protein).

ancestor(animal_protein, chicken).
ancestor(animal_protein, salmon).
ancestor(plant_protein, tofu).

ancestor(fruit, apple).
ancestor(fruit, banana).
ancestor(fruit, orange).

ancestor(vegetable, carrot).
ancestor(vegetable, broccoli).

ancestor(grain, rice).
ancestor(grain, bread).

ancestor(dairy, cheese).
ancestor(dairy, yogurt).

is_ancestor(A, C) :- ancestor(A, C).
is_ancestor(A, C) :- ancestor(A, B), is_ancestor(B, C).

%% Ejemplos de consultas
% ?- is_fruit(apple).              % true
% ?- identify_food(X).             % flujo interactivo
% ?- possible_foods(L).            % devuelve lista de candidatos
% ?- is_ancestor(food, banana).    % true



%% Ejemplo de uso en la práctica:
%% ===============================

% ?- is_fruit(banana).
% true.

% ?- identify_food(F).
% Is it sweet? (yes/no):
% |: yes.
% Is it a fruit? (yes/no):
% |: yes.
% I think the food is: apple
% F = apple.

% ?- possible_foods(L).
% Is it sweet? (yes/no):
% |: no.
% Is it spicy? (yes/no):
% |: yes.
% Is it dairy? (yes/no):
% |: no.
% Is it vegan? (yes/no):
% |: yes.
% Possible foods: [chili]
% L = [chili].

% ?- is_ancestor(food, cheese).
% true.

% ?- is_ancestor(plant_protein, tofu).
% true.
