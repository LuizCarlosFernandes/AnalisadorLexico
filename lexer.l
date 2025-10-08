%option c++ noyywrap
%{
#include <iostream>
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

{Underline} std::cout << "Underline\n";
{Number} std::cout << "Número\n";
{LowerCase} std::cout << "LowerCase\n";
{UpperCase} std::cout << "UpperCase\n";
{Package} std::cout << "Package\n"; 
{ClassNames} std::cout << "ClassNames\n";
{RelationNames} std::cout << "RelationNames\n";
{InstanceNames} std::cout << "InstanceNames\n";



%%
int main(){
    yyFlexLexer lexer;
    lexer.yylex();
    return 0;
}