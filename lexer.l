%option c++ noyywrap
%{
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <unordered_set>
#include <filesystem>
#include "src/FileWriter.h"
#include "src/PatternsCheck.h"

using namespace std;
ifstream fin;
ofstream CountersOutput;
FileWriter * writer = nullptr;
bool prettyPrint = true;

namespace fs = std::filesystem;

int current_column = 1;
int keywords_count = 0;
int relations_count = 0;
int metaAtributes_count = 0;

unordered_set<string> classes_count;
unordered_set<string> instances_count;


unordered_map<string, string> mapIdentifier = {{"relator", "relator"}, {"event", "event"}, {"situation", "situation"}, {"process", "process"},
{"category", "category"}, {"mixin", "mixin"}, {"phaseMixin", "phaseMixin"}, {"roleMixin", "roleMixin"}, {"historialRoleMixin", "historialRoleMixin"},
{"kind", "kind"}, {"collective", "collective"}, {"quantity", "quantity"}, {"quality", "quality"}, {"mode", "mode"}, {"intrisicMode", "intrisicMode"},
{"extrinsicMode", "extrinsicMode"}, {"subkind", "subkind"}, {"phase", "phase"}, {"role", "role"}, {"historicalRole", "historicalRole"},
{"material", "material"}, {"derivation", "derivation"}, {"comparative", "comparative"}, {"mediation", "mediation"}, {"characterization", "characterization"},
{"externalDependence", "externalDependence"}, {"componentOf", "componentOf"}, {"memberOf", "memberOf"}, {"subCollectionOf", "subCollectionOf"},
{"subQualityOf", "subQualityOf"}, {"instantiation", "instantiation"}, {"termination", "termination"}, {"participational", "participational"},
{"participation", "participation"}, {"historicalDependence", "historicalDependence"}, {"creation", "creation"}, {"manifestation", "manifestation"},
{"bringsAbout", "bringsAbout"}, {"triggers", "triggers"}, {"composition", "composition"}, {"aggregation", "aggregation"},
{"inherence", "inherence"}, {"value", "value"}, {"formal", "formal"}, {"constitution", "constitution"}, {"import", "import"} ,{"genset", "genset"},
{"functional-complexes", "functional-complexes"},{"disjoint", "disjoint"}, {"complete", "complete"}, {"general", "general"}, {"specifics", "specifics"}, {"where", "where"},
{"package", "package"}, {"intrinsic-modes", "intrinsic-modes"}};

unordered_map<string, string> mapDatatypes = {{"number", "number"}, {"string", "string"}, {"boolean", "boolean"}, {"date", "date"}, {"time", "time"},
{"datetime", "datetime"}};

unordered_map<string, string> mapMetaAtributes = {{"ordered", "ordered"}, {"const", "const"}, {"derived", "derived"}, 
{"subsets", "subsets"}, {"redefines", "redefines"}};

%}

%option yylineno

CommentLine "//".*
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
{CommentLine}
{Cardinality} { writer->writeToken(yylineno, current_column, "Cardinality", yytext, prettyPrint); current_column += yyleng; }
{SpecialSymbols}   { writer->writeToken(yylineno, current_column, "SpecialSymbol", yytext, prettyPrint); current_column += yyleng; }
{Association} { writer->writeToken(yylineno, current_column, "Association", yytext, prettyPrint);; current_column += yyleng; }
{Underline} writer->writeToken(yylineno, current_column, "Underline", yytext, prettyPrint); current_column += yyleng;
{Number} writer->writeToken(yylineno, current_column, "Number", yytext, prettyPrint); current_column += yyleng;
{GenericName} {
    string lexeme(yytext);
    auto it = mapIdentifier.find(lexeme);
    auto datatypeIt = mapDatatypes.find(lexeme);
    auto metaIt = mapMetaAtributes.find(lexeme);
    
    if(datatypeIt != mapDatatypes.end()){
        writer->writeToken(yylineno, current_column, "Datatype", yytext, prettyPrint);
    }
    else if(metaIt != mapMetaAtributes.end()) {
        writer->writeToken(yylineno, current_column, "Meta-Atribute", yytext, prettyPrint);
        metaAtributes_count++;
    }
    else if (it != mapIdentifier.end()) {
        writer->writeToken(yylineno, current_column, "Keyword", yytext, prettyPrint);
        keywords_count++;
    }
    else if (isPackage(lexeme)) {
        writer->writeToken(yylineno, current_column, "Package", yytext, prettyPrint);
    }
    else if (isDataType(lexeme)) {
        writer->writeToken(yylineno, current_column, "NewDatatype", yytext, prettyPrint);
    }
    else if (isInstance(lexeme)) {
        writer->writeToken(yylineno, current_column, "Instance", yytext, prettyPrint);
        instances_count.insert(lexeme);
    }
    else if (isClassname(lexeme)) {
        writer->writeToken(yylineno, current_column, "Classname", yytext, prettyPrint);
        classes_count.insert(lexeme);
    }
    else if (isRelation(lexeme)) {
        writer->writeToken(yylineno, current_column, "Relation", yytext, prettyPrint);
        relations_count++;
    }
    else {
        writer->writeToken(yylineno, current_column, "Unknown", yytext, prettyPrint);
    }
    current_column += yyleng;
}

%%
int main(int argc, char ** argv){
    bool sinthesisTable = true;

    if(argc < 2){
        cerr << "Uso: ./lexer <caminho_da_pasta> [prettyOff]" << endl;
        return 1;
    }

    fs::path inputDir(argv[1]);

    // prettyPrint = false se houver 3º argumento
    if(argc > 2)
        prettyPrint = false;

    // Checa se é diretório
    if(!fs::exists(inputDir) || !fs::is_directory(inputDir)){
        cerr << "Erro: caminho informado não é um diretório." << endl;
        return 1;
    }

    // Cria pasta output
    fs::path outDir = "output";
    try {
        if(!fs::exists(outDir)){
            fs::create_directory(outDir);
        }
    } catch (const fs::filesystem_error& e) {
        cerr << "Erro ao criar diretório: " << e.what() << endl;
        return 1;
    }

    // Itera arquivos da pasta
    for(const auto & entry : fs::directory_iterator(inputDir)){
        if(entry.is_regular_file()){
            
            string filename = entry.path().string();
            fin.open(filename);

            if(!fin.is_open()){
                cerr << "Erro ao abrir arquivo: " << filename << endl;
                continue;
            }

        

            // Nome de saída (substitui extensão por TokensList.txt)
            string outName = entry.path().filename().string();
            size_t dot = outName.find_last_of(".");
            if(dot != string::npos)
                outName = outName.substr(0, dot);

            string outFile = "output/" + outName + "_TokensList.txt";
            writer = new FileWriter(outFile, prettyPrint);

            yyFlexLexer lexer;
            current_column = 1;
            lexer.switch_streams(&fin);
            lexer.yylex();

            fin.close();

            delete writer;
            writer = nullptr;

            // Zera contadores para o próximo arquivo
            keywords_count = 0;
            relations_count = 0;
            metaAtributes_count = 0;
            classes_count.clear();
            instances_count.clear();
        }
    }

    return 0;
}
