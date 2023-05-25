use std::error::Error;

use inkwell::{
    builder::Builder,
    context::Context,
    execution_engine::JitFunction,
    module::Module,
    types::BasicMetadataTypeEnum,
    values::{BasicValue, BasicValueEnum, FunctionValue},
    AddressSpace, OptimizationLevel,
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
}

impl<'input, 'lexer, 'ctx> CodeGen<'input, 'lexer, 'ctx> {
    pub fn new(
        lexer: &'input LRNonStreamingLexer<'lexer, 'input, DefaultLexerTypes>,
        context: &'ctx Context,
    ) -> Self {
        let module = context.create_module("main");
        let builder = context.create_builder();

        let i32_type = context.i32_type();
        let ptr_type = context.i8_type().ptr_type(AddressSpace::from(0));
        let fn_type = i32_type.fn_type(&[BasicMetadataTypeEnum::PointerType(ptr_type)], true);
        let printf = module.add_function("printf", fn_type, None);

        Self {
            lexer,
            context,
            module,
            builder,
            printf,
        }
    }
    pub fn compile(&mut self, file: &File) {
        let execution_engine = self
            .module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();

        self.walk_file(file);

        let i32_type = self.context.i32_type();
        let fn_type = i32_type.fn_type(&[], false);

        let function = self.module.add_function("add", fn_type, None);
        let basic_block = self.context.append_basic_block(function, "entry");

        self.builder.position_at_end(basic_block);
        let return_value = i32_type.const_int(42, false);
        self.builder.build_return(Some(&return_value));
        println!(
            "Generated LLVM IR: {}",
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
        };
        Ok(None)
    }
    fn visit_function_decl(&mut self, function_decl: &FunctionDecl) -> CodeGenResult<'ctx> {
        let fn_type = self.context.i32_type().fn_type(&[], false);
        let fn_name = self.lexer.span_str(function_decl.function_sig.name);
        let fn_value = self.module.add_function(fn_name, fn_type, None);
        let basic_block = self.context.append_basic_block(fn_value, "entry");
        self.builder.position_at_end(basic_block);
        self.walk_block(&function_decl.body);
        if let Type::Unit = function_decl.function_sig.proto.return_type {
            self.builder.build_return(None);
        } else {
            //todo change this to check if the last statement is a return
            let return_value = self.context.i32_type().const_int(10, false);
            self.builder.build_return(Some(&return_value));
        }
        Ok(None)
    }
    fn visit_statement(&mut self, statement: &Statement) -> CodeGenResult<'ctx> {
        println!("{statement:?}");
        match statement {
            Statement::Return(return_) => self.visit_return(return_),
            Statement::Expr(expr) => self.visit_expr(expr),
            Statement::VarDecl(var_decl) => self.visit_var_decl(var_decl),
            Statement::Print(print) => self.visit_print(print),
            _ => Ok(None),
        }
    }

    fn visit_var_decl(&mut self, var_decl: &VarDecl) -> CodeGenResult<'ctx> {
        let var_name = self.lexer.span_str(var_decl.name);
        let var_type = self.context.i32_type();
        let var_value = match var_decl.value {
            Some(ref value) => {
                // todo change this to assign registers
                self.visit_expr(value)?
                    .expect("expr should return a value")
                    .as_basic_value_enum()
            }
            None => self
                .context
                .i32_type()
                .const_int(1, false)
                .as_basic_value_enum(),
        };
        let var = self.builder.build_alloca(var_type, var_name);
        self.builder.build_store(var, var_value);
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
            Expr::BinOp(lhs, op, rhs) => {
                println!("BINOP");
                let lhs = self.visit_expr(lhs)?.expect("expr should return a value");
                let rhs = self.visit_expr(rhs)?.expect("expr should return a value");
                match op {
                    BinOp::Add => {
                        let result = self.builder.build_int_add(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "add",
                        );
                        Ok(Some(result.as_basic_value_enum()))
                    }
                    BinOp::Sub => {
                        let res = self.builder.build_int_sub(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "sub",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Mul => {
                        let res = self.builder.build_int_mul(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "mul",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    BinOp::Div => {
                        let res = self.builder.build_int_signed_div(
                            lhs.into_int_value(),
                            rhs.into_int_value(),
                            "div",
                        );
                        Ok(Some(res.as_basic_value_enum()))
                    }
                    _ => Ok(None),
                }
            }
            Expr::Int(int) => Ok(Some(
                self.context
                    .i32_type()
                    .const_int(*int as u64, false)
                    .as_basic_value_enum(),
            )),
            _ => Ok(Some(
                self.context
                    .i32_type()
                    .const_int(69, false)
                    .as_basic_value_enum(),
            )),
        }
    }
    fn visit_type_decl(&mut self, type_decl: &TypeDecl) -> CodeGenResult<'ctx> {
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
