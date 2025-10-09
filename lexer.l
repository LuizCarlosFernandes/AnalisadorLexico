%option c++ noyywrap
%{
#include <iostream>
#include <fstream>
#include <unordered_map>

//#include "Token.hpp"
using namespace std;
ifstream fin;
int current_column = 1;

unordered_map<string, string> mapIdentifier = {{"event", "event"}, {"situation", "situation"}, {"process", "process"},
{"category", "category"}, {"mixin", "mixin"}, {"phaseMixin", "phaseMixin"}, {"roleMixin", "roleMixin"}, {"historialRoleMixin", "historialRoleMixin"},
{"kind", "kind"}, {"collective", "collective"}, {"quantity", "quantity"}, {"quality", "quality"}, {"mode", "mode"}, {"intrisicMode", "intrisicMode"},
{"extrinsicMode", "extrinsicMode"}, {"subKind", "subKind"}, {"phase", "phase"}, {"role", "role"}, {"historicalRole", "historicalRole"},
{"material", "material"}, {"derivation", "derivation"}, {"comparative", "comparative"}, {"mediation", "mediation"}, {"characterization", "characterization"},
{"externalDependence", "externalDependence"}, {"componentOf", "componentOf"}, {"memberOf", "memberOf"}, {"subCollectionOf", "subCollectionOf"},
{"subQualityOf", "subQualityOf"}, {"instantiation", "instantiation"}, {"termination", "termination"}, {"participational", "participational"},
{"participation", "participation"}, {"historicalDependence", "historicalDependence"}, {"creation", "creation"}, {"manifestation", "manifestation"},
{"bringsAbout", "bringsAbout"}, {"triggers", "triggers"}, {"composition", "composition"}, {"aggregation", "aggregation"},
{"inherence", "inherence"}, {"value", "value"}, {"formal", "formal"}, {"constitution", "constitution"}, {"genset", "genset"},
{"disjoint", "disjoint"}, {"complete", "complete"}, {"general", "general"}, {"specifics", "specifics"}, {"where", "where"},
{"package", "package"}, {"number", "number"}, {"string", "string"}, {"boolean", "boolean"}, {"date", "date"}, {"time", "time"},
{"datetime", "datetime"}, {"ordered", "ordered"}, {"const", "const"}, {"derived", "derived"}, {"subsets", "subsets"}, {"redefines", "redefines"}
};

%}

%option yylineno

Underline [_]
Number [0-9]+

LowerCase [a-z]
UpperCase [A-Z]
Letters [a-zA-Z]
SpecialSymbols [{}()\[\]|\.\.|<>--|--<>|\\*|@|:]
Package {UpperCase}({Letters}*)+"Pkg"
NewTypes {UpperCase}({Letters}*)+"DataType"
RelationNames {LowerCase}({Letters}|{Underline})*
ClassNames {UpperCase}({Letters}|{Underline})*
InstanceNames {Letters}({Letters}|{Number}|{Underline})*
Identifier {LowerCase}({Letters}*)



%%

[ \t]+ current_column += yyleng;
\n current_column = 1;


{Underline} cout << current_column << " Underline\n"; current_column += yyleng;
{Number} cout << current_column << " Number " << yytext << "\n"; current_column += yyleng;
{LowerCase} cout << current_column << " LowerCase\n"; current_column += yyleng;
{UpperCase} cout << current_column << " UpperCase\n"; current_column += yyleng;
{SpecialSymbols} cout << current_column << " SpecialSymbol " << yytext << "\n"; current_column += yyleng;
{Package} cout << current_column << " Package\n"; current_column += yyleng;
{NewTypes} cout << current_column << " NewTypes\n"; current_column += yyleng;
{ClassNames} cout << current_column << " ClassNames\n"; current_column += yyleng;
{RelationNames} cout << current_column << " RelationNames\n"; current_column += yyleng;
{InstanceNames} cout << current_column << " InstanceNames\n"; current_column += yyleng;
{Identifier} {
    auto it = mapIdentifier.find(yytext);
    if(it != mapIdentifier.end()){
        cout << current_column << " ID " << it->second << "\n";
    } else {
        cout << "Erro na linha " << yylineno << " No token:" << yytext << "\n";
    }
}

%%
//#include "Token.hpp"
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