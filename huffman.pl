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
filtrar([' '|R], SaidaFiltrada) :- filtrar(R, SaidaFiltrada).
filtrar(['\n'|R], SaidaFiltrada) :- filtrar(R, SaidaFiltrada).
filtrar([C|R], [C|RestoFiltrado]) :- filtrar(R, RestoFiltrado).

/* 2. Cria uma tabela estatística com a quantidade de cada letra no texto */
/* a. Ordena o texto por merge sort */
merge_sort([], []).
merge_sort([E], [E]).
merge_sort(L, ListaOrdenada) :-
    split(L, Metade1, Metade2),
    merge_sort(Metade1, Ordenada1),
    merge_sort(Metade2, Ordenada2),
    intercala(Ordenada1, Ordenada2, ListaOrdenada).


intercala([], L, L).
intercala(L, [], L).
intercala([PrimeiroA|RestoA], [PrimeiroB|RestoB], [PrimeiroA|Resultado]) :-
    PrimeiroA @=< PrimeiroB,
    intercala(RestoA, [PrimeiroB|RestoB], Resultado).
intercala([PrimeiroA|RestoA], [PrimeiroB|RestoB], [PrimeiroB|Resultado]) :-
    PrimeiroA @> PrimeiroB,
    intercala([PrimeiroA|RestoA], RestoB, Resultado).

split([], [], []).
split([E], [E], []).
split([Primeiro, Segundo|Resto], [Primeiro|RestoMetade1], [Segundo|RestoMetade2]) :-
    split(Resto, RestoMetade1, RestoMetade2).


/* b. Contar cada caractere da lista ordenada (RLE) */
conta_frequencia([], []).
conta_frequencia([PrimeiroCaractere|Resto], TabelaFrequencia) :-
    conta_frequencia(Resto, PrimeiroCaractere, 1, TabelaFrequencia).

conta_frequencia([], CaractereAtual, QuantidadeAtual, [(CaractereAtual, QuantidadeAtual)]).

conta_frequencia([CaractereAtual|Resto], CaractereAtual, QuantidadeAtual, TabelaFrequencia) :-
    NovaQuantidade is QuantidadeAtual + 1,
    conta_frequencia(Resto, CaractereAtual, NovaQuantidade, TabelaFrequencia).

conta_frequencia([NovoCaractere|Resto], CaractereAtual, QuantidadeAtual, [(CaractereAtual, QuantidadeAtual)|TabelaFrequencia]) :-
    conta_frequencia(Resto, NovoCaractere, 1, TabelaFrequencia).

/* 3. Cria a árvore de Huffman */
/* a. Transforma a tabela de frequência em uma lista de folhas */
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
cria_tabela_codigos(folha(Caractere, _), [(Caractere, [0])]).
cria_tabela_codigos(Arvore, Tabela) :-
    cria_tabela_codigos(Arvore, [], Tabela).
cria_tabela_codigos(folha(Caractere, _), Caminho, [(Caractere, Caminho)]).

/* a. Para nó interno, percorre esquerda com 0 e direita com 1 */
cria_tabela_codigos(no(_, Esquerda, Direita), Caminho, Tabela) :-
    cria_tabela_codigos(Esquerda, [0|Caminho], TabelaEsquerda),
    cria_tabela_codigos(Direita, [1|Caminho], TabelaDireita),
    junta_listas(TabelaEsquerda, TabelaDireita, Tabela).

junta_listas([], L, L).
junta_listas([X|Xs], L, [X|R]) :-
    junta_listas(Xs, L, R).

inverte_lista(Lista, Invertida) :- inverte_lista(Lista, [], Invertida).
inverte_lista([], Acumulador, Acumulador).
inverte_lista([X|Xs], Acumulador, Invertida) :-
    inverte_lista(Xs, [X|Acumulador], Invertida).

/* b. Inverte todos os códigos da tabela */
corrige_codigos([], []).
corrige_codigos([(Caractere, CodigoInvertido)|Resto], [(Caractere, Codigo)|TabelaFinal]) :-
    inverte_lista(CodigoInvertido, Codigo),
    corrige_codigos(Resto, TabelaFinal).

monta_tabela_codigos(Arvore, TabelaFinal) :-
    cria_tabela_codigos(Arvore, TabelaInvertida),
    corrige_codigos(TabelaInvertida, TabelaFinal).

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
    imprime_arvore(Arvore, 0),

    monta_tabela_codigos(Arvore, TabelaCodigos),
    write('Tabela de codigos: '),
    writeln(TabelaCodigos).
