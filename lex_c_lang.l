%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
"const"     { return(CONST); }
"else"      { return(ELSE); }
"float"     { return(FLOAT); }
"if"        { return(IF); }
"int"       { return(INT); }
"return"    { return(RETURN); }
"signed"    { return(SIGNED); }
"static"    { return(STATIC); }
"unsigned"  { return(UNSIGNED); }

0[xX][a-fA-F0-9]+  { return(CONSTANT); }
0[0-9]+            { return(CONSTANT); }
[0-9]+             { return(CONSTANT); }

[0-9]+[Ee][+-]?[0-9]+              { return(CONSTANT); }
[0-9]*"."[0-9]+([Ee][+-]?[0-9]+)?  { return(CONSTANT); }
[0-9]+"."[0-9]*([Ee][+-]?[0-9]+)?  { return(CONSTANT); }

">>="  { return(RIGHT_ASSIGN); }
"<<="  { return(LEFT_ASSIGN); }
"+="   { return(ADD_ASSIGN); }
"-="   { return(SUB_ASSIGN); }
"*="   { return(MUL_ASSIGN); }
"/="   { return(DIV_ASSIGN); }
"%="   { return(MOD_ASSIGN); }
"&="   { return(AND_ASSIGN); }
"^="   { return(XOR_ASSIGN); }
"|="   { return(OR_ASSIGN); }
">>"   { return(RIGHT_OP); }
"<<"   { return(LEFT_OP); }
"++"   { return(INC_OP); }
"--"   { return(DEC_OP); }
"->"   { return(PTR_OP); }
"&&"   { return(AND_OP); }
"||"   { return(OR_OP); }
"<="   { return(LE_OP); }
">="   { return(GE_OP); }
"=="   { return(EQ_OP); }
"!="   { return(NE_OP); }
";"    { return(';'); }
"{"    { return('{'); }
"}"    { return('}'); }
","    { return(','); }
":"    { return(':'); }
"="    { return('='); }
"("    { return('('); }
")"    { return(')'); }
"["    { return('['); }
"]"    { return(']'); }
"."    { return('.'); }
"&"    { return('&'); }
"!"    { return('!'); }
"~"    { return('~'); }
"-"    { return('-'); }
"+"    { return('+'); }
"*"    { return('*'); }
"/"    { return('/'); }
"%"    { return('%'); }
"<"    { return('<'); }
">"    { return('>'); }
"^"    { return('^'); }
"|"    { return('|'); }
"?"    { return('?'); }

[ \t\v\n\f]   { }
.             { /* ignore other characters */ }
%%
