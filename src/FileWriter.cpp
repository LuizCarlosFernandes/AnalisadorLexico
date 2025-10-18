#include "FileWriter.h"

FileWriter::FileWriter(const std::string& path){
    out.open(path);
    if (!out.is_open())
        throw std::runtime_error("Erro ao abrir arquivo de saída: " + path);
    writeHeader();
}

FileWriter::~FileWriter(){
    if (out.is_open())
        out.close();
}

void FileWriter::writeHeader(){
    out << std::left
        << std::setw(6)  << "Line"   << " | "
        << std::setw(7)  << "Column" << " | "
        << std::setw(13) << "Type"   << " | "
        << "Lexeme" << "\n";
    out << std::string(60, '-') << "\n";
    }

void FileWriter::writeToken(int line, int column, const std::string& type, const std::string& lexeme) {
    out << std::left
        << std::setw(6)  << line   << " | "
        << std::setw(7)  << column << " | "
        << std::setw(13) << type   << " | "
        << lexeme << "\n";
    }