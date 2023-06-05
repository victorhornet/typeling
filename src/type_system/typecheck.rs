use std::collections::HashMap;

use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::ast::*;
use crate::type_system::GADT;

use crate::visitors::Visitor;

pub struct TypeChecker<'lexer, 'input> {
    pub vars: HashMap<&'input str, Type>,
    pub var_stack: TypeStack<'input>,
    lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
    funs: HashMap<&'input str, Type>,
    errs: Vec<TypeCheckError>,
}

pub struct TypeStack<'input> {
    frames: Vec<TypeStackFrame<'input>>,
}
impl<'input> TypeStack<'input> {
    pub fn new() -> Self {
        Self { frames: vec![] }
    }
    pub fn push(&mut self) {
        self.frames.push(TypeStackFrame::new());
    }
    pub fn pop(&mut self) {
        self.frames.pop();
    }
    pub fn insert(&mut self, name: &'input str, value: Type) {
        self.frames
            .last_mut()
            .expect("stack must have at least one frame")
            .vars
            .insert(name, value);
    }
    pub fn get(&self, name: &'input str) -> Option<Type> {
        for frame in self.frames.iter().rev() {
            if let Some(value) = frame.vars.get(name) {
                return Some(value.to_owned());
            }
        }
        None
    }
}

impl<'input> Default for TypeStack<'input> {
    fn default() -> Self {
        Self::new()
    }
}

pub struct TypeStackFrame<'input> {
    vars: HashMap<&'input str, Type>,
    funs: HashMap<&'input str, Type>,
}

impl<'input> TypeStackFrame<'input> {
    pub fn new() -> Self {
        Self {
            vars: HashMap::new(),
            funs: HashMap::new(),
        }
    }
}

impl<'input> Default for TypeStackFrame<'input> {
    fn default() -> Self {
        Self::new()
    }
}

impl<'lexer, 'input> TypeChecker<'lexer, 'input> {
    pub fn new(lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>) -> Self {
        Self {
            vars: HashMap::new(),
            var_stack: TypeStack::new(),
            funs: HashMap::new(),
            lexer,
            errs: vec![],
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
}
impl<'lexer, 'input> Visitor<TCResult> for TypeChecker<'lexer, 'input> {
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> TCResult {
        match var_decl.var_type.clone() {
            Some(var_type) => self
                .var_stack
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
                self.var_stack
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
            .ok_or(TypeCheckError::UndefinedVariable(
                self.lexer.span_str(assign.name).to_string(),
            ))?
            .clone();
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
                .var_stack
                .get(self.lexer.span_str(*name))
                .ok_or(TypeCheckError::UndefinedVariable(
                    self.lexer.span_str(*name).to_string(),
                ))
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
                let fun_type = self.funs.get(self.lexer.span_str(*name)).cloned().ok_or(
                    TypeCheckError::UndefinedFunction(self.lexer.span_str(*name).to_string()),
                )?;
                for (_, arg) in args.iter().enumerate() {
                    let _arg_type = self.visit_expr(arg)?.expect("expr must have a type");
                    //todo check arg type with function proto
                }
                Ok(Some(fun_type))
            }
            _ => todo!("{:?}", expr),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> TCResult {
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
    fn visit_block(&mut self, block: &Block) -> TCResult {
        self.var_stack.push();
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
        self.var_stack.pop();
        Ok(Some(block_type))
    }

    fn visit_type_decl(&mut self, type_decl: &GADT) -> TCResult {
        Ok(Some(Type::GADT(type_decl.clone())))
    }
    fn visit_alias_decl(&mut self, _alias_decl: &AliasDecl) -> TCResult {
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
type TCResult = TypeCheckResult<Option<Type>>;

#[derive(Debug)]
pub enum TypeCheckError {
    ReturnTypeMismatch { expected: Type, found: Type },
    AssignTypeMismatch { expected: Type, found: Type },
    UnOpTypeMismatch(Type),
    BinOpTypeMismatch((Type, Type)),
    UndefinedVariable(String),
    UndefinedFunction(String),
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
