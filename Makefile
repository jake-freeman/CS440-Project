# Makefile for simplified C language compiler
# CS 440

LEX = lex
YACC = yacc -d
CC = gcc

TARGET = c_langCheck
TARGET2 = c_lang

$(TARGET): y.tab.o lex.yy.o
	$(CC) -o $(TARGET) y.tab.o lex.yy.o

$(TARGET2): y.tab.o lex.yy.o
	$(CC) -o $(TARGET2) y.tab.o lex.yy.o

lex.yy.o: lex.yy.c y.tab.h

y.tab.c y.tab.h: $(TARGET).y
	$(YACC) -v $(TARGET).y

	y.tab.c y.tab.h: $(TARGET2).y
		$(YACC) -v $(TARGET2).y


lex.yy.c: $(TARGET).l
	$(LEX) $(TARGET).l

	lex.yy.c: $(TARGET2).l
		$(LEX) $(TARGET2).l

debug:
	$(YACC) -v -t $(TARGET).y
	$(MAKE) $(TARGET)

	$(YACC) -v -t $(TARGET2).y
	$(MAKE) $(TARGET2)

run: clean
	$(MAKE) $(TARGET)
	./$(TARGET) < test.c

	$(MAKE) $(TARGET2)
	./$(TARGET2) < test.c

run_debug: debug
	./$(TARGET) < test.c

		./$(TARGET2) < test.c

clean:
	-rm -f *.o lex.yy.c *.tab.*  $(TARGET) *.output

		-rm -f *.o lex.yy.c *.tab.*  $(TARGET2) *.output

.PHONY: clean run debug run_debug
