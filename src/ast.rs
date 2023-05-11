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

pub trait Visitor {
    fn visit(&self);
}

impl Visitor for Expr {
    fn visit(&self) {
        match *self {
            Expr::Number(_) => println!("visit number"),
            Expr::Op(ref l, _, ref r) => {
                l.visit();
                r.visit();
            }
            Expr::Error => println!("visit error"),
        }
    }
}
