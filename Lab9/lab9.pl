
%========================================
% 1. ESTRUCTURA GENERAL DE LA ORACION
%========================================

sentence --> noun_phrase, verb_phrase.

%========================================
% 2. FRASES (PHRASES)
%========================================

% 2.1 Frase nominal (noun_phrase)
% Determinante + (cero o más adjetivos) + sustantivo
noun_phrase --> determiner, adjectives, noun.

% 2.2 Frase verbal (verb_phrase)
% Verbo + otra frase nominal
verb_phrase --> verb, noun_phrase.

%========================================
% 3. LEXICO 
%========================================

%---------- Determinantes ----------

determiner --> [the] | [a] | [some].

%---------- Adjetivos ----------

adjective --> [big] | [small] | [angry] | [happy] | [hungry] | [tiny] | [fast] | [slow] | [green].        
           

% Lista de adjetivos (puede haber 0, 1 o más).

adjectives --> [] | adjective, adjectives.

%---------- Sustantivos ----------

noun --> [cat] | [dog] | [fish] | [bird] | [mouse] | [rabbit] | [cheese] | [meat] | [grass].    
      

%---------- Verbos ----------

verb --> [eats] | [sees] | [likes] | [chases].    

%========================================
% 4. DEMOSTRACIONES DE PARSING
%========================================

example1 :-
    phrase(sentence, [the, hungry, cat, eats, the, tiny, mouse]).

example2 :-
    phrase(sentence, [a, small, bird, sees, a, big, dog]).

example3 :-
    phrase(sentence, [some, happy, rabbits, like, the, green, grass]).

%========================================
% 5. DEMOSTRACIONES DE GENERATION
%========================================
% Generar oraciones que sean válidas según la gramática.

% generate_sentence(Words):
%   devuelve en Words una lista de palabras que forma una oración válida.

generate_sentence(Words) :-
    phrase(sentence, Words).
