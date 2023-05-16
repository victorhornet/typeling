%start file
%%
file -> ParseResult<File>
    : item_list { Ok(File {items: $1?}) }
    | empty { Ok(File {items: vec![]}) }
    ;

item_list -> ParseResult<Vec<Item>>
    : item { Ok(vec![$1?])}
    | item_list item { flatten($1, $2) }
    ;

item -> ParseResult<Item>
    : function_decl { Ok(Item::Function($1?)) }
    | struct_decl { Ok(Item::Struct($1?)) }
    | enum_decl { Ok(Item::Enum($1?)) }
    ;

struct_decl -> ParseResult<StructDecl>
    : "STRUCT" ident "SEMICOLON" { Ok(StructDecl) }
    ;

enum_decl -> ParseResult<EnumDecl>
    : "ENUM" ident "SEMICOLON" { Ok(EnumDecl) }
    ;


function_decl -> ParseResult<FunctionDecl>
    : function_sig block { Ok(FunctionDecl {function_sig: $1?, body: $2?}) }
    ;

function_sig -> ParseResult<FunctionSig>
    : "FN" ident "LPAREN" params "RPAREN" function_decl_return { Ok(FunctionSig {name: $2?, params: $4?, return_type: $6?}) }
    ;

function_decl_return -> ParseResult<Option<Type>>
    : "RETURNS" type { Ok(Some($2?)) }
    | empty { Ok(None) }
    ;

params -> ParseResult<Vec<Param>>
    : empty { Ok(vec![]) }
    | param_list { $1 }
    ;

param_list -> ParseResult<Vec<Param>>
    : param { Ok(vec![$1?]) }
    | param_list "COMMA" param { flatten($1, $3) }
    ;

param -> ParseResult<Param>
    : ident "COLON" type { Ok(Param {name: $1?, param_type: $3?}) }
    ;

block -> ParseResult<Block>
    : "LBRACE" block_contents "RBRACE" { Ok(Block {statements: $2?}) }
    ;

block_contents -> ParseResult<Vec<Statement>>
    : stmt_list { $1 }
    | empty { Ok(vec![]) }
    ;


stmt_list -> ParseResult<Vec<Statement>>
    : stmt { Ok(vec![$1?]) }
    | stmt_list stmt { flatten($1, $2) }
    ;

stmt -> ParseResult<Statement>
    : expr "SEMICOLON" { Ok(Statement::Expr($1?)) }
    | block { Ok(Statement::Block($1?)) }
    | if_stmt { Ok(Statement::If($1?)) }
    | while_stmt { Ok(Statement::While($1?))}
    | return_stmt { Ok(Statement::Return($1?)) }
    | print_stmt { Ok(Statement::Print($1?))}
    | var_decl { Ok(Statement::VarDecl($1?))}
    | assign_stmt { Ok(Statement::Assign($1?))}
    | function_call { Ok(Statement::FunctionCall($1?))}
    ;

if_stmt -> ParseResult<If>
    : "IF" "RPAREN" expr "LPAREN" block { Ok(If {condition: $3?, then_block: $5?, else_block: None}) }
    | "IF" "RPAREN" expr "LPAREN" block "ELSE" block { Ok(If {condition: $3?, then_block: $5?, else_block: Some($7?)}) }
    ;

while_stmt -> ParseResult<While>
    : "WHILE" "RPAREN" expr "LPAREN" block { Ok(While {condition: $3?, body: $5?}) }
    ;

return_stmt -> ParseResult<Return>
    : "RETURN" expr "SEMICOLON" { Ok(Return {value: Some($2?)}) }
    | "RETURN" "SEMICOLON" { Ok(Return {value: None}) }
    ;

print_stmt -> ParseResult<Print>
    : "PRINT" "RPAREN" expr "LPAREN" "SEMICOLON" { Ok(Print {value: $3?}) }
    ;

var_decl -> ParseResult<VarDecl>
    : "LET" ident "COLON" type "SEMICOLON" { Ok(VarDecl {name: $2?, var_type: $4?, value: None}) }
    | "LET" ident "COLON" type "ASSIGN" expr "SEMICOLON" { Ok(VarDecl {name: $2?, var_type: $4?, value: Some($6?)}) }
    ;

assign_stmt -> ParseResult<Assign>
    : ident "ASSIGN" expr "SEMICOLON" { Ok(Assign {name: $1?, value: $3?}) }
    ;

type -> ParseResult<Type>
    : primitive_type { $1 }
    | ident { Ok(Type::Ident($1?)) }
    ;

primitive_type -> ParseResult<Type>
    : "INT" { Ok(Type::Int) }
    | "FLOAT" { Ok(Type::Float) }
    | "STRING" { Ok(Type::String) }
    | "BOOL" { Ok(Type::Bool) }
    | "LPAREN" "RPAREN" { Ok(Type::Unit) }
    ;

function_call -> ParseResult<FunctionCall>
    : ident "RPAREN" arg_list "LPAREN" { Ok(FunctionCall {name: $1?, args: $3?}) }
    ;

arg_list -> ParseResult<Vec<Expr>>
    : expr { Ok(vec![$1?])}
    | arg_list "COMMA" expr { flatten($1, $3) }
    ;

ident -> ParseResult<String>
    : "IDENT" { Ok(String::from("temp")) }
    ;

expr -> ParseResult<Expr>
    : expr expr_op factor { Ok(Expr::BinOp(Box::new($1?), $2?, Box::new($3?)))}
    | factor { $1 }
    ;

factor -> ParseResult<Expr>
    : factor factor_op term { Ok(Expr::BinOp(Box::new($1?), $2?, Box::new($3?)))}
    | term { $1 }
    ;

term -> ParseResult<Expr>
    : "LPAREN" expr "RPAREN" { $2 }
    | "INT_LIT" { Ok(Expr::Int(0)) }
    ;

expr_op -> ParseResult<BinOp>
    : "PLUS" { Ok(BinOp::Add) }
    | "MINUS" { Ok(BinOp::Sub) }
    ;

factor_op -> ParseResult<BinOp>
    : "TIMES" { Ok(BinOp::Mul) }
    | "DIVIDE" { Ok(BinOp::Div) }
    ;

empty -> ParseResult<Option<()>>
    : { Ok(None) }
    ;

%%

use crate::ast::*;

fn flatten<T>(lhs: ParseResult<Vec<T>>, rhs: ParseResult<T>) -> ParseResult<Vec<T>>
{
    let mut flt = lhs?;
    flt.push(rhs?);
    Ok(flt)
}


