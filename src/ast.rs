use std::error::Error;

use cfgrammar::Span;

pub type ParseResult<T> = Result<T, Box<dyn Error>>;

#[derive(Debug)]
pub struct File {
    pub items: Vec<Item>,
    pub span: Span,
}

#[derive(Debug)]
pub enum Item {
    FunctionDecl(FunctionDecl),
    TypeDecl(TypeDecl),
}

#[derive(Debug)]
pub struct FunctionDecl {
    pub function_sig: FunctionSig,
    pub body: Block,
    pub span: Span,
}

#[derive(Debug, PartialEq)]
pub struct FunctionSig {
    pub name: Span,
    pub proto: FunctionProto,
    pub span: Span,
}

#[derive(Debug, PartialEq)]
pub struct FunctionProto {
    pub params: Vec<Param>,
    pub return_type: Type,
    pub span: Span,
}

#[derive(Debug, PartialEq)]
pub struct Param {
    pub name: Span,
    pub param_type: Type,
    pub span: Span,
}

#[derive(Debug, PartialEq)]
pub enum Type {
    Unit,
    Int,
    Float,
    Bool,
    String,
    Ident(Span),
    Array(Box<Type>),
    Function(Box<FunctionSig>),
}

#[derive(Debug)]
pub struct TypeDecl {
    pub name: Span,
    pub def: TypeDef,
    pub span: Span,
}

#[derive(Debug)]
pub enum TypeDef {
    Unit,
    Tuple(Vec<Type>),
    Struct(Vec<StructField>),
    Enum(Vec<EnumVariant>),
}

#[derive(Debug)]
pub struct StructField {
    pub key: Span,
    pub ty: Type,
    pub span: Span,
}

#[derive(Debug)]
pub struct EnumVariant {
    pub tag: Span,
    pub ty: TypeDef,
    pub span: Span,
}

#[derive(Debug)]
pub struct Alias {
    pub name: Span,
    pub original: Type,
    pub span: Span,
}
#[derive(Debug)]
pub struct Block {
    pub statements: Vec<Statement>,
    pub span: Span,
}

#[derive(Debug)]
pub enum Statement {
    Expr(Expr),
    Block(Block),
    If(If),
    While(While),
    VarDecl(VarDecl),
    Assign(Assign),
    FunctionCall(FunctionCall),
    Print(Print),
    Return(Return),
}

#[derive(Debug)]
pub struct Print {
    pub value: Expr,
    pub span: Span,
}

#[derive(Debug)]
pub struct Return {
    pub value: Option<Expr>,
    pub span: Span,
}

#[derive(Debug)]
pub struct If {
    pub condition: Expr,
    pub then_block: Block,
    pub else_block: Option<Block>,
    pub span: Span,
}

#[derive(Debug)]
pub struct While {
    pub condition: Expr,
    pub body: Block,
    pub span: Span,
}

#[derive(Debug)]
pub struct VarDecl {
    pub name: Span,
    pub var_type: Type,
    pub value: Option<Expr>,
    pub span: Span,
}

#[derive(Debug)]
pub struct Assign {
    pub name: Span,
    pub value: Expr,
    pub span: Span,
}

#[derive(Debug)]
pub struct FunctionCall {
    pub name: Span,
    pub args: Vec<Expr>,
    pub span: Span,
}

#[derive(Debug)]
pub enum Expr {
    Int(i64),
    Float(f64),
    Bool(bool),
    String(String),
    Struct(String, Vec<Expr>),
    Enum(String, String),
    Array(Vec<Expr>),
    Function(FunctionSig),
    Var(String),
    BinOp(Box<Expr>, BinOp, Box<Expr>),
    UnOp(UnOp, Box<Expr>),
    FunctionCall(FunctionCall),
}

#[derive(Debug)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Eq,
    Neq,
    Lt,
    Gt,
    Leq,
    Geq,
    And,
    Or,
}

#[derive(Debug)]
pub enum UnOp {
    Neg,
    Not,
}

#[derive(Debug, PartialEq)]
pub enum IndentationLevel {
    Tabs(u32),
    Spaces(u32),
    None,
}

pub fn slice<'a>(input: &'a str, span: &Span) -> &'a str {
    &input[span.start()..span.end()]
}
