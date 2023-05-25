use crate::ast::*;

use super::Visitor;

pub struct TypeCheck;

impl TypeCheck {}
impl Visitor<TypeCheckResult<Type>> for TypeCheck {
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
        _ => Err(TypeCheckError::Unimplemented),
    }
}

type TypeCheckResult<T> = Result<T, TypeCheckError>;
pub enum TypeCheckError {
    TypeMismatch((Type, Type)),
    Unimplemented,
}
