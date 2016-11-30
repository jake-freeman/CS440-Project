%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  typedef struct node
  {
      struct node *left;
      struct node *right;
      char *token;
  } node;

  node *mknode(char *token, node *left, node *right);
  void printtree(node *tree);

  node* head;

  #define YYSTYPE struct node *
%}
%token IDENTIFIER I_CONST F_CONST
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token INT SIGNED UNSIGNED FLOAT KEY_CONST

%token IF ELSE

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start translation_unit
%%

primary_expression
  : IDENTIFIER { $$ = mknode( "INDENTIFIER", NULL, NULL ); }
  | I_CONST { $$ = mknode( "CONSTANT", NULL, NULL ); }
  | F_CONST { $$ = mknode( "CONSTANT", NULL, NULL ); }
  | '(' expression ')' { $$ = mknode( "expression", $1, NULL ); }
  ;

postfix_expression
  : primary_expression { $$ = mknode( "primary_expression", $1, NULL ); }
  | postfix_expression '[' expression ']' { $$ = mknode( "array", $1, $3 ); }
  | postfix_expression PTR_OP IDENTIFIER
  | postfix_expression INC_OP { $$ = mknode( "++", $1, NULL ); }
  | postfix_expression DEC_OP { $$ = mknode( "--", $1, NULL ); }
  ;

unary_expression
  : postfix_expression { $$ = mknode( "postfix_expression", $1, NULL ); }
  | unary_operator unary_expression { $$ = mknode( "unary op", $2, NULL ); }
  | INC_OP unary_expression { $$ = mknode( "++", $2, NULL ); }
  | DEC_OP unary_expression { $$ = mknode( "--", $2, NULL ); }
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
  | multiplicative_expression '*' unary_expression { $$ = mknode( "*", $1, $3 ); }
  | multiplicative_expression '/' unary_expression { $$ = mknode( "/", $1, $3 ); }
  | multiplicative_expression '%' unary_expression { $$ = mknode( "%", $1, $3 ); }
  ;

additive_expression
  : multiplicative_expression
  | additive_expression '+' multiplicative_expression { $$ = mknode( "+", $1, $3 ); }
  | additive_expression '-' multiplicative_expression { $$ = mknode( "-", $1, $3 ); }
  ;

shift_expression
  : additive_expression
  | shift_expression LEFT_OP additive_expression { $$ = mknode( "<<", $1, $3 ); }
  | shift_expression RIGHT_OP additive_expression { $$ = mknode( ">>", $1, $3 ); }
  ;

relational_expression
  : shift_expression
  | relational_expression '<' shift_expression { $$ = mknode( "<", $1, $3 ); }
  | relational_expression '>' shift_expression { $$ = mknode( ">", $1, $3 ); }
  | relational_expression LE_OP shift_expression { $$ = mknode( "<=", $1, $3 ); }
  | relational_expression GE_OP shift_expression { $$ = mknode( ">=", $1, $3 ); }
  ;

equality_expression
  : relational_expression
  | equality_expression EQ_OP relational_expression { $$ = mknode( "==", $1, $3 ); }
  | equality_expression NE_OP relational_expression { $$ = mknode( "!=", $1, $3 ); }
  ;

and_expression
  : equality_expression
  | and_expression '&' equality_expression { $$ = mknode( "&", $1, $3 ); }
  ;

exclusive_or_expression
  : and_expression
  | exclusive_or_expression '^' and_expression { $$ = mknode( "^", $1, $3 ); }
  ;

inclusive_or_expression
  : exclusive_or_expression
  | inclusive_or_expression '|' exclusive_or_expression { $$ = mknode( "|", $1, $3 ); }
  ;

logical_and_expression
  : inclusive_or_expression
  | logical_and_expression AND_OP inclusive_or_expression { $$ = mknode( "&&", $1, $3 ); }
  ;

logical_or_expression
  : logical_and_expression
  | logical_or_expression OR_OP logical_and_expression { $$ = mknode( "||", $1, $3 ); }
  ;

conditional_expression
  : logical_or_expression
  | logical_or_expression '?' expression ':' conditional_expression
    { $$ = mknode( "conditional ?", $1, mknode( "conditional :", $3, $5 ) ); }
  ;

assignment_expression
  : conditional_expression
  | unary_expression assignment_operator assignment_expression  { $$ = mknode( "assignment", $1, $3 ); }
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
  : assignment_expression  { $$ = mknode( "assignment_expression", $1, NULL ); }
  | expression ',' assignment_expression  { $$ = mknode( "expression, assignment_expression", $1, $3 ); }
  ;

constant_expression
  : conditional_expression
  ;

declaration
  : declaration_specifiers ';' { $$ = mknode( "declaration_specifiers", $1, NULL ); }
  | declaration_specifiers init_declarator_list ';' { $$ = mknode( "declaration", $1, $2 ); }
  ;

declaration_specifiers
  : type_specifier
  | type_specifier declaration_specifiers  { $$ = mknode( "declaration_specifier", $1, $2 ); }
  ;

init_declarator_list
  : init_declarator  { $$ = mknode( "declarator", $1, NULL ); }
  | init_declarator_list ',' init_declarator  { $$ = mknode( "declarator_list", $1, $3 ); }
  ;

init_declarator
  : declarator  { $$ = mknode( "declarator", $1, NULL ); }
  | declarator '=' initializer  { $$ = mknode( "=", $1, $3 ); }
  ;

type_specifier
  : INT       { $$ = mknode( "INT", NULL, NULL ); }
  | FLOAT     { $$ = mknode( "FLOAT", NULL, NULL ); }
  | SIGNED    { $$ = mknode( "SIGNED", NULL, NULL ); }
  | UNSIGNED  { $$ = mknode( "UNSIGNED", NULL, NULL ); }
  ;

declarator
  : pointer direct_declarator  { $$ = mknode( "*direct_declarator", $2, NULL ); }
  | direct_declarator  { $$ = mknode( "direct_declarator", $1, NULL ); }
  ;

direct_declarator
  : IDENTIFIER { $$ = mknode( "IDENTIFIER", NULL, NULL ); }
  | '(' declarator ')' { $$ = mknode( "(declarator)", $2, NULL ); }
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
  : assignment_expression { $$ = mknode( "assignment_expression", $1, NULL ); }
  | '{' initializer_list '}' { $$ = mknode( "initializer_list", $2, NULL ); }
  | '{' initializer_list ',' '}' { $$ = mknode( "initializer_list", $2, NULL ); }
  ;

initializer_list
  : initializer { $$ = mknode( "initializer", $1, NULL ); }
  | initializer_list ',' initializer { $$ = mknode( "initializer_list", $1, $3 ); }
  ;

statement
  : compound_statement { $$ = mknode( "compound_statement", $1, NULL ); }
  | expression_statement { $$ = mknode( "expression_statement", $1, NULL ); }
  | selection_statement { $$ = mknode( "selection_statement", $1, NULL ); }
  ;

compound_statement
  : '{' '}'
  | '{' statement_list '}' { $$ = mknode( "statement_list", $1, NULL ); }
  | '{' declaration_list '}' { $$ = mknode( "declaration_list", $1, NULL ); }
  | '{' declaration_list statement_list '}' { $$ = mknode( "declaration_list", $1, $2 ); }
  ;

declaration_list
  : declaration { $$ = mknode( "declaration", $1, NULL ); }
  | declaration_list declaration { $$ = mknode( "declaration", $1, $2 ); }
  ;

statement_list
  : statement { $$ = mknode( "statement", $1, NULL ); }
  | statement_list statement { $$ = mknode( "statement_list", $1, $2 ); }
  ;

expression_statement
  : ';'
  | expression ';' { $$ = mknode( "expression", $1, NULL ); }
  ;

selection_statement
  : IF '(' expression ')' statement %prec LOWER_THAN_ELSE  { $$ = mknode( "IF", $3, $5 ); }
  | IF '(' expression ')' statement ELSE statement
  ;

declaration_statement
  : declaration { $$ = mknode( "declaration", $1, NULL ); }
  | statement   { $$ = mknode( "statement", $1, NULL ); }
  ;

translation_unit
  : declaration_statement { $$ = mknode( "root_declaration_statement", $1, NULL ); }
  | translation_unit declaration_statement { head = ($$ = mknode( "", $1, $2 )); }
  ;


%%

node *mknode(char *token, node *left, node *right)
{
  /* malloc the node */
  node *newnode = (node *)malloc(sizeof(node));
  char *newstr = (char *)malloc(strlen(token)+1);
  strcpy(newstr, token);
  newnode->left = left;
  newnode->right = right;
  newnode->token = newstr;
  return(newnode);
}

void printtree(node *tree)
{
  int i;

  if (tree->left || tree->right) {
    printf("(");
  }

  printf(" %s ", tree->token);

  if (tree->left) {
    printtree(tree->left);
  } if (tree->right) {
    printtree(tree->right);
  }

  if (tree->left || tree->right) {
    printf(")");
  }
}

extern char yytext[];

void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

int main()
{
    // debugging flag
    yydebug = 1;
    if (yyparse() == 0) {
      printtree(head);
      printf("\n");
      return 0;
    }
    else {
      return 1;
    }
}
