#ifndef PATTERNS_CHECK_HPP
#define PATTERNS_CHECK_HPP

#include <string>
using namespace std;

bool isClassname(const string& s);
bool isRelation(const string& s);
bool isInstance(const string& s);
bool isPackage(const string& s);
bool isDataType(const string& s);

#endif