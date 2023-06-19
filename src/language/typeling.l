
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
construct "CONSTRUCT"
case "CASE"
of "OF"

[0-9]+ "INT_LIT"
[0-9][_0-9]*\.(([0-9]+[_0-9]*)|([0-9]*))f "FLOAT_LIT"
\"([^\\\"]|\\[\'\"ntr])*\" "STRING_LIT"
true "TRUE"
false "FALSE"

\_ "WILDCARD"

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
and "AND"
or "OR"
not "NOT"

\= "ASSIGN"
\| "PIPE"
\; "SEMICOLON"
\: "COLON"
\( "LPAREN"
\) "RPAREN"

<INITIAL>\{ "LBRACE"
<INITIAL>\} "RBRACE"

\[ "LBRACKET"
\] "RBRACKET"
\, "COMMA"
\. "DOT"

i64 "INT"
f64 "FLOAT"
str "STRING"
bool "BOOL"

-> "RETURNS"
=> "ARROW"

[_a-z][_a-zA-Z0-9]* "IDENT"
[A-Z][_a-zA-Z0-9]* "TYPE_IDENT"


[\t \n]+ ;
//[^\n]*\n ;
/\*([^*]|\*[^/])*\*/ ;

%%