/* ====================================
   CODIFICAÇÃO DE HUFFMAN EM PROLOG
   ====================================
   Nome: Bruna Soncini
   RA:   10428267
   ====================================
 */


/* 1. Lê o arquivo e retorna uma lista de caracteres */
ler_arquivo(NomeArquivo, Caracteres) :-
    open(NomeArquivo, read, Stream),
    read_string(Stream, _, Texto),
    close(Stream),
    string_chars(Texto, Caracteres).

/* a. Ignora espaços e quebras de linha ('\n') do arquivo */ 
filtrar([], []).
filtrar([' '|Cs], R) :- filtrar(Cs, R).
filtrar(['\n'|Cs], R) :- filtrar(Cs, R).
filtrar([C|Cs], [C|R]) :- filtrar(Cs, R).

/* 2. Cria uma tabela estatística com a quantidade de cada letra no texto
    a. Ordena o texto por merge sort: */
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

/* b. Contar cada caractere da lista ordenada (RLE) */
conta_frequencia([], []).
conta_frequencia([E|Es], R) :- conta_frequencia(Es, E, 1, R).
conta_frequencia([], E, N, [(E, N)]).
conta_frequencia([E|Es], E, N, R) :- N2 is N + 1, conta_frequencia(Es, E, N2, R).
conta_frequencia([A|As], E, N, [(E, N)|R]) :- conta_frequencia(As, A, 1, R).

/* 3. Cria a árvore de Huffman 
    a. Transforma a tabela de frequência em uma lista de folhas */
cria_folhas([], []).
cria_folhas([(Caractere, Frequencia)|Resto], [folha(Caractere, Frequencia)|Folhas]) :-
    cria_folhas(Resto, Folhas).

pega_frequencia(folha(_, Frequencia), Frequencia).
pega_frequencia(no(Frequencia, _, _), Frequencia).

junta_nos(No1, No2, no(FrequenciaTotal, No1, No2)) :-
    pega_frequencia(No1, F1),
    pega_frequencia(No2, F2),
    FrequenciaTotal is F1 + F2.

insere_ordenado(No, [], [No]).
insere_ordenado(No, [Atual|Resto], [No, Atual|Resto]) :-
    pega_frequencia(No, FNo),
    pega_frequencia(Atual, FAtual),
    FNo =< FAtual.

insere_ordenado(No, [Atual|Resto], [Atual|ListaFinal]) :-
    pega_frequencia(No, FNo),
    pega_frequencia(Atual, FAtual),
    FNo > FAtual,
    insere_ordenado(No, Resto, ListaFinal).

ordena_nos([], []).
ordena_nos([No|Resto], ListaOrdenada) :-
    ordena_nos(Resto, RestoOrdenado),
    insere_ordenado(No, RestoOrdenado, ListaOrdenada).

/* b. Cria a árvore juntando os dois menores nós até sobrar apenas um */
cria_arvore([Arvore], Arvore).
cria_arvore([No1, No2|Resto], ArvoreFinal) :-
    junta_nos(No1, No2, NovoNo),
    insere_ordenado(NovoNo, Resto, NovaLista),
    cria_arvore(NovaLista, ArvoreFinal).

/* c. Função auxiliar que recebe a tabela de frequências e devolve a árvore */
monta_arvore_huffman(Frequencias, Arvore) :-
    cria_folhas(Frequencias, Folhas),
    ordena_nos(Folhas, FolhasOrdenadas),
    cria_arvore(FolhasOrdenadas, Arvore).

% d. Imprime a árvore de Huffman de forma mais legível
imprime_arvore(folha(Caractere, Frequencia), Espacos) :-
    imprime_espacos(Espacos),
    write('Folha: '),
    write(Caractere),
    write(' (freq: '),
    write(Frequencia),
    writeln(')').

imprime_arvore(no(Frequencia, Esquerda, Direita), Espacos) :-
    imprime_espacos(Espacos),
    write('No (freq: '),
    write(Frequencia),
    writeln(')'),
    NovoEspaco is Espacos + 4,
    imprime_arvore(Esquerda, NovoEspaco),
    imprime_arvore(Direita, NovoEspaco).

imprime_espacos(0).
imprime_espacos(N) :-
    N > 0,
    write(' '),
    N2 is N - 1,
    imprime_espacos(N2).

/* 4. Cria a tabela dos códigos para cada símbolo */

/* 5. Codifica o texto original */

/* 6. Gera o arquivo 'out' */

/* Função principal */
:- initialization(iniciar).

iniciar :-
    ler_arquivo('in', Entrada),
    filtrar(Entrada, EntradaFiltrada),
    merge_sort(EntradaFiltrada, TextoOrdenado),

    write('Texto Ordenado: '),
    writeln(TextoOrdenado),

    conta_frequencia(TextoOrdenado, Frequencia),
    write('Contagem de caracteres: '),
    writeln(Frequencia),

    monta_arvore_huffman(Frequencia, Arvore),
    write('Arvore de Huffman: '),
    imprime_arvore(Arvore, 0).
