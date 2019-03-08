/* Compiler Theory and Design
   Devon Artist
   12/16/2018
   All the heavy lifting for the compiler done here.*/

%{

#include <string>
#include <vector>
#include <map>
#include <iostream>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

int * paraArray;
bool isFirst = true;
int firstCase = 0;
int currCase = 0;
int x[100];
int y = 0;

%}

%error-verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL
%token <type> REAL_LITERAL
%token <type> BOOL_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP NOTOP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS IF THEN ELSE OTHERS CASE ARROW ENDCASE ENDIF WHEN REAL

%type <type> type statement  reductions expression relation term remain
	factor primary variable cases negation

%%

function:
	function_header variables body ;

function_header:
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' |  error ';' ;

optional_parameters:
    parameters |
    ;

parameters:
    parameter ',' parameters |
    parameter ;

parameter:
    IDENTIFIER ':' type {symbols.insert($1,(Types)paraArray[y]); y++;} ;

variables:
    variables variable |
     ;

variable:
	IDENTIFIER ':' type IS statement
		{if(symbols.find($1,$$)) appendError(DUPLICATE_IDENTIFIER, $1); else checkAssignment($3, $5, "Variable Initialization");
		symbols.insert($1, $3);} |
		error ';' ;

type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement END ';' ;



statement:
	expression ';' |
	IF expression THEN statement ELSE statement ENDIF ';' { $$ = checkIfs($2, $4, $6);} |
	CASE expression IS cases OTHERS ARROW statement ENDCASE ';' {checkCaseExpression($2); } |
	REDUCE operator reductions ENDREDUCE ';'{$$ = $3;} ;

cases:
	cases case |
	;

case:
	WHEN INT_LITERAL ARROW statement {if(isFirst == true) { firstCase = $4; isFirst = false;} else {checkCaseClauses((Types)firstCase, $4);}} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;

expression:
	expression ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;

factor:
	factor MULOP remain  {$$ = checkArithmetic($1, $3);} |
	remain ;

remain:
    remain REMOP negation {$$ = checkRemainder($1, $3); } |
    negation ;

negation:
    NOTOP primary |
    primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL {$$ = $1;}|
	REAL_LITERAL {$$ = $1;}|
	BOOL_LITERAL {$$ = $1;}|
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;



%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
    paraArray = new (nothrow) int [argc];
	for(int i = 0; i < argc - 1; i++)
	{
        paraArray[i] = atof(argv[i+1]);
        //x[i] = atof(argv[i+1]);

	}

	firstLine();
	yyparse();
	lastLine();
	return 0;
}
