%option c++ noyywrap
%{
#include <iostream>
#include <fstream>
using namespace std;
ifstream fin;
int current_column = 1;
%}


Underline [_]
Number [0-9]+

LowerCase [a-z]
UpperCase [A-Z]
Letters [a-zA-Z]

Package {UpperCase}({Letters}*)+"Pkg"
NewTypes {UpperCase}({Letters}*)+"DataType"

ClassNames {UpperCase}({Letters}|{Underline})*
RelationNames {LowerCase}({Letters}|{Underline})*
InstanceNames {Letters}({Letters}|{Number}|{Underline})*

%%

[ \t]+ current_column += yyleng;
\n current_column = 1;
{Underline} cout << current_column << " Underline\n"; current_column += yyleng;
{Number} cout << current_column << " Number\n"; current_column += yyleng;
{LowerCase} cout << current_column << " LowerCase\n"; current_column += yyleng;
{UpperCase} cout << current_column << " UpperCase\n"; current_column += yyleng;
{Package} cout << current_column << " Package\n"; current_column += yyleng;
{NewTypes} cout << current_column << " NewTypes\n"; current_column += yyleng;
{ClassNames} cout << current_column << " ClassNames\n"; current_column += yyleng;
{RelationNames} cout << current_column << " RelationNames\n"; current_column += yyleng;
{InstanceNames} cout << current_column << " InstanceNames\n"; current_column += yyleng;

%%
int main(int argc, char ** argv){
    yyFlexLexer lexer;
    lexer.switch_streams(&fin);  // altera entrada para arquivo
    if(argc > 1 && argv != nullptr){
        fin.open(argv[1]); //Abre arquivo a ser analisado
        lexer.yylex();
    } else {
        cout << "Erro ao abrir arquivo";
    }

    if(fin.is_open())
        fin.close();

    cout << "\n";
    return 0;
}