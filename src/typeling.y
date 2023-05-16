%start file
%%
file -> File
    : item_list { File {items: $1} }
    | empty { File {items: vec![]} }
    ;

item_list -> Vec<Item>
    : item { vec![$1]}
    | item_list item { flatten($1, $2) }
    ;

item -> Item
    : function_decl { Item::Function($1) }
    | struct_decl { Item::Struct($1) }
    | enum_decl { Item::Enum($1) }
    ;

struct_decl -> StructDecl
    : "STRUCT" ident "SEMICOLON" { StructDecl }
    ;

enum_decl -> EnumDecl
    : "ENUM" ident "SEMICOLON" { EnumDecl }
    ;


function_decl -> FunctionDecl
    : function_sig block { FunctionDecl {function_sig: $1, body: $2} }
    ;

function_sig -> FunctionSig
    : "FN" ident "LPAREN" params "RPAREN" function_decl_return { FunctionSig {name: $2, params: $4, return_type: $6} }
    ;

function_decl_return -> Option<Type>
    : "RETURNS" type { Some($2) }
    | empty { None }
    ;

params -> Vec<Param>
    : empty { vec![] }
    | param_list { $1 }
    ;

param_list -> Vec<Param>
    : param { vec![$1] }
    | param_list "COMMA" param { flatten($1, $3) }
    ;

param -> Param
    : ident "COLON" type { Param {name: $1, param_type: $3} }
    ;

block -> Block
    : "LBRACE" block_contents "RBRACE" { Block {statements: $2} }
    ;

block_contents -> Vec<Statement>
    : stmt_list { $1 }
    | empty { vec![] }
    ;


stmt_list -> Vec<Statement>
    : stmt { vec![$1] }
    | stmt_list stmt { flatten($1, $2) }
    ;

stmt -> Statement
    : expr "SEMICOLON" { Statement::Expr($1) }
    | block { Statement::Block($1) }
    | if_stmt { Statement::If($1) }
    | while_stmt { Statement::While($1)}
    | return_stmt { Statement::Return($1) }
    | print_stmt { Statement::Print($1)}
    | var_decl { Statement::VarDecl($1)}
    | assign_stmt { Statement::Assign($1)}
    | function_call { Statement::FunctionCall($1)}
    ;

if_stmt -> If
    : "IF" "RPAREN" expr "LPAREN" block { If {condition: $3, then_block: $5, else_block: None} }
    | "IF" "RPAREN" expr "LPAREN" block "ELSE" block { If {condition: $3, then_block: $5, else_block: Some($7)} }
    ;

while_stmt -> While
    : "WHILE" "RPAREN" expr "LPAREN" block { While {condition: $3, body: $5} }
    ;

return_stmt -> Return
    : "RETURN" expr "SEMICOLON" { Return {value: Some($2)} }
    | "RETURN" "SEMICOLON" { Return {value: None} }
    ;

print_stmt -> Print
    : "PRINT" "RPAREN" expr "LPAREN" "SEMICOLON" { Print {value: $3} }
    ;

var_decl -> VarDecl
    : "LET" ident "COLON" type "SEMICOLON" { VarDecl {name: $2, var_type: $4, value: None} }
    | "LET" ident "COLON" type "ASSIGN" expr "SEMICOLON" { VarDecl {name: $2, var_type: $4, value: Some($6)} }
    ;

assign_stmt -> Assign
    : ident "ASSIGN" expr "SEMICOLON" { Assign {name: $1, value: $3} }
    ;

type -> Type
    : primitive_type { $1 }
    | ident { Type::Ident($1) }
    ;

primitive_type -> Type
    : "INT" { Type::Int }
    | "FLOAT" { Type::Float }
    | "STRING" { Type::String }
    | "BOOL" { Type::Bool }
    | "LPAREN" "RPAREN" { Type::Unit }
    ;

function_call -> FunctionCall
    : ident "RPAREN" arg_list "LPAREN" { FunctionCall {name: $1, args: $3} }
    ;

arg_list -> Vec<Expr>
    : expr { vec![$1]}
    | arg_list "COMMA" expr { flatten($1, $3) }
    ;

ident -> String
    : "IDENT" { String::from("temp") }
    ;

expr -> Expr
    : expr expr_op factor { Expr::BinOp(Box::new($1), $2, Box::new($3))}
    | factor { $1 }
    ;

factor -> Expr
    : factor factor_op term { Expr::BinOp(Box::new($1), $2, Box::new($3))}
    | term { $1 }
    ;

term -> Expr
    : "LPAREN" expr "RPAREN" { $2 }
    | "INT_LIT" { Expr::Int(0) }
    ;

expr_op -> BinOp
    : "PLUS" { BinOp::Add }
    | "MINUS" { BinOp::Sub }
    ;

factor_op -> BinOp
    : "TIMES" { BinOp::Mul }
    | "DIVIDE" { BinOp::Div }
    ;

empty -> Option<()>
    : { None }
    ;

%%

use crate::ast::*;

fn flatten_res<T>(lhs: Result<Vec<T>, ()>, rhs: Result<T, ()>) -> Result<Vec<T>, ()>
{
    let mut flt = lhs?;
    flt.push(rhs?);
    Ok(flt)
}

fn flatten<T>(lhs: Vec<T>, rhs: T) -> Vec<T> {
    let mut flt = lhs;
    flt.push(rhs);
    flt
}
