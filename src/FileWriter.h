#ifndef FILE_WRITER
#define FILE_WRITER

#include <fstream>
#include <iomanip>
#include <string>

class FileWriter {
    private:
        std::ofstream out;

    public:
        FileWriter(const std::string& path);
        ~FileWriter();
        void writeHeader();
        void writeToken(int line, int column, const std::string& type, const std::string& lexeme);
};
#endif