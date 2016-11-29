# Makefile for simplified C language compiler
# CS 440

LEX = lex
YACC = yacc -d
CC = gcc

TARGET = c_lang

$(TARGET): y.tab.o lex.yy.o
	$(CC) -o $(TARGET) y.tab.o lex.yy.o

lex.yy.o: lex.yy.c y.tab.h

y.tab.c y.tab.h: $(TARGET).y
	$(YACC) -v $(TARGET).y

lex.yy.c: $(TARGET).l
	$(LEX) $(TARGET).l

debug:
	$(YACC) -v -t $(TARGET).y
	$(MAKE) $(TARGET)

run: clean
	$(MAKE) $(TARGET)
	./$(TARGET) < test.c

run_debug: debug
	./$(TARGET) < test.c

clean:
	-rm -f *.o lex.yy.c *.tab.*  $(TARGET) *.output

.PHONY: clean run debug run_debug
