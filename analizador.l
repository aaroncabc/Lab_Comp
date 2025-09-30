%{
#include <stdio.h>
#include <string.h>

int errorCount = 0;

#define MAX_IDS 100
char *identificadores[MAX_IDS];
int idIndex = 0;

int getIdentificadorNum(char *lexema) {
    for (int i = 0; i < idIndex; i++) {
        if (strcmp(identificadores[i], lexema) == 0) {
            return i + 1;
        }
    }
    if (idIndex < MAX_IDS) {
        identificadores[idIndex] = strdup(lexema);
        idIndex++;
        return idIndex;
    }
    return -1;
}

int col = 1;
int token_start_col = 1;

#define YY_USER_ACTION \
    token_start_col = col; \
    col += yyleng; \
    for (int i = 0; i < yyleng; i++) { \
        if (yytext[i] == '\n') { yylineno++; col = 1; } \
    }
%}

%option noyywrap
%option yylineno

DIG     [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*
INT     [-+]?{DIG}+
LONG    {INT}[lL]
FLOAT   {DIG}+(\.{DIG}+)?([eE][-+]?{DIG}+)? 
IMAG    ({INT}|{FLOAT})[jJ]
STRING  \"([^"\n])*\"|\'([^'\n])*\'

%%

"and"       { printf("AND "); }
"else"      { printf("ELSE "); }
"is"        { printf("IS "); }
"return"    { printf("RETURN "); }
"break"     { printf("BREAK "); }
"for"       { printf("FOR "); }
"not"       { printf("NOT "); }
"while"     { printf("WHILE "); }
"continue"  { printf("CONTINUE "); }
"if"        { printf("IF "); }
"or"        { printf("OR "); }
"def"       { printf("DEF "); }
"import"    { printf("IMPORT "); }
"pass"      { printf("PASS "); }
"elif"      { printf("ELIF "); }
"in"        { printf("IN "); }
"print"     { printf("PRINT "); }

"**"    { printf("OP_EXP "); }
"//"    { printf("OP_DIVINT "); }
"<<"    { printf("OP_SHIFT_LEFT "); }
">>"    { printf("OP_SHIFT_RIGHT "); }
"<="    { printf("OP_LE "); }
">="    { printf("OP_GE "); }
"=="    { printf("OP_EQ "); }
"!="    { printf("OP_NE "); }
"<>"    { printf("OP_NE_ALT "); }
"+"     { printf("OP_PLUS "); }
"-"     { printf("OP_MINUS "); }
"*"     { printf("OP_MUL "); }
"/"     { printf("OP_DIV "); }
"%"     { printf("OP_MOD "); }
"<"     { printf("OP_LT "); }
">"     { printf("OP_GT "); }
"&"     { printf("OP_AND "); }
"|"     { printf("OP_OR "); }
"^"     { printf("OP_XOR "); }
"~"     { printf("OP_NOT "); }
"="     { printf("ASSIGN "); }

"("     { printf("PARABRE "); }
")"     { printf("PARCIERR "); }
"["     { printf("CORABRE "); }
"]"     { printf("CORCIERR "); }
";"     { printf("PUNTOCOMA "); }
","     { printf("COMA "); }
":"     { printf("DOSPUNTOS "); }
"."     { printf("PUNTO "); }

">>="   { printf("ASSIGN_SHR "); }
"<<="   { printf("ASSIGN_SHL "); }
"+="    { printf("ASSIGN_PLUS "); }
"-="    { printf("ASSIGN_MINUS "); }
"*="    { printf("ASSIGN_MUL "); }
"/="    { printf("ASSIGN_DIV "); }
"//="   { printf("ASSIGN_DIVINT "); }
"&="    { printf("ASSIGN_AND "); }
"|="    { printf("ASSIGN_OR "); }
"^="    { printf("ASSIGN_XOR "); }
"**="   { printf("ASSIGN_EXP "); }
"%="    { printf("ASSIGN_MOD "); }

{ID}    {
            int num = getIdentificadorNum(yytext);
            printf("ID%d=%s ", num, yytext);
        }

{LONG}  { printf("LONG=%s ", yytext); }
{IMAG}  { printf("IMAG=%s ", yytext); }
{FLOAT} { printf("FLOAT=%s ", yytext); }
{INT}   { printf("INT=%s ", yytext); }

{STRING} { printf("STRING=%s ", yytext); }

"#".*   { }

[ \t\r\n]+    { }

{DIG}+{ID}+   {
    printf("\n    ERROR (linea %d, col %d): %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

{DIG}+(\.{DIG}+){2,}   {
    printf("\n    ERROR (linea %d, col %d): %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

{DIG}+[eE][-+]?   {
    printf("\n    ERROR (linea %d, col %d): %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

{INT}[lL]{2,}   {
    printf("\n    ERROR (linea %d, col %d): %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

({INT}|{FLOAT})[jJ]{2,}   {
    printf("\n    ERROR (linea %d, col %d): %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

\"([^"\n]*)$   {
    printf("\n    ERROR (linea %d, col %d): string no cerrado\n", yylineno, token_start_col);
    errorCount++;
}

\'([^'\n]*)$   {
    printf("\n    ERROR (linea %d, col %d): string no cerrado\n", yylineno, token_start_col);
    errorCount++;
}

\?\?   {
    printf("\n    ERROR (linea %d, col %d): operador desconocido %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

.   {
    printf("\n    ERROR (linea %d, col %d): %s\n", yylineno, token_start_col, yytext);
    errorCount++;
}

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    }
    yylex();
    printf("\n\n--- Identificadores encontrados ---\n");
    for (int i = 0; i < idIndex; i++) {
        printf("Id%d=%s\n", i+1, identificadores[i]);
    }
    printf("\nTotal errores léxicos: %d\n", errorCount);
    return 0;
}
