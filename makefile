# Compiladores
CC=g++
LEX=flex++
ARQUIVO=lexerv2.l

# Dependências
all: lexer

lexer: lex.yy.cc
	$(CC) lex.yy.cc -std=c++17 -o lexer

lex.yy.cc: $(ARQUIVO)
	$(LEX) $(ARQUIVO)

clean:
	rm lexer lex.yy.cc