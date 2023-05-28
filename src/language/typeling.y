%start file

%right "ASSIGN"
%left "OR"
%left "AND"
%nonassoc "EQ" "NEQ" "LT" "GT" "LTE" "GTE"
%left "PLUS" "MINUS"
%left "TIMES" "DIVIDE" "MOD"
%nonassoc "NOT" 


%right "IDENT" "LPAREN"

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
    : "ALIAS" "IDENT" "ASSIGN" type "SEMICOLON" { Ok(AliasDecl {name: $2?.span(), original: $4?, span: $span}) }
    ;

type_decl -> ParseResult<TypeDecl>
    : "TYPE" "IDENT" type_def { Ok(TypeDecl {name: $2?.span(), def: $3?, span: $span}) }
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
    : "IDENT" "COLON" type { Ok(StructField { key: $1?.span(), ty: $3?, span: $span }) }
    ;

enum_variants -> ParseResult<Vec<EnumVariant>>
    : enum_variant { Ok(vec![$1?]) }
    | enum_variants "PIPE" enum_variant { flatten($1, $3) }
    ;

enum_variant -> ParseResult<EnumVariant>
    : "IDENT" variant_type_def { Ok(EnumVariant {tag: $1?.span(), ty: $2?, span: $span}) }
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
    : "FN" "IDENT" function_proto { Ok(FunctionSig {name: $2?.span(), proto: $3?, span: $span}) }
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
    : "IDENT" "COLON" type { Ok(Param {name: $1?.span(), param_type: $3?, span: $span}) }
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
    : "IDENT" "COLON" type "SEMICOLON" { Ok(VarDecl {name: $1?.span(), var_type: $3?, value: None, span: $span}) }
    | "IDENT" "COLON" type "ASSIGN" expr "SEMICOLON" { Ok(VarDecl {name: $1?.span(), var_type: $3?, value: Some($5?), span: $span}) }
    ;

assign_stmt -> ParseResult<Assign>
    : "IDENT" "ASSIGN" expr "SEMICOLON" { Ok(Assign {name: $1?.span(), value: $3?, span: $span}) }
    ;

type -> ParseResult<Type>
    : primitive_type { $1 }
    | "IDENT" { Ok(Type::Ident($1?.span())) }
    ;

primitive_type -> ParseResult<Type>
    : "INT" { Ok(Type::Int) } 
    | "FLOAT" { Ok(Type::Float) }
    | "STRING" { Ok(Type::String) }
    | "BOOL" { Ok(Type::Bool) }
    | "LPAREN" "RPAREN" { Ok(Type::Unit) }
    ;


args -> ParseResult<Vec<Expr>>
    : %empty { Ok(vec![]) }
    | arg_list { $1 }
    ;    

arg_list -> ParseResult<Vec<Expr>>
    : expr { Ok(vec![$1?])}
    | arg_list "COMMA" expr { flatten($1, $3) }
    ;

expr -> ParseResult<Expr>
    : expr "AND" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::And($2?.span()), rhs: Box::new($3?), span: $span})} %prec "AND"
    | expr "PLUS" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::Add($2?.span()), rhs: Box::new($3?), span: $span})} %prec "PLUS"
    | expr "MINUS" expr { Ok(Expr::BinOp {lhs: Box::new($1?), op: BinOp::Sub($2?.span()), rhs: Box::new($3?), span: $span})} %prec "MINUS"
    | expr "TIMES" expr { Ok(Expr::BinOp {lhs: Box::new($1?), op: BinOp::Mul($2?.span()), rhs: Box::new($3?), span: $span})} %prec "TIMES"
    | expr "DIVIDE" expr { Ok(Expr::BinOp {lhs: Box::new($1?), op: BinOp::Div($2?.span()), rhs: Box::new($3?), span: $span})} %prec "DIVIDE"
    | expr "MOD" expr { Ok(Expr::BinOp {lhs: Box::new($1?), op: BinOp::Mod($2?.span()), rhs: Box::new($3?), span: $span})} %prec "MOD"
    | expr "EQ" expr { Ok(Expr::BinOp {lhs: Box::new($1?), op: BinOp::Eq($2?.span()), rhs: Box::new($3?), span: $span})} %prec "EQ"
    | expr "NEQ" expr { Ok(Expr::BinOp {lhs: Box::new($1?), op: BinOp::Neq($2?.span()), rhs: Box::new($3?), span: $span})} %prec "NEQ"
    | expr "LT" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::Lt($2?.span()), rhs: Box::new($3?), span: $span})} %prec "LT"
    | expr "LTE" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::Lte($2?.span()), rhs: Box::new($3?), span: $span})} %prec "LTE" 
    | expr "GT" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::Gt($2?.span()), rhs: Box::new($3?), span: $span})} %prec "GT"
    | expr "GTE" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::Gte($2?.span()), rhs: Box::new($3?), span: $span})} %prec "GTE"
    | expr "OR" expr { Ok(Expr::BinOp{lhs: Box::new($1?), op: BinOp::Or($2?.span()), rhs: Box::new($3?), span: $span})} %prec "OR"
    | factor { $1 }
    ;

factor -> ParseResult<Expr>
    : unary_op term { Ok(Expr::UnOp{op: $1?, expr: Box::new($2?), span: $span}) }
    | array { $1 }
    | term { $1 }
    ;

array -> ParseResult<Expr>
    : "LBRACKET" array_elems "RBRACKET" { Ok(Expr::Array{values: $2?, span: $span}) }
    ;

array_elems -> ParseResult<Vec<Expr>>
    : %empty { Ok(vec![]) }
    | array_elem_list { $1 }
    ;

array_elem_list -> ParseResult<Vec<Expr>>
    : expr { Ok(vec![$1?]) }
    | array_elem_list "COMMA" expr { flatten($1, $3) }
    ;

term -> ParseResult<Expr>
    : "IDENT" { Ok( Expr::Var{name: $1?.span(), span: $span}) }
    | "IDENT" "LPAREN" args "RPAREN" { Ok( Expr::FunctionCall {name: $1?.span(), args: $3?, span: $span}) }
    | "INT_LIT" { Ok( Expr::Int{ value: $lexer.span_str($1?.span()).parse().unwrap(), span: $span}) }
    | "FLOAT_LIT" { Ok( Expr::Float{value: $lexer.span_str($1?.span()).parse().unwrap(), span: $span}) }
    | "FALSE" { Ok( Expr::Bool{value: false, span: $span}) }
    | "TRUE" { Ok( Expr::Bool{value: true, span: $span}) }
    | "STRING_LIT" { Ok( Expr::String{value: $lexer.span_str($1?.span()).to_string(), span: $span}) }
    | "LPAREN" expr "RPAREN" { $2 }
    ;

unary_op -> ParseResult<UnOp>
    : "MINUS" { Ok(UnOp::Neg($span)) }
    | "NOT" { Ok(UnOp::Not($span)) }
    ;

%%

use crate::ast::*;

fn flatten<T>(lhs: ParseResult<Vec<T>>, rhs: ParseResult<T>) -> ParseResult<Vec<T>>
{
    let mut flt = lhs?;
    flt.push(rhs?);
    Ok(flt)
}
