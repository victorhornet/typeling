use crate::ast::*;

use super::Visitor;

pub struct TypeChecker;

impl TypeChecker {
    pub fn new() -> Self {
        Self
    }
    pub fn check(&mut self, file: &File) -> TypeCheckResult<()> {
        //todo find all type check results
        self.visit_file(file)
    }
}
impl Visitor<TypeCheckResult<Type>> for TypeChecker {
    fn visit_expr(&mut self, expr: &Expr) -> TypeCheckResult<Type> {
        match expr {
            Expr::Int { .. } => Ok(Type::Int),
            Expr::BinOp { lhs, op, rhs, .. } => {
                let lhs_type = self.visit_expr(lhs);
                let rhs_type = self.visit_expr(rhs);
                binop_type(op, (lhs_type?, rhs_type?))
            }
            _ => unimplemented!(),
        }
    }
}

fn binop_type(binop: &BinOp, ops: (Type, Type)) -> TypeCheckResult<Type> {
    match binop {
        BinOp::Add(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::String, Type::String) => Ok(Type::String),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Sub(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Mul(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Div(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Mod(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::And() => match ops {
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Or() => match ops {
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Eq(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            (Type::String, Type::String) => Ok(Type::Bool),
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Neq(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            (Type::String, Type::String) => Ok(Type::Bool),
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Lt(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Gt(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Lte(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        BinOp::Gte(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::TypeMismatch(ops)),
        },
        _ => Err(TypeCheckError::Unimplemented),
    }
}

type TypeCheckResult<T> = Result<T, TypeCheckError>;
pub enum TypeCheckError {
    TypeMismatch((Type, Type)),
    Unimplemented,
}
