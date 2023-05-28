use std::{collections::HashMap, error::Error};

use inkwell::{
    builder::Builder,
    context::Context,
    execution_engine::JitFunction,
    module::Module,
    types::{BasicMetadataTypeEnum, BasicTypeEnum},
    values::{BasicValue, BasicValueEnum, FunctionValue, PointerValue},
    AddressSpace, IntPredicate, OptimizationLevel,
};
use lrlex::{DefaultLexerTypes, LRNonStreamingLexer};
use lrpar::NonStreamingLexer;

use crate::ast::*;

use super::Visitor;

pub struct CodeGen<'input, 'lexer, 'ctx> {
    pub lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
    pub context: &'ctx Context,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
    pub printf: FunctionValue<'ctx>,
    pub stack: Stack<'input, 'ctx>,
    pub functions: HashMap<&'input str, FunctionValue<'ctx>>,
}

#[derive(Default)]
pub struct Stack<'input, 'ctx> {
    frames: Vec<StackFrame<'input, 'ctx>>,
}
impl<'input, 'ctx> Stack<'input, 'ctx> {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn push(&mut self) {
        self.frames.push(StackFrame::new());
    }
    pub fn pop(&mut self) {
        self.frames.pop();
    }
    pub fn insert(&mut self, name: &'input str, value: PointerValue<'ctx>) {
        self.frames
            .last_mut()
            .expect("stack must have at least one frame")
            .variables
            .insert(name, value);
    }
    pub fn get(&self, name: &'input str) -> Option<PointerValue<'ctx>> {
        for frame in self.frames.iter().rev() {
            if let Some(value) = frame.variables.get(name) {
                return Some(*value);
            }
        }
        None
    }
}

#[derive(Default)]
struct StackFrame<'input, 'ctx> {
    pub variables: HashMap<&'input str, PointerValue<'ctx>>,
}
impl<'input, 'ctx> StackFrame<'input, 'ctx> {
    pub fn new() -> Self {
        Self::default()
    }
}

impl<'input, 'lexer, 'ctx> CodeGen<'input, 'lexer, 'ctx> {
    pub fn new(
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        context: &'ctx Context,
    ) -> Self {
        let module = context.create_module("main");
        let builder = context.create_builder();

        let i64_type = context.i64_type();
        let ptr_type = context.i8_type().ptr_type(AddressSpace::from(0));
        let fn_type = i64_type.fn_type(&[BasicMetadataTypeEnum::PointerType(ptr_type)], true);
        let printf = module.add_function("printf", fn_type, None);
        let stack = Stack::new();
        let functions = HashMap::new();
        Self {
            lexer,
            context,
            module,
            builder,
            printf,
            stack,
            functions,
        }
    }
    pub fn compile(&mut self, file: &File) {
        let execution_engine = self
            .module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();

        self.walk_file(file);

        let i64_type = self.context.i64_type();
        let fn_type = i64_type.fn_type(&[], false);

        let function = self.module.add_function("add", fn_type, None);
        let basic_block = self.context.append_basic_block(function, "entry");

        self.builder.position_at_end(basic_block);
        let return_value = i64_type.const_int(42, false);
        self.builder.build_return(Some(&return_value));
        println!(
            "Generated LLVM IR:\n{}",
            self.module.print_to_string().to_string()
        );

        unsafe {
            type Main = unsafe extern "C" fn() -> ();
            let jit_function: JitFunction<Main> = execution_engine.get_function("main").unwrap();
            jit_function.call();
        }
    }
}

#[allow(unused_variables)]
impl<'input, 'lexer, 'ctx> Visitor<CodeGenResult<'ctx>> for CodeGen<'input, 'lexer, 'ctx> {
    fn visit_file(&mut self, file: &File) -> CodeGenResult<'ctx> {
        self.walk_file(file);
        Ok(None)
    }
    fn visit_item(&mut self, item: &Item) -> CodeGenResult<'ctx> {
        match item {
            Item::FunctionDecl(function_decl) => self.visit_function_decl(function_decl)?,
            Item::TypeDecl(type_decl) => self.visit_type_decl(type_decl)?,
            Item::AliasDecl(alias_decl) => self.visit_alias_decl(alias_decl)?,
        };
        Ok(None)
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> CodeGenResult<'ctx> {
        let fn_name = self.lexer.span_str(function_decl.function_sig.name);
        if self.functions.contains_key(fn_name) {
            panic!("function {} already exists", fn_name)
        }
        let fn_type = self.context.i64_type().fn_type(&[], false);
        let fn_value = self.module.add_function(fn_name, fn_type, None);
        self.functions.insert(fn_name, fn_value);
        let basic_block = self.context.append_basic_block(fn_value, "entry");
        self.builder.position_at_end(basic_block);
        self.visit_block(&function_decl.body)?;
        if basic_block.get_terminator().is_none() {
            if let Type::Unit = function_decl.function_sig.proto.return_type {
                self.builder.build_return(None);
            } else {
                //todo: return error
                panic!("function must return a value");
            }
        };
        Ok(None)
    }
    fn visit_block(&mut self, block: &Block) -> CodeGenResult<'ctx> {
        self.stack.push();
        self.walk_block(block);
        self.stack.pop();
        Ok(None)
    }
    fn visit_statement(&mut self, statement: &Statement) -> CodeGenResult<'ctx> {
        match statement {
            Statement::Return(return_) => self.visit_return(return_),
            Statement::Expr(expr) => self.visit_expr(expr),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Assign(assign) => self.visit_assign(assign),
            _ => Ok(None),
        }
    }

    fn visit_assign(&mut self, assign: &Assign) -> CodeGenResult<'ctx> {
        let var_name = self.lexer.span_str(assign.name);
        let var_ptr = self
            .stack
            .get(var_name)
            .expect(format!("variable {var_name} not found").as_str());
        let var_value = self
            .visit_expr(&assign.value)?
            .expect("expr must return a value");
        self.builder.build_store(var_ptr, var_value);

        Ok(None)
    }

    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> CodeGenResult<'ctx> {
        let var_name = self.lexer.span_str(var_decl.name);
        // todo: add type inferenece
        let var_type = match &var_decl.var_type {
            Type::Unit => panic!("cannot declare a variable of type unit"),
            Type::Int => BasicTypeEnum::IntType(self.context.i64_type()),
            Type::Float => BasicTypeEnum::FloatType(self.context.f64_type()),
            Type::Bool => BasicTypeEnum::IntType(self.context.bool_type()),
            Type::String => todo!("string type"),
            Type::Ident(_) => todo!("custom type"),
            Type::Array(_) => todo!("array type"),
            Type::Function(_) => todo!("function type"),
        };

        if self
            .stack
            .frames
            .last()
            .unwrap()
            .variables
            .contains_key(var_name)
        {
            panic!("variable already declared")
        }

        let var = self.builder.build_alloca(var_type, var_name);
        self.stack.insert(var_name, var);

        let var_value = match &var_decl.value {
            Some(var_value) => Some(
                self.visit_expr(var_value)?
                    .expect("expr must return a value")
                    .as_basic_value_enum(),
            ),
            None => None,
        };
        if let Some(val) = var_value {
            self.builder.build_store(var, val);
        }

        Ok(None)
    }

    fn visit_return(&mut self, return_: &Return) -> CodeGenResult<'ctx> {
        match return_.value {
            Some(ref value) => {
                let return_value = self
                    .visit_expr(value)?
                    .expect("return value should be a value");
                self.builder.build_return(Some(&return_value))
            }
            None => self.builder.build_return(None),
        };
        Ok(None)
    }
    fn visit_expr(&mut self, expr: &Expr) -> CodeGenResult<'ctx> {
        match expr {
            Expr::BinOp { lhs, op, rhs, .. } => {
                let lhs = self.visit_expr(lhs)?.expect("expr should return a value");
                let rhs = self.visit_expr(rhs)?.expect("expr should return a value");
                //todo support other types
                match op {
                    //ints, floats, strings
                    BinOp::Add(_) => {
                        let result = self.builder.build_int_add(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "add",
                        );
                        Ok(Some(result.as_basic_value_enum()))
                    }
                    BinOp::Sub(_) => {
                        let res = self.builder.build_int_sub(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "sub",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    //ints, floats
                    BinOp::Mul(_) => {
                        let res = self.builder.build_int_mul(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "mul",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Div(_) => {
                        let res = self.builder.build_int_signed_div(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "div",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // ints
                    BinOp::Mod(_) => {
                        let res = self.builder.build_int_signed_rem(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "mod",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // ints, floats, bools, strings
                    BinOp::Eq(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::EQ,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "eq",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Neq(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::NE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "neq",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // ints, floats
                    BinOp::Gt(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SGT,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "gt",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Gte(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SGE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "gte",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Lt(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SLT,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "lt",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Lte(_) => {
                        let res = self.builder.build_int_compare(
                            IntPredicate::SLE,
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "lte",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    // bools
                    BinOp::And(_) => {
                        let res = self.builder.build_and(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "and",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Or(_) => {
                        let res =
                            self.builder
                                .build_or(lhs.into_int_value(), rhs.into_int_value(), "or");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                }
            }
            Expr::UnOp { op, expr, .. } => {
                let expr = self.visit_expr(expr)?.expect("expr should return a value");
                match op {
                    UnOp::Neg(_) => {
                        let res = if expr.is_int_value() {
                            self.builder
                                .build_int_neg(expr.into_int_value(), "neg")
                                .as_basic_value_enum()
                        } else {
                            self.builder
                                .build_float_neg(expr.into_float_value(), "neg")
                                .as_basic_value_enum()
                        };
                        Ok(Some(res))
                    }
                    UnOp::Not(_) => {
                        let res = self.builder.build_not(expr.into_int_value(), "not");
                        Ok(Some(res.as_basic_value_enum()))
                    }
                }
            }
            Expr::Int { value, .. } => Ok(Some(
                self.context
                    .i64_type()
                    .const_int(*value as u64, false)
                    .as_basic_value_enum(),
            )),
            Expr::Float { value, .. } => Ok(Some(
                self.context
                    .f64_type()
                    .const_float(*value)
                    .as_basic_value_enum(),
            )),
            Expr::Bool { value, .. } => Ok(Some(
                self.context
                    .bool_type()
                    .const_int(*value as u64, false)
                    .as_basic_value_enum(),
            )),
            Expr::Var { name, .. } => {
                let var_name = self.lexer.span_str(*name);
                let var = self.stack.get(var_name).expect("variable not found");
                let val = self.builder.build_load(var, var_name);
                Ok(Some(val))
            }
            _ => Ok(Some(
                self.context
                    .i64_type()
                    .const_int(69, false)
                    .as_basic_value_enum(),
            )),
        }
    }
    fn visit_type_decl(&mut self, type_decl: &TypeDecl) -> CodeGenResult<'ctx> {
        Ok(None)
    }
    fn visit_alias_decl(&mut self, alias: &AliasDecl) -> CodeGenResult<'ctx> {
        Ok(None)
    }
    fn visit_print(&mut self, print: &Print) -> CodeGenResult<'ctx> {
        // let _val = self
        //     .visit_expr(&print.value)?
        //     .expect("expressions must return a value");
        // let val = self.context.i8_type().const_int(69, false);
        // let ptr = self.printf.get_first_param().unwrap().into_pointer_value();
        // self.builder.build_store(ptr, val);
        // self.builder
        //     .build_call(self.printf, &[ptr.into()], "printf");
        Ok(None)
    }
}

type CodeGenResult<'a> = Result<Option<BasicValueEnum<'a>>, Box<dyn Error>>;
