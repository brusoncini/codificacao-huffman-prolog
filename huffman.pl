% ====================================
% CODIFICAÇÃO DE HUFFMAN EM PROLOG
% ====================================
% Nome: Bruna Soncini
% RA:   10428267
% ====================================


% 1. Lê o arquivo e retorna uma lista de caracteres
ler_arquivo(NomeArquivo, Caracteres) :-
    open(NomeArquivo, read, Stream),
    read_string(Stream, _, Texto),
    close(Stream),
    string_chars(Texto, Caracteres).

% a. Ignora espaços e quebras de linha ('\n') do arquivo 
filtrar([], []).
filtrar([], []).
filtrar([' '|Cs], R) :- filtrar(Cs, R).
filtrar(['\n'|Cs], R) :- filtrar(Cs, R).
filtrar([C|Cs], [C|R]) :- filtrar(Cs, R).

% 2. Cria uma tabela estatística com a quantidade de cada letra no texto
% a. Ordena o texto por merge sort:
merge_sort([], []).
merge_sort([A], [A]).
merge_sort(L, R) :- split(L, L1, L2), merge_sort(L1, R1), merge_sort(L2, R2), intercala(R1, R2, R).

intercala([], L, L).
intercala(L, [], L).
intercala([A|As], [B|Bs], [A|X]) :- A @=< B, intercala(As, [B|Bs], X).
intercala([A|As], [B|Bs], [B|X]) :- A @> B, intercala([A|As], Bs, X).

split([], [], []).
split([A], [A], []).
split([A,B|X], [A|As], [B|Bs]) :- split(X, As, Bs).

% b. Contar cada caractere da lista ordenada (RLE)
conta_frequencia([], []).
conta_frequencia([E|Es], R) :- conta_frequencia(Es, E, 1, R).
conta_frequencia([], E, N, [(E, N)]).
conta_frequencia([E|Es], E, N, R) :- N2 is N + 1, conta_frequencia(Es, E, N2, R).
conta_frequencia([A|As], E, N, [(E, N)|R]) :- conta_frequencia(As, A, 1, R).

% 3. Cria a árvore de Huffman

% 4. Cria a tabela dos códigos para cada símbolo 

% 5. Codifica o texto original

% 6. Gera o arquivo 'out'

% Função principal
:- initialization(iniciar).

iniciar :-
    ler_arquivo('in', Entrada),
    filtrar(Entrada, EntradaFiltrada),
    merge_sort(EntradaFiltrada, TextoOrdenado),

    write('Texto Ordenado: '),
    writeln(TextoOrdenado),

    conta_frequencia(TextoOrdenado, Frequencia),
    write('Contagem de caracteres: '),
    writeln(Frequencia).
