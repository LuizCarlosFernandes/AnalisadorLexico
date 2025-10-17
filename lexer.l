%option c++ noyywrap
%{
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <filesystem>

using namespace std;
ifstream fin;
ofstream TokensOutput; 
ofstream CountersOutput;


namespace fs = std::filesystem;


int classes_count = 0;
int relations_count = 0;
int keywords_count = 0;
int instances_count = 0;
int metaAtributes_count = 0;
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
{"inherence", "inherence"}, {"value", "value"}, {"formal", "formal"}, {"constitution", "constitution"}, {"import", "import"} ,{"genset", "genset"},
{"functional-complexes", "functional-complexes"},{"disjoint", "disjoint"}, {"complete", "complete"}, {"general", "general"}, {"specifics", "specifics"}, {"where", "where"},
{"package", "package"}, {"number", "number"}, {"string", "string"}, {"boolean", "boolean"}, {"date", "date"}, {"time", "time"},
{"datetime", "datetime"}, {"intrinsic-modes", "intrinsic-modes"}};
unordered_map<string, string> mapMetaAtributes = {{"ordered", "ordered"}, {"const", "const"}, {"derived", "derived"}, 
{"subsets", "subsets"}, {"redefines", "redefines"}};

%}

%option yylineno

Underline [_]
Number [0-9]+
Letters [a-zA-Z]
SpecialSymbols [{}()\[\]*@:,]
Association ("<>--"|"--"|"--<>"|".."|"<o>--")
Cardinality (\[{Number}(".."({Number}|\*))?\])
GenericName {Letters}({Letters}|{Number}|{Underline})*(\-({Letters}|{Number}|{Underline})+)*

%%

[ \t]+ current_column += yyleng;
\n current_column = 1;
{Cardinality} { TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", Cardinality " << yytext << "\n"; current_column += yyleng; }
{SpecialSymbols}   { TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", SpecialSymbol " << yytext << "\n"; current_column += yyleng; }
{Association} { TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", Association " << yytext << "\n"; current_column += yyleng; }
{Underline} TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", Underline\n"; current_column += yyleng;
{Number} TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", Number " << yytext << "\n"; current_column += yyleng;
{GenericName} {
    string lexeme(yytext);
    auto it = mapIdentifier.find(lexeme);
    auto metaIt = mapMetaAtributes.find(lexeme);
    
    if(metaIt != mapMetaAtributes.end()) {//Testa se é um meta-atributo e aumenta o contador
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", MetaAtribute (" << metaIt->second << ")\n";
        metaAtributes_count++;
    }
    // 1. É uma palavra-chave/reservada/estereótipo? (Mais específico)
    else if (it != mapIdentifier.end()) {
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", Keyword (" << it->second << ")\n";
        keywords_count++;
        
    }
    // 2. É um Package? (Verifica o sufixo)
    else if (lexeme.length() > 3 && lexeme.substr(lexeme.length() - 3) == "Pkg") {
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", Package (" << lexeme << ")\n";
    }
    // 3. É um NewType? (Verifica o sufixo)
    else if (lexeme.length() > 8 && lexeme.substr(lexeme.length() - 8) == "DataType") {
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", NewType (" << lexeme << ")\n";
    }
    // 4. É uma InstanceName? (Verifica se termina com número, conforme a descrição do trabalho)
    else if (!lexeme.empty() && isdigit(lexeme.back())) {
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", InstanceName (" << lexeme << ")\n";
        instances_count++;
    }
    // 5. É um ClassName? (Regra geral de capitalização)
    else if (!lexeme.empty() && isupper(lexeme[0])) {
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", ClassName (" << lexeme << ")\n";
        classes_count++;
    }
    // 6. É um RelationName? (Regra geral de capitalização)
    else if (!lexeme.empty() && islower(lexeme[0])) {
        TokensOutput << "Column: " << current_column << ", Line: " << yylineno << ", RelationName (" << lexeme << ")\n";
        relations_count++;
    }
    // 7. Se não for nada disso, é um erro.
    else {
        TokensOutput << "Erro na linha " << yylineno << ": Identificador inválido '" << lexeme << "'\n";
    }
    current_column += yyleng;
}

%%
int main(int argc, char ** argv){
    yyFlexLexer lexer;
    lexer.switch_streams(&fin);  // altera entrada para arquivo
    
    fs::path dir = "output";
    try{
        if(!fs::exists(dir)){
            fs::create_directory(dir);
        }
    }catch (const fs::filesystem_error& e) {
        cerr << "Erro ao criar diretório: " << e.what() << endl;
        return 1;
        
    }

    if(argc > 1 && argv != nullptr){
        string filename(argv[1]);
        fin.open(filename); //Abre arquivo a ser analisado
        TokensOutput.open("output/" + filename.substr(9, filename.length()- 9).replace(filename.length()-15 ,6 , "TokensList.txt"));
        CountersOutput.open("output/" + filename.substr(9, filename.length()- 9).replace(filename.length()-15 ,6 , "SynthesisTable.txt"));
        lexer.yylex();
        //Escrita de contadores.
        CountersOutput << "Classes: " << classes_count << "\n";
        CountersOutput << "Relations: " << relations_count << "\n";
        CountersOutput << "Keywords: " << keywords_count << "\n";
        CountersOutput << "Instances: " << instances_count << "\n";
        CountersOutput << "MetaAtributes: " << metaAtributes_count << "\n";
        
        fin.close();
        TokensOutput.close();
        CountersOutput.close();
    } else {
        cout << "Erro ao abrir arquivo.";
    }
}