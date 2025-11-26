
%========================================
% Task A: Base Semantic Grammar
%========================================

% sentence(Sem)

sentence(Sem) --> noun_phrase(Subj), verb_phrase(Subj, Sem).     


% noun_phrase(Subj)
%   - Versión con determinante: "the cat", "a dog"

%noun_phrase(Subj) --> determiner, noun(Subj).


%   - Versión sin determinante: "fish"
%     (para poder analizar: [the, cat, eats, fish])

%noun_phrase(Subj) --> noun(Subj).


% verb_phrase(Subj, Sem)
%   - Subj: sujeto (por ejemplo cat, dog, ...)
%   - Sem:  significado completo que se construye.
%   - Estructura: verbo + sintagma nominal (objeto).

verb_phrase(Subj, Sem) -->
    verb(V),                    % reconoce el verbo y da V = eat / see
    noun_phrase(Obj),           % reconoce el objeto y da Obj = fish / bird / ...
    { Sem =.. [V, Subj, Obj] }. % construye Sem como V(Subj, Obj), y resulta por ejm: eat(cat, fish)


%----------------------------------------
% Léxico con semántica
%----------------------------------------

% determinantes
determiner --> [the].
determiner --> [a].

% sustantivos: dan su forma lógica (cat, dog, fish, bird)
noun(cat)  --> [cat].
noun(dog)  --> [dog].
noun(fish) --> [fish].
noun(bird) --> [bird].

% verbos: dan su forma lógica (eat, see)
verb(eat) --> [eats].
verb(see) --> [sees].

%----------------------------------------
% Examples:
%
% ?- phrase(sentence(S), [the, cat, eats, fish]).
%    S = eat(cat, fish).
%
% ?- phrase(sentence(S), [a, dog, sees, the, bird]).
%    S = see(dog, bird).
%----------------------------------------



%========================================
% Task B: Adjectives
%========================================

% noun_phrase(Subj)
%   - Ahora permitimos adjetivos antes del nombre.

% Con determinante: "the big cat", "a small dog"
noun_phrase(Subj) -->
    determiner,
    adjectives,     % cero o más adjetivos
    noun(Subj).

% Sin determinante: "big cat", "fish", "angry bird"
noun_phrase(Subj) -->
    adjectives,     % cero o más adjetivos
    noun(Subj).


% adjectives
%   - Cero adjetivos.
adjectives --> [].

%   - Uno o más adjetivos en secuencia.
adjectives --> adjective, adjectives.


% adjective
adjective --> [big].
adjective --> [small].
adjective --> [angry].

%----------------------------------------
% Examples:
%
% ?- phrase(sentence(S), [the, big, cat, eats, fish]).
%    S = eat(cat, fish).
%
% ?- phrase(sentence(S), [a, small, angry, dog, sees, the, bird]).
%    S = see(dog, bird).
%----------------------------------------
