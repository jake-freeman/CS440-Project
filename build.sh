#!/bin/sh

set -e
set -x

# lexar / parser
lex c_lang.l
yacc -d -v c_lang.y
gcc lex.yy.c y.tab.c -o c_lang

# type checker
lex c_langCheck.l
yacc -d -v c_langCheck.y
gcc lex.yy.c y.tab.c -o c_langCheck
