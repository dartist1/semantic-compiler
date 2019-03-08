/* Compiler Theory and Design
   Devon Artist
   12/16/2018 */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
real    {digit}+"."{digit}*
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="    { ECHO; return(RELOP); }
"<="    { ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"-"     { ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"rem"   { ECHO; return (REMOP); }
"="     { ECHO; return(RELOP); }
"=>"    {ECHO; return(ARROW); }
"not"   { ECHO; return(NOTOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case        { ECHO; return(CASE); }
else        {ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase     {ECHO; return(ENDCASE); }
endreduce	{ ECHO; return(ENDREDUCE); }
false       { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
if      { ECHO; return(IF); }
is		{ ECHO; return(IS); }
others  { ECHO; return(OTHERS); }
real    { ECHO; return(REAL); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
then        {ECHO; return(THEN); }
true        { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
when        { ECHO; return(WHEN); }
endif   { ECHO; return(ENDIF); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real}      { ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
