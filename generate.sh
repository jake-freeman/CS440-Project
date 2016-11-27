#!/bin/sh

set -e

lex lex_c_lang.l
yacc -d -v yacc_c_lang.y
gcc lex.yy.c y.tab.c -o c_lang
