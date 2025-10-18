# Compiladores
CC=g++
LEX=flex++
ARQUIVO=lexer.l

# Dependências
all: lexer

lexer: lex.yy.cc
	$(CC) lex.yy.cc src/FileWriter.h src/FileWriter.cpp -std=c++17 -o lexer

lex.yy.cc: $(ARQUIVO)
	$(LEX) $(ARQUIVO)

clean:
	rm lexer lex.yy.cc