%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap

%%
 /* keywords */
"int"       { printf("INT ");       return(INT); }
"float"     { printf("FLOAT ");     return(FLOAT); }
"signed"    { printf("SIGNED ");    return(SIGNED); }
"unsigned"  { printf("UNSIGNED ");  return(UNSIGNED); }
"const"     { printf("KEY_CONST "); return(KEY_CONST); }
"static"    { printf("STATIC ");    return(STATIC); }
"if"        { printf("IF ");        return(IF); }
"else"      { printf("ELSE ");      return(ELSE); }

 /* Ignore single line comments */
\/\/.* { }

 /* any identifier name */
[a-zA-Z_]([a-zA-Z_]|[0-9])* { printf("INDENTIFIER "); return(IDENTIFIER); }

 /* integer constant */
0[xX][a-fA-F0-9]+  { printf("I_CONST "); return(I_CONST); }
[0-9]+             { printf("I_CONST "); return(I_CONST); }

 /* floating point constant */
[0-9]+[Ee][+-]?[0-9]+              { printf("F_CONST "); return(F_CONST); }
[0-9]*"."[0-9]+([Ee][+-]?[0-9]+)?  { printf("F_CONST "); return(F_CONST); }
[0-9]+"."[0-9]*([Ee][+-]?[0-9]+)?  { printf("F_CONST "); return(F_CONST); }

 /* compound assignment and modification operators */
">>="  { printf("RIGHT_ASSIGN "); return(RIGHT_ASSIGN); }
"<<="  { printf("LEFT_ASSIGN ");  return(LEFT_ASSIGN); }
"+="   { printf("ADD_ASSIGN ");   return(ADD_ASSIGN); }
"-="   { printf("SUB_ASSIGN ");   return(SUB_ASSIGN); }
"*="   { printf("MUL_ASSIGN ");   return(MUL_ASSIGN); }
"/="   { printf("DIV_ASSIGN ");   return(DIV_ASSIGN); }
"%="   { printf("MOD_ASSIGN ");   return(MOD_ASSIGN); }
"&="   { printf("AND_ASSIGN ");   return(AND_ASSIGN); }
"^="   { printf("XOR_ASSIGN ");   return(XOR_ASSIGN); }
"|="   { printf("OR_ASSIGN ");    return(OR_ASSIGN); }
">>"   { printf("RIGHT_OP ");     return(RIGHT_OP); }
"<<"   { printf("LEFT_OP ");      return(LEFT_OP); }
"++"   { printf("INC_OP ");       return(INC_OP); }
"--"   { printf("DEC_OP ");       return(DEC_OP); }
"->"   { printf("PTR_OP ");       return(PTR_OP); }
"&&"   { printf("AND_OP ");       return(AND_OP); }
"||"   { printf("OR_OP ");        return(OR_OP); }
"<="   { printf("LE_OP ");        return(LE_OP); }
">="   { printf("GE_OP ");        return(GE_OP); }
"=="   { printf("EQ_OP ");        return(EQ_OP); }
"!="   { printf("NE_OP ");        return(NE_OP); }

 /* single chars */
";"    { printf(";\n"); return(';'); }
"{"    { printf("{\n"); return('{'); }
"}"    { printf("}\n"); return('}'); }
","    { printf(", "); return(','); }
":"    { printf(": "); return(':'); }
"="    { printf("= "); return('='); }
"("    { printf("( "); return('('); }
")"    { printf(") "); return(')'); }
"["    { printf("[ "); return('['); }
"]"    { printf("] "); return(']'); }
"."    { printf(". "); return('.'); }
"&"    { printf("& "); return('&'); }
"!"    { printf("! "); return('!'); }
"~"    { printf("~ "); return('~'); }
"-"    { printf("- "); return('-'); }
"+"    { printf("+ "); return('+'); }
"*"    { printf("* "); return('*'); }
"/"    { printf("/ "); return('/'); }
"%"    { printf("%% "); return('%'); }
"<"    { printf("< "); return('<'); }
">"    { printf("> "); return('>'); }
"^"    { printf("^ "); return('^'); }
"|"    { printf("| "); return('|'); }
"?"    { printf("? "); return('?'); }

[ \t\v\n\f]   { }
.             { /* ignore other characters */ }
%%
