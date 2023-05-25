use crate::ast::*;

use super::Visitor;

pub struct TypeCheck;

impl TypeCheck {}
impl Visitor<Option<Type>> for TypeCheck {
    fn visit_expr(&mut self, expr: &Expr) -> Option<Type> {
        match expr {
            Expr::Int(_) => Some(Type::Int),
            Expr::BinOp(lhs, op, rhs) => {
                let lhs_type = self.visit_expr(lhs);
                let rhs_type = self.visit_expr(rhs);
                binop_type(op, (lhs_type?, rhs_type?))
            }
            _ => None,
        }
    }
}

fn binop_type(binop: &BinOp, ops: (Type, Type)) -> Option<Type> {
    match binop {
        BinOp::Add => match ops {
            (Type::Int, Type::Int) => Some(Type::Int),
            _ => None,
        },
        BinOp::Sub => match ops {
            (Type::Int, Type::Int) => Some(Type::Int),
            _ => None,
        },
        BinOp::Mul => match ops {
            (Type::Int, Type::Int) => Some(Type::Int),
            _ => None,
        },

        BinOp::Div => match ops {
            (Type::Int, Type::Int) => Some(Type::Int),
            _ => None,
        },
        _ => unimplemented!("Type error"),
    }
}

type TypeCheckResult<T> = Result<T, TypeCheckError>;
enum TypeCheckError {
    TypeMismatch,
    Unimplemented,
}
