%%
fn "FN"
return "RETURN"
if "IF"
else "ELSE"
while "WHILE"
print "PRINT"
type "TYPE"
alias "ALIAS"
let "LET"

[-+]?[0-9]+ "INT_LIT"
[-+]?[0-9][_0-9]*\.(([0-9]+[_0-9]*)|([0-9]*)) "FLOAT_LIT"
\"[^\"]*\" "STRING_LIT"
true "TRUE"
false "FALSE"

\+ "PLUS"
\- "MINUS"
\* "TIMES"
\/ "DIVIDE"
\% "MOD"

\== "EQ"
\!= "NEQ"
\> "GT"
\< "LT"
\>= "GTE"
\<= "LTE"
\&\& "AND"
\|\| "OR"
\! "NOT"

\= "ASSIGN"
\| "PIPE"
\; "SEMICOLON"
\: "COLON"
\( "LPAREN"
\) "RPAREN"
\{ "LBRACE"
\} "RBRACE"
\[ "LBRACKET"
\] "RBRACKET"
\, "COMMA"

i64 "INT"
f64 "FLOAT"
String "STRING"
bool "BOOL"

-> "RETURNS"

[_a-zA-Z][_a-zA-Z0-9]* "IDENT"


[\t \n]+ ;
//[^\n]*\n ;
/\*([^*]|\*[^/])*\*/ ;

%%