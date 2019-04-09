%{
#include "tokens.h"
%}

%%

[a-zA-z][_a-zA-Z0-9]*         return IDENTIFIER;
[1-9][0-9]*                   return NUMBER;
[ \t\n]                       ;
.                             printf("unexpected character\n");

%%

int yywrap(void){
  return 1;
}
