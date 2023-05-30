use std::collections::HashMap;

use cfgrammar::Span;
use inkwell::context::Context;
use inkwell::types::AnyTypeEnum;
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::ast::*;
use crate::compiler::Stack;

use super::Visitor;

pub struct TypeChecker<'lexer, 'input, 'ctx> {
    pub vars: HashMap<&'input str, Type>,
    pub var_stack: Stack<'input, AnyTypeEnum<'ctx>>,
    lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
    context: &'ctx Context,
    funs: HashMap<&'input str, Type>,
}

impl<'lexer, 'input, 'ctx> TypeChecker<'lexer, 'input, 'ctx> {
    pub fn new(
        lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        context: &'ctx Context,
    ) -> Self {
        Self {
            vars: HashMap::new(),
            var_stack: Stack::new(),
            funs: HashMap::new(),
            context,
            lexer,
        }
    }
    pub fn check(&mut self, file: &File) -> TypeCheckResult<()> {
        //todo find all type check results
        let res = self.walk_file(file);
        for r in res {
            r?;
        }
        Ok(())
    }
    fn get_basic_type(&self, ty: Type) -> TypeCheckResult<AnyTypeEnum<'ctx>> {
        match ty {
            Type::Unit => Ok(self.context.void_type().into()),
            Type::Int => Ok(self.context.i64_type().into()),
            Type::Float => Ok(self.context.f64_type().into()),
            Type::Bool => Ok(self.context.bool_type().into()),
            Type::String(size) => Ok(self.context.i8_type().array_type(size as u32).into()),
            Type::Ident(span) => self
                .var_stack
                .get(self.lexer.span_str(span))
                .ok_or(TypeCheckError::UndefinedVariable(span)),
            Type::Array(_) => unimplemented!(),
            Type::Function(_) => unimplemented!(),
        }
    }
}
impl<'lexer, 'input, 'ctx> Visitor<TCResult<'ctx>> for TypeChecker<'lexer, 'input, 'ctx> {
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> TCResult<'ctx> {
        match var_decl.var_type.clone() {
            Some(var_type) => self.var_stack.insert(
                self.lexer.span_str(var_decl.name),
                self.get_basic_type(var_type)?,
            ),

            None => {
                let expr_type = self
                    .visit_expr(
                        var_decl
                            .value
                            .as_ref()
                            .expect("value must exist if type is not specified"),
                    )?
                    .expect("can't infer type of expr"); //todo return error
                self.var_stack
                    .insert(self.lexer.span_str(var_decl.name), expr_type)
            }
        };
        Ok(None)
    }
    fn visit_assign(&mut self, assign: &Assign) -> TCResult<'ctx> {
        let expr_type = self
            .visit_expr(&assign.value)?
            .expect("expr must have a type");
        let var_type = self
            .vars
            .get(self.lexer.span_str(assign.name))
            .ok_or(TypeCheckError::UndefinedVariable(assign.name))?
            .clone();
        if expr_type != var_type {
            return Err(TypeCheckError::AssignTypeMismatch {
                expected: var_type,
                found: expr_type,
            });
        }
        Ok(None)
    }
    fn visit_expr(&mut self, expr: &Expr) -> TCResult<'ctx> {
        match expr {
            Expr::Int { .. } => Ok(Some(self.context.i64_type().into())),
            Expr::Float { .. } => Ok(Some(self.context.f64_type().into())),
            Expr::String { value, .. } => Ok(Some(
                self.context.i8_type().array_type(value.len() as u32).into(),
            )),
            Expr::Bool { .. } => Ok(Some(self.context.bool_type().into())),
            Expr::Var { name, .. } => self
                .var_stack
                .get(self.lexer.span_str(*name))
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
            Expr::FunctionCall { name, args, .. } => {
                let fun_type = self
                    .funs
                    .get(self.lexer.span_str(*name))
                    .cloned()
                    .ok_or(TypeCheckError::UndefinedFunction(name.to_owned()))?;
                for (_, arg) in args.iter().enumerate() {
                    let _arg_type = self.visit_expr(arg)?.expect("expr must have a type");
                    //todo check arg type with function proto
                }
                Ok(Some(fun_type))
            }
            _ => todo!("{:?}", expr),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> TCResult<'ctx> {
        let return_type = function_decl.function_sig.proto.return_type.clone();
        let body_type = self
            .visit_block(&function_decl.body)?
            .expect("function body should have a type");
        //todo fix this
        // if return_type != body_type {
        //     return Err(TypeCheckError::ReturnTypeMismatch {
        //         expected: return_type,
        //         found: body_type,
        //     });
        // }
        self.funs.insert(
            self.lexer.span_str(function_decl.function_sig.name),
            return_type,
        );
        Ok(None)
    }
    fn visit_block(&mut self, block: &Block) -> TCResult<'ctx> {
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

    fn visit_type_decl(&mut self, type_decl: &TypeDecl) -> TCResult<'ctx> {
        Ok(None)
    }
    fn visit_alias_decl(&mut self, alias_decl: &AliasDecl) -> TCResult<'ctx> {
        Ok(None)
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
type TCResult<'ctx> = TypeCheckResult<Option<AnyTypeEnum<'ctx>>>;

#[derive(Debug)]
pub enum TypeCheckError {
    ReturnTypeMismatch { expected: Type, found: Type },
    AssignTypeMismatch { expected: Type, found: Type },
    UnOpTypeMismatch(Type),
    BinOpTypeMismatch((Type, Type)),
    UndefinedVariable(Span),
    UndefinedFunction(Span),
    Unimplemented,
}

#[cfg(test)]
mod tests {
    use inkwell::context::Context;
    use inkwell::types::AnyTypeEnum;

    #[test]
    fn test_basic_type_enum() {
        let context = Context::create();
        assert_eq!(
            AnyTypeEnum::IntType(context.i64_type()),
            AnyTypeEnum::IntType(context.i64_type())
        );
        assert_ne!(
            AnyTypeEnum::IntType(context.i64_type()),
            AnyTypeEnum::IntType(context.i32_type())
        );
        assert_eq!(
            AnyTypeEnum::StructType(context.struct_type(&[], false)),
            AnyTypeEnum::StructType(context.struct_type(&[], false))
        );
        assert_ne!(
            AnyTypeEnum::StructType(context.struct_type(&[], false)),
            AnyTypeEnum::StructType(context.struct_type(&[context.i64_type().into()], false))
        );
    }
}
