%start file
%%
file -> ParseResult<File>
    : item_list { Ok(File {items: $1?, span: $span}) }
    | %empty { Ok(File {items: vec![], span: $span}) }
    ;

item_list -> ParseResult<Vec<Item>>
    : item { Ok(vec![$1?])}
    | item_list item { flatten($1, $2) }
    ;

item -> ParseResult<Item>
    : function_decl { Ok(Item::FunctionDecl($1?)) }
    | type_decl { Ok(Item::TypeDecl($1?)) }
    | alias_decl { Ok(Item::AliasDecl($1?)) }
    ;

alias_decl -> ParseResult<AliasDecl>
    : "ALIAS" ident "ASSIGN" type "SEMICOLON" { Ok(AliasDecl {name: $2?, original: $4?, span: $span}) }
    ;

type_decl -> ParseResult<TypeDecl>
    : "TYPE" ident type_def { Ok(TypeDecl {name: $2?, def: $3?, span: $span}) }
    ;

type_def -> ParseResult<TypeDef>
    : "SEMICOLON" { Ok(TypeDef::Unit) }
    | tuple_def "SEMICOLON" { $1 }
    | struct_def { $1 }
    | "ASSIGN" enum_variants "SEMICOLON" { Ok(TypeDef::Enum($2?)) }
    ;

tuple_def -> ParseResult<TypeDef>
    : "LPAREN" "RPAREN" { Ok(TypeDef::Tuple(vec![])) }
    | "LPAREN" tuple_params "RPAREN" { Ok(TypeDef::Tuple($2?)) }
    ;

struct_def -> ParseResult<TypeDef>
    : "LBRACE" "RBRACE" { Ok(TypeDef::Struct(vec![])) }
    | "LBRACE" struct_fields "RBRACE" { Ok(TypeDef::Struct($2?)) }
    | "LBRACE" struct_fields "COMMA" "RBRACE" { Ok(TypeDef::Struct($2?)) }
    ;

tuple_params -> ParseResult<Vec<Type>>
    : type { Ok(vec![$1?]) }
    | tuple_params "COMMA" type { flatten($1, $3) }
    ;

struct_fields -> ParseResult<Vec<StructField>>
    : struct_field { Ok(vec![$1?]) }
    | struct_fields "COMMA" struct_field { flatten($1, $3) }
    ;

struct_field -> ParseResult<StructField>
    : ident "COLON" type { Ok(StructField { key: $1?, ty: $3?, span: $span }) }
    ;

enum_variants -> ParseResult<Vec<EnumVariant>>
    : enum_variant { Ok(vec![$1?]) }
    | enum_variants "PIPE" enum_variant { flatten($1, $3) }
    ;

enum_variant -> ParseResult<EnumVariant>
    : ident variant_type_def { Ok(EnumVariant {tag: $1?, ty: $2?, span: $span}) }
    ;

variant_type_def -> ParseResult<TypeDef>
    : %empty { Ok(TypeDef::Unit)}
    | struct_def { $1 }
    | tuple_def { $1 }
    ;

function_decl -> ParseResult<FunctionDecl>
    : function_sig block { Ok(FunctionDecl {function_sig: $1?, body: $2?, span: $span}) }
    ;

function_sig -> ParseResult<FunctionSig>
    : "FN" ident function_proto { Ok(FunctionSig {name: $2?, proto: $3?, span: $span}) }
    ;

function_proto -> ParseResult<FunctionProto>
    : "LPAREN" params "RPAREN" function_decl_return { Ok(FunctionProto{params: $2?, return_type: $4?, span: $span})}
    ;

function_decl_return -> ParseResult<Type>
    : "RETURNS" type { $2 }
    | %empty { Ok(Type::Unit) }
    ;

params -> ParseResult<Vec<Param>>
    : %empty { Ok(vec![]) }
    | param_list { $1 }
    ;

param_list -> ParseResult<Vec<Param>>
    : param { Ok(vec![$1?]) }
    | param_list "COMMA" param { flatten($1, $3) }
    ;

param -> ParseResult<Param>
    : ident "COLON" type { Ok(Param {name: $1?, param_type: $3?, span: $span}) }
    ;

block -> ParseResult<Block>
    : "LBRACE" block_contents "RBRACE" { Ok(Block {statements: $2?, span: $span}) }
    ;

block_contents -> ParseResult<Vec<Statement>>
    : stmt_list { $1 }
    | %empty { Ok(vec![]) }
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
    | function_call "SEMICOLON" { Ok(Statement::FunctionCall($1?))}
    ;

if_stmt -> ParseResult<If>
    : "IF" expr block { Ok(If {condition: $2?, then_block: $3?, else_block: None, span: $span}) }
    | "IF" expr "LPAREN" block "ELSE" block { Ok(If {condition: $2?, then_block: $4?, else_block: Some($6?), span: $span}) }
    ;

while_stmt -> ParseResult<While>
    : "WHILE" expr block { Ok(While {condition: $2?, body: $3?, span: $span}) }
    ;

return_stmt -> ParseResult<Return>
    : "RETURN" expr "SEMICOLON" { Ok(Return {value: Some($2?), span: $span}) }
    | "RETURN" "SEMICOLON" { Ok(Return {value: None, span: $span}) }
    ;

print_stmt -> ParseResult<Print>
    : "PRINT" "LPAREN" expr "RPAREN" "SEMICOLON" { Ok(Print {value: $3?, span: $span}) }
    ;

var_decl -> ParseResult<VarDecl>
    : "LET" ident "COLON" type "SEMICOLON" { Ok(VarDecl {name: $2?, var_type: $4?, value: None, span: $span}) }
    | "LET" ident "COLON" type "ASSIGN" expr "SEMICOLON" { Ok(VarDecl {name: $2?, var_type: $4?, value: Some($6?), span: $span}) }
    ;

assign_stmt -> ParseResult<Assign>
    : ident "ASSIGN" expr "SEMICOLON" { Ok(Assign {name: $1?, value: $3?, span: $span}) }
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
    : ident "LPAREN" args "RPAREN" { Ok(FunctionCall {name: $1?, args: $3?, span: $span}) }
    ;

args -> ParseResult<Vec<Expr>>
    : %empty { Ok(vec![]) }
    | arg_list { $1 }
    ;    

arg_list -> ParseResult<Vec<Expr>>
    : expr { Ok(vec![$1?])}
    | arg_list "COMMA" expr { flatten($1, $3) }
    ;

ident -> ParseResult<Span>
    : "IDENT" { Ok($span) }
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
    | "INT_LIT" { Ok( Expr::Int($lexer.span_str($1?.span()).parse().unwrap())) }
    ;

expr_op -> ParseResult<BinOp>
    : "PLUS" { Ok(BinOp::Add) }
    | "MINUS" { Ok(BinOp::Sub) }
    ;

factor_op -> ParseResult<BinOp>
    : "TIMES" { Ok(BinOp::Mul) }
    | "DIVIDE" { Ok(BinOp::Div) }
    ;




%%

use crate::ast::*;
use cfgrammar::Span;

fn flatten<T>(lhs: ParseResult<Vec<T>>, rhs: ParseResult<T>) -> ParseResult<Vec<T>>
{
    let mut flt = lhs?;
    flt.push(rhs?);
    Ok(flt)
}
