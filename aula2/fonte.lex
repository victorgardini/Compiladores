%{
    /*
        Definition Section has x variables which can be accessed 
        inside yylex() zzzand main()
    */

    int linhas=1, erros=0;
%}

  /*
    Rule Section has three rules, first rule matches with capital letters, 
    second rule matches with any character except newline and third rule does not take 
    input after the enter
  */


DIGITO  [0-9]
ID      [A-Za-z][A-Za-z0-9]*
ESPACO  [\t\r" "]


%%

{ESPACO} /*reconhece espaço em branco*/


{DIGITO}+{ID} {
    printf("Identificador inválido: %s - ", yytext);
    erros++;
    printf("Linha: %d\n", linhas);
} /*reconhece erro em identificador*/


{ID}{DIGITO}*{ID}* {
    printf("Identificador: %s\n", yytext);
}

{DIGITO}+ {
    printf("Inteiro: %s\n",yytext);
}

{DIGITO}+"."{DIGITO}+ {
    printf("Real: %s\n",yytext);
}

"//"[^\n]* {
    printf("Comentários\n");
} /*Comentários Simples, nessa linguagem não há
comentário de mais de uma linha, para fazê-lo, deve-se
comentar uma linha por vez */

\n {
    linhas++;
} /*reconhece mudança de linhas*/

. {
    printf("Token inválido: %s - ",yytext);
    erros++;
    printf("Linha: %d\n", linhas);
} /*Apresenta erro em qualquer coisa que não for uma
regra válida*/

%%

int yywrap();

void main() {
    yylex();
    
    printf("Total de erros encontrados: %d\n", erros);
    
    if (erros == 0)
        printf("\nCódigo analisado com sucesso!\n");
}
    
int yywrap() {
    return 1;
}