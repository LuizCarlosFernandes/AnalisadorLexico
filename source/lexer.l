%option c++ noyywrap
%{
#include <iostream>
int main(){

}
%}


Underline[_]
Numbers[0-9]

LowerCase [a-z]
UpperCase [A-Z]
Letters [a-zA-Z]

Package {UpperCase}({Letters}*)+"PKG"
NewTypes {UpperCase}({Letters}*)+"DataType"

ClassNames {UpperCase}({Letters}|{Underline})*
RelationNames {LowerCase}({Letters}|{Underline})*
InstanceNames {Letters}({Letters}|{Numbers}|{Underline})*




%%



%%