use std::collections::HashMap;

use cfgrammar::Span;
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::ast::*;

use super::Visitor;

pub struct TypeChecker<'lexer, 'input> {
    pub vars: HashMap<&'input str, Type>,
    lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
}

impl<'lexer, 'input> TypeChecker<'lexer, 'input> {
    pub fn new(lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>) -> Self {
        Self {
            vars: HashMap::new(),
            lexer,
        }
    }
    pub fn check(&mut self, file: &File) -> TypeCheckResult<()> {
        //todo find all type check results
        let res = self.walk_file(file);
        for r in res {
            r?;
        }
        println!("{:?}", self.vars);
        Ok(())
    }
}
impl<'lexer, 'input> Visitor<TCResult> for TypeChecker<'lexer, 'input> {
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> TCResult {
        match var_decl.var_type.clone() {
            Some(var_type) => self
                .vars
                .insert(self.lexer.span_str(var_decl.name), var_type),
            None => {
                let expr_type = self
                    .visit_expr(
                        var_decl
                            .value
                            .as_ref()
                            .expect("value must exist if type is not specified"),
                    )?
                    .expect("can't infer type of expr"); //todo return error
                self.vars
                    .insert(self.lexer.span_str(var_decl.name), expr_type)
            }
        };
        Ok(None)
    }
    fn visit_assign(&mut self, assign: &Assign) -> TCResult {
        let expr_type = self
            .visit_expr(&assign.value)?
            .expect("expr must have a type");
        let var_type = self
            .vars
            .get(self.lexer.span_str(assign.name))
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
            Expr::String { .. } => Ok(Some(Type::String)),
            Expr::Bool { .. } => Ok(Some(Type::Bool)),
            Expr::Var { name, .. } => self
                .vars
                .get(self.lexer.span_str(*name))
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
            _ => todo!("{:?}", expr),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> TCResult {
        let return_type = function_decl.function_sig.proto.return_type.clone();
        let body_type = self
            .visit_block(&function_decl.body)?
            .expect("function body should have a type");
        if return_type != body_type {
            return Err(TypeCheckError::ReturnTypeMismatch {
                expected: return_type,
                found: body_type,
            });
        }
        Ok(None)
    }
    fn visit_block(&mut self, block: &Block) -> TCResult {
        let mut block_type = Type::Unit;
        for stmt in &block.statements {
            if let Statement::Return(ret) = stmt {
                block_type = match ret.value {
                    Some(ref expr) => self.visit_expr(expr)?.expect("expr must have a type"),
                    None => Type::Unit,
                }
            } else {
                self.visit_statement(stmt)?;
            }
        }
        Ok(Some(block_type))
    }

    fn visit_type_decl(&mut self, type_decl: &TypeDecl) -> TCResult {
        Ok(None)
    }
    fn visit_alias_decl(&mut self, alias_decl: &AliasDecl) -> TCResult {
        Ok(None)
    }
}

fn binop_type(binop: &BinOp, ops: (Type, Type)) -> TypeCheckResult<Type> {
    match binop {
        BinOp::Add(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Int),
            (Type::String, Type::String) => Ok(Type::String),
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
            (Type::String, Type::String) => Ok(Type::Bool),
            (Type::Bool, Type::Bool) => Ok(Type::Bool),
            _ => Err(TypeCheckError::BinOpTypeMismatch(ops)),
        },
        BinOp::Neq(_) => match ops {
            (Type::Int, Type::Int) => Ok(Type::Bool),
            (Type::Float, Type::Float) => Ok(Type::Bool),
            (Type::String, Type::String) => Ok(Type::Bool),
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
    ReturnTypeMismatch { expected: Type, found: Type },
    AssignTypeMismatch { expected: Type, found: Type },
    UnOpTypeMismatch(Type),
    BinOpTypeMismatch((Type, Type)),
    UndefinedVariable(Span),
    Unimplemented,
}
