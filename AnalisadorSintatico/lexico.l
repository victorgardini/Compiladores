%{
    #include <stdio.h>
    #include "sintatico.tab.h"

    #define ANSI_COLOR_RED     "\x1b[31m"
    #define ANSI_COLOR_GREEN   "\x1b[32m"
    #define ANSI_COLOR_YELLOW  "\x1b[33m"
    #define ANSI_COLOR_BLUE    "\x1b[34m"
    #define ANSI_COLOR_MAGENTA "\x1b[35m"
    #define ANSI_COLOR_CYAN    "\x1b[36m"
    #define ANSI_COLOR_RESET   "\x1b[0m"

    extern int erros;
    extern int linhas;

    void token_reconhecido(int linhas, char * tipo, char * token){
        printf("--> L: %.3d Token %s \"%s\" - OK\n", linhas, tipo, token);
    }

    void token_nao_reconhecido(int linhas, char * token){
        printf(ANSI_COLOR_RED"--> L: %.3d Token \"%s\" - ERRO\n" ANSI_COLOR_RESET, linhas, token);
    }

%}

%option yylineno

DIGITO [0-9]
ALFABETO [a-zA-Z]
ID [a-zA-Z_][a-zA-Z0-9_]*
ESPACO " "|"\t"

OPERADORES_ARITMETICOS  "+"|"-"|"*"|"/"|"^"
OPERADORES_LOGICOS  "or"|"and"|"not"

PONTO_E_VIRGULA ";"
VIRGULA ","
ATRIBUICAO "="

OPERADORES_RELACIONAIS "=="|">"|"<"|">="|"<="|"!="
ABRE_PARENTESES "("
FECHA_PARENTESES ")"
ABRE_CHAVES "{"
FECHA_CHAVES "}"

IF "if"
ELSE "else"
WHILE "while"
FOR "for"
DEF "def"
RETURN "return"
TIPOS_VARIAVEIS "int"|"float"|"double"|"char"
INICIO_PROGRAMA "%INICIO_PROGRAMA%"
FIM_PROGRAMA "%FIM_PROGRAMA%"

QUEBRA_LINHA [\n]

%%

{IF} { return (IF); }
{ELSE} { return (ELSE); }
{FOR} { return (FOR);}
{WHILE} { return (WHILE); }
{DEF} { return (DEF);}
{RETURN} { return (RETURN); }
{TIPOS_VARIAVEIS} { return (TIPOS_VARIAVEIS); }
{INICIO_PROGRAMA} { return (INICIO_PROGRAMA); }
{FIM_PROGRAMA} { return (FIM_PROGRAMA); }

{DIGITO}+ { return (NUMERO_INTEIRO);}
{DIGITO}+"."{DIGITO}* { return (NUMERO_REAL);}

{OPERADORES_ARITMETICOS} { return (OPERADORES_ARITMETICOS);}
{OPERADORES_RELACIONAIS} { return (OPERADORES_RELACIONAIS);}
{OPERADORES_LOGICOS} { return (OPERADORES_LOGICOS);}

{ALFABETO}+({ALFABETO}|{DIGITO})* { return ID; }
{DIGITO}+|{DIGITO}+"."{DIGITO}+ { return NUMERO; }

{PONTO_E_VIRGULA} { return (PONTO_E_VIRGULA);}
{VIRGULA} { return (VIRGULA);}
{ABRE_PARENTESES} { return (ABRE_PARENTESES);}
{FECHA_PARENTESES} { return (FECHA_PARENTESES);}
{ABRE_CHAVES} { return (ABRE_CHAVES);}
{FECHA_CHAVES} { return (FECHA_CHAVES);}
{ATRIBUICAO} { return (ATRIBUICAO);}

{QUEBRA_LINHA} {} /* { linhas++; }  Ignora quebra de linha */                
{ESPACO}+ {}

"//".*$ {}

{DIGITO}+{ID} {printf ("Identificador inválido na linha %d\n", yylineno); erros++;}

[\"][^\"]*[\"] {return (STRING);}

. {printf("Caractere desconhecido na linha %d\n", yylineno); erros++;}
