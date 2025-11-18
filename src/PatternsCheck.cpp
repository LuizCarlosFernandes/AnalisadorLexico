#include <string>
#include <cctype>
using namespace std;

bool isClassname(const string& s) {
    if (s.empty() || !isupper(s[0])) return false;
    size_t i = 1;
    while (i < s.size() && isalpha(s[i])) i++;

    while (i < s.size() && s[i] == '_') {
        i++;
        if (i >= s.size() || !isalpha(s[i])) return false;
        while (i < s.size() && isalpha(s[i])) i++;
    }
    return i == s.size();
}

bool isRelation(const string& s) {
    if (s.empty() || !islower(s[0])) return false;
    size_t i = 1;
    while (i < s.size() && isalpha(s[i])) i++;

    while (i < s.size() && s[i] == '_') {
        i++;
        if (i >= s.size() || !isalpha(s[i])) return false;
        while (i < s.size() && isalpha(s[i])) i++;
    }
    return i == s.size();
}

bool isInstance(const string& s) {
    if (s.empty() || !isalpha(s[0])) return false;
    size_t i = 1;
    while (i < s.size() && isalpha(s[i])) i++;

    while (i < s.size() && s[i] == '_') {
        i++;
        while (i < s.size() && isalpha(s[i])) i++;
    }

    if (i >= s.size() || !isdigit(s[i])) return false;
    while (i < s.size() && isdigit(s[i])) i++;

    return i == s.size();
}

bool isPackage(const string& s) {
    if (s.size() < 4) return false;
    if (s.substr(s.size() - 3) != "Pkg") return false;
    for (size_t i = 0; i < s.size() - 3; i++)
        if (!isalpha(s[i])) return false;
    return true;
}

bool isDataType(const string& s) {
    if (s.size() < 8) return false;
    if (s.substr(s.size() - 8) != "DataType") return false;
    for (size_t i = 0; i < s.size() - 8; i++)
        if (!std::isalpha(s[i])) return false;
    return true;
}