#include <stdio.h>
#include "parser/tokens.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

char *names[] = {NULL,"Symbol","Text","Number","Identifier"};

int main(){
  int ntoken, vtoken;
  ntoken = yylex();
  while(ntoken) {
    printf("%d\n",ntoken);
    ntoken = yylex();
  }
  return 0;
}
