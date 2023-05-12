use std::fmt::{Debug, Error, Formatter};

#[derive(PartialEq)]
pub enum Expr {
    Number(i32),
    Op(Box<Expr>, OpCode, Box<Expr>),
    Error,
}

pub enum ExprSymbol<'input> {
    NumSymbol(&'input str),
    Op(Box<ExprSymbol<'input>>, OpCode, Box<ExprSymbol<'input>>),
    Error,
}

#[derive(Copy, Clone, PartialEq)]
pub enum OpCode {
    Mul,
    Div,
    Add,
    Sub,
}

impl Debug for Expr {
    fn fmt(&self, fmt: &mut Formatter) -> Result<(), Error> {
        use self::Expr::*;
        match *self {
            Number(n) => write!(fmt, "{:?}", n),
            Op(ref l, op, ref r) => write!(fmt, "({:?} {:?} {:?})", l, op, r),
            Error => write!(fmt, "error"),
        }
    }
}

impl<'input> Debug for ExprSymbol<'input> {
    fn fmt(&self, fmt: &mut Formatter) -> Result<(), Error> {
        use self::ExprSymbol::*;
        match *self {
            NumSymbol(n) => write!(fmt, "{:?}", n),
            Op(ref l, op, ref r) => write!(fmt, "({:?} {:?} {:?})", l, op, r),
            Error => write!(fmt, "error"),
        }
    }
}

impl Debug for OpCode {
    fn fmt(&self, fmt: &mut Formatter) -> Result<(), Error> {
        use self::OpCode::*;
        match *self {
            Mul => write!(fmt, "*"),
            Div => write!(fmt, "/"),
            Add => write!(fmt, "+"),
            Sub => write!(fmt, "-"),
        }
    }
}

pub trait Visitor<T> {
    fn visit_expr(&self, expr: &Expr) -> T;
}

pub struct Calculator;

impl Calculator {
    pub fn new() -> Self {
        Calculator::default()
    }
}

impl Default for Calculator {
    fn default() -> Self {
        Calculator
    }
}

impl Visitor<i32> for Calculator {
    fn visit_expr(&self, expr: &Expr) -> i32 {
        match *expr {
            Expr::Number(n) => n,
            Expr::Op(ref l, op, ref r) => {
                let l = self.visit_expr(l);
                let r = self.visit_expr(r);
                match op {
                    OpCode::Mul => l * r,
                    OpCode::Div => l / r,
                    OpCode::Add => l + r,
                    OpCode::Sub => l - r,
                }
            }
            Expr::Error => panic!("error"),
        }
    }
}
