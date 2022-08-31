%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "prog.tab.h"
extern int line;
%}

%%
[0-9]		{ 
                return INTEGER_CONSTANT; 
                }

[a-z]           { 
                return ID; 
                }

[ \t]                   ;
"begin"		{return T_BEGIN;}
"end"		{return T_END;}
"<"		{return '<';}						
"<>"		{return T_DIF;}
"or"		{return T_OR;}
"and"		{return T_AND;}
">="		{return T_G_EQ;}
"<="		{return T_L_EQ;}
"div"		{return T_DIV;}
"mod"		{return T_MOD;}
"not"		{return T_NOT;}
"if"		{return T_IF;}
"then"		{return T_THEN;}
"else"		{return T_ELSE;}
":="		{return T_ASSIGN;}
"while"		{return T_WHILE;}
"do"		{return T_DO;}
"integer"	{return T_INTEGER;}
"boolean"	{return T_BOOL;}
"function"	{return T_FUNC;}
"procedure"	{return T_PRO;}
"var"		{return T_VAR;}
"\n"		{++line; return NEWLINE;}
"program"	{return T_PROG;}
\n|.		{return yytext[0];}

%%
