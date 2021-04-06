/* 
    Seção de comentários
*/

%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    #define ANSI_COLOR_RED     "\x1b[31m"
    #define ANSI_COLOR_GREEN   "\x1b[32m"
    #define ANSI_COLOR_YELLOW  "\x1b[33m"
    #define ANSI_COLOR_BLUE    "\x1b[34m"
    #define ANSI_COLOR_MAGENTA "\x1b[35m"
    #define ANSI_COLOR_CYAN    "\x1b[36m"
    #define ANSI_COLOR_RESET   "\x1b[0m"

    int yylex();
    int yyparse();

    extern FILE * yyin;
    extern int yylineno;
    int erros = 0;

    void yyerror (const char *s) {
        printf(ANSI_COLOR_RED "Erro encontrado na linha %d: %s \n" ANSI_COLOR_RESET, yylineno, s);
        erros++;
    }

    int main(int argc, char *argv[]) {
        FILE * arquivo = fopen(argv[1], "r");
        
        if (!arquivo) {
            printf(ANSI_COLOR_RED"\n[ERRO] Ocorreu um erro ao abrir o arquivo!\n"ANSI_COLOR_RESET);
            printf(ANSI_COLOR_YELLOW"\n[DICA] Verifique se o arquivo e/ou o diretório existe.\n"ANSI_COLOR_RESET);
            return -1;
        }
        
        yyin = arquivo;
        do {
            yyparse();
        } while (!feof(yyin));

        if (erros == 0) {
            printf(ANSI_COLOR_GREEN"\n[SUCESSO] Análise executada com sucesso! Nenhum erro encontrado.\n\n"ANSI_COLOR_RESET);
            exit(0);
        }
        else {
            printf(ANSI_COLOR_YELLOW"\n[AVISO] A análise foi interrompida, o código possui erros.\n\n"ANSI_COLOR_RESET);
            exit(1);
        }
    }
%}

%token INICIO_PROGRAMA
%token FIM_PROGRAMA

%token IF
%token FOR
%token ELSE
%token WHILE
%token DEF
%token RETURN

%token TIPOS_VARIAVEIS
%token NUMERO_INTEIRO
%token NUMERO_REAL

%token ID
%token NUMERO
%token OPERADORES_ARITMETICOS
%token OPERADORES_RELACIONAIS
%token OPERADORES_LOGICOS

%token PONTO_E_VIRGULA
%token VIRGULA
%token ABRE_PARENTESES
%token FECHA_PARENTESES
%token ABRE_CHAVES
%token FECHA_CHAVES
%token ATRIBUICAO
%token STRING

%define parse.error verbose

%start principal

%%

/* Definição da estrutura inicial do programa */
principal: INICIO_PROGRAMA comandos FIM_PROGRAMA;

/* Definição dos comandos possíveis */
comandos: decl_var comandos 
	| ID atribuicao PONTO_E_VIRGULA comandos 
	| condicional comandos 
    | funcao comandos
	| loop comandos 
	| %empty;

/* Declaração das funções */
funcao: DEF ID ABRE_PARENTESES lista_parametros FECHA_PARENTESES bloco_comando_funcao
    | ID ABRE_PARENTESES STRING FECHA_PARENTESES PONTO_E_VIRGULA
    | ID ABRE_PARENTESES cont_parametros FECHA_PARENTESES PONTO_E_VIRGULA
    | ID ABRE_PARENTESES ID FECHA_PARENTESES PONTO_E_VIRGULA
    | ID ABRE_PARENTESES STRING VIRGULA ID FECHA_PARENTESES PONTO_E_VIRGULA;

/* Definição da lista de parametros de uma função */
lista_parametros: TIPOS_VARIAVEIS ID cont_parametros
    | %empty;

/* Definição da continuação dos parametros de uma função*/
cont_parametros: VIRGULA TIPOS_VARIAVEIS ID cont_parametros
    | VIRGULA ID cont_parametros
    | ID cont_parametros
    | %empty;

var_num: ID 
    | NUMERO_REAL 
    | NUMERO_INTEIRO;

/* Definição da estrutura de declaração das variáveis */
decl_var: TIPOS_VARIAVEIS ID PONTO_E_VIRGULA
	| TIPOS_VARIAVEIS ID atribuicao PONTO_E_VIRGULA;

/* Definição das estruturas de atribuicao de variáveis */
atribuicao: ATRIBUICAO expressao_arit 
    | ATRIBUICAO ID ABRE_PARENTESES cont_parametros FECHA_PARENTESES
	| var_num;

/* Definição das regras de expressão aritméticas */
expressao_arit: arit1 arit2 ;
arit1: ABRE_PARENTESES expressao_arit FECHA_PARENTESES arit2 
     | var_num arit2;
arit2: OPERADORES_ARITMETICOS arit1 
     | %empty;

/* Definição das regras de expressão lógica */
expressao_logica: expressao_arit log1 ;
log1: OPERADORES_RELACIONAIS expressao_arit log2 
    | %empty;
log2: OPERADORES_LOGICOS expressao_logica 
    | %empty;

/* Definição do bloco de comandos delimitados pelas chaves */
bloco_comando: ABRE_CHAVES comandos FECHA_CHAVES;

/* Definição do bloco de comando das funções */
bloco_comando_funcao: ABRE_CHAVES comandos FECHA_CHAVES
    | ABRE_CHAVES comandos RETURN var_num PONTO_E_VIRGULA FECHA_CHAVES
    | ABRE_CHAVES comandos RETURN STRING PONTO_E_VIRGULA FECHA_CHAVES;

/* Declaração das estruturas condicionais */
condicional: IF ABRE_PARENTESES expressao_logica FECHA_PARENTESES bloco_comando cond1;
cond1: ELSE bloco_comando 
    | %empty;

/* Declaração das estruturas de repetição */
loop: FOR ABRE_PARENTESES decl_var expressao_logica PONTO_E_VIRGULA ID atribuicao FECHA_PARENTESES bloco_comando
    | WHILE ABRE_PARENTESES expressao_logica FECHA_PARENTESES bloco_comando;

%%
