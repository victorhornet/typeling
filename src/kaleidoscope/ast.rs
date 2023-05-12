use codespan;

pub type Span = codespan::Span;

#[derive(Debug, Clone, PartialEq)]
pub struct File {
    pub items: Vec<Item>,
    pub span: Span,
}

impl File {
    pub fn new(items: Vec<Item>, span: Span) -> Self {
        Self { items, span }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum Item {
    Extern(FunctionDecl),
    Function(Function),
}

#[derive(Debug, Clone, PartialEq)]
pub struct FunctionDecl {
    pub ident: Ident,
    pub args: Vec<Ident>,
    pub span: Span,
}

impl FunctionDecl {
    pub fn new(ident: Ident, args: Vec<Ident>, span: Span) -> Self {
        Self { ident, args, span }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct Function {
    pub decl: FunctionDecl,
    pub body: Expr,
    pub span: Span,
}

impl Function {
    pub fn new(decl: FunctionDecl, body: Expr, span: Span) -> Self {
        Self { decl, body, span }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum Expr {
    Ident(Ident),
    Literal(Literal),
    FunctionCall(FunctionCall),
}

#[derive(Debug, Clone, PartialEq)]
pub struct Ident {
    pub name: String,
    pub span: Span,
}

impl Ident {
    pub fn new<S: Into<String>>(name: S, span: Span) -> Self {
        Self {
            name: name.into(),
            span,
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct Literal {
    pub value: f64,
    pub span: Span,
}

impl Literal {
    pub fn new(value: f64, span: Span) -> Self {
        Self { value, span }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct FunctionCall {
    pub ident: Ident,
    pub args: Vec<Expr>,
    pub span: Span,
}

impl FunctionCall {
    pub fn new(ident: Ident, args: Vec<Expr>, span: Span) -> Self {
        Self { ident, args, span }
    }
}
