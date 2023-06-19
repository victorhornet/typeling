use std::collections::HashMap;

use cfgrammar::Span;
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;
use thiserror::Error;

use crate::ast::*;
use crate::compiler::CompilerContext;
use crate::type_system::GADT;

use crate::visitors::Visitor;

use super::GADTConstructorFields;

pub struct TypeChecker<'lexer, 'input, 'lctx, 'cctx> {
    pub var_stack: TypeStack<'input>,
    lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
    compiler_ctx: &'cctx mut CompilerContext<'input, 'lctx>,
    funs: HashMap<&'input str, Type>,
    errs: Vec<TypeCheckError>,
}

impl<'lexer, 'input, 'lctx, 'cctx> TypeChecker<'lexer, 'input, 'lctx, 'cctx> {
    pub fn new(
        lexer: &'lexer LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        compiler_ctx: &'cctx mut CompilerContext<'input, 'lctx>,
    ) -> Self {
        Self {
            var_stack: TypeStack::new(),
            funs: HashMap::new(),
            lexer,
            compiler_ctx,
            errs: vec![],
        }
    }
    pub fn check(&mut self, file: &File) -> TypeCheckResult<()> {
        //todo find all type check results
        self.var_stack.push();
        let res = self.walk_file(file);
        for r in res {
            r?;
        }
        Ok(())
    }

    fn get_pattern_type(
        &mut self,
        pattern: &Pattern,
        expr_type: &Type,
    ) -> Result<Type, TypeCheckError> {
        let pattern_type = match pattern {
            Pattern::Wildcard => expr_type.clone(),
            Pattern::Ident(name) => {
                self.var_stack
                    .insert(self.lexer.span_str(*name), expr_type.clone());
                expr_type.clone()
            }
            Pattern::Value(expr) => self
                .visit_expr(expr)?
                .unwrap_or_else(|| panic!("{expr:?} did not return a type")),
            Pattern::TypeIdent(constructor, args) => {
                //todo change this
                let constructor_name = self.lexer.span_str(*constructor);
                let (constructor_sig, _) = self
                    .compiler_ctx
                    .constructor_signatures
                    .get(constructor_name)
                    .unwrap()
                    .clone();
                let gadt = self
                    .compiler_ctx
                    .type_constructors
                    .get(constructor_name)
                    .unwrap()
                    .clone();
                match (args, constructor_sig.get_fields()) {
                    (TypePatternArgs::None, GADTConstructorFields::Unit) => Type::Ident(gadt.name),
                    (TypePatternArgs::Tuple(patterns), GADTConstructorFields::Tuple(fields)) => {
                        for (pattern, field_type) in patterns.iter().zip(fields) {
                            let pattern_type = self.get_pattern_type(pattern, field_type)?;
                            if *field_type != pattern_type {
                                todo!("return proper error")
                            }
                        }

                        Type::Ident(gadt.name)
                    }

                    (TypePatternArgs::Struct(_), GADTConstructorFields::Struct(_, _)) => {
                        unimplemented!("struct pattern type check")
                    }
                    _ => todo!("return proper error"),
                }
            }
        };
        Ok(pattern_type)
    }

    fn check_var_assign(
        &mut self,
        var_type: Type,
        expr_type: &Type,
        span: Span,
    ) -> Option<Result<Option<Type>, TypeCheckError>> {
        match (var_type, expr_type.clone()) {
            (Type::String(_), Type::String(_)) => {}
            (var_type, expr_type) => {
                if var_type != expr_type {
                    return Some(Err(TypeCheckError::VarTypeMismatch {
                        start: self.lexer.line_col(span).0,
                        expected: var_type,
                        found: expr_type,
                    }));
                }
            }
        };
        None
    }
}
impl<'lexer, 'input, 'lctx, 'cctx> Visitor<TCResult> for TypeChecker<'lexer, 'input, 'lctx, 'cctx> {
    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> TCResult {
        match (var_decl.var_type.clone(), var_decl.value.clone()) {
            (Some(var_type), Some(expr)) => {
                let expr_type = self.visit_expr(&expr)?.expect("expr must have a type");

                if let Some(value) = self.check_var_assign(var_type, &expr_type, var_decl.span) {
                    return value;
                }
                self.var_stack
                    .insert(self.lexer.span_str(var_decl.name), expr_type)
            }
            (None, Some(expr)) => {
                let expr_type = self
                    .visit_expr(&expr)?
                    .ok_or(TypeCheckError::CannotInferType(
                        self.lexer.line_col(*expr.span()).0,
                    ))?; //todo return error
                self.var_stack
                    .insert(self.lexer.span_str(var_decl.name), expr_type.clone());
                self.compiler_ctx
                    .inferred_types
                    .insert(var_decl.span, expr_type);
            }
            (Some(var_type), None) => self
                .var_stack
                .insert(self.lexer.span_str(var_decl.name), var_type),
            _ => {
                unreachable!()
            }
        };
        Ok(None)
    }
    fn visit_assign(&mut self, assign: &Assign) -> TCResult {
        let expr_type = self
            .visit_expr(&assign.value)?
            .expect("expr must have a type");
        match assign.target.clone() {
            Expr::Var { name, span } => {
                let (start, end) = self.lexer.line_col(span);

                let var_type = self.var_stack.get(self.lexer.span_str(name)).ok_or(
                    TypeCheckError::UndefinedVariable(
                        start,
                        end,
                        self.lexer.span_str(name).to_string(),
                    ),
                )?;
                if let Some(value) = self.check_var_assign(var_type, &expr_type, assign.span) {
                    return value;
                }
                Ok(None)
            }
            Expr::MemberAccess { expr, member, .. } => todo!("type check member access assign"),
            _ => Err(TypeCheckError::AssignToNonVar(
                self.lexer.span_str(assign.span).to_owned(),
            )),
        }
    }
    fn visit_expr(&mut self, expr: &Expr) -> TCResult {
        match expr {
            Expr::Int { .. } => Ok(Some(Type::Int)),
            Expr::Float { .. } => Ok(Some(Type::Float)),
            Expr::String { value, .. } => Ok(Some(Type::String(value.len() - 2))),
            Expr::Bool { .. } => Ok(Some(Type::Bool)),
            Expr::Var { name, span } => {
                let (start, end) = self.lexer.line_col(*span);
                self.var_stack
                    .get(self.lexer.span_str(*name))
                    .ok_or(TypeCheckError::UndefinedVariable(
                        start,
                        end,
                        self.lexer.span_str(*name).to_string(),
                    ))
                    .map(Some)
            }
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
            Expr::FunctionCall { name, args, span } => {
                let fun_type = self.funs.get(self.lexer.span_str(*name)).cloned().ok_or(
                    TypeCheckError::UndefinedFunction(
                        self.lexer.line_col(*span).0,
                        self.lexer.span_str(*name).to_string(),
                    ),
                )?;
                for (_, arg) in args.iter().enumerate() {
                    let _arg_type = self.visit_expr(arg)?.expect("expr must have a type");
                    //todo check arg type with function proto
                }
                Ok(Some(fun_type))
            }
            Expr::Case {
                span,
                expr,
                patterns,
            } => {
                self.var_stack.push();
                let expr_type = self.visit_expr(expr)?.expect("expr must have a type");
                let mut branch_types = vec![];
                for (pattern, branch) in patterns {
                    let pattern_type = self.get_pattern_type(pattern, &expr_type)?;
                    if pattern_type != expr_type {
                        let (start, end) = self.lexer.line_col(*span);
                        return Err(TypeCheckError::CaseTypeMismatch {
                            start,
                            end,
                            expected: expr_type,
                            found: pattern_type,
                        });
                    }
                    let branch_type = match branch {
                        CaseBranchBody::Expr(expr) => {
                            self.visit_expr(expr)?.expect("expr must have a type")
                        }
                        CaseBranchBody::Block(branch) => {
                            self.visit_block(branch)?.expect("branch must have a type")
                        }
                    };
                    branch_types.push(branch_type);
                }
                self.var_stack.pop();
                if branch_types.iter().any(|t| t != &branch_types[0]) {
                    let (start, end) = self.lexer.line_col(*span);
                    return Err(TypeCheckError::CaseBranchTypeMismatch {
                        start,
                        end,
                        branch_types,
                    });
                }
                Ok(Some(branch_types[0].clone()))
            }
            Expr::ConstructorCall { name, args, span } => {
                // let constructor_type = self
                //     .constructors
                //     .get(self.lexer.span_str(*constructor))
                //     .cloned()
                //     .ok_or(TypeCheckError::UndefinedConstructor(
                //         self.lexer.line_col(*span).0,
                //         self.lexer.span_str(*constructor).to_string(),
                //     ))?;
                // for (_, arg) in args.iter().enumerate() {
                //     let _arg_type = self.visit_expr(arg)?.expect("expr must have a type");
                //     //todo check arg type with constructor proto
                // }
                let constructor_name = self.lexer.span_str(*name);
                let gadt = self
                    .compiler_ctx
                    .type_constructors
                    .get(constructor_name)
                    .unwrap();
                Ok(Some(Type::Ident(gadt.name.clone())))
            }
            _ => todo!("{:?}", expr),
        }
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> TCResult {
        let return_type = function_decl.function_sig.proto.return_type.clone();
        self.funs.insert(
            self.lexer.span_str(function_decl.function_sig.name),
            return_type.clone(),
        );

        function_decl
            .function_sig
            .proto
            .params
            .iter()
            .for_each(|param| {
                self.var_stack
                    .insert(self.lexer.span_str(param.name), param.param_type.clone())
            });
        let body_type = self
            .visit_block(&function_decl.body)?
            .expect("function body should have a type");
        //todo fix this
        if return_type != body_type {
            return Err(TypeCheckError::ReturnTypeMismatch {
                expected: return_type,
                found: body_type,
            });
        }
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

#[derive(Error, Debug)]
pub enum TypeCheckError {
    #[error("Mismatched function return type: expected {expected}, found {found}")]
    ReturnTypeMismatch { expected: Type, found: Type },
    #[error("Mismatched assign value type: expected {expected}, found {found}")]
    AssignTypeMismatch { expected: Type, found: Type },
    #[error("Unary operation on unsupported type: {0}")]
    UnOpTypeMismatch(Type),
    #[error("Binary operation on unsupported types: {0:?}")]
    BinOpTypeMismatch((Type, Type)),
    #[error("Undefined variable at line {}, column {}: {2}", .0 .0, .0 .1)]
    UndefinedVariable((usize, usize), (usize, usize), String),
    #[error("Undefined function at line {}, column {}: {1}", .0 .0, .0 .1)]
    UndefinedFunction((usize, usize), String),
    #[error("Unimplemented feature")]
    Unimplemented,
    #[error("Illegal assignment target: {0}")]
    AssignToNonVar(String),
    #[error("Mismatched case pattern type line {}, column {}: expected {expected:?}, found {found:?}", start.0, start.1)]
    CaseTypeMismatch {
        start: (usize, usize),
        end: (usize, usize),
        expected: Type,
        found: Type,
    },
    #[error("Mismatched case branch types at line {}, column {}: {branch_types:?}", start.0, start.1)]
    CaseBranchTypeMismatch {
        start: (usize, usize),
        end: (usize, usize),
        branch_types: Vec<Type>,
    },
    #[error("Mismatched variable type at line {}, column {}: expected {expected:?}, found {found:?}", start.0, start.1)]
    VarTypeMismatch {
        start: (usize, usize),
        expected: Type,
        found: Type,
    },
    #[error("Cannot infer type of expression at line {}, column {}", .0 .0, .0 .1)]
    CannotInferType((usize, usize)),
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
