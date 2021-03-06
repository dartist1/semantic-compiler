// Compiler Theory and Design
// Devon Artist
// 12/16/2018

// This file contains all of the methods to check for different errors.

#include <string>
#include <vector>
#include <iostream>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{


	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)

    {
        appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
    }


    if((lValue == REAL_TYPE) && (rValue == INT_TYPE))
    {
        appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
    }

    if(lValue == INT_TYPE && rValue == REAL_TYPE)
    {
        appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
    }



}

Types checkArithmetic(Types left, Types right)
{

	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}





    if(left == REAL_TYPE || right == REAL_TYPE )
    {
        return REAL_TYPE;


    }
    if((left == REAL_TYPE && right == INT_TYPE) || (left == INT_TYPE && right == REAL_TYPE))
    {
        appendError(GENERAL_SEMANTIC, "Function Narrowing Return");
        return MISMATCH;
    }




	return INT_TYPE;
}



Types checkRemainder(Types left, Types right)
{
    if(left == MISMATCH || right == MISMATCH)
        return MISMATCH;
    if(left == REAL_TYPE || right == REAL_TYPE)
    {
        appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
        return MISMATCH;
    }
    return INT_TYPE;
}

Types checkIfs(Types express, Types tStatement, Types eStatement)
{



    if(express != BOOL_TYPE)
    {
        appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
        return MISMATCH;
    }

    if((tStatement == INT_TYPE && eStatement != INT_TYPE) || (tStatement == REAL_TYPE && eStatement != REAL_TYPE))
    {
        appendError(GENERAL_SEMANTIC, "Then Else Types Mismatch");
        return MISMATCH;
    }



    return MISMATCH;
}



void checkCaseExpression(Types express)
{
    if(express != INT_TYPE)
    {
        appendError(GENERAL_SEMANTIC, "Case Expression Not Integer");

    }


}


void checkCaseClauses(Types case1, Types case2)
{


    if(case1 != case2)
    {
        appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
    }
}



Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{

	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}
