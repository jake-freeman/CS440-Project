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
%token IDENTIFIER
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
  | postfix_expression INC_OP {if ($<info.type>1 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$ = $<info.ival>2 + 1;
                                                        }
                                                        if ($<info.type>1 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>2 + 1;
                                                        } }
  | postfix_expression DEC_OP                          {if ($<info.type>1 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>2 - 1;
                                                        }
                                                        if ($<info.type>1 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>2 - 1;
                                                        } }
  ;

unary_expression
  : postfix_expression
  | unary_operator unary_expression
  | INC_OP unary_expression               {if ($<info.type>2 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>2 + 1;
                                                        }
                                                        if ($<info.type>2 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>2 + 1;
                                                        } }
  | DEC_OP unary_expression               {if ($<info.type>2 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>2 - 1;
                                                        }
                                                        if ($<info.type>2 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>2 - 1;
                                                        } }
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
                                                          exit(1);
                                                      }
                                                      if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                          yyerror("Type mismatch: multiplying float by int.");
                                                          exit(1);
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
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: dividing float by int.");
                                                            exit(1);
                                                        }
                                                     }
  | multiplicative_expression '%' unary_expression  { if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$ = $<info.ival>1 % $<info.ival>3;
                                                      }
                                                      if ($<info.type>1 == 2 || $<info.type>3 == 2) {
                                                          yyerror("Type mismatch: modulus operation on float.");
                                                          exit(1);
                                                      }
                                                     }
  ;

additive_expression
  : multiplicative_expression
  | additive_expression '+' multiplicative_expression  {
                                                          if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                                             $<info.type>$ = 1;
                                                             $<info.ival>$  = $<info.ival>1 + $<info.ival>3;
                                                          }
                                                          if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                             $<info.type>$ = 2;
                                                             $<info.fval>$   = $<info.fval>1 + $<info.fval>3;
                                                          }
                                                          if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                              yyerror("Type mismatch: adding int and float.");
                                                              exit(1);

                                                          }
                                                          if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                              yyerror("Type mismatch: adding float and int.");
                                                              exit(1);
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
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: subtracting int from float.");
                                                            exit(1);
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
  | relational_expression '<' shift_expression  {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: relating float to int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: relating int to float.");
                                                            exit(1);
                                                        }
                                                     }
  | relational_expression '>' shift_expression       {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: relating float to int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: relating int to float.");
                                                            exit(1);
                                                        }
                                                     }
  | relational_expression LE_OP shift_expression
  | relational_expression GE_OP shift_expression
  ;

equality_expression
  : relational_expression
  | equality_expression EQ_OP relational_expression     {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: equating float to int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: equating int to float.");
                                                            exit(1);
                                                        }
                                                     }
  | equality_expression NE_OP relational_expression
  ;

and_expression
  : equality_expression
  | and_expression '&' equality_expression              {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: ANDing float with int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: ANDing int with float.");
                                                            exit(1);
                                                        }
                                                     }
  ;

exclusive_or_expression
  : and_expression
  | exclusive_or_expression '^' and_expression        {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: XORing float with int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: XORing int with float.");
                                                            exit(1);
                                                        }
                                                     }
  ;

inclusive_or_expression
  : exclusive_or_expression
  | inclusive_or_expression '|' exclusive_or_expression   {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: ORing float with int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: ORing int with float.");
                                                            exit(1);
                                                        }
                                                     }
  ;

logical_and_expression
  : inclusive_or_expression
  | logical_and_expression AND_OP inclusive_or_expression   {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: ANDing float with int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: ANDing int with float.");
                                                            exit(1);
                                                        }
                                                     }
  ;

logical_or_expression
  : logical_and_expression
  | logical_or_expression OR_OP logical_and_expression    {       if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                                            yyerror("Type mismatch: ORing float to int.");
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: ORing int to float.");
                                                            exit(1);
                                                        }
                                                     }
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
                                                            exit(1);
                                                        }
                                                        if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                                            yyerror("Type mismatch: assignment int to float.");
                                                            exit(1);
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
  | declaration_specifiers init_declarator_list ';'   { if ($<info.type>1 == 1 && $<info.type>2 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>2;
                                                      }
                                                      if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>2;
                                                        }}
  ;

declaration_specifiers
  : type_specifier
  | type_specifier declaration_specifiers { if ($<info.type>1 == 1 && $<info.type>2 == 1){
                                                          $<info.type>$ = 1;
                                                          $<info.ival>$  = $<info.ival>2;
                                                      }
                                                      if ($<info.type>1 == 2 && $<info.type>2 == 2) {
                                                           $<info.type>$ = 2;
                                                           $<info.fval>$ = $<info.fval>2;
                                                        }}
  ;

init_declarator_list
  : init_declarator
  | init_declarator_list ',' init_declarator
  ;

init_declarator
  : declarator
  | declarator '=' initializer { if ($<info.type>1 == 1 && $<info.type>3 == 1){
                                      $<info.type>$ = 1;
                                      $<info.ival>$  = $<info.ival>3;
                                  }
                                  if ($<info.type>1 == 2 && $<info.type>3 == 2) {
                                       $<info.type>$ = 2;
                                       $<info.fval>$ = $<info.fval>3;
                                  }
                                  if ($<info.type>1 == 1 && $<info.type>3 == 2) {
                                        yyerror("Type mismatch: assignment float to int.");
                                        exit(1);
                                  }
                                  if ($<info.type>1 == 2 && $<info.type>3 == 1) {
                                        yyerror("Type mismatch: assignment int to float.");
                                        exit(1);
                                  }
                                }
  ;

type_specifier
  : INT       { $<info.type>$ = 1; }
  | FLOAT     { $<info.type>$ = 2; }
  | SIGNED    { $<info.type>$ = 1; }
  | UNSIGNED  { $<info.type>$ = 1; }
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
    fprintf(stderr,"error: %s\n",str,__LINE__);
}
int main()
{
    // debugging flag
    yydebug = 1;
    yyparse();
}
