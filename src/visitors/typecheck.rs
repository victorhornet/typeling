use std::collections::HashMap;

use cfgrammar::Span;

use crate::ast::*;

use super::Visitor;

#[derive(Default)]
pub struct TypeChecker {
    vars: HashMap<Span, Type>,
}

impl TypeChecker {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn check(&mut self, file: &File) -> TypeCheckResult<()> {
        //todo find all type check results
        self.visit_file(file)?;
        Ok(())
    }
}
impl Visitor<TCResult> for TypeChecker {
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> TCResult {
        self.vars.insert(var_decl.name, var_decl.var_type.clone());
        Ok(None)
    }
    fn visit_assign(&mut self, assign: &Assign) -> TCResult {
        let expr_type = self
            .visit_expr(&assign.value)?
            .expect("expr must have a type");
        let var_type = self
            .vars
            .get(&assign.name)
            .cloned()
            .ok_or(TypeCheckError::UndefinedVariable(assign.name))?;
        if expr_type != var_type {
            return Err(TypeCheckError::AssignTypeMismatch {
                expected: var_type,
                found: expr_type,
            });
        }
        Ok(None)
    }
    fn visit_expr(&mut self, expr: &Expr) -> TCResult {
        match expr {
            Expr::Int { .. } => Ok(Some(Type::Int)),
            Expr::Float { .. } => Ok(Some(Type::Float)),
            Expr::String { value, .. } => Ok(Some(Type::String(value.len() - 2))),
            Expr::Bool { .. } => Ok(Some(Type::Bool)),
            Expr::Var { name, .. } => self
                .vars
                .get(name)
                .cloned()
                .ok_or(TypeCheckError::UndefinedVariable(name.to_owned()))
                .map(Some),
            Expr::BinOp { lhs, op, rhs, .. } => {
                let lhs_type = self.visit_expr(lhs);
                let rhs_type = self.visit_expr(rhs);
                Ok(Some(binop_type(
                    op,
                    (
                        lhs_type?.expect("expr must have a type"),
                        rhs_type?.expect("expr must have a type"),
                    ),
                )?))
            }
            Expr::UnOp { op, expr, .. } => {
                let expr_type = self.visit_expr(expr);
                Ok(Some(unop_type(
                    op,
                    expr_type?.expect("expr must have a type"),
                )?))
            }
            _ => unimplemented!(),
        }
    }
}

fn binop_type(binop: &BinOp, ops: (Type, Type)) -> TypeCheckResult<Type> {
    match binop {
        BinOp::Add(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::String(s1), Type::String(s2)) => Ok(Type::String(s1 + s2)),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Sub(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Mul(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Div(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::Float, Type::Float) => Ok(Type::Float),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Mod(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::And(_) => match ops {
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Or(_) => match ops {
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Eq(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            (Type::String(_), Type::String(_)) => Ok(Type::Bool),
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Neq(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            (Type::String(_), Type::String(_)) => Ok(Type::Bool),
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Lt(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Gt(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Lte(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Gte(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
    }
}

fn unop_type(unop: &UnOp, op: Type) -> TypeCheckResult<Type> {
    match unop {
        UnOp::Not(_) => match op {
            Type::Bool => Ok(Type::Bool),
            t => Err(TypeCheckError::UnOpTypeMismatch(t)),
        },
        UnOp::Neg(_) => match op {
            Type::Int => Ok(Type::Int),
            Type::Float => Ok(Type::Float),
            t => Err(TypeCheckError::UnOpTypeMismatch(t)),
        },
    }
}

type TypeCheckResult<T> = Result<T, TypeCheckError>;
type TCResult = TypeCheckResult<Option<Type>>;

#[derive(Debug)]
pub enum TypeCheckError {
    AssignTypeMismatch { expected: Type, found: Type },
    UnOpTypeMismatch(Type),
    BinOpTypeMismatch((Type, Type)),
    UndefinedVariable(Span),
    Unimplemented,
}
