use std::{collections::HashMap, error::Error};

use cfgrammar::Span;

use crate::type_system::GADT;

pub type ParseResult<T> = Result<T, Box<dyn Error>>;

#[derive(Debug, Clone)]
pub struct File {
    pub items: Vec<Item>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum Item {
    FunctionDecl(FunctionDecl),
    TypeDecl(GADT),
    AliasDecl(AliasDecl),
}

#[derive(Debug, Clone)]
pub enum IdentType {
    Variable,
    Function,
    Type,
    Alias,
}

#[derive(Debug, Clone)]
pub struct FunctionDecl {
    pub function_sig: FunctionSig,
    pub body: Block,
    pub span: Span,
}

#[derive(Debug, PartialEq, Clone)]
pub struct FunctionSig {
    pub name: Span,
    pub proto: FunctionProto,
    pub span: Span,
}

#[derive(Debug, PartialEq, Clone)]
pub struct FunctionProto {
    pub params: Vec<Param>,
    pub return_type: Type,
    pub span: Span,
}

#[derive(Debug, PartialEq, Clone)]
pub struct Param {
    pub name: Span,
    pub param_type: Type,
    pub span: Span,
}

#[derive(Debug, PartialEq, Clone)]
pub enum Type {
    // todo: inferred
    Unit,
    Int,
    Float,
    Bool,
    String(usize),
    Ident(String),
    GADT(GADT),
}

#[derive(Debug, Clone)]
pub struct TypeDecl {
    pub name: Span,
    pub def: TypeDef,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum TypeDef {
    Unit,
    Tuple(Vec<Type>),
    Struct(Vec<StructField>),
    Enum(Vec<EnumVariant>),
}

#[derive(Debug, Clone)]
pub struct StructField {
    pub key: Span,
    pub ty: Type,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct EnumVariant {
    pub tag: Span,
    pub ty: TypeDef,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct AliasDecl {
    pub name: Span,
    pub original: Type,
    pub span: Span,
}
#[derive(Debug, Clone)]
pub struct Block {
    pub statements: Vec<Statement>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum Statement {
    Expr(Expr),
    Block(Block),
    If(If),
    While(While),
    VarDecl(VarDecl),
    Assign(Assign),
    Print(Print),
    Return(Return),
}

#[derive(Debug, Clone)]
pub struct Print {
    pub value: Expr,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct Return {
    pub value: Option<Expr>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct If {
    pub condition: Expr,
    pub then_block: Block,
    pub else_block: Option<Block>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct While {
    pub condition: Expr,
    pub body: Block,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct VarDecl {
    pub name: Span,
    pub var_type: Option<Type>,
    pub value: Option<Expr>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct Assign {
    pub name: Span,
    pub value: Expr,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub struct FunctionCall {
    pub name: Span,
    pub args: Vec<Expr>,
    pub span: Span,
}

#[derive(Debug, Clone)]
pub enum ConstructorCallArgs {
    None,
    Tuple(Vec<Expr>),
    Struct(HashMap<String, Expr>),
}

impl From<Vec<Expr>> for ConstructorCallArgs {
    fn from(args: Vec<Expr>) -> Self {
        Self::Tuple(args)
    }
}

impl From<Vec<(String, Expr)>> for ConstructorCallArgs {
    fn from(args: Vec<(String, Expr)>) -> Self {
        Self::Struct(args.into_iter().collect())
    }
}

#[derive(Debug, Clone)]
pub enum Expr {
    Int {
        value: i64,
        span: Span,
    },
    Float {
        value: f64,
        span: Span,
    },
    Bool {
        value: bool,
        span: Span,
    },
    String {
        value: String,
        span: Span,
    },
    Struct {
        name: Span,
        fields: Vec<StructField>,
        span: Span,
    },
    Enum {
        name: Span,
        variant: Span,
        fields: Vec<Expr>,
        span: Span,
    },
    Array {
        values: Vec<Expr>,
        span: Span,
    },
    Function {
        function_proto: FunctionProto,
        body: Block,
        span: Span,
    },
    Var {
        name: Span,
        span: Span,
    },
    BinOp {
        op: BinOp,
        lhs: Box<Expr>,
        rhs: Box<Expr>,
        span: Span,
    },
    UnOp {
        op: UnOp,
        expr: Box<Expr>,
        span: Span,
    },
    FunctionCall {
        name: Span,
        args: Vec<Expr>,
        span: Span,
    },
    ConstructorCall {
        name: Span,
        args: ConstructorCallArgs,
        span: Span,
    },
}

#[derive(Debug, Clone)]
pub enum BinOp {
    Add(Span),
    Sub(Span),
    Mul(Span),
    Div(Span),
    Mod(Span),
    Eq(Span),
    Neq(Span),
    Lt(Span),
    Gt(Span),
    Lte(Span),
    Gte(Span),
    And(Span),
    Or(Span),
}

#[derive(Debug, Clone)]
pub enum UnOp {
    Neg(Span),
    Not(Span),
}

#[derive(Debug, PartialEq, Clone)]
pub enum IndentationLevel {
    Tabs { amount: u32, span: Span },
    Spaces { amount: u32, span: Span },
    None,
}

pub fn slice<'a>(input: &'a str, span: &Span) -> &'a str {
    &input[span.start()..span.end()]
}
