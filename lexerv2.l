%option c++ noyywrap
%{
#include <iostream>
#include <fstream>
#include <unordered_map>

//#include "Token.h"
using namespace std;
ifstream fin;
int current_column = 1;

unordered_map<string, string> mapIdentifier = {{"relator", "relator"}, {"event", "event"}, {"situation", "situation"}, {"process", "process"},
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

Letters [a-zA-Z]
SpecialSymbols [{}()\[\]|\.\.|<>--|--<>|\\*|@|:]
GenericName {Letters}({Letters}|{Number}|{Underline})*

%%

[ \t]+ current_column += yyleng;
\n current_column = 1;

"--"            { cout << current_column << " SpecialSymbol " << yytext << "\n"; current_column += yyleng; }
"<>--"          { cout << current_column << " SpecialSymbol " << yytext << "\n"; current_column += yyleng; }
"--<>"          { cout << current_column << " SpecialSymbol " << yytext << "\n"; current_column += yyleng; }
".."            { cout << current_column << " SpecialSymbol " << yytext << "\n"; current_column += yyleng; }
[{}()\[\]*@:,]   { cout << current_column << " SpecialSymbol " << yytext << "\n"; current_column += yyleng; }


{Underline} cout << current_column << " Underline\n"; current_column += yyleng;
{Number} cout << current_column << " Number " << yytext << "\n"; current_column += yyleng;
{GenericName} {
    string lexeme(yytext);
    auto it = mapIdentifier.find(lexeme);

    // 1. É uma palavra-chave/reservada/estereótipo? (Mais específico)
    if (it != mapIdentifier.end()) {
        cout << current_column << " Keyword (" << it->second << ")\n";
    }
    // 2. É um Package? (Verifica o sufixo)
    else if (lexeme.length() > 3 && lexeme.substr(lexeme.length() - 3) == "Pkg") {
        cout << current_column << " Package (" << lexeme << ")\n";
    }
    // 3. É um NewType? (Verifica o sufixo)
    else if (lexeme.length() > 8 && lexeme.substr(lexeme.length() - 8) == "DataType") {
        cout << current_column << " NewType (" << lexeme << ")\n";
    }
    // 4. É uma InstanceName? (Verifica se termina com número, conforme a descrição do trabalho)
    else if (!lexeme.empty() && isdigit(lexeme.back())) {
        cout << current_column << " InstanceName (" << lexeme << ")\n";
    }
    // 5. É um ClassName? (Regra geral de capitalização)
    else if (!lexeme.empty() && isupper(lexeme[0])) {
        cout << current_column << " ClassName (" << lexeme << ")\n";
    }
    // 6. É um RelationName? (Regra geral de capitalização)
    else if (!lexeme.empty() && islower(lexeme[0])) {
        cout << current_column << " RelationName (" << lexeme << ")\n";
    }
    // 7. Se não for nada disso, é um erro.
    else {
        cout << "Erro na linha " << yylineno << ": Identificador inválido '" << lexeme << "'\n";
    }
    current_column += yyleng;
}

%%
//#include "Token.h"
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