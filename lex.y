%{dkd,
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

%}
%union { int nb; char var; }
%token tINT tVOID tIF tELSE tWHILE tRETURN tPRINT 
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tGE tLE tASSIGN tAND tOR tNOT
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA
%token <nb> tNB
%token <var> tID
%left tOR
%left tAND
%left tEQ tNE
%left tADD tSUB
%left tMUL tDIV
%right tNOT 
%start Program
%%

Program: Function_list;

Function_list:
    Function
    | Function_list Function;

Function:
    Type_specifier tID tLPAR Parameter_list tRPAR Compound_statement;

Type_specifier:
    tINT
    | tVOID;

Parameter_list:
    Parameter_declaration
    | %empty
    | Parameter_list tCOMMA Parameter_declaration;

Parameter_declaration:
    tINT tID;

Compound_statement:
    tLBRACE Statement_list tRBRACE;

Statement_list:
    Statement
    | %empty
    | Statement_list Statement;

Statement:
    Expression_statement
    | Declaration_statement
    | Compound_statement
    | Selection_statement
    | Iteration_statement
    | Return_statement
    | Print_statement;

Declaration_statement:
    tINT Declaration tSEMMI
    | tINT Declaration_statement Declaration tSEMMI;

Declaration:
    Declarator_var
    | Declarator_list tCOMMA Declarator_var;

Declarator_var: tID
    | tID tASSIGN Expression;

Expression_statement: Expression tSEMI;

Selection_statement:tIF tLPAR Expression tRPAR Statement tELSE Statement
    | tIF tLPAR Expression tRPAR Statement;

Iteration_statement: tWHILE tLPAR Expression tRPAR Statement;
 
Return_statement: tRETURN Expression tSEMI
    | tRETURN tSEMI;

Print_statement:tPRINT tLPAR Expression tRPAR tSEMI;

Expression: Assignment_expression;

Assignment_expression: Equality_expression
    | tID tASSIGN Assignment_expression
    | tID tLPAR Arguments tRPAR;

Arguments:
    Expression
    | %empty
    |Arguments tCOMMA Expression;

Equality_expression:
    Relational_expression
    | Equality_expression tEQ Relational_expression
    | Equality_expression tNE Relational_expression;

Relational_expression:
    Additive_expression
    | Relational_expression tLT Additive_expression
    | Relational_expression tGT Additive_expression
    | Relational_expression tLE Additive_expression
    | Relational_expression tGE Additive_expression;

Additive_expression:
    Multiplicative_expression
    | Additive_expression tADD Multiplicative_expression
    | Additive_expression tSUB Multiplicative_expression;

Multiplicative_expression:
    Unary_expression
    | Multiplicative_expression tMUL Unary_expression
    | Multiplicative_expression tDIV Unary_expression;

Unary_expression:
    Primary_expression
    | tSUB Unary_expression
    | tNOT Unary_expression;

Primary_expression:
    tID
    | tNB
    | tLPAR Expression tRPAR;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(void) {
    printf("Prog\n"); 
    //yydebug=1;
    yyparse();
    return 0;
}
 

