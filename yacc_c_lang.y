%token IDENTIFIER CONSTANT
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token INT LONG SIGNED UNSIGNED FLOAT CONST

%token IF ELSE RETURN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start translation_unit
%%

primary_expression
  : IDENTIFIER
  | CONSTANT
  | '(' expression ')'
  ;

postfix_expression
  : primary_expression
  | postfix_expression '[' expression ']'
  | postfix_expression '(' ')'
  | postfix_expression '.' IDENTIFIER
  | postfix_expression PTR_OP IDENTIFIER
  | postfix_expression INC_OP
  | postfix_expression DEC_OP
  ;

unary_expression
  : postfix_expression
  | unary_operator unary_expression
  | INC_OP unary_expression
  | DEC_OP unary_expression
  ;

unary_operator
  : '&'
  | '*'
  | '+'
  | '-'
  | '~'
  | '!'
  ;

multiplicative_expression
  : unary_expression
  | multiplicative_expression '*' unary_expression
  | multiplicative_expression '/' unary_expression
  | multiplicative_expression '%' unary_expression
  ;

additive_expression
  : multiplicative_expression
  | additive_expression '+' multiplicative_expression
  | additive_expression '-' multiplicative_expression
  ;

shift_expression
  : additive_expression
  | shift_expression LEFT_OP additive_expression
  | shift_expression RIGHT_OP additive_expression
  ;

relational_expression
  : shift_expression
  | relational_expression '<' shift_expression
  | relational_expression '>' shift_expression
  | relational_expression LE_OP shift_expression
  | relational_expression GE_OP shift_expression
  ;

equality_expression
  : relational_expression
  | equality_expression EQ_OP relational_expression
  | equality_expression NE_OP relational_expression
  ;

and_expression
  : equality_expression
  | and_expression '&' equality_expression
  ;

exclusive_or_expression
  : and_expression
  | exclusive_or_expression '^' and_expression
  ;

inclusive_or_expression
  : exclusive_or_expression
  | inclusive_or_expression '|' exclusive_or_expression
  ;

logical_and_expression
  : inclusive_or_expression
  | logical_and_expression AND_OP inclusive_or_expression
  ;

logical_or_expression
  : logical_and_expression
  | logical_or_expression OR_OP logical_and_expression
  ;

conditional_expression
  : logical_or_expression
  | logical_or_expression '?' expression ':' conditional_expression
  ;

assignment_expression
  : conditional_expression
  | unary_expression assignment_operator assignment_expression
  ;

assignment_operator
  : '='
  | MUL_ASSIGN
  | DIV_ASSIGN
  | MOD_ASSIGN
  | ADD_ASSIGN
  | SUB_ASSIGN
  | LEFT_ASSIGN
  | RIGHT_ASSIGN
  | AND_ASSIGN
  | XOR_ASSIGN
  | OR_ASSIGN
  ;

expression
  : assignment_expression
  | expression ',' assignment_expression
  ;

constant_expression
  : conditional_expression
  ;

declaration
  : declaration_specifiers ';'
  | declaration_specifiers init_declarator_list ';'
  ;

declaration_specifiers
  : type_specifier
  | type_specifier declaration_specifiers
  ;

init_declarator_list
  : init_declarator
  | init_declarator_list ',' init_declarator
  ;

init_declarator
  : declarator
  | declarator '=' initializer
  ;

type_specifier
  : INT
  | FLOAT
  | SIGNED
  | UNSIGNED
  ;

declarator
  : pointer direct_declarator
  | direct_declarator
  ;

direct_declarator
  : IDENTIFIER
  | '(' declarator ')'
  | direct_declarator '[' constant_expression ']'
  | direct_declarator '[' ']'
  | direct_declarator '(' parameter_type_list ')'
  | direct_declarator '(' identifier_list ')'
  | direct_declarator '(' ')'
  ;

pointer
  : '*'
  | '*' type_qualifier_list
  | '*' pointer
  | '*' type_qualifier_list pointer
  ;

type_qualifier_list
  : CONST
  | type_qualifier_list CONST
  ;


parameter_type_list
  : parameter_list
  ;

parameter_list
  : parameter_declaration
  | parameter_list ',' parameter_declaration
  ;

parameter_declaration
  : declaration_specifiers declarator
  | declaration_specifiers abstract_declarator
  | declaration_specifiers
  ;

identifier_list
  : IDENTIFIER
  | identifier_list ',' IDENTIFIER
  ;

abstract_declarator
  : pointer
  | direct_abstract_declarator
  | pointer direct_abstract_declarator
  ;

direct_abstract_declarator
  : '(' abstract_declarator ')'
  | '[' ']'
  | '[' constant_expression ']'
  | direct_abstract_declarator '[' ']'
  | direct_abstract_declarator '[' constant_expression ']'
  | '(' ')'
  | '(' parameter_type_list ')'
  | direct_abstract_declarator '(' ')'
  | direct_abstract_declarator '(' parameter_type_list ')'
  ;

initializer
  : assignment_expression
  | '{' initializer_list '}'
  | '{' initializer_list ',' '}'
  ;

initializer_list
  : initializer
  | initializer_list ',' initializer
  ;

statement
  : compound_statement
  | expression_statement
  | selection_statement
  ;

compound_statement
  : '{' '}'
  | '{' statement_list '}'
  | '{' declaration_list '}'
  | '{' declaration_list statement_list '}'
  ;

declaration_list
  : declaration
  | declaration_list declaration
  ;

statement_list
  : statement
  | statement_list statement
  ;

expression_statement
  : ';'
  | expression ';'
  ;

selection_statement
  : IF '(' expression ')' statement %prec LOWER_THAN_ELSE
  | IF '(' expression ')' statement ELSE statement
  ;

declaration_statement
  : declaration
  | statement
  ;

translation_unit
  : declaration_statement
  | translation_unit declaration
  ;


%%
#include <stdio.h>

extern char yytext[];

void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int main()
{
    yyparse();
}