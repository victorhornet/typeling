%start file

%right "ASSIGN"
%left "OR"
%left "AND"
%nonassoc "EQ" "NEQ" "LT" "GT" "LTE" "GTE"
%left "PLUS" "MINUS"
%left "TIMES" "DIVIDE" "MOD"
%left "DOT"
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
    : "ALIAS" "IDENT" "ASSIGN" type { Ok(AliasDecl {name: $2?.span(), original: $4?, span: $span}) }
    ;

type_decl -> ParseResult<GADT>
    : "TYPE" "IDENT" generics type_def {
        let name = $lexer.span_str($2?.span()).to_string();
        let generics = $3?;
        let constructors = $4?;
        let mut gadt = GADT::new(name, generics, constructors);
        gadt.replace_shorthand().map_err(|name| Box::new(ParseError::DuplicateTypeConstructor(name)))?;
        Ok(gadt) 
    }
    ;

generics -> ParseResult<Vec<String>>
    : %empty { Ok(vec![]) }
    | generic_list { $1 }
    ;

generic_list -> ParseResult<Vec<String>>
    : "IDENT" { Ok(vec![ $lexer.span_str($1?.span()).to_string() ]) }
    | generic_list "IDENT" { flatten($1, Ok($lexer.span_str($2?.span()).to_string())) }
    ;

type_def -> ParseResult<HashMap<String, GADTConstructor>>
    : shorthand_def { $1 }
    | "ASSIGN" type_constructors { $2 }
    ;

type_constructors -> ParseResult<HashMap<String, GADTConstructor>>
    : type_constructor { 
        let mut map = HashMap::new();
        let constructor = $1?;
        map.insert(constructor.clone().get_name().to_string(), constructor);
        Ok(map)
    }
    | type_constructors "PIPE" type_constructor { 
        let mut map = $1?;
        let constructor = $3?;
        let name = constructor.get_name().to_string();
        if map.contains_key(&name) {
            return Err(Box::new(ParseError::DuplicateTypeConstructor(name)));
        }
        map.insert(name, constructor);
        Ok(map)
    }
    ;

type_constructor -> ParseResult<GADTConstructor>
    : "IDENT" type_constructor_params { 
        Ok(GADTConstructor::new($lexer.span_str($1?.span()),  $2?)) 
    }
    | "IDENT" shorthand_def { 
        let mut constructor = $2?.get("@").unwrap().clone();
        let name = $lexer.span_str($1?.span()).to_string();
        constructor.set_name(&name);
        Ok(constructor)
     }
    ;


type_constructor_params -> ParseResult<GADTConstructorFields>
    : anonymous_type_constructor_param_list { 
        Ok(GADTConstructorFields::from($1?)) 
    }
    | named_type_constructor_param_list { 
        Ok(GADTConstructorFields::from($1?))
    }
    ;

anonymous_type_constructor_param_list -> ParseResult<Vec<Type>>
    : type { Ok(vec![$1?]) }
    | anonymous_type_constructor_param_list type { flatten($1, $2) }
    ;

named_type_constructor_param_list -> ParseResult<Vec<(&'input str, Type)>>
    : named_field { Ok(vec![$1?]) }
    | named_type_constructor_param_list named_field { flatten($1, $2) }
    ;

shorthand_def -> ParseResult<HashMap<String, GADTConstructor>>
    : %empty { 
        let mut map = HashMap::new();
        map.insert("@".to_owned(), GADTConstructorBuilder::new("@").unit_fields().build());
        Ok(map) 
    }
    | "LPAREN" tuple_params "RPAREN" { 
        let mut map = HashMap::new();
        map.insert("@".to_owned(), GADTConstructorBuilder::new("@").unit_fields().build());
        Ok(map) 
    }
    | struct_def { 
        let mut map = HashMap::new();
        map.insert("@".to_owned(), $1?);
        Ok(map) 
    }
    ;

struct_def -> ParseResult<GADTConstructor>
    : "LBRACE" "RBRACE" { Ok(GADTConstructorBuilder::new("@").unit_fields().build()) }
    | "LBRACE" struct_fields "RBRACE" { Ok(GADTConstructorBuilder::new("@").struct_fields(&$2?).build()) }
    | "LBRACE" struct_fields "COMMA" "RBRACE" { Ok(GADTConstructorBuilder::new("@").struct_fields(&$2?).build()) }
    ;

tuple_params -> ParseResult<Vec<Type>>
    : type { Ok(vec![$1?]) }
    | tuple_params "COMMA" type { flatten($1, $3) }
    ;

struct_fields -> ParseResult<Vec<(&'input str, Type)>>
    : named_field { Ok(vec![$1?]) }
    | struct_fields "COMMA" named_field { flatten($1, $3) }
    ;

named_field -> ParseResult<(&'input str, Type)>
    : "IDENT" "COLON" type { Ok(($lexer.span_str($1?.span()), $3?)) }
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
    : "IDENT" "COLON" type "SEMICOLON" { Ok(VarDecl {name: $1?.span(), var_type: Some($3?), value: None, span: $span}) }
    | "IDENT" "COLON" type "ASSIGN" expr "SEMICOLON" { Ok(VarDecl {name: $1?.span(), var_type: Some($3?), value: Some($5?), span: $span}) }
    | "IDENT" "COLON" "ASSIGN" expr "SEMICOLON" { Ok(VarDecl {name: $1?.span(), var_type: None, value: Some($4?), span: $span}) }
    ;

assign_stmt -> ParseResult<Assign>
    : assignable_expr "ASSIGN" expr "SEMICOLON" { Ok(Assign {target: $1?, value: $3?, span: $span}) }
    ;

type -> ParseResult<Type>
    : primitive_type { $1 }
    | "IDENT" { Ok(Type::Ident($lexer.span_str($1?.span()).to_string())) }
    ;

primitive_type -> ParseResult<Type>
    : "INT" { Ok(Type::Int) } 
    | "FLOAT" { Ok(Type::Float) }
    | "STRING" { Ok(Type::String($1?.span().len() - 2)) }
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

member_access -> ParseResult<Expr>
    : assignable_expr "DOT" "IDENT" { Ok(Expr::MemberAccess{expr: Box::new($1?), member: MemberAccessType::Field($3?.span()), span: $span}) } %prec "DOT"
    | assignable_expr "DOT" "INT_LIT" { Ok(Expr::MemberAccess{expr: Box::new($1?), member: MemberAccessType::Index($3?.span()), span: $span}) } %prec "DOT"
    ;

factor -> ParseResult<Expr>
    : unary_op term { Ok(Expr::UnOp{op: $1?, expr: Box::new($2?), span: $span}) }
    | term { $1 }
    ;

assignable_expr -> ParseResult<Expr>
    : "IDENT" { Ok( Expr::Var{name: $1?.span(), span: $span}) }
    | member_access { $1 }
    | array { $1 }
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
    : assignable_expr { $1 }
    | "IDENT" "LPAREN" args "RPAREN" { Ok( Expr::FunctionCall {name: $1?.span(), args: $3?, span: $span}) }
    | "CONSTRUCT" "IDENT" { Ok(Expr::ConstructorCall {name: $2?.span(), args: ConstructorCallArgs::None, span: $span}) }
    | "CONSTRUCT" "IDENT" "LPAREN" array_elem_list "RPAREN" { Ok(Expr::ConstructorCall {name: $2?.span(), args: ConstructorCallArgs::from($4?), span: $span}) }
    | "CONSTRUCT" "IDENT" "LPAREN" construct_type_arg_list_named_elems "RPAREN" { Ok(Expr::ConstructorCall {name: $2?.span(), args: ConstructorCallArgs::from($4?), span: $span}) }
    | "INT_LIT" { Ok( Expr::Int{ value: $lexer.span_str($1?.span()).parse().unwrap(), span: $span}) }
    | "FLOAT_LIT" { Ok( Expr::Float{value: $lexer.span_str($1?.span()).parse().unwrap(), span: $span}) }
    | "FALSE" { Ok( Expr::Bool{value: false, span: $span}) }
    | "TRUE" { Ok( Expr::Bool{value: true, span: $span}) }
    | "STRING_LIT" { Ok( Expr::String{value: $lexer.span_str($1?.span()).to_string(), span: $span}) }
    | "LPAREN" expr "RPAREN" { $2 }
    ;

construct_type_arg_list_named_elems -> ParseResult<Vec<(String, Expr)>>
    : construct_type_arg_list_named_elem { Ok(vec![$1?]) }
    | construct_type_arg_list_named_elems "COMMA" construct_type_arg_list_named_elem { flatten($1, $3) }
    ;

construct_type_arg_list_named_elem -> ParseResult<(String, Expr)>
    : "IDENT" "ASSIGN" expr { Ok(($lexer.span_str($1?.span()).to_string(), $3?)) }
    ;


unary_op -> ParseResult<UnOp>
    : "MINUS" { Ok(UnOp::Neg($span)) }
    | "NOT" { Ok(UnOp::Not($span)) } 
    ;

%%

use crate::ast::*;
use crate::type_system::{GADT, GADTConstructor, GADTConstructorBuilder, GADTConstructorFields};
use std::collections::HashMap;
use core::fmt::{self, Display, Formatter};
use std::error::Error;

fn flatten<T>(lhs: ParseResult<Vec<T>>, rhs: ParseResult<T>) -> ParseResult<Vec<T>>
{
    let mut flt = lhs?;
    flt.push(rhs?);
    Ok(flt)
}

fn init_map<T>(key: String, value: T) -> ParseResult<HashMap<String, T>>
{
    let mut map = HashMap::new();
    map.insert(key, value);
    Ok(map)
}


#[derive(Debug)]
pub enum ParseError {
    DuplicateTypeConstructor(String),
    DuplicateTypeConstructorParam(String),
    DuplicateFieldName(String),
}

impl Display for ParseError {
    fn fmt(&self, f: &mut Formatter) -> Result<(), fmt::Error> {
        match self {
            ParseError::DuplicateTypeConstructor(name) => {
                write!(f, "Duplicate type constructor: {}", name)
            }
            ParseError::DuplicateTypeConstructorParam(name) => {
                write!(f, "Duplicate type constructor param: {}", name)
            }
            ParseError::DuplicateFieldName(name) => {
                write!(f, "Duplicate field name: {}", name)
            }
        }
    }
}

impl Error for ParseError {
    fn description(&self) -> &str {
        match self {
            ParseError::DuplicateTypeConstructor(_) => "Duplicate type constructor",
            ParseError::DuplicateTypeConstructorParam(_) => "Duplicate type constructor param",
            ParseError::DuplicateFieldName(_) => "Duplicate field name",
        }
    }
}
