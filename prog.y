%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
int line=1;
int error=0;
#define YYERROR_VERBOSE

void yyerror(const char *msg)
{
	error=1;
	printf("ERROR(PARSER):line %d %s \n",line,msg);
}

%}


%token T_BEGIN T_END
%token T_DIF T_OR T_AND T_G_EQ T_L_EQ 
%token T_DIV T_MOD
%token T_NOT
%token ID INTEGER_CONSTANT
%token T_IF T_THEN T_ELSE
%token T_ASSIGN
%token T_WHILE T_DO
%token T_INTEGER T_BOOL
%token T_FUNC 
%token T_PRO
%token T_VAR
%token T_PROG
%token NEWLINE
%%

program : T_PROG ID ';' NEWLINE block '.' NEWLINE ;
block : a compound_statement ;
a : 
	| local_definition a 
	;
local_definition : 	variable_definition 
					|procedure_definition 
					|function_definition
					;
variable_definition: T_VAR  b  NEWLINE  ;
b : 
	def_some_variables ';' b 
	|def_some_variables ';'
;
def_some_variables : ID c ':' data_type ;

procedure_definition:NEWLINE procedure_header block ';'NEWLINE ;
procedure_header: T_PRO ID formal_parameters ';' NEWLINE;  
function_definition:NEWLINE function_header block ';'NEWLINE ;
function_header:T_FUNC ID formal_parameters ':' data_type ';' NEWLINE ;

formal_parameters: 
				|'(' formal_parameter d ')' 
				;
d:
	|';' formal_parameter d 
	;
formal_parameter: ID c ':' data_type ;
c: 
	|',' ID c
	;
data_type: T_INTEGER |T_BOOL  ;
statement:	  |
		  assignment 

		  |if_statement 
		  |while_statement NEWLINE
		  |proc_func_call NEWLINE
		  |compound_statement NEWLINE  
		  ;
assignment: ID T_ASSIGN expression   ;
if_statement:T_IF expression T_THEN statement f   ;

f:	|
	T_ELSE statement
	;
while_statement:T_WHILE expression T_DO NEWLINE  statement  ;
proc_func_call:	ID g ;    
g:
	'('actual_parameters')' 
	;

actual_parameters:expression e;
e:
	|','expression e
	;

compound_statement:T_BEGIN NEWLINE h  T_END NEWLINE ;
h:	
	statement k
	;
k:
	|';' statement k
	;
expression:expression  binary_operator expression  
		|unary_operator expression  
		|proc_func_call
		|'('expression')'
		|INTEGER_CONSTANT
		|ID  
		;
binary_operator: '='|T_DIF|T_OR|T_AND
		|'<'|'>'|T_G_EQ|T_L_EQ
		|UN|'*'| T_DIV|T_MOD
		;
unary_operator:T_NOT
		|UN
		;
UN:'+'|'-';				
				
%%

int main ( int argc, char **argv  )
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyparse ();
  if (error==0) printf("FINISHED PARSING AT %d LINE(s)",line);
  return 0;
  }

