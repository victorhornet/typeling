use cfgrammar::Span;

#[derive(Debug)]
pub struct File {
    pub items: Vec<Item>,
}

#[derive(Debug)]
pub enum Item {
    Function(FunctionDecl),
    Struct(StructDecl),
    Enum(EnumDecl),
}

#[derive(Debug)]
pub struct FunctionDecl {
    pub function_sig: FunctionSig,
    pub body: Block,
}

#[derive(Debug)]
pub struct FunctionSig {
    pub name: String,
    pub params: Vec<Param>,
    pub return_type: Option<Type>,
}

#[derive(Debug)]
pub struct Param {
    pub name: String,
    pub param_type: Type,
}

#[derive(Debug)]
pub enum Type {
    Unit,
    Int,
    Float,
    Bool,
    String,
    Ident(String),
    Struct(String),
    Enum(String),
    Array(Box<Type>),
    Function(Box<FunctionSig>),
}

#[derive(Debug)]
pub struct Block {
    pub statements: Vec<Statement>,
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
}

#[derive(Debug)]
pub struct Return {
    pub value: Option<Expr>,
}

#[derive(Debug)]
pub struct If {
    pub condition: Expr,
    pub then_block: Block,
    pub else_block: Option<Block>,
}

#[derive(Debug)]
pub struct While {
    pub condition: Expr,
    pub body: Block,
}

#[derive(Debug)]
pub struct VarDecl {
    pub name: String,
    pub var_type: Type,
    pub value: Option<Expr>,
}

#[derive(Debug)]
pub struct Assign {
    pub name: String,
    pub value: Expr,
}

#[derive(Debug)]
pub struct FunctionCall {
    pub name: String,
    pub args: Vec<Expr>,
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

#[derive(Debug)]
pub struct StructDecl;

#[derive(Debug)]
pub struct EnumDecl;
