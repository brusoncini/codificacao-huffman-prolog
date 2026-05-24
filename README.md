# Codificação de Huffman em Prolog

<p align="center">
  <img src="https://img.shields.io/badge/Prolog-SWI--Prolog-blue">
  <img src="https://img.shields.io/badge/status-concluído-green">
  <img src="https://img.shields.io/badge/tipo-projeto%20acadêmico-purple">
</p>

Implementação do algoritmo de **Codificação de Huffman** em Prolog para a disciplina de Paradigmas de Programação.


## 🎯 Objetivo
O projeto recebe um arquivo de entrada 'in' contendo texto e gera sua representação codificada 'out' utilizando o algoritmo de Huffman.


## 💻 Codificação de Huffman
É um método de compressão que usa as probabilidades de ocorrência dos símbolos no conjunto de dados para determinar códigos de tamanho variável para cada símbolo. Foi desenvolvido em 1952 por David A. Huffman.

Uma árvore binária completa, chamada de árvore de Huffman, é construída recursivamente a partir da junção dos dois símbolos de menor probabilidade, que são então somados em símbolos auxiliares e estes símbolos auxiliares recolocados no conjunto de símbolos.

O processo termina quando todos os símbolos forem unidos em símbolos auxiliares, formando uma árvore binária. A árvore é então percorrida, atribuindo-se valores binários de 1 ou 0 para cada aresta, e os códigos são gerados a partir desse percurso.

Os símbolos mais comuns são geralmente representados usando-se menos dígitos que os símbolos que aparecem com menos frequência.


## 📌 Funcionalidades

- Leitura de arquivos texto
- Conversão do texto para lista de caracteres
- Ordenação dos caracteres utilizando Merge Sort
- Construção da tabela de frequências
- Geração da árvore de Huffman
- Codificação do texto de entrada
- Geração do arquivo codificado


## ▶️ Como executar

### 1. Instale o SWI-Prolog
Certifique-se de ter o SWI instalado na sua máquina.

https://www.swi-prolog.org


### 2. Execute o programa

No terminal:

```bash
swipl huffman.pl
```

Ou abra o interpretador manualmente:

```bash
swipl
```

e carregue o arquivo:

```prolog
['huffman.pl'].
```


## 📚 Referência

- https://pt.wikipedia.org/wiki/Codificação_de_Huffman

## 👩🏻‍💻 Feito por

Desenvolvido com ❤️ por [Bruna Soncini](https://www.linkedin.com/in/brunasoncini/).