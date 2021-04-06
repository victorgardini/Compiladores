all: sintatico.tab.c lex.yy.c
	@echo "\nCriando o analisador...\n"
	gcc lex.yy.c sintatico.tab.c -ll -o analisador.exe
	@echo "\nOK!"
	@echo "\nPara utilizar, execute no seu terminal: ./analisador exemplos/teste1.txt\n"

sintatico.tab.c: sintatico.y
	@echo "\nCriando o arquivo de analise sintática...\n"
	bison -d sintatico.y

lex.yy.c: lexico.l
	@echo "\nCriando o arquivo de analise léxica...\n"
	lex lexico.l

clean:
	rm -rf lex.yy.c sintatico.tab.c analisador sintatico.tab.h lex.yy.o sintatico.tab.o
