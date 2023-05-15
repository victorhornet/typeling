%start file
%%
file 
    : item_list
    | empty
    ;

item_list 
    : item 
    | item_list item
    ;

item 
    : function_decl
    ;

function_decl
    : function_sig block
    ;

function_sig
    : "FN" ident "LPAREN" sig_args "RPAREN" function_decl_return
    ;

function_decl_return
    : "RETURNS" type
    | empty
    ;

sig_args    
    : empty
    | sig_arg_list
    ;

sig_arg_list
    : sig_arg
    | sig_arg_list "COMMA" sig_arg
    ;

sig_arg
    : ident "COLON" type
    ;

block
    : "LBRACE" block_contents "RBRACE"
    ;

block_contents
    : stmt_list
    | empty
    ;


stmt_list
    : stmt
    | stmt_list stmt
    ;

stmt
    : expr "SEMICOLON"
    | block
    | if_stmt
    | while_stmt
    | return_stmt
    | print_stmt
    | var_decl
    | assign_stmt
    | function_call
    ;

if_stmt
    : "IF" "RPAREN" expr "LPAREN" block
    | "IF" "RPAREN" expr "LPAREN" block "ELSE" block
    ;

while_stmt
    : "WHILE" "RPAREN" expr "LPAREN" block
    ;

return_stmt
    : "RETURN" expr "SEMICOLON"
    ;

print_stmt
    : "PRINT" "RPAREN" expr "LPAREN" "SEMICOLON"
    ;

var_decl
    : "LET" ident "COLON" type "SEMICOLON"
    | "LET" ident "COLON" type "ASSIGN" expr "SEMICOLON"
    ;

assign_stmt
    : ident "ASSIGN" expr "SEMICOLON"
    ;

type
    : primitive_type
    | compound_type
    | ident
    ;

primitive_type
    : "INT"
    | "FLOAT"
    | "STRING"
    | "BOOL"
    | unit_type;

unit_type
    : "LPAREN" "RPAREN"
    ;

compound_type
    : ident "LT" type_list "GT"
    ;

type_list
    : type
    | type_list "COMMA" type
    ;

function_call
    : ident "RPAREN" arg_list "LPAREN"
    ;

arg_list
    : expr
    | arg_list "COMMA" expr
    ;

ident
    : "IDENT"
    ;

expr: empty;

empty: ;
%%
