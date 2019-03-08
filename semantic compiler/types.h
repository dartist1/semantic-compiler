// Compiler Theory and Design
// Devon Artist
// 12/16/2018

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkIfs(Types express, Types tStatement, Types eStatement);
Types checkRemainder(Types left, Types right);
void checkCaseExpression(Types express);
void checkCaseClauses(Types case1, Types case2);
void checkFunctionNarrowing(Types left, Types right);
