%union{
    struct Info{
      int ival;
      float fval;
      int type;
    };

    int ival;
    float fval;
    struct Info info;
}

%token <ival> I_CONST
%token <fval> F_CONST

%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token INT SIGNED UNSIGNED FLOAT KEY_CONST

%token IF ELSE RETURN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start translation_unit
%%

primary_expression
  : IDENTIFIER
  | I_CONST {$<info.ival>$ = $1; $<info.type>$ = 1; }
  | F_CONST {$<info.fval>$ = $1; $<info.type>$ = 2; }
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
  | multiplicative_expression '*' unary_expression {  if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$ = $<info.ival>1 * $<info.ival>3;
                                                      }
                                                      if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                          $<info.type>$ = 2;
                                                          $<info.fval>$ = $<info.fval>1 * $<info.fval>3;
                                                      }
                                                      if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                          yyerror("Type mismatch: multiplying int by float.");
                                                      }
                                                      if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                          yyerror("Type mismatch: multiplying float by int.");
                                                      }
                                                   }
  | multiplicative_expression '/' unary_expression  {   if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                            $<info.type>$ = 1;
                                                            $<info.ival>$ = $<info.ival>1 / $<info.ival>3;
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                             $<info.type>$ = 2;
                                                             $<info.fval>$ = $<info.fval>1 / $<info.fval>3;
                                                        }
                                                        if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: dividing int by float.");
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: dividing float by int.");
                                                        }
                                                     }
  | multiplicative_expression '%' unary_expression  { if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$ = $<info.ival>1 % $<info.ival>3;
                                                      }
                                                      if ($<info.type>1 == 2 || $<info.type>3 == 2) {
                                                          yyerror("Type mismatch: modulus operation on float.");
                                                      }
                                                     }
  ;

additive_expression
  : multiplicative_expression
  | additive_expression '+' multiplicative_expression  {  if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                             $<info.type>$ = 1;
                                                             $<info.ival>$  = $<info.ival>1 + $<info.ival>3;
                                                          }
                                                          if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                             $<info.type>$ = 2;
                                                             $<info.fval>$   = $<info.fval>1 + $<info.fval>3;
                                                          }
                                                          if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                              yyerror("Type mismatch: adding int and float.");
                                                          }
                                                          if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                              yyerror("Type mismatch: adding float and int.");
                                                          }
                                                     }
  | additive_expression '-' multiplicative_expression  { if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>1 - $<info.ival>3;
                                                      }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>1 - $<info.fval>3;
                                                        }
                                                        if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: subtracting float from int.");
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: subtracting int from float.");
                                                        }
                                                     }
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
  | unary_expression assignment_operator assignment_expression { if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>3;
                                                      }
                                                      if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>3;
                                                        }
                                                        if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: assignment float to int.");
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: assignment int to float.");
                                                        }
                                                     }
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
  : KEY_CONST
  | type_qualifier_list KEY_CONST
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
  | translation_unit declaration_statement
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
    // debugging flag
    yydebug = 1;
    yyparse();
}
